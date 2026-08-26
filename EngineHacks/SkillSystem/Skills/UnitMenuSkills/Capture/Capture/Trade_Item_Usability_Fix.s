.thumb
.org 0x0

@ FE7 trade-menu wrapper for IsItemDisplayUseable.
@ Generic captured enemies may not have character/class data, but their
@ inventory still needs to be rendered without dereferencing null pointers.

.macro blh to, reg=r3
	ldr	\reg, =\to
	mov	lr, \reg
	.short	0xF800
.endm

	push	{lr}
	mov	r1, r5				@ skipped vanilla item copy
	cmp	r0, #0
	beq	SafeItem

	ldr	r2, [r0]
	cmp	r2, #0
	beq	SafeItem

	ldr	r2, [r0, #4]
	cmp	r2, #0
	beq	SafeItem

	blh	0x08016AB0			@ IsItemDisplayUseable
	b	Finish

SafeItem:
	movs	r0, #1

Finish:
	mov	r2, r0				@ skipped vanilla result copy
	lsl	r2, #0x18			@ skipped vanilla sign extension
	asr	r2, #0x18
	pop	{r3}
	bx	r3
