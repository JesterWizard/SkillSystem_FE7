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
@ _src/SkillTester.c:11: static bool IsUnitOnField(Unit* unit) {
	subs	r3, r0, #0	@ unit, tmp133,
@ _src/SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	beq	.L2		@,
@ _src/SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	ldr	r2, [r0]	@ unit_6(D)->pCharacterData, unit_6(D)->pCharacterData
@ _src/SkillTester.c:13:         return FALSE;
	subs	r0, r2, #0	@ <retval>, unit_6(D)->pCharacterData,
@ _src/SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	beq	.L2		@,
@ _src/SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	ldr	r3, [r3, #12]	@ _2, unit_6(D)->state
@ _src/SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	ldr	r2, .L9	@ tmp123,
@ _src/SkillTester.c:13:         return FALSE;
	movs	r0, #0	@ <retval>,
@ _src/SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	tst	r3, r2	@ _2, tmp123
	bne	.L2		@,
@ _src/SkillTester.c:22:     return TRUE;
	adds	r0, r0, #1	@ <retval>,
@ _src/SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	lsls	r3, r3, #24	@ tmp134, _2,
	bpl	.L2		@,
@ _src/SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	ldr	r3, .L9+4	@ tmp126,
@ _src/SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	ldrb	r0, [r3, #4]	@ tmp128,
	subs	r3, r0, #1	@ tmp130, tmp128
	sbcs	r0, r0, r3	@ <retval>, tmp128, tmp130
.L2:
@ _src/SkillTester.c:23: }
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
@ _src/SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L31	@ tmp148,
@ _src/SkillTester.c:39: bool NihilTester(Unit* unit, u8 skillID) {
	push	{r4, r5, lr}	@
@ _src/SkillTester.c:40:     if (!IsBattleReal() || !NegatedSkills[skillID]) {
	ldrh	r4, [r2]	@ gBattleStats, gBattleStats
@ _src/SkillTester.c:39: bool NihilTester(Unit* unit, u8 skillID) {
	movs	r3, r0	@ unit, tmp181
@ _src/SkillTester.c:40:     if (!IsBattleReal() || !NegatedSkills[skillID]) {
	movs	r2, #3	@ tmp152,
	movs	r0, r4	@ tmp154, gBattleStats
	ands	r0, r2	@ tmp154, tmp152
	tst	r4, r2	@ gBattleStats, tmp152
	beq	.L12		@,
@ _src/SkillTester.c:40:     if (!IsBattleReal() || !NegatedSkills[skillID]) {
	ldr	r2, .L31+4	@ tmp156,
@ _src/SkillTester.c:40:     if (!IsBattleReal() || !NegatedSkills[skillID]) {
	ldrb	r2, [r2, r1]	@ tmp157, NegatedSkills
@ _src/SkillTester.c:41:         return FALSE;
	subs	r0, r2, #0	@ <retval>, tmp157,
@ _src/SkillTester.c:40:     if (!IsBattleReal() || !NegatedSkills[skillID]) {
	beq	.L12		@,
@ _src/SkillTester.c:45:     if (unit->index == gBattleTarget.unit.index) {
	movs	r1, #11	@ _5,
@ _src/SkillTester.c:45:     if (unit->index == gBattleTarget.unit.index) {
	movs	r0, #11	@ tmp159,
@ _src/SkillTester.c:45:     if (unit->index == gBattleTarget.unit.index) {
	ldr	r2, .L31+8	@ tmp158,
@ _src/SkillTester.c:45:     if (unit->index == gBattleTarget.unit.index) {
	ldrsb	r1, [r3, r1]	@ _5,* _5
@ _src/SkillTester.c:45:     if (unit->index == gBattleTarget.unit.index) {
	ldrsb	r0, [r2, r0]	@ tmp159,
	ldr	r3, .L31+12	@ opponent,
	cmp	r0, r1	@ tmp159, _5
	beq	.L13		@,
@ _src/SkillTester.c:48:     else if (unit->index == gBattleActor.unit.index) {
	ldrb	r3, [r3, #11]	@ tmp161,
	lsls	r3, r3, #24	@ tmp161, tmp161,
@ _src/SkillTester.c:41:         return FALSE;
	movs	r0, #0	@ <retval>,
@ _src/SkillTester.c:48:     else if (unit->index == gBattleActor.unit.index) {
	asrs	r3, r3, #24	@ tmp161, tmp161,
	cmp	r3, r1	@ tmp161, _5
	bne	.L12		@,
@ _src/SkillTester.c:49:         opponent = &gBattleTarget.unit;
	movs	r3, r2	@ opponent, tmp158
.L13:
@ _src/SkillTester.c:55:     if (!opponent->pCharacterData || !opponent->pClassData) {
	ldr	r5, [r3]	@ _9, opponent_22->pCharacterData
@ _src/SkillTester.c:41:         return FALSE;
	subs	r0, r5, #0	@ <retval>, _9,
@ _src/SkillTester.c:55:     if (!opponent->pCharacterData || !opponent->pClassData) {
	beq	.L12		@,
@ _src/SkillTester.c:55:     if (!opponent->pCharacterData || !opponent->pClassData) {
	ldr	r1, [r3, #4]	@ _10, opponent_22->pClassData
@ _src/SkillTester.c:41:         return FALSE;
	subs	r0, r1, #0	@ <retval>, _10,
@ _src/SkillTester.c:55:     if (!opponent->pCharacterData || !opponent->pClassData) {
	beq	.L12		@,
@ _src/SkillTester.c:59:     u8 nihil = NihilIDLink;
	ldr	r2, .L31+16	@ tmp162,
@ _src/SkillTester.c:60:     if (PersonalSkillTable[opponent->pCharacterData->number] == nihil) {
	ldrb	r0, [r5, #4]	@ tmp164,
@ _src/SkillTester.c:59:     u8 nihil = NihilIDLink;
	ldrb	r4, [r2]	@ nihil, NihilIDLink
@ _src/SkillTester.c:60:     if (PersonalSkillTable[opponent->pCharacterData->number] == nihil) {
	ldr	r2, .L31+20	@ tmp163,
@ _src/SkillTester.c:60:     if (PersonalSkillTable[opponent->pCharacterData->number] == nihil) {
	ldrb	r2, [r2, r0]	@ tmp165, PersonalSkillTable
@ _src/SkillTester.c:61:         return TRUE;
	movs	r0, #1	@ <retval>,
@ _src/SkillTester.c:60:     if (PersonalSkillTable[opponent->pCharacterData->number] == nihil) {
	cmp	r2, r4	@ tmp165, nihil
	beq	.L12		@,
@ _src/SkillTester.c:63:     if (ClassSkillTable[opponent->pClassData->number] == nihil) {
	ldr	r2, .L31+24	@ tmp166,
@ _src/SkillTester.c:63:     if (ClassSkillTable[opponent->pClassData->number] == nihil) {
	ldrb	r1, [r1, #4]	@ tmp167,
@ _src/SkillTester.c:63:     if (ClassSkillTable[opponent->pClassData->number] == nihil) {
	ldrb	r2, [r2, r1]	@ tmp168, ClassSkillTable
	cmp	r2, r4	@ tmp168, nihil
	beq	.L12		@,
@ _src/SkillTester.c:68:     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	movs	r0, #11	@ tmp170,
@ _src/SkillTester.c:68:     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	movs	r1, #192	@ tmp172,
@ _src/SkillTester.c:67:     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldr	r2, .L31+28	@ tmp169,
@ _src/SkillTester.c:68:     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	ldrsb	r0, [r3, r0]	@ tmp170,
@ _src/SkillTester.c:67:     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldrb	r2, [r2, #2]	@ learnedLimit,
@ _src/SkillTester.c:68:     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	tst	r0, r1	@ tmp170, tmp172
	beq	.L14		@,
@ _src/SkillTester.c:68:     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	cmp	r2, #6	@ learnedLimit,
	ble	.L14		@,
	movs	r2, #6	@ learnedLimit,
.L14:
	adds	r3, r3, #50	@ ivtmp.46,
	adds	r2, r3, r2	@ _40, ivtmp.46, learnedLimit
.L16:
@ _src/SkillTester.c:71:     for (int i = 0; i < learnedLimit; ++i) {
	cmp	r3, r2	@ ivtmp.46, _40
	bne	.L17		@,
.L26:
@ _src/SkillTester.c:41:         return FALSE;
	movs	r0, #0	@ <retval>,
.L12:
@ _src/SkillTester.c:81: }
	@ sp needed	@
	pop	{r4, r5}
	pop	{r1}
	bx	r1
.L17:
@ _src/SkillTester.c:72:         if (!IsSkillIDValid(opponent->supports[i])) {
	ldrb	r0, [r3]	@ _21, MEM[(unsigned char *)_41]
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r1, r0, #1	@ tmp174, _21,
@ _src/SkillTester.c:72:         if (!IsSkillIDValid(opponent->supports[i])) {
	lsls	r1, r1, #24	@ tmp177, tmp174,
	lsrs	r1, r1, #24	@ tmp177, tmp177,
	cmp	r1, #253	@ tmp177,
	bhi	.L26		@,
@ _src/SkillTester.c:75:         if (opponent->supports[i] == nihil) {
	adds	r3, r3, #1	@ ivtmp.46,
	cmp	r0, r4	@ _21, nihil
	bne	.L16		@,
@ _src/SkillTester.c:61:         return TRUE;
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
	movs	r7, r0	@ unit, tmp379
	movs	r5, r1	@ buffer, tmp380
	sub	sp, sp, #20	@,,
@ _src/SkillTester.c:88:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	cmp	r0, #0	@ unit,
	beq	.L66		@,
@ _src/SkillTester.c:95:     buffer->lastUnitChecked = unit->index;
	movs	r2, #11	@ pretmp_62,
	ldrsb	r2, [r7, r2]	@ pretmp_62,* pretmp_62
@ _src/SkillTester.c:88:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	ldr	r0, [r0]	@ _1, unit_81(D)->pCharacterData
@ _src/SkillTester.c:95:     buffer->lastUnitChecked = unit->index;
	lsls	r3, r2, #24	@ _55, pretmp_62,
	lsrs	r3, r3, #24	@ _55, _55,
@ _src/SkillTester.c:88:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	cmp	r0, #0	@ _1,
	beq	.L34		@,
@ _src/SkillTester.c:88:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	ldr	r1, [r7, #4]	@ _2, unit_81(D)->pClassData
@ _src/SkillTester.c:88:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	cmp	r1, #0	@ _2,
	bne	.L35		@,
.L34:
@ _src/SkillTester.c:89:         buffer->lastUnitChecked = unit ? unit->index : 0;
	strb	r3, [r5]	@ _55, buffer_84(D)->lastUnitChecked
@ _src/SkillTester.c:90:         buffer->skills[0] = 0;
	movs	r3, #0	@ tmp218,
	strb	r3, [r5, #1]	@ tmp218, buffer_84(D)->skills[0]
.L105:
@ _src/SkillTester.c:217: }
	movs	r0, r5	@, buffer
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L66:
@ _src/SkillTester.c:89:         buffer->lastUnitChecked = unit ? unit->index : 0;
	movs	r3, r0	@ _55, unit
	b	.L34		@
.L35:
@ _src/SkillTester.c:94:     unitNum = unit->pCharacterData->number;
	ldrb	r0, [r0, #4]	@ unitNum,
@ _src/SkillTester.c:95:     buffer->lastUnitChecked = unit->index;
	strb	r3, [r5]	@ _55, buffer_84(D)->lastUnitChecked
@ _src/SkillTester.c:98:     temp = PersonalSkillTable[unitNum];
	ldr	r3, .L112	@ tmp221,
	ldrb	r0, [r3, r0]	@ _7, PersonalSkillTable
	str	r3, [sp, #4]	@ tmp221, %sfp
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r0, #1	@ tmp222, _7,
@ _src/SkillTester.c:99:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp225, tmp222,
@ _src/SkillTester.c:86:     int unitNum = 0, count = 0, temp = 0;
	movs	r4, #0	@ count,
@ _src/SkillTester.c:99:     if (IsSkillIDValid(temp)) {
	lsrs	r3, r3, #24	@ tmp225, tmp225,
	cmp	r3, #253	@ tmp225,
	bhi	.L37		@,
@ _src/SkillTester.c:100:         buffer->skills[count++] = temp;
	strb	r0, [r5, #1]	@ _7, buffer_84(D)->skills[0]
@ _src/SkillTester.c:100:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L37:
@ _src/SkillTester.c:104:     temp = ClassSkillTable[unit->pClassData->number];
	ldr	r3, .L112+4	@ tmp228,
@ _src/SkillTester.c:104:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r1, [r1, #4]	@ tmp229,
@ _src/SkillTester.c:104:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r1, [r3, r1]	@ _10, ClassSkillTable
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r1, #1	@ tmp230, _10,
@ _src/SkillTester.c:105:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp233, tmp230,
	lsrs	r3, r3, #24	@ tmp233, tmp233,
	cmp	r3, #253	@ tmp233,
	bhi	.L38		@,
@ _src/SkillTester.c:106:         buffer->skills[count++] = temp;
	adds	r3, r5, r4	@ tmp235, buffer, count
	strb	r1, [r3, #1]	@ _10, buffer_84(D)->skills[count_51]
@ _src/SkillTester.c:106:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L38:
@ _src/SkillTester.c:111:     if ((unit->index & 0xC0) != 0) {
	movs	r1, #192	@ tmp239,
@ _src/SkillTester.c:110:     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldr	r3, .L112+8	@ tmp237,
@ _src/SkillTester.c:110:     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldrb	r3, [r3, #2]	@ learnedLimit,
@ _src/SkillTester.c:111:     if ((unit->index & 0xC0) != 0) {
	tst	r2, r1	@ pretmp_62, tmp239
	beq	.L39		@,
@ _src/SkillTester.c:112:         if (learnedLimit > 6) {
	cmp	r3, #6	@ learnedLimit,
	ble	.L39		@,
	movs	r3, #6	@ learnedLimit,
.L39:
@ _src/SkillTester.c:117:         if (!IsSkillIDValid(unit->supports[i])) {
	subs	r2, r7, r4	@ tmp377, unit, count
	adds	r1, r3, r4	@ _165, learnedLimit, count
	adds	r2, r2, #50	@ tmp378,
.L41:
@ _src/SkillTester.c:116:     for (int i = 0; i < learnedLimit; ++i) {
	cmp	r4, r1	@ count, _165
	bne	.L43		@,
.L42:
	movs	r3, r7	@ ivtmp.76, unit
	adds	r3, r3, #30	@ ivtmp.76,
	str	r3, [sp]	@ ivtmp.76, %sfp
	adds	r3, r3, #10	@ _161,
	str	r3, [sp, #12]	@ _161, %sfp
.L48:
@ _src/SkillTester.c:124:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp]	@ ivtmp.76, %sfp
	ldrh	r6, [r3]	@ _24, MEM[(short unsigned int *)_159]
@ _src/SkillTester.c:124:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	cmp	r6, #0	@ _24,
	beq	.L47		@,
@ _src/SkillTester.c:126:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L112+12	@ tmp249,
	movs	r0, r6	@, _24
	bl	.L114		@
@ _src/SkillTester.c:126:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L112+16	@ tmp250,
	ldr	r3, [r3]	@ PassiveSkillBit, PassiveSkillBit
@ _src/SkillTester.c:126:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	tst	r3, r0	@ PassiveSkillBit, tmp381
	beq	.L46		@,
@ _src/SkillTester.c:127:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r6, r6, #24	@ _18, _24,
	ldr	r3, .L112+20	@ tmp254,
	lsrs	r6, r6, #24	@ _18, _18,
	movs	r0, r6	@, _18
	str	r3, [sp, #8]	@ tmp254, %sfp
	bl	.L114		@
@ _src/SkillTester.c:127:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	adds	r0, r0, #4	@ tmp255,
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	ldrb	r3, [r0, #31]	@ tmp257,
	subs	r3, r3, #1	@ tmp258,
@ _src/SkillTester.c:127:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r3, r3, #24	@ tmp261, tmp258,
	lsrs	r3, r3, #24	@ tmp261, tmp261,
	cmp	r3, #253	@ tmp261,
	bhi	.L46		@,
@ _src/SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldr	r3, [sp, #8]	@ tmp254, %sfp
	movs	r0, r6	@, _18
	bl	.L114		@
@ _src/SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r0, r0, #4	@ tmp265,
@ _src/SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldrb	r2, [r0, #31]	@ tmp266,
@ _src/SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r3, r4, #1	@ count, count,
@ _src/SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r4, r5, r4	@ tmp264, buffer, count
	strb	r2, [r4, #1]	@ tmp266, buffer_84(D)->skills[count_142]
@ _src/SkillTester.c:130:                 if (!gSkillTestConfig.passiveSkillStack) {
	ldr	r2, .L112+8	@ tmp268,
@ _src/SkillTester.c:130:                 if (!gSkillTestConfig.passiveSkillStack) {
	ldrb	r2, [r2, #3]	@ tmp269,
@ _src/SkillTester.c:128:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	movs	r4, r3	@ count, count
@ _src/SkillTester.c:130:                 if (!gSkillTestConfig.passiveSkillStack) {
	cmp	r2, #0	@ tmp269,
	beq	.L47		@,
.L46:
@ _src/SkillTester.c:124:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp]	@ ivtmp.76, %sfp
	ldr	r2, [sp, #12]	@ _161, %sfp
	adds	r3, r3, #2	@ ivtmp.76,
	str	r3, [sp]	@ ivtmp.76, %sfp
	cmp	r3, r2	@ ivtmp.76, _161
	bne	.L48		@,
.L47:
@ _src/SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r2, #11	@ _25,
@ _src/SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r3, #11	@ tmp271,
@ _src/SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldr	r6, .L112+24	@ tmp270,
@ _src/SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r2, [r7, r2]	@ _25,* _25
@ _src/SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r3, [r6, r3]	@ tmp271,
	ldr	r1, .L112+28	@ tmp370,
	str	r1, [sp]	@ tmp370, %sfp
	cmp	r3, r2	@ tmp271, _25
	bne	.L50		@,
@ _src/SkillTester.c:139:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrh	r3, [r1]	@ gBattleStats, gBattleStats
	lsls	r3, r3, #30	@ tmp391, gBattleStats,
	beq	.L50		@,
@ _src/SkillTester.c:140:         temp = gBattleActor.weaponBefore;
	movs	r3, r6	@ tmp283, tmp270
.L111:
@ _src/SkillTester.c:143:         temp = gBattleTarget.weaponBefore;
	adds	r3, r3, #74	@ tmp297,
@ _src/SkillTester.c:143:         temp = gBattleTarget.weaponBefore;
	ldrh	r0, [r3]	@ temp,
.L51:
@ _src/SkillTester.c:151:         const ItemData* itemData = GetItemData(temp & 0xFF);
	lsls	r0, r0, #24	@ tmp299, temp,
	ldr	r3, .L112+20	@ tmp301,
	lsrs	r0, r0, #24	@ tmp299, tmp299,
	bl	.L114		@
@ _src/SkillTester.c:152:         if (itemData && IsSkillIDValid(itemData->skill)) {
	cmp	r0, #0	@ itemData,
	beq	.L53		@,
@ _src/SkillTester.c:152:         if (itemData && IsSkillIDValid(itemData->skill)) {
	adds	r0, r0, #4	@ tmp302,
	ldrb	r2, [r0, #31]	@ _33,
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp303, _33,
@ _src/SkillTester.c:152:         if (itemData && IsSkillIDValid(itemData->skill)) {
	lsls	r3, r3, #24	@ tmp306, tmp303,
	lsrs	r3, r3, #24	@ tmp306, tmp306,
	cmp	r3, #253	@ tmp306,
	bhi	.L53		@,
@ _src/SkillTester.c:153:             buffer->skills[count++] = itemData->skill;
	adds	r3, r5, r4	@ tmp308, buffer, count
	strb	r2, [r3, #1]	@ _33, buffer_84(D)->skills[count_56]
@ _src/SkillTester.c:153:             buffer->skills[count++] = itemData->skill;
	adds	r4, r4, #1	@ count,
.L53:
@ _src/SkillTester.c:161:     if (IsBattleReal()) {
	ldr	r3, [sp]	@ tmp370, %sfp
	ldrh	r3, [r3]	@ gBattleStats, gBattleStats
	lsls	r3, r3, #30	@ tmp393, gBattleStats,
	beq	.L54		@,
@ _src/SkillTester.c:162:         u8 traceId = TraceIDLink;
	ldr	r3, .L112+32	@ tmp318,
	adds	r1, r5, #1	@ ivtmp.59, buffer,
	ldrb	r0, [r3]	@ traceId, TraceIDLink
@ _src/SkillTester.c:164:         for (int i = 0; i < count; ++i) {
	movs	r3, r1	@ ivtmp.67, ivtmp.59
.L55:
@ _src/SkillTester.c:164:         for (int i = 0; i < count; ++i) {
	subs	r2, r3, r5	@ tmp321, ivtmp.67, buffer
	subs	r2, r2, #1	@ i,
	cmp	r4, r2	@ count, i
	bgt	.L57		@,
.L54:
@ _src/SkillTester.c:214:     buffer->skills[count++] = 0;
	movs	r3, #0	@ tmp361,
	adds	r4, r5, r4	@ tmp360, buffer, count
	strb	r3, [r4, #1]	@ tmp361, buffer_84(D)->skills[count_58]
@ _src/SkillTester.c:216:     return buffer;
	b	.L105		@
.L43:
@ _src/SkillTester.c:117:         if (!IsSkillIDValid(unit->supports[i])) {
	ldrb	r0, [r2, r4]	@ _14, MEM[(unsigned char *)_171 + _170 * 1]
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r0, #1	@ tmp243, _14,
@ _src/SkillTester.c:117:         if (!IsSkillIDValid(unit->supports[i])) {
	lsls	r3, r3, #24	@ tmp246, tmp243,
	lsrs	r3, r3, #24	@ tmp246, tmp246,
	cmp	r3, #253	@ tmp246,
	bhi	.L42		@,
@ _src/SkillTester.c:120:         buffer->skills[count++] = unit->supports[i];
	adds	r4, r4, #1	@ count,
@ _src/SkillTester.c:120:         buffer->skills[count++] = unit->supports[i];
	strb	r0, [r5, r4]	@ _14, MEM[(unsigned char *)buffer_84(D) + _166 * 1]
	b	.L41		@
.L50:
@ _src/SkillTester.c:142:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp285,
@ _src/SkillTester.c:142:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r3, .L112+36	@ tmp284,
@ _src/SkillTester.c:142:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp285,
	cmp	r1, r2	@ tmp285, _25
	bne	.L52		@,
@ _src/SkillTester.c:142:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r2, [sp]	@ tmp370, %sfp
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
	lsls	r2, r2, #30	@ tmp392, gBattleStats,
	bne	.L111		@,
.L52:
@ _src/SkillTester.c:147:         temp = GetUnitEquippedWeapon(unit);
	movs	r0, r7	@, unit
	ldr	r3, .L112+40	@ tmp298,
	bl	.L114		@
	b	.L51		@
.L57:
@ _src/SkillTester.c:165:             if (buffer->skills[i] == traceId) {
	adds	r3, r3, #1	@ ivtmp.67,
@ _src/SkillTester.c:165:             if (buffer->skills[i] == traceId) {
	subs	r2, r3, #1	@ tmp319, ivtmp.67,
@ _src/SkillTester.c:165:             if (buffer->skills[i] == traceId) {
	ldrb	r2, [r2]	@ MEM[(unsigned char *)_154 + 4294967295B], MEM[(unsigned char *)_154 + 4294967295B]
	cmp	r2, r0	@ MEM[(unsigned char *)_154 + 4294967295B], traceId
	bne	.L55		@,
@ _src/SkillTester.c:172:             if (unit->index == gBattleTarget.unit.index) {
	movs	r3, #11	@ _36,
	ldrsb	r3, [r7, r3]	@ _36,* _36
@ _src/SkillTester.c:172:             if (unit->index == gBattleTarget.unit.index) {
	movs	r7, #11	@ tmp367,
@ _src/SkillTester.c:172:             if (unit->index == gBattleTarget.unit.index) {
	ldr	r2, .L112+36	@ tmp366,
@ _src/SkillTester.c:172:             if (unit->index == gBattleTarget.unit.index) {
	ldrsb	r7, [r2, r7]	@ tmp367,
	cmp	r7, r3	@ tmp367, _36
	bne	.L107		@,
@ _src/SkillTester.c:173:                 opponent = &gBattleActor.unit;
	movs	r2, r6	@ opponent, tmp270
	b	.L64		@
.L107:
@ _src/SkillTester.c:175:             else if (unit->index == gBattleActor.unit.index) {
	ldrb	r6, [r6, #11]	@ tmp324,
	lsls	r6, r6, #24	@ tmp324, tmp324,
	asrs	r6, r6, #24	@ tmp324, tmp324,
	cmp	r6, r3	@ tmp324, _36
	bne	.L54		@,
.L64:
@ _src/SkillTester.c:178:             if (opponent && opponent->pCharacterData && opponent->pClassData) {
	ldr	r3, [r2]	@ _39, opponent_80->pCharacterData
@ _src/SkillTester.c:178:             if (opponent && opponent->pCharacterData && opponent->pClassData) {
	cmp	r3, #0	@ _39,
	beq	.L54		@,
@ _src/SkillTester.c:178:             if (opponent && opponent->pCharacterData && opponent->pClassData) {
	ldr	r7, [r2, #4]	@ _40, opponent_80->pClassData
@ _src/SkillTester.c:178:             if (opponent && opponent->pCharacterData && opponent->pClassData) {
	cmp	r7, #0	@ _40,
	beq	.L54		@,
@ _src/SkillTester.c:179:                 u8 copied = PersonalSkillTable[opponent->pCharacterData->number];
	ldr	r6, [sp, #4]	@ tmp221, %sfp
@ _src/SkillTester.c:179:                 u8 copied = PersonalSkillTable[opponent->pCharacterData->number];
	ldrb	r3, [r3, #4]	@ tmp326,
@ _src/SkillTester.c:179:                 u8 copied = PersonalSkillTable[opponent->pCharacterData->number];
	ldrb	r3, [r6, r3]	@ copied, PersonalSkillTable
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r6, r3, #1	@ tmp327, copied,
@ _src/SkillTester.c:180:                 if (!IsSkillIDValid(copied)) {
	lsls	r6, r6, #24	@ tmp330, tmp327,
	lsrs	r6, r6, #24	@ tmp330, tmp330,
	cmp	r6, #253	@ tmp330,
	bls	.L58		@,
@ _src/SkillTester.c:181:                     copied = ClassSkillTable[opponent->pClassData->number];
	ldrb	r6, [r7, #4]	@ tmp333,
@ _src/SkillTester.c:181:                     copied = ClassSkillTable[opponent->pClassData->number];
	ldr	r3, .L112+4	@ tmp332,
	ldrb	r3, [r3, r6]	@ copied, ClassSkillTable
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r6, r3, #1	@ tmp334, copied,
@ _src/SkillTester.c:183:                 if (!IsSkillIDValid(copied)) {
	lsls	r6, r6, #24	@ tmp337, tmp334,
	lsrs	r6, r6, #24	@ tmp337, tmp337,
	cmp	r6, #253	@ tmp337,
	bls	.L58		@,
@ _src/SkillTester.c:184:                     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldr	r3, .L112+8	@ tmp339,
@ _src/SkillTester.c:185:                     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	movs	r7, #11	@ tmp340,
@ _src/SkillTester.c:184:                     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldrb	r6, [r3, #2]	@ learnedLimit,
@ _src/SkillTester.c:185:                     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	movs	r3, #192	@ tmp342,
@ _src/SkillTester.c:185:                     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	ldrsb	r7, [r2, r7]	@ tmp340,
@ _src/SkillTester.c:185:                     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	tst	r7, r3	@ tmp340, tmp342
	beq	.L59		@,
@ _src/SkillTester.c:185:                     if ((opponent->index & 0xC0) != 0 && learnedLimit > 6) {
	cmp	r6, #6	@ learnedLimit,
	bgt	.L60		@,
.L59:
@ _src/SkillTester.c:188:                     copied = 0;
	movs	r3, #0	@ copied,
@ _src/SkillTester.c:189:                     for (int i = 0; i < learnedLimit; ++i) {
	cmp	r6, r3	@ learnedLimit,
	beq	.L58		@,
.L60:
@ _src/SkillTester.c:190:                         if (!IsSkillIDValid(opponent->supports[i])) {
	adds	r2, r2, #50	@ tmp345,
	ldrb	r3, [r2]	@ copied,
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r2, r3, #1	@ tmp346, copied,
@ _src/SkillTester.c:190:                         if (!IsSkillIDValid(opponent->supports[i])) {
	lsls	r2, r2, #24	@ tmp349, tmp346,
	lsrs	r2, r2, #24	@ tmp349, tmp349,
	cmp	r2, #253	@ tmp349,
	bls	.L58		@,
@ _src/SkillTester.c:188:                     copied = 0;
	movs	r3, #0	@ copied,
.L58:
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r2, r3, #1	@ tmp351, copied,
@ _src/SkillTester.c:197:                 if (IsSkillIDValid(copied) && copied != traceId && count < 10) {
	lsls	r2, r2, #24	@ tmp354, tmp351,
	lsrs	r2, r2, #24	@ tmp354, tmp354,
	cmp	r2, #253	@ tmp354,
	bhi	.L54		@,
@ _src/SkillTester.c:197:                 if (IsSkillIDValid(copied) && copied != traceId && count < 10) {
	cmp	r3, r0	@ copied, traceId
	beq	.L54		@,
@ _src/SkillTester.c:197:                 if (IsSkillIDValid(copied) && copied != traceId && count < 10) {
	cmp	r4, #9	@ count,
	bgt	.L54		@,
.L61:
@ _src/SkillTester.c:199:                     for (int i = 0; i < count; ++i) {
	subs	r2, r1, r5	@ tmp358, ivtmp.59, buffer
	subs	r2, r2, #1	@ i,
	cmp	r4, r2	@ count, i
	bgt	.L62		@,
@ _src/SkillTester.c:206:                         buffer->skills[count++] = copied;
	adds	r2, r5, r4	@ tmp364, buffer, count
	strb	r3, [r2, #1]	@ copied, buffer_84(D)->skills[count_57]
@ _src/SkillTester.c:206:                         buffer->skills[count++] = copied;
	adds	r4, r4, #1	@ count,
	b	.L54		@
.L62:
@ _src/SkillTester.c:200:                         if (buffer->skills[i] == copied) {
	adds	r1, r1, #1	@ ivtmp.59,
@ _src/SkillTester.c:200:                         if (buffer->skills[i] == copied) {
	subs	r2, r1, #1	@ tmp356, ivtmp.59,
@ _src/SkillTester.c:200:                         if (buffer->skills[i] == copied) {
	ldrb	r2, [r2]	@ MEM[(unsigned char *)_145 + 4294967295B], MEM[(unsigned char *)_145 + 4294967295B]
	cmp	r2, r3	@ MEM[(unsigned char *)_145 + 4294967295B], copied
	bne	.L61		@,
	b	.L54		@
.L113:
	.align	2
.L112:
	.word	PersonalSkillTable
	.word	ClassSkillTable
	.word	gSkillTestConfig
	.word	GetItemAttributes
	.word	PassiveSkillBit
	.word	GetItemData
	.word	gBattleActor
	.word	gBattleStats
	.word	TraceIDLink
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
@ _src/SkillTester.c:226:     for (int i = 0; i < 0x100; ++i) {
	movs	r6, #0	@ i,
@ _src/SkillTester.c:223:     int count = 0;
	movs	r4, r6	@ count, i
@ _src/SkillTester.c:220: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	sub	sp, sp, #28	@,,
@ _src/SkillTester.c:220: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	str	r0, [sp, #4]	@ tmp198, %sfp
@ _src/SkillTester.c:221:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r5, .L129	@ buffer,
.L121:
@ _src/SkillTester.c:227:         Unit* other = gUnitLookup[i];
	ldr	r2, .L129+4	@ tmp159,
	lsls	r3, r6, #2	@ tmp157, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _71 * 1]
@ _src/SkillTester.c:229:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ _src/SkillTester.c:229:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp199,
	beq	.L116		@,
@ _src/SkillTester.c:229:         if (!IsUnitOnField(other) || unit->index == i) {
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #11]	@ tmp162,
	lsls	r3, r3, #24	@ tmp162, tmp162,
	asrs	r3, r3, #24	@ tmp162, tmp162,
@ _src/SkillTester.c:229:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r3, r6	@ tmp162, i
	beq	.L116		@,
@ _src/SkillTester.c:234:         buffer = MakeSkillBuffer(other, buffer);
	movs	r1, r5	@, buffer
	movs	r0, r7	@, other
	bl	MakeSkillBuffer		@
@ _src/SkillTester.c:238:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L129+8	@ tmp163,
	ldrh	r3, [r3]	@ _8, gSkillTestConfig
	str	r3, [sp, #8]	@ _8, %sfp
@ _src/SkillTester.c:238:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L129+12	@ tmp194,
	str	r3, [sp, #16]	@ tmp194, %sfp
@ _src/SkillTester.c:239:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r3, .L129+16	@ tmp195,
	str	r3, [sp, #20]	@ tmp195, %sfp
@ _src/SkillTester.c:234:         buffer = MakeSkillBuffer(other, buffer);
	movs	r5, r0	@ buffer, tmp200
	adds	r0, r0, #1	@ ivtmp.101,
.L117:
@ _src/SkillTester.c:237:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	ldrb	r3, [r0]	@ _29, MEM[(unsigned char *)_69]
@ _src/SkillTester.c:237:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	cmp	r3, #0	@ _29,
	bne	.L120		@,
.L116:
@ _src/SkillTester.c:226:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp219,
@ _src/SkillTester.c:226:     for (int i = 0; i < 0x100; ++i) {
	adds	r6, r6, #1	@ i,
@ _src/SkillTester.c:226:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp219, tmp219,
	cmp	r6, r3	@ i, tmp219
	bne	.L121		@,
@ _src/SkillTester.c:258:     buffer->lastUnitChecked = 0;
	movs	r3, #0	@ tmp187,
@ _src/SkillTester.c:259:     gAuraSkillBuffer[count++].skillID = 0;
	ldr	r0, .L129+16	@ tmp189,
	lsls	r4, r4, #1	@ tmp190, count,
@ _src/SkillTester.c:258:     buffer->lastUnitChecked = 0;
	strb	r3, [r5]	@ tmp187, buffer_30->lastUnitChecked
@ _src/SkillTester.c:259:     gAuraSkillBuffer[count++].skillID = 0;
	strb	r3, [r4, r0]	@ tmp187, gAuraSkillBuffer[count_34].skillID
@ _src/SkillTester.c:262: }
	add	sp, sp, #28	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L120:
@ _src/SkillTester.c:238:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #16]	@ tmp194, %sfp
	ldrb	r2, [r2, r3]	@ tmp165, AuraSkillTable
	cmp	r2, #0	@ tmp165,
	beq	.L118		@,
@ _src/SkillTester.c:238:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #8]	@ _8, %sfp
	cmp	r2, r4	@ _8, count
	ble	.L118		@,
@ _src/SkillTester.c:239:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r2, [sp, #20]	@ tmp195, %sfp
	lsls	r1, r4, #1	@ tmp166, count,
	adds	r1, r1, r2	@ _11, tmp166, tmp195
@ _src/SkillTester.c:239:                 auraBuffer[count].skillID = buffer->skills[j];
	strb	r3, [r1]	@ _29, _11->skillID
@ _src/SkillTester.c:241:                 distance = absolute(other->xPos - unit->xPos) +
	movs	r3, #16	@ tmp170,
@ _src/SkillTester.c:241:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #4]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp171,
@ _src/SkillTester.c:241:                 distance = absolute(other->xPos - unit->xPos) +
	ldrsb	r3, [r7, r3]	@ tmp170,
@ _src/SkillTester.c:241:                 distance = absolute(other->xPos - unit->xPos) +
	lsls	r2, r2, #24	@ tmp171, tmp171,
	asrs	r2, r2, #24	@ tmp171, tmp171,
@ _src/SkillTester.c:241:                 distance = absolute(other->xPos - unit->xPos) +
	subs	r2, r3, r2	@ tmp172, tmp170, tmp171
@ _src/SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r3, r2, #31	@ tmp202, tmp172,
	adds	r2, r2, r3	@ tmp173, tmp172, tmp202
	eors	r2, r3	@ tmp173, tmp202
@ _src/SkillTester.c:242:                            absolute(other->yPos - unit->yPos);
	movs	r3, #17	@ tmp174,
@ _src/SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	str	r2, [sp, #12]	@ tmp173, %sfp
@ _src/SkillTester.c:242:                            absolute(other->yPos - unit->yPos);
	ldrsb	r3, [r7, r3]	@ tmp174,
	mov	ip, r3	@ tmp174, tmp174
@ _src/SkillTester.c:242:                            absolute(other->yPos - unit->yPos);
	mov	r2, ip	@ tmp174, tmp174
@ _src/SkillTester.c:242:                            absolute(other->yPos - unit->yPos);
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #17]	@ tmp175,
	lsls	r3, r3, #24	@ tmp175, tmp175,
	asrs	r3, r3, #24	@ tmp175, tmp175,
@ _src/SkillTester.c:242:                            absolute(other->yPos - unit->yPos);
	subs	r3, r2, r3	@ tmp176, tmp174, tmp175
@ _src/SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r2, r3, #31	@ tmp203, tmp176,
	adds	r3, r3, r2	@ tmp177, tmp176, tmp203
	eors	r3, r2	@ tmp177, tmp203
@ _src/SkillTester.c:241:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #12]	@ tmp173, %sfp
	adds	r3, r2, r3	@ distance, tmp173, tmp177
@ _src/SkillTester.c:244:                 if (distance > 63) {
	cmp	r3, #63	@ distance,
	ble	.L119		@,
	movs	r3, #63	@ distance,
.L119:
@ _src/SkillTester.c:251:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	movs	r2, #11	@ tmp178,
	ldrsb	r2, [r7, r2]	@ tmp178,
@ _src/SkillTester.c:251:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	asrs	r2, r2, #6	@ tmp179, tmp178,
@ _src/SkillTester.c:249:                 auraBuffer[count].distance = distance;
	lsls	r2, r2, #6	@ tmp181, tmp179,
	orrs	r3, r2	@ tmp184, tmp181
	strb	r3, [r1, #1]	@ tmp184, MEM <unsigned char> [(struct AuraSkillBuffer *)_11 + 1B]
@ _src/SkillTester.c:252:                 ++count;
	adds	r4, r4, #1	@ count,
.L118:
	adds	r0, r0, #1	@ ivtmp.101,
	b	.L117		@
.L130:
	.align	2
.L129:
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
@ _src/SkillTester.c:266: bool CheckSkillBuffer(Unit* unit, u8 skillID) {
	movs	r3, r0	@ unit, tmp130
@ _src/SkillTester.c:267:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ _src/SkillTester.c:267:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L132		@,
@ _src/SkillTester.c:268:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
@ _src/SkillTester.c:268:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	beq	.L132		@,
@ _src/SkillTester.c:273:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	movs	r0, #11	@ tmp126,
	ldrsb	r0, [r3, r0]	@ tmp126,
@ _src/SkillTester.c:273:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldr	r3, .L140	@ tmp127,
	ldrb	r2, [r3]	@ gDefenderSkillBuffer, gDefenderSkillBuffer
@ _src/SkillTester.c:273:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	cmp	r0, r2	@ tmp126, gDefenderSkillBuffer
	beq	.L133		@,
@ _src/SkillTester.c:270:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r3, .L140+4	@ buffer,
.L133:
	adds	r3, r3, #1	@ ivtmp.116,
.L134:
@ _src/SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	ldrb	r0, [r3]	@ _10, MEM[(unsigned char *)_17]
@ _src/SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	cmp	r0, #0	@ _10,
	bne	.L135		@,
.L132:
@ _src/SkillTester.c:278: }
	@ sp needed	@
	bx	lr
.L135:
@ _src/SkillTester.c:29:         if (buffer->skills[i] == skillID) {
	adds	r3, r3, #1	@ ivtmp.116,
	cmp	r1, r0	@ skillID, _10
	bne	.L134		@,
@ _src/SkillTester.c:267:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
	b	.L132		@
.L141:
	.align	2
.L140:
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
@ _src/SkillTester.c:282: bool SkillTester(Unit* unit, u8 skillID) {
	movs	r5, r0	@ unit, tmp162
	movs	r6, r1	@ skillID, tmp163
@ _src/SkillTester.c:283:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ _src/SkillTester.c:283:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L167		@,
@ _src/SkillTester.c:284:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	bne	.L144		@,
.L145:
@ _src/SkillTester.c:284:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
.L167:
@ _src/SkillTester.c:313: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L144:
@ _src/SkillTester.c:285:     if (!unit || !unit->pCharacterData || !unit->pClassData) {return FALSE;}
	cmp	r5, #0	@ unit,
	beq	.L145		@,
@ _src/SkillTester.c:285:     if (!unit || !unit->pCharacterData || !unit->pClassData) {return FALSE;}
	ldr	r3, [r5]	@ unit_18(D)->pCharacterData, unit_18(D)->pCharacterData
	cmp	r3, #0	@ unit_18(D)->pCharacterData,
	beq	.L145		@,
@ _src/SkillTester.c:285:     if (!unit || !unit->pCharacterData || !unit->pClassData) {return FALSE;}
	ldr	r3, [r5, #4]	@ unit_18(D)->pClassData, unit_18(D)->pClassData
	cmp	r3, #0	@ unit_18(D)->pClassData,
	beq	.L145		@,
@ _src/SkillTester.c:287:     int index = unit->index;
	movs	r3, #11	@ index,
@ _src/SkillTester.c:293:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r2, .L170	@ tmp139,
@ _src/SkillTester.c:293:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrb	r2, [r2, #11]	@ tmp140,
@ _src/SkillTester.c:287:     int index = unit->index;
	ldrsb	r3, [r5, r3]	@ index,* index
@ _src/SkillTester.c:293:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #24	@ tmp140, tmp140,
@ _src/SkillTester.c:290:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r4, .L170+4	@ buffer,
@ _src/SkillTester.c:293:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	asrs	r2, r2, #24	@ tmp140, tmp140,
	cmp	r2, r3	@ tmp140, index
	bne	.L146		@,
@ _src/SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L170+8	@ tmp141,
@ _src/SkillTester.c:293:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
@ _src/SkillTester.c:294:         buffer = &gDefenderSkillBuffer;
	ldr	r4, .L170+12	@ buffer,
@ _src/SkillTester.c:293:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #30	@ tmp167, gBattleStats,
	bne	.L146		@,
@ _src/SkillTester.c:290:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r4, .L170+4	@ buffer,
.L146:
@ _src/SkillTester.c:297:     if (index != buffer->lastUnitChecked) {
	ldrb	r2, [r4]	@ *buffer_13, *buffer_13
@ _src/SkillTester.c:297:     if (index != buffer->lastUnitChecked) {
	cmp	r2, r3	@ *buffer_13, index
	beq	.L147		@,
@ _src/SkillTester.c:298:         MakeSkillBuffer(unit, buffer);
	movs	r1, r4	@, buffer
	movs	r0, r5	@, unit
	bl	MakeSkillBuffer		@
.L147:
	adds	r4, r4, #1	@ ivtmp.127,
@ _src/SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	movs	r3, r4	@ ivtmp.135, ivtmp.127
.L148:
@ _src/SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	ldrb	r2, [r3]	@ _26, MEM[(unsigned char *)_40]
@ _src/SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	cmp	r2, #0	@ _26,
	bne	.L150		@,
@ _src/SkillTester.c:308:     if (IsSkillIDValid(CatchEmAllIDLink) && IsSkillInBuffer(buffer, CatchEmAllIDLink)) {
	ldr	r3, .L170+16	@ tmp156,
	ldrb	r2, [r3]	@ CatchEmAllIDLink.13_10, CatchEmAllIDLink
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp157, CatchEmAllIDLink.13_10,
@ _src/SkillTester.c:308:     if (IsSkillIDValid(CatchEmAllIDLink) && IsSkillInBuffer(buffer, CatchEmAllIDLink)) {
	lsls	r3, r3, #24	@ tmp160, tmp157,
	lsrs	r3, r3, #24	@ tmp160, tmp160,
	cmp	r3, #253	@ tmp160,
	bls	.L153		@,
	b	.L145		@
.L150:
@ _src/SkillTester.c:29:         if (buffer->skills[i] == skillID) {
	adds	r3, r3, #1	@ ivtmp.135,
	cmp	r6, r2	@ skillID, _26
	bne	.L148		@,
.L149:
@ _src/SkillTester.c:304:         return !NihilTester(unit, skillID);
	movs	r1, r6	@, skillID
	movs	r0, r5	@, unit
	bl	NihilTester		@
@ _src/SkillTester.c:304:         return !NihilTester(unit, skillID);
	movs	r3, #1	@ tmp153,
	eors	r0, r3	@ tmp152, tmp153
	lsls	r0, r0, #24	@ <retval>, tmp152,
	lsrs	r0, r0, #24	@ <retval>, <retval>,
@ _src/SkillTester.c:304:         return !NihilTester(unit, skillID);
	b	.L167		@
.L152:
@ _src/SkillTester.c:29:         if (buffer->skills[i] == skillID) {
	adds	r4, r4, #1	@ ivtmp.127,
	cmp	r2, r3	@ CatchEmAllIDLink.13_10, _23
	beq	.L149		@,
.L153:
@ _src/SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	ldrb	r3, [r4]	@ _23, MEM[(unsigned char *)_5]
@ _src/SkillTester.c:28:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	cmp	r3, #0	@ _23,
	bne	.L152		@,
	b	.L145		@
.L171:
	.align	2
.L170:
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
@ _src/SkillTester.c:316: bool NewAuraSkillCheck(Unit* unit, u8 skillID, int allyOption, int maxRange) {
	str	r3, [sp, #12]	@ tmp169, %sfp
@ _src/SkillTester.c:317:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L191	@ iftmp.15_22,
@ _src/SkillTester.c:316: bool NewAuraSkillCheck(Unit* unit, u8 skillID, int allyOption, int maxRange) {
	movs	r4, r1	@ skillID, tmp167
	movs	r5, r2	@ allyOption, tmp168
	str	r0, [sp, #8]	@ tmp166, %sfp
@ _src/SkillTester.c:317:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	str	r3, [sp]	@ iftmp.15_22, %sfp
@ _src/SkillTester.c:317:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	lsls	r3, r2, #31	@ tmp172, allyOption,
	bpl	.L173		@,
@ _src/SkillTester.c:317:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L191+4	@ iftmp.15_22,
	str	r3, [sp]	@ iftmp.15_22, %sfp
.L173:
@ _src/SkillTester.c:319:     if (skillID == 0)   {return TRUE;}
	cmp	r4, #0	@ skillID,
	bne	.L174		@,
.L181:
@ _src/SkillTester.c:319:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
.L175:
@ _src/SkillTester.c:339: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L174:
@ _src/SkillTester.c:320:     if (skillID == 255) {return FALSE;}
	cmp	r4, #255	@ skillID,
	bne	.L176		@,
.L183:
@ _src/SkillTester.c:320:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
	b	.L175		@
.L176:
@ _src/SkillTester.c:324:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	movs	r7, #0	@ i,
@ _src/SkillTester.c:323:     int limit = gSkillTestConfig.auraSkillBufferLimit;
	ldr	r3, .L191+8	@ tmp140,
@ _src/SkillTester.c:323:     int limit = gSkillTestConfig.auraSkillBufferLimit;
	ldrh	r3, [r3]	@ limit, gSkillTestConfig
	ldr	r6, .L191+12	@ ivtmp.144,
	str	r3, [sp, #4]	@ limit, %sfp
.L177:
@ _src/SkillTester.c:324:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	ldr	r3, [sp, #4]	@ limit, %sfp
	cmp	r7, r3	@ i, limit
	bge	.L183		@,
@ _src/SkillTester.c:324:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	ldrb	r2, [r6]	@ _19, MEM[(unsigned char *)_18]
@ _src/SkillTester.c:324:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	cmp	r2, #0	@ _19,
	beq	.L183		@,
@ _src/SkillTester.c:325:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldrb	r1, [r6, #1]	@ *_18, *_18
@ _src/SkillTester.c:325:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldr	r0, [sp, #12]	@ maxRange, %sfp
@ _src/SkillTester.c:325:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	lsls	r3, r1, #26	@ tmp145, *_18,
	lsrs	r3, r3, #26	@ tmp146, tmp145,
@ _src/SkillTester.c:325:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r3, r0	@ tmp146, maxRange
	ble	.L178		@,
.L179:
@ _src/SkillTester.c:324:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	adds	r7, r7, #1	@ i,
	adds	r6, r6, #2	@ ivtmp.144,
	b	.L177		@
.L178:
@ _src/SkillTester.c:325:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r2, r4	@ _19, skillID
	bne	.L179		@,
@ _src/SkillTester.c:328:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	movs	r0, #11	@ tmp156,
	ldr	r3, [sp, #8]	@ unit, %sfp
@ _src/SkillTester.c:328:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	lsrs	r1, r1, #6	@ tmp153, *_18,
@ _src/SkillTester.c:328:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	ldrsb	r0, [r3, r0]	@ tmp156,
	lsls	r1, r1, #6	@ tmp155, tmp153,
	ldr	r3, [sp]	@ iftmp.15_22, %sfp
	bl	.L114		@
@ _src/SkillTester.c:330:             if (allyOption & 2)
	movs	r3, #2	@ tmp180,
	tst	r5, r3	@ allyOption, tmp180
	beq	.L180		@,
@ _src/SkillTester.c:333:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp157,
	beq	.L181		@,
.L182:
@ _src/SkillTester.c:333:             if (check || (allyOption & 4))
	movs	r3, #4	@ tmp181,
	tst	r5, r3	@ allyOption, tmp181
	beq	.L179		@,
	b	.L181		@
.L180:
@ _src/SkillTester.c:333:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp157,
	beq	.L182		@,
	b	.L181		@
.L192:
	.align	2
.L191:
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
@ _src/SkillTester.c:342: void InitializePreBattleLoop(Unit* attacker, Unit* defender) {
	movs	r4, r0	@ attacker, tmp132
@ _src/SkillTester.c:343:     MakeAuraSkillBuffer(attacker);
	bl	MakeAuraSkillBuffer		@
@ _src/SkillTester.c:344:     MakeSkillBuffer(attacker, &gAttackerSkillBuffer);
	ldr	r1, .L199	@ tmp118,
	movs	r0, r4	@, attacker
	bl	MakeSkillBuffer		@
@ _src/SkillTester.c:345:     gDefenderSkillBuffer.lastUnitChecked = 0;
	movs	r3, #0	@ tmp120,
	ldr	r1, .L199+4	@ tmp119,
	strb	r3, [r1]	@ tmp120, gDefenderSkillBuffer.lastUnitChecked
@ _src/SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r3, .L199+8	@ tmp122,
@ _src/SkillTester.c:347:     if (IsBattleReal()) {
	ldrh	r3, [r3]	@ gBattleStats, gBattleStats
	lsls	r3, r3, #30	@ tmp133, gBattleStats,
	beq	.L193		@,
@ _src/SkillTester.c:348:         MakeSkillBuffer(&gBattleTarget.unit, &gDefenderSkillBuffer);
	ldr	r0, .L199+12	@ tmp131,
	bl	MakeSkillBuffer		@
.L193:
@ _src/SkillTester.c:350: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
.L200:
	.align	2
.L199:
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
@ _src/SkillTester.c:354:     gAttackerSkillBuffer.lastUnitChecked = 0;
	movs	r2, #0	@ tmp115,
@ _src/SkillTester.c:356: }
	@ sp needed	@
@ _src/SkillTester.c:354:     gAttackerSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L202	@ tmp114,
	strb	r2, [r3]	@ tmp115, gAttackerSkillBuffer.lastUnitChecked
@ _src/SkillTester.c:355:     gDefenderSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L202+4	@ tmp117,
	strb	r2, [r3]	@ tmp115, gDefenderSkillBuffer.lastUnitChecked
@ _src/SkillTester.c:356: }
	bx	lr
.L203:
	.align	2
.L202:
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
@ _src/SkillTester.c:360:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L225	@ iftmp.20_32,
@ _src/SkillTester.c:359: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	sub	sp, sp, #20	@,,
@ _src/SkillTester.c:359: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	movs	r5, r1	@ allyOption, tmp191
	str	r0, [sp, #8]	@ tmp190, %sfp
	str	r2, [sp, #12]	@ tmp192, %sfp
@ _src/SkillTester.c:360:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	str	r3, [sp, #4]	@ iftmp.20_32, %sfp
@ _src/SkillTester.c:360:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	lsls	r3, r1, #31	@ tmp198, allyOption,
	bpl	.L205		@,
@ _src/SkillTester.c:360:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L225+4	@ iftmp.20_32,
	str	r3, [sp, #4]	@ iftmp.20_32, %sfp
.L205:
@ _src/SkillTester.c:365:     for (int i = 0; i < 0x100; ++i) {
	movs	r4, #0	@ i,
@ _src/SkillTester.c:362:     int count = 0;
	movs	r6, r4	@ count, i
.L212:
@ _src/SkillTester.c:366:         Unit* other = gUnitLookup[i];
	ldr	r2, .L225+8	@ tmp154,
	lsls	r3, r4, #2	@ tmp152, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _34 * 1]
@ _src/SkillTester.c:368:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ _src/SkillTester.c:368:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp193,
	beq	.L209		@,
@ _src/SkillTester.c:368:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, #11	@ _4,
	ldr	r3, [sp, #8]	@ unit, %sfp
	ldrsb	r0, [r3, r0]	@ _4,* _4
@ _src/SkillTester.c:368:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, r4	@ _4, i
	beq	.L209		@,
@ _src/SkillTester.c:374:             check = !pAllegianceChecker(unit->index, other->index);
	movs	r1, #11	@ _31,
@ _src/SkillTester.c:373:         if (allyOption & 2) {
	movs	r3, #2	@ tmp207,
@ _src/SkillTester.c:374:             check = !pAllegianceChecker(unit->index, other->index);
	ldrsb	r1, [r7, r1]	@ _31,* _31
@ _src/SkillTester.c:373:         if (allyOption & 2) {
	tst	r5, r3	@ allyOption, tmp207
	beq	.L207		@,
@ _src/SkillTester.c:374:             check = !pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.20_32, %sfp
	bl	.L114		@
@ _src/SkillTester.c:380:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp194,
	beq	.L208		@,
.L211:
@ _src/SkillTester.c:380:         if (check || (allyOption & 4)) {
	movs	r3, #4	@ tmp209,
	tst	r5, r3	@ allyOption, tmp209
	beq	.L209		@,
.L208:
@ _src/SkillTester.c:381:             if ((absolute(other->xPos - unit->xPos)
	movs	r3, #16	@ tmp163,
@ _src/SkillTester.c:381:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #8]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp164,
@ _src/SkillTester.c:381:             if ((absolute(other->xPos - unit->xPos)
	ldrsb	r3, [r7, r3]	@ tmp163,
@ _src/SkillTester.c:381:             if ((absolute(other->xPos - unit->xPos)
	lsls	r2, r2, #24	@ tmp164, tmp164,
	asrs	r2, r2, #24	@ tmp164, tmp164,
@ _src/SkillTester.c:381:             if ((absolute(other->xPos - unit->xPos)
	subs	r2, r3, r2	@ tmp165, tmp163, tmp164
@ _src/SkillTester.c:382:                + absolute(other->yPos - unit->yPos)) <= range) {
	movs	r3, #17	@ tmp167,
@ _src/SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r2, #31	@ tmp199, tmp165,
	adds	r2, r2, r1	@ tmp166, tmp165, tmp199
	eors	r2, r1	@ tmp166, tmp199
@ _src/SkillTester.c:382:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldr	r1, [sp, #8]	@ unit, %sfp
	ldrb	r1, [r1, #17]	@ tmp168,
@ _src/SkillTester.c:382:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldrsb	r3, [r7, r3]	@ tmp167,
@ _src/SkillTester.c:382:                + absolute(other->yPos - unit->yPos)) <= range) {
	lsls	r1, r1, #24	@ tmp168, tmp168,
	asrs	r1, r1, #24	@ tmp168, tmp168,
@ _src/SkillTester.c:382:                + absolute(other->yPos - unit->yPos)) <= range) {
	subs	r3, r3, r1	@ tmp169, tmp167, tmp168
@ _src/SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r3, #31	@ tmp200, tmp169,
	adds	r3, r3, r1	@ tmp170, tmp169, tmp200
	eors	r3, r1	@ tmp170, tmp200
@ _src/SkillTester.c:382:                + absolute(other->yPos - unit->yPos)) <= range) {
	adds	r3, r2, r3	@ tmp171, tmp166, tmp170
@ _src/SkillTester.c:381:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #12]	@ range, %sfp
	cmp	r3, r2	@ tmp171, range
	ble	.L210		@,
.L209:
@ _src/SkillTester.c:365:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp176,
@ _src/SkillTester.c:365:     for (int i = 0; i < 0x100; ++i) {
	adds	r4, r4, #1	@ i,
@ _src/SkillTester.c:365:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp176, tmp176,
	cmp	r4, r3	@ i, tmp176
	bne	.L212		@,
@ _src/SkillTester.c:389:     gUnitRangeBuffer[count++] = 0;
	movs	r2, #0	@ tmp178,
	ldr	r3, .L225+12	@ tmp177,
	strb	r2, [r3, r6]	@ tmp178, gUnitRangeBuffer[count_28]
@ _src/SkillTester.c:390:     if (!gUnitRangeBuffer[0])
	ldrb	r0, [r3]	@ gUnitRangeBuffer, gUnitRangeBuffer
@ _src/SkillTester.c:393:     return gUnitRangeBuffer;
	subs	r2, r0, #1	@ tmp186, gUnitRangeBuffer
	sbcs	r0, r0, r2	@ tmp185, gUnitRangeBuffer, tmp186
	rsbs	r0, r0, #0	@ tmp187, tmp185
	ands	r0, r3	@ <retval>, tmp177
@ _src/SkillTester.c:394: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L207:
@ _src/SkillTester.c:377:             check =  pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.20_32, %sfp
	bl	.L114		@
@ _src/SkillTester.c:380:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp195,
	bne	.L208		@,
	b	.L211		@
.L210:
@ _src/SkillTester.c:383:                 gUnitRangeBuffer[count++] = i;
	ldr	r3, .L225+12	@ tmp174,
	strb	r4, [r3, r6]	@ i, gUnitRangeBuffer[count_54]
@ _src/SkillTester.c:383:                 gUnitRangeBuffer[count++] = i;
	adds	r6, r6, #1	@ count,
	b	.L209		@
.L226:
	.align	2
.L225:
	.word	AreAllegiancesEqual
	.word	AreAllegiancesAllied
	.word	gUnitLookup
	.word	gUnitRangeBuffer
	.size	GetUnitsInRange, .-GetUnitsInRange
	.ident	"GCC: (devkitARM release 63) 13.2.0"
	.code 16
	.align	1
.L114:
	bx	r3
