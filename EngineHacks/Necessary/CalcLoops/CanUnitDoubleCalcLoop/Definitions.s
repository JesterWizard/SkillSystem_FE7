.include "../../../SkillSystem/Internals/NewSkillTester/reference/SkillsRef.s"
.include "Hooks.s" 

SET_FUNC BattleForecastHitCountUpdate, 0x80334E8+1 //changed 803666C+1
SET_FUNC ClearBattleHits, 0x08028F85
SET_FUNC BattleGetBattleUnitOrder, 0x08029029
SET_FUNC BattleGetFollowUpOrder, 0x0802903D
SET_FUNC BattleGenerateRoundHits, 0x080290B9
SET_FUNC GetItemIndex, 0x080171B5
SET_FUNC GetItemUses, 0x08017295
SET_FUNC GetItemWeaponEffect, 0x08017425
SET_FUNC IsItemEffectiveAgainst, 0x8016821 // FE7; SkillsRef still has the FE8 pointer-table address
SET_FUNC GetUnitSupportBonuses, 0x8026A19 // FE7; SkillsRef still has FE8 0x80285B1
SET_DATA gpCurrentRound, 0x0203A50C
SET_DATA gBattleHitIterator, 0x0203A50C


