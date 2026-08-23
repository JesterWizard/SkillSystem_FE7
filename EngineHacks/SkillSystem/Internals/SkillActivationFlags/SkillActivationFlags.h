#ifndef SKILL_ACTIVATION_FLAGS_H
#define SKILL_ACTIVATION_FLAGS_H

#include "../NewSkillTester/include/gbafe.h"

// ============================================================================
// Skill activation flags (DEC-85)
// ============================================================================
// Sixteen per-unit "this skill has already fired" bits, packed into the two
// vanilla-unused unit bytes 0x3A and 0x3B. While a skill's bit is set, the
// skill must not proc again.
//
// A skill claims a bit in flag_assignments.event, which fills the two tables
// below. Scope decides when the bit clears:
//
//   once per turn -- cleared for every unit at the top of each player phase
//   once per map  -- cleared only when the unit is loaded for a chapter
//
// The bit lives on the *deployed* Unit, never on a BattleUnit: the battle
// structs are working copies and only selected fields survive combat. A skill
// running in a battle loop must GetUnit(battleUnit->unit.index) first.
// ============================================================================

enum {
	// Bits available, i.e. the width of unit->unk3A/unk3B taken together.
	ACTIVATION_FLAG_BIT_COUNT = 16,

	// Skill IDs are one byte.
	ACTIVATION_FLAG_SKILL_COUNT = 256,

	// Highest deployment id the reset loop walks.
	ACTIVATION_FLAG_LAST_DEPLOYMENT_ID = 0xBF
};

enum {
	ACTIVATION_FLAG_SCOPE_PER_TURN = 0,
	ACTIVATION_FLAG_SCOPE_PER_MAP  = 1
};

// Returned by GetSkillActivationBit for a skill that owns no bit.
#define ACTIVATION_FLAG_NO_BIT (-1)

// Filled by SkillActivationFlags.event.
//   SkillActivationFlagTable[skillId] = bit + 1, or 0 for "no bit"
//   SkillActivationFlagScope[bit]     = ACTIVATION_FLAG_SCOPE_*
extern const u8 SkillActivationFlagTable[ACTIVATION_FLAG_SKILL_COUNT];
extern const u8 SkillActivationFlagScope[ACTIVATION_FLAG_BIT_COUNT];

// -> bit index 0..15, or ACTIVATION_FLAG_NO_BIT when the skill owns no flag.
int GetSkillActivationBit(int skillId);

// Mask of the bits declared once-per-map, i.e. the bits a turn reset keeps.
int GetPerMapActivationFlagMask(void);

// 1 when the flag is already set, i.e. the skill has fired.
// A skill that owns no bit is never blocked.
int IsSkillActivationFlagSet(struct Unit* unit, int skillId);

// 1 when the skill may still fire. The inverse of IsSkillActivationFlagSet.
int CanSkillActivationFlagProc(struct Unit* unit, int skillId);

struct Unit* SetSkillActivationFlag(struct Unit* unit, int skillId);
struct Unit* ClearSkillActivationFlag(struct Unit* unit, int skillId);

// Clears every bit, both scopes. Called when a unit is loaded.
struct Unit* ClearUnitActivationFlags(struct Unit* unit);

// Clears the once-per-turn bits, keeps the once-per-map ones.
struct Unit* ClearUnitTurnActivationFlags(struct Unit* unit);

// Proc routine run from the top of gProcScr_PlayerPhase; clears the
// once-per-turn bits on every loaded unit.
int ResetTurnActivationFlags(void);

#endif // SKILL_ACTIVATION_FLAGS_H
