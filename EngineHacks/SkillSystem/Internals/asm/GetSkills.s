
	.thumb

	@this hack takes r0 = character data in ram and returns a pointer to a 0-terminated list of skills (using the text buffer)
	@supports 1 personal, 1 class, 7 learned (unit->supports at +0x32)

	SkillsBuffer = 0x02026B90 //FE7 -> FE8 0x202b156 @0x202a5b4

	SkillsUnitBuffer  = 0x0202A9D4 // FE7 -> FE8 0x02026BB0
	SkillsCountBuffer = 0x0202A9D8 // FE7 -> FE8 0x02026BB4

	lPersonalSkillTable  = EALiterals+0x00
	lClassSkillTable     = EALiterals+0x04

	UNIT_SUPPORTS = 0x32
	LEARNED_SKILL_COUNT = 7

GetSkills:
	@ Arguments: r0 = Unit
	@ Returns:   r0 = address of skill buffer

	ldr r1, =SkillsUnitBuffer
	ldr r2, [r1]

	cmp r0, r2
	bne make_buffer

return_in_buffer:
	ldr r0, =SkillsBuffer
	ldr r1, =SkillsCountBuffer
	ldr r1, [r1]

	bx lr

make_buffer:
	str r0, [r1]

	push {r4-r7, lr}

	mov r4, r0            @ var r4 = unit
	ldr r5, =SkillsBuffer @ var r5 = it

	@ Clear leftover IDs so callers that read a fixed slot count
	@ cannot pick up another unit's skills after the terminator.
	mov r0, #0
	mov r1, #0
clear_buf:
	strb r0, [r5, r1]
	add r1, #1
	cmp r1, #16
	blt clear_buf

	@ personal skill first, if any

	ldr  r6, [r4]
	cmp  r6, #0x00
	beq  no_personal
	ldrb r6, [r6, #0x04] @ var r6 = character id

	ldr  r2, lPersonalSkillTable
	ldrb r2, [r2, r6] @ skill byte

	cmp r2, #0
	beq no_personal
	cmp r2, #0xFF
	beq no_personal

	strb r2, [r5]
	add  r5, #1

no_personal:
	@ class skill, if any

	ldr  r0, [r4, #0x04]
	cmp  r0, #0
	beq  no_class
	ldrb r0, [r0, #0x04] @ r0 = class id

	ldr  r2, lClassSkillTable
	ldrb r2, [r2, r0] @ skill byte

	cmp r2, #0
	beq no_class
	cmp r2, #0xFF
	beq no_class

	strb r2, [r5]
	add  r5, #1

no_class:
	@ Learned skills in unit->supports[]. Players 7, others 6 (leader).
	mov r0, r4
	ldrb r0, [r0, #0x0B]
	mov r1, #0xC0
	and r0, r1
	cmp r0, #0
	bne learned_other_max
	mov r7, #LEARNED_SKILL_COUNT
	b learned_have_max
learned_other_max:
	mov r7, #6
learned_have_max:
	mov r0, r4
	add r0, #UNIT_SUPPORTS
	mov r2, #0
copy_learned:
	cmp r2, r7
	bge end_learned
	ldrb r1, [r0, r2]
	cmp r1, #0
	beq end_learned
	cmp r1, #0xFF
	beq end_learned
	strb r1, [r5]
	add r5, #1
	add r2, #1
	b copy_learned

end_learned:
	mov r1, r5

end:
	ldr r0, =SkillsBuffer
	sub r1, r0

	ldr r2, =SkillsCountBuffer
	str r1, [r2]

	pop {r4-r7}

	pop {r3}
	bx r3

	.pool
	.align

EALiterals:
	@ POIN lPersonalSkillTable
	@ POIN lClassSkillTable
