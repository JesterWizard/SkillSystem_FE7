"""Decode a lyn .event blob (SHORT/BYTE/WORD) into the bytes EA would emit."""
from __future__ import annotations

import re
from pathlib import Path

TOKEN_RE = re.compile(r"^(SHORT|BYTE|WORD)$", re.I)
NUM_RE = re.compile(r"^\$?[0-9A-Fa-f]+$")


def lyn_to_bytes(path: Path) -> bytes:
    out = bytearray()
    for raw in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw.split("//", 1)[0].strip()
        if not line:
            continue
        parts = line.replace(",", " ").split()
        if not parts or not TOKEN_RE.match(parts[0]):
            continue
        width = {"SHORT": 2, "BYTE": 1, "WORD": 4}[parts[0].upper()]
        for tok in parts[1:]:
            if not NUM_RE.match(tok):
                continue
            value = int(tok[1:], 16) if tok.startswith("$") else int(tok, 16)
            out.extend(value.to_bytes(width, "little"))
    return bytes(out)
