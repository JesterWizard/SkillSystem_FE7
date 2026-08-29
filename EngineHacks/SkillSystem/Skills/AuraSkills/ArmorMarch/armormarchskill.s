.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

.equ ChapterData, 0x0202BBF8
.equ GetUnit,     0x08018D0C

.global ArmorMarch_StartOfTurn
.type ArmorMarch_StartOfTurn, %function

ArmorMarch_StartOfTurn:
    push {r4-r7, lr}
    mov r0, r8
    push {r0}

    @ 1. Unset the ArmorMarch bit for all units of the current phase
    ldr r0, =ChapterData
    ldrb r4, [r0, #0xF]        @ phase: 0x00 (Player), 0x40 (NPC), 0x80 (Enemy)
    mov r5, #0x40
    add r5, r4                 @ end deployment ID for this phase
    cmp r4, #0
    bne UnsetPhaseLoop
    add r4, #1                 @ player units start at 1

UnsetPhaseLoop:
    cmp r4, r5
    bge DoneUnset
    mov r0, r4
    blh GetUnit
    cmp r0, #0
    beq NextUnsetUnit
    bl GetUnitDebuffEntry
    cmp r0, #0
    beq NextUnsetUnit
    ldr r1, =ArmorMarchBitOffset_Link
    ldr r1, [r1]
    bl UnsetBit
NextUnsetUnit:
    add r4, #1
    b UnsetPhaseLoop

DoneUnset:
    @ 2. Loop over each unit in the current phase and check if it gets the Armor March buff
    ldr r0, =ChapterData
    ldrb r4, [r0, #0xF]        @ phase: 0x00, 0x40, 0x80
    mov r5, #0x40
    add r5, r4                 @ end deployment ID
    cmp r4, #0
    bne UnitPhaseLoop
    add r4, #1                 @ player units start at 1

UnitPhaseLoop:
    cmp r4, r5
    blt ContinueUnitPhaseLoop
    b DoneTurnLoop

ContinueUnitPhaseLoop:
    mov r0, r4
    blh GetUnit
    mov r6, r0                 @ r6 = current unit struct (Unit*)
    cmp r6, #0
    beq NextUnit

    bl IsUnitOnField
    cmp r0, #0
    beq NextUnit

    @ Check if this unit qualifies for Armor March:
    @ Case 1: Unit has ArmorMarchID skill AND is adjacent to an ally armor
    mov r0, r6
    ldr r1, =ArmorMarchID_Link
    ldr r1, [r1]
    bl SkillTester
    cmp r0, #0
    beq CheckCase2

    @ Unit has ArmorMarchID. Check if any adjacent ally is an armor.
    mov r0, r6
    mov r1, #0                 @ allyOption: 0 (allies / same faction)
    mov r2, #1                 @ range: 1 (adjacent)
    bl GetUnitsInRange
    cmp r0, #0
    beq CheckCase3             @ No adjacent allies, check KeepUp

    mov r7, r0                 @ r7 = pointer to unit range buffer
CheckAdjacentArmorLoop:
    ldrb r0, [r7]
    cmp r0, #0
    beq CheckCase3             @ No adjacent armor found, check KeepUp
    add r7, #1
    blh GetUnit
    cmp r0, #0
    beq CheckAdjacentArmorLoop
    @ Check if ally's class is in ArmorMarchList
    ldr r1, [r0, #4]           @ pClassData
    cmp r1, #0
    beq CheckAdjacentArmorLoop
    ldrb r1, [r1, #4]          @ class ID
    ldr r2, =ArmorMarchList
CheckClassLoop1:
    ldrb r3, [r2]
    cmp r3, #0
    beq CheckAdjacentArmorLoop
    cmp r3, r1
    beq ApplyArmorMarch        @ Found adjacent armor ally! Apply buff!
    add r2, #1
    b CheckClassLoop1

CheckCase2:
    @ Case 2: Unit is an armor AND is adjacent to an ally with ArmorMarchID skill
    ldr r0, [r6, #4]           @ pClassData
    cmp r0, #0
    beq CheckCase3
    ldrb r1, [r0, #4]          @ unit class ID
    ldr r2, =ArmorMarchList
CheckUnitIsArmorLoop:
    ldrb r3, [r2]
    cmp r3, #0
    beq CheckCase3             @ Unit is not an armor class, check KeepUp
    cmp r3, r1
    beq UnitIsArmor
    add r2, #1
    b CheckUnitIsArmorLoop

UnitIsArmor:
    @ Unit is an armor. Check if any adjacent ally has ArmorMarchID.
    mov r0, r6
    mov r1, #0                 @ allyOption: 0 (allies)
    mov r2, #1                 @ range: 1 (adjacent)
    bl GetUnitsInRange
    cmp r0, #0
    beq CheckCase3             @ No adjacent allies, check KeepUp

    mov r7, r0                 @ r7 = pointer to unit range buffer
CheckAdjacentSkillLoop:
    ldrb r0, [r7]
    cmp r0, #0
    beq CheckCase3             @ No adjacent ally with skill, check KeepUp
    add r7, #1
    blh GetUnit
    cmp r0, #0
    beq CheckAdjacentSkillLoop
    ldr r1, =ArmorMarchID_Link
    ldr r1, [r1]
    bl SkillTester
    cmp r0, #0
    bne ApplyArmorMarch        @ Found adjacent ally with ArmorMarch! Apply buff!
    b CheckAdjacentSkillLoop

CheckCase3:
    @ Keep Up is live in prArmorMarchCheck, not a start-of-turn bit.
    b NextUnit

ApplyArmorMarch:
    mov r0, r6                 @ r6 = current unit (Unit*)
    bl GetUnitDebuffEntry
    cmp r0, #0
    beq NextUnit
    ldr r1, =ArmorMarchBitOffset_Link
    ldr r1, [r1]
    bl SetBit
    b NextUnit

NextUnit:
    add r4, #1
    b UnitPhaseLoop

DoneTurnLoop:
    mov r0, #0                 @ no blocking proc / animation
    pop {r0}
    mov r8, r0
    pop {r4-r7}
    pop {r1}
    bx r1

.align
.ltorg
