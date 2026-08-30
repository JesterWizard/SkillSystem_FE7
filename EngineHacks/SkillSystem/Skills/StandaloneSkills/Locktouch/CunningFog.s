.thumb

@ FE7 GetUnitFogViewRange (0x080175BC).
@ Vanilla: chapterVisionRange +5 if CA_STEAL (0x08), plus torch nibble.
@ Cunning grants the same +5 when the steal bit is clear.
@ Vision lives in r5: SkillTester (and the ldr r3 trampoline) clobber r3.

.equ CunningID, SkillTester+4
.equ ChapterData, 0x0202BBF8

.global CunningFog
CunningFog:
	push {r4, r5, lr}
	mov r4, r0
	ldr r0, =ChapterData
	ldrb r5, [r0, #13]
	ldr r0, [r4]
	ldr r1, [r4, #4]
	ldr r0, [r0, #0x28]
	ldr r1, [r1, #0x28]
	orr r0, r1
	mov r1, #8
	and r0, r1
	bne AddFive
	mov r0, r4
	ldr r1, CunningID
	ldr r3, SkillTester
	mov lr, r3
	.short 0xf800
	cmp r0, #0
	beq Torch
AddFive:
	add r5, #5
Torch:
	mov r0, r4
	add r0, #0x31
	ldrb r0, [r0]
	lsl r0, #28
	lsr r0, #28
	add r0, r5
CunningFogDone:
	pop {r4, r5}
	pop {r1}
	bx r1

.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD CunningID
