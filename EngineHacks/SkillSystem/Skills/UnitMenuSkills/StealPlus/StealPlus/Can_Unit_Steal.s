.thumb
.align

@ FE7 StealCommandUsability (0x08022F78).
@ 1 = usable, 2 = grayed (inventory full), 3 = hidden.

.equ StealID, SkillTester+4
.equ StealPlusID, StealID+4
.equ CunningID, StealPlusID+4
.equ AlsoUseVanillaCheck, CunningID+4

.equ gActiveUnit, 0x03004690
.equ MakeTargetListForSteal, 0x08024505
.equ GetTargetListSize, 0x0804B175

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

push	{r4,r14}
ldr		r4, =gActiveUnit

ldr		r0, [r4]
ldr		r1, SkillTester
mov		lr, r1
ldr		r1, StealID
.short	0xF800
cmp		r0, #0
bne		CheckStatus

ldr		r0, [r4]
ldr		r1, SkillTester
mov		lr, r1
ldr		r1, StealPlusID
.short	0xF800
cmp		r0, #0
bne		CheckStatus

ldr		r0, [r4]
ldr		r1, SkillTester
mov		lr, r1
ldr		r1, CunningID
.short	0xF800
cmp		r0, #0
bne		CheckStatus

ldr		r0, AlsoUseVanillaCheck
cmp		r0, #0
beq		RetHidden

ldr		r2, [r4]
ldr		r0, [r2]
ldr		r1, [r2, #0x4]
ldr		r0, [r0, #0x28]
ldr		r1, [r1, #0x28]
orr		r0, r1
mov		r1, #0x4
and		r0, r1
cmp		r0, #0
beq		RetHidden

CheckStatus:
ldr		r2, [r4]
ldr		r0, [r2, #0xC]
mov		r1, #0x40
and		r0, r1
cmp		r0, #0
bne		RetHidden

mov		r0, r2
blh		MakeTargetListForSteal
blh		GetTargetListSize
cmp		r0, #0
beq		RetHidden

ldr		r3, [r4]
mov		r1, #0
add		r3, #0x1E
CountLoop:
ldrh	r0, [r3]
cmp		r0, #0
beq		CountDone
add		r1, #1
add		r3, #2
cmp		r1, #5
blt		CountLoop
CountDone:
cmp		r1, #5
beq		RetGray

mov		r0, #1
b		GoBack

RetGray:
mov		r0, #2
b		GoBack

RetHidden:
mov		r0, #3

GoBack:
pop		{r4}
pop		{r1}
bx		r1

.align
.ltorg
SkillTester:
