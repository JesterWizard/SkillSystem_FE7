"""Locate the Sacrifice blob from the ApplyUnitAction hook at 0x0802F218."""
from __future__ import annotations

import re
import struct
from pathlib import Path

from summon_symbols import label_offsets  # noqa: F401

ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
UNIT_MENU = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills"
ACTION_S = UNIT_MENU / "Sacrifice" / "SacrificeAction.s"
ACTION_LYN = UNIT_MENU / "Sacrifice" / "SacrificeAction.lyn.event"
INSTALLER = UNIT_MENU / "UnitMenuSkills.event"
SKILLS_MENU = UNIT_MENU / "SkillsMenu.event"

ROM_BASE = 0x08000000
APPLY_UNIT_ACTION = 0x2F218
HOOK_PTR = APPLY_UNIT_ACTION + 4
JUMP_TO_HACK = bytes((0x00, 0x4B, 0x18, 0x47))


def source_action_id(name: str = "Sacrifice") -> int:
    equ = {
        "Sacrifice": "SacrificeActionID",
        "ArdentSacrifice": "ArdentSacrificeActionID",
        "ReciprocalAid": "ReciprocalAidActionID",
    }[name]
    match = re.search(
        rf"^\.equ\s+{equ},\s*(0x[0-9A-Fa-f]+|\d+)",
        ACTION_S.read_text(encoding="utf-8"),
        re.M,
    )
    assert match, f"SacrificeAction.s no longer defines {equ}"
    return int(match.group(1), 0)


def installer_action_id(name: str = "Sacrifice") -> int:
    macro = {
        "Sacrifice": "SACRIFICE_ACTION_ID",
        "ArdentSacrifice": "ARDENT_SACRIFICE_ACTION_ID",
        "ReciprocalAid": "RECIPROCAL_AID_ACTION_ID",
    }[name]
    match = re.search(
        rf"#define\s+{macro}\s+(0x[0-9A-Fa-f]+|\d+)",
        INSTALLER.read_text(encoding="utf-8"),
    )
    assert match, f"UnitMenuSkills.event no longer defines {macro}"
    return int(match.group(1), 0)


def action_symbols(rom: bytes) -> dict[str, int]:
    if rom[APPLY_UNIT_ACTION : APPLY_UNIT_ACTION + 4] != JUMP_TO_HACK:
        return {}
    entry = struct.unpack_from("<I", rom, HOOK_PTR)[0]
    if not (ROM_BASE <= entry < ROM_BASE + len(rom)):
        return {}
    offsets = label_offsets(ACTION_LYN)
    if "ApplyUnitActionFE7" not in offsets:
        return {}
    base = ((entry - ROM_BASE) & ~1) - (offsets["ApplyUnitActionFE7"] & ~1)
    return {n: base + (off & ~1) for n, off in offsets.items()}


def links(rom: bytes) -> dict[str, int]:
    syms = action_symbols(rom)
    if not syms or "SacrificeLinks" not in syms:
        return {}
    words = struct.unpack_from("<7I", rom, syms["SacrificeLinks"])
    return {
        "SkillTester": words[0] & ~1,
        "SkillID": words[1],
        "HelpText": words[2],
        "ArdentID": words[3],
        "ArdentHelp": words[4],
        "ReciprocalID": words[5],
        "ReciprocalHelp": words[6],
    }


def selection_callbacks(rom: bytes, label: str = "SacrificeTargetSelection") -> dict[str, int]:
    syms = action_symbols(rom)
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
