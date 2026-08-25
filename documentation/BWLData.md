# BWL Data Map

---

## Index

- [Introduction](#introduction)
- [Plan](#plan)
- [Byte map](#byte-map)
- [Rally flags](#rally-flags)
- [Code Locations](#code-locations)
- [TODO](#todo)
- [Limitations & Bugs](#limitations--bugs)

## Introduction

Each playable character (pid `1`–`0x45`) has a 16-byte Battle/Win/Loss entry in
vanilla RAM, reached through `BWL_GetEntry`. The table is saved with the
chapter, so anything stored here survives suspend and new maps unless we clear
it.

Learned skills used to live in BWL. They now live in `unit->supports[]`, and
support exp lives in `gBwlSupportExp`. That left the 16-byte entry as vanilla
stats plus a few build-specific overlays.

Player-facing effect: Rally no longer writes the unused Debuff table. Each
applied rally is one bit on the **target** unit's BWL pad byte. Stat getters
add the bonus while the bit is set. Bits clear at the start of the next player
phase.

## Plan

One BWL entry is 16 bytes (`pid * 0x10` from the table base). Layout follows
the `UnitUsageStats` bitfield in
`EngineHacks/Necessary/GrowthGetters/C/include/bmsave.h`. This build only
changes two bytes: `+0x08` (already promotion level) and `+0x0F` (rally flags).
Rally Mag uses `+0x0E` bit 7 (`deathSkirm` overlay).

### Access

| Item | Value |
|------|-------|
| Entry size | `0x10` |
| Valid pid | `1`–`0x45` (`BWL_ARRAY_NUM` is `0x46`) |
| Getter | `BWL_GetEntry` at `0x080A0550` (char id in `r0`; `0` if none) |
| Support exp (not in this table) | `gBwlSupportExp` at `0x0203FE10`, 7 bytes per pid |

## Byte map

Bit offsets are from the start of the 16-byte entry. "This build" notes
overlays on top of vanilla FE7.

| Offset | Bits | Vanilla | This build |
|--------|------|---------|------------|
| `+0x00` | 0–7 | `lossAmt` (losses) | Unchanged |
| `+0x01`–`+0x02` | 8–23 | `favval` (favoritism) | Unchanged |
| `+0x03` | 24–31 | `actAmt` (battles acted) | Unchanged |
| `+0x04` | 32–39 | `statViewAmt` | Unchanged |
| `+0x05` | 40–45 | `deathLoc` | Unchanged |
| `+0x05`–`+0x06` | 46–55 | `deathTurn` | Unchanged |
| `+0x07` | 56–61 | `deployAmt` | Unchanged |
| `+0x07`–`+0x08` | 62–71 | `moveAmt` (tiles moved) | **Byte `+0x08` is promotion level** (`CheckBattleUnitLevelUp.c`). Tiles-moved high bits are gone. |
| `+0x09` | 72–75 | `deathCause` | Unchanged |
| `+0x09`–`+0x0A` | 76–87 | `expGained` | Unchanged |
| `+0x0B` | 88–97 | `winAmt` | Unchanged |
| `+0x0C`–`+0x0D` | 98–109 | `battleAmt` | Unchanged |
| `+0x0D`–`+0x0E` | 110–118 | `killerPid` | Unchanged |
| `+0x0E` | 119 | `deathSkirm` | **Bit 7: Rally Mag applied** (FE7 has no skirmish death flag to keep) |
| **`+0x0F`** | **120–127** | **8-bit pad (unused)** | **Applied rally flags (Str–Spectrum)** |

Not in the 16-byte entry:

| Location | Size | This build |
|----------|------|------------|
| `unit+0x32`–`+0x38` | 7 bytes | Learned skills (`supports[]`) |
| `gBwlSupportExp[pid][7]` | 7 bytes | Support exp (DEC-59) |

## Rally flags

Byte `+0x0F`. Bit order matches `RallySkillList` in `RallySkills.event`.

| Bit | Mask | Skill | Bonus |
|-----|------|-------|-------|
| 0 | `0x01` | Rally Str | +4 Str |
| 1 | `0x02` | Rally Skl | +4 Skl |
| 2 | `0x04` | Rally Spd | +4 Spd |
| 3 | `0x08` | Rally Def | +4 Def |
| 4 | `0x10` | Rally Res | +4 Res |
| 5 | `0x20` | Rally Luk | +8 Luk |
| 6 | `0x40` | Rally Mov | +2 Mov |
| 7 | `0x80` | Rally Spectrum | +2 to Str/Skl/Spd/Def/Res/Luk (not Mov) |

Rally Mag does not fit in that byte. It uses **`+0x0E` bit 7** (`0x80`). `prRallyMag` adds +4 Mag while that bit is set, plus the Spectrum Mag bonus when bit 7 of `+0x0F` is set.

`RallyCommandEffect_apply` ORs bits 0–7 onto `+0x0F` and bit 8 onto `+0x0E` bit 7.
`ClearBwlRallies` writes `0` to every pid's `+0x0F` at player-phase start.
`prRally*` in `RallyStat.s` reads the flags through `GetUnitBwlRallyFlags`.

## Code Locations

| Feature | Location | Description |
|---------|----------|-------------|
| Apply / clear / read flags | `GetBwlEntryForUnit`, `RallyCommandEffect_apply`, `ClearBwlRallies`, `GetUnitBwlRallyFlags` in `EngineHacks/SkillSystem/Skills/RallySkills/asm/Rally.s` | Writes and clears BWL `+0x0F` |
| Named Skills-menu commands | `RallyStrCommandUsability` (and siblings) in the same file; `SkillsMenu.event` | One command per rally skill the unit owns, including Rally Mag |
| Stat bonuses | `prRallyStr` (and siblings) in `EngineHacks/Necessary/StatGetters/_asm/RallyStat.s` | Adds rally amounts while the matching bit is set |
| Phase clear | `TurnCalcLoop_Silent` in `EngineHacks/Necessary/CalcLoops/TurnLoop/Installer.event` | Calls `ClearBwlRallies` |
| Promotion overlay | `GetUnitPromotionLevel` in `EngineHacks/Necessary/GrowthGetters/C/CheckBattleUnitLevelUp.c` | Byte `+0x08` |
| Support exp table | `GetBwlSupportRow` in `EngineHacks/SkillSystem/Internals/asm/BwlSupports.s` | Not BWL; `gBwlSupportExp` |
| Struct definition | `struct UnitUsageStats` in `EngineHacks/Necessary/GrowthGetters/C/include/bmsave.h` | Bitfield for the 16-byte entry |

## TODO

- If Rally Mag is enabled (`USE_STRMAG_SPLIT`), it needs a ninth bit; `+0x0F` is full.
- Confirm whether FE7 vanilla ever wrote `+0x0F` on a retail save before treating the pad as empty.

## Limitations & Bugs

- Only characters with a BWL row (player pid `1`–`0x45`) can receive rally
  bonuses. Green/red units in range are skipped.
- Bits persist in suspend/save until the next player phase, which is intended
  for mid-turn rally but means a savestate taken after Rally still has the
  bonuses.
- Byte `+0x08` is not free: promotion-level code already owns it.
- File an issue if a vanilla BWL field (wins, deaths, favor) looks wrong after
  this overlay; the pad byte should not overlap those fields.
