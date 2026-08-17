.thumb
.align 2

@ FE7 expanded convoy chunk save/load (DEC-61 + DEC-68)
@ EMS passes r0 = chunk SRAM address, r1 = size (0x190).

.equ GetConvoyItemArray,     0x0802E701
.equ ClearConvoyItems,       0x0802E709
.equ WriteAndVerifySramFast, 0x080BFBD9
.equ ReadSramFastPtr,        0x03005E70
.equ GetItemData,            0x080174AD
.equ ConvoySaveSize,         0x190
.equ ConvoyItemCount,        200
.equ ItemData_Number,        0x06

.global MSa_SaveConvoyExpanded
.type MSa_SaveConvoyExpanded, %function
MSa_SaveConvoyExpanded:
	push	{r4, r5, lr}
	mov	r4, r0			@ sram dest
	mov	r5, r1			@ size
	cmp	r5, #0
	bne	1f
	ldr	r5, =ConvoySaveSize
1:
	ldr	r3, =GetConvoyItemArray
	bl	bx_r3
	mov	r1, r4
	mov	r2, r5
	ldr	r3, =WriteAndVerifySramFast
	bl	bx_r3
	pop	{r4, r5}
	pop	{r0}
	bx	r0

.align 2
.global MSa_LoadConvoyExpanded
.type MSa_LoadConvoyExpanded, %function
MSa_LoadConvoyExpanded:
	push	{r4, r5, lr}
	mov	r4, r0			@ sram source
	mov	r5, r1			@ size
	cmp	r5, #0
	bne	1f
	ldr	r5, =ConvoySaveSize
1:
	ldr	r3, =ClearConvoyItems
	bl	bx_r3
	ldr	r3, =GetConvoyItemArray
	bl	bx_r3
	mov	r1, r0
	ldr	r3, =ReadSramFastPtr
	ldr	r3, [r3]
	mov	r0, r4
	mov	r2, r5
	bl	bx_r3
	bl	SanitizeConvoyItems
	pop	{r4, r5}
	pop	{r0}
	bx	r0

.align 2
.global SanitizeConvoyItems
.type SanitizeConvoyItems, %function
SanitizeConvoyItems:
	push	{r4, r5, r6, lr}
	ldr	r3, =GetConvoyItemArray
	bl	bx_r3
	mov	r4, r0
	mov	r5, #0
sanitize_loop:
	ldrh	r6, [r4]
	cmp	r6, #0
	beq	sanitize_next
	mov	r0, #0xFF
	and	r0, r6
	cmp	r0, #0
	beq	sanitize_clear
	ldr	r3, =GetItemData
	bl	bx_r3
	cmp	r0, #0
	beq	sanitize_clear
	ldrb	r1, [r0, #ItemData_Number]
	mov	r0, #0xFF
	and	r0, r6
	cmp	r0, r1
	beq	sanitize_next
sanitize_clear:
	mov	r0, #0
	strh	r0, [r4]
sanitize_next:
	add	r4, #2
	add	r5, #1
	cmp	r5, #ConvoyItemCount
	blt	sanitize_loop
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0

.align 2
.global GetConvoyItemCountSanitized
.type GetConvoyItemCountSanitized, %function
GetConvoyItemCountSanitized:
	push	{r4, r5, lr}
	bl	SanitizeConvoyItems
	bl	CountConvoyItems
	cmp	r0, #0
	bne	count_done
	ldr	r4, =0x0203A720
	mov	r5, #100
migrate_check:
	ldrh	r0, [r4]
	cmp	r0, #0
	bne	do_migrate
	add	r4, #2
	sub	r5, #1
	cmp	r5, #0
	bne	migrate_check
	mov	r0, #0
	b	count_done
do_migrate:
	ldr	r3, =GetConvoyItemArray
	bl	bx_r3
	mov	r1, r0
	ldr	r0, =0x0203A720
	mov	r2, #100
migrate_copy:
	ldrh	r3, [r0]
	strh	r3, [r1]
	mov	r3, #0
	strh	r3, [r0]
	add	r0, #2
	add	r1, #2
	sub	r2, #1
	cmp	r2, #0
	bne	migrate_copy
	bl	SanitizeConvoyItems
	bl	CountConvoyItems
count_done:
	pop	{r4, r5}
	pop	{r1}
	bx	r1

.align 2
CountConvoyItems:
	push	{r4, lr}
	ldr	r3, =GetConvoyItemArray
	bl	bx_r3
	mov	r1, r0
	mov	r0, #0
	mov	r2, #ConvoyItemCount
count_loop:
	ldrh	r3, [r1]
	cmp	r3, #0
	beq	count_next
	add	r0, #1
count_next:
	add	r1, #2
	sub	r2, #1
	cmp	r2, #0
	bne	count_loop
	pop	{r4}
	pop	{r1}
	bx	r1

bx_r3:
	bx	r3

.ltorg
.align 2
