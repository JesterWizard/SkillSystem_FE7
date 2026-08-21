.thumb
@ Skill System personal data page (FE8-style Str/Mag layout)
.include "mss_defs.s"

.global MSS_page1
.type MSS_page1, %function

.set NoAltIconDraw, 1 @ DrawIcon + IconRework sheet 1 (SkillIcons)

MSS_page1:

page_start

@load the growth getters onto the stack, if needed
ldr r0,=Growth_Getter_Table
str		r0,[sp,#0xC]

ldr r0,=Display_Growth_Options_Link
ldr r0,[r0]
mov		r1,#0x10		@set if stat name color should reflect growth
and		r0,r1
mov		r1,r8
ldrb	r1,[r1,#0xB]
mov		r2,#0xC0
tst		r1,r2
beq		IsPlayerUnit
mov		r0,#0
IsPlayerUnit:
str		r0,[sp,#0x14]

draw_textID_at 13, 3, textID=TID_Str, growth_func=2 @str
draw_textID_at 13, 5, textID=TID_Mag, growth_func=3 @mag
draw_textID_at 13, 7, textID=TID_Skl, growth_func=4 @skl
draw_textID_at 13, 9, textID=TID_Spd, growth_func=5 @spd
draw_textID_at 13, 11, textID=TID_Luck, growth_func=6 @luck
draw_textID_at 13, 13, textID=TID_Def, growth_func=7 @def
draw_textID_at 13, 15, textID=TID_Res, growth_func=8 @res

b 	NoRescue
.ltorg
NoRescue:

ldr		r0,=StatScreenStruct
sub		r0,#1
mov		r1,r8
ldrb	r1,[r1,#0xB]
mov		r2,#0xC0
tst		r1,r2
beq		Label2
ldrb	r1,[r0]
mov		r2,#0xFE
and		r1,r2
strb	r1,[r0]			@don't display enemy growths
Label2:
ldrb	r0,[r0]
mov		r1,#1
tst		r0,r1
beq		ShowStats
b		ShowGrowths

ShowStats:
b		ShowStats2


ShowGrowths:
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#4]		@str growth getter
draw_growth_at 18, 3
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#8]		@mag growth getter (USE_STRMAG_SPLIT)
draw_growth_at 18, 5
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#12]		@skl
draw_growth_at 18, 7
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#16]		@spd
draw_growth_at 18, 9
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#20]		@luk
draw_growth_at 18, 11
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#24]		@def
draw_growth_at 18, 13
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#28]		@res
draw_growth_at 18, 15
ldr		r0,[sp,#0xC]
ldr		r0,[r0]			@hp
draw_growth_at 18, 17
draw_textID_at 13, 17, textID=TID_HP, growth_func=1 @hp name
b		NextColumn
.ltorg

ShowStats2:
b		ShowStats3

NextColumn:

draw_textID_at 21, 3, textID=TID_Con @con
draw_con_bar_at 24, 3
draw_con_number_at 24, 3

draw_textID_at 21, 5, textID=TID_Aid @aid
draw_number_at 25, 5, 0x8018450, 2 @aid getter
draw_aid_icon_at 26, 5

draw_status_text_at 21, 7

ldr r0,=AffinTextIDLink
ldrh r0,[r0]
draw_textID_at 21, 9, width=8 @affin

draw_affinity_icon_at 24, 9


ldr r0,=TalkTextIDLink
ldrh r0,[r0]
draw_talk_text_at 21, 11

ldr r0,=SkillsTextIDLink
ldrh r0, [r0]
draw_textID_at 21, 13, width=8, colour=White @skills

Nexty:

b skipliterals
.ltorg

ShowStats3:
draw_str_bar_at 16, 3
draw_str_number_at 16, 3
draw_mag_bar_at 16, 5
draw_mag_number_at 16, 5
draw_skl_bar_at 16, 7
draw_skl_number_at 16, 7
draw_spd_bar_at 16, 9
draw_spd_number_at 16, 9
draw_luck_bar_at 16, 11
draw_luck_number_at 16, 11
draw_def_bar_at 16, 13
draw_def_number_at 16, 13
draw_res_bar_at 16, 15
draw_res_number_at 16, 15
draw_textID_at 13, 17, TID_Move @move
draw_move_bar_at 16, 17
draw_move_number_at 16, 17

b		NextColumn
.ltorg

skipliterals:

mov r0, r8
ldr r1, =Skill_Getter
mov lr, r1
.short 0xf800 @skills now stored in the skills buffer

mov r6, r0
ldrb r0, [r6]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 21, 15

ldrb r0, [r6,#1]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 24, 15

ldrb r0, [r6, #2]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 27, 15

ldrb r0, [r6, #3]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 21, 17

ldrb r0, [r6, #4]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 24, 17

ldrb r0, [r6, #5]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 27, 17

SkillEnd:

ldr		r0,=StatScreenStruct
sub		r0,#0x2
ldrb	r0,[r0]
cmp		r0,#0x0
beq		DoNotUpdate
ldr		r0,=BgBitfield
ldrb	r1,[r0]
mov		r2,#0x5
orr		r1,r2
strb	r1,[r0]
ldr		r0,=BgMapFillRect
mov		r14,r0
ldr		r0,=Const_2003D2C
ldr		r1,=Const_2022D40
mov		r2,#0x12
mov		r3,#0x12
.short	0xF800
ldr		r0,=BgMapFillRect
mov		r14,r0
ldr		r0,=Const_200472C
ldr		r1,=Const_2023D40
mov		r2,#0x12
mov		r3,#0x12
.short	0xF800
ldr		r0,=StatScreenStruct
sub		r0,#0x2
mov		r1,#0x0
strb	r1,[r0]
b DoNotUpdate
.ltorg

DoNotUpdate:
page_end

.ltorg

Restore_Palette:
@r0=thing to store back, r1=0 if we can skip this
cmp		r1,#0
beq		RestoreDone
cmp		r0,#0
beq		RestoreDone
ldr		r1,Const2_2028E70
ldr		r1,[r1]
strh	r0,[r1,#0x10]
RestoreDone:
bx		r14

.align
Const2_2028E70:
.long 0x02028D70

@ Mag at unit+0x47 via MSG MagGetter.
.global MagDisplayGetter
MagDisplayGetter:
push	{r14}
blh		MagGetter
pop		{r1}
bx		r1

.include "GetTalkee.s"

.ltorg
