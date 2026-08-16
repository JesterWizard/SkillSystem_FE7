@ =============================================================================
@ EWRAM SkillSys window
@ =============================================================================
@ Range: 0x0203F000–0x02040000 (end of 256K EWRAM)
@
@ Vanilla FE7 BSS does not use this tail. SkillSys already parked several
@ buffers here; they are recorded as SET_ARRAY so the bump pool starts after
@ the last occupant instead of overlapping it.
@
@ Known overlaps (do not malloc into these):
@ - GaidenMagic SelectedSpell/UsingSpellMenu/DidSelectSpell at 0x0203F080
@   sit inside gAnimRoundData if both are enabled.
@ - AoE / combat-art byte 0x0203F101 is DebuffTableRam+1.

.set BattleBufferMaxAtks, 31
.set BattleBufferWidth,   4
.set BattleHitArraySize,  (BattleBufferMaxAtks * BattleBufferWidth)
.set AnimRoundDataSize,   (BattleBufferMaxAtks * 2)

.set DebuffTableSize, 0x440

@ 4-byte magic + (0x46 PIDs * 6 slots) + 0x46 override flags
.set LearnedSkillRamSize, (4 + (0x46 * 6) + 0x46)

SET_DATA FreeEwramSpaceTop,    0x0203F730
SET_DATA FreeEwramSpaceBottom, 0x02040000
SET_DATA UsedFreeEwramSpaceTop, FreeEwramSpaceBottom

.macro _kernel_malloc_ewram name, size
 .set UsedFreeEwramSpaceTop, UsedFreeEwramSpaceTop - \size
 SET_DATA \name, UsedFreeEwramSpaceTop
.endm

@ -- Fixed occupants (low address → high). Do not reorder without repoints. --

SET_ARRAY gBattleHitArray, 0x0203F000, BattleHitArraySize
SET_ARRAY gAnimRoundData,  0x0203F07C, AnimRoundDataSize
SET_ARRAY DebuffTableRam,  0x0203F100, DebuffTableSize
SET_ARRAY gLearnedSkillRam, 0x0203F540, LearnedSkillRamSize

@ -- Bump pool: 0x0203F730–0x02040000, allocated downward -----------------
@ Add new EWRAM with:
@   _kernel_malloc_ewram gMyBuffer, 0x20
@ Pad manually if the next symbol needs 2- or 4-byte alignment.
