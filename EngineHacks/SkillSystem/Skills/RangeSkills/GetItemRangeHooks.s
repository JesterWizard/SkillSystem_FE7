.thumb

.macro _blr reg
	mov	lr, \reg
	.short	0xF800
.endm

.equ ItemRangeGetter, OffsetList + 0x0
.equ ppActiveUnit, OffsetList + 0x4
.equ ppSubjectUnit, OffsetList + 0x8

@ r0 = gSubjectUnit if set, else gActiveUnit
LoadRangeUnit:
	ldr	r0, ppSubjectUnit
	ldr	r0, [r0]
	cmp	r0, #0
	bne	LoadRangeUnitDone
	ldr	r0, ppActiveUnit
	ldr	r0, [r0]
LoadRangeUnitDone:
	bx	lr

@ r0 = item short
.global GetItemMinRangeHook
.type GetItemMinRangeHook, %function
GetItemMinRangeHook:
	push	{r4, lr}
	mov	r4, r0
	bl	LoadRangeUnit
	mov	r1, r4
	ldr	r3, ItemRangeGetter
	_blr	r3
	lsr	r0, r0, #16
	pop	{r4}
	pop	{r1}
	bx	r1

.global GetItemMaxRangeHook
.type GetItemMaxRangeHook, %function
GetItemMaxRangeHook:
	push	{r4, lr}
	mov	r4, r0
	bl	LoadRangeUnit
	mov	r1, r4
	ldr	r3, ItemRangeGetter
	_blr	r3
	lsl	r0, r0, #16
	lsr	r0, r0, #16
	pop	{r4}
	pop	{r1}
	bx	r1

@ r0 = item, r1 = range. SetBattleUnitWeapon keeps the battle unit in r5.
.global IsItemCoveringRangeHook
.type IsItemCoveringRangeHook, %function
IsItemCoveringRangeHook:
	push	{r4-r6, lr}
	mov	r6, r1
	mov	r4, r0
	mov	r0, r5
	cmp	r0, #0
	bne	GotUnit
	bl	LoadRangeUnit
GotUnit:
	mov	r1, r4
	ldr	r3, ItemRangeGetter
	_blr	r3
	lsl	r1, r0, #16
	lsr	r1, r1, #16
	lsr	r2, r0, #16
	mov	r0, #0
	cmp	r2, r6
	bgt	CoverFail
	cmp	r6, r1
	bgt	CoverFail
	mov	r0, #1
CoverFail:
	pop	{r4-r6}
	pop	{r3}
	bx	r3
.align
.ltorg
OffsetList:
