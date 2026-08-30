from pathlib import Path
import re

t = Path("EngineHacks/SkillSystem/Skills/StandaloneSkills/Boon/Boon.lyn.event").read_text()
data = bytearray()
for line in t.splitlines():
    line = line.split(";")[0].strip()
    if line.startswith("SHORT"):
        for h in re.findall(r"\$([0-9A-Fa-f]+)", line):
            data += int(h, 16).to_bytes(2, "little")
    elif line.startswith("BYTE"):
        for h in re.findall(r"\$([0-9A-Fa-f]+)", line):
            data += bytes([int(h, 16)])
print("len", len(data))
Path("_boon.bin").write_bytes(data)

rom = Path("FE7_clean.gba").read_bytes()
Path("_tick.bin").write_bytes(rom[0x01E9A0:0x01EA80])
