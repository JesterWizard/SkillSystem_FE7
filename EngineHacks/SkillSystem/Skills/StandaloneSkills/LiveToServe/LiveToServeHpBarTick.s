.thumb

@ FE7 efxHPBar:
@   0x0804D6A8  hit apply (recipient). Sol/Ooze: also tick the other display.
@   0x0804D970  Resire loop 1 (holder, on hit). Do not copy onto the caster;
@               their bar ticks in loop 2 when the spell ends.
@   0x0804DA78  Resire loop 2. Freeze only if the LUT is still a heal.
@               Ooze LUT is a drain, so the caster drops here once.
@   0x0804DB00  Loop 3 apply. Same freeze as backup.
@   0x0806C610 / 0x0806C6E0  anims-off floating HP: skip the steal negate.

    .global LiveToServeHpBarTickMain
    .global LiveToServeHpBarTickResire
    .global LiveToServeHpBarResireHealSetup
    .global LiveToServeHpBarTickResireSteal
    .global TickMainDone
    .global TickResireDone
    .global TickSetupDone
    .global TickStealDone
    .global OozeOtherOut
    @ Not .global: backward bl to a global is an unpatched reloc in as+objcopy.
    .global MapHpSkipNegA
    .global MapHpSkipNegB
    .global MapHpADone
    .global MapHpBDone

    .equ GetAnimPosition,    0x08054679
    .equ FE7BattleHits,      0x0203F000
    .equ gpCurrentRound,     0x0203A50C
    .equ HpDisplay,          0x0203E0B8
    .equ LiquidOozeBarFlag,  0x0203AA01
    .equ OozeAttr,           0x1000
    .equ HpStealAttr,        0x100
    @ Spare word in efxHPBarResire (vanilla uses 0x48+). Loop 1 sets this
    @ so loop 2 can freeze if the RAM flag / hit copy is gone.
    .equ OozeProcMark,       0x44

@ ---------------------------------------------------------------------------
    .thumb_func
