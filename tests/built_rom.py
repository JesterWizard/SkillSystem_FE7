"""Loading FE7_Hack.gba for ROM-phase tests, with a real "was it built?" check.

`MAKE_HACK_full.cmd` copies FE7_clean.gba over FE7_Hack.gba *before* it
assembles. If the assemble step then fails, is interrupted, or was never run,
FE7_Hack.gba exists at full size but is byte-identical to the clean ROM. A test
that only checks `is_file()` walks into that copy and fails deep inside a
struct.unpack or a `find() == -1` assertion, which reads as "the hack is
broken" when the truth is "there is no hack in this file".

`load()` raises SkipTest for both cases -- missing and unassembled -- so the
suite stays honest about a missing local build without ever masking a genuine
regression: the moment the ROM really is assembled, the tests run for real.
"""
from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BUILT = ROOT / "FE7_Hack.gba"
CLEAN = ROOT / "FE7_clean.gba"
SYMS = ROOT / "FE7_Hack.sym"

ROM_ADDR_MASK = 0x1FFFFFF


def load() -> bytes:
    """Bytes of the assembled ROM, or SkipTest if it was never assembled."""
    if not BUILT.is_file():
        raise unittest.SkipTest("FE7_Hack.gba not built")
    rom = BUILT.read_bytes()
    if CLEAN.is_file() and rom == CLEAN.read_bytes():
        raise unittest.SkipTest(
            "FE7_Hack.gba is an unassembled copy of FE7_clean.gba; "
            "run MAKE_HACK_quick.cmd"
        )
    return rom


def symbols() -> dict[str, int]:
    """Nocash .sym map, or SkipTest if it is missing."""
    if not SYMS.is_file():
        raise unittest.SkipTest("FE7_Hack.sym not built")
    out: dict[str, int] = {}
    for line in SYMS.read_text(encoding="utf-8", errors="replace").splitlines():
        m = re.match(r"([0-9A-Fa-f]{8})\s+(\S+)", line.strip())
        if m:
            out[m.group(2)] = int(m.group(1), 16)
    return out


def offset(rom: bytes, addr: int, size: int = 4) -> int:
    """ROM file offset for a GBA address, checked against the image length.

    A stale .sym pointing past the end of a freshly copied ROM means the two
    artifacts disagree about which build they belong to -- skip rather than
    raise struct.error from the caller.
    """
    off = addr & ROM_ADDR_MASK
    if off < 0 or off + size > len(rom):
        raise unittest.SkipTest(
            f"{addr:#010x} is past the end of FE7_Hack.gba; "
            "the ROM and FE7_Hack.sym are from different builds"
        )
    return off
