.thumb

.macro _blr reg
	mov	lr, \reg
	.short	0xF800
.endm

.equ ItemRangeGetter, OffsetList + 0x0
.equ CanUnitUseWeapon, OffsetList + 0x4

@ r0 = packed range; FE7 fill indexes (mask-1) and only has
@ RANGE1=1 RANGE2=2 RANGE1+2=3 RANGE3=4 RANGE2+3=6 RANGE1+2+3=7
@ Overlay rings stop at 3; extra max still applies via min/max hooks.
PackedToMask:
	lsl	r1, r0, #16
	lsr	r1, r1, #16
	lsr	r2, r0, #16
	cmp	r2, #1
	bge	MinOk
	mov	r2, #1
MinOk:
	cmp	r1, #3
	ble	MaxOk
	mov	r1, #3
MaxOk:
	cmp	r1, r2
	bge	Build
	mov	r0, #0
	bx	lr
Build:
	mov	r0, #1
	lsl	r0, r1
	sub	r0, #1
	sub	r2, #1
	mov	r3, #1
	lsl	r3, r2
	sub	r3, #1
	eor	r0, r3
PackedMaskDone:
	bx	lr

@ r0 = unit, r1 = item slot (-1 = all usable weapons)
.global GetUnitItemReachBits
.type GetUnitItemReachBits, %function
GetUnitItemReachBits:
	push	{r4-r7, lr}
	mov	r4, r0
	mov	r7, #0
	cmp	r1, #0
	blt	AllItems
	lsl	r1, r1, #1
	mov	r0, r4
	add	r0, #0x1E
	add	r0, r1
	ldrh	r1, [r0]
	mov	r0, r4
	ldr	r3, ItemRangeGetter
	_blr	r3
	bl	PackedToMask
	b	Done

AllItems:
	mov	r5, #0
Loop:
	lsl	r1, r5, #1
	mov	r0, r4
	add	r0, #0x1E
	add	r0, r1
	ldrh	r6, [r0]
	cmp	r6, #0
	beq	Next
	mov	r0, r4
	mov	r1, r6
	ldr	r3, CanUnitUseWeapon
	_blr	r3
	lsl	r0, r0, #24
	cmp	r0, #0
	beq	Next
	mov	r0, r4
	mov	r1, r6
	ldr	r3, ItemRangeGetter
	_blr	r3
	bl	PackedToMask
	orr	r7, r0
Next:
	add	r5, #1
	cmp	r5, #4
	ble	Loop
	mov	r0, r7
Done:
	pop	{r4-r7}
	pop	{r1}
	bx	r1
.align
.ltorg
OffsetList:
