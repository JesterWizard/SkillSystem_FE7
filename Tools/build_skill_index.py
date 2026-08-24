"""Generate skill-index.md/json from skill_definitions + MasterSkillInstaller."""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
INSTALLER = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "MasterSkillInstaller.event"
SKILLS = ROOT / "EngineHacks" / "SkillSystem" / "Skills"
OUT = ROOT / "Documentation" / "skill-index.md"
JSON_OUT = ROOT / "Documentation" / "skill-index.json"
ID_FILE = "EngineHacks/SkillSystem/skill_definitions.event"
MASTER = "EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event"

DEFINE_RE = re.compile(r"^#define\s+(\w+ID)\s+(\S+)")
ALIAS_RE = re.compile(r"^\w+ID$")
INCLUDE_RE = re.compile(r'^(//)?#include\s+"([^"]+)"')
SECTION_RE = re.compile(r"^//(?!#)\s*(.+?)\s*$")
MACRO_RE = re.compile(r"\b[A-Za-z_]\w*ID\b")
SKILL_OFF = "OFF"
SOURCE_SUFFIX = {".s", ".event", ".c", ".h", ".txt"}
MENTION_SUFFIX = {".s", ".event", ".c", ".h"}
Row = dict[str, Any]


def catalog_defines(text: str) -> list[tuple[str, str, str]]:
    """Return (macro, rhs, section_folder) rows; skip aliases."""
    rows: list[tuple[str, str, str]] = []
    section = ""
    for line in text.splitlines():
        sm = SECTION_RE.match(line)
        if sm:
            comment = sm.group(1)
            if len(comment) < 40 and "you" not in comment.lower():
                section = comment.replace(" ", "")
            continue
        m = DEFINE_RE.match(line)
        if not m:
            continue
        name, rhs = m.group(1), m.group(2)
        if ALIAS_RE.fullmatch(rhs):
            continue
        rows.append((name, rhs, section))
    return rows


def live_prefixes(text: str) -> list[str]:
    prefixes: list[str] = []
    for line in text.splitlines():
        m = INCLUDE_RE.match(line.strip())
        if not m or m.group(1):
            continue
        rel = m.group(2).replace("\\", "/")
        parent = str(Path(rel).parent).replace("\\", "/")
        if parent in (".", ""):
            continue
        prefixes.append(parent)
    return prefixes


def source_map(skills_root: Path) -> tuple[dict[str, list[Path]], dict[str, list[Path]]]:
    by_stem: dict[str, list[Path]] = {}
    by_folder: dict[str, list[Path]] = {}
    for path in skills_root.rglob("*.s"):
        by_stem.setdefault(path.stem.lower(), []).append(path)
        by_folder.setdefault(path.parent.name.lower(), []).append(path)
    return by_stem, by_folder


def is_live(rel_posix: str, prefixes: list[str]) -> bool:
    for prefix in sorted(prefixes, key=len, reverse=True):
        if rel_posix == prefix or rel_posix.startswith(prefix + "/"):
            return True
    return False


def skill_stem(macro: str) -> str:
    return macro[:-2] if macro.endswith("ID") else macro


def _posix(path: Path) -> str:
    rel = path.relative_to(ROOT).as_posix()
    if rel.lower().startswith("tests/"):
        return "tests/" + rel.split("/", 1)[1]
    return rel


def _skip_generated(name: str) -> bool:
    low = name.lower()
    return low.endswith(".lyn.event") or low.endswith(".bat")


def folder_sources(folder: Path) -> list[str]:
    if not folder.is_dir():
        return []
    out: list[str] = []
    for path in sorted(folder.iterdir()):
        if not path.is_file() or _skip_generated(path.name):
            continue
        if path.suffix.lower() in SOURCE_SUFFIX:
            out.append(_posix(path))
    return out


def test_py_files() -> list[Path]:
    seen: set[str] = set()
    out: list[Path] = []
    for pat in ("tests/test_*.py", "Tests/test_*.py"):
        for path in ROOT.glob(pat):
            key = str(path.resolve()).lower()
            if key in seen:
                continue
            seen.add(key)
            out.append(path)
    return out


def mention_index() -> dict[str, list[str]]:
    idx: dict[str, list[str]] = {}

    def add(macro: str, path: Path) -> None:
        rel = _posix(path)
        bucket = idx.setdefault(macro, [])
        if rel not in bucket:
            bucket.append(rel)

    for path in SKILLS.rglob("*"):
        if not path.is_file() or _skip_generated(path.name):
            continue
        if path.suffix.lower() not in MENTION_SUFFIX:
            continue
        try:
            text = path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        for macro in set(MACRO_RE.findall(text)):
            add(macro, path)
    for path in test_py_files():
        if path.name.lower() in {
            "test_skill_index.py",
            "test_implement_prompt_hook.py",
        }:
            continue
        try:
            text = path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        for macro in set(MACRO_RE.findall(text)):
            add(macro, path)
    return idx


def installer_for_folder(folder_rel: str, installer_text: str) -> str:
    best_name = ""
    best_rel = ""
    for line in installer_text.splitlines():
        m = INCLUDE_RE.match(line.strip())
        if not m:
            continue
        rel = m.group(2).replace("\\", "/")
        parent = str(Path(rel).parent).replace("\\", "/")
        name = parent if parent not in (".", "") else Path(rel).stem
        if name == "charge_table":
            continue
        if folder_rel == name or folder_rel.startswith(name + "/"):
            if len(name) > len(best_name):
                best_name = name
                best_rel = rel
    if best_rel:
        return (SKILLS / best_rel).relative_to(ROOT).as_posix()
    if folder_rel:
        cat0 = folder_rel.split("/", 1)[0]
        guess = SKILLS / cat0 / f"{cat0}.event"
        if guess.is_file():
            return guess.relative_to(ROOT).as_posix()
    return ""


def _split_mentions(paths: list[str]) -> tuple[list[str], list[str]]:
    sources: list[str] = []
    tests: list[str] = []
    for path in paths:
        low = path.replace("\\", "/").lower()
        target = tests if low.startswith("tests/") else sources
        if path not in target:
            target.append(path)
    return sources, tests


_ROWS: list[Row] | None = None


def rows() -> list[Row]:
    global _ROWS
    if _ROWS is None:
        _ROWS = _compute_rows()
    return _ROWS


def _compute_rows() -> list[Row]:
    installer_text = INSTALLER.read_text(encoding="utf-8")
    defs = catalog_defines(DEFS.read_text(encoding="utf-8"))
    prefixes = live_prefixes(installer_text)
    by_stem, by_folder = source_map(SKILLS)
    mentions = mention_index()
    out: list[Row] = []
    for macro, rhs, section in defs:
        stem = skill_stem(macro)
        key = stem.lower()
        cands = by_stem.get(key) or by_folder.get(key) or []
        cands = sorted(cands, key=lambda p: (len(p.parts), p.as_posix().lower()))
        live_cands = [
            p
            for p in cands
            if is_live(p.parent.relative_to(SKILLS).as_posix(), prefixes)
        ]
        src = (live_cands or cands)[0] if cands else None
        if src is not None:
            rel = src.relative_to(SKILLS).as_posix()
            category = rel.split("/", 1)[0]
            folder_path = src.parent
            live = is_live(str(folder_path.relative_to(SKILLS).as_posix()), prefixes)
            source = src.relative_to(ROOT).as_posix()
        else:
            rel = ""
            category = section or ""
            folder_path = SKILLS / category / stem if category else None
            live = is_live(category, prefixes) if category else False
            source = ""
        folder_rel = (
            folder_path.relative_to(SKILLS).as_posix()
            if folder_path is not None and folder_path.exists()
            else rel.rsplit("/", 1)[0] if rel else category
        )
        folder = (
            folder_path.relative_to(ROOT).as_posix()
            if folder_path is not None and folder_path.exists()
            else ""
        )
        from_folder = folder_sources(folder_path) if folder_path is not None else []
        mentioned, tests = _split_mentions(mentions.get(macro, []))
        sources: list[str] = []
        for path in from_folder + mentioned:
            if path not in sources:
                sources.append(path)
        if not sources and source:
            sources = [source]
        off = rhs == "SKILL_OFF"
        out.append(
            {
                "skill": stem,
                "macro": macro,
                "id": SKILL_OFF if off else rhs,
                "off": "yes" if off else "no",
                "category": category,
                "live": "yes" if live else "no",
                "source": source,
                "folder": folder,
                "installer": installer_for_folder(folder_rel, installer_text),
                "sources": sources,
                "tests": tests,
            }
        )
    return out


def live_category_list(text: str | None = None) -> tuple[list[str], list[str]]:
    raw = text if text is not None else INSTALLER.read_text(encoding="utf-8")
    live: list[str] = []
    dead: list[str] = []
    for line in raw.splitlines():
        m = INCLUDE_RE.match(line.strip())
        if not m:
            continue
        rel = m.group(2).replace("\\", "/")
        parent = str(Path(rel).parent).replace("\\", "/")
        name = parent if parent not in (".", "") else Path(rel).stem
        if name == "charge_table":
            continue
        target = live if m.group(1) is None else dead
        if name not in target:
            target.append(name)
    return live, dead


def lookup(name: str) -> Row | None:
    needle = name.strip().lower()
    if needle.endswith("id"):
        stem = needle[:-2]
    else:
        stem = needle
    for r in rows():
        if r["skill"].lower() == stem or r["macro"].lower() == needle:
            return r
    return None


def format_row(r: Row) -> str:
    lines = [
        f"{r['skill']}\tmacro={r['macro']}\tid={r['id']}\toff={r['off']}\t"
        f"category={r['category']}\tlive={r['live']}\tfolder={r.get('folder', '')}\t"
        f"installer={r.get('installer', '')}\t{r['source']}"
    ]
    sources = r.get("sources") or []
    tests = r.get("tests") or []
    if sources:
        lines.append("sources:\t" + " ".join(sources))
    if tests:
        lines.append("tests:\t" + " ".join(tests))
    return "\n".join(lines)


def pack_dict(r: Row) -> dict[str, Any]:
    return {
        "skill": r["skill"],
        "macro": r["macro"],
        "id": r["id"],
        "off": r["off"],
        "category": r["category"],
        "live": r["live"],
        "source": r["source"],
        "folder": r.get("folder", ""),
        "installer": r.get("installer", ""),
        "id_file": ID_FILE,
        "master_installer": MASTER,
        "sources": list(r.get("sources") or []),
        "tests": list(r.get("tests") or []),
    }


def extract_skills(text: str, index_rows: list[Row] | None = None) -> list[Row]:
    index_rows = index_rows if index_rows is not None else rows()
    found: list[tuple[int, Row]] = []
    seen: set[str] = set()
    for r in sorted(index_rows, key=lambda x: len(x["skill"]), reverse=True):
        pat = re.compile(rf"\b{re.escape(r['skill'])}(?:ID)?\b", re.I)
        m = pat.search(text)
        if not m or r["macro"] in seen:
            continue
        seen.add(r["macro"])
        found.append((m.start(), r))
    found.sort(key=lambda item: item[0])
    return [r for _, r in found]


def rewrite_prompt(text: str) -> str:
    packs = extract_skills(text)
    stripped = text.strip()
    if not packs:
        return (
            "NO_SKILL_MATCH\n"
            "Name a skill (Provoke, Nullify, NullifyID).\n"
            f"User: {stripped}\n"
        )
    names = ", ".join(r["skill"] for r in packs)
    blocks = "\n\n".join(format_row(r) for r in packs)
    return (
        f"IMPLEMENT SKILL: {names}\n"
        "Do not search. Do not read Documentation/skill-index.md.\n"
        "Read only the paths below (plus id_file / master_installer if toggling live/ID).\n"
        f"id_file={ID_FILE}\n"
        f"master_installer={MASTER}\n"
        "After EngineHacks/EA/test changes: .\\MAKE_HACK_quick.cmd\n"
        "\nUser intent:\n"
        f"{stripped}\n"
        "\nFile pack:\n"
        f"{blocks}\n"
    )


def render(index_rows: list[Row] | None = None) -> str:
    index_rows = index_rows if index_rows is not None else rows()
    live, dead = live_category_list()
    lines = [
        "# Skill index",
        "",
        "**Derived view — not the source of truth.** Edit",
        "`EngineHacks/SkillSystem/skill_definitions.event` (IDs) and",
        "`EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event` (which",
        "categories are live). This file is rewritten by `MAKE_HACK` and",
        "`python Tools/build_skill_index.py`. Query a skill file pack with",
        "`python Tools/build_skill_index.py --skill Provoke`. Rewrite an",
        "implement prompt with `python Tools/skill_prompt.py implement Provoke`.",
        "",
        "## Live categories",
        "",
        "From `EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event`.",
        "",
        "| Category | Live |",
        "|----------|------|",
    ]
    seen: set[str] = set()
    for name in live:
        lines.append(f"| `{name}` | yes |")
        seen.add(name)
    for name in dead:
        if name in seen:
            continue
        lines.append(f"| `{name}` | no |")
    lines += [
        "",
        "## Skills",
        "",
        "| Skill | Macro | ID | Off | Category | Live | Source |",
        "|-------|-------|----|-----|----------|------|--------|",
    ]
    for r in index_rows:
        src = f"`{r['source']}`" if r["source"] else ""
        cat = f"`{r['category']}`" if r["category"] else ""
        lines.append(
            f"| {r['skill']} | `{r['macro']}` | {r['id']} | {r['off']} | {cat} | {r['live']} | {src} |"
        )
    lines.append("")
    return "\n".join(lines)


def write(path: Path = OUT) -> Path:
    index_rows = rows()
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as fh:
        fh.write(render(index_rows))
    payload = {
        "id_file": ID_FILE,
        "master_installer": MASTER,
        "skills": [pack_dict(r) for r in index_rows],
    }
    with JSON_OUT.open("w", encoding="utf-8", newline="\n") as fh:
        fh.write(json.dumps(payload, indent=2) + "\n")
    return path


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Query skill file packs from the event files. "
        "The markdown/JSON output is a derived view, not the source of truth."
    )
    parser.add_argument(
        "--skill",
        metavar="NAME",
        help="print one file pack (name or FooID); do not read skill-index.md",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="print JSON (one pack with --skill, or write full index without)",
    )
    parser.add_argument(
        "--prompt",
        metavar="TEXT",
        help="rewrite a freeform implement-skill prompt into a file-pack brief",
    )
    args = parser.parse_args(argv)
    if args.prompt is not None:
        print(rewrite_prompt(args.prompt), end="")
        return 0 if extract_skills(args.prompt) else 1
    if args.skill:
        row = lookup(args.skill)
        if row is None:
            print(f"no skill matching {args.skill!r}", flush=True)
            return 1
        if args.json:
            print(json.dumps(pack_dict(row), indent=2))
        else:
            print(format_row(row))
        return 0
    write()
    print(
        f"Wrote {OUT} and {JSON_OUT} (derived; event files remain source of truth)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
