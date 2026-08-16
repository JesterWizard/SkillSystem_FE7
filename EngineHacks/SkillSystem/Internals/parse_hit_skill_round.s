.thumb
@ Hook at 0x08052F7C (after POS_L/POS_R gAnimRoundData writes).
@ r5 = POS_L, r4 = POS_R, r9 = current hit, r0 = POS_R type to store.
@ Continue at 0x08052F87 (cmp r0, #0 after miss-bit and).

.equ ParseHit_Continue, 0x08052F87

parse_hit_skill_round:
    strh r0, [r4]

    push {r0-r3}

    mov r2, r9
    ldrh r2, [r2]

    mov r0, #0x40
    lsl r0, #8 @ 0x4000 attacker skill
    tst r2, r0
    beq CheckShield

    mov r3, #0x80
    lsl r3, #4 @ 0x0800
    ldrh r0, [r5]
    mov r1, #0xFF
    and r1, r0
    cmp r1, #4
    blo OrLeftOff
    cmp r1, #9
    bne RightOff
OrLeftOff:
    orr r0, r3
    strh r0, [r5]
RightOff:
    ldrh r0, [r4]
    mov r1, #0xFF
    and r1, r0
    cmp r1, #4
    blo OrRightOff
    cmp r1, #9
    bne CheckShield
OrRightOff:
    orr r0, r3
    strh r0, [r4]

CheckShield:
    mov r0, #0x80
    lsl r0, #8 @ 0x8000 defender skill
    tst r2, r0
    beq ToVanilla

    mov r3, #0x40
    lsl r3, #4 @ 0x0400
    ldrh r0, [r5]
    mov r1, #0xFF
    and r1, r0
    cmp r1, #4
    blo RightDef
    cmp r1, #7
    beq RightDef
    cmp r1, #8
    bhi RightDef
    orr r0, r3
    strh r0, [r5]
RightDef:
    ldrh r0, [r4]
    mov r1, #0xFF
    and r1, r0
    cmp r1, #4
    blo ToVanilla
    cmp r1, #7
    beq ToVanilla
    cmp r1, #8
    bhi ToVanilla
    orr r0, r3
    strh r0, [r4]

ToVanilla:
    pop {r0-r3}
    mov r2, r9
    ldrh r1, [r2]
    mov r0, #2
    and r0, r1
    ldr r3, =ParseHit_Continue
    bx r3

    .align
    .ltorg
