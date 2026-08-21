.thumb
.equ SteadyBrawlerID, SkillTester+4
.equ gBattleData, 0x203A3D8
.equ DoublingThreshold, 4

@ Steady Brawler: -25% damage while doubling, +25% when not.

push {r4-r7, lr}
mov r4, r0 @attacker
mov r5, r1 @defender

cmp r5, #0
beq GoBack

ldr r3, =gBattleData
ldrb r3, [r3]
cmp r3, #4
beq GoBack

@stat screen / UI stats have no live defender
ldr r1, [r5, #4]
cmp r1, #0
beq GoBack

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, SteadyBrawlerID
.short 0xf800
cmp r0, #0
beq GoBack

mov r1, #0x5E
ldrsh r2, [r4, r1] @attacker AS
ldrsh r3, [r5, r1] @defender AS
sub r6, r2, r3
cmp r6, #DoublingThreshold
blt AddDamage

@doubling: subtract 25% of current damage
mov r1, #0x5A
ldrsh r2, [r4, r1] @atk
mov r1, #0x5C
ldrsh r3, [r5, r1] @def
sub r0, r2, r3
cmp r0, #0
ble GoBack
lsr r0, r0, #2 @dmg/4
mov r1, #0x5A
ldrsh r2, [r4, r1]
sub r2, r0
strh r2, [r4, r1]
b GoBack

AddDamage:
mov r1, #0x5A
ldrsh r2, [r4, r1]
mov r1, #0x5C
ldrsh r3, [r5, r1]
sub r0, r2, r3
cmp r0, #0
ble GoBack
add r0, #2
lsr r0, r0, #2 @(dmg+2)/4
mov r1, #0x5A
ldrsh r2, [r4, r1]
add r2, r0
strh r2, [r4, r1]

GoBack:
pop {r4-r7}
pop {r0}
bx r0

.ltorg
.align

SkillTester:
@POIN SkillTester
@WORD SteadyBrawlerID
