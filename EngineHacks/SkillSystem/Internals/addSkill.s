.thumb
@ r0 = unit, r1 = skill id
@ Learned skills in unit->supports[]. Players: 7 slots. Non-players: 6 (keep leader at [6]).
.set UNIT_SUPPORTS, 0x32
.set LEARNED_SKILL_COUNT_PLAYER, 7
.set LEARNED_SKILL_COUNT_OTHER, 6

push {r4-r6,lr}

mov r6, r0 @ unit
mov r5, r1 @ skill

ldrb r1, [r6, #0x0B]
mov r2, #0xC0
and r1, r2
cmp r1, #0
bne OtherMax
mov r3, #LEARNED_SKILL_COUNT_PLAYER
b HaveMax
OtherMax:
mov r3, #LEARNED_SKILL_COUNT_OTHER

HaveMax:
mov r4, r6
add r4, #UNIT_SUPPORTS
mov r2, #0
LoopStart:
ldrb r1, [r4, r2]
cmp r1, r5
beq False
cmp r1, #0
bne NextLoop
strb r5, [r4, r2]
b True

NextLoop:
add r2, #1
cmp r2, r3
blt LoopStart

mov  r1, #0x80
lsl  r1, #8
orr  r1, r5
ldr  r0, =0x202BBE6
strh r1, [r0]

True:
mov r0, #1
b End

False:
mov r0, #0

End:
pop {r4-r6}
pop {r1}
bx r1
