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
	.global	IsSkillInBuffer
	.syntax unified
	.code	16
	.thumb_func
	.type	IsSkillInBuffer, %function
IsSkillInBuffer:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	adds	r0, r0, #1	@ ivtmp.47,
.L12:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:27:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	ldrb	r3, [r0]	@ _1, MEM[(unsigned char *)_12]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:27:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	cmp	r3, #0	@ _1,
	bne	.L14		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:32:     return FALSE;
	movs	r0, r3	@ <retval>, _1
.L13:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:33: }
	@ sp needed	@
	bx	lr
.L14:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:28:         if (buffer->skills[i] == skillID) {
	adds	r0, r0, #1	@ ivtmp.47,
	cmp	r3, r1	@ _1, skillID
	bne	.L12		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:29:             return TRUE;
	movs	r0, #1	@ <retval>,
	b	.L13		@
	.size	IsSkillInBuffer, .-IsSkillInBuffer
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
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldr	r3, .L25	@ tmp125,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldrh	r3, [r3]	@ gBattleStats, gBattleStats
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:37: bool NihilTester(Unit* unit, u8 skillID) {
	movs	r2, r0	@ unit, tmp143
	push	{r4, lr}	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:49:     return FALSE;
	movs	r0, #0	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	lsls	r3, r3, #30	@ tmp148, gBattleStats,
	beq	.L17		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldr	r3, .L25+4	@ tmp133,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldrb	r3, [r3, r1]	@ tmp134, NegatedSkills
	cmp	r3, r0	@ tmp134,
	beq	.L17		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:43:         if (unit->index == gBattleTarget.unit.index) {
	ldr	r3, .L25+8	@ tmp135,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:43:         if (unit->index == gBattleTarget.unit.index) {
	ldrb	r2, [r2, #11]	@ MEM[(signed char *)unit_9(D) + 11B], MEM[(signed char *)unit_9(D) + 11B]
	ldrb	r3, [r3, #11]	@ tmp137,
	lsls	r2, r2, #24	@ MEM[(signed char *)unit_9(D) + 11B], MEM[(signed char *)unit_9(D) + 11B],
	lsls	r3, r3, #24	@ tmp137, tmp137,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:44:             buffer = &gAttackerSkillBuffer;
	ldr	r0, .L25+12	@ buffer,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:43:         if (unit->index == gBattleTarget.unit.index) {
	asrs	r2, r2, #24	@ MEM[(signed char *)unit_9(D) + 11B], MEM[(signed char *)unit_9(D) + 11B],
	asrs	r3, r3, #24	@ tmp137, tmp137,
	cmp	r2, r3	@ MEM[(signed char *)unit_9(D) + 11B], tmp137
	beq	.L18		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:40:         SkillBuffer* buffer = &gDefenderSkillBuffer;
	ldr	r0, .L25+16	@ buffer,
.L18:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:47:         return IsSkillInBuffer(buffer, NihilIDLink);
	ldr	r3, .L25+20	@ tmp138,
	ldrb	r1, [r3]	@ NihilIDLink, NihilIDLink
	bl	IsSkillInBuffer		@
.L17:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:50: }
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
	.word	gAttackerSkillBuffer
	.word	gDefenderSkillBuffer
	.word	NihilIDLink
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
	movs	r6, r0	@ unit, tmp319
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:55:     int unitNum = unit->pCharacterData->number;
	ldr	r3, [r0]	@ unit_68(D)->pCharacterData, unit_68(D)->pCharacterData
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:55:     int unitNum = unit->pCharacterData->number;
	ldrb	r0, [r3, #4]	@ unitNum,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:57:     buffer->lastUnitChecked = unit->index;
	ldrb	r3, [r6, #11]	@ tmp196,
	strb	r3, [r1]	@ tmp196, buffer_70(D)->lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:60:     temp = PersonalSkillTable[unitNum];
	ldr	r3, .L61	@ tmp198,
	ldrb	r2, [r3, r0]	@ _5, PersonalSkillTable
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp199, _5,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:61:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp202, tmp199,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:54: SkillBuffer* MakeSkillBuffer(Unit* unit, SkillBuffer* buffer) {
	movs	r5, r1	@ buffer, tmp320
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:56:     int count = 0, temp = 0;
	movs	r4, #0	@ count,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:54: SkillBuffer* MakeSkillBuffer(Unit* unit, SkillBuffer* buffer) {
	sub	sp, sp, #20	@,,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:61:     if (IsSkillIDValid(temp)) {
	lsrs	r3, r3, #24	@ tmp202, tmp202,
	cmp	r3, #253	@ tmp202,
	bhi	.L28		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:62:         buffer->skills[count++] = temp;
	strb	r2, [r1, #1]	@ _5, buffer_70(D)->skills[0]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:62:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L28:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:66:     temp = ClassSkillTable[unit->pClassData->number];
	ldr	r2, [r6, #4]	@ unit_68(D)->pClassData, unit_68(D)->pClassData
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:66:     temp = ClassSkillTable[unit->pClassData->number];
	ldr	r3, .L61+4	@ tmp205,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:66:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r2, [r2, #4]	@ tmp207,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:66:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r2, [r3, r2]	@ _9, ClassSkillTable
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp208, _9,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:67:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp211, tmp208,
	lsrs	r3, r3, #24	@ tmp211, tmp211,
	cmp	r3, #253	@ tmp211,
	bhi	.L29		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:68:         buffer->skills[count++] = temp;
	adds	r3, r5, r4	@ tmp213, buffer, count
	strb	r2, [r3, #1]	@ _9, buffer_70(D)->skills[count_46]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:68:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L29:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:73:     BWLData* unitBWL = BWL_GetEntry(unitNum);
	ldr	r3, .L61+8	@ tmp215,
	bl	.L63		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:74:     if (unitBWL) {
	cmp	r0, #0	@ unitBWL,
	beq	.L30		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:76:             if (!IsSkillIDValid(unitBWL->skills[i])) {
	subs	r0, r0, r4	@ tmp217, unitBWL, count
	adds	r2, r4, #4	@ _145, count,
	adds	r0, r0, #1	@ tmp218,
.L32:
	ldrb	r1, [r0, r4]	@ _10, MEM[(unsigned char *)_141 + _140 * 1]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r1, #1	@ tmp219, _10,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:76:             if (!IsSkillIDValid(unitBWL->skills[i])) {
	lsls	r3, r3, #24	@ tmp222, tmp219,
	lsrs	r3, r3, #24	@ tmp222, tmp222,
	cmp	r3, #253	@ tmp222,
	bhi	.L31		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:79:             buffer->skills[count++] = unitBWL->skills[i];
	adds	r4, r4, #1	@ count,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:79:             buffer->skills[count++] = unitBWL->skills[i];
	strb	r1, [r5, r4]	@ _10, MEM[(unsigned char *)buffer_70(D) + _142 * 1]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:75:         for (int i = 0; i < 4; ++i) {
	cmp	r4, r2	@ count, _145
	bne	.L32		@,
.L31:
	movs	r3, r6	@ ivtmp.66, unit
	adds	r3, r3, #30	@ ivtmp.66,
	str	r3, [sp, #4]	@ ivtmp.66, %sfp
	adds	r3, r3, #10	@ _136,
	str	r3, [sp, #12]	@ _136, %sfp
.L33:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:92:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp, #4]	@ ivtmp.66, %sfp
	ldrh	r7, [r3]	@ _27, MEM[(short unsigned int *)_134]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:92:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	cmp	r7, #0	@ _27,
	beq	.L39		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:94:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L61+12	@ tmp237,
	movs	r0, r7	@, _27
	bl	.L63		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:94:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L61+16	@ tmp238,
	ldr	r3, [r3]	@ PassiveSkillBit, PassiveSkillBit
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:94:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	tst	r3, r0	@ PassiveSkillBit, tmp323
	beq	.L38		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r7, r7, #24	@ _21, _27,
	ldr	r3, .L61+20	@ tmp242,
	lsrs	r7, r7, #24	@ _21, _21,
	movs	r0, r7	@, _21
	str	r3, [sp, #8]	@ tmp242, %sfp
	bl	.L63		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	adds	r0, r0, #4	@ tmp243,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	ldrb	r3, [r0, #31]	@ tmp245,
	subs	r3, r3, #1	@ tmp246,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r3, r3, #24	@ tmp249, tmp246,
	lsrs	r3, r3, #24	@ tmp249, tmp249,
	cmp	r3, #253	@ tmp249,
	bhi	.L38		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:96:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldr	r3, [sp, #8]	@ tmp242, %sfp
	movs	r0, r7	@, _21
	bl	.L63		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:96:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r0, r0, #4	@ tmp253,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:96:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldrb	r2, [r0, #31]	@ tmp254,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:96:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r3, r4, #1	@ count, count,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:96:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r4, r5, r4	@ tmp252, buffer, count
	strb	r2, [r4, #1]	@ tmp254, buffer_70(D)->skills[count_119]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:98:                 if (!gSkillTestConfig.passiveSkillStack) {
	ldr	r2, .L61+24	@ tmp256,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:98:                 if (!gSkillTestConfig.passiveSkillStack) {
	ldrb	r2, [r2, #3]	@ tmp257,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:96:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	movs	r4, r3	@ count, count
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:98:                 if (!gSkillTestConfig.passiveSkillStack) {
	cmp	r2, #0	@ tmp257,
	beq	.L39		@,
.L38:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:92:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp, #4]	@ ivtmp.66, %sfp
	ldr	r2, [sp, #12]	@ _136, %sfp
	adds	r3, r3, #2	@ ivtmp.66,
	str	r3, [sp, #4]	@ ivtmp.66, %sfp
	cmp	r3, r2	@ ivtmp.66, _136
	bne	.L33		@,
.L39:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:107:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r2, #11	@ _28,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:107:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp259,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:107:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldr	r3, .L61+28	@ tmp258,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:107:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r2, [r6, r2]	@ _28,* _28
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:107:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp259,
	ldr	r7, .L61+20	@ tmp317,
	cmp	r1, r2	@ tmp259, _28
	bne	.L41		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r1, .L61+32	@ tmp260,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:107:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrh	r1, [r1]	@ gBattleStats, gBattleStats
	lsls	r1, r1, #30	@ tmp330, gBattleStats,
	beq	.L41		@,
.L60:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:111:         temp = GetItemData(gBattleTarget.weaponBefore & 0xFF)->skill;
	adds	r3, r3, #74	@ tmp292,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:111:         temp = GetItemData(gBattleTarget.weaponBefore & 0xFF)->skill;
	ldrb	r0, [r3]	@ tmp296,
.L59:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:115:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	bl	.L64		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:115:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	adds	r0, r0, #4	@ tmp304,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:115:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	ldrb	r3, [r0, #31]	@ temp,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r2, r3, #1	@ tmp306, _45,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:119:     if (IsSkillIDValid(temp)) {
	lsls	r2, r2, #24	@ tmp309, tmp306,
	lsrs	r2, r2, #24	@ tmp309, tmp309,
	cmp	r2, #253	@ tmp309,
	bhi	.L44		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:120:         buffer->skills[count++] = temp;
	adds	r2, r5, r4	@ tmp311, buffer, count
	strb	r3, [r2, #1]	@ _45, buffer_70(D)->skills[count_52]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:120:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L44:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:124:     buffer->skills[count++] = 0;
	movs	r3, #0	@ tmp314,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:127: }
	movs	r0, r5	@, buffer
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:124:     buffer->skills[count++] = 0;
	adds	r4, r5, r4	@ tmp313, buffer, count
	strb	r3, [r4, #1]	@ tmp314, buffer_70(D)->skills[count_53]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:127: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L30:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:82:         u8* tempBuffer = GetInitialSkillList_Pointer(unit, gTempSkillBuffer);
	ldr	r3, .L61+36	@ tmp226,
	movs	r0, r6	@, unit
	ldr	r3, [r3]	@ GetInitialSkillList_Pointer, GetInitialSkillList_Pointer
	ldr	r1, .L61+40	@ tmp225,
	bl	.L63		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:83:         for (int i = 0; i < gSkillTestConfig.genericLearnedSkillLimit; ++i) {
	ldr	r3, .L61+24	@ tmp228,
	ldrb	r2, [r3, #2]	@ tmp229,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:84:             if (!IsSkillIDValid(tempBuffer[i])) {
	subs	r0, r0, r4	@ tmp318, tmp322, count
	adds	r2, r2, r4	@ _149, tmp229, count
.L34:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:83:         for (int i = 0; i < gSkillTestConfig.genericLearnedSkillLimit; ++i) {
	cmp	r4, r2	@ count, _149
	beq	.L31		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:84:             if (!IsSkillIDValid(tempBuffer[i])) {
	ldrb	r1, [r0, r4]	@ _14, MEM[(u8 *)_153 + _154 * 1]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r1, #1	@ tmp231, _14,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:84:             if (!IsSkillIDValid(tempBuffer[i])) {
	lsls	r3, r3, #24	@ tmp234, tmp231,
	lsrs	r3, r3, #24	@ tmp234, tmp234,
	cmp	r3, #253	@ tmp234,
	bls	.LCB324	@
	b	.L31	@long jump	@
.LCB324:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:87:             buffer->skills[count++] = tempBuffer[i];
	adds	r4, r4, #1	@ count,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:87:             buffer->skills[count++] = tempBuffer[i];
	strb	r1, [r5, r4]	@ _14, MEM[(unsigned char *)buffer_70(D) + _150 * 1]
	b	.L34		@
.L41:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:110:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp280,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:110:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r3, .L61+44	@ tmp279,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:110:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp280,
	cmp	r1, r2	@ tmp280, _28
	bne	.L43		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L61+32	@ tmp281,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:110:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
	lsls	r2, r2, #30	@ tmp331, gBattleStats,
	bne	.L60		@,
.L43:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:115:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	movs	r0, r6	@, unit
	ldr	r3, .L61+48	@ tmp300,
	bl	.L63		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:115:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	lsls	r0, r0, #24	@ tmp301, tmp328,
	lsrs	r0, r0, #24	@ tmp301, tmp301,
	b	.L59		@
.L62:
	.align	2
.L61:
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
	.type	MakeAuraSkillBuffer, %function
MakeAuraSkillBuffer:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:136:     for (int i = 0; i < 0x100; ++i) {
	movs	r6, #0	@ i,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:133:     int count = 0;
	movs	r4, r6	@ count, i
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	sub	sp, sp, #28	@,,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	str	r0, [sp, #4]	@ tmp198, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:131:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r5, .L79	@ buffer,
.L71:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:137:         Unit* other = gUnitLookup[i];
	ldr	r2, .L79+4	@ tmp159,
	lsls	r3, r6, #2	@ tmp157, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _71 * 1]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp199,
	beq	.L66		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:         if (!IsUnitOnField(other) || unit->index == i) {
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #11]	@ tmp162,
	lsls	r3, r3, #24	@ tmp162, tmp162,
	asrs	r3, r3, #24	@ tmp162, tmp162,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r3, r6	@ tmp162, i
	beq	.L66		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:144:         buffer = MakeSkillBuffer(other, buffer);
	movs	r1, r5	@, buffer
	movs	r0, r7	@, other
	bl	MakeSkillBuffer		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:148:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L79+8	@ tmp163,
	ldrh	r3, [r3]	@ _8, gSkillTestConfig
	str	r3, [sp, #8]	@ _8, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:148:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L79+12	@ tmp194,
	str	r3, [sp, #16]	@ tmp194, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:149:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r3, .L79+16	@ tmp195,
	str	r3, [sp, #20]	@ tmp195, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:144:         buffer = MakeSkillBuffer(other, buffer);
	movs	r5, r0	@ buffer, tmp200
	adds	r0, r0, #1	@ ivtmp.100,
.L67:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:147:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	ldrb	r3, [r0]	@ _29, MEM[(unsigned char *)_69]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:147:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	cmp	r3, #0	@ _29,
	bne	.L70		@,
.L66:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:136:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp219,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:136:     for (int i = 0; i < 0x100; ++i) {
	adds	r6, r6, #1	@ i,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:136:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp219, tmp219,
	cmp	r6, r3	@ i, tmp219
	bne	.L71		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:168:     buffer->lastUnitChecked = 0;
	movs	r3, #0	@ tmp187,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:169:     gAuraSkillBuffer[count++].skillID = 0;
	ldr	r0, .L79+16	@ tmp189,
	lsls	r4, r4, #1	@ tmp190, count,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:168:     buffer->lastUnitChecked = 0;
	strb	r3, [r5]	@ tmp187, buffer_30->lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:169:     gAuraSkillBuffer[count++].skillID = 0;
	strb	r3, [r4, r0]	@ tmp187, gAuraSkillBuffer[count_34].skillID
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:172: }
	add	sp, sp, #28	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L70:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:148:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #16]	@ tmp194, %sfp
	ldrb	r2, [r2, r3]	@ tmp165, AuraSkillTable
	cmp	r2, #0	@ tmp165,
	beq	.L68		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:148:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #8]	@ _8, %sfp
	cmp	r2, r4	@ _8, count
	ble	.L68		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:149:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r2, [sp, #20]	@ tmp195, %sfp
	lsls	r1, r4, #1	@ tmp166, count,
	adds	r1, r1, r2	@ _11, tmp166, tmp195
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:149:                 auraBuffer[count].skillID = buffer->skills[j];
	strb	r3, [r1]	@ _29, _11->skillID
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:                 distance = absolute(other->xPos - unit->xPos) +
	movs	r3, #16	@ tmp170,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #4]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp171,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:                 distance = absolute(other->xPos - unit->xPos) +
	ldrsb	r3, [r7, r3]	@ tmp170,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:                 distance = absolute(other->xPos - unit->xPos) +
	lsls	r2, r2, #24	@ tmp171, tmp171,
	asrs	r2, r2, #24	@ tmp171, tmp171,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:                 distance = absolute(other->xPos - unit->xPos) +
	subs	r2, r3, r2	@ tmp172, tmp170, tmp171
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r3, r2, #31	@ tmp202, tmp172,
	adds	r2, r2, r3	@ tmp173, tmp172, tmp202
	eors	r2, r3	@ tmp173, tmp202
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:                            absolute(other->yPos - unit->yPos);
	movs	r3, #17	@ tmp174,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	str	r2, [sp, #12]	@ tmp173, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:                            absolute(other->yPos - unit->yPos);
	ldrsb	r3, [r7, r3]	@ tmp174,
	mov	ip, r3	@ tmp174, tmp174
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:                            absolute(other->yPos - unit->yPos);
	mov	r2, ip	@ tmp174, tmp174
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:                            absolute(other->yPos - unit->yPos);
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #17]	@ tmp175,
	lsls	r3, r3, #24	@ tmp175, tmp175,
	asrs	r3, r3, #24	@ tmp175, tmp175,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:                            absolute(other->yPos - unit->yPos);
	subs	r3, r2, r3	@ tmp176, tmp174, tmp175
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r2, r3, #31	@ tmp203, tmp176,
	adds	r3, r3, r2	@ tmp177, tmp176, tmp203
	eors	r3, r2	@ tmp177, tmp203
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #12]	@ tmp173, %sfp
	adds	r3, r2, r3	@ distance, tmp173, tmp177
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:154:                 if (distance > 63) {
	cmp	r3, #63	@ distance,
	ble	.L69		@,
	movs	r3, #63	@ distance,
.L69:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:161:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	movs	r2, #11	@ tmp178,
	ldrsb	r2, [r7, r2]	@ tmp178,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:161:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	asrs	r2, r2, #6	@ tmp179, tmp178,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:159:                 auraBuffer[count].distance = distance;
	lsls	r2, r2, #6	@ tmp181, tmp179,
	orrs	r3, r2	@ tmp184, tmp181
	strb	r3, [r1, #1]	@ tmp184, MEM <unsigned char> [(struct AuraSkillBuffer *)_11 + 1B]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:162:                 ++count;
	adds	r4, r4, #1	@ count,
.L68:
	adds	r0, r0, #1	@ ivtmp.100,
	b	.L67		@
.L80:
	.align	2
.L79:
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
	movs	r3, r0	@ unit, tmp128
	push	{r4, lr}	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:177:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:177:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L82		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:178:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:178:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	beq	.L82		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:183:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	movs	r2, #11	@ tmp122,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:183:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldr	r0, .L87	@ tmp123,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:183:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldrsb	r2, [r3, r2]	@ tmp122,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:183:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldrb	r3, [r0]	@ gDefenderSkillBuffer, gDefenderSkillBuffer
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:183:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	cmp	r2, r3	@ tmp122, gDefenderSkillBuffer
	beq	.L83		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:180:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r0, .L87+4	@ buffer,
.L83:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:187:     return IsSkillInBuffer(buffer, skillID);
	bl	IsSkillInBuffer		@
.L82:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:188: }
	@ sp needed	@
	pop	{r4}
	pop	{r1}
	bx	r1
.L88:
	.align	2
.L87:
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
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:192: bool SkillTester(Unit* unit, u8 skillID) {
	movs	r5, r0	@ unit, tmp146
	movs	r4, r1	@ skillID, tmp147
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:193:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:193:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L90		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:194:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	bne	.L91		@,
.L94:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:194:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
.L90:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:217: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L91:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:196:     int index = unit->index;
	movs	r3, #11	@ index,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:202:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r2, .L102	@ tmp127,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:202:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrb	r2, [r2, #11]	@ tmp128,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:196:     int index = unit->index;
	ldrsb	r3, [r5, r3]	@ index,* index
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:202:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #24	@ tmp128, tmp128,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:199:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r6, .L102+4	@ buffer,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:202:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	asrs	r2, r2, #24	@ tmp128, tmp128,
	cmp	r2, r3	@ tmp128, index
	bne	.L92		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L102+8	@ tmp129,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:202:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:203:         buffer = &gDefenderSkillBuffer;
	ldr	r6, .L102+12	@ buffer,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:202:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #30	@ tmp152, gBattleStats,
	bne	.L92		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:199:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r6, .L102+4	@ buffer,
.L92:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (index != buffer->lastUnitChecked) {
	ldrb	r2, [r6]	@ *buffer_10, *buffer_10
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (index != buffer->lastUnitChecked) {
	cmp	r2, r3	@ *buffer_10, index
	beq	.L93		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:207:         MakeSkillBuffer(unit, buffer);
	movs	r1, r6	@, buffer
	movs	r0, r5	@, unit
	bl	MakeSkillBuffer		@
.L93:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:211:     if (IsSkillInBuffer(buffer, skillID)) {
	movs	r1, r4	@, skillID
	movs	r0, r6	@, buffer
	bl	IsSkillInBuffer		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:211:     if (IsSkillInBuffer(buffer, skillID)) {
	cmp	r0, #0	@ tmp148,
	beq	.L94		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:213:         return !NihilTester(unit, skillID);
	movs	r1, r4	@, skillID
	movs	r0, r5	@, unit
	bl	NihilTester		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:213:         return !NihilTester(unit, skillID);
	movs	r3, #1	@ tmp143,
	eors	r0, r3	@ tmp142, tmp143
	lsls	r0, r0, #24	@ <retval>, tmp142,
	lsrs	r0, r0, #24	@ <retval>, <retval>,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:213:         return !NihilTester(unit, skillID);
	b	.L90		@
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
	.type	NewAuraSkillCheck, %function
NewAuraSkillCheck:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, lr}	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:220: bool NewAuraSkillCheck(Unit* unit, u8 skillID, int allyOption, int maxRange) {
	movs	r4, r1	@ skillID, tmp163
	movs	r5, r2	@ allyOption, tmp164
	str	r0, [sp]	@ tmp162, %sfp
	str	r3, [sp, #4]	@ tmp165, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:221:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r7, .L125	@ iftmp.16_21,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:221:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	lsls	r3, r2, #31	@ tmp168, allyOption,
	bpl	.L105		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:221:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r7, .L125+4	@ iftmp.16_21,
.L105:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:223:     if (skillID == 0)   {return TRUE;}
	cmp	r4, #0	@ skillID,
	bne	.L106		@,
.L113:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:223:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
.L107:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:242: }
	@ sp needed	@
	pop	{r1, r2, r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L106:
	ldr	r6, .L125+8	@ ivtmp.119,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:224:     if (skillID == 255) {return FALSE;}
	cmp	r4, #255	@ skillID,
	bne	.L109		@,
.L108:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:224:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
	b	.L107		@
.L115:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:228:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldrb	r1, [r6, #1]	@ *_17, *_17
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:228:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldr	r0, [sp, #4]	@ maxRange, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:228:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	lsls	r3, r1, #26	@ tmp141, *_17,
	lsrs	r3, r3, #26	@ tmp142, tmp141,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:228:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r3, r0	@ tmp142, maxRange
	ble	.L110		@,
.L111:
	adds	r6, r6, #2	@ ivtmp.119,
.L109:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:227:     for (int i = 0; auraBuffer[i].skillID; ++i) {
	ldrb	r2, [r6]	@ _18, MEM[(unsigned char *)_17]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:227:     for (int i = 0; auraBuffer[i].skillID; ++i) {
	cmp	r2, #0	@ _18,
	bne	.L115		@,
	b	.L108		@
.L110:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:228:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r2, r4	@ _18, skillID
	bne	.L111		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:231:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	movs	r0, #11	@ tmp152,
	ldr	r3, [sp]	@ unit, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:231:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	lsrs	r1, r1, #6	@ tmp149, *_17,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:231:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	ldrsb	r0, [r3, r0]	@ tmp152,
	lsls	r1, r1, #6	@ tmp151, tmp149,
	bl	.L64		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:233:             if (allyOption & 2)
	movs	r3, #2	@ tmp172,
	tst	r5, r3	@ allyOption, tmp172
	beq	.L112		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:236:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp153,
	beq	.L113		@,
.L114:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:236:             if (check || (allyOption & 4))
	movs	r3, #4	@ tmp173,
	tst	r5, r3	@ allyOption, tmp173
	beq	.L111		@,
	b	.L113		@
.L112:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:236:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp153,
	beq	.L114		@,
	b	.L113		@
.L126:
	.align	2
.L125:
	.word	AreAllegiancesEqual
	.word	AreAllegiancesAllied
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
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:245: void InitializePreBattleLoop(Unit* attacker, Unit* defender) {
	movs	r4, r0	@ attacker, tmp132
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:246:     MakeAuraSkillBuffer(attacker);
	bl	MakeAuraSkillBuffer		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:247:     MakeSkillBuffer(attacker, &gAttackerSkillBuffer);
	ldr	r1, .L133	@ tmp118,
	movs	r0, r4	@, attacker
	bl	MakeSkillBuffer		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:248:     gDefenderSkillBuffer.lastUnitChecked = 0;
	movs	r3, #0	@ tmp120,
	ldr	r1, .L133+4	@ tmp119,
	strb	r3, [r1]	@ tmp120, gDefenderSkillBuffer.lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r3, .L133+8	@ tmp122,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:250:     if (IsBattleReal()) {
	ldrh	r3, [r3]	@ gBattleStats, gBattleStats
	lsls	r3, r3, #30	@ tmp133, gBattleStats,
	beq	.L127		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:251:         MakeSkillBuffer(&gBattleTarget.unit, &gDefenderSkillBuffer);
	ldr	r0, .L133+12	@ tmp131,
	bl	MakeSkillBuffer		@
.L127:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:253: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
.L134:
	.align	2
.L133:
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
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:257:     gAttackerSkillBuffer.lastUnitChecked = 0;
	movs	r2, #0	@ tmp115,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:259: }
	@ sp needed	@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:257:     gAttackerSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L136	@ tmp114,
	strb	r2, [r3]	@ tmp115, gAttackerSkillBuffer.lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:258:     gDefenderSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L136+4	@ tmp117,
	strb	r2, [r3]	@ tmp115, gDefenderSkillBuffer.lastUnitChecked
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:259: }
	bx	lr
.L137:
	.align	2
.L136:
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
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:263:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L159	@ iftmp.21_32,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:262: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	sub	sp, sp, #20	@,,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:262: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	movs	r5, r1	@ allyOption, tmp191
	str	r0, [sp, #8]	@ tmp190, %sfp
	str	r2, [sp, #12]	@ tmp192, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:263:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	str	r3, [sp, #4]	@ iftmp.21_32, %sfp
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:263:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	lsls	r3, r1, #31	@ tmp198, allyOption,
	bpl	.L139		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:263:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L159+4	@ iftmp.21_32,
	str	r3, [sp, #4]	@ iftmp.21_32, %sfp
.L139:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268:     for (int i = 0; i < 0x100; ++i) {
	movs	r4, #0	@ i,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:265:     int count = 0;
	movs	r6, r4	@ count, i
.L146:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:269:         Unit* other = gUnitLookup[i];
	ldr	r2, .L159+8	@ tmp154,
	lsls	r3, r4, #2	@ tmp152, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _34 * 1]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:271:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:271:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp193,
	beq	.L143		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:271:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, #11	@ _4,
	ldr	r3, [sp, #8]	@ unit, %sfp
	ldrsb	r0, [r3, r0]	@ _4,* _4
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:271:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, r4	@ _4, i
	beq	.L143		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:277:             check = !pAllegianceChecker(unit->index, other->index);
	movs	r1, #11	@ _31,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:276:         if (allyOption & 2) {
	movs	r3, #2	@ tmp207,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:277:             check = !pAllegianceChecker(unit->index, other->index);
	ldrsb	r1, [r7, r1]	@ _31,* _31
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:276:         if (allyOption & 2) {
	tst	r5, r3	@ allyOption, tmp207
	beq	.L141		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:277:             check = !pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.21_32, %sfp
	bl	.L63		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:283:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp194,
	beq	.L142		@,
.L145:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:283:         if (check || (allyOption & 4)) {
	movs	r3, #4	@ tmp209,
	tst	r5, r3	@ allyOption, tmp209
	beq	.L143		@,
.L142:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:284:             if ((absolute(other->xPos - unit->xPos)
	movs	r3, #16	@ tmp163,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:284:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #8]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp164,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:284:             if ((absolute(other->xPos - unit->xPos)
	ldrsb	r3, [r7, r3]	@ tmp163,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:284:             if ((absolute(other->xPos - unit->xPos)
	lsls	r2, r2, #24	@ tmp164, tmp164,
	asrs	r2, r2, #24	@ tmp164, tmp164,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:284:             if ((absolute(other->xPos - unit->xPos)
	subs	r2, r3, r2	@ tmp165, tmp163, tmp164
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:285:                + absolute(other->yPos - unit->yPos)) <= range) {
	movs	r3, #17	@ tmp167,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r2, #31	@ tmp199, tmp165,
	adds	r2, r2, r1	@ tmp166, tmp165, tmp199
	eors	r2, r1	@ tmp166, tmp199
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:285:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldr	r1, [sp, #8]	@ unit, %sfp
	ldrb	r1, [r1, #17]	@ tmp168,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:285:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldrsb	r3, [r7, r3]	@ tmp167,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:285:                + absolute(other->yPos - unit->yPos)) <= range) {
	lsls	r1, r1, #24	@ tmp168, tmp168,
	asrs	r1, r1, #24	@ tmp168, tmp168,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:285:                + absolute(other->yPos - unit->yPos)) <= range) {
	subs	r3, r3, r1	@ tmp169, tmp167, tmp168
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r3, #31	@ tmp200, tmp169,
	adds	r3, r3, r1	@ tmp170, tmp169, tmp200
	eors	r3, r1	@ tmp170, tmp200
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:285:                + absolute(other->yPos - unit->yPos)) <= range) {
	adds	r3, r2, r3	@ tmp171, tmp166, tmp170
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:284:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #12]	@ range, %sfp
	cmp	r3, r2	@ tmp171, range
	ble	.L144		@,
.L143:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp176,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268:     for (int i = 0; i < 0x100; ++i) {
	adds	r4, r4, #1	@ i,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp176, tmp176,
	cmp	r4, r3	@ i, tmp176
	bne	.L146		@,
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:292:     gUnitRangeBuffer[count++] = 0;
	movs	r2, #0	@ tmp178,
	ldr	r3, .L159+12	@ tmp177,
	strb	r2, [r3, r6]	@ tmp178, gUnitRangeBuffer[count_28]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:293:     if (!gUnitRangeBuffer[0])
	ldrb	r0, [r3]	@ gUnitRangeBuffer, gUnitRangeBuffer
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:296:     return gUnitRangeBuffer;
	subs	r2, r0, #1	@ tmp186, gUnitRangeBuffer
	sbcs	r0, r0, r2	@ tmp185, gUnitRangeBuffer, tmp186
	rsbs	r0, r0, #0	@ tmp187, tmp185
	ands	r0, r3	@ <retval>, tmp177
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:297: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L141:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:280:             check =  pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.21_32, %sfp
	bl	.L63		@
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:283:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp195,
	bne	.L142		@,
	b	.L145		@
.L144:
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:286:                 gUnitRangeBuffer[count++] = i;
	ldr	r3, .L159+12	@ tmp174,
	strb	r4, [r3, r6]	@ i, gUnitRangeBuffer[count_54]
@ EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:286:                 gUnitRangeBuffer[count++] = i;
	adds	r6, r6, #1	@ count,
	b	.L143		@
.L160:
	.align	2
.L159:
	.word	AreAllegiancesEqual
	.word	AreAllegiancesAllied
	.word	gUnitLookup
	.word	gUnitRangeBuffer
	.size	GetUnitsInRange, .-GetUnitsInRange
	.ident	"GCC: (devkitARM release 63) 13.2.0"
	.code 16
	.align	1
.L63:
	bx	r3
.L64:
	bx	r7
