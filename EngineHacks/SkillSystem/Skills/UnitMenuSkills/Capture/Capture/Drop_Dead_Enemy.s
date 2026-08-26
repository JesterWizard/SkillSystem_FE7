.thumb
.org 0x0

@ FE7 replacement for UnitDrop (0x08017E08).
@ r0 = carrier, r1 = destination x, r2 = destination y.
@ Captured enemies are kept at 1 HP while carried so the trade menu can use
@ their unit data.  Once dropped, they must follow the normal dead-enemy
@ cleanup path instead of remaining as a live unit with 1 HP.

	push	{r4, r5, r6, r7, lr}
	mov	r5, r0
	mov	r6, r1
	mov	r7, r2

	@ Resolve the unit currently carried by the carrier.
	ldr	r1, UnitLookup
	ldrb	r2, [r5, #0x1B]
	lsl	r0, r2, #2
	add	r0, r0, r1
	ldr	r2, [r0]
	mov	r4, r2
	cmp	r4, #0
	beq	End

	@ Vanilla FE7 UnitDrop: clear rescue state from both units.
	ldr	r0, [r5, #0xC]
	movs	r1, #0x31
	neg	r1, r1
	and	r0, r1
	str	r0, [r5, #0xC]

	ldr	r3, [r4, #0xC]
	movs	r0, #0x32
	neg	r0, r0
	and	r3, r0

	@ Preserve vanilla's same-faction dropped-unit state adjustment.
	movs	r0, #0xC0
	ldrb	r1, [r4, #0xB]
	and	r0, r1
	ldr	r1, ChapterData
	ldrb	r1, [r1, #0xF]
	cmp	r0, r1
	bne	StoreDroppedState
	movs	r0, #2
	orr	r3, r0

StoreDroppedState:
	str	r3, [r4, #0xC]
	movs	r0, #0
	strb	r0, [r5, #0x1B]
	strb	r0, [r4, #0x1B]
	strb	r6, [r4, #0x10]
	strb	r7, [r4, #0x11]

	@ A captured enemy is an enemy unit with the temporary 1 HP value.
	ldrb	r0, [r4, #0xB]
	movs	r1, #0x80
	tst	r0, r1
	beq	End
	ldrb	r0, [r4, #0x13]
	cmp	r0, #1
	bhi	End

	@ Match FE7's dead-enemy cleanup: mark dead, clear character data, HP=0.
	ldr	r0, [r4, #0xC]
	movs	r1, #0xD
	orr	r0, r1
	str	r0, [r4, #0xC]
	movs	r0, #0
	str	r0, [r4]
	strb	r0, [r4, #0x13]

End:
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0

.align
UnitLookup:
	.long	0x08B92EB0
ChapterData:
	.long	0x0202BBF8
