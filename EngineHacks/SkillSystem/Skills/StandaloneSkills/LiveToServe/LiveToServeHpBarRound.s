.thumb

@ FE7 battle-anim HP-round LUT builder, 0x08052DE4..0x08053208.
@ Each hit appends one round to the LUT: halfword[round*2 + position].
@ GetHpRound (0x08053340) masks 0xFFF. The bar ctor 0x0804D5A4 spawns a bar
@ for a position only when its round and round+1 differ, then the tick walks
@ 0x0203E0B8[position] between them. So a side with no round never animates.
@
@ The LUT always applies hit.hpChange to the RECIPIENT (HP - hpChange).
@ Staff heals store negative hpChange, so the target bar rises. Combat
@ Counter must not use that field -- it would tick the Counter unit.
@
@ This hook appends a round for the OTHER position from a signed flag:
@   +N  Live to Serve healer gain (display only)
@ Real HP is written elsewhere; HPSTEAL is not used. Liquid Ooze dual-bar
@ drain is the HPSTEAL path (LiveToServeHpBarSteal), not this extra round.
@
@ The flag is consumed here so a stale value cannot survive into the next
@ combat. 0 means neither skill published a delta.
@
@ At both hook sites r1 already holds the LUT base (the build relocates it,
@ so it must not be hardcoded) and r7 / r8 are the position 0 / position 1
@ round counters. maxHP per side is at 0x0203E0BC + position*2.

.equ LiveToServeHealFlag, 0x0203AA02
.equ HpRoundMax,          0x0203E0BC
.equ HpRoundMask,         0xFFF

    .global LiveToServeRoundA
    .global LiveToServeRoundB

@ ---------------------------------------------------------------------------
@ Recipient is position 1, so the healer is position 0 (counter r7).
@ Replaces 0x0805314C..0x08053153:
@     strh r2,[r0] / movs r0,#0x40 / mov r2,r9 / ldrh r2,[r2]
@ Resume 0x08053155 (ands r0,r2).
    .thumb_func
LiveToServeRoundA:
    strh    r2, [r0]

    ldr     r3, =LiveToServeHealFlag
    mov     r2, #0
    ldrsb   r2, [r3, r2]
    cmp     r2, #0
    beq     RoundADone
    mov     r0, #0
    strb    r0, [r3]

    lsl     r0, r7, #1              @ halfword index of round r7, position 0
    lsl     r0, r0, #1
    add     r0, r0, r1
    ldrh    r0, [r0]
    ldr     r3, =HpRoundMask
    and     r0, r3
    add     r0, r0, r2              @ signed: +heal / -drain
    cmp     r0, #0
    bge     RoundAFloor
    mov     r0, #0
RoundAFloor:
    ldr     r3, =HpRoundMax
    ldrh    r3, [r3]
    cmp     r0, r3
    ble     RoundANoCap
    mov     r0, r3
RoundANoCap:
    add     r7, #1
    lsl     r3, r7, #1
    lsl     r3, r3, #1
    add     r3, r3, r1
    strh    r0, [r3]

RoundADone:
    mov     r0, #0x40
    mov     r2, r9
    ldrh    r2, [r2]
    ldr     r3, =0x08053155
    bx      r3

@ ---------------------------------------------------------------------------
@ Recipient is position 0, so the healer is position 1 (counter r8).
@ Replaces 0x080531B0..0x080531B7, same four instructions.
@ Resume 0x080531B9.
    .thumb_func
LiveToServeRoundB:
    strh    r2, [r0]

    ldr     r3, =LiveToServeHealFlag
    mov     r2, #0
    ldrsb   r2, [r3, r2]
    cmp     r2, #0
    beq     RoundBDone
    mov     r0, #0
    strb    r0, [r3]

    mov     r0, r8                  @ halfword index of round r8, position 1
    lsl     r0, r0, #1
    add     r0, #1
    lsl     r0, r0, #1
    add     r0, r0, r1
    ldrh    r0, [r0]
    ldr     r3, =HpRoundMask
    and     r0, r3
    add     r0, r0, r2
    cmp     r0, #0
    bge     RoundBFloor
    mov     r0, #0
RoundBFloor:
    ldr     r3, =HpRoundMax
    ldrh    r3, [r3, #2]
    cmp     r0, r3
    ble     RoundBNoCap
    mov     r0, r3
RoundBNoCap:
    mov     r3, r8
    add     r3, #1
    mov     r8, r3
    lsl     r3, r3, #1
    add     r3, #1
    lsl     r3, r3, #1
    add     r3, r3, r1
    strh    r0, [r3]

RoundBDone:
    mov     r0, #0x40
    mov     r2, r9
    ldrh    r2, [r2]
    ldr     r3, =0x080531B9
    bx      r3

    .align
    .ltorg
