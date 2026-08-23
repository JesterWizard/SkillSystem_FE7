@ Last remaining weapon use is a guaranteed crit.
@ r0 is attacker, r1 is defender
@ Feature, not a skill: no SkillTester.

.thumb

push {r4, lr}
mov r4, r0              @attacker

mov r0, #0x48           @equipped weapon
ldrh r0, [r4, r0]
cmp r0, #0
beq End
lsr r0, r0, #8          @uses
cmp r0, #1
bne End

mov r1, #0x66           @battle crit (signed halfword)
mov r0, #100
strh r0, [r4, r1]

End:
pop {r4}
pop {r0}
bx r0

.align
.ltorg
