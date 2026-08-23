#include "SkillActivationFlags.h"

// ============================================================================
// Skill activation flags (DEC-85) -- see SkillActivationFlags.h.
// ============================================================================
// unit->unk3A and unit->unk3B are adjacent and unit+0x3A is halfword aligned,
// so the pair is addressed as one u16. It is done through a helper rather than
// a cast at each site so there is exactly one place that knows the layout.
// ============================================================================

static inline u16 GetUnitActivationFlags(struct Unit* unit)
{
	return unit->unk3A | (unit->unk3B << 8);
}

static inline void SetUnitActivationFlags(struct Unit* unit, u16 flags)
{
	unit->unk3A = flags & 0xFF;
	unit->unk3B = flags >> 8;
}

int GetSkillActivationBit(int skillId)
{
	int bit = SkillActivationFlagTable[skillId & 0xFF];

	// The table stores bit + 1 so that 0 can mean "no bit".
	return bit - 1;
}

int GetPerMapActivationFlagMask(void)
{
	int mask = 0;
	int bit;

	for (bit = 0; bit < ACTIVATION_FLAG_BIT_COUNT; bit++)
		if (SkillActivationFlagScope[bit] != ACTIVATION_FLAG_SCOPE_PER_TURN)
			mask |= 1 << bit;

	return mask;
}

int IsSkillActivationFlagSet(struct Unit* unit, int skillId)
{
	int bit = GetSkillActivationBit(skillId);

	// A skill that owns no bit is never blocked.
	if (bit < 0)
		return 0;

	return (GetUnitActivationFlags(unit) & (1 << bit)) != 0;
}

int CanSkillActivationFlagProc(struct Unit* unit, int skillId)
{
	return !IsSkillActivationFlagSet(unit, skillId);
}

struct Unit* SetSkillActivationFlag(struct Unit* unit, int skillId)
{
	int bit = GetSkillActivationBit(skillId);

	if (bit >= 0)
		SetUnitActivationFlags(unit, GetUnitActivationFlags(unit) | (1 << bit));

	return unit;
}

struct Unit* ClearSkillActivationFlag(struct Unit* unit, int skillId)
{
	int bit = GetSkillActivationBit(skillId);

	if (bit >= 0)
		SetUnitActivationFlags(unit, GetUnitActivationFlags(unit) & ~(1 << bit));

	return unit;
}

struct Unit* ClearUnitActivationFlags(struct Unit* unit)
{
	SetUnitActivationFlags(unit, 0);
	return unit;
}

struct Unit* ClearUnitTurnActivationFlags(struct Unit* unit)
{
	SetUnitActivationFlags(unit,
		GetUnitActivationFlags(unit) & GetPerMapActivationFlagMask());

	return unit;
}

int ResetTurnActivationFlags(void)
{
	int keep = GetPerMapActivationFlagMask();
	int i;

	for (i = 1; i <= ACTIVATION_FLAG_LAST_DEPLOYMENT_ID; i++)
	{
		struct Unit* unit = GetUnit(i);

		// gUnitLookup has NULL holes, and freed slots keep a stale pointer with
		// a cleared pCharacterData -- skip both.
		if (!unit || !unit->pCharacterData)
			continue;

		SetUnitActivationFlags(unit, GetUnitActivationFlags(unit) & keep);
	}

	// Proc routines return 0 to mean "nothing to block on".
	return 0;
}
