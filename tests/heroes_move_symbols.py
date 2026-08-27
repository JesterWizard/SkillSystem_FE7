"""Locate a Heroes-movement blob from its UnitActionFunctionPointer entry."""
from __future__ import annotations

import re
import struct
from pathlib import Path

from summon_symbols import label_offsets  # noqa: F401

ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
UNIT_MENU = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills"
SKILLS_MENU = UNIT_MENU / "SkillsMenu.event"
INSTALLER = UNIT_MENU / "UnitMenuSkills.event"
ROM_BASE = 0x08000000
UNIT_ACTION_TABLE = 0x2F248

# name -> (folder, action .s, .equ, installer #define, entry, links, selection, skill id label)
SKILLS = {
    "Smite": ("Smite", "SmiteAction", "SmiteActionID", "SMITE_ACTION_ID", "SmiteID"),
    "Pivot": ("Pivot", "PivotAction", "PivotActionID", "PIVOT_ACTION_ID", "PivotID"),
    "Reposition": (
        "Reposition",
        "RepositionAction",
        "RepositionActionID",
        "REPOSITION_ACTION_ID",
        "RepositionID",
    ),
    "Swap": ("Swap", "SwapAction", "SwapActionID", "SWAP_ACTION_ID", "SwapID"),
    "Swarp": ("Swarp", "SwarpAction", "SwarpActionID", "SWARP_ACTION_ID", "SwarpID"),
    "DrawBack": (
        "DrawBack",
        "DrawBackAction",
        "DrawBackActionID",
        "DRAWBACK_ACTION_ID",
        "DrawBackID",
    ),
}


def _paths(name: str) -> tuple[Path, Path]:
    folder, stem, *_ = SKILLS[name]
    return UNIT_MENU / folder / f"{stem}.s", UNIT_MENU / folder / f"{stem}.lyn.event"


def source_action_id(name: str) -> int:
    src, _ = _paths(name)
    equ = SKILLS[name][2]
    match = re.search(rf"^\.equ\s+{equ},\s*(0x[0-9A-Fa-f]+|\d+)", src.read_text(encoding="utf-8"), re.M)
    assert match, f"{src.name} no longer defines {equ}"
    return int(match.group(1), 0)


def installer_action_id(name: str) -> int:
    macro = SKILLS[name][3]
    match = re.search(
        rf"#define\s+{macro}\s+(0x[0-9A-Fa-f]+|\d+)",
        INSTALLER.read_text(encoding="utf-8"),
    )
    assert match, f"UnitMenuSkills.event no longer defines {macro}"
    return int(match.group(1), 0)


def table_entry_offset(name: str) -> int:
    return UNIT_ACTION_TABLE + 4 * (installer_action_id(name) - 1)


def action_symbols(rom: bytes, name: str) -> dict[str, int]:
    _, lyn = _paths(name)
    entry = struct.unpack_from("<I", rom, table_entry_offset(name))[0]
    if not (ROM_BASE <= entry < ROM_BASE + len(rom)):
        return {}
    offsets = label_offsets(lyn)
    label = f"{name}ActionEntry" if name != "DrawBack" else "DrawBackActionEntry"
    if label not in offsets:
        return {}
    base = ((entry - ROM_BASE) & ~1) - (offsets[label] & ~1)
    return {n: base + (off & ~1) for n, off in offsets.items()}


def links(rom: bytes, name: str) -> dict[str, int]:
    syms = action_symbols(rom, name)
    label = f"{name}Links"
    if not syms or label not in syms:
        return {}
    tester, skill_id, help_text = struct.unpack_from("<III", rom, syms[label])
    return {"SkillTester": tester & ~1, "SkillID": skill_id, "HelpText": help_text}


def selection_callbacks(rom: bytes, name: str) -> dict[str, int]:
    syms = action_symbols(rom, name)
    label = f"{name}TargetSelection"
    if not syms or label not in syms:
        return {}
    words = struct.unpack_from("<8I", rom, syms[label])
    names = (
        "OnInit",
        "OnEnd",
        "unused2",
        "OnSwitchIn",
        "unused4",
        "OnSelect",
        "OnBPress",
        "unused7",
    )
    return dict(zip(names, words))
