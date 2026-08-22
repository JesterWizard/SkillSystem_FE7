.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ AdeptID, SkillTester+4
.equ d100Result, 0x802857C

@ r0 is attacker, r1 is defender, r2 current buffer, r3 battle data
@ Extra Adept hit: GetBattleUnitHitCount (BattleUnit+0x7F remaining).
@ Speed % also lives here for a one-hit path if that pad is clear.
push {r4-r7,lr}
mov r4, r0
mov r5, r1
mov r6, r2
mov r7, r3

mov r0, r4
add r0, #0x7F
ldrb r1, [r0]
mov r2, #0x80           @Astra owns this swing
tst r1, r2
bne End
cmp r1, #0
beq OrigChance
sub r1, #1
strb r1, [r0]
cmp r1, #0
bne End
b StampSkill

OrigChance:
ldr r0, SkillTester
mov lr, r0
mov r0, r4              @attacker data
ldr r1, AdeptID
.short 0xf800
cmp r0, #0
beq End
@if user has Adept, check for proc rate
ldrb r0, [r4, #0x16]    @speed stat as activation rate
mov r1, r4              @skill user
blh d100Result
cmp r0, #1
bne End

StampSkill:
ldr r0,[r6]
lsl r0,r0,#0xD
lsr r0,r0,#0xD
mov r1, #0xC0
lsl r1, #8
tst r0, r1
bne End

ldr r2,[r6]
lsl r1,r2,#0xD
lsr r1,r1,#0xD
mov r0, #0x40
lsl r0, #8
orr r1, r0
ldr r0,=#0xFFF80000
and r0,r2
orr r0,r1
str r0,[r6]

End:
pop {r4-r7}
pop {r15}

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD AdeptID
