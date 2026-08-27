.thumb
.align

@ ============================================================================
@ Shove (FE7U)
@
@ Push one adjacent unit a single tile directly away from the shover.
@
@ Why this exists instead of the HeroesMovement version
@ ----------------------------------------------------
@ UnitMenuSkills/HeroesMovement ships Shove as prebuilt .bin blobs that were
@ never rebuilt for FE7.  Their literal pools are pure FE8: gActiveUnit
@ 0x03004E50 (FE7: 0x03004690), gActionData 0x0203A958 (FE7: 0x0203A85C),
@ StartTargetSelection 0x0804FA3C (FE7: 0x0804AE88), GetUnit 0x08019430
@ (FE7: 0x08018D0C), the movement/range maps at 0x0202E4E0/E4E4 (FE7:
@ 0x0202E3E4/E3E8).  The .s sources next to them were partly re-pointed at FE7
@ addresses but nothing reassembles them -- the event files #incbin the stale
@ .bin -- so the command could not work no matter how it was wired.
@
@ The action id was dead as well.  ShoveSelection_OnSelection wrote 0x26, and
@ FE7's ApplyUnitAction (0x0802F218) does `sub r0,#1; cmp r0,#0x1A; bhi` before
@ indexing UnitActionFunctionPointer at 0x0802F248, so every id above 0x1B is
@ dropped on the floor.  0x26 lives in UnitActionRework's table, which patches
@ 0x0803200C -- the middle of a unit-info-window routine, not ApplyUnitAction.
@
@ So Shove is rebuilt here against FE7's own routines, in the shape Summon
@ already uses in this folder, and takes action id 0x0B: never written by
@ vanilla FE7 (verified by reading the immediate at all 39 stores to
@ gActionData+0x11) and pointing at the do-nothing handler 0x0802F31E.
@
@ Vanilla routines this is modelled on:
@   DropUsability            0x0802181C   target list, then GetTargetListSize
@   MakeDropTargetList       0x08023EC4   clear range map, ForEachAdjacentPos
@   DropEffect               0x08021854   StartTargetSelection, returns 0x17
@   DropSelection_OnSelect   0x08021874   action id + tile into gActionData
@   ActionDrop               0x0802F3A4   GetFacingFromTo then Make6CKOIDO
@ ============================================================================

@ --- RAM -------------------------------------------------------------------
.equ gActionData,   0x0203A85C     @ +0x0D target, +0x11 action, +0x13/14 tile
.equ gActiveUnit,   0x03004690
.equ gMapSize,      0x0202E3D8     @ two halfwords
.equ ppMapUnit,     0x0202E3DC
.equ ppMapTerrain,  0x0202E3E0
.equ ppMapRange,    0x0202E3E8
.equ ppMapHidden,   0x0202E3F0

@ --- ROM -------------------------------------------------------------------
.equ ForEachAdjacentPosition, 0x08023AA9  @ r0=x r1=y r2=void(*)(int x,int y)
                                          @ calls InitTargets, so the target
                                          @ list is reset for us
.equ AddTarget,               0x0804ACFD  @ r0=x r1=y r2=uid r3=trap
.equ GetTargetListSize,       0x0804B175
.equ StartTargetSelection,    0x0804AE89
.equ ClearMapWith,            0x080190AD  @ r0=row table, r1=value
.equ GetUnit,                 0x08018D0D
.equ CanUnitCrossTerrain,     0x08018D69  @ r0=unit, r1=terrain id
.equ ChangeActiveUnitFacing,  0x0801EC11  @ r0=x, r1=y
.equ GetStringFromIndex,      0x08012C61
.equ NewBottomHelpText,       0x08032561  @ r0=proc, r1=text in buffer
.equ ClearBG0BG1,             0x0804A041
.equ HideMoveRangeGfx,        0x0801D2D5
.equ SelectionBackToUnitMenu, 0x08021655
.equ RefreshEntityMaps,       0x08019ABD
.equ GetFacingFromTo,         0x0801D3DD  @ r0=toX r1=toY r2=fromX r3=fromY
                                          @ -> 0 left, 1 right, 2 down, 3 up
.equ NewUnitMoveProc,         0x0801D47D  @ Make6CKOIDO: r0=unit, r1=facing,
                                          @ r2=mode, r3=parent proc.  Blocking
                                          @ child that slides the unit one tile.
                                          @ mode 0 keeps the sprite hidden
                                          @ (rescue), 2 leaves the MU alive for
                                          @ a follow-up proc (drop), 1 deletes
                                          @ the MU and refreshes maps+sprites,
                                          @ which is what a plain move wants.

.equ ShoveActionID,   0x0B
.equ US_UNSELECTABLE, 0x40         @ also US_CANTOING; same bit in FE7
.equ MENU_ENABLED,    1
.equ MENU_HIDDEN,     3
.equ SELECTION_DONE,  0x17         @ end + beep + clear gfx, as DropEffect uses

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.global ShoveMakeTargetList
.type   ShoveMakeTargetList, %function
.global ShoveUsability
.type   ShoveUsability, %function
.global ShoveEffect
.type   ShoveEffect, %function
.global ShoveActionEntry
.type   ShoveActionEntry, %function
.global ShoveAction
.type   ShoveAction, %function
.global ShoveTargetSelection
.global ShoveLinks

@ ---------------------------------------------------------------------------
@ r0 = destination x, r1 = destination y, r2 = the unit being pushed.
@ Returns r0 = 1 when that unit can be left standing there.
@
@ The terrain check runs against the PUSHED unit, not the shover: a fighter
@ must not be able to shove a cavalier into a forest the cavalier cannot enter.
@ ---------------------------------------------------------------------------
ShoveCanLand:
	push {r4,r5,r6,lr}
	mov r4,r0
	mov r5,r1
	mov r6,r2

	cmp r4,#0
	blt ShoveCanLand_No
	cmp r5,#0
	blt ShoveCanLand_No
	ldr r0,=gMapSize
	ldrh r1,[r0,#0]
	cmp r4,r1
	bge ShoveCanLand_No
	ldrh r1,[r0,#2]
	cmp r5,r1
	bge ShoveCanLand_No

	lsl r5,r5,#2                @ row pointers are words

	@ another unit already standing there
	ldr r0,=ppMapUnit
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	cmp r0,#0
	bne ShoveCanLand_No

	@ a fog-hidden unit occupies the tile even though the unit map reads 0
	ldr r0,=ppMapHidden
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	mov r1,#1
	and r0,r1
	cmp r0,#0
	bne ShoveCanLand_No

	ldr r0,=ppMapTerrain
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r1,[r0]
	mov r0,r6
	blh CanUnitCrossTerrain
	lsl r0,r0,#24               @ the getter returns a byte
	cmp r0,#0
	beq ShoveCanLand_No

	mov r0,#1
	b ShoveCanLand_Ret
ShoveCanLand_No:
	mov r0,#0
ShoveCanLand_Ret:
	pop {r4,r5,r6}
	pop {r1}
	bx r1

@ ---------------------------------------------------------------------------
@ r0 = x, r1 = y: one of the four tiles around the shover.  Adds the unit
@ standing there to the target list when it can actually be pushed.
@
@ The target list holds the TARGET's tile (that is what the cursor walks); the
@ tile it gets pushed onto is recomputed in ShoveSelect_OnSelect.
@ ---------------------------------------------------------------------------
ShoveTryAddUnit:
	push {r4,r5,r6,r7,lr}
	mov r4,r0
	mov r5,r1

	ldr r0,=ppMapUnit
	ldr r0,[r0]
	lsl r2,r5,#2
	add r0,r2
	ldr r0,[r0]
	add r0,r4
	ldrb r7,[r0]                @ unit index on the tile
	cmp r7,#0
	beq ShoveTryAddUnit_Ret

	mov r0,r7
	blh GetUnit
	cmp r0,#0
	beq ShoveTryAddUnit_Ret
	mov r6,r0                   @ the unit that would be pushed

	ldr r0,=gActiveUnit
	ldr r0,[r0]
	cmp r0,r6
	beq ShoveTryAddUnit_Ret     @ ForEachAdjacentPosition includes the centre

	@ destination = target + (target - shover), i.e. one tile straight on
	mov r1,#0x10
	ldrsb r1,[r0,r1]
	mov r2,#0x11
	ldrsb r2,[r0,r2]
	lsl r3,r4,#1
	sub r3,r3,r1                @ destination x
	lsl r1,r5,#1
	sub r1,r1,r2                @ destination y
	mov r0,r3
	mov r2,r6
	bl ShoveCanLand
	cmp r0,#0
	beq ShoveTryAddUnit_Ret

	@ r3 is AddTarget's fourth argument, so blh must not scratch it
	mov r0,r4
	mov r1,r5
	mov r2,r7
	mov r3,#0
	blh AddTarget, r7

ShoveTryAddUnit_Ret:
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

@ ---------------------------------------------------------------------------
@ r0 = the shover.  Fills the engine target list with every adjacent unit that
@ has somewhere to be pushed.  Same shape as MakeDropTargetList.
@ ---------------------------------------------------------------------------
ShoveMakeTargetList:
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
	ldr r2,=ShoveTryAddUnit+1
	blh ForEachAdjacentPosition

	pop {r4,r5}
	pop {r0}
	bx r0

@ ---------------------------------------------------------------------------
@ Unit-menu usability.  The menu reads the return value directly: 1 shows the
@ command, 2 greys it out, 3 hides it.
@ ---------------------------------------------------------------------------
ShoveUsability:
	push {r4,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]

	@ the unit has already acted, or is cantoing
	ldr r0,[r4,#0xC]
	mov r1,#US_UNSELECTABLE
	and r0,r1
	cmp r0,#0
	bne ShoveUsability_No

	ldr r0,=ShoveLinks
	ldr r3,[r0,#0]              @ SkillTester
	ldr r1,[r0,#4]              @ ShoveID
	mov r0,r4
	mov lr,r3
	.short 0xF800
	cmp r0,#0
	beq ShoveUsability_No

	mov r0,r4
	bl ShoveMakeTargetList
	blh GetTargetListSize
	cmp r0,#0
	beq ShoveUsability_No

	mov r0,#MENU_ENABLED
	b ShoveUsability_Ret
ShoveUsability_No:
	mov r0,#MENU_HIDDEN
ShoveUsability_Ret:
	pop {r4}
	pop {r1}
	bx r1

@ ---------------------------------------------------------------------------
@ Unit-menu effect: hand the shovable units to a target selection.
@ ---------------------------------------------------------------------------
ShoveEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl ShoveMakeTargetList
	ldr r0,=ShoveTargetSelection
	blh StartTargetSelection
	mov r0,#SELECTION_DONE
	pop {r1}
	bx r1

@ ---------------------------------------------------------------------------
@ Target-selection callbacks.
@ ---------------------------------------------------------------------------
ShoveSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=ShoveLinks
	ldr r0,[r0,#8]              @ bottom-help text id
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

ShoveSelect_OnEnd:
	push {lr}
	blh HideMoveRangeGfx
	blh ClearBG0BG1
	pop {r1}
	bx r1

@ r0 = proc, r1 = highlighted entry.  Turn the shover towards it.
ShoveSelect_OnSwitchIn:
	push {lr}
	mov r2,r1
	mov r0,#0
	ldrsb r0,[r2,r0]
	mov r1,#1
	ldrsb r1,[r2,r1]
	blh ChangeActiveUnitFacing
	pop {r1}
	bx r1

@ r0 = proc, r1 = chosen entry.  Same shape as DropSelection_OnSelect: the
@ tile the unit ends up on goes in gActionData +0x13/+0x14, never in +0x0E/
@ +0x0F -- those hold the shover's own destination and PlayerPhase walks the
@ unit to them.
ShoveSelect_OnSelect:
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
	sub r0,r0,r1                @ destination x
	mov r3,#1
	ldrsb r3,[r4,r3]
	lsl r3,r3,#1
	sub r3,r3,r2                @ destination y

	ldr r2,=gActionData
	mov r1,#ShoveActionID
	strb r1,[r2,#0x11]
	ldrb r1,[r4,#2]             @ target unit index
	strb r1,[r2,#0x0D]
	strb r0,[r2,#0x13]
	strb r3,[r2,#0x14]

	mov r0,#SELECTION_DONE
	pop {r4}
	pop {r1}
	bx r1

@ ---------------------------------------------------------------------------
@ Action-table entry.  ApplyUnitAction enters handlers with `mov pc` after its
@ own `push {r4,r5,lr}`, leaving the parent proc in r5, so the frame is unwound
@ here exactly like the vanilla handlers at 0x0802F2B4..0x0802F31E do.
@ ---------------------------------------------------------------------------
ShoveActionEntry:
	mov r0,r5
	bl ShoveAction
	pop {r4,r5}
	pop {r1}
	bx r1

@ ---------------------------------------------------------------------------
@ r0 = parent proc.  Slide the chosen unit onto the tile the selection picked,
@ then end the shover's turn.
@
@ Returns 0, like every vanilla handler that leaves something running.
@ ApplyUnitAction is entry 0x0802F219 of the map-main proc script, run under
@ proc command 0x16: nonzero means "run the next script command this frame",
@ zero means "stop the script for this frame".  Returning 0 buys one frame; the
@ blocking child NewUnitMoveProc parks on this proc is what holds the action
@ open until the unit has finished moving.
@ ---------------------------------------------------------------------------
ShoveAction:
	push {r4,r5,r6,r7,lr}
	mov r6,r0                   @ parent proc

	ldr r4,=gActionData
	ldrb r0,[r4,#0x0D]
	blh GetUnit
	mov r5,r0                   @ the unit being pushed
	cmp r5,#0
	beq ShoveAction_Done

	@ r3 carries an argument into both calls below, so neither blh may use it
	mov r0,#0x13
	ldrsb r0,[r4,r0]
	mov r1,#0x14
	ldrsb r1,[r4,r1]
	mov r2,#0x10
	ldrsb r2,[r5,r2]
	mov r3,#0x11
	ldrsb r3,[r5,r3]
	blh GetFacingFromTo, r7

	@ The MU is built from the unit's CURRENT tile, so the animation has to be
	@ staged before the unit data moves.
	mov r1,r0                   @ facing
	mov r0,r5
	mov r2,#1                   @ delete the MU and refresh when the slide ends
	mov r3,r6
	blh NewUnitMoveProc, r7

	mov r0,#0x13
	ldrsb r0,[r4,r0]
	strb r0,[r5,#0x10]
	mov r0,#0x14
	ldrsb r0,[r4,r0]
	strb r0,[r5,#0x11]

	blh RefreshEntityMaps

	@ the shover's turn is over
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldr r1,[r0,#0xC]
	mov r2,#US_UNSELECTABLE
	orr r1,r2
	str r1,[r0,#0xC]

ShoveAction_Done:
	mov r0,#0
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

.ltorg
.align 4

@ TargetSelectionDefinition: init, end, init2, switch-in, switch-out, A, B, R.
ShoveTargetSelection:
	.word ShoveSelect_OnInit+1
	.word ShoveSelect_OnEnd+1
	.word 0
	.word ShoveSelect_OnSwitchIn+1
	.word 0
	.word ShoveSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0

.align 4
@ Filled in by UnitMenuSkills.event, in this order:
@ POIN SkillTester
@ WORD ShoveID
@ WORD UM_ShoveDesc
ShoveLinks:
