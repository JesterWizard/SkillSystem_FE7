.thumb
@ When the Sure Strike BG proc ends, set ANIM_BIT3_BLOCKEND so C03 can resume.
.equ BreakLoop,     0x08006651
.equ Proc_End,      0x080046A1
.equ gEfxSemaphore, 0x0201774C

.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

EfxSkillType01BG_Loop:
    push {r4, lr}
    mov r4, r0
    ldrh r0, [r4, #0x2C]
    add r0, #1
    strh r0, [r4, #0x2C]
    lsl r0, #16
    lsr r0, #16
    cmp r0, #0x28
    ble Ret

    ldr r0, [r4, #0x5C]
    ldrh r1, [r0, #0x10]
    mov r2, #0x40
    orr r1, r2
    strh r1, [r0, #0x10]

    ldr r0, [r4, #0x60]
    blh BreakLoop
    ldr r1, =gEfxSemaphore
    ldr r0, [r1]
    sub r0, #1
    str r0, [r1]
    mov r0, r4
    blh Proc_End

Ret:
    pop {r4}
    pop {r1}
    bx r1

    .align
    .ltorg
