@ FE7 BattleInitTargetCanCounter (0x0802A1F4)
.equ DazzleID, SkillTester+4
.equ MoonlightID, DazzleID+4

.thumb
DazzleCheck:
push {r4-r7, lr}
ldr r4, =0x0203A3F0 @ gBattleActor
ldr r5, =0x0203A470 @ gBattleTarget

ldr r0, [r4, #0x4C]
ldr r1, [r5, #0x4C]
orr r0, r1
mov r1, #0x80 @ IA_UNCOUNTERABLE
and r0, r1
cmp r0, #0
bne DisableCounter

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, DazzleID
.short 0xf800
cmp r0, #0
bne DisableCounter

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, MoonlightID
.short 0xf800
cmp r0, #0
beq BerserkCheck

DisableCounter:
mov r0, r5
add r0, #0x48
mov r1, #0
strh r1, [r0]
add r0, #0x0A
strb r1, [r0]

BerserkCheck:
mov r1, r4
add r1, #0x30
mov r0, #0x0F
ldrb r1, [r1]
and r0, r1
cmp r0, #4 @ UNIT_STATUS_BERSERK
bne End
mov r0, #0x0B
ldrsb r0, [r4, r0]
mov r1, #0xC0
and r0, r1
cmp r0, #0
bne End
mov r2, #0x0B
ldrsb r2, [r5, r2]
and r2, r1
cmp r2, #0
bne End
mov r0, r5
add r0, #0x48
mov r1, #0
strh r1, [r0]
add r0, #0x0A
strb r1, [r0]

End:
pop {r4-r7}
pop {r0}
bx r0

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD DazzleID
@WORD MoonlightID
