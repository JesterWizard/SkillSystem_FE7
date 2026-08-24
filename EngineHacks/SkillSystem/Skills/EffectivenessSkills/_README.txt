If ENABLE_SLAYER_AND_EFFECTIVENESS_REWORK is commented out (in Config.event), vanilla effectiveness is unchanged.

If enabled, class weaknesses are a bitfield at class+0x50 (ArmorType, HorseType, FlierType, DragonType, MonsterType, SwordType in Tables/TableDefinitions.event).

Weapon effectiveness pointers (+0x10) list {BYTE 0, coeff*2; SHORT types} terminated by WORD 0. Delphi Shield uses the same pointer with SetProtection(FlierType) and item ability 0x4000.

FE7 hooks:
- 0x28B32 BC_Power: apply max(slayer, weapon) coeff, Resourceful doubles it, then attack = attack * coeff / 2
- 0x16820 IsItemEffectiveAgainst: 0/1 for forecast, respects Nullify and protector items

Skills (Effectiveness_Skills.s):
- Nullify: defender is immune to effective damage (weapons and Slayer/Skybreaker)
- Resourceful: double the effectiveness coefficient
- Skybreaker: effective vs FlierType
- Slayer: effective vs MonsterType

Slayer is the skill, not a class table. Give the unit Slayer and set MonsterType on target classes.
