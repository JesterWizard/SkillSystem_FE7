.thumb

.macro _blr reg
	mov	lr, \reg
	.short	0xF800
.endm

.equ SkillTester, OffsetList + 0x0
.equ SkillId, OffsetList + 0x4

@ vanilla GetMagOn2Range at 0x184B4, then +1 if StaffSavant
.global MagOn2Hook
.type MagOn2Hook, %function
MagOn2Hook:
	push	{r4, r5, lr}
	mov	r4, r0
	ldr	r3, =0x08016765
	_blr	r3
	lsl	r0, r0, #16
	lsr	r0, r0, #16
	ldr	r3, =0x0801606D
	_blr	r3
	mov	r1, #20
	ldrsb	r1, [r4, r1]
	add	r1, r0
	lsr	r0, r1, #31
	add	r1, r0
	asr	r0, r1, #1
	cmp	r0, #4
	bgt	NotMin
	mov	r0, #5
NotMin:
	mov	r5, r0
	mov	r0, r4
	ldr	r1, SkillId
	ldr	r3, SkillTester
	_blr	r3
	cmp	r0, #0
	beq	NoSkill
	add	r5, #1
NoSkill:
	mov	r0, r5
	pop	{r4, r5}
	pop	{r1}
	bx	r1
.align
.ltorg
OffsetList:
