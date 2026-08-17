	.cpu arm7tdmi
	.arch armv4t
	.fpu softvfp
	.eabi_attribute 20, 1	@ Tag_ABI_FP_denormal
	.eabi_attribute 21, 1	@ Tag_ABI_FP_exceptions
	.eabi_attribute 23, 3	@ Tag_ABI_FP_number_model
	.eabi_attribute 24, 1	@ Tag_ABI_align8_needed
	.eabi_attribute 25, 1	@ Tag_ABI_align8_preserved
	.eabi_attribute 26, 1	@ Tag_ABI_enum_size
	.eabi_attribute 30, 2	@ Tag_ABI_optimization_goals
	.eabi_attribute 34, 0	@ Tag_CPU_unaligned_access
	.eabi_attribute 18, 4	@ Tag_ABI_PCS_wchar_t
	.file	"FE7.c"
@ GNU C17 (devkitARM release 63) version 13.2.0 (arm-none-eabi)
@	compiled by GNU C version 10.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.18-GMP

@ GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
@ options passed: -mcpu=arm7tdmi -mthumb -mthumb-interwork -mtune=arm7tdmi -mlong-calls -march=armv4t -O2
	.text
	.align	1
	.p2align 2,,3
	.global	LoopDebuggerProc
	.syntax unified
	.code	16
	.thumb_func
	.type	LoopDebuggerProc, %function
LoopDebuggerProc:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:365: }
	@ sp needed	@
	bx	lr
	.size	LoopDebuggerProc, .-LoopDebuggerProc
	.align	1
	.p2align 2,,3
	.global	MenuAutoHelpBoxSelect
	.syntax unified
	.code	16
	.thumb_func
	.type	MenuAutoHelpBoxSelect, %function
MenuAutoHelpBoxSelect:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:2610: }
	movs	r0, #0	@,
	@ sp needed	@
	bx	lr
	.size	MenuAutoHelpBoxSelect, .-MenuAutoHelpBoxSelect
	.align	1
	.p2align 2,,3
	.global	DebuggerHelpBox
	.syntax unified
	.code	16
	.thumb_func
	.type	DebuggerHelpBox, %function
DebuggerHelpBox:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:2616: }
	movs	r0, #0	@,
	@ sp needed	@
	bx	lr
	.size	DebuggerHelpBox, .-DebuggerHelpBox
	.align	1
	.p2align 2,,3
	.syntax unified
	.code	16
	.thumb_func
	.type	GetUnitBwlSupportRow, %function
GetUnitBwlSupportRow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:3323:     if (!unit || !unit->pCharacterData)
	cmp	r0, #0	@ unit,
	beq	.L8		@,
@ Data/FE6_FE7.c:3323:     if (!unit || !unit->pCharacterData)
	ldr	r3, [r0]	@ _1, unit_11(D)->pCharacterData
@ Data/FE6_FE7.c:3323:     if (!unit || !unit->pCharacterData)
	cmp	r3, #0	@ _1,
	beq	.L8		@,
@ Data/FE6_FE7.c:3327:     pid = unit->pCharacterData->number;
	ldrb	r4, [r3, #4]	@ _3,
@ Data/FE6_FE7.c:3328:     if (pid < 1 || pid > 0x45)
	subs	r3, r4, #1	@ tmp124, _3,
@ Data/FE6_FE7.c:3328:     if (pid < 1 || pid > 0x45)
	cmp	r3, #68	@ tmp124,
	bhi	.L8		@,
@ Data/FE6_FE7.c:3332:     if (!((void * (*)(int))(0x080A0550 | 1))(pid))
	movs	r0, r4	@, _3
	ldr	r3, .L15	@ tmp125,
	bl	.L17		@
@ Data/FE6_FE7.c:3332:     if (!((void * (*)(int))(0x080A0550 | 1))(pid))
	cmp	r0, #0	@ tmp131,
	beq	.L8		@,
@ Data/FE6_FE7.c:3336:     return gBwlSupportExp + pid * SupportOptions;
	ldr	r3, .L15+4	@ tmp133,
	mov	ip, r3	@ tmp133, tmp133
@ Data/FE6_FE7.c:3336:     return gBwlSupportExp + pid * SupportOptions;
	lsls	r0, r4, #3	@ tmp127, _3,
	subs	r0, r0, r4	@ tmp128, tmp127, _3
@ Data/FE6_FE7.c:3336:     return gBwlSupportExp + pid * SupportOptions;
	add	r0, r0, ip	@ <retval>, tmp133
.L5:
@ Data/FE6_FE7.c:3337: }
	@ sp needed	@
	pop	{r4}
	pop	{r1}
	bx	r1
.L8:
@ Data/FE6_FE7.c:3325:         return NULL;
	movs	r0, #0	@ <retval>,
	b	.L5		@
.L16:
	.align	2
.L15:
	.word	134874449
	.word	33816080
	.size	GetUnitBwlSupportRow, .-GetUnitBwlSupportRow
	.align	1
	.p2align 2,,3
	.global	UnlockGameIfNeeded
	.syntax unified
	.code	16
	.thumb_func
	.type	UnlockGameIfNeeded, %function
UnlockGameIfNeeded:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:208:     int locked = GetGameLock();
	ldr	r4, .L25	@ tmp123,
	bl	.L27		@
@ Data/FE6_FE7.c:209:     while (locked)
	cmp	r0, #0	@ tmp125,
	beq	.L18		@,
	ldr	r5, .L25+4	@ tmp124,
.L20:
@ Data/FE6_FE7.c:211:         UnlockGame();
	bl	.L28		@
@ Data/FE6_FE7.c:212:         locked = GetGameLock();
	bl	.L27		@
@ Data/FE6_FE7.c:209:     while (locked)
	cmp	r0, #0	@ tmp126,
	bne	.L20		@,
.L18:
@ Data/FE6_FE7.c:214: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L26:
	.align	2
.L25:
	.word	GetGameLock
	.word	UnlockGame
	.size	UnlockGameIfNeeded, .-UnlockGameIfNeeded
	.align	1
	.p2align 2,,3
	.global	MenuCancelSelectResumePlayerPhase
	.syntax unified
	.code	16
	.thumb_func
	.type	MenuCancelSelectResumePlayerPhase, %function
MenuCancelSelectResumePlayerPhase:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2621:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L30	@ tmp119,
@ Data/FE6_FE7.c:2624: }
	@ sp needed	@
@ Data/FE6_FE7.c:2621:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L30+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2622:     Proc_Goto(proc, EndLabel);
	movs	r1, #99	@,
	ldr	r3, .L30+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2624: }
	movs	r0, #27	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L31:
	.align	2
.L30:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	MenuCancelSelectResumePlayerPhase, .-MenuCancelSelectResumePlayerPhase
	.align	1
	.p2align 2,,3
	.syntax unified
	.code	16
	.thumb_func
	.type	DisplayVertUiHand, %function
DisplayVertUiHand:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:412:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	ldr	r6, .L36	@ tmp161,
@ Data/FE6_FE7.c:411: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:411: {
	movs	r4, r0	@ x, tmp164
	movs	r5, r1	@ y, tmp165
@ Data/FE6_FE7.c:412:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	bl	.L38		@
@ Data/FE6_FE7.c:412:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	ldr	r7, .L36+4	@ tmp162,
@ Data/FE6_FE7.c:412:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	ldr	r3, [r7]	@ sPrevHandClockFrame, sPrevHandClockFrame
@ Data/FE6_FE7.c:412:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	subs	r0, r0, #1	@ tmp138,
@ Data/FE6_FE7.c:412:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	cmp	r0, r3	@ tmp138, sPrevHandClockFrame
	beq	.L35		@,
	ldr	r3, .L36+8	@ tmp163,
.L33:
@ Data/FE6_FE7.c:418:     sPrevHandScreenPosition.x = x;
	strh	r4, [r3]	@ x, sPrevHandScreenPosition.x
@ Data/FE6_FE7.c:419:     sPrevHandScreenPosition.y = y;
	strh	r5, [r3, #2]	@ y, sPrevHandScreenPosition.y
@ Data/FE6_FE7.c:420:     sPrevHandClockFrame = GetGameClock();
	bl	.L38		@
@ Data/FE6_FE7.c:420:     sPrevHandClockFrame = GetGameClock();
	str	r0, [r7]	@ tmp167, sPrevHandClockFrame
@ Data/FE6_FE7.c:422:     y += (sHandVOffsetLookup[Mod(GetGameClock(), ARRAY_COUNT(sHandVOffsetLookup))] - 14);
	bl	.L38		@
@ Data/FE6_FE7.c:422:     y += (sHandVOffsetLookup[Mod(GetGameClock(), ARRAY_COUNT(sHandVOffsetLookup))] - 14);
	movs	r1, #32	@,
	ldr	r3, .L36+12	@ tmp152,
	bl	.L17		@
@ Data/FE6_FE7.c:423:     PutSprite(2, x, y, sSprite_VertHand, 0);
	movs	r1, #0	@ tmp159,
	ldr	r3, .L36+16	@ tmp153,
@ Data/FE6_FE7.c:422:     y += (sHandVOffsetLookup[Mod(GetGameClock(), ARRAY_COUNT(sHandVOffsetLookup))] - 14);
	adds	r0, r3, r0	@ tmp155, tmp153, tmp169
	ldrb	r2, [r0, #8]	@ tmp156, sHandVOffsetLookup
@ Data/FE6_FE7.c:422:     y += (sHandVOffsetLookup[Mod(GetGameClock(), ARRAY_COUNT(sHandVOffsetLookup))] - 14);
	subs	r2, r2, #14	@ tmp157,
@ Data/FE6_FE7.c:423:     PutSprite(2, x, y, sSprite_VertHand, 0);
	str	r1, [sp]	@ tmp159,
	movs	r0, #2	@,
	movs	r1, r4	@, x
@ Data/FE6_FE7.c:422:     y += (sHandVOffsetLookup[Mod(GetGameClock(), ARRAY_COUNT(sHandVOffsetLookup))] - 14);
	adds	r2, r2, r5	@ y, tmp157, y
@ Data/FE6_FE7.c:423:     PutSprite(2, x, y, sSprite_VertHand, 0);
	ldr	r4, .L36+20	@ tmp160,
	bl	.L27		@
@ Data/FE6_FE7.c:424: }
	add	sp, sp, #12	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L35:
@ Data/FE6_FE7.c:414:         x = (x + sPrevHandScreenPosition.x) >> 1;
	ldr	r3, .L36+8	@ tmp163,
	movs	r1, #0	@ tmp171,
	ldrsh	r2, [r3, r1]	@ sPrevHandScreenPosition, tmp163, tmp171
@ Data/FE6_FE7.c:414:         x = (x + sPrevHandScreenPosition.x) >> 1;
	adds	r4, r2, r4	@ _7, sPrevHandScreenPosition, x
@ Data/FE6_FE7.c:415:         y = (y + sPrevHandScreenPosition.y) >> 1;
	movs	r1, #2	@ tmp172,
	ldrsh	r2, [r3, r1]	@ tmp144, tmp163, tmp172
@ Data/FE6_FE7.c:415:         y = (y + sPrevHandScreenPosition.y) >> 1;
	adds	r5, r2, r5	@ _10, tmp144, y
@ Data/FE6_FE7.c:414:         x = (x + sPrevHandScreenPosition.x) >> 1;
	asrs	r4, r4, #1	@ x, _7,
@ Data/FE6_FE7.c:415:         y = (y + sPrevHandScreenPosition.y) >> 1;
	asrs	r5, r5, #1	@ y, _10,
	b	.L33		@
.L37:
	.align	2
.L36:
	.word	GetGameClock
	.word	sPrevHandClockFrame
	.word	sPrevHandScreenPosition
	.word	Mod
	.word	.LANCHOR0
	.word	PutSprite
	.size	DisplayVertUiHand, .-DisplayVertUiHand
	.align	1
	.p2align 2,,3
	.global	PlayerPhase_ApplyUnitMovementWithoutMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	PlayerPhase_ApplyUnitMovementWithoutMenu, %function
PlayerPhase_ApplyUnitMovementWithoutMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2013:     gActiveUnit->xPos = gActionData.xMove;
	ldr	r3, .L40	@ tmp118,
@ Data/FE6_FE7.c:2017: }
	@ sp needed	@
@ Data/FE6_FE7.c:2013:     gActiveUnit->xPos = gActionData.xMove;
	ldr	r0, [r3]	@ gActiveUnit.47_2, gActiveUnit
@ Data/FE6_FE7.c:2013:     gActiveUnit->xPos = gActionData.xMove;
	ldr	r3, .L40+4	@ tmp119,
@ Data/FE6_FE7.c:2013:     gActiveUnit->xPos = gActionData.xMove;
	ldrh	r3, [r3, #14]	@ MEM <vector(2) unsigned char> [(unsigned char *)&gActionData + 14B], MEM <vector(2) unsigned char> [(unsigned char *)&gActionData + 14B]
	strh	r3, [r0, #16]	@ MEM <vector(2) unsigned char> [(unsigned char *)&gActionData + 14B], MEM <vector(2) signed char> [(signed char *)gActiveUnit.47_2 + 16B]
@ Data/FE6_FE7.c:2015:     UnitFinalizeMovement(gActiveUnit);
	ldr	r3, .L40+8	@ tmp122,
	bl	.L17		@
@ Data/FE6_FE7.c:2016:     ResetTextFont();
	ldr	r3, .L40+12	@ tmp123,
	bl	.L17		@
@ Data/FE6_FE7.c:2017: }
	pop	{r4}
	pop	{r0}
	bx	r0
.L41:
	.align	2
.L40:
	.word	gActiveUnit
	.word	gActionData
	.word	UnitFinalizeMovement
	.word	ResetTextFont
	.size	PlayerPhase_ApplyUnitMovementWithoutMenu, .-PlayerPhase_ApplyUnitMovementWithoutMenu
	.align	1
	.p2align 2,,3
	.global	ClearActiveUnitStuff
	.syntax unified
	.code	16
	.thumb_func
	.type	ClearActiveUnitStuff, %function
ClearActiveUnitStuff:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
	mov	lr, r9	@,
	mov	r7, r8	@,
@ Data/FE6_FE7.c:2143:     MU_EndAll();
	ldr	r3, .L55	@ tmp140,
@ Data/FE6_FE7.c:2142: {
	push	{r7, lr}	@
@ Data/FE6_FE7.c:2142: {
	mov	r9, r0	@ proc, tmp189
@ Data/FE6_FE7.c:2143:     MU_EndAll();
	bl	.L17		@
@ Data/FE6_FE7.c:2144:     if (gActiveUnit)
	ldr	r3, .L55+4	@ tmp141,
	ldr	r3, [r3]	@ gActiveUnit.53_1, gActiveUnit
@ Data/FE6_FE7.c:2144:     if (gActiveUnit)
	cmp	r3, #0	@ gActiveUnit.53_1,
	beq	.L43		@,
@ Data/FE6_FE7.c:2146:         if (!(gActiveUnit->state & (US_DEAD | US_NOT_DEPLOYED | US_BIT16)))
	ldr	r2, [r3, #12]	@ _2, gActiveUnit.53_1->state
@ Data/FE6_FE7.c:2146:         if (!(gActiveUnit->state & (US_DEAD | US_NOT_DEPLOYED | US_BIT16)))
	ldr	r1, .L55+8	@ tmp143,
@ Data/FE6_FE7.c:2146:         if (!(gActiveUnit->state & (US_DEAD | US_NOT_DEPLOYED | US_BIT16)))
	tst	r2, r1	@ _2, tmp143
	beq	.L54		@,
.L43:
@ Data/FE6_FE7.c:2154:     s8 cameraReturn = EnsureCameraOntoPositionIfValid(proc, gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	ldr	r5, .L55+12	@ tmp146,
	movs	r2, #0	@ tmp193,
	ldrsh	r3, [r5, r2]	@ _5, tmp146, tmp193
@ Data/FE6_FE7.c:2154:     s8 cameraReturn = EnsureCameraOntoPositionIfValid(proc, gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	movs	r1, #2	@ tmp194,
	ldrsh	r2, [r5, r1]	@ _7, tmp146, tmp194
@ Data/FE6_FE7.c:1974:     if (y < 0)
	movs	r1, r3	@ tmp151, _5
	movs	r4, #1	@ <retval>,
	orrs	r1, r2	@ tmp151, _7
	bmi	.L44		@,
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	ldr	r6, .L55+16	@ tmp186,
	movs	r7, #0	@ tmp195,
	ldrsh	r1, [r6, r7]	@ gBmMapSize, tmp186, tmp195
@ Data/FE6_FE7.c:2154:     s8 cameraReturn = EnsureCameraOntoPositionIfValid(proc, gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	movs	r0, r3	@ _10, _5
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	cmp	r3, r1	@ _5, gBmMapSize
	bge	.L44		@,
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	movs	r1, #2	@ tmp196,
	ldrsh	r7, [r6, r1]	@ tmp155, tmp186, tmp196
@ Data/FE6_FE7.c:2154:     s8 cameraReturn = EnsureCameraOntoPositionIfValid(proc, gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	mov	r8, r2	@ _12, _7
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	cmp	r2, r7	@ _7, tmp155
	bge	.L45		@,
@ Data/FE6_FE7.c:1994:     return EnsureCameraOntoPosition(proc, x, y);
	movs	r1, r3	@, _5
	mov	r0, r9	@, proc
	ldr	r3, .L55+20	@ tmp156,
	bl	.L17		@
@ Data/FE6_FE7.c:2155:     cameraReturn ^= 1;
	movs	r3, #1	@ tmp159,
	eors	r0, r3	@ tmp161, tmp159
	lsls	r4, r0, #24	@ tmp162, tmp161,
@ Data/FE6_FE7.c:2156:     SetCursorMapPositionIfValid(gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	movs	r3, #0	@ tmp197,
	ldrsh	r0, [r5, r3]	@ _9, tmp146, tmp197
@ Data/FE6_FE7.c:2156:     SetCursorMapPositionIfValid(gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	movs	r3, #2	@ tmp198,
	ldrsh	r1, [r5, r3]	@ _11, tmp146, tmp198
@ Data/FE6_FE7.c:1974:     if (y < 0)
	movs	r3, r0	@ tmp168, _10
@ Data/FE6_FE7.c:2156:     SetCursorMapPositionIfValid(gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	mov	r8, r1	@ _12, _11
@ Data/FE6_FE7.c:2155:     cameraReturn ^= 1;
	asrs	r4, r4, #24	@ cameraReturn, tmp162,
@ Data/FE6_FE7.c:1974:     if (y < 0)
	orrs	r3, r1	@ tmp168, _12
	bmi	.L44		@,
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	movs	r2, #0	@ tmp199,
	ldrsh	r3, [r6, r2]	@ gBmMapSize, tmp186, tmp199
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	cmp	r0, r3	@ _10, gBmMapSize
	bge	.L44		@,
.L45:
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	movs	r2, #2	@ tmp200,
	ldrsh	r3, [r6, r2]	@ tmp172, tmp186, tmp200
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	cmp	r8, r3	@ _12, tmp172
	bge	.L44		@,
@ Data/FE6_FE7.c:2002:     SetCursorMapPosition(x, y);
	mov	r1, r8	@, _12
	ldr	r3, .L55+24	@ tmp173,
	bl	.L17		@
.L44:
@ Data/FE6_FE7.c:2165: }
	@ sp needed	@
@ Data/FE6_FE7.c:2157:     gBmSt.gameStateBits &= ~BM_FLAG_3;
	movs	r1, #8	@ tmp179,
	ldr	r2, .L55+28	@ tmp174,
	ldrb	r3, [r2, #4]	@ tmp177,
	bics	r3, r1	@ tmp178, tmp179
	strb	r3, [r2, #4]	@ tmp178, gBmSt.gameStateBits
@ Data/FE6_FE7.c:2159:     HideMoveRangeGraphics();
	ldr	r3, .L55+32	@ tmp181,
	bl	.L17		@
@ Data/FE6_FE7.c:2161:     RefreshEntityBmMaps();
	ldr	r3, .L55+36	@ tmp182,
	bl	.L17		@
@ Data/FE6_FE7.c:2162:     RefreshUnitSprites();
	ldr	r3, .L55+40	@ tmp183,
	bl	.L17		@
@ Data/FE6_FE7.c:2163:     RenderBmMap();
	ldr	r3, .L55+44	@ tmp184,
	bl	.L17		@
@ Data/FE6_FE7.c:2165: }
	movs	r0, r4	@, <retval>
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L54:
@ Data/FE6_FE7.c:2150:             gActiveUnit->state &= ~(US_HIDDEN | US_UNSELECTABLE | US_CANTOING);
	movs	r1, #67	@ tmp145,
	bics	r2, r1	@ tmp144, tmp145
	str	r2, [r3, #12]	@ tmp144, gActiveUnit.53_1->state
	b	.L43		@
.L56:
	.align	2
.L55:
	.word	MU_EndAll
	.word	gActiveUnit
	.word	65548
	.word	gActiveUnitMoveOrigin
	.word	gBmMapSize
	.word	EnsureCameraOntoPosition
	.word	SetCursorMapPosition
	.word	gBmSt
	.word	HideMoveRangeGraphics
	.word	RefreshEntityBmMaps
	.word	RefreshUnitSprites
	.word	RenderBmMap
	.size	ClearActiveUnitStuff, .-ClearActiveUnitStuff
	.align	1
	.p2align 2,,3
	.global	CheckKeysForCheatCode
	.syntax unified
	.code	16
	.thumb_func
	.type	CheckKeysForCheatCode, %function
CheckKeysForCheatCode:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:2544:     int keys = gKeyStatusPtr->newKeys;
	ldr	r5, .L74	@ tmp182,
	ldr	r3, [r5]	@ gKeyStatusPtr.70_1, gKeyStatusPtr
	ldrh	r4, [r3, #8]	@ _2,
@ Data/FE6_FE7.c:2543: {
	movs	r6, r0	@ proc, tmp183
@ Data/FE6_FE7.c:2545:     if (!keys)
	cmp	r4, #0	@ _2,
	beq	.L57		@,
@ Data/FE6_FE7.c:2550:     if (KonamiCodeEnabled)
	ldr	r2, .L74+4	@ tmp137,
@ Data/FE6_FE7.c:2550:     if (KonamiCodeEnabled)
	ldr	r2, [r2]	@ KonamiCodeEnabled, KonamiCodeEnabled
	cmp	r2, #0	@ KonamiCodeEnabled,
	beq	.L61		@,
@ Data/FE6_FE7.c:2552:         if (KonamiCodeSequence[proc->id] & keys)
	ldr	r2, [r0, #44]	@ _4, proc_19(D)->id
@ Data/FE6_FE7.c:2552:         if (KonamiCodeSequence[proc->id] & keys)
	ldr	r0, .L74+8	@ tmp139,
	lsls	r1, r2, #1	@ tmp140, _4,
	adds	r1, r0, r1	@ tmp141, tmp139, tmp140
@ Data/FE6_FE7.c:2552:         if (KonamiCodeSequence[proc->id] & keys)
	ldrh	r1, [r1, #40]	@ tmp144, KonamiCodeSequence
	tst	r1, r4	@ tmp144, _2
	beq	.L62		@,
@ Data/FE6_FE7.c:2554:             proc->id++;
	adds	r2, r2, #1	@ _6,
	str	r2, [r6, #44]	@ _6, proc_19(D)->id
@ Data/FE6_FE7.c:2567:         if (!KonamiCodeSequence[proc->id])
	lsls	r2, r2, #1	@ tmp151, _6,
	adds	r0, r0, r2	@ tmp152, tmp139, tmp151
@ Data/FE6_FE7.c:2567:         if (!KonamiCodeSequence[proc->id])
	ldrh	r2, [r0, #40]	@ tmp154, KonamiCodeSequence
	cmp	r2, #0	@ tmp154,
	bne	.L61		@,
@ Data/FE6_FE7.c:2569:             ToggleFlag(DebuggerTurnedOff_Flag);
	ldr	r3, .L74+12	@ tmp161,
	ldr	r7, [r3]	@ DebuggerTurnedOff_Flag.72_9, DebuggerTurnedOff_Flag
@ Data/FE6_FE7.c:2532:     if (CheckFlag(flag))
	ldr	r3, .L74+16	@ tmp162,
	movs	r0, r7	@, DebuggerTurnedOff_Flag.72_9
	bl	.L17		@
@ Data/FE6_FE7.c:2532:     if (CheckFlag(flag))
	cmp	r0, #0	@ tmp184,
	beq	.L65		@,
@ Data/FE6_FE7.c:2534:         ClearFlag(flag);
	movs	r0, r7	@, DebuggerTurnedOff_Flag.72_9
	ldr	r3, .L74+20	@ tmp165,
	bl	.L17		@
.L66:
@ Data/FE6_FE7.c:2570:             proc->id = 0;
	movs	r3, #0	@ tmp167,
	str	r3, [r6, #44]	@ tmp167, proc_19(D)->id
@ Data/FE6_FE7.c:2573:     keys |= gKeyStatusPtr->heldKeys;
	ldr	r3, [r5]	@ gKeyStatusPtr.70_1, gKeyStatusPtr
.L61:
	ldrh	r2, [r3, #4]	@ _11,
@ Data/FE6_FE7.c:2574:     if (KeyComboToDisableFlag)
	ldr	r3, .L74+24	@ tmp169,
	ldr	r3, [r3]	@ KeyComboToDisableFlag.74_12, KeyComboToDisableFlag
@ Data/FE6_FE7.c:2574:     if (KeyComboToDisableFlag)
	cmp	r3, #0	@ KeyComboToDisableFlag.74_12,
	beq	.L57		@,
.L73:
@ Data/FE6_FE7.c:2576:         if ((keys & KEYS_MASK) == KeyComboToDisableFlag)
	orrs	r4, r2	@ tmp170, _11
	lsls	r4, r4, #22	@ tmp173, tmp170,
	lsrs	r4, r4, #22	@ tmp174, tmp173,
@ Data/FE6_FE7.c:2576:         if ((keys & KEYS_MASK) == KeyComboToDisableFlag)
	cmp	r3, r4	@ KeyComboToDisableFlag.74_12, tmp174
	beq	.L72		@,
.L57:
@ Data/FE6_FE7.c:2581: }
	@ sp needed	@
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L62:
@ Data/FE6_FE7.c:2558:             if (keys & DPAD_UP)
	lsls	r2, r4, #25	@ tmp158, _2,
	lsrs	r2, r2, #31	@ tmp159, tmp158,
	lsls	r2, r2, #1	@ tmp160, tmp159,
@ Data/FE6_FE7.c:2564:                 proc->id = 0;
	str	r2, [r6, #44]	@ tmp160, proc_19(D)->id
@ Data/FE6_FE7.c:2573:     keys |= gKeyStatusPtr->heldKeys;
	ldrh	r2, [r3, #4]	@ _11,
@ Data/FE6_FE7.c:2574:     if (KeyComboToDisableFlag)
	ldr	r3, .L74+24	@ tmp169,
	ldr	r3, [r3]	@ KeyComboToDisableFlag.74_12, KeyComboToDisableFlag
@ Data/FE6_FE7.c:2574:     if (KeyComboToDisableFlag)
	cmp	r3, #0	@ KeyComboToDisableFlag.74_12,
	beq	.L57		@,
	b	.L73		@
.L72:
@ Data/FE6_FE7.c:2578:             ToggleFlag(DebuggerTurnedOff_Flag);
	ldr	r3, .L74+12	@ tmp176,
	ldr	r4, [r3]	@ DebuggerTurnedOff_Flag.76_14, DebuggerTurnedOff_Flag
@ Data/FE6_FE7.c:2532:     if (CheckFlag(flag))
	ldr	r3, .L74+16	@ tmp177,
	movs	r0, r4	@, DebuggerTurnedOff_Flag.76_14
	bl	.L17		@
@ Data/FE6_FE7.c:2532:     if (CheckFlag(flag))
	cmp	r0, #0	@ tmp185,
	beq	.L68		@,
@ Data/FE6_FE7.c:2534:         ClearFlag(flag);
	movs	r0, r4	@, DebuggerTurnedOff_Flag.76_14
	ldr	r3, .L74+20	@ tmp180,
	bl	.L17		@
	b	.L57		@
.L65:
@ Data/FE6_FE7.c:2538:         SetFlag(flag);
	movs	r0, r7	@, DebuggerTurnedOff_Flag.72_9
	ldr	r3, .L74+28	@ tmp166,
	bl	.L17		@
	b	.L66		@
.L68:
	movs	r0, r4	@, DebuggerTurnedOff_Flag.76_14
	ldr	r3, .L74+28	@ tmp181,
	bl	.L17		@
	b	.L57		@
.L75:
	.align	2
.L74:
	.word	gKeyStatusPtr
	.word	KonamiCodeEnabled
	.word	.LANCHOR0
	.word	DebuggerTurnedOff_Flag
	.word	CheckFlag
	.word	ClearFlag
	.word	KeyComboToDisableFlag
	.word	SetFlag
	.size	CheckKeysForCheatCode, .-CheckKeysForCheatCode
	.align	1
	.p2align 2,,3
	.global	SetBlendTargetA_
	.syntax unified
	.code	16
	.thumb_func
	.type	SetBlendTargetA_, %function
SetBlendTargetA_:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:32:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) &= ~BLDCNT_TARGETA(1, 1, 1, 1, 1);
	movs	r6, #31	@ tmp161,
@ Data/FE6_FE7.c:34: }
	@ sp needed	@
@ Data/FE6_FE7.c:33:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) |= BLDCNT_TARGETA(bg0, bg1, bg2, bg3, obj);
	ldr	r5, [sp, #16]	@ tmp172, obj
	lsls	r3, r3, #3	@ tmp138, tmp169,
	lsls	r5, r5, #4	@ tmp140, tmp172,
	orrs	r3, r5	@ tmp143, tmp140
	lsls	r4, r2, #2	@ tmp148, tmp168,
	orrs	r3, r0	@ tmp146, tmp166
@ Data/FE6_FE7.c:33:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) |= BLDCNT_TARGETA(bg0, bg1, bg2, bg3, obj);
	ldr	r2, .L77	@ tmp136,
@ Data/FE6_FE7.c:33:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) |= BLDCNT_TARGETA(bg0, bg1, bg2, bg3, obj);
	lsls	r1, r1, #1	@ tmp153, tmp167,
	orrs	r3, r4	@ tmp151, tmp148
	orrs	r3, r1	@ tmp156, tmp153
@ Data/FE6_FE7.c:32:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) &= ~BLDCNT_TARGETA(1, 1, 1, 1, 1);
	ldrh	r1, [r2, #60]	@ MEM[(u16 *)&gLCDControlBuffer + 60B], MEM[(u16 *)&gLCDControlBuffer + 60B]
	bics	r1, r6	@ tmp160, tmp161
@ Data/FE6_FE7.c:33:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) |= BLDCNT_TARGETA(bg0, bg1, bg2, bg3, obj);
	orrs	r3, r1	@ tmp164, tmp160
	strh	r3, [r2, #60]	@ tmp164, MEM[(u16 *)&gLCDControlBuffer + 60B]
@ Data/FE6_FE7.c:34: }
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L78:
	.align	2
.L77:
	.word	gLCDControlBuffer
	.size	SetBlendTargetA_, .-SetBlendTargetA_
	.align	1
	.p2align 2,,3
	.global	SetBlendTargetB_
	.syntax unified
	.code	16
	.thumb_func
	.type	SetBlendTargetB_, %function
SetBlendTargetB_:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, lr}	@
@ Data/FE6_FE7.c:39:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) |= BLDCNT_TARGETB(bg0, bg1, bg2, bg3, obj);
	ldr	r5, [sp, #12]	@ tmp175, obj
@ Data/FE6_FE7.c:40: }
	@ sp needed	@
@ Data/FE6_FE7.c:39:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) |= BLDCNT_TARGETB(bg0, bg1, bg2, bg3, obj);
	lsls	r5, r5, #12	@ tmp141, tmp175,
	lsls	r3, r3, #11	@ tmp139, tmp172,
	lsls	r4, r2, #10	@ tmp146, tmp171,
	orrs	r3, r5	@ tmp144, tmp141
@ Data/FE6_FE7.c:39:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) |= BLDCNT_TARGETB(bg0, bg1, bg2, bg3, obj);
	ldr	r2, .L80	@ tmp137,
@ Data/FE6_FE7.c:39:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) |= BLDCNT_TARGETB(bg0, bg1, bg2, bg3, obj);
	lsls	r1, r1, #9	@ tmp151, tmp170,
	orrs	r3, r4	@ tmp149, tmp146
	lsls	r0, r0, #8	@ tmp156, tmp169,
	orrs	r3, r1	@ tmp154, tmp151
	orrs	r3, r0	@ tmp159, tmp156
@ Data/FE6_FE7.c:38:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) &= ~BLDCNT_TARGETB(1, 1, 1, 1, 1);
	ldrh	r1, [r2, #60]	@ MEM[(u16 *)&gLCDControlBuffer + 60B], MEM[(u16 *)&gLCDControlBuffer + 60B]
	ldr	r0, .L80+4	@ tmp164,
	ands	r1, r0	@ tmp163, tmp164
@ Data/FE6_FE7.c:39:     *((u16 *)(void *)&gLCDControlBuffer.bldcnt) |= BLDCNT_TARGETB(bg0, bg1, bg2, bg3, obj);
	orrs	r3, r1	@ tmp167, tmp163
	strh	r3, [r2, #60]	@ tmp167, MEM[(u16 *)&gLCDControlBuffer + 60B]
@ Data/FE6_FE7.c:40: }
	pop	{r4, r5}
	pop	{r0}
	bx	r0
.L81:
	.align	2
.L80:
	.word	gLCDControlBuffer
	.word	-7937
	.size	SetBlendTargetB_, .-SetBlendTargetB_
	.align	1
	.p2align 2,,3
	.global	BG_GetMapBuffer_
	.syntax unified
	.code	16
	.thumb_func
	.type	BG_GetMapBuffer_, %function
BG_GetMapBuffer_:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:51:     if (bg > 3)
	cmp	r0, #3	@ bg,
	bgt	.L84		@,
@ Data/FE6_FE7.c:55:     return BgTilemapBuffers_[bg];
	ldr	r3, .L85	@ tmp116,
	lsls	r0, r0, #2	@ tmp117, bg,
	adds	r3, r3, r0	@ tmp118, tmp116, tmp117
	ldr	r0, [r3, #64]	@ <retval>, BgTilemapBuffers_[bg_2(D)]
.L82:
@ Data/FE6_FE7.c:56: }
	@ sp needed	@
	bx	lr
.L84:
	ldr	r0, .L85+4	@ <retval>,
@ Data/FE6_FE7.c:55:     return BgTilemapBuffers_[bg];
	b	.L82		@
.L86:
	.align	2
.L85:
	.word	.LANCHOR0
	.word	gBG0TilemapBuffer
	.size	BG_GetMapBuffer_, .-BG_GetMapBuffer_
	.align	1
	.p2align 2,,3
	.global	DrawUiFrame_
	.syntax unified
	.code	16
	.thumb_func
	.type	DrawUiFrame_, %function
DrawUiFrame_:
	@ Function supports interworking.
	@ args = 12, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:59: {
	movs	r0, r1	@ x, tmp122
	movs	r1, r2	@ y, tmp123
	movs	r2, r3	@ width, tmp124
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	ldr	r3, [sp, #24]	@ tmp126, style
	ldr	r4, .L88	@ tmp121,
	str	r3, [sp]	@ tmp126,
	ldr	r3, [sp, #16]	@, height
	bl	.L27		@
@ Data/FE6_FE7.c:61: }
	add	sp, sp, #8	@,,
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
.L89:
	.align	2
.L88:
	.word	PutUiWindowFrame
	.size	DrawUiFrame_, .-DrawUiFrame_
	.align	1
	.p2align 2,,3
	.global	GetStringFromIndexSafe
	.syntax unified
	.code	16
	.thumb_func
	.type	GetStringFromIndexSafe, %function
GetStringFromIndexSafe:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	movs	r3, #128	@ tmp119,
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	subs	r2, r0, #1	@ tmp118, index,
@ Data/FE6_FE7.c:66: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	lsls	r3, r3, #7	@ tmp119, tmp119,
	cmp	r2, r3	@ tmp118, tmp119
	bcc	.L93		@,
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	ldr	r0, .L94	@ <retval>,
.L90:
@ Data/FE6_FE7.c:72: }
	@ sp needed	@
	pop	{r4}
	pop	{r1}
	bx	r1
.L93:
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	ldr	r3, .L94+4	@ tmp120,
	bl	.L17		@
	b	.L90		@
.L95:
	.align	2
.L94:
	.word	BlankString
	.word	GetStringFromIndex
	.size	GetStringFromIndexSafe, .-GetStringFromIndexSafe
	.align	1
	.p2align 2,,3
	.global	InitProc
	.syntax unified
	.code	16
	.thumb_func
	.type	InitProc, %function
InitProc:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:325:     proc->page = 0;
	movs	r2, #128	@ tmp118,
	lsls	r2, r2, #9	@ tmp118, tmp118,
@ Data/FE6_FE7.c:323: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:325:     proc->page = 0;
	str	r2, [r0, #52]	@ tmp118, MEM <unsigned int> [(void *)proc_4(D) + 52B]
@ Data/FE6_FE7.c:338: }
	@ sp needed	@
@ Data/FE6_FE7.c:331:     proc->tileID = 1;
	movs	r2, #1	@ tmp119,
@ Data/FE6_FE7.c:328:     proc->godMode = 0;
	movs	r3, #0	@ tmp116,
@ Data/FE6_FE7.c:331:     proc->tileID = 1;
	strh	r2, [r0, #42]	@ tmp119, proc_4(D)->tileID
@ Data/FE6_FE7.c:332:     proc->id = 0;
	movs	r2, #0	@ tmp117,
@ Data/FE6_FE7.c:328:     proc->godMode = 0;
	strh	r3, [r0, #50]	@ tmp116, MEM <vector(2) unsigned char> [(unsigned char *)proc_4(D) + 50B]
@ Data/FE6_FE7.c:333:     proc->lastTileHovered = 0;
	str	r3, [r0, #44]	@ tmp116, MEM <unsigned int> [(void *)proc_4(D) + 44B]
@ Data/FE6_FE7.c:332:     proc->id = 0;
	adds	r3, r3, #48	@ tmp122,
	strb	r2, [r0, r3]	@ tmp117, proc_4(D)->id
@ Data/FE6_FE7.c:336:         proc->tmp[i] = 0;
	movs	r1, #0	@,
	movs	r2, #30	@,
	ldr	r3, .L97	@ tmp128,
	adds	r0, r0, #64	@ tmp125,
	bl	.L17		@
@ Data/FE6_FE7.c:338: }
	pop	{r4}
	pop	{r0}
	bx	r0
.L98:
	.align	2
.L97:
	.word	memset
	.size	InitProc, .-InitProc
	.align	1
	.p2align 2,,3
	.global	CopyProcVariables
	.syntax unified
	.code	16
	.thumb_func
	.type	CopyProcVariables, %function
CopyProcVariables:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:343:     dst->tileID = src->tileID;
	movs	r2, #42	@ tmp154,
	ldrsh	r3, [r1, r2]	@ _1, src, tmp154
@ Data/FE6_FE7.c:360: }
	@ sp needed	@
@ Data/FE6_FE7.c:343:     dst->tileID = src->tileID;
	strh	r3, [r0, #42]	@ _1, dst_19(D)->tileID
@ Data/FE6_FE7.c:344:     dst->mainID = src->mainID;
	movs	r3, #53	@ tmp130,
	ldrsb	r2, [r1, r3]	@ _2,
@ Data/FE6_FE7.c:344:     dst->mainID = src->mainID;
	strb	r2, [r0, r3]	@ _2, dst_19(D)->mainID
@ Data/FE6_FE7.c:345:     dst->lastTileHovered = src->lastTileHovered;
	ldrh	r3, [r1, #44]	@ _3,
@ Data/FE6_FE7.c:345:     dst->lastTileHovered = src->lastTileHovered;
	strh	r3, [r0, #44]	@ _3, dst_19(D)->lastTileHovered
@ Data/FE6_FE7.c:346:     dst->editing = src->editing;
	movs	r3, #46	@ tmp134,
	ldrsb	r2, [r1, r3]	@ _4,
@ Data/FE6_FE7.c:346:     dst->editing = src->editing;
	strb	r2, [r0, r3]	@ _4, dst_19(D)->editing
@ Data/FE6_FE7.c:347:     dst->actionID = src->actionID;
	adds	r3, r3, #1	@ tmp137,
	ldrb	r2, [r1, r3]	@ _5,
@ Data/FE6_FE7.c:347:     dst->actionID = src->actionID;
	strb	r2, [r0, r3]	@ _5, dst_19(D)->actionID
@ Data/FE6_FE7.c:348:     dst->id = src->id;
	ldrh	r3, [r1, #48]	@ MEM <vector(2) signed char> [(signed char *)src_18(D) + 48B], MEM <vector(2) signed char> [(signed char *)src_18(D) + 48B]
@ Data/FE6_FE7.c:348:     dst->id = src->id;
	strh	r3, [r0, #48]	@ MEM <vector(2) signed char> [(signed char *)src_18(D) + 48B], MEM <vector(2) signed char> [(signed char *)dst_19(D) + 48B]
@ Data/FE6_FE7.c:351:     dst->page = src->page;
	movs	r3, #52	@ tmp142,
@ Data/FE6_FE7.c:341: {
	movs	r5, r1	@ src, tmp152
@ Data/FE6_FE7.c:350:     dst->godMode = src->godMode;
	ldrh	r2, [r1, #50]	@ MEM <vector(2) unsigned char> [(unsigned char *)src_18(D) + 50B], MEM <vector(2) unsigned char> [(unsigned char *)src_18(D) + 50B]
@ Data/FE6_FE7.c:351:     dst->page = src->page;
	ldrb	r1, [r1, r3]	@ _9,
@ Data/FE6_FE7.c:351:     dst->page = src->page;
	strb	r1, [r0, r3]	@ _9, dst_19(D)->page
@ Data/FE6_FE7.c:357:         dst->tmp[i] = src->tmp[i];
	movs	r1, r5	@ tmp148, src
@ Data/FE6_FE7.c:341: {
	movs	r4, r0	@ dst, tmp151
@ Data/FE6_FE7.c:352:     dst->lastFlag = src->lastFlag;
	ldrh	r3, [r5, #54]	@ _10,
@ Data/FE6_FE7.c:352:     dst->lastFlag = src->lastFlag;
	strh	r3, [r0, #54]	@ _10, dst_19(D)->lastFlag
@ Data/FE6_FE7.c:353:     dst->gold = src->gold;
	ldr	r3, [r5, #56]	@ _11, src_18(D)->gold
@ Data/FE6_FE7.c:357:         dst->tmp[i] = src->tmp[i];
	adds	r1, r1, #64	@ tmp148,
@ Data/FE6_FE7.c:353:     dst->gold = src->gold;
	str	r3, [r0, #56]	@ _11, dst_19(D)->gold
@ Data/FE6_FE7.c:350:     dst->godMode = src->godMode;
	strh	r2, [r0, #50]	@ MEM <vector(2) unsigned char> [(unsigned char *)src_18(D) + 50B], MEM <vector(2) unsigned char> [(unsigned char *)dst_19(D) + 50B]
@ Data/FE6_FE7.c:357:         dst->tmp[i] = src->tmp[i];
	ldr	r3, .L100	@ tmp150,
	movs	r2, #30	@,
	adds	r0, r0, #64	@ tmp149,
	bl	.L17		@
@ Data/FE6_FE7.c:359:     dst->unit = src->unit;
	ldr	r3, [r5, #60]	@ _14, src_18(D)->unit
@ Data/FE6_FE7.c:359:     dst->unit = src->unit;
	str	r3, [r4, #60]	@ _14, dst_19(D)->unit
@ Data/FE6_FE7.c:360: }
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L101:
	.align	2
.L100:
	.word	memmove
	.size	CopyProcVariables, .-CopyProcVariables
	.align	1
	.p2align 2,,3
	.global	SaveProcVarsToIdler
	.syntax unified
	.code	16
	.thumb_func
	.type	SaveProcVarsToIdler, %function
SaveProcVarsToIdler:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:317: {
	movs	r4, r0	@ proc, tmp120
@ Data/FE6_FE7.c:321: }
	@ sp needed	@
@ Data/FE6_FE7.c:318:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	ldr	r3, .L103	@ tmp118,
	ldr	r0, .L103+4	@ tmp117,
	bl	.L17		@
@ Data/FE6_FE7.c:319:     CopyProcVariables(procIdler, proc);
	movs	r1, r4	@, proc
	bl	CopyProcVariables		@
@ Data/FE6_FE7.c:320:     Proc_End(proc);
	movs	r0, r4	@, proc
	ldr	r3, .L103+8	@ tmp119,
	bl	.L17		@
@ Data/FE6_FE7.c:321: }
	pop	{r4}
	pop	{r0}
	bx	r0
.L104:
	.align	2
.L103:
	.word	Proc_Find
	.word	.LANCHOR0+80
	.word	Proc_End
	.size	SaveProcVarsToIdler, .-SaveProcVarsToIdler
	.align	1
	.p2align 2,,3
	.global	SomeMenuInit
	.syntax unified
	.code	16
	.thumb_func
	.type	SomeMenuInit, %function
SomeMenuInit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:385:     ResetTextFont();
	ldr	r5, .L106	@ tmp115,
@ Data/FE6_FE7.c:396: }
	@ sp needed	@
@ Data/FE6_FE7.c:385:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:386:     SetTextFontGlyphs(0);
	ldr	r4, .L106+4	@ tmp116,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:389:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L106+8	@ tmp117,
	ldr	r3, .L106+12	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:390:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L106+16	@ tmp119,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:391:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:392:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:393:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L106+20	@ tmp122,
	bl	.L17		@
@ Data/FE6_FE7.c:394:     ClearBg0Bg1();
	ldr	r3, .L106+24	@ tmp123,
	bl	.L17		@
@ Data/FE6_FE7.c:395:     ResetText();
	ldr	r3, .L106+28	@ tmp124,
	bl	.L17		@
@ Data/FE6_FE7.c:396: }
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L107:
	.align	2
.L106:
	.word	ResetTextFont
	.word	SetTextFontGlyphs
	.word	gBG0TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.word	SetTextFont
	.word	ClearBg0Bg1
	.word	ResetText
	.size	SomeMenuInit, .-SomeMenuInit
	.align	1
	.p2align 2,,3
	.global	SaveStats
	.syntax unified
	.code	16
	.thumb_func
	.type	SaveStats, %function
SaveStats:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:434:     unit->maxHP = proc->tmp[0];
	movs	r2, #64	@ tmp134,
@ Data/FE6_FE7.c:444: }
	@ sp needed	@
@ Data/FE6_FE7.c:434:     unit->maxHP = proc->tmp[0];
	ldrh	r2, [r0, r2]	@ tmp137,
@ Data/FE6_FE7.c:432:     struct Unit * unit = proc->unit;
	ldr	r3, [r0, #60]	@ unit, proc_20(D)->unit
@ Data/FE6_FE7.c:434:     unit->maxHP = proc->tmp[0];
	strb	r2, [r3, #18]	@ tmp137, unit_21->maxHP
@ Data/FE6_FE7.c:436:     unit->curHP = proc->tmp[1];
	movs	r2, #66	@ tmp138,
@ Data/FE6_FE7.c:436:     unit->curHP = proc->tmp[1];
	ldrh	r2, [r0, r2]	@ tmp141,
	strb	r2, [r3, #19]	@ tmp141, unit_21->curHP
@ Data/FE6_FE7.c:437:     unit->pow = proc->tmp[2];
	movs	r2, #68	@ tmp142,
@ Data/FE6_FE7.c:437:     unit->pow = proc->tmp[2];
	ldrh	r2, [r0, r2]	@ tmp145,
	strb	r2, [r3, #20]	@ tmp145, unit_21->pow
@ Data/FE6_FE7.c:438:     unit->skl = proc->tmp[3];
	movs	r2, #70	@ tmp146,
@ Data/FE6_FE7.c:438:     unit->skl = proc->tmp[3];
	ldrh	r2, [r0, r2]	@ tmp149,
	strb	r2, [r3, #21]	@ tmp149, unit_21->skl
@ Data/FE6_FE7.c:439:     unit->spd = proc->tmp[4];
	movs	r2, #72	@ tmp150,
@ Data/FE6_FE7.c:439:     unit->spd = proc->tmp[4];
	ldrh	r2, [r0, r2]	@ tmp153,
	strb	r2, [r3, #22]	@ tmp153, unit_21->spd
@ Data/FE6_FE7.c:440:     unit->def = proc->tmp[5];
	movs	r2, #74	@ tmp154,
@ Data/FE6_FE7.c:440:     unit->def = proc->tmp[5];
	ldrh	r2, [r0, r2]	@ tmp157,
	strb	r2, [r3, #23]	@ tmp157, unit_21->def
@ Data/FE6_FE7.c:441:     unit->res = proc->tmp[6];
	movs	r2, #76	@ tmp158,
@ Data/FE6_FE7.c:441:     unit->res = proc->tmp[6];
	ldrh	r2, [r0, r2]	@ tmp161,
	strb	r2, [r3, #24]	@ tmp161, unit_21->res
@ Data/FE6_FE7.c:442:     unit->lck = proc->tmp[7];
	movs	r2, #78	@ tmp162,
@ Data/FE6_FE7.c:442:     unit->lck = proc->tmp[7];
	ldrh	r2, [r0, r2]	@ tmp165,
	strb	r2, [r3, #25]	@ tmp165, unit_21->lck
@ Data/FE6_FE7.c:443:     unit->_u3A = proc->tmp[8];
	movs	r2, #80	@ tmp166,
@ Data/FE6_FE7.c:443:     unit->_u3A = proc->tmp[8];
	ldrh	r1, [r0, r2]	@ tmp169,
	subs	r2, r2, #22	@ tmp170,
	strb	r1, [r3, r2]	@ tmp169, unit_21->_u3A
@ Data/FE6_FE7.c:444: }
	bx	lr
	.size	SaveStats, .-SaveStats
	.align	1
	.p2align 2,,3
	.global	SaveItems
	.syntax unified
	.code	16
	.thumb_func
	.type	SaveItems, %function
SaveItems:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, r0	@ proc, tmp142
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	movs	r2, #64	@ tmp126,
@ Data/FE6_FE7.c:447: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:449:     struct Unit * unit = proc->unit;
	ldr	r0, [r0, #60]	@ unit, proc_6(D)->unit
@ Data/FE6_FE7.c:456: }
	@ sp needed	@
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	ldrh	r2, [r3, r2]	@ tmp127,
	strh	r2, [r0, #30]	@ tmp127, unit_7->items[0]
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	movs	r2, #66	@ tmp129,
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	ldrh	r2, [r3, r2]	@ tmp130,
	strh	r2, [r0, #32]	@ tmp130, unit_7->items[1]
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	movs	r2, #68	@ tmp132,
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	ldrh	r2, [r3, r2]	@ tmp133,
	strh	r2, [r0, #34]	@ tmp133, unit_7->items[2]
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	movs	r2, #70	@ tmp135,
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	ldrh	r2, [r3, r2]	@ tmp136,
	strh	r2, [r0, #36]	@ tmp136, unit_7->items[3]
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	movs	r2, #72	@ tmp138,
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r3, r2]	@ tmp139,
	strh	r3, [r0, #38]	@ tmp139, unit_7->items[4]
@ Data/FE6_FE7.c:455:     UnitRemoveInvalidItems(unit);
	ldr	r3, .L110	@ tmp141,
	bl	.L17		@
@ Data/FE6_FE7.c:456: }
	pop	{r4}
	pop	{r0}
	bx	r0
.L111:
	.align	2
.L110:
	.word	UnitRemoveInvalidItems
	.size	SaveItems, .-SaveItems
	.align	1
	.p2align 2,,3
	.global	GetMostSignificantDigit
	.syntax unified
	.code	16
	.thumb_func
	.type	GetMostSignificantDigit, %function
GetMostSignificantDigit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:540:     while (val >= pDigitTable[type][result + 1])
	ldr	r3, .L119	@ tmp124,
	lsls	r1, r1, #2	@ tmp125, tmp133,
	adds	r3, r3, r1	@ tmp126, tmp124, tmp125
	ldr	r3, [r3, #112]	@ _14, pDigitTable[type_10(D)]
@ Data/FE6_FE7.c:540:     while (val >= pDigitTable[type][result + 1])
	ldr	r2, [r3, #4]	@ MEM[(const int *)_14 + 4B], MEM[(const int *)_14 + 4B]
	cmp	r0, r2	@ val, MEM[(const int *)_14 + 4B]
	blt	.L116		@,
@ Data/FE6_FE7.c:539:     int result = 0;
	movs	r2, #0	@ result,
	adds	r3, r3, #8	@ ivtmp.339,
.L114:
@ Data/FE6_FE7.c:540:     while (val >= pDigitTable[type][result + 1])
	adds	r3, r3, #4	@ ivtmp.339,
@ Data/FE6_FE7.c:540:     while (val >= pDigitTable[type][result + 1])
	subs	r1, r3, #4	@ tmp129, ivtmp.339,
@ Data/FE6_FE7.c:540:     while (val >= pDigitTable[type][result + 1])
	ldr	r1, [r1]	@ MEM[(const int *)_8 + 4294967292B], MEM[(const int *)_8 + 4294967292B]
@ Data/FE6_FE7.c:542:         result++;
	adds	r2, r2, #1	@ result,
@ Data/FE6_FE7.c:540:     while (val >= pDigitTable[type][result + 1])
	cmp	r1, r0	@ MEM[(const int *)_8 + 4294967292B], val
	ble	.L114		@,
@ Data/FE6_FE7.c:544:     if (result > 9)
	movs	r0, r2	@ <retval>, result
	cmp	r2, #9	@ <retval>,
	bgt	.L118		@,
.L112:
@ Data/FE6_FE7.c:549: }
	@ sp needed	@
	bx	lr
.L118:
@ Data/FE6_FE7.c:544:     if (result > 9)
	movs	r0, #9	@ <retval>,
	b	.L112		@
.L116:
@ Data/FE6_FE7.c:540:     while (val >= pDigitTable[type][result + 1])
	movs	r0, #0	@ <retval>,
@ Data/FE6_FE7.c:548:     return result;
	b	.L112		@
.L120:
	.align	2
.L119:
	.word	.LANCHOR0
	.size	GetMostSignificantDigit, .-GetMostSignificantDigit
	.align	1
	.p2align 2,,3
	.global	BackPressSFX
	.syntax unified
	.code	16
	.thumb_func
	.type	BackPressSFX, %function
BackPressSFX:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:563: }
	@ sp needed	@
	bx	lr
	.size	BackPressSFX, .-BackPressSFX
	.align	1
	.p2align 2,,3
	.global	ConfirmPressSFX
	.syntax unified
	.code	16
	.thumb_func
	.type	ConfirmPressSFX, %function
ConfirmPressSFX:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	@ sp needed	@
	bx	lr
	.size	ConfirmPressSFX, .-ConfirmPressSFX
	.align	1
	.p2align 2,,3
	.global	RedrawStateMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	RedrawStateMenu, %function
RedrawStateMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, fp	@,
	mov	r7, r10	@,
	mov	r5, r8	@,
	mov	r6, r9	@,
	push	{r5, r6, r7, lr}	@
	movs	r4, r0	@ proc, tmp176
	sub	sp, sp, #20	@,,
@ Data/FE6_FE7.c:746:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * NumberOfOptions, 0);
	movs	r2, #18	@,
	movs	r3, #0	@,
	movs	r1, #9	@,
	ldr	r5, .L137	@ tmp153,
	ldr	r0, .L137+4	@ tmp152,
	bl	.L28		@
@ Data/FE6_FE7.c:752:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	movs	r3, #66	@ tmp154,
	ldrsh	r3, [r4, r3]	@ tmp155,
@ Data/FE6_FE7.c:752:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	movs	r2, #64	@ tmp157,
	ldrsh	r2, [r4, r2]	@ tmp158,
@ Data/FE6_FE7.c:752:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsls	r3, r3, #16	@ tmp156, tmp155,
@ Data/FE6_FE7.c:752:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	orrs	r3, r2	@ tmp156, tmp158
	mov	r8, r3	@ _7, tmp156
	ldr	r3, .L137+8	@ ivtmp.401,
	mov	fp, r3	@ ivtmp.401, ivtmp.401
	movs	r3, #128	@ _145,
	mov	r4, fp	@ ivtmp.412, ivtmp.401
@ Data/FE6_FE7.c:754:     for (int i = 0; i < NumberOfState; ++i)
	movs	r5, #0	@ i,
	lsls	r3, r3, #1	@ _145, _145,
	add	r3, r3, fp	@ _145, ivtmp.401
	mov	r10, r3	@ _145, _145
	ldr	r3, .L137+12	@ tmp171,
	mov	r9, r3	@ tmp171, tmp171
@ Data/FE6_FE7.c:764:             ClearText(&th[i]);
	ldr	r3, .L137+16	@ tmp173,
	str	r3, [sp, #4]	@ tmp173, %sfp
@ Data/FE6_FE7.c:765:             Text_SetColor(&th[i], c);
	ldr	r3, .L137+20	@ tmp174,
	str	r3, [sp, #8]	@ tmp174, %sfp
@ Data/FE6_FE7.c:766:             Text_DrawString(&th[i], states[i]);
	ldr	r3, .L137+24	@ tmp175,
	ldr	r7, .L137+28	@ ivtmp.414,
	str	r3, [sp, #12]	@ tmp175, %sfp
.L126:
@ Data/FE6_FE7.c:756:         c = state & (1 << i);
	movs	r3, #1	@ tmp161,
	mov	r6, r8	@ c, _7
	lsls	r3, r3, r5	@ tmp160, tmp161, i
@ Data/FE6_FE7.c:757:         if (c)
	mov	r2, r8	@ _7, _7
	ands	r6, r3	@ c, tmp160
	tst	r2, r3	@ _7, tmp160
	beq	.L124		@,
@ Data/FE6_FE7.c:759:             c = TEXT_COLOR_SYSTEM_GOLD;
	movs	r6, #3	@ c,
.L124:
@ Data/FE6_FE7.c:762:         if (Text_GetColor(&th[i]) != c)
	movs	r0, r4	@, ivtmp.412
	bl	.L139		@
@ Data/FE6_FE7.c:762:         if (Text_GetColor(&th[i]) != c)
	cmp	r0, r6	@ tmp177, c
	beq	.L125		@,
@ Data/FE6_FE7.c:764:             ClearText(&th[i]);
	movs	r0, r4	@, ivtmp.412
	ldr	r3, [sp, #4]	@ tmp173, %sfp
	bl	.L17		@
@ Data/FE6_FE7.c:765:             Text_SetColor(&th[i], c);
	movs	r1, r6	@, c
	movs	r0, r4	@, ivtmp.412
	ldr	r3, [sp, #8]	@ tmp174, %sfp
	bl	.L17		@
@ Data/FE6_FE7.c:766:             Text_DrawString(&th[i], states[i]);
	movs	r1, r7	@, ivtmp.414
	movs	r0, r4	@, ivtmp.412
	ldr	r3, [sp, #12]	@ tmp175, %sfp
	bl	.L17		@
.L125:
@ Data/FE6_FE7.c:754:     for (int i = 0; i < NumberOfState; ++i)
	adds	r4, r4, #8	@ ivtmp.412,
@ Data/FE6_FE7.c:754:     for (int i = 0; i < NumberOfState; ++i)
	adds	r5, r5, #1	@ i,
@ Data/FE6_FE7.c:754:     for (int i = 0; i < NumberOfState; ++i)
	adds	r7, r7, #16	@ ivtmp.414,
	cmp	r4, r10	@ ivtmp.412, _145
	bne	.L126		@,
	movs	r3, #132	@ _135,
	rsbs	r3, r3, #0	@ _135, _135
	mov	r8, r3	@ _135, _135
	movs	r3, #128	@ tmp196,
	ldr	r4, .L137+32	@ ivtmp.403,
	lsls	r3, r3, #3	@ tmp196, tmp196,
	ldr	r5, .L137+36	@ tmp172,
	add	r8, r8, r4	@ _135, ivtmp.403
	adds	r6, r4, r3	@ _136, ivtmp.403, tmp196
.L127:
@ Data/FE6_FE7.c:774:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	movs	r1, r4	@, ivtmp.403
	mov	r0, fp	@, ivtmp.401
	bl	.L28		@
@ Data/FE6_FE7.c:772:     for (int i = 0; i < 8; ++i)
	movs	r3, #8	@ tmp197,
	mov	ip, r3	@ tmp197, tmp197
	adds	r4, r4, #128	@ ivtmp.403,
	add	fp, fp, ip	@ ivtmp.401, tmp197
	cmp	r4, r6	@ ivtmp.403, _136
	bne	.L127		@,
	ldr	r7, .L137+40	@ _126,
	ldr	r6, .L137+44	@ ivtmp.390,
	ldr	r4, .L137+48	@ ivtmp.392,
	add	r7, r7, r8	@ _126, _135
.L128:
@ Data/FE6_FE7.c:780:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	movs	r1, r4	@, ivtmp.392
	movs	r0, r6	@, ivtmp.390
@ Data/FE6_FE7.c:778:     for (int i = 0; i < 8; ++i)
	adds	r4, r4, #128	@ ivtmp.392,
@ Data/FE6_FE7.c:780:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	bl	.L28		@
@ Data/FE6_FE7.c:778:     for (int i = 0; i < 8; ++i)
	adds	r6, r6, #8	@ ivtmp.390,
	cmp	r4, r7	@ ivtmp.392, _126
	bne	.L128		@,
	movs	r7, #148	@ _52,
	ldr	r6, .L137+52	@ ivtmp.377,
	lsls	r7, r7, #3	@ _52, _52,
	ldr	r4, .L137+56	@ ivtmp.379,
	add	r7, r7, r8	@ _52, _135
.L129:
@ Data/FE6_FE7.c:786:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	movs	r1, r4	@, ivtmp.379
	movs	r0, r6	@, ivtmp.377
@ Data/FE6_FE7.c:784:     for (int i = 0; i < 8; ++i)
	adds	r4, r4, #128	@ ivtmp.379,
@ Data/FE6_FE7.c:786:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	bl	.L28		@
@ Data/FE6_FE7.c:784:     for (int i = 0; i < 8; ++i)
	adds	r6, r6, #8	@ ivtmp.377,
	cmp	r7, r4	@ _52, ivtmp.379
	bne	.L129		@,
	ldr	r7, .L137+60	@ _83,
	ldr	r6, .L137+64	@ ivtmp.364,
	ldr	r4, .L137+68	@ ivtmp.366,
	add	r7, r7, r8	@ _83, _135
.L130:
@ Data/FE6_FE7.c:792:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	movs	r1, r4	@, ivtmp.366
	movs	r0, r6	@, ivtmp.364
@ Data/FE6_FE7.c:790:     for (int i = 0; i < 8; ++i)
	adds	r4, r4, #128	@ ivtmp.366,
@ Data/FE6_FE7.c:792:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	bl	.L28		@
@ Data/FE6_FE7.c:790:     for (int i = 0; i < 8; ++i)
	adds	r6, r6, #8	@ ivtmp.364,
	cmp	r7, r4	@ _83, ivtmp.366
	bne	.L130		@,
@ Data/FE6_FE7.c:796:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	ldr	r3, .L137+72	@ tmp170,
	bl	.L17		@
@ Data/FE6_FE7.c:797: }
	add	sp, sp, #20	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	mov	fp, r7
	mov	r10, r6
	mov	r9, r5
	mov	r8, r4
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L138:
	.align	2
.L137:
	.word	TileMap_FillRect
	.word	gBG0TilemapBuffer+158
	.word	gStatScreen+24
	.word	Text_GetColor
	.word	ClearText
	.word	Text_SetColor
	.word	Text_DrawString
	.word	states
	.word	gBG0TilemapBuffer+132
	.word	PutText
	.word	1170
	.word	gStatScreen+88
	.word	gBG0TilemapBuffer+146
	.word	gStatScreen+152
	.word	gBG0TilemapBuffer+160
	.word	1198
	.word	gStatScreen+216
	.word	gBG0TilemapBuffer+174
	.word	BG_EnableSyncByMask
	.size	RedrawStateMenu, .-RedrawStateMenu
	.align	1
	.p2align 2,,3
	.global	StateInit
	.syntax unified
	.code	16
	.thumb_func
	.type	StateInit, %function
StateInit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, r9	@,
	mov	r7, r8	@,
	mov	r9, r0	@ proc, tmp143
	push	{r7, lr}	@
@ Data/FE6_FE7.c:385:     ResetTextFont();
	ldr	r5, .L143	@ tmp123,
@ Data/FE6_FE7.c:714: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:385:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:386:     SetTextFontGlyphs(0);
	ldr	r4, .L143+4	@ tmp124,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:389:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L143+8	@ tmp125,
	ldr	r3, .L143+12	@ tmp126,
	bl	.L17		@
@ Data/FE6_FE7.c:390:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L143+16	@ tmp127,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:391:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:392:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:393:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L143+20	@ tmp130,
	bl	.L17		@
@ Data/FE6_FE7.c:394:     ClearBg0Bg1();
	ldr	r3, .L143+24	@ tmp131,
	bl	.L17		@
@ Data/FE6_FE7.c:395:     ResetText();
	ldr	r3, .L143+28	@ tmp132,
	bl	.L17		@
@ Data/FE6_FE7.c:717:     proc->tmp[0] = unit->state;
	mov	r3, r9	@ proc, proc
	mov	r2, r9	@ proc, proc
	ldr	r3, [r3, #60]	@ proc_12(D)->unit, proc_12(D)->unit
	ldr	r3, [r3, #12]	@ MEM[(long unsigned int *)unit_14 + 12B], MEM[(long unsigned int *)unit_14 + 12B]
	str	r3, [r2, #64]	@ MEM[(long unsigned int *)unit_14 + 12B], MEM <unsigned int> [(short int *)proc_12(D) + 64B]
@ Data/FE6_FE7.c:76:     PutUiWindowFrame(x, y, width, height, style);
	movs	r3, #0	@ tmp135,
	ldr	r4, .L143+32	@ tmp136,
	str	r3, [sp]	@ tmp135,
	movs	r2, #29	@,
	adds	r3, r3, #18	@,
	movs	r1, #1	@,
	movs	r0, #1	@,
	bl	.L27		@
	ldr	r4, .L143+36	@ ivtmp.425,
	adds	r3, r4, #1	@ _43, ivtmp.425,
	adds	r3, r3, #255	@ _43,
	mov	r8, r3	@ _43, _43
	ldr	r5, .L143+40	@ ivtmp.427,
	ldr	r7, .L143+44	@ tmp141,
	ldr	r6, .L143+48	@ tmp142,
.L141:
@ Data/FE6_FE7.c:737:         InitText(&th[i], StateWidth);
	movs	r0, r4	@, ivtmp.425
	movs	r1, #7	@,
	bl	.L145		@
@ Data/FE6_FE7.c:738:         Text_DrawString(&th[i], states[i]);
	movs	r1, r5	@, ivtmp.427
	movs	r0, r4	@, ivtmp.425
@ Data/FE6_FE7.c:735:     for (int i = 0; i < NumberOfState; ++i)
	adds	r4, r4, #8	@ ivtmp.425,
@ Data/FE6_FE7.c:738:         Text_DrawString(&th[i], states[i]);
	bl	.L38		@
@ Data/FE6_FE7.c:735:     for (int i = 0; i < NumberOfState; ++i)
	adds	r5, r5, #16	@ ivtmp.427,
	cmp	r4, r8	@ ivtmp.425, _43
	bne	.L141		@,
@ Data/FE6_FE7.c:740:     StartGreenText(proc);
	mov	r0, r9	@, proc
	ldr	r3, .L143+52	@ tmp140,
	bl	.L17		@
@ Data/FE6_FE7.c:741:     RedrawStateMenu(proc);
	mov	r0, r9	@, proc
	bl	RedrawStateMenu		@
@ Data/FE6_FE7.c:742: }
	add	sp, sp, #12	@,,
	@ sp needed	@
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L144:
	.align	2
.L143:
	.word	ResetTextFont
	.word	SetTextFontGlyphs
	.word	gBG0TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.word	SetTextFont
	.word	ClearBg0Bg1
	.word	ResetText
	.word	PutUiWindowFrame
	.word	gStatScreen+24
	.word	states
	.word	InitText
	.word	Text_DrawString
	.word	StartGreenText
	.size	StateInit, .-StateInit
	.align	1
	.p2align 2,,3
	.global	StateIdle
	.syntax unified
	.code	16
	.thumb_func
	.type	StateIdle, %function
StateIdle:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:806:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L183	@ tmp152,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r5, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:807:     if ((keys & START_BUTTON) || (keys & B_BUTTON))
	movs	r3, #10	@ tmp156,
@ Data/FE6_FE7.c:805: {
	movs	r6, r0	@ proc, tmp229
@ Data/FE6_FE7.c:807:     if ((keys & START_BUTTON) || (keys & B_BUTTON))
	tst	r3, r5	@ tmp156, keys
	bne	.L179		@,
.L147:
@ Data/FE6_FE7.c:813:     u32 id = proc->id;
	movs	r3, #48	@ tmp161,
@ Data/FE6_FE7.c:814:     if ((keys & A_BUTTON))
	movs	r2, #1	@ tmp163,
@ Data/FE6_FE7.c:813:     u32 id = proc->id;
	ldrsb	r4, [r6, r3]	@ id,
@ Data/FE6_FE7.c:814:     if ((keys & A_BUTTON))
	tst	r2, r5	@ tmp163, keys
	bne	.L180		@,
.L148:
@ Data/FE6_FE7.c:826:     DisplayUiHand(StateCursorLocationTable[id].x, StateCursorLocationTable[id].y);
	ldr	r3, .L183+4	@ tmp182,
	lsls	r2, r4, #3	@ tmp183, id,
	adds	r1, r3, r2	@ tmp184, tmp182, tmp183
@ Data/FE6_FE7.c:826:     DisplayUiHand(StateCursorLocationTable[id].x, StateCursorLocationTable[id].y);
	ldr	r0, [r2, r3]	@ StateCursorLocationTable[id_34].x, StateCursorLocationTable[id_34].x
	ldr	r1, [r1, #4]	@ StateCursorLocationTable[id_34].y, StateCursorLocationTable[id_34].y
	ldr	r3, .L183+8	@ tmp190,
	bl	.L17		@
@ Data/FE6_FE7.c:828:     if (keys & DPAD_RIGHT)
	lsls	r3, r5, #27	@ tmp230, keys,
	bpl	.L149		@,
@ Data/FE6_FE7.c:830:         id += 8;
	adds	r4, r4, #8	@ id,
.L149:
@ Data/FE6_FE7.c:832:     if (keys & DPAD_LEFT)
	lsls	r3, r5, #26	@ tmp231, keys,
	bpl	.L150		@,
@ Data/FE6_FE7.c:834:         id -= 8;
	subs	r4, r4, #8	@ id,
.L150:
@ Data/FE6_FE7.c:836:     if (keys & DPAD_UP)
	lsls	r3, r5, #25	@ tmp232, keys,
	bpl	.L151		@,
@ Data/FE6_FE7.c:838:         if (!(id % 8))
	lsls	r3, r4, #29	@ tmp233, id,
	beq	.L181		@,
.L152:
@ Data/FE6_FE7.c:842:         id--;
	subs	r4, r4, #1	@ id,
.L151:
@ Data/FE6_FE7.c:844:     if (keys & DPAD_DOWN)
	lsls	r5, r5, #24	@ tmp234, keys,
	bpl	.L153		@,
@ Data/FE6_FE7.c:847:         id++;
	adds	r3, r4, #1	@ id, id,
@ Data/FE6_FE7.c:850:             id -= 8;
	subs	r4, r4, #7	@ id,
@ Data/FE6_FE7.c:848:         if (!(id % 8))
	lsls	r2, r3, #29	@ tmp235, id,
	bne	.L182		@,
.L153:
@ Data/FE6_FE7.c:854:     if (id != (int)proc->id)
	movs	r3, #48	@ tmp223,
@ Data/FE6_FE7.c:854:     if (id != (int)proc->id)
	ldrsb	r2, [r6, r3]	@ tmp224,
@ Data/FE6_FE7.c:854:     if (id != (int)proc->id)
	cmp	r2, r4	@ tmp224, id
	beq	.L146		@,
@ Data/FE6_FE7.c:856:         id %= NumberOfState;
	movs	r2, #31	@ tmp225,
	ands	r2, r4	@ id, id
@ Data/FE6_FE7.c:858:         RedrawStateMenu(proc);
	movs	r0, r6	@, proc
@ Data/FE6_FE7.c:857:         proc->id = id;
	strb	r2, [r6, r3]	@ id, proc_32(D)->id
@ Data/FE6_FE7.c:858:         RedrawStateMenu(proc);
	bl	RedrawStateMenu		@
.L146:
@ Data/FE6_FE7.c:860: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L182:
@ Data/FE6_FE7.c:847:         id++;
	movs	r4, r3	@ id, id
	b	.L153		@
.L181:
@ Data/FE6_FE7.c:840:             id += 8;
	adds	r4, r4, #8	@ id,
	b	.L152		@
.L180:
@ Data/FE6_FE7.c:816:         u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	adds	r3, r3, #18	@ tmp169,
	ldrsh	r3, [r6, r3]	@ tmp170,
@ Data/FE6_FE7.c:816:         u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	movs	r1, #64	@ tmp172,
@ Data/FE6_FE7.c:817:         state ^= (1 << id);
	lsls	r2, r2, r4	@ tmp175, tmp163, id
@ Data/FE6_FE7.c:816:         u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	ldrsh	r1, [r6, r1]	@ tmp173,
@ Data/FE6_FE7.c:816:         u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsls	r3, r3, #16	@ tmp171, tmp170,
@ Data/FE6_FE7.c:816:         u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	orrs	r3, r1	@ tmp174, tmp173
	eors	r3, r2	@ _58, tmp175
@ Data/FE6_FE7.c:820:         proc->tmp[0] = state & 0xffff;
	str	r3, [r6, #64]	@ _58, MEM <unsigned int> [(short int *)proc_32(D) + 64B]
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsrs	r2, r3, #16	@ tmp179, _58,
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsls	r3, r3, #16	@ _58, _58,
@ Data/FE6_FE7.c:801:     proc->unit->state = state;
	ldr	r1, [r6, #60]	@ proc_32(D)->unit, proc_32(D)->unit
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsls	r2, r2, #16	@ tmp178, tmp179,
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	asrs	r3, r3, #16	@ _58, _58,
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	orrs	r3, r2	@ state, tmp178
@ Data/FE6_FE7.c:823:         RedrawStateMenu(proc);
	movs	r0, r6	@, proc
@ Data/FE6_FE7.c:801:     proc->unit->state = state;
	str	r3, [r1, #12]	@ state, _55->state
@ Data/FE6_FE7.c:823:         RedrawStateMenu(proc);
	bl	RedrawStateMenu		@
	b	.L148		@
.L179:
@ Data/FE6_FE7.c:810:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	ldr	r3, .L183+12	@ tmp160,
	bl	.L17		@
@ Data/FE6_FE7.c:576: }
	b	.L147		@
.L184:
	.align	2
.L183:
	.word	gKeyStatusPtr
	.word	StateCursorLocationTable
	.word	DisplayUiHand
	.word	Proc_Goto
	.size	StateIdle, .-StateIdle
	.align	1
	.p2align 2,,3
	.global	SaveState
	.syntax unified
	.code	16
	.thumb_func
	.type	SaveState, %function
SaveState:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	movs	r3, #66	@ tmp124,
@ Data/FE6_FE7.c:802: }
	@ sp needed	@
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	ldrsh	r3, [r0, r3]	@ tmp125,
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	movs	r1, #64	@ tmp127,
@ Data/FE6_FE7.c:801:     proc->unit->state = state;
	ldr	r2, [r0, #60]	@ proc_9(D)->unit, proc_9(D)->unit
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	ldrsh	r1, [r0, r1]	@ tmp128,
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsls	r3, r3, #16	@ tmp126, tmp125,
@ Data/FE6_FE7.c:800:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	orrs	r3, r1	@ state, tmp128
@ Data/FE6_FE7.c:801:     proc->unit->state = state;
	str	r3, [r2, #12]	@ state, _7->state
@ Data/FE6_FE7.c:802: }
	bx	lr
	.size	SaveState, .-SaveState
	.align	1
	.p2align 2,,3
	.global	RedrawUnitStatsMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	RedrawUnitStatsMenu, %function
RedrawUnitStatsMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, r10	@,
	mov	r7, r9	@,
	mov	r6, r8	@,
	push	{r6, r7, lr}	@
@ Data/FE6_FE7.c:931:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * NumberOfOptions, 0);
	ldr	r7, .L191	@ tmp129,
	movs	r3, #0	@,
	movs	r2, #18	@,
	movs	r1, #9	@,
	ldr	r4, .L191+4	@ tmp130,
@ Data/FE6_FE7.c:930: {
	mov	r10, r0	@ proc, tmp139
@ Data/FE6_FE7.c:931:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * NumberOfOptions, 0);
	movs	r0, r7	@, tmp129
	bl	.L27		@
@ Data/FE6_FE7.c:932:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L191+8	@ tmp137,
	movs	r0, #1	@,
	mov	r8, r3	@ tmp137, tmp137
	bl	.L17		@
	movs	r3, #158	@ _55,
	rsbs	r3, r3, #0	@ _55, _55
	mov	r9, r3	@ _55, _55
	ldr	r3, .L191+12	@ tmp147,
	movs	r4, r7	@ ivtmp.458, tmp129
	mov	ip, r3	@ tmp147, tmp147
	ldr	r6, .L191+16	@ ivtmp.456,
	ldr	r5, .L191+20	@ tmp138,
	add	r9, r9, r7	@ _55, tmp129
	subs	r4, r4, #68	@ ivtmp.458,
	add	r7, r7, ip	@ _56, tmp147
.L187:
@ Data/FE6_FE7.c:938:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, (Y_HAND - 1) + (i * 2)));
	movs	r1, r4	@, ivtmp.458
	movs	r0, r6	@, ivtmp.456
@ Data/FE6_FE7.c:936:     for (int i = 0; i < NumberOfOptions; ++i)
	adds	r4, r4, #128	@ ivtmp.458,
@ Data/FE6_FE7.c:938:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, (Y_HAND - 1) + (i * 2)));
	bl	.L28		@
@ Data/FE6_FE7.c:936:     for (int i = 0; i < NumberOfOptions; ++i)
	adds	r6, r6, #8	@ ivtmp.456,
	cmp	r4, r7	@ ivtmp.458, _56
	bne	.L187		@,
	mov	r5, r10	@ proc, proc
	ldr	r6, .L191+24	@ _46,
	ldr	r4, .L191+28	@ ivtmp.447,
	ldr	r7, .L191+32	@ tmp136,
	adds	r5, r5, #64	@ proc,
	add	r6, r6, r9	@ _46, _55
.L188:
@ Data/FE6_FE7.c:943:         PutNumber(
	movs	r0, r4	@, ivtmp.447
	movs	r3, #0	@ tmp142,
	ldrsh	r2, [r5, r3]	@ MEM[(short int *)_44], ivtmp.445, tmp142
	movs	r1, #3	@,
@ Data/FE6_FE7.c:941:     for (int i = 0; i < NumberOfOptions; ++i)
	adds	r4, r4, #128	@ ivtmp.447,
@ Data/FE6_FE7.c:943:         PutNumber(
	bl	.L145		@
@ Data/FE6_FE7.c:941:     for (int i = 0; i < NumberOfOptions; ++i)
	adds	r5, r5, #2	@ ivtmp.445,
	cmp	r4, r6	@ ivtmp.447, _46
	bne	.L188		@,
@ Data/FE6_FE7.c:948: }
	@ sp needed	@
@ Data/FE6_FE7.c:947:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	bl	.L193		@
@ Data/FE6_FE7.c:948: }
	pop	{r5, r6, r7}
	mov	r10, r7
	mov	r9, r6
	mov	r8, r5
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L192:
	.align	2
.L191:
	.word	gBG0TilemapBuffer+158
	.word	TileMap_FillRect
	.word	BG_EnableSyncByMask
	.word	1084
	.word	gStatScreen+24
	.word	PutText
	.word	1254
	.word	gBG0TilemapBuffer+102
	.word	PutNumber
	.size	RedrawUnitStatsMenu, .-RedrawUnitStatsMenu
	.align	1
	.p2align 2,,3
	.global	EditStatsIdle
	.syntax unified
	.code	16
	.thumb_func
	.type	EditStatsIdle, %function
EditStatsIdle:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
	mov	lr, r9	@,
	mov	r7, r8	@,
	push	{r7, lr}	@
@ Data/FE6_FE7.c:583:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L262	@ tmp211,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r6, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:579: {
	movs	r4, r0	@ proc, tmp442
@ Data/FE6_FE7.c:584:     if (keys & B_BUTTON)
	lsls	r3, r6, #30	@ tmp443, keys,
	bpl	.LCB1511	@
	b	.L257	@long jump	@
.LCB1511:
.L195:
@ Data/FE6_FE7.c:589:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp223,
	tst	r3, r6	@ tmp223, keys
	beq	.LCB1518	@
	b	.L258	@long jump	@
.LCB1518:
.L196:
@ Data/FE6_FE7.c:597:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	movs	r5, #48	@ tmp271,
@ Data/FE6_FE7.c:595:     if (proc->editing)
	movs	r7, #46	@ tmp265,
	movs	r2, #16	@ tmp269,
@ Data/FE6_FE7.c:597:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r5]	@ tmp272,
@ Data/FE6_FE7.c:595:     if (proc->editing)
	ldrsb	r3, [r4, r7]	@ _2,
	ands	r2, r6	@ tmp269, keys
@ Data/FE6_FE7.c:597:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ tmp273, tmp272,
	mov	r8, r2	@ _169, tmp269
	adds	r1, r1, #8	@ _173,
@ Data/FE6_FE7.c:595:     if (proc->editing)
	cmp	r3, #0	@ _2,
	bne	.LCB1532	@
	b	.L197	@long jump	@
.LCB1532:
@ Data/FE6_FE7.c:597:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	movs	r2, #49	@ tmp275,
	ldrsb	r2, [r4, r2]	@ tmp276,
@ Data/FE6_FE7.c:597:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	ldr	r3, .L262+4	@ tmp274,
	lsls	r2, r2, #3	@ tmp277, tmp276,
	adds	r3, r3, r2	@ tmp278, tmp274, tmp277
@ Data/FE6_FE7.c:597:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	ldr	r0, [r3, #120]	@ CursorLocationTable[_4].x, CursorLocationTable[_4].x
	bl	DisplayVertUiHand		@
@ Data/FE6_FE7.c:598:         int max = StatCapLookup[proc->id];
	ldr	r3, .L262+8	@ tmp429,
	mov	r9, r3	@ tmp429, tmp429
	mov	r2, r9	@ tmp285, tmp429
@ Data/FE6_FE7.c:598:         int max = StatCapLookup[proc->id];
	ldrsb	r3, [r4, r5]	@ tmp284,
@ Data/FE6_FE7.c:598:         int max = StatCapLookup[proc->id];
	adds	r2, r2, #56	@ tmp285,
	ldrsb	r7, [r2, r3]	@ _12, StatCapLookup
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	cmp	r7, #10	@ _12,
	bgt	.LCB1547	@
	b	.L221	@long jump	@
.LCB1547:
	mov	r3, r9	@ ivtmp.469, tmp429
@ Data/FE6_FE7.c:525:     int result = 1;
	subs	r5, r5, #47	@ result,
	adds	r3, r3, #76	@ ivtmp.469,
.L199:
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	adds	r3, r3, #4	@ ivtmp.469,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	subs	r1, r3, #4	@ tmp288, ivtmp.469,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	ldr	r1, [r1]	@ MEM[(const int *)_114 + 4294967292B], MEM[(const int *)_114 + 4294967292B]
@ Data/FE6_FE7.c:528:         result++;
	adds	r5, r5, #1	@ result,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	cmp	r7, r1	@ _12, MEM[(const int *)_114 + 4294967292B]
	bgt	.L199		@,
@ Data/FE6_FE7.c:530:     if (result > 9)
	cmp	r5, #9	@ _167,
	ble	.L198		@,
	movs	r5, #9	@ _167,
.L198:
@ Data/FE6_FE7.c:602:         if (keys & DPAD_RIGHT)
	mov	r3, r8	@ _169, _169
	cmp	r3, #0	@ _169,
	beq	.L201		@,
@ Data/FE6_FE7.c:604:             if (proc->digit > 0)
	movs	r3, #49	@ tmp290,
	ldrsb	r3, [r4, r3]	@ _13,
@ Data/FE6_FE7.c:604:             if (proc->digit > 0)
	cmp	r3, #0	@ _13,
	bgt	.LCB1570	@
	b	.L202	@long jump	@
.LCB1570:
@ Data/FE6_FE7.c:606:                 proc->digit--;
	subs	r3, r3, #1	@ tmp294,
	lsls	r3, r3, #24	@ tmp295, tmp294,
	asrs	r3, r3, #24	@ _18, tmp295,
.L203:
	movs	r2, #49	@ tmp302,
@ Data/FE6_FE7.c:613:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _18, proc_87(D)->digit
	bl	RedrawUnitStatsMenu		@
.L201:
@ Data/FE6_FE7.c:615:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp444, keys,
	bpl	.L204		@,
@ Data/FE6_FE7.c:617:             if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp311,
	ldrsb	r3, [r4, r3]	@ _22,
@ Data/FE6_FE7.c:617:             if (proc->digit < (max_digits - 1))
	subs	r5, r5, #1	@ tmp312,
@ Data/FE6_FE7.c:617:             if (proc->digit < (max_digits - 1))
	cmp	r3, r5	@ _22, tmp312
	bge	.LCB1592	@
	b	.L259	@long jump	@
.LCB1592:
@ Data/FE6_FE7.c:624:                 proc->editing = false;
	movs	r3, #46	@ tmp316,
	movs	r2, #0	@ tmp317,
	strb	r2, [r4, r3]	@ tmp317, proc_87(D)->editing
@ Data/FE6_FE7.c:623:                 proc->digit = 0;
	movs	r3, #0	@ _28,
.L206:
	movs	r2, #49	@ tmp319,
@ Data/FE6_FE7.c:626:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _28, proc_87(D)->digit
	bl	RedrawUnitStatsMenu		@
.L204:
@ Data/FE6_FE7.c:629:         if (keys & DPAD_UP)
	movs	r3, #64	@ tmp322,
	tst	r3, r6	@ tmp322, keys
	beq	.L207		@,
@ Data/FE6_FE7.c:631:             if (proc->tmp[proc->id] == max)
	movs	r2, #48	@ tmp328,
	ldrsb	r1, [r4, r2]	@ tmp329,
	lsls	r1, r1, #1	@ tmp330, tmp329,
	adds	r1, r4, r1	@ _125, proc, tmp330
@ Data/FE6_FE7.c:631:             if (proc->tmp[proc->id] == max)
	ldrsh	r2, [r1, r3]	@ _31, MEM <s16> [(struct DebuggerProc *)_125 + 64B]
@ Data/FE6_FE7.c:631:             if (proc->tmp[proc->id] == max)
	cmp	r2, r7	@ _31, _12
	bne	.LCB1617	@
	b	.L222	@long jump	@
.LCB1617:
@ Data/FE6_FE7.c:637:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	movs	r3, #49	@ tmp334,
	ldrsb	r3, [r4, r3]	@ tmp335,
@ Data/FE6_FE7.c:637:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp336, tmp335,
	add	r3, r3, r9	@ tmp337, tmp429
@ Data/FE6_FE7.c:637:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_35], DigitDecimalTable[_35]
	adds	r3, r3, r2	@ tmp342, DigitDecimalTable[_35], _31
@ Data/FE6_FE7.c:638:                 if (proc->tmp[proc->id] > max)
	adds	r2, r3, #0	@ _51, tmp342
	lsls	r3, r3, #16	@ tmp344, tmp342,
	asrs	r3, r3, #16	@ tmp344, tmp344,
	cmp	r3, r7	@ tmp344, _12
	ble	.L209		@,
	adds	r2, r7, #0	@ _51, _12
.L209:
	lsls	r3, r2, #16	@ _41, _51,
	asrs	r3, r3, #16	@ _41, _41,
.L208:
@ Data/FE6_FE7.c:633:                 proc->tmp[proc->id] = min;
	movs	r2, #64	@ tmp346,
@ Data/FE6_FE7.c:643:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:633:                 proc->tmp[proc->id] = min;
	strh	r3, [r1, r2]	@ _41, MEM <s16> [(struct DebuggerProc *)_125 + 64B]
@ Data/FE6_FE7.c:643:             RedrawUnitStatsMenu(proc);
	bl	RedrawUnitStatsMenu		@
.L207:
@ Data/FE6_FE7.c:645:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp445, keys,
	bpl	.L194		@,
@ Data/FE6_FE7.c:648:             if (proc->tmp[proc->id] == min)
	movs	r3, #48	@ tmp355,
	ldrsb	r2, [r4, r3]	@ tmp356,
	lsls	r2, r2, #1	@ tmp357, tmp356,
	adds	r2, r4, r2	@ _69, proc, tmp357
@ Data/FE6_FE7.c:648:             if (proc->tmp[proc->id] == min)
	adds	r3, r3, #16	@ tmp358,
	ldrsh	r1, [r2, r3]	@ _42, MEM <s16> [(struct DebuggerProc *)_69 + 64B]
@ Data/FE6_FE7.c:648:             if (proc->tmp[proc->id] == min)
	cmp	r1, #0	@ _42,
	bne	.L260		@,
@ Data/FE6_FE7.c:650:                 proc->tmp[proc->id] = max;
	movs	r3, #64	@ tmp374,
@ Data/FE6_FE7.c:661:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:650:                 proc->tmp[proc->id] = max;
	strh	r7, [r2, r3]	@ _43, MEM <s16> [(struct DebuggerProc *)_69 + 64B]
@ Data/FE6_FE7.c:661:             RedrawUnitStatsMenu(proc);
	bl	RedrawUnitStatsMenu		@
.L194:
@ Data/FE6_FE7.c:698: }
	@ sp needed	@
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L197:
@ Data/FE6_FE7.c:666:         DisplayUiHand(CursorLocationTable[0].x - ((StatWidth + 2) * 8), (Y_HAND - 1 + (proc->id * 2)) * 8);
	ldr	r3, .L262+12	@ tmp376,
	movs	r0, #100	@,
	bl	.L17		@
@ Data/FE6_FE7.c:667:         if (keys & DPAD_RIGHT)
	mov	r3, r8	@ _169, _169
	cmp	r3, #0	@ _169,
	beq	.L215		@,
@ Data/FE6_FE7.c:669:             proc->digit = 1;
	movs	r3, #1	@ tmp378,
	movs	r2, #49	@ tmp377,
	strb	r3, [r4, r2]	@ tmp378, proc_87(D)->digit
@ Data/FE6_FE7.c:670:             proc->editing = true;
	strb	r3, [r4, r7]	@ tmp378, proc_87(D)->editing
.L215:
@ Data/FE6_FE7.c:672:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp446, keys,
	bpl	.L216		@,
@ Data/FE6_FE7.c:674:             proc->digit = 0;
	movs	r3, #49	@ tmp390,
	movs	r2, #0	@ tmp391,
	strb	r2, [r4, r3]	@ tmp391, proc_87(D)->digit
@ Data/FE6_FE7.c:675:             proc->editing = true;
	subs	r3, r3, #3	@ tmp393,
	adds	r2, r2, #1	@ tmp394,
	strb	r2, [r4, r3]	@ tmp394, proc_87(D)->editing
.L216:
@ Data/FE6_FE7.c:678:         if (keys & DPAD_UP)
	lsls	r3, r6, #25	@ tmp447, keys,
	bpl	.L217		@,
@ Data/FE6_FE7.c:680:             proc->id--;
	movs	r3, #48	@ tmp403,
@ Data/FE6_FE7.c:680:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp405,
	subs	r3, r3, #1	@ tmp406,
	lsls	r3, r3, #24	@ tmp407, tmp406,
	asrs	r2, r3, #24	@ _62, tmp407,
@ Data/FE6_FE7.c:681:             if (proc->id < 0)
	cmp	r3, #0	@ tmp407,
	blt	.L261		@,
	movs	r3, #48	@ tmp411,
@ Data/FE6_FE7.c:685:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _62, MEM <struct DebuggerProc> [(void *)proc_87(D)].id
	bl	RedrawUnitStatsMenu		@
.L217:
@ Data/FE6_FE7.c:687:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp448, keys,
	bpl	.L194		@,
@ Data/FE6_FE7.c:689:             proc->id++;
	movs	r1, #48	@ tmp420,
@ Data/FE6_FE7.c:692:                 proc->id = 0;
	movs	r0, #8	@ tmp438,
	movs	r5, #0	@ tmp440,
@ Data/FE6_FE7.c:689:             proc->id++;
	ldrb	r3, [r4, r1]	@ tmp422,
	adds	r3, r3, #1	@ tmp423,
	lsls	r3, r3, #24	@ tmp424, tmp423,
	asrs	r2, r3, #24	@ _68, tmp424,
@ Data/FE6_FE7.c:692:                 proc->id = 0;
	lsrs	r3, r3, #31	@ tmp439, tmp424,
	cmp	r0, r2	@ tmp438, _68
	adcs	r3, r3, r5	@ tmp437, tmp439, tmp440
	rsbs	r3, r3, #0	@ tmp441, tmp437
	ands	r2, r3	@ _68, tmp441
@ Data/FE6_FE7.c:695:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r1]	@ _68, MEM <struct DebuggerProc> [(void *)proc_87(D)].id
	bl	RedrawUnitStatsMenu		@
@ Data/FE6_FE7.c:698: }
	b	.L194		@
.L258:
@ Data/FE6_FE7.c:434:     unit->maxHP = proc->tmp[0];
	movs	r2, #64	@ tmp227,
@ Data/FE6_FE7.c:432:     struct Unit * unit = proc->unit;
	ldr	r3, [r4, #60]	@ unit, proc_87(D)->unit
@ Data/FE6_FE7.c:434:     unit->maxHP = proc->tmp[0];
	ldrh	r2, [r4, r2]	@ tmp230,
	strb	r2, [r3, #18]	@ tmp230, unit_130->maxHP
@ Data/FE6_FE7.c:436:     unit->curHP = proc->tmp[1];
	movs	r2, #66	@ tmp231,
@ Data/FE6_FE7.c:436:     unit->curHP = proc->tmp[1];
	ldrh	r2, [r4, r2]	@ tmp234,
	strb	r2, [r3, #19]	@ tmp234, unit_130->curHP
@ Data/FE6_FE7.c:437:     unit->pow = proc->tmp[2];
	movs	r2, #68	@ tmp235,
@ Data/FE6_FE7.c:437:     unit->pow = proc->tmp[2];
	ldrh	r2, [r4, r2]	@ tmp238,
	strb	r2, [r3, #20]	@ tmp238, unit_130->pow
@ Data/FE6_FE7.c:438:     unit->skl = proc->tmp[3];
	movs	r2, #70	@ tmp239,
@ Data/FE6_FE7.c:438:     unit->skl = proc->tmp[3];
	ldrh	r2, [r4, r2]	@ tmp242,
	strb	r2, [r3, #21]	@ tmp242, unit_130->skl
@ Data/FE6_FE7.c:439:     unit->spd = proc->tmp[4];
	movs	r2, #72	@ tmp243,
@ Data/FE6_FE7.c:439:     unit->spd = proc->tmp[4];
	ldrh	r2, [r4, r2]	@ tmp246,
	strb	r2, [r3, #22]	@ tmp246, unit_130->spd
@ Data/FE6_FE7.c:440:     unit->def = proc->tmp[5];
	movs	r2, #74	@ tmp247,
@ Data/FE6_FE7.c:440:     unit->def = proc->tmp[5];
	ldrh	r2, [r4, r2]	@ tmp250,
	strb	r2, [r3, #23]	@ tmp250, unit_130->def
@ Data/FE6_FE7.c:441:     unit->res = proc->tmp[6];
	movs	r2, #76	@ tmp251,
@ Data/FE6_FE7.c:441:     unit->res = proc->tmp[6];
	ldrh	r2, [r4, r2]	@ tmp254,
	strb	r2, [r3, #24]	@ tmp254, unit_130->res
@ Data/FE6_FE7.c:442:     unit->lck = proc->tmp[7];
	movs	r2, #78	@ tmp255,
@ Data/FE6_FE7.c:442:     unit->lck = proc->tmp[7];
	ldrh	r2, [r4, r2]	@ tmp258,
	strb	r2, [r3, #25]	@ tmp258, unit_130->lck
@ Data/FE6_FE7.c:443:     unit->_u3A = proc->tmp[8];
	movs	r2, #80	@ tmp259,
@ Data/FE6_FE7.c:443:     unit->_u3A = proc->tmp[8];
	ldrh	r1, [r4, r2]	@ tmp262,
	subs	r2, r2, #22	@ tmp263,
	strb	r1, [r3, r2]	@ tmp262, unit_130->_u3A
@ Data/FE6_FE7.c:592:         Proc_Goto(proc, RestartLabel);
	movs	r0, r4	@, proc
	movs	r1, #1	@,
	ldr	r3, .L262+16	@ tmp264,
	bl	.L17		@
@ Data/FE6_FE7.c:576: }
	b	.L196		@
.L257:
@ Data/FE6_FE7.c:586:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	ldr	r3, .L262+16	@ tmp219,
	bl	.L17		@
@ Data/FE6_FE7.c:576: }
	b	.L195		@
.L260:
@ Data/FE6_FE7.c:654:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	movs	r3, #49	@ tmp361,
	ldrsb	r3, [r4, r3]	@ tmp362,
@ Data/FE6_FE7.c:654:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp363, tmp362,
	add	r3, r3, r9	@ tmp364, tmp429
@ Data/FE6_FE7.c:654:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_46], DigitDecimalTable[_46]
	subs	r1, r1, r3	@ tmp369, _42, DigitDecimalTable[_46]
@ Data/FE6_FE7.c:655:                 if (proc->tmp[proc->id] < min)
	lsls	r7, r1, #16	@ tmp372, tmp369,
	asrs	r7, r7, #16	@ tmp372, tmp372,
	mvns	r7, r7	@ tmp431, tmp372
@ Data/FE6_FE7.c:650:                 proc->tmp[proc->id] = max;
	movs	r3, #64	@ tmp374,
@ Data/FE6_FE7.c:655:                 if (proc->tmp[proc->id] < min)
	asrs	r7, r7, #31	@ tmp435, tmp431,
	ands	r7, r1	@ tmp359, tmp369
	lsls	r7, r7, #16	@ _43, tmp359,
	asrs	r7, r7, #16	@ _43, _43,
@ Data/FE6_FE7.c:661:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:650:                 proc->tmp[proc->id] = max;
	strh	r7, [r2, r3]	@ _43, MEM <s16> [(struct DebuggerProc *)_69 + 64B]
@ Data/FE6_FE7.c:661:             RedrawUnitStatsMenu(proc);
	bl	RedrawUnitStatsMenu		@
	b	.L194		@
.L259:
@ Data/FE6_FE7.c:619:                 proc->digit++;
	adds	r3, r3, #1	@ tmp314,
	lsls	r3, r3, #24	@ tmp315, tmp314,
	asrs	r3, r3, #24	@ _28, tmp315,
	b	.L206		@
.L261:
@ Data/FE6_FE7.c:683:                 proc->id = NumberOfOptions - 1;
	movs	r2, #8	@ _62,
	movs	r3, #48	@ tmp411,
@ Data/FE6_FE7.c:685:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _62, MEM <struct DebuggerProc> [(void *)proc_87(D)].id
	bl	RedrawUnitStatsMenu		@
	b	.L217		@
.L202:
@ Data/FE6_FE7.c:611:                 proc->editing = false;
	movs	r2, #46	@ tmp299,
	movs	r1, #0	@ tmp300,
@ Data/FE6_FE7.c:610:                 proc->digit = max_digits - 1;
	subs	r3, r5, #1	@ tmp297, _167,
	lsls	r3, r3, #24	@ tmp298, tmp297,
@ Data/FE6_FE7.c:611:                 proc->editing = false;
	strb	r1, [r4, r2]	@ tmp300, proc_87(D)->editing
@ Data/FE6_FE7.c:610:                 proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _18, tmp298,
	b	.L203		@
.L222:
	movs	r3, #0	@ _41,
	b	.L208		@
.L221:
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	movs	r5, #1	@ _167,
	b	.L198		@
.L263:
	.align	2
.L262:
	.word	gKeyStatusPtr
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	DisplayUiHand
	.word	Proc_Goto
	.size	EditStatsIdle, .-EditStatsIdle
	.align	1
	.p2align 2,,3
	.global	EditStatsInit
	.syntax unified
	.code	16
	.thumb_func
	.type	EditStatsInit, %function
EditStatsInit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, r8	@,
	push	{lr}	@
@ Data/FE6_FE7.c:385:     ResetTextFont();
	ldr	r5, .L267	@ tmp138,
@ Data/FE6_FE7.c:871: {
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:871: {
	movs	r7, r0	@ proc, tmp206
@ Data/FE6_FE7.c:385:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:386:     SetTextFontGlyphs(0);
	ldr	r4, .L267+4	@ tmp139,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:389:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L267+8	@ tmp140,
	ldr	r3, .L267+12	@ tmp141,
	bl	.L17		@
@ Data/FE6_FE7.c:390:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L267+16	@ tmp142,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:391:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:392:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:393:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L267+20	@ tmp145,
	bl	.L17		@
@ Data/FE6_FE7.c:394:     ClearBg0Bg1();
	ldr	r3, .L267+24	@ tmp146,
	bl	.L17		@
@ Data/FE6_FE7.c:395:     ResetText();
	ldr	r3, .L267+28	@ tmp147,
	bl	.L17		@
@ Data/FE6_FE7.c:874:     proc->tmp[0] = unit->maxHP;
	movs	r1, #18	@ tmp149,
@ Data/FE6_FE7.c:874:     proc->tmp[0] = unit->maxHP;
	movs	r2, #64	@ tmp150,
@ Data/FE6_FE7.c:873:     struct Unit * unit = proc->unit;
	ldr	r3, [r7, #60]	@ unit, proc_25(D)->unit
@ Data/FE6_FE7.c:874:     proc->tmp[0] = unit->maxHP;
	ldrsb	r1, [r3, r1]	@ tmp149,
@ Data/FE6_FE7.c:874:     proc->tmp[0] = unit->maxHP;
	strh	r1, [r7, r2]	@ tmp149, proc_25(D)->tmp[0]
@ Data/FE6_FE7.c:875:     proc->tmp[1] = unit->curHP;
	movs	r1, #19	@ tmp152,
	ldrsb	r1, [r3, r1]	@ tmp152,
@ Data/FE6_FE7.c:875:     proc->tmp[1] = unit->curHP;
	adds	r2, r2, #2	@ tmp153,
	strh	r1, [r7, r2]	@ tmp152, proc_25(D)->tmp[1]
@ Data/FE6_FE7.c:876:     proc->tmp[2] = unit->pow;
	movs	r1, #20	@ tmp155,
	ldrsb	r1, [r3, r1]	@ tmp155,
@ Data/FE6_FE7.c:876:     proc->tmp[2] = unit->pow;
	adds	r2, r2, #2	@ tmp156,
	strh	r1, [r7, r2]	@ tmp155, proc_25(D)->tmp[2]
@ Data/FE6_FE7.c:877:     proc->tmp[3] = unit->skl;
	movs	r1, #21	@ tmp158,
	ldrsb	r1, [r3, r1]	@ tmp158,
@ Data/FE6_FE7.c:877:     proc->tmp[3] = unit->skl;
	adds	r2, r2, #2	@ tmp159,
	strh	r1, [r7, r2]	@ tmp158, proc_25(D)->tmp[3]
@ Data/FE6_FE7.c:878:     proc->tmp[4] = unit->spd;
	movs	r1, #22	@ tmp161,
	ldrsb	r1, [r3, r1]	@ tmp161,
@ Data/FE6_FE7.c:878:     proc->tmp[4] = unit->spd;
	adds	r2, r2, #2	@ tmp162,
	strh	r1, [r7, r2]	@ tmp161, proc_25(D)->tmp[4]
@ Data/FE6_FE7.c:879:     proc->tmp[5] = unit->def;
	movs	r1, #23	@ tmp164,
	ldrsb	r1, [r3, r1]	@ tmp164,
@ Data/FE6_FE7.c:879:     proc->tmp[5] = unit->def;
	adds	r2, r2, #2	@ tmp165,
	strh	r1, [r7, r2]	@ tmp164, proc_25(D)->tmp[5]
@ Data/FE6_FE7.c:880:     proc->tmp[6] = unit->res;
	movs	r1, #24	@ tmp167,
	ldrsb	r1, [r3, r1]	@ tmp167,
@ Data/FE6_FE7.c:880:     proc->tmp[6] = unit->res;
	adds	r2, r2, #2	@ tmp168,
	strh	r1, [r7, r2]	@ tmp167, proc_25(D)->tmp[6]
@ Data/FE6_FE7.c:881:     proc->tmp[7] = unit->lck;
	movs	r1, #25	@ tmp170,
	ldrsb	r1, [r3, r1]	@ tmp170,
@ Data/FE6_FE7.c:881:     proc->tmp[7] = unit->lck;
	adds	r2, r2, #2	@ tmp171,
	strh	r1, [r7, r2]	@ tmp170, proc_25(D)->tmp[7]
@ Data/FE6_FE7.c:882:     proc->tmp[8] = unit->_u3A;
	subs	r2, r2, #20	@ tmp172,
	ldrb	r2, [r3, r2]	@ tmp174,
@ Data/FE6_FE7.c:882:     proc->tmp[8] = unit->_u3A;
	movs	r3, #80	@ tmp175,
	strh	r2, [r7, r3]	@ tmp174, proc_25(D)->tmp[8]
@ Data/FE6_FE7.c:76:     PutUiWindowFrame(x, y, width, height, style);
	movs	r3, #0	@ tmp176,
	ldr	r4, .L267+32	@ tmp177,
	str	r3, [sp]	@ tmp176,
	movs	r2, #9	@,
	adds	r3, r3, #20	@,
	movs	r1, #0	@,
	movs	r0, #12	@,
	bl	.L27		@
	ldr	r3, .L267+36	@ tmp204,
	movs	r6, r3	@ _65, tmp204
	mov	r8, r3	@ tmp204, tmp204
	movs	r4, r3	@ ivtmp.481, tmp204
	ldr	r5, .L267+40	@ tmp205,
	adds	r6, r6, #120	@ _65,
.L265:
@ Data/FE6_FE7.c:901:         InitText(&th[i], StatWidth);
	movs	r0, r4	@, ivtmp.481
	movs	r1, #4	@,
@ Data/FE6_FE7.c:899:     for (int i = 0; i < 15; ++i)
	adds	r4, r4, #8	@ ivtmp.481,
@ Data/FE6_FE7.c:901:         InitText(&th[i], StatWidth);
	bl	.L28		@
@ Data/FE6_FE7.c:899:     for (int i = 0; i < 15; ++i)
	cmp	r4, r6	@ ivtmp.481, _65
	bne	.L265		@,
@ Data/FE6_FE7.c:905:     Text_DrawString(&th[c], MaxHPText);
	ldr	r4, .L267+44	@ tmp182,
	mov	r0, r8	@, tmp204
	ldr	r1, .L267+48	@ tmp180,
	bl	.L27		@
@ Data/FE6_FE7.c:907:     Text_DrawString(&th[c], HPText);
	mov	r0, r8	@ tmp184, tmp204
	ldr	r1, .L267+52	@ tmp183,
	adds	r0, r0, #8	@ tmp184,
	bl	.L27		@
@ Data/FE6_FE7.c:909:     Text_DrawString(&th[c], StrText);
	mov	r0, r8	@ tmp187, tmp204
	ldr	r1, .L267+56	@ tmp186,
	adds	r0, r0, #16	@ tmp187,
	bl	.L27		@
@ Data/FE6_FE7.c:911:     Text_DrawString(&th[c], SklText);
	mov	r0, r8	@ tmp190, tmp204
	ldr	r1, .L267+60	@ tmp189,
	adds	r0, r0, #24	@ tmp190,
	bl	.L27		@
@ Data/FE6_FE7.c:913:     Text_DrawString(&th[c], SpdText);
	mov	r0, r8	@ tmp193, tmp204
	ldr	r1, .L267+64	@ tmp192,
	adds	r0, r0, #32	@ tmp193,
	bl	.L27		@
@ Data/FE6_FE7.c:915:     Text_DrawString(&th[c], DefText);
	mov	r0, r8	@ tmp196, tmp204
	ldr	r1, .L267+68	@ tmp195,
	adds	r0, r0, #40	@ tmp196,
	bl	.L27		@
@ Data/FE6_FE7.c:917:     Text_DrawString(&th[c], ResText);
	mov	r0, r8	@ tmp199, tmp204
	ldr	r1, .L267+72	@ tmp198,
	adds	r0, r0, #48	@ tmp199,
	bl	.L27		@
@ Data/FE6_FE7.c:919:     Text_DrawString(&th[c], LckText);
	mov	r0, r8	@ tmp204, tmp204
	ldr	r1, .L267+76	@ tmp201,
	adds	r0, r0, #56	@ tmp204,
	bl	.L27		@
@ Data/FE6_FE7.c:926:     RedrawUnitStatsMenu(proc);
	movs	r0, r7	@, proc
	bl	RedrawUnitStatsMenu		@
@ Data/FE6_FE7.c:927: }
	add	sp, sp, #8	@,,
	@ sp needed	@
	pop	{r7}
	mov	r8, r7
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L268:
	.align	2
.L267:
	.word	ResetTextFont
	.word	SetTextFontGlyphs
	.word	gBG0TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.word	SetTextFont
	.word	ClearBg0Bg1
	.word	ResetText
	.word	PutUiWindowFrame
	.word	gStatScreen+24
	.word	InitText
	.word	Text_DrawString
	.word	MaxHPText
	.word	HPText
	.word	StrText
	.word	SklText
	.word	SpdText
	.word	DefText
	.word	ResText
	.word	LckText
	.size	EditStatsInit, .-EditStatsInit
	.align	1
	.p2align 2,,3
	.global	RedrawItemMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	RedrawItemMenu, %function
RedrawItemMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, fp	@,
	mov	r7, r10	@,
	mov	r6, r9	@,
	mov	r5, r8	@,
	push	{r5, r6, r7, lr}	@
	movs	r4, r0	@ proc, tmp222
	sub	sp, sp, #36	@,,
@ Data/FE6_FE7.c:984:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L308	@ tmp172,
	ldr	r3, .L308+4	@ tmp173,
	bl	.L17		@
@ Data/FE6_FE7.c:985:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L308+8	@ tmp211,
	movs	r0, #1	@,
	mov	fp, r3	@ tmp211, tmp211
	bl	.L17		@
@ Data/FE6_FE7.c:986:     ResetIconGraphics();
	ldr	r3, .L308+12	@ tmp175,
	bl	.L17		@
	add	r3, sp, #12	@ ivtmp.524,,
	mov	r8, r3	@ ivtmp.524, ivtmp.524
	movs	r7, r3	@ ivtmp.559, ivtmp.524
	ldr	r3, .L308+16	@ tmp212,
	mov	r10, r3	@ tmp212, tmp212
@ Data/FE6_FE7.c:992:         itemData[i] = GetItemData(proc->tmp[i] & 0xFF);
	movs	r3, #255	@ tmp181,
	movs	r5, r4	@ ivtmp.498, proc
	mov	r9, r3	@ tmp181, tmp181
	mov	r3, r10	@ tmp212, tmp212
	adds	r5, r5, #64	@ ivtmp.498,
@ Data/FE6_FE7.c:986:     ResetIconGraphics();
	movs	r6, r5	@ ivtmp.557, ivtmp.498
@ Data/FE6_FE7.c:992:         itemData[i] = GetItemData(proc->tmp[i] & 0xFF);
	mov	r10, r5	@ ivtmp.498, ivtmp.498
	movs	r5, r3	@ tmp212, tmp212
	adds	r4, r4, #74	@ _186,
.L270:
	mov	r3, r9	@ tmp181, tmp181
	ldrh	r0, [r6]	@ MEM[(short int *)_183], MEM[(short int *)_183]
	ands	r0, r3	@ tmp182, tmp181
	bl	.L28		@
@ Data/FE6_FE7.c:990:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.557,
@ Data/FE6_FE7.c:992:         itemData[i] = GetItemData(proc->tmp[i] & 0xFF);
	stmia	r7!, {r0}	@ MEM[(const struct ItemData * *)_184], tmp223
@ Data/FE6_FE7.c:990:     for (int i = 0; i < NumberOfItems; ++i)
	cmp	r6, r4	@ ivtmp.557, _186
	bne	.L270		@,
	ldr	r3, .L308+20	@ ivtmp.534,
	mov	r9, r3	@ ivtmp.534, ivtmp.534
	movs	r7, r3	@ ivtmp.546, ivtmp.534
	ldr	r3, .L308+24	@ tmp213,
	mov	r5, r10	@ ivtmp.498, ivtmp.498
	mov	r10, r3	@ tmp213, tmp213
@ Data/FE6_FE7.c:1001:             if (GetItemDescId(proc->tmp[i] & 0xFFFF) < 0x4000)
	ldr	r3, .L308+28	@ tmp220,
	str	r3, [sp, #4]	@ tmp220, %sfp
@ Data/FE6_FE7.c:1001:             if (GetItemDescId(proc->tmp[i] & 0xFFFF) < 0x4000)
	mov	r3, r10	@ tmp213, tmp213
@ Data/FE6_FE7.c:990:     for (int i = 0; i < NumberOfItems; ++i)
	movs	r6, r5	@ ivtmp.548, ivtmp.498
@ Data/FE6_FE7.c:1001:             if (GetItemDescId(proc->tmp[i] & 0xFFFF) < 0x4000)
	mov	r10, r5	@ ivtmp.498, ivtmp.498
	movs	r5, r3	@ tmp213, tmp213
	b	.L274		@
.L272:
@ Data/FE6_FE7.c:995:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.548,
	adds	r7, r7, #8	@ ivtmp.546,
	cmp	r6, r4	@ ivtmp.548, _186
	beq	.L305		@,
.L274:
@ Data/FE6_FE7.c:997:         ClearText(&th[i]);
	movs	r0, r7	@, ivtmp.546
	bl	.L28		@
@ Data/FE6_FE7.c:998:         if (proc->tmp[i])
	movs	r3, #0	@ tmp278,
	ldrsh	r0, [r6, r3]	@ _7, ivtmp.548, tmp278
@ Data/FE6_FE7.c:998:         if (proc->tmp[i])
	cmp	r0, #0	@ _7,
	beq	.L272		@,
@ Data/FE6_FE7.c:1001:             if (GetItemDescId(proc->tmp[i] & 0xFFFF) < 0x4000)
	lsls	r0, r0, #16	@ tmp186, _7,
	ldr	r3, [sp, #4]	@ tmp220, %sfp
	lsrs	r0, r0, #16	@ tmp185, tmp186,
	bl	.L17		@
@ Data/FE6_FE7.c:1001:             if (GetItemDescId(proc->tmp[i] & 0xFFFF) < 0x4000)
	movs	r3, #128	@ tmp296,
	lsls	r3, r3, #7	@ tmp296, tmp296,
	cmp	r0, r3	@ tmp224, tmp296
	bge	.L272		@,
@ Data/FE6_FE7.c:1003:                 str = GetItemName(proc->tmp[i] & 0xFFFF);
	ldrh	r0, [r6]	@ tmp190, MEM[(short int *)_172]
	ldr	r3, .L308+32	@ tmp192,
	bl	.L17		@
@ Data/FE6_FE7.c:1004:                 if (str && *str)
	cmp	r0, #0	@ str,
	beq	.L272		@,
@ Data/FE6_FE7.c:1004:                 if (str && *str)
	ldrb	r3, [r0]	@ *str_85, *str_85
	cmp	r3, #0	@ *str_85,
	beq	.L272		@,
@ Data/FE6_FE7.c:1006:                     Text_DrawString(&th[i], str);
	movs	r1, r0	@, str
	ldr	r3, .L308+36	@ tmp194,
	movs	r0, r7	@, ivtmp.546
@ Data/FE6_FE7.c:995:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.548,
@ Data/FE6_FE7.c:1006:                     Text_DrawString(&th[i], str);
	bl	.L17		@
@ Data/FE6_FE7.c:995:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r7, r7, #8	@ ivtmp.546,
	cmp	r6, r4	@ ivtmp.548, _186
	bne	.L274		@,
.L305:
@ Data/FE6_FE7.c:1017:             PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	ldr	r3, .L308+40	@ tmp219,
	mov	r5, r10	@ ivtmp.498, ivtmp.498
	mov	r10, r3	@ tmp219, tmp219
	movs	r3, r4	@ _186, _186
	ldr	r7, .L308+44	@ ivtmp.536,
@ Data/FE6_FE7.c:995:     for (int i = 0; i < NumberOfItems; ++i)
	movs	r6, r5	@ ivtmp.532, ivtmp.498
@ Data/FE6_FE7.c:1017:             PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	movs	r4, r7	@ ivtmp.536, ivtmp.536
	mov	r7, r9	@ ivtmp.534, ivtmp.534
	mov	r9, r5	@ ivtmp.498, ivtmp.498
	movs	r5, r3	@ _186, _186
	b	.L276		@
.L275:
@ Data/FE6_FE7.c:1013:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.532,
	adds	r7, r7, #8	@ ivtmp.534,
	adds	r4, r4, #128	@ ivtmp.536,
	cmp	r6, r5	@ ivtmp.532, _186
	beq	.L306		@,
.L276:
@ Data/FE6_FE7.c:1015:         if (proc->tmp[i])
	movs	r2, #0	@ tmp279,
	ldrsh	r3, [r6, r2]	@ MEM[(short int *)_161], ivtmp.532, tmp279
	cmp	r3, #0	@ MEM[(short int *)_161],
	beq	.L275		@,
@ Data/FE6_FE7.c:1017:             PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	movs	r1, r4	@, ivtmp.536
	movs	r0, r7	@, ivtmp.534
@ Data/FE6_FE7.c:1013:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.532,
@ Data/FE6_FE7.c:1017:             PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	bl	.L310		@
@ Data/FE6_FE7.c:1013:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r7, r7, #8	@ ivtmp.534,
	adds	r4, r4, #128	@ ivtmp.536,
	cmp	r6, r5	@ ivtmp.532, _186
	bne	.L276		@,
.L306:
	ldr	r3, .L308+48	@ ivtmp.522,
	ldr	r7, .L308+52	@ tmp209,
	movs	r4, r5	@ _186, _186
	mov	r5, r9	@ ivtmp.498, ivtmp.498
	mov	r9, r3	@ ivtmp.522, ivtmp.522
	movs	r3, r7	@ tmp209, tmp209
	movs	r6, r5	@ ivtmp.520, ivtmp.498
	movs	r7, r4	@ _186, _186
	mov	r4, r9	@ ivtmp.522, ivtmp.522
	mov	r9, r5	@ ivtmp.498, ivtmp.498
	mov	r5, r8	@ ivtmp.524, ivtmp.524
	mov	r8, r3	@ tmp209, tmp209
.L278:
@ Data/FE6_FE7.c:1023:         if (proc->tmp[i])
	movs	r2, #0	@ tmp280,
	ldrsh	r3, [r6, r2]	@ MEM[(short int *)_145], ivtmp.520, tmp280
@ Data/FE6_FE7.c:1029:             n = 0;
	movs	r2, #0	@ n,
@ Data/FE6_FE7.c:1023:         if (proc->tmp[i])
	cmp	r3, #0	@ MEM[(short int *)_145],
	beq	.L277		@,
@ Data/FE6_FE7.c:1025:             n = itemData[i]->number;
	ldr	r3, [r5]	@ MEM[(const struct ItemData * *)_148], MEM[(const struct ItemData * *)_148]
@ Data/FE6_FE7.c:1025:             n = itemData[i]->number;
	ldrb	r2, [r3, #6]	@ n,
.L277:
@ Data/FE6_FE7.c:2748:     PutNumber(tm, color, number);
	movs	r0, r4	@, ivtmp.522
	movs	r1, #3	@,
@ Data/FE6_FE7.c:1021:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.520,
@ Data/FE6_FE7.c:2748:     PutNumber(tm, color, number);
	bl	.L193		@
@ Data/FE6_FE7.c:1021:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r4, r4, #128	@ ivtmp.522,
	adds	r5, r5, #4	@ ivtmp.524,
	cmp	r6, r7	@ ivtmp.520, _186
	bne	.L278		@,
	ldr	r3, .L308+56	@ ivtmp.511,
	movs	r4, r7	@ _186, _186
	mov	r7, r8	@ tmp209, tmp209
	mov	r8, r3	@ ivtmp.511, ivtmp.511
@ Data/FE6_FE7.c:1038:             n = (proc->tmp[i] & 0xFF00) >> 8;
	movs	r3, #255	@ tmp217,
	mov	r5, r9	@ ivtmp.498, ivtmp.498
	mov	r9, r3	@ tmp217, tmp217
	movs	r3, r7	@ tmp209, tmp209
@ Data/FE6_FE7.c:1021:     for (int i = 0; i < NumberOfItems; ++i)
	movs	r6, r5	@ ivtmp.509, ivtmp.498
@ Data/FE6_FE7.c:1038:             n = (proc->tmp[i] & 0xFF00) >> 8;
	mov	r7, r8	@ ivtmp.511, ivtmp.511
	mov	r8, r5	@ ivtmp.498, ivtmp.498
	movs	r5, r3	@ tmp209, tmp209
.L280:
@ Data/FE6_FE7.c:1036:         if (proc->tmp[i])
	movs	r2, #0	@ tmp281,
	ldrsh	r3, [r6, r2]	@ _32, ivtmp.509, tmp281
@ Data/FE6_FE7.c:1042:             n = 0;
	movs	r2, #0	@ n,
@ Data/FE6_FE7.c:1036:         if (proc->tmp[i])
	cmp	r3, #0	@ _32,
	beq	.L279		@,
@ Data/FE6_FE7.c:1038:             n = (proc->tmp[i] & 0xFF00) >> 8;
	asrs	r2, r3, #8	@ tmp200, _32,
@ Data/FE6_FE7.c:1038:             n = (proc->tmp[i] & 0xFF00) >> 8;
	mov	r3, r9	@ tmp217, tmp217
	ands	r2, r3	@ n, tmp217
.L279:
@ Data/FE6_FE7.c:1044:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X + 3, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, n);
	movs	r0, r7	@, ivtmp.511
	movs	r1, #3	@,
@ Data/FE6_FE7.c:1034:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.509,
@ Data/FE6_FE7.c:1044:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X + 3, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, n);
	bl	.L28		@
@ Data/FE6_FE7.c:1034:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r7, r7, #128	@ ivtmp.511,
	cmp	r6, r4	@ ivtmp.509, _186
	bne	.L280		@,
@ Data/FE6_FE7.c:1055:                 DrawIcon(TILEMAP_LOCATED(gBG0TilemapBuffer, x - 2, Y_HAND + (i * 2)), icon, 0x4000);
	ldr	r3, .L308+60	@ tmp215,
	mov	r5, r8	@ ivtmp.498, ivtmp.498
	ldr	r6, .L308+64	@ ivtmp.500,
	mov	r8, r3	@ tmp215, tmp215
	ldr	r7, .L308+68	@ tmp210,
	b	.L282		@
.L281:
@ Data/FE6_FE7.c:1048:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r5, r5, #2	@ ivtmp.498,
	adds	r6, r6, #128	@ ivtmp.500,
	cmp	r5, r4	@ ivtmp.498, _186
	beq	.L307		@,
.L282:
@ Data/FE6_FE7.c:1050:         icon = GetItemIconId(proc->tmp[i]);
	movs	r3, #0	@ tmp282,
	ldrsh	r0, [r5, r3]	@ MEM[(short int *)_96], ivtmp.498, tmp282
	bl	.L145		@
@ Data/FE6_FE7.c:1051:         if (icon >= 0)
	cmp	r0, #0	@ icon,
	blt	.L281		@,
@ Data/FE6_FE7.c:1053:             if (proc->tmp[i])
	movs	r2, #0	@ tmp283,
	ldrsh	r3, [r5, r2]	@ MEM[(short int *)_96], ivtmp.498, tmp283
	cmp	r3, #0	@ MEM[(short int *)_96],
	beq	.L281		@,
@ Data/FE6_FE7.c:1055:                 DrawIcon(TILEMAP_LOCATED(gBG0TilemapBuffer, x - 2, Y_HAND + (i * 2)), icon, 0x4000);
	movs	r2, #128	@,
	movs	r1, r0	@, icon
	lsls	r2, r2, #7	@,,
	movs	r0, r6	@, ivtmp.500
@ Data/FE6_FE7.c:1048:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r5, r5, #2	@ ivtmp.498,
@ Data/FE6_FE7.c:1055:                 DrawIcon(TILEMAP_LOCATED(gBG0TilemapBuffer, x - 2, Y_HAND + (i * 2)), icon, 0x4000);
	bl	.L193		@
@ Data/FE6_FE7.c:1048:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #128	@ ivtmp.500,
	cmp	r5, r4	@ ivtmp.498, _186
	bne	.L282		@,
.L307:
@ Data/FE6_FE7.c:1060:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	bl	.L311		@
@ Data/FE6_FE7.c:1061: }
	add	sp, sp, #36	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	mov	fp, r7
	mov	r10, r6
	mov	r9, r5
	mov	r8, r4
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L309:
	.align	2
.L308:
	.word	gBG0TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.word	ResetIconGraphics
	.word	GetItemData
	.word	gStatScreen+24
	.word	ClearText
	.word	GetItemDescId
	.word	GetItemName
	.word	Text_DrawString
	.word	PutText
	.word	gBG0TilemapBuffer+146
	.word	gBG0TilemapBuffer+166
	.word	PutNumber
	.word	gBG0TilemapBuffer+172
	.word	DrawIcon
	.word	gBG0TilemapBuffer+142
	.word	GetItemIconId
	.size	RedrawItemMenu, .-RedrawItemMenu
	.align	1
	.p2align 2,,3
	.global	EditItemsInit
	.syntax unified
	.code	16
	.thumb_func
	.type	EditItemsInit, %function
EditItemsInit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:385:     ResetTextFont();
	ldr	r6, .L315	@ tmp130,
@ Data/FE6_FE7.c:952: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:952: {
	movs	r5, r0	@ proc, tmp161
@ Data/FE6_FE7.c:385:     ResetTextFont();
	bl	.L38		@
@ Data/FE6_FE7.c:386:     SetTextFontGlyphs(0);
	ldr	r4, .L315+4	@ tmp131,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:389:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L315+8	@ tmp132,
	ldr	r3, .L315+12	@ tmp133,
	bl	.L17		@
@ Data/FE6_FE7.c:390:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L315+16	@ tmp134,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:391:     ResetTextFont();
	bl	.L38		@
@ Data/FE6_FE7.c:392:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:393:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L315+20	@ tmp137,
	bl	.L17		@
@ Data/FE6_FE7.c:394:     ClearBg0Bg1();
	ldr	r3, .L315+24	@ tmp138,
	bl	.L17		@
@ Data/FE6_FE7.c:395:     ResetText();
	ldr	r3, .L315+28	@ tmp139,
	bl	.L17		@
@ Data/FE6_FE7.c:954:     LoadIconPalettes(4);
	movs	r0, #4	@,
	ldr	r3, .L315+32	@ tmp140,
	bl	.L17		@
@ Data/FE6_FE7.c:958:         proc->tmp[i] = unit->items[i];
	movs	r2, #64	@ tmp141,
@ Data/FE6_FE7.c:955:     struct Unit * unit = proc->unit;
	ldr	r3, [r5, #60]	@ unit, proc_11(D)->unit
@ Data/FE6_FE7.c:958:         proc->tmp[i] = unit->items[i];
	ldrh	r1, [r3, #30]	@ tmp142,
	strh	r1, [r5, r2]	@ tmp142, proc_11(D)->tmp[0]
	ldrh	r1, [r3, #32]	@ tmp145,
	adds	r2, r2, #2	@ tmp144,
	strh	r1, [r5, r2]	@ tmp145, proc_11(D)->tmp[1]
	ldrh	r1, [r3, #34]	@ tmp148,
	adds	r2, r2, #2	@ tmp147,
	strh	r1, [r5, r2]	@ tmp148, proc_11(D)->tmp[2]
	ldrh	r1, [r3, #36]	@ tmp151,
	adds	r2, r2, #2	@ tmp150,
	strh	r1, [r5, r2]	@ tmp151, proc_11(D)->tmp[3]
	ldrh	r2, [r3, #38]	@ tmp154,
	movs	r3, #72	@ tmp153,
	strh	r2, [r5, r3]	@ tmp154, proc_11(D)->tmp[4]
@ Data/FE6_FE7.c:76:     PutUiWindowFrame(x, y, width, height, style);
	movs	r3, #0	@ tmp156,
	ldr	r4, .L315+36	@ tmp157,
	str	r3, [sp]	@ tmp156,
	movs	r2, #18	@,
	movs	r1, #1	@,
	movs	r0, #6	@,
	adds	r3, r3, #12	@,
	bl	.L27		@
	ldr	r4, .L315+40	@ ivtmp.572,
	movs	r7, r4	@ _58, ivtmp.572
	ldr	r6, .L315+44	@ tmp160,
	adds	r7, r7, #40	@ _58,
.L313:
@ Data/FE6_FE7.c:974:         InitText(&th[i], ItemNameWidth);
	movs	r0, r4	@, ivtmp.572
	movs	r1, #8	@,
@ Data/FE6_FE7.c:972:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r4, r4, #8	@ ivtmp.572,
@ Data/FE6_FE7.c:974:         InitText(&th[i], ItemNameWidth);
	bl	.L38		@
@ Data/FE6_FE7.c:972:     for (int i = 0; i < NumberOfItems; ++i)
	cmp	r4, r7	@ ivtmp.572, _58
	bne	.L313		@,
@ Data/FE6_FE7.c:977:     RedrawItemMenu(proc);
	movs	r0, r5	@, proc
	bl	RedrawItemMenu		@
@ Data/FE6_FE7.c:978: }
	add	sp, sp, #12	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L316:
	.align	2
.L315:
	.word	ResetTextFont
	.word	SetTextFontGlyphs
	.word	gBG0TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.word	SetTextFont
	.word	ClearBg0Bg1
	.word	ResetText
	.word	LoadIconPalettes
	.word	PutUiWindowFrame
	.word	gStatScreen+24
	.word	InitText
	.size	EditItemsInit, .-EditItemsInit
	.align	1
	.p2align 2,,3
	.global	EditItemsIdle
	.syntax unified
	.code	16
	.thumb_func
	.type	EditItemsIdle, %function
EditItemsIdle:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
	mov	lr, r9	@,
	mov	r7, r8	@,
	push	{r7, lr}	@
@ Data/FE6_FE7.c:1068:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L434	@ tmp292,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r6, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:1065: {
	movs	r4, r0	@ proc, tmp659
@ Data/FE6_FE7.c:1069:     if (keys & B_BUTTON)
	lsls	r3, r6, #30	@ tmp667, keys,
	bpl	.LCB2404	@
	b	.L424	@long jump	@
.LCB2404:
.L318:
@ Data/FE6_FE7.c:1075:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp305,
	tst	r3, r6	@ tmp305, keys
	beq	.LCB2411	@
	b	.L425	@long jump	@
.LCB2411:
.L319:
@ Data/FE6_FE7.c:1084:         u16 item = proc->tmp[proc->id];
	movs	r5, #48	@ tmp327,
	ldrsb	r1, [r4, r5]	@ prephitmp_305,
@ Data/FE6_FE7.c:1082:     if (keys & SELECT_BUTTON)
	lsls	r3, r6, #29	@ tmp668, keys,
	bpl	.L320		@,
@ Data/FE6_FE7.c:1084:         u16 item = proc->tmp[proc->id];
	movs	r3, r1	@ tmp335, prephitmp_305
	adds	r3, r3, #32	@ tmp335,
	lsls	r3, r3, #1	@ tmp336, tmp335,
@ Data/FE6_FE7.c:1084:         u16 item = proc->tmp[proc->id];
	ldrh	r0, [r3, r4]	@ item, *proc_187(D)
@ Data/FE6_FE7.c:1085:         if (item)
	cmp	r0, #0	@ item,
	beq	.LCB2426	@
	b	.L426	@long jump	@
.LCB2426:
.L320:
@ Data/FE6_FE7.c:1097:     if (proc->editing)
	movs	r5, #46	@ tmp347,
	movs	r7, #16	@ tmp351,
	ldrsb	r3, [r4, r5]	@ _26,
@ Data/FE6_FE7.c:1101:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r1, #1	@ tmp353,
@ Data/FE6_FE7.c:1097:     if (proc->editing)
	mov	r8, r3	@ _26, _26
	ands	r7, r6	@ _328, keys
@ Data/FE6_FE7.c:1101:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ _330, tmp353,
@ Data/FE6_FE7.c:1097:     if (proc->editing)
	cmp	r3, #0	@ _26,
	bne	.LCB2438	@
	b	.L322	@long jump	@
.LCB2438:
@ Data/FE6_FE7.c:1101:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r2, #49	@ tmp355,
	ldrsb	r2, [r4, r2]	@ tmp356,
@ Data/FE6_FE7.c:1101:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r3, .L434+4	@ tmp354,
	lsls	r2, r2, #3	@ tmp357, tmp356,
	adds	r3, r3, r2	@ tmp358, tmp354, tmp357
	ldr	r0, [r3, #120]	@ pretmp_325, CursorLocationTable[_324].x
@ Data/FE6_FE7.c:1099:         if (proc->editing == 1)
	mov	r3, r8	@ _26, _26
	cmp	r3, #1	@ _26,
	bne	.LCB2447	@
	b	.L427	@long jump	@
.LCB2447:
@ Data/FE6_FE7.c:525:     int result = 1;
	movs	r5, #1	@ result,
@ Data/FE6_FE7.c:1176:             DisplayVertUiHand(CursorLocationTable[proc->digit].x + (3 * 8), (Y_HAND + (proc->id * 2)) * 8);
	adds	r0, r0, #24	@ tmp496,
@ Data/FE6_FE7.c:1176:             DisplayVertUiHand(CursorLocationTable[proc->digit].x + (3 * 8), (Y_HAND + (proc->id * 2)) * 8);
	bl	DisplayVertUiHand		@
	ldr	r3, .L434+8	@ tmp652,
	mov	r8, r3	@ tmp652, tmp652
	adds	r3, r3, #76	@ ivtmp.591,
.L344:
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	adds	r3, r3, #4	@ ivtmp.591,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	subs	r1, r3, #4	@ tmp499, ivtmp.591,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	ldr	r1, [r1]	@ MEM[(const int *)_146 + 4294967292B], MEM[(const int *)_146 + 4294967292B]
@ Data/FE6_FE7.c:528:         result++;
	adds	r5, r5, #1	@ result,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	cmp	r1, #254	@ MEM[(const int *)_146 + 4294967292B],
	ble	.L344		@,
@ Data/FE6_FE7.c:530:     if (result > 9)
	cmp	r5, #9	@ _265,
	ble	.L345		@,
	movs	r5, #9	@ _265,
.L345:
@ Data/FE6_FE7.c:1181:             if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _328,
	beq	.L346		@,
@ Data/FE6_FE7.c:1183:                 if (proc->digit > 0)
	movs	r3, #49	@ tmp501,
	ldrsb	r3, [r4, r3]	@ _90,
@ Data/FE6_FE7.c:1183:                 if (proc->digit > 0)
	cmp	r3, #0	@ _90,
	bgt	.LCB2472	@
	b	.L347	@long jump	@
.LCB2472:
@ Data/FE6_FE7.c:1185:                     proc->digit--;
	subs	r3, r3, #1	@ tmp505,
	lsls	r3, r3, #24	@ tmp506, tmp505,
	asrs	r3, r3, #24	@ _93, tmp506,
.L348:
	movs	r2, #49	@ tmp513,
@ Data/FE6_FE7.c:1192:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _93, proc_187(D)->digit
	bl	RedrawItemMenu		@
.L346:
@ Data/FE6_FE7.c:1194:             if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp671, keys,
	bpl	.L349		@,
@ Data/FE6_FE7.c:1196:                 if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp522,
	ldrsb	r3, [r4, r3]	@ _97,
@ Data/FE6_FE7.c:1196:                 if (proc->digit < (max_digits - 1))
	subs	r5, r5, #1	@ tmp523,
@ Data/FE6_FE7.c:1196:                 if (proc->digit < (max_digits - 1))
	cmp	r3, r5	@ _97, tmp523
	bge	.LCB2494	@
	b	.L428	@long jump	@
.LCB2494:
@ Data/FE6_FE7.c:1203:                     proc->editing = 1;
	movs	r3, #46	@ tmp527,
	movs	r2, #1	@ tmp528,
	strb	r2, [r4, r3]	@ tmp528, proc_187(D)->editing
@ Data/FE6_FE7.c:1202:                     proc->digit = 0;
	movs	r3, #0	@ cstore_65,
.L351:
	movs	r2, #49	@ tmp530,
@ Data/FE6_FE7.c:1206:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ cstore_65, proc_187(D)->digit
	bl	RedrawItemMenu		@
.L349:
@ Data/FE6_FE7.c:1209:             if (keys & DPAD_UP)
	movs	r3, #64	@ tmp533,
	tst	r3, r6	@ tmp533, keys
	beq	.L352		@,
@ Data/FE6_FE7.c:1211:                 if ((proc->tmp[proc->id] & 0xFF00) == max)
	movs	r2, #48	@ tmp539,
	ldrsb	r2, [r4, r2]	@ tmp540,
	lsls	r2, r2, #1	@ tmp541, tmp540,
	adds	r2, r4, r2	@ _206, proc, tmp541
@ Data/FE6_FE7.c:1211:                 if ((proc->tmp[proc->id] & 0xFF00) == max)
	ldrsh	r1, [r2, r3]	@ _105, MEM <s16> [(struct DebuggerProc *)_206 + 64B]
@ Data/FE6_FE7.c:1211:                 if ((proc->tmp[proc->id] & 0xFF00) == max)
	movs	r3, #255	@ tmp544,
	movs	r0, r1	@ tmp543, _105
	lsls	r3, r3, #8	@ tmp544, tmp544,
	ands	r0, r3	@ tmp543, tmp544
@ Data/FE6_FE7.c:1211:                 if ((proc->tmp[proc->id] & 0xFF00) == max)
	cmp	r0, r3	@ tmp543, tmp544
	bne	.LCB2523	@
	b	.L429	@long jump	@
.LCB2523:
@ Data/FE6_FE7.c:1217:                     proc->tmp[proc->id] += DigitDecimalTable[proc->digit] << 8;
	movs	r3, #49	@ tmp551,
	ldrsb	r3, [r4, r3]	@ tmp552,
@ Data/FE6_FE7.c:1217:                     proc->tmp[proc->id] += DigitDecimalTable[proc->digit] << 8;
	lsls	r3, r3, #2	@ tmp553, tmp552,
	add	r3, r3, r8	@ tmp554, tmp652
@ Data/FE6_FE7.c:1217:                     proc->tmp[proc->id] += DigitDecimalTable[proc->digit] << 8;
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_112], DigitDecimalTable[_112]
	lsls	r3, r3, #8	@ tmp558, DigitDecimalTable[_112],
@ Data/FE6_FE7.c:1217:                     proc->tmp[proc->id] += DigitDecimalTable[proc->digit] << 8;
	adds	r3, r3, r1	@ tmp561, tmp558, _105
	lsls	r3, r3, #16	@ cstore_39, tmp561,
	asrs	r3, r3, #16	@ cstore_39, cstore_39,
.L354:
	movs	r1, #64	@ tmp562,
@ Data/FE6_FE7.c:1223:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strh	r3, [r2, r1]	@ cstore_39, MEM <s16> [(struct DebuggerProc *)_206 + 64B]
	bl	RedrawItemMenu		@
.L352:
@ Data/FE6_FE7.c:1225:             if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp672, keys,
	bpl	.L317		@,
@ Data/FE6_FE7.c:1228:                 if ((proc->tmp[proc->id] & 0xFF00) == min)
	movs	r3, #48	@ tmp571,
@ Data/FE6_FE7.c:1228:                 if ((proc->tmp[proc->id] & 0xFF00) == min)
	movs	r2, #64	@ tmp574,
	ldrsb	r3, [r4, r3]	@ tmp572,
	lsls	r3, r3, #1	@ tmp573, tmp572,
	adds	r3, r4, r3	@ _83, proc, tmp573
	ldrsh	r2, [r3, r2]	@ _126, MEM <s16> [(struct DebuggerProc *)_83 + 64B]
@ Data/FE6_FE7.c:1228:                 if ((proc->tmp[proc->id] & 0xFF00) == min)
	movs	r1, #255	@ tmp576,
	lsls	r1, r1, #8	@ tmp576, tmp576,
@ Data/FE6_FE7.c:1228:                 if ((proc->tmp[proc->id] & 0xFF00) == min)
	tst	r2, r1	@ _126, tmp576
	bne	.LCB2557	@
	b	.L430	@long jump	@
.LCB2557:
@ Data/FE6_FE7.c:1234:                     proc->tmp[proc->id] -= DigitDecimalTable[proc->digit] << 8;
	movs	r1, #49	@ tmp585,
	ldrsb	r1, [r4, r1]	@ tmp586,
@ Data/FE6_FE7.c:1234:                     proc->tmp[proc->id] -= DigitDecimalTable[proc->digit] << 8;
	lsls	r1, r1, #2	@ tmp587, tmp586,
	add	r1, r1, r8	@ tmp588, tmp652
@ Data/FE6_FE7.c:1234:                     proc->tmp[proc->id] -= DigitDecimalTable[proc->digit] << 8;
	ldr	r1, [r1, #68]	@ DigitDecimalTable[_133], DigitDecimalTable[_133]
	lsls	r1, r1, #8	@ tmp592, DigitDecimalTable[_133],
@ Data/FE6_FE7.c:1234:                     proc->tmp[proc->id] -= DigitDecimalTable[proc->digit] << 8;
	subs	r2, r2, r1	@ tmp595, _126, tmp592
	lsls	r2, r2, #16	@ _130, tmp595,
	asrs	r2, r2, #16	@ _130, _130,
.L357:
	movs	r1, #64	@ tmp596,
@ Data/FE6_FE7.c:1241:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strh	r2, [r3, r1]	@ _130, MEM <s16> [(struct DebuggerProc *)_83 + 64B]
	bl	RedrawItemMenu		@
.L317:
@ Data/FE6_FE7.c:1279: }
	@ sp needed	@
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L427:
@ Data/FE6_FE7.c:1101:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	bl	DisplayVertUiHand		@
@ Data/FE6_FE7.c:1627:     const struct ItemData * table = GetItemData(1);
	ldr	r3, .L434+12	@ tmp651,
	movs	r0, #1	@,
	mov	r9, r3	@ tmp651, tmp651
@ Data/FE6_FE7.c:1629:     int i = 1;
	subs	r5, r5, #45	@ i,
@ Data/FE6_FE7.c:1627:     const struct ItemData * table = GetItemData(1);
	bl	.L17		@
@ Data/FE6_FE7.c:1630:     for (; i <= 256; i++)
	b	.L324		@
.L413:
@ Data/FE6_FE7.c:1630:     for (; i <= 256; i++)
	adds	r5, r5, #1	@ i,
.L324:
@ Data/FE6_FE7.c:1632:         table = GetItemData(i);
	movs	r0, r5	@, i
	bl	.L139		@
@ Data/FE6_FE7.c:1633:         if (table->number != i)
	ldrb	r3, [r0, #6]	@ tmp364,
@ Data/FE6_FE7.c:1633:         if (table->number != i)
	cmp	r5, r3	@ i, tmp364
	beq	.L413		@,
@ Data/FE6_FE7.c:1635:             i--;
	subs	r0, r5, #1	@ i, i,
@ Data/FE6_FE7.c:1639:     table = GetItemData(i);
	bl	.L139		@
@ Data/FE6_FE7.c:1640:     c = table->number;
	ldrb	r5, [r0, #6]	@ c,
@ Data/FE6_FE7.c:1645:     if (c <= 1)
	cmp	r5, #1	@ c,
	bgt	.LCB2611	@
	b	.L431	@long jump	@
.LCB2611:
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	cmp	r5, #16	@ c,
	bgt	.LCB2613	@
	b	.L432	@long jump	@
.LCB2613:
.L325:
@ Data/FE6_FE7.c:1647:         c = 0x7F;
	movs	r3, #2	@ prephitmp_306,
	mov	r9, r3	@ prephitmp_306, prephitmp_306
.L329:
@ Data/FE6_FE7.c:1107:             if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _328,
	beq	.L330		@,
@ Data/FE6_FE7.c:1109:                 if (proc->digit > 0)
	movs	r3, #49	@ tmp365,
	ldrsb	r3, [r4, r3]	@ _23,
@ Data/FE6_FE7.c:1109:                 if (proc->digit > 0)
	cmp	r3, #0	@ _23,
	bgt	.LCB2624	@
	b	.L331	@long jump	@
.LCB2624:
@ Data/FE6_FE7.c:1111:                     proc->digit--;
	subs	r3, r3, #1	@ tmp369,
	lsls	r3, r3, #24	@ tmp370, tmp369,
	asrs	r3, r3, #24	@ _26, tmp370,
	mov	r8, r3	@ _26, _26
.L332:
	movs	r3, #49	@ tmp374,
	mov	r2, r8	@ _26, _26
@ Data/FE6_FE7.c:1119:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _26, proc_187(D)->digit
	bl	RedrawItemMenu		@
.L330:
@ Data/FE6_FE7.c:1121:             if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp669, keys,
	bpl	.L333		@,
@ Data/FE6_FE7.c:1123:                 if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp383,
	ldrsb	r2, [r4, r3]	@ _27,
@ Data/FE6_FE7.c:1123:                 if (proc->digit < (max_digits - 1))
	mov	r3, r9	@ prephitmp_306, prephitmp_306
	subs	r3, r3, #1	@ prephitmp_306,
	subs	r1, r3, #1	@ tmp387, tmp386
	sbcs	r3, r3, r1	@ tmp385, tmp386, tmp387
@ Data/FE6_FE7.c:1123:                 if (proc->digit < (max_digits - 1))
	cmp	r2, r3	@ _27, tmp385
	blt	.LCB2650	@
	b	.L334	@long jump	@
.LCB2650:
@ Data/FE6_FE7.c:1125:                     proc->digit++;
	adds	r2, r2, #1	@ tmp389,
	lsls	r3, r2, #24	@ tmp390, tmp389,
	asrs	r3, r3, #24	@ _32, tmp390,
.L335:
	movs	r2, #49	@ tmp394,
@ Data/FE6_FE7.c:1132:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _32, proc_187(D)->digit
	bl	RedrawItemMenu		@
.L333:
@ Data/FE6_FE7.c:1135:             if (keys & DPAD_UP)
	movs	r3, #64	@ tmp397,
	tst	r3, r6	@ tmp397, keys
	beq	.L336		@,
@ Data/FE6_FE7.c:1137:                 if ((proc->tmp[proc->id] & 0xFF) == max)
	movs	r2, #48	@ tmp403,
@ Data/FE6_FE7.c:1137:                 if ((proc->tmp[proc->id] & 0xFF) == max)
	movs	r0, #255	@ tmp408,
	ldrsb	r2, [r4, r2]	@ tmp404,
	lsls	r2, r2, #1	@ tmp405, tmp404,
	adds	r2, r4, r2	@ _81, proc, tmp405
@ Data/FE6_FE7.c:1137:                 if ((proc->tmp[proc->id] & 0xFF) == max)
	ldrsh	r1, [r2, r3]	@ _35, MEM <s16> [(struct DebuggerProc *)_81 + 64B]
@ Data/FE6_FE7.c:1137:                 if ((proc->tmp[proc->id] & 0xFF) == max)
	movs	r3, r0	@ tmp411, tmp408
	ands	r3, r1	@ tmp411, _35
@ Data/FE6_FE7.c:1137:                 if ((proc->tmp[proc->id] & 0xFF) == max)
	cmp	r3, r5	@ tmp411, c
	bne	.LCB2678	@
	b	.L433	@long jump	@
.LCB2678:
@ Data/FE6_FE7.c:1143:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	movs	r7, #49	@ tmp415,
	ldrsb	r7, [r4, r7]	@ tmp416,
@ Data/FE6_FE7.c:1143:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	ldr	r3, .L434+8	@ tmp414,
	lsls	r7, r7, #2	@ tmp417, tmp416,
	adds	r3, r3, r7	@ tmp418, tmp414, tmp417
@ Data/FE6_FE7.c:1143:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	ldr	r3, [r3, #104]	@ *_43, *_43
	adds	r3, r3, r1	@ tmp423, *_43, _35
@ Data/FE6_FE7.c:1144:                     if ((proc->tmp[proc->id] & 0xFF) > max)
	movs	r1, r0	@ tmp427, tmp408
@ Data/FE6_FE7.c:1143:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	lsls	r3, r3, #16	@ tmp424, tmp423,
	lsrs	r3, r3, #16	@ _46, tmp424,
@ Data/FE6_FE7.c:1144:                     if ((proc->tmp[proc->id] & 0xFF) > max)
	ands	r1, r3	@ tmp427, _46
@ Data/FE6_FE7.c:1144:                     if ((proc->tmp[proc->id] & 0xFF) > max)
	cmp	r1, r5	@ tmp427, c
	ble	.LCB2693	@
	b	.L339	@long jump	@
.LCB2693:
@ Data/FE6_FE7.c:1143:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	lsls	r3, r3, #16	@ _38, _46,
@ Data/FE6_FE7.c:1149:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	lsls	r0, r1, #16	@ _311, tmp427,
@ Data/FE6_FE7.c:1143:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	asrs	r3, r3, #16	@ _38, _38,
@ Data/FE6_FE7.c:1149:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	asrs	r0, r0, #16	@ _311, _311,
.L338:
@ Data/FE6_FE7.c:1139:                     proc->tmp[proc->id] = min | (proc->tmp[proc->id] & 0xFF00);
	movs	r1, #64	@ tmp444,
	strh	r3, [r2, r1]	@ _38, MEM <s16> [(struct DebuggerProc *)_81 + 64B]
@ Data/FE6_FE7.c:1149:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	ldr	r3, .L434+16	@ tmp446,
	bl	.L17		@
@ Data/FE6_FE7.c:1149:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	movs	r3, #48	@ tmp447,
	ldrsb	r3, [r4, r3]	@ tmp448,
@ Data/FE6_FE7.c:1149:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	adds	r3, r3, #32	@ tmp449,
	lsls	r3, r3, #1	@ tmp450, tmp449,
	strh	r0, [r4, r3]	@ tmp663, proc_187(D)->tmp[_56]
@ Data/FE6_FE7.c:1150:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	bl	RedrawItemMenu		@
.L336:
@ Data/FE6_FE7.c:1152:             if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp670, keys,
	bmi	.LCB2719	@
	b	.L317	@long jump	@
.LCB2719:
@ Data/FE6_FE7.c:1154:                 if ((proc->tmp[proc->id] & 0xFF) == min)
	movs	r3, #48	@ tmp459,
@ Data/FE6_FE7.c:1154:                 if ((proc->tmp[proc->id] & 0xFF) == min)
	movs	r2, #64	@ tmp462,
	movs	r1, #255	@ tmp466,
	ldrsb	r3, [r4, r3]	@ tmp460,
	lsls	r3, r3, #1	@ tmp461, tmp460,
	adds	r3, r4, r3	@ _222, proc, tmp461
	ldrsh	r0, [r3, r2]	@ _60, MEM <s16> [(struct DebuggerProc *)_222 + 64B]
	movs	r6, r1	@ _147, tmp466
@ Data/FE6_FE7.c:1156:                     proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF00);
	movs	r2, r0	@ _63, _60
	ands	r6, r0	@ _147, _60
	bics	r2, r1	@ _63, tmp466
@ Data/FE6_FE7.c:1154:                 if ((proc->tmp[proc->id] & 0xFF) == min)
	tst	r1, r0	@ tmp466, _60
	beq	.LCB2734	@
	b	.L342	@long jump	@
.LCB2734:
@ Data/FE6_FE7.c:1156:                     proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF00);
	orrs	r2, r5	@ _63, c
@ Data/FE6_FE7.c:1170:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	ands	r1, r2	@ tmp466, _63
	movs	r0, r1	@ _318, tmp466
.L343:
@ Data/FE6_FE7.c:1156:                     proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF00);
	movs	r1, #64	@ tmp488,
	strh	r2, [r3, r1]	@ _63, MEM <s16> [(struct DebuggerProc *)_222 + 64B]
@ Data/FE6_FE7.c:1170:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	ldr	r3, .L434+16	@ tmp490,
	bl	.L17		@
@ Data/FE6_FE7.c:1170:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	movs	r3, #48	@ tmp491,
	ldrsb	r3, [r4, r3]	@ tmp492,
@ Data/FE6_FE7.c:1170:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	adds	r3, r3, #32	@ tmp493,
	lsls	r3, r3, #1	@ tmp494, tmp493,
	strh	r0, [r4, r3]	@ tmp664, proc_187(D)->tmp[_79]
@ Data/FE6_FE7.c:1171:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	bl	RedrawItemMenu		@
	b	.L317		@
.L322:
@ Data/FE6_FE7.c:1247:         DisplayUiHand(CursorLocationTable[0].x - ((ItemNameWidth + 4) * 8), (Y_HAND + (proc->id * 2)) * 8);
	movs	r0, #52	@,
	ldr	r3, .L434+20	@ tmp598,
	bl	.L17		@
@ Data/FE6_FE7.c:1248:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _328,
	beq	.L358		@,
@ Data/FE6_FE7.c:1250:             proc->digit = 1;
	movs	r3, #1	@ tmp600,
	movs	r2, #49	@ tmp599,
	strb	r3, [r4, r2]	@ tmp600, proc_187(D)->digit
@ Data/FE6_FE7.c:1251:             proc->editing = true;
	strb	r3, [r4, r5]	@ tmp600, proc_187(D)->editing
.L358:
@ Data/FE6_FE7.c:1253:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp673, keys,
	bpl	.L359		@,
@ Data/FE6_FE7.c:1255:             proc->digit = 0;
	movs	r3, #49	@ tmp612,
	movs	r2, #0	@ tmp613,
	strb	r2, [r4, r3]	@ tmp613, proc_187(D)->digit
@ Data/FE6_FE7.c:1256:             proc->editing = 2;
	subs	r3, r3, #3	@ tmp615,
	adds	r2, r2, #2	@ tmp616,
	strb	r2, [r4, r3]	@ tmp616, proc_187(D)->editing
.L359:
@ Data/FE6_FE7.c:1259:         if (keys & DPAD_UP)
	lsls	r3, r6, #25	@ tmp674, keys,
	bpl	.L360		@,
@ Data/FE6_FE7.c:1261:             proc->id--;
	movs	r3, #48	@ tmp625,
@ Data/FE6_FE7.c:1261:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp627,
	subs	r3, r3, #1	@ tmp628,
	lsls	r3, r3, #24	@ tmp629, tmp628,
	asrs	r2, r3, #24	@ _155, tmp629,
@ Data/FE6_FE7.c:1262:             if (proc->id < 0)
	cmp	r3, #0	@ tmp629,
	bge	.L361		@,
@ Data/FE6_FE7.c:1264:                 proc->id = NumberOfItems - 1;
	movs	r2, #4	@ _155,
.L361:
	movs	r3, #48	@ tmp633,
@ Data/FE6_FE7.c:1266:             RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _155, MEM <struct DebuggerProc> [(void *)proc_187(D)].id
	bl	RedrawItemMenu		@
.L360:
@ Data/FE6_FE7.c:1268:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp675, keys,
	bmi	.LCB2810	@
	b	.L317	@long jump	@
.LCB2810:
@ Data/FE6_FE7.c:1270:             proc->id++;
	movs	r1, #48	@ tmp642,
@ Data/FE6_FE7.c:1273:                 proc->id = 0;
	movs	r0, #4	@ tmp655,
	movs	r5, #0	@ tmp657,
@ Data/FE6_FE7.c:1270:             proc->id++;
	ldrb	r3, [r4, r1]	@ tmp644,
	adds	r3, r3, #1	@ tmp645,
	lsls	r3, r3, #24	@ tmp646, tmp645,
	asrs	r2, r3, #24	@ _160, tmp646,
@ Data/FE6_FE7.c:1273:                 proc->id = 0;
	lsrs	r3, r3, #31	@ tmp656, tmp646,
	cmp	r0, r2	@ tmp655, _160
	adcs	r3, r3, r5	@ tmp654, tmp656, tmp657
	rsbs	r3, r3, #0	@ tmp658, tmp654
	ands	r2, r3	@ _160, tmp658
@ Data/FE6_FE7.c:1276:             RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r1]	@ _160, MEM <struct DebuggerProc> [(void *)proc_187(D)].id
	bl	RedrawItemMenu		@
@ Data/FE6_FE7.c:1279: }
	b	.L317		@
.L425:
@ Data/FE6_FE7.c:1077:         CloseHelpBox();
	ldr	r3, .L434+24	@ tmp309,
	bl	.L17		@
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	movs	r3, #64	@ tmp310,
@ Data/FE6_FE7.c:449:     struct Unit * unit = proc->unit;
	ldr	r0, [r4, #60]	@ unit, proc_187(D)->unit
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r4, r3]	@ tmp311,
	strh	r3, [r0, #30]	@ tmp311, unit_267->items[0]
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	movs	r3, #66	@ tmp313,
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r4, r3]	@ tmp314,
	strh	r3, [r0, #32]	@ tmp314, unit_267->items[1]
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	movs	r3, #68	@ tmp316,
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r4, r3]	@ tmp317,
	strh	r3, [r0, #34]	@ tmp317, unit_267->items[2]
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	movs	r3, #70	@ tmp319,
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r4, r3]	@ tmp320,
	strh	r3, [r0, #36]	@ tmp320, unit_267->items[3]
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	movs	r3, #72	@ tmp322,
@ Data/FE6_FE7.c:452:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r4, r3]	@ tmp323,
	strh	r3, [r0, #38]	@ tmp323, unit_267->items[4]
@ Data/FE6_FE7.c:455:     UnitRemoveInvalidItems(unit);
	ldr	r3, .L434+28	@ tmp325,
	bl	.L17		@
@ Data/FE6_FE7.c:1079:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L434+32	@ tmp326,
	bl	.L17		@
@ Data/FE6_FE7.c:576: }
	b	.L319		@
.L424:
@ Data/FE6_FE7.c:1071:         CloseHelpBox();
	ldr	r3, .L434+24	@ tmp300,
	bl	.L17		@
@ Data/FE6_FE7.c:1072:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L434+32	@ tmp301,
	bl	.L17		@
@ Data/FE6_FE7.c:576: }
	b	.L318		@
.L435:
	.align	2
.L434:
	.word	gKeyStatusPtr
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	GetItemData
	.word	MakeNewItem
	.word	DisplayUiHand
	.word	CloseHelpBox
	.word	UnitRemoveInvalidItems
	.word	Proc_Goto
.L426:
@ Data/FE6_FE7.c:1087:             int msg = GetItemDescId(item);
	ldr	r3, .L436	@ tmp337,
	bl	.L17		@
@ Data/FE6_FE7.c:1088:             if (msg > 0 && msg < 0x4000)
	ldr	r3, .L436+4	@ tmp339,
@ Data/FE6_FE7.c:1088:             if (msg > 0 && msg < 0x4000)
	subs	r1, r0, #1	@ tmp338, msg,
@ Data/FE6_FE7.c:1087:             int msg = GetItemDescId(item);
	movs	r2, r0	@ msg, tmp660
@ Data/FE6_FE7.c:1088:             if (msg > 0 && msg < 0x4000)
	cmp	r1, r3	@ tmp338, tmp339
	bls	.L321		@,
.L423:
@ Data/FE6_FE7.c:1101:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r5]	@ prephitmp_305,
	b	.L320		@
.L428:
@ Data/FE6_FE7.c:1198:                     proc->digit++;
	adds	r3, r3, #1	@ tmp525,
	lsls	r3, r3, #24	@ tmp526, tmp525,
	asrs	r3, r3, #24	@ cstore_65, tmp526,
	b	.L351		@
.L430:
@ Data/FE6_FE7.c:1230:                     proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF);
	ldr	r1, .L436+8	@ tmp583,
	orrs	r2, r1	@ _130, tmp583
	b	.L357		@
.L347:
@ Data/FE6_FE7.c:1190:                     proc->editing = false;
	movs	r2, #46	@ tmp510,
	movs	r1, #0	@ tmp511,
@ Data/FE6_FE7.c:1189:                     proc->digit = max_digits - 1;
	subs	r3, r5, #1	@ tmp508, _265,
	lsls	r3, r3, #24	@ tmp509, tmp508,
@ Data/FE6_FE7.c:1190:                     proc->editing = false;
	strb	r1, [r4, r2]	@ tmp511, proc_187(D)->editing
@ Data/FE6_FE7.c:1189:                     proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _93, tmp509,
	b	.L348		@
.L429:
@ Data/FE6_FE7.c:1213:                     proc->tmp[proc->id] = min | (proc->tmp[proc->id] & 0xFF);
	movs	r3, #255	@ tmp549,
	ands	r3, r1	@ cstore_39, _105
	b	.L354		@
.L431:
@ Data/FE6_FE7.c:1647:         c = 0x7F;
	movs	r5, #127	@ c,
	b	.L325		@
.L334:
@ Data/FE6_FE7.c:1130:                     proc->editing = false;
	movs	r3, #46	@ tmp391,
	movs	r2, #0	@ tmp392,
	strb	r2, [r4, r3]	@ tmp392, proc_187(D)->editing
@ Data/FE6_FE7.c:1129:                     proc->digit = 0;
	movs	r3, #0	@ _32,
	b	.L335		@
.L342:
@ Data/FE6_FE7.c:1160:                     val = (proc->tmp[proc->id] & 0xFF) - pDigitTable[1][proc->digit];
	movs	r5, #49	@ tmp476,
	ldrsb	r5, [r4, r5]	@ tmp477,
@ Data/FE6_FE7.c:1160:                     val = (proc->tmp[proc->id] & 0xFF) - pDigitTable[1][proc->digit];
	ldr	r0, .L436+12	@ tmp475,
	lsls	r5, r5, #2	@ tmp478, tmp477,
	adds	r0, r0, r5	@ tmp479, tmp475, tmp478
@ Data/FE6_FE7.c:1160:                     val = (proc->tmp[proc->id] & 0xFF) - pDigitTable[1][proc->digit];
	ldr	r0, [r0, #104]	@ *_69, *_69
	subs	r6, r6, r0	@ val, _147, *_69
	movs	r0, #0	@ _318,
@ Data/FE6_FE7.c:1161:                     if (val < min)
	cmp	r6, #0	@ val,
	bge	.LCB2949	@
	b	.L343	@long jump	@
.LCB2949:
@ Data/FE6_FE7.c:1167:                         proc->tmp[proc->id] = val | (proc->tmp[proc->id] & 0xFF00);
	orrs	r2, r6	@ tmp483, val
	lsls	r2, r2, #16	@ _63, tmp483,
	asrs	r2, r2, #16	@ _63, _63,
@ Data/FE6_FE7.c:1170:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	ands	r1, r2	@ tmp466, _63
	movs	r0, r1	@ _318, tmp466
	b	.L343		@
.L321:
@ Data/FE6_FE7.c:1092:                     (Y_HAND + (proc->id * 2)) * 8,
	ldrsb	r1, [r4, r5]	@ tmp342,
@ Data/FE6_FE7.c:1092:                     (Y_HAND + (proc->id * 2)) * 8,
	adds	r1, r1, #1	@ tmp343,
@ Data/FE6_FE7.c:1090:                 StartHelpBox(
	movs	r0, #52	@,
	ldr	r3, .L436+16	@ tmp345,
	lsls	r1, r1, #4	@ tmp344, tmp343,
	bl	.L17		@
	b	.L423		@
.L339:
@ Data/FE6_FE7.c:1146:                         proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF00);
	bics	r3, r0	@ tmp435, tmp408
@ Data/FE6_FE7.c:1146:                         proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF00);
	orrs	r3, r5	@ tmp439, c
	lsls	r3, r3, #16	@ _38, tmp439,
	asrs	r3, r3, #16	@ _38, _38,
@ Data/FE6_FE7.c:1149:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	ands	r0, r3	@ _311, _38
	b	.L338		@
.L331:
@ Data/FE6_FE7.c:1116:                     proc->editing = 2;
	movs	r3, #46	@ tmp371,
	movs	r2, #2	@ tmp372,
	strb	r2, [r4, r3]	@ tmp372, proc_187(D)->editing
	b	.L332		@
.L433:
@ Data/FE6_FE7.c:1139:                     proc->tmp[proc->id] = min | (proc->tmp[proc->id] & 0xFF00);
	movs	r3, r1	@ _35, _35
	bics	r3, r0	@ _35, tmp408
	movs	r0, #0	@ _311,
	b	.L338		@
.L432:
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	movs	r3, #1	@ prephitmp_306,
	mov	r9, r3	@ prephitmp_306, prephitmp_306
	b	.L329		@
.L437:
	.align	2
.L436:
	.word	GetItemDescId
	.word	16382
	.word	-256
	.word	.LANCHOR1
	.word	StartHelpBox
	.size	EditItemsIdle, .-EditItemsIdle
	.align	1
	.p2align 2,,3
	.global	AdjustWEXPForClass
	.syntax unified
	.code	16
	.thumb_func
	.type	AdjustWEXPForClass, %function
AdjustWEXPForClass:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:1285: {
	movs	r5, r0	@ unit, tmp145
@ Data/FE6_FE7.c:1286:     if (unit->pClassData->number == classID)
	ldr	r3, [r5, #4]	@ unit_6(D)->pClassData, unit_6(D)->pClassData
	ldrb	r3, [r3, #4]	@ tmp132,
@ Data/FE6_FE7.c:1285: {
	movs	r0, r1	@ classID, tmp146
@ Data/FE6_FE7.c:1286:     if (unit->pClassData->number == classID)
	cmp	r3, r1	@ tmp132, classID
	beq	.L438		@,
@ Data/FE6_FE7.c:1290:     const struct ClassData * table = GetClassData(classID);
	ldr	r3, .L447	@ tmp133,
	bl	.L17		@
	movs	r2, r5	@ ivtmp.605, unit
	movs	r4, r0	@ table, tmp147
@ Data/FE6_FE7.c:1294:     for (int i = 0; i < 8; ++i)
	movs	r3, #0	@ i,
@ Data/FE6_FE7.c:1291:     unit->pClassData = table;
	str	r0, [r5, #4]	@ table, unit_6(D)->pClassData
	adds	r2, r2, #40	@ ivtmp.605,
	adds	r4, r4, #44	@ tmp142,
	b	.L444		@
.L446:
@ Data/FE6_FE7.c:1305:             unit->ranks[i] = 0; // zero out wexp
	strb	r1, [r2]	@ _11, MEM[(unsigned char *)_34]
.L441:
@ Data/FE6_FE7.c:1294:     for (int i = 0; i < 8; ++i)
	adds	r3, r3, #1	@ i,
@ Data/FE6_FE7.c:1294:     for (int i = 0; i < 8; ++i)
	adds	r2, r2, #1	@ ivtmp.605,
	cmp	r3, #8	@ i,
	beq	.L438		@,
.L444:
@ Data/FE6_FE7.c:1296:         classRank = table->baseRanks[i];
	ldrb	r1, [r4, r3]	@ _11, MEM[(unsigned char *)_35 + _36 * 1]
@ Data/FE6_FE7.c:1297:         if (!classRank) // new class has no rank
	cmp	r1, #0	@ _11,
	beq	.L446		@,
@ Data/FE6_FE7.c:1308:         else if (classRank > unit->ranks[i])
	ldrb	r0, [r2]	@ MEM[(unsigned char *)_31], MEM[(unsigned char *)_31]
	cmp	r0, r1	@ MEM[(unsigned char *)_31], _11
	bcs	.L441		@,
@ Data/FE6_FE7.c:1310:             unit->ranks[i] = classRank;
	strb	r1, [r2]	@ _11, MEM[(unsigned char *)_31]
@ Data/FE6_FE7.c:1311:             charRank = unit->pCharacterData->baseRanks[i];
	ldr	r0, [r5]	@ unit_6(D)->pCharacterData, unit_6(D)->pCharacterData
	adds	r0, r0, r3	@ tmp140, unit_6(D)->pCharacterData, i
	ldrb	r0, [r0, #20]	@ _14, *_13
@ Data/FE6_FE7.c:1312:             if (charRank > unit->ranks[i])
	cmp	r1, r0	@ _11, _14
	bcs	.L441		@,
@ Data/FE6_FE7.c:1294:     for (int i = 0; i < 8; ++i)
	adds	r3, r3, #1	@ i,
@ Data/FE6_FE7.c:1314:                 unit->ranks[i] = charRank;
	strb	r0, [r2]	@ _14, MEM[(unsigned char *)_31]
@ Data/FE6_FE7.c:1294:     for (int i = 0; i < 8; ++i)
	adds	r2, r2, #1	@ ivtmp.605,
	cmp	r3, #8	@ i,
	bne	.L444		@,
.L438:
@ Data/FE6_FE7.c:1318: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L448:
	.align	2
.L447:
	.word	GetClassData
	.size	AdjustWEXPForClass, .-AdjustWEXPForClass
	.align	1
	.p2align 2,,3
	.global	GetFreeUnitByFaction
	.syntax unified
	.code	16
	.thumb_func
	.type	GetFreeUnitByFaction, %function
GetFreeUnitByFaction:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:1322:     int i = faction, last = faction + 0x40;
	movs	r6, r0	@ last, faction
@ Data/FE6_FE7.c:1321: {
	movs	r4, r0	@ faction, tmp122
@ Data/FE6_FE7.c:1322:     int i = faction, last = faction + 0x40;
	adds	r6, r6, #64	@ last,
@ Data/FE6_FE7.c:1323:     if (!i)
	cmp	r0, #0	@ faction,
	bne	.L450		@,
@ Data/FE6_FE7.c:1324:         i = 1;
	adds	r4, r4, #1	@ faction,
.L450:
	ldr	r5, .L460	@ tmp121,
	b	.L452		@
.L459:
@ Data/FE6_FE7.c:1326:     for (; i < last; ++i)
	adds	r4, r4, #1	@ faction,
@ Data/FE6_FE7.c:1326:     for (; i < last; ++i)
	cmp	r6, r4	@ last, faction
	ble	.L458		@,
.L452:
@ Data/FE6_FE7.c:1328:         struct Unit * unit = GetUnit(i);
	movs	r0, r4	@, faction
	bl	.L28		@
@ Data/FE6_FE7.c:1330:         if (unit->pCharacterData == NULL)
	ldr	r3, [r0]	@ unit_11->pCharacterData, unit_11->pCharacterData
	cmp	r3, #0	@ unit_11->pCharacterData,
	bne	.L459		@,
.L449:
@ Data/FE6_FE7.c:1335: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L458:
@ Data/FE6_FE7.c:1334:     return NULL;
	movs	r0, #0	@ <retval>,
	b	.L449		@
.L461:
	.align	2
.L460:
	.word	GetUnit
	.size	GetFreeUnitByFaction, .-GetFreeUnitByFaction
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC207:
	.ascii	"Level\000"
	.align	2
.LC210:
	.ascii	"Exp\000"
	.align	2
.LC213:
	.ascii	"Bonus Con\000"
	.align	2
.LC216:
	.ascii	"Bonus Mov\000"
	.align	2
.LC219:
	.ascii	"Status\000"
	.align	2
.LC222:
	.ascii	"Allegiance\000"
	.align	2
.LC225:
	.ascii	"  Player\000"
	.align	2
.LC228:
	.ascii	"  NPC\000"
	.align	2
.LC230:
	.ascii	"  Enemy\000"
	.text
	.align	1
	.p2align 2,,3
	.global	RedrawMiscMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	RedrawMiscMenu, %function
RedrawMiscMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, r10	@,
	mov	r7, r9	@,
	mov	r6, r8	@,
@ Data/FE6_FE7.c:1438:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
@ Data/FE6_FE7.c:1435: {
	push	{r6, r7, lr}	@
@ Data/FE6_FE7.c:1438:     BG_Fill(gBG0TilemapBuffer, 0);
	ldr	r3, .L488	@ tmp152,
@ Data/FE6_FE7.c:1435: {
	movs	r5, r0	@ proc, tmp215
@ Data/FE6_FE7.c:1438:     BG_Fill(gBG0TilemapBuffer, 0);
	ldr	r0, .L488+4	@ tmp151,
	bl	.L17		@
@ Data/FE6_FE7.c:1439:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L488+8	@ tmp209,
	movs	r0, #1	@,
	mov	r8, r3	@ tmp209, tmp209
	bl	.L17		@
@ Data/FE6_FE7.c:1440:     ResetIconGraphics();
	ldr	r3, .L488+12	@ tmp154,
	bl	.L17		@
	ldr	r3, .L488+16	@ tmp210,
	mov	r10, r3	@ tmp210, tmp210
	movs	r6, r3	@ ivtmp.637, tmp210
	movs	r3, #72	@ _115,
	add	r3, r3, r10	@ _115, tmp210
	mov	r9, r3	@ _115, _115
	mov	r4, r10	@ ivtmp.648, tmp210
	ldr	r7, .L488+20	@ tmp213,
.L463:
@ Data/FE6_FE7.c:1447:         ClearText(&th[i]);
	movs	r0, r4	@, ivtmp.648
@ Data/FE6_FE7.c:1445:     for (i = 0; i <= NumberOfMisc; ++i)
	adds	r4, r4, #8	@ ivtmp.648,
@ Data/FE6_FE7.c:1447:         ClearText(&th[i]);
	bl	.L145		@
@ Data/FE6_FE7.c:1445:     for (i = 0; i <= NumberOfMisc; ++i)
	cmp	r4, r9	@ ivtmp.648, _115
	bne	.L463		@,
@ Data/FE6_FE7.c:1452:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(proc->tmp[0])->nameTextId));
	movs	r3, #64	@ tmp157,
@ Data/FE6_FE7.c:1452:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(proc->tmp[0])->nameTextId));
	ldrsh	r0, [r5, r3]	@ tmp158,
	ldr	r3, .L488+24	@ tmp159,
	bl	.L17		@
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	movs	r3, #128	@ tmp161,
@ Data/FE6_FE7.c:1452:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(proc->tmp[0])->nameTextId));
	ldrh	r0, [r0]	@ _7, *_6
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	subs	r2, r0, #1	@ tmp160, _7,
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	lsls	r3, r3, #7	@ tmp161, tmp161,
	cmp	r2, r3	@ tmp160, tmp161
	bcs	.LCB3165	@
	b	.L481	@long jump	@
.LCB3165:
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	ldr	r1, .L488+28	@ _77,
.L464:
@ Data/FE6_FE7.c:1452:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(proc->tmp[0])->nameTextId));
	mov	r0, r10	@, tmp210
	ldr	r7, .L488+32	@ tmp214,
	bl	.L145		@
@ Data/FE6_FE7.c:1454:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetClassData(proc->tmp[1])->nameTextId));
	movs	r3, #66	@ tmp165,
@ Data/FE6_FE7.c:1454:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetClassData(proc->tmp[1])->nameTextId));
	ldrsh	r0, [r5, r3]	@ tmp166,
	ldr	r3, .L488+36	@ tmp167,
	bl	.L17		@
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	movs	r3, #128	@ tmp169,
@ Data/FE6_FE7.c:1454:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetClassData(proc->tmp[1])->nameTextId));
	ldrh	r0, [r0]	@ _12, *_11
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	subs	r2, r0, #1	@ tmp168, _12,
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	lsls	r3, r3, #7	@ tmp169, tmp169,
	cmp	r2, r3	@ tmp168, tmp169
	bcc	.L482		@,
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	ldr	r1, .L488+28	@ _73,
.L465:
@ Data/FE6_FE7.c:1454:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetClassData(proc->tmp[1])->nameTextId));
	ldr	r4, .L488+40	@ tmp171,
	movs	r0, r4	@, tmp171
	bl	.L145		@
@ Data/FE6_FE7.c:1468:     Text_DrawString(&th[i], "Level");
	movs	r0, r4	@ tmp174, tmp171
	ldr	r1, .L488+44	@ tmp173,
	adds	r0, r0, #8	@ tmp174,
	bl	.L145		@
@ Data/FE6_FE7.c:1470:     Text_DrawString(&th[i], "Exp");
	movs	r0, r4	@ tmp177, tmp171
	ldr	r1, .L488+48	@ tmp176,
	adds	r0, r0, #16	@ tmp177,
	bl	.L145		@
@ Data/FE6_FE7.c:1472:     Text_DrawString(&th[i], "Bonus Con");
	movs	r0, r4	@ tmp180, tmp171
	ldr	r1, .L488+52	@ tmp179,
	adds	r0, r0, #24	@ tmp180,
	bl	.L145		@
@ Data/FE6_FE7.c:1474:     Text_DrawString(&th[i], "Bonus Mov");
	movs	r0, r4	@ tmp183, tmp171
	ldr	r1, .L488+56	@ tmp182,
	adds	r0, r0, #32	@ tmp183,
	bl	.L145		@
@ Data/FE6_FE7.c:1482:     Text_DrawString(&th[i], "Status");
	movs	r0, r4	@ tmp186, tmp171
	ldr	r1, .L488+60	@ tmp185,
	adds	r0, r0, #40	@ tmp186,
	bl	.L145		@
@ Data/FE6_FE7.c:1521:     Text_DrawString(&th[i], "Allegiance");
	movs	r0, r4	@ tmp189, tmp171
	ldr	r1, .L488+64	@ tmp188,
	adds	r0, r0, #48	@ tmp189,
	bl	.L145		@
@ Data/FE6_FE7.c:1526:     if (proc->tmp[7] == 0)
	movs	r3, #78	@ tmp191,
	ldrsh	r3, [r5, r3]	@ _14,
@ Data/FE6_FE7.c:1526:     if (proc->tmp[7] == 0)
	cmp	r3, #0	@ _14,
	beq	.L483		@,
@ Data/FE6_FE7.c:1531:     else if (proc->tmp[7] == 1)
	cmp	r3, #1	@ _14,
	beq	.L484		@,
@ Data/FE6_FE7.c:1535:     else if (proc->tmp[7] == 2)
	cmp	r3, #2	@ _14,
	beq	.L485		@,
.L467:
@ Data/FE6_FE7.c:1541:     PutText(&th[8], gBG0TilemapBuffer + TILEMAP_INDEX(START_X - 3, Y_HAND + (i * 2)));
	ldr	r3, .L488+68	@ tmp201,
	movs	r7, r3	@ tmp201, tmp201
	movs	r1, r3	@, tmp201
	ldr	r3, .L488+72	@ tmp211,
	ldr	r0, .L488+76	@ tmp202,
	mov	r9, r3	@ tmp211, tmp211
	bl	.L17		@
	ldr	r3, .L488+80	@ tmp252,
	adds	r4, r7, r3	@ ivtmp.639, tmp201, tmp252
	adds	r7, r7, #116	@ _109,
.L469:
@ Data/FE6_FE7.c:1545:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	movs	r1, r4	@, ivtmp.639
	movs	r0, r6	@, ivtmp.637
@ Data/FE6_FE7.c:1543:     for (i = 0; i < NumberOfMisc; ++i)
	adds	r4, r4, #128	@ ivtmp.639,
@ Data/FE6_FE7.c:1545:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	bl	.L139		@
@ Data/FE6_FE7.c:1543:     for (i = 0; i < NumberOfMisc; ++i)
	adds	r6, r6, #8	@ ivtmp.637,
	cmp	r4, r7	@ ivtmp.639, _109
	bne	.L469		@,
	movs	r4, #0	@ ivtmp.621,
	ldr	r6, .L488+84	@ ivtmp.628,
	ldr	r7, .L488+88	@ tmp212,
	adds	r5, r5, #64	@ ivtmp.626,
.L470:
@ Data/FE6_FE7.c:2748:     PutNumber(tm, color, number);
	movs	r1, #3	@,
	movs	r0, r6	@, ivtmp.628
@ Data/FE6_FE7.c:1557:                 gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	movs	r3, #0	@ tmp238,
	ldrsh	r2, [r5, r3]	@ pretmp_99, ivtmp.626, tmp238
@ Data/FE6_FE7.c:1554:         else if (i < 2)
	cmp	r4, #1	@ ivtmp.621,
	bls	.L486		@,
.L471:
@ Data/FE6_FE7.c:1550:         if (i == 7)
	adds	r4, r4, #1	@ ivtmp.621,
@ Data/FE6_FE7.c:1561:             PutNumber(
	bl	.L145		@
@ Data/FE6_FE7.c:1550:         if (i == 7)
	cmp	r4, #7	@ ivtmp.621,
	beq	.L487		@,
	adds	r6, r6, #128	@ ivtmp.628,
	adds	r5, r5, #2	@ ivtmp.626,
@ Data/FE6_FE7.c:2748:     PutNumber(tm, color, number);
	movs	r1, #3	@,
	movs	r0, r6	@, ivtmp.628
@ Data/FE6_FE7.c:1557:                 gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	movs	r3, #0	@ tmp238,
	ldrsh	r2, [r5, r3]	@ pretmp_99, ivtmp.626, tmp238
@ Data/FE6_FE7.c:1554:         else if (i < 2)
	cmp	r4, #1	@ ivtmp.621,
	bhi	.L471		@,
.L486:
@ Data/FE6_FE7.c:2748:     PutNumber(tm, color, number);
	bl	.L145		@
@ Data/FE6_FE7.c:1550:         if (i == 7)
	adds	r4, r4, #1	@ ivtmp.621,
	adds	r5, r5, #2	@ ivtmp.626,
	adds	r6, r6, #128	@ ivtmp.628,
	b	.L470		@
.L487:
@ Data/FE6_FE7.c:1572:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
@ Data/FE6_FE7.c:1573: }
	@ sp needed	@
@ Data/FE6_FE7.c:1572:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	bl	.L193		@
@ Data/FE6_FE7.c:1573: }
	pop	{r5, r6, r7}
	mov	r10, r7
	mov	r9, r6
	mov	r8, r5
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L482:
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	ldr	r3, .L488+92	@ tmp170,
	bl	.L17		@
	movs	r1, r0	@ _73, tmp219
	b	.L465		@
.L481:
	ldr	r3, .L488+92	@ tmp162,
	bl	.L17		@
	movs	r1, r0	@ _77, tmp217
	b	.L464		@
.L483:
@ Data/FE6_FE7.c:1529:         Text_DrawString(&th[8], "  Player");
	movs	r0, r4	@ tmp171, tmp171
	ldr	r1, .L488+96	@ tmp192,
	adds	r0, r0, #56	@ tmp171,
	bl	.L145		@
	b	.L467		@
.L485:
@ Data/FE6_FE7.c:1537:         Text_DrawString(&th[8], "  Enemy");
	movs	r0, r4	@ tmp171, tmp171
	ldr	r1, .L488+100	@ tmp198,
	adds	r0, r0, #56	@ tmp171,
	bl	.L145		@
	b	.L467		@
.L484:
@ Data/FE6_FE7.c:1533:         Text_DrawString(&th[8], "  NPC");
	movs	r0, r4	@ tmp171, tmp171
	ldr	r1, .L488+104	@ tmp195,
	adds	r0, r0, #56	@ tmp171,
	bl	.L145		@
	b	.L467		@
.L489:
	.align	2
.L488:
	.word	BG_Fill
	.word	gBG0TilemapBuffer
	.word	BG_EnableSyncByMask
	.word	ResetIconGraphics
	.word	gStatScreen+24
	.word	ClearText
	.word	GetCharacterData
	.word	BlankString
	.word	Text_DrawString
	.word	GetClassData
	.word	gStatScreen+32
	.word	.LC207
	.word	.LC210
	.word	.LC213
	.word	.LC216
	.word	.LC219
	.word	.LC222
	.word	gBG0TilemapBuffer+1056
	.word	PutText
	.word	gStatScreen+88
	.word	-908
	.word	gBG0TilemapBuffer+166
	.word	PutNumber
	.word	GetStringFromIndex
	.word	.LC225
	.word	.LC230
	.word	.LC228
	.size	RedrawMiscMenu, .-RedrawMiscMenu
	.align	1
	.p2align 2,,3
	.global	EditMiscInit
	.syntax unified
	.code	16
	.thumb_func
	.type	EditMiscInit, %function
EditMiscInit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	movs	r5, r0	@ proc, tmp217
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:385:     ResetTextFont();
	ldr	r6, .L493	@ tmp144,
	bl	.L38		@
@ Data/FE6_FE7.c:386:     SetTextFontGlyphs(0);
	ldr	r4, .L493+4	@ tmp145,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:389:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L493+8	@ tmp146,
	ldr	r3, .L493+12	@ tmp147,
	bl	.L17		@
@ Data/FE6_FE7.c:390:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L493+16	@ tmp148,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:391:     ResetTextFont();
	bl	.L38		@
@ Data/FE6_FE7.c:392:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:393:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L493+20	@ tmp151,
	bl	.L17		@
@ Data/FE6_FE7.c:394:     ClearBg0Bg1();
	ldr	r3, .L493+24	@ tmp152,
	bl	.L17		@
@ Data/FE6_FE7.c:395:     ResetText();
	ldr	r3, .L493+28	@ tmp153,
	bl	.L17		@
@ Data/FE6_FE7.c:1389:     LoadIconPalettes(4);
	movs	r0, #4	@,
	ldr	r3, .L493+32	@ tmp154,
	bl	.L17		@
@ Data/FE6_FE7.c:1393:         proc->tmp[i] = 0;
	movs	r0, r5	@ tmp155, proc
@ Data/FE6_FE7.c:1390:     struct Unit * unit = proc->unit;
	ldr	r4, [r5, #60]	@ unit, proc_32(D)->unit
@ Data/FE6_FE7.c:1393:         proc->tmp[i] = 0;
	movs	r2, #16	@,
	movs	r1, #0	@,
	ldr	r3, .L493+36	@ tmp158,
	adds	r0, r0, #64	@ tmp155,
	bl	.L17		@
@ Data/FE6_FE7.c:1395:     proc->tmp[0] = unit->pCharacterData->number;
	ldr	r3, [r4]	@ unit_35->pCharacterData, unit_35->pCharacterData
	ldrb	r2, [r3, #4]	@ tmp163,
@ Data/FE6_FE7.c:1395:     proc->tmp[0] = unit->pCharacterData->number;
	movs	r3, #64	@ tmp164,
	strh	r2, [r5, r3]	@ tmp163, proc_32(D)->tmp[0]
@ Data/FE6_FE7.c:1396:     proc->tmp[1] = unit->pClassData->number;
	ldr	r3, [r4, #4]	@ unit_35->pClassData, unit_35->pClassData
	ldrb	r2, [r3, #4]	@ tmp167,
@ Data/FE6_FE7.c:1396:     proc->tmp[1] = unit->pClassData->number;
	movs	r3, #66	@ tmp168,
	strh	r2, [r5, r3]	@ tmp167, proc_32(D)->tmp[1]
@ Data/FE6_FE7.c:1397:     proc->tmp[2] = unit->level;
	movs	r2, #8	@ tmp170,
	ldrsb	r2, [r4, r2]	@ tmp170,
@ Data/FE6_FE7.c:1397:     proc->tmp[2] = unit->level;
	adds	r3, r3, #2	@ tmp171,
	strh	r2, [r5, r3]	@ tmp170, proc_32(D)->tmp[2]
@ Data/FE6_FE7.c:1398:     proc->tmp[3] = unit->exp;
	ldrb	r2, [r4, #9]	@ tmp173,
@ Data/FE6_FE7.c:1398:     proc->tmp[3] = unit->exp;
	adds	r3, r3, #2	@ tmp174,
	strh	r2, [r5, r3]	@ tmp173, proc_32(D)->tmp[3]
@ Data/FE6_FE7.c:1399:     proc->tmp[4] = unit->conBonus;
	movs	r2, #26	@ tmp176,
	ldrsb	r2, [r4, r2]	@ tmp176,
@ Data/FE6_FE7.c:1399:     proc->tmp[4] = unit->conBonus;
	adds	r3, r3, #2	@ tmp177,
	strh	r2, [r5, r3]	@ tmp176, proc_32(D)->tmp[4]
@ Data/FE6_FE7.c:1400:     proc->tmp[5] = unit->movBonus;
	movs	r2, #29	@ tmp179,
	ldrsb	r2, [r4, r2]	@ tmp179,
@ Data/FE6_FE7.c:1400:     proc->tmp[5] = unit->movBonus;
	adds	r3, r3, #2	@ tmp180,
	strh	r2, [r5, r3]	@ tmp179, proc_32(D)->tmp[5]
@ Data/FE6_FE7.c:1401:     proc->tmp[6] = unit->statusIndex;
	movs	r2, #48	@ tmp183,
@ Data/FE6_FE7.c:1401:     proc->tmp[6] = unit->statusIndex;
	movs	r1, #76	@ tmp191,
@ Data/FE6_FE7.c:1401:     proc->tmp[6] = unit->statusIndex;
	ldrb	r3, [r4, r2]	@ *unit_35, *unit_35
	lsls	r3, r3, #28	@ tmp187, *unit_35,
	lsrs	r3, r3, #28	@ tmp189, tmp187,
@ Data/FE6_FE7.c:1401:     proc->tmp[6] = unit->statusIndex;
	strh	r3, [r5, r1]	@ tmp189, proc_32(D)->tmp[6]
@ Data/FE6_FE7.c:1402:     proc->tmp[8] = unit->statusDuration;
	ldrb	r3, [r4, r2]	@ *unit_35, *unit_35
@ Data/FE6_FE7.c:1402:     proc->tmp[8] = unit->statusDuration;
	adds	r2, r2, #32	@ tmp202,
@ Data/FE6_FE7.c:1402:     proc->tmp[8] = unit->statusDuration;
	lsrs	r3, r3, #4	@ tmp200, *unit_35,
@ Data/FE6_FE7.c:1402:     proc->tmp[8] = unit->statusDuration;
	strh	r3, [r5, r2]	@ tmp200, proc_32(D)->tmp[8]
@ Data/FE6_FE7.c:1403:     proc->tmp[7] = (unit->index & 0xC0) >> 6;
	ldrb	r3, [r4, #11]	@ tmp209,
@ Data/FE6_FE7.c:1403:     proc->tmp[7] = (unit->index & 0xC0) >> 6;
	subs	r2, r2, #2	@ tmp210,
@ Data/FE6_FE7.c:1403:     proc->tmp[7] = (unit->index & 0xC0) >> 6;
	lsrs	r3, r3, #6	@ tmp208, tmp209,
@ Data/FE6_FE7.c:1403:     proc->tmp[7] = (unit->index & 0xC0) >> 6;
	strh	r3, [r5, r2]	@ tmp208, proc_32(D)->tmp[7]
@ Data/FE6_FE7.c:76:     PutUiWindowFrame(x, y, width, height, style);
	movs	r3, #0	@ tmp212,
	ldr	r4, .L493+40	@ tmp213,
	str	r3, [sp]	@ tmp212,
	movs	r0, #9	@,
	adds	r3, r3, #18	@,
	subs	r2, r2, #66	@,
	subs	r1, r1, #75	@,
	bl	.L27		@
	ldr	r4, .L493+44	@ ivtmp.661,
	movs	r7, r4	@ _75, ivtmp.661
	ldr	r6, .L493+48	@ tmp216,
	adds	r7, r7, #72	@ _75,
.L491:
@ Data/FE6_FE7.c:1418:         InitText(&th[i], MiscNameWidth);
	movs	r0, r4	@, ivtmp.661
	movs	r1, #6	@,
@ Data/FE6_FE7.c:1416:     for (int i = 0; i <= NumberOfMisc; ++i)
	adds	r4, r4, #8	@ ivtmp.661,
@ Data/FE6_FE7.c:1418:         InitText(&th[i], MiscNameWidth);
	bl	.L38		@
@ Data/FE6_FE7.c:1416:     for (int i = 0; i <= NumberOfMisc; ++i)
	cmp	r7, r4	@ _75, ivtmp.661
	bne	.L491		@,
@ Data/FE6_FE7.c:1421:     RedrawMiscMenu(proc);
	movs	r0, r5	@, proc
	bl	RedrawMiscMenu		@
@ Data/FE6_FE7.c:1422: }
	add	sp, sp, #12	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L494:
	.align	2
.L493:
	.word	ResetTextFont
	.word	SetTextFontGlyphs
	.word	gBG0TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.word	SetTextFont
	.word	ClearBg0Bg1
	.word	ResetText
	.word	LoadIconPalettes
	.word	memset
	.word	PutUiWindowFrame
	.word	gStatScreen+24
	.word	InitText
	.size	EditMiscInit, .-EditMiscInit
	.align	1
	.p2align 2,,3
	.global	GetMiscMin
	.syntax unified
	.code	16
	.thumb_func
	.type	GetMiscMin, %function
GetMiscMin:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:1576: {
	movs	r3, r0	@ id, tmp123
@ Data/FE6_FE7.c:1623: }
	@ sp needed	@
@ Data/FE6_FE7.c:1578:     switch (id)
	movs	r2, #2	@ tmp121,
	movs	r0, #0	@ tmp122,
	cmp	r2, r3	@ tmp121, id
	adcs	r0, r0, r0	@ tmp120, tmp122, tmp122
@ Data/FE6_FE7.c:1623: }
	bx	lr
	.size	GetMiscMin, .-GetMiscMin
	.align	1
	.p2align 2,,3
	.global	GetMiscMax
	.syntax unified
	.code	16
	.thumb_func
	.type	GetMiscMax, %function
GetMiscMax:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:1707: {
	movs	r4, r0	@ id, tmp146
@ Data/FE6_FE7.c:1709:     switch (id)
	cmp	r0, #6	@ id,
	bhi	.L497		@,
	ldr	r2, .L516	@ tmp131,
	lsls	r3, r0, #2	@ tmp129, id,
	ldr	r3, [r2, r3]	@ tmp132,
	mov	pc, r3	@ tmp132
	.section	.rodata
	.align	2
.L499:
	.word	.L504
	.word	.L503
	.word	.L502
	.word	.L512
	.word	.L500
	.word	.L500
	.word	.L498
	.text
.L500:
@ Data/FE6_FE7.c:1733:             result = 15;
	movs	r0, #15	@ <retval>,
.L496:
@ Data/FE6_FE7.c:1758: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L498:
@ Data/FE6_FE7.c:1746:             result = 10;
	movs	r0, #10	@ <retval>,
@ Data/FE6_FE7.c:1748:             break;
	b	.L496		@
.L504:
@ Data/FE6_FE7.c:1681:     const struct CharacterData * table = GetCharacterData(1);
	movs	r0, #1	@,
	ldr	r5, .L516+4	@ tmp144,
	bl	.L28		@
@ Data/FE6_FE7.c:1683:     int i = 1;
	movs	r4, #1	@ i,
@ Data/FE6_FE7.c:1684:     for (; i <= c; i++)
	b	.L505		@
.L513:
@ Data/FE6_FE7.c:1684:     for (; i <= c; i++)
	adds	r4, r4, #1	@ i,
.L505:
@ Data/FE6_FE7.c:1686:         table = GetCharacterData(i);
	movs	r0, r4	@, i
	bl	.L28		@
@ Data/FE6_FE7.c:1687:         if (table->number != i)
	ldrb	r3, [r0, #4]	@ tmp137,
@ Data/FE6_FE7.c:1687:         if (table->number != i)
	cmp	r4, r3	@ i, tmp137
	beq	.L513		@,
.L510:
@ Data/FE6_FE7.c:1662:             i--;
	subs	r0, r4, #1	@ i, id,
@ Data/FE6_FE7.c:1666:     table = GetClassData(i);
	bl	.L28		@
@ Data/FE6_FE7.c:1667:     c = table->number;
	ldrb	r0, [r0, #4]	@ <retval>,
@ Data/FE6_FE7.c:1672:     if (c <= 1)
	cmp	r0, #1	@ <retval>,
	bgt	.L496		@,
@ Data/FE6_FE7.c:1701:         c = 0x49;
	movs	r0, #73	@ <retval>,
	b	.L496		@
.L503:
@ Data/FE6_FE7.c:1654:     const struct ClassData * table = GetClassData(1);
	ldr	r5, .L516+8	@ tmp145,
	movs	r0, #1	@,
	bl	.L28		@
@ Data/FE6_FE7.c:1657:     for (; i <= c; i++)
	b	.L509		@
.L514:
@ Data/FE6_FE7.c:1657:     for (; i <= c; i++)
	adds	r4, r4, #1	@ id,
.L509:
@ Data/FE6_FE7.c:1659:         table = GetClassData(i);
	movs	r0, r4	@, id
	bl	.L28		@
@ Data/FE6_FE7.c:1660:         if (table->number != i)
	ldrb	r3, [r0, #4]	@ tmp142,
@ Data/FE6_FE7.c:1660:         if (table->number != i)
	cmp	r4, r3	@ id, tmp142
	beq	.L514		@,
	b	.L510		@
.L502:
@ Data/FE6_FE7.c:1723:             result = 255;
	movs	r0, #255	@ <retval>,
	b	.L496		@
.L512:
@ Data/FE6_FE7.c:1709:     switch (id)
	movs	r0, #100	@ <retval>,
@ Data/FE6_FE7.c:1757:     return result;
	b	.L496		@
.L497:
@ Data/FE6_FE7.c:1753:             result = 2;
	movs	r0, #2	@ <retval>,
@ Data/FE6_FE7.c:1754:             break;
	b	.L496		@
.L517:
	.align	2
.L516:
	.word	.L499
	.word	GetCharacterData
	.word	GetClassData
	.size	GetMiscMax, .-GetMiscMax
	.align	1
	.p2align 2,,3
	.global	CountDebuggerMenuItems
	.syntax unified
	.code	16
	.thumb_func
	.type	CountDebuggerMenuItems, %function
CountDebuggerMenuItems:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	cmp	r0, #0	@ page,
	ble	.L518		@,
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	movs	r5, #0	@ i,
@ Data/FE6_FE7.c:1918:     int result = 0;
	movs	r2, #0	@ result,
	ldr	r6, .L530	@ ivtmp.697,
.L523:
	movs	r4, r2	@ _29, result
	ldr	r3, [r6]	@ ivtmp.694, MEM[(const struct MenuItemDef * *)_33]
	adds	r4, r4, #255	@ _29,
	b	.L522		@
.L529:
@ Data/FE6_FE7.c:1927:             result++;
	adds	r2, r2, #1	@ result,
@ Data/FE6_FE7.c:1921:         for (int c = 0; c < 255; ++c)
	adds	r3, r3, #36	@ ivtmp.694,
	cmp	r2, r4	@ result, _29
	beq	.L521		@,
.L522:
@ Data/FE6_FE7.c:1923:             if (!ggDebuggerMenuItems[i][c].name)
	ldr	r1, [r3]	@ MEM[(const char * *)_26], MEM[(const char * *)_26]
	cmp	r1, #0	@ MEM[(const char * *)_26],
	bne	.L529		@,
.L521:
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	adds	r5, r5, #1	@ i,
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	adds	r6, r6, #4	@ ivtmp.697,
	cmp	r0, r5	@ page, i
	bne	.L523		@,
@ Data/FE6_FE7.c:1930:     return result + page; // avoid the word 0 terminator offset
	adds	r0, r0, r2	@ <retval>, page, result
.L518:
@ Data/FE6_FE7.c:1931: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L531:
	.align	2
.L530:
	.word	ggDebuggerMenuItems
	.size	CountDebuggerMenuItems, .-CountDebuggerMenuItems
	.align	1
	.p2align 2,,3
	.global	GetDebuggerMenuText
	.syntax unified
	.code	16
	.thumb_func
	.type	GetDebuggerMenuText, %function
GetDebuggerMenuText:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:1936:     index += CountDebuggerMenuItems(procIdler->page);
	movs	r3, #52	@ tmp132,
@ Data/FE6_FE7.c:1934: {
	push	{r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:1936:     index += CountDebuggerMenuItems(procIdler->page);
	ldrb	r7, [r0, r3]	@ _43,
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	cmp	r7, #0	@ _43,
	beq	.L534		@,
@ Data/FE6_FE7.c:1918:     int result = 0;
	movs	r2, #0	@ result,
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	movs	r5, #0	@ i,
	ldr	r6, .L544	@ ivtmp.713,
.L537:
	movs	r4, r2	@ _32, result
	ldr	r3, [r6]	@ ivtmp.710, MEM[(const struct MenuItemDef * *)_21]
	adds	r4, r4, #255	@ _32,
	b	.L536		@
.L543:
@ Data/FE6_FE7.c:1927:             result++;
	adds	r2, r2, #1	@ result,
@ Data/FE6_FE7.c:1921:         for (int c = 0; c < 255; ++c)
	adds	r3, r3, #36	@ ivtmp.710,
	cmp	r2, r4	@ result, _32
	beq	.L535		@,
.L536:
@ Data/FE6_FE7.c:1923:             if (!ggDebuggerMenuItems[i][c].name)
	ldr	r0, [r3]	@ MEM[(const char * *)_35], MEM[(const char * *)_35]
	cmp	r0, #0	@ MEM[(const char * *)_35],
	bne	.L543		@,
.L535:
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	adds	r5, r5, #1	@ i,
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	adds	r6, r6, #4	@ ivtmp.713,
	cmp	r7, r5	@ _43, i
	bgt	.L537		@,
@ Data/FE6_FE7.c:1930:     return result + page; // avoid the word 0 terminator offset
	adds	r7, r7, r2	@ _43, _43, result
.L534:
@ Data/FE6_FE7.c:1937:     return gDebuggerMenuText[index * 2];
	adds	r1, r1, r7	@ tmp136, index, _43
@ Data/FE6_FE7.c:1937:     return gDebuggerMenuText[index * 2];
	ldr	r3, .L544+4	@ tmp135,
@ Data/FE6_FE7.c:1938: }
	@ sp needed	@
@ Data/FE6_FE7.c:1937:     return gDebuggerMenuText[index * 2];
	lsls	r1, r1, #3	@ tmp138, tmp136,
@ Data/FE6_FE7.c:1937:     return gDebuggerMenuText[index * 2];
	ldr	r0, [r1, r3]	@ gDebuggerMenuText[_3], gDebuggerMenuText[_3]
@ Data/FE6_FE7.c:1938: }
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L545:
	.align	2
.L544:
	.word	ggDebuggerMenuItems
	.word	gDebuggerMenuText
	.size	GetDebuggerMenuText, .-GetDebuggerMenuText
	.align	1
	.p2align 2,,3
	.global	FixCursorOverflow
	.syntax unified
	.code	16
	.thumb_func
	.type	FixCursorOverflow, %function
FixCursorOverflow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, lr}	@
@ Data/FE6_FE7.c:1941:     int x = gBmSt.playerCursor.x;
	ldr	r3, .L551	@ tmp162,
	movs	r2, #20	@ tmp165,
	ldrsh	r4, [r3, r2]	@ _1, tmp162, tmp165
@ Data/FE6_FE7.c:1942:     int y = gBmSt.playerCursor.y;
	movs	r2, #22	@ tmp166,
	ldrsh	r1, [r3, r2]	@ _2, tmp162, tmp166
@ Data/FE6_FE7.c:1943:     if (x < 0)
	cmp	r4, #0	@ _1,
	bge	.L547		@,
@ Data/FE6_FE7.c:1945:         gBmSt.playerCursor.x = 0;
	movs	r2, #0	@ tmp133,
@ Data/FE6_FE7.c:1946:         gActiveUnitMoveOrigin.x = 0;
	ldr	r0, .L551+4	@ tmp135,
@ Data/FE6_FE7.c:1945:         gBmSt.playerCursor.x = 0;
	strh	r2, [r3, #20]	@ tmp133, gBmSt.playerCursor.x
@ Data/FE6_FE7.c:1946:         gActiveUnitMoveOrigin.x = 0;
	strh	r2, [r0]	@ tmp133, gActiveUnitMoveOrigin.x
.L547:
@ Data/FE6_FE7.c:1948:     if (y < 0)
	cmp	r1, #0	@ _2,
	bge	.L548		@,
@ Data/FE6_FE7.c:1950:         gBmSt.playerCursor.y = 0;
	movs	r2, #0	@ tmp141,
@ Data/FE6_FE7.c:1951:         gActiveUnitMoveOrigin.y = 0;
	ldr	r0, .L551+4	@ tmp143,
@ Data/FE6_FE7.c:1950:         gBmSt.playerCursor.y = 0;
	strh	r2, [r3, #22]	@ tmp141, gBmSt.playerCursor.y
@ Data/FE6_FE7.c:1951:         gActiveUnitMoveOrigin.y = 0;
	strh	r2, [r0, #2]	@ tmp141, gActiveUnitMoveOrigin.y
.L548:
@ Data/FE6_FE7.c:1953:     if (x >= gBmMapSize.x)
	ldr	r0, .L551+8	@ tmp163,
	movs	r5, #0	@ tmp167,
	ldrsh	r2, [r0, r5]	@ _3, tmp163, tmp167
@ Data/FE6_FE7.c:1953:     if (x >= gBmMapSize.x)
	cmp	r4, r2	@ _1, _3
	blt	.L549		@,
@ Data/FE6_FE7.c:1955:         x = gBmMapSize.x - 1;
	subs	r2, r2, #1	@ x,
@ Data/FE6_FE7.c:1957:         gActiveUnitMoveOrigin.x = x;
	ldr	r5, .L551+4	@ tmp149,
@ Data/FE6_FE7.c:1956:         gBmSt.playerCursor.x = x;
	lsls	r4, r2, #16	@ _5, x,
	asrs	r4, r4, #16	@ _5, _5,
	strh	r4, [r3, #20]	@ _5, gBmSt.playerCursor.x
@ Data/FE6_FE7.c:1957:         gActiveUnitMoveOrigin.x = x;
	strh	r4, [r5]	@ _5, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:1958:         gActiveUnit->xPos = x;
	ldr	r4, .L551+12	@ tmp152,
	ldr	r4, [r4]	@ gActiveUnit, gActiveUnit
	strb	r2, [r4, #16]	@ x, gActiveUnit.45_6->xPos
.L549:
@ Data/FE6_FE7.c:1960:     if (y >= gBmMapSize.y)
	movs	r2, #2	@ _8,
	ldrsh	r2, [r0, r2]	@ _8, tmp163, _8
@ Data/FE6_FE7.c:1960:     if (y >= gBmMapSize.y)
	cmp	r1, r2	@ _2, _8
	blt	.L546		@,
@ Data/FE6_FE7.c:1962:         y = gBmMapSize.y - 1;
	subs	r2, r2, #1	@ y,
@ Data/FE6_FE7.c:1963:         gBmSt.playerCursor.y = y;
	lsls	r1, r2, #16	@ _10, y,
	asrs	r1, r1, #16	@ _10, _10,
	strh	r1, [r3, #22]	@ _10, gBmSt.playerCursor.y
@ Data/FE6_FE7.c:1964:         gActiveUnitMoveOrigin.x = y;
	ldr	r3, .L551+4	@ tmp157,
	strh	r1, [r3]	@ _10, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:1965:         gActiveUnit->yPos = y;
	ldr	r3, .L551+12	@ tmp160,
	ldr	r3, [r3]	@ gActiveUnit, gActiveUnit
	strb	r2, [r3, #17]	@ y, gActiveUnit.46_11->yPos
.L546:
@ Data/FE6_FE7.c:1967: }
	@ sp needed	@
	pop	{r4, r5}
	pop	{r0}
	bx	r0
.L552:
	.align	2
.L551:
	.word	gBmSt
	.word	gActiveUnitMoveOrigin
	.word	gBmMapSize
	.word	gActiveUnit
	.size	FixCursorOverflow, .-FixCursorOverflow
	.align	1
	.p2align 2,,3
	.global	PickupUnitIdle
	.syntax unified
	.code	16
	.thumb_func
	.type	PickupUnitIdle, %function
PickupUnitIdle:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:2020: {
	movs	r4, r0	@ proc, tmp202
@ Data/FE6_FE7.c:2007:     FixCursorOverflow();
	bl	FixCursorOverflow		@
@ Data/FE6_FE7.c:2008:     HandlePlayerCursorMovement();
	ldr	r3, .L562	@ tmp143,
	bl	.L17		@
@ Data/FE6_FE7.c:2022:     u16 keys = gKeyStatusPtr->newKeys;
	ldr	r3, .L562+4	@ tmp145,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r3, [r3, #8]	@ keys,
@ Data/FE6_FE7.c:2023:     if (keys & A_BUTTON)
	lsls	r2, r3, #31	@ tmp204, keys,
	bmi	.L560		@,
@ Data/FE6_FE7.c:2035:     if (keys & B_BUTTON)
	movs	r5, #2	@ tmp172,
	tst	r5, r3	@ tmp172, keys
	bne	.L561		@,
@ Data/FE6_FE7.c:2045:         gBmSt.playerCursorDisplay.x, gBmSt.playerCursorDisplay.y,
	ldr	r3, .L562+8	@ tmp188,
@ Data/FE6_FE7.c:2044:     PutMapCursor(
	movs	r2, #32	@ tmp210,
	ldrsh	r4, [r3, r2]	@ _11, tmp188, tmp210
	movs	r2, #34	@ tmp211,
	ldrsh	r6, [r3, r2]	@ _13, tmp188, tmp211
@ Data/FE6_FE7.c:2046:         IsUnitSpriteHoverEnabledAt(gBmSt.playerCursor.x, gBmSt.playerCursor.y) ? 3 : 0);
	movs	r2, #22	@ tmp212,
	ldrsh	r1, [r3, r2]	@ tmp191, tmp188, tmp212
	movs	r0, #20	@ tmp193,
	ldrsh	r0, [r3, r0]	@ tmp193, tmp188, tmp193
	ldr	r3, .L562+12	@ tmp194,
	bl	.L17		@
@ Data/FE6_FE7.c:2044:     PutMapCursor(
	rsbs	r3, r0, #0	@ tmp199, tmp203
	adcs	r0, r0, r3	@ tmp198, tmp203, tmp199
	rsbs	r2, r0, #0	@ tmp200, tmp198
	bics	r2, r5	@ iftmp.51_19, tmp172
@ Data/FE6_FE7.c:2044:     PutMapCursor(
	movs	r1, r6	@, _13
	movs	r0, r4	@, _11
	ldr	r3, .L562+16	@ tmp197,
@ Data/FE6_FE7.c:2044:     PutMapCursor(
	adds	r2, r2, #3	@ iftmp.51_19,
@ Data/FE6_FE7.c:2044:     PutMapCursor(
	bl	.L17		@
.L553:
@ Data/FE6_FE7.c:2047: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L561:
@ Data/FE6_FE7.c:2037:         gActionData.xMove = gActiveUnitMoveOrigin.x;
	ldr	r3, .L562+20	@ tmp176,
	movs	r1, #0	@ tmp208,
	ldrsh	r2, [r3, r1]	@ _6, tmp176, tmp208
@ Data/FE6_FE7.c:2037:         gActionData.xMove = gActiveUnitMoveOrigin.x;
	ldr	r1, .L562+24	@ tmp177,
	strb	r2, [r1, #14]	@ _6, gActionData.xMove
@ Data/FE6_FE7.c:2038:         gActionData.yMove = gActiveUnitMoveOrigin.y;
	movs	r0, #2	@ tmp209,
	ldrsh	r3, [r3, r0]	@ _8, tmp176, tmp209
@ Data/FE6_FE7.c:2038:         gActionData.yMove = gActiveUnitMoveOrigin.y;
	strb	r3, [r1, #15]	@ _8, gActionData.yMove
.L559:
@ Data/FE6_FE7.c:2013:     gActiveUnit->xPos = gActionData.xMove;
	ldr	r1, .L562+28	@ tmp182,
	ldr	r0, [r1]	@ gActiveUnit.47_46, gActiveUnit
@ Data/FE6_FE7.c:2013:     gActiveUnit->xPos = gActionData.xMove;
	strb	r2, [r0, #16]	@ _6,
@ Data/FE6_FE7.c:2014:     gActiveUnit->yPos = gActionData.yMove;
	strb	r3, [r0, #17]	@ _8,
@ Data/FE6_FE7.c:2015:     UnitFinalizeMovement(gActiveUnit);
	ldr	r3, .L562+32	@ tmp185,
	bl	.L17		@
@ Data/FE6_FE7.c:2016:     ResetTextFont();
	ldr	r3, .L562+36	@ tmp186,
	bl	.L17		@
@ Data/FE6_FE7.c:2041:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L562+40	@ tmp187,
	bl	.L17		@
@ Data/FE6_FE7.c:2042:         return;
	b	.L553		@
.L560:
@ Data/FE6_FE7.c:2025:         gActionData.xMove = gBmSt.playerCursor.x;
	ldr	r3, .L562+8	@ tmp153,
	movs	r1, #20	@ tmp206,
	ldrsh	r2, [r3, r1]	@ _2, tmp153, tmp206
@ Data/FE6_FE7.c:2025:         gActionData.xMove = gBmSt.playerCursor.x;
	ldr	r1, .L562+24	@ tmp154,
	strb	r2, [r1, #14]	@ _2, gActionData.xMove
@ Data/FE6_FE7.c:2026:         gActionData.yMove = gBmSt.playerCursor.y;
	movs	r0, #22	@ tmp207,
	ldrsh	r3, [r3, r0]	@ _4, tmp153, tmp207
@ Data/FE6_FE7.c:2026:         gActionData.yMove = gBmSt.playerCursor.y;
	strb	r3, [r1, #15]	@ _4, gActionData.yMove
@ Data/FE6_FE7.c:2027:         gActiveUnitMoveOrigin.x = gBmSt.playerCursor.x;
	ldr	r1, .L562+20	@ tmp159,
	strh	r2, [r1]	@ _2, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:2028:         gActiveUnitMoveOrigin.y = gBmSt.playerCursor.y;
	strh	r3, [r1, #2]	@ _4, gActiveUnitMoveOrigin.y
	b	.L559		@
.L563:
	.align	2
.L562:
	.word	HandlePlayerCursorMovement
	.word	gKeyStatusPtr
	.word	gBmSt
	.word	IsUnitSpriteHoverEnabledAt
	.word	PutMapCursor
	.word	gActiveUnitMoveOrigin
	.word	gActionData
	.word	gActiveUnit
	.word	UnitFinalizeMovement
	.word	ResetTextFont
	.word	Proc_Goto
	.size	PickupUnitIdle, .-PickupUnitIdle
	.align	1
	.p2align 2,,3
	.global	IsCoordinateValid
	.syntax unified
	.code	16
	.thumb_func
	.type	IsCoordinateValid, %function
IsCoordinateValid:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:1974:     if (y < 0)
	movs	r2, r0	@ tmp123, x
@ Data/FE6_FE7.c:1969: {
	movs	r3, r0	@ x, tmp141
	push	{r4, r5, lr}	@
@ Data/FE6_FE7.c:1972:         return false;
	movs	r0, #0	@ <retval>,
@ Data/FE6_FE7.c:1974:     if (y < 0)
	orrs	r2, r1	@ tmp123, y
	bmi	.L564		@,
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	ldr	r2, .L570	@ tmp124,
	movs	r5, #0	@ tmp149,
	ldrsh	r4, [r2, r5]	@ gBmMapSize, tmp124, tmp149
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	cmp	r3, r4	@ x, gBmMapSize
	bge	.L564		@,
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	movs	r3, #2	@ tmp127,
	ldrsh	r3, [r2, r3]	@ tmp127, tmp124, tmp127
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	adds	r0, r0, #1	@ tmp128,
	cmp	r1, r3	@ y, tmp127
	bge	.L569		@,
.L564:
@ Data/FE6_FE7.c:1987: }
	@ sp needed	@
	pop	{r4, r5}
	pop	{r1}
	bx	r1
.L569:
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	movs	r0, #0	@ tmp128,
	b	.L564		@
.L571:
	.align	2
.L570:
	.word	gBmMapSize
	.size	IsCoordinateValid, .-IsCoordinateValid
	.align	1
	.p2align 2,,3
	.global	EnsureCameraOntoPositionIfValid
	.syntax unified
	.code	16
	.thumb_func
	.type	EnsureCameraOntoPositionIfValid, %function
EnsureCameraOntoPositionIfValid:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:1974:     if (y < 0)
	movs	r4, r1	@ tmp123, x
@ Data/FE6_FE7.c:1992:         return 0;
	movs	r3, #0	@ <retval>,
@ Data/FE6_FE7.c:1974:     if (y < 0)
	orrs	r4, r2	@ tmp123, y
	bmi	.L573		@,
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	ldr	r4, .L577	@ tmp124,
	movs	r6, #0	@ tmp137,
	ldrsh	r5, [r4, r6]	@ gBmMapSize, tmp124, tmp137
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	cmp	r1, r5	@ x, gBmMapSize
	bge	.L573		@,
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	movs	r5, #2	@ tmp138,
	ldrsh	r4, [r4, r5]	@ tmp127, tmp124, tmp138
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	cmp	r2, r4	@ y, tmp127
	bge	.L573		@,
@ Data/FE6_FE7.c:1994:     return EnsureCameraOntoPosition(proc, x, y);
	ldr	r3, .L577+4	@ tmp128,
	bl	.L17		@
	movs	r3, r0	@ <retval>, tmp135
.L573:
@ Data/FE6_FE7.c:1995: }
	@ sp needed	@
	movs	r0, r3	@, <retval>
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L578:
	.align	2
.L577:
	.word	gBmMapSize
	.word	EnsureCameraOntoPosition
	.size	EnsureCameraOntoPositionIfValid, .-EnsureCameraOntoPositionIfValid
	.align	1
	.p2align 2,,3
	.global	SetCursorMapPositionIfValid
	.syntax unified
	.code	16
	.thumb_func
	.type	SetCursorMapPositionIfValid, %function
SetCursorMapPositionIfValid:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:1974:     if (y < 0)
	movs	r3, r0	@ tmp121, x
@ Data/FE6_FE7.c:1997: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:1974:     if (y < 0)
	orrs	r3, r1	@ tmp121, y
	bmi	.L579		@,
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	ldr	r3, .L581	@ tmp122,
	movs	r4, #0	@ tmp130,
	ldrsh	r2, [r3, r4]	@ gBmMapSize, tmp122, tmp130
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	cmp	r0, r2	@ x, gBmMapSize
	bge	.L579		@,
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	movs	r2, #2	@ tmp131,
	ldrsh	r3, [r3, r2]	@ tmp125, tmp122, tmp131
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	cmp	r1, r3	@ y, tmp125
	bge	.L579		@,
@ Data/FE6_FE7.c:2002:     SetCursorMapPosition(x, y);
	ldr	r3, .L581+4	@ tmp126,
	bl	.L17		@
.L579:
@ Data/FE6_FE7.c:2003: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
.L582:
	.align	2
.L581:
	.word	gBmMapSize
	.word	SetCursorMapPosition
	.size	SetCursorMapPositionIfValid, .-SetCursorMapPositionIfValid
	.align	1
	.p2align 2,,3
	.global	FixAndHandlePlayerCursorMovement
	.syntax unified
	.code	16
	.thumb_func
	.type	FixAndHandlePlayerCursorMovement, %function
FixAndHandlePlayerCursorMovement:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2007:     FixCursorOverflow();
	bl	FixCursorOverflow		@
@ Data/FE6_FE7.c:2009: }
	@ sp needed	@
@ Data/FE6_FE7.c:2008:     HandlePlayerCursorMovement();
	ldr	r3, .L584	@ tmp114,
	bl	.L17		@
@ Data/FE6_FE7.c:2009: }
	pop	{r4}
	pop	{r0}
	bx	r0
.L585:
	.align	2
.L584:
	.word	HandlePlayerCursorMovement
	.size	FixAndHandlePlayerCursorMovement, .-FixAndHandlePlayerCursorMovement
	.align	1
	.p2align 2,,3
	.global	PickupUnitNow
	.syntax unified
	.code	16
	.thumb_func
	.type	PickupUnitNow, %function
PickupUnitNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2053:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L587	@ tmp119,
@ Data/FE6_FE7.c:2056: }
	@ sp needed	@
@ Data/FE6_FE7.c:2053:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L587+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2054:     Proc_Goto(proc, PickupUnitLabel);
	movs	r1, #4	@,
	ldr	r3, .L587+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2056: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L588:
	.align	2
.L587:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	PickupUnitNow, .-PickupUnitNow
	.align	1
	.p2align 2,,3
	.global	StartPromotionNow
	.syntax unified
	.code	16
	.thumb_func
	.type	StartPromotionNow, %function
StartPromotionNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:2924:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r3, .L594	@ tmp131,
	movs	r1, #11	@ tmp132,
	ldr	r2, [r3]	@ gActiveUnit.86_9, gActiveUnit
	movs	r3, #192	@ tmp133,
@ Data/FE6_FE7.c:2058: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2924:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldrsb	r1, [r2, r1]	@ tmp132,
	ands	r3, r1	@ tmp134, tmp132
@ Data/FE6_FE7.c:2924:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r1, .L594+4	@ tmp135,
	ldrb	r1, [r1, #15]	@ tmp136,
@ Data/FE6_FE7.c:2924:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	cmp	r3, r1	@ tmp134, tmp136
	bne	.L593		@,
@ Data/FE6_FE7.c:2929:     int promoted = UNIT_CATTRIBUTES(gActiveUnit) & CA_PROMOTED;
	ldr	r3, [r2]	@ gActiveUnit.86_9->pCharacterData, gActiveUnit.86_9->pCharacterData
	ldr	r1, [r2, #4]	@ _17, gActiveUnit.86_9->pClassData
	ldr	r3, [r3, #40]	@ _15->attributes, _15->attributes
	ldr	r2, [r1, #40]	@ _17->attributes, _17->attributes
	orrs	r3, r2	@ tmp138, _17->attributes
@ Data/FE6_FE7.c:2930:     if (promoted)
	lsls	r3, r3, #23	@ tmp152, tmp138,
	bmi	.L593		@,
@ Data/FE6_FE7.c:2935:     if (!promotionClass)
	ldrb	r3, [r1, #5]	@ tmp143,
	cmp	r3, #0	@ tmp143,
	beq	.L593		@,
@ Data/FE6_FE7.c:2065:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L594+8	@ tmp145,
	ldr	r0, .L594+12	@ tmp144,
	bl	.L17		@
@ Data/FE6_FE7.c:2066:     proc->actionID = ActionID_Promo;
	movs	r3, #47	@ tmp146,
	movs	r2, #1	@ tmp147,
@ Data/FE6_FE7.c:2067:     Proc_Goto(proc, UnitActionLabel);
	movs	r1, #3	@,
@ Data/FE6_FE7.c:2066:     proc->actionID = ActionID_Promo;
	strb	r2, [r0, r3]	@ tmp147, proc_6->actionID
@ Data/FE6_FE7.c:2067:     Proc_Goto(proc, UnitActionLabel);
	ldr	r3, .L594+16	@ tmp149,
	bl	.L17		@
@ Data/FE6_FE7.c:2068:     return MENU_ACT_SKIPCURSOR | MENU_ACT_END | MENU_ACT_SND6A | MENU_ACT_CLEAR;
	movs	r0, #23	@ <retval>,
	b	.L590		@
.L593:
@ Data/FE6_FE7.c:2062:         return MENU_ACT_SKIPCURSOR | MENU_ACT_SND6B;
	movs	r0, #9	@ <retval>,
.L590:
@ Data/FE6_FE7.c:2069: }
	@ sp needed	@
	pop	{r4}
	pop	{r1}
	bx	r1
.L595:
	.align	2
.L594:
	.word	gActiveUnit
	.word	gPlaySt
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	StartPromotionNow, .-StartPromotionNow
	.align	1
	.p2align 2,,3
	.global	StartArenaNow
	.syntax unified
	.code	16
	.thumb_func
	.type	StartArenaNow, %function
StartArenaNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2074:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L597	@ tmp119,
@ Data/FE6_FE7.c:2078: }
	@ sp needed	@
@ Data/FE6_FE7.c:2074:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L597+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2075:     proc->actionID = ActionID_Arena;
	movs	r3, #47	@ tmp120,
	movs	r2, #2	@ tmp121,
@ Data/FE6_FE7.c:2076:     Proc_Goto(proc, UnitActionLabel); // 0xb7
	movs	r1, #3	@,
@ Data/FE6_FE7.c:2075:     proc->actionID = ActionID_Arena;
	strb	r2, [r0, r3]	@ tmp121, proc_3->actionID
@ Data/FE6_FE7.c:2076:     Proc_Goto(proc, UnitActionLabel); // 0xb7
	ldr	r3, .L597+8	@ tmp123,
	bl	.L17		@
@ Data/FE6_FE7.c:2078: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L598:
	.align	2
.L597:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	StartArenaNow, .-StartArenaNow
	.align	1
	.p2align 2,,3
	.global	SupplyNow
	.syntax unified
	.code	16
	.thumb_func
	.type	SupplyNow, %function
SupplyNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2085:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L600	@ tmp120,
@ Data/FE6_FE7.c:2089: }
	@ sp needed	@
@ Data/FE6_FE7.c:2085:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L600+4	@ tmp119,
	bl	.L17		@
@ Data/FE6_FE7.c:2086:     Proc_Goto(proc, EndLabel);
	movs	r1, #99	@,
	ldr	r3, .L600+8	@ tmp121,
	bl	.L17		@
@ Data/FE6_FE7.c:2087:     StartBmSupply(gActiveUnit, NULL);
	ldr	r3, .L600+12	@ tmp122,
	movs	r1, #0	@,
	ldr	r0, [r3]	@ gActiveUnit, gActiveUnit
	ldr	r3, .L600+16	@ tmp124,
	bl	.L17		@
@ Data/FE6_FE7.c:2089: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L601:
	.align	2
.L600:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.word	gActiveUnit
	.word	StartBmSupply
	.size	SupplyNow, .-SupplyNow
	.align	1
	.p2align 2,,3
	.global	LevelupNow
	.syntax unified
	.code	16
	.thumb_func
	.type	LevelupNow, %function
LevelupNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2094:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L603	@ tmp119,
@ Data/FE6_FE7.c:2098: }
	@ sp needed	@
@ Data/FE6_FE7.c:2094:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L603+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2095:     proc->actionID = ActionID_Levelup;
	movs	r3, #47	@ tmp120,
	movs	r2, #3	@ tmp121,
@ Data/FE6_FE7.c:2096:     Proc_Goto(proc, UnitActionLabel); // 0xb7
	movs	r1, #3	@,
@ Data/FE6_FE7.c:2095:     proc->actionID = ActionID_Levelup;
	strb	r2, [r0, r3]	@ tmp121, proc_3->actionID
@ Data/FE6_FE7.c:2096:     Proc_Goto(proc, UnitActionLabel); // 0xb7
	ldr	r3, .L603+8	@ tmp123,
	bl	.L17		@
@ Data/FE6_FE7.c:2098: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L604:
	.align	2
.L603:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	LevelupNow, .-LevelupNow
	.align	1
	.p2align 2,,3
	.global	EditStatsNow
	.syntax unified
	.code	16
	.thumb_func
	.type	EditStatsNow, %function
EditStatsNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2102:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L606	@ tmp119,
@ Data/FE6_FE7.c:2105: }
	@ sp needed	@
@ Data/FE6_FE7.c:2102:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L606+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2103:     Proc_Goto(proc, EditStatsLabel);
	movs	r1, #9	@,
	ldr	r3, .L606+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2105: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L607:
	.align	2
.L606:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	EditStatsNow, .-EditStatsNow
	.align	1
	.p2align 2,,3
	.global	EditItemsNow
	.syntax unified
	.code	16
	.thumb_func
	.type	EditItemsNow, %function
EditItemsNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2109:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L609	@ tmp119,
@ Data/FE6_FE7.c:2112: }
	@ sp needed	@
@ Data/FE6_FE7.c:2109:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L609+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2110:     Proc_Goto(proc, EditItemsLabel);
	movs	r1, #10	@,
	ldr	r3, .L609+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2112: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L610:
	.align	2
.L609:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	EditItemsNow, .-EditItemsNow
	.align	1
	.p2align 2,,3
	.global	EditMiscNow
	.syntax unified
	.code	16
	.thumb_func
	.type	EditMiscNow, %function
EditMiscNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2116:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L612	@ tmp119,
@ Data/FE6_FE7.c:2119: }
	@ sp needed	@
@ Data/FE6_FE7.c:2116:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L612+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2117:     Proc_Goto(proc, EditMiscLabel);
	movs	r1, #11	@,
	ldr	r3, .L612+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2119: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L613:
	.align	2
.L612:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	EditMiscNow, .-EditMiscNow
	.align	1
	.p2align 2,,3
	.global	EditStateNow
	.syntax unified
	.code	16
	.thumb_func
	.type	EditStateNow, %function
EditStateNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2123:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L615	@ tmp119,
@ Data/FE6_FE7.c:2126: }
	@ sp needed	@
@ Data/FE6_FE7.c:2123:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L615+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2124:     Proc_Goto(proc, StateLabel);
	movs	r1, #14	@,
	ldr	r3, .L615+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2126: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L616:
	.align	2
.L615:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	EditStateNow, .-EditStateNow
	.align	1
	.p2align 2,,3
	.global	DebuggerMenuItemDraw
	.syntax unified
	.code	16
	.thumb_func
	.type	DebuggerMenuItemDraw, %function
DebuggerMenuItemDraw:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r2, #52	@ _3,
	push	{r3, r4, r5, r6, r7, lr}	@
	mov	lr, r9	@,
	mov	r7, r8	@,
@ Data/FE6_FE7.c:2130:     if (menuItem->availability == greyed)
	movs	r3, #61	@ tmp148,
	mov	r9, r2	@ _3, _3
@ Data/FE6_FE7.c:2129: {
	push	{r7, lr}	@
@ Data/FE6_FE7.c:2130:     if (menuItem->availability == greyed)
	ldrb	r3, [r1, r3]	@ tmp149,
@ Data/FE6_FE7.c:2129: {
	movs	r6, r1	@ menuItem, tmp174
	add	r9, r9, r1	@ _3, menuItem
@ Data/FE6_FE7.c:2130:     if (menuItem->availability == greyed)
	cmp	r3, #2	@ tmp149,
	beq	.L630		@,
.L618:
@ Data/FE6_FE7.c:2134:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	ldr	r3, .L632	@ tmp154,
	ldr	r0, .L632+4	@ tmp153,
	bl	.L17		@
@ Data/FE6_FE7.c:2136:     Text_DrawString(&menuItem->text, GetDebuggerMenuText(procIdler, menuItem->itemNumber));
	movs	r3, #60	@ tmp155,
@ Data/FE6_FE7.c:2136:     Text_DrawString(&menuItem->text, GetDebuggerMenuText(procIdler, menuItem->itemNumber));
	ldrsb	r3, [r6, r3]	@ _5,
	mov	r8, r3	@ _5, _5
@ Data/FE6_FE7.c:1936:     index += CountDebuggerMenuItems(procIdler->page);
	movs	r3, #52	@ tmp156,
@ Data/FE6_FE7.c:1936:     index += CountDebuggerMenuItems(procIdler->page);
	ldrb	r7, [r0, r3]	@ _62,
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	cmp	r7, #0	@ _62,
	beq	.L620		@,
@ Data/FE6_FE7.c:1918:     int result = 0;
	movs	r2, #0	@ result,
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	movs	r4, #0	@ i,
	ldr	r5, .L632+8	@ ivtmp.774,
.L623:
	movs	r1, r2	@ _51, result
	ldr	r3, [r5]	@ ivtmp.771, MEM[(const struct MenuItemDef * *)_41]
	adds	r1, r1, #255	@ _51,
	b	.L622		@
.L631:
@ Data/FE6_FE7.c:1927:             result++;
	adds	r2, r2, #1	@ result,
@ Data/FE6_FE7.c:1921:         for (int c = 0; c < 255; ++c)
	adds	r3, r3, #36	@ ivtmp.771,
	cmp	r2, r1	@ result, _51
	beq	.L621		@,
.L622:
@ Data/FE6_FE7.c:1923:             if (!ggDebuggerMenuItems[i][c].name)
	ldr	r0, [r3]	@ MEM[(const char * *)_54], MEM[(const char * *)_54]
	cmp	r0, #0	@ MEM[(const char * *)_54],
	bne	.L631		@,
.L621:
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	adds	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:1919:     for (int i = 0; i < page; ++i)
	adds	r5, r5, #4	@ ivtmp.774,
	cmp	r7, r4	@ _62, i
	bgt	.L623		@,
@ Data/FE6_FE7.c:1930:     return result + page; // avoid the word 0 terminator offset
	adds	r7, r7, r2	@ _62, _62, result
.L620:
@ Data/FE6_FE7.c:1937:     return gDebuggerMenuText[index * 2];
	movs	r3, r7	@ _62, _62
@ Data/FE6_FE7.c:2139: }
	@ sp needed	@
@ Data/FE6_FE7.c:1937:     return gDebuggerMenuText[index * 2];
	ldr	r2, .L632+12	@ tmp158,
@ Data/FE6_FE7.c:1937:     return gDebuggerMenuText[index * 2];
	add	r3, r3, r8	@ _62, _5
@ Data/FE6_FE7.c:1937:     return gDebuggerMenuText[index * 2];
	lsls	r3, r3, #3	@ tmp161, tmp159,
@ Data/FE6_FE7.c:2136:     Text_DrawString(&menuItem->text, GetDebuggerMenuText(procIdler, menuItem->itemNumber));
	ldr	r1, [r3, r2]	@ gDebuggerMenuText[_28], gDebuggerMenuText[_28]
	mov	r0, r9	@, _3
	ldr	r3, .L632+16	@ tmp163,
	bl	.L17		@
@ Data/FE6_FE7.c:2137:     PutText(&menuItem->text, BG_GetMapBuffer_New(0) + TILEMAP_INDEX(menuItem->xTile, menuItem->yTile));
	movs	r3, #44	@ tmp178,
	ldrsh	r1, [r6, r3]	@ tmp164, menuItem, tmp178
	movs	r2, #42	@ tmp179,
	ldrsh	r3, [r6, r2]	@ tmp166, menuItem, tmp179
	lsls	r1, r1, #5	@ tmp165, tmp164,
	adds	r1, r1, r3	@ tmp167, tmp165, tmp166
@ Data/FE6_FE7.c:2137:     PutText(&menuItem->text, BG_GetMapBuffer_New(0) + TILEMAP_INDEX(menuItem->xTile, menuItem->yTile));
	ldr	r3, .L632+20	@ tmp170,
@ Data/FE6_FE7.c:2137:     PutText(&menuItem->text, BG_GetMapBuffer_New(0) + TILEMAP_INDEX(menuItem->xTile, menuItem->yTile));
	lsls	r1, r1, #1	@ tmp168, tmp167,
@ Data/FE6_FE7.c:2137:     PutText(&menuItem->text, BG_GetMapBuffer_New(0) + TILEMAP_INDEX(menuItem->xTile, menuItem->yTile));
	mov	r0, r9	@, _3
	adds	r1, r1, r3	@ tmp169, tmp168, tmp170
	ldr	r3, .L632+24	@ tmp171,
	bl	.L17		@
@ Data/FE6_FE7.c:2139: }
	movs	r0, #0	@,
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L630:
@ Data/FE6_FE7.c:2132:         Text_SetColor(&menuItem->text, 1);
	movs	r1, #1	@,
	mov	r0, r9	@, _3
	ldr	r3, .L632+28	@ tmp151,
	bl	.L17		@
	b	.L618		@
.L633:
	.align	2
.L632:
	.word	Proc_Find
	.word	.LANCHOR0+80
	.word	ggDebuggerMenuItems
	.word	gDebuggerMenuText
	.word	Text_DrawString
	.word	gBG0TilemapBuffer
	.word	PutText
	.word	Text_SetColor
	.size	DebuggerMenuItemDraw, .-DebuggerMenuItemDraw
	.align	1
	.p2align 2,,3
	.global	UnitBeginActionInit
	.syntax unified
	.code	16
	.thumb_func
	.type	UnitBeginActionInit, %function
UnitBeginActionInit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:2168: {
	movs	r4, r0	@ unit, tmp165
@ Data/FE6_FE7.c:2193: }
	@ sp needed	@
@ Data/FE6_FE7.c:2169:     gActiveUnit = unit;
	ldr	r3, .L635	@ tmp125,
	str	r0, [r3]	@ unit, gActiveUnit
@ Data/FE6_FE7.c:2170:     gActiveUnitId = unit->index;
	ldr	r3, .L635+4	@ tmp126,
	ldrb	r2, [r0, #11]	@ tmp127,
@ Data/FE6_FE7.c:2171:     InitBattleUnit(&gBattleActor, unit);
	movs	r1, r4	@, unit
@ Data/FE6_FE7.c:2170:     gActiveUnitId = unit->index;
	strb	r2, [r3]	@ tmp127, gActiveUnitId
@ Data/FE6_FE7.c:2171:     InitBattleUnit(&gBattleActor, unit);
	ldr	r0, .L635+8	@ tmp129,
	ldr	r3, .L635+12	@ tmp130,
	bl	.L17		@
@ Data/FE6_FE7.c:2172:     ClearUnit(&gBattleTarget.unit); // so a previous unit isn't affected
	ldr	r5, .L635+16	@ tmp131,
	ldr	r3, .L635+20	@ tmp132,
	movs	r0, r5	@, tmp131
	bl	.L17		@
@ Data/FE6_FE7.c:2173:     gBattleTarget.unit.index = 0;   // (fixed bug of promote -> levelup with another char)
	movs	r2, #0	@ tmp134,
@ Data/FE6_FE7.c:2175:     gActiveUnitMoveOrigin.x = unit->xPos;
	movs	r0, #16	@ _3,
@ Data/FE6_FE7.c:2176:     gActiveUnitMoveOrigin.y = unit->yPos;
	movs	r1, #17	@ _5,
@ Data/FE6_FE7.c:2173:     gBattleTarget.unit.index = 0;   // (fixed bug of promote -> levelup with another char)
	strb	r2, [r5, #11]	@ tmp134, gBattleTarget.unit.index
@ Data/FE6_FE7.c:2175:     gActiveUnitMoveOrigin.x = unit->xPos;
	ldr	r3, .L635+24	@ tmp136,
@ Data/FE6_FE7.c:2175:     gActiveUnitMoveOrigin.x = unit->xPos;
	ldrsb	r0, [r4, r0]	@ _3,* _3
@ Data/FE6_FE7.c:2175:     gActiveUnitMoveOrigin.x = unit->xPos;
	strh	r0, [r3]	@ _3, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:2176:     gActiveUnitMoveOrigin.y = unit->yPos;
	ldrsb	r1, [r4, r1]	@ _5,* _5
@ Data/FE6_FE7.c:2176:     gActiveUnitMoveOrigin.y = unit->yPos;
	strh	r1, [r3, #2]	@ _5, gActiveUnitMoveOrigin.y
@ Data/FE6_FE7.c:2177:     gActionData.xMove = unit->xPos;
	ldr	r3, .L635+28	@ tmp140,
	strb	r0, [r3, #14]	@ _3, gActionData.xMove
@ Data/FE6_FE7.c:2178:     gActionData.yMove = unit->yPos;
	strb	r1, [r3, #15]	@ _5, gActionData.yMove
@ Data/FE6_FE7.c:2180:     gActionData.subjectIndex = unit->index;
	ldrb	r1, [r4, #11]	@ tmp145,
@ Data/FE6_FE7.c:2186:     gBmSt.taken_action = 0;
	movs	r0, #0	@ tmp152,
@ Data/FE6_FE7.c:2180:     gActionData.subjectIndex = unit->index;
	strb	r1, [r3, #12]	@ tmp145, gActionData.subjectIndex
@ Data/FE6_FE7.c:2186:     gBmSt.taken_action = 0;
	movs	r1, #61	@ tmp157,
@ Data/FE6_FE7.c:2181:     gActionData.targetIndex = 0;
	strb	r2, [r3, #13]	@ tmp134, gActionData.targetIndex
@ Data/FE6_FE7.c:2184:     gActionData.moveCount = 0;
	strh	r2, [r3, #16]	@ tmp134, MEM <unsigned short> [(unsigned char *)&gActionData + 16B]
@ Data/FE6_FE7.c:2182:     gActionData.itemSlotIndex = -1;
	adds	r2, r2, #255	@ tmp154,
	strb	r2, [r3, #18]	@ tmp154, gActionData.itemSlotIndex
@ Data/FE6_FE7.c:2186:     gBmSt.taken_action = 0;
	ldr	r3, .L635+32	@ tmp156,
	strb	r0, [r3, r1]	@ tmp152, gBmSt.taken_action
@ Data/FE6_FE7.c:2187:     gBmSt.unk3F = 0xFF;
	adds	r1, r1, #2	@ tmp161,
	strb	r2, [r3, r1]	@ tmp154, gBmSt.unk3F
@ Data/FE6_FE7.c:2189:     sub_802C334(); // zeroes out a few bits of unknown ram
	ldr	r3, .L635+36	@ tmp164,
	bl	.L17		@
@ Data/FE6_FE7.c:2193: }
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L636:
	.align	2
.L635:
	.word	gActiveUnit
	.word	gActiveUnitId
	.word	gBattleActor
	.word	InitBattleUnit
	.word	gBattleTarget
	.word	ClearUnit
	.word	gActiveUnitMoveOrigin
	.word	gActionData
	.word	gBmSt
	.word	sub_802C334
	.size	UnitBeginActionInit, .-UnitBeginActionInit
	.align	1
	.p2align 2,,3
	.global	SaveMisc
	.syntax unified
	.code	16
	.thumb_func
	.type	SaveMisc, %function
SaveMisc:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
	mov	lr, r9	@,
	mov	r7, r8	@,
@ Data/FE6_FE7.c:1346:     unit->pCharacterData = GetCharacterData(proc->tmp[0]);
	movs	r3, #64	@ tmp161,
@ Data/FE6_FE7.c:1343: {
	push	{r7, lr}	@
@ Data/FE6_FE7.c:1345:     struct Unit * unit = proc->unit;
	ldr	r6, [r0, #60]	@ unit, proc_42(D)->unit
@ Data/FE6_FE7.c:1343: {
	movs	r7, r0	@ proc, tmp290
@ Data/FE6_FE7.c:1346:     unit->pCharacterData = GetCharacterData(proc->tmp[0]);
	ldrsh	r0, [r0, r3]	@ tmp162,
	ldr	r3, .L660	@ tmp163,
	bl	.L17		@
@ Data/FE6_FE7.c:1347:     AdjustWEXPForClass(unit, proc->tmp[1]);
	movs	r3, #66	@ tmp164,
@ Data/FE6_FE7.c:1346:     unit->pCharacterData = GetCharacterData(proc->tmp[0]);
	str	r0, [r6]	@ tmp291, unit_43->pCharacterData
@ Data/FE6_FE7.c:1347:     AdjustWEXPForClass(unit, proc->tmp[1]);
	movs	r0, r6	@, unit
	ldrsh	r1, [r7, r3]	@ tmp165,
	bl	AdjustWEXPForClass		@
@ Data/FE6_FE7.c:1348:     unit->level = proc->tmp[2];
	movs	r3, #68	@ tmp166,
@ Data/FE6_FE7.c:1348:     unit->level = proc->tmp[2];
	ldrh	r3, [r7, r3]	@ tmp169,
	strb	r3, [r6, #8]	@ tmp169, unit_43->level
@ Data/FE6_FE7.c:1349:     unit->exp = proc->tmp[3] & 0xFF;
	movs	r3, #70	@ tmp170,
@ Data/FE6_FE7.c:1349:     unit->exp = proc->tmp[3] & 0xFF;
	ldrh	r3, [r7, r3]	@ tmp173,
	strb	r3, [r6, #9]	@ tmp173, unit_43->exp
@ Data/FE6_FE7.c:1350:     unit->conBonus = proc->tmp[4];
	movs	r3, #72	@ tmp174,
@ Data/FE6_FE7.c:1350:     unit->conBonus = proc->tmp[4];
	ldrh	r3, [r7, r3]	@ tmp177,
	strb	r3, [r6, #26]	@ tmp177, unit_43->conBonus
@ Data/FE6_FE7.c:1351:     unit->movBonus = proc->tmp[5];
	movs	r3, #74	@ tmp178,
	ldrsb	r3, [r7, r3]	@ _13,
@ Data/FE6_FE7.c:1352:     if (UNIT_MOV(unit) > 15)
	ldr	r2, [r6, #4]	@ unit_43->pClassData, unit_43->pClassData
@ Data/FE6_FE7.c:1351:     unit->movBonus = proc->tmp[5];
	strb	r3, [r6, #29]	@ _13, unit_43->movBonus
@ Data/FE6_FE7.c:1352:     if (UNIT_MOV(unit) > 15)
	ldrb	r2, [r2, #18]	@ _16,
	lsls	r2, r2, #24	@ _16, _16,
	asrs	r2, r2, #24	@ _16, _16,
	adds	r3, r3, r2	@ tmp185, _13, _16
@ Data/FE6_FE7.c:1352:     if (UNIT_MOV(unit) > 15)
	cmp	r3, #15	@ tmp185,
	ble	.L638		@,
@ Data/FE6_FE7.c:1354:         unit->movBonus = 15 - UNIT_MOV_BASE(unit);
	movs	r3, #15	@ tmp186,
	subs	r3, r3, r2	@ tmp189, tmp186, _16
@ Data/FE6_FE7.c:1354:         unit->movBonus = 15 - UNIT_MOV_BASE(unit);
	strb	r3, [r6, #29]	@ tmp189, unit_43->movBonus
.L638:
@ Data/FE6_FE7.c:1357:     unit->statusDuration = proc->tmp[8];
	movs	r3, #80	@ tmp192,
@ Data/FE6_FE7.c:1356:     unit->statusIndex = proc->tmp[6] & 0xF;
	movs	r2, #15	@ tmp199,
	movs	r4, #48	@ tmp191,
	ldrh	r1, [r7, r3]	@ tmp195,
	subs	r3, r3, #4	@ tmp197,
	ldrh	r3, [r7, r3]	@ tmp201,
	lsls	r1, r1, #4	@ tmp196, tmp195,
	ands	r3, r2	@ tmp202, tmp199
	orrs	r3, r1	@ tmp206, tmp196
@ Data/FE6_FE7.c:1358:     if (unit->statusIndex && !unit->statusDuration)
	lsls	r1, r3, #24	@ _26, tmp206,
@ Data/FE6_FE7.c:1356:     unit->statusIndex = proc->tmp[6] & 0xF;
	strb	r3, [r6, r4]	@ tmp206, MEM <unsigned char> [(struct Unit *)unit_43 + 48B]
@ Data/FE6_FE7.c:1358:     if (unit->statusIndex && !unit->statusDuration)
	ands	r3, r2	@ tmp211, tmp199
	movs	r0, r3	@ _27, tmp211
	lsrs	r1, r1, #24	@ _26, _26,
@ Data/FE6_FE7.c:1358:     if (unit->statusIndex && !unit->statusDuration)
	cmp	r2, r1	@ tmp199, _26
	bcc	.L639		@,
	cmp	r3, #0	@ _27,
	bne	.L657		@,
.L639:
@ Data/FE6_FE7.c:1364:         unit->statusDuration = 0;
	movs	r2, #0	@ cstore_70,
@ Data/FE6_FE7.c:1362:     if (!unit->statusIndex)
	cmp	r0, #0	@ _27,
	beq	.L640		@,
@ Data/FE6_FE7.c:1364:         unit->statusDuration = 0;
	movs	r3, #48	@ tmp251,
	ldrb	r2, [r6, r3]	@ MEM <struct Unit> [(void *)unit_43], MEM <struct Unit> [(void *)unit_43]
	lsrs	r2, r2, #4	@ cstore_70, MEM <struct Unit> [(void *)unit_43],
.L640:
	movs	r1, #48	@ tmp257,
	movs	r3, #15	@ tmp266,
	ldrb	r0, [r6, r1]	@ MEM <struct Unit> [(void *)unit_43].statusDuration, MEM <struct Unit> [(void *)unit_43].statusDuration
	lsls	r2, r2, #4	@ tmp260, cstore_70,
	ands	r3, r0	@ tmp265, MEM <struct Unit> [(void *)unit_43].statusDuration
	orrs	r3, r2	@ tmp269, tmp260
	strb	r3, [r6, r1]	@ tmp269, MEM <struct Unit> [(void *)unit_43].statusDuration
@ Data/FE6_FE7.c:1366:     if (proc->tmp[7] != (unit->index & 0xC0))
	movs	r3, #78	@ tmp271,
@ Data/FE6_FE7.c:1366:     if (proc->tmp[7] != (unit->index & 0xC0))
	movs	r2, #11	@ tmp272,
@ Data/FE6_FE7.c:1366:     if (proc->tmp[7] != (unit->index & 0xC0))
	ldrsh	r4, [r7, r3]	@ _31,
@ Data/FE6_FE7.c:1366:     if (proc->tmp[7] != (unit->index & 0xC0))
	movs	r3, #192	@ tmp273,
@ Data/FE6_FE7.c:1366:     if (proc->tmp[7] != (unit->index & 0xC0))
	ldrsb	r2, [r6, r2]	@ tmp272,
@ Data/FE6_FE7.c:1366:     if (proc->tmp[7] != (unit->index & 0xC0))
	ands	r3, r2	@ tmp274, tmp272
@ Data/FE6_FE7.c:1366:     if (proc->tmp[7] != (unit->index & 0xC0))
	cmp	r4, r3	@ _31, tmp274
	bne	.L658		@,
.L637:
@ Data/FE6_FE7.c:1383: }
	@ sp needed	@
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L657:
@ Data/FE6_FE7.c:1360:         unit->statusDuration = 5;
	movs	r1, #80	@ tmp237,
	orrs	r3, r1	@ tmp239, tmp237
@ Data/FE6_FE7.c:1362:     if (!unit->statusIndex)
	ands	r2, r3	@ tmp199, tmp239
	movs	r0, r2	@ _27, tmp199
@ Data/FE6_FE7.c:1360:         unit->statusDuration = 5;
	strb	r3, [r6, r4]	@ tmp239, unit_43->statusDuration
	b	.L639		@
.L658:
@ Data/FE6_FE7.c:1322:     int i = faction, last = faction + 0x40;
	movs	r3, #64	@ last,
	mov	r9, r3	@ last, last
@ Data/FE6_FE7.c:1368:         struct Unit * newUnit = GetFreeUnitByFaction(proc->tmp[7] << 6);
	lsls	r4, r4, #6	@ i, _31,
@ Data/FE6_FE7.c:1322:     int i = faction, last = faction + 0x40;
	add	r9, r9, r4	@ last, i
@ Data/FE6_FE7.c:1323:     if (!i)
	cmp	r4, #0	@ i,
	bne	.L643		@,
@ Data/FE6_FE7.c:1324:         i = 1;
	adds	r4, r4, #1	@ i,
.L643:
	ldr	r3, .L660+4	@ tmp285,
	mov	r8, r3	@ tmp285, tmp285
	b	.L645		@
.L659:
@ Data/FE6_FE7.c:1326:     for (; i < last; ++i)
	adds	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:1326:     for (; i < last; ++i)
	cmp	r9, r4	@ last, i
	beq	.L637		@,
.L645:
@ Data/FE6_FE7.c:1328:         struct Unit * unit = GetUnit(i);
	movs	r0, r4	@, i
	bl	.L193		@
@ Data/FE6_FE7.c:1330:         if (unit->pCharacterData == NULL)
	ldr	r3, [r0]	@ unit_65->pCharacterData, unit_65->pCharacterData
@ Data/FE6_FE7.c:1328:         struct Unit * unit = GetUnit(i);
	movs	r5, r0	@ unit, tmp292
@ Data/FE6_FE7.c:1330:         if (unit->pCharacterData == NULL)
	cmp	r3, #0	@ unit_65->pCharacterData,
	bne	.L659		@,
@ Data/FE6_FE7.c:1373:         int deploymentID = newUnit->index;
	movs	r4, #11	@ _36,
@ Data/FE6_FE7.c:1374:         memcpy((void *)newUnit, (void *)unit, sizeof(struct Unit));
	movs	r2, #72	@,
	movs	r1, r6	@, unit
@ Data/FE6_FE7.c:1373:         int deploymentID = newUnit->index;
	ldrsb	r4, [r0, r4]	@ _36,* _36
@ Data/FE6_FE7.c:1374:         memcpy((void *)newUnit, (void *)unit, sizeof(struct Unit));
	ldr	r3, .L660+8	@ tmp280,
	bl	.L17		@
@ Data/FE6_FE7.c:1375:         ClearUnit(unit);
	movs	r0, r6	@, unit
	ldr	r3, .L660+12	@ tmp283,
	bl	.L17		@
@ Data/FE6_FE7.c:1379:         UnitBeginActionInit(newUnit);
	movs	r0, r5	@, unit
@ Data/FE6_FE7.c:1377:         newUnit->index = deploymentID; // copy unit into a free slot in unit struct ram
	strb	r4, [r5, #11]	@ _36, unit_65->index
@ Data/FE6_FE7.c:1379:         UnitBeginActionInit(newUnit);
	bl	UnitBeginActionInit		@
@ Data/FE6_FE7.c:1380:         proc->unit = newUnit;
	str	r5, [r7, #60]	@ unit, proc_42(D)->unit
	b	.L637		@
.L661:
	.align	2
.L660:
	.word	GetCharacterData
	.word	GetUnit
	.word	memcpy
	.word	ClearUnit
	.size	SaveMisc, .-SaveMisc
	.align	1
	.p2align 2,,3
	.global	EditMiscIdle
	.syntax unified
	.code	16
	.thumb_func
	.type	EditMiscIdle, %function
EditMiscIdle:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
	mov	r5, r8	@,
	mov	lr, fp	@,
	mov	r7, r10	@,
	mov	r6, r9	@,
	push	{r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:1764:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L748	@ tmp207,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r5, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:1761: {
	movs	r4, r0	@ proc, tmp392
@ Data/FE6_FE7.c:1765:     if (keys & B_BUTTON)
	lsls	r3, r5, #30	@ tmp394, keys,
	bpl	.LCB4680	@
	b	.L739	@long jump	@
.LCB4680:
.L663:
@ Data/FE6_FE7.c:1770:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp219,
	tst	r3, r5	@ tmp219, keys
	beq	.LCB4687	@
	b	.L740	@long jump	@
.LCB4687:
.L664:
	movs	r2, #16	@ tmp228,
	ands	r2, r5	@ tmp228, keys
	mov	r9, r2	@ _186, tmp228
@ Data/FE6_FE7.c:1778:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r2, #48	@ tmp230,
@ Data/FE6_FE7.c:1776:     if (proc->editing)
	movs	r6, #46	@ tmp224,
@ Data/FE6_FE7.c:1778:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r2]	@ tmp231,
	mov	r10, r2	@ tmp230, tmp230
@ Data/FE6_FE7.c:1776:     if (proc->editing)
	ldrsb	r3, [r4, r6]	@ _2,
	adds	r2, r2, #16	@ tmp236,
@ Data/FE6_FE7.c:1778:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r1, #1	@ tmp232,
	ands	r2, r5	@ tmp236, keys
	mov	r8, r2	@ _191, tmp236
@ Data/FE6_FE7.c:1778:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ _190, tmp232,
@ Data/FE6_FE7.c:1776:     if (proc->editing)
	cmp	r3, #0	@ _2,
	bne	.LCB4707	@
	b	.L665	@long jump	@
.LCB4707:
@ Data/FE6_FE7.c:1778:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r3, #49	@ tmp239,
	ldrsb	r3, [r4, r3]	@ tmp240,
@ Data/FE6_FE7.c:1778:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r7, .L748+4	@ tmp238,
	lsls	r3, r3, #3	@ tmp241, tmp240,
	adds	r3, r7, r3	@ tmp242, tmp238, tmp241
@ Data/FE6_FE7.c:1778:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r0, [r3, #120]	@ CursorLocationTable[_4].x, CursorLocationTable[_4].x
	bl	DisplayVertUiHand		@
@ Data/FE6_FE7.c:1779:         int max = GetMiscMax(proc->id);
	mov	r3, r10	@ tmp230, tmp230
	ldrsb	r0, [r4, r3]	@ tmp246,
	bl	GetMiscMax		@
@ Data/FE6_FE7.c:1578:     switch (id)
	movs	r1, #0	@ tmp251,
@ Data/FE6_FE7.c:1780:         int min = GetMiscMin(proc->id);
	mov	r3, r10	@ tmp230, tmp230
@ Data/FE6_FE7.c:1779:         int max = GetMiscMax(proc->id);
	movs	r6, r0	@ max, tmp393
@ Data/FE6_FE7.c:1578:     switch (id)
	movs	r0, r1	@ tmp249, tmp251
@ Data/FE6_FE7.c:1780:         int min = GetMiscMin(proc->id);
	ldrsb	r2, [r4, r3]	@ _13,
@ Data/FE6_FE7.c:1578:     switch (id)
	subs	r3, r3, #46	@ tmp250,
	cmp	r3, r2	@ tmp250, _13
	adcs	r0, r0, r1	@ tmp249, tmp249, tmp251
	mov	r10, r0	@ _157, tmp249
@ Data/FE6_FE7.c:1781:         int type = (proc->id < 2);
	movs	r0, #1	@ tmp258,
	lsrs	r3, r2, #31	@ tmp259, _13,
	cmp	r0, r2	@ tmp258, _13
	adcs	r3, r3, r1	@ type, tmp259, tmp251
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	lsls	r3, r3, #2	@ tmp261, type,
	adds	r7, r7, r3	@ tmp262, tmp238, tmp261
	ldr	r7, [r7, #112]	@ _52, pDigitTable[type_128]
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	ldr	r3, [r7, #4]	@ MEM[(const int *)_52 + 4B], MEM[(const int *)_52 + 4B]
	cmp	r6, r3	@ max, MEM[(const int *)_52 + 4B]
	bgt	.LCB4735	@
	b	.L697	@long jump	@
.LCB4735:
@ Data/FE6_FE7.c:525:     int result = 1;
	movs	r3, #1	@ result,
.L667:
@ Data/FE6_FE7.c:528:         result++;
	adds	r3, r3, #1	@ result,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	lsls	r2, r3, #2	@ tmp265, result,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	ldr	r2, [r7, r2]	@ MEM[(const int *)_52 + _131 * 1], MEM[(const int *)_52 + _131 * 1]
	cmp	r6, r2	@ max, MEM[(const int *)_52 + _131 * 1]
	bgt	.L667		@,
@ Data/FE6_FE7.c:530:     if (result > 9)
	mov	fp, r3	@ _178, result
	cmp	r3, #9	@ _178,
	ble	.L666		@,
	movs	r3, #9	@ _178,
	mov	fp, r3	@ _178, _178
.L666:
@ Data/FE6_FE7.c:1785:         if (keys & DPAD_RIGHT)
	mov	r3, r9	@ _186, _186
	cmp	r3, #0	@ _186,
	beq	.L669		@,
@ Data/FE6_FE7.c:1787:             if (proc->digit > 0)
	movs	r3, #49	@ tmp267,
	ldrsb	r3, [r4, r3]	@ _15,
@ Data/FE6_FE7.c:1787:             if (proc->digit > 0)
	cmp	r3, #0	@ _15,
	bgt	.LCB4757	@
	b	.L670	@long jump	@
.LCB4757:
@ Data/FE6_FE7.c:1789:                 proc->digit--;
	subs	r3, r3, #1	@ tmp271,
	lsls	r3, r3, #24	@ tmp272, tmp271,
	asrs	r3, r3, #24	@ _19, tmp272,
.L671:
	movs	r2, #49	@ tmp279,
@ Data/FE6_FE7.c:1796:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _19, proc_100(D)->digit
	bl	RedrawMiscMenu		@
.L669:
@ Data/FE6_FE7.c:1798:         if (keys & DPAD_LEFT)
	lsls	r3, r5, #26	@ tmp395, keys,
	bpl	.L672		@,
@ Data/FE6_FE7.c:1800:             if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp288,
	ldrsb	r2, [r4, r3]	@ _23,
@ Data/FE6_FE7.c:1800:             if (proc->digit < (max_digits - 1))
	mov	r3, fp	@ _178, _178
	subs	r3, r3, #1	@ _178,
@ Data/FE6_FE7.c:1800:             if (proc->digit < (max_digits - 1))
	cmp	r2, r3	@ _23, tmp289
	blt	.LCB4780	@
	b	.L673	@long jump	@
.LCB4780:
@ Data/FE6_FE7.c:1802:                 proc->digit++;
	adds	r2, r2, #1	@ tmp291,
	lsls	r3, r2, #24	@ tmp292, tmp291,
	asrs	r3, r3, #24	@ _29, tmp292,
.L674:
	movs	r2, #49	@ tmp296,
@ Data/FE6_FE7.c:1809:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _29, proc_100(D)->digit
	bl	RedrawMiscMenu		@
.L672:
@ Data/FE6_FE7.c:1812:         if (keys & DPAD_UP)
	mov	r3, r8	@ _191, _191
	cmp	r3, #0	@ _191,
	beq	.L675		@,
@ Data/FE6_FE7.c:1814:             if ((proc->tmp[proc->id]) == max)
	movs	r3, #48	@ tmp298,
	ldrsb	r2, [r4, r3]	@ tmp299,
	lsls	r2, r2, #1	@ tmp300, tmp299,
	adds	r2, r4, r2	@ _148, proc, tmp300
@ Data/FE6_FE7.c:1814:             if ((proc->tmp[proc->id]) == max)
	adds	r3, r3, #16	@ tmp301,
	ldrsh	r1, [r2, r3]	@ _32, MEM <s16> [(struct DebuggerProc *)_148 + 64B]
@ Data/FE6_FE7.c:1814:             if ((proc->tmp[proc->id]) == max)
	cmp	r1, r6	@ _32, max
	bne	.LCB4802	@
	b	.L741	@long jump	@
.LCB4802:
@ Data/FE6_FE7.c:1820:                 proc->tmp[proc->id] += pDigitTable[type][proc->digit];
	movs	r3, #49	@ tmp302,
	ldrsb	r3, [r4, r3]	@ tmp303,
@ Data/FE6_FE7.c:1820:                 proc->tmp[proc->id] += pDigitTable[type][proc->digit];
	lsls	r3, r3, #2	@ tmp304, tmp303,
@ Data/FE6_FE7.c:1820:                 proc->tmp[proc->id] += pDigitTable[type][proc->digit];
	ldr	r3, [r3, r7]	@ *_40, *_40
	adds	r3, r3, r1	@ tmp308, *_40, _32
	lsls	r3, r3, #16	@ _44, tmp308,
	asrs	r3, r3, #16	@ _44, _44,
@ Data/FE6_FE7.c:1821:                 if ((proc->tmp[proc->id]) > max)
	cmp	r3, r6	@ _44, max
	ble	.L677		@,
@ Data/FE6_FE7.c:1823:                     proc->tmp[proc->id] = max;
	lsls	r3, r6, #16	@ _44, max,
	asrs	r3, r3, #16	@ _44, _44,
.L677:
@ Data/FE6_FE7.c:1816:                 proc->tmp[proc->id] = min;
	movs	r1, #64	@ tmp309,
@ Data/FE6_FE7.c:1828:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:1816:                 proc->tmp[proc->id] = min;
	strh	r3, [r2, r1]	@ _44, MEM <s16> [(struct DebuggerProc *)_148 + 64B]
@ Data/FE6_FE7.c:1828:             RedrawMiscMenu(proc);
	bl	RedrawMiscMenu		@
.L675:
@ Data/FE6_FE7.c:1830:         if (keys & DPAD_DOWN)
	lsls	r5, r5, #24	@ tmp396, keys,
	bpl	.L662		@,
@ Data/FE6_FE7.c:1832:             if ((proc->tmp[proc->id]) == min)
	movs	r3, #48	@ tmp318,
	ldrsb	r2, [r4, r3]	@ tmp319,
	lsls	r2, r2, #1	@ tmp320, tmp319,
	adds	r2, r4, r2	@ _129, proc, tmp320
@ Data/FE6_FE7.c:1832:             if ((proc->tmp[proc->id]) == min)
	adds	r3, r3, #16	@ tmp321,
	ldrsh	r3, [r2, r3]	@ _50, MEM <s16> [(struct DebuggerProc *)_129 + 64B]
@ Data/FE6_FE7.c:1832:             if ((proc->tmp[proc->id]) == min)
	cmp	r3, r10	@ _50, _157
	bne	.LCB4835	@
	b	.L742	@long jump	@
.LCB4835:
@ Data/FE6_FE7.c:1838:                 val = (proc->tmp[proc->id]) - pDigitTable[type][proc->digit];
	movs	r1, #49	@ tmp322,
	ldrsb	r1, [r4, r1]	@ tmp323,
@ Data/FE6_FE7.c:1838:                 val = (proc->tmp[proc->id]) - pDigitTable[type][proc->digit];
	lsls	r1, r1, #2	@ tmp324, tmp323,
@ Data/FE6_FE7.c:1838:                 val = (proc->tmp[proc->id]) - pDigitTable[type][proc->digit];
	ldr	r1, [r1, r7]	@ *_56, *_56
	subs	r3, r3, r1	@ val, _50, *_56
@ Data/FE6_FE7.c:1839:                 if (val < min)
	cmp	r3, r10	@ val, _157
	blt	.LCB4842	@
	b	.L682	@long jump	@
.LCB4842:
@ Data/FE6_FE7.c:1841:                     proc->tmp[proc->id] = min;
	mov	r3, r10	@ _157, _157
	lsls	r3, r3, #16	@ _51, _157,
	asrs	r3, r3, #16	@ _51, _51,
.L681:
@ Data/FE6_FE7.c:1834:                 proc->tmp[proc->id] = max;
	movs	r1, #64	@ tmp326,
@ Data/FE6_FE7.c:1850:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:1834:                 proc->tmp[proc->id] = max;
	strh	r3, [r2, r1]	@ _51, MEM <s16> [(struct DebuggerProc *)_129 + 64B]
@ Data/FE6_FE7.c:1850:             RedrawMiscMenu(proc);
	bl	RedrawMiscMenu		@
	b	.L662		@
.L665:
@ Data/FE6_FE7.c:1855:         DisplayUiHand(CursorLocationTable[0].x - ((MiscNameWidth + 3) * 8), (Y_HAND + (proc->id * 2)) * 8);
	ldr	r3, .L748+8	@ tmp328,
	movs	r0, #76	@,
	bl	.L17		@
@ Data/FE6_FE7.c:1856:         if (proc->id == (NumberOfMisc - 1))
	mov	r3, r10	@ tmp230, tmp230
	ldrsb	r3, [r4, r3]	@ tmp330,
	cmp	r3, #7	@ tmp330,
	beq	.L743		@,
@ Data/FE6_FE7.c:1883:             if (keys & DPAD_RIGHT)
	mov	r3, r9	@ _186, _186
	cmp	r3, #0	@ _186,
	beq	.L689		@,
@ Data/FE6_FE7.c:1885:                 proc->digit = 1;
	movs	r3, #1	@ tmp342,
	movs	r2, #49	@ tmp341,
	strb	r3, [r4, r2]	@ tmp342, proc_100(D)->digit
@ Data/FE6_FE7.c:1886:                 proc->editing = true;
	strb	r3, [r4, r6]	@ tmp342, proc_100(D)->editing
.L689:
@ Data/FE6_FE7.c:1888:             if (keys & DPAD_LEFT)
	lsls	r3, r5, #26	@ tmp398, keys,
	bmi	.L744		@,
.L688:
@ Data/FE6_FE7.c:1894:         if (keys & DPAD_UP)
	mov	r3, r8	@ _191, _191
	cmp	r3, #0	@ _191,
	beq	.L691		@,
@ Data/FE6_FE7.c:1896:             proc->id--;
	movs	r3, #48	@ tmp360,
@ Data/FE6_FE7.c:1896:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp362,
	subs	r3, r3, #1	@ tmp363,
	lsls	r3, r3, #24	@ tmp364, tmp363,
	asrs	r2, r3, #24	@ _75, tmp364,
@ Data/FE6_FE7.c:1897:             if (proc->id < 0)
	cmp	r3, #0	@ tmp364,
	blt	.L745		@,
.L692:
	movs	r3, #48	@ tmp368,
@ Data/FE6_FE7.c:1901:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _75, MEM <struct DebuggerProc> [(void *)proc_100(D)].id
	bl	RedrawMiscMenu		@
.L691:
@ Data/FE6_FE7.c:1903:         if (keys & DPAD_DOWN)
	lsls	r5, r5, #24	@ tmp399, keys,
	bpl	.L662		@,
@ Data/FE6_FE7.c:1905:             proc->id++;
	movs	r1, #48	@ tmp377,
@ Data/FE6_FE7.c:1908:                 proc->id = 0;
	movs	r0, #7	@ tmp388,
	movs	r5, #0	@ tmp390,
@ Data/FE6_FE7.c:1905:             proc->id++;
	ldrb	r3, [r4, r1]	@ tmp379,
	adds	r3, r3, #1	@ tmp380,
	lsls	r3, r3, #24	@ tmp381, tmp380,
	asrs	r2, r3, #24	@ _80, tmp381,
@ Data/FE6_FE7.c:1908:                 proc->id = 0;
	lsrs	r3, r3, #31	@ tmp389, tmp381,
	cmp	r0, r2	@ tmp388, _80
	adcs	r3, r3, r5	@ tmp387, tmp389, tmp390
	rsbs	r3, r3, #0	@ tmp391, tmp387
	ands	r2, r3	@ _80, tmp391
@ Data/FE6_FE7.c:1911:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r1]	@ _80, MEM <struct DebuggerProc> [(void *)proc_100(D)].id
	bl	RedrawMiscMenu		@
.L662:
@ Data/FE6_FE7.c:1914: }
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	mov	fp, r7
	mov	r10, r6
	mov	r9, r5
	mov	r8, r4
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L740:
@ Data/FE6_FE7.c:1772:         SaveMisc(proc);
	movs	r0, r4	@, proc
	bl	SaveMisc		@
@ Data/FE6_FE7.c:1773:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L748+12	@ tmp223,
	bl	.L17		@
@ Data/FE6_FE7.c:576: }
	b	.L664		@
.L739:
@ Data/FE6_FE7.c:1767:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	ldr	r3, .L748+12	@ tmp215,
	bl	.L17		@
@ Data/FE6_FE7.c:576: }
	b	.L663		@
.L743:
@ Data/FE6_FE7.c:1858:             int val = proc->tmp[proc->id];
	adds	r3, r3, #71	@ tmp331,
@ Data/FE6_FE7.c:1858:             int val = proc->tmp[proc->id];
	ldrsh	r3, [r4, r3]	@ val,
@ Data/FE6_FE7.c:1859:             if (keys & DPAD_RIGHT)
	mov	r2, r9	@ _186, _186
	cmp	r2, #0	@ _186,
	beq	.L684		@,
@ Data/FE6_FE7.c:1867:             if (val < 0)
	movs	r2, #2	@ prephitmp_94,
	adds	r3, r3, #1	@ val, val,
	bmi	.L685		@,
.L738:
@ Data/FE6_FE7.c:1871:             if (val > 2)
	movs	r2, #0	@ prephitmp_94,
	cmp	r3, #2	@ val,
	ble	.L746		@,
.L685:
@ Data/FE6_FE7.c:1877:                 proc->tmp[proc->id] = val;
	movs	r3, #78	@ tmp339,
@ Data/FE6_FE7.c:1878:                 RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:1877:                 proc->tmp[proc->id] = val;
	strh	r2, [r4, r3]	@ prephitmp_94, proc_100(D)->tmp[7]
@ Data/FE6_FE7.c:1878:                 RedrawMiscMenu(proc);
	bl	RedrawMiscMenu		@
	b	.L688		@
.L744:
@ Data/FE6_FE7.c:1890:                 proc->digit = 0;
	movs	r3, #49	@ tmp354,
	movs	r2, #0	@ tmp355,
	strb	r2, [r4, r3]	@ tmp355, proc_100(D)->digit
@ Data/FE6_FE7.c:1891:                 proc->editing = true;
	subs	r3, r3, #3	@ tmp357,
	adds	r2, r2, #1	@ tmp358,
	strb	r2, [r4, r3]	@ tmp358, proc_100(D)->editing
	b	.L688		@
.L673:
@ Data/FE6_FE7.c:1807:                 proc->editing = false;
	movs	r3, #46	@ tmp293,
	movs	r2, #0	@ tmp294,
	strb	r2, [r4, r3]	@ tmp294, proc_100(D)->editing
@ Data/FE6_FE7.c:1806:                 proc->digit = 0;
	movs	r3, #0	@ _29,
	b	.L674		@
.L745:
@ Data/FE6_FE7.c:1899:                 proc->id = NumberOfMisc - 1;
	movs	r2, #7	@ _75,
	b	.L692		@
.L670:
@ Data/FE6_FE7.c:1793:                 proc->digit = max_digits - 1;
	mov	r3, fp	@ _178, _178
@ Data/FE6_FE7.c:1794:                 proc->editing = false;
	movs	r2, #46	@ tmp276,
	movs	r1, #0	@ tmp277,
@ Data/FE6_FE7.c:1793:                 proc->digit = max_digits - 1;
	subs	r3, r3, #1	@ tmp274,
	lsls	r3, r3, #24	@ tmp275, tmp274,
@ Data/FE6_FE7.c:1794:                 proc->editing = false;
	strb	r1, [r4, r2]	@ tmp277, proc_100(D)->editing
@ Data/FE6_FE7.c:1793:                 proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _19, tmp275,
	b	.L671		@
.L741:
@ Data/FE6_FE7.c:1816:                 proc->tmp[proc->id] = min;
	mov	r3, r10	@ _157, _157
	lsls	r3, r3, #16	@ _44, _157,
	asrs	r3, r3, #16	@ _44, _44,
	b	.L677		@
.L742:
@ Data/FE6_FE7.c:1834:                 proc->tmp[proc->id] = max;
	lsls	r3, r6, #16	@ _51, max,
	asrs	r3, r3, #16	@ _51, _51,
	b	.L681		@
.L697:
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	movs	r3, #1	@ _178,
	mov	fp, r3	@ _178, _178
	b	.L666		@
.L684:
@ Data/FE6_FE7.c:1863:             else if (keys & DPAD_LEFT)
	lsls	r2, r5, #26	@ tmp397, keys,
	bmi	.L747		@,
@ Data/FE6_FE7.c:1867:             if (val < 0)
	cmp	r3, #0	@ val,
	blt	.L702		@,
@ Data/FE6_FE7.c:1871:             if (val > 2)
	movs	r2, #0	@ prephitmp_94,
	cmp	r3, #2	@ val,
	bgt	.L685		@,
@ Data/FE6_FE7.c:1894:         if (keys & DPAD_UP)
	mov	r3, r8	@ _191, _191
	cmp	r3, #0	@ _191,
	beq	.L691		@,
@ Data/FE6_FE7.c:1896:             proc->id--;
	movs	r2, #6	@ _75,
	b	.L692		@
.L682:
@ Data/FE6_FE7.c:1845:                     proc->tmp[proc->id] = val;
	lsls	r3, r3, #16	@ _51, val,
	asrs	r3, r3, #16	@ _51, _51,
	b	.L681		@
.L747:
@ Data/FE6_FE7.c:1867:             if (val < 0)
	movs	r2, #2	@ prephitmp_94,
	subs	r3, r3, #1	@ val, val,
	bpl	.L738		@,
	b	.L685		@
.L746:
@ Data/FE6_FE7.c:1877:                 proc->tmp[proc->id] = val;
	lsls	r2, r3, #16	@ prephitmp_94, val,
	asrs	r2, r2, #16	@ prephitmp_94, prephitmp_94,
	b	.L685		@
.L702:
@ Data/FE6_FE7.c:1867:             if (val < 0)
	movs	r2, #2	@ prephitmp_94,
	b	.L685		@
.L749:
	.align	2
.L748:
	.word	gKeyStatusPtr
	.word	.LANCHOR0
	.word	DisplayUiHand
	.word	Proc_Goto
	.size	EditMiscIdle, .-EditMiscIdle
	.align	1
	.p2align 2,,3
	.global	RestartDebuggerMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	RestartDebuggerMenu, %function
RestartDebuggerMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:2258:     struct Unit * unit = proc->unit; // GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	ldr	r4, [r0, #60]	@ unit, proc_3(D)->unit
@ Data/FE6_FE7.c:2257: {
	movs	r5, r0	@ proc, tmp266
@ Data/FE6_FE7.c:2259:     if (!unit)
	cmp	r4, #0	@ unit,
	bne	.LCB5084	@
	b	.L762	@long jump	@
.LCB5084:
@ Data/FE6_FE7.c:2264:     EndAllMenus();
	ldr	r3, .L764	@ tmp165,
	bl	.L17		@
@ Data/FE6_FE7.c:2265:     ResetText();
	ldr	r3, .L764+4	@ tmp166,
	bl	.L17		@
@ Data/FE6_FE7.c:2269:     ProcPtr playerPhaseProc = Proc_Find(gProcScr_PlayerPhase);
	ldr	r3, .L764+8	@ tmp168,
	ldr	r0, .L764+12	@ tmp167,
	bl	.L17		@
@ Data/FE6_FE7.c:2271:     Proc_Goto(playerPhaseProc, 9); // wait for menu?
	movs	r1, #9	@,
	ldr	r3, .L764+16	@ tmp169,
	bl	.L17		@
@ Data/FE6_FE7.c:2272:     UnitBeginActionInit(unit);
	movs	r0, r4	@, unit
	bl	UnitBeginActionInit		@
@ Data/FE6_FE7.c:2274:     proc->editing = false;
	movs	r3, #0	@ tmp170,
@ Data/FE6_FE7.c:2276:     proc->id = 0;
	movs	r2, #0	@ tmp171,
@ Data/FE6_FE7.c:2279:         proc->tmp[i] = 0;
	movs	r0, r5	@ tmp175, proc
@ Data/FE6_FE7.c:2274:     proc->editing = false;
	strh	r3, [r5, #46]	@ tmp170, MEM <unsigned short> [(void *)proc_3(D) + 46B]
@ Data/FE6_FE7.c:2276:     proc->id = 0;
	adds	r3, r3, #48	@ tmp172,
	strb	r2, [r5, r3]	@ tmp171, proc_3(D)->id
@ Data/FE6_FE7.c:2279:         proc->tmp[i] = 0;
	movs	r1, #0	@,
	movs	r2, #30	@,
	ldr	r3, .L764+20	@ tmp178,
	adds	r0, r0, #64	@ tmp175,
	bl	.L17		@
@ Data/FE6_FE7.c:2282:     gPlaySt.xCursor = gBmSt.playerCursor.x;
	ldr	r4, .L764+24	@ tmp259,
@ Data/FE6_FE7.c:2282:     gPlaySt.xCursor = gBmSt.playerCursor.x;
	ldr	r3, .L764+28	@ tmp181,
	ldrh	r2, [r4, #20]	@ tmp185,
	strb	r2, [r3, #18]	@ tmp185, gPlaySt.xCursor
@ Data/FE6_FE7.c:2283:     gPlaySt.yCursor = gBmSt.playerCursor.y;
	ldrh	r2, [r4, #22]	@ tmp190,
	strb	r2, [r3, #19]	@ tmp190, gPlaySt.yCursor
@ Data/FE6_FE7.c:2289:     gActiveUnit->state |= US_HIDDEN;
	movs	r2, #1	@ tmp192,
@ Data/FE6_FE7.c:2289:     gActiveUnit->state |= US_HIDDEN;
	ldr	r6, .L764+32	@ tmp191,
	ldr	r0, [r6]	@ gActiveUnit.61_22, gActiveUnit
@ Data/FE6_FE7.c:2289:     gActiveUnit->state |= US_HIDDEN;
	ldr	r3, [r0, #12]	@ gActiveUnit.61_22->state, gActiveUnit.61_22->state
	orrs	r3, r2	@ tmp193, tmp192
	str	r3, [r0, #12]	@ tmp193, gActiveUnit.61_22->state
@ Data/FE6_FE7.c:2290:     HideUnitSprite(gActiveUnit);
	ldr	r7, .L764+36	@ tmp195,
	bl	.L145		@
@ Data/FE6_FE7.c:2248:     if (!MU_Exists())
	ldr	r3, .L764+40	@ tmp196,
	bl	.L17		@
@ Data/FE6_FE7.c:2248:     if (!MU_Exists())
	cmp	r0, #0	@ tmp268,
	beq	.L763		@,
.L753:
@ Data/FE6_FE7.c:2253:     MU_SetDefaultFacing_Auto();
	ldr	r3, .L764+44	@ tmp205,
	bl	.L17		@
@ Data/FE6_FE7.c:2294:     gBmSt.gameStateBits &= ~BM_FLAG_3;
	movs	r2, #11	@ tmp211,
	ldrb	r3, [r4, #4]	@ tmp209,
	bics	r3, r2	@ tmp210, tmp211
	strb	r3, [r4, #4]	@ tmp210, gBmSt.gameStateBits
@ Data/FE6_FE7.c:2295:     PutMapCursor(
	movs	r3, #32	@ tmp281,
	ldrsh	r6, [r4, r3]	@ _28, tmp259, tmp281
	movs	r3, #34	@ tmp282,
	ldrsh	r7, [r4, r3]	@ _30, tmp259, tmp282
@ Data/FE6_FE7.c:2297:         IsUnitSpriteHoverEnabledAt(gBmSt.playerCursor.x, gBmSt.playerCursor.y) ? 3 : 0);
	movs	r3, #22	@ tmp283,
	ldrsh	r1, [r4, r3]	@ tmp216, tmp259, tmp283
	movs	r3, #20	@ tmp284,
	ldrsh	r0, [r4, r3]	@ tmp218, tmp259, tmp284
	ldr	r3, .L764+48	@ tmp219,
	bl	.L17		@
@ Data/FE6_FE7.c:2295:     PutMapCursor(
	rsbs	r2, r0, #0	@ tmp260, tmp269
	adcs	r2, r2, r0	@ tmp260, tmp269
	movs	r3, #2	@ tmp263,
	rsbs	r2, r2, #0	@ tmp262, tmp260
	bics	r2, r3	@ iftmp.64_36, tmp263
@ Data/FE6_FE7.c:2295:     PutMapCursor(
	movs	r1, r7	@, _30
	ldr	r3, .L764+52	@ tmp222,
	movs	r0, r6	@, _28
@ Data/FE6_FE7.c:2295:     PutMapCursor(
	adds	r2, r2, #3	@ iftmp.64_36,
@ Data/FE6_FE7.c:2295:     PutMapCursor(
	bl	.L17		@
@ Data/FE6_FE7.c:2300:     switch (proc->page)
	movs	r3, #52	@ tmp223,
	ldrb	r3, [r5, r3]	@ _37,
@ Data/FE6_FE7.c:2300:     switch (proc->page)
	cmp	r3, #1	@ _37,
	beq	.L755		@,
	cmp	r3, #2	@ _37,
	beq	.L756		@,
	cmp	r3, #0	@ _37,
	bne	.L757		@,
@ Data/FE6_FE7.c:2304:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDef, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r3, #28	@ tmp285,
	ldrsh	r1, [r4, r3]	@ tmp225, tmp259, tmp285
@ Data/FE6_FE7.c:2304:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDef, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r2, #12	@ tmp286,
	ldrsh	r3, [r4, r2]	@ tmp227, tmp259, tmp286
@ Data/FE6_FE7.c:2304:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDef, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	ldr	r0, .L764+56	@ tmp230,
	subs	r1, r1, r3	@ tmp228, tmp225, tmp227
	movs	r2, #1	@,
	movs	r3, #21	@,
	ldr	r4, .L764+60	@ tmp231,
	bl	.L27		@
.L758:
@ Data/FE6_FE7.c:2319:     if (menu)
	cmp	r0, #0	@ menu,
	beq	.L757		@,
@ Data/FE6_FE7.c:2321:         menu->itemCurrent = proc->mainID;
	movs	r3, #53	@ tmp248,
@ Data/FE6_FE7.c:2321:         menu->itemCurrent = proc->mainID;
	movs	r1, #97	@ tmp249,
@ Data/FE6_FE7.c:2321:         menu->itemCurrent = proc->mainID;
	ldrb	r2, [r5, r3]	@ _58,
@ Data/FE6_FE7.c:2321:         menu->itemCurrent = proc->mainID;
	strb	r2, [r0, r1]	@ _58, menu_56->itemCurrent
@ Data/FE6_FE7.c:2322:         int count = menu->itemCount - 1;
	adds	r3, r3, #43	@ tmp251,
	ldrb	r3, [r0, r3]	@ _59,
@ Data/FE6_FE7.c:2322:         int count = menu->itemCount - 1;
	subs	r3, r3, #1	@ count,
@ Data/FE6_FE7.c:2323:         if (menu->itemCurrent >= count)
	cmp	r3, r2	@ count, _58
	bgt	.L757		@,
@ Data/FE6_FE7.c:2325:             menu->itemCurrent = count;
	strb	r3, [r0, r1]	@ count, menu_56->itemCurrent
.L757:
@ Data/FE6_FE7.c:2330:     Decompress(gUnknown_08A02274, (void *)(VRAM + 0x10000 + 0x240 * 0x20)); //
	ldr	r0, .L764+64	@ tmp257,
	ldr	r1, .L764+68	@,
	ldr	r3, .L764+72	@ tmp258,
	bl	.L17		@
.L750:
@ Data/FE6_FE7.c:2331: }
	@ sp needed	@
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L756:
@ Data/FE6_FE7.c:2314:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage3, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r3, #28	@ tmp289,
	ldrsh	r1, [r4, r3]	@ tmp241, tmp259, tmp289
@ Data/FE6_FE7.c:2314:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage3, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r2, #12	@ tmp290,
	ldrsh	r3, [r4, r2]	@ tmp243, tmp259, tmp290
@ Data/FE6_FE7.c:2314:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage3, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	ldr	r0, .L764+76	@ tmp246,
	subs	r1, r1, r3	@ tmp244, tmp241, tmp243
	movs	r2, #1	@,
	movs	r3, #21	@,
	ldr	r4, .L764+60	@ tmp247,
	bl	.L27		@
@ Data/FE6_FE7.c:2315:             break;
	b	.L758		@
.L763:
@ Data/FE6_FE7.c:2250:         MU_Create(gActiveUnit);
	ldr	r0, [r6]	@ gActiveUnit, gActiveUnit
	ldr	r3, .L764+80	@ tmp201,
	bl	.L17		@
@ Data/FE6_FE7.c:2251:         HideUnitSprite(gActiveUnit);
	ldr	r0, [r6]	@ gActiveUnit, gActiveUnit
	bl	.L145		@
	b	.L753		@
.L755:
@ Data/FE6_FE7.c:2309:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage2, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r3, #28	@ tmp287,
	ldrsh	r1, [r4, r3]	@ tmp233, tmp259, tmp287
@ Data/FE6_FE7.c:2309:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage2, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r2, #12	@ tmp288,
	ldrsh	r3, [r4, r2]	@ tmp235, tmp259, tmp288
@ Data/FE6_FE7.c:2309:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage2, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	ldr	r0, .L764+84	@ tmp238,
	subs	r1, r1, r3	@ tmp236, tmp233, tmp235
	movs	r2, #1	@,
	movs	r3, #21	@,
	ldr	r4, .L764+60	@ tmp239,
	bl	.L27		@
@ Data/FE6_FE7.c:2310:             break;
	b	.L758		@
.L762:
@ Data/FE6_FE7.c:2261:         Proc_Goto(proc, EndLabel);
	movs	r1, #99	@,
	ldr	r3, .L764+16	@ tmp164,
	bl	.L17		@
@ Data/FE6_FE7.c:2262:         return;
	b	.L750		@
.L765:
	.align	2
.L764:
	.word	EndAllMenus
	.word	ResetText
	.word	Proc_Find
	.word	gProcScr_PlayerPhase
	.word	Proc_Goto
	.word	memset
	.word	gBmSt
	.word	gPlaySt
	.word	gActiveUnit
	.word	HideUnitSprite
	.word	MU_Exists
	.word	MU_SetDefaultFacing_Auto
	.word	IsUnitSpriteHoverEnabledAt
	.word	PutMapCursor
	.word	.LANCHOR2+12
	.word	StartOrphanMenuAdjusted
	.word	gUnknown_08A02274
	.word	100747264
	.word	Decompress
	.word	.LANCHOR2+84
	.word	MU_Create
	.word	.LANCHOR2+48
	.size	RestartDebuggerMenu, .-RestartDebuggerMenu
	.align	1
	.p2align 2,,3
	.global	ShouldStartDebugger
	.syntax unified
	.code	16
	.thumb_func
	.type	ShouldStartDebugger, %function
ShouldStartDebugger:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:2198:     if (CheckFlag(DebuggerTurnedOff_Flag))
	ldr	r3, .L767	@ tmp118,
@ Data/FE6_FE7.c:2197: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2198:     if (CheckFlag(DebuggerTurnedOff_Flag))
	ldr	r0, [r3]	@ DebuggerTurnedOff_Flag, DebuggerTurnedOff_Flag
@ Data/FE6_FE7.c:2203: }
	@ sp needed	@
@ Data/FE6_FE7.c:2198:     if (CheckFlag(DebuggerTurnedOff_Flag))
	ldr	r3, .L767+4	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2198:     if (CheckFlag(DebuggerTurnedOff_Flag))
	rsbs	r3, r0, #0	@ tmp126, tmp127
	adcs	r0, r0, r3	@ tmp125, tmp127, tmp126
@ Data/FE6_FE7.c:2203: }
	pop	{r4}
	pop	{r1}
	bx	r1
.L768:
	.align	2
.L767:
	.word	DebuggerTurnedOff_Flag
	.word	CheckFlag
	.size	ShouldStartDebugger, .-ShouldStartDebugger
	.align	1
	.p2align 2,,3
	.global	RestartNow
	.syntax unified
	.code	16
	.thumb_func
	.type	RestartNow, %function
RestartNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2207:     Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
@ Data/FE6_FE7.c:2209: }
	@ sp needed	@
@ Data/FE6_FE7.c:2207:     Proc_Goto(proc, RestartLabel);
	ldr	r3, .L770	@ tmp116,
	bl	.L17		@
@ Data/FE6_FE7.c:2209: }
	movs	r0, #0	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L771:
	.align	2
.L770:
	.word	Proc_Goto
	.size	RestartNow, .-RestartNow
	.align	1
	.p2align 2,,3
	.global	StartDebuggerProc
	.syntax unified
	.code	16
	.thumb_func
	.type	StartDebuggerProc, %function
StartDebuggerProc:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
	mov	lr, r9	@,
	mov	r7, r8	@,
@ Data/FE6_FE7.c:2198:     if (CheckFlag(DebuggerTurnedOff_Flag))
	ldr	r3, .L782	@ tmp138,
@ Data/FE6_FE7.c:2212: { // based on PlayerPhase_MainIdle
	movs	r6, r0	@ playerPhaseProc, tmp200
	push	{r7, lr}	@
@ Data/FE6_FE7.c:2198:     if (CheckFlag(DebuggerTurnedOff_Flag))
	ldr	r0, [r3]	@ DebuggerTurnedOff_Flag, DebuggerTurnedOff_Flag
	ldr	r3, .L782+4	@ tmp140,
	bl	.L17		@
	subs	r4, r0, #0	@ tmp141, tmp201,
@ Data/FE6_FE7.c:2198:     if (CheckFlag(DebuggerTurnedOff_Flag))
	bne	.L772		@,
@ Data/FE6_FE7.c:2217:     struct Unit * unit = GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	ldr	r2, .L782+8	@ tmp143,
	movs	r1, #22	@ tmp211,
	ldrsh	r3, [r2, r1]	@ tmp144, tmp143, tmp211
@ Data/FE6_FE7.c:2217:     struct Unit * unit = GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	ldr	r1, .L782+12	@ tmp146,
	ldr	r1, [r1]	@ gBmMapUnit, gBmMapUnit
	lsls	r3, r3, #2	@ tmp147, tmp144,
@ Data/FE6_FE7.c:2217:     struct Unit * unit = GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	ldr	r3, [r3, r1]	@ *_6, *_6
@ Data/FE6_FE7.c:2217:     struct Unit * unit = GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	movs	r0, #20	@ tmp212,
	ldrsh	r2, [r2, r0]	@ tmp149, tmp143, tmp212
@ Data/FE6_FE7.c:2217:     struct Unit * unit = GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	ldrb	r0, [r3, r2]	@ *_10, *_10
	ldr	r3, .L782+16	@ tmp152,
	bl	.L17		@
	subs	r5, r0, #0	@ unit, tmp202,
@ Data/FE6_FE7.c:2218:     if (!unit)
	beq	.L772		@,
@ Data/FE6_FE7.c:2222:     gActiveUnitMoveOrigin.x = unit->xPos;
	movs	r2, #16	@ tmp155,
@ Data/FE6_FE7.c:2222:     gActiveUnitMoveOrigin.x = unit->xPos;
	ldr	r3, .L782+20	@ tmp153,
@ Data/FE6_FE7.c:2222:     gActiveUnitMoveOrigin.x = unit->xPos;
	ldrsb	r2, [r0, r2]	@ tmp155,
@ Data/FE6_FE7.c:2222:     gActiveUnitMoveOrigin.x = unit->xPos;
	strh	r2, [r3]	@ tmp155, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:2223:     gActiveUnitMoveOrigin.y = unit->yPos;
	movs	r2, #17	@ tmp158,
	ldrsb	r2, [r0, r2]	@ tmp158,
@ Data/FE6_FE7.c:2223:     gActiveUnitMoveOrigin.y = unit->yPos;
	strh	r2, [r3, #2]	@ tmp158, gActiveUnitMoveOrigin.y
@ Data/FE6_FE7.c:2224:     UnitBeginActionInit(unit);
	bl	UnitBeginActionInit		@
@ Data/FE6_FE7.c:2225:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	ldr	r3, .L782+24	@ tmp160,
	movs	r0, r3	@, tmp160
	mov	r9, r3	@ tmp160, tmp160
	ldr	r3, .L782+28	@ tmp199,
	mov	r8, r3	@ tmp199, tmp199
	bl	.L17		@
	subs	r7, r0, #0	@ procIdler, tmp203,
@ Data/FE6_FE7.c:2226:     if (!procIdler)
	beq	.L780		@,
.L776:
@ Data/FE6_FE7.c:2231:     procIdler->unit = unit;
	str	r5, [r7, #60]	@ unit, procIdler_17->unit
@ Data/FE6_FE7.c:2233:     DebuggerProc * proc = Proc_Find(DebuggerProcCmd);
	ldr	r5, .L782+32	@ tmp180,
	movs	r0, r5	@, tmp180
	bl	.L193		@
	subs	r4, r0, #0	@ proc, tmp205,
@ Data/FE6_FE7.c:2234:     if (!proc)
	beq	.L781		@,
.L772:
@ Data/FE6_FE7.c:2244: }
	@ sp needed	@
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L781:
@ Data/FE6_FE7.c:2238:         proc = Proc_StartBlocking(DebuggerProcCmd, playerPhaseProc);
	movs	r1, r6	@, playerPhaseProc
	movs	r0, r5	@, tmp180
	ldr	r3, .L782+36	@ tmp183,
	bl	.L17		@
@ Data/FE6_FE7.c:325:     proc->page = 0;
	movs	r3, #128	@ tmp186,
	lsls	r3, r3, #9	@ tmp186, tmp186,
	str	r3, [r0, #52]	@ tmp186, MEM <unsigned int> [(void *)proc_37 + 52B]
@ Data/FE6_FE7.c:331:     proc->tileID = 1;
	movs	r3, #1	@ tmp187,
@ Data/FE6_FE7.c:332:     proc->id = 0;
	movs	r2, #0	@ tmp185,
@ Data/FE6_FE7.c:2238:         proc = Proc_StartBlocking(DebuggerProcCmd, playerPhaseProc);
	movs	r5, r0	@ proc, tmp206
@ Data/FE6_FE7.c:331:     proc->tileID = 1;
	strh	r3, [r0, #42]	@ tmp187, proc_37->tileID
@ Data/FE6_FE7.c:332:     proc->id = 0;
	adds	r3, r3, #47	@ tmp190,
@ Data/FE6_FE7.c:328:     proc->godMode = 0;
	strh	r4, [r0, #50]	@ proc, MEM <vector(2) unsigned char> [(unsigned char *)proc_37 + 50B]
@ Data/FE6_FE7.c:333:     proc->lastTileHovered = 0;
	str	r4, [r0, #44]	@ proc, MEM <unsigned int> [(void *)proc_37 + 44B]
@ Data/FE6_FE7.c:336:         proc->tmp[i] = 0;
	movs	r1, #0	@,
@ Data/FE6_FE7.c:332:     proc->id = 0;
	strb	r2, [r0, r3]	@ tmp185, proc_37->id
@ Data/FE6_FE7.c:336:         proc->tmp[i] = 0;
	movs	r2, #30	@,
	ldr	r3, .L782+40	@ tmp196,
	adds	r0, r0, #64	@ tmp193,
	bl	.L17		@
@ Data/FE6_FE7.c:2240:         CopyProcVariables(proc, procIdler);
	movs	r1, r7	@, procIdler
	movs	r0, r5	@, proc
	bl	CopyProcVariables		@
	b	.L772		@
.L780:
@ Data/FE6_FE7.c:2228:         procIdler = Proc_Start(DebuggerProcCmdIdler, (void *)3);
	movs	r1, #3	@,
	mov	r0, r9	@, tmp160
	ldr	r3, .L782+44	@ tmp164,
	bl	.L17		@
@ Data/FE6_FE7.c:325:     proc->page = 0;
	movs	r3, #128	@ tmp167,
	lsls	r3, r3, #9	@ tmp167, tmp167,
	str	r3, [r0, #52]	@ tmp167, MEM <unsigned int> [(void *)procIdler_30 + 52B]
@ Data/FE6_FE7.c:331:     proc->tileID = 1;
	movs	r3, #1	@ tmp168,
@ Data/FE6_FE7.c:332:     proc->id = 0;
	movs	r2, #0	@ tmp166,
@ Data/FE6_FE7.c:331:     proc->tileID = 1;
	strh	r3, [r0, #42]	@ tmp168, procIdler_30->tileID
@ Data/FE6_FE7.c:332:     proc->id = 0;
	adds	r3, r3, #47	@ tmp171,
@ Data/FE6_FE7.c:328:     proc->godMode = 0;
	strh	r4, [r0, #50]	@ tmp141, MEM <vector(2) unsigned char> [(unsigned char *)procIdler_30 + 50B]
@ Data/FE6_FE7.c:333:     proc->lastTileHovered = 0;
	str	r4, [r0, #44]	@ tmp141, MEM <unsigned int> [(void *)procIdler_30 + 44B]
@ Data/FE6_FE7.c:2228:         procIdler = Proc_Start(DebuggerProcCmdIdler, (void *)3);
	movs	r7, r0	@ procIdler, tmp204
@ Data/FE6_FE7.c:332:     proc->id = 0;
	strb	r2, [r0, r3]	@ tmp166, procIdler_30->id
@ Data/FE6_FE7.c:336:         proc->tmp[i] = 0;
	movs	r1, #0	@,
	movs	r2, #30	@,
	ldr	r3, .L782+40	@ tmp177,
	adds	r0, r0, #64	@ tmp174,
	bl	.L17		@
	b	.L776		@
.L783:
	.align	2
.L782:
	.word	DebuggerTurnedOff_Flag
	.word	CheckFlag
	.word	gBmSt
	.word	gBmMapUnit
	.word	GetUnit
	.word	gActiveUnitMoveOrigin
	.word	.LANCHOR0+80
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_StartBlocking
	.word	memset
	.word	Proc_Start
	.size	StartDebuggerProc, .-StartDebuggerProc
	.align	1
	.p2align 2,,3
	.global	MakeMoveunitForAnyActiveUnit
	.syntax unified
	.code	16
	.thumb_func
	.type	MakeMoveunitForAnyActiveUnit, %function
MakeMoveunitForAnyActiveUnit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2248:     if (!MU_Exists())
	ldr	r3, .L787	@ tmp117,
	bl	.L17		@
@ Data/FE6_FE7.c:2248:     if (!MU_Exists())
	cmp	r0, #0	@ tmp127,
	beq	.L786		@,
.L785:
@ Data/FE6_FE7.c:2254: }
	@ sp needed	@
@ Data/FE6_FE7.c:2253:     MU_SetDefaultFacing_Auto();
	ldr	r3, .L787+4	@ tmp126,
	bl	.L17		@
@ Data/FE6_FE7.c:2254: }
	pop	{r4}
	pop	{r0}
	bx	r0
.L786:
@ Data/FE6_FE7.c:2250:         MU_Create(gActiveUnit);
	ldr	r4, .L787+8	@ tmp120,
	ldr	r3, .L787+12	@ tmp122,
	ldr	r0, [r4]	@ gActiveUnit, gActiveUnit
	bl	.L17		@
@ Data/FE6_FE7.c:2251:         HideUnitSprite(gActiveUnit);
	ldr	r0, [r4]	@ gActiveUnit, gActiveUnit
	ldr	r3, .L787+16	@ tmp125,
	bl	.L17		@
	b	.L785		@
.L788:
	.align	2
.L787:
	.word	MU_Exists
	.word	MU_SetDefaultFacing_Auto
	.word	gActiveUnit
	.word	MU_Create
	.word	HideUnitSprite
	.size	MakeMoveunitForAnyActiveUnit, .-MakeMoveunitForAnyActiveUnit
	.align	1
	.p2align 2,,3
	.global	PageMenuItemDrawSprites
	.syntax unified
	.code	16
	.thumb_func
	.type	PageMenuItemDrawSprites, %function
PageMenuItemDrawSprites:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:2336:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L790	@ tmp136,
@ Data/FE6_FE7.c:2334: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:2334: {
	movs	r4, r0	@ menu, tmp162
@ Data/FE6_FE7.c:2336:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L790+4	@ tmp135,
	bl	.L17		@
@ Data/FE6_FE7.c:2344:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	movs	r3, #96	@ tmp137,
	ldrb	r3, [r4, r3]	@ tmp138,
@ Data/FE6_FE7.c:2344:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	adds	r3, r3, #11	@ tmp139,
	lsls	r3, r3, #2	@ tmp140, tmp139,
	adds	r4, r4, r3	@ tmp141, menu, tmp140
	ldr	r3, [r4, #4]	@ _4, menu_19(D)->menuItems[_3]
@ Data/FE6_FE7.c:2344:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	movs	r2, #42	@ tmp166,
	ldrsh	r4, [r3, r2]	@ tmp143, _4, tmp166
@ Data/FE6_FE7.c:2345:     int y = (menu->menuItems[menu->itemCount - 1]->yTile * 8) + 4;
	movs	r5, #44	@ tmp144,
	ldrsh	r5, [r3, r5]	@ tmp144, _4, tmp144
@ Data/FE6_FE7.c:2347:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	ldr	r2, .L790+8	@ tmp169,
@ Data/FE6_FE7.c:2347:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	movs	r3, #52	@ tmp148,
@ Data/FE6_FE7.c:2347:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	mov	ip, r2	@ tmp169, tmp169
@ Data/FE6_FE7.c:2344:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	lsls	r4, r4, #3	@ _7, tmp143,
@ Data/FE6_FE7.c:2344:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	movs	r1, r4	@ x, _7
@ Data/FE6_FE7.c:2347:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	ldrb	r3, [r0, r3]	@ tmp149,
@ Data/FE6_FE7.c:2347:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	ldr	r6, .L790+12	@ tmp146,
@ Data/FE6_FE7.c:2345:     int y = (menu->menuItems[menu->itemCount - 1]->yTile * 8) + 4;
	lsls	r5, r5, #3	@ tmp145, tmp144,
@ Data/FE6_FE7.c:2347:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	add	r3, r3, ip	@ tmp150, tmp169
@ Data/FE6_FE7.c:2345:     int y = (menu->menuItems[menu->itemCount - 1]->yTile * 8) + 4;
	adds	r5, r5, #4	@ y,
@ Data/FE6_FE7.c:2347:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	ldr	r7, .L790+16	@ tmp151,
	movs	r2, r5	@, y
	str	r3, [sp]	@ tmp150,
	movs	r0, #0	@,
	movs	r3, r6	@, tmp146
@ Data/FE6_FE7.c:2344:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	adds	r1, r1, #30	@ x,
@ Data/FE6_FE7.c:2347:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	bl	.L145		@
@ Data/FE6_FE7.c:2348:     x += 8;
	movs	r1, r4	@ x, _7
@ Data/FE6_FE7.c:2349:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr2, 0) + OAM2_LAYER(0));
	ldr	r3, .L790+20	@ tmp154,
	movs	r2, r5	@, y
	str	r3, [sp]	@ tmp154,
	movs	r0, #0	@,
	movs	r3, r6	@, tmp146
@ Data/FE6_FE7.c:2348:     x += 8;
	adds	r1, r1, #38	@ x,
@ Data/FE6_FE7.c:2349:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr2, 0) + OAM2_LAYER(0));
	bl	.L145		@
@ Data/FE6_FE7.c:2351:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + NumberOfPages);
	movs	r2, #169	@ tmp173,
	lsls	r2, r2, #2	@ tmp173, tmp173,
	mov	ip, r2	@ tmp173, tmp173
@ Data/FE6_FE7.c:2350:     x += 8;
	movs	r1, r4	@ _7, _7
@ Data/FE6_FE7.c:2351:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + NumberOfPages);
	ldr	r3, .L790+24	@ tmp158,
	ldr	r3, [r3]	@ NumberOfPages, NumberOfPages
	add	r3, r3, ip	@ tmp159, tmp173
	str	r3, [sp]	@ tmp159,
	movs	r2, r5	@, y
	movs	r3, r6	@, tmp146
	movs	r0, #0	@,
@ Data/FE6_FE7.c:2350:     x += 8;
	adds	r1, r1, #46	@ _7,
@ Data/FE6_FE7.c:2351:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + NumberOfPages);
	bl	.L145		@
@ Data/FE6_FE7.c:2353: }
	add	sp, sp, #12	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L791:
	.align	2
.L790:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	677
	.word	gObject_8x8
	.word	PutSprite
	.word	581
	.word	NumberOfPages
	.size	PageMenuItemDrawSprites, .-PageMenuItemDrawSprites
	.align	1
	.p2align 2,,3
	.global	PageIncrementNow
	.syntax unified
	.code	16
	.thumb_func
	.type	PageIncrementNow, %function
PageIncrementNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:2359:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L794	@ tmp123,
	ldr	r5, .L794+4	@ tmp124,
	bl	.L28		@
@ Data/FE6_FE7.c:2360:     proc->actionID = 0;
	movs	r2, #0	@ tmp126,
	movs	r3, #47	@ tmp125,
@ Data/FE6_FE7.c:2361:     Proc_Goto(proc, RestartLabel); // 0xb7
	movs	r1, #1	@,
@ Data/FE6_FE7.c:2360:     proc->actionID = 0;
	strb	r2, [r0, r3]	@ tmp126, proc_9->actionID
@ Data/FE6_FE7.c:2361:     Proc_Goto(proc, RestartLabel); // 0xb7
	ldr	r3, .L794+8	@ tmp128,
@ Data/FE6_FE7.c:2359:     proc = Proc_Find(DebuggerProcCmd);
	movs	r4, r0	@ proc, tmp146
@ Data/FE6_FE7.c:2361:     Proc_Goto(proc, RestartLabel); // 0xb7
	bl	.L17		@
@ Data/FE6_FE7.c:2362:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	ldr	r0, .L794+12	@ tmp130,
	bl	.L28		@
@ Data/FE6_FE7.c:2363:     proc->page++;
	movs	r3, #52	@ tmp132,
@ Data/FE6_FE7.c:2364:     if (proc->page > (NumberOfPages - 1))
	ldr	r2, .L794+16	@ tmp137,
@ Data/FE6_FE7.c:2363:     proc->page++;
	ldrb	r3, [r4, r3]	@ tmp134,
@ Data/FE6_FE7.c:2364:     if (proc->page > (NumberOfPages - 1))
	ldr	r2, [r2]	@ NumberOfPages, NumberOfPages
@ Data/FE6_FE7.c:2363:     proc->page++;
	adds	r3, r3, #1	@ tmp135,
	lsls	r3, r3, #24	@ tmp136, tmp135,
	lsrs	r3, r3, #24	@ _2, tmp136,
@ Data/FE6_FE7.c:2364:     if (proc->page > (NumberOfPages - 1))
	cmp	r3, r2	@ _2, NumberOfPages
	blt	.L793		@,
@ Data/FE6_FE7.c:2366:         proc->page = 0;
	movs	r3, #0	@ _2,
.L793:
@ Data/FE6_FE7.c:2370: }
	@ sp needed	@
	movs	r2, #52	@ tmp139,
	strb	r3, [r4, r2]	@ _2, MEM <struct DebuggerProc> [(void *)proc_9].page
@ Data/FE6_FE7.c:2368:     procIdler->page = proc->page;
	strb	r3, [r0, r2]	@ _2, procIdler_13->page
@ Data/FE6_FE7.c:2370: }
	movs	r0, #23	@,
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L795:
	.align	2
.L794:
	.word	DebuggerProcCmd
	.word	Proc_Find
	.word	Proc_Goto
	.word	.LANCHOR0+80
	.word	NumberOfPages
	.size	PageIncrementNow, .-PageIncrementNow
	.align	1
	.p2align 2,,3
	.global	PageMenuItemDraw
	.syntax unified
	.code	16
	.thumb_func
	.type	PageMenuItemDraw, %function
PageMenuItemDraw:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
	bl	DebuggerMenuItemDraw		@
	@ sp needed	@
	pop	{r4}
	pop	{r1}
	bx	r1
	.size	PageMenuItemDraw, .-PageMenuItemDraw
	.align	1
	.p2align 2,,3
	.global	GetNextUnit
	.syntax unified
	.code	16
	.thumb_func
	.type	GetNextUnit, %function
GetNextUnit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:2388:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	movs	r7, #192	@ tmp125,
	ands	r7, r1	@ _25, allegiance
@ Data/FE6_FE7.c:2388:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	movs	r3, r7	@ tmp126, _25
@ Data/FE6_FE7.c:2385: {
	mov	lr, r8	@,
@ Data/FE6_FE7.c:2388:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	adds	r4, r0, #1	@ i, deployId,
@ Data/FE6_FE7.c:2388:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	adds	r3, r3, #63	@ tmp126,
@ Data/FE6_FE7.c:2385: {
	mov	r8, r0	@ deployId, tmp133
	movs	r5, r1	@ allegiance, tmp134
	push	{lr}	@
@ Data/FE6_FE7.c:2388:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	cmp	r4, r3	@ i, tmp126
	bgt	.L798		@,
	ldr	r6, .L814	@ tmp132,
	adds	r7, r7, #64	@ _26,
.L801:
@ Data/FE6_FE7.c:2390:         unit = GetUnit(i);
	movs	r0, r4	@, i
	bl	.L38		@
@ Data/FE6_FE7.c:2391:         if (UNIT_IS_VALID(unit))
	cmp	r0, #0	@ <retval>,
	beq	.L799		@,
@ Data/FE6_FE7.c:2391:         if (UNIT_IS_VALID(unit))
	ldr	r3, [r0]	@ unit_17->pCharacterData, unit_17->pCharacterData
	cmp	r3, #0	@ unit_17->pCharacterData,
	bne	.L797		@,
.L799:
@ Data/FE6_FE7.c:2388:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	adds	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:2388:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	cmp	r4, r7	@ i, _26
	bne	.L801		@,
.L798:
@ Data/FE6_FE7.c:2396:     for (int i = allegiance; i < deployId; ++i)
	cmp	r8, r5	@ deployId, allegiance
	ble	.L804		@,
	ldr	r6, .L814	@ tmp132,
.L802:
@ Data/FE6_FE7.c:2398:         unit = GetUnit(i);
	movs	r0, r5	@, allegiance
	bl	.L38		@
@ Data/FE6_FE7.c:2399:         if (UNIT_IS_VALID(unit))
	cmp	r0, #0	@ <retval>,
	beq	.L803		@,
@ Data/FE6_FE7.c:2399:         if (UNIT_IS_VALID(unit))
	ldr	r3, [r0]	@ unit_21->pCharacterData, unit_21->pCharacterData
	cmp	r3, #0	@ unit_21->pCharacterData,
	bne	.L797		@,
.L803:
@ Data/FE6_FE7.c:2396:     for (int i = allegiance; i < deployId; ++i)
	adds	r5, r5, #1	@ allegiance,
@ Data/FE6_FE7.c:2396:     for (int i = allegiance; i < deployId; ++i)
	cmp	r8, r5	@ deployId, allegiance
	bne	.L802		@,
.L804:
@ Data/FE6_FE7.c:2404:     return NULL;
	movs	r0, #0	@ <retval>,
.L797:
@ Data/FE6_FE7.c:2405: }
	@ sp needed	@
	pop	{r7}
	mov	r8, r7
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L815:
	.align	2
.L814:
	.word	GetUnit
	.size	GetNextUnit, .-GetNextUnit
	.align	1
	.p2align 2,,3
	.global	GetPrevUnit
	.syntax unified
	.code	16
	.thumb_func
	.type	GetPrevUnit, %function
GetPrevUnit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:2412:     for (int i = deployId - 1; i >= allegiance; --i) // should loop back to itself I guess
	subs	r4, r0, #1	@ i, deployId,
@ Data/FE6_FE7.c:2408: {
	movs	r5, r0	@ deployId, tmp130
	movs	r7, r1	@ allegiance, tmp131
@ Data/FE6_FE7.c:2412:     for (int i = deployId - 1; i >= allegiance; --i) // should loop back to itself I guess
	cmp	r4, r1	@ i, allegiance
	blt	.L817		@,
	ldr	r6, .L833	@ tmp129,
.L820:
@ Data/FE6_FE7.c:2414:         unit = GetUnit(i);
	movs	r0, r4	@, i
	bl	.L38		@
@ Data/FE6_FE7.c:2415:         if (UNIT_IS_VALID(unit))
	cmp	r0, #0	@ <retval>,
	beq	.L818		@,
@ Data/FE6_FE7.c:2415:         if (UNIT_IS_VALID(unit))
	ldr	r3, [r0]	@ unit_12->pCharacterData, unit_12->pCharacterData
	cmp	r3, #0	@ unit_12->pCharacterData,
	bne	.L816		@,
.L818:
@ Data/FE6_FE7.c:2412:     for (int i = deployId - 1; i >= allegiance; --i) // should loop back to itself I guess
	subs	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:2412:     for (int i = deployId - 1; i >= allegiance; --i) // should loop back to itself I guess
	cmp	r7, r4	@ allegiance, i
	ble	.L820		@,
.L817:
@ Data/FE6_FE7.c:2420:     for (int i = ((allegiance & 0xC0) + 0x3F); i > deployId; --i) // should loop back to itself I guess
	movs	r4, #192	@ tmp124,
	ands	r4, r7	@ tmp125, allegiance
@ Data/FE6_FE7.c:2420:     for (int i = ((allegiance & 0xC0) + 0x3F); i > deployId; --i) // should loop back to itself I guess
	adds	r4, r4, #63	@ i,
@ Data/FE6_FE7.c:2420:     for (int i = ((allegiance & 0xC0) + 0x3F); i > deployId; --i) // should loop back to itself I guess
	cmp	r5, r4	@ deployId, i
	bge	.L823		@,
	ldr	r6, .L833	@ tmp129,
.L821:
@ Data/FE6_FE7.c:2422:         unit = GetUnit(i);
	movs	r0, r4	@, i
	bl	.L38		@
@ Data/FE6_FE7.c:2423:         if (UNIT_IS_VALID(unit))
	cmp	r0, #0	@ <retval>,
	beq	.L822		@,
@ Data/FE6_FE7.c:2423:         if (UNIT_IS_VALID(unit))
	ldr	r3, [r0]	@ unit_19->pCharacterData, unit_19->pCharacterData
	cmp	r3, #0	@ unit_19->pCharacterData,
	bne	.L816		@,
.L822:
@ Data/FE6_FE7.c:2420:     for (int i = ((allegiance & 0xC0) + 0x3F); i > deployId; --i) // should loop back to itself I guess
	subs	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:2420:     for (int i = ((allegiance & 0xC0) + 0x3F); i > deployId; --i) // should loop back to itself I guess
	cmp	r5, r4	@ deployId, i
	bne	.L821		@,
.L823:
@ Data/FE6_FE7.c:2428:     return NULL;
	movs	r0, #0	@ <retval>,
.L816:
@ Data/FE6_FE7.c:2429: }
	@ sp needed	@
	pop	{r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L834:
	.align	2
.L833:
	.word	GetUnit
	.size	GetPrevUnit, .-GetPrevUnit
	.align	1
	.p2align 2,,3
	.global	SwapToPreviousUnit
	.syntax unified
	.code	16
	.thumb_func
	.type	SwapToPreviousUnit, %function
SwapToPreviousUnit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:2434:     int deployId = unit->index & 0xFF;
	movs	r3, #11	@ _2,
@ Data/FE6_FE7.c:2432: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2434:     int deployId = unit->index & 0xFF;
	ldr	r2, [r0, #60]	@ proc_6(D)->unit, proc_6(D)->unit
@ Data/FE6_FE7.c:2432: {
	movs	r4, r0	@ proc, tmp125
@ Data/FE6_FE7.c:2434:     int deployId = unit->index & 0xFF;
	ldrsb	r3, [r2, r3]	@ _2,* _2
	ldrb	r0, [r2, #11]	@ deployId,
@ Data/FE6_FE7.c:2435:     int allegiance = UNIT_FACTION(unit); // 0x00, 0x40, or 0x80
	movs	r2, #192	@ tmp123,
	movs	r1, r2	@ allegiance, tmp123
	ands	r1, r3	@ allegiance, _2
@ Data/FE6_FE7.c:2436:     if (!allegiance)
	tst	r2, r3	@ tmp123, _2
	bne	.L836		@,
@ Data/FE6_FE7.c:2438:         allegiance = 1;
	movs	r1, #1	@ allegiance,
.L836:
@ Data/FE6_FE7.c:2440:     unit = GetPrevUnit(deployId, allegiance);
	bl	GetPrevUnit		@
@ Data/FE6_FE7.c:2441:     if (unit)
	cmp	r0, #0	@ unit,
	beq	.L835		@,
@ Data/FE6_FE7.c:2443:         proc->unit = unit;
	str	r0, [r4, #60]	@ unit, proc_6(D)->unit
.L835:
@ Data/FE6_FE7.c:2445: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
	.size	SwapToPreviousUnit, .-SwapToPreviousUnit
	.align	1
	.p2align 2,,3
	.global	SwapToNextUnit
	.syntax unified
	.code	16
	.thumb_func
	.type	SwapToNextUnit, %function
SwapToNextUnit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2449:     int deployId = unit->index & 0xFF;
	ldr	r3, [r0, #60]	@ proc_5(D)->unit, proc_5(D)->unit
@ Data/FE6_FE7.c:2447: {
	movs	r4, r0	@ proc, tmp127
@ Data/FE6_FE7.c:2450:     int allegiance = UNIT_FACTION(unit);
	movs	r1, #192	@ tmp122,
@ Data/FE6_FE7.c:2449:     int deployId = unit->index & 0xFF;
	movs	r0, #255	@ tmp124,
@ Data/FE6_FE7.c:2449:     int deployId = unit->index & 0xFF;
	ldrb	r3, [r3, #11]	@ _2,
	lsls	r3, r3, #24	@ _2, _2,
	asrs	r3, r3, #24	@ _2, _2,
@ Data/FE6_FE7.c:2450:     int allegiance = UNIT_FACTION(unit);
	ands	r1, r3	@ allegiance, _2
@ Data/FE6_FE7.c:2449:     int deployId = unit->index & 0xFF;
	ands	r0, r3	@ deployId, _2
@ Data/FE6_FE7.c:2451:     unit = GetNextUnit(deployId, allegiance);
	bl	GetNextUnit		@
@ Data/FE6_FE7.c:2452:     if (unit)
	cmp	r0, #0	@ unit,
	beq	.L842		@,
@ Data/FE6_FE7.c:2454:         proc->unit = unit;
	str	r0, [r4, #60]	@ unit, proc_5(D)->unit
.L842:
@ Data/FE6_FE7.c:2456: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
	.size	SwapToNextUnit, .-SwapToNextUnit
	.align	1
	.p2align 2,,3
	.global	PageIdler
	.syntax unified
	.code	16
	.thumb_func
	.type	PageIdler, %function
PageIdler:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:2460:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L871	@ tmp155,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r5, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:2459: {
	movs	r4, r0	@ menu, tmp224
@ Data/FE6_FE7.c:2461:     PageMenuItemDrawSprites(menu);
	bl	PageMenuItemDrawSprites		@
@ Data/FE6_FE7.c:2462:     if (!keys)
	cmp	r5, #0	@ keys,
	bne	.L848		@,
.L860:
@ Data/FE6_FE7.c:2464:         return MENU_ITEM_NONE;
	movs	r0, #0	@ <retval>,
.L865:
@ Data/FE6_FE7.c:2522: }
	@ sp needed	@
	pop	{r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L848:
@ Data/FE6_FE7.c:2466:     DebuggerProc * proc = Proc_Find(DebuggerProcCmd);
	ldr	r7, .L871+4	@ tmp157,
	ldr	r0, .L871+8	@ tmp156,
	bl	.L145		@
	movs	r6, r0	@ proc, tmp225
@ Data/FE6_FE7.c:2467:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	ldr	r0, .L871+12	@ tmp159,
	bl	.L145		@
@ Data/FE6_FE7.c:2468:     proc->mainID = menu->itemCurrent;
	movs	r2, #97	@ tmp161,
	ldrsb	r1, [r4, r2]	@ _3,
@ Data/FE6_FE7.c:2468:     proc->mainID = menu->itemCurrent;
	subs	r2, r2, #44	@ tmp162,
	strb	r1, [r6, r2]	@ _3, proc_31->mainID
@ Data/FE6_FE7.c:2469:     procIdler->mainID = menu->itemCurrent;
	strb	r1, [r0, r2]	@ _3, procIdler_33->mainID
@ Data/FE6_FE7.c:2470:     int page = proc->page;
	subs	r2, r2, #1	@ tmp166,
@ Data/FE6_FE7.c:2467:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	movs	r3, r0	@ procIdler, tmp226
@ Data/FE6_FE7.c:2470:     int page = proc->page;
	ldrb	r1, [r6, r2]	@ page,
@ Data/FE6_FE7.c:2472:     if (keys & L_BUTTON)
	lsls	r2, r5, #22	@ tmp229, keys,
	bmi	.L868		@,
@ Data/FE6_FE7.c:2483:     if (keys & R_BUTTON)
	lsls	r2, r5, #23	@ tmp230, keys,
	bmi	.L869		@,
	movs	r2, #16	@ tmp202,
	ands	r2, r5	@ _87, keys
@ Data/FE6_FE7.c:2495:     if (keys & DPAD_LEFT)
	lsls	r5, r5, #26	@ tmp231, keys,
	bmi	.L858		@,
@ Data/FE6_FE7.c:2499:     if (keys & DPAD_RIGHT)
	cmp	r2, #0	@ _87,
	beq	.L860		@,
@ Data/FE6_FE7.c:2501:         page++;
	adds	r1, r1, #1	@ page,
.L861:
@ Data/FE6_FE7.c:2509:         if (page >= NumberOfPages)
	ldr	r2, .L871+16	@ tmp215,
@ Data/FE6_FE7.c:2509:         if (page >= NumberOfPages)
	ldr	r0, [r2]	@ NumberOfPages, NumberOfPages
	movs	r2, #0	@ _80,
	cmp	r0, r1	@ NumberOfPages, page
	bgt	.L870		@,
.L862:
@ Data/FE6_FE7.c:2513:         proc->page = page;
	movs	r1, #52	@ tmp218,
@ Data/FE6_FE7.c:2515:         Proc_Goto(proc, RestartLabel);
	movs	r0, r6	@, proc
@ Data/FE6_FE7.c:2513:         proc->page = page;
	strb	r2, [r6, r1]	@ _80, proc_31->page
@ Data/FE6_FE7.c:2514:         procIdler->page = page;
	strb	r2, [r3, r1]	@ _80, procIdler_33->page
@ Data/FE6_FE7.c:2515:         Proc_Goto(proc, RestartLabel);
	ldr	r3, .L871+20	@ tmp222,
	subs	r1, r1, #51	@,
	bl	.L17		@
@ Data/FE6_FE7.c:2481:         return MENU_ACT_SKIPCURSOR | MENU_ACT_CLEAR | MENU_ACT_END | MENU_ACT_SND6A;
	movs	r0, #23	@ <retval>,
	b	.L865		@
.L858:
@ Data/FE6_FE7.c:2499:     if (keys & DPAD_RIGHT)
	cmp	r2, #0	@ _87,
	bne	.L860		@,
@ Data/FE6_FE7.c:2505:         if (page < 0)
	subs	r1, r1, #1	@ page, page
	bcs	.L861		@,
@ Data/FE6_FE7.c:2507:             page = NumberOfPages - 1;
	ldr	r2, .L871+16	@ tmp211,
@ Data/FE6_FE7.c:2507:             page = NumberOfPages - 1;
	ldr	r2, [r2]	@ NumberOfPages, NumberOfPages
	subs	r2, r2, #1	@ page,
@ Data/FE6_FE7.c:2513:         proc->page = page;
	lsls	r2, r2, #24	@ tmp214, page,
	lsrs	r2, r2, #24	@ _80, tmp214,
	b	.L862		@
.L868:
@ Data/FE6_FE7.c:2434:     int deployId = unit->index & 0xFF;
	movs	r3, #11	@ _57,
@ Data/FE6_FE7.c:2434:     int deployId = unit->index & 0xFF;
	ldr	r2, [r6, #60]	@ proc_31->unit, proc_31->unit
@ Data/FE6_FE7.c:2434:     int deployId = unit->index & 0xFF;
	ldrsb	r3, [r2, r3]	@ _57,* _57
	ldrb	r0, [r2, #11]	@ deployId,
@ Data/FE6_FE7.c:2435:     int allegiance = UNIT_FACTION(unit); // 0x00, 0x40, or 0x80
	movs	r2, #192	@ tmp174,
	movs	r1, r2	@ allegiance, tmp174
	ands	r1, r3	@ allegiance, _57
@ Data/FE6_FE7.c:2436:     if (!allegiance)
	tst	r2, r3	@ tmp174, _57
	bne	.L851		@,
@ Data/FE6_FE7.c:2438:         allegiance = 1;
	movs	r1, #1	@ allegiance,
.L851:
@ Data/FE6_FE7.c:2440:     unit = GetPrevUnit(deployId, allegiance);
	bl	GetPrevUnit		@
@ Data/FE6_FE7.c:2441:     if (unit)
	cmp	r0, #0	@ unit,
	beq	.L867		@,
.L856:
@ Data/FE6_FE7.c:2454:         proc->unit = unit;
	str	r0, [r6, #60]	@ unit, proc_31->unit
.L857:
@ Data/FE6_FE7.c:2486:         gActiveUnitMoveOrigin.x = proc->unit->xPos;
	movs	r2, #16	@ tmp194,
@ Data/FE6_FE7.c:2486:         gActiveUnitMoveOrigin.x = proc->unit->xPos;
	ldr	r3, .L871+24	@ tmp192,
@ Data/FE6_FE7.c:2486:         gActiveUnitMoveOrigin.x = proc->unit->xPos;
	ldrsb	r2, [r0, r2]	@ tmp194,
@ Data/FE6_FE7.c:2486:         gActiveUnitMoveOrigin.x = proc->unit->xPos;
	strh	r2, [r3]	@ tmp194, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:2487:         gActiveUnitMoveOrigin.y = proc->unit->yPos;
	movs	r2, #17	@ tmp197,
	ldrsb	r2, [r0, r2]	@ tmp197,
@ Data/FE6_FE7.c:2491:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r6	@, proc
@ Data/FE6_FE7.c:2487:         gActiveUnitMoveOrigin.y = proc->unit->yPos;
	strh	r2, [r3, #2]	@ tmp197, gActiveUnitMoveOrigin.y
@ Data/FE6_FE7.c:2491:         Proc_Goto(proc, RestartLabel);
	ldr	r3, .L871+20	@ tmp198,
	bl	.L17		@
@ Data/FE6_FE7.c:2481:         return MENU_ACT_SKIPCURSOR | MENU_ACT_CLEAR | MENU_ACT_END | MENU_ACT_SND6A;
	movs	r0, #23	@ <retval>,
	b	.L865		@
.L869:
@ Data/FE6_FE7.c:2450:     int allegiance = UNIT_FACTION(unit);
	movs	r1, #192	@ tmp188,
@ Data/FE6_FE7.c:2449:     int deployId = unit->index & 0xFF;
	movs	r0, #255	@ tmp190,
@ Data/FE6_FE7.c:2449:     int deployId = unit->index & 0xFF;
	ldr	r3, [r6, #60]	@ proc_31->unit, proc_31->unit
	ldrb	r3, [r3, #11]	@ _64,
	lsls	r3, r3, #24	@ _64, _64,
	asrs	r3, r3, #24	@ _64, _64,
@ Data/FE6_FE7.c:2450:     int allegiance = UNIT_FACTION(unit);
	ands	r1, r3	@ allegiance, _64
@ Data/FE6_FE7.c:2449:     int deployId = unit->index & 0xFF;
	ands	r0, r3	@ deployId, _64
@ Data/FE6_FE7.c:2451:     unit = GetNextUnit(deployId, allegiance);
	bl	GetNextUnit		@
@ Data/FE6_FE7.c:2452:     if (unit)
	cmp	r0, #0	@ unit,
	bne	.L856		@,
.L867:
@ Data/FE6_FE7.c:2486:         gActiveUnitMoveOrigin.x = proc->unit->xPos;
	ldr	r0, [r6, #60]	@ unit, proc_31->unit
	b	.L857		@
.L870:
@ Data/FE6_FE7.c:2513:         proc->page = page;
	lsls	r1, r1, #24	@ tmp217, page,
	lsrs	r2, r1, #24	@ _80, tmp217,
	b	.L862		@
.L872:
	.align	2
.L871:
	.word	gKeyStatusPtr
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	.LANCHOR0+80
	.word	NumberOfPages
	.word	Proc_Goto
	.word	gActiveUnitMoveOrigin
	.size	PageIdler, .-PageIdler
	.align	1
	.p2align 2,,3
	.global	ToggleFlag
	.syntax unified
	.code	16
	.thumb_func
	.type	ToggleFlag, %function
ToggleFlag:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2532:     if (CheckFlag(flag))
	ldr	r3, .L876	@ tmp116,
@ Data/FE6_FE7.c:2531: {
	movs	r4, r0	@ flag, tmp121
@ Data/FE6_FE7.c:2532:     if (CheckFlag(flag))
	bl	.L17		@
@ Data/FE6_FE7.c:2532:     if (CheckFlag(flag))
	cmp	r0, #0	@ tmp122,
	beq	.L874		@,
@ Data/FE6_FE7.c:2534:         ClearFlag(flag);
	movs	r0, r4	@, flag
	ldr	r3, .L876+4	@ tmp119,
	bl	.L17		@
.L873:
@ Data/FE6_FE7.c:2540: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
.L874:
@ Data/FE6_FE7.c:2538:         SetFlag(flag);
	movs	r0, r4	@, flag
	ldr	r3, .L876+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2540: }
	b	.L873		@
.L877:
	.align	2
.L876:
	.word	CheckFlag
	.word	ClearFlag
	.word	SetFlag
	.size	ToggleFlag, .-ToggleFlag
	.align	1
	.p2align 2,,3
	.global	StartKeyListenerProc
	.syntax unified
	.code	16
	.thumb_func
	.type	StartKeyListenerProc, %function
StartKeyListenerProc:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:2591:     int keys = gKeyStatusPtr->newKeys;
	ldr	r3, .L882	@ tmp120,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
@ Data/FE6_FE7.c:2592:     if (!keys)
	ldrh	r3, [r3, #8]	@ tmp121,
	cmp	r3, #0	@ tmp121,
	bne	.L879		@,
.L881:
@ Data/FE6_FE7.c:2594:         return 0;
	movs	r0, #0	@ <retval>,
.L878:
@ Data/FE6_FE7.c:2604: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L879:
@ Data/FE6_FE7.c:2596:     CheatCodeKeyListenerProc * proc = Proc_Find(CheatCodeKeyListenerCmd);
	ldr	r5, .L882+4	@ tmp123,
	ldr	r3, .L882+8	@ tmp124,
	movs	r0, r5	@, tmp123
	bl	.L17		@
	subs	r4, r0, #0	@ proc, tmp130,
@ Data/FE6_FE7.c:2597:     if (proc)
	bne	.L881		@,
@ Data/FE6_FE7.c:2601:     proc = Proc_Start(CheatCodeKeyListenerCmd, PROC_TREE_3);
	movs	r1, #3	@,
	movs	r0, r5	@, tmp123
	ldr	r3, .L882+12	@ tmp127,
	bl	.L17		@
@ Data/FE6_FE7.c:2602:     proc->id = 0;
	str	r4, [r0, #44]	@ proc, proc_10->id
@ Data/FE6_FE7.c:2603:     return true;
	movs	r0, #1	@ <retval>,
	b	.L878		@
.L883:
	.align	2
.L882:
	.word	gKeyStatusPtr
	.word	.LANCHOR2+120
	.word	Proc_Find
	.word	Proc_Start
	.size	StartKeyListenerProc, .-StartKeyListenerProc
	.align	1
	.p2align 2,,3
	.global	PutNumberHex
	.syntax unified
	.code	16
	.thumb_func
	.type	PutNumberHex, %function
PutNumberHex:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2748:     PutNumber(tm, color, number);
	ldr	r3, .L885	@ tmp117,
@ Data/FE6_FE7.c:2749: }
	@ sp needed	@
@ Data/FE6_FE7.c:2748:     PutNumber(tm, color, number);
	bl	.L17		@
@ Data/FE6_FE7.c:2749: }
	pop	{r4}
	pop	{r0}
	bx	r0
.L886:
	.align	2
.L885:
	.word	PutNumber
	.size	PutNumberHex, .-PutNumberHex
	.align	1
	.p2align 2,,3
	.global	PromoAction
	.syntax unified
	.code	16
	.thumb_func
	.type	PromoAction, %function
PromoAction:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2752: {
	movs	r4, r0	@ proc, tmp119
@ Data/FE6_FE7.c:2756: }
	@ sp needed	@
@ Data/FE6_FE7.c:2753:     StartBmPromotion(proc);
	ldr	r3, .L888	@ tmp116,
	bl	.L17		@
@ Data/FE6_FE7.c:2754:     Proc_Goto(proc, PostActionLabel);
	movs	r0, r4	@, proc
	movs	r1, #2	@,
	ldr	r3, .L888+4	@ tmp117,
	bl	.L17		@
@ Data/FE6_FE7.c:2756: }
	movs	r0, #0	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L889:
	.align	2
.L888:
	.word	StartBmPromotion
	.word	Proc_Goto
	.size	PromoAction, .-PromoAction
	.align	1
	.p2align 2,,3
	.global	ArenaAction
	.syntax unified
	.code	16
	.thumb_func
	.type	ArenaAction, %function
ArenaAction:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2758: {
	movs	r4, r0	@ proc, tmp119
@ Data/FE6_FE7.c:2762: }
	@ sp needed	@
@ Data/FE6_FE7.c:2759:     StartArenaScreen();
	ldr	r3, .L891	@ tmp116,
	bl	.L17		@
@ Data/FE6_FE7.c:2760:     Proc_Goto(proc, PostActionLabel);
	movs	r0, r4	@, proc
	movs	r1, #2	@,
	ldr	r3, .L891+4	@ tmp117,
	bl	.L17		@
@ Data/FE6_FE7.c:2762: }
	movs	r0, #0	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L892:
	.align	2
.L891:
	.word	StartArenaScreen
	.word	Proc_Goto
	.size	ArenaAction, .-ArenaAction
	.align	1
	.p2align 2,,3
	.global	LevelupAction
	.syntax unified
	.code	16
	.thumb_func
	.type	LevelupAction, %function
LevelupAction:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:2783:     gActiveUnit->exp = 99;
	ldr	r3, .L900	@ tmp122,
	ldr	r1, [r3]	@ gActiveUnit.78_1, gActiveUnit
@ Data/FE6_FE7.c:2783:     gActiveUnit->exp = 99;
	movs	r3, #99	@ tmp123,
@ Data/FE6_FE7.c:2781: {
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:2784:     InitBattleUnit(&gBattleActor, gActiveUnit);
	ldr	r4, .L900+4	@ tmp125,
@ Data/FE6_FE7.c:2783:     gActiveUnit->exp = 99;
	strb	r3, [r1, #9]	@ tmp123, gActiveUnit.78_1->exp
@ Data/FE6_FE7.c:2781: {
	movs	r5, r0	@ proc, tmp172
@ Data/FE6_FE7.c:2784:     InitBattleUnit(&gBattleActor, gActiveUnit);
	ldr	r3, .L900+8	@ tmp126,
	movs	r0, r4	@, tmp125
	bl	.L17		@
@ Data/FE6_FE7.c:2789:     if (CanBattleUnitGainLevels(&gBattleActor))
	movs	r0, r4	@, tmp125
	ldr	r3, .L900+12	@ tmp128,
	bl	.L17		@
@ Data/FE6_FE7.c:2789:     if (CanBattleUnitGainLevels(&gBattleActor))
	cmp	r0, #0	@ tmp173,
	beq	.L894		@,
@ Data/FE6_FE7.c:2792:         if (!(gPlaySt.chapterStateBits & PLAY_FLAG_EXTRA_MAP))
	ldr	r3, .L900+16	@ tmp131,
@ Data/FE6_FE7.c:2792:         if (!(gPlaySt.chapterStateBits & PLAY_FLAG_EXTRA_MAP))
	ldrb	r3, [r3, #20]	@ tmp134,
	cmp	r3, #127	@ tmp134,
	bls	.L899		@,
.L894:
@ Data/FE6_FE7.c:2819:     Proc_Goto(proc, PostActionLabel);
	movs	r1, #2	@,
	movs	r0, r5	@, proc
	ldr	r3, .L900+20	@ tmp170,
	bl	.L17		@
.L895:
@ Data/FE6_FE7.c:2822: }
	@ sp needed	@
	movs	r0, #0	@,
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L899:
@ Data/FE6_FE7.c:2795:             gBattleActor.expGain = 1;
	movs	r6, #1	@ tmp137,
	movs	r3, #110	@ tmp136,
	strb	r6, [r4, r3]	@ tmp137, gBattleActor.expGain
@ Data/FE6_FE7.c:2796:             gBattleActor.unit.exp += 1;
	ldrb	r3, [r4, #9]	@ tmp142,
	adds	r3, r3, #1	@ tmp143,
@ Data/FE6_FE7.c:2798:             CheckBattleUnitLevelUp(&gBattleActor);
	movs	r0, r4	@, tmp125
@ Data/FE6_FE7.c:2796:             gBattleActor.unit.exp += 1;
	strb	r3, [r4, #9]	@ tmp143, gBattleActor.unit.exp
@ Data/FE6_FE7.c:2798:             CheckBattleUnitLevelUp(&gBattleActor);
	ldr	r3, .L900+24	@ tmp146,
	bl	.L17		@
@ Data/FE6_FE7.c:2801:             MU_EndAll();
	ldr	r3, .L900+28	@ tmp147,
	bl	.L17		@
@ Data/FE6_FE7.c:2802:             ResetText();
	ldr	r3, .L900+32	@ tmp148,
	bl	.L17		@
@ Data/FE6_FE7.c:2804:             gBattleActor.weaponBefore = 1; // see BeginMapAnimForSummon
	movs	r3, #74	@ tmp150,
@ Data/FE6_FE7.c:2807:             gManimSt.u62 = 0;
	movs	r2, #98	@ tmp154,
	movs	r1, #0	@ tmp155,
@ Data/FE6_FE7.c:2804:             gBattleActor.weaponBefore = 1; // see BeginMapAnimForSummon
	strh	r6, [r4, r3]	@ tmp137, gBattleActor.weaponBefore
@ Data/FE6_FE7.c:2807:             gManimSt.u62 = 0;
	ldr	r3, .L900+36	@ tmp153,
	strb	r1, [r3, r2]	@ tmp155, gManimSt.u62
@ Data/FE6_FE7.c:2808:             gManimSt.actorCount_maybe = 1;
	subs	r2, r2, #4	@ tmp158,
@ Data/FE6_FE7.c:2810:             gManimSt.subjectActorId = 0;
	adds	r1, r1, #1	@ tmp163,
@ Data/FE6_FE7.c:2808:             gManimSt.actorCount_maybe = 1;
	strh	r6, [r3, r2]	@ tmp137, MEM <vector(2) unsigned char> [(unsigned char *)&gManimSt + 94B]
@ Data/FE6_FE7.c:2810:             gManimSt.subjectActorId = 0;
	adds	r1, r1, #255	@ tmp163,
	subs	r2, r2, #6	@ tmp162,
	strh	r1, [r3, r2]	@ tmp163, MEM <vector(2) unsigned char> [(unsigned char *)&gManimSt + 88B]
@ Data/FE6_FE7.c:2813:             SetupMapBattleAnim(&gBattleActor, &gBattleTarget, gBattleHitArray);
	movs	r0, r4	@, tmp125
	ldr	r2, .L900+40	@ tmp165,
	ldr	r1, .L900+44	@ tmp166,
	ldr	r3, .L900+48	@ tmp168,
	bl	.L17		@
@ Data/FE6_FE7.c:2815:             Proc_Goto(proc, LevelupLabel);
	movs	r1, #13	@,
	movs	r0, r5	@, proc
	ldr	r3, .L900+20	@ tmp169,
	bl	.L17		@
	b	.L895		@
.L901:
	.align	2
.L900:
	.word	gActiveUnit
	.word	gBattleActor
	.word	InitBattleUnit
	.word	CanBattleUnitGainLevels
	.word	gPlaySt
	.word	Proc_Goto
	.word	CheckBattleUnitLevelUp
	.word	MU_EndAll
	.word	ResetText
	.word	gManimSt
	.word	gBattleHitArray
	.word	gBattleTarget
	.word	SetupMapBattleAnim
	.size	LevelupAction, .-LevelupAction
	.align	1
	.p2align 2,,3
	.global	UnitActionFunc
	.syntax unified
	.code	16
	.thumb_func
	.type	UnitActionFunc, %function
UnitActionFunc:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:2856:     switch (proc->actionID)
	movs	r3, #47	@ tmp117,
@ Data/FE6_FE7.c:2855: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2856:     switch (proc->actionID)
	ldrb	r3, [r0, r3]	@ _1,
@ Data/FE6_FE7.c:2855: {
	movs	r4, r0	@ proc, tmp126
@ Data/FE6_FE7.c:2856:     switch (proc->actionID)
	cmp	r3, #2	@ _1,
	beq	.L903		@,
	cmp	r3, #3	@ _1,
	beq	.L904		@,
	cmp	r3, #1	@ _1,
	bne	.L905		@,
@ Data/FE6_FE7.c:2753:     StartBmPromotion(proc);
	ldr	r3, .L906	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2754:     Proc_Goto(proc, PostActionLabel);
	movs	r1, #2	@,
	movs	r0, r4	@, proc
	ldr	r3, .L906+4	@ tmp119,
	bl	.L17		@
.L905:
@ Data/FE6_FE7.c:2878: }
	@ sp needed	@
@ Data/FE6_FE7.c:2876:     proc->actionID = 0;
	movs	r3, #47	@ tmp122,
	movs	r2, #0	@ tmp123,
@ Data/FE6_FE7.c:2878: }
	movs	r0, #0	@,
@ Data/FE6_FE7.c:2876:     proc->actionID = 0;
	strb	r2, [r4, r3]	@ tmp123, proc_4(D)->actionID
@ Data/FE6_FE7.c:2878: }
	pop	{r4}
	pop	{r1}
	bx	r1
.L904:
@ Data/FE6_FE7.c:2870:             LevelupAction(proc);
	bl	LevelupAction		@
@ Data/FE6_FE7.c:2871:             break;
	b	.L905		@
.L903:
@ Data/FE6_FE7.c:2759:     StartArenaScreen();
	ldr	r3, .L906+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2760:     Proc_Goto(proc, PostActionLabel);
	movs	r1, #2	@,
	movs	r0, r4	@, proc
	ldr	r3, .L906+4	@ tmp121,
	bl	.L17		@
@ Data/FE6_FE7.c:2761:     return 0;
	b	.L905		@
.L907:
	.align	2
.L906:
	.word	StartBmPromotion
	.word	Proc_Goto
	.word	StartArenaScreen
	.size	UnitActionFunc, .-UnitActionFunc
	.align	1
	.p2align 2,,3
	.global	SetupUnitFunc
	.syntax unified
	.code	16
	.thumb_func
	.type	SetupUnitFunc, %function
SetupUnitFunc:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:2827:         GetUnit(gActionData.subjectIndex)->items[gActionData.itemSlotIndex];
	ldr	r5, .L909	@ tmp126,
@ Data/FE6_FE7.c:2834: }
	@ sp needed	@
@ Data/FE6_FE7.c:2827:         GetUnit(gActionData.subjectIndex)->items[gActionData.itemSlotIndex];
	ldr	r7, .L909+4	@ tmp128,
	ldrb	r0, [r5, #12]	@ tmp127,
	bl	.L145		@
@ Data/FE6_FE7.c:2827:         GetUnit(gActionData.subjectIndex)->items[gActionData.itemSlotIndex];
	ldrb	r3, [r5, #18]	@ tmp130,
@ Data/FE6_FE7.c:2827:         GetUnit(gActionData.subjectIndex)->items[gActionData.itemSlotIndex];
	adds	r3, r3, #12	@ tmp131,
	lsls	r3, r3, #1	@ tmp132, tmp131,
	adds	r0, r0, r3	@ tmp133, tmp166, tmp132
@ Data/FE6_FE7.c:2826:     gBattleActor.weaponBefore = gBattleTarget.weaponBefore =
	movs	r3, #74	@ tmp136,
@ Data/FE6_FE7.c:2827:         GetUnit(gActionData.subjectIndex)->items[gActionData.itemSlotIndex];
	ldrh	r2, [r0, #6]	@ _6, *_3
@ Data/FE6_FE7.c:2826:     gBattleActor.weaponBefore = gBattleTarget.weaponBefore =
	ldr	r6, .L909+8	@ tmp138,
@ Data/FE6_FE7.c:2826:     gBattleActor.weaponBefore = gBattleTarget.weaponBefore =
	ldr	r4, .L909+12	@ tmp135,
@ Data/FE6_FE7.c:2826:     gBattleActor.weaponBefore = gBattleTarget.weaponBefore =
	strh	r2, [r6, r3]	@ _6, gBattleActor.weaponBefore
@ Data/FE6_FE7.c:2826:     gBattleActor.weaponBefore = gBattleTarget.weaponBefore =
	strh	r2, [r4, r3]	@ _6, gBattleTarget.weaponBefore
@ Data/FE6_FE7.c:2829:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	ldrb	r0, [r5, #12]	@ tmp142,
	bl	.L145		@
@ Data/FE6_FE7.c:2829:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	ldr	r3, .L909+16	@ tmp144,
	bl	.L17		@
@ Data/FE6_FE7.c:2829:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	movs	r3, #72	@ tmp147,
@ Data/FE6_FE7.c:2830:     gBattleActor.hasItemEffectTarget = 0;
	movs	r2, #0	@ tmp154,
@ Data/FE6_FE7.c:2829:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	lsls	r0, r0, #16	@ tmp145, tmp168,
	lsrs	r0, r0, #16	@ _11, tmp145,
@ Data/FE6_FE7.c:2829:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	strh	r0, [r6, r3]	@ _11, gBattleActor.weapon
@ Data/FE6_FE7.c:2829:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	strh	r0, [r4, r3]	@ _11, gBattleTarget.weapon
@ Data/FE6_FE7.c:2830:     gBattleActor.hasItemEffectTarget = 0;
	adds	r3, r3, #54	@ tmp153,
	strb	r2, [r6, r3]	@ tmp154, gBattleActor.hasItemEffectTarget
@ Data/FE6_FE7.c:2831:     gBattleTarget.statusOut = -1;
	adds	r2, r2, #255	@ tmp158,
	subs	r3, r3, #15	@ tmp157,
	strb	r2, [r4, r3]	@ tmp158, gBattleTarget.statusOut
@ Data/FE6_FE7.c:2832:     gActionData.unitActionType = 1;
	subs	r3, r3, #110	@ tmp161,
	strb	r3, [r5, #17]	@ tmp161, gActionData.unitActionType
@ Data/FE6_FE7.c:2833:     UnitBeginAction(gActiveUnit);
	ldr	r3, .L909+20	@ tmp163,
	ldr	r0, [r3]	@ gActiveUnit, gActiveUnit
	ldr	r3, .L909+24	@ tmp165,
	bl	.L17		@
@ Data/FE6_FE7.c:2834: }
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L910:
	.align	2
.L909:
	.word	gActionData
	.word	GetUnit
	.word	gBattleActor
	.word	gBattleTarget
	.word	GetUnitEquippedWeapon
	.word	gActiveUnit
	.word	UnitBeginAction
	.size	SetupUnitFunc, .-SetupUnitFunc
	.align	1
	.p2align 2,,3
	.global	PlayerPhase_PrepareActionBasic
	.syntax unified
	.code	16
	.thumb_func
	.type	PlayerPhase_PrepareActionBasic, %function
PlayerPhase_PrepareActionBasic:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:2837: {
	movs	r4, r0	@ proc, tmp157
@ Data/FE6_FE7.c:2839:     SetupUnitFunc();
	bl	SetupUnitFunc		@
@ Data/FE6_FE7.c:2842:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	ldr	r7, .L916	@ tmp133,
@ Data/FE6_FE7.c:2842:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	ldr	r6, .L916+4	@ tmp135,
	ldrb	r0, [r7, #12]	@ tmp134,
	bl	.L38		@
@ Data/FE6_FE7.c:2842:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	movs	r5, #16	@ _4,
	ldrsb	r5, [r0, r5]	@ _4,* _4
@ Data/FE6_FE7.c:2842:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	ldrb	r0, [r7, #12]	@ tmp137,
	bl	.L38		@
@ Data/FE6_FE7.c:2842:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	movs	r2, #17	@ _9,
@ Data/FE6_FE7.c:1974:     if (y < 0)
	movs	r3, r5	@ tmp143, _4
@ Data/FE6_FE7.c:2842:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	ldrsb	r2, [r0, r2]	@ _9,* _9
	movs	r0, #1	@ <retval>,
@ Data/FE6_FE7.c:1974:     if (y < 0)
	orrs	r3, r2	@ tmp143, _9
	bmi	.L911		@,
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	ldr	r3, .L916+8	@ tmp145,
	movs	r6, #0	@ tmp162,
	ldrsh	r1, [r3, r6]	@ gBmMapSize, tmp145, tmp162
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	cmp	r5, r1	@ _4, gBmMapSize
	bge	.L911		@,
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	movs	r1, #2	@ tmp163,
	ldrsh	r3, [r3, r1]	@ tmp148, tmp145, tmp163
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	cmp	r2, r3	@ _9, tmp148
	bge	.L911		@,
@ Data/FE6_FE7.c:1994:     return EnsureCameraOntoPosition(proc, x, y);
	ldr	r3, .L916+12	@ tmp149,
	movs	r1, r5	@, _4
	movs	r0, r4	@, proc
	bl	.L17		@
@ Data/FE6_FE7.c:2843:     cameraReturn ^= 1;
	movs	r3, #1	@ tmp152,
	eors	r0, r3	@ tmp154, tmp152
@ Data/FE6_FE7.c:2851:     return cameraReturn;
	lsls	r0, r0, #24	@ tmp155, tmp154,
	asrs	r0, r0, #24	@ <retval>, tmp155,
.L911:
@ Data/FE6_FE7.c:2852: }
	@ sp needed	@
	pop	{r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L917:
	.align	2
.L916:
	.word	gActionData
	.word	GetUnit
	.word	gBmMapSize
	.word	EnsureCameraOntoPosition
	.size	PlayerPhase_PrepareActionBasic, .-PlayerPhase_PrepareActionBasic
	.align	1
	.p2align 2,,3
	.global	PlayerPhase_FinishActionNoCanto
	.syntax unified
	.code	16
	.thumb_func
	.type	PlayerPhase_FinishActionNoCanto, %function
PlayerPhase_FinishActionNoCanto:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:2882:     if (gPlaySt.chapterVisionRange != 0)
	ldr	r4, .L926	@ tmp187,
@ Data/FE6_FE7.c:2882:     if (gPlaySt.chapterVisionRange != 0)
	ldrb	r3, [r4, #13]	@ tmp142,
	cmp	r3, #0	@ tmp142,
	beq	.L919		@,
@ Data/FE6_FE7.c:2884:         RenderBmMapOnBg2();
	ldr	r3, .L926+4	@ tmp143,
	bl	.L17		@
@ Data/FE6_FE7.c:2886:         MoveActiveUnit(gActionData.xMove, gActionData.yMove);
	ldr	r3, .L926+8	@ tmp144,
@ Data/FE6_FE7.c:2886:         MoveActiveUnit(gActionData.xMove, gActionData.yMove);
	ldrb	r1, [r3, #15]	@ tmp145,
	ldrb	r0, [r3, #14]	@ tmp147,
	ldr	r3, .L926+12	@ tmp148,
	bl	.L17		@
@ Data/FE6_FE7.c:2888:         RefreshEntityBmMaps();
	ldr	r3, .L926+16	@ tmp149,
	bl	.L17		@
@ Data/FE6_FE7.c:2889:         RenderBmMap();
	ldr	r3, .L926+20	@ tmp150,
	bl	.L17		@
@ Data/FE6_FE7.c:2891:         NewBMXFADE(0);
	ldr	r3, .L926+24	@ tmp151,
	movs	r0, #0	@,
	bl	.L17		@
@ Data/FE6_FE7.c:2893:         RefreshUnitSprites();
	ldr	r3, .L926+28	@ tmp152,
	bl	.L17		@
.L920:
@ Data/FE6_FE7.c:2902:     if (gActiveUnit->curHP != 0)
	movs	r2, #19	@ tmp161,
@ Data/FE6_FE7.c:2902:     if (gActiveUnit->curHP != 0)
	ldr	r3, .L926+32	@ tmp160,
	ldr	r3, [r3]	@ gActiveUnit.81_10, gActiveUnit
@ Data/FE6_FE7.c:2902:     if (gActiveUnit->curHP != 0)
	ldrsb	r2, [r3, r2]	@ tmp161,
	cmp	r2, #0	@ tmp161,
	beq	.L921		@,
@ Data/FE6_FE7.c:2903:         gActiveUnit->state = gActiveUnit->state & ~US_HIDDEN;
	movs	r1, #1	@ tmp164,
	ldr	r2, [r3, #12]	@ gActiveUnit.81_10->state, gActiveUnit.81_10->state
	bics	r2, r1	@ tmp162, tmp164
@ Data/FE6_FE7.c:2903:         gActiveUnit->state = gActiveUnit->state & ~US_HIDDEN;
	str	r2, [r3, #12]	@ tmp162, gActiveUnit.81_10->state
.L921:
@ Data/FE6_FE7.c:2905:     SetCursorMapPositionIfValid(gActiveUnit->xPos, gActiveUnit->yPos);
	movs	r0, #16	@ _14,
@ Data/FE6_FE7.c:2905:     SetCursorMapPositionIfValid(gActiveUnit->xPos, gActiveUnit->yPos);
	movs	r1, #17	@ _16,
@ Data/FE6_FE7.c:2905:     SetCursorMapPositionIfValid(gActiveUnit->xPos, gActiveUnit->yPos);
	ldrsb	r0, [r3, r0]	@ _14,* _14
@ Data/FE6_FE7.c:2905:     SetCursorMapPositionIfValid(gActiveUnit->xPos, gActiveUnit->yPos);
	ldrsb	r1, [r3, r1]	@ _16,* _16
@ Data/FE6_FE7.c:1974:     if (y < 0)
	movs	r3, r0	@ tmp169, _14
	orrs	r3, r1	@ tmp169, _16
	bmi	.L922		@,
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	ldr	r3, .L926+36	@ tmp171,
	movs	r5, #0	@ tmp189,
	ldrsh	r2, [r3, r5]	@ gBmMapSize, tmp171, tmp189
@ Data/FE6_FE7.c:1978:     if (x >= gBmMapSize.x)
	cmp	r0, r2	@ _14, gBmMapSize
	bge	.L922		@,
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	movs	r2, #2	@ tmp190,
	ldrsh	r3, [r3, r2]	@ tmp174, tmp171, tmp190
@ Data/FE6_FE7.c:1982:     if (y >= gBmMapSize.y)
	cmp	r1, r3	@ _16, tmp174
	bge	.L922		@,
@ Data/FE6_FE7.c:2002:     SetCursorMapPosition(x, y);
	ldr	r3, .L926+40	@ tmp175,
	bl	.L17		@
.L922:
@ Data/FE6_FE7.c:2913: }
	@ sp needed	@
@ Data/FE6_FE7.c:2907:     gPlaySt.xCursor = gBmSt.playerCursor.x;
	ldr	r3, .L926+44	@ tmp177,
@ Data/FE6_FE7.c:2907:     gPlaySt.xCursor = gBmSt.playerCursor.x;
	ldrh	r2, [r3, #20]	@ tmp180,
	strb	r2, [r4, #18]	@ tmp180, gPlaySt.xCursor
@ Data/FE6_FE7.c:2908:     gPlaySt.yCursor = gBmSt.playerCursor.y;
	ldrh	r3, [r3, #22]	@ tmp185,
	strb	r3, [r4, #19]	@ tmp185, gPlaySt.yCursor
@ Data/FE6_FE7.c:2910:     MU_EndAll();
	ldr	r3, .L926+48	@ tmp186,
	bl	.L17		@
@ Data/FE6_FE7.c:2913: }
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L919:
@ Data/FE6_FE7.c:2897:         MoveActiveUnit(gActionData.xMove, gActionData.yMove);
	ldr	r3, .L926+8	@ tmp153,
@ Data/FE6_FE7.c:2897:         MoveActiveUnit(gActionData.xMove, gActionData.yMove);
	ldrb	r1, [r3, #15]	@ tmp154,
	ldrb	r0, [r3, #14]	@ tmp156,
	ldr	r3, .L926+12	@ tmp157,
	bl	.L17		@
@ Data/FE6_FE7.c:2899:         RefreshEntityBmMaps();
	ldr	r3, .L926+16	@ tmp158,
	bl	.L17		@
@ Data/FE6_FE7.c:2900:         RenderBmMap();
	ldr	r3, .L926+20	@ tmp159,
	bl	.L17		@
	b	.L920		@
.L927:
	.align	2
.L926:
	.word	gPlaySt
	.word	RenderBmMapOnBg2
	.word	gActionData
	.word	MoveActiveUnit
	.word	RefreshEntityBmMaps
	.word	RenderBmMap
	.word	NewBMXFADE
	.word	RefreshUnitSprites
	.word	gActiveUnit
	.word	gBmMapSize
	.word	SetCursorMapPosition
	.word	gBmSt
	.word	MU_EndAll
	.size	PlayerPhase_FinishActionNoCanto, .-PlayerPhase_FinishActionNoCanto
	.align	1
	.p2align 2,,3
	.global	CallPlayerPhase_FinishAction
	.syntax unified
	.code	16
	.thumb_func
	.type	CallPlayerPhase_FinishAction, %function
CallPlayerPhase_FinishAction:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2917:     PlayerPhase_FinishActionNoCanto(proc);
	bl	PlayerPhase_FinishActionNoCanto		@
@ Data/FE6_FE7.c:2920: }
	@ sp needed	@
@ Data/FE6_FE7.c:2918:     ProcPtr playerPhaseProc = Proc_Find(gProcScr_PlayerPhase);
	ldr	r3, .L929	@ tmp117,
	ldr	r0, .L929+4	@ tmp116,
	bl	.L17		@
@ Data/FE6_FE7.c:2919:     Proc_Goto(playerPhaseProc, 0);
	movs	r1, #0	@,
	ldr	r3, .L929+8	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2920: }
	pop	{r4}
	pop	{r0}
	bx	r0
.L930:
	.align	2
.L929:
	.word	Proc_Find
	.word	gProcScr_PlayerPhase
	.word	Proc_Goto
	.size	CallPlayerPhase_FinishAction, .-CallPlayerPhase_FinishAction
	.align	1
	.p2align 2,,3
	.global	CanActiveUnitPromote
	.syntax unified
	.code	16
	.thumb_func
	.type	CanActiveUnitPromote, %function
CanActiveUnitPromote:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:2924:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r3, .L936	@ tmp128,
	movs	r1, #11	@ tmp129,
	ldr	r2, [r3]	@ gActiveUnit.86_1, gActiveUnit
	movs	r3, #192	@ tmp130,
	ldrsb	r1, [r2, r1]	@ tmp129,
	ands	r3, r1	@ tmp131, tmp129
@ Data/FE6_FE7.c:2924:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r1, .L936+4	@ tmp132,
	ldrb	r1, [r1, #15]	@ tmp133,
@ Data/FE6_FE7.c:2924:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	cmp	r3, r1	@ tmp131, tmp133
	bne	.L934		@,
@ Data/FE6_FE7.c:2929:     int promoted = UNIT_CATTRIBUTES(gActiveUnit) & CA_PROMOTED;
	ldr	r3, [r2]	@ gActiveUnit.86_1->pCharacterData, gActiveUnit.86_1->pCharacterData
	ldr	r1, [r2, #4]	@ _9, gActiveUnit.86_1->pClassData
	ldr	r3, [r3, #40]	@ _7->attributes, _7->attributes
	ldr	r2, [r1, #40]	@ _9->attributes, _9->attributes
	orrs	r3, r2	@ tmp135, _9->attributes
@ Data/FE6_FE7.c:2930:     if (promoted)
	lsls	r3, r3, #23	@ tmp144, tmp135,
	bmi	.L934		@,
@ Data/FE6_FE7.c:2935:     if (!promotionClass)
	ldrb	r0, [r1, #5]	@ tmp140,
@ Data/FE6_FE7.c:2940:     return usable;
	rsbs	r3, r0, #0	@ tmp143, tmp140
	adcs	r0, r0, r3	@ tmp142, tmp140, tmp143
	adds	r0, r0, #1	@ <retval>,
.L932:
@ Data/FE6_FE7.c:2941: }
	@ sp needed	@
	bx	lr
.L934:
@ Data/FE6_FE7.c:2926:         return greyed;
	movs	r0, #2	@ <retval>,
	b	.L932		@
.L937:
	.align	2
.L936:
	.word	gActiveUnit
	.word	gPlaySt
	.size	CanActiveUnitPromote, .-CanActiveUnitPromote
	.align	1
	.p2align 2,,3
	.global	CanActiveUnitPromoteMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	CanActiveUnitPromoteMenu, %function
CanActiveUnitPromoteMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:2924:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r3, .L943	@ tmp130,
	movs	r1, #11	@ tmp131,
	ldr	r2, [r3]	@ gActiveUnit.86_3, gActiveUnit
	movs	r3, #192	@ tmp132,
	ldrsb	r1, [r2, r1]	@ tmp131,
	ands	r3, r1	@ tmp133, tmp131
@ Data/FE6_FE7.c:2924:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r1, .L943+4	@ tmp134,
	ldrb	r1, [r1, #15]	@ tmp135,
@ Data/FE6_FE7.c:2924:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	cmp	r3, r1	@ tmp133, tmp135
	bne	.L941		@,
@ Data/FE6_FE7.c:2929:     int promoted = UNIT_CATTRIBUTES(gActiveUnit) & CA_PROMOTED;
	ldr	r3, [r2]	@ gActiveUnit.86_3->pCharacterData, gActiveUnit.86_3->pCharacterData
	ldr	r1, [r2, #4]	@ _11, gActiveUnit.86_3->pClassData
	ldr	r3, [r3, #40]	@ _9->attributes, _9->attributes
	ldr	r2, [r1, #40]	@ _11->attributes, _11->attributes
	orrs	r3, r2	@ tmp137, _11->attributes
@ Data/FE6_FE7.c:2930:     if (promoted)
	lsls	r3, r3, #23	@ tmp146, tmp137,
	bmi	.L941		@,
@ Data/FE6_FE7.c:2935:     if (!promotionClass)
	ldrb	r0, [r1, #5]	@ tmp142,
@ Data/FE6_FE7.c:2940:     return usable;
	rsbs	r3, r0, #0	@ tmp145, tmp142
	adcs	r0, r0, r3	@ tmp144, tmp142, tmp145
	adds	r0, r0, #1	@ <retval>,
.L939:
@ Data/FE6_FE7.c:2945: }
	@ sp needed	@
	bx	lr
.L941:
@ Data/FE6_FE7.c:2926:         return greyed;
	movs	r0, #2	@ <retval>,
	b	.L939		@
.L944:
	.align	2
.L943:
	.word	gActiveUnit
	.word	gPlaySt
	.size	CanActiveUnitPromoteMenu, .-CanActiveUnitPromoteMenu
	.align	1
	.p2align 2,,3
	.global	CallArenaIsUnitAllowed
	.syntax unified
	.code	16
	.thumb_func
	.type	CallArenaIsUnitAllowed, %function
CallArenaIsUnitAllowed:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:2949:     if (ArenaIsUnitAllowed(gActiveUnit))
	ldr	r3, .L948	@ tmp119,
@ Data/FE6_FE7.c:2948: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2949:     if (ArenaIsUnitAllowed(gActiveUnit))
	ldr	r0, [r3]	@ gActiveUnit, gActiveUnit
@ Data/FE6_FE7.c:2954: }
	@ sp needed	@
@ Data/FE6_FE7.c:2949:     if (ArenaIsUnitAllowed(gActiveUnit))
	ldr	r3, .L948+4	@ tmp121,
	bl	.L17		@
@ Data/FE6_FE7.c:2953:     return greyed;
	rsbs	r3, r0, #0	@ tmp126, tmp127
	adcs	r0, r0, r3	@ tmp125, tmp127, tmp126
	adds	r0, r0, #1	@ <retval>,
@ Data/FE6_FE7.c:2954: }
	pop	{r4}
	pop	{r1}
	bx	r1
.L949:
	.align	2
.L948:
	.word	gActiveUnit
	.word	ArenaIsUnitAllowed
	.size	CallArenaIsUnitAllowed, .-CallArenaIsUnitAllowed
	.align	1
	.p2align 2,,3
	.global	CallEndEventNow
	.syntax unified
	.code	16
	.thumb_func
	.type	CallEndEventNow, %function
CallEndEventNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2960:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L951	@ tmp119,
@ Data/FE6_FE7.c:2968: }
	@ sp needed	@
@ Data/FE6_FE7.c:2960:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L951+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2961:     Proc_Goto(proc, EndLabel);
	movs	r1, #99	@,
	ldr	r3, .L951+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2965:     CallEndEvent();
	ldr	r3, .L951+12	@ tmp121,
	bl	.L17		@
@ Data/FE6_FE7.c:2968: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L952:
	.align	2
.L951:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.word	CallEndEvent
	.size	CallEndEventNow, .-CallEndEventNow
	.align	1
	.p2align 2,,3
	.global	EditWExpNow
	.syntax unified
	.code	16
	.thumb_func
	.type	EditWExpNow, %function
EditWExpNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2973:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L954	@ tmp119,
@ Data/FE6_FE7.c:2976: }
	@ sp needed	@
@ Data/FE6_FE7.c:2973:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L954+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2974:     Proc_Goto(proc, WExpLabel);
	movs	r1, #16	@,
	ldr	r3, .L954+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2976: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L955:
	.align	2
.L954:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	EditWExpNow, .-EditWExpNow
	.align	1
	.p2align 2,,3
	.global	EditSupportNow
	.syntax unified
	.code	16
	.thumb_func
	.type	EditSupportNow, %function
EditSupportNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2981:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L957	@ tmp119,
@ Data/FE6_FE7.c:2984: }
	@ sp needed	@
@ Data/FE6_FE7.c:2981:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L957+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2982:     Proc_Goto(proc, SupportLabel);
	movs	r1, #17	@,
	ldr	r3, .L957+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2984: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L958:
	.align	2
.L957:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	EditSupportNow, .-EditSupportNow
	.align	1
	.p2align 2,,3
	.global	SaveWExp
	.syntax unified
	.code	16
	.thumb_func
	.type	SaveWExp, %function
SaveWExp:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r3, r0	@ ivtmp.926, proc
	ldr	r2, [r0, #60]	@ proc_6(D)->unit, proc_6(D)->unit
	adds	r3, r3, #64	@ ivtmp.926,
	adds	r2, r2, #40	@ ivtmp.928,
	adds	r0, r0, #80	@ _24,
.L960:
@ Data/FE6_FE7.c:3112:         unit->ranks[i] = proc->tmp[i];
	ldrh	r1, [r3]	@ MEM[(short int *)_21], MEM[(short int *)_21]
@ Data/FE6_FE7.c:3110:     for (int i = 0; i < WExpOptions; ++i)
	adds	r3, r3, #2	@ ivtmp.926,
@ Data/FE6_FE7.c:3112:         unit->ranks[i] = proc->tmp[i];
	strb	r1, [r2]	@ MEM[(short int *)_21], MEM[(unsigned char *)_22]
@ Data/FE6_FE7.c:3110:     for (int i = 0; i < WExpOptions; ++i)
	adds	r2, r2, #1	@ ivtmp.928,
	cmp	r3, r0	@ ivtmp.926, _24
	bne	.L960		@,
@ Data/FE6_FE7.c:3114: }
	@ sp needed	@
	bx	lr
	.size	SaveWExp, .-SaveWExp
	.align	1
	.p2align 2,,3
	.global	ClearTilesetRow
	.syntax unified
	.code	16
	.thumb_func
	.type	ClearTilesetRow, %function
ClearTilesetRow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
@ Data/FE6_FE7.c:3118:     gLCDControlBuffer.bg1cnt.priority = 0;
	movs	r1, #3	@ tmp121,
@ Data/FE6_FE7.c:3117: {
	push	{lr}	@
@ Data/FE6_FE7.c:3118:     gLCDControlBuffer.bg1cnt.priority = 0;
	ldr	r2, .L963	@ tmp115,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp120, tmp121
@ Data/FE6_FE7.c:3117: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:3118:     gLCDControlBuffer.bg1cnt.priority = 0;
	strb	r3, [r2, #16]	@ tmp120, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3119:     SetBackgroundTileDataOffset(2, 0);
	movs	r1, #0	@,
	movs	r0, #2	@,
	ldr	r3, .L963+4	@ tmp123,
	bl	.L17		@
@ Data/FE6_FE7.c:3120:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp124,
	movs	r2, #0	@,
	str	r3, [sp]	@ tmp124,
	movs	r1, #1	@,
	movs	r0, #0	@,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3121:     BG_Fill(gBG2TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L963+8	@ tmp125,
	ldr	r3, .L963+12	@ tmp126,
	bl	.L17		@
@ Data/FE6_FE7.c:3122:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT);
	movs	r0, #7	@,
	ldr	r3, .L963+16	@ tmp127,
	bl	.L17		@
@ Data/FE6_FE7.c:3123: }
	add	sp, sp, #12	@,,
	@ sp needed	@
	pop	{r0}
	bx	r0
.L964:
	.align	2
.L963:
	.word	gLCDControlBuffer
	.word	SetBackgroundTileDataOffset
	.word	gBG2TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.size	ClearTilesetRow, .-ClearTilesetRow
	.align	1
	.p2align 2,,3
	.global	NewGetWeaponLevelFromExp
	.syntax unified
	.code	16
	.thumb_func
	.type	NewGetWeaponLevelFromExp, %function
NewGetWeaponLevelFromExp:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:3127:     if (wexp < WPN_EXP_E)
	cmp	r0, #0	@ wexp,
	ble	.L967		@,
@ Data/FE6_FE7.c:3130:     if (wexp < WPN_EXP_D)
	cmp	r0, #30	@ wexp,
	ble	.L968		@,
@ Data/FE6_FE7.c:3133:     if (wexp < WPN_EXP_C)
	cmp	r0, #70	@ wexp,
	ble	.L969		@,
@ Data/FE6_FE7.c:3136:     if (wexp < WPN_EXP_B)
	cmp	r0, #120	@ wexp,
	ble	.L970		@,
@ Data/FE6_FE7.c:3139:     if (wexp < WPN_EXP_A)
	cmp	r0, #180	@ wexp,
	ble	.L971		@,
@ Data/FE6_FE7.c:3142:     if (wexp < WPN_EXP_S)
	cmp	r0, #250	@ wexp,
	ble	.L972		@,
@ Data/FE6_FE7.c:3145:     return WPN_LEVEL_S;
	movs	r0, #6	@ <retval>,
	b	.L965		@
.L968:
@ Data/FE6_FE7.c:3131:         return WPN_LEVEL_E;
	movs	r0, #1	@ <retval>,
.L965:
@ Data/FE6_FE7.c:3146: }
	@ sp needed	@
	bx	lr
.L967:
@ Data/FE6_FE7.c:3128:         return WPN_LEVEL_0;
	movs	r0, #0	@ <retval>,
	b	.L965		@
.L972:
@ Data/FE6_FE7.c:3143:         return WPN_LEVEL_A;
	movs	r0, #5	@ <retval>,
	b	.L965		@
.L969:
@ Data/FE6_FE7.c:3134:         return WPN_LEVEL_D;
	movs	r0, #2	@ <retval>,
	b	.L965		@
.L970:
@ Data/FE6_FE7.c:3137:         return WPN_LEVEL_C;
	movs	r0, #3	@ <retval>,
	b	.L965		@
.L971:
@ Data/FE6_FE7.c:3140:         return WPN_LEVEL_B;
	movs	r0, #4	@ <retval>,
	b	.L965		@
	.size	NewGetWeaponLevelFromExp, .-NewGetWeaponLevelFromExp
	.align	1
	.p2align 2,,3
	.global	NewGetWeaponExpProgressState
	.syntax unified
	.code	16
	.thumb_func
	.type	NewGetWeaponExpProgressState, %function
NewGetWeaponExpProgressState:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:3127:     if (wexp < WPN_EXP_E)
	cmp	r0, #0	@ wexp,
	ble	.L980		@,
@ Data/FE6_FE7.c:3130:     if (wexp < WPN_EXP_D)
	cmp	r0, #30	@ wexp,
	ble	.L975		@,
@ Data/FE6_FE7.c:3133:     if (wexp < WPN_EXP_C)
	cmp	r0, #70	@ wexp,
	ble	.L976		@,
@ Data/FE6_FE7.c:3136:     if (wexp < WPN_EXP_B)
	cmp	r0, #120	@ wexp,
	ble	.L977		@,
@ Data/FE6_FE7.c:3139:     if (wexp < WPN_EXP_A)
	cmp	r0, #180	@ wexp,
	ble	.L978		@,
@ Data/FE6_FE7.c:3142:     if (wexp < WPN_EXP_S)
	cmp	r0, #250	@ wexp,
	ble	.L981		@,
.L980:
	movs	r0, #0	@ _2,
	movs	r3, #0	@ _11,
	b	.L974		@
.L975:
@ Data/FE6_FE7.c:3161:             return;
	movs	r3, #30	@ _11,
@ Data/FE6_FE7.c:3159:             *outValue = wexp - WPN_EXP_E;
	subs	r0, r0, #1	@ _2,
.L974:
@ Data/FE6_FE7.c:3179:             *outValue = wexp - WPN_EXP_A;
	str	r0, [r1]	@ _2, *outValue_10(D)
@ Data/FE6_FE7.c:3189: }
	@ sp needed	@
@ Data/FE6_FE7.c:3180:             *outMax = WPN_EXP_S - WPN_EXP_A;
	str	r3, [r2]	@ _11, *outMax_12(D)
@ Data/FE6_FE7.c:3189: }
	bx	lr
.L981:
@ Data/FE6_FE7.c:3181:             return;
	movs	r3, #70	@ _11,
@ Data/FE6_FE7.c:3179:             *outValue = wexp - WPN_EXP_A;
	subs	r0, r0, #181	@ _2,
@ Data/FE6_FE7.c:3181:             return;
	b	.L974		@
.L978:
@ Data/FE6_FE7.c:3176:             return;
	movs	r3, #60	@ _11,
@ Data/FE6_FE7.c:3174:             *outValue = wexp - WPN_EXP_B;
	subs	r0, r0, #121	@ _2,
@ Data/FE6_FE7.c:3176:             return;
	b	.L974		@
.L977:
@ Data/FE6_FE7.c:3171:             return;
	movs	r3, #50	@ _11,
@ Data/FE6_FE7.c:3169:             *outValue = wexp - WPN_EXP_C;
	subs	r0, r0, #71	@ _2,
@ Data/FE6_FE7.c:3171:             return;
	b	.L974		@
.L976:
@ Data/FE6_FE7.c:3166:             return;
	movs	r3, #40	@ _11,
@ Data/FE6_FE7.c:3164:             *outValue = wexp - WPN_EXP_D;
	subs	r0, r0, #31	@ _2,
@ Data/FE6_FE7.c:3166:             return;
	b	.L974		@
	.size	NewGetWeaponExpProgressState, .-NewGetWeaponExpProgressState
	.global	__aeabi_idiv
	.align	1
	.p2align 2,,3
	.global	DebuggerDisplayWeaponExp
	.syntax unified
	.code	16
	.thumb_func
	.type	DebuggerDisplayWeaponExp, %function
DebuggerDisplayWeaponExp:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, r8	@,
	movs	r7, r3	@ wtype, tmp205
	push	{lr}	@
	movs	r4, r2	@ y, tmp204
	sub	sp, sp, #24	@,,
@ Data/FE6_FE7.c:3039:     UnpackUiBarPalette(BGPAL_WEXP_BAR);
	ldr	r3, .L985	@ tmp145,
@ Data/FE6_FE7.c:3037: {
	movs	r6, r0	@ num, tmp202
@ Data/FE6_FE7.c:3039:     UnpackUiBarPalette(BGPAL_WEXP_BAR);
	movs	r0, #2	@,
@ Data/FE6_FE7.c:3037: {
	movs	r5, r1	@ x, tmp203
@ Data/FE6_FE7.c:3039:     UnpackUiBarPalette(BGPAL_WEXP_BAR);
	bl	.L17		@
@ Data/FE6_FE7.c:3044:     DrawIcon(
	ldr	r3, .L985+4	@ tmp189,
	movs	r1, r7	@ wtype, wtype
	mov	r8, r3	@ tmp189, tmp189
	movs	r2, #160	@,
@ Data/FE6_FE7.c:3045:         gBG0TilemapBuffer + TILEMAP_INDEX(x, y),
	lsls	r4, r4, #5	@ _1, y,
	adds	r0, r4, r5	@ tmp148, _1, x
@ Data/FE6_FE7.c:3045:         gBG0TilemapBuffer + TILEMAP_INDEX(x, y),
	lsls	r0, r0, #1	@ tmp149, tmp148,
@ Data/FE6_FE7.c:3044:     DrawIcon(
	ldr	r3, .L985+8	@ tmp152,
	adds	r1, r1, #112	@ wtype,
	add	r0, r0, r8	@ tmp150, tmp189
	lsls	r2, r2, #7	@,,
	bl	.L17		@
@ Data/FE6_FE7.c:3051:     color = wexp >= WPN_EXP_S ? TEXT_COLOR_SYSTEM_GREEN : TEXT_COLOR_SYSTEM_BLUE;
	ldr	r3, [sp, #48]	@ tmp220, wexp
@ Data/FE6_FE7.c:3051:     color = wexp >= WPN_EXP_S ? TEXT_COLOR_SYSTEM_GREEN : TEXT_COLOR_SYSTEM_BLUE;
	movs	r7, #2	@ iftmp.95_27,
@ Data/FE6_FE7.c:3051:     color = wexp >= WPN_EXP_S ? TEXT_COLOR_SYSTEM_GREEN : TEXT_COLOR_SYSTEM_BLUE;
	cmp	r3, #250	@ tmp220,
	ble	.L983		@,
@ Data/FE6_FE7.c:3051:     color = wexp >= WPN_EXP_S ? TEXT_COLOR_SYSTEM_GREEN : TEXT_COLOR_SYSTEM_BLUE;
	adds	r7, r7, #2	@ iftmp.95_27,
.L983:
@ Data/FE6_FE7.c:3054:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	ldr	r0, [sp, #48]	@, wexp
	ldr	r3, .L985+12	@ tmp153,
	bl	.L17		@
@ Data/FE6_FE7.c:3054:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	movs	r3, r5	@ tmp154, x
	adds	r3, r3, #8	@ tmp154,
	adds	r3, r3, r4	@ tmp155, tmp154, _1
@ Data/FE6_FE7.c:3054:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	lsls	r3, r3, #1	@ tmp156, tmp155,
@ Data/FE6_FE7.c:3054:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	add	r3, r3, r8	@ tmp156, tmp189
	movs	r2, r0	@ _12, tmp206
@ Data/FE6_FE7.c:3054:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	movs	r1, r7	@, iftmp.95_27
@ Data/FE6_FE7.c:3054:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	movs	r0, r3	@ tmp157, tmp156
@ Data/FE6_FE7.c:3054:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	ldr	r3, .L985+16	@ tmp159,
	bl	.L17		@
@ Data/FE6_FE7.c:3059:         0x180 + num * 6, 5, gBG2TilemapBuffer + TILEMAP_INDEX(x + 2, y + 1), TILEREF(0, BGPAL_WEXP_BAR), 0x22,
	adds	r4, r4, r5	@ tmp164, _1, x
@ Data/FE6_FE7.c:3056:     NewGetWeaponExpProgressState(wexp, &progress, &progressMax);
	add	r2, sp, #20	@,,
	ldr	r0, [sp, #48]	@, wexp
	add	r1, sp, #16	@,,
	bl	NewGetWeaponExpProgressState		@
@ Data/FE6_FE7.c:3059:         0x180 + num * 6, 5, gBG2TilemapBuffer + TILEMAP_INDEX(x + 2, y + 1), TILEREF(0, BGPAL_WEXP_BAR), 0x22,
	adds	r4, r4, #38	@ tmp165,
@ Data/FE6_FE7.c:3058:     DrawStatBarGfx(
	ldr	r3, .L985+20	@ tmp168,
@ Data/FE6_FE7.c:3059:         0x180 + num * 6, 5, gBG2TilemapBuffer + TILEMAP_INDEX(x + 2, y + 1), TILEREF(0, BGPAL_WEXP_BAR), 0x22,
	lsls	r4, r4, #1	@ tmp166, tmp165,
@ Data/FE6_FE7.c:3058:     DrawStatBarGfx(
	adds	r4, r4, r3	@ tmp167, tmp166, tmp168
	movs	r3, #0	@ tmp174,
	str	r3, [sp, #8]	@ tmp174,
@ Data/FE6_FE7.c:3060:         (progress * 34) / (progressMax - 1), 0);
	ldr	r3, [sp, #16]	@ progress, progress
@ Data/FE6_FE7.c:3060:         (progress * 34) / (progressMax - 1), 0);
	ldr	r1, [sp, #20]	@ progressMax, progressMax
@ Data/FE6_FE7.c:3060:         (progress * 34) / (progressMax - 1), 0);
	lsls	r0, r3, #4	@ tmp177, progress,
	adds	r0, r0, r3	@ tmp178, tmp177, progress
@ Data/FE6_FE7.c:3060:         (progress * 34) / (progressMax - 1), 0);
	subs	r1, r1, #1	@ tmp180,
@ Data/FE6_FE7.c:3058:     DrawStatBarGfx(
	ldr	r3, .L985+24	@ tmp185,
@ Data/FE6_FE7.c:3060:         (progress * 34) / (progressMax - 1), 0);
	lsls	r0, r0, #1	@ tmp179, tmp178,
@ Data/FE6_FE7.c:3058:     DrawStatBarGfx(
	bl	.L17		@
	movs	r3, #34	@ tmp187,
	str	r3, [sp]	@ tmp187,
	movs	r3, #128	@,
@ Data/FE6_FE7.c:3059:         0x180 + num * 6, 5, gBG2TilemapBuffer + TILEMAP_INDEX(x + 2, y + 1), TILEREF(0, BGPAL_WEXP_BAR), 0x22,
	lsls	r5, r6, #1	@ tmp170, num,
	adds	r5, r5, r6	@ tmp171, tmp170, num
	lsls	r5, r5, #1	@ tmp172, tmp171,
@ Data/FE6_FE7.c:3058:     DrawStatBarGfx(
	adds	r5, r5, #129	@ tmp173,
	adds	r5, r5, #255	@ tmp173,
	movs	r2, r4	@, tmp167
	str	r0, [sp, #4]	@ tmp207,
	movs	r1, #5	@,
	movs	r0, r5	@, tmp173
	ldr	r4, .L985+28	@ tmp188,
	lsls	r3, r3, #6	@,,
	bl	.L27		@
@ Data/FE6_FE7.c:3061: }
	add	sp, sp, #24	@,,
	@ sp needed	@
	pop	{r7}
	mov	r8, r7
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L986:
	.align	2
.L985:
	.word	UnpackUiBarPalette
	.word	gBG0TilemapBuffer
	.word	DrawIcon
	.word	GetDisplayRankStringFromExp
	.word	PutSpecialChar
	.word	gBG2TilemapBuffer
	.word	__aeabi_idiv
	.word	DrawStatBarGfx
	.size	DebuggerDisplayWeaponExp, .-DebuggerDisplayWeaponExp
	.align	1
	.p2align 2,,3
	.global	RedrawUnitWExpMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	RedrawUnitWExpMenu, %function
RedrawUnitWExpMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, r8	@,
	push	{lr}	@
@ Data/FE6_FE7.c:3065:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * WExpOptions, 0);
	ldr	r5, .L990	@ tmp129,
@ Data/FE6_FE7.c:3064: {
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:3065:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * WExpOptions, 0);
	movs	r2, #16	@,
	movs	r1, #9	@,
@ Data/FE6_FE7.c:3064: {
	movs	r6, r0	@ proc, tmp184
@ Data/FE6_FE7.c:3065:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * WExpOptions, 0);
	movs	r3, #0	@,
	movs	r0, r5	@, tmp129
	ldr	r4, .L990+4	@ tmp130,
	bl	.L27		@
@ Data/FE6_FE7.c:3066:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT);
	ldr	r3, .L990+8	@ tmp183,
	movs	r0, #3	@,
	mov	r8, r3	@ tmp183, tmp183
	bl	.L17		@
@ Data/FE6_FE7.c:3067:     gLCDControlBuffer.bg1cnt.priority = 1;
	movs	r1, #3	@ tmp138,
	movs	r0, #1	@ tmp140,
	ldr	r2, .L990+12	@ tmp132,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp137, tmp138
	orrs	r3, r0	@ tmp142, tmp140
	strb	r3, [r2, #16]	@ tmp142, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3068:     gLCDControlBuffer.bg2cnt.priority = 0;
	ldrb	r3, [r2, #20]	@ gLCDControlBuffer.bg2cnt.priority, gLCDControlBuffer.bg2cnt.priority
	bics	r3, r1	@ tmp149, tmp138
@ Data/FE6_FE7.c:3076:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r1, r5	@ tmp152, tmp129
	ldr	r4, .L990+16	@ tmp153,
	ldr	r7, .L990+20	@ tmp154,
	movs	r0, r4	@, tmp153
	subs	r1, r1, #14	@ tmp152,
@ Data/FE6_FE7.c:3068:     gLCDControlBuffer.bg2cnt.priority = 0;
	strb	r3, [r2, #20]	@ tmp149, gLCDControlBuffer.bg2cnt.priority
@ Data/FE6_FE7.c:3076:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	bl	.L145		@
@ Data/FE6_FE7.c:3078:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r1, r5	@ tmp155, tmp129
	movs	r0, r4	@ tmp156, tmp153
	adds	r1, r1, #114	@ tmp155,
	adds	r0, r0, #8	@ tmp156,
	bl	.L145		@
@ Data/FE6_FE7.c:3080:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r1, r5	@ tmp158, tmp129
	movs	r0, r4	@ tmp159, tmp153
	adds	r1, r1, #242	@ tmp158,
	adds	r0, r0, #16	@ tmp159,
	bl	.L145		@
@ Data/FE6_FE7.c:3082:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r1, r5	@ tmp161, tmp129
	movs	r0, r4	@ tmp162, tmp153
	adds	r1, r1, #115	@ tmp161,
	adds	r1, r1, #255	@ tmp161,
	adds	r0, r0, #24	@ tmp162,
	bl	.L145		@
@ Data/FE6_FE7.c:3084:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r1, r5	@ tmp164, tmp129
	movs	r0, r4	@ tmp165, tmp153
	adds	r1, r1, #243	@ tmp164,
	adds	r1, r1, #255	@ tmp164,
	adds	r0, r0, #32	@ tmp165,
	bl	.L145		@
@ Data/FE6_FE7.c:3086:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r0, r4	@ tmp168, tmp153
	ldr	r3, .L990+24	@ tmp200,
	adds	r0, r0, #40	@ tmp168,
	adds	r1, r5, r3	@ tmp167, tmp129, tmp200
	bl	.L145		@
@ Data/FE6_FE7.c:3088:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r0, r4	@ tmp171, tmp153
	ldr	r3, .L990+28	@ tmp202,
	adds	r0, r0, #48	@ tmp171,
	adds	r1, r5, r3	@ tmp170, tmp129, tmp202
	bl	.L145		@
@ Data/FE6_FE7.c:3090:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r0, r4	@ tmp153, tmp153
@ Data/FE6_FE7.c:3093:     for (int i = 0; i < WExpOptions; ++i)
	movs	r4, #0	@ _1,
@ Data/FE6_FE7.c:3090:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	ldr	r3, .L990+32	@ tmp204,
	adds	r0, r0, #56	@ tmp153,
	adds	r1, r5, r3	@ tmp173, tmp129, tmp204
	bl	.L145		@
	ldr	r7, .L990+36	@ tmp182,
	adds	r6, r6, #64	@ ivtmp.952,
	adds	r5, r5, #8	@ ivtmp.956,
.L988:
	movs	r0, r4	@ i, _1
@ Data/FE6_FE7.c:3095:         DebuggerDisplayWeaponExp(
	movs	r1, #0	@ tmp188,
	ldrsh	r3, [r6, r1]	@ MEM[(short int *)_42], ivtmp.952, tmp188
@ Data/FE6_FE7.c:3096:             i, x - 2, Y_HAND + (i * 2), i,
	adds	r4, r4, #1	@ _1,
@ Data/FE6_FE7.c:3095:         DebuggerDisplayWeaponExp(
	movs	r1, #6	@,
	str	r3, [sp]	@ MEM[(short int *)_42],
	lsls	r2, r4, #1	@ tmp176, _1,
	movs	r3, r0	@, i
	bl	DebuggerDisplayWeaponExp		@
@ Data/FE6_FE7.c:3098:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	movs	r0, r5	@, ivtmp.956
	movs	r3, #0	@ tmp189,
	ldrsh	r2, [r6, r3]	@ MEM[(short int *)_42], ivtmp.952, tmp189
	movs	r1, #3	@,
	bl	.L145		@
@ Data/FE6_FE7.c:3093:     for (int i = 0; i < WExpOptions; ++i)
	adds	r6, r6, #2	@ ivtmp.952,
	adds	r5, r5, #128	@ ivtmp.956,
	cmp	r4, #8	@ _1,
	bne	.L988		@,
@ Data/FE6_FE7.c:3101:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp180,
	movs	r2, #0	@,
	movs	r1, #1	@,
	str	r3, [sp]	@ tmp180,
	movs	r0, #0	@,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3104:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT);
	movs	r0, #3	@,
	bl	.L193		@
@ Data/FE6_FE7.c:3105: }
	add	sp, sp, #8	@,,
	@ sp needed	@
	pop	{r7}
	mov	r8, r7
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L991:
	.align	2
.L990:
	.word	gBG0TilemapBuffer+158
	.word	TileMap_FillRect
	.word	BG_EnableSyncByMask
	.word	gLCDControlBuffer
	.word	gStatScreen+24
	.word	PutText
	.word	626
	.word	754
	.word	882
	.word	PutNumber
	.size	RedrawUnitWExpMenu, .-RedrawUnitWExpMenu
	.align	1
	.p2align 2,,3
	.global	EditWExpInit
	.syntax unified
	.code	16
	.thumb_func
	.type	EditWExpInit, %function
EditWExpInit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, fp	@,
	mov	r6, r9	@,
	mov	r5, r8	@,
	mov	r7, r10	@,
	mov	r9, r0	@ proc, tmp168
	push	{r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:2994:     LoadIconPalettes(4);
	ldr	r3, .L999	@ tmp137,
@ Data/FE6_FE7.c:2993: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:2994:     LoadIconPalettes(4);
	movs	r0, #4	@,
	bl	.L17		@
@ Data/FE6_FE7.c:385:     ResetTextFont();
	ldr	r6, .L999+4	@ tmp138,
	bl	.L38		@
@ Data/FE6_FE7.c:386:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	ldr	r5, .L999+8	@ tmp139,
	bl	.L28		@
@ Data/FE6_FE7.c:389:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r3, .L999+12	@ tmp141,
	ldr	r0, .L999+16	@ tmp140,
	bl	.L17		@
@ Data/FE6_FE7.c:390:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	ldr	r4, .L999+20	@ tmp162,
	bl	.L27		@
@ Data/FE6_FE7.c:391:     ResetTextFont();
	bl	.L38		@
@ Data/FE6_FE7.c:392:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L28		@
@ Data/FE6_FE7.c:393:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L999+24	@ tmp145,
	bl	.L17		@
@ Data/FE6_FE7.c:394:     ClearBg0Bg1();
	ldr	r3, .L999+28	@ tmp146,
	bl	.L17		@
@ Data/FE6_FE7.c:395:     ResetText();
	ldr	r3, .L999+32	@ tmp147,
	bl	.L17		@
	mov	r3, r9	@ proc, proc
	mov	r0, r9	@ _76, proc
	ldr	r2, [r3, #60]	@ proc_18(D)->unit, proc_18(D)->unit
	adds	r0, r0, #80	@ _76,
	adds	r2, r2, #40	@ ivtmp.987,
	adds	r3, r3, #64	@ ivtmp.989,
.L993:
@ Data/FE6_FE7.c:3002:         proc->tmp[i] = unit->ranks[i];
	ldrb	r1, [r2]	@ MEM[(unsigned char *)_73], MEM[(unsigned char *)_73]
	strh	r1, [r3]	@ MEM[(unsigned char *)_73], MEM[(short int *)_74]
@ Data/FE6_FE7.c:3000:     for (int i = 0; i < WExpOptions; ++i)
	adds	r3, r3, #2	@ ivtmp.989,
	adds	r2, r2, #1	@ ivtmp.987,
	cmp	r3, r0	@ ivtmp.989, _76
	bne	.L993		@,
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	movs	r3, #0	@ tmp151,
	movs	r2, #16	@,
	movs	r1, #1	@,
	movs	r0, #5	@,
	str	r3, [sp]	@ tmp151,
	ldr	r5, .L999+36	@ tmp152,
	adds	r3, r3, #18	@,
	bl	.L28		@
@ Data/FE6_FE7.c:3013:     BG_EnableSyncByMask(BG2_SYNC_BIT);
	movs	r0, #4	@,
	bl	.L27		@
	ldr	r5, .L999+40	@ ivtmp.970,
	movs	r7, r5	@ _64, ivtmp.970
	movs	r4, r5	@ ivtmp.979, ivtmp.970
	ldr	r6, .L999+44	@ tmp163,
	adds	r7, r7, #120	@ _64,
.L994:
@ Data/FE6_FE7.c:3019:         InitText(&th[i], WExpWidth);
	movs	r0, r4	@, ivtmp.979
	movs	r1, #11	@,
@ Data/FE6_FE7.c:3017:     for (int i = 0; i < 15; ++i)
	adds	r4, r4, #8	@ ivtmp.979,
@ Data/FE6_FE7.c:3019:         InitText(&th[i], WExpWidth);
	bl	.L38		@
@ Data/FE6_FE7.c:3017:     for (int i = 0; i < 15; ++i)
	cmp	r4, r7	@ ivtmp.979, _64
	bne	.L994		@,
	ldr	r3, .L999+48	@ tmp164,
	mov	fp, r3	@ tmp164, tmp164
	ldr	r3, .L999+52	@ tmp165,
	mov	r10, r3	@ tmp165, tmp165
	ldr	r3, .L999+56	@ tmp166,
	mov	r8, r3	@ tmp166, tmp166
	ldr	r4, .L999+60	@ ivtmp.972,
	ldr	r7, .L999+64	@ tmp167,
@ Data/FE6_FE7.c:3021:     for (int i = 0; i < WExpOptions; ++i)
	ldr	r6, .L999+68	@ tmp161,
.L995:
@ Data/FE6_FE7.c:3023:         x = Text_GetCursor(&th[i]);
	movs	r0, r5	@, ivtmp.970
	bl	.L311		@
@ Data/FE6_FE7.c:3024:         x++;
	adds	r1, r0, #1	@ x, tmp169,
@ Data/FE6_FE7.c:3025:         Text_SetCursor(&th[i], x);
	movs	r0, r5	@, ivtmp.970
	bl	.L310		@
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	movs	r0, r4	@, ivtmp.972
	bl	.L193		@
@ Data/FE6_FE7.c:3021:     for (int i = 0; i < WExpOptions; ++i)
	adds	r4, r4, #1	@ ivtmp.972,
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	movs	r1, r0	@ _33, tmp170
@ Data/FE6_FE7.c:3027:         Text_DrawString(&th[i], GetStringFromIndexSafe(wexpText + i));
	movs	r0, r5	@, ivtmp.970
	bl	.L145		@
@ Data/FE6_FE7.c:3021:     for (int i = 0; i < WExpOptions; ++i)
	adds	r5, r5, #8	@ ivtmp.970,
	cmp	r4, r6	@ ivtmp.972, tmp161
	bne	.L995		@,
@ Data/FE6_FE7.c:3032:     RedrawUnitWExpMenu(proc);
	mov	r0, r9	@, proc
	bl	RedrawUnitWExpMenu		@
@ Data/FE6_FE7.c:3033: }
	add	sp, sp, #12	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	mov	fp, r7
	mov	r10, r6
	mov	r9, r5
	mov	r8, r4
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1000:
	.align	2
.L999:
	.word	LoadIconPalettes
	.word	ResetTextFont
	.word	SetTextFontGlyphs
	.word	BG_Fill
	.word	gBG0TilemapBuffer
	.word	BG_EnableSyncByMask
	.word	SetTextFont
	.word	ClearBg0Bg1
	.word	ResetText
	.word	PutUiWindowFrame
	.word	gStatScreen+24
	.word	InitText
	.word	Text_GetCursor
	.word	Text_SetCursor
	.word	GetStringFromIndex
	.word	4369
	.word	Text_DrawString
	.word	4377
	.size	EditWExpInit, .-EditWExpInit
	.align	1
	.p2align 2,,3
	.global	EditWExpIdle
	.syntax unified
	.code	16
	.thumb_func
	.type	EditWExpIdle, %function
EditWExpIdle:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, r8	@,
	push	{lr}	@
@ Data/FE6_FE7.c:3196:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L1071	@ tmp198,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r6, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:3192: {
	movs	r4, r0	@ proc, tmp418
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:3197:     if (keys & B_BUTTON)
	lsls	r3, r6, #30	@ tmp419, keys,
	bpl	.LCB7339	@
	b	.L1065	@long jump	@
.LCB7339:
.L1002:
@ Data/FE6_FE7.c:3203:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp223,
	tst	r3, r6	@ tmp223, keys
	beq	.L1003		@,
	movs	r3, r4	@ ivtmp.1008, proc
	movs	r0, r4	@ _7, proc
	ldr	r2, [r4, #60]	@ proc_82(D)->unit, proc_82(D)->unit
	adds	r3, r3, #64	@ ivtmp.1008,
	adds	r2, r2, #40	@ ivtmp.1010,
	adds	r0, r0, #80	@ _7,
.L1004:
@ Data/FE6_FE7.c:3112:         unit->ranks[i] = proc->tmp[i];
	ldrh	r1, [r3]	@ MEM[(short int *)_52], MEM[(short int *)_52]
@ Data/FE6_FE7.c:3110:     for (int i = 0; i < WExpOptions; ++i)
	adds	r3, r3, #2	@ ivtmp.1008,
@ Data/FE6_FE7.c:3112:         unit->ranks[i] = proc->tmp[i];
	strb	r1, [r2]	@ MEM[(short int *)_52], MEM[(unsigned char *)_53]
@ Data/FE6_FE7.c:3110:     for (int i = 0; i < WExpOptions; ++i)
	adds	r2, r2, #1	@ ivtmp.1010,
	cmp	r0, r3	@ _7, ivtmp.1008
	bne	.L1004		@,
@ Data/FE6_FE7.c:3118:     gLCDControlBuffer.bg1cnt.priority = 0;
	movs	r1, #3	@ tmp237,
	ldr	r2, .L1071+4	@ tmp231,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp236, tmp237
	strb	r3, [r2, #16]	@ tmp236, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3119:     SetBackgroundTileDataOffset(2, 0);
	movs	r1, #0	@,
	movs	r0, #2	@,
	ldr	r3, .L1071+8	@ tmp239,
	bl	.L17		@
@ Data/FE6_FE7.c:3120:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp240,
	movs	r2, #0	@,
	movs	r1, #1	@,
	movs	r0, #0	@,
	str	r3, [sp]	@ tmp240,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3121:     BG_Fill(gBG2TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1071+12	@ tmp241,
	ldr	r3, .L1071+16	@ tmp242,
	bl	.L17		@
@ Data/FE6_FE7.c:3122:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT);
	movs	r0, #7	@,
	ldr	r3, .L1071+20	@ tmp243,
	bl	.L17		@
@ Data/FE6_FE7.c:3207:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L1071+24	@ tmp244,
	bl	.L17		@
.L1003:
@ Data/FE6_FE7.c:3212:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r2, #48	@ tmp251,
@ Data/FE6_FE7.c:3210:     if (proc->editing)
	movs	r5, #46	@ tmp245,
	movs	r7, #16	@ tmp249,
@ Data/FE6_FE7.c:3212:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r2]	@ tmp252,
@ Data/FE6_FE7.c:3210:     if (proc->editing)
	ldrsb	r3, [r4, r5]	@ _2,
@ Data/FE6_FE7.c:3212:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r1, #1	@ tmp253,
	ands	r7, r6	@ _106, keys
@ Data/FE6_FE7.c:3212:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ _155, tmp253,
@ Data/FE6_FE7.c:3210:     if (proc->editing)
	cmp	r3, #0	@ _2,
	bne	.LCB7400	@
	b	.L1005	@long jump	@
.LCB7400:
@ Data/FE6_FE7.c:3212:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r2, r2, #1	@ tmp255,
	ldrsb	r2, [r4, r2]	@ tmp256,
@ Data/FE6_FE7.c:3212:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r3, .L1071+28	@ tmp254,
	lsls	r2, r2, #3	@ tmp257, tmp256,
	adds	r3, r3, r2	@ tmp258, tmp254, tmp257
@ Data/FE6_FE7.c:3212:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r0, [r3, #120]	@ CursorLocationTable[_4].x, CursorLocationTable[_4].x
	bl	DisplayVertUiHand		@
	ldr	r3, .L1071+32	@ tmp405,
@ Data/FE6_FE7.c:525:     int result = 1;
	subs	r5, r5, #45	@ result,
	mov	r8, r3	@ tmp405, tmp405
	adds	r3, r3, #76	@ ivtmp.1000,
.L1006:
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	adds	r3, r3, #4	@ ivtmp.1000,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	subs	r1, r3, #4	@ tmp263, ivtmp.1000,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	ldr	r1, [r1]	@ MEM[(const int *)_98 + 4294967292B], MEM[(const int *)_98 + 4294967292B]
@ Data/FE6_FE7.c:528:         result++;
	adds	r5, r5, #1	@ result,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	cmp	r1, #250	@ MEM[(const int *)_98 + 4294967292B],
	ble	.L1006		@,
@ Data/FE6_FE7.c:530:     if (result > 9)
	cmp	r5, #9	@ _129,
	ble	.LCB7421	@
	b	.L1066	@long jump	@
.LCB7421:
@ Data/FE6_FE7.c:3217:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _106,
	beq	.L1008		@,
.L1070:
@ Data/FE6_FE7.c:3219:             if (proc->digit > 0)
	movs	r3, #49	@ tmp265,
	ldrsb	r3, [r4, r3]	@ _11,
@ Data/FE6_FE7.c:3219:             if (proc->digit > 0)
	cmp	r3, #0	@ _11,
	bgt	.LCB7428	@
	b	.L1009	@long jump	@
.LCB7428:
@ Data/FE6_FE7.c:3221:                 proc->digit--;
	subs	r3, r3, #1	@ tmp269,
	lsls	r3, r3, #24	@ tmp270, tmp269,
	asrs	r3, r3, #24	@ _15, tmp270,
.L1010:
	movs	r2, #49	@ tmp277,
@ Data/FE6_FE7.c:3228:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _15, proc_82(D)->digit
	bl	RedrawUnitWExpMenu		@
.L1008:
@ Data/FE6_FE7.c:3230:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp420, keys,
	bpl	.L1011		@,
@ Data/FE6_FE7.c:3232:             if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp286,
	ldrsb	r3, [r4, r3]	@ _19,
@ Data/FE6_FE7.c:3232:             if (proc->digit < (max_digits - 1))
	subs	r5, r5, #1	@ tmp287,
@ Data/FE6_FE7.c:3232:             if (proc->digit < (max_digits - 1))
	cmp	r3, r5	@ _19, tmp287
	bge	.LCB7450	@
	b	.L1067	@long jump	@
.LCB7450:
@ Data/FE6_FE7.c:3239:                 proc->editing = false;
	movs	r3, #46	@ tmp291,
	movs	r2, #0	@ tmp292,
	strb	r2, [r4, r3]	@ tmp292, proc_82(D)->editing
@ Data/FE6_FE7.c:3238:                 proc->digit = 0;
	movs	r3, #0	@ _25,
.L1013:
	movs	r2, #49	@ tmp294,
@ Data/FE6_FE7.c:3241:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _25, proc_82(D)->digit
	bl	RedrawUnitWExpMenu		@
.L1011:
@ Data/FE6_FE7.c:3244:         if (keys & DPAD_UP)
	movs	r3, #64	@ tmp297,
	tst	r3, r6	@ tmp297, keys
	beq	.L1014		@,
@ Data/FE6_FE7.c:3246:             if (proc->tmp[proc->id] == max)
	movs	r2, #48	@ tmp303,
	ldrsb	r1, [r4, r2]	@ tmp304,
	lsls	r1, r1, #1	@ tmp305, tmp304,
	adds	r1, r4, r1	@ _149, proc, tmp305
@ Data/FE6_FE7.c:3246:             if (proc->tmp[proc->id] == max)
	ldrsh	r2, [r1, r3]	@ _28, MEM <s16> [(struct DebuggerProc *)_149 + 64B]
@ Data/FE6_FE7.c:3246:             if (proc->tmp[proc->id] == max)
	cmp	r2, #251	@ _28,
	bne	.LCB7475	@
	b	.L1027	@long jump	@
.LCB7475:
@ Data/FE6_FE7.c:3252:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	movs	r3, #49	@ tmp309,
	ldrsb	r3, [r4, r3]	@ tmp310,
@ Data/FE6_FE7.c:3252:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp311, tmp310,
	add	r3, r3, r8	@ tmp312, tmp405
@ Data/FE6_FE7.c:3252:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_31], DigitDecimalTable[_31]
	adds	r3, r3, r2	@ tmp317, DigitDecimalTable[_31], _28
@ Data/FE6_FE7.c:3253:                 if (proc->tmp[proc->id] > max)
	adds	r2, r3, #0	@ tmp307, tmp317
	lsls	r3, r3, #16	@ tmp320, tmp317,
	asrs	r3, r3, #16	@ tmp320, tmp320,
	cmp	r3, #251	@ tmp320,
	ble	.L1016		@,
	movs	r2, #251	@ tmp307,
.L1016:
	lsls	r3, r2, #16	@ _27, tmp307,
	asrs	r3, r3, #16	@ _27, _27,
.L1015:
@ Data/FE6_FE7.c:3248:                 proc->tmp[proc->id] = min;
	movs	r2, #64	@ tmp322,
@ Data/FE6_FE7.c:3258:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3248:                 proc->tmp[proc->id] = min;
	strh	r3, [r1, r2]	@ _27, MEM <s16> [(struct DebuggerProc *)_149 + 64B]
@ Data/FE6_FE7.c:3258:             RedrawUnitWExpMenu(proc);
	bl	RedrawUnitWExpMenu		@
.L1014:
@ Data/FE6_FE7.c:3260:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp421, keys,
	bpl	.L1001		@,
@ Data/FE6_FE7.c:3263:             if (proc->tmp[proc->id] == min)
	movs	r3, #48	@ tmp331,
	ldrsb	r1, [r4, r3]	@ tmp332,
	lsls	r1, r1, #1	@ tmp333, tmp332,
@ Data/FE6_FE7.c:3263:             if (proc->tmp[proc->id] == min)
	adds	r3, r3, #16	@ tmp334,
	adds	r1, r4, r1	@ _158, proc, tmp333
	ldrsh	r2, [r1, r3]	@ _39, MEM <s16> [(struct DebuggerProc *)_158 + 64B]
	movs	r3, #251	@ _8,
@ Data/FE6_FE7.c:3263:             if (proc->tmp[proc->id] == min)
	cmp	r2, #0	@ _39,
	bne	.L1068		@,
@ Data/FE6_FE7.c:3265:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp350,
@ Data/FE6_FE7.c:3276:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3265:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _8, MEM <s16> [(struct DebuggerProc *)_158 + 64B]
@ Data/FE6_FE7.c:3276:             RedrawUnitWExpMenu(proc);
	bl	RedrawUnitWExpMenu		@
.L1001:
@ Data/FE6_FE7.c:3313: }
	add	sp, sp, #8	@,,
	@ sp needed	@
	pop	{r7}
	mov	r8, r7
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1005:
@ Data/FE6_FE7.c:3281:         DisplayUiHand(CursorLocationTable[0].x - ((WExpWidth + 2) * 8), (Y_HAND + (proc->id * 2)) * 8);
	movs	r0, #44	@,
	ldr	r3, .L1071+36	@ tmp352,
	bl	.L17		@
@ Data/FE6_FE7.c:3282:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _106,
	beq	.L1021		@,
@ Data/FE6_FE7.c:3284:             proc->digit = 1;
	movs	r3, #1	@ tmp354,
	movs	r2, #49	@ tmp353,
	strb	r3, [r4, r2]	@ tmp354, proc_82(D)->digit
@ Data/FE6_FE7.c:3285:             proc->editing = true;
	strb	r3, [r4, r5]	@ tmp354, proc_82(D)->editing
.L1021:
@ Data/FE6_FE7.c:3287:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp422, keys,
	bpl	.L1022		@,
@ Data/FE6_FE7.c:3289:             proc->digit = 0;
	movs	r3, #49	@ tmp366,
	movs	r2, #0	@ tmp367,
	strb	r2, [r4, r3]	@ tmp367, proc_82(D)->digit
@ Data/FE6_FE7.c:3290:             proc->editing = true;
	subs	r3, r3, #3	@ tmp369,
	adds	r2, r2, #1	@ tmp370,
	strb	r2, [r4, r3]	@ tmp370, proc_82(D)->editing
.L1022:
@ Data/FE6_FE7.c:3293:         if (keys & DPAD_UP)
	lsls	r3, r6, #25	@ tmp423, keys,
	bpl	.L1023		@,
@ Data/FE6_FE7.c:3295:             proc->id--;
	movs	r3, #48	@ tmp379,
@ Data/FE6_FE7.c:3295:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp381,
	subs	r3, r3, #1	@ tmp382,
	lsls	r3, r3, #24	@ tmp383, tmp382,
	asrs	r2, r3, #24	@ _58, tmp383,
@ Data/FE6_FE7.c:3296:             if (proc->id < 0)
	cmp	r3, #0	@ tmp383,
	blt	.L1069		@,
	movs	r3, #48	@ tmp387,
@ Data/FE6_FE7.c:3300:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _58, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitWExpMenu		@
.L1023:
@ Data/FE6_FE7.c:3302:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp424, keys,
	bpl	.L1001		@,
@ Data/FE6_FE7.c:3304:             proc->id++;
	movs	r1, #48	@ tmp396,
@ Data/FE6_FE7.c:3307:                 proc->id = 0;
	movs	r0, #7	@ tmp408,
	movs	r5, #0	@ tmp410,
@ Data/FE6_FE7.c:3304:             proc->id++;
	ldrb	r3, [r4, r1]	@ tmp398,
	adds	r3, r3, #1	@ tmp399,
	lsls	r3, r3, #24	@ tmp400, tmp399,
	asrs	r2, r3, #24	@ _63, tmp400,
@ Data/FE6_FE7.c:3307:                 proc->id = 0;
	lsrs	r3, r3, #31	@ tmp409, tmp400,
	cmp	r0, r2	@ tmp408, _63
	adcs	r3, r3, r5	@ tmp407, tmp409, tmp410
	rsbs	r3, r3, #0	@ tmp411, tmp407
	ands	r2, r3	@ _63, tmp411
@ Data/FE6_FE7.c:3310:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r1]	@ _63, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitWExpMenu		@
@ Data/FE6_FE7.c:3313: }
	b	.L1001		@
.L1066:
@ Data/FE6_FE7.c:530:     if (result > 9)
	movs	r5, #9	@ _129,
@ Data/FE6_FE7.c:3217:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _106,
	bne	.LCB7604	@
	b	.L1008	@long jump	@
.LCB7604:
	b	.L1070		@
.L1065:
@ Data/FE6_FE7.c:3118:     gLCDControlBuffer.bg1cnt.priority = 0;
	movs	r1, #3	@ tmp212,
	ldr	r2, .L1071+4	@ tmp206,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp211, tmp212
	strb	r3, [r2, #16]	@ tmp211, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3119:     SetBackgroundTileDataOffset(2, 0);
	movs	r1, #0	@,
	movs	r0, #2	@,
	ldr	r3, .L1071+8	@ tmp214,
	bl	.L17		@
@ Data/FE6_FE7.c:3120:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp215,
	movs	r2, #0	@,
	str	r3, [sp]	@ tmp215,
	movs	r1, #1	@,
	movs	r0, #0	@,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3121:     BG_Fill(gBG2TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1071+12	@ tmp216,
	ldr	r3, .L1071+16	@ tmp217,
	bl	.L17		@
@ Data/FE6_FE7.c:3122:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT);
	movs	r0, #7	@,
	ldr	r3, .L1071+20	@ tmp218,
	bl	.L17		@
@ Data/FE6_FE7.c:3200:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L1071+24	@ tmp219,
	bl	.L17		@
@ Data/FE6_FE7.c:563: }
	b	.L1002		@
.L1068:
@ Data/FE6_FE7.c:3269:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	subs	r3, r3, #202	@ tmp337,
	ldrsb	r3, [r4, r3]	@ tmp338,
@ Data/FE6_FE7.c:3269:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp339, tmp338,
	add	r3, r3, r8	@ tmp340, tmp405
@ Data/FE6_FE7.c:3269:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	ldr	r0, [r3, #68]	@ DigitDecimalTable[_42], DigitDecimalTable[_42]
	subs	r0, r2, r0	@ tmp345, _39, DigitDecimalTable[_42]
@ Data/FE6_FE7.c:3270:                 if (proc->tmp[proc->id] < min)
	lsls	r3, r0, #16	@ tmp348, tmp345,
	asrs	r3, r3, #16	@ tmp348, tmp348,
	mvns	r3, r3	@ tmp413, tmp348
@ Data/FE6_FE7.c:3265:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp350,
@ Data/FE6_FE7.c:3270:                 if (proc->tmp[proc->id] < min)
	asrs	r3, r3, #31	@ tmp417, tmp413,
	ands	r3, r0	@ tmp335, tmp345
	lsls	r3, r3, #16	@ _8, tmp335,
	asrs	r3, r3, #16	@ _8, _8,
@ Data/FE6_FE7.c:3276:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3265:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _8, MEM <s16> [(struct DebuggerProc *)_158 + 64B]
@ Data/FE6_FE7.c:3276:             RedrawUnitWExpMenu(proc);
	bl	RedrawUnitWExpMenu		@
	b	.L1001		@
.L1067:
@ Data/FE6_FE7.c:3234:                 proc->digit++;
	adds	r3, r3, #1	@ tmp289,
	lsls	r3, r3, #24	@ tmp290, tmp289,
	asrs	r3, r3, #24	@ _25, tmp290,
	b	.L1013		@
.L1069:
@ Data/FE6_FE7.c:3298:                 proc->id = WExpOptions - 1;
	movs	r2, #7	@ _58,
	movs	r3, #48	@ tmp387,
@ Data/FE6_FE7.c:3300:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _58, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitWExpMenu		@
	b	.L1023		@
.L1009:
@ Data/FE6_FE7.c:3226:                 proc->editing = false;
	movs	r2, #46	@ tmp274,
	movs	r1, #0	@ tmp275,
@ Data/FE6_FE7.c:3225:                 proc->digit = max_digits - 1;
	subs	r3, r5, #1	@ tmp272, _129,
	lsls	r3, r3, #24	@ tmp273, tmp272,
@ Data/FE6_FE7.c:3226:                 proc->editing = false;
	strb	r1, [r4, r2]	@ tmp275, proc_82(D)->editing
@ Data/FE6_FE7.c:3225:                 proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _15, tmp273,
	b	.L1010		@
.L1027:
	movs	r3, #0	@ _27,
	b	.L1015		@
.L1072:
	.align	2
.L1071:
	.word	gKeyStatusPtr
	.word	gLCDControlBuffer
	.word	SetBackgroundTileDataOffset
	.word	gBG2TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.word	Proc_Goto
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	DisplayUiHand
	.size	EditWExpIdle, .-EditWExpIdle
	.align	1
	.p2align 2,,3
	.global	RedrawUnitSupportsMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	RedrawUnitSupportsMenu, %function
RedrawUnitSupportsMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
	mov	lr, r9	@,
	mov	r7, r8	@,
@ Data/FE6_FE7.c:3388:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * SupportOptions, 0);
	ldr	r6, .L1078	@ tmp130,
@ Data/FE6_FE7.c:3387: {
	push	{r7, lr}	@
@ Data/FE6_FE7.c:3388:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * SupportOptions, 0);
	movs	r3, #0	@,
	movs	r2, #14	@,
	movs	r1, #9	@,
	ldr	r4, .L1078+4	@ tmp131,
@ Data/FE6_FE7.c:3387: {
	mov	r9, r0	@ proc, tmp141
@ Data/FE6_FE7.c:3388:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * SupportOptions, 0);
	movs	r0, r6	@, tmp130
	bl	.L27		@
@ Data/FE6_FE7.c:3389:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L1078+8	@ tmp138,
	movs	r0, #1	@,
	mov	r8, r3	@ tmp138, tmp138
	bl	.L17		@
	ldr	r3, .L1078+12	@ tmp146,
	mov	ip, r3	@ tmp146, tmp146
	ldr	r5, .L1078+16	@ ivtmp.1034,
	ldr	r7, .L1078+20	@ tmp139,
	subs	r4, r6, #6	@ ivtmp.1036, tmp130,
	add	r6, r6, ip	@ _54, tmp146
.L1074:
@ Data/FE6_FE7.c:3395:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	movs	r1, r4	@, ivtmp.1036
	movs	r0, r5	@, ivtmp.1034
@ Data/FE6_FE7.c:3393:     for (int i = 0; i < SupportOptions; ++i)
	adds	r4, r4, #128	@ ivtmp.1036,
@ Data/FE6_FE7.c:3395:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	bl	.L145		@
@ Data/FE6_FE7.c:3393:     for (int i = 0; i < SupportOptions; ++i)
	adds	r5, r5, #8	@ ivtmp.1034,
	cmp	r4, r6	@ ivtmp.1036, _54
	bne	.L1074		@,
	mov	r4, r9	@ ivtmp.1023, proc
	mov	r7, r9	@ proc, proc
	ldr	r5, .L1078+24	@ ivtmp.1025,
	ldr	r6, .L1078+28	@ tmp140,
	adds	r4, r4, #64	@ ivtmp.1023,
	adds	r7, r7, #78	@ proc,
.L1075:
@ Data/FE6_FE7.c:3400:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	movs	r0, r5	@, ivtmp.1025
	movs	r3, #0	@ tmp144,
	ldrsh	r2, [r4, r3]	@ MEM[(short int *)_42], ivtmp.1023, tmp144
	movs	r1, #3	@,
@ Data/FE6_FE7.c:3398:     for (int i = 0; i < SupportOptions; ++i)
	adds	r4, r4, #2	@ ivtmp.1023,
@ Data/FE6_FE7.c:3400:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	bl	.L38		@
@ Data/FE6_FE7.c:3398:     for (int i = 0; i < SupportOptions; ++i)
	adds	r5, r5, #128	@ ivtmp.1025,
	cmp	r4, r7	@ ivtmp.1023, _44
	bne	.L1075		@,
@ Data/FE6_FE7.c:3404: }
	@ sp needed	@
@ Data/FE6_FE7.c:3403:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	bl	.L193		@
@ Data/FE6_FE7.c:3404: }
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1079:
	.align	2
.L1078:
	.word	gBG0TilemapBuffer+158
	.word	TileMap_FillRect
	.word	BG_EnableSyncByMask
	.word	890
	.word	gStatScreen+24
	.word	PutText
	.word	gBG0TilemapBuffer+166
	.word	PutNumber
	.size	RedrawUnitSupportsMenu, .-RedrawUnitSupportsMenu
	.section	.rodata.str1.4
	.align	2
.LC564:
	.ascii	"\000"
	.text
	.align	1
	.p2align 2,,3
	.global	EditSupportsInit
	.syntax unified
	.code	16
	.thumb_func
	.type	EditSupportsInit, %function
EditSupportsInit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, fp	@,
	mov	r5, r8	@,
	mov	r7, r10	@,
	mov	r6, r9	@,
	mov	r8, r0	@ proc, tmp176
	push	{r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:385:     ResetTextFont();
	ldr	r5, .L1104	@ tmp143,
@ Data/FE6_FE7.c:3341: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:385:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:386:     SetTextFontGlyphs(0);
	ldr	r4, .L1104+4	@ tmp144,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:389:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1104+8	@ tmp145,
	ldr	r3, .L1104+12	@ tmp146,
	bl	.L17		@
@ Data/FE6_FE7.c:390:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L1104+16	@ tmp147,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:391:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:392:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:393:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L1104+20	@ tmp150,
	bl	.L17		@
@ Data/FE6_FE7.c:394:     ClearBg0Bg1();
	ldr	r3, .L1104+24	@ tmp151,
	bl	.L17		@
@ Data/FE6_FE7.c:395:     ResetText();
	ldr	r3, .L1104+28	@ tmp152,
	bl	.L17		@
@ Data/FE6_FE7.c:3343:     struct Unit * unit = proc->unit;
	mov	r3, r8	@ proc, proc
	ldr	r7, [r3, #60]	@ unit, proc_28(D)->unit
@ Data/FE6_FE7.c:3344:     u8 * row = GetUnitBwlSupportRow(unit);
	movs	r0, r7	@, unit
	bl	GetUnitBwlSupportRow		@
	mov	r2, r8	@ ivtmp.1075, proc
	movs	r3, r0	@ ivtmp.1077, row
	adds	r2, r2, #64	@ ivtmp.1075,
	adds	r4, r0, #7	@ _88, row,
	b	.L1082		@
.L1102:
@ Data/FE6_FE7.c:3347:         proc->tmp[i] = row ? row[i] : 0;
	ldrb	r1, [r3]	@ iftmp.107_21, MEM[(u8 *)_89]
@ Data/FE6_FE7.c:3345:     for (int i = 0; i < SupportOptions; ++i)
	adds	r3, r3, #1	@ ivtmp.1077,
@ Data/FE6_FE7.c:3347:         proc->tmp[i] = row ? row[i] : 0;
	strh	r1, [r2]	@ iftmp.107_21, MEM[(short int *)_86]
@ Data/FE6_FE7.c:3345:     for (int i = 0; i < SupportOptions; ++i)
	adds	r2, r2, #2	@ ivtmp.1075,
	cmp	r3, r4	@ ivtmp.1077, _88
	beq	.L1101		@,
.L1082:
@ Data/FE6_FE7.c:3347:         proc->tmp[i] = row ? row[i] : 0;
	cmp	r0, #0	@ row,
	bne	.L1102		@,
@ Data/FE6_FE7.c:3347:         proc->tmp[i] = row ? row[i] : 0;
	movs	r1, #0	@ iftmp.107_21,
@ Data/FE6_FE7.c:3345:     for (int i = 0; i < SupportOptions; ++i)
	adds	r3, r3, #1	@ ivtmp.1077,
@ Data/FE6_FE7.c:3347:         proc->tmp[i] = row ? row[i] : 0;
	strh	r1, [r2]	@ iftmp.107_21, MEM[(short int *)_86]
@ Data/FE6_FE7.c:3345:     for (int i = 0; i < SupportOptions; ++i)
	adds	r2, r2, #2	@ ivtmp.1075,
	cmp	r3, r4	@ ivtmp.1077, _88
	bne	.L1082		@,
.L1101:
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	movs	r3, #0	@ tmp156,
	ldr	r4, .L1104+32	@ tmp157,
	str	r3, [sp]	@ tmp156,
	movs	r2, #10	@,
	adds	r3, r3, #16	@,
	movs	r1, #1	@,
	movs	r0, #11	@,
	bl	.L27		@
	ldr	r3, .L1104+36	@ ivtmp.1056,
	mov	r10, r3	@ ivtmp.1056, ivtmp.1056
	movs	r3, #120	@ _78,
	add	r3, r3, r10	@ _78, ivtmp.1056
	mov	fp, r3	@ _78, _78
	ldr	r3, .L1104+40	@ tmp169,
	mov	r4, r10	@ ivtmp.1067, ivtmp.1056
	mov	r9, r3	@ tmp169, tmp169
	ldr	r6, .L1104+44	@ tmp170,
	ldr	r5, .L1104+48	@ tmp171,
.L1083:
@ Data/FE6_FE7.c:3367:         InitText(&th[i], SupportWidth);
	movs	r0, r4	@, ivtmp.1067
	movs	r1, #5	@,
	bl	.L139		@
@ Data/FE6_FE7.c:3368:         Text_DrawString(&th[i], "");
	movs	r0, r4	@, ivtmp.1067
	movs	r1, r6	@, tmp170
@ Data/FE6_FE7.c:3365:     for (int i = 0; i < 15; ++i)
	adds	r4, r4, #8	@ ivtmp.1067,
@ Data/FE6_FE7.c:3368:         Text_DrawString(&th[i], "");
	bl	.L28		@
@ Data/FE6_FE7.c:3365:     for (int i = 0; i < 15; ++i)
	cmp	r4, fp	@ ivtmp.1067, _78
	bne	.L1083		@,
@ Data/FE6_FE7.c:3371:     if (unit->pCharacterData->pSupportData)
	ldr	r3, [r7]	@ unit_30->pCharacterData, unit_30->pCharacterData
	ldr	r3, [r3, #44]	@ prephitmp_18, _7->pSupportData
@ Data/FE6_FE7.c:3371:     if (unit->pCharacterData->pSupportData)
	cmp	r3, #0	@ prephitmp_18,
	beq	.L1084		@,
@ Data/FE6_FE7.c:3379:                 Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(uid)->nameTextId));
	ldr	r2, .L1104+52	@ tmp172,
	mov	r9, r2	@ tmp172, tmp172
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	ldr	r2, .L1104+56	@ tmp174,
@ Data/FE6_FE7.c:3374:         for (int i = 0; i < SupportOptions; ++i)
	movs	r4, #0	@ i,
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	mov	fp, r2	@ tmp174, tmp174
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	ldr	r6, .L1104+60	@ _46,
	b	.L1087		@
.L1085:
@ Data/FE6_FE7.c:3374:         for (int i = 0; i < SupportOptions; ++i)
	movs	r3, #8	@ tmp190,
	mov	ip, r3	@ tmp190, tmp190
@ Data/FE6_FE7.c:3374:         for (int i = 0; i < SupportOptions; ++i)
	adds	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:3374:         for (int i = 0; i < SupportOptions; ++i)
	add	r10, r10, ip	@ ivtmp.1056, tmp190
	cmp	r4, #7	@ i,
	beq	.L1084		@,
.L1103:
@ Data/FE6_FE7.c:3376:             uid = unit->pCharacterData->pSupportData->characters[i];
	ldr	r3, [r7]	@ unit_30->pCharacterData, unit_30->pCharacterData
	ldr	r3, [r3, #44]	@ prephitmp_18, pretmp_19->pSupportData
.L1087:
@ Data/FE6_FE7.c:3376:             uid = unit->pCharacterData->pSupportData->characters[i];
	ldrb	r0, [r3, r4]	@ uid, *prephitmp_18
@ Data/FE6_FE7.c:3377:             if (uid)
	cmp	r0, #0	@ uid,
	beq	.L1085		@,
@ Data/FE6_FE7.c:3379:                 Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(uid)->nameTextId));
	bl	.L139		@
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	movs	r3, #128	@ tmp165,
@ Data/FE6_FE7.c:3379:                 Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(uid)->nameTextId));
	ldrh	r0, [r0]	@ _16, *_15
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	subs	r2, r0, #1	@ tmp164, _16,
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	movs	r1, r6	@ _46, _46
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	lsls	r3, r3, #7	@ tmp165, tmp165,
	cmp	r2, r3	@ tmp164, tmp165
	bcs	.L1086		@,
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	bl	.L311		@
	movs	r1, r0	@ _46, tmp179
.L1086:
@ Data/FE6_FE7.c:3379:                 Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(uid)->nameTextId));
	mov	r0, r10	@, ivtmp.1056
	bl	.L28		@
@ Data/FE6_FE7.c:3374:         for (int i = 0; i < SupportOptions; ++i)
	movs	r3, #8	@ tmp190,
	mov	ip, r3	@ tmp190, tmp190
@ Data/FE6_FE7.c:3374:         for (int i = 0; i < SupportOptions; ++i)
	adds	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:3374:         for (int i = 0; i < SupportOptions; ++i)
	add	r10, r10, ip	@ ivtmp.1056, tmp190
	cmp	r4, #7	@ i,
	bne	.L1103		@,
.L1084:
@ Data/FE6_FE7.c:3383:     RedrawUnitSupportsMenu(proc);
	mov	r0, r8	@, proc
	bl	RedrawUnitSupportsMenu		@
@ Data/FE6_FE7.c:3384: }
	add	sp, sp, #12	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	mov	fp, r7
	mov	r10, r6
	mov	r9, r5
	mov	r8, r4
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1105:
	.align	2
.L1104:
	.word	ResetTextFont
	.word	SetTextFontGlyphs
	.word	gBG0TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.word	SetTextFont
	.word	ClearBg0Bg1
	.word	ResetText
	.word	PutUiWindowFrame
	.word	gStatScreen+24
	.word	InitText
	.word	.LC564
	.word	Text_DrawString
	.word	GetCharacterData
	.word	GetStringFromIndex
	.word	BlankString
	.size	EditSupportsInit, .-EditSupportsInit
	.align	1
	.p2align 2,,3
	.global	EditSupportsIdle
	.syntax unified
	.code	16
	.thumb_func
	.type	EditSupportsIdle, %function
EditSupportsIdle:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, r8	@,
	push	{lr}	@
@ Data/FE6_FE7.c:3425:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L1179	@ tmp198,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r6, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:3421: {
	movs	r4, r0	@ proc, tmp392
@ Data/FE6_FE7.c:3426:     if (keys & B_BUTTON)
	lsls	r3, r6, #30	@ tmp394, keys,
	bpl	.LCB7982	@
	b	.L1172	@long jump	@
.LCB7982:
.L1107:
@ Data/FE6_FE7.c:3431:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp210,
	tst	r3, r6	@ tmp210, keys
	beq	.LCB7989	@
	b	.L1173	@long jump	@
.LCB7989:
.L1108:
@ Data/FE6_FE7.c:3439:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r2, #48	@ tmp225,
@ Data/FE6_FE7.c:3437:     if (proc->editing)
	movs	r5, #46	@ tmp219,
	movs	r7, #16	@ tmp223,
@ Data/FE6_FE7.c:3439:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r2]	@ tmp226,
@ Data/FE6_FE7.c:3437:     if (proc->editing)
	ldrsb	r3, [r4, r5]	@ _2,
@ Data/FE6_FE7.c:3439:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r1, #1	@ tmp227,
	ands	r7, r6	@ _109, keys
@ Data/FE6_FE7.c:3439:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ _151, tmp227,
@ Data/FE6_FE7.c:3437:     if (proc->editing)
	cmp	r3, #0	@ _2,
	bne	.LCB8002	@
	b	.L1112	@long jump	@
.LCB8002:
@ Data/FE6_FE7.c:3439:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r2, r2, #1	@ tmp229,
	ldrsb	r2, [r4, r2]	@ tmp230,
@ Data/FE6_FE7.c:3439:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r3, .L1179+4	@ tmp228,
	lsls	r2, r2, #3	@ tmp231, tmp230,
	adds	r3, r3, r2	@ tmp232, tmp228, tmp231
@ Data/FE6_FE7.c:3439:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r0, [r3, #120]	@ CursorLocationTable[_4].x, CursorLocationTable[_4].x
	bl	DisplayVertUiHand		@
	ldr	r3, .L1179+8	@ tmp379,
@ Data/FE6_FE7.c:525:     int result = 1;
	subs	r5, r5, #45	@ result,
	mov	r8, r3	@ tmp379, tmp379
	adds	r3, r3, #76	@ ivtmp.1087,
.L1113:
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	adds	r3, r3, #4	@ ivtmp.1087,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	subs	r1, r3, #4	@ tmp237, ivtmp.1087,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	ldr	r1, [r1]	@ MEM[(const int *)_105 + 4294967292B], MEM[(const int *)_105 + 4294967292B]
@ Data/FE6_FE7.c:528:         result++;
	adds	r5, r5, #1	@ result,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	cmp	r1, #254	@ MEM[(const int *)_105 + 4294967292B],
	ble	.L1113		@,
@ Data/FE6_FE7.c:530:     if (result > 9)
	cmp	r5, #9	@ _123,
	ble	.LCB8023	@
	b	.L1174	@long jump	@
.LCB8023:
@ Data/FE6_FE7.c:3444:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _109,
	beq	.L1115		@,
.L1178:
@ Data/FE6_FE7.c:3446:             if (proc->digit > 0)
	movs	r3, #49	@ tmp239,
	ldrsb	r3, [r4, r3]	@ _11,
@ Data/FE6_FE7.c:3446:             if (proc->digit > 0)
	cmp	r3, #0	@ _11,
	bgt	.LCB8030	@
	b	.L1116	@long jump	@
.LCB8030:
@ Data/FE6_FE7.c:3448:                 proc->digit--;
	subs	r3, r3, #1	@ tmp243,
	lsls	r3, r3, #24	@ tmp244, tmp243,
	asrs	r3, r3, #24	@ _15, tmp244,
.L1117:
	movs	r2, #49	@ tmp251,
@ Data/FE6_FE7.c:3455:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _15, proc_82(D)->digit
	bl	RedrawUnitSupportsMenu		@
.L1115:
@ Data/FE6_FE7.c:3457:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp395, keys,
	bpl	.L1118		@,
@ Data/FE6_FE7.c:3459:             if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp260,
	ldrsb	r3, [r4, r3]	@ _19,
@ Data/FE6_FE7.c:3459:             if (proc->digit < (max_digits - 1))
	subs	r5, r5, #1	@ tmp261,
@ Data/FE6_FE7.c:3459:             if (proc->digit < (max_digits - 1))
	cmp	r3, r5	@ _19, tmp261
	bge	.LCB8052	@
	b	.L1175	@long jump	@
.LCB8052:
@ Data/FE6_FE7.c:3466:                 proc->editing = false;
	movs	r3, #46	@ tmp265,
	movs	r2, #0	@ tmp266,
	strb	r2, [r4, r3]	@ tmp266, proc_82(D)->editing
@ Data/FE6_FE7.c:3465:                 proc->digit = 0;
	movs	r3, #0	@ _25,
.L1120:
	movs	r2, #49	@ tmp268,
@ Data/FE6_FE7.c:3468:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _25, proc_82(D)->digit
	bl	RedrawUnitSupportsMenu		@
.L1118:
@ Data/FE6_FE7.c:3471:         if (keys & DPAD_UP)
	movs	r3, #64	@ tmp271,
	tst	r3, r6	@ tmp271, keys
	beq	.L1121		@,
@ Data/FE6_FE7.c:3473:             if (proc->tmp[proc->id] == max)
	movs	r2, #48	@ tmp277,
	ldrsb	r1, [r4, r2]	@ tmp278,
	lsls	r1, r1, #1	@ tmp279, tmp278,
	adds	r1, r4, r1	@ _146, proc, tmp279
@ Data/FE6_FE7.c:3473:             if (proc->tmp[proc->id] == max)
	ldrsh	r2, [r1, r3]	@ _28, MEM <s16> [(struct DebuggerProc *)_146 + 64B]
@ Data/FE6_FE7.c:3473:             if (proc->tmp[proc->id] == max)
	cmp	r2, #255	@ _28,
	bne	.LCB8077	@
	b	.L1134	@long jump	@
.LCB8077:
@ Data/FE6_FE7.c:3479:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	movs	r3, #49	@ tmp283,
	ldrsb	r3, [r4, r3]	@ tmp284,
@ Data/FE6_FE7.c:3479:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp285, tmp284,
	add	r3, r3, r8	@ tmp286, tmp379
@ Data/FE6_FE7.c:3479:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_31], DigitDecimalTable[_31]
	adds	r3, r3, r2	@ tmp291, DigitDecimalTable[_31], _28
@ Data/FE6_FE7.c:3480:                 if (proc->tmp[proc->id] > max)
	adds	r2, r3, #0	@ tmp281, tmp291
	lsls	r3, r3, #16	@ tmp294, tmp291,
	asrs	r3, r3, #16	@ tmp294, tmp294,
	cmp	r3, #255	@ tmp294,
	ble	.L1123		@,
	movs	r2, #255	@ tmp281,
.L1123:
	lsls	r3, r2, #16	@ _38, tmp281,
	asrs	r3, r3, #16	@ _38, _38,
.L1122:
@ Data/FE6_FE7.c:3475:                 proc->tmp[proc->id] = min;
	movs	r2, #64	@ tmp296,
@ Data/FE6_FE7.c:3485:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3475:                 proc->tmp[proc->id] = min;
	strh	r3, [r1, r2]	@ _38, MEM <s16> [(struct DebuggerProc *)_146 + 64B]
@ Data/FE6_FE7.c:3485:             RedrawUnitSupportsMenu(proc);
	bl	RedrawUnitSupportsMenu		@
.L1121:
@ Data/FE6_FE7.c:3487:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp396, keys,
	bpl	.L1106		@,
@ Data/FE6_FE7.c:3490:             if (proc->tmp[proc->id] == min)
	movs	r3, #48	@ tmp305,
	ldrsb	r1, [r4, r3]	@ tmp306,
	lsls	r1, r1, #1	@ tmp307, tmp306,
@ Data/FE6_FE7.c:3490:             if (proc->tmp[proc->id] == min)
	adds	r3, r3, #16	@ tmp308,
	adds	r1, r4, r1	@ _8, proc, tmp307
	ldrsh	r2, [r1, r3]	@ _39, MEM <s16> [(struct DebuggerProc *)_8 + 64B]
	movs	r3, #255	@ _112,
@ Data/FE6_FE7.c:3490:             if (proc->tmp[proc->id] == min)
	cmp	r2, #0	@ _39,
	bne	.L1176		@,
@ Data/FE6_FE7.c:3492:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp324,
@ Data/FE6_FE7.c:3503:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3492:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _112, MEM <s16> [(struct DebuggerProc *)_8 + 64B]
@ Data/FE6_FE7.c:3503:             RedrawUnitSupportsMenu(proc);
	bl	RedrawUnitSupportsMenu		@
.L1106:
@ Data/FE6_FE7.c:3540: }
	@ sp needed	@
	pop	{r7}
	mov	r8, r7
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1112:
@ Data/FE6_FE7.c:3508:         DisplayUiHand(CursorLocationTable[0].x - ((SupportWidth + 2) * 8), (Y_HAND + (proc->id * 2)) * 8);
	movs	r0, #92	@,
	ldr	r3, .L1179+12	@ tmp326,
	bl	.L17		@
@ Data/FE6_FE7.c:3509:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _109,
	beq	.L1128		@,
@ Data/FE6_FE7.c:3511:             proc->digit = 1;
	movs	r3, #1	@ tmp328,
	movs	r2, #49	@ tmp327,
	strb	r3, [r4, r2]	@ tmp328, proc_82(D)->digit
@ Data/FE6_FE7.c:3512:             proc->editing = true;
	strb	r3, [r4, r5]	@ tmp328, proc_82(D)->editing
.L1128:
@ Data/FE6_FE7.c:3514:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp397, keys,
	bpl	.L1129		@,
@ Data/FE6_FE7.c:3516:             proc->digit = 0;
	movs	r3, #49	@ tmp340,
	movs	r2, #0	@ tmp341,
	strb	r2, [r4, r3]	@ tmp341, proc_82(D)->digit
@ Data/FE6_FE7.c:3517:             proc->editing = true;
	subs	r3, r3, #3	@ tmp343,
	adds	r2, r2, #1	@ tmp344,
	strb	r2, [r4, r3]	@ tmp344, proc_82(D)->editing
.L1129:
@ Data/FE6_FE7.c:3520:         if (keys & DPAD_UP)
	lsls	r3, r6, #25	@ tmp398, keys,
	bpl	.L1130		@,
@ Data/FE6_FE7.c:3522:             proc->id--;
	movs	r3, #48	@ tmp353,
@ Data/FE6_FE7.c:3522:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp355,
	subs	r3, r3, #1	@ tmp356,
	lsls	r3, r3, #24	@ tmp357, tmp356,
	asrs	r2, r3, #24	@ _58, tmp357,
@ Data/FE6_FE7.c:3523:             if (proc->id < 0)
	cmp	r3, #0	@ tmp357,
	blt	.L1177		@,
	movs	r3, #48	@ tmp361,
@ Data/FE6_FE7.c:3527:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _58, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitSupportsMenu		@
.L1130:
@ Data/FE6_FE7.c:3529:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp399, keys,
	bpl	.L1106		@,
@ Data/FE6_FE7.c:3531:             proc->id++;
	movs	r1, #48	@ tmp370,
@ Data/FE6_FE7.c:3534:                 proc->id = 0;
	movs	r0, #6	@ tmp382,
	movs	r5, #0	@ tmp384,
@ Data/FE6_FE7.c:3531:             proc->id++;
	ldrb	r3, [r4, r1]	@ tmp372,
	adds	r3, r3, #1	@ tmp373,
	lsls	r3, r3, #24	@ tmp374, tmp373,
	asrs	r2, r3, #24	@ _64, tmp374,
@ Data/FE6_FE7.c:3534:                 proc->id = 0;
	lsrs	r3, r3, #31	@ tmp383, tmp374,
	cmp	r0, r2	@ tmp382, _64
	adcs	r3, r3, r5	@ tmp381, tmp383, tmp384
	rsbs	r3, r3, #0	@ tmp385, tmp381
	ands	r2, r3	@ _64, tmp385
@ Data/FE6_FE7.c:3537:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r1]	@ _64, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitSupportsMenu		@
@ Data/FE6_FE7.c:3540: }
	b	.L1106		@
.L1174:
@ Data/FE6_FE7.c:530:     if (result > 9)
	movs	r5, #9	@ _123,
@ Data/FE6_FE7.c:3444:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _109,
	bne	.LCB8204	@
	b	.L1115	@long jump	@
.LCB8204:
	b	.L1178		@
.L1173:
@ Data/FE6_FE7.c:3409:     u8 * row = GetUnitBwlSupportRow(unit);
	ldr	r0, [r4, #60]	@ proc_82(D)->unit, proc_82(D)->unit
	bl	GetUnitBwlSupportRow		@
@ Data/FE6_FE7.c:3410:     if (!row)
	cmp	r0, #0	@ row,
	beq	.L1111		@,
	movs	r3, r4	@ ivtmp.1095, proc
	movs	r1, r4	@ _52, proc
	adds	r3, r3, #64	@ ivtmp.1095,
	adds	r1, r1, #78	@ _52,
.L1110:
@ Data/FE6_FE7.c:3416:         row[i] = proc->tmp[i];
	ldrh	r2, [r3]	@ MEM[(short int *)_59], MEM[(short int *)_59]
@ Data/FE6_FE7.c:3414:     for (int i = 0; i < SupportOptions; ++i)
	adds	r3, r3, #2	@ ivtmp.1095,
@ Data/FE6_FE7.c:3416:         row[i] = proc->tmp[i];
	strb	r2, [r0]	@ MEM[(short int *)_59], MEM[(u8 *)_50]
@ Data/FE6_FE7.c:3414:     for (int i = 0; i < SupportOptions; ++i)
	adds	r0, r0, #1	@ ivtmp.1097,
	cmp	r1, r3	@ _52, ivtmp.1095
	bne	.L1110		@,
.L1111:
@ Data/FE6_FE7.c:3434:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L1179+16	@ tmp215,
	bl	.L17		@
@ Data/FE6_FE7.c:563: }
	b	.L1108		@
.L1172:
@ Data/FE6_FE7.c:3428:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	ldr	r3, .L1179+16	@ tmp206,
	bl	.L17		@
@ Data/FE6_FE7.c:563: }
	b	.L1107		@
.L1176:
@ Data/FE6_FE7.c:3496:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	subs	r3, r3, #206	@ tmp311,
	ldrsb	r3, [r4, r3]	@ tmp312,
@ Data/FE6_FE7.c:3496:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp313, tmp312,
	add	r3, r3, r8	@ tmp314, tmp379
@ Data/FE6_FE7.c:3496:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	ldr	r0, [r3, #68]	@ DigitDecimalTable[_42], DigitDecimalTable[_42]
	subs	r0, r2, r0	@ tmp319, _39, DigitDecimalTable[_42]
@ Data/FE6_FE7.c:3497:                 if (proc->tmp[proc->id] < min)
	lsls	r3, r0, #16	@ tmp322, tmp319,
	asrs	r3, r3, #16	@ tmp322, tmp322,
	mvns	r3, r3	@ tmp387, tmp322
@ Data/FE6_FE7.c:3492:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp324,
@ Data/FE6_FE7.c:3497:                 if (proc->tmp[proc->id] < min)
	asrs	r3, r3, #31	@ tmp391, tmp387,
	ands	r3, r0	@ tmp309, tmp319
	lsls	r3, r3, #16	@ _112, tmp309,
	asrs	r3, r3, #16	@ _112, _112,
@ Data/FE6_FE7.c:3503:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3492:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _112, MEM <s16> [(struct DebuggerProc *)_8 + 64B]
@ Data/FE6_FE7.c:3503:             RedrawUnitSupportsMenu(proc);
	bl	RedrawUnitSupportsMenu		@
	b	.L1106		@
.L1175:
@ Data/FE6_FE7.c:3461:                 proc->digit++;
	adds	r3, r3, #1	@ tmp263,
	lsls	r3, r3, #24	@ tmp264, tmp263,
	asrs	r3, r3, #24	@ _25, tmp264,
	b	.L1120		@
.L1177:
@ Data/FE6_FE7.c:3525:                 proc->id = SupportOptions - 1;
	movs	r2, #6	@ _58,
	movs	r3, #48	@ tmp361,
@ Data/FE6_FE7.c:3527:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _58, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitSupportsMenu		@
	b	.L1130		@
.L1116:
@ Data/FE6_FE7.c:3453:                 proc->editing = false;
	movs	r2, #46	@ tmp248,
	movs	r1, #0	@ tmp249,
@ Data/FE6_FE7.c:3452:                 proc->digit = max_digits - 1;
	subs	r3, r5, #1	@ tmp246, _123,
	lsls	r3, r3, #24	@ tmp247, tmp246,
@ Data/FE6_FE7.c:3453:                 proc->editing = false;
	strb	r1, [r4, r2]	@ tmp249, proc_82(D)->editing
@ Data/FE6_FE7.c:3452:                 proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _15, tmp247,
	b	.L1117		@
.L1134:
	movs	r3, #0	@ _38,
	b	.L1122		@
.L1180:
	.align	2
.L1179:
	.word	gKeyStatusPtr
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	DisplayUiHand
	.word	Proc_Goto
	.size	EditSupportsIdle, .-EditSupportsIdle
	.align	1
	.p2align 2,,3
	.global	SaveSupports
	.syntax unified
	.code	16
	.thumb_func
	.type	SaveSupports, %function
SaveSupports:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:3407: {
	movs	r4, r0	@ proc, tmp130
@ Data/FE6_FE7.c:3409:     u8 * row = GetUnitBwlSupportRow(unit);
	ldr	r0, [r0, #60]	@ proc_9(D)->unit, proc_9(D)->unit
	bl	GetUnitBwlSupportRow		@
	subs	r2, r0, #0	@ row, tmp131,
@ Data/FE6_FE7.c:3410:     if (!row)
	beq	.L1181		@,
	movs	r3, r4	@ ivtmp.1108, proc
	adds	r4, r4, #78	@ _28,
	adds	r3, r3, #64	@ ivtmp.1108,
.L1183:
@ Data/FE6_FE7.c:3416:         row[i] = proc->tmp[i];
	ldrh	r1, [r3]	@ MEM[(short int *)_25], MEM[(short int *)_25]
@ Data/FE6_FE7.c:3414:     for (int i = 0; i < SupportOptions; ++i)
	adds	r3, r3, #2	@ ivtmp.1108,
@ Data/FE6_FE7.c:3416:         row[i] = proc->tmp[i];
	strb	r1, [r2]	@ MEM[(short int *)_25], MEM[(u8 *)_26]
@ Data/FE6_FE7.c:3414:     for (int i = 0; i < SupportOptions; ++i)
	adds	r2, r2, #1	@ ivtmp.1110,
	cmp	r3, r4	@ ivtmp.1108, _28
	bne	.L1183		@,
.L1181:
@ Data/FE6_FE7.c:3418: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
	.size	SaveSupports, .-SaveSupports
	.align	1
	.p2align 2,,3
	.global	SaveLearnedSkills
	.syntax unified
	.code	16
	.thumb_func
	.type	SaveLearnedSkills, %function
SaveLearnedSkills:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:3619:     u8 * skills = GetUnitLearnedSkillRam(proc->unit);
	ldr	r3, [r0, #60]	@ _1, proc_10(D)->unit
@ Data/FE6_FE7.c:3550:     if (!unit)
	cmp	r3, #0	@ _1,
	beq	.L1188		@,
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	movs	r1, #11	@ tmp133,
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	movs	r2, #192	@ tmp134,
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	ldrsb	r1, [r3, r1]	@ tmp133,
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	ands	r2, r1	@ tmp135, tmp133
@ Data/FE6_FE7.c:3567:     return LearnedSkillCount;
	rsbs	r1, r2, #0	@ tmp144, tmp135
	adcs	r2, r2, r1	@ tmp143, tmp135, tmp144
	adds	r2, r2, #6	@ _16,
	adds	r0, r0, #64	@ ivtmp.1118,
	lsls	r2, r2, #1	@ tmp137, _16,
	adds	r3, r3, #50	@ ivtmp.1120,
	adds	r2, r0, r2	@ _34, ivtmp.1118, tmp137
.L1191:
@ Data/FE6_FE7.c:3628:         skills[i] = (u8)proc->tmp[i];
	ldrh	r1, [r0]	@ MEM[(short int *)_12], MEM[(short int *)_12]
@ Data/FE6_FE7.c:3626:     for (i = 0; i < limit; ++i)
	adds	r0, r0, #2	@ ivtmp.1118,
@ Data/FE6_FE7.c:3628:         skills[i] = (u8)proc->tmp[i];
	strb	r1, [r3]	@ MEM[(short int *)_12], MEM[(u8 *)_11]
@ Data/FE6_FE7.c:3626:     for (i = 0; i < limit; ++i)
	adds	r3, r3, #1	@ ivtmp.1120,
	cmp	r0, r2	@ ivtmp.1118, _34
	bne	.L1191		@,
@ Data/FE6_FE7.c:3572:     *(struct Unit **)0x0202A9D4 = NULL;
	movs	r2, #0	@ tmp142,
	ldr	r3, .L1197	@ tmp141,
	str	r2, [r3]	@ tmp142, MEM[(struct Unit * *)33728980B]
.L1188:
@ Data/FE6_FE7.c:3631: }
	@ sp needed	@
	bx	lr
.L1198:
	.align	2
.L1197:
	.word	33728980
	.size	SaveLearnedSkills, .-SaveLearnedSkills
	.align	1
	.p2align 2,,3
	.global	CanEditLearnedSkillsMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	CanEditLearnedSkillsMenu, %function
CanEditLearnedSkillsMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
@ Data/FE6_FE7.c:3635:     if (!gActiveUnit)
	ldr	r3, .L1202	@ tmp118,
@ Data/FE6_FE7.c:3640: }
	@ sp needed	@
@ Data/FE6_FE7.c:3635:     if (!gActiveUnit)
	ldr	r0, [r3]	@ gActiveUnit, gActiveUnit
@ Data/FE6_FE7.c:3639:     return usable;
	rsbs	r3, r0, #0	@ tmp122, gActiveUnit
	adcs	r0, r0, r3	@ tmp121, gActiveUnit, tmp122
	adds	r0, r0, #1	@ <retval>,
@ Data/FE6_FE7.c:3640: }
	bx	lr
.L1203:
	.align	2
.L1202:
	.word	gActiveUnit
	.size	CanEditLearnedSkillsMenu, .-CanEditLearnedSkillsMenu
	.align	1
	.p2align 2,,3
	.global	EditSkillsNow
	.syntax unified
	.code	16
	.thumb_func
	.type	EditSkillsNow, %function
EditSkillsNow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}	@
@ Data/FE6_FE7.c:3645:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L1205	@ tmp119,
@ Data/FE6_FE7.c:3648: }
	@ sp needed	@
@ Data/FE6_FE7.c:3645:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L1205+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:3646:     Proc_Goto(proc, EditSkillsLabel);
	movs	r1, #21	@,
	ldr	r3, .L1205+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:3648: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L1206:
	.align	2
.L1205:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	EditSkillsNow, .-EditSkillsNow
	.section	.rodata.str1.4
	.align	2
.LC581:
	.ascii	"---\000"
	.text
	.align	1
	.p2align 2,,3
	.global	RedrawLearnedSkillsMenu
	.syntax unified
	.code	16
	.thumb_func
	.type	RedrawLearnedSkillsMenu, %function
RedrawLearnedSkillsMenu:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, fp	@,
	mov	r7, r10	@,
	mov	r6, r9	@,
	mov	r5, r8	@,
	push	{r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:3695:     int limit = GetUnitLearnedSkillLimit(proc->unit);
	ldr	r3, [r0, #60]	@ _1, proc_35(D)->unit
@ Data/FE6_FE7.c:3694: {
	movs	r4, r0	@ proc, tmp214
	sub	sp, sp, #28	@,,
@ Data/FE6_FE7.c:3559:     if (!unit)
	cmp	r3, #0	@ _1,
	bne	.LCB8438	@
	b	.L1208	@long jump	@
.LCB8438:
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	movs	r2, #192	@ tmp154,
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	ldrb	r3, [r3, #11]	@ tmp153,
	lsls	r3, r3, #24	@ tmp153, tmp153,
	asrs	r3, r3, #24	@ tmp153, tmp153,
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	tst	r2, r3	@ tmp154, tmp153
	beq	.LCB8445	@
	b	.L1221	@long jump	@
.LCB8445:
@ Data/FE6_FE7.c:3567:     return LearnedSkillCount;
	movs	r3, #7	@ _51,
	str	r3, [sp, #4]	@ _51, %sfp
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	subs	r2, r2, #178	@ prephitmp_82,
.L1209:
@ Data/FE6_FE7.c:3705:     for (i = 0; i < limit; ++i)
	movs	r7, #0	@ i,
@ Data/FE6_FE7.c:3701:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 6, Y_HAND), 14, 2 * limit, 0);
	ldr	r6, .L1241	@ tmp156,
	movs	r1, #14	@,
	movs	r0, r6	@, tmp156
	movs	r3, #0	@,
	ldr	r5, .L1241+4	@ tmp157,
	bl	.L28		@
@ Data/FE6_FE7.c:3702:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L1241+8	@ tmp210,
	movs	r0, #1	@,
	str	r3, [sp, #20]	@ tmp210, %sfp
	bl	.L17		@
@ Data/FE6_FE7.c:3703:     ResetIconGraphics();
	ldr	r3, .L1241+12	@ tmp159,
	bl	.L17		@
@ Data/FE6_FE7.c:3704:     LoadIconPalettes(4);
	ldr	r3, .L1241+16	@ tmp160,
	movs	r0, #4	@,
	bl	.L17		@
	ldr	r3, .L1241+20	@ tmp206,
	mov	fp, r3	@ tmp206, tmp206
	ldr	r3, .L1241+24	@ tmp207,
	mov	r10, r3	@ tmp207, tmp207
	ldr	r3, .L1241+28	@ tmp208,
	mov	r9, r3	@ tmp208, tmp208
	ldr	r3, .L1241+32	@ tmp209,
	mov	r8, r3	@ tmp209, tmp209
@ Data/FE6_FE7.c:3580:         return "---";
	ldr	r3, .L1241+36	@ _59,
	str	r3, [sp, #8]	@ _59, %sfp
@ Data/FE6_FE7.c:3578:     if (skillId == 0 || skillId == 0xFF || !SkillDescTable[skillId])
	ldr	r3, .L1241+40	@ tmp212,
	str	r3, [sp, #12]	@ tmp212, %sfp
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	ldr	r3, .L1241+44	@ _59,
	ldr	r5, .L1241+48	@ ivtmp.1139,
	str	r3, [sp, #16]	@ _59, %sfp
	adds	r4, r4, #64	@ ivtmp.1141,
	subs	r6, r6, #8	@ ivtmp.1143,
.L1219:
@ Data/FE6_FE7.c:3707:         ClearText(&th[i]);
	movs	r0, r5	@, ivtmp.1139
	bl	.L311		@
@ Data/FE6_FE7.c:3708:         Text_DrawString(&th[i], GetLearnedSkillName(proc->tmp[i]));
	movs	r2, #0	@ tmp243,
	ldrsh	r3, [r4, r2]	@ _8, ivtmp.1141, tmp243
@ Data/FE6_FE7.c:3578:     if (skillId == 0 || skillId == 0xFF || !SkillDescTable[skillId])
	cmp	r3, #0	@ _8,
	beq	.L1213		@,
	cmp	r3, #255	@ _8,
	beq	.L1213		@,
@ Data/FE6_FE7.c:3578:     if (skillId == 0 || skillId == 0xFF || !SkillDescTable[skillId])
	ldr	r2, [sp, #12]	@ tmp212, %sfp
	lsls	r3, r3, #1	@ tmp174, _8,
	ldrh	r0, [r3, r2]	@ _55, SkillDescTable
@ Data/FE6_FE7.c:3578:     if (skillId == 0 || skillId == 0xFF || !SkillDescTable[skillId])
	cmp	r0, #0	@ _55,
	beq	.L1213		@,
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	movs	r2, #128	@ tmp176,
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	subs	r3, r0, #1	@ tmp175, _55,
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	ldr	r1, [sp, #16]	@ _59, %sfp
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	lsls	r2, r2, #7	@ tmp176, tmp176,
	cmp	r3, r2	@ tmp175, tmp176
	bcs	.L1214		@,
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	ldr	r3, .L1241+52	@ tmp177,
	bl	.L17		@
	subs	r1, r0, #0	@ _59, tmp215,
@ Data/FE6_FE7.c:3583:     if (!desc)
	beq	.L1213		@,
.L1214:
@ Data/FE6_FE7.c:3587:     for (char * it = desc; *it; ++it)
	ldrb	r3, [r1]	@ _61, *_62
	cmp	r3, #0	@ _61,
	beq	.L1212		@,
@ Data/FE6_FE7.c:3587:     for (char * it = desc; *it; ++it)
	movs	r2, r1	@ it, _59
	b	.L1217		@
.L1216:
@ Data/FE6_FE7.c:3587:     for (char * it = desc; *it; ++it)
	ldrb	r3, [r2, #1]	@ _61, MEM[(char *)it_64]
@ Data/FE6_FE7.c:3587:     for (char * it = desc; *it; ++it)
	adds	r2, r2, #1	@ it,
@ Data/FE6_FE7.c:3587:     for (char * it = desc; *it; ++it)
	cmp	r3, #0	@ _61,
	beq	.L1212		@,
.L1217:
@ Data/FE6_FE7.c:3589:         if (*it == ':')
	cmp	r3, #58	@ _61,
	bne	.L1216		@,
@ Data/FE6_FE7.c:3591:             *it = 0;
	movs	r3, #0	@ tmp178,
	strb	r3, [r2]	@ tmp178, *it_75
.L1212:
@ Data/FE6_FE7.c:3708:         Text_DrawString(&th[i], GetLearnedSkillName(proc->tmp[i]));
	movs	r0, r5	@, ivtmp.1139
	bl	.L310		@
@ Data/FE6_FE7.c:3709:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(nameX, Y_HAND + (i * 2)));
	movs	r1, r6	@, ivtmp.1143
	movs	r0, r5	@, ivtmp.1139
	bl	.L139		@
@ Data/FE6_FE7.c:3710:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	movs	r0, r6	@ tmp183, ivtmp.1143
	movs	r1, #3	@,
	movs	r3, #0	@ tmp244,
	ldrsh	r2, [r4, r3]	@ MEM[(short int *)_94], ivtmp.1141, tmp244
	adds	r0, r0, #24	@ tmp183,
	bl	.L193		@
@ Data/FE6_FE7.c:3711:         if (proc->tmp[i] && proc->tmp[i] != 0xFF)
	movs	r3, #0	@ tmp245,
	ldrsh	r1, [r4, r3]	@ _47, ivtmp.1141, tmp245
@ Data/FE6_FE7.c:3709:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(nameX, Y_HAND + (i * 2)));
	adds	r7, r7, #1	@ i,
@ Data/FE6_FE7.c:3711:         if (proc->tmp[i] && proc->tmp[i] != 0xFF)
	cmp	r1, #0	@ _47,
	beq	.L1218		@,
	cmp	r1, #255	@ _47,
	beq	.L1218		@,
@ Data/FE6_FE7.c:3713:             DrawIcon(
	movs	r2, #128	@,
	adds	r1, r1, #1	@ tmp197,
	ldr	r3, .L1241+56	@ tmp199,
	adds	r1, r1, #255	@ tmp197,
	subs	r0, r6, #4	@ tmp198, ivtmp.1143,
	lsls	r2, r2, #7	@,,
	bl	.L17		@
.L1218:
@ Data/FE6_FE7.c:3705:     for (i = 0; i < limit; ++i)
	ldr	r3, [sp, #4]	@ _51, %sfp
	adds	r5, r5, #8	@ ivtmp.1139,
	adds	r4, r4, #2	@ ivtmp.1141,
	adds	r6, r6, #128	@ ivtmp.1143,
	cmp	r7, r3	@ i, _51
	blt	.L1219		@,
.L1220:
@ Data/FE6_FE7.c:3719:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	ldr	r3, [sp, #20]	@ tmp210, %sfp
	bl	.L17		@
@ Data/FE6_FE7.c:3720: }
	add	sp, sp, #28	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	mov	fp, r7
	mov	r10, r6
	mov	r9, r5
	mov	r8, r4
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1213:
@ Data/FE6_FE7.c:3580:         return "---";
	ldr	r1, [sp, #8]	@ _59, %sfp
	b	.L1212		@
.L1221:
@ Data/FE6_FE7.c:3565:         return 6; /* keep supports[6] leader */
	movs	r3, #6	@ _51,
	movs	r2, #12	@ prephitmp_82,
	str	r3, [sp, #4]	@ _51, %sfp
	b	.L1209		@
.L1208:
@ Data/FE6_FE7.c:3701:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 6, Y_HAND), 14, 2 * limit, 0);
	movs	r2, #0	@,
	movs	r1, #14	@,
	movs	r3, #0	@,
	ldr	r0, .L1241	@ tmp201,
	ldr	r4, .L1241+4	@ tmp202,
	bl	.L27		@
@ Data/FE6_FE7.c:3702:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L1241+8	@ tmp210,
	movs	r0, #1	@,
	str	r3, [sp, #20]	@ tmp210, %sfp
	bl	.L17		@
@ Data/FE6_FE7.c:3703:     ResetIconGraphics();
	ldr	r3, .L1241+12	@ tmp204,
	bl	.L17		@
@ Data/FE6_FE7.c:3704:     LoadIconPalettes(4);
	movs	r0, #4	@,
	ldr	r3, .L1241+16	@ tmp205,
	bl	.L17		@
	b	.L1220		@
.L1242:
	.align	2
.L1241:
	.word	gBG0TilemapBuffer+150
	.word	TileMap_FillRect
	.word	BG_EnableSyncByMask
	.word	ResetIconGraphics
	.word	LoadIconPalettes
	.word	ClearText
	.word	Text_DrawString
	.word	PutText
	.word	PutNumber
	.word	.LC581
	.word	SkillDescTable
	.word	BlankString
	.word	gStatScreen+24
	.word	GetStringFromIndex
	.word	DrawIcon
	.size	RedrawLearnedSkillsMenu, .-RedrawLearnedSkillsMenu
	.align	1
	.p2align 2,,3
	.global	EditSkillsInit
	.syntax unified
	.code	16
	.thumb_func
	.type	EditSkillsInit, %function
EditSkillsInit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, r10	@,
	mov	r7, r9	@,
	mov	r6, r8	@,
	push	{r6, r7, lr}	@
@ Data/FE6_FE7.c:3653:     int limit = GetUnitLearnedSkillLimit(proc->unit);
	ldr	r3, [r0, #60]	@ _1, proc_20(D)->unit
@ Data/FE6_FE7.c:3651: {
	movs	r5, r0	@ proc, tmp198
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:3559:     if (!unit)
	cmp	r3, #0	@ _1,
	bne	.LCB8657	@
	b	.L1254	@long jump	@
.LCB8657:
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	movs	r2, #192	@ tmp143,
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	ldrb	r3, [r3, #11]	@ tmp142,
	lsls	r3, r3, #24	@ tmp142, tmp142,
	asrs	r3, r3, #24	@ tmp142, tmp142,
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	tst	r2, r3	@ tmp143, tmp142
	bne	.L1255		@,
	movs	r3, #16	@ prephitmp_63,
@ Data/FE6_FE7.c:3567:     return LearnedSkillCount;
	movs	r6, #7	@ _40,
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	mov	r10, r3	@ prephitmp_63, prephitmp_63
.L1244:
@ Data/FE6_FE7.c:385:     ResetTextFont();
	ldr	r3, .L1261	@ tmp145,
	mov	r9, r3	@ tmp145, tmp145
	bl	.L17		@
@ Data/FE6_FE7.c:386:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	ldr	r7, .L1261+4	@ tmp146,
	bl	.L145		@
@ Data/FE6_FE7.c:389:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1261+8	@ tmp147,
	ldr	r3, .L1261+12	@ tmp148,
	bl	.L17		@
@ Data/FE6_FE7.c:390:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L1261+16	@ tmp192,
	movs	r0, #1	@,
	mov	r8, r3	@ tmp192, tmp192
	bl	.L17		@
@ Data/FE6_FE7.c:391:     ResetTextFont();
	bl	.L139		@
@ Data/FE6_FE7.c:392:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L145		@
@ Data/FE6_FE7.c:393:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L1261+20	@ tmp152,
	bl	.L17		@
@ Data/FE6_FE7.c:394:     ClearBg0Bg1();
	ldr	r3, .L1261+24	@ tmp153,
	bl	.L17		@
@ Data/FE6_FE7.c:395:     ResetText();
	ldr	r3, .L1261+28	@ tmp154,
	bl	.L17		@
@ Data/FE6_FE7.c:3659:     LoadIconPalettes(4);
	movs	r0, #4	@,
	ldr	r3, .L1261+32	@ tmp155,
	bl	.L17		@
@ Data/FE6_FE7.c:3572:     *(struct Unit **)0x0202A9D4 = NULL;
	movs	r3, #0	@ tmp157,
	ldr	r2, .L1261+36	@ tmp156,
	str	r3, [r2]	@ tmp157, MEM[(struct Unit * *)33728980B]
@ Data/FE6_FE7.c:3661:     skills = GetUnitLearnedSkillRam(proc->unit);
	ldr	r0, [r5, #60]	@ _2, proc_20(D)->unit
@ Data/FE6_FE7.c:3550:     if (!unit)
	cmp	r0, #0	@ _2,
	beq	.L1260		@,
	movs	r1, r5	@ vectp.1157, proc
@ Data/FE6_FE7.c:3664:         proc->tmp[i] = 0;
	movs	r2, #76	@ tmp170,
	str	r3, [r5, #64]	@ tmp157, MEM <vector(2) short int> [(short int *)proc_20(D) + 64B]
	str	r3, [r5, #68]	@ tmp157, MEM <vector(2) short int> [(short int *)proc_20(D) + 68B]
	str	r3, [r5, #72]	@ tmp157, MEM <vector(2) short int> [(short int *)proc_20(D) + 72B]
	adds	r1, r1, #64	@ vectp.1157,
	strh	r3, [r5, r2]	@ tmp157, proc_20(D)->tmp[6]
@ Data/FE6_FE7.c:3668:         for (i = 0; i < limit; ++i)
	cmp	r6, #0	@ _40,
	beq	.L1248		@,
	lsls	r7, r6, #1	@ tmp174, _40,
	adds	r0, r0, #50	@ ivtmp.1169,
	adds	r7, r1, r7	@ _88, ivtmp.1171, tmp174
.L1250:
@ Data/FE6_FE7.c:3670:             proc->tmp[i] = (skills[i] == 0xFF) ? 0 : skills[i];
	ldrb	r2, [r0]	@ _5, MEM[(u8 *)_82]
@ Data/FE6_FE7.c:3670:             proc->tmp[i] = (skills[i] == 0xFF) ? 0 : skills[i];
	movs	r3, r2	@ tmp195, _5
	subs	r3, r3, #255	@ tmp195,
	subs	r4, r3, #1	@ tmp196, tmp195
	sbcs	r3, r3, r4	@ tmp194, tmp195, tmp196
	rsbs	r3, r3, #0	@ tmp197, tmp194
	ands	r2, r3	@ _5, tmp197
@ Data/FE6_FE7.c:3670:             proc->tmp[i] = (skills[i] == 0xFF) ? 0 : skills[i];
	strh	r2, [r1]	@ _5, MEM[(short int *)_83]
@ Data/FE6_FE7.c:3668:         for (i = 0; i < limit; ++i)
	adds	r1, r1, #2	@ ivtmp.1171,
	adds	r0, r0, #1	@ ivtmp.1169,
	cmp	r1, r7	@ ivtmp.1171, _88
	bne	.L1250		@,
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	movs	r3, #0	@ tmp188,
	movs	r0, #2	@,
	str	r3, [sp]	@ tmp188,
	movs	r2, #22	@,
	mov	r3, r10	@, prephitmp_63
	movs	r1, #1	@,
	ldr	r7, .L1261+40	@ tmp189,
	bl	.L145		@
@ Data/FE6_FE7.c:3680:     BG_EnableSyncByMask(BG2_SYNC_BIT);
	movs	r0, #4	@,
	bl	.L193		@
.L1246:
	ldr	r4, .L1261+44	@ ivtmp.1164,
	lsls	r6, r6, #3	@ tmp178, _40,
	ldr	r7, .L1261+48	@ tmp191,
	adds	r6, r4, r6	@ _66, ivtmp.1164, tmp178
.L1253:
@ Data/FE6_FE7.c:3685:         InitText(&th[i], LearnedSkillNameWidth);
	movs	r0, r4	@, ivtmp.1164
	movs	r1, #12	@,
@ Data/FE6_FE7.c:3683:     for (i = 0; i < limit; ++i)
	adds	r4, r4, #8	@ ivtmp.1164,
@ Data/FE6_FE7.c:3685:         InitText(&th[i], LearnedSkillNameWidth);
	bl	.L145		@
@ Data/FE6_FE7.c:3683:     for (i = 0; i < limit; ++i)
	cmp	r4, r6	@ ivtmp.1164, _66
	bne	.L1253		@,
.L1252:
@ Data/FE6_FE7.c:3687:     proc->id = 0;
	movs	r3, #0	@ tmp180,
@ Data/FE6_FE7.c:3689:     proc->editing = false;
	movs	r2, #0	@ tmp181,
@ Data/FE6_FE7.c:3687:     proc->id = 0;
	strh	r3, [r5, #48]	@ tmp180, MEM <vector(2) signed char> [(signed char *)proc_20(D) + 48B]
@ Data/FE6_FE7.c:3689:     proc->editing = false;
	adds	r3, r3, #46	@ tmp182,
@ Data/FE6_FE7.c:3690:     RedrawLearnedSkillsMenu(proc);
	movs	r0, r5	@, proc
@ Data/FE6_FE7.c:3689:     proc->editing = false;
	strb	r2, [r5, r3]	@ tmp181, proc_20(D)->editing
@ Data/FE6_FE7.c:3690:     RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
@ Data/FE6_FE7.c:3691: }
	add	sp, sp, #8	@,,
	@ sp needed	@
	pop	{r5, r6, r7}
	mov	r10, r7
	mov	r9, r6
	mov	r8, r5
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1255:
	movs	r3, #14	@ prephitmp_63,
@ Data/FE6_FE7.c:3565:         return 6; /* keep supports[6] leader */
	movs	r6, #6	@ _40,
	mov	r10, r3	@ prephitmp_63, prephitmp_63
	b	.L1244		@
.L1260:
@ Data/FE6_FE7.c:3664:         proc->tmp[i] = 0;
	adds	r3, r3, #76	@ tmp161,
	str	r0, [r5, #64]	@ _2, MEM <vector(2) short int> [(short int *)proc_20(D) + 64B]
	str	r0, [r5, #68]	@ _2, MEM <vector(2) short int> [(short int *)proc_20(D) + 68B]
	str	r0, [r5, #72]	@ _2, MEM <vector(2) short int> [(short int *)proc_20(D) + 72B]
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	movs	r2, #22	@,
@ Data/FE6_FE7.c:3664:         proc->tmp[i] = 0;
	strh	r0, [r5, r3]	@ _2, proc_20(D)->tmp[6]
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	movs	r1, #1	@,
	str	r0, [sp]	@ _2,
	mov	r3, r10	@, prephitmp_63
	adds	r0, r0, #2	@,
	ldr	r7, .L1261+40	@ tmp165,
	bl	.L145		@
@ Data/FE6_FE7.c:3680:     BG_EnableSyncByMask(BG2_SYNC_BIT);
	movs	r0, #4	@,
	bl	.L193		@
@ Data/FE6_FE7.c:3683:     for (i = 0; i < limit; ++i)
	cmp	r6, #0	@ _40,
	bne	.L1246		@,
	b	.L1252		@
.L1254:
	movs	r3, #2	@ prephitmp_63,
@ Data/FE6_FE7.c:3561:         return 0;
	movs	r6, #0	@ _40,
	mov	r10, r3	@ prephitmp_63, prephitmp_63
	b	.L1244		@
.L1248:
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	str	r6, [sp]	@ _40,
	mov	r3, r10	@, prephitmp_63
	movs	r2, #22	@,
	movs	r1, #1	@,
	movs	r0, #2	@,
	ldr	r6, .L1261+40	@ tmp186,
	bl	.L38		@
@ Data/FE6_FE7.c:3680:     BG_EnableSyncByMask(BG2_SYNC_BIT);
	movs	r0, #4	@,
	bl	.L193		@
	b	.L1252		@
.L1262:
	.align	2
.L1261:
	.word	ResetTextFont
	.word	SetTextFontGlyphs
	.word	gBG0TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.word	SetTextFont
	.word	ClearBg0Bg1
	.word	ResetText
	.word	LoadIconPalettes
	.word	33728980
	.word	PutUiWindowFrame
	.word	gStatScreen+24
	.word	InitText
	.size	EditSkillsInit, .-EditSkillsInit
	.align	1
	.p2align 2,,3
	.global	EditSkillsIdle
	.syntax unified
	.code	16
	.thumb_func
	.type	EditSkillsIdle, %function
EditSkillsIdle:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, r8	@,
	push	{lr}	@
@ Data/FE6_FE7.c:3724:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L1344	@ tmp206,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r6, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:3725:     int limit = GetUnitLearnedSkillLimit(proc->unit);
	ldr	r3, [r0, #60]	@ _2, proc_95(D)->unit
@ Data/FE6_FE7.c:3723: {
	movs	r4, r0	@ proc, tmp455
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:3559:     if (!unit)
	cmp	r3, #0	@ _2,
	bne	.LCB8853	@
	b	.L1290	@long jump	@
.LCB8853:
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	movs	r2, #11	@ tmp207,
	ldrsb	r2, [r3, r2]	@ tmp207,
@ Data/FE6_FE7.c:3563:     if ((unit->index & 0xC0) != 0)
	movs	r3, #192	@ tmp208,
	ands	r3, r2	@ tmp209, tmp207
@ Data/FE6_FE7.c:3567:     return LearnedSkillCount;
	rsbs	r2, r3, #0	@ tmp442, tmp209
	adcs	r3, r3, r2	@ tmp441, tmp209, tmp442
	adds	r5, r3, #6	@ _96, tmp441,
.L1264:
@ Data/FE6_FE7.c:3727:     if (keys & B_BUTTON)
	lsls	r3, r6, #30	@ tmp458, keys,
	bpl	.LCB8867	@
	b	.L1336	@long jump	@
.LCB8867:
.L1265:
@ Data/FE6_FE7.c:3735:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp235,
	tst	r3, r6	@ tmp235, keys
	beq	.LCB8874	@
	b	.L1337	@long jump	@
.LCB8874:
.L1266:
@ Data/FE6_FE7.c:3746:             proc->tmp[proc->id],
	movs	r7, #48	@ tmp254,
	ldrsb	r3, [r4, r7]	@ _189,
@ Data/FE6_FE7.c:3748:             (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r3, #1	@ tmp255, _189,
@ Data/FE6_FE7.c:3745:         TryShowSkillHelp(
	lsls	r1, r1, #4	@ prephitmp_186, tmp255,
@ Data/FE6_FE7.c:3743:     if (keys & SELECT_BUTTON)
	lsls	r2, r6, #29	@ tmp459, keys,
	bpl	.LCB8885	@
	b	.L1338	@long jump	@
.LCB8885:
.L1267:
@ Data/FE6_FE7.c:3750:     if (proc->editing)
	movs	r3, #46	@ tmp282,
	movs	r7, #16	@ tmp286,
	mov	r8, r3	@ tmp282, tmp282
	ldrsb	r3, [r4, r3]	@ _13,
	ands	r7, r6	@ _187, keys
@ Data/FE6_FE7.c:3750:     if (proc->editing)
	cmp	r3, #0	@ _13,
	bne	.LCB8895	@
	b	.L1268	@long jump	@
.LCB8895:
@ Data/FE6_FE7.c:3752:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r2, #49	@ tmp289,
@ Data/FE6_FE7.c:525:     int result = 1;
	movs	r5, #1	@ result,
@ Data/FE6_FE7.c:3752:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r2, [r4, r2]	@ tmp290,
@ Data/FE6_FE7.c:3752:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r3, .L1344+4	@ tmp288,
	lsls	r2, r2, #3	@ tmp291, tmp290,
	adds	r3, r3, r2	@ tmp292, tmp288, tmp291
@ Data/FE6_FE7.c:3752:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r0, [r3, #120]	@ CursorLocationTable[_15].x, CursorLocationTable[_15].x
	bl	DisplayVertUiHand		@
	ldr	r3, .L1344+8	@ tmp440,
	mov	r8, r3	@ tmp440, tmp440
	adds	r3, r3, #76	@ ivtmp.1181,
.L1269:
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	adds	r3, r3, #4	@ ivtmp.1181,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	subs	r1, r3, #4	@ tmp297, ivtmp.1181,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	ldr	r1, [r1]	@ MEM[(const int *)_175 + 4294967292B], MEM[(const int *)_175 + 4294967292B]
@ Data/FE6_FE7.c:528:         result++;
	adds	r5, r5, #1	@ result,
@ Data/FE6_FE7.c:526:     while (number > pDigitTable[type][result])
	cmp	r1, #254	@ MEM[(const int *)_175 + 4294967292B],
	ble	.L1269		@,
@ Data/FE6_FE7.c:530:     if (result > 9)
	cmp	r5, #9	@ _146,
	ble	.LCB8916	@
	b	.L1339	@long jump	@
.LCB8916:
@ Data/FE6_FE7.c:3757:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _187,
	beq	.L1271		@,
.L1343:
@ Data/FE6_FE7.c:3759:             if (proc->digit > 0)
	movs	r3, #49	@ tmp299,
	ldrsb	r3, [r4, r3]	@ _22,
@ Data/FE6_FE7.c:3759:             if (proc->digit > 0)
	cmp	r3, #0	@ _22,
	bgt	.LCB8923	@
	b	.L1272	@long jump	@
.LCB8923:
@ Data/FE6_FE7.c:3761:                 proc->digit--;
	subs	r3, r3, #1	@ tmp303,
	lsls	r3, r3, #24	@ tmp304, tmp303,
	asrs	r3, r3, #24	@ _26, tmp304,
.L1273:
	movs	r2, #49	@ tmp311,
@ Data/FE6_FE7.c:3768:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _26, proc_95(D)->digit
	bl	RedrawLearnedSkillsMenu		@
.L1271:
@ Data/FE6_FE7.c:3770:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp460, keys,
	bpl	.L1274		@,
@ Data/FE6_FE7.c:3772:             if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp320,
	ldrsb	r3, [r4, r3]	@ _30,
@ Data/FE6_FE7.c:3772:             if (proc->digit < (max_digits - 1))
	subs	r5, r5, #1	@ tmp321,
@ Data/FE6_FE7.c:3772:             if (proc->digit < (max_digits - 1))
	cmp	r3, r5	@ _30, tmp321
	bge	.LCB8945	@
	b	.L1340	@long jump	@
.LCB8945:
@ Data/FE6_FE7.c:3779:                 proc->editing = false;
	movs	r3, #46	@ tmp325,
	movs	r2, #0	@ tmp326,
	strb	r2, [r4, r3]	@ tmp326, proc_95(D)->editing
@ Data/FE6_FE7.c:3778:                 proc->digit = 0;
	movs	r3, #0	@ _35,
.L1276:
	movs	r2, #49	@ tmp328,
@ Data/FE6_FE7.c:3781:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _35, proc_95(D)->digit
	bl	RedrawLearnedSkillsMenu		@
.L1274:
@ Data/FE6_FE7.c:3783:         if (keys & DPAD_UP)
	movs	r3, #64	@ tmp331,
	tst	r3, r6	@ tmp331, keys
	beq	.L1277		@,
@ Data/FE6_FE7.c:3785:             if (proc->tmp[proc->id] == max)
	movs	r2, #48	@ tmp337,
	ldrsb	r1, [r4, r2]	@ tmp338,
	lsls	r1, r1, #1	@ tmp339, tmp338,
	adds	r1, r4, r1	@ _143, proc, tmp339
@ Data/FE6_FE7.c:3785:             if (proc->tmp[proc->id] == max)
	ldrsh	r2, [r1, r3]	@ _38, MEM <s16> [(struct DebuggerProc *)_143 + 64B]
@ Data/FE6_FE7.c:3785:             if (proc->tmp[proc->id] == max)
	cmp	r2, #255	@ _38,
	bne	.LCB8970	@
	b	.L1292	@long jump	@
.LCB8970:
@ Data/FE6_FE7.c:3791:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	movs	r3, #49	@ tmp343,
	ldrsb	r3, [r4, r3]	@ tmp344,
@ Data/FE6_FE7.c:3791:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp345, tmp344,
	add	r3, r3, r8	@ tmp346, tmp440
@ Data/FE6_FE7.c:3791:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_41], DigitDecimalTable[_41]
	adds	r3, r3, r2	@ tmp351, DigitDecimalTable[_41], _38
@ Data/FE6_FE7.c:3792:                 if (proc->tmp[proc->id] > max)
	adds	r2, r3, #0	@ tmp341, tmp351
	lsls	r3, r3, #16	@ tmp354, tmp351,
	asrs	r3, r3, #16	@ tmp354, tmp354,
	cmp	r3, #255	@ tmp354,
	ble	.L1279		@,
	movs	r2, #255	@ tmp341,
.L1279:
	lsls	r3, r2, #16	@ _123, tmp341,
	asrs	r3, r3, #16	@ _123, _123,
.L1278:
@ Data/FE6_FE7.c:3787:                 proc->tmp[proc->id] = min;
	movs	r2, #64	@ tmp356,
@ Data/FE6_FE7.c:3797:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3787:                 proc->tmp[proc->id] = min;
	strh	r3, [r1, r2]	@ _123, MEM <s16> [(struct DebuggerProc *)_143 + 64B]
@ Data/FE6_FE7.c:3797:             RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
.L1277:
@ Data/FE6_FE7.c:3799:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp461, keys,
	bpl	.L1263		@,
@ Data/FE6_FE7.c:3801:             if (proc->tmp[proc->id] == min)
	movs	r3, #48	@ tmp365,
	ldrsb	r1, [r4, r3]	@ tmp366,
	lsls	r1, r1, #1	@ tmp367, tmp366,
@ Data/FE6_FE7.c:3801:             if (proc->tmp[proc->id] == min)
	adds	r3, r3, #16	@ tmp368,
	adds	r1, r4, r1	@ _166, proc, tmp367
	ldrsh	r2, [r1, r3]	@ _48, MEM <s16> [(struct DebuggerProc *)_166 + 64B]
	movs	r3, #255	@ _47,
@ Data/FE6_FE7.c:3801:             if (proc->tmp[proc->id] == min)
	cmp	r2, #0	@ _48,
	beq	.LCB9009	@
	b	.L1341	@long jump	@
.LCB9009:
@ Data/FE6_FE7.c:3803:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp384,
@ Data/FE6_FE7.c:3813:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3803:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _47, MEM <s16> [(struct DebuggerProc *)_166 + 64B]
@ Data/FE6_FE7.c:3813:             RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
.L1263:
@ Data/FE6_FE7.c:3848: }
	add	sp, sp, #8	@,,
	@ sp needed	@
	pop	{r7}
	mov	r8, r7
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1268:
@ Data/FE6_FE7.c:3818:         DisplayUiHand(CursorLocationTable[0].x - ((LearnedSkillNameWidth + 2) * 8), (Y_HAND + (proc->id * 2)) * 8);
	movs	r0, #36	@,
	ldr	r3, .L1344+12	@ tmp386,
	bl	.L17		@
@ Data/FE6_FE7.c:3819:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _187,
	beq	.L1284		@,
@ Data/FE6_FE7.c:3821:             proc->digit = 1;
	movs	r3, #1	@ tmp388,
	movs	r2, #49	@ tmp387,
	strb	r3, [r4, r2]	@ tmp388, proc_95(D)->digit
@ Data/FE6_FE7.c:3822:             proc->editing = true;
	mov	r2, r8	@ tmp282, tmp282
	strb	r3, [r4, r2]	@ tmp388, proc_95(D)->editing
.L1284:
@ Data/FE6_FE7.c:3824:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp462, keys,
	bpl	.L1285		@,
@ Data/FE6_FE7.c:3826:             proc->digit = 0;
	movs	r3, #49	@ tmp400,
	movs	r2, #0	@ tmp401,
	strb	r2, [r4, r3]	@ tmp401, proc_95(D)->digit
@ Data/FE6_FE7.c:3827:             proc->editing = true;
	subs	r3, r3, #3	@ tmp403,
	adds	r2, r2, #1	@ tmp404,
	strb	r2, [r4, r3]	@ tmp404, proc_95(D)->editing
.L1285:
@ Data/FE6_FE7.c:3829:         if (keys & DPAD_UP)
	lsls	r3, r6, #25	@ tmp463, keys,
	bpl	.L1286		@,
@ Data/FE6_FE7.c:3831:             proc->id--;
	movs	r3, #48	@ tmp413,
@ Data/FE6_FE7.c:3831:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp415,
	subs	r3, r3, #1	@ tmp416,
	lsls	r3, r3, #24	@ tmp417, tmp416,
	asrs	r2, r3, #24	@ _67, tmp417,
@ Data/FE6_FE7.c:3832:             if (proc->id < 0)
	cmp	r3, #0	@ tmp417,
	bge	.LCB9067	@
	b	.L1342	@long jump	@
.LCB9067:
@ Data/FE6_FE7.c:3831:             proc->id--;
	movs	r3, #48	@ tmp424,
@ Data/FE6_FE7.c:3836:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3831:             proc->id--;
	strb	r2, [r4, r3]	@ _67, proc_95(D)->id
@ Data/FE6_FE7.c:3836:             RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
.L1286:
@ Data/FE6_FE7.c:3838:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp464, keys,
	bpl	.L1263		@,
@ Data/FE6_FE7.c:3840:             proc->id++;
	movs	r3, #48	@ tmp433,
@ Data/FE6_FE7.c:3840:             proc->id++;
	ldrb	r3, [r4, r3]	@ tmp435,
	adds	r3, r3, #1	@ tmp436,
	lsls	r3, r3, #24	@ tmp437, tmp436,
	asrs	r3, r3, #24	@ _75, tmp437,
@ Data/FE6_FE7.c:3841:             if (proc->id >= limit)
	cmp	r3, r5	@ _75, _96
	blt	.L1289		@,
@ Data/FE6_FE7.c:3843:                 proc->id = 0;
	movs	r3, #0	@ _75,
.L1289:
	movs	r2, #48	@ tmp438,
@ Data/FE6_FE7.c:3845:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _75, MEM <struct DebuggerProc> [(void *)proc_95(D)].id
	bl	RedrawLearnedSkillsMenu		@
@ Data/FE6_FE7.c:3848: }
	b	.L1263		@
.L1339:
@ Data/FE6_FE7.c:530:     if (result > 9)
	movs	r5, #9	@ _146,
@ Data/FE6_FE7.c:3757:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _187,
	bne	.LCB9100	@
	b	.L1271	@long jump	@
.LCB9100:
	b	.L1343		@
.L1338:
@ Data/FE6_FE7.c:3746:             proc->tmp[proc->id],
	adds	r3, r3, #32	@ tmp263,
	lsls	r3, r3, #1	@ tmp264, tmp263,
@ Data/FE6_FE7.c:3745:         TryShowSkillHelp(
	ldrsh	r3, [r3, r4]	@ _6, *proc_95(D)
@ Data/FE6_FE7.c:3600:     if (skillId == 0 || skillId == 0xFF)
	cmp	r3, #0	@ _6,
	bne	.LCB9112	@
	b	.L1267	@long jump	@
.LCB9112:
	cmp	r3, #255	@ _6,
	bne	.LCB9118	@
	b	.L1267	@long jump	@
.LCB9118:
@ Data/FE6_FE7.c:3604:     return SkillDescTable[skillId];
	ldr	r2, .L1344+16	@ tmp276,
	lsls	r3, r3, #1	@ tmp277, _6,
	ldrh	r2, [r3, r2]	@ _151, SkillDescTable
@ Data/FE6_FE7.c:3610:     if (msg)
	cmp	r2, #0	@ _151,
	bne	.LCB9123	@
	b	.L1267	@long jump	@
.LCB9123:
@ Data/FE6_FE7.c:3612:         StartHelpBox(x, y, msg);
	movs	r0, #36	@,
	ldr	r3, .L1344+20	@ tmp278,
	bl	.L17		@
@ Data/FE6_FE7.c:3752:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r7]	@ tmp280,
@ Data/FE6_FE7.c:3752:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r1, #1	@ tmp281,
@ Data/FE6_FE7.c:3752:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ prephitmp_186, tmp281,
	b	.L1267		@
.L1337:
@ Data/FE6_FE7.c:3737:         CloseHelpBox();
	ldr	r3, .L1344+24	@ tmp239,
	bl	.L17		@
@ Data/FE6_FE7.c:3738:         SaveLearnedSkills(proc);
	movs	r0, r4	@, proc
	bl	SaveLearnedSkills		@
@ Data/FE6_FE7.c:3118:     gLCDControlBuffer.bg1cnt.priority = 0;
	movs	r1, #3	@ tmp246,
	ldr	r2, .L1344+28	@ tmp240,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp245, tmp246
	strb	r3, [r2, #16]	@ tmp245, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3119:     SetBackgroundTileDataOffset(2, 0);
	movs	r1, #0	@,
	movs	r0, #2	@,
	ldr	r3, .L1344+32	@ tmp248,
	bl	.L17		@
@ Data/FE6_FE7.c:3120:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp249,
	movs	r2, #0	@,
	str	r3, [sp]	@ tmp249,
	movs	r1, #1	@,
	movs	r0, #0	@,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3121:     BG_Fill(gBG2TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1344+36	@ tmp250,
	ldr	r3, .L1344+40	@ tmp251,
	bl	.L17		@
@ Data/FE6_FE7.c:3122:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT);
	movs	r0, #7	@,
	ldr	r3, .L1344+44	@ tmp252,
	bl	.L17		@
@ Data/FE6_FE7.c:3740:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L1344+48	@ tmp253,
	bl	.L17		@
@ Data/FE6_FE7.c:576: }
	b	.L1266		@
.L1336:
@ Data/FE6_FE7.c:3729:         CloseHelpBox();
	ldr	r3, .L1344+24	@ tmp217,
	bl	.L17		@
@ Data/FE6_FE7.c:3730:         SaveLearnedSkills(proc);
	movs	r0, r4	@, proc
	bl	SaveLearnedSkills		@
@ Data/FE6_FE7.c:3118:     gLCDControlBuffer.bg1cnt.priority = 0;
	movs	r1, #3	@ tmp224,
	ldr	r2, .L1344+28	@ tmp218,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp223, tmp224
	strb	r3, [r2, #16]	@ tmp223, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3119:     SetBackgroundTileDataOffset(2, 0);
	movs	r1, #0	@,
	movs	r0, #2	@,
	ldr	r3, .L1344+32	@ tmp226,
	bl	.L17		@
@ Data/FE6_FE7.c:3120:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp227,
	movs	r2, #0	@,
	str	r3, [sp]	@ tmp227,
	movs	r1, #1	@,
	movs	r0, #0	@,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3121:     BG_Fill(gBG2TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1344+36	@ tmp228,
	ldr	r3, .L1344+40	@ tmp229,
	bl	.L17		@
@ Data/FE6_FE7.c:3122:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT);
	movs	r0, #7	@,
	ldr	r3, .L1344+44	@ tmp230,
	bl	.L17		@
@ Data/FE6_FE7.c:3732:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L1344+48	@ tmp231,
	bl	.L17		@
@ Data/FE6_FE7.c:563: }
	b	.L1265		@
.L1341:
@ Data/FE6_FE7.c:3807:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	subs	r3, r3, #206	@ tmp371,
	ldrsb	r3, [r4, r3]	@ tmp372,
@ Data/FE6_FE7.c:3807:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp373, tmp372,
	add	r3, r3, r8	@ tmp374, tmp440
@ Data/FE6_FE7.c:3807:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	ldr	r0, [r3, #68]	@ DigitDecimalTable[_51], DigitDecimalTable[_51]
	subs	r0, r2, r0	@ tmp379, _48, DigitDecimalTable[_51]
@ Data/FE6_FE7.c:3808:                 if (proc->tmp[proc->id] < min)
	lsls	r3, r0, #16	@ tmp382, tmp379,
	asrs	r3, r3, #16	@ tmp382, tmp382,
	mvns	r3, r3	@ tmp446, tmp382
@ Data/FE6_FE7.c:3803:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp384,
@ Data/FE6_FE7.c:3808:                 if (proc->tmp[proc->id] < min)
	asrs	r3, r3, #31	@ tmp450, tmp446,
	ands	r3, r0	@ tmp369, tmp379
	lsls	r3, r3, #16	@ _47, tmp369,
	asrs	r3, r3, #16	@ _47, _47,
@ Data/FE6_FE7.c:3813:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3803:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _47, MEM <s16> [(struct DebuggerProc *)_166 + 64B]
@ Data/FE6_FE7.c:3813:             RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
	b	.L1263		@
.L1340:
@ Data/FE6_FE7.c:3774:                 proc->digit++;
	adds	r3, r3, #1	@ tmp323,
	lsls	r3, r3, #24	@ tmp324, tmp323,
	asrs	r3, r3, #24	@ _35, tmp324,
	b	.L1276		@
.L1342:
@ Data/FE6_FE7.c:3831:             proc->id--;
	movs	r3, #48	@ tmp424,
@ Data/FE6_FE7.c:3834:                 proc->id = limit - 1;
	subs	r2, r5, #1	@ _67, _96,
@ Data/FE6_FE7.c:3836:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3831:             proc->id--;
	strb	r2, [r4, r3]	@ _67, proc_95(D)->id
@ Data/FE6_FE7.c:3836:             RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
	b	.L1286		@
.L1272:
@ Data/FE6_FE7.c:3766:                 proc->editing = false;
	movs	r2, #46	@ tmp308,
	movs	r1, #0	@ tmp309,
@ Data/FE6_FE7.c:3765:                 proc->digit = max_digits - 1;
	subs	r3, r5, #1	@ tmp306, _146,
	lsls	r3, r3, #24	@ tmp307, tmp306,
@ Data/FE6_FE7.c:3766:                 proc->editing = false;
	strb	r1, [r4, r2]	@ tmp309, proc_95(D)->editing
@ Data/FE6_FE7.c:3765:                 proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _26, tmp307,
	b	.L1273		@
.L1292:
	movs	r3, #0	@ _123,
	b	.L1278		@
.L1290:
@ Data/FE6_FE7.c:3561:         return 0;
	movs	r5, #0	@ _96,
	b	.L1264		@
.L1345:
	.align	2
.L1344:
	.word	gKeyStatusPtr
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	DisplayUiHand
	.word	SkillDescTable
	.word	StartHelpBox
	.word	CloseHelpBox
	.word	gLCDControlBuffer
	.word	SetBackgroundTileDataOffset
	.word	gBG2TilemapBuffer
	.word	BG_Fill
	.word	BG_EnableSyncByMask
	.word	Proc_Goto
	.size	EditSkillsIdle, .-EditSkillsIdle
	.global	CheatCodeKeyListenerCmd
	.section	.rodata.str1.4
	.align	2
.LC624:
	.ascii	"CheatCodeKeyListenerProc\000"
	.global	KonamiCodeSequence
	.global	StatCapLookup
	.global	gDebuggerMenuDefPage3
	.global	gDebuggerMenuDefPage2
	.global	gDebuggerMenuDef
	.global	DebuggerProcCmdIdler
	.align	2
.LC625:
	.ascii	"DebuggerProcIdler\000"
	.global	DebuggerProcCmd
	.align	2
.LC626:
	.ascii	"DebuggerProcName\000"
	.global	BgTilemapBuffers_
	.global	gEkrBg2QuakeVec
	.bss
	.align	2
	.type	gEkrBg2QuakeVec, %object
	.size	gEkrBg2QuakeVec, 4
gEkrBg2QuakeVec:
	.space	4
	.section	.rodata
	.align	2
	.set	.LANCHOR0,. + 0
	.set	.LANCHOR1,. + 128
	.set	.LANCHOR2,. + 256
	.type	sSprite_VertHand, %object
	.size	sSprite_VertHand, 8
sSprite_VertHand:
	.short	1
	.short	2
	.short	16384
	.short	6
	.type	sHandVOffsetLookup, %object
	.size	sHandVOffsetLookup, 32
sHandVOffsetLookup:
	.ascii	"\000\000\000\000\000\000\000\001\001\002\002\002\003"
	.ascii	"\003\003\003\004\004\004\004\004\004\004\003\003\002"
	.ascii	"\002\002\001\001\001\001"
	.type	KonamiCodeSequence, %object
	.size	KonamiCodeSequence, 24
KonamiCodeSequence:
	.short	64
	.short	64
	.short	128
	.short	128
	.short	32
	.short	16
	.short	32
	.short	16
	.short	2
	.short	1
	.short	0
	.short	0
	.type	BgTilemapBuffers_, %object
	.size	BgTilemapBuffers_, 16
BgTilemapBuffers_:
	.word	gBG0TilemapBuffer
	.word	gBG1TilemapBuffer
	.word	gBG2TilemapBuffer
	.word	gBG3TilemapBuffer
	.type	DebuggerProcCmdIdler, %object
	.size	DebuggerProcCmdIdler, 32
DebuggerProcCmdIdler:
@ opcode:
	.short	1
@ dataImm:
	.short	0
@ dataPtr:
	.word	.LC625
@ opcode:
	.short	14
@ dataImm:
	.short	0
@ dataPtr:
	.word	0
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	LoopDebuggerProc
@ opcode:
	.short	0
@ dataImm:
	.short	0
@ dataPtr:
	.word	0
	.type	pDigitTable, %object
	.size	pDigitTable, 8
pDigitTable:
	.word	DigitDecimalTable
	.word	DigitHexTable
	.type	CursorLocationTable, %object
	.size	CursorLocationTable, 64
CursorLocationTable:
@ x:
	.word	148
@ y:
	.word	16
@ x:
	.word	140
@ y:
	.word	16
@ x:
	.word	132
@ y:
	.word	16
@ x:
	.word	124
@ y:
	.word	16
@ x:
	.word	116
@ y:
	.word	16
@ x:
	.word	108
@ y:
	.word	16
@ x:
	.word	100
@ y:
	.word	16
@ x:
	.word	92
@ y:
	.word	16
	.type	StatCapLookup, %object
	.size	StatCapLookup, 9
StatCapLookup:
	.ascii	"cc???????"
	.space	3
	.type	DigitDecimalTable, %object
	.size	DigitDecimalTable, 36
DigitDecimalTable:
	.word	1
	.word	10
	.word	100
	.word	1000
	.word	10000
	.word	100000
	.word	1000000
	.word	10000000
	.word	100000000
	.type	DigitHexTable, %object
	.size	DigitHexTable, 36
DigitHexTable:
	.word	1
	.word	16
	.word	256
	.word	4096
	.word	65536
	.word	1048576
	.word	16777216
	.word	268435456
	.word	2147483647
	.type	gDebuggerMenuDef, %object
	.size	gDebuggerMenuDef, 36
gDebuggerMenuDef:
@ rect:
@ x:
	.byte	1
@ y:
	.byte	0
@ w:
	.byte	9
@ h:
	.byte	0
@ style:
	.byte	0
@ menuItems:
	.space	3
	.word	gDebuggerMenuItems
@ onInit:
	.word	0
@ onEnd:
	.word	0
@ _u14:
	.word	0
@ onBPress:
	.word	MenuCancelSelectResumePlayerPhase
@ onRPress:
	.word	MenuAutoHelpBoxSelect
@ onHelpBox:
	.word	DebuggerHelpBox
	.type	gDebuggerMenuDefPage2, %object
	.size	gDebuggerMenuDefPage2, 36
gDebuggerMenuDefPage2:
@ rect:
@ x:
	.byte	1
@ y:
	.byte	0
@ w:
	.byte	9
@ h:
	.byte	0
@ style:
	.byte	0
@ menuItems:
	.space	3
	.word	gDebuggerMenuItemsPage2
@ onInit:
	.word	0
@ onEnd:
	.word	0
@ _u14:
	.word	0
@ onBPress:
	.word	MenuCancelSelectResumePlayerPhase
@ onRPress:
	.word	MenuAutoHelpBoxSelect
@ onHelpBox:
	.word	DebuggerHelpBox
	.type	gDebuggerMenuDefPage3, %object
	.size	gDebuggerMenuDefPage3, 36
gDebuggerMenuDefPage3:
@ rect:
@ x:
	.byte	1
@ y:
	.byte	0
@ w:
	.byte	9
@ h:
	.byte	0
@ style:
	.byte	0
@ menuItems:
	.space	3
	.word	gDebuggerMenuItemsPage3
@ onInit:
	.word	0
@ onEnd:
	.word	0
@ _u14:
	.word	0
@ onBPress:
	.word	MenuCancelSelectResumePlayerPhase
@ onRPress:
	.word	MenuAutoHelpBoxSelect
@ onHelpBox:
	.word	DebuggerHelpBox
	.type	CheatCodeKeyListenerCmd, %object
	.size	CheatCodeKeyListenerCmd, 32
CheatCodeKeyListenerCmd:
@ opcode:
	.short	1
@ dataImm:
	.short	0
@ dataPtr:
	.word	.LC624
@ opcode:
	.short	14
@ dataImm:
	.short	0
@ dataPtr:
	.word	0
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	CheckKeysForCheatCode
@ opcode:
	.short	0
@ dataImm:
	.short	0
@ dataPtr:
	.word	0
	.type	states, %object
	.size	states, 512
states:
	.ascii	"Acting\000"
	.space	9
	.ascii	"Acted\000"
	.space	10
	.ascii	"Dead\000"
	.space	11
	.ascii	"Undeployed\000"
	.space	5
	.ascii	"Rescuing\000"
	.space	7
	.ascii	"Rescued\000"
	.space	8
	.ascii	"Cantoed\000"
	.space	8
	.ascii	"Under roof\000"
	.space	5
	.ascii	"Spotted\000"
	.space	8
	.ascii	"Concealed\000"
	.space	6
	.ascii	"AI decided\000"
	.space	5
	.ascii	"In ballista\000"
	.space	4
	.ascii	"Drop item\000"
	.space	6
	.ascii	"Afa's drops\000"
	.space	4
	.ascii	"Solo anim1\000"
	.space	5
	.ascii	"Solo anim2\000"
	.space	5
	.ascii	"Escaped\000"
	.space	8
	.ascii	"Arena 1\000"
	.space	8
	.ascii	"Arena 2\000"
	.space	8
	.ascii	"Super arena\000"
	.space	4
	.ascii	"Unk 25\000"
	.space	9
	.ascii	"Benched\000"
	.space	8
	.ascii	"Scene unit\000"
	.space	5
	.ascii	"Portrait+1\000"
	.space	5
	.ascii	"Shake\000"
	.space	10
	.ascii	"Can't deploy\000"
	.space	3
	.ascii	"Departed\000"
	.space	7
	.ascii	"4th palette\000"
	.space	4
	.ascii	"Unk 35\000"
	.space	9
	.ascii	"Unk 36\000"
	.space	9
	.ascii	"Capture\000"
	.space	8
	.ascii	"Unk 38\000"
	.space	9
	.type	StateCursorLocationTable, %object
	.size	StateCursorLocationTable, 256
StateCursorLocationTable:
@ x:
	.word	8
@ y:
	.word	16
@ x:
	.word	8
@ y:
	.word	32
@ x:
	.word	8
@ y:
	.word	48
@ x:
	.word	8
@ y:
	.word	64
@ x:
	.word	8
@ y:
	.word	80
@ x:
	.word	8
@ y:
	.word	96
@ x:
	.word	8
@ y:
	.word	112
@ x:
	.word	8
@ y:
	.word	128
@ x:
	.word	64
@ y:
	.word	16
@ x:
	.word	64
@ y:
	.word	32
@ x:
	.word	64
@ y:
	.word	48
@ x:
	.word	64
@ y:
	.word	64
@ x:
	.word	64
@ y:
	.word	80
@ x:
	.word	64
@ y:
	.word	96
@ x:
	.word	64
@ y:
	.word	112
@ x:
	.word	64
@ y:
	.word	128
@ x:
	.word	120
@ y:
	.word	16
@ x:
	.word	120
@ y:
	.word	32
@ x:
	.word	120
@ y:
	.word	48
@ x:
	.word	120
@ y:
	.word	64
@ x:
	.word	120
@ y:
	.word	80
@ x:
	.word	120
@ y:
	.word	96
@ x:
	.word	120
@ y:
	.word	112
@ x:
	.word	120
@ y:
	.word	128
@ x:
	.word	176
@ y:
	.word	16
@ x:
	.word	176
@ y:
	.word	32
@ x:
	.word	176
@ y:
	.word	48
@ x:
	.word	176
@ y:
	.word	64
@ x:
	.word	176
@ y:
	.word	80
@ x:
	.word	176
@ y:
	.word	96
@ x:
	.word	176
@ y:
	.word	112
@ x:
	.word	176
@ y:
	.word	128
	.type	DebuggerProcCmd, %object
	.size	DebuggerProcCmd, 592
DebuggerProcCmd:
@ opcode:
	.short	1
@ dataImm:
	.short	0
@ dataPtr:
	.word	.LC626
@ opcode:
	.short	14
@ dataImm:
	.short	0
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	0
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	1
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	UnlockGameIfNeeded
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	EndPlayerPhaseSideWindows
@ opcode:
	.short	14
@ dataImm:
	.short	1
@ dataPtr:
	.word	0
@ opcode:
	.short	20
@ dataImm:
	.short	0
@ dataPtr:
	.word	DoesBMXFADEExist
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	SetAllUnitNotBackSprite
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	RefreshUnitSprites
@ opcode:
	.short	22
@ dataImm:
	.short	0
@ dataPtr:
	.word	ClearActiveUnitStuff
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	RestartDebuggerMenu
@ opcode:
	.short	11
@ dataImm:
	.short	20
@ dataPtr:
	.word	0
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	LoopDebuggerProc
@ opcode:
	.short	11
@ dataImm:
	.short	3
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	PlayerPhase_ApplyUnitMovementWithoutMenu
@ opcode:
	.short	8
@ dataImm:
	.short	0
@ dataPtr:
	.word	gProcScr_CamMove
@ opcode:
	.short	22
@ dataImm:
	.short	0
@ dataPtr:
	.word	PlayerPhase_PrepareActionBasic
@ opcode:
	.short	14
@ dataImm:
	.short	1
@ dataPtr:
	.word	0
@ opcode:
	.short	22
@ dataImm:
	.short	0
@ dataPtr:
	.word	UnitActionFunc
@ opcode:
	.short	11
@ dataImm:
	.short	2
@ dataPtr:
	.word	0
@ opcode:
	.short	22
@ dataImm:
	.short	0
@ dataPtr:
	.word	HandlePostActionTraps
@ opcode:
	.short	22
@ dataImm:
	.short	0
@ dataPtr:
	.word	RunPotentialWaitEvents
@ opcode:
	.short	22
@ dataImm:
	.short	0
@ dataPtr:
	.word	EnsureCameraOntoActiveUnitPosition
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	CallPlayerPhase_FinishAction
@ opcode:
	.short	12
@ dataImm:
	.short	99
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	13
@ dataPtr:
	.word	0
@ opcode:
	.short	14
@ dataImm:
	.short	5
@ dataPtr:
	.word	0
@ opcode:
	.short	20
@ dataImm:
	.short	0
@ dataPtr:
	.word	BattleEventEngineExists
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	DeleteBattleAnimInfoThing
@ opcode:
	.short	14
@ dataImm:
	.short	1
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	MapAnimProc_DisplayExpBar
@ opcode:
	.short	14
@ dataImm:
	.short	0
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	MapAnim_MoveCameraOntoSubject
@ opcode:
	.short	14
@ dataImm:
	.short	2
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	UpdateActorFromBattle
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	MapAnim_Cleanup
@ opcode:
	.short	12
@ dataImm:
	.short	1
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	4
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	ResetUnitSpriteHover
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	PickupUnitIdle
@ opcode:
	.short	12
@ dataImm:
	.short	99
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	9
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditStatsInit
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditStatsIdle
@ opcode:
	.short	12
@ dataImm:
	.short	99
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	10
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditItemsInit
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditItemsIdle
@ opcode:
	.short	12
@ dataImm:
	.short	99
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	11
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditMiscInit
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditMiscIdle
@ opcode:
	.short	12
@ dataImm:
	.short	99
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	14
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	StateInit
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	StateIdle
@ opcode:
	.short	12
@ dataImm:
	.short	99
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	16
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditWExpInit
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditWExpIdle
@ opcode:
	.short	12
@ dataImm:
	.short	99
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	17
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditSupportsInit
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditSupportsIdle
@ opcode:
	.short	12
@ dataImm:
	.short	99
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	21
@ dataPtr:
	.word	0
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditSkillsInit
@ opcode:
	.short	3
@ dataImm:
	.short	0
@ dataPtr:
	.word	EditSkillsIdle
@ opcode:
	.short	12
@ dataImm:
	.short	99
@ dataPtr:
	.word	0
@ opcode:
	.short	11
@ dataImm:
	.short	99
@ dataPtr:
	.word	0
@ opcode:
	.short	22
@ dataImm:
	.short	0
@ dataPtr:
	.word	ClearActiveUnitStuff
@ opcode:
	.short	2
@ dataImm:
	.short	0
@ dataPtr:
	.word	SaveProcVarsToIdler
@ opcode:
	.short	0
@ dataImm:
	.short	0
@ dataPtr:
	.word	0
	.ident	"GCC: (devkitARM release 63) 13.2.0"
	.text
	.code 16
	.align	1
.L17:
	bx	r3
.L27:
	bx	r4
.L28:
	bx	r5
.L38:
	bx	r6
.L145:
	bx	r7
.L193:
	bx	r8
.L139:
	bx	r9
.L310:
	bx	r10
.L311:
	bx	fp
