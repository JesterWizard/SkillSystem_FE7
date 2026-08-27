.thumb
.align
.include "../HeroesMoveFE7.inc"

@ ============================================================================
@ Swap (FE7U)
@
@ Exchange tiles with an adjacent ally.  Template: Shove/ShoveAction.s.
@ Action id 0x1B: vanilla never writes it, and PlayerPhase's pre-action
@ table at 0x0801CA80 uses the default path (0x0801CB68).  0x0A is Give
@ and cancels here without a rescued unit.
@ ============================================================================

.equ SwapActionID, 0x1B

.global SwapMakeTargetList
.type   SwapMakeTargetList, %function
.global SwapUsability
.type   SwapUsability, %function
.global SwapEffect
.type   SwapEffect, %function
.global SwapActionEntry
.type   SwapActionEntry, %function
.global SwapAction
.type   SwapAction, %function
.global SwapTargetSelection
.global SwapLinks

@ r0=x r1=y r2=unit r3=occupant index to ignore (the swap partner).
SwapCanStand:
	push {r4,r5,r6,r7,lr}
	mov r4,r0
	mov r5,r1
	mov r6,r2
	mov r7,r3
	cmp r4,#0
	blt SwapCanStand_No
	cmp r5,#0
	blt SwapCanStand_No
	ldr r0,=gMapSize
	ldrh r1,[r0,#0]
	cmp r4,r1
	bge SwapCanStand_No
	ldrh r1,[r0,#2]
	cmp r5,r1
	bge SwapCanStand_No
	lsl r5,r5,#2
	ldr r0,=ppMapUnit
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	cmp r0,#0
	beq SwapCanStand_Hidden
	cmp r0,r7
	bne SwapCanStand_No
SwapCanStand_Hidden:
	ldr r0,=ppMapHidden
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	mov r1,#1
	and r0,r1
	cmp r0,#0
	bne SwapCanStand_No
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
	beq SwapCanStand_No
	mov r0,#1
	b SwapCanStand_Ret
SwapCanStand_No:
	mov r0,#0
SwapCanStand_Ret:
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

SwapTryAddUnit:
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
	beq SwapTryAddUnit_Ret
	mov r0,r7
	blh GetUnit
	cmp r0,#0
	beq SwapTryAddUnit_Ret
	mov r6,r0
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	cmp r0,r6
	beq SwapTryAddUnit_Ret
	ldr r0,[r6,#0xC]
	mov r1,#US_RESCUED
	and r0,r1
	cmp r0,#0
	bne SwapTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldrb r0,[r0,#0x0B]
	ldrb r1,[r6,#0x0B]
	blh AreAllegiancesAllied
	cmp r0,#0
	beq SwapTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldrb r3,[r6,#0x0B]
	mov r1,r4
	mov r2,r5
	@ r0=actor, need x,y of target: r4,r5
	push {r0}
	mov r0,r4
	mov r1,r5
	pop {r2}
	bl SwapCanStand
	cmp r0,#0
	beq SwapTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldrb r3,[r0,#0x0B]
	mov r1,#0x10
	ldrsb r1,[r0,r1]
	mov r2,#0x11
	ldrsb r2,[r0,r2]
	mov r0,r1
	mov r1,r2
	mov r2,r6
	bl SwapCanStand
	cmp r0,#0
	beq SwapTryAddUnit_Ret
	mov r0,r4
	mov r1,r5
	mov r2,r7
	mov r3,#0
	blh AddTarget, r7
SwapTryAddUnit_Ret:
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

SwapMakeTargetList:
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
	ldr r2,=SwapTryAddUnit+1
	blh ForEachAdjacentPosition
	pop {r4,r5}
	pop {r0}
	bx r0

SwapUsability:
	push {r4,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	ldr r0,[r4,#0xC]
	mov r1,#US_UNSELECTABLE
	and r0,r1
	cmp r0,#0
	bne SwapUsability_No
	ldr r0,=SwapLinks
	ldr r3,[r0,#0]
	ldr r1,[r0,#4]
	mov r0,r4
	mov lr,r3
	.short 0xF800
	cmp r0,#0
	beq SwapUsability_No
	mov r0,r4
	bl SwapMakeTargetList
	blh GetTargetListSize
	cmp r0,#0
	beq SwapUsability_No
	mov r0,#MENU_ENABLED
	b SwapUsability_Ret
SwapUsability_No:
	mov r0,#MENU_HIDDEN
SwapUsability_Ret:
	pop {r4}
	pop {r1}
	bx r1

SwapEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl SwapMakeTargetList
	ldr r0,=SwapTargetSelection
	blh StartTargetSelection
	mov r0,#SELECTION_DONE
	pop {r1}
	bx r1

SwapSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=SwapLinks
	ldr r0,[r0,#8]
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

SwapSelect_OnEnd:
	push {lr}
	blh HideMoveRangeGfx
	blh ClearBG0BG1
	pop {r1}
	bx r1

SwapSelect_OnSwitchIn:
	push {lr}
	mov r2,r1
	mov r0,#0
	ldrsb r0,[r2,r0]
	mov r1,#1
	ldrsb r1,[r2,r1]
	blh ChangeActiveUnitFacing
	pop {r1}
	bx r1

SwapSelect_OnSelect:
	push {r4,lr}
	mov r4,r1
	ldr r2,=gActionData
	mov r1,#SwapActionID
	strb r1,[r2,#0x11]
	ldrb r1,[r4,#2]
	strb r1,[r2,#0x0D]
	mov r0,#SELECTION_DONE
	pop {r4}
	pop {r1}
	bx r1

SwapActionEntry:
	mov r0,r5
	bl SwapAction
	pop {r4,r5}
	pop {r1}
	bx r1

SwapAction:
	push {r4,r5,r6,r7,lr}
	mov r7,r0                   @ parent
	ldr r0,=gActiveUnit
	ldr r5,[r0]
	cmp r5,#0
	beq SwapAction_Done
	ldr r4,=gActionData
	ldrb r0,[r4,#0x0D]
	blh GetUnit
	mov r6,r0
	cmp r6,#0
	beq SwapAction_Done
	blh DeleteAllMoveUnits
	mov r0,#0x10
	ldrsb r0,[r6,r0]
	mov r1,#0x11
	ldrsb r1,[r6,r1]
	mov r2,#0x10
	ldrsb r2,[r5,r2]
	mov r3,#0x11
	ldrsb r3,[r5,r3]
	blh GetFacingFromTo, r4
	mov r1,r0
	mov r0,r5
	mov r2,#1
	mov r3,r7
	blh NewUnitMoveProc, r4
	mov r0,#0x10
	ldrsb r0,[r5,r0]
	mov r1,#0x11
	ldrsb r1,[r5,r1]
	mov r2,#0x10
	ldrsb r2,[r6,r2]
	mov r3,#0x11
	ldrsb r3,[r6,r3]
	blh GetFacingFromTo, r4
	mov r1,r0
	mov r0,r6
	mov r2,#1
	mov r3,r7
	blh NewUnitMoveProc, r4
	mov r0,#0x10
	ldrsb r0,[r5,r0]
	mov r1,#0x11
	ldrsb r1,[r5,r1]
	mov r2,#0x10
	ldrsb r2,[r6,r2]
	mov r3,#0x11
	ldrsb r3,[r6,r3]
	strb r2,[r5,#0x10]
	strb r3,[r5,#0x11]
	strb r0,[r6,#0x10]
	strb r1,[r6,#0x11]
	ldr r4,=gActionData
	strb r2,[r4,#0x0E]
	strb r3,[r4,#0x0F]
	strb r0,[r4,#0x13]
	strb r1,[r4,#0x14]
	blh RefreshEntityMaps
	ldr r1,[r5,#0xC]
	mov r2,#US_UNSELECTABLE
	orr r1,r2
	str r1,[r5,#0xC]
SwapAction_Done:
	mov r0,#0
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

.ltorg
.align 4
SwapTargetSelection:
	.word SwapSelect_OnInit+1
	.word SwapSelect_OnEnd+1
	.word 0
	.word SwapSelect_OnSwitchIn+1
	.word 0
	.word SwapSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0
.align 4
SwapLinks:
