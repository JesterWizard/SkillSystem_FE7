"""Generate Documentation/skill-index.md from skill_definitions + MasterSkillInstaller."""
from __future__ import annotations

import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFS = ROOT / "EngineHacks" / "SkillSystem" / "skill_definitions.event"
INSTALLER = ROOT / "EngineHacks" / "SkillSystem" / "Skills" / "MasterSkillInstaller.event"
SKILLS = ROOT / "EngineHacks" / "SkillSystem" / "Skills"
OUT = ROOT / "Documentation" / "skill-index.md"

DEFINE_RE = re.compile(r"^#define\s+(\w+ID)\s+(\S+)")
ALIAS_RE = re.compile(r"^\w+ID$")
INCLUDE_RE = re.compile(r'^(//)?#include\s+"([^"]+)"')
SECTION_RE = re.compile(r"^//(?!#)\s*(.+?)\s*$")
SKILL_OFF = "OFF"


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


def rows() -> list[dict[str, str]]:
    defs = catalog_defines(DEFS.read_text(encoding="utf-8"))
    prefixes = live_prefixes(INSTALLER.read_text(encoding="utf-8"))
    by_stem, by_folder = source_map(SKILLS)
    out = []
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
            live = is_live(str(src.parent.relative_to(SKILLS).as_posix()), prefixes)
            source = src.relative_to(ROOT).as_posix()
        else:
            rel = ""
            category = section or ""
            live = is_live(category, prefixes) if category else False
            source = ""
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


def lookup(name: str) -> dict[str, str] | None:
    needle = name.strip().lower()
    if needle.endswith("id"):
        stem = needle[:-2]
    else:
        stem = needle
    for r in rows():
        if r["skill"].lower() == stem or r["macro"].lower() == needle:
            return r
    return None


def format_row(r: dict[str, str]) -> str:
    return (
        f"{r['skill']}\tmacro={r['macro']}\tid={r['id']}\toff={r['off']}\t"
        f"category={r['category']}\tlive={r['live']}\t{r['source']}"
    )


def render(index_rows: list[dict[str, str]] | None = None) -> str:
    index_rows = index_rows if index_rows is not None else rows()
    live, dead = live_category_list()
    lines = [
        "# Skill index",
        "",
        "**Derived view — not the source of truth.** Edit",
        "`EngineHacks/SkillSystem/skill_definitions.event` (IDs) and",
        "`EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event` (which",
        "categories are live). This file is rewritten by `MAKE_HACK` and",
        "`python Tools/build_skill_index.py`. Query a skill live with",
        "`python Tools/build_skill_index.py --skill Provoke`.",
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
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as fh:
        fh.write(render())
    return path


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Query skill IDs/live/path from the event files. "
        "The markdown output is a derived view, not the source of truth."
    )
    parser.add_argument(
        "--skill",
        metavar="NAME",
        help="print one row from the event files (name or FooID); do not read skill-index.md",
    )
    args = parser.parse_args(argv)
    if args.skill:
        row = lookup(args.skill)
        if row is None:
            print(f"no skill matching {args.skill!r}", flush=True)
            return 1
        print(format_row(row))
        return 0
    write()
    print(f"Wrote {OUT} (derived; event files remain source of truth)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
