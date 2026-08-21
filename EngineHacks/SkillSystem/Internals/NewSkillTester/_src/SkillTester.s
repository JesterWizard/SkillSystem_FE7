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
	adds	r0, r0, #1	@ ivtmp.46,
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
	adds	r0, r0, #1	@ ivtmp.46,
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
	movs	r6, r0	@ unit, tmp280
	movs	r5, r1	@ buffer, tmp281
	sub	sp, sp, #20	@,,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:57:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	cmp	r0, #0	@ unit,
	beq	.L48		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:64:     buffer->lastUnitChecked = unit->index;
	movs	r2, #11	@ pretmp_50,
	ldrsb	r2, [r6, r2]	@ pretmp_50,* pretmp_50
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:57:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	ldr	r0, [r0]	@ _1, unit_55(D)->pCharacterData
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:64:     buffer->lastUnitChecked = unit->index;
	lsls	r3, r2, #24	@ _44, pretmp_50,
	lsrs	r3, r3, #24	@ _44, _44,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:57:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	cmp	r0, #0	@ _1,
	beq	.L28		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:57:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	ldr	r1, [r6, #4]	@ _2, unit_55(D)->pClassData
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:57:     if (!unit || !unit->pCharacterData || !unit->pClassData) {
	cmp	r1, #0	@ _2,
	bne	.L29		@,
.L28:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:58:         buffer->lastUnitChecked = unit ? unit->index : 0;
	strb	r3, [r5]	@ _44, buffer_58(D)->lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:59:         buffer->skills[0] = 0;
	movs	r3, #0	@ tmp180,
	strb	r3, [r5, #1]	@ tmp180, buffer_58(D)->skills[0]
.L30:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:130: }
	movs	r0, r5	@, buffer
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L48:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:58:         buffer->lastUnitChecked = unit ? unit->index : 0;
	movs	r3, r0	@ _44, unit
	b	.L28		@
.L29:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:63:     unitNum = unit->pCharacterData->number;
	ldrb	r0, [r0, #4]	@ unitNum,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:64:     buffer->lastUnitChecked = unit->index;
	strb	r3, [r5]	@ _44, buffer_58(D)->lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:67:     temp = PersonalSkillTable[unitNum];
	ldr	r3, .L73	@ tmp183,
	ldrb	r0, [r3, r0]	@ _7, PersonalSkillTable
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r0, #1	@ tmp184, _7,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:68:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp187, tmp184,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:55:     int unitNum = 0, count = 0, temp = 0;
	movs	r4, #0	@ count,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:68:     if (IsSkillIDValid(temp)) {
	lsrs	r3, r3, #24	@ tmp187, tmp187,
	cmp	r3, #253	@ tmp187,
	bhi	.L31		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:69:         buffer->skills[count++] = temp;
	strb	r0, [r5, #1]	@ _7, buffer_58(D)->skills[0]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:69:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L31:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:73:     temp = ClassSkillTable[unit->pClassData->number];
	ldr	r3, .L73+4	@ tmp190,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:73:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r1, [r1, #4]	@ tmp191,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:73:     temp = ClassSkillTable[unit->pClassData->number];
	ldrb	r1, [r3, r1]	@ _10, ClassSkillTable
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r1, #1	@ tmp192, _10,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:74:     if (IsSkillIDValid(temp)) {
	lsls	r3, r3, #24	@ tmp195, tmp192,
	lsrs	r3, r3, #24	@ tmp195, tmp195,
	cmp	r3, #253	@ tmp195,
	bhi	.L32		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:75:         buffer->skills[count++] = temp;
	adds	r3, r5, r4	@ tmp197, buffer, count
	strb	r1, [r3, #1]	@ _10, buffer_58(D)->skills[count_34]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:75:         buffer->skills[count++] = temp;
	adds	r4, r4, #1	@ count,
.L32:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:80:     if ((unit->index & 0xC0) != 0) {
	movs	r1, #192	@ tmp201,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:79:     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldr	r3, .L73+8	@ tmp199,
	str	r3, [sp, #4]	@ tmp199, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:79:     int learnedLimit = gSkillTestConfig.genericLearnedSkillLimit;
	ldrb	r3, [r3, #2]	@ learnedLimit,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:80:     if ((unit->index & 0xC0) != 0) {
	tst	r2, r1	@ pretmp_50, tmp201
	beq	.L33		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:81:         if (learnedLimit > 6) {
	cmp	r3, #6	@ learnedLimit,
	ble	.L33		@,
	movs	r3, #6	@ learnedLimit,
.L33:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:86:         if (!IsSkillIDValid(unit->supports[i])) {
	subs	r2, r6, r4	@ tmp278, unit, count
	adds	r1, r3, r4	@ _108, learnedLimit, count
	adds	r2, r2, #50	@ tmp279,
.L35:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:85:     for (int i = 0; i < learnedLimit; ++i) {
	cmp	r4, r1	@ count, _108
	bne	.L37		@,
.L36:
	movs	r3, r6	@ ivtmp.64, unit
	adds	r3, r3, #30	@ ivtmp.64,
	str	r3, [sp]	@ ivtmp.64, %sfp
	adds	r3, r3, #10	@ _91,
	str	r3, [sp, #12]	@ _91, %sfp
.L42:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:93:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp]	@ ivtmp.64, %sfp
	ldrh	r7, [r3]	@ _24, MEM[(short unsigned int *)_6]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:93:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	cmp	r7, #0	@ _24,
	beq	.L41		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L73+12	@ tmp211,
	movs	r0, r7	@, _24
	bl	.L75		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	ldr	r3, .L73+16	@ tmp212,
	ldr	r3, [r3]	@ PassiveSkillBit, PassiveSkillBit
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:95:         if ((GetItemAttributes(temp) & PassiveSkillBit)) {
	tst	r3, r0	@ PassiveSkillBit, tmp282
	beq	.L40		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:96:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r7, r7, #24	@ _18, _24,
	ldr	r3, .L73+20	@ tmp216,
	lsrs	r7, r7, #24	@ _18, _18,
	movs	r0, r7	@, _18
	str	r3, [sp, #8]	@ tmp216, %sfp
	bl	.L75		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:96:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	adds	r0, r0, #4	@ tmp217,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	ldrb	r3, [r0, #31]	@ tmp219,
	subs	r3, r3, #1	@ tmp220,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:96:             if (IsSkillIDValid(GetItemData(temp & 0xFF)->skill)) {
	lsls	r3, r3, #24	@ tmp223, tmp220,
	lsrs	r3, r3, #24	@ tmp223, tmp223,
	cmp	r3, #253	@ tmp223,
	bhi	.L40		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:97:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldr	r3, [sp, #8]	@ tmp216, %sfp
	movs	r0, r7	@, _18
	bl	.L75		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:97:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r0, r0, #4	@ tmp227,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:97:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	ldrb	r2, [r0, #31]	@ tmp228,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:97:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r3, r4, #1	@ count, count,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:97:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	adds	r4, r5, r4	@ tmp226, buffer, count
	strb	r2, [r4, #1]	@ tmp228, buffer_58(D)->skills[count_27]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:99:                 if (!gSkillTestConfig.passiveSkillStack) {
	ldr	r2, [sp, #4]	@ tmp199, %sfp
	ldrb	r2, [r2, #3]	@ tmp231,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:97:                 buffer->skills[count++] = GetItemData(temp & 0xFF)->skill;
	movs	r4, r3	@ count, count
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:99:                 if (!gSkillTestConfig.passiveSkillStack) {
	cmp	r2, #0	@ tmp231,
	beq	.L41		@,
.L40:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:93:     for (int i = 0; i < 5 && unit->items[i]; ++i) {
	ldr	r3, [sp]	@ ivtmp.64, %sfp
	ldr	r2, [sp, #12]	@ _91, %sfp
	adds	r3, r3, #2	@ ivtmp.64,
	str	r3, [sp]	@ ivtmp.64, %sfp
	cmp	r3, r2	@ ivtmp.64, _91
	bne	.L42		@,
.L41:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:108:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r2, #11	@ _25,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:108:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp233,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:108:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldr	r3, .L73+24	@ tmp232,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:108:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r2, [r6, r2]	@ _25,* _25
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:108:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp233,
	cmp	r1, r2	@ tmp233, _25
	bne	.L44		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r1, .L73+28	@ tmp234,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:108:     if (unit->index == gBattleActor.unit.index && IsBattleReal()) {
	ldrh	r1, [r1]	@ gBattleStats, gBattleStats
	lsls	r1, r1, #30	@ tmp287, gBattleStats,
	beq	.L44		@,
.L72:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:112:         temp = gBattleTarget.weaponBefore;
	adds	r3, r3, #74	@ tmp259,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:112:         temp = gBattleTarget.weaponBefore;
	ldrh	r0, [r3]	@ temp,
.L45:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:120:         const ItemData* itemData = GetItemData(temp & 0xFF);
	lsls	r0, r0, #24	@ tmp261, temp,
	ldr	r3, .L73+20	@ tmp263,
	lsrs	r0, r0, #24	@ tmp261, tmp261,
	bl	.L75		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:121:         if (itemData && IsSkillIDValid(itemData->skill)) {
	cmp	r0, #0	@ itemData,
	beq	.L47		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:121:         if (itemData && IsSkillIDValid(itemData->skill)) {
	adds	r0, r0, #4	@ tmp264,
	ldrb	r2, [r0, #31]	@ _33,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r2, #1	@ tmp265, _33,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:121:         if (itemData && IsSkillIDValid(itemData->skill)) {
	lsls	r3, r3, #24	@ tmp268, tmp265,
	lsrs	r3, r3, #24	@ tmp268, tmp268,
	cmp	r3, #253	@ tmp268,
	bhi	.L47		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:122:             buffer->skills[count++] = itemData->skill;
	adds	r3, r5, r4	@ tmp270, buffer, count
	strb	r2, [r3, #1]	@ _33, buffer_58(D)->skills[count_39]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:122:             buffer->skills[count++] = itemData->skill;
	adds	r4, r4, #1	@ count,
.L47:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:127:     buffer->skills[count++] = 0;
	movs	r3, #0	@ tmp273,
	adds	r4, r5, r4	@ tmp272, buffer, count
	strb	r3, [r4, #1]	@ tmp273, buffer_58(D)->skills[count_40]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:129:     return buffer;
	b	.L30		@
.L37:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:86:         if (!IsSkillIDValid(unit->supports[i])) {
	ldrb	r0, [r2, r4]	@ _14, MEM[(unsigned char *)_114 + _113 * 1]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r0, #1	@ tmp205, _14,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:86:         if (!IsSkillIDValid(unit->supports[i])) {
	lsls	r3, r3, #24	@ tmp208, tmp205,
	lsrs	r3, r3, #24	@ tmp208, tmp208,
	cmp	r3, #253	@ tmp208,
	bhi	.L36		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:89:         buffer->skills[count++] = unit->supports[i];
	adds	r4, r4, #1	@ count,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:89:         buffer->skills[count++] = unit->supports[i];
	strb	r0, [r5, r4]	@ _14, MEM[(unsigned char *)buffer_58(D) + _109 * 1]
	b	.L35		@
.L44:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:111:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	movs	r1, #11	@ tmp247,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:111:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r3, .L73+32	@ tmp246,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:111:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrsb	r1, [r3, r1]	@ tmp247,
	cmp	r1, r2	@ tmp247, _25
	bne	.L46		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L73+28	@ tmp248,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:111:     else if (unit->index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
	lsls	r2, r2, #30	@ tmp288, gBattleStats,
	bne	.L72		@,
.L46:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:116:         temp = GetUnitEquippedWeapon(unit);
	movs	r0, r6	@, unit
	ldr	r3, .L73+36	@ tmp260,
	bl	.L75		@
	b	.L45		@
.L74:
	.align	2
.L73:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:     for (int i = 0; i < 0x100; ++i) {
	movs	r6, #0	@ i,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:136:     int count = 0;
	movs	r4, r6	@ count, i
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:133: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	sub	sp, sp, #28	@,,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:133: AuraSkillBuffer* MakeAuraSkillBuffer(Unit* unit) {
	str	r0, [sp, #4]	@ tmp198, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:134:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r5, .L90	@ buffer,
.L82:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:140:         Unit* other = gUnitLookup[i];
	ldr	r2, .L90+4	@ tmp159,
	lsls	r3, r6, #2	@ tmp157, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _71 * 1]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:142:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:142:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp199,
	beq	.L77		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:142:         if (!IsUnitOnField(other) || unit->index == i) {
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #11]	@ tmp162,
	lsls	r3, r3, #24	@ tmp162, tmp162,
	asrs	r3, r3, #24	@ tmp162, tmp162,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:142:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r3, r6	@ tmp162, i
	beq	.L77		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:147:         buffer = MakeSkillBuffer(other, buffer);
	movs	r1, r5	@, buffer
	movs	r0, r7	@, other
	bl	MakeSkillBuffer		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L90+8	@ tmp163,
	ldrh	r3, [r3]	@ _8, gSkillTestConfig
	str	r3, [sp, #8]	@ _8, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r3, .L90+12	@ tmp194,
	str	r3, [sp, #16]	@ tmp194, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r3, .L90+16	@ tmp195,
	str	r3, [sp, #20]	@ tmp195, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:147:         buffer = MakeSkillBuffer(other, buffer);
	movs	r5, r0	@ buffer, tmp200
	adds	r0, r0, #1	@ ivtmp.89,
.L78:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:150:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	ldrb	r3, [r0]	@ _29, MEM[(unsigned char *)_69]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:150:         for (int j = 0; buffer->skills[j] != 0; ++j) {
	cmp	r3, #0	@ _29,
	bne	.L81		@,
.L77:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp219,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:     for (int i = 0; i < 0x100; ++i) {
	adds	r6, r6, #1	@ i,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:139:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp219, tmp219,
	cmp	r6, r3	@ i, tmp219
	bne	.L82		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:171:     buffer->lastUnitChecked = 0;
	movs	r3, #0	@ tmp187,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:172:     gAuraSkillBuffer[count++].skillID = 0;
	ldr	r0, .L90+16	@ tmp189,
	lsls	r4, r4, #1	@ tmp190, count,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:171:     buffer->lastUnitChecked = 0;
	strb	r3, [r5]	@ tmp187, buffer_30->lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:172:     gAuraSkillBuffer[count++].skillID = 0;
	strb	r3, [r4, r0]	@ tmp187, gAuraSkillBuffer[count_34].skillID
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:175: }
	add	sp, sp, #28	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L81:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #16]	@ tmp194, %sfp
	ldrb	r2, [r2, r3]	@ tmp165, AuraSkillTable
	cmp	r2, #0	@ tmp165,
	beq	.L79		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:151:             if (AuraSkillTable[buffer->skills[j]] && count < gSkillTestConfig.auraSkillBufferLimit) {
	ldr	r2, [sp, #8]	@ _8, %sfp
	cmp	r2, r4	@ _8, count
	ble	.L79		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:                 auraBuffer[count].skillID = buffer->skills[j];
	ldr	r2, [sp, #20]	@ tmp195, %sfp
	lsls	r1, r4, #1	@ tmp166, count,
	adds	r1, r1, r2	@ _11, tmp166, tmp195
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:152:                 auraBuffer[count].skillID = buffer->skills[j];
	strb	r3, [r1]	@ _29, _11->skillID
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	movs	r3, #16	@ tmp170,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #4]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp171,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	ldrsb	r3, [r7, r3]	@ tmp170,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	lsls	r2, r2, #24	@ tmp171, tmp171,
	asrs	r2, r2, #24	@ tmp171, tmp171,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	subs	r2, r3, r2	@ tmp172, tmp170, tmp171
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r3, r2, #31	@ tmp202, tmp172,
	adds	r2, r2, r3	@ tmp173, tmp172, tmp202
	eors	r2, r3	@ tmp173, tmp202
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:155:                            absolute(other->yPos - unit->yPos);
	movs	r3, #17	@ tmp174,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	str	r2, [sp, #12]	@ tmp173, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:155:                            absolute(other->yPos - unit->yPos);
	ldrsb	r3, [r7, r3]	@ tmp174,
	mov	ip, r3	@ tmp174, tmp174
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:155:                            absolute(other->yPos - unit->yPos);
	mov	r2, ip	@ tmp174, tmp174
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:155:                            absolute(other->yPos - unit->yPos);
	ldr	r3, [sp, #4]	@ unit, %sfp
	ldrb	r3, [r3, #17]	@ tmp175,
	lsls	r3, r3, #24	@ tmp175, tmp175,
	asrs	r3, r3, #24	@ tmp175, tmp175,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:155:                            absolute(other->yPos - unit->yPos);
	subs	r3, r2, r3	@ tmp176, tmp174, tmp175
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r2, r3, #31	@ tmp203, tmp176,
	adds	r3, r3, r2	@ tmp177, tmp176, tmp203
	eors	r3, r2	@ tmp177, tmp203
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:154:                 distance = absolute(other->xPos - unit->xPos) +
	ldr	r2, [sp, #12]	@ tmp173, %sfp
	adds	r3, r2, r3	@ distance, tmp173, tmp177
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:157:                 if (distance > 63) {
	cmp	r3, #63	@ distance,
	ble	.L80		@,
	movs	r3, #63	@ distance,
.L80:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:164:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	movs	r2, #11	@ tmp178,
	ldrsb	r2, [r7, r2]	@ tmp178,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:164:                 auraBuffer[count].faction = UNIT_FACTION(other) >> 6;
	asrs	r2, r2, #6	@ tmp179, tmp178,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:162:                 auraBuffer[count].distance = distance;
	lsls	r2, r2, #6	@ tmp181, tmp179,
	orrs	r3, r2	@ tmp184, tmp181
	strb	r3, [r1, #1]	@ tmp184, MEM <unsigned char> [(struct AuraSkillBuffer *)_11 + 1B]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:165:                 ++count;
	adds	r4, r4, #1	@ count,
.L79:
	adds	r0, r0, #1	@ ivtmp.89,
	b	.L78		@
.L91:
	.align	2
.L90:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:180:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:180:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L93		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:181:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:181:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	beq	.L93		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:186:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	movs	r2, #11	@ tmp122,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:186:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldr	r0, .L98	@ tmp123,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:186:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldrsb	r2, [r3, r2]	@ tmp122,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:186:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	ldrb	r3, [r0]	@ gDefenderSkillBuffer, gDefenderSkillBuffer
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:186:     if (unit->index == gDefenderSkillBuffer.lastUnitChecked) {
	cmp	r2, r3	@ tmp122, gDefenderSkillBuffer
	beq	.L94		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:183:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r0, .L98+4	@ buffer,
.L94:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:190:     return IsSkillInBuffer(buffer, skillID);
	bl	IsSkillInBuffer		@
.L93:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:191: }
	@ sp needed	@
	pop	{r4}
	pop	{r1}
	bx	r1
.L99:
	.align	2
.L98:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:195: bool SkillTester(Unit* unit, u8 skillID) {
	movs	r4, r0	@ unit, tmp161
	movs	r5, r1	@ skillID, tmp162
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:196:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:196:     if (skillID == 0)   {return TRUE;}
	cmp	r1, #0	@ skillID,
	beq	.L101		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:197:     if (skillID == 255) {return FALSE;}
	cmp	r1, #255	@ skillID,
	bne	.L102		@,
.L103:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:197:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
.L101:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:226: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L102:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:198:     if (!unit || !unit->pCharacterData || !unit->pClassData) {return FALSE;}
	cmp	r4, #0	@ unit,
	beq	.L103		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:198:     if (!unit || !unit->pCharacterData || !unit->pClassData) {return FALSE;}
	ldr	r3, [r4]	@ unit_20(D)->pCharacterData, unit_20(D)->pCharacterData
	cmp	r3, #0	@ unit_20(D)->pCharacterData,
	beq	.L103		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:198:     if (!unit || !unit->pCharacterData || !unit->pClassData) {return FALSE;}
	ldr	r3, [r4, #4]	@ unit_20(D)->pClassData, unit_20(D)->pClassData
	cmp	r3, #0	@ unit_20(D)->pClassData,
	beq	.L103		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:200:     int index = unit->index;
	movs	r3, #11	@ index,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldr	r2, .L121	@ tmp134,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrb	r2, [r2, #11]	@ tmp135,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:200:     int index = unit->index;
	ldrsb	r3, [r4, r3]	@ index,* index
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #24	@ tmp135, tmp135,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:203:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r6, .L121+4	@ buffer,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	asrs	r2, r2, #24	@ tmp135, tmp135,
	cmp	r2, r3	@ tmp135, index
	bne	.L104		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r2, .L121+8	@ tmp136,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	ldrh	r2, [r2]	@ gBattleStats, gBattleStats
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:207:         buffer = &gDefenderSkillBuffer;
	ldr	r6, .L121+12	@ buffer,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:206:     if (index == gBattleTarget.unit.index && IsBattleReal()) {
	lsls	r2, r2, #30	@ tmp168, gBattleStats,
	bne	.L104		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:203:     SkillBuffer* buffer = &gAttackerSkillBuffer;
	ldr	r6, .L121+4	@ buffer,
.L104:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:210:     if (index != buffer->lastUnitChecked) {
	ldrb	r2, [r6]	@ *buffer_15, *buffer_15
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:210:     if (index != buffer->lastUnitChecked) {
	cmp	r2, r3	@ *buffer_15, index
	beq	.L105		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:211:         MakeSkillBuffer(unit, buffer);
	movs	r1, r6	@, buffer
	movs	r0, r4	@, unit
	bl	MakeSkillBuffer		@
.L105:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:215:     if (IsSkillInBuffer(buffer, skillID)) {
	movs	r1, r5	@, skillID
	movs	r0, r6	@, buffer
	bl	IsSkillInBuffer		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:215:     if (IsSkillInBuffer(buffer, skillID)) {
	cmp	r0, #0	@ tmp163,
	beq	.L106		@,
.L107:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:217:         return !NihilTester(unit, skillID);
	movs	r1, r5	@, skillID
	movs	r0, r4	@, unit
	bl	NihilTester		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:217:         return !NihilTester(unit, skillID);
	movs	r3, #1	@ tmp150,
	eors	r0, r3	@ tmp149, tmp150
	lsls	r0, r0, #24	@ <retval>, tmp149,
	lsrs	r0, r0, #24	@ <retval>, <retval>,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:217:         return !NihilTester(unit, skillID);
	b	.L101		@
.L106:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:221:     if (IsSkillIDValid(CatchEmAllIDLink) && IsSkillInBuffer(buffer, CatchEmAllIDLink)) {
	ldr	r3, .L121+16	@ tmp152,
	ldrb	r1, [r3]	@ CatchEmAllIDLink.13_11, CatchEmAllIDLink
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:5: static bool IsSkillIDValid(u8 skillID) {return skillID != 0 && skillID != 255;}
	subs	r3, r1, #1	@ tmp153, CatchEmAllIDLink.13_11,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:221:     if (IsSkillIDValid(CatchEmAllIDLink) && IsSkillInBuffer(buffer, CatchEmAllIDLink)) {
	lsls	r3, r3, #24	@ tmp156, tmp153,
	lsrs	r3, r3, #24	@ tmp156, tmp156,
	cmp	r3, #253	@ tmp156,
	bhi	.L103		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:221:     if (IsSkillIDValid(CatchEmAllIDLink) && IsSkillInBuffer(buffer, CatchEmAllIDLink)) {
	movs	r0, r6	@, buffer
	bl	IsSkillInBuffer		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:221:     if (IsSkillIDValid(CatchEmAllIDLink) && IsSkillInBuffer(buffer, CatchEmAllIDLink)) {
	cmp	r0, #0	@ tmp165,
	beq	.L103		@,
	b	.L107		@
.L122:
	.align	2
.L121:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:229: bool NewAuraSkillCheck(Unit* unit, u8 skillID, int allyOption, int maxRange) {
	str	r3, [sp, #12]	@ tmp169, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:230:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L142	@ iftmp.15_22,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:229: bool NewAuraSkillCheck(Unit* unit, u8 skillID, int allyOption, int maxRange) {
	movs	r4, r1	@ skillID, tmp167
	movs	r5, r2	@ allyOption, tmp168
	str	r0, [sp, #8]	@ tmp166, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:230:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	str	r3, [sp]	@ iftmp.15_22, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:230:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	lsls	r3, r2, #31	@ tmp172, allyOption,
	bpl	.L124		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:230:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L142+4	@ iftmp.15_22,
	str	r3, [sp]	@ iftmp.15_22, %sfp
.L124:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:232:     if (skillID == 0)   {return TRUE;}
	cmp	r4, #0	@ skillID,
	bne	.L125		@,
.L132:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:232:     if (skillID == 0)   {return TRUE;}
	movs	r0, #1	@ <retval>,
.L126:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:252: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L125:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:233:     if (skillID == 255) {return FALSE;}
	cmp	r4, #255	@ skillID,
	bne	.L127		@,
.L134:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:233:     if (skillID == 255) {return FALSE;}
	movs	r0, #0	@ <retval>,
	b	.L126		@
.L127:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	movs	r7, #0	@ i,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:236:     int limit = gSkillTestConfig.auraSkillBufferLimit;
	ldr	r3, .L142+8	@ tmp140,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:236:     int limit = gSkillTestConfig.auraSkillBufferLimit;
	ldrh	r3, [r3]	@ limit, gSkillTestConfig
	ldr	r6, .L142+12	@ ivtmp.108,
	str	r3, [sp, #4]	@ limit, %sfp
.L128:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	ldr	r3, [sp, #4]	@ limit, %sfp
	cmp	r7, r3	@ i, limit
	bge	.L134		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	ldrb	r2, [r6]	@ _19, MEM[(unsigned char *)_18]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	cmp	r2, #0	@ _19,
	beq	.L134		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:238:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldrb	r1, [r6, #1]	@ *_18, *_18
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:238:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	ldr	r0, [sp, #12]	@ maxRange, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:238:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	lsls	r3, r1, #26	@ tmp145, *_18,
	lsrs	r3, r3, #26	@ tmp146, tmp145,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:238:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r3, r0	@ tmp146, maxRange
	ble	.L129		@,
.L130:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:237:     for (int i = 0; i < limit && auraBuffer[i].skillID; ++i) {
	adds	r7, r7, #1	@ i,
	adds	r6, r6, #2	@ ivtmp.108,
	b	.L128		@
.L129:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:238:         if (auraBuffer[i].distance <= maxRange && auraBuffer[i].skillID == skillID) {
	cmp	r2, r4	@ _19, skillID
	bne	.L130		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:241:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	movs	r0, #11	@ tmp156,
	ldr	r3, [sp, #8]	@ unit, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:241:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	lsrs	r1, r1, #6	@ tmp153, *_18,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:241:             int check = pAllegianceChecker(unit->index, auraBuffer[i].faction << 6);
	ldrsb	r0, [r3, r0]	@ tmp156,
	lsls	r1, r1, #6	@ tmp155, tmp153,
	ldr	r3, [sp]	@ iftmp.15_22, %sfp
	bl	.L75		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:243:             if (allyOption & 2)
	movs	r3, #2	@ tmp180,
	tst	r5, r3	@ allyOption, tmp180
	beq	.L131		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:246:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp157,
	beq	.L132		@,
.L133:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:246:             if (check || (allyOption & 4))
	movs	r3, #4	@ tmp181,
	tst	r5, r3	@ allyOption, tmp181
	beq	.L130		@,
	b	.L132		@
.L131:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:246:             if (check || (allyOption & 4))
	cmp	r0, #0	@ tmp157,
	beq	.L133		@,
	b	.L132		@
.L143:
	.align	2
.L142:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:255: void InitializePreBattleLoop(Unit* attacker, Unit* defender) {
	movs	r4, r0	@ attacker, tmp132
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:256:     MakeAuraSkillBuffer(attacker);
	bl	MakeAuraSkillBuffer		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:257:     MakeSkillBuffer(attacker, &gAttackerSkillBuffer);
	ldr	r1, .L150	@ tmp118,
	movs	r0, r4	@, attacker
	bl	MakeSkillBuffer		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:258:     gDefenderSkillBuffer.lastUnitChecked = 0;
	movs	r3, #0	@ tmp120,
	ldr	r1, .L150+4	@ tmp119,
	strb	r3, [r1]	@ tmp120, gDefenderSkillBuffer.lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:7:     return gBattleStats.config & (BATTLE_CONFIG_REAL | BATTLE_CONFIG_SIMULATE);
	ldr	r3, .L150+8	@ tmp122,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:260:     if (IsBattleReal()) {
	ldrh	r3, [r3]	@ gBattleStats, gBattleStats
	lsls	r3, r3, #30	@ tmp133, gBattleStats,
	beq	.L144		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:261:         MakeSkillBuffer(&gBattleTarget.unit, &gDefenderSkillBuffer);
	ldr	r0, .L150+12	@ tmp131,
	bl	MakeSkillBuffer		@
.L144:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:263: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
.L151:
	.align	2
.L150:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:267:     gAttackerSkillBuffer.lastUnitChecked = 0;
	movs	r2, #0	@ tmp115,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:269: }
	@ sp needed	@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:267:     gAttackerSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L153	@ tmp114,
	strb	r2, [r3]	@ tmp115, gAttackerSkillBuffer.lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:268:     gDefenderSkillBuffer.lastUnitChecked = 0;
	ldr	r3, .L153+4	@ tmp117,
	strb	r2, [r3]	@ tmp115, gDefenderSkillBuffer.lastUnitChecked
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:269: }
	bx	lr
.L154:
	.align	2
.L153:
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
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:273:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L176	@ iftmp.20_32,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:272: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	sub	sp, sp, #20	@,,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:272: u8* GetUnitsInRange(Unit* unit, int allyOption, int range) {
	movs	r5, r1	@ allyOption, tmp191
	str	r0, [sp, #8]	@ tmp190, %sfp
	str	r2, [sp, #12]	@ tmp192, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:273:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	str	r3, [sp, #4]	@ iftmp.20_32, %sfp
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:273:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	lsls	r3, r1, #31	@ tmp198, allyOption,
	bpl	.L156		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:273:     const s8(*pAllegianceChecker)(int, int) = ((allyOption & 1) ? AreAllegiancesAllied : AreAllegiancesEqual);
	ldr	r3, .L176+4	@ iftmp.20_32,
	str	r3, [sp, #4]	@ iftmp.20_32, %sfp
.L156:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:278:     for (int i = 0; i < 0x100; ++i) {
	movs	r4, #0	@ i,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:275:     int count = 0;
	movs	r6, r4	@ count, i
.L163:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:279:         Unit* other = gUnitLookup[i];
	ldr	r2, .L176+8	@ tmp154,
	lsls	r3, r4, #2	@ tmp152, i,
	ldr	r7, [r2, r3]	@ other, MEM[(struct Unit * *)&gUnitLookup + _34 * 1]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:281:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, r7	@, other
	bl	IsUnitOnField		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:281:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, #0	@ tmp193,
	beq	.L160		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:281:         if (!IsUnitOnField(other) || unit->index == i) {
	movs	r0, #11	@ _4,
	ldr	r3, [sp, #8]	@ unit, %sfp
	ldrsb	r0, [r3, r0]	@ _4,* _4
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:281:         if (!IsUnitOnField(other) || unit->index == i) {
	cmp	r0, r4	@ _4, i
	beq	.L160		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:287:             check = !pAllegianceChecker(unit->index, other->index);
	movs	r1, #11	@ _31,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:286:         if (allyOption & 2) {
	movs	r3, #2	@ tmp207,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:287:             check = !pAllegianceChecker(unit->index, other->index);
	ldrsb	r1, [r7, r1]	@ _31,* _31
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:286:         if (allyOption & 2) {
	tst	r5, r3	@ allyOption, tmp207
	beq	.L158		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:287:             check = !pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.20_32, %sfp
	bl	.L75		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:293:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp194,
	beq	.L159		@,
.L162:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:293:         if (check || (allyOption & 4)) {
	movs	r3, #4	@ tmp209,
	tst	r5, r3	@ allyOption, tmp209
	beq	.L160		@,
.L159:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294:             if ((absolute(other->xPos - unit->xPos)
	movs	r3, #16	@ tmp163,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #8]	@ unit, %sfp
	ldrb	r2, [r2, #16]	@ tmp164,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294:             if ((absolute(other->xPos - unit->xPos)
	ldrsb	r3, [r7, r3]	@ tmp163,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294:             if ((absolute(other->xPos - unit->xPos)
	lsls	r2, r2, #24	@ tmp164, tmp164,
	asrs	r2, r2, #24	@ tmp164, tmp164,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294:             if ((absolute(other->xPos - unit->xPos)
	subs	r2, r3, r2	@ tmp165, tmp163, tmp164
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:295:                + absolute(other->yPos - unit->yPos)) <= range) {
	movs	r3, #17	@ tmp167,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r2, #31	@ tmp199, tmp165,
	adds	r2, r2, r1	@ tmp166, tmp165, tmp199
	eors	r2, r1	@ tmp166, tmp199
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:295:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldr	r1, [sp, #8]	@ unit, %sfp
	ldrb	r1, [r1, #17]	@ tmp168,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:295:                + absolute(other->yPos - unit->yPos)) <= range) {
	ldrsb	r3, [r7, r3]	@ tmp167,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:295:                + absolute(other->yPos - unit->yPos)) <= range) {
	lsls	r1, r1, #24	@ tmp168, tmp168,
	asrs	r1, r1, #24	@ tmp168, tmp168,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:295:                + absolute(other->yPos - unit->yPos)) <= range) {
	subs	r3, r3, r1	@ tmp169, tmp167, tmp168
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:4: static int  absolute(int value)        {return value < 0 ? -value : value;}
	asrs	r1, r3, #31	@ tmp200, tmp169,
	adds	r3, r3, r1	@ tmp170, tmp169, tmp200
	eors	r3, r1	@ tmp170, tmp200
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:295:                + absolute(other->yPos - unit->yPos)) <= range) {
	adds	r3, r2, r3	@ tmp171, tmp166, tmp170
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:294:             if ((absolute(other->xPos - unit->xPos)
	ldr	r2, [sp, #12]	@ range, %sfp
	cmp	r3, r2	@ tmp171, range
	ble	.L161		@,
.L160:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:278:     for (int i = 0; i < 0x100; ++i) {
	movs	r3, #128	@ tmp176,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:278:     for (int i = 0; i < 0x100; ++i) {
	adds	r4, r4, #1	@ i,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:278:     for (int i = 0; i < 0x100; ++i) {
	lsls	r3, r3, #1	@ tmp176, tmp176,
	cmp	r4, r3	@ i, tmp176
	bne	.L163		@,
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:302:     gUnitRangeBuffer[count++] = 0;
	movs	r2, #0	@ tmp178,
	ldr	r3, .L176+12	@ tmp177,
	strb	r2, [r3, r6]	@ tmp178, gUnitRangeBuffer[count_28]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:303:     if (!gUnitRangeBuffer[0])
	ldrb	r0, [r3]	@ gUnitRangeBuffer, gUnitRangeBuffer
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:306:     return gUnitRangeBuffer;
	subs	r2, r0, #1	@ tmp186, gUnitRangeBuffer
	sbcs	r0, r0, r2	@ tmp185, gUnitRangeBuffer, tmp186
	rsbs	r0, r0, #0	@ tmp187, tmp185
	ands	r0, r3	@ <retval>, tmp177
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:307: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L158:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:290:             check =  pAllegianceChecker(unit->index, other->index);
	ldr	r3, [sp, #4]	@ iftmp.20_32, %sfp
	bl	.L75		@
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:293:         if (check || (allyOption & 4)) {
	cmp	r0, #0	@ tmp195,
	bne	.L159		@,
	b	.L162		@
.L161:
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:296:                 gUnitRangeBuffer[count++] = i;
	ldr	r3, .L176+12	@ tmp174,
	strb	r4, [r3, r6]	@ i, gUnitRangeBuffer[count_54]
@ c:\Users\Owner\Desktop\Gaming\Nintendo\Game_Boy_Advance\FE7\FEBuilder\BuildFiles\SkillSystem_FE7\EngineHacks\SkillSystem\Internals\NewSkillTester\_src\SkillTester.c:296:                 gUnitRangeBuffer[count++] = i;
	adds	r6, r6, #1	@ count,
	b	.L160		@
.L177:
	.align	2
.L176:
	.word	AreAllegiancesEqual
	.word	AreAllegiancesAllied
	.word	gUnitLookup
	.word	gUnitRangeBuffer
	.size	GetUnitsInRange, .-GetUnitsInRange
	.ident	"GCC: (devkitARM release 63) 13.2.0"
	.code 16
	.align	1
.L75:
	bx	r3
