.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

@ FE8 efxHpBarLive_parent at 0x8052A50, FE7 addresses.
@ Hooked at 0804DCE0 after AIS +0x5C/+0x60 are stored. r6 = proc.
@ Halfwords: recip 0x4C/0x50/0x48/0x2E, healer 0x4E/0x52/0x4A/0x30.

    .global LiveToServeHpBarParent
    .thumb_func
LiveToServeHpBarParent:
    ldr     r4, =0x0203E05E
    ldr     r0, [r6, #0x60]
    blh     0x08054679
    lsl     r0, #1
    add     r0, r4
    mov     r1, #0
    ldrsh   r5, [r0, r1]
    add     r4, r5, #1
    lsl     r4, #0x10
    lsr     r4, #0x10
    ldr     r0, [r6, #0x60]
    blh     0x08054679
    lsl     r5, #1
    add     r5, r0
    mov     r0, r5
    blh     0x08053341
    lsl     r0, #0x10
    asr     r0, #0x10
    mov     r1, #0x4C
    strh    r0, [r6, r1]
    ldr     r0, [r6, #0x60]
    blh     0x08054679
    lsl     r4, #0x10
    asr     r4, #0xF
    add     r4, r0
    mov     r0, r4
    blh     0x08053341
    lsl     r0, #0x10
    asr     r0, #0x10
    mov     r1, #0x50
    strh    r0, [r6, r1]
    mov     r1, #0x4C
    ldrh    r1, [r6, r1]
    cmp     r1, r0
    ble     RecipHeal
    mov     r0, #1
    neg     r0, r0
    b       RecipDelta
RecipHeal:
    mov     r0, #1
RecipDelta:
    mov     r1, #0x48
    strh    r0, [r6, r1]

    ldr     r4, =0x0203E05E
    ldr     r0, [r6, #0x5C]
    blh     0x08054679
    lsl     r0, #1
    add     r0, r4
    mov     r1, #0
    ldrsh   r5, [r0, r1]
    add     r4, r5, #1
    lsl     r4, #0x10
    lsr     r4, #0x10
    ldr     r0, [r6, #0x5C]
    blh     0x08054679
    lsl     r5, #1
    add     r5, r0
    mov     r0, r5
    blh     0x08053341
    lsl     r0, #0x10
    asr     r0, #0x10
    mov     r1, #0x4E
    strh    r0, [r6, r1]
    ldr     r0, [r6, #0x5C]
    blh     0x08054679
    lsl     r4, #0x10
    asr     r4, #0xF
    add     r4, r0
    mov     r0, r4
    blh     0x08053341
    lsl     r0, #0x10
    asr     r0, #0x10
    mov     r1, #0x52
    strh    r0, [r6, r1]
    mov     r1, #0x4E
    ldrh    r1, [r6, r1]
    cmp     r1, r0
    ble     Heal2
    mov     r0, #1
    neg     r0, r0
    b       Hurt2
Heal2:
    mov     r0, #1
Hurt2:
    mov     r1, #0x4A
    strh    r0, [r6, r1]

    ldr     r0, =0x0203A3F0
    ldrb    r1, [r0, #0x13]
    mov     r2, #0x72
    ldrb    r2, [r0, r2]
    mov     r3, #0x7F
    ldrb    r3, [r0, r3]
    cmp     r2, r1
    bne     UseInitial
    cmp     r3, #0
    beq     AfterHealer
    sub     r2, r1, r3
UseInitial:
    cmp     r2, r1
    beq     AfterHealer
    mov     r0, #0x4E
    strh    r2, [r6, r0]
    mov     r0, #0x52
    strh    r1, [r6, r0]
    mov     r0, #0x30
    strh    r2, [r6, r0]
    mov     r0, #1
    mov     r3, #0x4A
    strh    r0, [r6, r3]
    mov     r0, #0
    str     r0, [r6, #0x58]
    ldr     r0, [r6, #0x5C]
    blh     0x08054679
    ldr     r1, =0x0203E0B8
    lsl     r0, #1
    add     r1, r0
    mov     r0, #0x4E
    ldrh    r0, [r6, r0]
    strh    r0, [r1]
AfterHealer:
    mov     r1, #0
    strh    r1, [r6, #0x2C]
    mov     r0, #0x4C
    ldrh    r0, [r6, r0]
    strh    r0, [r6, #0x2E]
    mov     r0, #0x4E
    ldrh    r0, [r6, r0]
    strh    r0, [r6, #0x30]
    str     r1, [r6, #0x54]
    str     r1, [r6, #0x58]
    mov     r0, #0x4E
    ldrh    r0, [r6, r0]
    mov     r2, #0x52
    ldrh    r2, [r6, r2]
    cmp     r0, r2
    bne     CheckBothDone
    mov     r0, #0
    mov     r2, #0x4A
    strh    r0, [r6, r2]
CheckBothDone:
    mov     r0, #0x4C
    ldrh    r0, [r6, r0]
    mov     r2, #0x50
    ldrh    r2, [r6, r2]
    cmp     r0, r2
    bne     SkipDone
    mov     r0, #0x4E
    ldrh    r0, [r6, r0]
    mov     r2, #0x52
    ldrh    r2, [r6, r2]
    cmp     r0, r2
    bne     SkipDone
    mov     r0, #1
    str     r0, [r6, #0x58]
SkipDone:
    str     r7, [r6, #0x64]
    ldr     r0, [r6, #0x5C]
    blh     0x08054679
    ldr     r1, =0x02017780
    lsl     r0, #1
    add     r0, r1
    mov     r1, #2
    strh    r1, [r0]
    pop     {r4, r5, r6, r7}
    pop     {r0}
    bx      r0

    .align
    .ltorg
