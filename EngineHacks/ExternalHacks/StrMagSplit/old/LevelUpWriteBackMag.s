.thumb
.org 0x0

@ FE7 UpdateUnitFromBattle jumpToHack at 0x29CA0 (Luk writeback).
@ r4 = Unit, r5 = BattleUnit

Luk:
mov		r0, r5
add		r0, #0x79
ldrb	r0, [r0]
ldrb	r1, [r4, #0x19]
add		r0, r1
strb	r0, [r4, #0x19]

Mag:
mov		r0, r5
add		r0, #0x7A
ldrb	r0, [r0]
mov		r3, #0x47
ldrb	r1, [r4, r3]
add		r0, r1
strb	r0, [r4, r3]

ldr		r0, ReturnAddr
bx		r0

.align
ReturnAddr:
.long 0x08029CAD
