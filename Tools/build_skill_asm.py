"""Rebuild SkillSystem .s files to .lyn.event (and .dmp) when sources change."""
from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SKILL_ROOT = ROOT / "EngineHacks" / "SkillSystem"
AS = Path(r"C:\devkitPro\devkitARM\bin\arm-none-eabi-as.exe")
OBJCOPY = Path(r"C:\devkitPro\devkitARM\bin\arm-none-eabi-objcopy.exe")
LYN = ROOT / "EventAssembler" / "Tools" / "lyn.exe"

INC_BIN_RE = re.compile(r'#incbin\s+"([^"]+\.dmp)"')
INC_BIN_BARE_RE = re.compile(r"#incbin\s+([^\s\"]+\.dmp)")
INC_LYN_RE = re.compile(r'#include\s+"([^"]+\.lyn\.event)"')


def event_files() -> list[Path]:
    files = []
    for path in SKILL_ROOT.rglob("*.event"):
        if path.name.endswith(".lyn.event"):
            continue
        files.append(path)
    return files


def asm_source_for(target: Path) -> Path:
    name = target.name
    if name.endswith(".lyn.event"):
        return target.with_name(name[: -len(".lyn.event")] + ".s")
    return target.with_suffix(".s")


def resolve_source(event: Path, rel: str) -> Path | None:
    src = asm_source_for((event.parent / rel).resolve())
    return src if src.is_file() else None


def is_trampoline_asm(src: Path) -> bool:
    text = src.read_text(encoding="utf-8", errors="replace")
    return "SkillTester:" in text and "@POIN" in text


def should_build_asm(src: Path) -> bool:
    # Compiler dumps (SkillTester.s next to SkillTester.c) must not be re-lyn'd here.
    # Hand-written trampoline .s files can sit beside an unused .c (KeenFighter).
    if src.with_suffix(".c").is_file() and not is_trampoline_asm(src):
        return False
    return True


def discover_sources() -> list[Path]:
    found: set[Path] = set()
    for event in event_files():
        text = event.read_text(encoding="utf-8", errors="replace")
        for regex in (INC_BIN_RE, INC_BIN_BARE_RE, INC_LYN_RE):
            for match in regex.finditer(text):
                src = resolve_source(event, match.group(1))
                if src is not None and should_build_asm(src):
                    found.add(src)
    return sorted(found)


def convert_events() -> int:
    changed = 0
    for event in event_files():
        text = event.read_text(encoding="utf-8", errors="replace")
        original = text

        def repl_quoted_fixed(match: re.Match[str]) -> str:
            rel = match.group(1)
            if resolve_source(event, rel) is None:
                return match.group(0)
            lyn_rel = rel[: -len(".dmp")] + ".lyn.event"
            return f'#include "{lyn_rel}"'

        text = INC_BIN_RE.sub(repl_quoted_fixed, text)

        def repl_bare(match: re.Match[str]) -> str:
            rel = match.group(1)
            if resolve_source(event, rel) is None:
                return match.group(0)
            return f'#include "{rel[: -len(".dmp")]}.lyn.event"'

        text = INC_BIN_BARE_RE.sub(repl_bare, text)
        if text != original:
            event.write_text(text, encoding="utf-8")
            changed += 1
    return changed


def stale(src: Path, *outputs: Path) -> bool:
    src_mtime = src.stat().st_mtime
    for out in outputs:
        if not out.is_file() or out.stat().st_mtime < src_mtime:
            return True
    return False


def build_one(src: Path) -> None:
    obj = src.with_suffix(".o")
    lyn = src.with_suffix(".lyn.event")
    dmp = src.with_suffix(".dmp")
    if not stale(src, lyn):
        if stale(src, dmp):
            _assemble(src, obj)
            subprocess.run([str(OBJCOPY), "-S", str(obj), "-O", "binary", str(dmp)], check=True)
            obj.unlink(missing_ok=True)
            print(f"[DMP] {dmp.relative_to(ROOT)}")
        return
    _assemble(src, obj)
    lyn_text = subprocess.check_output([str(LYN), str(obj)], cwd=str(ROOT))
    lyn.write_bytes(lyn_text.replace(b"\r\n", b"\n"))
    subprocess.run([str(OBJCOPY), "-S", str(obj), "-O", "binary", str(dmp)], check=True)
    obj.unlink(missing_ok=True)
    print(f"[LYN] {lyn.relative_to(ROOT)}")


def _assemble(src: Path, obj: Path) -> None:
    subprocess.run(
        [
            str(AS),
            "-mcpu=arm7tdmi",
            "-mthumb",
            "-mthumb-interwork",
            f"-I{src.parent}",
            str(src),
            "-o",
            str(obj),
        ],
        check=True,
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--convert", action="store_true", help="Replace skill #incbin dmp with lyn includes")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()

    for tool in (AS, OBJCOPY, LYN):
        if not tool.is_file():
            print(f"Missing tool: {tool}", file=sys.stderr)
            return 1

    if args.convert:
        n = convert_events()
        print(f"Converted {n} event files from dmp incbin to lyn include")

    sources = discover_sources()
    if args.force:
        for src in sources:
            for extra in (src.with_suffix(".lyn.event"), src.with_suffix(".dmp")):
                extra.unlink(missing_ok=True)

    print(f"Building {len(sources)} skill asm files")
    errors = []
    for src in sources:
        try:
            build_one(src)
        except subprocess.CalledProcessError as exc:
            errors.append((src, exc))
            print(f"[FAIL] {src.relative_to(ROOT)}", file=sys.stderr)
    if errors:
        print(f"{len(errors)} file(s) failed to assemble", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    os.chdir(ROOT)
    raise SystemExit(main())
