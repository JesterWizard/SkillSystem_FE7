# FE7 Skill System

Domain language for the FE7U port of the FE8 Skill System. This file is a glossary only. How the build, hooks, and tests work lives in `CLAUDE.md`.

## Product

**Buildfile**:
Source that Event Assembler applies onto a ROM. This repository is a buildfile, not an application.
_Avoid_: program, installer, FEBuilder patch

**Clean ROM**:
Untracked vanilla FE7U image the builder copies from (`FE7_clean.gba`).
_Avoid_: base ROM, original ROM, vanilla dump (as a filename)

**Hack ROM**:
Built output image (`FE7_Hack.gba`).
_Avoid_: SkillsTest.gba, patched ROM, output.gba

**FreeSpace**:
ROM range past the vanilla 16MB image where new code and relocated tables live.
_Avoid_: unused ROM, padding, expansion area

## Skills

**Skill**:
A named ability with a unique ID in 1–254.
_Avoid_: hack (for a single ability), perk, feat

**Skill ID**:
The numeric identity of a skill. Duplicate IDs are invalid.
_Avoid_: skill number, index (unless talking about a table row)

**SKILL_OFF**:
Sentinel ID 255 meaning the skill is not installed.
_Avoid_: disabled, unused, ID 0

**Category**:
The engine moment a skill is allowed to run (pre-battle, proc, stat modifier, and so on). A skill with no live category include is dead even if its ID exists.
_Avoid_: type, folder, module (for this grouping)

**Wiring**:
The category-loop record that makes a skill reachable (include, `SkillTester` pointer, skill ID word).
_Avoid_: installer snippet, hook (unless it is a vanilla branch patch)

**SkillTester**:
The shared predicate: does this unit currently have this skill ID?
_Avoid_: HasSkill, skill check, SkillSys test

**Learnset**:
Skills granted by unit level, not by editor personal/class rows.
_Avoid_: level-up table (when you mean the skill list), promotion skills

**Editor data**:
Which unit, class, or item is assigned a skill. Not engine behavior; do not test it as such.
_Avoid_: skill assignment tests, “Lyn has X”

**Skill scroll**:
An item that grants a skill when used.
_Avoid_: skill item, manual

## Engine moments

**Stat getter**:
Vanilla `GetUnit*` entry that runs a terminator-ended modifier chain.
_Avoid_: stat formula, stat hook (the hook is how getters are installed)

**Modifier chain**:
Ordered list of routines that add to one stat; a routine not in a chain never runs.
_Avoid_: stat list, POIN table (as the concept name)

**Pre-battle**:
Skills that write battle-struct fields before combat resolves.
_Avoid_: in-combat (unless the skill is a proc)

**Proc**:
Chance- or threshold-based combat skill that may or may not fire in a round.
_Avoid_: proc skill vs ProcSkills as if they were different ideas; RNG skill

**Post-battle**:
Skills that run after combat ends.
_Avoid_: post-action (a different, often uninstalled category)

**Aura**:
Skills whose effect depends on nearby units.
_Avoid_: range buff (unless the skill is specifically a range modifier)

**WTA**:
Weapon triangle advantage, including skills that alter it.
_Avoid_: triangle, WT, weapon triangle skill (use WTA)

## Data and memory

**Table expansion**:
Copy a vanilla table into FreeSpace, append there, and repoint. Never grow a vanilla table in place.
_Avoid_: extend in-place, ORG past table end

**RAM map**:
Named IWRAM, EWRAM, and SRAM symbols so code does not hard-code SkillSys addresses.
_Avoid_: ram.s, free RAM (as the file/concept)

**IWRAM / EWRAM / SRAM**:
The three SkillSys-owned RAM regions (tiny hot state, larger arrays, save chunks).
_Avoid_: WRAM, cart RAM (for SRAM)

## Verification

**Source test**:
A test that must pass before assemble; it does not read the Hack ROM.
_Avoid_: unit test (as the phase name)

**ROM test**:
A test that reads the built Hack ROM. The test source must name that ROM with a runner marker or it runs in the wrong phase.
_Avoid_: integration test (as the phase name)

**Unicorn verification**:
Executing compiled Thumb on an ARM7TDMI emulator and asserting both sides of every branch. Assemble-clean is not “working.”
_Avoid_: source review, lyn check, “it builds”
