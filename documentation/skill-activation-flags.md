# Skill Activation Flags

---

## Index

- [Introduction](#introduction)
- [Plan](#plan)
- [Claiming a bit](#claiming-a-bit)
- [Using the flag from a skill](#using-the-flag-from-a-skill)
- [The forecast guard](#the-forecast-guard)
- [Reset points](#reset-points)
- [Placeholder icons](#placeholder-icons)
- [Code Locations](#code-locations)
- [Testing](#testing)
- [TODO](#todo)
- [Limitations & Bugs](#limitations--bugs)

## Introduction

Some skills may only fire once in a window — "dodges the first attack against
this unit every turn", "revives once per chapter". The engine has nowhere to
record that, so DEC-85 packs sixteen per-unit "this skill has already fired"
bits into the two vanilla-unused unit bytes `0x3A` and `0x3B`.

While a skill's bit is set, the skill must not proc. The bit clears either at
the top of the next player phase (once per turn) or when the unit is loaded for
a chapter (once per map).

The system is written in C (`SkillActivationFlags.c` / `.h`) and compiled
through `lyn`. Only the parts C cannot express — the two lookup tables, the bit
assignment macros, and the `gProcScr_PlayerPhase` splice — stay in the event
file.

Player-facing effect: a once-per-turn skill gets exactly one charge per player
phase, spent on the first qualifying event and unavailable until the next turn.

## Plan

Three moving parts, in the order you touch them when adding a skill.

| Step | Where | What |
|------|-------|------|
| 1 | `flag_assignments.event` | Claim one of the sixteen bits and pick a scope |
| 2 | Your skill's `.c` | Call `CanSkillActivationFlagProc`, then `SetSkillActivationFlag` |
| 3 | Your skill's `.c` | Guard against the battle forecast — see below |

### Where the bit lives

The bit lives on the **deployed `Unit`**, never on a `BattleUnit`. The battle
structs are working copies and only selected fields survive combat, so a write
to `battleUnit->unit.unk3A` is discarded when the fight ends.

A skill running in a battle loop must resolve the real unit first:

```c
unit = GetUnit(defender->unit.index);
```

### Layout

| Byte | Bits | Notes |
|------|------|-------|
| `unit+0x3A` | 0–7 | Low half |
| `unit+0x3B` | 8–15 | High half |

C reads and writes these as a single `u16` via inline helpers, so only one
place in the codebase knows the split; gcc merges the pair into one
`ldrh`/`strh`.

## Claiming a bit

Add one macro line to `flag_assignments.event`. Each bit may be owned by
exactly one skill ID.

```
ActivationFlagOncePerTurn(HurricaneID, 0)
ActivationFlagOncePerMap(MiracleID, 1)
```

| Macro | Scope byte | Cleared |
|-------|-----------|---------|
| `ActivationFlagOncePerTurn(id, bit)` | `0` | Top of every player phase |
| `ActivationFlagOncePerMap(id, bit)` | `1` | Only when the unit is loaded |

The macros fill two tables:

| Table | Indexed by | Holds |
|-------|-----------|-------|
| `SkillActivationFlagTable` | skill ID (`0–255`) | `bit + 1`, or `0` for "no bit" |
| `SkillActivationFlagScope` | bit (`0–15`) | `0` per turn, `1` per map |

The `+ 1` bias is what makes `0` mean "this skill owns no flag" — bit `0` is a
real, usable bit, so the table cannot use a bare `0` as its sentinel.

The comment block at the top of `flag_assignments.event` carries a bit-to-skill
table. Keep it current; it is the only human-readable census of which bits are
spoken for.

**A skill left at `SKILL_OFF` still burns its bit.** Delete the macro line when
you retire a skill, or the bit stays claimed by something that can never fire.

## Using the flag from a skill

```c
#include "../../../Internals/SkillActivationFlags/SkillActivationFlags.h"

if (!CanSkillActivationFlagProc(unit, MySkillID_Link))
	return;

SetSkillActivationFlag(unit, MySkillID_Link);
```

A skill that owns no bit is **never blocked** — `CanSkillActivationFlagProc`
returns true for it. That keeps the call harmless if you add it before claiming
a bit, but it also means forgetting step 1 produces a skill that silently procs
every time rather than an error. If a once-per-turn skill fires repeatedly,
check `flag_assignments.event` first.

### Available routines

| Routine | Returns |
|---------|---------|
| `GetSkillActivationBit(skillId)` | bit `0–15`, or `ACTIVATION_FLAG_NO_BIT` (`-1`) |
| `IsSkillActivationFlagSet(unit, skillId)` | `1` when it has already fired |
| `CanSkillActivationFlagProc(unit, skillId)` | `1` when it may still fire |
| `SetSkillActivationFlag(unit, skillId)` | `unit` |
| `ClearSkillActivationFlag(unit, skillId)` | `unit` |
| `ClearUnitActivationFlags(unit)` | `unit` — all sixteen bits |
| `ClearUnitTurnActivationFlags(unit)` | `unit` — per-turn bits only |
| `GetPerMapActivationFlagMask()` | mask of bits a turn reset keeps |
| `ResetTurnActivationFlags()` | proc routine, walks every unit |

`lyn` resolves these by symbol, so a C skill needs no `POIN` list — only the
skill ID link word.

## The forecast guard

**Any skill that writes an activation flag must check `gBattleStats.config`
first.**

The battle forecast predicts the fight by running the *same* battle proc loop as
real combat. A skill that sets its flag unconditionally therefore spends its
charge the moment the player opens the forecast menu — before a blow is struck,
and again for every target they hover over.

```c
if (!(stats->config & BATTLE_CONFIG_REAL))
	return;

if (stats->config & BATTLE_CONFIG_SIMULATE)
	return;
```

`config` is written wholesale before each generation:

| Caller | `config` | REAL (bit 0) | SIMULATE (bit 1) |
|--------|---------|--------------|------------------|
| `BattleGenerateSimulation` — forecast | `0x2` | 0 | 1 |
| `SimulateBattleBallista` | `0xA` | 0 | 1 |
| `BattleGenerateReal` @ `0x080283DC` | `0x1` | 1 | 0 |
| `BattleGenerateReal` @ `0x08028410` | `0x9` | 1 | 0 |

The decomp annotates bit `0x2` as *"battle hasn't started yet"*.

Both bits are checked rather than just one: `0xA` is REAL-clear but carries
other bits, so testing only for `SIMULATE` would be fragile against a config
this table does not enumerate.

This is not a Hurricane quirk. It applies to **every** proc-loop skill that
writes persistent state — counters, flags, unit fields. Anything that only
touches the round buffer is fine, because the forecast's buffer is discarded.

## Reset points

| When | Routine | Clears |
|------|---------|--------|
| Top of each player phase | `ResetTurnActivationFlags` | Once-per-turn bits only |
| Unit loaded for a chapter | `HookUnitLoading` | All sixteen bits |

### Once per turn

`ResetTurnActivationFlags` is spliced into `gProcScr_PlayerPhase` at
`0x8B93384`. The phase dispatcher at `0x80153E0` starts that script fresh
whenever `gPlaySt+0x0F` is `0`, so commands at the top of the script run exactly
once per player phase.

**The hook must stay above the script's first `PROC_LABEL`.** The script header:

```
$8B93374  PROC_19
$8B9337C  PROC_SET_MARK(2)
$8B93384  PROC_YIELD          <- displaced; replayed inside our proc
$8B9338C  PROC_LABEL(0)       <- per-action idle loop starts here
```

Everything from `LABEL(0)` onward is the per-unit idle loop — `$8B93484` and
`$8B934FC` both `PROC_GOTO(0)` after a unit finishes acting. A hook placed
there would re-run once per unit *action*, handing every once-per-turn skill a
fresh charge mid-turn. `test_skill_activation_flags_rom.py` pins this invariant.

The reset walks deployment ids up to `ACTIVATION_FLAG_LAST_DEPLOYMENT_ID`
(`0xBF`) via `gUnitLookup`, keeping the per-map bits by masking with
`GetPerMapActivationFlagMask()`.

Because the reset runs on the **player** phase only, a once-per-turn charge
covers the player phase *and the enemy phase that follows it*. A defensive skill
like Hurricane spends its charge on whichever incoming attack lands first across
that whole window.

### Once per map

`HookUnitLoading` zeroes both bytes with a single `strh r0, [r5, #0x3A]` when a
unit is loaded, so a chapter always starts clean. That covers both scopes — the
per-map distinction only matters to the turn reset.

## Placeholder icons

A skill with no art yet uses the shared WIP badge rather than borrowing another
skill's icon, so unfinished art is visually obvious in game instead of looking
like a deliberate duplicate.

```
ORG SkillIcon(MySkillID)
#incbin "SkillIcons/WIP.dmp"
```

`SkillIcons/WIP.png` is the editable source; `WIP.dmp` is the 128-byte GBA tile
data the build consumes. Both live alongside every other icon.

To produce a `.dmp` from new art:

```bash
python Tools/png2dmp.py path/to/Icon.png EngineHacks/SkillSystem/SkillIcons/Icon.dmp
```

The source PNG must be **16x16, indexed** (4bpp or 8bpp), using the shared skill
icon palette. `png2dmp.py` reproduces all 403 existing `.dmp` files byte-for-byte
from their PNGs, which is what pins the tile format.

## Code Locations

| What | Where |
|------|-------|
| Routines (C) | `EngineHacks/SkillSystem/Internals/SkillActivationFlags/SkillActivationFlags.c` |
| Declarations | `…/SkillActivationFlags.h` |
| Tables, macros, phase hook | `…/SkillActivationFlags.event` |
| Bit assignments | `…/flag_assignments.event` |
| Install point | `EngineHacks/SkillSystem/Internals/SkillSystem.event:369` |
| Once-per-map reset | `EngineHacks/SkillSystem/Internals/asm/HookUnitLoading.s` |
| Reference skill | `EngineHacks/SkillSystem/Skills/ProcSkills/Hurricane/Hurricane.c` |
| Icon table | `EngineHacks/SkillSystem/skill_icons.event` |
| PNG → DMP | `Tools/png2dmp.py` |

`unit+0x3A` is also listed in [ram-map.md](ram-map.md) under unit struct bytes.

## Testing

| File | Phase | Covers |
|------|-------|--------|
| `Tests/test_skill_activation_flags.py` | source | 26 tests — bit maths, both scopes, table/macro agreement |
| `Tests/test_skill_activation_flags_rom.py` | ROM | 8 tests — routines reachable from the installed proc |

Per `.claude/rules/skill-unicorn-verification.md`, flag code is not "working"
until its compiled Thumb has executed under Unicorn with **both** sides of every
branch asserted — flag set *and* flag clear. A test that only asserts the skill
fires passes vacuously against a routine that always fires.

The ROM-phase test follows the installed proc to reach the routines, so it
proves reachability as well as arithmetic. That is the form that catches a
routine which exists but was never wired in.

## TODO

- Add the activation flags to the EMS unit pack so they survive suspend/resume.
- Audit the other proc-loop skills for the missing forecast guard; the root
  cause is not specific to Hurricane.
- Replace `SkillIcons/WIP.dmp` on Hurricane once real art exists.
- If more than sixteen once-only skills are ever needed, the next free unit
  bytes have to be found before the table can widen.

## Limitations & Bugs

- Sixteen bits is a hard ceiling. There is no overflow path; the seventeenth
  skill to want a flag needs new storage.
- A skill that owns no bit is never blocked, so forgetting to claim one fails
  open — the skill procs every time rather than erroring.
- Activation flags are not part of the EMS unit pack, so suspending and
  resuming mid-chapter clears them. Once-per-map skills become usable again
  after a resume.
- The once-per-turn reset runs on the player phase only, so a charge spans the
  player phase and the following enemy phase. This is deliberate but is not
  what "once per turn" implies to every reader.
- `ShrewdPotential.s` still writes a magic stat to `unit+0x3A` (an unported FE8
  offset). It is not installed today, but it must be repointed to `0x47` before
  `StandaloneSkills.event` is re-enabled or it will corrupt activation flags.
- The Unicorn harness runs routines directly rather than through a live
  `MakeBattle`, so it cannot prove round buffers arrive in the assumed order.
  Behaviour that depends on round ordering still needs an in-game check.
