.thumb

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

.set GameDataStruct,                   0x0202BCB0
.set ChapterDataStruct,                0x0202BBF8
.set ActionStruct,                     0x0203A868
.set SelectedUnit,                     0x02033E40 		
.set ActiveUnit,                       0x03004690 		
.set BattleActingUnit,                 0x0203A3F0 @attacker
.set BattleTargetUnit,                 0x0203A470 @defender

.set TargeterXY,                       0x0203DCF4 		
.set TargetList,                       0x0203DCF8
.set TargetNum,                        0x0203DFF8 		

.set CurrentMapSize,                   0x0202E3D8
.set rsUnitMapRows,                    0x0202E3DC
.set rsTerrainMapRows,                 0x0202E3E0
.set rsMoveMapRows,                    0x0202E3E4
.set rsRangeMapRows,                   0x0202E3E8
.set rsFogMapRows,                     0x0202E3EC
.set rsOtherMoveMapRows,               0x0202E3F4
@----------------------------------------------------------
@List of Relevant Routines

@Item & Unit Related routines
	.set RamUnitByID,                      0x08018d0c
		@ arguments:
			@r0 = unit deployment id
		@returns:
			@r0 = unit pointer
	.set BActingUnitUpdate,                0x0802A4B4
		@ arguments:
			@r0 = unit pointer
			@r1 = selected item slot
	.set BTargetUnitUpdate,                0x0802A560
		@arguments:
			@r0 = unit pointer
	.set DecrementItemUses,                0x0801672E
		@arguments: r0= item/uses short

	.set Unit_GetEquippedWeapon,       0x08016764 
		@ arguments: r0 = Unit Struct pointer;
		@ returns: r0 = Item Short
	.set Unit_ReorderItems,                0x08017688
		@arguments: r0 = ram unit pointer
		@remove spaces in unit's inventory caused 
		@by things like stolen and broken items
	.set Unit_ItemCount,                   0x080176DA
		@arguments: r0= ram unit pointer
	.set GetUnit,                          0x08018d0c
	.set Unit_GetAid,                      0x08018450
	.set Unit_GetHalfMag,                  0x080184B4
	.set Unit_GetCurHP,                    0x08018a70
	.set Unit_GetMaxHP,                    0x08018ab0
	.set Unit_GetStr,                      0x08018AD0
	.set Unit_GetMag,                      0x08018AD0
	.set Unit_GetSkl,                      0x08018AF0
	.set Unit_GetSpd,                      0x08018b30
	.set Unit_GetDef,                      0x08018b70
	.set Unit_GetRes,                      0x08018b90
	.set Unit_GetLuck,                     0x08018bb8
	.set Unit_CanCrossTerrain,             0x08018D68 
		@ arguments: r0 = Unit Struct pointer, r1 = Terrain Index;
		@ returns: r0 = 0 if Unit cannot cross/stand on terrain
	.set Unit_GetRangeMap,                 0x08016EBC 
		@ arguments: r0 = Unit Struct pointer, r1 = Item Slot Index (-1 for all);
		@ returns: r0 = range mask
	.set Unit_CanUseItem,                  0x08026cd0 
		@ arguments: r0 = Unit Struct pointer, r1 = Item Short;
		@ returns = 1 if unit can use item, 0 otherwise
	.set StaffHitRate,                     0x0802A66C 	@
	.set Item_GetMight,                    0x080172E0 
		@ arguments: r0 = Item Short
		@ returns: r0 = Might
	.set Item_GetWeight,                   0x08017310
		@ arguments: r0 = Item Short
		@ returns: r0 = weight
	
	@Trap Related Routines
	.set FindTrapAt,                       0x0802E1F0
	.set FindTrapTypeAt,                   0x0802BA94
	.set CreateTrap,                       0x0802BACC
	.set CreateLightRune,                  0x0802C1E8
	.set CreateBallista,                   0x08034740
	.set FindBallistaAt,                   0x080346C8 
		@ arguments: r0 = x, r1 = y;
		@ returns: ballista item at (x, y) (0 if none)

	@6C related routines
	.set New6C,                            0x08004494 
		@ arguments: r0 = pointer to ROM 6C code, r1 = parent;
		@ returns: r0 = new 6C pointer (0 if no space available)
	.set New6CBlocking,                    0x080044F8 
		@ arguments: r0 = pointer to ROM 6C code, r1 = parent;
		@ returns: r0 = new 6C pointer (0 if no space available)
	.set End6C,                            0x08004584 
		@ arguments: r0 = pointer to 6C to delete
	.set Break6CLoop,                      0x080046A0 
		@ arguments: r0 = pointer to 6C whose loop to break
	.set Find6C,                           0x080046A8 
		@ arguments: r0 = pointer to ROM 6C code;
		@ returns: r0 = 6C pointer of first match (0 if none found)
	@Other Routines
	.set PlaySoundEffect,              0x080BE594 	
		@arguments: r0= sound id
		
	.set ConfirmStaffUse,                     0x0802764C 
		@writes action 0x3 (using a staff) to ActionStruct
		@also removes range squares and clears BG2
		@arguments: none
		