.thumb
@ FE7 C03: nextRoundId is the current round (0 on the first C03, not yet +1).
@ Do not subtract 1 — that made Adept's extra strike read the first hit.
@ Also honor 0x4000 on the 4-byte hit array in case parse missed 0x0800.

.equ GetAISLayerId,           0x08054665
.equ GetAnimPosition,         0x08054679
.equ NewEfxSkillType01BG,     0x0805889D
.equ NewEfxSkillCommonBG,     0x08058589
.equ NewEfxSpecalEffect,      0x0806337D
.equ gAnimRoundData,          0x0203E036
.equ gBattleHitArray,         0x0203A4F0
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
    cmp r5, #6
    bhi DoSpecal
    lsl r5, #1
    mov r0, r4
    blh GetAnimPosition
    add r0, r5
    lsl r0, #1
    ldr r1, =gAnimRoundData
    add r1, r0
    ldrh r6, [r1]

    ldrh r5, [r4, #0xE]
    lsl r5, #2
    ldr r1, =gBattleHitArray
    add r1, r5
    ldr r1, [r1]

    ldrb r0, [r4, #0x12]
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
    mov r0, #0x40
    lsl r0, #8
    tst r1, r0
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
