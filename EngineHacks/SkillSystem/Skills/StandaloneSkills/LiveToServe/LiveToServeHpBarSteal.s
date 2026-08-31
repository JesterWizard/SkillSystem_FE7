.thumb

@ FE7 battle-anim HP-round LUT builder, 0x08052DE4..0x08053208.
@ Per hit it appends one round to 0x0203E062 (halfword[round*2 + position]).
@ GetHpRound (0x08053340) masks 0xFFF. The combat bar ctor 0x0804D5A4 spawns
@ only when round and round+1 differ, and its tick 0x0804D6A8 walks
@ 0x0203E0B8[position] one step at a time -- that is the visible HP.
@
@ An HPSTEAL hit (attributes 0x100) is the only shape that gives BOTH sides a
@ round, which is why it is the only thing that ever moved two bars at once:
@     taker    newHP = max(HP - hpChange, 0)          no upper cap
@     stealer  newHP = min(HP + hpChange, maxHP[pos]) no lower cap
@ Liquid Ooze (0x1000) keeps that dual-round shape so both bars tick.
@ Both sides use HP - |hpChange| (same direction). Finish may have left
@ hpChange negative; abs so the holder is not healed (HP - -N).
@
@ LiveToServe writes a NEGATIVE hpChange (-heal), so the taker already gains
@ (HP - -heal) but can overshoot max, and the stealer loses. Both are fixed
@ here for negative hpChange only; vanilla hits are always positive, so
@ Nosferatu and every normal drain keep their exact vanilla arithmetic.
@
@ r9 = current BattleHit (4 bytes, signed hpChange at +3).
@ maxHP per side: 0x0203E0BC + position*2.
@
@ Which side is taker and which is stealer depends on hit+2 bit 0x08 against
@ 0x0203E014, so both roles are patched and both compute HP + |hpChange|.
@ That makes the result independent of which unit the engine calls the
@ attacker for a staff hit.

    .equ HitMaxHp,           0x0203E0BC
    .equ LiquidOozeBarFlag,  0x0203AA01

    .global LiveToServeTakeA
    .global LiveToServeStealA
    .global LiveToServeTakeB
    .global LiveToServeStealB

@ ---------------------------------------------------------------------------
@ Taker, path A (position 1). Replaces 0x0805304C..0x08053053:
@     movs r1,#3 / ldrsb r1,[r5,r1] / subs r0,r0,r1 / lsls r0,r0,#16
@ Resume 0x08053055 (lsrs r2,r0,#16).
    .thumb_func
LiveToServeTakeA:
    ldr     r3, =LiquidOozeBarFlag
    ldrb    r3, [r3]
    cmp     r3, #0
    bne     TakeAOozeAbs
    mov     r2, r9
    ldrh    r3, [r2]
    mov     r1, #0x10
    lsl     r1, #8                  @ 0x1000 Liquid Ooze
    tst     r3, r1
    beq     TakeALive
TakeAOozeAbs:
    mov     r2, r9
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    cmp     r1, #0
    bge     TakeAOozeSub
    neg     r1, r1
TakeAOozeSub:
    sub     r0, r0, r1              @ both bars: drain |hpChange|
    cmp     r0, #0
    bge     TakeADone
    mov     r0, #0
    b       TakeADone
TakeALive:
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    sub     r0, r0, r1
    cmp     r1, #0
    bge     TakeADone
    ldr     r2, =HitMaxHp
    ldrh    r2, [r2, #2]
    cmp     r0, r2
    ble     TakeADone
    mov     r0, r2
TakeADone:
    lsl     r0, r0, #16
    ldr     r3, =0x08053055
    bx      r3

@ ---------------------------------------------------------------------------
@ Stealer, path A (position 0). Replaces 0x08053078..0x0805307F:
@     mov r2,r9 / movs r1,#3 / ldrsb r1,[r2,r1] / adds r0,r0,r1
@ Resume 0x08053081 (lsls r0,r0,#16); the vanilla max cap follows there.
    .thumb_func
LiveToServeStealA:
    ldr     r3, =LiquidOozeBarFlag
    ldrb    r3, [r3]
    cmp     r3, #0
    bne     StealAOozeAbs
    mov     r2, r9
    ldrh    r3, [r2]
    mov     r1, #0x10
    lsl     r1, #8                  @ 0x1000 Liquid Ooze
    tst     r3, r1
    beq     StealALive
StealAOozeAbs:
    mov     r2, r9
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    cmp     r1, #0
    bge     StealAOozeSub
    neg     r1, r1
StealAOozeSub:
    sub     r0, r0, r1              @ drain |hpChange|, same as taker
    cmp     r0, #0
    bge     StealAOut
    mov     r0, #0
    b       StealAOut
StealALive:
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    cmp     r1, #0
    bge     StealAAdd
    neg     r1, r1
StealAAdd:
    add     r0, r0, r1
StealAOut:
    ldr     r3, =0x08053081
    bx      r3

@ ---------------------------------------------------------------------------
@ Taker, path B (position 0). Replaces 0x080530B0..0x080530B7:
@     movs r1,#3 / ldrsb r1,[r2,r1] / subs r0,r0,r1 / lsls r0,r0,#16
@ Resume 0x080530B9 (lsrs r2,r0,#16).
    .thumb_func
LiveToServeTakeB:
    ldr     r3, =LiquidOozeBarFlag
    ldrb    r3, [r3]
    cmp     r3, #0
    bne     TakeBOozeAbs
    mov     r2, r9
    ldrh    r3, [r2]
    mov     r1, #0x10
    lsl     r1, #8
    tst     r3, r1
    beq     TakeBLive
TakeBOozeAbs:
    mov     r2, r9
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    cmp     r1, #0
    bge     TakeBOozeSub
    neg     r1, r1
TakeBOozeSub:
    sub     r0, r0, r1
    cmp     r0, #0
    bge     TakeBDone
    mov     r0, #0
    b       TakeBDone
TakeBLive:
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    sub     r0, r0, r1
    cmp     r1, #0
    bge     TakeBDone
    ldr     r2, =HitMaxHp
    ldrh    r2, [r2, #0]
    cmp     r0, r2
    ble     TakeBDone
    mov     r0, r2
TakeBDone:
    lsl     r0, r0, #16
    ldr     r3, =0x080530B9
    bx      r3

@ ---------------------------------------------------------------------------
@ Stealer, path B (position 1). Replaces 0x080530D8..0x080530DF.
@ Resume 0x080530E1 (lsls r0,r0,#16); the vanilla max cap follows there.
    .thumb_func
LiveToServeStealB:
    ldr     r3, =LiquidOozeBarFlag
    ldrb    r3, [r3]
    cmp     r3, #0
    bne     StealBOozeAbs
    mov     r2, r9
    ldrh    r3, [r2]
    mov     r1, #0x10
    lsl     r1, #8                  @ 0x1000 Liquid Ooze
    tst     r3, r1
    beq     StealBLive
StealBOozeAbs:
    mov     r2, r9
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    cmp     r1, #0
    bge     StealBOozeSub
    neg     r1, r1
StealBOozeSub:
    sub     r0, r0, r1
    cmp     r0, #0
    bge     StealBOut
    mov     r0, #0
    b       StealBOut
StealBLive:
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    cmp     r1, #0
    bge     StealBAdd
    neg     r1, r1
StealBAdd:
    add     r0, r0, r1
StealBOut:
    ldr     r3, =0x080530E1
    bx      r3

    .align
    .ltorg
