.thumb
.align

.global prIndoorMarch
.type prIndoorMarch, %function

prIndoorMarch:
push {r4-r5,r14}
mov r4, r0
mov r5, r1

ldr r0, =SkillTester
mov r14, r0
mov r0, r5
mov r1, #211                    @ IndoorMarchID
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
adr r1, IndoorTerrainList
MarchLoop:
ldrb r2, [r1]
cmp r2, #0
beq GoBack
cmp r2, r0
beq YesMarch
add r1, #1
b MarchLoop

YesMarch:
add r4, #2

GoBack:
mov r0, r4
mov r1, r5
pop {r4-r5}
pop {r2}
bx r2

.ltorg
.align
IndoorTerrainList:
.byte 0x17, 0x18, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x22, 0x2D, 0x2E, 0x30, 0x38, 0x39, 0x3B, 0x3C, 0x3D, 0x3F
.byte 0
.align
