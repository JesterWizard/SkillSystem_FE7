.thumb
@ C03: Astra 0x4000 → Elfire OBJ on unused OBJ VRAM, then x5.
@ Do not call 0x08058744 / 0x08058810 / 0x08058AC4 from C03 (LZ77 SWI crash).
@ Do not call 0x0805889C (tiles 0x06010800 + pal 2 wipe both units).
@ Tiles at 0x06014000, OBJ pal 15. No hide bit. Own proc BLOCKENDs.

.equ GetAISLayerId,              0x08054665
.equ GetAnimPosition,            0x08054679
.equ New6C,                      0x08004495
.equ PrepAIS,                    0x0805041D
.equ LZ77UnCompWram,             0x080BFA29
.equ TileTransferInfoAdd,        0x08003079
.equ CpuFastSet,                 0x080BFA0D
.equ EnablePaletteSync,          0x0800105D
.equ BreakLoop,                  0x08006651
.equ Break6CLoop,                0x080046A1
.equ VanillaC03_Continue,        0x08053689
.equ gBattleHitArray,            0x0203F000
.equ gAISArray,                  0x02000000
.equ gBanimLeftUnit,             0x0203E094
.equ gBanimRightUnit,            0x0203E098
.equ gAstraSplashDeployId,       0x0203F0FC
.equ ElfirePal,                  0x0820AB9C
.equ ElfireTiles,                0x0820A924
.equ ElfireFrameL,               0x08BB62EC
.equ ElfireFrameR,               0x08BB54CC
.equ SpellTileWram,              0x0201A784
.equ SpellTileVram,              0x06014000
.equ ObjPal15Buf,                0x02022C40

.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

SkillActivationAnims:
    push {r4-r6, lr}
    mov r4, r7

    ldrh r5, [r4, #0xE]
    mov r0, r5
    bl HitHasAstraFlag
    cmp r0, #0
    bne CheckSide
    cmp r5, #0
    beq ToVanilla
    sub r5, #1
    mov r0, r5
    bl HitHasAstraFlag
    cmp r0, #0
    beq ToVanilla

CheckSide:
    mov r0, r4
    blh GetAnimPosition
    mov r6, r0
    cmp r6, #0
    bne LoadRight
    ldr r0, =gBanimLeftUnit
    b LoadUnit
LoadRight:
    ldr r0, =gBanimRightUnit
LoadUnit:
    ldr r0, [r0]
    cmp r0, #0
    beq ToVanilla
    ldrb r0, [r0, #0x0B]
    ldr r1, =gAstraSplashDeployId
    ldrb r1, [r1]
    cmp r0, r1
    bne ToVanilla

    ldrh r1, [r4, #0x10]
    mov r2, #0x20
    orr r1, r2
    strh r1, [r4, #0x10]

    mov r0, r4
    blh GetAISLayerId
    cmp r0, #0
    bne ToVanilla

    mov r0, r4
    bl StartSkillElfireOBJ

ToVanilla:
    pop {r4-r6}
    pop {r3}
    mov lr, r3
    ldrh r1, [r7, #0x10]
    mov r2, #0x20
    mov r0, #0x20
    and r0, r1
    ldr r3, =VanillaC03_Continue
    bx r3

HitHasAstraFlag:
    cmp r0, #30
    bhi HitNo
    lsl r0, #2
    ldr r1, =gBattleHitArray
    ldr r0, [r1, r0]
    lsl r0, #13
    lsr r0, #13
    mov r1, #0x40
    lsl r1, #8
    and r0, r1
    bx lr
HitNo:
    mov r0, #0
    bx lr

StartSkillElfireOBJ:
    push {r4-r6, lr}
    sub sp, #4
    mov r5, r0
    ldr r0, =EfxSkillElfireOBJProc
    mov r1, #3
    blh New6C
    mov r4, r0
    str r5, [r4, #0x5C]
    mov r0, #0
    strh r0, [r4, #0x2C]
    ldr r3, =ElfireFrameL
    ldr r2, =ElfireFrameR
    str r2, [sp]
    mov r0, r5
    mov r1, r3
    blh PrepAIS
    mov r6, r0
    str r6, [r4, #0x60]
    mov r0, r5
    blh GetAnimPosition
    ldrh r1, [r6, #2]
    cmp r0, #0
    bne ElfireRight
    sub r1, #8
    b ElfireStoreX
ElfireRight:
    add r1, #8
ElfireStoreX:
    strh r1, [r6, #2]
    @ pal 15, prio 2, tile 0x200 (0x06014000)
    mov r0, #0xFA
    lsl r0, #8
    strh r0, [r6, #8]
    ldr r0, =ElfireTiles
    ldr r1, =SpellTileWram
    blh LZ77UnCompWram
    ldr r0, =SpellTileWram
    ldr r1, =SpellTileVram
    mov r2, #0x80
    lsl r2, #4
    blh TileTransferInfoAdd
    ldr r0, =ElfirePal
    ldr r1, =ObjPal15Buf
    mov r2, #8
    blh CpuFastSet
    blh EnablePaletteSync
    add sp, #4
    pop {r4-r6}
    pop {r1}
    bx r1

EfxSkillElfireLoop:
    push {r4-r6, lr}
    mov r4, r0
    ldrh r0, [r4, #0x2C]
    add r0, #1
    strh r0, [r4, #0x2C]
    lsl r0, #16
    asr r0, #16
    cmp r0, #0x28
    ble ElfireLoopRet

    ldr r5, [r4, #0x5C]
    ldr r6, =gAISArray
    mov r0, r5
    blh GetAnimPosition
    lsl r0, #3
    add r0, r6
    ldr r2, [r0]
    ldrh r1, [r2, #0x10]
    mov r3, #0x40
    orr r1, r3
    strh r1, [r2, #0x10]
    mov r0, r5
    blh GetAnimPosition
    lsl r0, #1
    add r0, #1
    lsl r0, #2
    add r0, r6
    ldr r2, [r0]
    ldrh r1, [r2, #0x10]
    mov r3, #0x40
    orr r1, r3
    strh r1, [r2, #0x10]

    ldr r0, [r4, #0x60]
    blh BreakLoop
    mov r0, r4
    blh Break6CLoop

ElfireLoopRet:
    pop {r4-r6}
    pop {r1}
    bx r1

    .align 2
EfxSkillElfireOBJProc:
    .word 3, EfxSkillElfireLoop+1
    .word 0, 0

    .align
    .ltorg
