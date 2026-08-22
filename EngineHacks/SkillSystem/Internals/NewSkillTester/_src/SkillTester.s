	.cpu arm7tdmi
	.arch armv4t
	.fpu softvfp
	.eabi_attribute 20, 1	@ Tag_ABI_FP_denormal
	.eabi_attribute 21, 1	@ Tag_ABI_FP_exceptions
	.eabi_attribute 23, 3	@ Tag_ABI_FP_number_model
	.eabi_attribute 24, 1	@ Tag_ABI_align8_needed
	.eabi_attribute 25, 1	@ Tag_ABI_align8_preserved
	.eabi_attribute 26, 1	@ Tag_ABI_enum_size
	.eabi_attribute 30, 4	@ Tag_ABI_optimization_goals
	.eabi_attribute 34, 0	@ Tag_CPU_unaligned_access
	.eabi_attribute 18, 4	@ Tag_ABI_PCS_wchar_t
	.file	"SkillTester.c"
@ GNU C17 (devkitARM release 63) version 13.2.0 (arm-none-eabi)
@	compiled by GNU C version 10.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.18-GMP

@ GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
@ options passed: -mcpu=arm7tdmi -mthumb -mthumb-interwork -mtune=arm7tdmi -mlong-calls -march=armv4t -Os
	.text
	.align	1
	.syntax unified
	.code	16
	.thumb_func
	.type	IsUnitOnField, %function
IsUnitOnField:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:11: static bool IsUnitOnField(Unit* unit) {
	subs	r3, r0, #0	@ unit, tmp133,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	beq	.L2		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	ldr	r2, [r0]	@ unit_6(D)->pCharacterData, unit_6(D)->pCharacterData
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:13:         return FALSE;
	subs	r0, r2, #0	@ <retval>, unit_6(D)->pCharacterData,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	beq	.L2		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	ldr	r3, [r3, #12]	@ _2, unit_6(D)->state
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	ldr	r2, .L9	@ tmp123,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:13:         return FALSE;
	movs	r0, #0	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	tst	r3, r2	@ _2, tmp123
	bne	.L2		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:22:     return TRUE;
	adds	r0, r0, #1	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	lsls	r3, r3, #24	@ tmp134, _2,
	bpl	.L2		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	ldr	r3, .L9+4	@ tmp126,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	ldrb	r0, [r3, #4]	@ tmp128,
	subs	r3, r0, #1	@ tmp130, tmp128
	sbcs	r0, r0, r3	@ <retval>, tmp128, tmp130
.L2:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:23: }
	@ sp needed	@
	bx	lr
.L10:
	.align	2
.L9:
	.word	65580
	.word	gSkillTestConfig
	.size	IsUnitOnField, .-IsUnitOnField
	.align	1
	.global	NihilTester
	.syntax unified
	.code	16
	.thumb_func
	.type	NihilTester, %function
NihilTester:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L31	@ tmp148,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39: bool NihilTester(Unit* unit, u8 skillID) {
	push	{r4, r5, lr}	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:40:     if (!IsBattleReal() || !NegatedSkills[skillID]) {
	ldrh	r4, [r2]	@ gBattleStats, gBattleStats
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39: bool NihilTester(Unit* unit, u8 skillID) {
	movs	r3, r0	@ unit, tmp181
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:40:     if (!IsBattleReal() || !NegatedSkills[skillID]) {
	movs	r2, #3	@ tmp152,
	movs	r0, r4	@ tmp154, gBattleStats
	ands	r0, r2	@ tmp154, tmp152
	tst	r4, r2	@ gBattleStats, tmp152
	beq	.L12		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:40:     if (!IsBattleReal() || !NegatedSkills[skillID]) {
	ldr	r2, .L31+4	@ tmp156,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:40:     if (!IsBattleReal() || !NegatedSkills[skillID]) {
	ldrb	r2, [r2, r1]	@ tmp157, NegatedSkills
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:41:         return FALSE;
	subs	r0, r2, #0	@ <retval>, tmp157,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:40:     if (!IsBattleReal() || !NegatedSkills[skillID]) {
	beq	.L12		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:45:     if (unit->index == gBattleTarget.unit.index) {
	movs	r1, #11	@ _5,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:45:     if (unit->index == gBattleTarget.unit.index) {
	movs	r0, #11	@ tmp159,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:45:     if (unit->index == gBattleTarget.unit.index) {
	ldr	r2, .L31+8	@ tmp158,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:45:     if (unit->index == gBattleTarget.unit.index) {
	ldrsb	r1, [r3, r1]	@ _5,* _5
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:45:     if (unit->index == gBattleTarget.unit.index) {
	ldrsb	r0, [r2, r0]	@ tmp159,
	ldr	r3, .L31+12	@ opponent,
	cmp	r0, r1	@ tmp159, _5
	beq	.L13		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:48:     else if (unit->index == gBattleActor.unit.index) {
	ldrb	r3, [r3, #11]	@ tmp161,
	lsls	r3, r3, #24	@ tmp161, tmp161,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:41:         return FALSE;
	movs	r0, #0	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:48:     else if (unit->index == gBattleActor.unit.index) {
	asrs	r3, r3, #24	@ tmp161, tmp161,
	cmp	r3, r1	@ tmp161, _5
	bne	.L12		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:49:         opponent = &gBattleTarget.unit;
	movs	r3, r2	@ opponent, tmp158
.L13:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:55:     if (!opponent->pCharacterData || !opponent->pClassData) {
	ldr	r5, [r3]	@ _9, opponent_22->pCharacterData
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:41:         return FALSE;
	subs	r0, r5, #0	@ <retval>, _9,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:55:     if (!opponent->pCharacterData || !opponent->pClassData) {
	beq	.L12		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:55:     if (!opponent->pCharacterData || !opponent->pClassData) {
	ldr	r1, [r3, #4]	@ _10, opponent_22->pClassData
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:41:         return FALSE;
	subs	r0, r1, #0	@ <retval>, _10,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:55:     if (!opponent->pCharacterData || !opponent->pClassData) {
	beq	.L12		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:59:     u8 nihil = NihilIDLink;
	ldr	r2, .L31+16	@ tmp162,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:60:     if (PersonalSkillTable[opponent->pCharacterData->number] == nihil) {
	ldrb	r0, [r5, #4]	@ tmp164,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:59:     u8 nihil = NihilIDLink;
	ldrb	r4, [r2]	@ nihil, NihilIDLink
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:60:     if (PersonalSkillTable[opponent->pCharacterData->number] == nihil) {
	ldr	r2, .L31+20	@ tmp163,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:60:     if (PersonalSkillTable[opponent->pCharacterData->number] == nihil) {
	ldrb	r2, [r2, r0]	@ tmp165, PersonalSkillTable
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:61:         return TRUE;
	movs	r0, #1	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:60:     if (PersonalSkillTable[opponent->pCharacterData->number] == nihil) {
	cmp	r2, r4	@ tmp165, nihil
	beq	.L12		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:63:     if (ClassSkillTable[opponent->pClassData->number] == nihil) {
	ldr	r2, .L31+24	@ tmp166,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:63:     if (ClassSkillTable[opponent->pClassData->number] == nihil) {
	ldrb	r1, [r1, #4]	@ tmp167,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:63:     if (ClassSkillTable[opponent->pClassData->number] == nihil) {
	ldrb	r2, [r2, r1]	@ tmp168, ClassSkillTable
	cmp	r2, r4	@ tmp168, nihil
	beq	.L12		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:68:     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	movs	r0, #11	@ tmp170,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:68:     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	movs	r1, #192	@ tmp172,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:67:     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldr	r2, .L31+28	@ tmp169,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:68:     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	ldrsb	r0, [r3, r0]	@ tmp170,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:67:     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldrb	r2, [r2, #2]	@ learnedLimit,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:68:     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	tst	r0, r1	@ tmp170, tmp172
	beq	.L14		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:68:     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	cmp	r2, #6	@ learnedLimit,
	ble	.L14		@,
	movs	r2, #6	@ learnedLimit,
.L14:
	adds	r3, r3, #50	@ ivtmp.45,
	adds	r2, r3, r2	@ _40, ivtmp.45, learnedLimit
.L16:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:71:     for (int i = 0; i < learnedLimit; ++i) {
	cmp	r3, r2	@ ivtmp.45, _40
	bne	.L17		@,
.L26:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:41:         return FALSE;
	movs	r0, #0	@ <retval>,
.L12:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:81: }
	@ sp needed	@
	pop	{r4, r5}
	pop	{r1}
	bx	r1
.L17:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:72:         if (!IsSkillIDValid(opponent->supports[i])) {
	ldrb	r0, [r3]	@ _21, MEM[(unsigned char *)_41]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r1, r0, #1	@ tmp174, _21,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:72:         if (!IsSkillIDValid(opponent->supports[i])) {
	lsls	r1, r1, #24	@ tmp177, tmp174,
	lsrs	r1, r1, #24	@ tmp177, tmp177,
	cmp	r1, #253	@ tmp177,
	bhi	.L26		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:75:         if (opponent->supports[i] == nihil) {
	adds	r3, r3, #1	@ ivtmp.45,
	cmp	r0, r4	@ _21, nihil
	bne	.L16		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:61:         return TRUE;
	movs	r0, #1	@ <retval>,
	b	.L12		@
.L32:
	.align	2
.L31:
	.word	gBattleStats
	.word	NegatedSkills
	.word	gBattleTarget
	.word	gBattleActor
	.word	NihilIDLink
	.word	PersonalSkillTable
	.word	ClassSkillTable
	.word	gSkillTestConfig
	.size	NihilTester, .-NihilTester
	.align	1
	.global	MakeSkillBuffer
	.syntax unified
	.code	16
	.thumb_func
	.type	MakeSkillBuffer, %function
MakeSkillBuffer:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	movs	r6, r0	@ unit, tmp280
	movs	r5, r1	@ buffer, tmp281
	sub	sp, sp, #20	@,,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:88:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	cmp	r0, #0	@ unit,
	beq	.L54		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:     buffer->lastUnitChecked = unit->index;
	movs	r2, #11	@ pretmp_50,
	ldrsb	r2, [r6, r2]	@ pretmp_50,* pretmp_50
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:88:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	ldr	r0, [r0]	@ _1, unit_55(D)->pCharacterData
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:     buffer->lastUnitChecked = unit->index;
	lsls	r3, r2, #24	@ _44, pretmp_50,
	lsrs	r3, r3, #24	@ _44, _44,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:88:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	cmp	r0, #0	@ _1,
	beq	.L34		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:88:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	ldr	r1, [r6, #4]	@ _2, unit_55(D)->pClassData
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:88:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	cmp	r1, #0	@ _2,
	bne	.L35		@,
.L34:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:89:         buffer->lastUnitChecked = unit ? unit->index : 0;
	strb	r3, [r5]	@ _44, buffer_58(D)->lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:90:         buffer->skills[0] = 0;
	movs	r3, #0	@ tmp180,
	strb	r3, [r5, #1]	@ tmp180, buffer_58(D)->skills[0]
.L36:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:161: }
	movs	r0, r5	@, buffer
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L54:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:89:         buffer->lastUnitChecked = unit ? unit->index : 0;
	movs	r3, r0	@ _44, unit
	b	.L34		@
.L35:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:94:     unitNum = unit->pCharacterData->number;
	ldrb	r0, [r0, #4]	@ unitNum,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:     buffer->lastUnitChecked = unit->index;
	strb	r3, [r5]	@ _44, buffer_58(D)->lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:98:     temp = PersonalSkillTable[unitNum];
	ldr	r3, .L79	@ tmp183,
	ldrb	r0, [r3, r0]	@ _7, PersonalSkillTable
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r0, #1	@ tmp184, _7,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:99:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp187, tmp184,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:86:     int unitNum = 0, count = 0, temp = 0;
	movs	r4, #0	@ count,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:99:     if (IsSkillIDValid(temp)) {
	lsrs	r3, r3, #24	@ tmp187, tmp187,
	cmp	r3, #253	@ tmp187,
	bhi	.L37		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:100:         buffer->skills[count++] = temp;
	strb	r0, [r5, #1]	@ _7, buffer_58(D)->skills[0]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:100:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L37:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:104:     temp = ClassSkillTable[unit->pClassData->number];
	ldr	r3, .L79+4	@ tmp190,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:104:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r1, [r1, #4]	@ tmp191,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:104:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r1, [r3, r1]	@ _10, ClassSkillTable
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r1, #1	@ tmp192, _10,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:105:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp195, tmp192,
	lsrs	r3, r3, #24	@ tmp195, tmp195,
	cmp	r3, #253	@ tmp195,
	bhi	.L38		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:106:         buffer->skills[count++] = temp;
	adds	r3, r5, r4	@ tmp197, buffer, count
	strb	r1, [r3, #1]	@ _10, buffer_58(D)->skills[count_34]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:106:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L38:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:111:     if ((unit->index & 0xC0) != 0) {
	movs	r1, #192	@ tmp201,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:110:     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldr	r3, .L79+8	@ tmp199,
	str	r3, [sp, #4]	@ tmp199, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:110:     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldrb	r3, [r3, #2]	@ learnedLimit,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:111:     if ((unit->index & 0xC0) != 0) {
	tst	r2, r1	@ pretmp_50, tmp201
	beq	.L39		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:112:         if (learnedLimit > 6) {
	cmp	r3, #6	@ learnedLimit,
	ble	.L39		@,
	movs	r3, #6	@ learnedLimit,
.L39:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:117:         if (!IsSkillIDValid(unit->supports[i])) {
	subs	r2, r6, r4	@ tmp278, unit, count
	adds	r1, r3, r4	@ _108, learnedLimit, count
	adds	r2, r2, #50	@ tmp279,
.L41:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:116:     for (int i = 0; i < learnedLimit; ++i) {
	cmp	r4, r1	@ count, _108
	bne	.L43		@,
.L42:
	movs	r3, r6	@ ivtmp.59, unit
	adds	r3, r3, #30	@ ivtmp.59,
	str	r3, [sp]	@ ivtmp.59, %sfp
	adds	r3, r3, #10	@ _91,
	str	r3, [sp, #12]	@ _91, %sfp
.L48:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:124:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp]	@ ivtmp.59, %sfp
	ldrh	r7, [r3]	@ _24, MEM[(short unsigned int *)_6]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:124:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	cmp	r7, #0	@ _24,
	beq	.L47		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:126:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L79+12	@ tmp211,
	movs	r0, r7	@, _24
	bl	.L81		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:126:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L79+16	@ tmp212,
	ldr	r3, [r3]	@ PassiveSkillBit, PassiveSkillBit
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:126:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	tst	r3, r0	@ PassiveSkillBit, tmp282
	beq	.L46		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:127:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r7, r7, #24	@ _18, _24,
	ldr	r3, .L79+20	@ tmp216,
	lsrs	r7, r7, #24	@ _18, _18,
	movs	r0, r7	@, _18
	str	r3, [sp, #8]	@ tmp216, %sfp
	bl	.L81		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:127:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	adds	r0, r0, #4	@ tmp217,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	ldrb	r3, [r0, #31]	@ tmp219,
	subs	r3, r3, #1	@ tmp220,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:127:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r3, r3, #24	@ tmp223, tmp220,
	lsrs	r3, r3, #24	@ tmp223, tmp223,
	cmp	r3, #253	@ tmp223,
	bhi	.L46		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldr	r3, [sp, #8]	@ tmp216, %sfp
	movs	r0, r7	@, _18
	bl	.L81		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r0, r0, #4	@ tmp227,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldrb	r2, [r0, #31]	@ tmp228,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r3, r4, #1	@ count, count,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r4, r5, r4	@ tmp226, buffer, count
	strb	r2, [r4, #1]	@ tmp228, buffer_58(D)->skills[count_27]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130:                 if (!gSkillTestConfig.passiveSkillStack) {
	ldr	r2, [sp, #4]	@ tmp199, %sfp
	ldrb	r2, [r2, #3]	@ tmp231,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	movs	r4, r3	@ count, count
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130:                 if (!gSkillTestConfig.passiveSkillStack) {
	cmp	r2, #0	@ tmp231,
	beq	.L47		@,
.L46:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:124:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp]	@ ivtmp.59, %sfp
	ldr	r2, [sp, #12]	@ _91, %sfp
	adds	r3, r3, #2	@ ivtmp.59,
	str	r3, [sp]	@ ivtmp.59, %sfp
	cmp	r3, r2	@ ivtmp.59, _91
	bne	.L48		@,
.L47:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r2, #11	@ _25,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp233,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldr	r3, .L79+24	@ tmp232,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r2, [r6, r2]	@ _25,* _25
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp233,
	cmp	r1, r2	@ tmp233, _25
	bne	.L50		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r1, .L79+28	@ tmp234,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrh	r1, [r1]	@ gBattleStats, gBattleStats
	lsls	r1, r1, #30	@ tmp287, gBattleStats,
	beq	.L50		@,
.L78:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:143:         temp = gBattleTarget.weaponBefore;
	adds	r3, r3, #74	@ tmp259,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:143:         temp = gBattleTarget.weaponBefore;
	ldrh	r0, [r3]	@ temp,
.L51:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:         const ItemData* itemData = GetItemData(temp & 0xFF);
	lsls	r0, r0, #24	@ tmp261, temp,
	ldr	r3, .L79+20	@ tmp263,
	lsrs	r0, r0, #24	@ tmp261, tmp261,
	bl	.L81		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:         if (itemData && IsSkillIDValid(itemData->skill)) {
	cmp	r0, #0	@ itemData,
	beq	.L53		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:         if (itemData && IsSkillIDValid(itemData->skill)) {
	adds	r0, r0, #4	@ tmp264,
	ldrb	r2, [r0, #31]	@ _33,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp265, _33,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:         if (itemData && IsSkillIDValid(itemData->skill)) {
	lsls	r3, r3, #24	@ tmp268, tmp265,
	lsrs	r3, r3, #24	@ tmp268, tmp268,
	cmp	r3, #253	@ tmp268,
	bhi	.L53		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:153:             buffer->skills[count++] = itemData->skill;
	adds	r3, r5, r4	@ tmp270, buffer, count
	strb	r2, [r3, #1]	@ _33, buffer_58(D)->skills[count_39]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:153:             buffer->skills[count++] = itemData->skill;
	adds	r4, r4, #1	@ count,
.L53:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:158:     buffer->skills[count++] = 0;
	movs	r3, #0	@ tmp273,
	adds	r4, r5, r4	@ tmp272, buffer, count
	strb	r3, [r4, #1]	@ tmp273, buffer_58(D)->skills[count_40]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:160:     return buffer;
	b	.L36		@
.L43:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:117:         if (!IsSkillIDValid(unit->supports[i])) {
	ldrb	r0, [r2, r4]	@ _14, MEM[(unsigned char *)_114 + _113 * 1]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r0, #1	@ tmp205, _14,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:117:         if (!IsSkillIDValid(unit->supports[i])) {
	lsls	r3, r3, #24	@ tmp208, tmp205,
	lsrs	r3, r3, #24	@ tmp208, tmp208,
	cmp	r3, #253	@ tmp208,
	bhi	.L42		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:120:         buffer->skills[count++] = unit->supports[i];
	adds	r4, r4, #1	@ count,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:120:         buffer->skills[count++] = unit->supports[i];
	strb	r0, [r5, r4]	@ _14, MEM[(unsigned char *)buffer_58(D) + _109 * 1]
	b	.L41		@
.L50:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:142:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp247,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:142:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r3, .L79+32	@ tmp246,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:142:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp247,
	cmp	r1, r2	@ tmp247, _25
	bne	.L52		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L79+28	@ tmp248,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:142:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
	lsls	r2, r2, #30	@ tmp288, gBattleStats,
	bne	.L78		@,
.L52:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:147:         temp = GetUnitEquippedWeapon(unit);
	movs	r0, r6	@, unit
	ldr	r3, .L79+36	@ tmp260,
	bl	.L81		@
	b	.L51		@
.L80:
	.align	2
.L79:
	.word	PersonalSkillTable
	.word	ClassSkillTable
	.word	gSkillTestConfig
	.word	GetItemAttributes
	.word	PassiveSkillBit
	.word	GetItemData
	.word	gBattleActor
	.word	gBattleStats
	.word	gBattleTarget
	.word	GetUnitEquippedWeapon
	.size	MakeSkillBuffer, .-MakeSkillBuffer
	.align	1
	.global	MakeAuraSkillBuffer
	.syntax unified
	.code	16
	.thumb_func
	.type	MakeAuraSkillBuffer, %function
MakeAuraSkillBuffer:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:170:     for (int i = 0; i < 0x100; ++i) {
	movs	r6, #0	@ i,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:167:     int count = 0;
	movs	r4, r6	@ count, i
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:164: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	sub	sp, sp, #28	@,,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:164: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	str	r0, [sp, #4]	@ tmp198, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:165:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r5, .L96	@ buffer,
.L88:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:171:         Unit* other = gUnitLookup[i];
	ldr	r2, .L96+4	@ tmp159,
	lsls	r3, r6, #2	@ tmp157, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _71 * 1]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:173:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:173:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp199,
	beq	.L83		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:173:         if (!IsUnitOnField(other) || unit->index == i) {
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #11]	@ tmp162,
	lsls	r3, r3, #24	@ tmp162, tmp162,
	asrs	r3, r3, #24	@ tmp162, tmp162,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:173:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r3, r6	@ tmp162, i
	beq	.L83		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:178:         buffer = MakeSkillBuffer(other, buffer);
	movs	r1, r5	@, buffer
	movs	r0, r7	@, other
	bl	MakeSkillBuffer		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:182:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L96+8	@ tmp163,
	ldrh	r3, [r3]	@ _8, gSkillTestConfig
	str	r3, [sp, #8]	@ _8, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:182:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L96+12	@ tmp194,
	str	r3, [sp, #16]	@ tmp194, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:183:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r3, .L96+16	@ tmp195,
	str	r3, [sp, #20]	@ tmp195, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:178:         buffer = MakeSkillBuffer(other, buffer);
	movs	r5, r0	@ buffer, tmp200
	adds	r0, r0, #1	@ ivtmp.84,
.L84:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:181:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	ldrb	r3, [r0]	@ _29, MEM[(unsigned char *)_69]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:181:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	cmp	r3, #0	@ _29,
	bne	.L87		@,
.L83:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:170:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp219,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:170:     for (int i = 0; i < 0x100; ++i) {
	adds	r6, r6, #1	@ i,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:170:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp219, tmp219,
	cmp	r6, r3	@ i, tmp219
	bne	.L88		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:202:     buffer->lastUnitChecked = 0;
	movs	r3, #0	@ tmp187,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:203:     gAuraSkillBuffer[count++].skillID = 0;
	ldr	r0, .L96+16	@ tmp189,
	lsls	r4, r4, #1	@ tmp190, count,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:202:     buffer->lastUnitChecked = 0;
	strb	r3, [r5]	@ tmp187, buffer_30->lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:203:     gAuraSkillBuffer[count++].skillID = 0;
	strb	r3, [r4, r0]	@ tmp187, gAuraSkillBuffer[count_34].skillID
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206: }
	add	sp, sp, #28	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L87:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:182:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #16]	@ tmp194, %sfp
	ldrb	r2, [r2, r3]	@ tmp165, AuraSkillTable
	cmp	r2, #0	@ tmp165,
	beq	.L85		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:182:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #8]	@ _8, %sfp
	cmp	r2, r4	@ _8, count
	ble	.L85		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:183:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r2, [sp, #20]	@ tmp195, %sfp
	lsls	r1, r4, #1	@ tmp166, count,
	adds	r1, r1, r2	@ _11, tmp166, tmp195
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:183:                 auraBuffer[count].skillID = buffer->skills[j];
	strb	r3, [r1]	@ _29, _11->skillID
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:185:                 distance = absolute(other->xPos - unit->xPos) +
	movs	r3, #16	@ tmp170,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:185:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #4]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp171,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:185:                 distance = absolute(other->xPos - unit->xPos) +
	ldrsb	r3, [r7, r3]	@ tmp170,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:185:                 distance = absolute(other->xPos - unit->xPos) +
	lsls	r2, r2, #24	@ tmp171, tmp171,
	asrs	r2, r2, #24	@ tmp171, tmp171,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:185:                 distance = absolute(other->xPos - unit->xPos) +
	subs	r2, r3, r2	@ tmp172, tmp170, tmp171
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r3, r2, #31	@ tmp202, tmp172,
	adds	r2, r2, r3	@ tmp173, tmp172, tmp202
	eors	r2, r3	@ tmp173, tmp202
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:186:                            absolute(other->yPos - unit->yPos);
	movs	r3, #17	@ tmp174,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	str	r2, [sp, #12]	@ tmp173, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:186:                            absolute(other->yPos - unit->yPos);
	ldrsb	r3, [r7, r3]	@ tmp174,
	mov	ip, r3	@ tmp174, tmp174
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:186:                            absolute(other->yPos - unit->yPos);
	mov	r2, ip	@ tmp174, tmp174
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:186:                            absolute(other->yPos - unit->yPos);
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #17]	@ tmp175,
	lsls	r3, r3, #24	@ tmp175, tmp175,
	asrs	r3, r3, #24	@ tmp175, tmp175,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:186:                            absolute(other->yPos - unit->yPos);
	subs	r3, r2, r3	@ tmp176, tmp174, tmp175
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r2, r3, #31	@ tmp203, tmp176,
	adds	r3, r3, r2	@ tmp177, tmp176, tmp203
	eors	r3, r2	@ tmp177, tmp203
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:185:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #12]	@ tmp173, %sfp
	adds	r3, r2, r3	@ distance, tmp173, tmp177
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:188:                 if (distance > 63) {
	cmp	r3, #63	@ distance,
	ble	.L86		@,
	movs	r3, #63	@ distance,
.L86:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:195:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	movs	r2, #11	@ tmp178,
	ldrsb	r2, [r7, r2]	@ tmp178,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:195:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	asrs	r2, r2, #6	@ tmp179, tmp178,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:193:                 auraBuffer[count].distance = distance;
	lsls	r2, r2, #6	@ tmp181, tmp179,
	orrs	r3, r2	@ tmp184, tmp181
	strb	r3, [r1, #1]	@ tmp184, MEM <unsigned char> [(struct AuraSkillBuffer *)_11 + 1B]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:196:                 ++count;
	adds	r4, r4, #1	@ count,
.L85:
	adds	r0, r0, #1	@ ivtmp.84,
	b	.L84		@
.L97:
	.align	2
.L96:
	.word	gAttackerSkillBuffer
	.word	gUnitLookup
	.word	gSkillTestConfig
	.word	AuraSkillTable
	.word	gAuraSkillBuffer
	.size	MakeAuraSkillBuffer, .-MakeAuraSkillBuffer
	.align	1
	.global	CheckSkillBuffer
	.syntax unified
	.code	16
	.thumb_func
	.type	CheckSkillBuffer, %function
CheckSkillBuffer:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:210: bool CheckSkillBuffer(Unit* unit, u8 skillID) {
	movs	r3, r0	@ unit, tmp130
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:211:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:211:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L99		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:212:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:212:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	beq	.L99		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:217:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	movs	r0, #11	@ tmp126,
	ldrsb	r0, [r3, r0]	@ tmp126,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:217:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldr	r3, .L107	@ tmp127,
	ldrb	r2, [r3]	@ gDefenderSkillBuffer, gDefenderSkillBuffer
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:217:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	cmp	r0, r2	@ tmp126, gDefenderSkillBuffer
	beq	.L100		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:214:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r3, .L107+4	@ buffer,
.L100:
	adds	r3, r3, #1	@ ivtmp.99,
.L101:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	ldrb	r0, [r3]	@ _10, MEM[(unsigned char *)_17]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	cmp	r0, #0	@ _10,
	bne	.L102		@,
.L99:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:222: }
	@ sp needed	@
	bx	lr
.L102:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:29:         if (buffer->skills[i] == skillID) {
	adds	r3, r3, #1	@ ivtmp.99,
	cmp	r1, r0	@ skillID, _10
	bne	.L101		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:211:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
	b	.L99		@
.L108:
	.align	2
.L107:
	.word	gDefenderSkillBuffer
	.word	gAttackerSkillBuffer
	.size	CheckSkillBuffer, .-CheckSkillBuffer
	.align	1
	.global	SkillTester
	.syntax unified
	.code	16
	.thumb_func
	.type	SkillTester, %function
SkillTester:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:226: bool SkillTester(Unit* unit, u8 skillID) {
	movs	r5, r0	@ unit, tmp162
	movs	r6, r1	@ skillID, tmp163
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:227:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:227:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L134		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:228:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	bne	.L111		@,
.L112:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:228:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
.L134:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:257: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L111:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:229:     if (!unit || !unit->pCharacterData || !unit->pClassData) {return FALSE;}
	cmp	r5, #0	@ unit,
	beq	.L112		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:229:     if (!unit || !unit->pCharacterData || !unit->pClassData) {return FALSE;}
	ldr	r3, [r5]	@ unit_18(D)->pCharacterData, unit_18(D)->pCharacterData
	cmp	r3, #0	@ unit_18(D)->pCharacterData,
	beq	.L112		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:229:     if (!unit || !unit->pCharacterData || !unit->pClassData) {return FALSE;}
	ldr	r3, [r5, #4]	@ unit_18(D)->pClassData, unit_18(D)->pClassData
	cmp	r3, #0	@ unit_18(D)->pClassData,
	beq	.L112		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:231:     int index = unit->index;
	movs	r3, #11	@ index,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r2, .L137	@ tmp139,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrb	r2, [r2, #11]	@ tmp140,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:231:     int index = unit->index;
	ldrsb	r3, [r5, r3]	@ index,* index
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #24	@ tmp140, tmp140,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:234:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r4, .L137+4	@ buffer,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	asrs	r2, r2, #24	@ tmp140, tmp140,
	cmp	r2, r3	@ tmp140, index
	bne	.L113		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L137+8	@ tmp141,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:238:         buffer = &gDefenderSkillBuffer;
	ldr	r4, .L137+12	@ buffer,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #30	@ tmp167, gBattleStats,
	bne	.L113		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:234:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r4, .L137+4	@ buffer,
.L113:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:241:     if (index != buffer->lastUnitChecked) {
	ldrb	r2, [r4]	@ *buffer_13, *buffer_13
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:241:     if (index != buffer->lastUnitChecked) {
	cmp	r2, r3	@ *buffer_13, index
	beq	.L114		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:242:         MakeSkillBuffer(unit, buffer);
	movs	r1, r4	@, buffer
	movs	r0, r5	@, unit
	bl	MakeSkillBuffer		@
.L114:
	adds	r4, r4, #1	@ ivtmp.110,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	movs	r3, r4	@ ivtmp.118, ivtmp.110
.L115:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	ldrb	r2, [r3]	@ _26, MEM[(unsigned char *)_40]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	cmp	r2, #0	@ _26,
	bne	.L117		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:252:     if (IsSkillIDValid(CatchEmAllIDLink) && IsSkillInBuffer(buffer, CatchEmAllIDLink)) {
	ldr	r3, .L137+16	@ tmp156,
	ldrb	r2, [r3]	@ CatchEmAllIDLink.12_10, CatchEmAllIDLink
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp157, CatchEmAllIDLink.12_10,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:252:     if (IsSkillIDValid(CatchEmAllIDLink) && IsSkillInBuffer(buffer, CatchEmAllIDLink)) {
	lsls	r3, r3, #24	@ tmp160, tmp157,
	lsrs	r3, r3, #24	@ tmp160, tmp160,
	cmp	r3, #253	@ tmp160,
	bls	.L120		@,
	b	.L112		@
.L117:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:29:         if (buffer->skills[i] == skillID) {
	adds	r3, r3, #1	@ ivtmp.118,
	cmp	r6, r2	@ skillID, _26
	bne	.L115		@,
.L116:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:248:         return !NihilTester(unit, skillID);
	movs	r1, r6	@, skillID
	movs	r0, r5	@, unit
	bl	NihilTester		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:248:         return !NihilTester(unit, skillID);
	movs	r3, #1	@ tmp153,
	eors	r0, r3	@ tmp152, tmp153
	lsls	r0, r0, #24	@ <retval>, tmp152,
	lsrs	r0, r0, #24	@ <retval>, <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:248:         return !NihilTester(unit, skillID);
	b	.L134		@
.L119:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:29:         if (buffer->skills[i] == skillID) {
	adds	r4, r4, #1	@ ivtmp.110,
	cmp	r2, r3	@ CatchEmAllIDLink.12_10, _23
	beq	.L116		@,
.L120:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	ldrb	r3, [r4]	@ _23, MEM[(unsigned char *)_5]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	cmp	r3, #0	@ _23,
	bne	.L119		@,
	b	.L112		@
.L138:
	.align	2
.L137:
	.word	gBattleTarget
	.word	gAttackerSkillBuffer
	.word	gBattleStats
	.word	gDefenderSkillBuffer
	.word	CatchEmAllIDLink
	.size	SkillTester, .-SkillTester
	.align	1
	.global	NewAuraSkillCheck
	.syntax unified
	.code	16
	.thumb_func
	.type	NewAuraSkillCheck, %function
NewAuraSkillCheck:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	sub	sp, sp, #20	@,,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:260: bool NewAuraSkillCheck(Unit* unit, u8 skillID, int allyOption, int maxRange) {
	str	r3, [sp, #12]	@ tmp169, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:261:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L158	@ iftmp.14_22,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:260: bool NewAuraSkillCheck(Unit* unit, u8 skillID, int allyOption, int maxRange) {
	movs	r4, r1	@ skillID, tmp167
	movs	r5, r2	@ allyOption, tmp168
	str	r0, [sp, #8]	@ tmp166, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:261:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	str	r3, [sp]	@ iftmp.14_22, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:261:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	lsls	r3, r2, #31	@ tmp172, allyOption,
	bpl	.L140		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:261:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L158+4	@ iftmp.14_22,
	str	r3, [sp]	@ iftmp.14_22, %sfp
.L140:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:263:     if (skillID == 0)   {return TRUE;}
	cmp	r4, #0	@ skillID,
	bne	.L141		@,
.L148:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:263:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
.L142:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:283: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L141:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:264:     if (skillID == 255) {return FALSE;}
	cmp	r4, #255	@ skillID,
	bne	.L143		@,
.L150:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:264:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
	b	.L142		@
.L143:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	movs	r7, #0	@ i,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:267:     int limit = gSkillTestConfig.auraSkillBufferLimit;
	ldr	r3, .L158+8	@ tmp140,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:267:     int limit = gSkillTestConfig.auraSkillBufferLimit;
	ldrh	r3, [r3]	@ limit, gSkillTestConfig
	ldr	r6, .L158+12	@ ivtmp.127,
	str	r3, [sp, #4]	@ limit, %sfp
.L144:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	ldr	r3, [sp, #4]	@ limit, %sfp
	cmp	r7, r3	@ i, limit
	bge	.L150		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	ldrb	r2, [r6]	@ _19, MEM[(unsigned char *)_18]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	cmp	r2, #0	@ _19,
	beq	.L150		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:269:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldrb	r1, [r6, #1]	@ *_18, *_18
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:269:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldr	r0, [sp, #12]	@ maxRange, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:269:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	lsls	r3, r1, #26	@ tmp145, *_18,
	lsrs	r3, r3, #26	@ tmp146, tmp145,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:269:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r3, r0	@ tmp146, maxRange
	ble	.L145		@,
.L146:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	adds	r7, r7, #1	@ i,
	adds	r6, r6, #2	@ ivtmp.127,
	b	.L144		@
.L145:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:269:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r2, r4	@ _19, skillID
	bne	.L146		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:272:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	movs	r0, #11	@ tmp156,
	ldr	r3, [sp, #8]	@ unit, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:272:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	lsrs	r1, r1, #6	@ tmp153, *_18,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:272:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	ldrsb	r0, [r3, r0]	@ tmp156,
	lsls	r1, r1, #6	@ tmp155, tmp153,
	ldr	r3, [sp]	@ iftmp.14_22, %sfp
	bl	.L81		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:274:             if (allyOption & 2)
	movs	r3, #2	@ tmp180,
	tst	r5, r3	@ allyOption, tmp180
	beq	.L147		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:277:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp157,
	beq	.L148		@,
.L149:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:277:             if (check || (allyOption & 4))
	movs	r3, #4	@ tmp181,
	tst	r5, r3	@ allyOption, tmp181
	beq	.L146		@,
	b	.L148		@
.L147:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:277:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp157,
	beq	.L149		@,
	b	.L148		@
.L159:
	.align	2
.L158:
	.word	AreAllegiancesEqual
	.word	AreAllegiancesAllied
	.word	gSkillTestConfig
	.word	gAuraSkillBuffer
	.size	NewAuraSkillCheck, .-NewAuraSkillCheck
	.align	1
	.global	InitializePreBattleLoop
	.syntax unified
	.code	16
	.thumb_func
	.type	InitializePreBattleLoop, %function
InitializePreBattleLoop:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:286: void InitializePreBattleLoop(Unit* attacker, Unit* defender) {
	movs	r4, r0	@ attacker, tmp132
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:287:     MakeAuraSkillBuffer(attacker);
	bl	MakeAuraSkillBuffer		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:288:     MakeSkillBuffer(attacker, &gAttackerSkillBuffer);
	ldr	r1, .L166	@ tmp118,
	movs	r0, r4	@, attacker
	bl	MakeSkillBuffer		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:289:     gDefenderSkillBuffer.lastUnitChecked = 0;
	movs	r3, #0	@ tmp120,
	ldr	r1, .L166+4	@ tmp119,
	strb	r3, [r1]	@ tmp120, gDefenderSkillBuffer.lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r3, .L166+8	@ tmp122,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:291:     if (IsBattleReal()) {
	ldrh	r3, [r3]	@ gBattleStats, gBattleStats
	lsls	r3, r3, #30	@ tmp133, gBattleStats,
	beq	.L160		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:292:         MakeSkillBuffer(&gBattleTarget.unit, &gDefenderSkillBuffer);
	ldr	r0, .L166+12	@ tmp131,
	bl	MakeSkillBuffer		@
.L160:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
.L167:
	.align	2
.L166:
	.word	gAttackerSkillBuffer
	.word	gDefenderSkillBuffer
	.word	gBattleStats
	.word	gBattleTarget
	.size	InitializePreBattleLoop, .-InitializePreBattleLoop
	.align	1
	.global	InitSkillBuffers
	.syntax unified
	.code	16
	.thumb_func
	.type	InitSkillBuffers, %function
InitSkillBuffers:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:298:     gAttackerSkillBuffer.lastUnitChecked = 0;
	movs	r2, #0	@ tmp115,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:300: }
	@ sp needed	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:298:     gAttackerSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L169	@ tmp114,
	strb	r2, [r3]	@ tmp115, gAttackerSkillBuffer.lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:299:     gDefenderSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L169+4	@ tmp117,
	strb	r2, [r3]	@ tmp115, gDefenderSkillBuffer.lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:300: }
	bx	lr
.L170:
	.align	2
.L169:
	.word	gAttackerSkillBuffer
	.word	gDefenderSkillBuffer
	.size	InitSkillBuffers, .-InitSkillBuffers
	.align	1
	.global	GetUnitsInRange
	.syntax unified
	.code	16
	.thumb_func
	.type	GetUnitsInRange, %function
GetUnitsInRange:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:304:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L192	@ iftmp.19_32,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:303: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	sub	sp, sp, #20	@,,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:303: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	movs	r5, r1	@ allyOption, tmp191
	str	r0, [sp, #8]	@ tmp190, %sfp
	str	r2, [sp, #12]	@ tmp192, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:304:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	str	r3, [sp, #4]	@ iftmp.19_32, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:304:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	lsls	r3, r1, #31	@ tmp198, allyOption,
	bpl	.L172		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:304:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L192+4	@ iftmp.19_32,
	str	r3, [sp, #4]	@ iftmp.19_32, %sfp
.L172:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:309:     for (int i = 0; i < 0x100; ++i) {
	movs	r4, #0	@ i,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:306:     int count = 0;
	movs	r6, r4	@ count, i
.L179:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:310:         Unit* other = gUnitLookup[i];
	ldr	r2, .L192+8	@ tmp154,
	lsls	r3, r4, #2	@ tmp152, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _34 * 1]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:312:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:312:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp193,
	beq	.L176		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:312:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, #11	@ _4,
	ldr	r3, [sp, #8]	@ unit, %sfp
	ldrsb	r0, [r3, r0]	@ _4,* _4
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:312:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, r4	@ _4, i
	beq	.L176		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:318:             check = !pAllegianceChecker(unit->index, other->index);
	movs	r1, #11	@ _31,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:317:         if (allyOption & 2) {
	movs	r3, #2	@ tmp207,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:318:             check = !pAllegianceChecker(unit->index, other->index);
	ldrsb	r1, [r7, r1]	@ _31,* _31
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:317:         if (allyOption & 2) {
	tst	r5, r3	@ allyOption, tmp207
	beq	.L174		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:318:             check = !pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.19_32, %sfp
	bl	.L81		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:324:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp194,
	beq	.L175		@,
.L178:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:324:         if (check || (allyOption & 4)) {
	movs	r3, #4	@ tmp209,
	tst	r5, r3	@ allyOption, tmp209
	beq	.L176		@,
.L175:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:325:             if ((absolute(other->xPos - unit->xPos)
	movs	r3, #16	@ tmp163,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:325:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #8]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp164,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:325:             if ((absolute(other->xPos - unit->xPos)
	ldrsb	r3, [r7, r3]	@ tmp163,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:325:             if ((absolute(other->xPos - unit->xPos)
	lsls	r2, r2, #24	@ tmp164, tmp164,
	asrs	r2, r2, #24	@ tmp164, tmp164,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:325:             if ((absolute(other->xPos - unit->xPos)
	subs	r2, r3, r2	@ tmp165, tmp163, tmp164
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:326:                + absolute(other->yPos - unit->yPos)) <= range) {
	movs	r3, #17	@ tmp167,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r2, #31	@ tmp199, tmp165,
	adds	r2, r2, r1	@ tmp166, tmp165, tmp199
	eors	r2, r1	@ tmp166, tmp199
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:326:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldr	r1, [sp, #8]	@ unit, %sfp
	ldrb	r1, [r1, #17]	@ tmp168,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:326:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldrsb	r3, [r7, r3]	@ tmp167,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:326:                + absolute(other->yPos - unit->yPos)) <= range) {
	lsls	r1, r1, #24	@ tmp168, tmp168,
	asrs	r1, r1, #24	@ tmp168, tmp168,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:326:                + absolute(other->yPos - unit->yPos)) <= range) {
	subs	r3, r3, r1	@ tmp169, tmp167, tmp168
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r3, #31	@ tmp200, tmp169,
	adds	r3, r3, r1	@ tmp170, tmp169, tmp200
	eors	r3, r1	@ tmp170, tmp200
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:326:                + absolute(other->yPos - unit->yPos)) <= range) {
	adds	r3, r2, r3	@ tmp171, tmp166, tmp170
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:325:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #12]	@ range, %sfp
	cmp	r3, r2	@ tmp171, range
	ble	.L177		@,
.L176:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:309:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp176,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:309:     for (int i = 0; i < 0x100; ++i) {
	adds	r4, r4, #1	@ i,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:309:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp176, tmp176,
	cmp	r4, r3	@ i, tmp176
	bne	.L179		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:333:     gUnitRangeBuffer[count++] = 0;
	movs	r2, #0	@ tmp178,
	ldr	r3, .L192+12	@ tmp177,
	strb	r2, [r3, r6]	@ tmp178, gUnitRangeBuffer[count_28]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:334:     if (!gUnitRangeBuffer[0])
	ldrb	r0, [r3]	@ gUnitRangeBuffer, gUnitRangeBuffer
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:337:     return gUnitRangeBuffer;
	subs	r2, r0, #1	@ tmp186, gUnitRangeBuffer
	sbcs	r0, r0, r2	@ tmp185, gUnitRangeBuffer, tmp186
	rsbs	r0, r0, #0	@ tmp187, tmp185
	ands	r0, r3	@ <retval>, tmp177
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:338: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L174:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:321:             check =  pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.19_32, %sfp
	bl	.L81		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:324:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp195,
	bne	.L175		@,
	b	.L178		@
.L177:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:327:                 gUnitRangeBuffer[count++] = i;
	ldr	r3, .L192+12	@ tmp174,
	strb	r4, [r3, r6]	@ i, gUnitRangeBuffer[count_54]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:327:                 gUnitRangeBuffer[count++] = i;
	adds	r6, r6, #1	@ count,
	b	.L176		@
.L193:
	.align	2
.L192:
	.word	AreAllegiancesEqual
	.word	AreAllegiancesAllied
	.word	gUnitLookup
	.word	gUnitRangeBuffer
	.size	GetUnitsInRange, .-GetUnitsInRange
	.ident	"GCC: (devkitARM release 63) 13.2.0"
	.code 16
	.align	1
.L81:
	bx	r3
