#!/usr/bin/env python3
"""Fail if a candidate table slot overlaps a known FE7 hazard region.

Example:
  python Tests/scripts/check_table_overlaps.py --base 0xBE222C --size 0x24 --id 0x9F
"""
from __future__ import annotations

import argparse
import sys

# file offset, length, name — keep in sync with fe7-freespace-tables skill
HAZARDS = (
    (0xBE3888, 0x400, "movement-cost / terrain tables after ItemTable"),
    (0xBE015C, 0x54 * 0x80, "ClassTable region"),
    (0xBDCE18, 0x34 * 0x100, "CharacterTable region"),
)


def overlaps(a0: int, a1: int, b0: int, b1: int) -> bool:
    return a0 < b1 and b0 < a1


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--base", type=lambda s: int(s, 0), required=True)
    p.add_argument("--size", type=lambda s: int(s, 0), required=True)
    p.add_argument("--id", type=lambda s: int(s, 0), required=True)
    p.add_argument(
        "--count",
        type=lambda s: int(s, 0),
        default=1,
        help="number of consecutive entries starting at --id",
    )
    args = p.parse_args()

    start = args.base + args.size * args.id
    end = start + args.size * args.count
    print(f"slot [0x{start:X}, 0x{end:X})")

    bad = False
    for hz0, hz_len, name in HAZARDS:
        hz1 = hz0 + hz_len
        if overlaps(start, end, hz0, hz1):
            print(f"OVERLAP: {name} [0x{hz0:X}, 0x{hz1:X})")
            bad = True

    if bad:
        print("Move this expansion to FreeSpace and repoint getters.")
        return 1
    print("OK: no known hazard overlap")
    return 0


if __name__ == "__main__":
    sys.exit(main())
