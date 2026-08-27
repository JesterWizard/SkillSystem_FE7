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
.equ gBattleTarget,      0x0203A470
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
.equ GetUnit,                0x08018D0D
.equ ClearUnitStruct,        0x08017509
.equ LoadUnit,               0x08017789  @ r0=UnitDefinition* -> r0=Unit*
.equ RefreshEntityMaps,      0x08019ABD
.equ RefreshUnitSprites,     0x08025725
.equ GetGameControlProc,     0x08012B39

@ The no-combat "act on a unit, gain 10 exp, show the bar" sequence.  These five
@ are ActionSteal's tail (0x0802F64C..0x0802F676) in order; see SummonAction.
.equ SetupBattleStructForStaffUser, 0x0802A4B5  @ r0=unit, r1=weapon slot (-1)
.equ CopyUnitToBattleStruct,        0x080285D5  @ r0=battle struct, r1=unit
.equ GiveInstigator10Exp,           0x0802A5D1  @ r0=proc; blocking child
.equ ClearMoveUnits,                0x0806CCB9
.equ StartMapBattleSequence,        0x0806F0DD  @ news up 0x08C9D50C; draws the bar

@ NOT an exp bar.  0x0802B678 is StartTradeMenu -- see SummonAction's tail.
.equ DoNotCall_StartTradeMenu,      0x0802B679

.equ SummonActionID,         0x05
.equ LastPlayerUnitID,       0x40        @ player deployment slots are 1..0x3F
.equ PlayerHPCap,            60          @ the cap every player unit is held to

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
@ Returns 0, like every vanilla handler that leaves something running
@ (ActionCombat, ActionArena, ActionDance, ActionSteal).
@
@ What that return actually does, since it is easy to get wrong: ApplyUnitAction
@ is not called from code at all.  It is entry 0x0802F219 of the map-main proc
@ script, run under proc command 0x16 (handler 0x0800490C), which calls the
@ routine and returns its sign-extended byte to the script interpreter at
@ 0x08004B84.  Nonzero means "run the next script command in this same frame";
@ zero means "stop the script for this frame" -- the command pointer has already
@ advanced, so next frame resumes at the FOLLOWING command.
@
@ So returning 0 buys exactly one frame.  It does not block and it does not
@ repeat.  What holds the action open is the blocking child GiveInstigator10Exp
@ parks on this proc (proc+0x28), plus the game lock the map-battle proc takes.
@ ---------------------------------------------------------------------------
SummonAction:
	push {r4,r5,r6,r7,lr}
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
	@ top.  Two separate reasons that has to be brought down here:
	@
	@   * GetUnitMaxHP reads maxHP with LDRSB, so anything over 127 goes negative
	@     and the stat screen shows 0/0.
	@   * every player unit in this hack is held to 60 HP, and a summon the
	@     player controls is a player unit like any other.
	@
	@ 60 is below the signed-byte limit, so clamping to it satisfies both; the
	@ class's own cap (127 for Fire Dragon) is deliberately NOT used, because it
	@ is boss data and would leave the dragon at roughly double a player's HP.
	mov r0,#0x33
	mov r1,#0xFF
	strb r1,[r4,r0]             @ S rank in the dragonstone slot

	mov r0,#PlayerHPCap
	ldrb r1,[r4,#0x12]          @ maxHP as autolevelling left it
	cmp r1,r0
	bls SummonAction_HPReady
	mov r1,r0
	strb r1,[r4,#0x12]
SummonAction_HPReady:
	strb r1,[r4,#0x13]          @ spawn at full HP

	@ --- barrier animation ---------------------------------------------------
	@ SummonAnimation (0x08073878) ends in New6C(script, 3) -- a ROOT proc at
	@ priority 3, not a child of anything.  Leave it that way.
	@
	@ It was briefly rebuilt here with NewBlocking6C so the action would wait
	@ for the effect instead of racing it, and that build froze.  The freeze was
	@ almost certainly the StartTradeMenu call below, which was present in the
	@ same build -- 0x08C9DD24 is SLEEP / CALL / REPEAT / CALL / END and does
	@ terminate, so it would survive being a blocking child.  Left at root
	@ anyway: that is how vanilla runs it, and with the map-battle sequence now
	@ holding the game lock the race it used to lose no longer exists.
	mov r0,r4
	blh SummonAnimation

SummonAction_Refresh:
	blh RefreshEntityMaps
	blh RefreshUnitSprites

	@ the summoner's turn is over
	ldr r0,[r5,#0xC]
	mov r1,#0x40
	orr r0,r1
	str r0,[r5,#0xC]

	@ --- 10 EXP for the summoner, with the bar on screen ---------------------
	@ This is ActionSteal's tail (0x0802F64C..0x0802F676), which is the vanilla
	@ action shaped exactly like a summon: no combat, one unit acting on another,
	@ 10 flat exp, exp bar on the map.  All five calls are needed and the order
	@ is vanilla's.
	@
	@ Do NOT reach for 0x0802B678 here.  It was named StartExpBar in this file
	@ and it is not an exp bar at all -- it is StartTradeMenu.  Its only caller
	@ in the whole ROM is 0x08021E88, the A-button handler of the Trade target
	@ selection at 0x08B95C78, and the script it news up (0x08B942F8) opens with
	@ LockGame, draws a portrait for BOTH units, lists both inventories, and then
	@ runs an interactive cursor.  Calling it here opened a trade window between
	@ the summoner and the dragon, with the game locked and no way out.  That was
	@ the freeze.  It also explains why no bar ever appeared: there is no exp
	@ anywhere on that path.
	@
	@ The piece that actually draws the bar is StartMapBattleSequence
	@ (0x0806F0DC) -- it news up 0x08C9D50C, which takes the game lock and plays
	@ the map sequence through to the exp bar and the unlock.  An earlier attempt
	@ called GiveInstigator10Exp alone; that banks the exp (into gBattleActor,
	@ committed a frame later by its blocking child) but nothing renders it.
	@
	@ GiveInstigator10Exp also can NOT be called bare: it ends in
	@ SaveInstigatorFromBattle, which writes gBattleActor back over the unit
	@ named by gBattleActor+0x0B.  Without the setup call below that is whatever
	@ unit fought last, so a bare call scribbles a stale battle struct onto an
	@ unrelated unit.
	@
	@ When LoadUnit failed there is no dragon and SummonAction_Refresh reaches
	@ here with r4 = 0, so the whole sequence is skipped rather than staged
	@ against null.
	cmp r4,#0
	beq SummonAction_Done

	@ gBattleActor = the summoner, weapon slot -1 (acting with no weapon)
	mov r0,r5
	mov r1,#1
	neg r1,r1
	blh SetupBattleStructForStaffUser

	@ gBattleTarget = the dragon.  ActionSteal pins terrainId (+0x55) to 1 before
	@ the copy so the sequence does not read terrain for a unit it never placed.
	ldr r0,=gBattleTarget
	mov r1,#0x55
	mov r2,#1
	strb r2,[r0,r1]
	mov r1,r4
	blh CopyUnitToBattleStruct

	@ +10 exp on gBattleActor, then a blocking child on the action proc that
	@ commits it to the summoner
	ldr r0,[sp,#0x10]
	blh GiveInstigator10Exp

	blh ClearMoveUnits
	blh StartMapBattleSequence

SummonAction_Done:
	add sp,#0x14
	mov r0,#0
	pop {r4,r5,r6,r7}
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
