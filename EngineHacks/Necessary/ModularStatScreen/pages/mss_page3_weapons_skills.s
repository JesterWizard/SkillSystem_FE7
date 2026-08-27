.thumb
@ Alternate page 3: all weapon ranks on the left, skill names on the right.
.include "mss_defs.s"

.global MSS_page3
.type MSS_page3, %function

.set NoAltIconDraw, 1 @ DrawIcon + IconRework sheet 1 (SkillIcons)

MSS_page3:

page_start

@ DrawWeaponRank uses page-buffer tiles (x=1 is the left of the right panel).
@ draw_skill_* uses tile_origin, where the right column is x=21 (page 1 Con/Skills).
draw_weapon_rank_at 1, 1, Sword, 0
draw_weapon_rank_at 1, 3, Lance, 1
draw_weapon_rank_at 1, 5, Axe, 2
draw_weapon_rank_at 1, 7, Bow, 3
b Page3RanksMid
.ltorg
Page3RanksMid:
draw_weapon_rank_at 1, 9, Staff, 4
draw_weapon_rank_at 1, 11, Anima, 5
draw_weapon_rank_at 1, 13, Light, 6
draw_weapon_rank_at 1, 15, Dark, 7

b Page3Skills
.ltorg

Page3Skills:
mov r0, r8
ldr r1, =Skill_Getter
mov lr, r1
.short 0xf800
mov r6, r0

ldrb r0, [r6]
cmp r0, #0
bne Skill1Draw
b SkillEnd
Skill1Draw:
mov r5, r0
draw_skill_icon_at 21, 3
mov r0, r5
ldr r1, =SkillDescTable
lsl r0, #1
ldrh r0, [r1, r0]
cmp r0, #0
beq Skill2
draw_skillname_at 23, 3, width=7, colour=White

Skill2:
ldrb r0, [r6, #1]
cmp r0, #0
bne Skill2Draw
b SkillEnd
Skill2Draw:
mov r5, r0
draw_skill_icon_at 21, 5
mov r0, r5
ldr r1, =SkillDescTable
lsl r0, #1
ldrh r0, [r1, r0]
cmp r0, #0
beq Skill3
draw_skillname_at 23, 5, width=7, colour=White

Skill3:
ldrb r0, [r6, #2]
cmp r0, #0
bne Skill3Draw
b SkillEnd
Skill3Draw:
mov r5, r0
draw_skill_icon_at 21, 7
mov r0, r5
ldr r1, =SkillDescTable
lsl r0, #1
ldrh r0, [r1, r0]
cmp r0, #0
beq Skill4
draw_skillname_at 23, 7, width=7, colour=White
b Skill4
.ltorg

Skill4:
ldrb r0, [r6, #3]
cmp r0, #0
bne Skill4Draw
b SkillEnd
Skill4Draw:
mov r5, r0
draw_skill_icon_at 21, 9
mov r0, r5
ldr r1, =SkillDescTable
lsl r0, #1
ldrh r0, [r1, r0]
cmp r0, #0
beq Skill5
draw_skillname_at 23, 9, width=7, colour=White

Skill5:
ldrb r0, [r6, #4]
cmp r0, #0
bne Skill5Draw
b SkillEnd
Skill5Draw:
mov r5, r0
draw_skill_icon_at 21, 11
mov r0, r5
ldr r1, =SkillDescTable
lsl r0, #1
ldrh r0, [r1, r0]
cmp r0, #0
beq Skill6
draw_skillname_at 23, 11, width=7, colour=White

Skill6:
ldrb r0, [r6, #5]
cmp r0, #0
bne Skill6Draw
b SkillEnd
Skill6Draw:
mov r5, r0
draw_skill_icon_at 21, 13
mov r0, r5
ldr r1, =SkillDescTable
lsl r0, #1
ldrh r0, [r1, r0]
cmp r0, #0
beq SkillEnd
draw_skillname_at 23, 13, width=7, colour=White

SkillEnd:
page_end

@ r0 = skill desc string; cut at the first ':' so only the name remains,
@ then remap letters to Bly narrow menu codes (same as TextProcess ^).
GetSkillNameFromSkillDesc:
	mov r3, r0
	sub r2, r0, #1
GetSkillNameFromSkillDesc.cut:
	add r2, #1
	ldrb r1, [r2]
	cmp r1, #0
	beq GetSkillNameFromSkillDesc.narrow
	cmp r1, #0x3A @ ':'
	bne GetSkillNameFromSkillDesc.cut
	mov r1, #0
	strb r1, [r2]
GetSkillNameFromSkillDesc.narrow:
	mov r2, r3
GetSkillNameFromSkillDesc.loop:
	ldrb r1, [r2]
	cmp r1, #0
	beq GetSkillNameFromSkillDesc.done
	cmp r1, #0x20
	blt GetSkillNameFromSkillDesc.next
	cmp r1, #0x7A
	bgt GetSkillNameFromSkillDesc.next
	sub r1, #0x20
	adr r0, NarrowMenuLut
	ldrb r1, [r0, r1]
	cmp r1, #0
	beq GetSkillNameFromSkillDesc.next
	strb r1, [r2]
GetSkillNameFromSkillDesc.next:
	add r2, #1
	b GetSkillNameFromSkillDesc.loop
GetSkillNameFromSkillDesc.done:
	mov r0, r3
	bx lr

.align 2
@ Index = char - 0x20. 0 = keep vanilla glyph. Matches NARROW_MENU_DICT.
NarrowMenuLut:
	.byte 0xBC, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x9B, 0x9C, 0x9D, 0x9E, 0x9F, 0xA0, 0xA2, 0xA3, 0x00, 0xA4, 0xA5, 0xA6, 0x00, 0x00, 0xA7
	.byte 0xA8, 0xA9, 0xAC, 0xAD, 0x00, 0xAE, 0xAF, 0x00, 0xB0, 0xB1, 0xB2, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x00, 0x89, 0x8A, 0x00, 0x00, 0x8B, 0x8C
	.byte 0x8D, 0x8E, 0x8F, 0x90, 0x00, 0x96, 0x97, 0x00, 0x98, 0x99, 0x9A

.ltorg
