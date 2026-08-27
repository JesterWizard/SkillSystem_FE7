.thumb
.align

@ ============================================================================
@ Summon (FE7U)
@
@ FE7 has no summon command of its own -- the entries _UnitMenuDefs.event calls
@ UM_Summon / UM_Summon_DK are Give and Take, and the action ids listed in
@ UnitActionRework's table are FE8's.  So everything here is built on the
@ routines FE7 actually uses for a *tile* selection, which is Drop:
@
@   DropUsability            0x0802181C   MakeDropTargetList, GetTargetListSize
@   MakeDropTargetList       0x08023EC4   ForEachAdjacentPosition
@   TryAddToDropTargetList   0x08023E6C   map checks + AddTarget
@   DropEffect               0x08021854   StartTargetSelection(0x08B95CF8)
@   DropSelection_OnSelect   0x08021874   tile into gActionData +0x13/+0x14
@
@ The action is dispatched by FE7's own ApplyUnitAction (0x0802F218), which
@ indexes UnitActionFunctionPointer at 0x0802F248 by (actionId - 1) and enters
@ the handler with `mov pc`.  UnitMenuSkills.event repoints the entry for
@ action id 0x05 -- an id vanilla FE7 never writes -- at SummonActionEntry.
@ ============================================================================

@ --- RAM -------------------------------------------------------------------
.equ gActionData,        0x0203A85C
.equ gActiveUnit,        0x03004690
.equ gChapterData,       0x0202BBF8
.equ gTargetArray,       0x0203DCF8
.equ ppMapUnit,          0x0202E3DC
.equ ppMapTerrain,       0x0202E3E0
.equ ppMapMovement,      0x0202E3E4
.equ ppMapRange,         0x0202E3E8
.equ ppMapHidden,        0x0202E3F0

@ --- ROM -------------------------------------------------------------------
.equ ClassTable,             0x08BE015C
.equ ForEachAdjacentPosition,0x08023AA9  @ r0=x r1=y r2=void(*)(int x,int y)
.equ AddTarget,              0x0804ACFD  @ r0=x r1=y r2=uid r3=trap
.equ GetTargetListSize,      0x0804B175
.equ StartTargetSelection,   0x0804AE89
.equ MapFill,                0x080190AD  @ r0=row table, r1=value
.equ ShowMoveRangeGfx,       0x0801D2A1  @ r0: &1 blue movement, &2 red, &4 green
.equ HideMoveRangeGfx,       0x0801D2D5
.equ ChangeActiveUnitFacing, 0x0801EC11
.equ GetStringFromIndex,     0x08012C61
.equ NewBottomHelpText,      0x08032561  @ r0=proc, r1=text in buffer
.equ ClearBG0BG1,            0x0804A041
.equ SelectionBackToUnitMenu,0x08021655
.equ SummonAnimation,        0x08073879  @ r0=unit; barrier-style map effect
.equ SummonAnimationProcs,   0x08C9DD24  @ the proc script SummonAnimation runs
.equ Find6C,                 0x080046A9  @ r0=proc script -> r0=proc or 0
.equ InsertChild6C,          0x080045DD  @ r0=proc, r1=new parent
.equ Isolate6C,              0x080045F1  @ r0=proc; unlink from its current list
.equ GetUnit,                0x08018D0D
.equ ClearUnitStruct,        0x08017509
.equ LoadUnit,               0x08017789  @ r0=UnitDefinition* -> r0=Unit*
.equ RefreshEntityMaps,      0x08019ABD
.equ RefreshUnitSprites,     0x08025725
.equ GetGameControlProc,     0x08012B39
.equ SetupBattleStructForStaffUser, 0x0802A4B5  @ r0=Unit, r1=weapon slot (-1 none)
.equ GiveInstigator10Exp,    0x0802A5D1  @ r0=Unit; +10 exp, then blocks on the exp bar
.equ gBattleStatsBitfield,   0x0203A3D8

.equ SummonActionID,         0x05
.equ LastPlayerUnitID,       0x40        @ player deployment slots are 1..0x3F
.equ SignedStatMax,          0x7F        @ GetUnitMaxHP reads maxHP with LDRSB

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.global SummonMakeTargetList
.type   SummonMakeTargetList, %function
.global SummonShowRange
.type   SummonShowRange, %function
.global SummonHover
.type   SummonHover, %function
.global SummonUnhover
.type   SummonUnhover, %function
.global SummonEffect
.type   SummonEffect, %function
.global SummonActionEntry
.type   SummonActionEntry, %function
.global SummonAction
.type   SummonAction, %function
.global SummonClearAll
.type   SummonClearAll, %function
.global SummonSetNextChapter
.type   SummonSetNextChapter, %function
.global SummonLinks

@ ---------------------------------------------------------------------------
@ r0 = summoner.  Fills the engine target list with the cardinal tiles the
@ dragon can be summoned onto.  Same shape as MakeDropTargetList.
@ ---------------------------------------------------------------------------
SummonMakeTargetList:
	push {r4,r5,lr}
	mov r4,#0x10
	ldrsb r4,[r0,r4]
	mov r5,#0x11
	ldrsb r5,[r0,r5]

	ldr r0,=ppMapRange
	ldr r0,[r0]
	mov r1,#0
	blh MapFill

	mov r0,r4
	mov r1,r5
	ldr r2,=SummonTryAddTile+1
	blh ForEachAdjacentPosition

	pop {r4,r5}
	pop {r0}
	bx r0

@ ---------------------------------------------------------------------------
@ r0 = x, r1 = y.  Called back once per adjacent tile.  ForEachAdjacentPosition
@ has already clipped to the map, so only occupancy and terrain are tested.
@ ---------------------------------------------------------------------------
SummonTryAddTile:
	push {r4,r5,r6,lr}
	mov r4,r0
	mov r6,r1
	lsl r5,r6,#2

	ldr r0,=ppMapUnit
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	cmp r0,#0
	bne SummonTryAddTile_Ret

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
	bne SummonTryAddTile_Ret

	ldr r0,=ppMapTerrain
	ldr r0,[r0]
	add r0,r5
	ldr r0,[r0]
	add r0,r4
	ldrb r0,[r0]
	bl SummonCanStandOn
	cmp r0,#0
	beq SummonTryAddTile_Ret

	mov r0,r4
	mov r1,r6
	mov r2,#0
	mov r3,#0
	blh AddTarget

SummonTryAddTile_Ret:
	pop {r4,r5,r6}
	pop {r0}
	bx r0

@ ---------------------------------------------------------------------------
@ r0 = terrain id -> r0 = 1 when the summoned class can stand there.
@ Mirrors GetMovCostTablePtr (0x080187D4) for a class id instead of a unit, so
@ the check follows the dragon's movement type and not the summoner's.
@ ---------------------------------------------------------------------------
SummonCanStandOn:
	push {r4,lr}
	mov r4,r0

	ldr r0,=SummonLinks
	ldr r1,[r0,#4]              @ class id
	mov r2,#0x54
	mul r1,r2
	ldr r0,=ClassTable
	add r0,r1                   @ class data

	ldr r1,=gChapterData
	ldrb r1,[r1,#0x15]          @ 0 clear, 1 snow, 2 snowstorm, 4 rain
	cmp r1,#4
	beq SummonCanStandOn_Rain
	cmp r1,#1
	blt SummonCanStandOn_Clear
	cmp r1,#2
	ble SummonCanStandOn_Snow
SummonCanStandOn_Clear:
	ldr r0,[r0,#0x38]
	b SummonCanStandOn_Lookup
SummonCanStandOn_Rain:
	ldr r0,[r0,#0x3C]
	b SummonCanStandOn_Lookup
SummonCanStandOn_Snow:
	ldr r0,[r0,#0x40]

SummonCanStandOn_Lookup:
	ldrsb r0,[r0,r4]
	cmp r0,#0
	ble SummonCanStandOn_No
	mov r0,#1
	b SummonCanStandOn_Ret
SummonCanStandOn_No:
	mov r0,#0
SummonCanStandOn_Ret:
	pop {r4}
	pop {r1}
	bx r1

@ ---------------------------------------------------------------------------
@ Paint the tiles currently in the target list blue.
@
@ The tile renderer (0x08019454) reads the MOVEMENT map first and only falls
@ through to the range map when that byte is negative, so blue squares come
@ from the movement map: fill it with -1, then drop a 0 on each target tile.
@ ---------------------------------------------------------------------------
SummonShowRange:
	push {r4,r5,r6,r7,lr}
	ldr r0,=ppMapMovement
	ldr r0,[r0]
	mov r1,#1
	neg r1,r1
	blh MapFill

	blh GetTargetListSize
	mov r6,r0
	mov r5,#0
	ldr r7,=gTargetArray

SummonShowRange_Loop:
	cmp r5,r6
	bge SummonShowRange_Done
	mov r0,#0
	ldrsb r0,[r7,r0]
	mov r1,#1
	ldrsb r1,[r7,r1]
	ldr r2,=ppMapMovement
	ldr r2,[r2]
	lsl r3,r1,#2
	add r2,r3
	ldr r2,[r2]
	add r2,r0
	mov r3,#0
	strb r3,[r2]
	add r7,#0xC                 @ sizeof(TargetEntry)
	add r5,#1
	b SummonShowRange_Loop

SummonShowRange_Done:
	mov r0,#1                   @ blue movement squares only
	blh ShowMoveRangeGfx
	pop {r4,r5,r6,r7}
	pop {r0}
	bx r0

@ ---------------------------------------------------------------------------
@ Unit-menu hover / unhover: preview the summonable tiles in blue.
@ ---------------------------------------------------------------------------
SummonHover:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl SummonMakeTargetList
	bl SummonShowRange
	mov r0,#0
	pop {r1}
	bx r1

SummonUnhover:
	push {lr}
	blh HideMoveRangeGfx
	mov r0,#0
	pop {r1}
	bx r1

@ ---------------------------------------------------------------------------
@ Unit-menu effect: hand the blue tiles to a target selection.
@ ---------------------------------------------------------------------------
SummonEffect:
	push {lr}
	ldr r0,=gActiveUnit
	ldr r0,[r0]
	bl SummonMakeTargetList
	bl SummonShowRange
	ldr r0,=SummonTargetSelection
	blh StartTargetSelection
	mov r0,#0x17
	pop {r1}
	bx r1

@ ---------------------------------------------------------------------------
@ Target-selection callbacks.
@ ---------------------------------------------------------------------------
SummonSelect_OnInit:
	push {r4,lr}
	mov r4,r0
	ldr r0,=SummonLinks
	ldr r0,[r0,#0xC]            @ bottom-help text id
	blh GetStringFromIndex
	mov r1,r0
	mov r0,r4
	blh NewBottomHelpText
	pop {r4}
	pop {r0}
	bx r0

SummonSelect_OnEnd:
	push {lr}
	blh HideMoveRangeGfx
	blh ClearBG0BG1
	pop {r1}
	bx r1

@ r0 = proc, r1 = highlighted entry.  Face the summoner at the tile.
SummonSelect_OnSwitchIn:
	push {lr}
	mov r2,r1
	mov r0,#0
	ldrsb r0,[r2,r0]
	mov r1,#1
	ldrsb r1,[r2,r1]
	blh ChangeActiveUnitFacing
	pop {r1}
	bx r1

@ r0 = proc, r1 = chosen entry.  Same shape as DropSelection_OnSelect: the tile
@ goes in gActionData +0x13/+0x14, never in +0x0E/+0x0F -- those hold the
@ summoner's own destination and PlayerPhase moves the unit to them.
SummonSelect_OnSelect:
	ldr r2,=gActionData
	mov r0,#SummonActionID
	strb r0,[r2,#0x11]
	ldrb r0,[r1,#0]
	strb r0,[r2,#0x13]
	ldrb r0,[r1,#1]
	strb r0,[r2,#0x14]
	mov r0,#0x17
	bx lr

@ ---------------------------------------------------------------------------
@ Action-table entry.  ApplyUnitAction enters handlers with `mov pc` after its
@ own `push {r4,r5,lr}`, leaving the parent proc in r5, so the frame is unwound
@ here exactly like the vanilla handlers at 0x0802F2B4..0x0802F31E do.
@ ---------------------------------------------------------------------------
SummonActionEntry:
	mov r0,r5
	bl SummonAction
	pop {r4,r5}
	pop {r1}
	bx r1

@ ---------------------------------------------------------------------------
@ r0 = parent proc.  Replace any dragon already out, then spawn the new one on
@ the chosen tile with the summoner's level and let autolevelling fill it in,
@ then award the summoner 10 EXP through the blocking exp-bar proc.
@
@ Returns 0, not 1: the handler has parked a blocking child on the parent proc,
@ so ApplyUnitAction must yield rather than tear the action down immediately --
@ this is what keeps the map UI hidden until the exp bar is done.  Every vanilla
@ handler that blocks (ActionDance, ActionArena, ActionStaff) returns 0 too.
@ ---------------------------------------------------------------------------
SummonAction:
	push {r4,r5,r6,lr}
	sub sp,#0x14                @ 0x00 UnitDefinition, 0x10 parent proc
	str r0,[sp,#0x10]
	add r4,sp,#0

	bl SummonClearAll

	ldr r5,=gActiveUnit
	ldr r5,[r5]
	ldr r6,=gActionData

	mov r0,#0
	str r0,[r4,#0]
	str r0,[r4,#4]
	str r0,[r4,#8]
	str r0,[r4,#0xC]

	ldr r0,=SummonLinks
	ldr r1,[r0,#0]              @ character id
	strb r1,[r4,#0]
	ldr r1,[r0,#4]              @ class id
	strb r1,[r4,#1]
	ldr r1,[r0,#8]              @ item id
	strb r1,[r4,#8]

	@ +3: bit0 autolevel, bits1-2 allegiance (0 = player), bits3-7 level
	ldrb r1,[r5,#8]
	cmp r1,#0x1F
	bls SummonAction_LevelReady
	mov r1,#0x1F
SummonAction_LevelReady:
	lsl r1,#3
	add r1,#1
	strb r1,[r4,#3]

	ldrb r1,[r6,#0x13]          @ chosen x
	strb r1,[r4,#4]
	strb r1,[r4,#6]
	ldrb r1,[r6,#0x14]          @ chosen y
	strb r1,[r4,#5]
	strb r1,[r4,#7]

	mov r0,r4
	blh LoadUnit
	mov r4,r0
	cmp r4,#0
	beq SummonAction_Refresh

	@ --- weapon rank, and an HP that fits in a signed byte -------------------
	@ Both have to happen here, on the spawned Unit, because neither survives
	@ the class/character tables:
	@
	@ Rank.  CanUnitUseAsWeapon ends in `unit[0x28 + item.weaponType] >= req`.
	@ Flametongue is weaponType 0x0B, so the byte read is unit+0x33 -- but
	@ LoadUnitStats only copies EIGHT rank bytes (class+0x2C -> unit+0x28..0x2F),
	@ so unit+0x33 is left as ClearUnitStruct's zero and no class edit can reach
	@ it.  Writing it directly is the only thing that works.
	@
	@ HP.  Fire Dragon's class base HP is 120 (it is a boss class meant to be
	@ fielded at level 1), and autolevelling adds an 85%-growth roll per level on
	@ top.  GetUnitMaxHP reads maxHP with LDRSB, so anything over 127 goes
	@ negative and the stat screen shows 0/0.  Clamp to the class's own HP cap.
	mov r0,#0x33
	mov r1,#0xFF
	strb r1,[r4,r0]             @ S rank in the dragonstone slot

	ldr r0,[r4,#4]              @ pClassData
	ldrb r0,[r0,#0x13]          @ class maxHP cap
	mov r1,#SignedStatMax
	cmp r0,r1
	bls SummonAction_HPCapReady
	mov r0,r1
SummonAction_HPCapReady:
	ldrb r1,[r4,#0x12]          @ maxHP as autolevelling left it
	cmp r1,r0
	bls SummonAction_HPReady
	mov r1,r0
	strb r1,[r4,#0x12]
SummonAction_HPReady:
	strb r1,[r4,#0x13]          @ spawn at full HP

	@ --- barrier animation, converted into a blocking child ------------------
	@ The animation must finish before the exp bar starts, or the two run at
	@ once -- that is the summon "glitching".
	@
	@ SummonAnimation (0x08073878) builds its proc with New6C(script, 3): a
	@ priority-3 *main* proc, neither a child nor blocking, and it discards the
	@ pointer.  So it is called for its side effects (it does the camera math
	@ that fills proc +0x30/+0x34, which is not worth duplicating here), and the
	@ proc it just made is then found by its script and re-hung as a blocking
	@ child of the action proc.  That is exactly the state NewBlocking6C leaves
	@ a proc in:
	@
	@   +0x27 |= 2      mark blocked
	@   +0x14  = parent (via InsertChild6C, after Isolate6C unlinks the old list)
	@   parent[+0x28]++ count one outstanding blocker
	mov r0,r4
	blh SummonAnimation

	ldr r0,=SummonAnimationProcs
	blh Find6C
	cmp r0,#0
	beq SummonAction_Refresh

	mov r6,r0                   @ gActionData is not needed past this point
	blh Isolate6C               @ r0 still the animation proc
	mov r0,r6
	ldr r1,[sp,#0x10]           @ parent proc, saved by SummonActionEntry
	blh InsertChild6C

	mov r0,#0x27
	ldrb r1,[r6,r0]
	mov r2,#2
	orr r1,r2
	strb r1,[r6,r0]

	ldr r0,[sp,#0x10]
	mov r1,#0x28
	ldrb r2,[r0,r1]
	add r2,#1
	strb r2,[r0,r1]

SummonAction_Refresh:
	blh RefreshEntityMaps
	blh RefreshUnitSprites

	@ the summoner's turn is over
	ldr r0,[r5,#0xC]
	mov r1,#0x40
	orr r0,r1
	str r0,[r5,#0xC]

	@ --- 10 EXP for the summoner, on a blocking proc ------------------------
	@ Modelled on ActionSteal (0x0802F62C), NOT on ActionDance.  Both award the
	@ same flat +10 through 0x0802A5D0, but Dance follows it with
	@ BeginBattleAnimations, and a summon must not:
	@
	@   BeginBattleAnimations -> NewEkrBattleDeamon (0x0804B1AC) starts a full
	@   battle-animation sequence, which reads gBattleTarget.  Dance can afford
	@   that because it fills the target in first (SetupBattleStructForStaffTarget
	@   at 0x0802F4EC); a summon has no target, so the deamon would run on
	@   whatever the previous combat left behind and jump through a stale
	@   pointer.  That is the 0x030031F4 crash after the barrier animation.
	@
	@ Steal is the right shape: set up the actor, award the exp, and let the
	@ exp-bar proc own the screen.  Order still matters --
	@ SetupBattleStructForStaffUser copies the summoner into gBattleActor and
	@ GiveInstigator10Exp reads that copy, not the Unit, so it has to run first.
	@ r1 = -1 means no weapon slot; this is not an attack.
	@
	@ GiveInstigator10Exp ends in NewBlocking6C on the exp-bar proc script
	@ (0x08B942A0 -> SaveInstigatorFromBattle), which banks the exp onto the Unit
	@ and keeps the map UI suppressed until the bar finishes.
	mov r0,r5
	mov r1,#1
	neg r1,r1
	blh SetupBattleStructForStaffUser

	ldr r1,=gBattleStatsBitfield
	mov r0,#0x40
	strh r0,[r1,#0]

	ldr r0,[sp,#0x10]           @ parent proc, saved by SummonActionEntry
	blh GiveInstigator10Exp

	add sp,#0x14
	mov r0,#0
	pop {r4,r5,r6}
	pop {r1}
	bx r1

@ ---------------------------------------------------------------------------
@ Remove every summon already on the field.  Only the player block is scanned,
@ so an enemy Fire Dragon of the same character is never cleared.
@ ---------------------------------------------------------------------------
SummonClearAll:
	push {r4,r5,r6,lr}
	ldr r6,=SummonLinks
	mov r4,#1
SummonClearAll_Loop:
	mov r0,r4
	blh GetUnit
	mov r5,r0
	cmp r5,#0
	beq SummonClearAll_Next

	ldr r0,[r5,#0]              @ pCharacterData
	cmp r0,#0
	beq SummonClearAll_Next
	ldrb r0,[r0,#4]
	ldr r1,[r6,#0]
	cmp r0,r1
	bne SummonClearAll_Next

	ldr r0,[r5,#4]              @ pClassData
	cmp r0,#0
	beq SummonClearAll_Next
	ldrb r0,[r0,#4]
	ldr r1,[r6,#4]
	cmp r0,r1
	bne SummonClearAll_Next

	mov r0,r5
	blh ClearUnitStruct

SummonClearAll_Next:
	add r4,#1
	cmp r4,#LastPlayerUnitID
	blo SummonClearAll_Loop

	pop {r4,r5,r6}
	pop {r0}
	bx r0

@ ---------------------------------------------------------------------------
@ SetNextChapter (0x08012B5C) replacement: drop the summon before the chapter
@ hands its unit list on, so the dragon never joins the party.
@ ---------------------------------------------------------------------------
SummonSetNextChapter:
	push {r4,lr}
	mov r4,r0
	bl SummonClearAll
	blh GetGameControlProc
	add r0,#0x2A
	strb r4,[r0]
	pop {r4}
	pop {r0}
	bx r0

.ltorg
.align 4

@ TargetSelectionDefinition: init, end, init2, switch-in, switch-out, A, B, R.
SummonTargetSelection:
	.word SummonSelect_OnInit+1
	.word SummonSelect_OnEnd+1
	.word 0
	.word SummonSelect_OnSwitchIn+1
	.word 0
	.word SummonSelect_OnSelect+1
	.word SelectionBackToUnitMenu
	.word 0

.align 4
@ Filled in by UnitMenuSkills.event, in this order:
@ WORD SUMMON_CHARACTER_ID
@ WORD SUMMON_CLASS_ID
@ WORD SUMMON_ITEM_ID
@ WORD UM_SummonSelect
SummonLinks:
