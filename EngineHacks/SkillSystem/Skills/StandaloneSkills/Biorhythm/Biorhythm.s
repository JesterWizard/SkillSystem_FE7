.thumb

@ Pre-battle: apply biorhythm hit/avo. Tempest doubles, Serenity halves.
@ r0 = attacker battle unit, r1 = defender (unused).

.equ TempestID, SkillTester+4
.equ SerenityID, TempestID+4
.equ BiorhythmTable, SerenityID+4
.equ ChapterData, 0x0202BBF8

.thumb
push {r4-r7, lr}
mov r5, r0

ldr r0, [r5]
cmp r0, #0
beq GoBack
ldrb r0, [r0, #4]
lsl r0, r0, #1
ldr r1, BiorhythmTable
add r1, r0
ldrb r2, [r1]
ldrb r3, [r1, #1]
mov r0, r2
orr r0, r3
cmp r0, #0
bne HaveParams
mov r2, #0
mov r3, #4
HaveParams:

ldr r0, =ChapterData
ldrh r0, [r0, #0x10]
mul r0, r3
lsr r0, #2
add r0, r2
Mod12:
cmp r0, #12
blt HavePhase
sub r0, #12
b Mod12

HavePhase:
@ phase in r0. Magnitudes: 10,7,5,0,5,7,10,7,5,0,7,10 with sign.
cmp r0, #3
beq GoBack
cmp r0, #9
beq GoBack

mov r4, #1
cmp r0, #3
bls NegativePhase
cmp r0, #10
bge NegativePhase
b PositivePhase

NegativePhase:
mov r4, #0
@ fall through to magnitude by phase
PositivePhase:
cmp r0, #0
beq Mag10
cmp r0, #6
beq Mag10
cmp r0, #1
beq Mag7
cmp r0, #5
beq Mag7
cmp r0, #7
beq Mag7
cmp r0, #11
beq Mag7
cmp r0, #10
beq Mag7
b Mag5

Mag10:
mov r7, #10
b ScaleSkill
Mag7:
mov r7, #7
b ScaleSkill
Mag5:
mov r7, #5

ScaleSkill:
ldr r1, SerenityID
mov r0, r5
ldr r3, SkillTester
mov lr, r3
.short 0xF800
cmp r0, #0
beq CheckTempest
lsr r7, #1
b Apply
CheckTempest:
ldr r1, TempestID
mov r0, r5
ldr r3, SkillTester
mov lr, r3
.short 0xF800
cmp r0, #0
beq Apply
lsl r7, #1

Apply:
mov r2, r5
add r2, #0x60
ldrh r3, [r2]
cmp r4, #0
bne AddIt
sub r3, r7
b StoreHit
AddIt:
add r3, r7
StoreHit:
strh r3, [r2]
add r2, #2
ldrh r3, [r2]
cmp r4, #0
bne AddAvo
sub r3, r7
b StoreAvo
AddAvo:
add r3, r7
StoreAvo:
strh r3, [r2]

GoBack:
pop {r4-r7}
pop {r1}
bx r1

.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD TempestID
@WORD SerenityID
@POIN BiorhythmTable
