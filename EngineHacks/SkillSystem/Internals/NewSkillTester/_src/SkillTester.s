	.cpu arm7tdmi
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
@ GNU C17 (devkitARM release 56) version 11.1.0 (arm-none-eabi)
@	compiled by GNU C version 10.3.0, GMP version 6.1.0, MPFR version 3.1.4, MPC version 1.0.3, isl version isl-0.18-GMP

@ GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
@ options passed: -mcpu=arm7tdmi -mthumb -mthumb-interwork -mtune=arm7tdmi -mlong-calls -march=armv4t -Os
	.text
	.align	1
	.arch armv4t
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	IsUnitOnField, %function
IsUnitOnField:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ _src/SkillTester.c:11: static bool IsUnitOnField(Unit* unit) {
	subs	r3, r0, #0	@ unit, tmp132,
@ _src/SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	beq	.L2		@,
@ _src/SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	ldr	r2, [r0]	@ unit_7(D)->pCharacterData, unit_7(D)->pCharacterData
@ _src/SkillTester.c:13:         return FALSE;
	subs	r0, r2, #0	@ <retval>, unit_7(D)->pCharacterData,
@ _src/SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	beq	.L2		@,
@ _src/SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	ldr	r3, [r3, #12]	@ _2, unit_7(D)->state
@ _src/SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	ldr	r2, .L9	@ tmp122,
@ _src/SkillTester.c:13:         return FALSE;
	movs	r0, #0	@ <retval>,
@ _src/SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	tst	r3, r2	@ _2, tmp122
	bne	.L2		@,
@ _src/SkillTester.c:22:     return TRUE;
	adds	r0, r0, #1	@ <retval>,
@ _src/SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	lsls	r3, r3, #24	@ tmp133, _2,
	bpl	.L2		@,
@ _src/SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	ldr	r3, .L9+4	@ tmp125,
@ _src/SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	ldrb	r0, [r3, #4]	@ tmp127,
	subs	r3, r0, #1	@ tmp129, tmp127
	sbcs	r0, r0, r3	@ <retval>, tmp127, tmp129
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
	.global	IsSkillInBuffer
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	IsSkillInBuffer, %function
IsSkillInBuffer:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	adds	r0, r0, #1	@ ivtmp.47,
.L12:
@ _src/SkillTester.c:27:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	ldrb	r3, [r0]	@ _1, MEM[(unsigned char *)_12]
@ _src/SkillTester.c:27:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	cmp	r3, #0	@ _1,
	bne	.L14		@,
@ _src/SkillTester.c:32:     return FALSE;
	movs	r0, r3	@ <retval>, _1
.L13:
@ _src/SkillTester.c:33: }
	@ sp needed	@
	bx	lr
.L14:
@ _src/SkillTester.c:28:         if (buffer->skills[i] == skillID) {
	adds	r0, r0, #1	@ ivtmp.47,
	cmp	r3, r1	@ _1, skillID
	bne	.L12		@,
@ _src/SkillTester.c:29:             return TRUE;
	movs	r0, #1	@ <retval>,
	b	.L13		@
	.size	IsSkillInBuffer, .-IsSkillInBuffer
	.align	1
	.global	NihilTester
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	NihilTester, %function
NihilTester:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ _src/SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldr	r3, .L25	@ tmp124,
@ _src/SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldrh	r3, [r3]	@ gBattleStats, gBattleStats
@ _src/SkillTester.c:37: bool NihilTester(Unit* unit, u8 skillID) {
	movs	r2, r0	@ unit, tmp142
	push	{r4, lr}	@
@ _src/SkillTester.c:49:     return FALSE;
	movs	r0, #0	@ <retval>,
@ _src/SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	lsls	r3, r3, #30	@ tmp146, gBattleStats,
	beq	.L17		@,
@ _src/SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldr	r3, .L25+4	@ tmp132,
@ _src/SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldrb	r3, [r3, r1]	@ tmp133, NegatedSkills
	cmp	r3, r0	@ tmp133,
	beq	.L17		@,
@ _src/SkillTester.c:43:         if (unit->index == gBattleTarget.unit.index) {
	ldr	r3, .L25+8	@ tmp134,
@ _src/SkillTester.c:43:         if (unit->index == gBattleTarget.unit.index) {
	ldrb	r2, [r2, #11]	@ MEM[(signed char *)unit_9(D) + 11B], MEM[(signed char *)unit_9(D) + 11B]
	ldrb	r3, [r3, #11]	@ tmp136,
	lsls	r2, r2, #24	@ MEM[(signed char *)unit_9(D) + 11B], MEM[(signed char *)unit_9(D) + 11B],
	lsls	r3, r3, #24	@ tmp136, tmp136,
@ _src/SkillTester.c:40:         SkillBuffer* buffer = &gDefenderSkillBuffer;
	ldr	r0, .L25+12	@ buffer,
@ _src/SkillTester.c:43:         if (unit->index == gBattleTarget.unit.index) {
	asrs	r2, r2, #24	@ MEM[(signed char *)unit_9(D) + 11B], MEM[(signed char *)unit_9(D) + 11B],
	asrs	r3, r3, #24	@ tmp136, tmp136,
	cmp	r2, r3	@ MEM[(signed char *)unit_9(D) + 11B], tmp136
	bne	.L18		@,
@ _src/SkillTester.c:44:             buffer = &gAttackerSkillBuffer;
	ldr	r0, .L25+16	@ buffer,
.L18:
@ _src/SkillTester.c:47:         return IsSkillInBuffer(buffer, NihilIDLink);
	ldr	r3, .L25+20	@ tmp137,
	ldrb	r1, [r3]	@ NihilIDLink, NihilIDLink
	bl	IsSkillInBuffer		@
.L17:
@ _src/SkillTester.c:50: }
	@ sp needed	@
	pop	{r4}
	pop	{r1}
	bx	r1
.L26:
	.align	2
.L25:
	.word	gBattleStats
	.word	NegatedSkills
	.word	gBattleTarget
	.word	gDefenderSkillBuffer
	.word	gAttackerSkillBuffer
	.word	NihilIDLink
	.size	NihilTester, .-NihilTester
	.align	1
	.global	MakeSkillBuffer
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	MakeSkillBuffer, %function
MakeSkillBuffer:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	movs	r6, r0	@ unit, tmp318
@ _src/SkillTester.c:56:     int unitNum = unit->pCharacterData->number;
	ldr	r3, [r0]	@ unit_70(D)->pCharacterData, unit_70(D)->pCharacterData
@ _src/SkillTester.c:56:     int unitNum = unit->pCharacterData->number;
	ldrb	r0, [r3, #4]	@ unitNum,
@ _src/SkillTester.c:58:     buffer->lastUnitChecked = unit->index;
	ldrb	r3, [r6, #11]	@ tmp195,
	strb	r3, [r1]	@ tmp195, buffer_72(D)->lastUnitChecked
@ _src/SkillTester.c:61:     temp = PersonalSkillTable[unitNum];
	ldr	r3, .L60	@ tmp197,
	ldrb	r2, [r3, r0]	@ _5, PersonalSkillTable
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp198, _5,
@ _src/SkillTester.c:62:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp201, tmp198,
@ _src/SkillTester.c:55: SkillBuffer* MakeSkillBuffer(Unit* unit, SkillBuffer* buffer) {
	movs	r5, r1	@ buffer, tmp319
@ _src/SkillTester.c:57:     int count = 0, temp = 0;
	movs	r4, #0	@ count,
@ _src/SkillTester.c:55: SkillBuffer* MakeSkillBuffer(Unit* unit, SkillBuffer* buffer) {
	sub	sp, sp, #20	@,,
@ _src/SkillTester.c:62:     if (IsSkillIDValid(temp)) {
	lsrs	r3, r3, #24	@ tmp201, tmp201,
	cmp	r3, #253	@ tmp201,
	bhi	.L28		@,
@ _src/SkillTester.c:63:         buffer->skills[count++] = temp;
	strb	r2, [r1, #1]	@ _5, buffer_72(D)->skills[0]
@ _src/SkillTester.c:63:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L28:
@ _src/SkillTester.c:67:     temp = ClassSkillTable[unit->pClassData->number];
	ldr	r2, [r6, #4]	@ unit_70(D)->pClassData, unit_70(D)->pClassData
@ _src/SkillTester.c:67:     temp = ClassSkillTable[unit->pClassData->number];
	ldr	r3, .L60+4	@ tmp204,
@ _src/SkillTester.c:67:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r2, [r2, #4]	@ tmp206,
@ _src/SkillTester.c:67:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r2, [r3, r2]	@ _9, ClassSkillTable
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp207, _9,
@ _src/SkillTester.c:68:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp210, tmp207,
	lsrs	r3, r3, #24	@ tmp210, tmp210,
	cmp	r3, #253	@ tmp210,
	bhi	.L29		@,
@ _src/SkillTester.c:69:         buffer->skills[count++] = temp;
	adds	r3, r5, r4	@ tmp212, buffer, count
	strb	r2, [r3, #1]	@ _9, buffer_72(D)->skills[count_46]
@ _src/SkillTester.c:69:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L29:
@ _src/SkillTester.c:73:     BWLData* unitBWL = BWL_GetEntry(unitNum);
	ldr	r3, .L60+8	@ tmp214,
	bl	.L62		@
@ _src/SkillTester.c:74:     if (unitBWL) {
	cmp	r0, #0	@ unitBWL,
	beq	.L30		@,
@ _src/SkillTester.c:76:             if (!IsSkillIDValid(unitBWL->skills[i])) {
	subs	r0, r0, r4	@ tmp216, unitBWL, count
	adds	r2, r4, #4	@ _50, count,
	adds	r0, r0, #1	@ tmp217,
.L32:
	ldrb	r1, [r0, r4]	@ _10, MEM[(unsigned char *)_116 + _121 * 1]
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r1, #1	@ tmp218, _10,
@ _src/SkillTester.c:76:             if (!IsSkillIDValid(unitBWL->skills[i])) {
	lsls	r3, r3, #24	@ tmp221, tmp218,
	lsrs	r3, r3, #24	@ tmp221, tmp221,
	cmp	r3, #253	@ tmp221,
	bhi	.L31		@,
@ _src/SkillTester.c:79:             buffer->skills[count++] = unitBWL->skills[i];
	adds	r4, r4, #1	@ count,
@ _src/SkillTester.c:79:             buffer->skills[count++] = unitBWL->skills[i];
	strb	r1, [r5, r4]	@ _10, MEM[(unsigned char *)buffer_72(D) + _120 * 1]
@ _src/SkillTester.c:75:         for (int i = 0; i < 4; ++i) {
	cmp	r2, r4	@ _50, count
	bne	.L32		@,
.L31:
	movs	r3, r6	@ ivtmp.64, unit
	adds	r3, r3, #30	@ ivtmp.64,
	str	r3, [sp, #4]	@ ivtmp.64, %sfp
	adds	r3, r3, #10	@ _122,
	str	r3, [sp, #12]	@ _122, %sfp
.L37:
@ _src/SkillTester.c:95:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp, #4]	@ ivtmp.64, %sfp
	ldrh	r7, [r3]	@ _27, MEM[(short unsigned int *)_36]
@ _src/SkillTester.c:95:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	cmp	r7, #0	@ _27,
	beq	.L36		@,
@ _src/SkillTester.c:97:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L60+12	@ tmp236,
	movs	r0, r7	@, _27
	bl	.L62		@
@ _src/SkillTester.c:97:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L60+16	@ tmp237,
	ldr	r3, [r3]	@ PassiveSkillBit, PassiveSkillBit
@ _src/SkillTester.c:97:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	tst	r3, r0	@ PassiveSkillBit, tmp322
	beq	.L35		@,
@ _src/SkillTester.c:98:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r7, r7, #24	@ _21, _27,
	ldr	r3, .L60+20	@ tmp241,
	lsrs	r7, r7, #24	@ _21, _21,
	movs	r0, r7	@, _21
	str	r3, [sp, #8]	@ tmp241, %sfp
	bl	.L62		@
@ _src/SkillTester.c:98:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	adds	r0, r0, #4	@ tmp242,
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	ldrb	r3, [r0, #31]	@ tmp244,
	subs	r3, r3, #1	@ tmp245,
@ _src/SkillTester.c:98:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r3, r3, #24	@ tmp248, tmp245,
	lsrs	r3, r3, #24	@ tmp248, tmp248,
	cmp	r3, #253	@ tmp248,
	bhi	.L35		@,
@ _src/SkillTester.c:99:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldr	r3, [sp, #8]	@ tmp241, %sfp
	movs	r0, r7	@, _21
	bl	.L62		@
@ _src/SkillTester.c:99:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r0, r0, #4	@ tmp252,
@ _src/SkillTester.c:99:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldrb	r2, [r0, #31]	@ tmp253,
@ _src/SkillTester.c:99:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r3, r4, #1	@ count, count,
@ _src/SkillTester.c:99:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r4, r5, r4	@ tmp251, buffer, count
	strb	r2, [r4, #1]	@ tmp253, buffer_72(D)->skills[count_138]
@ _src/SkillTester.c:101:                 if (!gSkillTestConfig.passiveSkillStack) {
	ldr	r2, .L60+24	@ tmp255,
@ _src/SkillTester.c:101:                 if (!gSkillTestConfig.passiveSkillStack) {
	ldrb	r2, [r2, #3]	@ tmp256,
@ _src/SkillTester.c:99:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	movs	r4, r3	@ count, count
@ _src/SkillTester.c:101:                 if (!gSkillTestConfig.passiveSkillStack) {
	cmp	r2, #0	@ tmp256,
	beq	.L36		@,
.L35:
@ _src/SkillTester.c:95:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp, #4]	@ ivtmp.64, %sfp
	adds	r3, r3, #2	@ ivtmp.64,
	str	r3, [sp, #4]	@ ivtmp.64, %sfp
	ldr	r2, [sp, #4]	@ ivtmp.64, %sfp
	ldr	r3, [sp, #12]	@ _122, %sfp
	cmp	r3, r2	@ _122, ivtmp.64
	bne	.L37		@,
.L36:
@ _src/SkillTester.c:110:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r2, #11	@ _28,
@ _src/SkillTester.c:110:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp258,
@ _src/SkillTester.c:110:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldr	r3, .L60+28	@ tmp257,
@ _src/SkillTester.c:110:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r2, [r6, r2]	@ _28,* _28
@ _src/SkillTester.c:110:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp258,
	ldr	r7, .L60+20	@ tmp316,
	cmp	r1, r2	@ tmp258, _28
	bne	.L39		@,
@ _src/SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r1, .L60+32	@ tmp259,
@ _src/SkillTester.c:110:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrh	r1, [r1]	@ gBattleStats, gBattleStats
	lsls	r1, r1, #30	@ tmp329, gBattleStats,
	beq	.L39		@,
.L59:
@ _src/SkillTester.c:114:         temp = GetItemData(gBattleTarget.weaponBefore & 0xFF)->skill;
	adds	r3, r3, #74	@ tmp291,
@ _src/SkillTester.c:114:         temp = GetItemData(gBattleTarget.weaponBefore & 0xFF)->skill;
	ldrb	r0, [r3]	@ tmp295,
.L58:
@ _src/SkillTester.c:118:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	bl	.L63		@
@ _src/SkillTester.c:118:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	adds	r0, r0, #4	@ tmp303,
@ _src/SkillTester.c:118:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	ldrb	r3, [r0, #31]	@ temp,
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r2, r3, #1	@ tmp305, _45,
@ _src/SkillTester.c:122:     if (IsSkillIDValid(temp)) {
	lsls	r2, r2, #24	@ tmp308, tmp305,
	lsrs	r2, r2, #24	@ tmp308, tmp308,
	cmp	r2, #253	@ tmp308,
	bhi	.L42		@,
@ _src/SkillTester.c:123:         buffer->skills[count++] = temp;
	adds	r2, r5, r4	@ tmp310, buffer, count
	strb	r3, [r2, #1]	@ _45, buffer_72(D)->skills[count_53]
@ _src/SkillTester.c:123:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L42:
@ _src/SkillTester.c:127:     buffer->skills[count++] = 0;
	movs	r3, #0	@ tmp313,
@ _src/SkillTester.c:130: }
	movs	r0, r5	@, buffer
@ _src/SkillTester.c:127:     buffer->skills[count++] = 0;
	adds	r4, r5, r4	@ tmp312, buffer, count
	strb	r3, [r4, #1]	@ tmp313, buffer_72(D)->skills[count_54]
@ _src/SkillTester.c:130: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L30:
@ _src/SkillTester.c:85:         u8* tempBuffer = GetInitialSkillList_Pointer(unit, gTempSkillBuffer);
	ldr	r3, .L60+36	@ tmp225,
	movs	r0, r6	@, unit
	ldr	r3, [r3]	@ GetInitialSkillList_Pointer, GetInitialSkillList_Pointer
	ldr	r1, .L60+40	@ tmp224,
	bl	.L62		@
@ _src/SkillTester.c:86:         for (int i = 0; i < gSkillTestConfig.genericLearnedSkillLimit; ++i) {
	ldr	r3, .L60+24	@ tmp227,
	ldrb	r2, [r3, #2]	@ tmp228,
@ _src/SkillTester.c:87:             if (!IsSkillIDValid(tempBuffer[i])) {
	subs	r0, r0, r4	@ tmp317, tmp321, count
	adds	r2, r2, r4	@ _123, tmp228, count
.L33:
@ _src/SkillTester.c:86:         for (int i = 0; i < gSkillTestConfig.genericLearnedSkillLimit; ++i) {
	cmp	r4, r2	@ count, _123
	beq	.L31		@,
@ _src/SkillTester.c:87:             if (!IsSkillIDValid(tempBuffer[i])) {
	ldrb	r1, [r0, r4]	@ _14, MEM[(u8 *)_145 + _146 * 1]
@ _src/SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r1, #1	@ tmp230, _14,
@ _src/SkillTester.c:87:             if (!IsSkillIDValid(tempBuffer[i])) {
	lsls	r3, r3, #24	@ tmp233, tmp230,
	lsrs	r3, r3, #24	@ tmp233, tmp233,
	cmp	r3, #253	@ tmp233,
	bls	.LCB325	@
	b	.L31	@long jump	@
.LCB325:
@ _src/SkillTester.c:90:             buffer->skills[count++] = tempBuffer[i];
	adds	r4, r4, #1	@ count,
@ _src/SkillTester.c:90:             buffer->skills[count++] = tempBuffer[i];
	strb	r1, [r5, r4]	@ _14, MEM[(unsigned char *)buffer_72(D) + _63 * 1]
	b	.L33		@
.L39:
@ _src/SkillTester.c:113:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp279,
@ _src/SkillTester.c:113:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r3, .L60+44	@ tmp278,
@ _src/SkillTester.c:113:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp279,
	cmp	r1, r2	@ tmp279, _28
	bne	.L41		@,
@ _src/SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L60+32	@ tmp280,
@ _src/SkillTester.c:113:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
	lsls	r2, r2, #30	@ tmp330, gBattleStats,
	bne	.L59		@,
.L41:
@ _src/SkillTester.c:118:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	movs	r0, r6	@, unit
	ldr	r3, .L60+48	@ tmp299,
	bl	.L62		@
@ _src/SkillTester.c:118:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	lsls	r0, r0, #24	@ tmp300, tmp327,
	lsrs	r0, r0, #24	@ tmp300, tmp300,
	b	.L58		@
.L61:
	.align	2
.L60:
	.word	PersonalSkillTable
	.word	ClassSkillTable
	.word	BWL_GetEntry
	.word	GetItemAttributes
	.word	PassiveSkillBit
	.word	GetItemData
	.word	gSkillTestConfig
	.word	gBattleActor
	.word	gBattleStats
	.word	GetInitialSkillList_Pointer
	.word	gTempSkillBuffer
	.word	gBattleTarget
	.word	GetUnitEquippedWeapon
	.size	MakeSkillBuffer, .-MakeSkillBuffer
	.align	1
	.global	MakeAuraSkillBuffer
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	MakeAuraSkillBuffer, %function
MakeAuraSkillBuffer:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
@ _src/SkillTester.c:139:     for (int i = 0; i < 0x100; ++i) {
	movs	r6, #0	@ i,
@ _src/SkillTester.c:136:     int count = 0;
	movs	r4, r6	@ count, i
@ _src/SkillTester.c:133: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	sub	sp, sp, #28	@,,
@ _src/SkillTester.c:133: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	str	r0, [sp, #4]	@ tmp197, %sfp
@ _src/SkillTester.c:134:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r5, .L78	@ buffer,
.L70:
@ _src/SkillTester.c:140:         Unit* other = gUnitLookup[i];
	ldr	r2, .L78+4	@ tmp158,
	lsls	r3, r6, #2	@ tmp156, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _65 * 1]
@ _src/SkillTester.c:142:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ _src/SkillTester.c:142:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp198,
	beq	.L65		@,
@ _src/SkillTester.c:142:         if (!IsUnitOnField(other) || unit->index == i) {
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #11]	@ tmp161,
	lsls	r3, r3, #24	@ tmp161, tmp161,
	asrs	r3, r3, #24	@ tmp161, tmp161,
@ _src/SkillTester.c:142:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r3, r6	@ tmp161, i
	beq	.L65		@,
@ _src/SkillTester.c:147:         buffer = MakeSkillBuffer(other, buffer);
	movs	r1, r5	@, buffer
	movs	r0, r7	@, other
	bl	MakeSkillBuffer		@
@ _src/SkillTester.c:151:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L78+8	@ tmp162,
	ldrh	r3, [r3]	@ _8, gSkillTestConfig
	str	r3, [sp, #8]	@ _8, %sfp
@ _src/SkillTester.c:151:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L78+12	@ tmp193,
	str	r3, [sp, #16]	@ tmp193, %sfp
@ _src/SkillTester.c:152:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r3, .L78+16	@ tmp194,
	str	r3, [sp, #20]	@ tmp194, %sfp
@ _src/SkillTester.c:147:         buffer = MakeSkillBuffer(other, buffer);
	movs	r5, r0	@ buffer, tmp199
	adds	r0, r0, #1	@ ivtmp.97,
.L66:
@ _src/SkillTester.c:150:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	ldrb	r3, [r0]	@ _28, MEM[(unsigned char *)_68]
@ _src/SkillTester.c:150:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	cmp	r3, #0	@ _28,
	bne	.L69		@,
.L65:
@ _src/SkillTester.c:139:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp218,
@ _src/SkillTester.c:139:     for (int i = 0; i < 0x100; ++i) {
	adds	r6, r6, #1	@ i,
@ _src/SkillTester.c:139:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp218, tmp218,
	cmp	r6, r3	@ i, tmp218
	bne	.L70		@,
@ _src/SkillTester.c:171:     buffer->lastUnitChecked = 0;
	movs	r3, #0	@ tmp186,
@ _src/SkillTester.c:172:     gAuraSkillBuffer[count++].skillID = 0;
	ldr	r0, .L78+16	@ tmp188,
	lsls	r4, r4, #1	@ tmp189, count,
@ _src/SkillTester.c:171:     buffer->lastUnitChecked = 0;
	strb	r3, [r5]	@ tmp186, buffer_29->lastUnitChecked
@ _src/SkillTester.c:172:     gAuraSkillBuffer[count++].skillID = 0;
	strb	r3, [r4, r0]	@ tmp186, gAuraSkillBuffer[count_33].skillID
@ _src/SkillTester.c:175: }
	add	sp, sp, #28	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L69:
@ _src/SkillTester.c:151:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #16]	@ tmp193, %sfp
	ldrb	r2, [r2, r3]	@ tmp164, AuraSkillTable
	cmp	r2, #0	@ tmp164,
	beq	.L67		@,
@ _src/SkillTester.c:151:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #8]	@ _8, %sfp
	cmp	r2, r4	@ _8, count
	ble	.L67		@,
@ _src/SkillTester.c:152:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r2, [sp, #20]	@ tmp194, %sfp
	lsls	r1, r4, #1	@ tmp165, count,
	adds	r1, r1, r2	@ _11, tmp165, tmp194
@ _src/SkillTester.c:152:                 auraBuffer[count].skillID = buffer->skills[j];
	strb	r3, [r1]	@ _28, _11->skillID
@ _src/SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	movs	r3, #16	@ tmp169,
@ _src/SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #4]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp170,
@ _src/SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	ldrsb	r3, [r7, r3]	@ tmp169,
@ _src/SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	lsls	r2, r2, #24	@ tmp170, tmp170,
	asrs	r2, r2, #24	@ tmp170, tmp170,
@ _src/SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	subs	r2, r3, r2	@ tmp171, tmp169, tmp170
@ _src/SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r3, r2, #31	@ tmp201, tmp171,
	adds	r2, r2, r3	@ tmp172, tmp171, tmp201
	eors	r2, r3	@ tmp172, tmp201
@ _src/SkillTester.c:155:                            absolute(other->yPos - unit->yPos);
	movs	r3, #17	@ tmp173,
@ _src/SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	str	r2, [sp, #12]	@ tmp172, %sfp
@ _src/SkillTester.c:155:                            absolute(other->yPos - unit->yPos);
	ldrsb	r3, [r7, r3]	@ tmp173,
	mov	ip, r3	@ tmp173, tmp173
@ _src/SkillTester.c:155:                            absolute(other->yPos - unit->yPos);
	mov	r2, ip	@ tmp173, tmp173
@ _src/SkillTester.c:155:                            absolute(other->yPos - unit->yPos);
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #17]	@ tmp174,
	lsls	r3, r3, #24	@ tmp174, tmp174,
	asrs	r3, r3, #24	@ tmp174, tmp174,
@ _src/SkillTester.c:155:                            absolute(other->yPos - unit->yPos);
	subs	r3, r2, r3	@ tmp175, tmp173, tmp174
@ _src/SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r2, r3, #31	@ tmp202, tmp175,
	adds	r3, r3, r2	@ tmp176, tmp175, tmp202
	eors	r3, r2	@ tmp176, tmp202
@ _src/SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #12]	@ tmp172, %sfp
	adds	r3, r2, r3	@ distance, tmp172, tmp176
@ _src/SkillTester.c:162:                 auraBuffer[count].distance = distance;
	cmp	r3, #63	@ distance,
	ble	.L68		@,
	movs	r3, #63	@ distance,
.L68:
@ _src/SkillTester.c:164:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	movs	r2, #11	@ tmp177,
	ldrsb	r2, [r7, r2]	@ tmp177,
@ _src/SkillTester.c:164:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	asrs	r2, r2, #6	@ tmp178, tmp177,
@ _src/SkillTester.c:162:                 auraBuffer[count].distance = distance;
	lsls	r2, r2, #6	@ tmp180, tmp178,
	orrs	r3, r2	@ tmp183, tmp180
	strb	r3, [r1, #1]	@ tmp183, MEM <unsigned char> [(struct AuraSkillBuffer *)_11 + 1B]
@ _src/SkillTester.c:165:                 ++count;
	adds	r4, r4, #1	@ count,
.L67:
	adds	r0, r0, #1	@ ivtmp.97,
	b	.L66		@
.L79:
	.align	2
.L78:
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
	.fpu softvfp
	.type	CheckSkillBuffer, %function
CheckSkillBuffer:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, r0	@ unit, tmp127
	push	{r4, lr}	@
@ _src/SkillTester.c:180:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ _src/SkillTester.c:180:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L81		@,
@ _src/SkillTester.c:181:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
@ _src/SkillTester.c:181:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	beq	.L81		@,
@ _src/SkillTester.c:186:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	movs	r4, #11	@ tmp121,
	ldrsb	r4, [r3, r4]	@ tmp121,
@ _src/SkillTester.c:186:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldr	r3, .L86	@ tmp122,
	ldrb	r2, [r3]	@ gDefenderSkillBuffer, gDefenderSkillBuffer
@ _src/SkillTester.c:183:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r0, .L86+4	@ buffer,
@ _src/SkillTester.c:186:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	cmp	r4, r2	@ tmp121, gDefenderSkillBuffer
	bne	.L82		@,
@ _src/SkillTester.c:187:         buffer = &gDefenderSkillBuffer;
	movs	r0, r3	@ buffer, tmp122
.L82:
@ _src/SkillTester.c:190:     return IsSkillInBuffer(buffer, skillID);
	bl	IsSkillInBuffer		@
.L81:
@ _src/SkillTester.c:191: }
	@ sp needed	@
	pop	{r4}
	pop	{r1}
	bx	r1
.L87:
	.align	2
.L86:
	.word	gDefenderSkillBuffer
	.word	gAttackerSkillBuffer
	.size	CheckSkillBuffer, .-CheckSkillBuffer
	.align	1
	.global	SkillTester
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	SkillTester, %function
SkillTester:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ _src/SkillTester.c:195: bool SkillTester(Unit* unit, u8 skillID) {
	movs	r5, r0	@ unit, tmp145
	movs	r4, r1	@ skillID, tmp146
@ _src/SkillTester.c:196:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ _src/SkillTester.c:196:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L89		@,
@ _src/SkillTester.c:197:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	bne	.L90		@,
.L93:
@ _src/SkillTester.c:197:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
.L89:
@ _src/SkillTester.c:220: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L90:
@ _src/SkillTester.c:199:     int index = unit->index;
	movs	r3, #11	@ index,
@ _src/SkillTester.c:205:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r2, .L102	@ tmp126,
@ _src/SkillTester.c:205:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrb	r2, [r2, #11]	@ tmp127,
@ _src/SkillTester.c:199:     int index = unit->index;
	ldrsb	r3, [r5, r3]	@ index,* index
@ _src/SkillTester.c:205:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #24	@ tmp127, tmp127,
@ _src/SkillTester.c:202:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r6, .L102+4	@ buffer,
@ _src/SkillTester.c:205:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	asrs	r2, r2, #24	@ tmp127, tmp127,
	cmp	r2, r3	@ tmp127, index
	bne	.L91		@,
@ _src/SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L102+8	@ tmp128,
@ _src/SkillTester.c:205:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
	lsls	r2, r2, #30	@ tmp149, gBattleStats,
	beq	.L91		@,
@ _src/SkillTester.c:206:         buffer = &gDefenderSkillBuffer;
	ldr	r6, .L102+12	@ buffer,
.L91:
@ _src/SkillTester.c:209:     if (index != buffer->lastUnitChecked) {
	ldrb	r2, [r6]	@ *buffer_9, *buffer_9
@ _src/SkillTester.c:209:     if (index != buffer->lastUnitChecked) {
	cmp	r2, r3	@ *buffer_9, index
	beq	.L92		@,
@ _src/SkillTester.c:210:         MakeSkillBuffer(unit, buffer);
	movs	r1, r6	@, buffer
	movs	r0, r5	@, unit
	bl	MakeSkillBuffer		@
.L92:
@ _src/SkillTester.c:214:     if (IsSkillInBuffer(buffer, skillID)) {
	movs	r1, r4	@, skillID
	movs	r0, r6	@, buffer
	bl	IsSkillInBuffer		@
@ _src/SkillTester.c:214:     if (IsSkillInBuffer(buffer, skillID)) {
	cmp	r0, #0	@ tmp147,
	beq	.L93		@,
@ _src/SkillTester.c:216:         return !NihilTester(unit, skillID);
	movs	r1, r4	@, skillID
	movs	r0, r5	@, unit
	bl	NihilTester		@
@ _src/SkillTester.c:216:         return !NihilTester(unit, skillID);
	movs	r3, #1	@ tmp142,
	eors	r0, r3	@ tmp141, tmp142
	lsls	r0, r0, #24	@ <retval>, tmp141,
	lsrs	r0, r0, #24	@ <retval>, <retval>,
@ _src/SkillTester.c:216:         return !NihilTester(unit, skillID);
	b	.L89		@
.L103:
	.align	2
.L102:
	.word	gBattleTarget
	.word	gAttackerSkillBuffer
	.word	gBattleStats
	.word	gDefenderSkillBuffer
	.size	SkillTester, .-SkillTester
	.align	1
	.global	NewAuraSkillCheck
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	NewAuraSkillCheck, %function
NewAuraSkillCheck:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, lr}	@
@ _src/SkillTester.c:223: bool NewAuraSkillCheck(Unit* unit, u8 skillID, int allyOption, int maxRange) {
	movs	r4, r1	@ skillID, tmp162
	movs	r5, r2	@ allyOption, tmp163
	str	r0, [sp]	@ tmp161, %sfp
	str	r3, [sp, #4]	@ tmp164, %sfp
@ _src/SkillTester.c:224:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r7, .L124	@ iftmp.16_19,
	lsls	r3, r2, #31	@ tmp167, allyOption,
	bmi	.L105		@,
	ldr	r7, .L124+4	@ iftmp.16_19,
.L105:
@ _src/SkillTester.c:226:     if (skillID == 0)   {return TRUE;}
	cmp	r4, #0	@ skillID,
	bne	.L106		@,
.L113:
@ _src/SkillTester.c:226:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
.L107:
@ _src/SkillTester.c:245: }
	@ sp needed	@
	pop	{r1, r2, r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L106:
	ldr	r6, .L124+8	@ ivtmp.116,
@ _src/SkillTester.c:227:     if (skillID == 255) {return FALSE;}
	cmp	r4, #255	@ skillID,
	bne	.L109		@,
.L108:
@ _src/SkillTester.c:227:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
	b	.L107		@
.L115:
@ _src/SkillTester.c:231:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldrb	r1, [r6, #1]	@ *_15, *_15
@ _src/SkillTester.c:231:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldr	r0, [sp, #4]	@ maxRange, %sfp
@ _src/SkillTester.c:231:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	lsls	r3, r1, #26	@ tmp140, *_15,
	lsrs	r3, r3, #26	@ tmp141, tmp140,
@ _src/SkillTester.c:231:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r3, r0	@ tmp141, maxRange
	ble	.L110		@,
.L111:
	adds	r6, r6, #2	@ ivtmp.116,
.L109:
@ _src/SkillTester.c:230:     for (int i = 0; auraBuffer[i].skillID; ++i) {
	ldrb	r2, [r6]	@ _16, MEM[(unsigned char *)_15]
@ _src/SkillTester.c:230:     for (int i = 0; auraBuffer[i].skillID; ++i) {
	cmp	r2, #0	@ _16,
	bne	.L115		@,
	b	.L108		@
.L110:
@ _src/SkillTester.c:231:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r2, r4	@ _16, skillID
	bne	.L111		@,
@ _src/SkillTester.c:234:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	movs	r0, #11	@ tmp151,
	ldr	r3, [sp]	@ unit, %sfp
@ _src/SkillTester.c:234:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	lsrs	r1, r1, #6	@ tmp148, *_15,
@ _src/SkillTester.c:234:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	ldrsb	r0, [r3, r0]	@ tmp151,
	lsls	r1, r1, #6	@ tmp150, tmp148,
	bl	.L63		@
@ _src/SkillTester.c:236:             if (allyOption & 2)
	movs	r3, #2	@ tmp171,
	tst	r5, r3	@ allyOption, tmp171
	beq	.L112		@,
@ _src/SkillTester.c:239:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp152,
	beq	.L113		@,
.L114:
@ _src/SkillTester.c:239:             if (check || (allyOption & 4))
	movs	r3, #4	@ tmp172,
	tst	r5, r3	@ allyOption, tmp172
	beq	.L111		@,
	b	.L113		@
.L112:
@ _src/SkillTester.c:239:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp152,
	beq	.L114		@,
	b	.L113		@
.L125:
	.align	2
.L124:
	.word	AreAllegiancesAllied
	.word	AreAllegiancesEqual
	.word	gAuraSkillBuffer
	.size	NewAuraSkillCheck, .-NewAuraSkillCheck
	.align	1
	.global	InitializePreBattleLoop
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	InitializePreBattleLoop, %function
InitializePreBattleLoop:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ _src/SkillTester.c:248: void InitializePreBattleLoop(Unit* attacker, Unit* defender) {
	movs	r4, r0	@ attacker, tmp131
@ _src/SkillTester.c:249:     MakeAuraSkillBuffer(attacker);
	bl	MakeAuraSkillBuffer		@
@ _src/SkillTester.c:250:     MakeSkillBuffer(attacker, &gAttackerSkillBuffer);
	ldr	r1, .L132	@ tmp117,
	movs	r0, r4	@, attacker
	bl	MakeSkillBuffer		@
@ _src/SkillTester.c:251:     gDefenderSkillBuffer.lastUnitChecked = 0;
	movs	r3, #0	@ tmp119,
	ldr	r1, .L132+4	@ tmp118,
	strb	r3, [r1]	@ tmp119, gDefenderSkillBuffer.lastUnitChecked
@ _src/SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r3, .L132+8	@ tmp121,
@ _src/SkillTester.c:253:     if (IsBattleReal()) {
	ldrh	r3, [r3]	@ gBattleStats, gBattleStats
	lsls	r3, r3, #30	@ tmp132, gBattleStats,
	beq	.L126		@,
@ _src/SkillTester.c:254:         MakeSkillBuffer(&gBattleTarget.unit, &gDefenderSkillBuffer);
	ldr	r0, .L132+12	@ tmp130,
	bl	MakeSkillBuffer		@
.L126:
@ _src/SkillTester.c:256: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
.L133:
	.align	2
.L132:
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
	.fpu softvfp
	.type	InitSkillBuffers, %function
InitSkillBuffers:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ _src/SkillTester.c:260:     gAttackerSkillBuffer.lastUnitChecked = 0;
	movs	r2, #0	@ tmp114,
@ _src/SkillTester.c:262: }
	@ sp needed	@
@ _src/SkillTester.c:260:     gAttackerSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L135	@ tmp113,
	strb	r2, [r3]	@ tmp114, gAttackerSkillBuffer.lastUnitChecked
@ _src/SkillTester.c:261:     gDefenderSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L135+4	@ tmp116,
	strb	r2, [r3]	@ tmp114, gDefenderSkillBuffer.lastUnitChecked
@ _src/SkillTester.c:262: }
	bx	lr
.L136:
	.align	2
.L135:
	.word	gAttackerSkillBuffer
	.word	gDefenderSkillBuffer
	.size	InitSkillBuffers, .-InitSkillBuffers
	.align	1
	.global	GetUnitsInRange
	.syntax unified
	.code	16
	.thumb_func
	.fpu softvfp
	.type	GetUnitsInRange, %function
GetUnitsInRange:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
@ _src/SkillTester.c:266:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L159	@ iftmp.21_32,
@ _src/SkillTester.c:265: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	sub	sp, sp, #20	@,,
@ _src/SkillTester.c:265: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	movs	r5, r1	@ allyOption, tmp190
	str	r0, [sp, #8]	@ tmp189, %sfp
	str	r2, [sp, #12]	@ tmp191, %sfp
@ _src/SkillTester.c:266:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	str	r3, [sp, #4]	@ iftmp.21_32, %sfp
	lsls	r3, r1, #31	@ tmp197, allyOption,
	bmi	.L138		@,
	ldr	r3, .L159+4	@ iftmp.21_32,
	str	r3, [sp, #4]	@ iftmp.21_32, %sfp
.L138:
@ _src/SkillTester.c:271:     for (int i = 0; i < 0x100; ++i) {
	movs	r4, #0	@ i,
@ _src/SkillTester.c:268:     int count = 0;
	movs	r6, r4	@ count, i
.L144:
@ _src/SkillTester.c:272:         Unit* other = gUnitLookup[i];
	ldr	r2, .L159+8	@ tmp153,
	lsls	r3, r4, #2	@ tmp151, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _74 * 1]
@ _src/SkillTester.c:274:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ _src/SkillTester.c:274:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp192,
	beq	.L139		@,
@ _src/SkillTester.c:274:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, #11	@ _4,
	ldr	r3, [sp, #8]	@ unit, %sfp
	ldrsb	r0, [r3, r0]	@ _4,* _4
@ _src/SkillTester.c:274:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, r4	@ _4, i
	beq	.L139		@,
@ _src/SkillTester.c:280:             check = !pAllegianceChecker(unit->index, other->index);
	movs	r1, #11	@ _29,
@ _src/SkillTester.c:279:         if (allyOption & 2) {
	movs	r3, #2	@ tmp206,
@ _src/SkillTester.c:280:             check = !pAllegianceChecker(unit->index, other->index);
	ldrsb	r1, [r7, r1]	@ _29,* _29
@ _src/SkillTester.c:279:         if (allyOption & 2) {
	tst	r5, r3	@ allyOption, tmp206
	beq	.L140		@,
@ _src/SkillTester.c:280:             check = !pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.21_32, %sfp
	bl	.L62		@
@ _src/SkillTester.c:286:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp193,
	beq	.L141		@,
.L143:
@ _src/SkillTester.c:286:         if (check || (allyOption & 4)) {
	movs	r3, #4	@ tmp208,
	tst	r5, r3	@ allyOption, tmp208
	beq	.L139		@,
.L141:
@ _src/SkillTester.c:287:             if ((absolute(other->xPos - unit->xPos)
	movs	r3, #16	@ tmp162,
@ _src/SkillTester.c:287:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #8]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp163,
@ _src/SkillTester.c:287:             if ((absolute(other->xPos - unit->xPos)
	ldrsb	r3, [r7, r3]	@ tmp162,
@ _src/SkillTester.c:287:             if ((absolute(other->xPos - unit->xPos)
	lsls	r2, r2, #24	@ tmp163, tmp163,
	asrs	r2, r2, #24	@ tmp163, tmp163,
@ _src/SkillTester.c:287:             if ((absolute(other->xPos - unit->xPos)
	subs	r2, r3, r2	@ tmp164, tmp162, tmp163
@ _src/SkillTester.c:288:                + absolute(other->yPos - unit->yPos)) <= range) {
	movs	r3, #17	@ tmp166,
@ _src/SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r2, #31	@ tmp198, tmp164,
	adds	r2, r2, r1	@ tmp165, tmp164, tmp198
	eors	r2, r1	@ tmp165, tmp198
@ _src/SkillTester.c:288:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldr	r1, [sp, #8]	@ unit, %sfp
	ldrb	r1, [r1, #17]	@ tmp167,
@ _src/SkillTester.c:288:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldrsb	r3, [r7, r3]	@ tmp166,
@ _src/SkillTester.c:288:                + absolute(other->yPos - unit->yPos)) <= range) {
	lsls	r1, r1, #24	@ tmp167, tmp167,
	asrs	r1, r1, #24	@ tmp167, tmp167,
@ _src/SkillTester.c:288:                + absolute(other->yPos - unit->yPos)) <= range) {
	subs	r3, r3, r1	@ tmp168, tmp166, tmp167
@ _src/SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r3, #31	@ tmp199, tmp168,
	adds	r3, r3, r1	@ tmp169, tmp168, tmp199
	eors	r3, r1	@ tmp169, tmp199
@ _src/SkillTester.c:288:                + absolute(other->yPos - unit->yPos)) <= range) {
	adds	r3, r2, r3	@ tmp170, tmp165, tmp169
@ _src/SkillTester.c:287:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #12]	@ range, %sfp
	cmp	r3, r2	@ tmp170, range
	ble	.L142		@,
.L139:
@ _src/SkillTester.c:271:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp175,
@ _src/SkillTester.c:271:     for (int i = 0; i < 0x100; ++i) {
	adds	r4, r4, #1	@ i,
@ _src/SkillTester.c:271:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp175, tmp175,
	cmp	r4, r3	@ i, tmp175
	bne	.L144		@,
@ _src/SkillTester.c:295:     gUnitRangeBuffer[count++] = 0;
	movs	r3, #0	@ tmp177,
	ldr	r0, .L159+12	@ tmp176,
	strb	r3, [r0, r6]	@ tmp177, gUnitRangeBuffer[count_28]
@ _src/SkillTester.c:296:     if (!gUnitRangeBuffer[0])
	ldrb	r3, [r0]	@ gUnitRangeBuffer, gUnitRangeBuffer
@ _src/SkillTester.c:297:         return FALSE;
	subs	r2, r3, #1	@ tmp185, gUnitRangeBuffer
	sbcs	r3, r3, r2	@ tmp184, gUnitRangeBuffer, tmp185
	rsbs	r3, r3, #0	@ tmp186, tmp184
	ands	r0, r3	@ <retval>, tmp186
@ _src/SkillTester.c:300: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L140:
@ _src/SkillTester.c:283:             check =  pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.21_32, %sfp
	bl	.L62		@
@ _src/SkillTester.c:286:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp194,
	bne	.L141		@,
	b	.L143		@
.L142:
@ _src/SkillTester.c:289:                 gUnitRangeBuffer[count++] = i;
	ldr	r3, .L159+12	@ tmp173,
	strb	r4, [r3, r6]	@ i, gUnitRangeBuffer[count_71]
@ _src/SkillTester.c:289:                 gUnitRangeBuffer[count++] = i;
	adds	r6, r6, #1	@ count,
	b	.L139		@
.L160:
	.align	2
.L159:
	.word	AreAllegiancesAllied
	.word	AreAllegiancesEqual
	.word	gUnitLookup
	.word	gUnitRangeBuffer
	.size	GetUnitsInRange, .-GetUnitsInRange
	.ident	"GCC: (devkitARM release 56) 11.1.0"
	.code 16
	.align	1
.L62:
	bx	r3
.L63:
	bx	r7
