.thumb
.align

.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

.equ GetUnit, 0x08018D0C
.equ MakeMoveMapWithMov, 0x08019BE0
.equ gMapSize, 0x0202E3D8
.equ ppMoveMapRows, 0x0202E3E4
.equ KEEPUP_RANGE, 3
.equ KEEPUP_FILL_CAP, 20
.equ MOV_UNREACHABLE, 0xFF

@ Keep Up: live +2 Mov while an allied Canto/Canto+ skill is within 3 manhattan.
@ Class CA_CANTO does not count (nearby Paladins were keeping the boost after
@ walking away from the Canto-skill ally).
@ r0 = unit. Returns 1 if the boost should apply now, else 0.

.global KeepUp
.type KeepUp, %function

KeepUp:
    push {r4-r7, lr}
    mov r1, r8
    push {r1}
    mov r4, r0                       @ unit
    mov r5, #0                       @ result

    ldr r1, =KeepUpID_Link
    ldr r1, [r1]
    bl SkillIdIsUsable
    cmp r0, #0
    beq KeepUpLeave
    mov r0, r4
    ldr r1, =KeepUpID_Link
    ldr r1, [r1]
    bl SkillTester
    cmp r0, #0
    beq KeepUpLeave

    bl InitSkillBuffers
    mov r6, #1                       @ deployment id

KeepUpScan:
    cmp r6, #0xC0
    bge KeepUpLeave
    ldrb r0, [r4, #0x0B]
    cmp r6, r0
    beq KeepUpScanNext
    mov r0, r6
    blh GetUnit
    cmp r0, #0
    beq KeepUpScanNext
    mov r8, r0
    bl IsUnitOnField
    cmp r0, #0
    beq KeepUpScanNext
    mov r0, r4
    mov r1, r8
    bl UnitsAreAllied
    cmp r0, #0
    beq KeepUpScanNext
    mov r0, r4
    mov r1, r8
    bl ManhattanDist
    cmp r0, #KEEPUP_RANGE
    bgt KeepUpScanNext
    cmp r0, #0
    beq KeepUpScanNext
    mov r0, r8
    bl UnitGrantsKeepUpCanto
    cmp r0, #0
    beq KeepUpScanNext
    mov r5, #1
    b KeepUpLeave

KeepUpScanNext:
    add r6, #1
    b KeepUpScan

KeepUpLeave:
    pop {r0}
    mov r8, r0
    mov r0, r5
    pop {r4-r7}
    pop {r1}
    bx r1

@ MakeMoveMapWithMov wrapper: fill, then drop tiles that only the +2 could reach
@ and that sit outside the Canto aura. Stops spending leftover Keep Up Mov after
@ walking out of range the same turn.
.global KeepUpAfterMoveMap
.type KeepUpAfterMoveMap, %function
KeepUpAfterMoveMap:
    push {r4, r5, lr}
    mov r4, r0
    mov r5, r1
    bl CallMakeMoveMapWithMov
    mov r0, r4
    mov r1, r5
    bl PruneKeepUpMoveMap
    pop {r4, r5}
    pop {r1}
    bx r1

CallMakeMoveMapWithMov:
    ldr r3, =MakeMoveMapWithMov+1
    bx r3

@ r0 = unit, r1 = fill Mov used for this map.
.global PruneKeepUpMoveMap
.type PruneKeepUpMoveMap, %function
PruneKeepUpMoveMap:
    push {r4-r7, lr}
    mov r4, r0
    mov r5, r1
    mov r1, r8
    push {r1}
    mov r1, r9
    push {r1}
    mov r1, r10
    push {r1}

    cmp r4, #0
    beq PruneLeave
    cmp r5, #KEEPUP_FILL_CAP
    bgt PruneLeave
    cmp r5, #2
    blt PruneLeave

    mov r0, r4
    bl KeepUp
    cmp r0, #0
    beq PruneLeave

    sub r6, r5, #2                   @ Mov without Keep Up
    ldr r0, =gMapSize
    mov r1, #0
    ldrsh r1, [r0, r1]
    mov r8, r1                       @ width
    mov r1, #2
    ldrsh r1, [r0, r1]
    mov r9, r1                       @ height
    ldr r0, =ppMoveMapRows
    ldr r0, [r0]
    cmp r0, #0
    beq PruneLeave
    mov r10, r0                      @ row table

    mov r7, #0                       @ y
PruneY:
    mov r0, r9
    cmp r7, r0
    bge PruneLeave
    lsl r0, r7, #2
    add r0, r10
    ldr r0, [r0]                     @ row y
    cmp r0, #0
    beq PruneYNext
    mov r1, #0                       @ x
PruneX:
    mov r2, r8
    cmp r1, r2
    bge PruneYNext
    ldrb r2, [r0, r1]                @ remaining
    cmp r2, #MOV_UNREACHABLE
    beq PruneXNext
    sub r2, r5, r2                   @ spent
    cmp r2, r6
    ble PruneXNext                   @ reachable without the +2
    @ Keep Up at this tile?
    mov r2, #0x10
    ldrsb r2, [r4, r2]
    mov r3, #0x11
    ldrsb r3, [r4, r3]
    strb r1, [r4, #0x10]
    strb r7, [r4, #0x11]
    push {r0, r1, r2, r3}
    mov r0, r4
    bl KeepUp
    mov r12, r0
    pop {r0, r1, r2, r3}
    strb r2, [r4, #0x10]
    strb r3, [r4, #0x11]
    mov r2, r12
    cmp r2, #0
    bne PruneXNext
    mov r2, #MOV_UNREACHABLE
    strb r2, [r0, r1]
PruneXNext:
    add r1, #1
    b PruneX
PruneYNext:
    add r7, #1
    b PruneY

PruneLeave:
    pop {r0}
    mov r10, r0
    pop {r0}
    mov r9, r0
    pop {r0}
    mov r8, r0
    pop {r4-r7}
    pop {r1}
    bx r1

@ r0 = unit A, r1 = unit B. 1 if same faction or blue/green allied.
UnitsAreAllied:
    ldrb r0, [r0, #0x0B]
    ldrb r1, [r1, #0x0B]
    mov r2, #0xC0
    and r0, r2
    and r1, r2
    cmp r0, r1
    beq AlliedYes
    orr r0, r1
    cmp r0, #0x40
    beq AlliedYes
    mov r0, #0
    bx lr
AlliedYes:
    mov r0, #1
    bx lr

@ r0 = unit A, r1 = unit B. Returns |dx|+|dy|.
ManhattanDist:
    push {r4, r5}
    mov r4, r0
    mov r5, r1
    mov r0, #0x10
    ldrsb r0, [r4, r0]
    mov r1, #0x10
    ldrsb r1, [r5, r1]
    sub r0, r1
    cmp r0, #0
    bge DistXPos
    neg r0, r0
DistXPos:
    mov r2, r0                       @ |dx|
    mov r0, #0x11
    ldrsb r0, [r4, r0]
    mov r1, #0x11
    ldrsb r1, [r5, r1]
    sub r0, r1
    cmp r0, #0
    bge DistYPos
    neg r0, r0
DistYPos:
    add r0, r2                       @ |dx|+|dy|
    pop {r4, r5}
    bx lr

@ r0 = ally. 1 if Canto skill or Canto+ skill.
UnitGrantsKeepUpCanto:
    push {r4, lr}
    mov r4, r0

    ldr r1, =CantoID_Link
    ldr r1, [r1]
    bl UnitHasUsableSkill
    cmp r0, #0
    bne CantoYes

    mov r0, r4
    ldr r1, =CantoPlusID_Link
    ldr r1, [r1]
    bl UnitHasUsableSkill
    cmp r0, #0
    bne CantoYes

    mov r0, #0
    b CantoEnd
CantoYes:
    mov r0, #1
CantoEnd:
    pop {r4}
    pop {r1}
    bx r1

@ r1 = skill id. Returns 1 if id is 1-254.
SkillIdIsUsable:
    lsl r1, r1, #24
    lsr r1, r1, #24
    cmp r1, #0
    beq SkillIdNo
    cmp r1, #0xFF
    beq SkillIdNo
    mov r0, #1
    bx lr
SkillIdNo:
    mov r0, #0
    bx lr

@ r0 = unit, r1 = skill id. 1 if the id is usable and SkillTester matches.
UnitHasUsableSkill:
    push {r4, r5, lr}
    mov r4, r0
    mov r5, r1
    bl SkillIdIsUsable
    cmp r0, #0
    beq UnitHasSkillNo
    mov r0, r4
    mov r1, r5
    lsl r1, r1, #24
    lsr r1, r1, #24
    bl SkillTester
    pop {r4, r5}
    pop {r1}
    bx r1
UnitHasSkillNo:
    mov r0, #0
    pop {r4, r5}
    pop {r1}
    bx r1

.align
.ltorg
