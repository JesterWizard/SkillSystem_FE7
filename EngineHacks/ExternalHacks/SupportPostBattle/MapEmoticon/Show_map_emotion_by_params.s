@ Show map emotion at tile (r0, r1) using table index r2.
@ Raw 16x16 at OBJ tile 0x21C in 2D order: top row 0x06014380, bottom row
@ 0x06014780 (tile 0x21C+32). FE7 map OBJ mapping is 2D.

.thumb
.align 2

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xf800
.endm

.equ CopyToPaletteBuffer, 0x08001084
.equ EnablePaletteSync, 0x0800105C
.equ Proc_Start, 0x08004494
.equ m4aSongNumStart, 0x080BE594
.equ gCameraPos, 0x0202BBC4
.equ gChapterData, 0x0202BBF8
.equ OBJ_VRAM, 0x06014380
.equ OBJ_TILE, 0x21C
.equ OBJ_TILE_GOLD, 0x220
.equ OBJ_VRAM_BASE, 0x06010000

.global Show_map_emotion_params
.type Show_map_emotion_params, %function
Show_map_emotion_params:
	push {r4-r7, lr}
	mov r5, r0
	mov r6, r1
	mov r4, r2
	lsl r5, #4
	lsl r6, #4
	ldr r0, =gCameraPos
	mov r1, #0
	ldsh r1, [r0, r1]
	sub r5, r1
	mov r1, #2
	ldsh r1, [r0, r1]
	sub r6, r1
	mov r0, r4
	mov r1, #20
	mul r0, r1
	ldr r4, =Show_map_emotion_Table
	add r4, r0
	ldr r0, [r4]
	cmp r0, #0
	beq Show_map_emotion_params.end
	ldr r0, [r4, #8]
	mov r1, #3
	blh Proc_Start
	cmp r0, #0
	beq Show_map_emotion_params.end
	mov r7, r0
	str r4, [r7, #0x50]
	add r5, #4
	str r5, [r7, #0x2C]
	sub r6, #12
	str r6, [r7, #0x30]
	mov r1, #0
	str r1, [r7, #0x64]
	ldrh r1, [r4, #0xE]
	ldr r2, =OBJ_TILE
	cmp r1, #0xA
	bne Show_map_emotion_params.got_tile
	ldr r2, =OBJ_TILE_GOLD
Show_map_emotion_params.got_tile:
	strh r2, [r7, #0x34]
	lsl r1, r2, #5
	ldr r2, =OBJ_VRAM_BASE
	add r1, r2
	ldr r0, [r4]
	mov r2, #0x40
Show_map_emotion_params.copy_top:
	ldrh r3, [r0]
	strh r3, [r1]
	add r0, #2
	add r1, #2
	sub r2, #2
	bne Show_map_emotion_params.copy_top
	ldr r2, =0x3C0
	add r1, r2
	mov r2, #0x40
Show_map_emotion_params.copy_bot:
	ldrh r3, [r0]
	strh r3, [r1]
	add r0, #2
	add r1, #2
	sub r2, #2
	bne Show_map_emotion_params.copy_bot
	ldr r0, [r4, #0x10]
	cmp r0, #0
	beq Show_map_emotion_params.sound
	ldrh r1, [r4, #0xE]
	add r1, #16
	lsl r1, r1, #5
	mov r2, #0x20
	blh CopyToPaletteBuffer
	blh EnablePaletteSync
Show_map_emotion_params.sound:
	ldr r0, =gChapterData
	add r0, #0x41
	ldrb r0, [r0]
	lsl r0, r0, #0x1E
	cmp r0, #0
	blt Show_map_emotion_params.end
	ldrh r0, [r4, #0xC]
	cmp r0, #0
	beq Show_map_emotion_params.end
	blh m4aSongNumStart
Show_map_emotion_params.end:
	mov r0, #0
	pop {r4-r7}
	pop {r1}
	bx r1
	.align
	.ltorg
