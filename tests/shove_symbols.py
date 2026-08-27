"""Locate the Shove blob's exported labels inside FE7_Hack.gba.

Same idea as summon_symbols: lyn emits every global as a run of cumulative
``ORG CURRENTOFFSET+$n`` lines at the top of the .lyn.event, so each label's
offset within the blob is known without guessing at byte signatures.  The one
absolute address needed to anchor that run is published by the ROM itself --
FE7's UnitActionFunctionPointer entry for the Shove action id, which
UnitMenuSkills.event repoints at ShoveActionEntry.

Anchoring on the table entry means these helpers return nothing at all when the
action is not installed, which is the failure the tests exist to catch.
"""
from __future__ import annotations

import re
import struct
from pathlib import Path

# summon_symbols owns the generic lyn parsing; the names are not summon-specific.
from summon_symbols import blob_length, label_offsets  # noqa: F401

ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
SHOVE_DIR = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/Shove"
ACTION_S = SHOVE_DIR / "ShoveAction.s"
ACTION_LYN = SHOVE_DIR / "ShoveAction.lyn.event"
UNIT_MENU_SKILLS = (
    ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/UnitMenuSkills.event"
)
SKILLS_MENU = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/SkillsMenu.event"

ROM_BASE = 0x08000000

# FE7 ApplyUnitAction (0x0802F218) indexes this by actionId - 1, after
# rejecting anything above 0x1B.
UNIT_ACTION_TABLE = 0x2F248


def source_action_id() -> int:
    """ShoveActionID as ShoveAction.s writes it into gActionData."""
    text = ACTION_S.read_text(encoding="utf-8", errors="replace")
    match = re.search(r"^\.equ\s+ShoveActionID,\s*(0x[0-9A-Fa-f]+|\d+)", text, re.M)
    assert match, "ShoveAction.s no longer defines ShoveActionID"
    return int(match.group(1), 0)


def installer_action_id() -> int:
    """SHOVE_ACTION_ID as UnitMenuSkills.event repoints the table with."""
    text = UNIT_MENU_SKILLS.read_text(encoding="utf-8", errors="replace")
    match = re.search(r"#define\s+SHOVE_ACTION_ID\s+(0x[0-9A-Fa-f]+|\d+)", text)
    assert match, "UnitMenuSkills.event no longer defines SHOVE_ACTION_ID"
    return int(match.group(1), 0)


def table_entry_offset(action_id: int | None = None) -> int:
    if action_id is None:
        action_id = installer_action_id()
    return UNIT_ACTION_TABLE + 4 * (action_id - 1)


def action_blob_base(rom: bytes) -> int:
    """File offset of ShoveAction.lyn.event's first byte, or -1."""
    entry = struct.unpack_from("<I", rom, table_entry_offset())[0]
    if not (ROM_BASE <= entry < ROM_BASE + len(rom)):
        return -1
    offsets = label_offsets(ACTION_LYN)
    if "ShoveActionEntry" not in offsets:
        return -1
    return ((entry - ROM_BASE) & ~1) - (offsets["ShoveActionEntry"] & ~1)


def action_symbols(rom: bytes) -> dict[str, int]:
    """Label -> file offset (Thumb bit stripped) for the shove blob."""
    base = action_blob_base(rom)
    if base < 0:
        return {}
    return {n: base + (off & ~1) for n, off in label_offsets(ACTION_LYN).items()}


def links(rom: bytes) -> dict[str, int]:
    """The words UnitMenuSkills.event appends after the blob."""
    syms = action_symbols(rom)
    if not syms:
        return {}
    at = syms["ShoveLinks"]
    tester, skill_id, help_text = struct.unpack_from("<III", rom, at)
    return {
        "SkillTester": tester & ~1,
        "ShoveID": skill_id,
        "HelpText": help_text,
    }


def selection_callbacks(rom: bytes) -> dict[str, int]:
    """The TargetSelectionDefinition slots, as absolute Thumb addresses."""
    syms = action_symbols(rom)
    if not syms:
        return {}
    at = syms["ShoveTargetSelection"]
    words = struct.unpack_from("<8I", rom, at)
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
