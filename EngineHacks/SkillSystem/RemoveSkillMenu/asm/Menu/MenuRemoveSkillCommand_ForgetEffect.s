
	.thumb

	.include "../Definitions.inc"

	pExtraItemOrSkill = 0x0202BBE6
	UNIT_SUPPORTS = 0x32
	LEARNED_SKILL_COUNT_PLAYER = 7
	LEARNED_SKILL_COUNT_OTHER = 6

ForgetEffect:
	push {r4-r7, lr}

	mov  r2, #0x3C
	ldrb r2, [r1, r2]
	sub  r2, #2

	ldr  r0, [r0, #0x14]
	ldr  r0, [r0, #0x2C]
	mov  r4, r0
	mov  r3, r0
	add  r3, #UNIT_SUPPORTS

	ldrb r0, [r4, #0x0B]
	mov r1, #0xC0
	and r0, r1
	cmp r0, #0
	bne ForgetEffect.other
	mov r7, #LEARNED_SKILL_COUNT_PLAYER
	b ForgetEffect.have_max
ForgetEffect.other:
	mov r7, #LEARNED_SKILL_COUNT_OTHER
ForgetEffect.have_max:

lop:
	add  r1, r3, r2
	add  r0, r2, #1
	cmp  r0, r7
	bge  write_new
	add  r0, r3, r0
	ldrb r0, [r0]
	strb r0, [r1]
	add r2, #1
	b lop

write_new:
	ldr  r0, =pExtraItemOrSkill
	ldrb r0, [r0]
	strb r0, [r1]

	mov r0, #(0x10 | 0x8 | 0x4 | 0x2)

	pop {r4-r7}
	pop {r1}
	bx r1

	.pool
	.align

EALiterals:
	@ nothing
