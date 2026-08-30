"""Rebuild SkillSystem .s files to .lyn.event when sources change."""
from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SKILL_ROOT = ROOT / "EngineHacks" / "SkillSystem"

# Modular Stat Screen pages live outside SKILL_ROOT and are included by
# ModularStatScreen.event as pre-generated .lyn.event files. Nothing rebuilt
# them, so edits to the page .s files (or to the shared mss_defs.s they all
# include) silently never reached the ROM. Build them here instead.
MSS_PAGES_DIR = ROOT / "EngineHacks" / "Necessary" / "ModularStatScreen" / "pages"
RANGE_LOOP_DIR = ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "RangeCalcLoop" / "RangeLoop"
RANGE_LOOP_ASM = [RANGE_LOOP_DIR / "RangeSkillLoop.s"]
POST_LOOP_ASM = [
    ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "PostBattleCalcLoop" / "post_loop.s"
]
DURABILITY_ASM = [
    ROOT / "EngineHacks" / "Necessary" / "DurabilityBasedItems" / "ScrollDurability.s",
    ROOT / "EngineHacks" / "Necessary" / "DurabilityBasedItems" / "ScrollNames.s",
    ROOT / "EngineHacks" / "Necessary" / "DurabilityBasedItems" / "SkillBookIconDraw.s",
]
WEAPON_USABILITY_ASM = [
    ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "WeaponUsabilityCalcLoop" / "CanUnitWieldWeapon.s",
    ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "WeaponUsabilityCalcLoop" / "DoesUnitHaveWRank.s",
]
HP_RESTORATION_ASM = [
    ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "HPRestorationCalcLoop" / "HPRestorationCalcLoop.s",
]
TURN_LOOP_ASM = [
    ROOT / "EngineHacks" / "Necessary" / "CalcLoops" / "TurnLoop" / "StartOfTurn_CalcLoop.s",
]
STAT_GETTER_ASM = [
    ROOT / "EngineHacks" / "Necessary" / "StatGetters" / "_asm" / "Bitpack.s",
    ROOT / "EngineHacks" / "Necessary" / "StatGetters" / "_asm" / "DebuffStat.s",
    ROOT / "EngineHacks" / "Necessary" / "StatGetters" / "_asm" / "HalfStatFunctions.s",
    ROOT / "EngineHacks" / "Necessary" / "StatGetters" / "_asm" / "HalveIfRescuing.s",
    ROOT / "EngineHacks" / "Necessary" / "StatGetters" / "_asm" / "RallyStat.s",
]
DEBUFF_ASM = [
    ROOT / "EngineHacks" / "Necessary" / "Debuffs" / "asm" / "ClearDebuffs.s",
    ROOT / "EngineHacks" / "Necessary" / "Debuffs" / "asm" / "DebuffGivenTableEntry.s",
    ROOT / "EngineHacks" / "Necessary" / "Debuffs" / "asm" / "GetUnitDebuffEntry.s",
    ROOT / "EngineHacks" / "Necessary" / "Debuffs" / "asm" / "InitDebuffs.s",
    ROOT / "EngineHacks" / "Necessary" / "Debuffs" / "asm" / "ProcessDebuffs.s",
    ROOT / "EngineHacks" / "Necessary" / "Debuffs" / "asm" / "Reload.s",
    ROOT / "EngineHacks" / "Necessary" / "Debuffs" / "asm" / "SetDebuffs.s",
    ROOT / "EngineHacks" / "Necessary" / "Debuffs" / "asm" / "SetUnitDebuffASMC.s",
]
SUPPORT_POST_BATTLE_ASM = [
    ROOT / "EngineHacks" / "ExternalHacks" / "SupportPostBattle" / "PostBattleSupports.s",
    ROOT / "EngineHacks" / "ExternalHacks" / "SupportPostBattle" / "MapEmoticon" / "Show_map_emotion_by_params.s",
    ROOT / "EngineHacks" / "ExternalHacks" / "SupportPostBattle" / "MapEmoticon" / "Show_map_emotion_Destructor.s",
]

MSS_PAGES = [
    MSS_PAGES_DIR / "AdjustBarBaseForSavior.s",
    MSS_PAGES_DIR / "SkipRescueArrowsIfSavior.s",
    MSS_PAGES_DIR / "signed_bonus_number.s",
    MSS_PAGES_DIR / "mss_page1_skills.s",
    MSS_PAGES_DIR / "mss_page2_original.s",
    MSS_PAGES_DIR / "mss_page3_original.s",
    MSS_PAGES_DIR / "mss_page3_weapons_skills.s",
    MSS_PAGES_DIR / "mss_page4_supports.s",
    MSS_PAGES_DIR / "mss_leftstatscreen.s",
]
# .s files the pages pull in with .include; mtime changes here restale every page.
MSS_PAGE_DEPS = [MSS_PAGES_DIR / "mss_defs.s", MSS_PAGES_DIR / "GetTalkee.s"]
AS = Path(r"C:\devkitPro\devkitARM\bin\arm-none-eabi-as.exe")
CC = Path(r"C:\devkitPro\devkitARM\bin\arm-none-eabi-gcc.exe")
LYN = ROOT / "EventAssembler" / "Tools" / "lyn.exe"
CLIB_INCLUDE = Path(r"C:\devkitPro\FE-CLib\include")

# C sources compiled to .lyn.event, newest-style skills. Each needs a sibling
# Definitions.s (which .includes SkillsRef.s) so vanilla symbols resolve.
C_SOURCES = [
    ROOT / "EngineHacks/SkillSystem/Internals/SkillActivationFlags/SkillActivationFlags.c",
    ROOT / "EngineHacks/SkillSystem/Skills/ProcSkills/Hurricane/Hurricane.c",
    ROOT / "EngineHacks/Necessary/CalcLoops/CanUnitDoubleCalcLoop/NewBattleGetFollowUpOrder.c",
]

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
    """True when any output is missing or no newer than src.

    Uses <= rather than <: an edit and a rebuild that land in the same
    filesystem timestamp tick (common on Windows, where NTFS/FAT mtime
    granularity is coarse and a build can follow an edit within it) would
    otherwise look fresh, and the .lyn.event silently keeps stale code while
    the build reports success.
    """
    src_mtime = src.stat().st_mtime
    for out in outputs:
        if not out.is_file() or out.stat().st_mtime <= src_mtime:
            return True
    return False


def build_one(src: Path, deps: list[Path] | None = None) -> None:
    obj = src.with_suffix(".o")
    lyn = src.with_suffix(".lyn.event")
    dmp = src.with_suffix(".dmp")
    fresh = not stale(src, lyn)
    for dep in deps or ():
        if dep.is_file() and stale(dep, lyn):
            fresh = False
    if fresh:
        dmp.unlink(missing_ok=True)
        return
    _assemble(src, obj)
    lyn_text = subprocess.check_output([str(LYN), str(obj)], cwd=str(ROOT))
    lyn.write_bytes(lyn_text.replace(b"\r\n", b"\n"))
    obj.unlink(missing_ok=True)
    dmp.unlink(missing_ok=True)
    print(f"[LYN] {lyn.relative_to(ROOT)}")


def build_one_c(src: Path) -> None:
    """Compile a .c skill to .lyn.event.

    Mirrors the per-skill Makefiles (see KeenFighter): compile to asm, assemble
    that plus the sibling Definitions.o, then lyn both objects together so the
    SkillsRef.s addresses resolve. The generated .s is written next to the .c,
    where should_build_asm() already knows to leave compiler dumps alone.
    """
    lyn = src.with_suffix(".lyn.event")
    defs = src.parent / "Definitions.s"
    headers = sorted(src.parent.rglob("*.h")) + [defs]

    fresh = not stale(src, lyn)
    for dep in headers:
        if dep.is_file() and stale(dep, lyn):
            fresh = False
    if fresh:
        return

    asm = src.with_name(src.stem + "_c.s")
    obj = src.with_name(src.stem + "_c.o")
    defs_obj = src.parent / "Definitions.o"

    subprocess.run(
        [
            str(CC),
            "-mcpu=arm7tdmi",
            "-mthumb",
            "-mthumb-interwork",
            "-Wall",
            "-mtune=arm7tdmi",
            "-O2",
            "-mlong-calls",
            "-S",
            str(src),
            f"-I{CLIB_INCLUDE}",
            "-o",
            str(asm),
            "-fverbose-asm",
        ],
        check=True,
    )
    _assemble(asm, obj)
    _assemble(defs, defs_obj)
    lyn_text = subprocess.check_output([str(LYN), str(obj), str(defs_obj)], cwd=str(ROOT))
    lyn.write_bytes(lyn_text.replace(b"\r\n", b"\n"))
    for tmp in (obj, defs_obj):
        tmp.unlink(missing_ok=True)
    print(f"[LYN-C] {lyn.relative_to(ROOT)}")


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

    for tool in (AS, CC, LYN):
        if not tool.is_file():
            print(f"Missing tool: {tool}", file=sys.stderr)
            return 1

    if args.convert:
        n = convert_events()
        print(f"Converted {n} event files from dmp incbin to lyn include")

    sources = discover_sources()
    c_sources = [p for p in C_SOURCES if p.is_file()]
    mss_pages = [p for p in MSS_PAGES if p.is_file()]
    range_loop = [p for p in RANGE_LOOP_ASM if p.is_file()]
    post_loop = [p for p in POST_LOOP_ASM if p.is_file()]
    durability = [p for p in DURABILITY_ASM if p.is_file()]
    weapon_usability = [p for p in WEAPON_USABILITY_ASM if p.is_file()]
    hp_restoration = [p for p in HP_RESTORATION_ASM if p.is_file()]
    turn_loop = [p for p in TURN_LOOP_ASM if p.is_file()]
    stat_getter = [p for p in STAT_GETTER_ASM if p.is_file()]
    debuffs = [p for p in DEBUFF_ASM if p.is_file()]
    extra = mss_pages + range_loop + post_loop + durability + weapon_usability + hp_restoration + turn_loop + stat_getter + debuffs + [
        p for p in SUPPORT_POST_BATTLE_ASM if p.is_file()
    ]
    if args.force:
        for src in sources + extra + c_sources:
            src.with_suffix(".lyn.event").unlink(missing_ok=True)
            src.with_suffix(".dmp").unlink(missing_ok=True)

    print(
        f"Building {len(sources)} skill asm files, {len(mss_pages)} stat screen pages, "
        f"{len(range_loop)} range-loop files, {len(post_loop)} post-loop files, "
        f"{len(durability)} durability files, {len(weapon_usability)} weapon-usability files, "
        f"{len(c_sources)} C sources"
    )
    errors = []
    for src in c_sources:
        try:
            build_one_c(src)
        except subprocess.CalledProcessError as exc:
            errors.append((src, exc))
    for src in sources:
        try:
            build_one(src)
        except subprocess.CalledProcessError as exc:
            errors.append((src, exc))
            print(f"[FAIL] {src.relative_to(ROOT)}", file=sys.stderr)
    for src in mss_pages:
        try:
            build_one(src, MSS_PAGE_DEPS)
        except subprocess.CalledProcessError as exc:
            errors.append((src, exc))
            print(f"[FAIL] {src.relative_to(ROOT)}", file=sys.stderr)
    for src in range_loop + post_loop + durability + weapon_usability + hp_restoration + turn_loop + stat_getter + debuffs + [
        p for p in SUPPORT_POST_BATTLE_ASM if p.is_file()
    ]:
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
