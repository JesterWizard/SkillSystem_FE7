.thumb
.equ TraceID, SkillTester+4
.equ Skill_Getter, TraceID+4
.equ PersonalSkillTable, 0x8D006CC
@ lPersonalSkillTable  = EALiterals+0x00

push	{r4, lr}
mov	r4, r0 @attacker
mov	r5, r1 @defender
ldr	r0,=#0x203A3F0 //FE8 -> #0x203A4EC
cmp	r4,r0
bne	End

@For the attacker:
@check skill
ldr	r0, SkillTester
mov	lr, r0
mov	r0, r4
ldr	r1, TraceID
.short	0xf800
cmp	r0, #0
beq	Defender

@get enemy skills
ldr	r0, Skill_Getter
mov	lr, r0
mov	r0, r5
.short	0xf800
ldrb	r3,[r0]         @skill ID for first skill of enemy

/* This was my attempt to cheat the skill onto the user but it won't work as I'm trying to modify ROM data
ldr r1,=PersonalSkillTable @load the personal skill table address
ldr r2,=#0x203A470      @load the defender struct
ldr r2,[r2]             @get attacker character struct
ldrb r2,[r2,#0x4]        @get attacker character ID
ldrb r3,[r1,r2]         @store the skill ID of the enemy in the attacker's personal skill table

ldr r2,=#0x203A3F0      @load the attacker struct
ldr r2,[r2]             @get attacker character struct
ldrb r2,[r2,#0x4]        @get attacker character ID
strb r3,[r1,r2]         @store the skill ID of the enemy in the attacker's personal skill table

*/

ldr	r1,=#0x203FFF0 //FE8 -> #0x30004E4
mov	r2,#0

LoopAttacker:
ldrb	r0,[r1,r2]
cmp	r0,#0
beq	StoreAttacker
add	r2,#1
cmp	r2,#4
beq	Defender
b	LoopAttacker

StoreAttacker:
strb	r3,[r1,r2]


@This divides the checks for both the attacker and defender having the Trace skill


@For the defender:
@check skill
Defender:
ldr	r0, SkillTester
mov	lr, r0
mov	r0, r5
ldr	r1, TraceID
.short	0xf800
cmp	r0, #0
beq	End

@get enemy skills
ldr	r0, Skill_Getter
mov	lr, r0
mov	r0, r4
.short	0xf800
ldrb	r3,[r0] //skill ID for first skill of enemy
ldr	r1,=#0x203FFF4 //FE8 -> #0x30004E8
mov	r2,#0

LoopDefender:
ldrb	r0,[r1,r2]
cmp	r0,#0
beq	StoreDefender
add	r2,#1
cmp	r2,#4
beq	End
b	LoopDefender

StoreDefender:
strb	r3,[r1,r2]

End:
pop	{r4, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD TraceID
@POIN Skill_Getter

EALiterals:
	@ POIN lPersonalSkillTable
	@ POIN lClassSkillTable
	@ POIN (GetInitialSkillList|1)
