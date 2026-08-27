@ Shared FE7U addresses for the Heroes Movement menu skills.
@ Shove/ShoveAction.s is the template; these skills follow it.

.equ gActionData,   0x0203A85C
.equ gActiveUnit,   0x03004690
.equ gMapSize,      0x0202E3D8
.equ ppMapUnit,     0x0202E3DC
.equ ppMapTerrain,  0x0202E3E0
.equ ppMapRange,    0x0202E3E8
.equ ppMapHidden,   0x0202E3F0

.equ ForEachAdjacentPosition, 0x08023AA9
.equ AddTarget,               0x0804ACFD
.equ GetTargetListSize,       0x0804B175
.equ StartTargetSelection,    0x0804AE89
.equ ClearMapWith,            0x080190AD
.equ GetUnit,                 0x08018D0D
.equ CanUnitCrossTerrain,     0x08018D69
.equ ChangeActiveUnitFacing,  0x0801EC11
.equ GetStringFromIndex,      0x08012C61
.equ NewBottomHelpText,       0x08032561
.equ ClearBG0BG1,             0x0804A041
.equ HideMoveRangeGfx,        0x0801D2D5
.equ SelectionBackToUnitMenu, 0x08021655
.equ RefreshEntityMaps,       0x08019ABD
.equ GetFacingFromTo,         0x0801D3DD
.equ NewUnitMoveProc,         0x0801D47D
.equ AreAllegiancesAllied,    0x080238B1
.equ InitTargets,             0x0804AC4D
.equ DeleteAllMoveUnits,      0x0806CCB9

.equ US_UNSELECTABLE, 0x40
.equ US_RESCUED,      0x20
.equ MENU_ENABLED,    1
.equ MENU_HIDDEN,     3
.equ SELECTION_DONE,  0x17
.equ UNIT_MAG,        0x47

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm
