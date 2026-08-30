.thumb
.align

.global Synchronize
.type Synchronize, %function

@ Called from ApplySeals while r6 = defender unit, r7 = attacker unit.
@ If a unit with Synchronize just received a status, copy it onto the other
@ unit when that unit has none.

Synchronize:
push {r4-r7, lr}

mov r4, r6
mov r5, r7
cmp r4, #0
beq SynchEnd
cmp r5, #0
beq SynchEnd

@ Attacker has Synchronize and a status, defender does not -> copy to defender.
ldr r0, =SkillTester
mov r14, r0
mov r0, r5
ldr r1, =SynchronizeIDLink
ldrb r1, [r1]
.short 0xF800
cmp r0, #0
beq CheckDefender

mov r3, #0x30
ldrb r0, [r5, r3]
mov r1, #0xF
and r0, r1
cmp r0, #0
beq CheckDefender
ldrb r1, [r4, r3]
mov r2, #0xF
and r1, r2
cmp r1, #0
bne CheckDefender
ldrb r0, [r5, r3]
strb r0, [r4, r3]

CheckDefender:
ldr r0, =SkillTester
mov r14, r0
mov r0, r4
ldr r1, =SynchronizeIDLink
ldrb r1, [r1]
.short 0xF800
cmp r0, #0
beq SynchEnd

mov r3, #0x30
ldrb r0, [r4, r3]
mov r1, #0xF
and r0, r1
cmp r0, #0
beq SynchEnd
ldrb r1, [r5, r3]
mov r2, #0xF
and r1, r2
cmp r1, #0
bne SynchEnd
ldrb r0, [r4, r3]
strb r0, [r5, r3]

SynchEnd:
pop {r4-r7}
pop {r0}
bx r0

.ltorg
.align
