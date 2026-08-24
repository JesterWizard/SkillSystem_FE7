#!/usr/bin/env python3
"""Rewrite a freeform skill request into a file-pack agent brief."""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_skill_index import extract_skills, rewrite_prompt  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    args = sys.argv[1:] if argv is None else argv
    if not args or args[0] in ("-h", "--help"):
        print("usage: python Tools/skill_prompt.py <prompt>", flush=True)
        print("example: python Tools/skill_prompt.py implement Nullify", flush=True)
        return 0 if args and args[0] in ("-h", "--help") else 2
    if args == ["-"]:
        text = sys.stdin.read()
    else:
        text = " ".join(args)
    print(rewrite_prompt(text), end="")
    return 0 if extract_skills(text) else 1


if __name__ == "__main__":
    raise SystemExit(main())
