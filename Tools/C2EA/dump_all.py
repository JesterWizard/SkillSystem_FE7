"""One-shot CSV -> event dump. Not part of the regular build.

Writes .event files next to each CSV. Does not overwrite Tables/TableInstaller.event.
"""
import builtins
import os
import sys

ROOT = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, ROOT)
os.chdir(os.path.join(ROOT, "..", "..", "Tables"))

builtins.input = lambda *args, **kwargs: "y"  # blank cells -> 0; skip pause
import c2ea  # noqa: E402

rom = os.path.normpath(os.path.join(os.getcwd(), "..", "FE7_clean.gba"))
csv_list = []
for dirpath, _, files in os.walk("."):
    for name in files:
        if name.lower().endswith(".csv"):
            csv_list.append(os.path.join(dirpath, name))
csv_list.sort()

for csv_path in csv_list:
    nmm_path = csv_path[:-4] + ".nmm"
    out_path = csv_path[:-4] + ".event"
    rom = c2ea.process(csv_path, nmm_path, out_path, rom)

print("Dumped", len(csv_list), "tables")
