.thumb

@ r0 = getter total, r1 = unit, r2 = UNIT_SKILL/SPEED offset.
@ DrawBar prints r3 as the number. While rescuing, use the getter so a
@ non-Savior half shows and a Savior total stays unhalved (HalveIfRescuing).

.global AdjustBarBaseForSavior
.type AdjustBarBaseForSavior, %function
AdjustBarBaseForSavior:
  push    {r4, r5, lr}
  mov     r4, r0
  mov     r5, r1
  ldrsb   r3, [r5, r2]
  ldr     r0, [r5, #0xC]
  mov     r1, #0x10
  and     r0, r1
  cmp     r0, #0
  beq     AdjustBarBaseRet
  mov     r3, r4
AdjustBarBaseRet:
  mov     r0, r4
AdjustBarBaseDone:
  pop     {r4, r5}
  pop     {r1}
  bx      r1
