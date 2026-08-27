.thumb
.align
.include "../HeroesMoveFE7.inc"

@ ============================================================================
@ Reposition (FE7U)
@
@ Pull an adjacent ally to the opposite side of the actor.
@ Template: Shove/ShoveAction.s.  Action id 0x13 is a vanilla nop slot.
@ ============================================================================

.equ RepositionActionID, 0x13

.global RepositionMakeTargetList
.type   RepositionMakeTargetList, %function
.global RepositionUsability
.type   RepositionUsability, %function
.global RepositionEffect
.type   RepositionEffect, %function
.global RepositionActionEntry
.type   RepositionActionEntry, %function
.global RepositionAction
.type   RepositionAction, %function
.global RepositionTargetSelection
.global RepositionLinks

RepositionCanLand:
	push {r4,r5,r6,lr}
	mov r4,r0
	mov r5,r1
	mov r6,r2
	cmp r4,#0
	blt RepositionCanLand_No
	cmp r5,#0
	blt RepositionCanLand_No
	ldr r0,=gMapSize
	ldrh r1,[r0,#0]
	cmp r4,r1
	bge RepositionCanLand_No
	ldrh r1,[r0,#2]
	cmp r5,r1
	bge RepositionCanLand_No
	lsl r5,r5,#2
	ldr r0,=ppMapUnit
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	cmp r0,#0
	bne RepositionCanLand_No
	ldr r0,=ppMapHidden
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	mov r1,#1
	and r0,r1
	cmp r0,#0
	bne RepositionCanLand_No
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
	beq RepositionCanLand_No
	mov r0,#1
	b RepositionCanLand_Ret
RepositionCanLand_No:
	mov r0,#0
RepositionCanLand_Ret:
	pop {r4,r5,r6}
	pop {r1}
	bx r1

RepositionTryAddUnit:
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
	beq RepositionTryAddUnit_Ret
	mov r0,r7
	blh GetUnit
	cmp r0,#0
	beq RepositionTryAddUnit_Ret
	mov r6,r0
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	cmp r0,r6
	beq RepositionTryAddUnit_Ret
	ldr r0,[r6,#0xC]
	mov r1,#US_RESCUED
	and r0,r1
	cmp r0,#0
	bne RepositionTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldrb r0,[r0,#0x0B]
	ldrb r1,[r6,#0x0B]
	blh AreAllegiancesAllied
	cmp r0,#0
	beq RepositionTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	mov r1,#0x10
	ldrsb r1,[r0,r1]
	mov r2,#0x11
	ldrsb r2,[r0,r2]
	lsl r3,r1,#1
	sub r3,r3,r4                @ dest x = 2*ax - tx
	lsl r1,r2,#1
	sub r1,r1,r5                @ dest y = 2*ay - ty
	mov r0,r3
	mov r2,r6                   @ target must land there
	bl RepositionCanLand
	cmp r0,#0
	beq RepositionTryAddUnit_Ret
	mov r0,r4
	mov r1,r5
	mov r2,r7
	mov r3,#0
	blh AddTarget, r7
RepositionTryAddUnit_Ret:
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

RepositionMakeTargetList:
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
	ldr r2,=RepositionTryAddUnit+1
	blh ForEachAdjacentPosition
	pop {r4,r5}
	pop {r0}
	bx r0

RepositionUsability:
	push {r4,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	ldr r0,[r4,#0xC]
	mov r1,#US_UNSELECTABLE
	and r0,r1
	cmp r0,#0
	bne RepositionUsability_No
	ldr r0,=RepositionLinks
	ldr r3,[r0,#0]
	ldr r1,[r0,#4]
	mov r0,r4
	mov lr,r3
	.short 0xF800
	cmp r0,#0
	beq RepositionUsability_No
	mov r0,r4
	bl RepositionMakeTargetList
	blh GetTargetListSize
	cmp r0,#0
	beq RepositionUsability_No
	mov r0,#MENU_ENABLED
	b RepositionUsability_Ret
RepositionUsability_No:
	mov r0,#MENU_HIDDEN
RepositionUsability_Ret:
	pop {r4}
	pop {r1}
	bx r1

RepositionEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl RepositionMakeTargetList
	ldr r0,=RepositionTargetSelection
	blh StartTargetSelection
	mov r0,#SELECTION_DONE
	pop {r1}
	bx r1

RepositionSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=RepositionLinks
	ldr r0,[r0,#8]
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

RepositionSelect_OnEnd:
	push {lr}
	blh HideMoveRangeGfx
	blh ClearBG0BG1
	pop {r1}
	bx r1

RepositionSelect_OnSwitchIn:
	push {lr}
	mov r2,r1
	mov r0,#0
	ldrsb r0,[r2,r0]
	mov r1,#1
	ldrsb r1,[r2,r1]
	blh ChangeActiveUnitFacing
	pop {r1}
	bx r1

RepositionSelect_OnSelect:
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
	lsl r1,r1,#1
	sub r1,r1,r0                @ dest x = 2*ax - tx
	mov r0,#1
	ldrsb r0,[r4,r0]
	lsl r2,r2,#1
	sub r2,r2,r0                @ dest y
	ldr r3,=gActionData
	mov r0,#RepositionActionID
	strb r0,[r3,#0x11]
	ldrb r0,[r4,#2]
	strb r0,[r3,#0x0D]
	strb r1,[r3,#0x13]
	strb r2,[r3,#0x14]
	mov r0,#SELECTION_DONE
	pop {r4}
	pop {r1}
	bx r1

RepositionActionEntry:
	mov r0,r5
	bl RepositionAction
	pop {r4,r5}
	pop {r1}
	bx r1

RepositionAction:
	push {r4,r5,r6,r7,lr}
	mov r6,r0
	ldr r4,=gActionData
	ldrb r0,[r4,#0x0D]
	blh GetUnit
	mov r5,r0
	cmp r5,#0
	beq RepositionAction_Done
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
	mov r0,#0x14
	ldrsb r0,[r4,r0]
	strb r0,[r5,#0x11]
	blh RefreshEntityMaps
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldr r1,[r0,#0xC]
	mov r2,#US_UNSELECTABLE
	orr r1,r2
	str r1,[r0,#0xC]
RepositionAction_Done:
	mov r0,#0
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

.ltorg
.align 4
RepositionTargetSelection:
	.word RepositionSelect_OnInit+1
	.word RepositionSelect_OnEnd+1
	.word 0
	.word RepositionSelect_OnSwitchIn+1
	.word 0
	.word RepositionSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0
.align 4
RepositionLinks:
