#!/usr/bin/env python3
"""Block verbose shell commands before their output hits context."""
import json
import re
import sys

_ORIG = (
    (re.compile(r"pytest|EXPLAIN ANALYZE"), "Use ctx_batch_execute instead."),
    (
        re.compile(r"kubectl logs|kubectl describe|gcloud|gh api"),
        "Blocked: verbose output. Redirect to sandbox.",
    ),
)
_PATHY = re.compile(r"[\\/]|\.\w+$")
_GIT_LIMIT = re.compile(r"(?:^|\s)(?:-n\s*\d+|--max-count=\d+|--max-count\s+\d+|-\d+)(?:\s|$)")
_GIT_SUMMARY = re.compile(r"(?:^|\s)(?:--stat|--name-only|--name-status|--shortstat|--dirstat|-s)(?:\s|$)")
_GIT_PATCH = re.compile(r"(?:^|\s)(?:-p|--patch|-u)(?:\s|$)")
_GBA = re.compile(r"(?:^|[\s\"'])(?:type|cat|Get-Content)\b[^\n]*\.gba\b", re.I)
_FULL_HACK = re.compile(r"MAKE_HACK_full", re.I)
_RUN_TESTS = re.compile(r"python(?:3)?\s+tests[/\\]run_tests\.py\b", re.I)
_UNITTEST = re.compile(r"python(?:3)?\s+-m\s+unittest\b", re.I)


def _command(data):
    if not isinstance(data, dict):
        return ""
    if data.get("command"):
        return data["command"]
    tool = data.get("tool_input")
    if isinstance(tool, dict) and tool.get("command"):
        return tool["command"]
    return ""


def _segments(command):
    return [s.strip() for s in re.split(r"\s*(?:&&|\|\||;|\|)\s*", command) if s.strip()]


def _tokens(segment):
    return re.findall(r'"[^"]*"|\S+', segment)


def _unquoted(tok):
    return tok[1:-1] if tok.startswith('"') and tok.endswith('"') else tok


def _git_verb(segment, verb):
    toks = [_unquoted(t) for t in _tokens(segment)]
    if len(toks) < 2 or toks[0] != "git" or toks[1] != verb:
        return None
    return toks[2:]


def _has_test_target(seg):
    for raw in _tokens(seg):
        t = _unquoted(raw)
        if t.endswith(".py") and not t.endswith("run_tests.py"):
            return True
        if ".test_" in t or t.startswith("tests.test") or t.startswith("Tests.test"):
            return True
    return False


def _has_pathspec(args):
    past_dd = False
    for a in args:
        if a == "--":
            past_dd = True
            continue
        if past_dd or not a.startswith("-") and _PATHY.search(a):
            return True
    return False


def _reason(command):
    for pat, msg in _ORIG:
        if pat.search(command):
            return msg
    if _FULL_HACK.search(command):
        return "Blocked: MAKE_HACK_full is verbose. Use MAKE_HACK_quick.cmd."
    if _GBA.search(command):
        return "Blocked: do not dump a .gba into context."

    for seg in _segments(command):
        log_args = _git_verb(seg, "log")
        if log_args is not None:
            joined = " " + " ".join(log_args) + " "
            if _GIT_PATCH.search(joined):
                return "Blocked: git log -p. Use --oneline -n N or name a path."
            if not _GIT_LIMIT.search(joined):
                return "Blocked: unscoped git log. Pass -n N (and --oneline)."

        diff_args = _git_verb(seg, "diff")
        if diff_args is not None:
            joined = " " + " ".join(diff_args) + " "
            if not _GIT_SUMMARY.search(joined) and not _has_pathspec(diff_args):
                return "Blocked: unfiltered git diff. Use --stat or name paths."

        show_args = _git_verb(seg, "show")
        if show_args is not None:
            joined = " " + " ".join(show_args) + " "
            if not _GIT_SUMMARY.search(joined) and not _has_pathspec(show_args):
                return "Blocked: git show patch. Use --stat or name a path."

        if _RUN_TESTS.search(seg) and not _has_test_target(seg):
            return "Blocked: full test dump. Run one tests/test_*.py file."
        if _UNITTEST.search(seg) and not _has_test_target(seg):
            return "Blocked: full test dump. Run one tests.test_*.Class.test."

    return None


def main():
    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError:
        print(json.dumps({"permission": "allow"}))
        return 0

    msg = _reason(_command(data))
    if msg:
        print(
            json.dumps(
                {
                    "permission": "deny",
                    "agent_message": msg,
                    "user_message": msg,
                }
            )
        )
        print(msg, file=sys.stderr)
        return 2

    print(json.dumps({"permission": "allow"}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
