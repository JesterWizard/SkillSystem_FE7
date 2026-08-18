@ BAN_DelayDigitsDamage: always red "-"
@ BAN_DelayDigitsHeal:   always green "+"
@
@ Proc fields (set by DisplayDamage):
@   +0x29, byte. Number of digits.
@   +0x2A, short. Amount (abs taken here).
@   +0x2C, byte. AISSubjectId. 0 if left, 1 if right.
.thumb

.global BAN_DelayDigitsDamage
.global BAN_DelayDigitsHeal

BAN_DelayDigitsDamage:
push  {r4-r7, r14}
mov   r4, r8
mov   r5, r9
push  {r4-r5}
mov   r4, #0x2C
ldrb  r4, [r0, r4]
mov   r5, #0x2A
ldsh  r5, [r0, r5]
cmp   r5, #0x0
bge   AbsDmg
  neg   r5, r5
AbsDmg:
mov   r7, #0x29
ldrb  r7, [r0, r7]
lsl   r7, #0x1

@ Red palette, "-" at sheet slot 0x0D.
@ NOTE: BAN_DigitsPalette+0x00 has GREEN fill colors for glyph
@ indices; +0x20 has RED fills. Color0 is just the key name.
ldr   r0, =BAN_DigitsPalette
add   r0, #0x20             @ Red fills
mov   r6, #0x1              @ 0x0C + 1 = 0x0D "-"
b     LoadPal


BAN_DelayDigitsHeal:
push  {r4-r7, r14}
mov   r4, r8
mov   r5, r9
push  {r4-r5}
mov   r4, #0x2C
ldrb  r4, [r0, r4]
mov   r5, #0x2A
ldsh  r5, [r0, r5]
cmp   r5, #0x0
bge   AbsHeal
  neg   r5, r5
AbsHeal:
mov   r7, #0x29
ldrb  r7, [r0, r7]
lsl   r7, #0x1

@ Green palette, "+" at sheet slot 0x0C.
ldr   r0, =BAN_DigitsPalette @ Green fills (base)
mov   r6, #0x0              @ 0x0C "+"


LoadPal:
@ OBJ pal 1 only (gPaletteBuffer+0x220). Avoid UI 5/7/9 and
@ weapon-icon pals 13/14. Subject still shifts VRAM below.
ldr   r1, =gPaletteBuffer+0x220
mov   r2, #0x8
swi   #0xC
ldr   r3, =EnablePaletteSync
bl    GOTO_R3

@ FE7 +/- glyphs live in the bottom half of each 16x16 slot.
ldr   r0, =0x081E5FD0
mov   r8, r0
mov   r0, #0x0C
add   r0, r6
lsl   r0, #0x6
mov   r1, #0x40
lsl   r1, #0x4              @ +0x400
add   r0, r1
add   r0, r8
ldr   r1, =0x6012400
lsl   r2, r4, #0x9
add   r1, r2
mov   r2, #0x8              @ one 8x8 tile
swi   #0xC

ldr   r0, =0x6012040
lsl   r4, #0x9
add   r4, r0
Loop:
  ldr   r0, =Denom
  ldrh  r1, [r0, r7]
  cmp   r1, #0x0
  beq   Return
    mov   r6, r1

    mov   r0, r5
    swi   #0x6
    mov   r1, r0
    mul   r1, r6
    sub   r5, r1

    cmp   r0, #0x0
    bne   L1
      mov   r0, #0xF
    L1:
    sub   r0, #0x1
    lsl   r0, #0x6
    add   r0, r8
    mov   r9, r0
    mov   r1, r4
    mov   r2, #0x10
    swi   #0xC
    mov   r0, r9
    mov   r1, r4
    mov   r2, #0x40
    lsl   r2, #0x4
    add   r0, r2
    add   r1, r2
    mov   r2, #0x10
    swi   #0xC

    add   r4, #0x40
    sub   r7, #0x2
    b     Loop


Return:
pop   {r4-r5}
mov   r8, r4
mov   r9, r5
pop   {r4-r7}
pop   {r0}
bx    r0
GOTO_R3:
bx    r3

Denom:
.short 0
.short 1
.short 10
.short 100
.short 1000
.short 10000
