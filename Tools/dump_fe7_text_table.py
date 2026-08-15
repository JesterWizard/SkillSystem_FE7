"""Copy FE7's vanilla text-pointer table into Text/NewTextTable.dmp.

Skill System's stock dump is FE8's table. Pointing GetStringFromIndex at it
makes title-start Huffman-decode garbage and black-screen.
"""
import argparse
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VANILLA_TABLE_FILE_OFF = 0xB808AC
DEFAULT_ENTRIES = 0x1800


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rom", type=Path, default=ROOT / "FE7_clean.gba")
    parser.add_argument("--out", type=Path, default=ROOT / "Text" / "NewTextTable.dmp")
    parser.add_argument("--entries", type=lambda s: int(s, 0), default=DEFAULT_ENTRIES)
    args = parser.parse_args()

    rom = args.rom.read_bytes()
    nbytes = args.entries * 4
    end = VANILLA_TABLE_FILE_OFF + nbytes
    if end > len(rom):
        print(f"ROM too small for {args.entries} entries", file=sys.stderr)
        return 1

    blob = bytearray(rom[VANILLA_TABLE_FILE_OFF:end])
    first = struct.unpack_from("<I", blob, 0)[0]
    if first != 0x08AEAE8C:
        print(f"unexpected text table start {first:08X} (not FE7U)", file=sys.stderr)
        return 1

    args.out.write_bytes(blob)
    print(f"Wrote {args.out} ({args.entries} entries from {args.rom.name})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
