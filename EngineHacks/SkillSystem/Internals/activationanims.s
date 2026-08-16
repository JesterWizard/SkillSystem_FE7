.thumb
@ FE7 C03: play the skill BG only for this AIS's current round, and only
@ when that round's hit actually has a proc flag. No full-array scan.

.equ GetAISLayerId,           0x08054665
.equ GetAnimPosition,         0x08054679
.equ NewEfxSkillType01BG,     0x0805889D
.equ NewEfxSkillCommonBG,     0x08058589
.equ NewEfxSpecalEffect,      0x0806337D
.equ gAnimRoundData,          0x0203E036
.equ C03_Wait,                0x080536A5

.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

SkillActivationAnims:
    ldrh r1, [r7, #0x10]
    mov r2, #0x20
    tst r1, r2
    bne ToWait

    orr r1, r2
    strh r1, [r7, #0x10]

    push {r4, r5, r6, lr}
    mov r4, r7
    mov r0, r4
    blh GetAISLayerId
    cmp r0, #0
    bne PopToWait

    ldrh r5, [r4, #0xE]
    cmp r5, #0
    beq RoundZero
    sub r5, #1
RoundZero:
    lsl r5, #1
    mov r0, r4
    blh GetAnimPosition
    add r0, r5
    lsl r0, #1
    ldr r1, =gAnimRoundData
    add r1, r0
    ldrh r6, [r1]

    mov r0, #0xFF
    and r0, r6
    cmp r0, #4
    blo TryOffensive
    cmp r0, #9
    beq TryOffensive
    mov r0, #0x40
    lsl r0, #4
    tst r6, r0
    bne DoDefensive
    b DoSpecal

TryOffensive:
    mov r0, #0x80
    lsl r0, #4
    tst r6, r0
    bne DoOffensive
    b DoSpecal

DoOffensive:
    mov r0, r4
    blh NewEfxSkillType01BG
    b PopToWait

DoDefensive:
    mov r0, r4
    blh NewEfxSkillCommonBG
    b PopToWait

DoSpecal:
    mov r0, r4
    blh NewEfxSpecalEffect

PopToWait:
    pop {r4, r5, r6}
    pop {r3}
    mov lr, r3

ToWait:
    ldrh r1, [r7, #0x10]
    ldr r3, =C03_Wait
    bx r3

    .align
    .ltorg
