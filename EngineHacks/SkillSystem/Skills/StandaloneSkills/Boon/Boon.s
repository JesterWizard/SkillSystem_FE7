.thumb

@ FE7 TickActiveFactionTurn (0x08018300) duration tick at 0x08018390.
@ Incoming: r4 = unit, r3 = unit+0x30, r2 = status byte, r6 = 0xF0.
@ jumpToHack clobbers r3; the installer uses ldr r0 / mov pc instead.
@ Resume 0x0801839F: ands r0, r6 (r0 = stored status). Keep index nibble
@ so the vanilla recover FX can read it.

.equ BoonID, SkillTester+4

push {r2, r3}
mov r0, r4
ldr r1, BoonID
ldr r2, SkillTester
mov lr, r2
.short 0xF800
pop {r2, r3}
cmp r0, #0
beq VanillaDec

mov r0, #0xF
and r0, r2
cmp r0, #0xB
beq BoonPetrify
cmp r0, #0xD
bne BoonClear
BoonPetrify:
ldr r0, [r4, #0xC]
mov r1, #2
bic r0, r1
str r0, [r4, #0xC]
BoonClear:
mov r0, #0xF
and r0, r2
strb r0, [r3]
b BoonDone

VanillaDec:
lsr r1, r2, #4
sub r1, #1
lsl r1, #4
mov r0, #0xF
and r0, r2
orr r0, r1
strb r0, [r3]
cmp r1, #0
bne BoonDone
mov r0, #0xF
and r0, r2
cmp r0, #0xB
beq VanillaClearPetrify
cmp r0, #0xD
bne BoonDone
VanillaClearPetrify:
ldr r0, [r4, #0xC]
mov r1, #2
bic r0, r1
str r0, [r4, #0xC]

BoonDone:
ldrb r0, [r3]
ldr r1, =0x0801839F
bx r1

.ltorg
.align 4
SkillTester:
@POIN SkillTester
@WORD BoonID
