---
description: FE7 table expansions must live in FreeSpace; never ORG past vanilla table ends
alwaysApply: true
---

# FE7 FreeSpace Table Expansions

Never `ORG` write past the end of a vanilla FE7 table in-place. Adjacent bytes are other live tables (movement costs, terrain bonuses, spell assoc). In-place expansion silently bricks the game.

Canonical incident: SkillScroll item `0x9F` at `ItemTable + 0x24*0x9F` == `0xBE3888` (Lyn Lord mov-cost table) → plains impassable → Mov 0.

## Vanilla anchors (file offsets)

| Table | Base | Entry | Safe last index (approx) | Next hazard |
|-------|------|-------|--------------------------|-------------|
| ItemTable | `0xBE222C` | `0x24` | `0x9A` | Mov-cost tables at `0xBE3888` (`0x9F*0x24` lands exactly there) |
| ClassTable | `0xBE015C` | `0x54` | keep vanilla count unless relocated | follows item/terrain data |
| CharacterTable | `0xBDCE18` | `0x34` | keep vanilla count unless relocated | ClassTable |

`CustomDefinitions.event` defines `FreeSpace` / `FreeSpaceEnd`. New bulk data goes there.

## Required pattern

1. Copy vanilla entries into FreeSpace (`#incbin` dump or installer label).
2. Append new IDs only on that FreeSpace copy.
3. `#undef` / `#define` the table symbol to the FreeSpace label for hack code.
4. Repoint vanilla getters/literals that embed the old base (e.g. `GetItemData` at `0x174BC`).
5. Do **not** `ORG vanillaBase + size*newId` for the new row.

Reference: `EngineHacks/SkillSystem/SkillScrolls/SkillScrolls.event` (`ExpandedItemTable`), `Tests/test_skill_scroll_id.py`, `Tests/scripts/check_table_overlaps.py`.

## Before merging any table expansion

- Run overlap math (`Tests/scripts/check_table_overlaps.py`); `base + entrySize * id` must not hit another table.
- Installer writes under FreeSpace cursor, not past the vanilla end.
- Update getters / jump tables / `cmp` max indices for the new ID.
- Prefer **`POIN Label`** over `WORD Label` for FreeSpace list pointers (`WORD` stores `0x01xxxxxx`).
- Diff critical adjacent regions against `FE7_clean.gba` (e.g. Lord mov costs at `0xBE3888`).

## Debugging hint

Mov 0, weird terrain, crash on unit/enemy appear, or bad high item IDs → suspect in-place table expansion first; diff the range vs clean ROM before chasing skills/events.
