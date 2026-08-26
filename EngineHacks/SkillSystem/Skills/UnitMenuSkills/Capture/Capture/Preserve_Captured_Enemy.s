.thumb
.org 0x0

@ FE7 replacement for KillUnit.
@ A rescued enemy must keep its character pointer while the carrier still
@ references it; otherwise opening the trade menu dereferences cleared data.

.macro blh to, reg=r3
	ldr	\reg, =\to
	mov	lr, \reg
	.short	0xF800
.endm

	push	{r4, lr}
	mov	r4, r0

	@ Vanilla allied units become dead and clear supports.
	ldrb	r1, [r4, #0xB]
	movs	r2, #0xC0
	and	r1, r2
	cmp	r1, #0
	beq	KillAlliedUnit

	@ Keep rescued non-player units intact for trade.
	ldr	r0, [r4, #0xC]
	movs	r1, #0x20
	tst	r0, r1
	bne	End

	@ Vanilla enemy/NPC behavior clears the character data pointer.
	movs	r0, #0
	str	r0, [r4]
	b	End

KillAlliedUnit:
	ldr	r0, [r4, #0xC]
	movs	r1, #5
	orr	r0, r1
	str	r0, [r4, #0xC]
	mov	r0, r4
	blh	0x08026844			@ ClearUnitSupports

End:
	pop	{r4}
	pop	{r0}
	bx	r0
