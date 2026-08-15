
.include "C:/devkitPro/FE-CLib/reference/FE8U-20190316.s"
SET_FUNC m4aSongNumStart, 0x80D01FD
SET_FUNC Menu_Draw, 0x804EF71
SET_FUNC GetChapterDefinition, 0x8034619
SET_FUNC SetupSupportPalettes, 0x8098C3D 
SET_FUNC LoadObjUIGfx, 0x8015681
SET_FUNC LoadGameCoreGfx, 0x80156F5
SET_DATA SupportScreenPal, 0x8A1B174 
SET_FUNC ApplyMapSpritePalettes, 0x8026629
SET_FUNC MapEventEngineExists, 0x800D199

SET_FUNC Font_ResetAllocation, (0x08005438+1) 
SET_FUNC Clean, (0x800F0C8+1) 

//@ Vanilla function declarations:
SET_FUNC PushToSecondaryOAM, 0x08002BB9
SET_FUNC RegisterObjectTileGraphics, 0x8012FF5
SET_FUNC GetUnitRangeMask, (0x08016EBC+1)

SET_FUNC CanUnitUseWeapon, (0x8016380+1)

SET_FUNC CanUnitUseStaff, (0x8016428 + 1)

SET_FUNC DrawItemMenuCommand, (0x08016470+1)

SET_FUNC GetWeaponRangeMask, (0x08016DB4+1)

SET_FUNC AttackUMEffect, (0x08021A3C+1)

SET_FUNC DrawItemRText, (0x08088E60+1)

SET_FUNC RTextUp, (0x08089354+1)

SET_FUNC RTextDown, (0x08089384+1)

SET_FUNC RTextLeft, (0x080893B4+1)

SET_FUNC RTextRight, (0x080893E4+1)

SET_FUNC GetUnitEquippedItem, (0x08016764+1)

SET_FUNC StartMovingPlatform, (0x080CD408+1)

SET_FUNC SetupMovingPlatform, (0x080CD47C+1)
SET_FUNC DeleteSomeAISStuff, (0x0805AA28+1)

SET_FUNC DeleteSomeAISProcs, (0x0805AE14+1)


SET_FUNC LockGameGraphicsLogic, 0x8030185
SET_FUNC UnlockGameGraphicsLogic, 0x80301B9
SET_FUNC MU_AllDisable, 0x80790E1
SET_FUNC MU_AllEnable, 0x80790ED

//@ Data declarations:
SET_DATA gBG0MapBuffer, 0x02022C60

SET_DATA gBG1MapBuffer, 0x02023460

SET_DATA gBG2MapBuffer, 0x02023C60

SET_DATA gPlayerGold, 0x202BCF8
SET_DATA gSomeAISStruct, 0x030053A0

SET_DATA gSomeAISRelatedStruct, 0x0201FADC

SET_DATA MemorySlot, 0x30004B8




