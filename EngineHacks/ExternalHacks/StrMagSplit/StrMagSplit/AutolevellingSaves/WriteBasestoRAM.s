.thumb
.org 0x0

@ UnitLoadStatsFromCharacter — Mag to unit+0x47, then Def and Res.
@ r1 = char data, r2 = class data, r4 = unit
@ ColorzCore callHack_r3 at 0x17958 is 12 bytes and overwrites the vanilla
@ Res loads, so this routine must store Res itself and resume at Luck.

ldrb	r0, [r1, #0x4]		@ char num
ldr		r3, MagCharTable
lsl		r0, #0x1
add		r0, r3
mov		r3, #0x0
ldsb	r0, [r0, r3]		@ char base
ldrb	r5, [r2, #0x4]		@ class num
lsl		r5, #0x2
ldr		r3, MagCharTable+4	@ MagClassTable
add		r5, r3
mov		r3, #0x0
ldsb	r5, [r5, r3]		@ class base
add		r0, r0, r5
mov		r3, r4
add		r3, #0x47
strb	r0, [r3]
mov		r3, #0x0
ldrb	r0, [r2, #0xF]
ldrb	r5, [r1, #0x10]
add		r0, r0, r5
strb	r0, [r4, #0x17]
ldrb	r0, [r2, #0x10]
ldrb	r5, [r1, #0x11]
add		r0, r0, r5
strb	r0, [r4, #0x18]
ldr		r0, ReturnAddr
bx		r0

.align
.ltorg
ReturnAddr:
.long 0x08017969
MagCharTable:
