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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:11: static bool IsUnitOnField(Unit* unit) {
	subs	r3, r0, #0	@ unit, tmp133,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	beq	.L2		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	ldr	r2, [r0]	@ unit_6(D)->pCharacterData, unit_6(D)->pCharacterData
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:13:         return FALSE;
	subs	r0, r2, #0	@ <retval>, unit_6(D)->pCharacterData,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:12:     if (!unit || !unit->pCharacterData)
	beq	.L2		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	ldr	r3, [r3, #12]	@ _2, unit_6(D)->state
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	ldr	r2, .L9	@ tmp123,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:13:         return FALSE;
	movs	r0, #0	@ <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:15:     if (unit->state & (US_RESCUED | US_NOT_DEPLOYED | US_DEAD | 0x00010000))
	tst	r3, r2	@ _2, tmp123
	bne	.L2		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:22:     return TRUE;
	adds	r0, r0, #1	@ <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	lsls	r3, r3, #24	@ tmp134, _2,
	bpl	.L2		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	ldr	r3, .L9+4	@ tmp126,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:18:     if ((unit->state & US_UNDER_A_ROOF) && (!gSkillTestConfig.roofUnitAuras)) {
	ldrb	r0, [r3, #4]	@ tmp128,
	subs	r3, r0, #1	@ tmp130, tmp128
	sbcs	r0, r0, r3	@ <retval>, tmp128, tmp130
.L2:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:23: }
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
	adds	r0, r0, #1	@ ivtmp.52,
.L12:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:27:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	ldrb	r3, [r0]	@ _1, MEM[(unsigned char *)_12]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:27:     for (int i = 0; buffer->skills[i] != 0; ++i) {
	cmp	r3, #0	@ _1,
	bne	.L14		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:32:     return FALSE;
	movs	r0, r3	@ <retval>, _1
.L13:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:33: }
	@ sp needed	@
	bx	lr
.L14:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:28:         if (buffer->skills[i] == skillID) {
	adds	r0, r0, #1	@ ivtmp.52,
	cmp	r3, r1	@ _1, skillID
	bne	.L12		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:29:             return TRUE;
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldr	r3, .L25	@ tmp125,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldrh	r3, [r3]	@ gBattleStats, gBattleStats
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:37: bool NihilTester(Unit* unit, u8 skillID) {
	movs	r2, r0	@ unit, tmp143
	push	{r4, lr}	@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:49:     return FALSE;
	movs	r0, #0	@ <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	lsls	r3, r3, #30	@ tmp148, gBattleStats,
	beq	.L17		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldr	r3, .L25+4	@ tmp133,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:39:     if ((gBattleStats.config & 3) && NegatedSkills[skillID]) {
	ldrb	r3, [r3, r1]	@ tmp134, NegatedSkills
	cmp	r3, r0	@ tmp134,
	beq	.L17		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:43:         if (unit->index == gBattleTarget.unit.index) {
	ldr	r3, .L25+8	@ tmp135,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:43:         if (unit->index == gBattleTarget.unit.index) {
	ldrb	r2, [r2, #11]	@ MEM[(signed char *)unit_9(D) + 11B], MEM[(signed char *)unit_9(D) + 11B]
	ldrb	r3, [r3, #11]	@ tmp137,
	lsls	r2, r2, #24	@ MEM[(signed char *)unit_9(D) + 11B], MEM[(signed char *)unit_9(D) + 11B],
	lsls	r3, r3, #24	@ tmp137, tmp137,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:44:             buffer = &gAttackerSkillBuffer;
	ldr	r0, .L25+12	@ buffer,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:43:         if (unit->index == gBattleTarget.unit.index) {
	asrs	r2, r2, #24	@ MEM[(signed char *)unit_9(D) + 11B], MEM[(signed char *)unit_9(D) + 11B],
	asrs	r3, r3, #24	@ tmp137, tmp137,
	cmp	r2, r3	@ MEM[(signed char *)unit_9(D) + 11B], tmp137
	beq	.L18		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:40:         SkillBuffer* buffer = &gDefenderSkillBuffer;
	ldr	r0, .L25+16	@ buffer,
.L18:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:47:         return IsSkillInBuffer(buffer, NihilIDLink);
	ldr	r3, .L25+20	@ tmp138,
	ldrb	r1, [r3]	@ NihilIDLink, NihilIDLink
	bl	IsSkillInBuffer		@
.L17:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:50: }
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:76:     int unitNum = unit->pCharacterData->number;
	ldr	r3, [r0]	@ unit_73(D)->pCharacterData, unit_73(D)->pCharacterData
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:78:     buffer->lastUnitChecked = unit->index;
	ldrb	r2, [r0, #11]	@ tmp203,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:76:     int unitNum = unit->pCharacterData->number;
	ldrb	r3, [r3, #4]	@ _2,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:78:     buffer->lastUnitChecked = unit->index;
	strb	r2, [r1]	@ tmp203, buffer_75(D)->lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:62:     if (unitNum < 1 || unitNum > 0x45) {
	subs	r2, r3, #1	@ tmp205, _2,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:75: SkillBuffer* MakeSkillBuffer(Unit* unit, SkillBuffer* buffer) {
	movs	r6, r0	@ unit, tmp337
	movs	r5, r1	@ buffer, tmp338
	sub	sp, sp, #20	@,,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:62:     if (unitNum < 1 || unitNum > 0x45) {
	cmp	r2, #68	@ tmp205,
	bhi	.L28		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:66:     if (*(u32*)ram != LEARNED_SKILL_MAGIC) {
	ldr	r1, .L67	@ tmp206,
	ldr	r2, .L67+4	@ tmp207,
	ldr	r1, [r1]	@ MEM[(u32 *)33813824B], MEM[(u32 *)33813824B]
	cmp	r1, r2	@ MEM[(u32 *)33813824B], tmp207
	bne	.L28		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:69:     if (!ram[4 + LEARNED_SLOTS_SIZE + unitNum]) {
	ldr	r2, .L67+8	@ tmp209,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:69:     if (!ram[4 + LEARNED_SLOTS_SIZE + unitNum]) {
	ldrb	r2, [r3, r2]	@ *_121, *_121
	cmp	r2, #0	@ *_121,
	beq	.L28		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:72:     return ram + 4 + unitNum * LEARNED_SLOT_COUNT;
	movs	r2, #6	@ tmp211,
	movs	r0, r2	@ ivtmp.94, tmp211
	muls	r0, r3	@ ivtmp.94, _2
	adds	r3, r3, #1	@ tmp212,
	muls	r3, r2	@ _167, tmp211
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:77:     int count = 0, temp = 0;
	movs	r2, #0	@ count,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:83:             if (!IsSkillIDValid(overrideSlots[i])) {
	ldr	r6, .L67+12	@ tmp214,
.L30:
	ldrb	r4, [r0, r6]	@ _7, *_6
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r1, r4, #1	@ tmp215, _7,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:83:             if (!IsSkillIDValid(overrideSlots[i])) {
	lsls	r1, r1, #24	@ tmp218, tmp215,
	lsrs	r1, r1, #24	@ tmp218, tmp218,
	cmp	r1, #253	@ tmp218,
	bhi	.L29		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:86:             buffer->skills[count++] = overrideSlots[i];
	adds	r1, r5, r2	@ tmp220, buffer, count
	strb	r4, [r1, #1]	@ _7, buffer_75(D)->skills[count_79]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:86:             buffer->skills[count++] = overrideSlots[i];
	adds	r2, r2, #1	@ count,
.L29:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:82:         for (int i = 0; i < LEARNED_SLOT_COUNT; ++i) {
	adds	r0, r0, #1	@ ivtmp.94,
	cmp	r0, r3	@ ivtmp.94, _167
	bne	.L30		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:88:         buffer->skills[count++] = 0;
	movs	r3, #0	@ tmp223,
	adds	r2, r5, r2	@ tmp222, buffer, count
	strb	r3, [r2, #1]	@ tmp223, buffer_75(D)->skills[count_48]
.L31:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:150: }
	movs	r0, r5	@, buffer
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L28:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:93:     temp = PersonalSkillTable[unitNum];
	ldr	r2, .L67+16	@ tmp225,
	ldrb	r2, [r2, r3]	@ _8, PersonalSkillTable
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp226, _8,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:94:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp229, tmp226,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:77:     int count = 0, temp = 0;
	movs	r4, #0	@ count,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:94:     if (IsSkillIDValid(temp)) {
	lsrs	r3, r3, #24	@ tmp229, tmp229,
	cmp	r3, #253	@ tmp229,
	bhi	.L32		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:         buffer->skills[count++] = temp;
	strb	r2, [r5, #1]	@ _8, buffer_75(D)->skills[0]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L32:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:99:     temp = ClassSkillTable[unit->pClassData->number];
	ldr	r2, [r6, #4]	@ unit_73(D)->pClassData, unit_73(D)->pClassData
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:99:     temp = ClassSkillTable[unit->pClassData->number];
	ldr	r3, .L67+20	@ tmp232,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:99:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r2, [r2, #4]	@ tmp234,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:99:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r2, [r3, r2]	@ _12, ClassSkillTable
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp235, _12,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:100:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp238, tmp235,
	lsrs	r3, r3, #24	@ tmp238, tmp238,
	cmp	r3, #253	@ tmp238,
	bhi	.L33		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:101:         buffer->skills[count++] = temp;
	adds	r3, r5, r4	@ tmp240, buffer, count
	strb	r2, [r3, #1]	@ _12, buffer_75(D)->skills[count_50]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:101:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L33:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:106:     u8* tempBuffer = GetInitialSkillList_Pointer(unit, gTempSkillBuffer);
	ldr	r3, .L67+24	@ tmp243,
	movs	r0, r6	@, unit
	ldr	r3, [r3]	@ GetInitialSkillList_Pointer, GetInitialSkillList_Pointer
	ldr	r1, .L67+28	@ tmp242,
	bl	.L69		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:107:     for (int i = 0; i < gSkillTestConfig.genericLearnedSkillLimit; ++i) {
	ldr	r3, .L67+32	@ tmp245,
	str	r3, [sp, #4]	@ tmp245, %sfp
	ldrb	r2, [r3, #2]	@ tmp246,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:108:         if (!IsSkillIDValid(tempBuffer[i])) {
	subs	r0, r0, r4	@ tmp336, tmp339, count
	adds	r2, r2, r4	@ _153, tmp246, count
.L34:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:107:     for (int i = 0; i < gSkillTestConfig.genericLearnedSkillLimit; ++i) {
	cmp	r4, r2	@ count, _153
	beq	.L38		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:108:         if (!IsSkillIDValid(tempBuffer[i])) {
	ldrb	r1, [r0, r4]	@ _16, MEM[(u8 *)_157 + _158 * 1]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r1, #1	@ tmp248, _16,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:108:         if (!IsSkillIDValid(tempBuffer[i])) {
	lsls	r3, r3, #24	@ tmp251, tmp248,
	lsrs	r3, r3, #24	@ tmp251, tmp251,
	cmp	r3, #253	@ tmp251,
	bls	.L35		@,
.L38:
	movs	r3, r6	@ ivtmp.71, unit
	adds	r3, r3, #30	@ ivtmp.71,
	str	r3, [sp]	@ ivtmp.71, %sfp
	adds	r3, r3, #10	@ _149,
	str	r3, [sp, #12]	@ _149, %sfp
.L36:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:115:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp]	@ ivtmp.71, %sfp
	ldrh	r7, [r3]	@ _29, MEM[(short unsigned int *)_147]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:115:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	cmp	r7, #0	@ _29,
	beq	.L42		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:117:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L67+36	@ tmp254,
	movs	r0, r7	@, _29
	bl	.L69		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:117:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L67+40	@ tmp255,
	ldr	r3, [r3]	@ PassiveSkillBit, PassiveSkillBit
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:117:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	tst	r3, r0	@ PassiveSkillBit, tmp340
	beq	.L41		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:118:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r7, r7, #24	@ _23, _29,
	ldr	r3, .L67+44	@ tmp259,
	lsrs	r7, r7, #24	@ _23, _23,
	movs	r0, r7	@, _23
	str	r3, [sp, #8]	@ tmp259, %sfp
	bl	.L69		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:118:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	adds	r0, r0, #4	@ tmp260,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	ldrb	r3, [r0, #31]	@ tmp262,
	subs	r3, r3, #1	@ tmp263,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:118:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r3, r3, #24	@ tmp266, tmp263,
	lsrs	r3, r3, #24	@ tmp266, tmp266,
	cmp	r3, #253	@ tmp266,
	bhi	.L41		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:119:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldr	r3, [sp, #8]	@ tmp259, %sfp
	movs	r0, r7	@, _23
	bl	.L69		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:119:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r0, r0, #4	@ tmp270,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:119:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldrb	r2, [r0, #31]	@ tmp271,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:119:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r3, r4, #1	@ count, count,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:119:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r4, r5, r4	@ tmp269, buffer, count
	strb	r2, [r4, #1]	@ tmp271, buffer_75(D)->skills[count_38]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:121:                 if (!gSkillTestConfig.passiveSkillStack) {
	ldr	r2, [sp, #4]	@ tmp245, %sfp
	ldrb	r2, [r2, #3]	@ tmp274,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:119:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	movs	r4, r3	@ count, count
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:121:                 if (!gSkillTestConfig.passiveSkillStack) {
	cmp	r2, #0	@ tmp274,
	beq	.L42		@,
.L41:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:115:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp]	@ ivtmp.71, %sfp
	ldr	r2, [sp, #12]	@ _149, %sfp
	adds	r3, r3, #2	@ ivtmp.71,
	str	r3, [sp]	@ ivtmp.71, %sfp
	cmp	r3, r2	@ ivtmp.71, _149
	bne	.L36		@,
.L42:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r2, #11	@ _30,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp276,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldr	r3, .L67+48	@ tmp275,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r2, [r6, r2]	@ _30,* _30
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp276,
	ldr	r7, .L67+44	@ tmp335,
	cmp	r1, r2	@ tmp276, _30
	bne	.L44		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r1, .L67+52	@ tmp277,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrh	r1, [r1]	@ gBattleStats, gBattleStats
	lsls	r1, r1, #30	@ tmp347, gBattleStats,
	beq	.L44		@,
.L66:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:134:         temp = GetItemData(gBattleTarget.weaponBefore & 0xFF)->skill;
	adds	r3, r3, #74	@ tmp309,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:134:         temp = GetItemData(gBattleTarget.weaponBefore & 0xFF)->skill;
	ldrb	r0, [r3]	@ tmp313,
.L65:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:138:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	bl	.L70		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:138:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	adds	r0, r0, #4	@ tmp321,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:138:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	ldrb	r3, [r0, #31]	@ temp,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r2, r3, #1	@ tmp323, _47,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:142:     if (IsSkillIDValid(temp)) {
	lsls	r2, r2, #24	@ tmp326, tmp323,
	lsrs	r2, r2, #24	@ tmp326, tmp326,
	cmp	r2, #253	@ tmp326,
	bhi	.L47		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:143:         buffer->skills[count++] = temp;
	adds	r2, r5, r4	@ tmp328, buffer, count
	strb	r3, [r2, #1]	@ _47, buffer_75(D)->skills[count_55]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:143:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L47:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:147:     buffer->skills[count++] = 0;
	movs	r3, #0	@ tmp331,
	adds	r4, r5, r4	@ tmp330, buffer, count
	strb	r3, [r4, #1]	@ tmp331, buffer_75(D)->skills[count_56]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:149:     return buffer;
	b	.L31		@
.L35:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:111:         buffer->skills[count++] = tempBuffer[i];
	adds	r4, r4, #1	@ count,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:111:         buffer->skills[count++] = tempBuffer[i];
	strb	r1, [r5, r4]	@ _16, MEM[(unsigned char *)buffer_75(D) + _154 * 1]
	b	.L34		@
.L44:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:133:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp297,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:133:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r3, .L67+56	@ tmp296,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:133:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp297,
	cmp	r1, r2	@ tmp297, _30
	bne	.L46		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L67+52	@ tmp298,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:133:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
	lsls	r2, r2, #30	@ tmp348, gBattleStats,
	bne	.L66		@,
.L46:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:138:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	movs	r0, r6	@, unit
	ldr	r3, .L67+60	@ tmp317,
	bl	.L69		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:138:         temp = GetItemData(GetUnitEquippedWeapon(unit) & 0xFF)->skill;
	lsls	r0, r0, #24	@ tmp318, tmp345,
	lsrs	r0, r0, #24	@ tmp318, tmp318,
	b	.L65		@
.L68:
	.align	2
.L67:
	.word	33813824
	.word	1397443667
	.word	33814248
	.word	33813828
	.word	PersonalSkillTable
	.word	ClassSkillTable
	.word	GetInitialSkillList_Pointer
	.word	gTempSkillBuffer
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:159:     for (int i = 0; i < 0x100; ++i) {
	movs	r6, #0	@ i,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:156:     int count = 0;
	movs	r4, r6	@ count, i
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:153: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	sub	sp, sp, #28	@,,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:153: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	str	r0, [sp, #4]	@ tmp198, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:154:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r5, .L85	@ buffer,
.L77:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:160:         Unit* other = gUnitLookup[i];
	ldr	r2, .L85+4	@ tmp159,
	lsls	r3, r6, #2	@ tmp157, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _71 * 1]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:162:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:162:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp199,
	beq	.L72		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:162:         if (!IsUnitOnField(other) || unit->index == i) {
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #11]	@ tmp162,
	lsls	r3, r3, #24	@ tmp162, tmp162,
	asrs	r3, r3, #24	@ tmp162, tmp162,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:162:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r3, r6	@ tmp162, i
	beq	.L72		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:167:         buffer = MakeSkillBuffer(other, buffer);
	movs	r1, r5	@, buffer
	movs	r0, r7	@, other
	bl	MakeSkillBuffer		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:171:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L85+8	@ tmp163,
	ldrh	r3, [r3]	@ _8, gSkillTestConfig
	str	r3, [sp, #8]	@ _8, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:171:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L85+12	@ tmp194,
	str	r3, [sp, #16]	@ tmp194, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:172:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r3, .L85+16	@ tmp195,
	str	r3, [sp, #20]	@ tmp195, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:167:         buffer = MakeSkillBuffer(other, buffer);
	movs	r5, r0	@ buffer, tmp200
	adds	r0, r0, #1	@ ivtmp.101,
.L73:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:170:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	ldrb	r3, [r0]	@ _29, MEM[(unsigned char *)_69]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:170:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	cmp	r3, #0	@ _29,
	bne	.L76		@,
.L72:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:159:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp219,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:159:     for (int i = 0; i < 0x100; ++i) {
	adds	r6, r6, #1	@ i,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:159:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp219, tmp219,
	cmp	r6, r3	@ i, tmp219
	bne	.L77		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:191:     buffer->lastUnitChecked = 0;
	movs	r3, #0	@ tmp187,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:192:     gAuraSkillBuffer[count++].skillID = 0;
	ldr	r0, .L85+16	@ tmp189,
	lsls	r4, r4, #1	@ tmp190, count,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:191:     buffer->lastUnitChecked = 0;
	strb	r3, [r5]	@ tmp187, buffer_30->lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:192:     gAuraSkillBuffer[count++].skillID = 0;
	strb	r3, [r4, r0]	@ tmp187, gAuraSkillBuffer[count_34].skillID
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:195: }
	add	sp, sp, #28	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L76:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:171:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #16]	@ tmp194, %sfp
	ldrb	r2, [r2, r3]	@ tmp165, AuraSkillTable
	cmp	r2, #0	@ tmp165,
	beq	.L74		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:171:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #8]	@ _8, %sfp
	cmp	r2, r4	@ _8, count
	ble	.L74		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:172:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r2, [sp, #20]	@ tmp195, %sfp
	lsls	r1, r4, #1	@ tmp166, count,
	adds	r1, r1, r2	@ _11, tmp166, tmp195
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:172:                 auraBuffer[count].skillID = buffer->skills[j];
	strb	r3, [r1]	@ _29, _11->skillID
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:174:                 distance = absolute(other->xPos - unit->xPos) +
	movs	r3, #16	@ tmp170,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:174:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #4]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp171,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:174:                 distance = absolute(other->xPos - unit->xPos) +
	ldrsb	r3, [r7, r3]	@ tmp170,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:174:                 distance = absolute(other->xPos - unit->xPos) +
	lsls	r2, r2, #24	@ tmp171, tmp171,
	asrs	r2, r2, #24	@ tmp171, tmp171,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:174:                 distance = absolute(other->xPos - unit->xPos) +
	subs	r2, r3, r2	@ tmp172, tmp170, tmp171
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r3, r2, #31	@ tmp202, tmp172,
	adds	r2, r2, r3	@ tmp173, tmp172, tmp202
	eors	r2, r3	@ tmp173, tmp202
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:175:                            absolute(other->yPos - unit->yPos);
	movs	r3, #17	@ tmp174,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	str	r2, [sp, #12]	@ tmp173, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:175:                            absolute(other->yPos - unit->yPos);
	ldrsb	r3, [r7, r3]	@ tmp174,
	mov	ip, r3	@ tmp174, tmp174
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:175:                            absolute(other->yPos - unit->yPos);
	mov	r2, ip	@ tmp174, tmp174
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:175:                            absolute(other->yPos - unit->yPos);
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #17]	@ tmp175,
	lsls	r3, r3, #24	@ tmp175, tmp175,
	asrs	r3, r3, #24	@ tmp175, tmp175,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:175:                            absolute(other->yPos - unit->yPos);
	subs	r3, r2, r3	@ tmp176, tmp174, tmp175
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r2, r3, #31	@ tmp203, tmp176,
	adds	r3, r3, r2	@ tmp177, tmp176, tmp203
	eors	r3, r2	@ tmp177, tmp203
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:174:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #12]	@ tmp173, %sfp
	adds	r3, r2, r3	@ distance, tmp173, tmp177
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:177:                 if (distance > 63) {
	cmp	r3, #63	@ distance,
	ble	.L75		@,
	movs	r3, #63	@ distance,
.L75:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:184:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	movs	r2, #11	@ tmp178,
	ldrsb	r2, [r7, r2]	@ tmp178,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:184:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	asrs	r2, r2, #6	@ tmp179, tmp178,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:182:                 auraBuffer[count].distance = distance;
	lsls	r2, r2, #6	@ tmp181, tmp179,
	orrs	r3, r2	@ tmp184, tmp181
	strb	r3, [r1, #1]	@ tmp184, MEM <unsigned char> [(struct AuraSkillBuffer *)_11 + 1B]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:185:                 ++count;
	adds	r4, r4, #1	@ count,
.L74:
	adds	r0, r0, #1	@ ivtmp.101,
	b	.L73		@
.L86:
	.align	2
.L85:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:200:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:200:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L88		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:201:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:201:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	beq	.L88		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	movs	r2, #11	@ tmp122,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldr	r0, .L93	@ tmp123,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldrsb	r2, [r3, r2]	@ tmp122,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldrb	r3, [r0]	@ gDefenderSkillBuffer, gDefenderSkillBuffer
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	cmp	r2, r3	@ tmp122, gDefenderSkillBuffer
	beq	.L89		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:203:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r0, .L93+4	@ buffer,
.L89:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:210:     return IsSkillInBuffer(buffer, skillID);
	bl	IsSkillInBuffer		@
.L88:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:211: }
	@ sp needed	@
	pop	{r4}
	pop	{r1}
	bx	r1
.L94:
	.align	2
.L93:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:215: bool SkillTester(Unit* unit, u8 skillID) {
	movs	r5, r0	@ unit, tmp146
	movs	r4, r1	@ skillID, tmp147
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:216:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:216:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L96		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:217:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	bne	.L97		@,
.L100:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:217:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
.L96:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:240: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L97:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:219:     int index = unit->index;
	movs	r3, #11	@ index,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:225:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r2, .L108	@ tmp127,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:225:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrb	r2, [r2, #11]	@ tmp128,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:219:     int index = unit->index;
	ldrsb	r3, [r5, r3]	@ index,* index
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:225:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #24	@ tmp128, tmp128,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:222:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r6, .L108+4	@ buffer,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:225:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	asrs	r2, r2, #24	@ tmp128, tmp128,
	cmp	r2, r3	@ tmp128, index
	bne	.L98		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L108+8	@ tmp129,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:225:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:226:         buffer = &gDefenderSkillBuffer;
	ldr	r6, .L108+12	@ buffer,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:225:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #30	@ tmp152, gBattleStats,
	bne	.L98		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:222:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r6, .L108+4	@ buffer,
.L98:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:229:     if (index != buffer->lastUnitChecked) {
	ldrb	r2, [r6]	@ *buffer_10, *buffer_10
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:229:     if (index != buffer->lastUnitChecked) {
	cmp	r2, r3	@ *buffer_10, index
	beq	.L99		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:230:         MakeSkillBuffer(unit, buffer);
	movs	r1, r6	@, buffer
	movs	r0, r5	@, unit
	bl	MakeSkillBuffer		@
.L99:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:234:     if (IsSkillInBuffer(buffer, skillID)) {
	movs	r1, r4	@, skillID
	movs	r0, r6	@, buffer
	bl	IsSkillInBuffer		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:234:     if (IsSkillInBuffer(buffer, skillID)) {
	cmp	r0, #0	@ tmp148,
	beq	.L100		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:236:         return !NihilTester(unit, skillID);
	movs	r1, r4	@, skillID
	movs	r0, r5	@, unit
	bl	NihilTester		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:236:         return !NihilTester(unit, skillID);
	movs	r3, #1	@ tmp143,
	eors	r0, r3	@ tmp142, tmp143
	lsls	r0, r0, #24	@ <retval>, tmp142,
	lsrs	r0, r0, #24	@ <retval>, <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:236:         return !NihilTester(unit, skillID);
	b	.L96		@
.L109:
	.align	2
.L108:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:243: bool NewAuraSkillCheck(Unit* unit, u8 skillID, int allyOption, int maxRange) {
	movs	r4, r1	@ skillID, tmp163
	movs	r5, r2	@ allyOption, tmp164
	str	r0, [sp]	@ tmp162, %sfp
	str	r3, [sp, #4]	@ tmp165, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:244:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r7, .L131	@ iftmp.20_21,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:244:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	lsls	r3, r2, #31	@ tmp168, allyOption,
	bpl	.L111		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:244:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r7, .L131+4	@ iftmp.20_21,
.L111:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:246:     if (skillID == 0)   {return TRUE;}
	cmp	r4, #0	@ skillID,
	bne	.L112		@,
.L119:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:246:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
.L113:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:265: }
	@ sp needed	@
	pop	{r1, r2, r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L112:
	ldr	r6, .L131+8	@ ivtmp.120,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:247:     if (skillID == 255) {return FALSE;}
	cmp	r4, #255	@ skillID,
	bne	.L115		@,
.L114:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:247:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
	b	.L113		@
.L121:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:251:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldrb	r1, [r6, #1]	@ *_17, *_17
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:251:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldr	r0, [sp, #4]	@ maxRange, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:251:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	lsls	r3, r1, #26	@ tmp141, *_17,
	lsrs	r3, r3, #26	@ tmp142, tmp141,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:251:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r3, r0	@ tmp142, maxRange
	ble	.L116		@,
.L117:
	adds	r6, r6, #2	@ ivtmp.120,
.L115:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:250:     for (int i = 0; auraBuffer[i].skillID; ++i) {
	ldrb	r2, [r6]	@ _18, MEM[(unsigned char *)_17]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:250:     for (int i = 0; auraBuffer[i].skillID; ++i) {
	cmp	r2, #0	@ _18,
	bne	.L121		@,
	b	.L114		@
.L116:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:251:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r2, r4	@ _18, skillID
	bne	.L117		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:254:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	movs	r0, #11	@ tmp152,
	ldr	r3, [sp]	@ unit, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:254:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	lsrs	r1, r1, #6	@ tmp149, *_17,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:254:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	ldrsb	r0, [r3, r0]	@ tmp152,
	lsls	r1, r1, #6	@ tmp151, tmp149,
	bl	.L70		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:256:             if (allyOption & 2)
	movs	r3, #2	@ tmp172,
	tst	r5, r3	@ allyOption, tmp172
	beq	.L118		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:259:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp153,
	beq	.L119		@,
.L120:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:259:             if (check || (allyOption & 4))
	movs	r3, #4	@ tmp173,
	tst	r5, r3	@ allyOption, tmp173
	beq	.L117		@,
	b	.L119		@
.L118:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:259:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp153,
	beq	.L120		@,
	b	.L119		@
.L132:
	.align	2
.L131:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268: void InitializePreBattleLoop(Unit* attacker, Unit* defender) {
	movs	r4, r0	@ attacker, tmp132
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:269:     MakeAuraSkillBuffer(attacker);
	bl	MakeAuraSkillBuffer		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:270:     MakeSkillBuffer(attacker, &gAttackerSkillBuffer);
	ldr	r1, .L139	@ tmp118,
	movs	r0, r4	@, attacker
	bl	MakeSkillBuffer		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:271:     gDefenderSkillBuffer.lastUnitChecked = 0;
	movs	r3, #0	@ tmp120,
	ldr	r1, .L139+4	@ tmp119,
	strb	r3, [r1]	@ tmp120, gDefenderSkillBuffer.lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r3, .L139+8	@ tmp122,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:273:     if (IsBattleReal()) {
	ldrh	r3, [r3]	@ gBattleStats, gBattleStats
	lsls	r3, r3, #30	@ tmp133, gBattleStats,
	beq	.L133		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:274:         MakeSkillBuffer(&gBattleTarget.unit, &gDefenderSkillBuffer);
	ldr	r0, .L139+12	@ tmp131,
	bl	MakeSkillBuffer		@
.L133:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:276: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
.L140:
	.align	2
.L139:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:280:     gAttackerSkillBuffer.lastUnitChecked = 0;
	movs	r2, #0	@ tmp115,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:282: }
	@ sp needed	@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:280:     gAttackerSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L142	@ tmp114,
	strb	r2, [r3]	@ tmp115, gAttackerSkillBuffer.lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:281:     gDefenderSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L142+4	@ tmp117,
	strb	r2, [r3]	@ tmp115, gDefenderSkillBuffer.lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:282: }
	bx	lr
.L143:
	.align	2
.L142:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:286:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L165	@ iftmp.25_32,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:285: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	sub	sp, sp, #20	@,,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:285: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	movs	r5, r1	@ allyOption, tmp191
	str	r0, [sp, #8]	@ tmp190, %sfp
	str	r2, [sp, #12]	@ tmp192, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:286:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	str	r3, [sp, #4]	@ iftmp.25_32, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:286:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	lsls	r3, r1, #31	@ tmp198, allyOption,
	bpl	.L145		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:286:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L165+4	@ iftmp.25_32,
	str	r3, [sp, #4]	@ iftmp.25_32, %sfp
.L145:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:291:     for (int i = 0; i < 0x100; ++i) {
	movs	r4, #0	@ i,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:288:     int count = 0;
	movs	r6, r4	@ count, i
.L152:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:292:         Unit* other = gUnitLookup[i];
	ldr	r2, .L165+8	@ tmp154,
	lsls	r3, r4, #2	@ tmp152, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _34 * 1]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp193,
	beq	.L149		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, #11	@ _4,
	ldr	r3, [sp, #8]	@ unit, %sfp
	ldrsb	r0, [r3, r0]	@ _4,* _4
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, r4	@ _4, i
	beq	.L149		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:300:             check = !pAllegianceChecker(unit->index, other->index);
	movs	r1, #11	@ _31,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:299:         if (allyOption & 2) {
	movs	r3, #2	@ tmp207,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:300:             check = !pAllegianceChecker(unit->index, other->index);
	ldrsb	r1, [r7, r1]	@ _31,* _31
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:299:         if (allyOption & 2) {
	tst	r5, r3	@ allyOption, tmp207
	beq	.L147		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:300:             check = !pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.25_32, %sfp
	bl	.L69		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:306:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp194,
	beq	.L148		@,
.L151:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:306:         if (check || (allyOption & 4)) {
	movs	r3, #4	@ tmp209,
	tst	r5, r3	@ allyOption, tmp209
	beq	.L149		@,
.L148:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:307:             if ((absolute(other->xPos - unit->xPos)
	movs	r3, #16	@ tmp163,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:307:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #8]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp164,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:307:             if ((absolute(other->xPos - unit->xPos)
	ldrsb	r3, [r7, r3]	@ tmp163,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:307:             if ((absolute(other->xPos - unit->xPos)
	lsls	r2, r2, #24	@ tmp164, tmp164,
	asrs	r2, r2, #24	@ tmp164, tmp164,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:307:             if ((absolute(other->xPos - unit->xPos)
	subs	r2, r3, r2	@ tmp165, tmp163, tmp164
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:308:                + absolute(other->yPos - unit->yPos)) <= range) {
	movs	r3, #17	@ tmp167,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r2, #31	@ tmp199, tmp165,
	adds	r2, r2, r1	@ tmp166, tmp165, tmp199
	eors	r2, r1	@ tmp166, tmp199
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:308:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldr	r1, [sp, #8]	@ unit, %sfp
	ldrb	r1, [r1, #17]	@ tmp168,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:308:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldrsb	r3, [r7, r3]	@ tmp167,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:308:                + absolute(other->yPos - unit->yPos)) <= range) {
	lsls	r1, r1, #24	@ tmp168, tmp168,
	asrs	r1, r1, #24	@ tmp168, tmp168,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:308:                + absolute(other->yPos - unit->yPos)) <= range) {
	subs	r3, r3, r1	@ tmp169, tmp167, tmp168
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r3, #31	@ tmp200, tmp169,
	adds	r3, r3, r1	@ tmp170, tmp169, tmp200
	eors	r3, r1	@ tmp170, tmp200
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:308:                + absolute(other->yPos - unit->yPos)) <= range) {
	adds	r3, r2, r3	@ tmp171, tmp166, tmp170
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:307:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #12]	@ range, %sfp
	cmp	r3, r2	@ tmp171, range
	ble	.L150		@,
.L149:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:291:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp176,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:291:     for (int i = 0; i < 0x100; ++i) {
	adds	r4, r4, #1	@ i,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:291:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp176, tmp176,
	cmp	r4, r3	@ i, tmp176
	bne	.L152		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:315:     gUnitRangeBuffer[count++] = 0;
	movs	r2, #0	@ tmp178,
	ldr	r3, .L165+12	@ tmp177,
	strb	r2, [r3, r6]	@ tmp178, gUnitRangeBuffer[count_28]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:316:     if (!gUnitRangeBuffer[0])
	ldrb	r0, [r3]	@ gUnitRangeBuffer, gUnitRangeBuffer
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:319:     return gUnitRangeBuffer;
	subs	r2, r0, #1	@ tmp186, gUnitRangeBuffer
	sbcs	r0, r0, r2	@ tmp185, gUnitRangeBuffer, tmp186
	rsbs	r0, r0, #0	@ tmp187, tmp185
	ands	r0, r3	@ <retval>, tmp177
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:320: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L147:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:303:             check =  pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.25_32, %sfp
	bl	.L69		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:306:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp195,
	bne	.L148		@,
	b	.L151		@
.L150:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:309:                 gUnitRangeBuffer[count++] = i;
	ldr	r3, .L165+12	@ tmp174,
	strb	r4, [r3, r6]	@ i, gUnitRangeBuffer[count_54]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:309:                 gUnitRangeBuffer[count++] = i;
	adds	r6, r6, #1	@ count,
	b	.L149		@
.L166:
	.align	2
.L165:
	.word	AreAllegiancesEqual
	.word	AreAllegiancesAllied
	.word	gUnitLookup
	.word	gUnitRangeBuffer
	.size	GetUnitsInRange, .-GetUnitsInRange
	.ident	"GCC: (devkitARM release 63) 13.2.0"
	.code 16
	.align	1
.L69:
	bx	r3
.L70:
	bx	r7
