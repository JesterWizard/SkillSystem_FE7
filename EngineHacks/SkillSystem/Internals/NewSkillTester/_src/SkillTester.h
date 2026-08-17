#include "../include/gbafe.h"

typedef struct SkillBuffer SkillBuffer;
typedef struct AuraSkillBuffer AuraSkillBuffer;
typedef struct SkillTestConfig SkillTestConfig;


extern s8 AreAllegiancesEqual(int factionA, int factionB);
extern s8 AreAllegiancesAllied(int factionA, int factionB);
extern int AreUnitsAllied(int, int) __attribute__((long_call));
extern int IsSameAllegience(int, int) __attribute__((long_call)); // forgive the typo
//Using a function pointer GetInitialSkillList doesn't have the thumb bit set
extern u8* (*GetInitialSkillList_Pointer) (Unit* unit, u8* skillBuffer);

struct SkillBuffer {
/*00*/  u8 lastUnitChecked;
/*01*/  u8 skills[11];
};

struct AuraSkillBuffer {
/*00*/  u8 skillID;
/*01*/  u8 distance : 6; //Relative to main unit
/*01*/  u8 faction  : 2;
};

struct SkillTestConfig {
/*00*/  u16 auraSkillBufferLimit;
/*02*/  u8 genericLearnedSkillLimit;
/*03*/  u8 passiveSkillStack;
/*04*/  u8 roofUnitAuras;
};

//RAM buffers
extern SkillBuffer gAttackerSkillBuffer;
extern SkillBuffer gDefenderSkillBuffer;
extern AuraSkillBuffer gAuraSkillBuffer[];
extern u8 gTempSkillBuffer[];
extern u8 gUnitRangeBuffer[];

//Tables in ROM defined by buildfile
extern u8 AuraSkillTable[];
extern u8 NegatedSkills[];
extern u8 PersonalSkillTable[];
extern u8 ClassSkillTable[];

extern u8 NihilIDLink;
extern u32 PassiveSkillBit;

extern SkillTestConfig gSkillTestConfig;
