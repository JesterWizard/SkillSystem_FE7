.thumb
@Item/Staff AI asm macros

.macro _blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.macro _blr reg
	mov lr, \reg
	.short 0xF800
.endm

@Stack pocket values for the new staff ai routines
	@the size of the stack pocket
	.set spSize,            0x30
	@0x0 is for passing arguments
	@0x4 and 0x8 seem to only be used in the unused
		@ warp ai so i don't use them just in case
		@ they are also passed to AiSetDecision
		@ so always initialize both to 0 if unused
	.set spUnitMove,        0x0C
	.set spItemSlot,        0x10
	.set spItemRange,       0x14
	.set spTargetTile,      0x18
	.set spTargetUnit,      0x1C
	.set spPriority,        0x20
	.set spDestination,     0x24
	.set spNewDestination,  0x28
	.set spNewPriority,     0x2C

@Return Values for AICondition routines
	@turn these into .set values later
	@0x1	update current target to the new target
	@0x2	update current priority to new priority
	@0x8	forcibly end target selection loop

@Relevant Ram Offsets
.set gActionData,                 0x0203A868
.set gAIData,                     0x0203AA04 	@
.set gAIActionData,               0x0203AA94 	@
.set gActiveUnit,                 0x03004690 	@
.set gActiveUnitID,               0x0202BE44 	

.set gMapSize,                    0x0202E3D8 	
.set gMapUnit,                    0x0202E3DC 	
.set gMapTerrain,                 0x0202E3E0 	
.set gMapMovement,                0x0202E3E4 	
.set gMapRange,                   0x0202E3E8 	
.set gMapFog,                     0x0202E3EC 	
.set gMapHidden,                  0x0202E3F0 	
.set gMapMovement2,               0x0202E3F4 	

@Routines
@character info routines
	.set GetUnit,                      0x08018d0c
		@ arguments:
			@r0 = unit deployment id
		@returns:
			@r0 = unit pointer
	.set GetUnitEquippedItem,          0x08016764
		@ arguments: r0 = Unit Struct pointer;
		@ returns: r0 = Item Short
	
	.set GetUnitAid,                   0x08018450
	.set GetUnitMagBy2Range,           0x080184B4
	.set GetUnitCurrentHP,             0x08018a70
	.set GetUnitMaxHP,                 0x08018ab0
	.set GetUnitStr,                   0x08018AD0
	.set GetUnitMag,                   0x08018AD0
	.set GetUnitPower,                 0x08018AD0
	.set GetUnitSkill,                 0x08018AF0
	.set GetUnitSpeed,                 0x08018b30
	.set GetUnitDefense,               0x08018b70
	.set GetUnitResistance,            0x08018b90
	.set GetUnitLuck,                  0x08018bb8
	
	.set CanUnitCrossTerrain,          0x08018D68
		@ arguments: r0 = Unit Struct pointer, r1 = Terrain Index;
		@ returns: r0 = 0 if Unit cannot cross/stand on terrain
	
	.set AreAllegiancesAllied,         0x080238B0
	.set IsUnitEnemyWithActiveUnit,    0x08037914
	
	.set DoesUnitHaveUsableStaff,      0x0803C44C
	.set HasUsableStaffOrWeapon,       0x080402A8
	
@Trap Related Routines
	.set GetTrapAt,                    0x0802E1F0
	.set GetSpecificTrapAt,            0x0802BA94
	.set AddTrap,                      0x0802BACC
	.set AddTrapExt,                   0x0802BAF4
	.set RemoveTrap,                   0x0802BB0C
	.set AddLightRune,                 0x0802C1E8
	.set RemoveLightRune,              0x0802EA90
	.set GetBallistaItemAt,            0x080346C8
		@ arguments: r0 = x, r1 = y;
		@ returns: ballista item at (x, y) (0 if none)
	.set AddBallista,                  0x08034740
	.set IsBallista,                   0x08037AA8
	
@Range and Move Cost Maps Routines
	.set SetupMapRowPointers,          0x080190AC
	.set MapAddInRange,                0x0801A2D4
	.set MapSetInMagicSealedRange,     0x0801B950
		@arguments: r0= unit pointer
	.set AiFillMovementMapForUnit,     0x0803C490
		@arguments: r0= unit pointer
	.set MapMovementMarkMovementEdges, 0x0801A8E4
	@AI Routines
	.set AiArePointsWithinDistance,    0x0803BFD0
		@arguments:
			@r0 = x1
			@r1 = y1
			@r2 = x2
			@r3 = y2
			@[sp] = distance
	.set AiSetDecision,                0x08039C20
		@arguments:
			@r0 = x
			@r1 = y
			@r2 = action id
			@r3 = unit id of target
			@[sp] = item slot number
	.set AiTryMoveTowards,             0x0803BA08
	.set AiFindTargetingPosition,      0x0803C284
		@arguments:
			@r0= pointer for where to store position coordinates
	.set AiSilencePriority,            0x08040300
		@arguments:
			@r0= target unit pointer
@Other Routines
	.set Div,                          0x080BFA14
	.set GetCurrentPhase,              0x080238D8
	.set GetStaffAccuracy,             0x0802A66C
		@arguments:
			@r0 = unit pointer to acting unit
			@r1 = unit pointer to target unit
		@retruns: r0= hit% rate
	