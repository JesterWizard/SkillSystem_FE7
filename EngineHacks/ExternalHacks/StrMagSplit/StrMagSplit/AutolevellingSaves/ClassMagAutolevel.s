.thumb
.org 0x0

@ FE7 UnitAutolevelCore Mag after Str; trampoline from 0x17AF2, return to 0x17AFC (Skl BL).

push	{r14}
ldr		r0, GetGrowthChance
mov		r14, r0
ldr		r0, [r4, #0x4]
ldrb	r0, [r0, #0x4]
lsl		r0, #0x2
ldr		r1, MagClassGrowth
add		r0, r1
ldrb	r0, [r0, #0x1]
mov		r1, r5
.short	0xF800
mov		r1, r4
add		r1, #0x47
ldrb	r2, [r1]
add		r2, r0, r2
strb	r2, [r1]
ldr		r0, [r4, #0x4]
add		r0, #0x20
ldrb	r0, [r0]
lsl		r0, #0x18
asr		r0, #0x18
mov		r1, r5
ldr		r2, ReturnAddr
bx		r2

.align
.ltorg
GetGrowthChance:
.long 0x08029605
ReturnAddr:
.long 0x08017AFD
MagClassGrowth:
