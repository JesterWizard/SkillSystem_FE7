.thumb
.align

.global prNatureRush
.type prNatureRush, %function

prNatureRush:
push {r4-r5,r14}
mov r4, r0
mov r5, r1

ldr r0, =SkillTester
mov r14, r0
mov r0, r5
mov r1, #212                    @ NatureRushID
.short 0xF800
cmp r0, #0
beq GoBack

ldrb r0, [r5, #0x10]
ldrb r1, [r5, #0x11]
lsl r1, #2
ldr r2, =0x202E3E0
ldr r2, [r2]
ldr r2, [r2, r1]
ldrb r0, [r2, r0]
adr r1, NatureRushList
RushLoop:
ldrb r2, [r1]
cmp r2, #0
beq GoBack
cmp r2, r0
beq YesRush
add r1, #1
b RushLoop

YesRush:
add r4, #2

GoBack:
mov r0, r4
mov r1, r5
pop {r4-r5}
pop {r2}
bx r2

.ltorg
.align
NatureRushList:
.byte 0x01, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x14, 0x15
.byte 0
.align
