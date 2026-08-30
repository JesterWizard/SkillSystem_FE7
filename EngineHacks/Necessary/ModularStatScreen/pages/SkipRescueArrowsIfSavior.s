.thumb

@ Hooked at 0x08080F84 (page 0, before the two OBJ down-arrows).
@ r4 = gStatScreen. Vanilla draws Skl/Spd arrows whenever US_RESCUING is set.
@ Savior keeps the Trv rescuee icon (0x08080FA4) but skips those arrows.

.equ SaviorID, SkillTester+4

.global SkipRescueArrowsIfSavior
.type SkipRescueArrowsIfSavior, %function
SkipRescueArrowsIfSavior:
  push    {r6, lr}
  ldr     r6, [r4, #0xC]
  cmp     r6, #0
  beq     SkipRescueNoUnit
  ldr     r0, [r6, #0xC]
  mov     r1, #0x10
  and     r0, r1
  cmp     r0, #0
  beq     SkipRescueNoUnit
  mov     r0, r6
  ldr     r1, SaviorID
  ldr     r3, SkillTester
  bl      SkipRescueCallST
  cmp     r0, #0
  bne     SkipRescueSavior
  ldr     r0, SkipRescueDrawArrows
  b       SkipRescueArrowsDone
SkipRescueSavior:
  ldr     r0, SkipRescueSkipArrows
  b       SkipRescueArrowsDone
SkipRescueNoUnit:
  ldr     r0, SkipRescueNoRescue
.global SkipRescueArrowsDone
SkipRescueArrowsDone:
  pop     {r6}
  pop     {r1}
  bx      r0

.thumb_func
SkipRescueCallST:
  mov     r2, #1
  orr     r3, r2
  bx      r3

.align 2
SkipRescueDrawArrows:
  .word 0x08080F91
SkipRescueSkipArrows:
  .word 0x08080FA5
SkipRescueNoRescue:
  .word 0x08080FD1

.ltorg
SkillTester:
@POIN SkillTester
@WORD SaviorID
