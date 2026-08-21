---
description: Red-green-refactor for FE7 Skill System features and ROM-visible behavior
alwaysApply: true
---

# Test-driven development

For new behavior or refactors that can change the ROM or build tools, follow red → green → refactor. Do not ship behavior changes without a test.

## Order of work

1. **Red** — One failing test for one observable behavior.
2. **Green** — Minimum change to pass. Rebuild `FE7_Hack.gba` if the test reads the ROM.
3. **Refactor** — Clean up while tests stay green. Never refactor while red.

Do not write all tests first, then all code.

## How to test here

- Runner: `python tests/run_tests.py` (combined list). `MAKE_HACK_full.cmd` runs source tests before assemble and ROM tests after. `python tests/<name>.py` still works for one file.
- Prefer characterization of public effects: built ROM vs `FE7_clean.gba`, dump/tool stdout, Event Assembler output.
- Skip (do not fail) if `FE7_clean.gba` or `FE7_Hack.gba` is missing.
- Do not assert on private asm labels or “how” a hack is wired unless that wiring is the bug (e.g. a literal pool next to a patched pointer).
- Do not write tests that check which unit, class, or item has which skill (personal/class/item tables, `PersonalSkillEditor.event`, “Lyn has Assassinate”, etc.). Skill assignment is editor data, not engine behavior. Test that a skill is enabled, ID-stable, and wired into the right calc/proc loop.

## Rules of thumb

- One test at a time; no speculative features.
- Tests must stay deterministic (fixed offsets, no NO$GBA).
- Docs-only / comments: no test required.