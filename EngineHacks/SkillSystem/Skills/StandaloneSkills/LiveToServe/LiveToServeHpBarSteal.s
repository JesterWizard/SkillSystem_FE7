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

.equ HitMaxHp,  0x0203E0BC

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
    mov     r2, r9
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
    mov     r2, r9
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    cmp     r1, #0
    bge     StealAAdd
    neg     r1, r1
StealAAdd:
    add     r0, r0, r1
    ldr     r3, =0x08053081
    bx      r3

@ ---------------------------------------------------------------------------
@ Taker, path B (position 0). Replaces 0x080530B0..0x080530B7:
@     movs r1,#3 / ldrsb r1,[r2,r1] / subs r0,r0,r1 / lsls r0,r0,#16
@ Resume 0x080530B9 (lsrs r2,r0,#16).
    .thumb_func
LiveToServeTakeB:
    mov     r2, r9
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
    mov     r2, r9
    mov     r1, #3
    ldrsb   r1, [r2, r1]
    cmp     r1, #0
    bge     StealBAdd
    neg     r1, r1
StealBAdd:
    add     r0, r0, r1
    ldr     r3, =0x080530E1
    bx      r3

    .align
    .ltorg
