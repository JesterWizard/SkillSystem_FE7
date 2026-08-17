@ =============================================================================
@ SRAM / Flash save window
@ =============================================================================
@ Range: 0x0E000000–0x0E008000 (32K). FE7 and EMS both treat this as the
@ usable save window; the rest of the GBA SRAM mirror is not used.
@
@ ExpandedModularSave (DEC-68) occupies the whole 0x8000:
@   meta      0x0000
@   suspend   0x00D4  size 0x2E78
@   game 1    0x2F4C  size 0x1400
@   game 2    0x434C  size 0x1400
@   game 3    0x574C  size 0x1400
@   link      0x6B4C  size 0x08B4
@   other     0x7400  size 0x0C00
@
@ Authoritative chunk layout: EngineHacks/Necessary/ExpandedModularSave/
@ ExModularSave.event (200-item convoy chunk $190, BWL supports, debuffs).
@
@ There is no spare SRAM for a bump pool unless you shrink an EMS block.
@ FreeSramSpaceTop == FreeSramSpaceBottom until that happens.

SET_DATA FreeSramSpaceTop,    0x0E008000
SET_DATA FreeSramSpaceBottom, 0x0E008000
SET_DATA UsedFreeSramSpaceTop, FreeSramSpaceBottom

.macro _kernel_malloc_sram name, size
 .set UsedFreeSramSpaceTop, UsedFreeSramSpaceTop - \size
 SET_DATA \name, UsedFreeSramSpaceTop
.endm

SET_DATA gSramBase, 0x0E000000

SET_DATA gSaveBlockMeta,      0x0E000000
SET_DATA gSaveBlockSuspend,   0x0E0000D4
SET_DATA gSaveBlockGame1,     0x0E002F4C
SET_DATA gSaveBlockGame2,     0x0E00434C
SET_DATA gSaveBlockGame3,     0x0E00574C
SET_DATA gSaveBlockLinkArena, 0x0E006B4C
SET_DATA gSaveBlockOther,     0x0E007400
