# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A port of the FE8 Skill System to **Fire Emblem 7 (FE7U)**. The repo is not a
program — it is a **ROM patch buildfile**. `FE7_clean.gba` (an untracked vanilla
FE7U ROM the user supplies) is copied to `FE7_Hack.gba`, then Event Assembler
writes hacks, tables, text, and compiled Thumb ASM into it. Installation via
FEBuilderGBA is not supported; Event Assembler is the only supported path.

Read `CONTEXT.md` first for domain vocabulary. This file is the build, wiring,
and test map.

## Build

```cmd
MAKE_HACK_full.cmd     :: text + maps + skill ASM + tests + assemble + UPS patch + launches NO$GBA
MAKE_HACK_quick.cmd    :: calls MAKE_HACK_full.cmd with the "quick" arg — skips text/map/patch steps
```

`MAKE_HACK_quick` is the normal loop. Use `MAKE_HACK_full` only when text
(`Text/`), maps (`Maps/`), or tables changed. Both scripts `pause` on failure and
launch NO$GBA on success.

`MAKE_HACK_full.cmd` is the authoritative pipeline order:
`copy ROM → (text, maps) → Tools/build_skill_asm.py → dump_fe7_text_table.py →
source tests → ColorzCore assemble → (UPS diff) → ROM tests → NO$GBA`.

External tool dependencies, hard-coded by path:
- devkitARM at `C:\devkitPro\devkitARM\bin` (`arm-none-eabi-as`, `objcopy`, `readelf`)
- `EventAssembler/` (ColorzCore, `lyn.exe`, `ParseFileUTF8.exe`) — vendored
- Python 3 for `Tools/*.py` and tests; `unicorn` for CPU-emulation tests
- `Tools/FE-Clib` is a git submodule

## Tests

```bash
python tests/run_tests.py                  # everything
python tests/run_tests.py --pre-assemble   # source-only tests (run before assemble)
python tests/run_tests.py --rom            # tests that read the built FE7_Hack.gba
python tests/test_defiant_execution.py     # a single file
python -m unittest tests.test_defiant_execution.ClassName.test_name  # a single test
```

`run_tests.py` splits tests into the **source** and **ROM** phases by *grepping
the test's own source* for markers (`FE7_Hack.gba`, `self.hack`, `cls.hack`,
`BUILT`, `cls.rom`, …). A test that reads the built ROM without naming it by one
of those markers runs in the wrong phase and will fail spuriously — reference the
ROM by one of those names.

Tests must `raise unittest.SkipTest` when `FE7_clean.gba`, `FE7_Hack.gba`,
`unicorn`, or devkitARM is missing — never fail the suite for a missing local tool.

`Tools/thumb_harness.py` is the Unicorn ARM7TDMI harness: `assemble(src)`,
`symbol_offsets(src)`, and `Harness(code, skill_present=)` with `.seed()`,
`.read()`, `.run()`. It stubs the shared `SkillTester` trampoline so both the
skill-present and skill-absent branches are reachable.

## Architecture

### Assembly order (`ROMBuildfile.event`)

`EAstdlib` → `CustomDefinitions.event` → `ORG FreeSpace` → text → `Tables/` →
`EngineHacks/_MasterHackInstaller.event`, then `ASSERT (FreeSpaceEnd - currentOffset)`
so an overrun fails the build. FreeSpace is `0x1000000`–`0x2000000` (past the
end of a 16MB ROM), defined in `CustomDefinitions.event`.

`EngineHacks/_MasterHackInstaller.event` is the install-order spine, and order
matters: the Skill System must install before `Necessary/StatGetters/`, because
the getter chains point at `prDefiant*`/`prPush*`/`prResolve` routines the skill
system defines. Expanded Modular Save installs after the skill system and
StrMag. Most modules are gated by `#ifdef`s from `EngineHacks/Config.event`,
which is the single toggle file for optional hacks (STR/MAG split, narrow font,
allegiance statscreen, tutorials) and for skill tuning constants.

### The three layers of a skill

1. **ID** — `EngineHacks/SkillSystem/skill_definitions.event` maps each skill to
   an ID `1–254` or to `SKILL_OFF` (255) to disable it. IDs must be unique.
   Descriptions/authors live in `skill_definition_descriptions.event`.
2. **Effect (Thumb ASM)** — `EngineHacks/SkillSystem/Skills/<Category>/<Skill>/<Skill>.s`,
   categorized by *when the engine runs it* (`PreBattleSkills`, `PostBattleSkills`,
   `ProcSkills`, `StatModifierSkills`, `AuraSkills`, `MovementSkills`, …).
3. **Wiring** — each category's `<Category>.event` appends the skill to that
   category's loop as a fixed record: `ALIGN 4`, label, `#include "<Skill>.lyn.event"`,
   then `POIN SkillTester` (+ any other externs the routine references) and
   `WORD <Skill>ID`. `Skills/MasterSkillInstaller.event` selects which categories
   are installed.

### Live skill categories

Source of truth: uncommented `#include`s in
`EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event`. Do not copy that
list elsewhere.

For one skill (ID, live, `.s` path), parse the event files:

```cmd
python Tools/build_skill_index.py --skill Provoke
```

`Documentation/skill-index.md` is a derived dump rewritten by `MAKE_HACK`. If it
disagrees with the event files, the event files win.

### Where to look

| Task | File |
|------|------|
| Domain words | `CONTEXT.md` |
| Skill ID, live, `.s` path | `python Tools/build_skill_index.py --skill Name` |
| Toggle ID / `SKILL_OFF` | `EngineHacks/SkillSystem/skill_definitions.event` |
| Effect ASM | `EngineHacks/SkillSystem/Skills/<Category>/<Skill>/<Skill>.s` |
| Loop wiring | `EngineHacks/SkillSystem/Skills/<Category>/<Category>.event` |
| Category on/off | `EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event` |
| Stat modifier chain | `EngineHacks/Necessary/StatGetters/<Stat>.event` |
| Optional hacks / skill constants | `EngineHacks/Config.event` |
| Editor assignment (do not test) | `Tables/NightmareModules/*.csv` |
| Level-up learnset | `EngineHacks/SkillSystem/skill_lists.event` |

`Tools/build_skill_asm.py` regenerates `.lyn.event` from `.s`: it scans every
non-`.lyn` `.event` under `SkillSystem/` for `#incbin "*.dmp"` / `#include
"*.lyn.event"`, finds the sibling `.s`, assembles it, and rewrites `#incbin`
references to `#include`. It deliberately skips a `.s` that has a sibling `.c`
(those are compiler dumps) unless the `.s` is a hand-written trampoline
(`SkillTester:` + `@POIN`). `AssembleARM.bat` is the manual single-file path
(drag a `.s` onto it) but the build script is preferred.

### Stat modifier chains

`EngineHacks/Necessary/StatGetters/<Stat>.event` defines a `p<Stat>Modifiers`
`POIN` list terminated by `WORD 0`. `_InstallStatGetters.event` hooks the vanilla
`GetUnit*` entry points so the chains actually run — a routine that exists but is
not in a chain, or a chain not installed, is dead code that source review cannot
detect. `_Common.event` provides the `rAdd`/`rIfUnitHasSkill`/`_testSkill` macros.

### Data and text

- `Tables/NightmareModules/*.csv` — personal skills, class skills, learnsets;
  compiled by `c2ea.exe`/`n2c.exe` via `Tables/TableInstaller.event`.
- `EngineHacks/SkillSystem/skill_lists.event` — level-up learnsets.
- `Text/text_buildfile.txt` + `Tools/TextProcess/text-process-classic.py` →
  `Text/InstallTextData.event`; skill names/descriptions in `skilldesc_text.txt`.
- `Maps/MasterMapInstaller.event` via `Tools/tmx2ea`.

## Project rules

`.claude/rules/` holds binding rules that are loaded automatically. The two that
most often change how a task is done:

- **`fe7-freespace-tables.md`** — never `ORG` past the end of a vanilla FE7 table
  in place; copy it into FreeSpace and repoint. In-place expansion silently
  bricks the ROM (canonical case: item ID `0x9F` landing on the Lord movement-cost
  table at `0xBE3888` → Mov 0).
- **`skill-unicorn-verification.md`** — skill ASM that computes or branches is not
  "working" until its compiled Thumb has been executed under Unicorn and the
  result asserted, on both sides of every branch. Never report a skill as working
  on the strength of a clean assemble or a source read.

Also present: `tdd.md` (red→green→refactor; do not test *which* unit/class/item
has a skill — that is editor data), `no-new-git-branches.md`,
`make-hack-quick.mdc` (assemble before handing back), `token-efficiency.mdc`,
`min-explore.mdc` (edit, do not tour; 2 searches / 3 sliced reads / 0 explore agents),
and `codedrift.md` (prefer CodeDrift MCP via `Tools/codedrift_cli.py`; pin `mcp<2`).

## Known state (from README)

Roughly half the FE8 skills are ported. ModularStatScreen and IconRework offsets
were hand-converted from FE8 and are not all verified. Skill scrolls and
in-game skill add/remove are partially supported. `Documentation/` holds
`ram-map.md` and `narrow-font.md`.
