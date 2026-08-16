# RAM Map

## Index

- [Introduction](#introduction)
- [Plan](#plan)
- [Code Locations](#code-locations)
- [Existing occupants](#existing-occupants)
- [TODO](#todo)
- [Limitations & Bugs](#limitations--bugs)

## Introduction

`asm/ram_map.s` is the central address registry for this build. It `.include`s three region sources that assemble into a single object:

| File | Region |
|------|--------|
| `asm/ram_map_iwram.s` | IWRAM (`0x03007A00`–`0x03007E00`) |
| `asm/ram_map_ewram.s` | EWRAM SkillSys window (`0x0203F000`–`0x02040000`) |
| `asm/ram_map_sram.s` | SRAM (`0x0E000000`–`0x0E008000`) |

The fragments are not compiled as separate objects; they are included so bump-allocator cursors stay consistent across regions.

It exists so custom code can refer to IWRAM, EWRAM, and SRAM locations by symbol instead of hard-coding addresses. That keeps the layout readable, keeps names stable, and makes it easier to move allocations later without touching every call site.

The file does not contain runtime logic. It defines linker-visible symbols and helper macros that describe where each region begins, where free space starts, and how SkillSys buffers are laid out.

| Region | Purpose | Notes |
|--------|---------|-------|
| IWRAM | Tiny hot-path state | 1KB below the user stack, above the FE7 m4a mixer |
| EWRAM | Larger runtime arrays | Tail of 256K EWRAM; SkillSys already uses the low end of this window |
| SRAM | Persistent save data | Entire `0x8000` is claimed by ExpandedModularSave |

## Plan

Use `ram_map.s` as a single source of truth for memory placement.

### Region model

| Region | How it is allocated | Typical use |
|--------|---------------------|-------------|
| IWRAM | Direct `SET_DATA` or `_kernel_malloc` downward from `UsedFreeRamSpaceTop` | Flags, small scratch |
| EWRAM | Direct `SET_DATA`/`SET_ARRAY` or `_kernel_malloc_ewram` downward from `UsedFreeEwramSpaceTop` | Battle extras, skill tables, larger scratch |
| SRAM | Direct `SET_DATA` for EMS block starts; `_kernel_malloc_sram` only after shrinking EMS | Save chunks |

### Macro usage

`SET_DATA`

- Use for a single absolute symbol.
- Use when the address is fixed and no `End` symbol is needed.

`SET_ARRAY`

- Use for a contiguous block.
- Emits both `name` and `nameEnd`.
- Use when the code treats the symbol as a byte range rather than a single pointer.

`_kernel_malloc`, `_kernel_malloc_ewram`, `_kernel_malloc_sram`

- Use for free-space allocations that should grow downward from the region’s free-space ceiling.
- Best for scratch buffers or internal runtime allocations that do not need a hard-coded absolute start.
- Pad manually if the next symbol needs 2- or 4-byte alignment.

### Practical rules

1. Put shared macros in `asm/ram_map.s` (before the `.include` lines). Region malloc macros stay in their region file so each cursor is local.
2. Add symbols to the matching region file (`ram_map_iwram.s`, `ram_map_ewram.s`, or `ram_map_sram.s`).
3. Use `SET_DATA` for fixed addresses and `SET_ARRAY` for spans.
4. Prefer cursor-based placement only when a region contains a sequence of adjacent arrays.
5. From GNU as, `.include "ram_map.s"` (assemble with `-I asm`, or include a region file if you only need that cursor).
6. Event Assembler does not parse these `.s` files. Keep EA `#define`s in sync when a symbol is also referenced from `.event` installers (`DebuffTableRam`, `gLearnedSkillRam`, battle-buffer repoints).
7. Do not assume SRAM past `0x0E008000` is available.
8. Do not malloc IWRAM below `0x03007A00` without checking the sound mixer at `0x03006D60`.

### Example

```asm
SET_DATA FreeEwramSpaceTop,    0x0203F730
SET_DATA FreeEwramSpaceBottom, 0x02040000
SET_DATA UsedFreeEwramSpaceTop, FreeEwramSpaceBottom

SET_ARRAY gBattleHitArray,  0x0203F000, BattleHitArraySize
SET_ARRAY gAnimRoundData,   0x0203F07C, AnimRoundDataSize
SET_ARRAY DebuffTableRam,   0x0203F100, DebuffTableSize
SET_ARRAY gLearnedSkillRam, 0x0203F540, LearnedSkillRamSize

_kernel_malloc_ewram gMyScratch, 0x20
```

This layout means:

- existing SkillSys buffers stay at known EWRAM offsets
- new arrays grow downward from `0x02040000`
- the free-space boundary still reflects the unused tail of EWRAM

## Code Locations

| Feature | Location | Description |
|---------|----------|-------------|
| Core memory map | `asm/ram_map.s` + `asm/ram_map_{iwram,ewram,sram}.s` | Defines the IWRAM, EWRAM, and SRAM symbols |
| IWRAM free-space allocation | `ram_map_iwram.s` | Reserves fast runtime memory from the top of free IWRAM downward |
| EWRAM free-space allocation | `ram_map_ewram.s` | SkillSys window plus downward bump pool |
| SRAM / EMS labels | `ram_map_sram.s` | Save-block starts; bump pool empty by default |
| EMS sizes / offsets | `EngineHacks/Necessary/ExpandedModularSave/ExModularSave.event` | Authoritative save layout |
| Battle-hit repoint | `EngineHacks/SkillSystem/Internals/repointbuffer_fe7.event` | Patches vanilla `gBattleHitArray` literals |

## Existing occupants

EWRAM window (`0x0203F000`–`0x02040000`):

| Symbol | Address | Size | End |
|--------|---------|------|-----|
| `gBattleHitArray` | `0x0203F000` | `31 * 4` | `0x0203F07C` |
| `gAnimRoundData` | `0x0203F07C` | `31 * 2` | `0x0203F0BA` |
| `DebuffTableRam` | `0x0203F100` | `0x440` | `0x0203F540` |
| `gLearnedSkillRam` | `0x0203F540` | `0x1EE` | `0x0203F72E` |
| **EWRAM bump pool** | `0x0203F730` | `0x8D0` | `0x02040000` |

IWRAM bump pool: `0x03007A00`–`0x03007E00` (`0x400` bytes).

SRAM bump pool: none until EMS is resized.

## TODO

- Move GaidenMagic spell-menu bytes off `0x0203F080` so they no longer overlap `gAnimRoundData`.
- Give AoE / combat arts a dedicated `_kernel_malloc_ewram` byte instead of `DebuffTableRam+1`.
- If more save data is needed, add an EMS chunk and only then open a SRAM bump pool.

## Limitations & Bugs

- `ram_map.s` is only a declaration file; it does not enforce bounds at runtime.
- If a symbol is assigned the wrong address, the assembler and linker will usually not catch the logic error.
- The SRAM region only reserves the lower `0x8000` bytes because that is the portion the current save code actually uses.
- Cursor-based placement is only safe when the sequence length is updated consistently with the backing storage and all consumers.
- EA `#define`s for the same addresses can drift if they are edited without updating `asm/ram_map_ewram.s`.

Modeled on [ygodm8 ram-map.md](https://github.com/JesterWizard/ygodm8/blob/master/documentation/ram-map.md).
