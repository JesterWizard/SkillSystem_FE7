#include "../../../Internals/NewSkillTester/include/gbafe.h"
#include "../../../Internals/SkillActivationFlags/SkillActivationFlags.h"

// ============================================================================
// Hurricane -- dodges the first attack against this unit every turn.
// ============================================================================
// Runs from the battle proc loop, immediately after ProcLoop_Start (which has
// already rolled true hit and, on a hit, computed damage). If this round is the
// first attack against the unit this turn, it is turned into a miss.
//
// "Every turn" is the once-per-turn half of the DEC-85 activation flags.
//
// Two things this routine has to get right, both of which were live bugs in the
// hand-written assembly version:
//
// 1. The defender is NOT the r1 the proc loop passes. ProcLoopParent (vanilla
//    0x29264) is reached from 0x080294FE with only the attacker in r0, and it
//    then hardcodes r1 = gBattleTarget. So r1 is the true defender only on
//    rounds gBattleActor initiates; on a counterattack it points back at the
//    attacker. The defender is whichever battle unit is not attacking.
//
// 2. A round that already missed still counts as the first attack. MakeBattle
//    (0x08028FB0) resolves the whole combat -- attack, counter, both doubling
//    rounds -- in one pass before anything animates. ProcLoop_Start rolls true
//    hit before this routine runs, so a naturally-missed round arrives already
//    carrying BATTLE_HIT_ATTR_MISS. If that did not spend the charge, the dodge
//    would land on the *second* swing of the same combat, which reads in game
//    as the skill firing late and inconsistently.
//
// 3. The battle forecast runs this same loop. Any skill that writes persistent
//    state has to check gBattleStats.config first, or merely opening the
//    forecast menu spends the charge before a blow is ever struck.
// ============================================================================

extern int SkillTester(struct Unit* unit, int id);
extern int HurricaneID_Link;

// A round already claimed by another skill is not Hurricane's to consume.
#define CLAIMED_BY_ANOTHER_SKILL \
	(BATTLE_HIT_ATTR_SURESHOT | BATTLE_HIT_ATTR_GREATSHLD)

void Hurricane(struct BattleUnit* attacker, struct BattleUnit* unused,
	struct BattleHit* round, struct BattleStats* stats)
{
	struct BattleUnit* defender;
	struct Unit* unit;
	int alreadyMissed;

	// The battle forecast runs this very same proc loop to predict the fight,
	// so a skill that writes anything persistent MUST bail here or it fires
	// just from opening the menu -- the charge is spent before a blow lands.
	//
	// gBattleStats.config is written wholesale before each generation:
	//   BattleGenerateSimulation (forecast) 0x2, ballista sim 0xA -- SIMULATE
	//   BattleGenerateReal                  0x1 and 0x9          -- REAL
	// so real combat always has REAL set and SIMULATE clear.
	if (!(stats->config & BATTLE_CONFIG_REAL))
		return;

	if (stats->config & BATTLE_CONFIG_SIMULATE)
		return;

	// See note 1 above: derive the defender, never trust the passed r1.
	defender = (attacker == &gBattleActor) ? &gBattleTarget : &gBattleActor;

	// Belt and braces: the loop is also run with no class data in some paths.
	if (!defender->unit.pClassData)
		return;

	if (round->attributes & CLAIMED_BY_ANOTHER_SKILL)
		return;

	if (!SkillTester(&defender->unit, HurricaneID_Link))
		return;

	// The flag lives on the deployed Unit, not on the battle copy.
	unit = GetUnit(defender->unit.index);

	if (!unit)
		return;

	if (!CanSkillActivationFlagProc(unit, HurricaneID_Link))
		return;

	SetSkillActivationFlag(unit, HurricaneID_Link);

	// See note 2 above: the charge is spent either way, but a round that missed
	// on its own has nothing left to rewrite.
	alreadyMissed = round->attributes & BATTLE_HIT_ATTR_MISS;

	if (alreadyMissed)
		return;

	round->attributes |= BATTLE_HIT_ATTR_MISS;
	stats->damage = 0;
}
