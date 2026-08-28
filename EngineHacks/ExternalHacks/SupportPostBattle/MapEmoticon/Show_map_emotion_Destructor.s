@ Draw the packed 16x16 heart every frame, then break so PROC_END runs.

.thumb
.align 2

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xf800
.endm

.equ Proc_Break, 0x080046A0
.equ PutSprite, 0x080069F4
.equ gObject_16x16, 0x08B905B8
.equ OBJ_TILE, 0x21C

.global Show_map_emotion_Destructor
.type Show_map_emotion_Destructor, %function
Show_map_emotion_Destructor:
	push {r4-r6, lr}
	mov r4, r0
	add r0, #0x64
	ldrh r1, [r0]
	add r2, r1, #1
	strh r2, [r0]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	mov r5, r1
	ldr r6, =HeartDisplayFrames
	ldr r6, [r6]
	sub r6, #1
	cmp r5, r6
	ble Show_map_emotion_Destructor.draw
	mov r0, r4
	blh Proc_Break
	b Show_map_emotion_Destructor.end
Show_map_emotion_Destructor.draw:
	ldr r6, [r4, #0x50]
	cmp r6, #0
	beq Show_map_emotion_Destructor.end
	ldrh r0, [r6, #0xE]
	lsl r0, r0, #12
	ldrh r1, [r4, #0x34]
	cmp r1, #0
	bne Show_map_emotion_Destructor.got_tile
	ldr r1, =OBJ_TILE
Show_map_emotion_Destructor.got_tile:
	orr r0, r1
	mov r6, r0
	ldr r3, =PutSprite
	mov lr, r3
	mov r0, #2
	ldr r1, [r4, #0x2C]
	ldr r2, [r4, #0x30]
	ldr r3, =gObject_16x16
	push {r6}
	.short 0xf800
	add sp, #4
Show_map_emotion_Destructor.end:
	pop {r4-r6}
	pop {r0}
	bx r0
	.align
	.ltorg

.align 2
.global HeartDisplayFrames
HeartDisplayFrames:
	.word 40
