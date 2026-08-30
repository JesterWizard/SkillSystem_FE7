.thumb

@ Hooked at 0804DD8C (efxHPBarLive HP apply). r5 = proc, r6 = AIS+0x60.
@ Vanilla only fills 0x203E0B8[recipient]. Also fill the other slot toward
@ gBattleActor+0x13 so both bars rise together. Resume 0804DDA9.

    .global LiveToServeHpBar
    .thumb_func
LiveToServeHpBar:
    ldr     r0, [r5, #0x48]
    ldrh    r1, [r5, #0x2E]
    add     r0, r1
    strh    r0, [r5, #0x2E]

    ldr     r0, [r5, #0x60]
    ldr     r3, =0x08054679
    bl      CallR3
    ldr     r1, =0x0203E0B8
    lsl     r0, #1
    add     r0, r1
    ldr     r1, [r5, #0x48]
    ldrh    r2, [r0]
    add     r1, r2
    strh    r1, [r0]

    ldr     r0, [r5, #0x60]
    ldr     r3, =0x08054679
    bl      CallR3
    mov     r1, #1
    eor     r0, r1
    ldr     r1, =0x0203E0B8
    lsl     r0, #1
    add     r0, r1
    ldrh    r2, [r0]
    ldr     r1, =0x0203A3F0
    ldrb    r1, [r1, #0x13]
    cmp     r2, r1
    bge     Done
    ldr     r3, [r5, #0x48]
    add     r2, r3
    cmp     r2, r1
    ble     StoreOther
    mov     r2, r1
StoreOther:
    strh    r2, [r0]
Done:
    ldr     r3, =0x0804DDA9
    bx      r3

CallR3:
    bx      r3

    .align
    .ltorg
