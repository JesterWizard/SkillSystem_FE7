.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.thumb
.equ GetUnit, 0x8018d0d
.equ NextRN_N, 0x8000E31

.global IsRallyApplicable
.type IsRallyApplicable, %function
IsRallyApplicable:
	@ Start-of-turn even with nobody in range (self still gets the rally).
	mov r0, #1
	bx lr
.ltorg

@ Do not StartProc an aura: FE8 song 136 / LockGame faults on FE7.
.global RallyChaosFunc
.type RallyChaosFunc, %function
RallyChaosFunc:
	push {r4-r7, lr}
	mov r4, r0                      @ unit with this skill

	mov r0, #8                      @ 0..7 -> bits 1<<n
	blh NextRN_N
	mov r7, #1
	lsl r7, r0                      @ rally bit to do

	mov r0, r4
	mov r1, r7
	bl RallyCommandEffect_apply

	mov r6, #0
RallyChaosLoop:
	add r6, #1
	cmp r6, #0xC0
	bge ExitRallyChaos
	mov r0, r6
	blh GetUnit
	cmp r0, #0
	beq RallyChaosLoop
	cmp r0, r4
	beq RallyChaosLoop
	ldr r1, [r0]
	cmp r1, #0
	beq RallyChaosLoop
	ldr r1, [r0, #0xC]
	mov r2, #0x2C                   @ dead | undeployed | rescued
	tst r1, r2
	bne RallyChaosLoop
	ldrb r1, [r0, #0x0B]
	ldrb r2, [r4, #0x0B]
	mov r3, #0xC0
	and r1, r3
	and r2, r3
	cmp r1, r2
	bne RallyChaosLoop
	ldrb r1, [r0, #0x10]
	ldrb r2, [r4, #0x10]
	sub r1, r2
	asr r2, r1, #31
	eor r1, r2
	sub r1, r2
	ldrb r2, [r0, #0x11]
	ldrb r3, [r4, #0x11]
	sub r2, r3
	asr r3, r2, #31
	eor r2, r3
	sub r2, r3
	add r1, r2
	cmp r1, #2
	bgt RallyChaosLoop
	mov r1, r7
	bl RallyCommandEffect_apply
	b RallyChaosLoop

ExitRallyChaos:
	pop {r4-r7}
	pop {r0}
	bx r0
.ltorg
