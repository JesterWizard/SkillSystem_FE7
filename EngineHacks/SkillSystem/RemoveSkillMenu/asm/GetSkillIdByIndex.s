
	.thumb

	.include "Definitions.inc"

	pExtraItemOrSkill = 0x0202BBE6 @ FE7; FE8 0x0202BCDE
	UNIT_SUPPORTS = 0x32
	LEARNED_SKILL_COUNT = 7

	lpCharSkillTable  = EALiterals+0x00
	lpClassSkillTable = EALiterals+0x04

GetSkillIdByIndex:
	@ Arguments: r0 = Unit Struct, r1 = Index
	@ Returns:   r0 = Skill Id (0 if none)
	@ Index: 0 personal, 1 class, 2..8 learned, 9 pending extra learn

	push {r4-r5, lr}

	mov r4, r0
	mov r5, r1

	cmp r5, #0
	bne not_char_skill

	ldr  r2, [r4]
	ldrb r2, [r2, #4]

	ldr  r3, lpCharSkillTable
	ldrb r0, [r3, r2]

	b end

not_char_skill:
	cmp r5, #1
	bne not_class_skill

	ldr  r2, [r4, #4]
	ldrb r2, [r2, #4]

	ldr  r3, lpClassSkillTable
	ldrb r0, [r3, r2]

	b end

not_class_skill:
	cmp r5, #9
	bne not_extra_learn_skill

	ldr  r2, =pExtraItemOrSkill
	ldrb r0, [r2]

	b end

not_extra_learn_skill:
	sub r5, #2
	blt return_zero

	cmp r5, #LEARNED_SKILL_COUNT
	bge return_zero

	@ non-player: slot 6 is leader, not a skill
	cmp r5, #6
	bne read_learned
	ldrb r0, [r4, #0x0B]
	mov r1, #0xC0
	and r0, r1
	cmp r0, #0
	bne return_zero

read_learned:
	mov r0, r4
	add r0, #UNIT_SUPPORTS
	ldrb r0, [r0, r5]

	b end

return_zero:
	mov r0, #0

end:
	pop {r4-r5}

	pop {r1}
	bx r1

	.pool
	.align

EALiterals:
	@ POIN CharacterSkillTable
	@ POIN ClassSkillTable
