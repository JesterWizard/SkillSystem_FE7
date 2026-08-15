.thumb
@Staff AI asm macros

.macro _blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.macro _bldr reg, dest
	ldr \reg, =\dest
	mov lr, \reg
	.short 0xF800
.endm

.macro _blr reg
	mov lr, \reg
	.short 0xF800
.endm
.set gProcEventEngine, 0x8591AC0
.set GetItemAttributes, 0x801727C 
.set CanUnitUseWeapon, 0x80161a4
.set CanUnitUseStaff, 0x80163D2
.set MovementMap, 0x202E3E4 
.set BackupMovementMap, 0x202E3F4 
.set Attacker, 0x203A3F0 
.set Defender, 0x203A470
.set GetItemType, 0x801725c
.set GetItemMight, 0x80172E0
.set GetItemRequiredExp, 0x80173B8
.set GetItemMinRange, 0x801736C
.set GetItemMaxRange, 0x8017384

.set GetUnitDefense, 0x8018b70
.set GetUnitResistance, 0x8018b90
.set IsWeaponEffective, 0x08016820   


.equ GetGameClock, 0x08000F14	@{U}
@.equ GetGameClock, 0x08000CD8	@{J}
.equ ProcGoto, 0x8004720 

@----------------------------------------------------------
@Relevant Ram Offsets
	.set ChapterDataStruct,            0x0202BBF8 		@{U}
@	.set ChapterDataStruct,            0x0202BCEC 		@{J}
	.set CurrentMapSize,               0x0202E3D8 		@{U}
@	.set CurrentMapSize,               0x0202E4D0 		@{J}
	.set UnitMapRows,                  0x0202E3DC 		@{U}
@	.set UnitMapRows,                  0x0202E3D8 		@{J}
	.set MoveCostMapRows,              0x0202E3E4 		@{U}
@	.set MoveCostMapRows,              0x0202E3E0 		@{J}
	.set RangeMapRows,                 0x0202E3E8 		@{U}
@	.set RangeMapRows,                 0x0202E3E4 		@{J}
	.set FogMapRows,                   0x0202E3EC		@{U}
@	.set FogMapRows,                   0x0202E3E8		@{J}
	.set ActionStruct,                 0x0203A868 		@{U}
@	.set ActionStruct,                 0x0203A954 		@{J}
	.set TargeterXY,                   0x0203DCF4 		@{U}
@	.set TargeterXY,                   0x0203DDE4 		@{J}
	.set TargetList,                   0x0203DCF8		@{U}
@	.set TargetList,                   0x0203DCF4		@{J}
	.set TargetNum,                    0x0203DFF8 		@{U}
@	.set TargetNum,                    0x0203E0E8 		@{J}
	.set SelectedUnit,                 0x02033E40 		@{U}
@	.set SelectedUnit,                 0x02033F38 		@{J}
	.set ActiveUnit,                   0x03004690 		@{U}
@	.set ActiveUnit,                   0x03004DF0 		@{J}

@----------------------------------------------------------
@List of Relevant Routines

	@Item & Unit Related routines
	.set DecrementItemUses,            0x0801672E	@{U}
@	.set DecrementItemUses,            0x08016894	@{J}
		@arguments: r0= item/uses short

	.set Unit_GetEquippedWeapon,       0x08016764	@{U}
@	.set Unit_GetEquippedWeapon,       0x080168D0	@{J}
		@ arguments: r0 = Unit Struct pointer;
		@ returns: r0 = Item Short
	.set Item_GetUsesLeft,             0x08017584	@{U}
@	.set Item_GetUsesLeft,             0x0801732C	@{J}
		@arguments: r0 = item/uses short
	.set Unit_ReorderItems,            0x08017688	@{U}
@	.set Unit_ReorderItems,            0x0801772C	@{J}
		@arguments: r0 = ram unit pointer
		@remove spaces in unit's inventory caused 
		@by things like stolen and broken items
	.set Unit_GetItemCount,        0x080176DA @ arguments: r0 = Unit Struct pointer; returns: r0 = Item Count	@{U}
@	.set Unit_GetItemCount,        0x08017780 @ arguments: r0 = Unit Struct pointer; returns: r0 = Item Count	@{J}
		@arguments: r0= ram unit pointer
	.set GetUnit,                  0x08018d0c @ arguments: r0 = Unit Allegience Index; returns: r0 = Unit Struct pointer (0 if not found)	@{U}
@	.set GetUnit,                  0x08019108 @ arguments: r0 = Unit Allegience Index; returns: r0 = Unit Struct pointer (0 if not found)	@{J}

	.set Unit_GetAid,                  0x08018450	@{U}
@	.set Unit_GetAid,                  0x080186CC	@{J}
	.set Unit_GetHalfMag,              0x080184B4	@{U}
@	.set Unit_GetHalfMag,              0x08018730	@{J}
	.set Unit_GetCurHP,                0x08018a70	@{U}
@	.set Unit_GetCurHP,                0x08018E64	@{J}
	.set Unit_GetMaxHP,                0x08018ab0	@{U}
@	.set Unit_GetMaxHP,                0x08018EA4	@{J}
	.set Unit_GetStr,                  0x08018AD0	@{U}
@	.set Unit_GetStr,                  0x08018EC4	@{J}
	.set Unit_GetMag,                  0x08018AD0	@{U}
@	.set Unit_GetMag,                  0x08018EC4	@{J}
	.set Unit_GetSkl,                  0x08018AF0	@{U}
@	.set Unit_GetSkl,                  0x08018EE4	@{J}
	.set Unit_GetSpd,                  0x08018b30	@{U}
@	.set Unit_GetSpd,                  0x08018F24	@{J}
	.set Unit_GetDef,                  0x08018b70	@{U}
@	.set Unit_GetDef,                  0x08018F64	@{J}
	.set Unit_GetRes,                  0x08018b90	@{U}
@	.set Unit_GetRes,                  0x08018F84	@{J}
	.set Unit_GetLuck,                 0x08018bb8	@{U}
@	.set Unit_GetLuck,                 0x08018FAC	@{J}
	.set Unit_CanCrossTerrain,         0x08018D68	@{U}
@	.set Unit_CanCrossTerrain,         0x08019174	@{J}
		@ arguments: r0 = Unit Struct pointer, r1 = Terrain Index;
		@ returns: r0 = 0 if Unit cannot cross/stand on terrain
	.set Unit_GetRangeMap,             0x08016EBC	@{U}
@	.set Unit_GetRangeMap,             0x08016F90	@{J}
		@ arguments: r0 = Unit Struct pointer, r1 = Item Slot Index (-1 for all);
		@ returns: r0 = range mask
	.set Unit_CanUseItem,              0x08026cd0	@{U}
@	.set Unit_CanUseItem,              0x0802881C	@{J}
		@ arguments: r0 = Unit Struct pointer, r1 = Item Short;
		@ returns = 1 if unit can use item, 0 otherwise
	.set StaffHitRate,                 0x0802A66C 	@{U}
@	.set StaffHitRate,                 0x0802CC14 	@{J}

	@Range and Move Cost Maps Routines
	.set FillMap,                      0x080190AC	@{U}
@	.set FillMap,                      0x08018D88	@{J}
		@r0 = row pointer; r1 = value
	.set AddRange,                     0x0801A2D4	@{U}
@	.set AddRange,                     0x0801A798	@{J}
		@build targeting range in range map
		@r0 = x; r1 = y; r2 = range; r3 = value
	.set CheckUnitsInRange,            0x08023944	@{U}
@	.set CheckUnitsInRange,            0x08024E5C	@{J}
	.set CheckTilesInRange,            0x08023A1C	@{U}
@	.set CheckTilesInRange,            0x08024EC8	@{J}
	.set CheckAdjacentUnits,           0x08023A74	@{U}
@	.set CheckAdjacentUnits,           0x08024F20	@{J}
	.set ShowRangeSquares,             0x0801D2A0	@{U}
@	.set ShowRangeSquares,             0x0801D6FC	@{J}
	.set HideRangeSquares,             0x0801D2D4	@{U}
@	.set HideRangeSquares,             0x0801D730	@{J}
		@arguments: none; returns: nothing
	
	@Target List Related Routines
	.set RefreshTargetList,            0x0804ACE4	@{U}
@	.set RefreshTargetList,            0x08050618	@{J}
		@r0 = x; r1 = y;
	.set AddTargetListEntry,           0x0804ACFC	@{U}
@	.set AddTargetListEntry,           0x08050630	@{J}
		@arguments: r0 = x, r1 = y, 
		@r2 = unit allegience byte, r3 = trap type; 
		@returns: nothing
	.set GetTargetListSize,            0x0804B174	@{U}
@	.set GetTargetListSize,            0x08050A9C	@{J}
	.set GetTargetListEntry,           0x0804B180	@{U}
@	.set GetTargetListEntry,           0x08050AA8	@{J}
	@6c stuff; most of these are taken from stan's notes
	.set NewTargetSelection,           0x0804AE88	@{U}
@	.set NewTargetSelection,           0x080507B0	@{J}
	.set NewTargetSelectv2,            0x0804A494	@{U}
@	.set NewTargetSelectv2,            0x08050818	@{J}

	.set New6C,                        0x08004494 @ arguments: r0 = pointer to ROM 6C code, r1 = parent; returns: r0 = new 6C pointer (0 if no space available)	@{U}
@	.set New6C,                        0x08002BCC @ arguments: r0 = pointer to ROM 6C code, r1 = parent; returns: r0 = new 6C pointer (0 if no space available)	@{J}

	.set New6CBlocking,                0x080044F8 @ same	@{U}
@	.set New6CBlocking,                0x08002C30 @ same	@{J}
	.set End6C,                        0x08004584	@{U}
@	.set End6C,                        0x08002CBC	@{J}
		@ arguments: r0 = pointer to 6C to delete

	.set Break6CLoop,              0x080046A0	@{U}
@	.set Break6CLoop,              0x08002DE4	@{J}
		@ arguments: r0 = pointer to 6C whose loop to break
	.set Find6C,                       0x080046A8	@{U}
@	.set Find6C,                       0x08002DEC	@{J}
		@ arguments: r0 = pointer to ROM 6C code; returns: r0 = 6C pointer of first match (0 if none found)
	.set Goto6CLabel,                  0x08004720	@{U}
@	.set Goto6CLabel,                  0x08002E74	@{J}
		@ arguments: r0 = pointer to 6C, r1 = label index to go to
	.set Goto6CPointer,                0x08004758	@{U}
@	.set Goto6CPointer,                0x08002EAC	@{J}
		@ arguments: r0 = pointer to 6C, r1 = pointer to ROM 6C code to go to
	.set ForEach6C,                    0x08004794	@{U}
@	.set ForEach6C,                    0x08002EE8	@{J}
		@ arguments: r0 = pointer to ROM 6C code, r1 = function<void(6CStruct*)>
	.set BlockEach6CMarked,            0x080047E8	@{U}
@	.set BlockEach6CMarked,            0x08002F3C	@{J}
		@ arguments: r0 = mark index
	.set UnblockEach6CMarked,          0x0800480c	@{U}
@	.set UnblockEach6CMarked,          0x08004760	@{J}
		@ arguments: r0 = mark index
	.set DeleteEach6CMarked,           0x08004834	@{U}
@	.set DeleteEach6CMarked,           0x08002F90	@{J}
		@ arguments: r0 = mark index
	.set DeleteEach6C,                 0x0800486c	@{U}
@	.set DeleteEach6C,                 0x08002FC8	@{J}
		@ arguments: r0 = pointer to ROM 6C code
	.set BreakEach6CLoop,              0x08004888	@{U}
@	.set BreakEach6CLoop,              0x08002FE4	@{J}
		@ arguments: r0 = pointer to ROM 6C code

	.set LockGameLogic,            0x08015308	@{U}
@	.set LockGameLogic,            0x08015384	@{J}
	.set UnlockGameLogic,          0x08015318	@{U}
@	.set UnlockGameLogic,          0x08015394	@{J}

	.set GetTextBuffer,                0x08012C60	@{U}
@	.set GetTextBuffer,                0x08009FA8	@{J}
	.set SetBottomHelpText,            0x08032560	@{U}
@	.set SetBottomHelpText,            0x08035610	@{J}
	
	@Trap Related Routines
	.set FindTrapAt,                   0x0802E1F0	@{U}
@	.set FindTrapAt,                   0x0802E128	@{J}
	.set FindTrapTypeAt,               0x0802BA94	@{U}
@	.set FindTrapTypeAt,               0x0802E184	@{J}
	.set CreateTrap,                   0x0802BACC	@{U}
@	.set CreateTrap,                   0x0802E1F0	@{J}
	.set CreateLightRune,              0x0802C1E8	@{U}
@	.set CreateLightRune,              0x0802E990	@{J}
	.set CreateBallista,               0x08034740	@{U}
@	.set CreateBallista,               0x08037A9C	@{J}
	.set FindBallistaAt,               0x080346C8	@{U}
@	.set FindBallistaAt,               0x08037A24	@{J}
		@ arguments: r0 = x, r1 = y;
		@ returns: ballista item at (x, y) (0 if none)
	
	@Other
	.set Font_ResetAllocation,     0x08005438	@{U}
@	.set Font_ResetAllocation,     0x08003C50	@{J}
		@frees space used by text and range squares?
		@arguments: none; returns: nothing

	.set PlaySoundEffect,              0x080BE594	@{U}
@	.set PlaySoundEffect,              0x080D4EF4	@{J}
		@arguments: r0= sound id

	.set ConfirmStaffUse,              0x0802764C	@{U}
@	.set ConfirmStaffUse,              0x080294C4	@{J}
		@writes action 0x3 (using a staff) to ActionStruct
		@also removes range squares and clears BG2
		@arguments: none
	.set CanChestOpen,                 0x080831AC	@{U}
@	.set CanChestOpen,                 0x080854E4	@{J}
		@check if chest can be opened
		@arguments: r0 = x, r1 = y
		@returns true(1) or false(0)
	.set FadingChestOpen,              0x080831C8	@{U}
@	.set FadingChestOpen,              0x08085500	@{J}
		@if the tile at the given area is an openable chest,
		@ perform fading tile change
		@arguments: r0 = x, r1 = y
	.set CanDoorOpen,                  0x080831F0	@{U}
@	.set CanDoorOpen,                  0x08085528	@{J}
		@check if door can be opened
		@arguments: r0 = x, r1 = y
		@returns true(1) or false(0)
	.set FadingDoorOpen,               0x0808320C	@{U}
@	.set FadingDoorOpen,               0x08085544	@{J}
		@if the tile at the given area is an openable door,
		@ perform fading tile change
		@arguments: r0 = x, r1 = y


@ I call "pairs" 32 bit values that hold two 16 bit parts, suitable for being stored in only one register

@ (rd != rox) MUST be true
.macro _MakePair rd, rs1, rs2, rox=r3
	lsl \rox, \rs1, #16 @ clearing top 16 bits of part 1
	lsl \rd,  \rs2, #16 @ clearing top 16 bits of part 2
	lsr \rox,       #16 @ shifting back part 1
	orr \rd, \rox       @ OR
.endm

.macro _GetPairFirst rd, rs
	lsl \rd, \rs, #16 @ clearing second part of pair
	asr \rd, \rd, #16 @ shifting back
.endm

.macro _GetPairSecond rd, rs
	asr \rd, \rs, #16 @ shifting second part of pair (erasing first part in the process)
.endm

@ unsigned variant

.macro _MakeUPair rd, rs1, rs2
	lsl \rd, \rs2, #16
	orr \rd, \rs1
.endm

.macro _GetUPairFirst rd, rs
	lsl \rd, \rs, #16 @ clearing second part of pair
	lsr \rd, \rd, #16 @ shifting back
.endm

.macro _GetUPairSecond rd, rs
	lsr \rd, \rs, #16 @ shifting second part of pair (erasing first part in the process)
.endm

.set ppRangeMapRows,           0x0202E3E8	@{U}
@.set ppRangeMapRows,           0x0202E3E4	@{J}

.set Map_Fill,                 0x080190AC @ arguments: r0 = rows start ptr, r1 = value; returns: nothing	@{U}
@.set Map_Fill,                 0x08018D88 @ arguments: r0 = rows start ptr, r1 = value; returns: nothing	@{J}

.set MoveRange_HideGfx,        0x0801D2D4 @ none	@{U}
@.set MoveRange_HideGfx,        0x0801D730 @ none	@{J}

.set BottomHelpDisplay_New,    0x08032560 @ arguments: r0 = parent 6C, r1 = pointer to text IN BUFFER	@{U}
@.set BottomHelpDisplay_New,    0x08035610 @ arguments: r0 = parent 6C, r1 = pointer to text IN BUFFER	@{J}

.set BottomHelpDisplay_EndAll, 0x0803279c @ none	@{U}
@.set BottomHelpDisplay_EndAll, 0x08035848 @ none	@{J}

.set pActionStruct,            0x0203A868	@{U}
@.set pActionStruct,            0x0203A954	@{J}

.set pBG0TileMap,              0x02022C60	@{U}
@.set pBG0TileMap,              0x02022C60	@{J}

.set ppMoveMapRows,            0x0202E3E4	@{U}
@.set ppMoveMapRows,            0x0202E3E0	@{J}

.set TargetSelection_New,      0x0804AE88 @ arguments: r0 = pointer to Target Selection Definition	@{U}
@.set TargetSelection_New,      0x080507B0 @ arguments: r0 = pointer to Target Selection Definition	@{J}

.set p6C_GBToUnitMenu,         0x0859B600	@{U}
@.set p6C_GBToUnitMenu,         0x085C3AE0	@{J}

.set ppActiveUnit,             0x03004690 @ Active Unit	@{U}
@.set ppActiveUnit,             0x03004DF0 @ Active Unit	@{J}

.set pGameDataStruct,          0x0202BCB0	@{U}
@.set pGameDataStruct,          0x0202BCAC	@{J}

.set HandlePPCursorMovement,   0x0801C194 @ none?	@{U}
@.set HandlePPCursorMovement,   0x0801C514 @ none?	@{J}

.set pKeyStatusBuffer,         0x02024C78	@{U}	@{J}

.set TCS_New,                  0x08011FC4 @ arguments: r0 = ROM source, r1 = OAM Index?	@{U}
@.set TCS_New,                  0x0800916C @ arguments: r0 = ROM source, r1 = OAM Index?	@{J}

.set TCS_SetAnim,              0x0801225c @ arguments: r0 = TCS, r1 = Index	@{U}
@.set TCS_SetAnim,              0x08009408 @ arguments: r0 = TCS, r1 = Index	@{J}

.set TCS_Update,               0x08012000 @ arguments: r0 = TCS, r1 = Display X, r2 = Display Y	@{U}
@.set TCS_Update,               0x080091AC @ arguments: r0 = TCS, r1 = Display X, r2 = Display Y	@{J}

.set TCS_Free,                 0x08011FE8 @ arguments: r0 = TCS	@{U}
@.set TCS_Free,                 0x08009194 @ arguments: r0 = TCS	@{J}

.set pChapterDataStruct,       0x0202BBF8	@{U}
@.set pChapterDataStruct,        0x0202BCEC	@{J}

.set EventEngine, 0x800D07C	@{U}
@.set EventEngine, 0x800D340	@{J}

.set MemorySlot,0x30004B8	@{U}
@.set MemorySlot,0x30004B0	@{J}
