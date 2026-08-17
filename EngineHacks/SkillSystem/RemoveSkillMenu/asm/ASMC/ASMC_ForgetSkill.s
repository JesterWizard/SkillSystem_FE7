
	.thumb

	gEventSlot = 0x030004B8
	UNIT_SUPPORTS = 0x32
	LEARNED_SKILL_COUNT_PLAYER = 7
	LEARNED_SKILL_COUNT_OTHER = 6

	GetUnitFromEventParam = 0x0800BC50|1

ASMC_ForgetSkill:
	push {r4-r7, lr}

	ldr r1, =gEventSlot
	ldr r0, [r1, #(0x02 * 4)]

	ldr r3, =GetUnitFromEventParam
	bl BXR3
	mov r4, r0 @ unit

	mov r3, r4
	add r3, #UNIT_SUPPORTS

	ldr r1, =gEventSlot
	ldr r1, [r1, #(0x01 * 4)]
	mov r5, r1 @ skill id

	ldrb r0, [r4, #0x0B]
	mov r1, #0xC0
	and r0, r1
	cmp r0, #0
	bne ASMC_ForgetSkill.other
	mov r7, #LEARNED_SKILL_COUNT_PLAYER
	b ASMC_ForgetSkill.have_max
ASMC_ForgetSkill.other:
	mov r7, #LEARNED_SKILL_COUNT_OTHER
ASMC_ForgetSkill.have_max:

	mov r2, #0
loop_find_slot:
	ldrb r0, [r3, r2]
	cmp r0, r5
	beq found_slot
	add r2, #1
	cmp r2, r7
	blt loop_find_slot

	ldr r1, =gEventSlot
	mov r0, #0
	str r0, [r1, #(0x0C * 4)]
	b end

found_slot:
loop_remove:
	add r0, r2, #1
	cmp r0, r7
	bge clear_last
	ldrb r0, [r3, r0]
	strb r0, [r3, r2]
	add r2, #1
	b loop_remove

clear_last:
	mov r0, #0
	sub r1, r7, #1
	strb r0, [r3, r1]

	ldr r1, =gEventSlot
	mov r0, #1
	str r0, [r1, #(0x0C * 4)]

end:
	pop {r4-r7}
	pop {r3}
BXR3:
	bx r3
