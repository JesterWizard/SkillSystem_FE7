.thumb
.org 0x0

@ FE7 trampoline from 0x28B52; return to 0x28B60.

mov 	r0, #0x4C
ldr		r0, [r5, r0]
mov		r1, #0x40
tst		r1, r0
bne		Magic

mov		r1, #0x2
tst		r1, r0
bne		Magic

mov		r1, #0x14
b		LoadStat

Magic:
mov		r1, #0x47

LoadStat:
ldsb	r1, [r5, r1]
mov		r0, #0x5A
ldrh	r0, [r5, r0]
add		r0, r1
mov		r1, #0x5A
strh	r0, [r5, r1]

ldr		r0, ReturnAddr
bx		r0

.align
.ltorg
ReturnAddr:
.long 0x08028B61
