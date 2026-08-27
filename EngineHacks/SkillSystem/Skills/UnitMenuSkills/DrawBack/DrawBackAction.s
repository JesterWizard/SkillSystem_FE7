.thumb
.align
.include "../HeroesMoveFE7.inc"

@ ============================================================================
@ Draw Back (FE7U)
@
@ Step one tile away from an adjacent ally; the ally occupies the tile the
@ actor left.  Template: Shove/ShoveAction.s.
@ Action id 0x15 is a vanilla nop slot.  Sacrifice.c's DrawBack used 0x28,
@ which ApplyUnitAction drops.
@ ============================================================================

.equ DrawBackActionID, 0x15

.global DrawBackMakeTargetList
.type   DrawBackMakeTargetList, %function
.global DrawBackUsability
.type   DrawBackUsability, %function
.global DrawBackEffect
.type   DrawBackEffect, %function
.global DrawBackActionEntry
.type   DrawBackActionEntry, %function
.global DrawBackDoAction
.type   DrawBackDoAction, %function
.global DrawBackTargetSelection
.global DrawBackLinks

@ r0=x r1=y r2=unit r3=occupant to ignore (0 = none).
DrawBackCanStand:
	push {r4,r5,r6,r7,lr}
	mov r4,r0
	mov r5,r1
	mov r6,r2
	mov r7,r3
	cmp r4,#0
	blt DrawBackCanStand_No
	cmp r5,#0
	blt DrawBackCanStand_No
	ldr r0,=gMapSize
	ldrh r1,[r0,#0]
	cmp r4,r1
	bge DrawBackCanStand_No
	ldrh r1,[r0,#2]
	cmp r5,r1
	bge DrawBackCanStand_No
	lsl r5,r5,#2
	ldr r0,=ppMapUnit
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	cmp r0,#0
	beq DrawBackCanStand_Hidden
	cmp r7,#0
	beq DrawBackCanStand_No
	cmp r0,r7
	bne DrawBackCanStand_No
DrawBackCanStand_Hidden:
	ldr r0,=ppMapHidden
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	mov r1,#1
	and r0,r1
	cmp r0,#0
	bne DrawBackCanStand_No
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
	beq DrawBackCanStand_No
	mov r0,#1
	b DrawBackCanStand_Ret
DrawBackCanStand_No:
	mov r0,#0
DrawBackCanStand_Ret:
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

DrawBackTryAddUnit:
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
	beq DrawBackTryAddUnit_Ret
	mov r0,r7
	blh GetUnit
	cmp r0,#0
	beq DrawBackTryAddUnit_Ret
	mov r6,r0
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	cmp r0,r6
	beq DrawBackTryAddUnit_Ret
	ldr r0,[r6,#0xC]
	mov r1,#US_RESCUED
	and r0,r1
	cmp r0,#0
	bne DrawBackTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldrb r0,[r0,#0x0B]
	ldrb r1,[r6,#0x0B]
	blh AreAllegiancesAllied
	cmp r0,#0
	beq DrawBackTryAddUnit_Ret
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
	mov r2,r0
	mov r0,r3
	mov r3,#0                   @ dest must be empty
	bl DrawBackCanStand
	cmp r0,#0
	beq DrawBackTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	mov r1,#0x10
	ldrsb r1,[r0,r1]
	mov r2,#0x11
	ldrsb r2,[r0,r2]
	ldrb r3,[r0,#0x0B]
	mov r0,r1
	mov r1,r2
	mov r2,r6
	bl DrawBackCanStand
	cmp r0,#0
	beq DrawBackTryAddUnit_Ret
	mov r0,r4
	mov r1,r5
	mov r2,r7
	mov r3,#0
	blh AddTarget, r7
DrawBackTryAddUnit_Ret:
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

DrawBackMakeTargetList:
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
	ldr r2,=DrawBackTryAddUnit+1
	blh ForEachAdjacentPosition
	pop {r4,r5}
	pop {r0}
	bx r0

DrawBackUsability:
	push {r4,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	ldr r0,[r4,#0xC]
	mov r1,#US_UNSELECTABLE
	and r0,r1
	cmp r0,#0
	bne DrawBackUsability_No
	ldr r0,=DrawBackLinks
	ldr r3,[r0,#0]
	ldr r1,[r0,#4]
	mov r0,r4
	mov lr,r3
	.short 0xF800
	cmp r0,#0
	beq DrawBackUsability_No
	mov r0,r4
	bl DrawBackMakeTargetList
	blh GetTargetListSize
	cmp r0,#0
	beq DrawBackUsability_No
	mov r0,#MENU_ENABLED
	b DrawBackUsability_Ret
DrawBackUsability_No:
	mov r0,#MENU_HIDDEN
DrawBackUsability_Ret:
	pop {r4}
	pop {r1}
	bx r1

DrawBackEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl DrawBackMakeTargetList
	ldr r0,=DrawBackTargetSelection
	blh StartTargetSelection
	mov r0,#SELECTION_DONE
	pop {r1}
	bx r1

DrawBackSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=DrawBackLinks
	ldr r0,[r0,#8]
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

DrawBackSelect_OnEnd:
	push {lr}
	blh HideMoveRangeGfx
	blh ClearBG0BG1
	pop {r1}
	bx r1

DrawBackSelect_OnSwitchIn:
	push {lr}
	mov r2,r1
	mov r0,#0
	ldrsb r0,[r2,r0]
	mov r1,#1
	ldrsb r1,[r2,r1]
	blh ChangeActiveUnitFacing
	pop {r1}
	bx r1

DrawBackSelect_OnSelect:
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
	sub r2,r2,r0
	ldr r3,=gActionData
	mov r0,#DrawBackActionID
	strb r0,[r3,#0x11]
	ldrb r0,[r4,#2]
	strb r0,[r3,#0x0D]
	strb r1,[r3,#0x13]
	strb r2,[r3,#0x14]
	mov r0,#SELECTION_DONE
	pop {r4}
	pop {r1}
	bx r1

DrawBackActionEntry:
	mov r0,r5
	bl DrawBackDoAction
	pop {r4,r5}
	pop {r1}
	bx r1

DrawBackDoAction:
	push {r4,r5,r6,r7,lr}
	mov r6,r0                   @ parent proc
	ldr r0,=gActiveUnit
	ldr r5,[r0]
	cmp r5,#0
	beq DrawBackAction_Done
	ldr r4,=gActionData
	ldrb r0,[r4,#0x0D]
	blh GetUnit
	cmp r0,#0
	beq DrawBackAction_Done
	push {r0}                   @ target
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
	pop {r7}                    @ target
	mov r0,#0x10
	ldrsb r0,[r5,r0]
	mov r1,#0x11
	ldrsb r1,[r5,r1]
	mov r2,#0x10
	ldrsb r2,[r7,r2]
	mov r3,#0x11
	ldrsb r3,[r7,r3]
	push {r7}
	blh GetFacingFromTo, r7
	mov r1,r0
	pop {r0}                    @ target
	mov r2,#1
	mov r3,r6
	blh NewUnitMoveProc, r7
	ldr r4,=gActionData
	ldr r0,=gActiveUnit
	ldr r5,[r0]
	ldrb r0,[r4,#0x0D]
	blh GetUnit
	mov r7,r0
	mov r0,#0x10
	ldrsb r0,[r5,r0]
	mov r1,#0x11
	ldrsb r1,[r5,r1]
	strb r0,[r7,#0x10]
	strb r1,[r7,#0x11]
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
DrawBackAction_Done:
	mov r0,#0
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

.ltorg
.align 4
DrawBackTargetSelection:
	.word DrawBackSelect_OnInit+1
	.word DrawBackSelect_OnEnd+1
	.word 0
	.word DrawBackSelect_OnSwitchIn+1
	.word 0
	.word DrawBackSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0
.align 4
DrawBackLinks:
