
	.thumb

	@this hack takes r0 = character data in ram and returns a pointer to a 0-terminated list of skills (using the text buffer)
	@supports 1 personal, 1 class, 4 learned

	SkillsBuffer = 0x02026B90 //FE7 -> FE8 0x202b156 @0x202a5b4

	SkillsUnitBuffer  = 0x0202A9D4 // FE7 -> FE8 0x02026BB0
	SkillsCountBuffer = 0x0202A9D8 // FE7 -> FE8 0x02026BB4

	lPersonalSkillTable  = EALiterals+0x00
	lClassSkillTable     = EALiterals+0x04
	lGetInitialSkillList = EALiterals+0x08
	lLearnedSkillRam     = EALiterals+0x0C

	LEARNED_PID_MAX = 0x45
	LEARNED_SLOT_COUNT = 6
	LEARNED_SLOTS_SIZE = 0x1A4 @ 0x46 * 6

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
	cmp r1, #8
	blt clear_buf

	@ Debugger override only. Never mass-clear this RAM: it sits
	@ against DebuffTableRam+DebuffTableSize (0x0203F540).
	ldr r1, lLearnedSkillRam
	ldr r2, [r1]
	ldr r3, LearnedSkillMagic
	cmp r2, r3
	bne no_override
	ldr r0, [r4]
	cmp r0, #0
	beq no_override
	ldrb r6, [r0, #4]
	cmp r6, #0
	beq no_override
	cmp r6, #LEARNED_PID_MAX
	bhi no_override
	ldr r2, LearnedOverrideOff
	add r1, r2
	ldrb r2, [r1, r6]
	cmp r2, #0
	beq no_override

	ldr r1, lLearnedSkillRam
	add r1, #4
	mov r2, #LEARNED_SLOT_COUNT
	mul r2, r6
	add r1, r2
	mov r2, #0
copy_override:
	ldrb r3, [r1, r2]
	strb r3, [r5, r2]
	add r2, #1
	cmp r2, #LEARNED_SLOT_COUNT
	blt copy_override
	mov r3, #0
	strb r3, [r5, r2]
	add r1, r5, r2
	b end

no_override:
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
	@ Learned skills from level-up lists. Do not use FE7 BWL+1..4.

	ldr r3, lGetInitialSkillList

	mov r0, r4 @ arg r0 = unit
	mov r1, r5 @ arg r1 = output buffer

	bl BXR3

	mov r1, r0

lop_move_to_end:
	ldrb r0, [r1]

	cmp r0, #0
	beq end

	add r1, #1
	b lop_move_to_end

end:
	ldr r0, =SkillsBuffer
	sub r1, r0

	ldr r2, =SkillsCountBuffer
	str r1, [r2]

	pop {r4-r7}

	pop {r3}
BXR3:
	bx r3

	.align
LearnedSkillMagic:
	.word 0x534B4C53
LearnedOverrideOff:
	.word 4 + LEARNED_SLOTS_SIZE

	.pool
	.align

EALiterals:
	@ POIN lPersonalSkillTable
	@ POIN lClassSkillTable
	@ POIN (GetInitialSkillList|1)
	@ POIN gLearnedSkillRam
