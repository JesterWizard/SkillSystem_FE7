.thumb
.align

.equ SummonID,SkillTester+4

.equ gActiveUnit,0x03004690
.equ GetTargetListSize,0x0804B175

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

@ Menu usability for the Summon skill.  Shaped after DropUsability
@ (0x0802181C): reject a unit that has already acted, build the tile list, and
@ show the command only when at least one tile survives.
@
@ Return codes are the unit-menu ones: 1 enabled, 2 greyed out, 3 hidden.
push {r4,lr}
ldr r4,=gActiveUnit
ldr r4,[r4]

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, SummonID
.short 0xf800
cmp r0,#0
beq ReturnFalse

@ US_UNSELECTABLE: the unit has already acted, or is cantoing
ldr r0,[r4,#0xC]
mov r1,#0x40
and r0,r1
cmp r0,#0
bne ReturnFalse

mov r0,r4
blh SummonMakeTargetList,r3
blh GetTargetListSize,r3
cmp r0,#0
beq ReturnFalse

mov r0,#1
b GoBack

ReturnFalse:
mov r0,#3

GoBack:
pop {r4}
pop {r1}
bx r1

.ltorg
.align

SkillTester:
@POIN SkillTester
@WORD SummonID
