@ =============================================================================
@ IWRAM free space
@ =============================================================================
@ Range: 0x03007A00–0x03007E00
@
@ Why these bounds:
@ - FE7 resets the user stack to 0x03007F00 (grows down). Leave 0x100 bytes
@   of headroom, so the bump ceiling is 0x03007E00.
@ - Vanilla m4a / ImprovedSoundMixer FE7 work buffer is BUFFER_IRAM_AE7 at
@   0x03006D60. Stay above 0x03007A00 so mixer + sound scratch are untouched.
@
@ Use for tiny, hot-path state only. Prefer EWRAM when the block is large.

SET_DATA FreeRamSpaceTop,    0x03007A00
SET_DATA FreeRamSpaceBottom, 0x03007E00
SET_DATA UsedFreeRamSpaceTop, FreeRamSpaceBottom

.macro _kernel_malloc name, size
 .set UsedFreeRamSpaceTop, UsedFreeRamSpaceTop - \size
 SET_DATA \name, UsedFreeRamSpaceTop
.endm

@ Example (commented): 4-byte scratch flag
@ _kernel_malloc gExampleIwramFlag, 4
