.thumb

@ efxHPBar parent: start/end from GetHpRound, delta = -1 if start > end.
@ HPSTEAL staff: healer LUT is 6 + (-10) = 0 (game over). On a staff drain,
@ set end = start + abs(hpChange) so 6 -> 16, same heal as the target.

    .global LiveToServeHpBarInvert
    .global LiveToServeHpBarInvert2
    .thumb_func
LiveToServeHpBarInvert:
    ldr     r3, =0x0804D649
    b       InvertBody

    .thumb_func
LiveToServeHpBarInvert2:
    ldr     r3, =0x0804D919

InvertBody:
    str     r0, [r6, #0x50]
    ldr     r1, [r6, #0x4C]
    ldr     r2, =0x0203A85C
    ldrb    r2, [r2, #0x11]
    cmp     r2, #3
    bne     Cmp
    cmp     r1, r0
    ble     Cmp
    ldr     r2, =0x0203A50C
    ldr     r2, [r2]
    mov     r0, #3
    ldrsb   r0, [r2, r0]
    cmp     r0, #0
    bge     AbsDone
    neg     r0, r0
AbsDone:
    cmp     r0, #0
    bne     AddHeal
    ldr     r0, [r6, #0x50]
    sub     r0, r1, r0
AddHeal:
    add     r0, r1
    str     r0, [r6, #0x50]
Cmp:
    cmp     r1, r0
    ble     Plus
    mov     r0, #1
    neg     r0, r0
    b       Store
Plus:
    mov     r0, #1
Store:
    str     r0, [r6, #0x48]
    bx      r3

    .align
    .ltorg
