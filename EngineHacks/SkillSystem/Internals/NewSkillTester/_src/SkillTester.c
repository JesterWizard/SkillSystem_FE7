#include "SkillTester.h"

/*Helper functions*/
static int  absolute(int value)        {return value < 0 ? -value : value;}
static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
static bool IsBattleReal() {
    return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
}

//Checks if given unit is on the field
static bool IsUnitOnField(Unit* unit) {
    if (!unit || !unit->pCharacterData)
        return FALSE;

    if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
        return FALSE;

    if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
        return FALSE;
    }

    return TRUE;
}

//Checks if given skillID is in given skill buffer
static inline bool IsSkillInBuffer(SkillBuffer* buffer, u8 skillID) __attribute__((always_inline));
static inline bool IsSkillInBuffer(SkillBuffer* buffer, u8 skillID) {
    for (int i = 0; buffer->skills[i] != 0; ++i) {
        if (buffer->skills[i] == skillID) {
            return TRUE;
        }
    }
    return FALSE;
}

//Checks if the given skillID is negated by Nihil
//Read the live opponent battle unit — do not trust skill RAM buffers.
//GetSkills still caches a unit pointer at gAttackerSkillBuffer (0x0202A9D4).
bool NihilTester(Unit* unit, u8 skillID) {
    if (!IsBattleReal() || !NegatedSkills[skillID]) {
        return FALSE;
    }

    Unit* opponent;
    if (unit->index == gBattleTarget.unit.index) {
        opponent = &gBattleActor.unit;
    }
    else if (unit->index == gBattleActor.unit.index) {
        opponent = &gBattleTarget.unit;
    }
    else {
        return FALSE;
    }

    if (!opponent->pCharacterData || !opponent->pClassData) {
        return FALSE;
    }

    u8 nihil = NihilIDLink;
    if (PersonalSkillTable[opponent->pCharacterData->number] == nihil) {
        return TRUE;
    }
    if (ClassSkillTable[opponent->pClassData->number] == nihil) {
        return TRUE;
    }

    int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
    if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
        learnedLimit = 6;
    }
    for (int i = 0; i < learnedLimit; ++i) {
        if (!IsSkillIDValid(opponent->supports[i])) {
            break;
        }
        if (opponent->supports[i] == nihil) {
            return TRUE;
        }
    }

    return FALSE;
}

/*Main functions*/

SkillBuffer* MakeSkillBuffer(Unit* unit, SkillBuffer* buffer) {
    int unitNum = 0, count = 0, temp = 0;

    if (!unit || !unit->pCharacterData || !unit->pClassData) {
        buffer->lastUnitChecked = unit ? unit->index : 0;
        buffer->skills[0] = 0;
        return buffer;
    }

    unitNum = unit->pCharacterData->number;
    buffer->lastUnitChecked = unit->index;

    //Personal skill
    temp = PersonalSkillTable[unitNum];
    if (IsSkillIDValid(temp)) {
        buffer->skills[count++] = temp;
    }

    //Class skill
    temp = ClassSkillTable[unit->pClassData->number];
    if (IsSkillIDValid(temp)) {
        buffer->skills[count++] = temp;
    }

    // Learned skills in unit->supports[]. Players: up to limit. Others: 6 (leader at [6]).
    int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
    if ((unit->index & 0xC0) != 0) {
        if (learnedLimit > 6) {
            learnedLimit = 6;
        }
    }
    for (int i = 0; i < learnedLimit; ++i) {
        if (!IsSkillIDValid(unit->supports[i])) {
            break;
        }
        buffer->skills[count++] = unit->supports[i];
    }

    //Item passive skills
    for (int i = 0; i < 5 && unit->items[i]; ++i) {
        temp = unit->items[i];
        if ((GetItemAttributes(temp) & PassiveSkillBit)) {
            if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
                buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
                //If passive skills don't stack, stop looping
                if (!gSkillTestConfig.passiveSkillStack) {
                    break;
                }
            }
        }
    }

    //Equipped weapon skills
    //If unit is in combat, use the equipped weapon short
    if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
        temp = gBattleActor.weaponBefore;
    }
    else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
        temp = gBattleTarget.weaponBefore;
    }
    //Otherwise, get the equipped weapon via a vanilla function
    else {
        temp = GetUnitEquippedWeapon(unit);
    }

    {
        const ItemData* itemData = GetItemData(temp & 0xFF);
        if (itemData && IsSkillIDValid(itemData->skill)) {
            buffer->skills[count++] = itemData->skill;
        }
    }

    //Add terminator to end of list
    buffer->skills[count++] = 0;

    return buffer;
}

