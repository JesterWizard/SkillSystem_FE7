.thumb

@ FE8 proc_stealhp leaves signed hpChange in the hit (byte 5 there).
@ FE7 BattleGenerateHitEffects then does ldrh damage / strb [hit,#3] at
@ 0x08029496, which turns Ooze's -N back into +damage. The LUT and Resire
@ then treat Nosferatu as a heal again. Skip that store when the hit is
@ already Ooze (0x1000, flag, or 0x100 with a negative hpChange).
@
@ Hook 0x08029490 (4-aligned). Overwrites:
@   ldr r1, [r2] / ldr r0, =gBattleStats / ldrh r0, [r0, #4] / strb [r1,#3]
@ Armsthrift at 0x08029498 is unchanged. r2 = &gpCurrentRound must survive.

    .global KeepHpChange
    .thumb_func
KeepHpChange:
    ldr     r1, [r2]
    ldr     r0, =0x0203A3D8
    ldrh    r0, [r0, #4]
    push    {r2}
    ldr     r2, [r1]
    mov     r3, #0x10
    lsl     r3, #8                  @ 0x1000
    tst     r2, r3
    bne     KeepSkip
    ldr     r3, =0x0203AA01
    ldrb    r3, [r3]
    cmp     r3, #0
    bne     KeepSkip
    mov     r3, #0x1
    lsl     r3, #8                  @ 0x100
    tst     r2, r3
    beq     KeepStore
    asr     r3, r2, #24             @ signed hpChange
    cmp     r3, #0
    blt     KeepSkip
KeepStore:
    strb    r0, [r1, #3]
KeepSkip:
    pop     {r2}
    ldr     r3, =0x08029499
    bx      r3

    .align
    .ltorg
