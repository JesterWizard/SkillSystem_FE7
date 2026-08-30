.thumb

@ HPSTEAL LUT fill does HP += hpChange for the stealer.
@ Staff heal stores negative hpChange, so that drains the healer bar.
@ Add abs(hpChange) instead: Nosferatu (positive) unchanged, heal fills.

    .global LiveToServeHpAbsAdd
    .global LiveToServeHpAbsAdd2
    .thumb_func
LiveToServeHpAbsAdd:
    mov     r2, r9
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    cmp     r1, #0
    bge     Add1
    neg     r1, r1
Add1:
    add     r0, r1
    ldr     r3, =0x08053081
    bx      r3

    .thumb_func
LiveToServeHpAbsAdd2:
    mov     r2, r9
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    cmp     r1, #0
    bge     Add2
    neg     r1, r1
Add2:
    add     r0, r1
    ldr     r3, =0x080530E1
    bx      r3

    .align
    .ltorg