//Creates an aura skill buffer with skill coordinates relative to a unit
AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
    SkillBuffer* buffer = &gAttackerSkillBuffer;
    AuraSkillBuffer* auraBuffer = gAuraSkillBuffer;
    int count = 0;
    int distance = 0;

    for (int i = 0; i < 0x100; ++i) {
        Unit* other = gUnitLookup[i];

        if (!IsUnitOnField(other) || unit->index == i) {
            continue;
        }

        //If the unit is actually on the field, make a skill buffer for them
        buffer = MakeSkillBuffer(other, buffer);

        //For every skill in the buffer, index AuraSkillTable to find a match
        for (int j = 0; buffer->skills[j] != 0; ++j) {
            if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
                auraBuffer[count].skillID = buffer->skills[j];

                distance = absolute(other->xPos - unit->xPos) +
                           absolute(other->yPos - unit->yPos);

                if (distance > 63) {
                    distance = 63;
                }

                //No need to `& 0x3F` because of the limit
                auraBuffer[count].distance = distance;
                //Shifting for storage
                auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
                ++count;
            }
        }
    }

    //Cleanup to avoid caching issues
    buffer->lastUnitChecked = 0;
    gAuraSkillBuffer[count++].skillID = 0;

    return gAuraSkillBuffer;
}

//Checks for skills in an in progress buffer
//Used by the weapon usability calc loop
bool CheckSkillBuffer(Unit* unit, u8 skillID) {
    if (skillID == 0)   {return TRUE;}
    if (skillID == 255) {return FALSE;}

    SkillBuffer* buffer = &gAttackerSkillBuffer;

    //lastUnitChecked is already set, so no need for extra checks
    if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
        buffer = &gDefenderSkillBuffer;
    }

    return IsSkillInBuffer(buffer, skillID);
}

//Checks unit for a given skill.
//If the unit tested is the same as last time, uses the previous skill buffer
bool SkillTester(Unit* unit, u8 skillID) {
    if (skillID == 0)   {return TRUE;}
    if (skillID == 255) {return FALSE;}
    if (!unit || !unit->pCharacterData || !unit->pClassData) {return FALSE;}

    int index = unit->index;

    //Default to the attacker buffer
    SkillBuffer* buffer = &gAttackerSkillBuffer;

    //If unit is the defender, use the defender buffer
    if (index == gBattleTarget.unit.index && IsBattleReal()) {
        buffer = &gDefenderSkillBuffer;
    }

    if (index != buffer->lastUnitChecked) {
        MakeSkillBuffer(unit, buffer);
    }

    //Check if matching skill is in buffer
    if (IsSkillInBuffer(buffer, skillID)) {
        //Reverse check since NihilTester returns true if nihil is found
        return !NihilTester(unit, skillID);
    }

    //Catch 'Em All: treat the unit as having every skill
    if (IsSkillIDValid(CatchEmAllIDLink) && IsSkillInBuffer(buffer, CatchEmAllIDLink)) {
        return !NihilTester(unit, skillID);
    }

    return FALSE;
}

//Loops through premade aura skill buffer to find matching aura skills within range
bool NewAuraSkillCheck(Unit* unit, u8 skillID, int allyOption, int maxRange) {
    const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);

    if (skillID == 0)   {return TRUE;}
    if (skillID == 255) {return FALSE;}

    AuraSkillBuffer* auraBuffer = gAuraSkillBuffer;
    int limit = gSkillTestConfig.auraSkillBufferLimit;
    for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
        if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {

            //NOTE: This is checking bits
            int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);

            if (allyOption & 2)
                check = !check;

            if (check || (allyOption & 4))
                return TRUE;
        }
    }

    return FALSE;
}

//Prepares buffers for prebattle loop
void InitializePreBattleLoop(Unit* attacker, Unit* defender) {
    MakeAuraSkillBuffer(attacker);
    MakeSkillBuffer(attacker, &gAttackerSkillBuffer);
    gDefenderSkillBuffer.lastUnitChecked = 0;

    if (IsBattleReal()) {
        MakeSkillBuffer(&gBattleTarget.unit, &gDefenderSkillBuffer);
    }
}

//Sets skill buffers to refresh next skill test
void InitSkillBuffers() {
    gAttackerSkillBuffer.lastUnitChecked = 0;
    gDefenderSkillBuffer.lastUnitChecked = 0;
}

//Finds units in a radius and returns a list of matching unit's indexes
u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
    const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);

    int count = 0;
    int check = 0;

    for (int i = 0; i < 0x100; ++i) {
        Unit* other = gUnitLookup[i];

        if (!IsUnitOnField(other) || unit->index == i) {
            continue;
        }

        //Check if other matches allyOption's criteria
        if (allyOption & 2) {
            check = !pAllegianceChecker(unit->index, other->index);
        }
        else {
            check =  pAllegianceChecker(unit->index, other->index);
        }

        if (check || (allyOption & 4)) {
            if ((absolute(other->xPos - unit->xPos)
               + absolute(other->yPos - unit->yPos)) <= range) {
                gUnitRangeBuffer[count++] = i;
            }
        }
    }

    //Terminator
    gUnitRangeBuffer[count++] = 0;
    if (!gUnitRangeBuffer[0])
        return FALSE;

    return gUnitRangeBuffer;
}
