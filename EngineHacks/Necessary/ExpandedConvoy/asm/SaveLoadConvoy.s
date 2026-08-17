.thumb
.align 2

@ FE7 expanded convoy save/load + sanitized item count (DEC-61)
@ Extra 100 items live in a sidecar at 0x0E0067D0 so suspend I/O can
@ keep vanilla chunk offsets. Shifting those chunks by +0xC8 overflowed
@ suspend-2 into game slot 0 (SRAM 0x3F2C) and blanked the first save file.

.equ GetConvoyItemArray,     0x0802E701
.equ ClearConvoyItems,       0x0802E709
.equ WriteAndVerifySramFast, 0x080BFBD9
.equ ReadSramFastPtr,        0x03005E70
.equ GetItemData,            0x080174AD
.equ VanillaConvoySaveSize,  0xC8
.equ ExtraConvoySaveSize,    0xC8
.equ ExtraConvoySram,        0x0E0067D0
.equ ConvoyItemCount,        200
.equ ItemData_Number,        0x06

.global MSa_SaveConvoyExpanded
.type MSa_SaveConvoyExpanded, %function
MSa_SaveConvoyExpanded:
	push	{r4, r5, lr}
	mov	r4, r0			@ vanilla convoy sram dest
	ldr	r3, =GetConvoyItemArray
	bl	bx_r3
	mov	r5, r0			@ convoy ram
	mov	r1, r4
	ldr	r2, =VanillaConvoySaveSize
	ldr	r3, =WriteAndVerifySramFast
	bl	bx_r3
	mov	r0, r4
	bl	ExtraConvoySramAddr
	cmp	r0, #0
	beq	save_done
	mov	r1, r0			@ extra dest
	mov	r0, r5
	ldr	r2, =VanillaConvoySaveSize
	add	r0, r2			@ ram + 100 items
	ldr	r2, =ExtraConvoySaveSize
	ldr	r3, =WriteAndVerifySramFast
	bl	bx_r3
save_done:
	pop	{r4, r5}
	pop	{r0}
	bx	r0

.align 2
.global MSa_LoadConvoyExpanded
.type MSa_LoadConvoyExpanded, %function
MSa_LoadConvoyExpanded:
	push	{r4, r5, lr}
	mov	r4, r0			@ vanilla convoy sram source
	ldr	r3, =ClearConvoyItems
	bl	bx_r3
	ldr	r3, =GetConvoyItemArray
	bl	bx_r3
	mov	r5, r0
	ldr	r3, =ReadSramFastPtr
	ldr	r3, [r3]
	mov	r0, r4
	mov	r1, r5
	ldr	r2, =VanillaConvoySaveSize
	bl	bx_r3
	mov	r0, r4
	bl	ExtraConvoySramAddr
	cmp	r0, #0
	beq	load_sanitize
	ldr	r3, =ReadSramFastPtr
	ldr	r3, [r3]
	mov	r1, r5
	ldr	r2, =VanillaConvoySaveSize
	add	r1, r2
	ldr	r2, =ExtraConvoySaveSize
	bl	bx_r3
load_sanitize:
	bl	SanitizeConvoyItems
	pop	{r4, r5}
	pop	{r0}
	bx	r0

@ r0 = vanilla convoy dest/src in SRAM. Return extra-SRAM ptr or 0.
.align 2
ExtraConvoySramAddr:
	push	{r4, r5, lr}
	ldr	r1, =0x0E000000
	sub	r0, r0, r1		@ sram offset
	adr	r4, ExtraConvoyOffsetTable
	mov	r5, #0
extra_idx_loop:
	ldr	r1, [r4]
	cmp	r0, r1
	beq	extra_idx_found
	add	r4, #4
	add	r5, #1
	cmp	r5, #5
	blt	extra_idx_loop
	mov	r0, #0
	b	extra_idx_done
extra_idx_found:
	@ index * 0xC8
	lsl	r0, r5, #6
	lsl	r1, r5, #7
	add	r0, r1
	lsl	r1, r5, #3
	add	r0, r1
	ldr	r1, =ExtraConvoySram
	add	r0, r1
extra_idx_done:
	pop	{r4, r5}
	pop	{r1}
	bx	r1

	.align 2
ExtraConvoyOffsetTable:
	.word 0x46C4	@ game 0 convoy (0x3F2C + 0x798)
	.word 0x5450	@ game 1 convoy (0x4CB8 + 0x798)
	.word 0x61DC	@ game 2 convoy (0x5A44 + 0x798)
	.word 0x19F8	@ suspend 0 convoy (0x00D4 + 0x1924)
	.word 0x3924	@ suspend 1 convoy (0x2000 + 0x1924)

@ Zero invalid item halfwords (keeps real items; drops 0xFFFF / bad IDs)
.align 2
.global SanitizeConvoyItems
.type SanitizeConvoyItems, %function
SanitizeConvoyItems:
	push	{r4, r5, r6, lr}
	ldr	r3, =GetConvoyItemArray
	bl	bx_r3
	mov	r4, r0			@ ptr
	mov	r5, #0			@ index
sanitize_loop:
	ldrh	r6, [r4]
	cmp	r6, #0
	beq	sanitize_next
	mov	r0, #0xFF
	and	r0, r6			@ item id
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
