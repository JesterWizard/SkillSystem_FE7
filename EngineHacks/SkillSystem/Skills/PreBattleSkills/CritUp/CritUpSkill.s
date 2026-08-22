@crit up skill, does pretty much the same as vanilla one but calls skill tester to make nihil easier
@character/class ability crit up (ability 1 value 0x40) no longer gives crit +15
@r0 is attacker (skill user), r1 is defender

.equ CritUpID, SkillTester+4

.thumb

push {r4-r7, lr}
mov r4, r0              @skill user
mov r5, r1              @defender

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, CritUpID
.short 0xf800
cmp r0, #0
beq End

@battle crit is a signed halfword at +0x66
mov r1, #0x66
ldrh r0, [r4, r1]
add r0, #15
strh r0, [r4, r1]

End:
pop {r4-r7}
pop {r0}
bx r0

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD CritUpID
