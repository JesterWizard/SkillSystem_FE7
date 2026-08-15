.thumb

.macro _blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.macro _blr reg
	mov lr, \reg
	.short 0xF800
.endm

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

@ ==================================
@ ============ ROUTINES ============
@ ==================================

.set LoadCompressedData,       0x08013168 @ arguments: r0 = Source Pointer, r1 = Dest Pointer

.set SVCModulo,                0x080BFA18 @ arguments: r0 = left, r1 = right; Returns: r0 = left % right
.set SVCDivide,                0x080BFA14 @ arguments: r0 = left, r1 = right; Returns: r0 = left / right, r1 = left % right
.set SVCLZSSUncomp16bit,       0x080BFA24 @ arguments: r0 = source, r1 = dest (can be VRAM!)
.set SVCLZSSUncomp8bit,        0x080BFA28 @ arguments: r0 = source, r1 = dest (cannot be VRAM :( )
.set SVCMemcopyFast,           0x080BFA0C @ arguments: r0 = source, r1 = dest, r2 = size/mode
.set SVCMemcopy,               0x080BFA10 @ arguments: r0 = source, r1 = dest, r2 = size/mode

.set PlaySound,                0x080BE594 @ arguments: r0 = sound id to play

.set ForEachAdjacentUnit,      0x08023A74 @ arguments: r0 = x, r1 = y, r2 = function<void(UnitStruct*)>; returns: nothing
.set AddTargetListEntry,       0x0804ACFC @ arguments: r0 = x, r1 = y, r2 = unit allegience byte, r3 = trap type; returns: nothing
.set GetTargetListSize,        0x0804B174 @ arguments: nothing; returns: r0 = current target list size

.set GetBallistaItemAt,        0x080346C8 @ arguments: r0 = x, r1 = y; returns: ballista item at (x, y) (0 if none)

.set ScheduleRoutineCall,      0x08014B50 @ arguments: r0 = routine to call, r1 = argument, r2 = time (in frames) before call happens

.set GetFacingDirectionId,     0x0806F478 @ arguments: r0 = xSource, r1 = ySource, r2 = xTarget, r3 = yTarget
.set ChangeActiveUnitFacing,   0x0801EC10 @ arguments: r0 = xTarget, r1 = yTarget

.set IDunnoReallyButIThinkItUpdatesStandingSprites, 0x08025724

.set Map_Fill,                 0x080190AC @ arguments: r0 = rows start ptr, r1 = value; returns: nothing
.set Map_AddInRange,           0x0801A2D4 @ arguments: r0 = Center X, r1 = Center Y, r2 = Range, r3 = Value to Add
.set Map_IncRange,             0x0801B19C @ arguments: r0 = Center X, r1 = Center Y, r2 = Min Range, r3 = Max Range

.set Class_GetROMStruct,       0x08018d20 @ arguments: r0 = Class Index

.set Unit_GetFromEventParam,   0x0800BC50 @ arguments: r0 = Event Paramter; returns: r0 = Unit Struct

.set GetUnit,                  0x08018d0c @ arguments: r0 = Unit Allegience Index; returns: r0 = Unit Struct pointer (0 if not found)
.set Unit_ApplyMovement,       0x08017F28 @ arguments: r0 = Unit Struct pointer
.set Unit_CanCrossTerrain,     0x08018D68 @ arguments: r0 = Unit Struct pointer, r1 = Terrain Index; returns: r0 = 0 if Unit cannot cross/stand on terrain
.set Unit_GetEquippedWeapon,   0x08016764 @ arguments: r0 = Unit Struct pointer; returns: r0 = Item Short
.set Unit_GetItemCount,        0x080176DA @ arguments: r0 = Unit Struct pointer; returns: r0 = Item Count
.set Unit_CanUseAsStaff,       0x080163D2 @ arguments: r0 = Unit Struct pointer, r1 = Item Short; returns: r0 = 0 if cannot use
.set Unit_GetMagOn2Range,      0x080184B4 @ arguments: r0 = Unit Struct pointer
.set Unit_GetRangeMap,         0x08016EBC @ arguments: r0 = Unit Struct pointer, r1 = Item Slot Index (-1 for all); returns: r0 = range mask
.set Unit_CanUseItem,          0x08026cd0 @ arguments: r0 = Unit Struct pointer, r1 = Item Short; returns = 1 if unit can use item, 0 otherwise

.set Unit_GetSpeed,            0x08018b30 @ arguments: r0 = Unit Struct pointer; returns: r0 = Unit Computed Speed
.set Unit_GetDefense,          0x08018b70 @ arguments: r0 = Unit Struct pointer; returns: r0 = Unit Computed Defense

.set BattleUnit_ShouldWRankUp, 0x0807A7D8 @ arguments: r0 = Battle Unit Struct pointer; returns: r0 = 1 if it needs to be shown
.set BattleUnit_ShouldWpnBroke, 0x0807A770 @ arguments: r0 = Battle Unit Struct pointer; returns: r0 = 1 if it needs to be shown

.set Item_GetIndex,            0x080171B4 @ arguments: r0 = Item Short; returns: r0 = Item Index (= (Item Short & 0xFF))
.set Item_GetMight,            0x080172E0 @ arguments: r0 = Item Short; returns: r0 = Might
.set Item_GetAttributes,       0x0801727C @ arguments: r0 = Item Short; returns: r0 = Attribute Word
.set Item_GetWType,            0x0801725c @ arguments: r0 = Item Short; returns: r0 = WType
.set Item_GetWRank,            0x080173B8 @ arguments: r0 = Item Short; returns: r0 = WRank
.set Item_GetUseEffect,        0x0801773C @ arguments: r0 = Item Short; returns: r0 = Use Effect
.set Item_GetMinRange,         0x0801736C @ arguments: r0 = Item Short; returns: r0 = Item Min Range
.set Item_GetMaxRange,         0x08017384 @ arguments: r0 = Item Short; returns: r0 = Item Min Range
.set Item_GetRangeMask,        0x08016DB4 @ arguments: r0 = Item Short; returns: r0 = Item Range Mask
.set Item_GetNameString,       0x080060E0 @ arguments: r0 = Item Short; returns: r0 = Item Name string pointer
.set Item_GetSomeString,       0x080171E4 @ arguments: r0 = Item Short, r1 = Capitalize the S?; returns: r0 = "Some"/"A" Item Name string pointer
.set Item_GetIconIndex,        0x0806d5ac @ arguments: r0 = Item Short; returns: r0 = Icon Id for item
.set Item_IsItem,              0x08016d36 @ arguments: r0 = Item Short; returns: r0 = 0 if item is weapon or staff

.set BottomHelpDisplay_New,    0x08032560 @ arguments: r0 = parent 6C, r1 = pointer to text IN BUFFER
.set BottomHelpDisplay_EndAll, 0x0803279c @ none

.set TargetSelection_New,      0x0804AE88 @ arguments: r0 = pointer to Target Selection Definition

.set MoveRange_ShowGfx,        0x0801D2A0 @ arguments: r0 = type bitfield (&1 = Move Blue Squares, &2 = Range Red Squares, &4 = Range Green Squares, &16 = Range Blue Squares)
.set MoveRange_HideGfx,        0x0801D2D4 @ none

.set MakeUIWindowTileMap,      0x08049CE4 @ arguments: r0 = x, r1 = y, r2 = width?, r3 = height???, [sp+0] = style??????

.set Font_SetupForUI,          0x080053D4 @ arguments: r0 = allocated font struct, r1 = VRAM root, r2 = size, r3 = palette Index
.set Font_ResetAllocation,     0x08005438 @ none

.set Text_Init,                0x08005474 @ arguments: r0 = allocated text struct pointer (8 bytes), r1 = size (in tiles)
.set Text_SetCursor,           0x08005574 @ arguments: r0 = text struct pointer, r1 = cursor pos (in pixels)
.set Text_AdvanceCursor,       0x08005578 @ arguments: r0 = text struct pointer, r1 = cursor pos offset (in pixels)
.set Text_SetColor,            0x08005580 @ arguments: r0 = text struct pointer, r1 = color index
.set Text_GetColor,            0x08005584 @ arguments: r0 = text struct pointer; returns: r0 = color index
.set Text_SetParameters,       0x08005588 @ arguments: r0 = text struct pointer, r1 = X Cursor, r2 = color index
.set Text_AppendString,        0x08005718 @ arguments: r0 = text struct pointer, r1 = string pointer
.set Text_Draw,                0x08005590 @ arguments: r0 = text struct pointer, r1 = root output tile pointer

.set String_GetTextWidth,      0x080055FC @ arguments: r0 = string pointer; returns: r0 = pixel width of string for current font
.set String_FromNumber,        0x08014590 @ arguments: r0 = number, r1 = output buffer; returns: r0 = size of string/number of digits
.set String_FromIdToStdBuffer, 0x08012C60 @ arguments: r0 = text id; returns: r0 = string pointer (actually constant)

.set SetCursorMapPosition,     0x08015A90 @ arguments: r0 = x, r1 = y

.set BeginCameraMovement,      0x08015CE0 @ arguments: r0 = parent 6C (or 0 if none), r1 = map x, r2 = map y

.set Popup_MakeSimple,         0x0800ad40 @ arguments: r0 = Definition, r1 = Time, r2 = Win Style, r3 = Parent 6C
.set Popup_SetShortParam,      0x0800AD28 @ arguments: r0 = Parameter (most likely item or wrank)
.set Popup_SetNumberParam,     0x0800ad34 @ arguments: r0 = Parameter
.set Popup_SetUnitParam,       0x0800ad1c @ arguments: r0 = Unit Parameter

.set MOVEUNIT_NewForMapUnit,   0x0806baf0 @ arguments: r0 = pointer to Unit Struct; returns: r0 = new MOVEUNIT pointer
.set MOVEUNIT_SetMovement,     0x0806c104 @ arguments: r0 = pointer to MOVEUNIT, r1 = pointer to movement buffer
.set MOVEUNIT_SetSprDirection, 0x0806bf4c @ arguments: r0 = pointer to MOVEUNIT, r1 = direction id (use prGetFacingDirectionId, or 0xB for idle)
.set MOVEUNIT_GetDisplayPos,   0x0807924C @ arguments: r0 = pointer to MOVEUNIT, r1 = Destination buffer
.set MOVEUNIT_DeleteAll,       0x0806CCB8 @ none

.set LockGameLogic,            0x08015308
.set UnlockGameLogic,          0x08015318

.set New6C,                    0x08004494 @ arguments: r0 = pointer to ROM 6C code, r1 = parent; returns: r0 = new 6C pointer (0 if no space available)
.set New6CBlocking,            0x080044F8 @ same
.set End6C,                    0x08004584 @ arguments: r0 = pointer to 6C to delete
.set Break6CLoop,              0x080046A0 @ arguments: r0 = pointer to 6C whose loop to break
.set Find6C,                   0x080046A8 @ arguments: r0 = pointer to ROM 6C code; returns: r0 = 6C pointer of first match (0 if none found)
.set Goto6CLabel,              0x08004720 @ arguments: r0 = pointer to 6C, r1 = label index to go to
.set Goto6CPointer,            0x08004758 @ arguments: r0 = pointer to 6C, r1 = pointer to ROM 6C code to go to
.set ForEach6C,                0x08004794 @ arguments: r0 = pointer to ROM 6C code, r1 = function<void(6CStruct*)>
.set BlockEach6CMarked,        0x080047E8 @ arguments: r0 = mark index
.set UnblockEach6CMarked,      0x0800480c @ arguments: r0 = mark index
.set DeleteEach6CMarked,       0x08004834 @ arguments: r0 = mark index
.set DeleteEach6C,             0x0800486c @ arguments: r0 = pointer to ROM 6C code
.set BreakEach6CLoop,          0x08004888 @ arguments: r0 = pointer to ROM 6C code

.set TCS_New,                  0x08011FC4 @ arguments: r0 = ROM source, r1 = OAM Index?
.set TCS_SetAnim,              0x0801225c @ arguments: r0 = TCS, r1 = Index
.set TCS_Update,               0x08012000 @ arguments: r0 = TCS, r1 = Display X, r2 = Display Y
.set TCS_Free,                 0x08011FE8 @ arguments: r0 = TCS

.set AIS_New,                  0x08004F48 @ arguments: r0 = Frame Data pointer, r1 = Depth (or Priority?); returns: r0 = AIS
.set AIS_Free,                 0x08005004 @ arguments: r0 = AIS

.set CopyToOAM_Secondary,      0x08002BB8 @ arguments: r0 = x, r1 = y, r2 = OAM data pointer, r3 = root obj tile index

.set Icon_LoadPalette,         0x08004D44 @ arguments: r0 = Which? (there's 2: 0 & 1), r1 = Output palette Index
.set Icon_LoadOBJGfx,          0x08004E98 @ arguments: r0 = icon id, r1 = output root tile index
.set BG_SetPosition,           0x08001D8C @ arguments: r0 = BG index, r1 = X, r2 = Y
.set BG_EnableSyncByMask,      0x08001FAC @ arguments: r0 = BG Mask
.set BG_EnableSync,            0x08001FBC @ arguments: r0 = BG index
.set EnablePaletteSync,        0x08001F94 @ none
.set BGMap_Fill,               0x08001810 @ arguments: r0 = BG Map Pointer, r1 = Value
.set BG1_Clear,                0x08050018 @ none
.set HandlePPCursorMovement,   0x0801C194 @ none?
.set Call_Future,              0x08014B50 @ arguments: r0 = routine to call, r1 = passed argument, r2 = time in frames to wait before call
.set SaveData_GetSRAMLocation, 0x0809E870 @ arguments: r0 = Save Slot Index (0-2 for standard save, 3-4 for suspends, 5-6 unknown); returns: SRAM Location
.set SaveData_SaveToSRAM,      0x080BFBD8 @ arguments: r0 = Input Data Ptr, r1 = Output SRAM pointer, r2 = Size (bytes)
.set DebugPrint,               0x080039D0 @ arguments: r0 = String
.set DebugPrintHex,            0x080039B4 @ arguments: r0 = Number, r1 = Digits
.set DebugFlushOnBG2_VScroll,  0x08003ABC @ arguments: r0 = current presses, r1 = new presses
.set DebugPrintOBJ,            0x0800530C @ arguments: r0 = x, r1 = y, r2 = String
.set SetupDebugBGFont,         0x0800378C @ arguments: r0 = bg id, r1 = tile offset
.set SMS_GetGraphicsIndex,     0x08024DEC @ arguments: r0 = SMS Index; returns: r0 = Tile Index within buffer
@ Those 2 are using the GmapUnit variants of the routines (not the MOVEUNIT ones)
.set MMS_GetROMTCS,            0x080BAC30 @ arguments: r0 = MMS (class) Index; returns: r0 = pointer to MMS ROMTCS
.set MMS_GetGfx,               0x080BAC1C @ arguments: r0 = MMS (class) Index; returns: r0 = pointer to MMS gfx
.set MOVEUNIT_GetGfxBuffer,    0x08079558 @ arguments: r0 = MOVEUNIT Index; returns: r0 = pointer to buffer of size 0x2200 (!)
@ =================================
@ =========== RAM STUFF ===========
@ =================================
.set ppActiveUnit,             0x03004690 @ Active Unit
.set ppSubjectUnit,            0x02033E40 @ I don't remeber where I found this?

.set pBattleUnitInstiagator,   0x0203A3F0
.set pBattleUnitTarget,        0x0203A470

.set pBattleRoundArray,        0x0203A50C
.set ppBattleCurrentRound,     0x0203A50C

.set pKeyStatusBuffer,         0x02024C78
.set pGameDataStruct,          0x0202BCB0
.set pChapterDataStruct,       0x0202BBF8
.set pActionStruct,            0x0203A868

.set pGenericBuffer,           0x02020140 @ Used while saving among other cases

.set pCurrentMapSize,          0x0202E3D8

.set pEventSlot0,              0x030004B8 @ Array of words (D entries)

.set ppUnitMapRows,            0x0202E3DC
.set ppTerrainMapRows,         0x0202E3E0
.set ppMoveMapRows,            0x0202E3E4
.set ppRangeMapRows,           0x0202E3E8
.set ppFogMapRows,             0x0202E3EC
.set ppOtherMoveMapRows,       0x0202E3F4

.set pBG0TileMap,              0x02022C60
.set pBG1TileMap,              0x02023460
.set pBG2TileMap,              0x02023C60
.set pBG3TileMap,              0x02024460

.set pPaletteBuffer,           0x02022860
.set pLCDControlBuffer,        0x03002870

.set pPopupShortArgument,      0x030005F4
.set ppPopupUnit,              0x030005F0
.set pPopupNumber,             0x030005F8

.set pp6CBattlePopup,          0x02020140
.set pBattlePopupEnded,        0x02020144

@ ===================================
@ ============ ROM STUFF ============
@ ===================================

.set p6C_GBToUnitMenu,         0x0859B600

@ For use with CopytoOAM
.set pOAM_8x8,                 0x08B905B0
.set pOAM_16x16,               0x08590F4C
.set pOAM_32x32,               0x08590F54
.set pOAM_64x64,               0x08590F5C
.set pOAM_16x32,               0x08590F6C

.set ppStandingMapSpriteTable, 0x08024e28 @ Pointing to a literal to account for possible repointing
.set paSMSTileIndexLookup, 0x02033E44 @ Table containing OBJ tile indexes, indexed by SMS id
