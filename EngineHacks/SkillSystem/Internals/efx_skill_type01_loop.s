.thumb
@ Hook at 0x08058920 (efxElfireOBJ loop). Vanilla ends the OBJ after 0x28
@ frames but never BLOCKENDs C03 and never clears AIS hide bit 0x400.
@ Only the skill-splash path (gSkillEfxActive) does that; real Elfire
@ still uses the vanilla end.

.equ BreakLoop,       0x08006651
.equ Break6CLoop,     0x080046A1
.equ GetAnimPosition, 0x08054679
.equ gEfxSemaphore,   0x0201774C
.equ gSkillEfxActive, 0x0203F0FC
.equ gAISArray,       0x02000000

.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

EfxSkillType01BG_Loop:
    push {r4-r6, lr}
    mov r4, r0
    ldrh r0, [r4, #0x2C]
    add r0, #1
    strh r0, [r4, #0x2C]
    lsl r0, #16
    asr r0, #16
    cmp r0, #0x28
    ble Ret

    ldr r1, =gSkillEfxActive
    ldrb r0, [r1]
    cmp r0, #0
    beq VanillaEnd

    mov r0, #0
    strb r0, [r1]

    ldr r5, [r4, #0x5C]
    ldr r6, =gAISArray
    mov r0, r5
    blh GetAnimPosition
    lsl r0, #3
    add r0, r6
    ldr r2, [r0]
    ldrh r1, [r2, #0x10]
    mov r3, #0x40
    orr r1, r3
    strh r1, [r2, #0x10]

    mov r0, r5
    blh GetAnimPosition
    lsl r0, #1
    add r0, #1
    lsl r0, #2
    add r0, r6
    ldr r2, [r0]
    ldrh r1, [r2, #0x10]
    mov r3, #0x40
    orr r1, r3
    strh r1, [r2, #0x10]

    ldr r0, [r4, #0x60]
    ldr r1, [r0, #0x1C]
    ldr r2, =0xFFFFFBFF
    and r1, r2
    str r1, [r0, #0x1C]

VanillaEnd:
    ldr r0, [r4, #0x60]
    blh BreakLoop
    ldr r1, =gEfxSemaphore
    ldr r0, [r1]
    sub r0, #1
    str r0, [r1]
    mov r0, r4
    blh Break6CLoop

Ret:
    pop {r4-r6}
    pop {r1}
    bx r1

    .align
    .ltorg
