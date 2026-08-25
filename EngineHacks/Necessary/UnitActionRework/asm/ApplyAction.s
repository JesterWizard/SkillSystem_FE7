.thumb
.global ApplyAction

@ FE7 ApplyUnitAction replacement. r0 = parent 6C.

.set pActionStruct, 0x0203A868
.set ppActiveUnit,  0x03004690
.set prUnit_GetStruct, 0x08018D0C

ApplyAction:
	push {r4-r5, lr}

	mov r4, r0

	ldr r5, =pActionStruct

	ldrb r0, [r5, #0x0C]
	ldr r3, =prUnit_GetStruct
	mov lr, r3
	.short 0xF800

	ldr r1, =ppActiveUnit
	str r0, [r1]

	ldrb r2, [r5, #0x11]

	ldr r3, EALiterals
	lsl r0, r2, #2
	add r0, r3
	ldr r0, [r0]

	lsr r5, r0, #28
	lsl r2, r0, #4
	lsr r2, #4
	beq Continue

	mov r0, r4
	bl BXR2

	cmp r5, #0
	beq End
	mov r0, #0
	b End

Continue:
	mov r0, #1

End:
	pop {r4-r5}
	pop {r1}
	bx r1

BXR2:
	bx r2

.align 2
.ltorg

.align 2
EALiterals:
	.word pActionRoutineTable
