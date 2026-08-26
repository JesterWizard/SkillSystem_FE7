.thumb
.org 0x0

@ FE7 replacement for func_08023CC0, the trade-target callback.
@ r0 = the unit currently being considered.
@ gTargetListSubject (0x02033E40) points to the unit initiating trade.

.macro blh to, reg=r3
	ldr	\reg, =\to
	mov	lr, \reg
	.short	0xF800
.endm

	push	{r4, r5, lr}
	mov	r4, r0
	ldr	r5, =0x02033E40

	@ Preserve FE7's normal same-allegiance trade target checks.
	ldr	r0, [r5]
	ldrb	r0, [r0, #0xB]
	lsl	r0, #24
	asr	r0, #24
	movs	r1, #0xB
	ldrsb	r1, [r4, r1]
	blh	0x080238C4			@ AreUnitIdsAllied
	lsl	r0, #24
	cmp	r0, #0
	beq	CheckCapturedEnemy

	mov	r1, r4
	add	r1, #0x30
	movs	r0, #0xF
	ldrb	r1, [r1]
	and	r0, r1
	cmp	r0, #4
	beq	CheckRescuedUnit

	ldr	r0, [r5]
	ldrh	r0, [r0, #0x1E]
	cmp	r0, #0
	bne	EnlistUnit
	ldrh	r0, [r4, #0x1E]
	cmp	r0, #0
	beq	CheckRescuedUnit

	ldr	r0, [r4]
	ldr	r1, [r4, #4]
	ldr	r0, [r0, #0x28]
	ldr	r1, [r1, #0x28]
	orr	r0, r1
	movs	r1, #0x80
	lsl	r1, #2
	and	r0, r1
	cmp	r0, #0
	bne	CheckRescuedUnit

EnlistUnit:
	movs	r0, #0x10
	ldrsb	r0, [r4, r0]
	movs	r1, #0x11
	ldrsb	r1, [r4, r1]
	movs	r2, #0xB
	ldrsb	r2, [r4, r2]
	movs	r3, #0
	push	{r4}
	blh	0x0804ACFC, r4			@ EnlistTarget
	pop	{r4}
	b	End

CheckCapturedEnemy:
	@ The captured unit remains an enemy, but is tradeable while carried.
	ldrb	r0, [r4, #0xB]
	movs	r1, #0x80
	tst	r0, r1
	beq	End
	ldrb	r0, [r4, #0x13]
	cmp	r0, #1
	bne	End

	@ Confirm this is the unit carried by the subject, not an arbitrary enemy.
	ldr	r0, [r5]
	ldr	r1, [r0, #0xC]
	movs	r2, #0x10
	tst	r1, r2
	beq	End
	ldrb	r1, [r0, #0x1B]
	ldrb	r0, [r4, #0xB]
	cmp	r0, r1
	bne	End

	ldr	r0, [r5]
	ldrh	r0, [r0, #0x1E]
	cmp	r0, #0
	bne	EnlistCapturedEnemy
	ldrh	r0, [r4, #0x1E]
	cmp	r0, #0
	beq	End

EnlistCapturedEnemy:
	movs	r0, #0x10
	ldrsb	r0, [r4, r0]
	movs	r1, #0x11
	ldrsb	r1, [r4, r1]
	movs	r2, #0xB
	ldrsb	r2, [r4, r2]
	movs	r3, #0
	push	{r4}
	blh	0x0804ACFC, r4			@ EnlistTarget
	pop	{r4}
	b	End

CheckRescuedUnit:
	ldr	r0, [r4, #0xC]
	movs	r1, #0x10
	and	r0, r1
	cmp	r0, #0
	beq	End

	ldrb	r0, [r4, #0x1B]
	blh	0x08018D0C			@ GetUnit
	cmp	r0, #0
	beq	End
	mov	r1, r0
	movs	r2, #0xB
	ldrsb	r2, [r1, r2]
	movs	r0, #0xC0
	and	r0, r2
	cmp	r0, #0
	bne	End

	ldr	r0, [r5]
	ldrh	r0, [r0, #0x1E]
	cmp	r0, #0
	bne	EnlistRescuedUnit
	ldrh	r0, [r1, #0x1E]
	cmp	r0, #0
	beq	End

EnlistRescuedUnit:
	movs	r0, #0x10
	ldrsb	r0, [r4, r0]
	movs	r1, #0x11
	ldrsb	r1, [r4, r1]
	movs	r3, #0
	push	{r4}
	blh	0x0804ACFC, r4			@ EnlistTarget; r2 is rescued unit ID
	pop	{r4}

End:
	pop	{r4, r5}
	pop	{r0}
	bx	r0
