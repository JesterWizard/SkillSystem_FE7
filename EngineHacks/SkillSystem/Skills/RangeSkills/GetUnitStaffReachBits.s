.thumb

.macro _blr reg
	mov	lr, \reg
	.short	0xF800
.endm

.equ ItemRangeGetter, OffsetList + 0x0
.equ CanUnitUseAsStaff, OffsetList + 0x4
.equ MapAddInRange, OffsetList + 0x8
.equ ForEachInRange, OffsetList + 0xC
.equ InitRangeMap, OffsetList + 0x10
.equ ppSubjectUnit, OffsetList + 0x14
.equ ppActiveUnit, OffsetList + 0x18

@ r0 = packed; staff fill wants 0x01 / 0x03 / 0x20, not weapon bit N
StaffMask:
	lsl	r1, r0, #16
	lsr	r1, r1, #16
	mov	r0, #0x20
	cmp	r1, #4
	bgt	MaskDone
	mov	r0, #1
	cmp	r1, #1
	ble	MaskDone
	mov	r0, #3
MaskDone:
	bx	lr

@ staff overlay mask → MapAddInRange radius (1 or 2)
StaffFillRadius:
	mov	r1, #1
	cmp	r0, #3
	blt	StaffFillRadiusKeep
	cmp	r0, #0x20
	beq	StaffFillRadiusKeep
	mov	r1, #2
StaffFillRadiusKeep:
	mov	r0, r1
StaffFillRadiusDone:
	bx	lr

@ 0x16FCC takes only r0 = unit; r1 is live junk
.global GetUnitStaffReachBitsAll
.type GetUnitStaffReachBitsAll, %function
GetUnitStaffReachBitsAll:
	mov	r1, #1
	neg	r1, r1

.global GetUnitStaffReachBits
.type GetUnitStaffReachBits, %function
GetUnitStaffReachBits:
	push	{r4-r7, lr}
	mov	r4, r0
	mov	r7, #0
	cmp	r1, #0
	blt	AllItems
	lsl	r1, r1, #1
	add	r0, r4, #0
	add	r0, #0x1E
	add	r0, r1
	ldrh	r1, [r0]
	mov	r0, r4
	ldr	r3, ItemRangeGetter
	_blr	r3
	bl	StaffMask
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
	ldr	r3, CanUnitUseAsStaff
	_blr	r3
	lsl	r0, r0, #24
	cmp	r0, #0
	beq	Next
	mov	r0, r4
	mov	r1, r6
	ldr	r3, ItemRangeGetter
	_blr	r3
	bl	StaffMask
	cmp	r0, r7
	bls	Next
	mov	r7, r0
Next:
	add	r5, #1
	cmp	r5, #4
	ble	Loop
	mov	r0, r7
Done:
	pop	{r4-r7}
	pop	{r1}
	bx	r1

@ 0x23A74: vanilla fills range 1; Heal usability uses this, so Staff never
@ appears at StaffSavant's extra tile. r0=x r1=y r2=callback
.global StaffRange1FillHook
.type StaffRange1FillHook, %function
StaffRange1FillHook:
	push	{r4-r7, lr}
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	ldr	r3, InitRangeMap
	_blr	r3
	ldr	r0, ppSubjectUnit
	ldr	r0, [r0]
	cmp	r0, #0
	bne	GotFillUnit
	ldr	r0, ppActiveUnit
	ldr	r0, [r0]
GotFillUnit:
	cmp	r0, #0
	beq	UseFillOne
	mov	r1, #1
	neg	r1, r1
	bl	GetUnitStaffReachBits
	bl	StaffFillRadius
	b	HaveFillMax
UseFillOne:
	mov	r0, #1
HaveFillMax:
	mov	r7, r0
	ldr	r3, MapAddInRange
	mov	r0, r4
	mov	r1, r5
	mov	r2, r7
	mov	r7, r3
	mov	r3, #1
	_blr	r7
	ldr	r7, MapAddInRange
	mov	r0, r4
	mov	r1, r5
	mov	r2, #0
	mov	r3, #1
	neg	r3, r3
	_blr	r7
	mov	r0, r6
	ldr	r3, ForEachInRange
	_blr	r3
	pop	{r4-r7}
	pop	{r1}
	bx	r1
.align
.ltorg
OffsetList:
