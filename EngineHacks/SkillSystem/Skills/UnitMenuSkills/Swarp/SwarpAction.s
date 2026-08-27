.thumb
.align
.include "../HeroesMoveFE7.inc"

@ ============================================================================
@ Swarp (FE7U)
@
@ Swap with an allied unit within Mag/2 range.  Mag is unit+0x47
@ (Str/Mag split).  Template: Shove/ShoveAction.s.
@ Action id 0x14 is a vanilla nop slot.
@ ============================================================================

.equ SwarpActionID, 0x14

.global SwarpMakeTargetList
.type   SwarpMakeTargetList, %function
.global SwarpUsability
.type   SwarpUsability, %function
.global SwarpEffect
.type   SwarpEffect, %function
.global SwarpActionEntry
.type   SwarpActionEntry, %function
.global SwarpAction
.type   SwarpAction, %function
.global SwarpTargetSelection
.global SwarpLinks

SwarpCanStand:
	push {r4,r5,r6,r7,lr}
	mov r4,r0
	mov r5,r1
	mov r6,r2
	mov r7,r3
	cmp r4,#0
	blt SwarpCanStand_No
	cmp r5,#0
	blt SwarpCanStand_No
	ldr r0,=gMapSize
	ldrh r1,[r0,#0]
	cmp r4,r1
	bge SwarpCanStand_No
	ldrh r1,[r0,#2]
	cmp r5,r1
	bge SwarpCanStand_No
	lsl r5,r5,#2
	ldr r0,=ppMapUnit
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	cmp r0,#0
	beq SwarpCanStand_Hidden
	cmp r0,r7
	bne SwarpCanStand_No
SwarpCanStand_Hidden:
	ldr r0,=ppMapHidden
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	mov r1,#1
	and r0,r1
	cmp r0,#0
	bne SwarpCanStand_No
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
	beq SwarpCanStand_No
	mov r0,#1
	b SwarpCanStand_Ret
SwarpCanStand_No:
	mov r0,#0
SwarpCanStand_Ret:
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

@ r0 = candidate unit, r4 = actor, r5 = mag/2 range.  Uses r6,r7.
SwarpTryAddUnit:
	push {r4,r5,r6,r7,lr}
	mov r6,r0
	ldr r0,[r6,#0]
	cmp r0,#0
	beq SwarpTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r4,[r0]
	cmp r6,r4
	beq SwarpTryAddUnit_Ret
	ldr r0,[r6,#0xC]
	mov r1,#US_RESCUED
	and r0,r1
	cmp r0,#0
	bne SwarpTryAddUnit_Ret
	ldrb r0,[r4,#0x0B]
	ldrb r1,[r6,#0x0B]
	blh AreAllegiancesAllied
	cmp r0,#0
	beq SwarpTryAddUnit_Ret
	mov r0,#0x10
	ldrsb r0,[r6,r0]
	mov r1,#0x10
	ldrsb r1,[r4,r1]
	sub r0,r0,r1
	cmp r0,#0
	bge SwarpTryAddUnit_AbsX
	neg r0,r0
SwarpTryAddUnit_AbsX:
	mov r1,#0x11
	ldrsb r1,[r6,r1]
	mov r2,#0x11
	ldrsb r2,[r4,r2]
	sub r1,r1,r2
	cmp r1,#0
	bge SwarpTryAddUnit_AbsY
	neg r1,r1
SwarpTryAddUnit_AbsY:
	add r0,r1
	cmp r0,#0
	beq SwarpTryAddUnit_Ret
	mov r5,#UNIT_MAG
	ldrb r5,[r4,r5]
	lsr r5,r5,#1
	cmp r0,r5
	bgt SwarpTryAddUnit_Ret
	mov r0,#0x10
	ldrsb r0,[r6,r0]
	mov r1,#0x11
	ldrsb r1,[r6,r1]
	ldrb r3,[r6,#0x0B]
	mov r2,r4
	bl SwarpCanStand
	cmp r0,#0
	beq SwarpTryAddUnit_Ret
	mov r0,#0x10
	ldrsb r0,[r4,r0]
	mov r1,#0x11
	ldrsb r1,[r4,r1]
	ldrb r3,[r4,#0x0B]
	mov r2,r6
	bl SwarpCanStand
	cmp r0,#0
	beq SwarpTryAddUnit_Ret
	mov r0,#0x10
	ldrsb r0,[r6,r0]
	mov r1,#0x11
	ldrsb r1,[r6,r1]
	ldrb r2,[r6,#0x0B]
	mov r3,#0
	blh AddTarget, r7
SwarpTryAddUnit_Ret:
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

SwarpMakeTargetList:
	push {r4,r5,lr}
	mov r4,r0
	mov r0,#0
	mov r1,#0
	blh InitTargets
	ldr r0,=ppMapRange
	ldr r0,[r0]
	mov r1,#0
	blh ClearMapWith
	mov r0,#UNIT_MAG
	ldrb r0,[r4,r0]
	lsr r0,r0,#1
	cmp r0,#0
	beq SwarpMakeTargetList_Ret
	mov r5,#1
SwarpMakeTargetList_Loop:
	mov r0,r5
	blh GetUnit
	cmp r0,#0
	beq SwarpMakeTargetList_Next
	bl SwarpTryAddUnit
SwarpMakeTargetList_Next:
	add r5,#1
	cmp r5,#0xC0
	blt SwarpMakeTargetList_Loop
SwarpMakeTargetList_Ret:
	pop {r4,r5}
	pop {r0}
	bx r0

SwarpUsability:
	push {r4,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	ldr r0,[r4,#0xC]
	mov r1,#US_UNSELECTABLE
	and r0,r1
	cmp r0,#0
	bne SwarpUsability_No
	mov r0,#UNIT_MAG
	ldrb r0,[r4,r0]
	lsr r0,r0,#1
	cmp r0,#0
	beq SwarpUsability_No
	ldr r0,=SwarpLinks
	ldr r3,[r0,#0]
	ldr r1,[r0,#4]
	mov r0,r4
	mov lr,r3
	.short 0xF800
	cmp r0,#0
	beq SwarpUsability_No
	mov r0,r4
	bl SwarpMakeTargetList
	blh GetTargetListSize
	cmp r0,#0
	beq SwarpUsability_No
	mov r0,#MENU_ENABLED
	b SwarpUsability_Ret
SwarpUsability_No:
	mov r0,#MENU_HIDDEN
SwarpUsability_Ret:
	pop {r4}
	pop {r1}
	bx r1

SwarpEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl SwarpMakeTargetList
	ldr r0,=SwarpTargetSelection
	blh StartTargetSelection
	mov r0,#SELECTION_DONE
	pop {r1}
	bx r1

SwarpSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=SwarpLinks
	ldr r0,[r0,#8]
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

SwarpSelect_OnEnd:
	push {lr}
	blh HideMoveRangeGfx
	blh ClearBG0BG1
	pop {r1}
	bx r1

SwarpSelect_OnSwitchIn:
	push {lr}
	mov r2,r1
	mov r0,#0
	ldrsb r0,[r2,r0]
	mov r1,#1
	ldrsb r1,[r2,r1]
	blh ChangeActiveUnitFacing
	pop {r1}
	bx r1

SwarpSelect_OnSelect:
	push {r4,lr}
	mov r4,r1
	ldr r2,=gActionData
	mov r1,#SwarpActionID
	strb r1,[r2,#0x11]
	ldrb r1,[r4,#2]
	strb r1,[r2,#0x0D]
	mov r0,#SELECTION_DONE
	pop {r4}
	pop {r1}
	bx r1

SwarpActionEntry:
	mov r0,r5
	bl SwarpAction
	pop {r4,r5}
	pop {r1}
	bx r1

SwarpAction:
	push {r4,r5,r6,r7,lr}
	mov r7,r0
	ldr r0,=gActiveUnit
	ldr r5,[r0]
	cmp r5,#0
	beq SwarpAction_Done
	ldr r4,=gActionData
	ldrb r0,[r4,#0x0D]
	blh GetUnit
	mov r6,r0
	cmp r6,#0
	beq SwarpAction_Done
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
SwarpAction_Done:
	mov r0,#0
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

.ltorg
.align 4
SwarpTargetSelection:
	.word SwarpSelect_OnInit+1
	.word SwarpSelect_OnEnd+1
	.word 0
	.word SwarpSelect_OnSwitchIn+1
	.word 0
	.word SwarpSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0
.align 4
SwarpLinks:
