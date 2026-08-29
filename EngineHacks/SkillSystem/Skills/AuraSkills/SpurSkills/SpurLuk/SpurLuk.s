@Spur Luk: adjacent allies gain +4 luck (+2 hit, +4 avoid, +4 dodge) in combat.
.equ SpurLukID, AuraSkillCheck+4
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
ldr r1, SpurLukID
mov r2, #0              @same faction
mov r3, #1              @range 1
.short 0xf800
cmp r0, #0
beq Done

@ add +2 hit
mov r0, r4
add r0, #0x60           @hit
ldrh r3, [r0]
add r3, #2
strh r3, [r0]

@ add +4 avoid
add r0, #2              @0x60 + 2 = 0x62 avoid
ldrh r3, [r0]
add r3, #4
strh r3, [r0]

@ add +4 dodge/crit avoid
add r0, #6              @0x62 + 6 = 0x68 dodge
ldrh r3, [r0]
add r3, #4
strh r3, [r0]

Done:
pop {r4-r7}
pop {r0}
bx r0
.align
.ltorg
AuraSkillCheck:
@ POIN AuraSkillCheck
@ WORD SpurLukID
