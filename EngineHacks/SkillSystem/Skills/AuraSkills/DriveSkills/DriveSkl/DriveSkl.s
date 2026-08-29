@Drive Skl: allies within 2 spaces gain +4 skill (+8 hit, +2 crit) in combat.
.equ DriveSklID, AuraSkillCheck+4
.thumb
push {r4-r7,lr}
@goes in the battle loop.
@r0 is the attacker
@r1 is the defender
mov r4, r0
mov r5, r1

CheckSkill:
@now check for the skill
ldr r0, AuraSkillCheck
mov lr, r0
mov r0, r4              @attacker
ldr r1, DriveSklID
mov r2, #0              @same faction
mov r3, #2              @range 2
.short 0xf800
cmp r0, #0
beq Done

@ add +8 hit
mov r0, r4
add r0, #0x60           @hit
ldrh r3, [r0]
add r3, #8
strh r3, [r0]

@ add +2 crit
add r0, #6              @0x60 + 6 = 0x66 crit
ldrh r3, [r0]
add r3, #2
strh r3, [r0]

Done:
pop {r4-r7}
pop {r0}
bx r0
.align
.ltorg
AuraSkillCheck:
@ POIN AuraSkillCheck
@ WORD DriveSklID
