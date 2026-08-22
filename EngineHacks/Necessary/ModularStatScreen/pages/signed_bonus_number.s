.thumb
@ Global DrawSignedBonusNumber, hooked over vanilla 0x08006240.
@ Vanilla always prints a green '+' then feeds the raw value to
@ DrawUiSmallNumber: a -3 Fortress Defense penalty comes out as '+7'
@ (signed remainder of -3 / 10). DrawBar (0x0807FD28) is the caller that
@ surfaces that on every core stat.

.equ DrawSpecialUiChar, 0x0800615C
.equ DrawUiSmallNumber, 0x08006234
.equ Green, 4
.equ RedPalBank, 9
.equ RedColour, 4
.equ Glyph_Plus, 21
.equ Glyph_Minus, 20
.equ gActiveFontPtr, 0x02028D70

.macro blh to, reg=r3
  push   {\reg}
  ldr    \reg, =\to
  mov    lr, \reg
  pop    {\reg}
  .short 0xf800
.endm

.global DrawSignedBonusNumber
.type DrawSignedBonusNumber, %function

@ Names prefixed so lyn does not export SetFontRedPalette / RestoreFontPalette
@ (mss_defs.s already emits those once per page).
SBN_SetFontRedPalette:
  ldr     r1, =gActiveFontPtr
  ldr     r1, [r1]
  ldrh    r0, [r1, #0x10]
  mov     r2, #RedPalBank
  lsl     r2, r2, #0xC
  add     r2, r2, r0
  strh    r2, [r1, #0x10]
  bx      lr

SBN_RestoreFontPalette:
  ldr     r1, =gActiveFontPtr
  ldr     r1, [r1]
  strh    r0, [r1, #0x10]
  bx      lr

@ DrawSpecialUiChar writes an 8x16 glyph (dest and dest+0x40). Glyph 20's bar
@ sits in the top 8px; the small digits sit lower. Shift the two VRAM tiles
@ down 4 pixels. Skip if the top 4 rows are already empty so a second minus
@ on the same cached glyph is not shifted twice.
SBN_ShiftMinusDown4:
  push    {r5, r6, r7, lr}
  ldrh    r0, [r4]
  lsl     r1, r0, #22
  lsr     r1, r1, #22
  beq     SBN_ShiftDone
  lsl     r1, r1, #5
  ldr     r2, =0x06000000
  add     r5, r1, r2
  ldr     r0, [r5]
  ldr     r1, [r5, #4]
  ldr     r2, [r5, #8]
  ldr     r3, [r5, #12]
  orr     r0, r1
  orr     r0, r2
  orr     r0, r3
  cmp     r0, #0
  beq     SBN_ShiftDone
  mov     r7, r5
  add     r7, #60
  mov     r0, #12
SBN_ShiftLoop:
  mov     r1, r7
  sub     r1, #16
  ldr     r2, [r1]
  str     r2, [r7]
  sub     r7, #4
  sub     r0, #1
  bne     SBN_ShiftLoop
  mov     r0, #0
  str     r0, [r5]
  str     r0, [r5, #4]
  str     r0, [r5, #8]
  str     r0, [r5, #12]
SBN_ShiftDone:
  pop     {r5, r6, r7}
  pop     {r0}
  bx      r0

DrawSignedBonusNumber:
  push    {r4, r5, r6, lr}
  mov     r4, r1
  mov     r5, r0
  cmp     r5, #0
  beq     SBN_End
  bgt     SBN_Positive

  neg     r5, r5
  bl      SBN_SetFontRedPalette
  mov     r6, r0
  mov     r0, r4
  mov     r1, #RedColour
  mov     r2, #Glyph_Minus
  blh     DrawSpecialUiChar
  bl      SBN_ShiftMinusDown4
  mov     r0, r4
  add     r0, #0x2
  cmp     r5, #0x9
  ble     SBN_NegDigits
  mov     r0, r4
  add     r0, #0x4
SBN_NegDigits:
  mov     r1, #RedColour
  mov     r2, r5
  blh     DrawUiSmallNumber
  mov     r0, r6
  bl      SBN_RestoreFontPalette
  b       SBN_End

SBN_Positive:
  mov     r0, r4
  mov     r1, #Green
  mov     r2, #Glyph_Plus
  blh     DrawSpecialUiChar
  mov     r0, r4
  add     r0, #0x2
  cmp     r5, #0x9
  ble     SBN_PosDigits
  mov     r0, r4
  add     r0, #0x4
SBN_PosDigits:
  mov     r1, #Green
  mov     r2, r5
  blh     DrawUiSmallNumber

SBN_End:
  pop     {r4, r5, r6}
  pop     {r0}
  bx      r0

.align 2
.ltorg
