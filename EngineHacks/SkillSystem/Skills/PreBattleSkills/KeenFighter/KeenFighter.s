.thumb
.align

.equ KeenFighterID,SkillTester+4
.equ gBattleData, 0x203A3D8

push {r4-r7,lr}
@goes in the battle loop.
@r0 is the attacker
@r1 is the defender
mov r4, r0
mov r5, r1

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, KeenFighterID
.short 0xf800
cmp r0, #0
beq   GoBack
//beq CheckDefender

@make sure we're in combat (or battle forecast)
ldrb r3, =gBattleData
ldrb r3, [r3]
cmp r3, #4
beq GoBack

ldr r4,=#0x203A3F0
ldr r5,=#0x203A470
mov r1,#0x5E        @short for speed
ldrsh r2,[r4,r1]    @load the speed short value for the attacker
ldrsh r7,[r5,r1]    @load the speed short value for the defender
sub r6,r7,r2        @subtract the enemy's attack speed from the skill holder's

@Get the absolute value of the difference to account for negatives
asr r3, r6, #31
add r6, r6, r3
eor r6, r3
cmp r6,#4           @does the enemy double?
bge ReduceDamage
b   GoBack

ReduceDamage:
mov r1,#0x5A        @get the attack short
ldrsh r7,[r5,r1]    @load the attack short value for the enemy
mov r1,#0x5C        @now get the defense short
ldrsh r6,[r4,r1]    @load the skill holder's defense value
sub r0,r7,r6        @subtract the skill's holder's defense from the enemy's attack
cmp r0, #0
ble GoBack          @if the difference is less than or equal to 0, (the skill holder's defense is higher) then we have nothing more to do
asr r2,r0,#1        @otherwise, get half of the resulting attack value
asr r3,r2,#1        @half it again and store it in another register
add r2,r3           @add both together to get a quick and dirty 75%
sub r0,r2           @subtract the resulting attack value from the 75% we calculated to get 25%
add r6,r0           @add this 25% to the skill holder's defense value
strh r6,[r4,r1]     @store the new defense value for the skill holder

GoBack:
pop {r4-r7}
pop {r0}
bx r0

.ltorg
.align

SkillTester:
@POIN SkillTester
@WORD KeenFighterID
