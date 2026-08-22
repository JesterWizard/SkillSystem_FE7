.thumb

@ r0 = unit, r1 = item short
@ returns r0 = packed range (max in low halfword, min in high halfword)
.global ItemRangeGetter
.type ItemRangeGetter, %function

.equ ItemTable, OffsetList + 0x0
.equ MagOn2, OffsetList + 0x4
.equ RangeModSkills, OffsetList + 0x8

ItemRangeGetter:
	push	{r4-r6, lr}
	mov	r4, r0
	mov	r5, r1
	add	sp, #-0x4
	mov	r6, sp

	mov	r0, r5
	ldr	r3, ItemTable
	mov	r1, #0xFF
	and	r0, r1
	lsl	r1, r0, #3
	add	r1, r0
	lsl	r1, r1, #2
	add	r1, r3
	ldrb	r1, [r1, #0x19]
	mov	r0, #0xF
	and	r0, r1
	strh	r0, [r6]
	lsr	r1, r1, #4
	strh	r1, [r6, #0x2]

	ldrh	r0, [r6]
	cmp	r0, #0
	bne	SkillCheck
	cmp	r4, #0
	beq	SkillCheck
	mov	r0, r4
	ldr	r3, MagOn2
	mov	lr, r3
	.short	0xF800
	strh	r0, [r6]
	ldr	r0, [r6]
	b	End

SkillCheck:
	ldr	r3, RangeModSkills
	cmp	r3, #0
	beq	NoSkills
	cmp	r4, #0
	beq	NoSkills
	mov	r0, r4
	mov	r1, r5
	ldr	r2, [r6]
	mov	lr, r3
	.short	0xF800
	b	End
NoSkills:
	ldr	r0, [r6]
End:
	add	sp, #0x4
	pop	{r4-r6}
	pop	{r3}
	bx	r3
.align
.ltorg
OffsetList:
