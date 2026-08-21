# Skill ASM must execute under Unicorn before it is called working

A new or changed skill is **not** done — and must not be reported to the user as
working — until its compiled Thumb has been executed on a CPU emulator and the
observable result asserted.

Reading the `.s`, checking a `POIN` list, or confirming a clean assemble proves
only that code exists. It does not prove the code computes anything. Two real
bugs in this repo passed every source-level check: ChargePlus doubled a movement
value via an add-then-copy that looked correct on paper, and every Defiant skill
returned no boost because the getter chain was never reachable from the ROM.

## Scope

Required for skill ASM that computes or decides anything:

- stat modifiers in getter chains (`prDefiant*`, `prPush*`, `prRally*`, …)
- pre-battle / post-combat loop routines that write battle-struct fields
- proc-rate, threshold, or HP-fraction checks
- anything with a branch — a skill whose only failure mode is "took the wrong
  path" is exactly what source review misses

Not required for: data-only edits (icons, descriptions, ID tables), pure
`#include` wiring with no new instructions, docs.

## How

Harness: `Tools/thumb_harness.py` (Unicorn ARM7TDMI, Thumb). Requires the
`unicorn` package and devkitARM at `C:\devkitPro\devkitARM\bin`.

Two entry points, in order of preference:

1. **Execute bytes from the built ROM.** Locate the routine by walking the
   structure that reaches it (getter chain, loop pointer list), then run those
   bytes. This proves the wiring *and* the arithmetic in one test — it is the
   only form that would have caught the Defiant chain never being installed.
   See `tests/test_defiant_execution.py`.
2. **Assemble the `.s` and execute that.** Use `assemble()` +
   `symbol_offsets()`; never hand-count label offsets. Cheaper, but blind to
   whether the routine is reachable in the ROM. See
   `tests/test_chargeplus_execution.py`.

`Harness` stubs the shared `SkillTester` trampoline (`.short 0xf800`) and takes
`skill_present=True|False`, so the skill-present and skill-absent paths are both
reachable without modelling skill lookup.

## Assertions that count

- **Both sides of every branch.** A test that only asserts the boost applies is
  passing vacuously if the routine unconditionally boosts. Assert the no-op case
  too.
- **The exact boundary**, and one step either side. For a 25%-of-max-HP gate:
  `4/16` (at), `3/16` (below), `5/16` (above).
- **The reported case verbatim** when fixing a bug report. If the user said
  4/16 HP, that exact pair gets its own named test.
- Assert the returned register or the written struct byte — not a label address
  and not "it didn't crash".

## Reporting

- Do not tell the user a skill works on the strength of source reading, a green
  assemble, or a structural pointer check. Say what was executed and what it
  returned.
- State the residual gap. The harness stubs skill lookup and usually runs one
  routine, not the whole chain, so it cannot prove the unit owns the skill or
  that a later modifier cancels the result. Say so, and ask for an in-game check.
- Never describe emulator verification that did not run.

## Test placement

- Put the test in `tests/`; `run_tests.py` auto-discovers `test_*.py`.
- `run_tests.py` sorts a test into the ROM phase by scanning its source for
  markers (`FE7_Hack.gba`, `self.hack`, `cls.hack`, `BUILT`, …). A ROM-reading
  test whose source contains none of them runs in the wrong phase — reference
  the ROM by one of those names so it lands after assemble.
- `raise unittest.SkipTest` when `unicorn`, devkitARM, or the built ROM is
  missing. Never fail the suite for a missing local tool.
- Skip conditions must be genuine. Do not skip when the routine is simply not
  wired in — that is the failure the test exists to catch.

Do not test which unit, class, or item has the skill; see `tdd.md`.