LiveToServeHpBarTickMain:
    ldr     r0, [r5, #0x48]
    ldrh    r1, [r5, #0x2E]
    add     r0, r1
    strh    r0, [r5, #0x2E]
    bl      OozeOtherBar
TickMainDone:
    ldr     r3, =0x0804D6B1
    bx      r3

@ ---------------------------------------------------------------------------
    .thumb_func
LiveToServeHpBarTickResire:
    mov     r1, #0
    strh    r1, [r5, #0x2C]
    ldr     r0, [r5, #0x48]
    ldrh    r1, [r5, #0x2E]
    add     r0, r1
    strh    r0, [r5, #0x2E]
TickResireDone:
    ldr     r3, =0x0804D979
    bx      r3

@ ---------------------------------------------------------------------------
@ Replaces 0x0804DA78..0x0804DA7F. Resume 0x0804DA91 (mov r0, r6).
@ r6 = proc.
    .thumb_func
LiveToServeHpBarResireHealSetup:
    push    {lr}
    ldr     r0, [r6, #OozeProcMark]
    cmp     r0, #0
    bne     SetupCheckHeal
    bl      OozeIsActive
    cmp     r0, #0
    beq     SetupVanilla
SetupCheckHeal:
    ldr     r0, [r6, #0x4C]
    ldr     r1, [r6, #0x50]
    cmp     r0, r1
    bge     SetupVanilla
    ldrh    r0, [r6, #0x2E]
    str     r0, [r6, #0x50]
    mov     r0, #0
    str     r0, [r6, #0x48]
    b       TickSetupDone
SetupVanilla:
    ldr     r1, [r6, #0x4C]
    ldr     r0, [r6, #0x50]
    cmp     r1, r0
    ble     SetupHeal
    mov     r0, #1
    neg     r0, r0
    b       SetupStore
SetupHeal:
    mov     r0, #1
SetupStore:
    str     r0, [r6, #0x48]
TickSetupDone:
    pop     {r1}
    ldr     r3, =0x0804DA91
    bx      r3

@ ---------------------------------------------------------------------------
    .thumb_func
LiveToServeHpBarTickResireSteal:
    push    {lr}
    bl      OozeFreezeHeal
    ldr     r0, [r5, #0x48]
    ldrh    r1, [r5, #0x2E]
    add     r0, r1
    strh    r0, [r5, #0x2E]
    pop     {r1}
TickStealDone:
    ldr     r3, =0x0804DB09
    bx      r3

@ ---------------------------------------------------------------------------
@ If Ooze and this proc is a heal, freeze so the caster bar cannot tick up.
@ A drain (start > final) is the spell-end drop; leave it alone.
    .thumb_func
OozeFreezeHeal:
    push    {lr}
    ldr     r0, [r5, #OozeProcMark]
    cmp     r0, #0
    bne     FreezeOoze
    bl      OozeIsActive
    cmp     r0, #0
    beq     FreezeDone
FreezeOoze:
    ldr     r0, [r5, #0x4C]
    ldr     r1, [r5, #0x50]
    cmp     r0, r1
    bge     FreezeDone
    ldrh    r0, [r5, #0x2E]
    str     r0, [r5, #0x50]
    mov     r0, #0
    str     r0, [r5, #0x48]
FreezeDone:
    pop     {r0}
    bx      r0

@ ---------------------------------------------------------------------------
    .thumb_func
OozeIsActive:
    push    {r2, r3, lr}
    ldr     r0, =LiquidOozeBarFlag
    ldrb    r0, [r0]
    cmp     r0, #0
    bne     OozeYes
    ldr     r0, =gpCurrentRound
    ldr     r0, [r0]
    cmp     r0, #0
    beq     ScanHits
    ldr     r0, [r0]
    bl      HitIsOoze
    cmp     r0, #0
    bne     OozeYes
ScanHits:
    ldr     r2, =FE7BattleHits
    mov     r3, #7
ScanLoop:
    ldr     r0, [r2]
    bl      HitIsOoze
    cmp     r0, #0
    bne     OozeYes
    add     r2, #4
    sub     r3, #1
    cmp     r3, #0
    bge     ScanLoop
OozeNo:
    mov     r0, #0
    b       OozeOut
OozeYes:
    mov     r0, #1
OozeOut:
    pop     {r2, r3}
    pop     {r1}
    bx      r1

@ 0x1000, or FE8's signal: 0x100 with signed hpChange < 0.
    .thumb_func
HitIsOoze:
    ldr     r1, =OozeAttr
    tst     r0, r1
    bne     HitYes
    ldr     r1, =HpStealAttr
    tst     r0, r1
    beq     HitNo
    asr     r1, r0, #24
    cmp     r1, #0
    blt     HitYes
HitNo:
    mov     r0, #0
    bx      lr
HitYes:
    mov     r0, #1
    bx      lr

@ ---------------------------------------------------------------------------
    .thumb_func
OozeOtherBar:
    push    {r4, lr}
    bl      OozeIsActive
    cmp     r0, #0
    beq     OozeSkip
    mov     r0, #1
    str     r0, [r5, #OozeProcMark]
    ldr     r0, [r5, #0x60]
    cmp     r0, #0
    bne     OtherHaveAis
    ldr     r0, [r5, #0x5C]
OtherHaveAis:
    ldr     r3, =GetAnimPosition
    bl      CallR3
    mov     r1, #1
    eor     r0, r1
    ldr     r1, =HpDisplay
    lsl     r0, #1
    add     r4, r0, r1
    ldr     r1, [r5, #0x48]
    ldrh    r0, [r4]
    add     r0, r1
    cmp     r0, #0
    bge     OozeStore
    mov     r0, #0
OozeStore:
    strh    r0, [r4]
OozeSkip:
OozeOtherOut:
    pop     {r4}
    pop     {r0}
    bx      r0

CallR3:
    bx      r3

@ ---------------------------------------------------------------------------
@ Anims-off floating HP. Vanilla: one signed delta, then its negate (steal).
@ Ooze: both use the same sign so the defender does not tick up.
@ A 0x0806C610 (r1 loaded). Resume 0x0806C619.
@ B 0x0806C6E0 (includes ldrsh). Resume 0x0806C6E7.
    .thumb_func
MapHpSkipNegA:
    push    {r1, lr}
    bl      OozeIsActive
    pop     {r1}
    cmp     r0, #0
    bne     MapHpASame
    neg     r0, r1
    b       MapHpAShift
MapHpASame:
    mov     r0, r1
MapHpAShift:
    lsl     r1, r0, #4
    mov     r2, #0x80
    lsl     r2, r2, #2
MapHpADone:
    pop     {r3}
    mov     lr, r3
    ldr     r3, =0x0806C619
    bx      r3

    .thumb_func
MapHpSkipNegB:
    ldrsh   r1, [r0, r2]
    push    {r1, lr}
    bl      OozeIsActive
    pop     {r1}
    cmp     r0, #0
    bne     MapHpBSame
    neg     r0, r1
    b       MapHpBShift
MapHpBSame:
    mov     r0, r1
MapHpBShift:
    lsl     r1, r0, #4
MapHpBDone:
    pop     {r3}
    mov     lr, r3
    ldr     r3, =0x0806C6E7
    bx      r3

    .align
    .ltorg
