.thumb
.align
.include "../HeroesMoveFE7.inc"

@ ============================================================================
@ Smite (FE7U)
@
@ Push one adjacent unit up to two tiles directly away.  Same FE7-native
@ rebuild as Shove (see Shove/ShoveAction.s): HeroesMovement's .bin blobs are
@ FE8 and action id 0x26 is above ApplyUnitAction's 0x1B ceiling.
@
@ Action id 0x11 is a vanilla nop slot (handler 0x0802F31E).
@ ============================================================================

.equ SmiteActionID, 0x11

.global SmiteMakeTargetList
.type   SmiteMakeTargetList, %function
.global SmiteUsability
.type   SmiteUsability, %function
.global SmiteEffect
.type   SmiteEffect, %function
.global SmiteActionEntry
.type   SmiteActionEntry, %function
.global SmiteAction
.type   SmiteAction, %function
.global SmiteTargetSelection
.global SmiteLinks

@ r0=x r1=y r2=unit.  r0=1 if that unit can stand there.
SmiteCanLand:
	push {r4,r5,r6,lr}
	mov r4,r0
	mov r5,r1
	mov r6,r2
	cmp r4,#0
	blt SmiteCanLand_No
	cmp r5,#0
	blt SmiteCanLand_No
	ldr r0,=gMapSize
	ldrh r1,[r0,#0]
	cmp r4,r1
	bge SmiteCanLand_No
	ldrh r1,[r0,#2]
	cmp r5,r1
	bge SmiteCanLand_No
	lsl r5,r5,#2
	ldr r0,=ppMapUnit
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	cmp r0,#0
	bne SmiteCanLand_No
	ldr r0,=ppMapHidden
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	mov r1,#1
	and r0,r1
	cmp r0,#0
	bne SmiteCanLand_No
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
	beq SmiteCanLand_No
	mov r0,#1
	b SmiteCanLand_Ret
SmiteCanLand_No:
	mov r0,#0
SmiteCanLand_Ret:
	pop {r4,r5,r6}
	pop {r1}
	bx r1

@ r0=dx r1=dy r2=tx r3=ty.  Writes dest in r0,r1.  r2=1 if any tile worked.
@ Uses the pushed unit in r6 (caller).
SmiteFarthest:
	push {r4,r5,r7,lr}
	mov r4,r0                   @ dx
	mov r5,r1                   @ dy
	mov r0,r2
	mov r1,r3
	mov r7,#0                   @ none yet
	@ n=1
	add r0,r4
	add r1,r5
	push {r0,r1}
	mov r2,r6
	bl SmiteCanLand
	pop {r2,r3}
	cmp r0,#0
	beq SmiteFarthest_Ret
	mov r7,#1
	mov r0,r2
	mov r1,r3
	@ n=2
	add r2,r4
	add r3,r5
	push {r0,r1}
	mov r0,r2
	mov r1,r3
	mov r2,r6
	bl SmiteCanLand
	mov r2,r0
	pop {r0,r1}
	cmp r2,#0
	beq SmiteFarthest_Ret
	add r0,r4
	add r1,r5
SmiteFarthest_Ret:
	mov r2,r7
	pop {r4,r5,r7}
	pop {r3}
	bx r3

SmiteTryAddUnit:
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
	beq SmiteTryAddUnit_Ret
	mov r0,r7
	blh GetUnit
	cmp r0,#0
	beq SmiteTryAddUnit_Ret
	mov r6,r0
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	cmp r0,r6
	beq SmiteTryAddUnit_Ret
	mov r1,#0x10
	ldrsb r1,[r0,r1]
	mov r2,#0x11
	ldrsb r2,[r0,r2]
	sub r1,r4,r1                @ dx = tx - ax
	sub r2,r5,r2                @ dy
	mov r0,r1
	mov r1,r2
	mov r2,r4
	mov r3,r5
	bl SmiteFarthest
	cmp r2,#0
	beq SmiteTryAddUnit_Ret
	mov r0,r4
	mov r1,r5
	mov r2,r7
	mov r3,#0
	blh AddTarget, r7
SmiteTryAddUnit_Ret:
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

SmiteMakeTargetList:
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
	ldr r2,=SmiteTryAddUnit+1
	blh ForEachAdjacentPosition
	pop {r4,r5}
	pop {r0}
	bx r0

SmiteUsability:
	push {r4,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	ldr r0,[r4,#0xC]
	mov r1,#US_UNSELECTABLE
	and r0,r1
	cmp r0,#0
	bne SmiteUsability_No
	ldr r0,=SmiteLinks
	ldr r3,[r0,#0]
	ldr r1,[r0,#4]
	mov r0,r4
	mov lr,r3
	.short 0xF800
	cmp r0,#0
	beq SmiteUsability_No
	mov r0,r4
	bl SmiteMakeTargetList
	blh GetTargetListSize
	cmp r0,#0
	beq SmiteUsability_No
	mov r0,#MENU_ENABLED
	b SmiteUsability_Ret
SmiteUsability_No:
	mov r0,#MENU_HIDDEN
SmiteUsability_Ret:
	pop {r4}
	pop {r1}
	bx r1

SmiteEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl SmiteMakeTargetList
	ldr r0,=SmiteTargetSelection
	blh StartTargetSelection
	mov r0,#SELECTION_DONE
	pop {r1}
	bx r1

SmiteSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=SmiteLinks
	ldr r0,[r0,#8]
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

SmiteSelect_OnEnd:
	push {lr}
	blh HideMoveRangeGfx
	blh ClearBG0BG1
	pop {r1}
	bx r1

SmiteSelect_OnSwitchIn:
	push {lr}
	mov r2,r1
	mov r0,#0
	ldrsb r0,[r2,r0]
	mov r1,#1
	ldrsb r1,[r2,r1]
	blh ChangeActiveUnitFacing
	pop {r1}
	bx r1

SmiteSelect_OnSelect:
	push {r4,r5,r6,lr}
	mov r4,r1
	ldrb r0,[r4,#2]
	blh GetUnit
	mov r6,r0
	cmp r6,#0
	beq SmiteSelect_OnSelect_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	mov r1,#0x10
	ldrsb r1,[r0,r1]
	mov r2,#0x11
	ldrsb r2,[r0,r2]
	mov r0,#0
	ldrsb r5,[r4,r0]
	mov r0,#1
	ldrsb r3,[r4,r0]
	sub r1,r5,r1
	sub r2,r3,r2
	mov r0,r1
	mov r1,r2
	mov r2,r5
	@ r3 already ty
	bl SmiteFarthest
	ldr r2,=gActionData
	mov r3,#SmiteActionID
	strb r3,[r2,#0x11]
	ldrb r3,[r4,#2]
	strb r3,[r2,#0x0D]
	strb r0,[r2,#0x13]
	strb r1,[r2,#0x14]
SmiteSelect_OnSelect_Ret:
	mov r0,#SELECTION_DONE
	pop {r4,r5,r6}
	pop {r1}
	bx r1

SmiteActionEntry:
	mov r0,r5
	bl SmiteAction
	pop {r4,r5}
	pop {r1}
	bx r1

SmiteAction:
	push {r4,r5,r6,r7,lr}
	mov r6,r0
	ldr r4,=gActionData
	ldrb r0,[r4,#0x0D]
	blh GetUnit
	mov r5,r0
	cmp r5,#0
	beq SmiteAction_Done
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
SmiteAction_Done:
	mov r0,#0
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

.ltorg
.align 4
SmiteTargetSelection:
	.word SmiteSelect_OnInit+1
	.word SmiteSelect_OnEnd+1
	.word 0
	.word SmiteSelect_OnSwitchIn+1
	.word 0
	.word SmiteSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0
.align 4
SmiteLinks:
