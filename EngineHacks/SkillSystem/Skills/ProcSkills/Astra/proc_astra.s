.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ AstraID, SkillTester+4
.equ d100Result, 0x802857C

@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data
@
@ Extra hits: GetBattleUnitHitCount (FE7 r5). That hook also rolls Skill %
@ once per swing and sets BattleUnit+0x7F = 0x85. This file still holds the
@ original SkillTester + Skill % check for a one-hit proc if 0x7F is clear.
@ Do not write [r6,#4] (FE7 rounds are 4 bytes).
push {r4-r7,lr}
mov r4, r0 @attacker
mov r5, r1 @defender
mov r6, r2 @battle buffer
mov r7, r3 @battle data

mov r0, r4
add r0, #0x7F
ldrb r1, [r0]
mov r2, #0x80
tst r1, r2
bne AstraSwing

@check for Astra proc
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, AstraID
.short 0xf800
cmp r0, #0
beq End
@if user has Astra, check for proc rate
ldrb r0, [r4, #0x15] @skill stat as activation rate
mov r1, r4 @skill user
blh d100Result
cmp r0, #1
bne End

mov r5, #1 @stamp 0x4000
b CheckMiss

AstraSwing:
mov r3, #0x0F
and r3, r1 @remaining this swing
cmp r3, #5
beq FirstHit
mov r5, #0
b DecRemain
FirstHit:
mov r5, #1
DecRemain:
sub r3, #1
mov r2, #0x0F
bic r1, r2
orr r1, r3
cmp r3, #0
bne StoreRemain
mov r2, #0x80
bic r1, r2
StoreRemain:
strb r1, [r0]

CheckMiss:
ldr r0,[r6]
lsl r0,r0,#0xD
lsr r0,r0,#0xD
mov r1, #0xC0
lsl r1, #8
add r1, #0x2
tst r0, r1
bne End

mov r2, #4
ldrsh r3, [r7, r2]
asr r3, #1
strh r3, [r7, #4]

cmp r5, #1
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
@WORD AstraID
