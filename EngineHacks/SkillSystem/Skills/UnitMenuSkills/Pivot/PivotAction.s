.thumb
.align
.include "../HeroesMoveFE7.inc"

@ ============================================================================
@ Pivot (FE7U)
@
@ Move the actor to the opposite side of an adjacent ally.
@ Template: Shove/ShoveAction.s.  Action id 0x16: vanilla never writes it,
@ and PlayerPhase's pre-action table at 0x0801CA80 uses the default path
@ (0x0801CB68).  0x09 is Take and cancels here without a rescued unit.
@ Dest is two tiles from the actor, through the ally.
@ ============================================================================

.equ PivotActionID, 0x16

.global PivotMakeTargetList
.type   PivotMakeTargetList, %function
.global PivotUsability
.type   PivotUsability, %function
.global PivotEffect
.type   PivotEffect, %function
.global PivotActionEntry
.type   PivotActionEntry, %function
.global PivotAction
.type   PivotAction, %function
.global PivotTargetSelection
.global PivotLinks

@ r0=x r1=y r2=unit.  r0=1 if that unit can stand there.
PivotCanLand:
	push {r4,r5,r6,lr}
	mov r4,r0
	mov r5,r1
	mov r6,r2
	cmp r4,#0
	blt PivotCanLand_No
	cmp r5,#0
	blt PivotCanLand_No
	ldr r0,=gMapSize
	ldrh r1,[r0,#0]
	cmp r4,r1
	bge PivotCanLand_No
	ldrh r1,[r0,#2]
	cmp r5,r1
	bge PivotCanLand_No
	lsl r5,r5,#2
	ldr r0,=ppMapUnit
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	cmp r0,#0
	bne PivotCanLand_No
	ldr r0,=ppMapHidden
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	mov r1,#1
	and r0,r1
	cmp r0,#0
	bne PivotCanLand_No
	ldr r0,=ppMapTerrain
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r1,[r0]
	mov r0,r6
	blh CanUnitCrossTerrain
	lsl r0,r0,#24
	cmp r0,#0
	beq PivotCanLand_No
	mov r0,#1
	b PivotCanLand_Ret
PivotCanLand_No:
	mov r0,#0
PivotCanLand_Ret:
	pop {r4,r5,r6}
	pop {r1}
	bx r1

PivotTryAddUnit:
	push {r4,r5,r6,r7,lr}
	mov r4,r0
	mov r5,r1
	ldr r0,=ppMapUnit
	ldr r0,[r0]
	lsl r2,r5,#2
	add r0,r2
	ldr r0,[r0]
	add r0,r4
	ldrb r7,[r0]
	cmp r7,#0
	beq PivotTryAddUnit_Ret
	mov r0,r7
	blh GetUnit
	cmp r0,#0
	beq PivotTryAddUnit_Ret
	mov r6,r0
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	cmp r0,r6
	beq PivotTryAddUnit_Ret
	ldr r0,[r6,#0xC]
	mov r1,#US_RESCUED
	and r0,r1
	cmp r0,#0
	bne PivotTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldrb r0,[r0,#0x0B]
	ldrb r1,[r6,#0x0B]
	blh AreAllegiancesAllied
	cmp r0,#0
	beq PivotTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	mov r1,#0x10
	ldrsb r1,[r0,r1]
	mov r2,#0x11
	ldrsb r2,[r0,r2]
	lsl r3,r4,#1
	sub r3,r3,r1                @ dest x = 2*tx - ax
	lsl r1,r5,#1
	sub r1,r1,r2                @ dest y = 2*ty - ay
	mov r2,r0                   @ actor must land there
	mov r0,r3
	bl PivotCanLand
	cmp r0,#0
	beq PivotTryAddUnit_Ret
	mov r0,r4
	mov r1,r5
	mov r2,r7
	mov r3,#0
	blh AddTarget, r7
PivotTryAddUnit_Ret:
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

PivotMakeTargetList:
	push {r4,r5,lr}
	mov r4,#0x10
	ldrsb r4,[r0,r4]
	mov r5,#0x11
	ldrsb r5,[r0,r5]
	ldr r0,=ppMapRange
	ldr r0,[r0]
	mov r1,#0
	blh ClearMapWith
	mov r0,r4
	mov r1,r5
	ldr r2,=PivotTryAddUnit+1
	blh ForEachAdjacentPosition
	pop {r4,r5}
	pop {r0}
	bx r0

PivotUsability:
	push {r4,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	ldr r0,[r4,#0xC]
	mov r1,#US_UNSELECTABLE
	and r0,r1
	cmp r0,#0
	bne PivotUsability_No
	ldr r0,=PivotLinks
	ldr r3,[r0,#0]
	ldr r1,[r0,#4]
	mov r0,r4
	mov lr,r3
	.short 0xF800
	cmp r0,#0
	beq PivotUsability_No
	mov r0,r4
	bl PivotMakeTargetList
	blh GetTargetListSize
	cmp r0,#0
	beq PivotUsability_No
	mov r0,#MENU_ENABLED
	b PivotUsability_Ret
PivotUsability_No:
	mov r0,#MENU_HIDDEN
PivotUsability_Ret:
	pop {r4}
	pop {r1}
	bx r1

PivotEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl PivotMakeTargetList
	ldr r0,=PivotTargetSelection
	blh StartTargetSelection
	mov r0,#SELECTION_DONE
	pop {r1}
	bx r1

PivotSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=PivotLinks
	ldr r0,[r0,#8]
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

PivotSelect_OnEnd:
	push {lr}
	blh HideMoveRangeGfx
	blh ClearBG0BG1
	pop {r1}
	bx r1

PivotSelect_OnSwitchIn:
	push {lr}
	mov r2,r1
	mov r0,#0
	ldrsb r0,[r2,r0]
	mov r1,#1
	ldrsb r1,[r2,r1]
	blh ChangeActiveUnitFacing
	pop {r1}
	bx r1

PivotSelect_OnSelect:
	push {r4,lr}
	mov r4,r1
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	mov r1,#0x10
	ldrsb r1,[r0,r1]
	mov r2,#0x11
	ldrsb r2,[r0,r2]
	mov r0,#0
	ldrsb r0,[r4,r0]
	lsl r0,r0,#1
	sub r0,r0,r1
	mov r3,#1
	ldrsb r3,[r4,r3]
	lsl r3,r3,#1
	sub r3,r3,r2
	ldr r2,=gActionData
	mov r1,#PivotActionID
	strb r1,[r2,#0x11]
	ldrb r1,[r4,#2]
	strb r1,[r2,#0x0D]
	strb r0,[r2,#0x13]
	strb r3,[r2,#0x14]
	mov r0,#SELECTION_DONE
	pop {r4}
	pop {r1}
	bx r1

PivotActionEntry:
	mov r0,r5
	bl PivotAction
	pop {r4,r5}
	pop {r1}
	bx r1

@ Slide the ACTOR onto the opposite tile.  Write +0x0E/+0x0F HERE, not
@ in OnSelect: those bytes are the walk dest, and writing them on A-press
@ makes PlayerPhase try to path through the ally before the action runs.
PivotAction:
	push {r4,r5,r6,r7,lr}
	mov r6,r0
	ldr r0,=gActiveUnit
	ldr r5,[r0]
	cmp r5,#0
	beq PivotAction_Done
	ldr r4,=gActionData
	blh DeleteAllMoveUnits
	mov r0,#0x13
	ldrsb r0,[r4,r0]
	mov r1,#0x14
	ldrsb r1,[r4,r1]
	mov r2,#0x10
	ldrsb r2,[r5,r2]
	mov r3,#0x11
	ldrsb r3,[r5,r3]
	blh GetFacingFromTo, r7
	mov r1,r0
	mov r0,r5
	mov r2,#1
	mov r3,r6
	blh NewUnitMoveProc, r7
	mov r0,#0x13
	ldrsb r0,[r4,r0]
	strb r0,[r5,#0x10]
	strb r0,[r4,#0x0E]
	mov r0,#0x14
	ldrsb r0,[r4,r0]
	strb r0,[r5,#0x11]
	strb r0,[r4,#0x0F]
	blh RefreshEntityMaps
	ldr r1,[r5,#0xC]
	mov r2,#US_UNSELECTABLE
	orr r1,r2
	str r1,[r5,#0xC]
PivotAction_Done:
	mov r0,#0
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

.ltorg
.align 4
PivotTargetSelection:
	.word PivotSelect_OnInit+1
	.word PivotSelect_OnEnd+1
	.word 0
	.word PivotSelect_OnSwitchIn+1
	.word 0
	.word PivotSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0
.align 4
PivotLinks:
