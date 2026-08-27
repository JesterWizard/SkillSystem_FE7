.thumb
.align
.include "../HeroesMoveFE7.inc"

@ ============================================================================
@ Sacrifice (FE7U)
@
@ Drain the actor's HP (leaving 1) into an adjacent ally, capped at the
@ ally's missing HP, and cure poison/sleep/silence/berserk/sick/petrify.
@ Template: Shove/ShoveAction.s.
@
@ Sacrifice.c is FE8 (gbafe.h, action 0x29, StartTargetSelection 0x0804FA3C).
@ Action 0x29 is above ApplyUnitAction's 0x1B ceiling, so the command could
@ never run.  Every vanilla nop slot with PlayerPhase's default path
@ 0x0801CB68 is already taken by Summon/Shove/Smite/Reposition/Swarp/
@ DrawBack/Pivot/Swap.
@
@ Action 0x1C is the next id PlayerPhase will still dispatch (cmp r0,#0x1F
@ at 0x0801CA66; table[0x1C] is already 0x0801CB68).  0x1D is the same.
@ 0x1E's PlayerPhase slot is 0x0801CB4C; UnitMenuSkills.event repoints it
@ at 0x0801CB68.  ApplyUnitAction's compare is only 0x1A, and the pointer
@ table at 0x0802F248 is flush against the Wait handler -- it cannot grow.
@ ApplyUnitActionFE7 replaces 0x0802F218: ids 1..0x1B still index that
@ table, 0x1C.. index HighActionTable.
@ ============================================================================

.equ SacrificeActionID,          0x1C
.equ ArdentSacrificeActionID,    0x1D
.equ ReciprocalAidActionID,      0x1E
.equ SacrificeActionIndex,       0x1B
.equ SacrificeHighLast,          2
.equ ArdentHealCap,              10
.equ U_MAXHP,                    0x12
.equ U_CURHP,                    0x13
.equ U_STATUS,                   0x30
.equ STATUS_NIBBLE,              0x0F
.equ STATUS_SICK,                9
.equ STATUS_PETRIFY,             11

.global ApplyUnitActionFE7
.type   ApplyUnitActionFE7, %function
.global SacrificeMakeTargetList
.type   SacrificeMakeTargetList, %function
.global SacrificeUsability
.type   SacrificeUsability, %function
.global SacrificeEffect
.type   SacrificeEffect, %function
.global SacrificeActionEntry
.type   SacrificeActionEntry, %function
.global SacrificeDoAction
.type   SacrificeDoAction, %function
.global ArdentSacrificeMakeTargetList
.type   ArdentSacrificeMakeTargetList, %function
.global ArdentSacrificeUsability
.type   ArdentSacrificeUsability, %function
.global ArdentSacrificeEffect
.type   ArdentSacrificeEffect, %function
.global ArdentSacrificeActionEntry
.type   ArdentSacrificeActionEntry, %function
.global ArdentSacrificeDoAction
.type   ArdentSacrificeDoAction, %function
.global ReciprocalAidMakeTargetList
.type   ReciprocalAidMakeTargetList, %function
.global ReciprocalAidUsability
.type   ReciprocalAidUsability, %function
.global ReciprocalAidEffect
.type   ReciprocalAidEffect, %function
.global ReciprocalAidActionEntry
.type   ReciprocalAidActionEntry, %function
.global ReciprocalAidDoAction
.type   ReciprocalAidDoAction, %function
.global SacrificeTargetSelection
.global ArdentSacrificeTargetSelection
.global ReciprocalAidTargetSelection
.global HighActionTable
.global SacrificeLinks

@ ---------------------------------------------------------------------------
@ Drop-in for ApplyUnitAction (0x0802F218).  Same prologue: parent proc in
@ r5, gActiveUnit rewritten from gActionData+0x0C, then mov pc into the
@ handler.  Handlers still unwind that {r4,r5,lr} frame themselves.
@ ---------------------------------------------------------------------------
ApplyUnitActionFE7:
	push {r4,r5,lr}
	mov r5,r0
	ldr r4,=gActionData
	ldrb r0,[r4,#0xC]
	blh GetUnit
	ldr r1,=gActiveUnit
	str r0,[r1]
	ldrb r0,[r4,#0x11]
	sub r0,#1
	cmp r0,#0x1A
	bls ApplyUnitAction_Vanilla
	sub r0,#SacrificeActionIndex
	cmp r0,#SacrificeHighLast
	bhi ApplyUnitAction_Default
	lsl r0,r0,#2
	ldr r1,=HighActionTable
	ldr r0,[r1,r0]
	cmp r0,#0
	beq ApplyUnitAction_Default
	mov pc,r0
ApplyUnitAction_Vanilla:
	lsl r0,r0,#2
	ldr r1,=0x0802F248
	ldr r0,[r1,r0]
	mov pc,r0
ApplyUnitAction_Default:
	mov r0,#1
	pop {r4,r5}
	pop {r1}
	bx r1
.ltorg

@ True when the status nibble is one Sacrifice will clear.
SacrificeStatusIsCurable:
	mov r1,#STATUS_NIBBLE
	and r0,r1
	cmp r0,#0
	beq SacrificeStatusIsCurable_No
	cmp r0,#4
	bls SacrificeStatusIsCurable_Yes
	cmp r0,#STATUS_SICK
	beq SacrificeStatusIsCurable_Yes
	cmp r0,#STATUS_PETRIFY
	beq SacrificeStatusIsCurable_Yes
SacrificeStatusIsCurable_No:
	mov r0,#0
	bx lr
SacrificeStatusIsCurable_Yes:
	mov r0,#1
	bx lr

SacrificeTryAddUnit:
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
	beq SacrificeTryAddUnit_Ret
	mov r0,r7
	blh GetUnit
	cmp r0,#0
	beq SacrificeTryAddUnit_Ret
	mov r6,r0
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	cmp r0,r6
	beq SacrificeTryAddUnit_Ret
	ldr r0,[r6,#0xC]
	mov r1,#US_RESCUED
	and r0,r1
	cmp r0,#0
	bne SacrificeTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldrb r0,[r0,#0x0B]
	ldrb r1,[r6,#0x0B]
	blh AreAllegiancesAllied
	cmp r0,#0
	beq SacrificeTryAddUnit_Ret
	ldrb r0,[r6,#U_CURHP]
	ldrb r1,[r6,#U_MAXHP]
	cmp r0,r1
	bcc SacrificeTryAddUnit_Add
	mov r1,#U_STATUS
	ldrb r0,[r6,r1]
	bl SacrificeStatusIsCurable
	cmp r0,#0
	beq SacrificeTryAddUnit_Ret
SacrificeTryAddUnit_Add:
	mov r0,r4
	mov r1,r5
	mov r2,r7
	mov r3,#0
	blh AddTarget, r7
SacrificeTryAddUnit_Ret:
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

SacrificeMakeTargetList:
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
	ldr r2,=SacrificeTryAddUnit+1
	blh ForEachAdjacentPosition
	pop {r4,r5}
	pop {r0}
	bx r0

SacrificeUsability:
	push {r4,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	ldrb r0,[r4,#U_CURHP]
	cmp r0,#1
	bls SacrificeUsability_No
	ldr r0,[r4,#0xC]
	mov r1,#US_UNSELECTABLE
	and r0,r1
	cmp r0,#0
	bne SacrificeUsability_No
	ldr r0,=SacrificeLinks
	ldr r3,[r0,#0]
	ldr r1,[r0,#4]
	mov r0,r4
	mov lr,r3
	.short 0xF800
	cmp r0,#0
	beq SacrificeUsability_No
	mov r0,r4
	bl SacrificeMakeTargetList
	blh GetTargetListSize
	cmp r0,#0
	beq SacrificeUsability_No
	mov r0,#MENU_ENABLED
	b SacrificeUsability_Ret
SacrificeUsability_No:
	mov r0,#MENU_HIDDEN
SacrificeUsability_Ret:
	pop {r4}
	pop {r1}
	bx r1

SacrificeEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl SacrificeMakeTargetList
	ldr r0,=SacrificeTargetSelection
	blh StartTargetSelection
	mov r0,#SELECTION_DONE
	pop {r1}
	bx r1

SacrificeSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=SacrificeLinks
	ldr r0,[r0,#8]
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

SacrificeSelect_OnEnd:
	push {lr}
	blh HideMoveRangeGfx
	blh ClearBG0BG1
	pop {r1}
	bx r1

SacrificeSelect_OnSwitchIn:
	push {lr}
	mov r2,r1
	mov r0,#0
	ldrsb r0,[r2,r0]
	mov r1,#1
	ldrsb r1,[r2,r1]
	blh ChangeActiveUnitFacing
	pop {r1}
	bx r1

SacrificeSelect_OnSelect:
	ldr r2,=gActionData
	mov r0,#SacrificeActionID
	strb r0,[r2,#0x11]
	ldrb r0,[r1,#2]
	strb r0,[r2,#0x0D]
	mov r0,#SELECTION_DONE
	bx lr

SacrificeActionEntry:
	mov r0,r5
	bl SacrificeDoAction
	pop {r4,r5}
	pop {r1}
	bx r1

@ r0 = parent proc (unused: no blocking child; HP is applied immediately).
SacrificeDoAction:
	push {r4,r5,r6,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	cmp r4,#0
	beq SacrificeAction_Done
	ldr r0,=gActionData
	ldrb r0,[r0,#0x0D]
	blh GetUnit
	cmp r0,#0
	beq SacrificeAction_Done
	mov r5,r0

	ldrb r6,[r4,#U_CURHP]
	sub r6,#1
	ldrb r0,[r5,#U_MAXHP]
	ldrb r1,[r5,#U_CURHP]
	sub r0,r1
	cmp r6,r0
	bls SacrificeAction_Apply
	mov r6,r0
SacrificeAction_Apply:
	ldrb r0,[r4,#U_CURHP]
	sub r0,r6
	strb r0,[r4,#U_CURHP]
	ldrb r0,[r5,#U_CURHP]
	add r0,r6
	strb r0,[r5,#U_CURHP]

	mov r1,#U_STATUS
	ldrb r0,[r5,r1]
	bl SacrificeStatusIsCurable
	cmp r0,#0
	beq SacrificeAction_Moved
	mov r0,#0
	mov r1,#U_STATUS
	strb r0,[r5,r1]
SacrificeAction_Moved:
	ldr r1,[r4,#0xC]
	mov r2,#US_UNSELECTABLE
	orr r1,r2
	str r1,[r4,#0xC]
	blh RefreshEntityMaps
SacrificeAction_Done:
	mov r0,#0
	pop {r4,r5,r6}
	pop {r1}
	bx r1
.ltorg

@ ---------------------------------------------------------------------------
@ Ardent Sacrifice: same drain as Sacrifice, capped at 10, no status cure.
@ Targeting is vanilla heal: adjacent allied, hurt, not rescued.
@ ---------------------------------------------------------------------------
ArdentTryAddUnit:
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
	beq ArdentTryAddUnit_Ret
	mov r0,r7
	blh GetUnit
	cmp r0,#0
	beq ArdentTryAddUnit_Ret
	mov r6,r0
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	cmp r0,r6
	beq ArdentTryAddUnit_Ret
	ldr r0,[r6,#0xC]
	mov r1,#US_RESCUED
	and r0,r1
	cmp r0,#0
	bne ArdentTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldrb r0,[r0,#0x0B]
	ldrb r1,[r6,#0x0B]
	blh AreAllegiancesAllied
	cmp r0,#0
	beq ArdentTryAddUnit_Ret
	ldrb r0,[r6,#U_CURHP]
	ldrb r1,[r6,#U_MAXHP]
	cmp r0,r1
	bcs ArdentTryAddUnit_Ret
	mov r0,r4
	mov r1,r5
	mov r2,r7
	mov r3,#0
	blh AddTarget, r7
ArdentTryAddUnit_Ret:
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

ArdentSacrificeMakeTargetList:
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
	ldr r2,=ArdentTryAddUnit+1
	blh ForEachAdjacentPosition
	pop {r4,r5}
	pop {r0}
	bx r0

ArdentSacrificeUsability:
	push {r4,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	ldrb r0,[r4,#U_CURHP]
	cmp r0,#1
	bls ArdentUsability_No
	ldr r0,[r4,#0xC]
	mov r1,#US_UNSELECTABLE
	and r0,r1
	cmp r0,#0
	bne ArdentUsability_No
	ldr r0,=SacrificeLinks
	ldr r3,[r0,#0]
	ldr r1,[r0,#12]
	mov r0,r4
	mov lr,r3
	.short 0xF800
	cmp r0,#0
	beq ArdentUsability_No
	mov r0,r4
	bl ArdentSacrificeMakeTargetList
	blh GetTargetListSize
	cmp r0,#0
	beq ArdentUsability_No
	mov r0,#MENU_ENABLED
	b ArdentUsability_Ret
ArdentUsability_No:
	mov r0,#MENU_HIDDEN
ArdentUsability_Ret:
	pop {r4}
	pop {r1}
	bx r1

ArdentSacrificeEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl ArdentSacrificeMakeTargetList
	ldr r0,=ArdentSacrificeTargetSelection
	blh StartTargetSelection
	mov r0,#SELECTION_DONE
	pop {r1}
	bx r1

ArdentSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=SacrificeLinks
	ldr r0,[r0,#16]
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

ArdentSelect_OnSelect:
	ldr r2,=gActionData
	mov r0,#ArdentSacrificeActionID
	strb r0,[r2,#0x11]
	ldrb r0,[r1,#2]
	strb r0,[r2,#0x0D]
	mov r0,#SELECTION_DONE
	bx lr

ArdentSacrificeActionEntry:
	mov r0,r5
	bl ArdentSacrificeDoAction
	pop {r4,r5}
	pop {r1}
	bx r1

ArdentSacrificeDoAction:
	push {r4,r5,r6,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	cmp r4,#0
	beq ArdentAction_Done
	ldr r0,=gActionData
	ldrb r0,[r0,#0x0D]
	blh GetUnit
	cmp r0,#0
	beq ArdentAction_Done
	mov r5,r0
	ldrb r6,[r4,#U_CURHP]
	sub r6,#1
	ldrb r0,[r5,#U_MAXHP]
	ldrb r1,[r5,#U_CURHP]
	sub r0,r1
	cmp r6,r0
	bls ArdentAction_Cap10
	mov r6,r0
ArdentAction_Cap10:
	cmp r6,#ArdentHealCap
	bls ArdentAction_Apply
	mov r6,#ArdentHealCap
ArdentAction_Apply:
	ldrb r0,[r4,#U_CURHP]
	sub r0,r6
	strb r0,[r4,#U_CURHP]
	ldrb r0,[r5,#U_CURHP]
	add r0,r6
	strb r0,[r5,#U_CURHP]
	ldr r1,[r4,#0xC]
	mov r2,#US_UNSELECTABLE
	orr r1,r2
	str r1,[r4,#0xC]
	blh RefreshEntityMaps
ArdentAction_Done:
	mov r0,#0
	pop {r4,r5,r6}
	pop {r1}
	bx r1
.ltorg

@ ---------------------------------------------------------------------------
@ Reciprocal Aid: swap current HP, each capped at their own max.
@ ---------------------------------------------------------------------------
ReciprocalTryAddUnit:
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
	beq ReciprocalTryAddUnit_Ret
	mov r0,r7
	blh GetUnit
	cmp r0,#0
	beq ReciprocalTryAddUnit_Ret
	mov r6,r0
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	cmp r0,r6
	beq ReciprocalTryAddUnit_Ret
	ldr r0,[r6,#0xC]
	mov r1,#US_RESCUED
	and r0,r1
	cmp r0,#0
	bne ReciprocalTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldrb r0,[r0,#0x0B]
	ldrb r1,[r6,#0x0B]
	blh AreAllegiancesAllied
	cmp r0,#0
	beq ReciprocalTryAddUnit_Ret
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	ldrb r1,[r0,#U_CURHP]
	ldrb r2,[r0,#U_MAXHP]
	ldrb r3,[r6,#U_CURHP]
	ldrb r0,[r6,#U_MAXHP]
	cmp r1,r2
	bne ReciprocalTryAddUnit_TargetFull
	cmp r3,r0
	beq ReciprocalTryAddUnit_Ret
ReciprocalTryAddUnit_TargetFull:
	cmp r3,r0
	bne ReciprocalTryAddUnit_Add
	cmp r0,r1
	bcc ReciprocalTryAddUnit_Ret
ReciprocalTryAddUnit_Add:
	mov r0,r4
	mov r1,r5
	mov r2,r7
	mov r3,#0
	blh AddTarget, r7
ReciprocalTryAddUnit_Ret:
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

ReciprocalAidMakeTargetList:
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
	ldr r2,=ReciprocalTryAddUnit+1
	blh ForEachAdjacentPosition
	pop {r4,r5}
	pop {r0}
	bx r0

ReciprocalAidUsability:
	push {r4,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	ldr r0,[r4,#0xC]
	mov r1,#US_UNSELECTABLE
	and r0,r1
	cmp r0,#0
	bne ReciprocalUsability_No
	ldr r0,=SacrificeLinks
	ldr r3,[r0,#0]
	ldr r1,[r0,#20]
	mov r0,r4
	mov lr,r3
	.short 0xF800
	cmp r0,#0
	beq ReciprocalUsability_No
	mov r0,r4
	bl ReciprocalAidMakeTargetList
	blh GetTargetListSize
	cmp r0,#0
	beq ReciprocalUsability_No
	mov r0,#MENU_ENABLED
	b ReciprocalUsability_Ret
ReciprocalUsability_No:
	mov r0,#MENU_HIDDEN
ReciprocalUsability_Ret:
	pop {r4}
	pop {r1}
	bx r1

ReciprocalAidEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl ReciprocalAidMakeTargetList
	ldr r0,=ReciprocalAidTargetSelection
	blh StartTargetSelection
	mov r0,#SELECTION_DONE
	pop {r1}
	bx r1

ReciprocalSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=SacrificeLinks
	ldr r0,[r0,#24]
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

ReciprocalSelect_OnSelect:
	ldr r2,=gActionData
	mov r0,#ReciprocalAidActionID
	strb r0,[r2,#0x11]
	ldrb r0,[r1,#2]
	strb r0,[r2,#0x0D]
	mov r0,#SELECTION_DONE
	bx lr

ReciprocalAidActionEntry:
	mov r0,r5
	bl ReciprocalAidDoAction
	pop {r4,r5}
	pop {r1}
	bx r1

ReciprocalAidDoAction:
	push {r4,r5,r6,r7,lr}
	ldr r4,=gActiveUnit
	ldr r4,[r4]
	cmp r4,#0
	beq ReciprocalAction_Done
	ldr r0,=gActionData
	ldrb r0,[r0,#0x0D]
	blh GetUnit
	cmp r0,#0
	beq ReciprocalAction_Done
	mov r5,r0
	ldrb r6,[r4,#U_CURHP]
	ldrb r7,[r5,#U_CURHP]
	cmp r7,r6
	bhs ReciprocalAction_HealActor
	sub r0,r6,r7
	ldrb r1,[r5,#U_MAXHP]
	sub r1,r7
	cmp r0,r1
	bls ReciprocalAction_ToTarget
	mov r0,r1
ReciprocalAction_ToTarget:
	sub r6,r0
	add r7,r0
	b ReciprocalAction_Write
ReciprocalAction_HealActor:
	sub r0,r7,r6
	ldrb r1,[r4,#U_MAXHP]
	sub r1,r6
	cmp r0,r1
	bls ReciprocalAction_ToActor
	mov r0,r1
ReciprocalAction_ToActor:
	sub r7,r0
	add r6,r0
ReciprocalAction_Write:
	strb r6,[r4,#U_CURHP]
	strb r7,[r5,#U_CURHP]
	ldr r1,[r4,#0xC]
	mov r2,#US_UNSELECTABLE
	orr r1,r2
	str r1,[r4,#0xC]
	blh RefreshEntityMaps
ReciprocalAction_Done:
	mov r0,#0
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

.ltorg
.align 4
SacrificeTargetSelection:
	.word SacrificeSelect_OnInit+1
	.word SacrificeSelect_OnEnd+1
	.word 0
	.word SacrificeSelect_OnSwitchIn+1
	.word 0
	.word SacrificeSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0

.align 4
ArdentSacrificeTargetSelection:
	.word ArdentSelect_OnInit+1
	.word SacrificeSelect_OnEnd+1
	.word 0
	.word SacrificeSelect_OnSwitchIn+1
	.word 0
	.word ArdentSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0

.align 4
ReciprocalAidTargetSelection:
	.word ReciprocalSelect_OnInit+1
	.word SacrificeSelect_OnEnd+1
	.word 0
	.word SacrificeSelect_OnSwitchIn+1
	.word 0
	.word ReciprocalSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0

.align 4
HighActionTable:
	.word SacrificeActionEntry
	.word ArdentSacrificeActionEntry
	.word ReciprocalAidActionEntry

.align 4
@ Filled in by UnitMenuSkills.event:
@ POIN SkillTester
@ WORD SacrificeID
@ WORD UM_SacrificeDesc
@ WORD ArdentSacrificeID
@ WORD UM_ArdentSacrificeDesc
@ WORD ReciprocalAidID
@ WORD UM_ReciprocalAidDesc
SacrificeLinks:
