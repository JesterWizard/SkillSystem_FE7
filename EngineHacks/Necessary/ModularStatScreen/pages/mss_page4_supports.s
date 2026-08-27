.thumb
@ Alternate page 4: support partners on the right, cumulative bonuses on the left.
.include "mss_defs.s"

.global MSS_page4
.type MSS_page4, %function
.global MSS_HelpPageSelect
.type MSS_HelpPageSelect, %function

.equ GetUnitSupportLevel, 0x08026695
.equ ApplyAffinitySupportBonuses, 0x080269B1
.equ InitSupportBonuses, 0x08026A09
.equ GetCharacterAffinityIcon, 0x08026B39
.equ GetSupportLevelUiChar, 0x08026B51
.equ GetCharacterData, 0x08018D39
.equ PageBg0, 0x020031A4

MSS_page4:

page_start

@ tile_origin x=13 is the left column of the right panel (page 1 Str).
ldr r0, =BonusTextIDLink
ldrh r0, [r0]
draw_textID_at 13, 3, width=6, colour=White

ldr r0, =AtkShortTextIDLink
ldrh r0, [r0]
draw_textID_at 13, 5, width=6, colour=White

draw_textID_at 13, 7, textID=TID_Def, width=6, colour=White

ldr r0, =HitShortTextIDLink
ldrh r0, [r0]
draw_textID_at 13, 9, width=6, colour=White
b Page4LabelsMid
.ltorg

Page4LabelsMid:
ldr r0, =AvoidTextIDLink
ldrh r0, [r0]
draw_textID_at 13, 11, width=6, colour=White

ldr r0, =CritShortTextIDLink
ldrh r0, [r0]
draw_textID_at 13, 13, width=6, colour=White

ldr r0, =DdgTextIDLink
ldrh r0, [r0]
draw_textID_at 13, 15, width=6, colour=White

@ Cumulative bonuses from every ranked support, ignoring map distance.
@ Partner list comes from Page4GetSupportData (Lyn-mode clones have NULL pSupportData).
add r0, sp, #0x40
blh InitSupportBonuses
mov r0, r8
bl Page4GetSupportData
str r0, [sp, #0x4C]
cmp r0, #0
beq Page4BonusDone
ldrb r6, [r0, #0x15]
cmp r6, #7
ble Page4BonusCountOk
mov r6, #7
Page4BonusCountOk:
mov r5, #0
Page4BonusLoop:
cmp r5, r6
bge Page4BonusDone
mov r0, r8
mov r1, r5
blh GetUnitSupportLevel
str r0, [sp, #0x48]
cmp r0, #0
beq Page4BonusNext
ldr r0, [sp, #0x4C]
ldrb r0, [r0, r5]
cmp r0, #0
beq Page4BonusNext
blh GetCharacterData
ldrb r1, [r0, #9]
add r0, sp, #0x40
ldr r2, [sp, #0x48]
blh ApplyAffinitySupportBonuses
Page4BonusNext:
add r5, #1
b Page4BonusLoop
Page4BonusDone:

add r4, sp, #0x40
ldrb r0, [r4, #1] @ Atk
draw_number_at 19, 5
ldrb r0, [r4, #2] @ Def
draw_number_at 19, 7
ldrb r0, [r4, #3] @ Hit
draw_number_at 19, 9
ldrb r0, [r4, #4] @ Avoid
draw_number_at 19, 11
ldrb r0, [r4, #5] @ Crit
draw_number_at 19, 13
ldrb r0, [r4, #6] @ Ddg
draw_number_at 19, 15

b Page4SupportList
.ltorg

Page4SupportList:
ldr r0, [sp, #0x4C]
cmp r0, #0
beq Page4ListDone
ldrb r6, [r0, #0x15]
cmp r6, #7
ble Page4ListCountOk
mov r6, #7
Page4ListCountOk:
mov r5, #0
mov r4, #3
Page4ListLoop:
cmp r5, r6
bge Page4ListDone
ldr r0, [sp, #0x4C]
ldrb r0, [r0, r5]
cmp r0, #0
beq Page4ListNext
str r0, [sp, #0x44]
mov r0, r8
mov r1, r5
blh GetUnitSupportLevel
str r0, [sp, #0x48]
ldr r0, [sp, #0x44]

blh GetCharacterAffinityIcon
cmp r0, #0
ble Page4ListName
mov r1, r0
mov r2, #0x7A
sub r1, r2
mov r0, #2
lsl r0, #8
orr r1, r0
mov r2, #0xA0
lsl r2, r2, #0x7
ldr r0, =PageBg0
lsl r3, r4, #6
add r0, r3
add r0, #42 @ x=21
blh DrawIcon

Page4ListName:
ldr r0, [sp, #0x44]
blh GetCharacterData
ldrh r0, [r0]
mov r3, r7
mov r1, #8
ldrh r2, [r3]
add r2, r1
strb r1, [r3, #4]
strb r2, [r3, #8]
blh String_GetFromIndex
mov r2, #0
str r2, [sp]
str r0, [sp, #4]
mov r2, #White
mov r0, r7
ldr r1, =PageBg0
lsl r3, r4, #6
add r1, r3
add r1, #46 @ x=23
mov r3, #0
blh DrawTextInline, r4
add r7, #8

ldr r0, [sp, #0x48]
cmp r0, #0
beq Page4ListAdvance
blh GetSupportLevelUiChar
mov r2, r0
ldr r0, [sp, #0x48]
cmp r0, #3
bne Page4RankBlue
mov r1, #Green
b Page4RankGo
Page4RankBlue:
mov r1, #Blue
Page4RankGo:
ldr r0, =PageBg0
lsl r3, r4, #6
add r0, r3
add r0, #56 @ x=28
blh DrawSpecialUiChar
Page4ListAdvance:
add r4, #2
cmp r4, #17
bgt Page4ListDone
Page4ListNext:
add r5, #1
b Page4ListLoop

Page4ListDone:
page_end

.ltorg

@ r0 = unit. SupportData* (ROM partners), with FE7 Lyn-mode clone fallback.
Page4GetSupportData:
	push {r4, r5, lr}
	ldr r0, [r0]
	cmp r0, #0
	beq Page4GetSupportData.fail
	mov r4, r0
	ldr r0, [r4, #0x2C]
	cmp r0, #0
	bne Page4GetSupportData.done
	ldrh r5, [r4]
	mov r4, #1
Page4GetSupportData.scan:
	mov r0, r4
	blh GetCharacterData
	ldrh r1, [r0]
	cmp r1, r5
	bne Page4GetSupportData.next
	ldr r1, [r0, #0x2C]
	cmp r1, #0
	beq Page4GetSupportData.next
	mov r0, r1
	b Page4GetSupportData.done
Page4GetSupportData.next:
	add r4, #1
	cmp r4, #0x45
	ble Page4GetSupportData.scan
Page4GetSupportData.fail:
	mov r0, #0
Page4GetSupportData.done:
	pop {r4, r5}
	pop {r1}
	bx r1

.ltorg

@ r4 = page index, r1 = gStatScreen, r5 = proc. Continue at vanilla str r0,[r1,#0x14].
MSS_HelpPageSelect:
	cmp r4, #0
	beq HelpPage0
	cmp r4, #1
	beq HelpPage1
	cmp r4, #2
	beq HelpPage2
	ldr r0, HelpPage4Ptr
	b HelpPageGo
HelpPage0:
	ldr r0, HelpPage0Ptr
	b HelpPageGo
HelpPage1:
	ldr r0, HelpPage1Ptr
	b HelpPageGo
HelpPage2:
	ldr r0, HelpPage2Ptr
HelpPageGo:
	ldr r3, HelpPageContinue
	bx r3
.align 2
HelpPage0Ptr:
	.word RText_Page1
HelpPage1Ptr:
	.word RText_Page2
HelpPage2Ptr:
	.word RText_Page3
HelpPage4Ptr:
	.word RText_Page4
HelpPageContinue:
	.word 0x0808153B
