#!/usr/bin/env python3
"""Structure 'implement' prompts and deny repo search when a skill pack exists."""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "Tools"))
from build_skill_index import extract_skills, rewrite_prompt  # noqa: E402

IMPLEMENT_RE = re.compile(r"\bimplement\b", re.I)
USER_QUERY_RE = re.compile(r"<user_query>\s*(.*?)\s*</user_query>", re.S)
CACHE = ROOT / ".cursor" / "cache" / "implement-brief.json"
SEARCH_TOOLS = {"grep", "glob"}
EXPLORE_AGENTS = {"explore", "generalPurpose"}
GENERIC = (
    "IMPLEMENT REQUEST — do not Grep/Glob/CodeDrift/explore first.\n"
    "User @ paths win. Named skill: python Tools/build_skill_index.py --skill Name\n"
    "Read only the listed pack paths. Do not read Documentation/skill-index.md.\n"
)


def last_user_query(data: dict) -> str:
    prompt = data.get("prompt")
    if isinstance(prompt, str) and prompt.strip():
        return prompt.strip()
    path = data.get("transcript_path")
    if not path:
        return ""
    try:
        raw = Path(path).read_text(encoding="utf-8", errors="replace")
    except OSError:
        return ""
    last = ""
    for line in raw.splitlines():
        line = line.strip()
        if not line.startswith("{"):
            continue
        try:
            row = json.loads(line)
        except json.JSONDecodeError:
            continue
        if row.get("role") != "user":
            continue
        msg = row.get("message") or {}
        content = msg.get("content")
        if isinstance(content, str):
            last = content
            continue
        if isinstance(content, list):
            texts = [
                c.get("text", "")
                for c in content
                if isinstance(c, dict) and c.get("type") == "text"
            ]
            if texts:
                last = "\n".join(texts)
    if last:
        inner = USER_QUERY_RE.findall(last)
        return (inner[-1] if inner else last).strip()
    matches = USER_QUERY_RE.findall(raw)
    if matches:
        return matches[-1].strip()
    return ""


def save_brief(data: dict, prompt: str, brief: str) -> None:
    cid = data.get("conversation_id")
    if not cid:
        return
    CACHE.parent.mkdir(parents=True, exist_ok=True)
    CACHE.write_text(
        json.dumps({"key": str(cid), "prompt": prompt, "brief": brief}),
        encoding="utf-8",
    )


def load_cache(data: dict) -> dict:
    cid = data.get("conversation_id")
    if not cid or not CACHE.is_file():
        return {}
    try:
        payload = json.loads(CACHE.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {}
    if payload.get("key") != str(cid):
        return {}
    return payload if isinstance(payload, dict) else {}


def brief_for(prompt: str) -> str:
    rewritten = rewrite_prompt(prompt)
    if rewritten.startswith("NO_SKILL_MATCH"):
        return GENERIC + rewritten
    return rewritten


def _tool_name(data: dict) -> str:
    return str(data.get("tool_name") or "").strip()


def _is_search_tool(data: dict) -> bool:
    name = _tool_name(data).lower()
    if name in SEARCH_TOOLS:
        return True
    if name == "task":
        kind = str((data.get("tool_input") or {}).get("subagent_type") or "")
        return kind in EXPLORE_AGENTS
    compact = name.replace(" ", "")
    if "codedrift_search" in compact or compact.endswith(":codedrift_search"):
        return True
    return False


def handle_submit(data: dict) -> dict:
    prompt = last_user_query(data)
    if not IMPLEMENT_RE.search(prompt):
        return {"continue": True}
    brief = brief_for(prompt)
    save_brief(data, prompt, brief)
    return {"continue": True, "additional_context": brief}


def handle_pre_tool(data: dict) -> dict:
    if not _is_search_tool(data):
        return {"permission": "allow"}
    prompt = last_user_query(data)
    if not prompt:
        prompt = str(load_cache(data).get("prompt") or "")
    if not IMPLEMENT_RE.search(prompt):
        return {"permission": "allow"}
    if not extract_skills(prompt):
        return {"permission": "allow"}
    brief = str(load_cache(data).get("brief") or "") or brief_for(prompt)
    return {
        "permission": "deny",
        "agent_message": brief + "\nRead the file pack. Do not Grep/Glob/explore.",
        "user_message": "Search skipped; skill file pack injected.",
    }


def handle(data: dict) -> dict:
    event = str(data.get("hook_event_name") or "")
    if event in ("beforeSubmitPrompt", "UserPromptSubmit") or (
        "prompt" in data and event != "preToolUse"
    ):
        return handle_submit(data)
    return handle_pre_tool(data)


def main() -> int:
    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError:
        print(json.dumps({"continue": True, "permission": "allow"}))
        return 0
    if not isinstance(data, dict):
        print(json.dumps({"continue": True, "permission": "allow"}))
        return 0
    print(json.dumps(handle(data)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
