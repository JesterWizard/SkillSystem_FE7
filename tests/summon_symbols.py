"""Locate the Summon blobs' exported labels inside FE7_Hack.gba.

lyn emits every global as a run of cumulative ``ORG CURRENTOFFSET+$n`` lines at
the top of the .lyn.event, so each label's offset *within the blob* is known
without guessing at instruction patterns.  Anchoring that run to an absolute
address then only needs one address the ROM already publishes:

* SummonAction  -- FE7's UnitActionFunctionPointer entry for action id 0x05,
  which UnitMenuSkills.event repoints at SummonActionEntry.
* NewSummonUsability -- has no such anchor, so it is found by searching for the
  contiguous run of opcodes lyn emits before its first relocation.

Both are derived from the generated files, so they follow source edits instead
of pinning a byte signature that silently stops matching.
"""
from __future__ import annotations

import re
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HACK = ROOT / "FE7_Hack.gba"
SUMMON_DIR = ROOT / "EngineHacks/SkillSystem/Skills/UnitMenuSkills/Summon"
ACTION_LYN = SUMMON_DIR / "SummonAction.lyn.event"
USABILITY_LYN = SUMMON_DIR / "NewSummonUsability.lyn.event"

ROM_BASE = 0x08000000

# FE7 ApplyUnitAction (0x0802F218) indexes this by actionId - 1.
UNIT_ACTION_TABLE = 0x2F248
SUMMON_ACTION_ID = 0x05
SUMMON_TABLE_ENTRY = UNIT_ACTION_TABLE + 4 * (SUMMON_ACTION_ID - 1)

_ORG_RE = re.compile(r"ORG\s+CURRENTOFFSET\+\$([0-9A-Fa-f]+)\s*;\s*(\w+)\s*:")
_DATA_RE = re.compile(r"^(SHORT|BYTE|WORD)\b", re.I)
_NUM_RE = re.compile(r"^\$?[0-9A-Fa-f]+$")


def label_offsets(lyn: Path) -> dict[str, int]:
    """Label -> offset from the blob's first byte (Thumb bit included)."""
    offsets: dict[str, int] = {}
    running = 0
    for line in lyn.read_text(encoding="utf-8", errors="replace").splitlines():
        match = _ORG_RE.search(line)
        if not match:
            continue
        running += int(match.group(1), 16)
        offsets[match.group(2)] = running
    return offsets


def leading_bytes(lyn: Path) -> bytes:
    """The blob's opcodes up to its first relocation, usable as a signature."""
    out = bytearray()
    for raw in lyn.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw.split("//", 1)[0].strip()
        if not line or line in {"PUSH", "POP"} or line.startswith(("ALIGN", "ORG")):
            continue
        if not _DATA_RE.match(line):
            break  # POIN or anything else lyn cannot express as literal bytes
        parts = line.replace(",", " ").split()
        width = {"SHORT": 2, "BYTE": 1, "WORD": 4}[parts[0].upper()]
        for tok in parts[1:]:
            if not _NUM_RE.match(tok):
                continue
            value = int(tok[1:], 16) if tok.startswith("$") else int(tok, 16)
            out.extend(value.to_bytes(width, "little"))
    return bytes(out)


def blob_length(lyn: Path) -> int:
    """Bytes EA emits for the blob, so trailing linked words can be located.

    The usability blob ends on a bare ``SkillTester:`` label; UnitMenuSkills.event
    appends ``POIN SkillTester`` and ``WORD SummonID`` straight after it, so those
    words live at blob_base + blob_length().
    """
    size = 0
    for raw in lyn.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw.split("//", 1)[0].strip()
        if not line or line in {"PUSH", "POP"} or line.startswith("ORG"):
            continue
        parts = line.replace(",", " ").split()
        head = parts[0].upper()
        if head == "ALIGN":
            step = int(parts[1])
            size = (size + step - 1) // step * step
            continue
        if head == "POIN":
            size += 4
            continue
        if head not in {"SHORT", "BYTE", "WORD"}:
            continue
        width = {"SHORT": 2, "BYTE": 1, "WORD": 4}[head]
        size += width * sum(1 for tok in parts[1:] if _NUM_RE.match(tok))
    return size


def action_blob_base(rom: bytes) -> int:
    """File offset of SummonAction.lyn.event's first byte, or -1."""
    entry = struct.unpack_from("<I", rom, SUMMON_TABLE_ENTRY)[0]
    if not (ROM_BASE <= entry < ROM_BASE + len(rom)):
        return -1
    offsets = label_offsets(ACTION_LYN)
    if "SummonActionEntry" not in offsets:
        return -1
    return ((entry - ROM_BASE) & ~1) - (offsets["SummonActionEntry"] & ~1)


def usability_blob_base(rom: bytes) -> int:
    """File offset of NewSummonUsability.lyn.event's first byte, or -1."""
    signature = leading_bytes(USABILITY_LYN)
    if len(signature) < 16:
        return -1
    first = rom.find(signature)
    if first < 0 or rom.find(signature, first + 1) >= 0:
        return -1  # missing, or ambiguous enough that a hit proves nothing
    return first


def action_symbols(rom: bytes) -> dict[str, int]:
    """Label -> file offset (Thumb bit stripped) for the summon action blob."""
    base = action_blob_base(rom)
    if base < 0:
        return {}
    return {n: base + (off & ~1) for n, off in label_offsets(ACTION_LYN).items()}


def usability_symbols(rom: bytes) -> dict[str, int]:
    base = usability_blob_base(rom)
    if base < 0:
        return {}
    return {n: base + (off & ~1) for n, off in label_offsets(USABILITY_LYN).items()}
