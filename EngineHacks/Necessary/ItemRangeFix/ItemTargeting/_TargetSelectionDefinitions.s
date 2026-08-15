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

@----------------------------------------------------------
@Relevant Ram Offsets
	.set ChapterDataStruct,            0x0202BBF8 		
	.set CurrentMapSize,               0x0202E3D8 		
	.set UnitMapRows,                  0x0202E3DC 		
	.set MoveCostMapRows,              0x0202E3E4 		
	.set RangeMapRows,                 0x0202E3E8 		
	.set FogMapRows,                   0x0202E3EC
	.set ActionStruct,                 0x0203A868 		
	.set TargeterXY,                   0x0203DCF4 		
	.set TargetList,                   0x0203DCF8
	.set TargetNum,                    0x0203DFF8 		
	.set SelectedUnit,                 0x02033E40 		
	.set ActiveUnit,                   0x03004690 		
@----------------------------------------------------------
@List of Relevant Routines

	@Item & Unit Related routines
	.set DecrementItemUses,            0x0801672E
		@arguments: r0= item/uses short

	.set Unit_GetEquippedWeapon,       0x08016764 
		@ arguments: r0 = Unit Struct pointer;
		@ returns: r0 = Item Short
	.set Item_GetUsesLeft,             0x08017584
		@arguments: r0 = item/uses short
	.set Unit_ReorderItems,            0x08017688
		@arguments: r0 = ram unit pointer
		@remove spaces in unit's inventory caused 
		@by things like stolen and broken items
	.set Unit_GetItemCount,               0x080176DA
		@arguments: r0= ram unit pointer
	.set GetUnit,                      0x08018d0c
	.set Unit_GetAid,                  0x08018450
	.set Unit_GetHalfMag,              0x080184B4
	.set Unit_GetCurHP,                0x08018a70
	.set Unit_GetMaxHP,                0x08018ab0
	.set Unit_GetStr,                  0x08018AD0
	.set Unit_GetMag,                  0x08018AD0
	.set Unit_GetSkl,                  0x08018AF0
	.set Unit_GetSpd,                  0x08018b30
	.set Unit_GetDef,                  0x08018b70
	.set Unit_GetRes,                  0x08018b90
	.set Unit_GetLuck,                 0x08018bb8
	.set Unit_CanCrossTerrain,         0x08018D68 
		@ arguments: r0 = Unit Struct pointer, r1 = Terrain Index;
		@ returns: r0 = 0 if Unit cannot cross/stand on terrain
	.set Unit_GetRangeMap,             0x08016EBC 
		@ arguments: r0 = Unit Struct pointer, r1 = Item Slot Index (-1 for all);
		@ returns: r0 = range mask
	.set Unit_CanUseItem,              0x08026cd0 
		@ arguments: r0 = Unit Struct pointer, r1 = Item Short;
		@ returns = 1 if unit can use item, 0 otherwise
	.set StaffHitRate,                 0x0802A66C 	@

	@Range and Move Cost Maps Routines
	.set FillMap,                      0x080190AC	@
		@r0 = row pointer; r1 = value
	.set AddRange,                     0x0801A2D4
		@build targeting range in range map
		@r0 = x; r1 = y; r2 = range; r3 = value
	.set CheckUnitsInRange,            0x08023944	@
	.set CheckTilesInRange,            0x08023A1C	@
	.set CheckAdjacentUnits,           0x08023A74	@
	.set ShowRangeSquares,             0x0801D2A0	@
	.set HideRangeSquares,             0x0801D2D4	@
		@arguments: none; returns: nothing
	
	@Target List Related Routines
	.set RefreshTargetList,            0x0804ACE4	@
		@r0 = x; r1 = y;
	.set AddTargetListEntry,           0x0804ACFC 
		@arguments: r0 = x, r1 = y, 
		@r2 = unit allegience byte, r3 = trap type; 
		@returns: nothing
	.set GetTargetListSize,            0x0804B174	@
	.set GetTargetListEntry,           0x0804B180	
	@6c stuff; most of these are taken from stan's notes
	.set NewTargetSelection,           0x0804AE88	
	.set NewTargetSelectv2,            0x0804A494	

	.set New6C,                        0x08004494 @ arguments: r0 = pointer to ROM 6C code, r1 = parent; returns: r0 = new 6C pointer (0 if no space available)
	.set New6CBlocking,                0x080044F8 @ same
	.set End6C,                        0x08004584 
		@ arguments: r0 = pointer to 6C to delete
	.set Break6CLoop,                  0x080046A0 
		@ arguments: r0 = pointer to 6C whose loop to break
	.set Find6C,                       0x080046A8 
		@ arguments: r0 = pointer to ROM 6C code; returns: r0 = 6C pointer of first match (0 if none found)
	.set Goto6CLabel,                  0x08004720 
		@ arguments: r0 = pointer to 6C, r1 = label index to go to
	.set Goto6CPointer,                0x08004758 
		@ arguments: r0 = pointer to 6C, r1 = pointer to ROM 6C code to go to
	.set ForEach6C,                    0x08004794 
		@ arguments: r0 = pointer to ROM 6C code, r1 = function<void(6CStruct*)>
	.set BlockEach6CMarked,            0x080047E8 
		@ arguments: r0 = mark index
	.set UnblockEach6CMarked,          0x0800480c 
		@ arguments: r0 = mark index
	.set DeleteEach6CMarked,           0x08004834 
		@ arguments: r0 = mark index
	.set DeleteEach6C,                 0x0800486c 
		@ arguments: r0 = pointer to ROM 6C code
	.set BreakEach6CLoop,              0x08004888 
		@ arguments: r0 = pointer to ROM 6C code

	.set LockGameLogic,                0x08015308
	.set UnlockGameLogic,              0x08015318

	.set GetTextBuffer,                0x08012C60	
	.set SetBottomHelpText,            0x08032560	
	
	@Trap Related Routines
	.set FindTrapAt,                   0x0802E1F0
	.set FindTrapTypeAt,               0x0802BA94
	.set CreateTrap,                   0x0802BACC
	.set CreateLightRune,              0x0802C1E8
	.set CreateBallista,               0x08034740
	.set FindBallistaAt,               0x080346C8 
		@ arguments: r0 = x, r1 = y;
		@ returns: ballista item at (x, y) (0 if none)
	
	@Other
	.set Font_ResetAllocation,     0x08005438
		@frees space used by text and range squares?
		@arguments: none; returns: nothing
	.set PlaySoundEffect,              0x080BE594 	
		@arguments: r0= sound id
	.set ConfirmStaffUse,              0x0802764C 
		@writes action 0x3 (using a staff) to ActionStruct
		@also removes range squares and clears BG2
		@arguments: none
	.set CanChestOpen,                 0x080831AC
		@check if chest can be opened
		@arguments: r0 = x, r1 = y
		@returns true(1) or false(0)
	.set FadingChestOpen,              0x080831C8
		@if the tile at the given area is an openable chest,
		@ perform fading tile change
		@arguments: r0 = x, r1 = y
	.set CanDoorOpen,                  0x080831F0
		@check if door can be opened
		@arguments: r0 = x, r1 = y
		@returns true(1) or false(0)
	.set FadingDoorOpen,               0x0808320C
		@if the tile at the given area is an openable door,
		@ perform fading tile change
		@arguments: r0 = x, r1 = y
@	.set FadingTileChange,             0x08078C14
		@perform fading tile change with the tile change that affects the given area?
		@arguments: r0 = x, r1 = y
	
@	.set SetMapCursorPosition,          
@	.set StartCameraMovement,           
