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
@ Data/FE6_FE7.c:386: }
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
@ Data/FE6_FE7.c:2634: }
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
@ Data/FE6_FE7.c:2640: }
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
@ Data/FE6_FE7.c:3347:     if (!unit || !unit->pCharacterData)
	cmp	r0, #0	@ unit,
	beq	.L8		@,
@ Data/FE6_FE7.c:3347:     if (!unit || !unit->pCharacterData)
	ldr	r3, [r0]	@ _1, unit_11(D)->pCharacterData
@ Data/FE6_FE7.c:3347:     if (!unit || !unit->pCharacterData)
	cmp	r3, #0	@ _1,
	beq	.L8		@,
@ Data/FE6_FE7.c:3351:     pid = unit->pCharacterData->number;
	ldrb	r4, [r3, #4]	@ _3,
@ Data/FE6_FE7.c:3352:     if (pid < 1 || pid > 0x45)
	subs	r3, r4, #1	@ tmp124, _3,
@ Data/FE6_FE7.c:3352:     if (pid < 1 || pid > 0x45)
	cmp	r3, #68	@ tmp124,
	bhi	.L8		@,
@ Data/FE6_FE7.c:3356:     if (!((void * (*)(int))(0x080A0550 | 1))(pid))
	movs	r0, r4	@, _3
	ldr	r3, .L15	@ tmp125,
	bl	.L17		@
@ Data/FE6_FE7.c:3356:     if (!((void * (*)(int))(0x080A0550 | 1))(pid))
	cmp	r0, #0	@ tmp131,
	beq	.L8		@,
@ Data/FE6_FE7.c:3360:     return gBwlSupportExp + pid * SupportOptions;
	ldr	r3, .L15+4	@ tmp133,
	mov	ip, r3	@ tmp133, tmp133
@ Data/FE6_FE7.c:3360:     return gBwlSupportExp + pid * SupportOptions;
	lsls	r0, r4, #3	@ tmp127, _3,
	subs	r0, r0, r4	@ tmp128, tmp127, _3
@ Data/FE6_FE7.c:3360:     return gBwlSupportExp + pid * SupportOptions;
	add	r0, r0, ip	@ <retval>, tmp133
.L5:
@ Data/FE6_FE7.c:3361: }
	@ sp needed	@
	pop	{r4}
	pop	{r1}
	bx	r1
.L8:
@ Data/FE6_FE7.c:3349:         return NULL;
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
@ Data/FE6_FE7.c:229:     int locked = GetGameLock();
	ldr	r4, .L25	@ tmp123,
	bl	.L27		@
@ Data/FE6_FE7.c:230:     while (locked)
	cmp	r0, #0	@ tmp125,
	beq	.L18		@,
	ldr	r5, .L25+4	@ tmp124,
.L20:
@ Data/FE6_FE7.c:232:         UnlockGame();
	bl	.L28		@
@ Data/FE6_FE7.c:233:         locked = GetGameLock();
	bl	.L27		@
@ Data/FE6_FE7.c:230:     while (locked)
	cmp	r0, #0	@ tmp126,
	bne	.L20		@,
.L18:
@ Data/FE6_FE7.c:235: }
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
@ Data/FE6_FE7.c:2645:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L30	@ tmp119,
@ Data/FE6_FE7.c:2648: }
	@ sp needed	@
@ Data/FE6_FE7.c:2645:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L30+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2646:     Proc_Goto(proc, EndLabel);
	movs	r1, #99	@,
	ldr	r3, .L30+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2648: }
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
@ Data/FE6_FE7.c:433:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	ldr	r6, .L36	@ tmp161,
@ Data/FE6_FE7.c:432: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:432: {
	movs	r4, r0	@ x, tmp164
	movs	r5, r1	@ y, tmp165
@ Data/FE6_FE7.c:433:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	bl	.L38		@
@ Data/FE6_FE7.c:433:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	ldr	r7, .L36+4	@ tmp162,
@ Data/FE6_FE7.c:433:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	ldr	r3, [r7]	@ sPrevHandClockFrame, sPrevHandClockFrame
@ Data/FE6_FE7.c:433:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	subs	r0, r0, #1	@ tmp138,
@ Data/FE6_FE7.c:433:     if ((int)(GetGameClock() - 1) == sPrevHandClockFrame)
	cmp	r0, r3	@ tmp138, sPrevHandClockFrame
	beq	.L35		@,
	ldr	r3, .L36+8	@ tmp163,
.L33:
@ Data/FE6_FE7.c:439:     sPrevHandScreenPosition.x = x;
	strh	r4, [r3]	@ x, sPrevHandScreenPosition.x
@ Data/FE6_FE7.c:440:     sPrevHandScreenPosition.y = y;
	strh	r5, [r3, #2]	@ y, sPrevHandScreenPosition.y
@ Data/FE6_FE7.c:441:     sPrevHandClockFrame = GetGameClock();
	bl	.L38		@
@ Data/FE6_FE7.c:441:     sPrevHandClockFrame = GetGameClock();
	str	r0, [r7]	@ tmp167, sPrevHandClockFrame
@ Data/FE6_FE7.c:443:     y += (sHandVOffsetLookup[Mod(GetGameClock(), ARRAY_COUNT(sHandVOffsetLookup))] - 14);
	bl	.L38		@
@ Data/FE6_FE7.c:443:     y += (sHandVOffsetLookup[Mod(GetGameClock(), ARRAY_COUNT(sHandVOffsetLookup))] - 14);
	movs	r1, #32	@,
	ldr	r3, .L36+12	@ tmp152,
	bl	.L17		@
@ Data/FE6_FE7.c:444:     PutSprite(2, x, y, sSprite_VertHand, 0);
	movs	r1, #0	@ tmp159,
	ldr	r3, .L36+16	@ tmp153,
@ Data/FE6_FE7.c:443:     y += (sHandVOffsetLookup[Mod(GetGameClock(), ARRAY_COUNT(sHandVOffsetLookup))] - 14);
	adds	r0, r3, r0	@ tmp155, tmp153, tmp169
	ldrb	r2, [r0, #8]	@ tmp156, sHandVOffsetLookup
@ Data/FE6_FE7.c:443:     y += (sHandVOffsetLookup[Mod(GetGameClock(), ARRAY_COUNT(sHandVOffsetLookup))] - 14);
	subs	r2, r2, #14	@ tmp157,
@ Data/FE6_FE7.c:444:     PutSprite(2, x, y, sSprite_VertHand, 0);
	str	r1, [sp]	@ tmp159,
	movs	r0, #2	@,
	movs	r1, r4	@, x
@ Data/FE6_FE7.c:443:     y += (sHandVOffsetLookup[Mod(GetGameClock(), ARRAY_COUNT(sHandVOffsetLookup))] - 14);
	adds	r2, r2, r5	@ y, tmp157, y
@ Data/FE6_FE7.c:444:     PutSprite(2, x, y, sSprite_VertHand, 0);
	ldr	r4, .L36+20	@ tmp160,
	bl	.L27		@
@ Data/FE6_FE7.c:445: }
	add	sp, sp, #12	@,,
	@ sp needed	@
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L35:
@ Data/FE6_FE7.c:435:         x = (x + sPrevHandScreenPosition.x) >> 1;
	ldr	r3, .L36+8	@ tmp163,
	movs	r1, #0	@ tmp171,
	ldrsh	r2, [r3, r1]	@ sPrevHandScreenPosition, tmp163, tmp171
@ Data/FE6_FE7.c:435:         x = (x + sPrevHandScreenPosition.x) >> 1;
	adds	r4, r2, r4	@ _7, sPrevHandScreenPosition, x
@ Data/FE6_FE7.c:436:         y = (y + sPrevHandScreenPosition.y) >> 1;
	movs	r1, #2	@ tmp172,
	ldrsh	r2, [r3, r1]	@ tmp144, tmp163, tmp172
@ Data/FE6_FE7.c:436:         y = (y + sPrevHandScreenPosition.y) >> 1;
	adds	r5, r2, r5	@ _10, tmp144, y
@ Data/FE6_FE7.c:435:         x = (x + sPrevHandScreenPosition.x) >> 1;
	asrs	r4, r4, #1	@ x, _7,
@ Data/FE6_FE7.c:436:         y = (y + sPrevHandScreenPosition.y) >> 1;
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
@ Data/FE6_FE7.c:2037:     gActiveUnit->xPos = gActionData.xMove;
	ldr	r3, .L40	@ tmp118,
@ Data/FE6_FE7.c:2041: }
	@ sp needed	@
@ Data/FE6_FE7.c:2037:     gActiveUnit->xPos = gActionData.xMove;
	ldr	r0, [r3]	@ gActiveUnit.48_2, gActiveUnit
@ Data/FE6_FE7.c:2037:     gActiveUnit->xPos = gActionData.xMove;
	ldr	r3, .L40+4	@ tmp119,
@ Data/FE6_FE7.c:2037:     gActiveUnit->xPos = gActionData.xMove;
	ldrh	r3, [r3, #14]	@ MEM <vector(2) unsigned char> [(unsigned char *)&gActionData + 14B], MEM <vector(2) unsigned char> [(unsigned char *)&gActionData + 14B]
	strh	r3, [r0, #16]	@ MEM <vector(2) unsigned char> [(unsigned char *)&gActionData + 14B], MEM <vector(2) signed char> [(signed char *)gActiveUnit.48_2 + 16B]
@ Data/FE6_FE7.c:2039:     UnitFinalizeMovement(gActiveUnit);
	ldr	r3, .L40+8	@ tmp122,
	bl	.L17		@
@ Data/FE6_FE7.c:2040:     ResetTextFont();
	ldr	r3, .L40+12	@ tmp123,
	bl	.L17		@
@ Data/FE6_FE7.c:2041: }
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
@ Data/FE6_FE7.c:2167:     MU_EndAll();
	ldr	r3, .L55	@ tmp140,
@ Data/FE6_FE7.c:2166: {
	push	{r7, lr}	@
@ Data/FE6_FE7.c:2166: {
	mov	r9, r0	@ proc, tmp189
@ Data/FE6_FE7.c:2167:     MU_EndAll();
	bl	.L17		@
@ Data/FE6_FE7.c:2168:     if (gActiveUnit)
	ldr	r3, .L55+4	@ tmp141,
	ldr	r3, [r3]	@ gActiveUnit.54_1, gActiveUnit
@ Data/FE6_FE7.c:2168:     if (gActiveUnit)
	cmp	r3, #0	@ gActiveUnit.54_1,
	beq	.L43		@,
@ Data/FE6_FE7.c:2170:         if (!(gActiveUnit->state & (US_DEAD | US_NOT_DEPLOYED | US_BIT16)))
	ldr	r2, [r3, #12]	@ _2, gActiveUnit.54_1->state
@ Data/FE6_FE7.c:2170:         if (!(gActiveUnit->state & (US_DEAD | US_NOT_DEPLOYED | US_BIT16)))
	ldr	r1, .L55+8	@ tmp143,
@ Data/FE6_FE7.c:2170:         if (!(gActiveUnit->state & (US_DEAD | US_NOT_DEPLOYED | US_BIT16)))
	tst	r2, r1	@ _2, tmp143
	beq	.L54		@,
.L43:
@ Data/FE6_FE7.c:2178:     s8 cameraReturn = EnsureCameraOntoPositionIfValid(proc, gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	ldr	r5, .L55+12	@ tmp146,
	movs	r2, #0	@ tmp193,
	ldrsh	r3, [r5, r2]	@ _5, tmp146, tmp193
@ Data/FE6_FE7.c:2178:     s8 cameraReturn = EnsureCameraOntoPositionIfValid(proc, gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	movs	r1, #2	@ tmp194,
	ldrsh	r2, [r5, r1]	@ _7, tmp146, tmp194
@ Data/FE6_FE7.c:1998:     if (y < 0)
	movs	r1, r3	@ tmp151, _5
	movs	r4, #1	@ <retval>,
	orrs	r1, r2	@ tmp151, _7
	bmi	.L44		@,
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	ldr	r6, .L55+16	@ tmp186,
	movs	r7, #0	@ tmp195,
	ldrsh	r1, [r6, r7]	@ gBmMapSize, tmp186, tmp195
@ Data/FE6_FE7.c:2178:     s8 cameraReturn = EnsureCameraOntoPositionIfValid(proc, gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	movs	r0, r3	@ _10, _5
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	cmp	r3, r1	@ _5, gBmMapSize
	bge	.L44		@,
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	movs	r1, #2	@ tmp196,
	ldrsh	r7, [r6, r1]	@ tmp155, tmp186, tmp196
@ Data/FE6_FE7.c:2178:     s8 cameraReturn = EnsureCameraOntoPositionIfValid(proc, gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	mov	r8, r2	@ _12, _7
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	cmp	r2, r7	@ _7, tmp155
	bge	.L45		@,
@ Data/FE6_FE7.c:2018:     return EnsureCameraOntoPosition(proc, x, y);
	movs	r1, r3	@, _5
	mov	r0, r9	@, proc
	ldr	r3, .L55+20	@ tmp156,
	bl	.L17		@
@ Data/FE6_FE7.c:2179:     cameraReturn ^= 1;
	movs	r3, #1	@ tmp159,
	eors	r0, r3	@ tmp161, tmp159
	lsls	r4, r0, #24	@ tmp162, tmp161,
@ Data/FE6_FE7.c:2180:     SetCursorMapPositionIfValid(gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	movs	r3, #0	@ tmp197,
	ldrsh	r0, [r5, r3]	@ _9, tmp146, tmp197
@ Data/FE6_FE7.c:2180:     SetCursorMapPositionIfValid(gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	movs	r3, #2	@ tmp198,
	ldrsh	r1, [r5, r3]	@ _11, tmp146, tmp198
@ Data/FE6_FE7.c:1998:     if (y < 0)
	movs	r3, r0	@ tmp168, _10
@ Data/FE6_FE7.c:2180:     SetCursorMapPositionIfValid(gActiveUnitMoveOrigin.x, gActiveUnitMoveOrigin.y);
	mov	r8, r1	@ _12, _11
@ Data/FE6_FE7.c:2179:     cameraReturn ^= 1;
	asrs	r4, r4, #24	@ cameraReturn, tmp162,
@ Data/FE6_FE7.c:1998:     if (y < 0)
	orrs	r3, r1	@ tmp168, _12
	bmi	.L44		@,
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	movs	r2, #0	@ tmp199,
	ldrsh	r3, [r6, r2]	@ gBmMapSize, tmp186, tmp199
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	cmp	r0, r3	@ _10, gBmMapSize
	bge	.L44		@,
.L45:
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	movs	r2, #2	@ tmp200,
	ldrsh	r3, [r6, r2]	@ tmp172, tmp186, tmp200
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	cmp	r8, r3	@ _12, tmp172
	bge	.L44		@,
@ Data/FE6_FE7.c:2026:     SetCursorMapPosition(x, y);
	mov	r1, r8	@, _12
	ldr	r3, .L55+24	@ tmp173,
	bl	.L17		@
.L44:
@ Data/FE6_FE7.c:2189: }
	@ sp needed	@
@ Data/FE6_FE7.c:2181:     gBmSt.gameStateBits &= ~BM_FLAG_3;
	movs	r1, #8	@ tmp179,
	ldr	r2, .L55+28	@ tmp174,
	ldrb	r3, [r2, #4]	@ tmp177,
	bics	r3, r1	@ tmp178, tmp179
	strb	r3, [r2, #4]	@ tmp178, gBmSt.gameStateBits
@ Data/FE6_FE7.c:2183:     HideMoveRangeGraphics();
	ldr	r3, .L55+32	@ tmp181,
	bl	.L17		@
@ Data/FE6_FE7.c:2185:     RefreshEntityBmMaps();
	ldr	r3, .L55+36	@ tmp182,
	bl	.L17		@
@ Data/FE6_FE7.c:2186:     RefreshUnitSprites();
	ldr	r3, .L55+40	@ tmp183,
	bl	.L17		@
@ Data/FE6_FE7.c:2187:     RenderBmMap();
	ldr	r3, .L55+44	@ tmp184,
	bl	.L17		@
@ Data/FE6_FE7.c:2189: }
	movs	r0, r4	@, <retval>
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L54:
@ Data/FE6_FE7.c:2174:             gActiveUnit->state &= ~(US_HIDDEN | US_UNSELECTABLE | US_CANTOING);
	movs	r1, #67	@ tmp145,
	bics	r2, r1	@ tmp144, tmp145
	str	r2, [r3, #12]	@ tmp144, gActiveUnit.54_1->state
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
@ Data/FE6_FE7.c:2568:     int keys = gKeyStatusPtr->newKeys;
	ldr	r5, .L74	@ tmp182,
	ldr	r3, [r5]	@ gKeyStatusPtr.71_1, gKeyStatusPtr
	ldrh	r4, [r3, #8]	@ _2,
@ Data/FE6_FE7.c:2567: {
	movs	r6, r0	@ proc, tmp183
@ Data/FE6_FE7.c:2569:     if (!keys)
	cmp	r4, #0	@ _2,
	beq	.L57		@,
@ Data/FE6_FE7.c:2574:     if (KonamiCodeEnabled)
	ldr	r2, .L74+4	@ tmp137,
@ Data/FE6_FE7.c:2574:     if (KonamiCodeEnabled)
	ldr	r2, [r2]	@ KonamiCodeEnabled, KonamiCodeEnabled
	cmp	r2, #0	@ KonamiCodeEnabled,
	beq	.L61		@,
@ Data/FE6_FE7.c:2576:         if (KonamiCodeSequence[proc->id] & keys)
	ldr	r2, [r0, #44]	@ _4, proc_19(D)->id
@ Data/FE6_FE7.c:2576:         if (KonamiCodeSequence[proc->id] & keys)
	ldr	r0, .L74+8	@ tmp139,
	lsls	r1, r2, #1	@ tmp140, _4,
	adds	r1, r0, r1	@ tmp141, tmp139, tmp140
@ Data/FE6_FE7.c:2576:         if (KonamiCodeSequence[proc->id] & keys)
	ldrh	r1, [r1, #40]	@ tmp144, KonamiCodeSequence
	tst	r1, r4	@ tmp144, _2
	beq	.L62		@,
@ Data/FE6_FE7.c:2578:             proc->id++;
	adds	r2, r2, #1	@ _6,
	str	r2, [r6, #44]	@ _6, proc_19(D)->id
@ Data/FE6_FE7.c:2591:         if (!KonamiCodeSequence[proc->id])
	lsls	r2, r2, #1	@ tmp151, _6,
	adds	r0, r0, r2	@ tmp152, tmp139, tmp151
@ Data/FE6_FE7.c:2591:         if (!KonamiCodeSequence[proc->id])
	ldrh	r2, [r0, #40]	@ tmp154, KonamiCodeSequence
	cmp	r2, #0	@ tmp154,
	bne	.L61		@,
@ Data/FE6_FE7.c:2593:             ToggleFlag(DebuggerTurnedOff_Flag);
	ldr	r3, .L74+12	@ tmp161,
	ldr	r7, [r3]	@ DebuggerTurnedOff_Flag.73_9, DebuggerTurnedOff_Flag
@ Data/FE6_FE7.c:2556:     if (CheckFlag(flag))
	ldr	r3, .L74+16	@ tmp162,
	movs	r0, r7	@, DebuggerTurnedOff_Flag.73_9
	bl	.L17		@
@ Data/FE6_FE7.c:2556:     if (CheckFlag(flag))
	cmp	r0, #0	@ tmp184,
	beq	.L65		@,
@ Data/FE6_FE7.c:2558:         ClearFlag(flag);
	movs	r0, r7	@, DebuggerTurnedOff_Flag.73_9
	ldr	r3, .L74+20	@ tmp165,
	bl	.L17		@
.L66:
@ Data/FE6_FE7.c:2594:             proc->id = 0;
	movs	r3, #0	@ tmp167,
	str	r3, [r6, #44]	@ tmp167, proc_19(D)->id
@ Data/FE6_FE7.c:2597:     keys |= gKeyStatusPtr->heldKeys;
	ldr	r3, [r5]	@ gKeyStatusPtr.71_1, gKeyStatusPtr
.L61:
	ldrh	r2, [r3, #4]	@ _11,
@ Data/FE6_FE7.c:2598:     if (KeyComboToDisableFlag)
	ldr	r3, .L74+24	@ tmp169,
	ldr	r3, [r3]	@ KeyComboToDisableFlag.75_12, KeyComboToDisableFlag
@ Data/FE6_FE7.c:2598:     if (KeyComboToDisableFlag)
	cmp	r3, #0	@ KeyComboToDisableFlag.75_12,
	beq	.L57		@,
.L73:
@ Data/FE6_FE7.c:2600:         if ((keys & KEYS_MASK) == KeyComboToDisableFlag)
	orrs	r4, r2	@ tmp170, _11
	lsls	r4, r4, #22	@ tmp173, tmp170,
	lsrs	r4, r4, #22	@ tmp174, tmp173,
@ Data/FE6_FE7.c:2600:         if ((keys & KEYS_MASK) == KeyComboToDisableFlag)
	cmp	r3, r4	@ KeyComboToDisableFlag.75_12, tmp174
	beq	.L72		@,
.L57:
@ Data/FE6_FE7.c:2605: }
	@ sp needed	@
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L62:
@ Data/FE6_FE7.c:2582:             if (keys & DPAD_UP)
	lsls	r2, r4, #25	@ tmp158, _2,
	lsrs	r2, r2, #31	@ tmp159, tmp158,
	lsls	r2, r2, #1	@ tmp160, tmp159,
@ Data/FE6_FE7.c:2588:                 proc->id = 0;
	str	r2, [r6, #44]	@ tmp160, proc_19(D)->id
@ Data/FE6_FE7.c:2597:     keys |= gKeyStatusPtr->heldKeys;
	ldrh	r2, [r3, #4]	@ _11,
@ Data/FE6_FE7.c:2598:     if (KeyComboToDisableFlag)
	ldr	r3, .L74+24	@ tmp169,
	ldr	r3, [r3]	@ KeyComboToDisableFlag.75_12, KeyComboToDisableFlag
@ Data/FE6_FE7.c:2598:     if (KeyComboToDisableFlag)
	cmp	r3, #0	@ KeyComboToDisableFlag.75_12,
	beq	.L57		@,
	b	.L73		@
.L72:
@ Data/FE6_FE7.c:2602:             ToggleFlag(DebuggerTurnedOff_Flag);
	ldr	r3, .L74+12	@ tmp176,
	ldr	r4, [r3]	@ DebuggerTurnedOff_Flag.77_14, DebuggerTurnedOff_Flag
@ Data/FE6_FE7.c:2556:     if (CheckFlag(flag))
	ldr	r3, .L74+16	@ tmp177,
	movs	r0, r4	@, DebuggerTurnedOff_Flag.77_14
	bl	.L17		@
@ Data/FE6_FE7.c:2556:     if (CheckFlag(flag))
	cmp	r0, #0	@ tmp185,
	beq	.L68		@,
@ Data/FE6_FE7.c:2558:         ClearFlag(flag);
	movs	r0, r4	@, DebuggerTurnedOff_Flag.77_14
	ldr	r3, .L74+20	@ tmp180,
	bl	.L17		@
	b	.L57		@
.L65:
@ Data/FE6_FE7.c:2562:         SetFlag(flag);
	movs	r0, r7	@, DebuggerTurnedOff_Flag.73_9
	ldr	r3, .L74+28	@ tmp166,
	bl	.L17		@
	b	.L66		@
.L68:
	movs	r0, r4	@, DebuggerTurnedOff_Flag.77_14
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
@ Data/FE6_FE7.c:346:     proc->page = 0;
	movs	r2, #128	@ tmp118,
	lsls	r2, r2, #9	@ tmp118, tmp118,
@ Data/FE6_FE7.c:344: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:346:     proc->page = 0;
	str	r2, [r0, #52]	@ tmp118, MEM <unsigned int> [(void *)proc_4(D) + 52B]
@ Data/FE6_FE7.c:359: }
	@ sp needed	@
@ Data/FE6_FE7.c:352:     proc->tileID = 1;
	movs	r2, #1	@ tmp119,
@ Data/FE6_FE7.c:349:     proc->godMode = 0;
	movs	r3, #0	@ tmp116,
@ Data/FE6_FE7.c:352:     proc->tileID = 1;
	strh	r2, [r0, #42]	@ tmp119, proc_4(D)->tileID
@ Data/FE6_FE7.c:353:     proc->id = 0;
	movs	r2, #0	@ tmp117,
@ Data/FE6_FE7.c:349:     proc->godMode = 0;
	strh	r3, [r0, #50]	@ tmp116, MEM <vector(2) unsigned char> [(unsigned char *)proc_4(D) + 50B]
@ Data/FE6_FE7.c:354:     proc->lastTileHovered = 0;
	str	r3, [r0, #44]	@ tmp116, MEM <unsigned int> [(void *)proc_4(D) + 44B]
@ Data/FE6_FE7.c:353:     proc->id = 0;
	adds	r3, r3, #48	@ tmp122,
	strb	r2, [r0, r3]	@ tmp117, proc_4(D)->id
@ Data/FE6_FE7.c:357:         proc->tmp[i] = 0;
	movs	r1, #0	@,
	movs	r2, #30	@,
	ldr	r3, .L97	@ tmp128,
	adds	r0, r0, #64	@ tmp125,
	bl	.L17		@
@ Data/FE6_FE7.c:359: }
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
@ Data/FE6_FE7.c:364:     dst->tileID = src->tileID;
	movs	r2, #42	@ tmp154,
	ldrsh	r3, [r1, r2]	@ _1, src, tmp154
@ Data/FE6_FE7.c:381: }
	@ sp needed	@
@ Data/FE6_FE7.c:364:     dst->tileID = src->tileID;
	strh	r3, [r0, #42]	@ _1, dst_19(D)->tileID
@ Data/FE6_FE7.c:365:     dst->mainID = src->mainID;
	movs	r3, #53	@ tmp130,
	ldrsb	r2, [r1, r3]	@ _2,
@ Data/FE6_FE7.c:365:     dst->mainID = src->mainID;
	strb	r2, [r0, r3]	@ _2, dst_19(D)->mainID
@ Data/FE6_FE7.c:366:     dst->lastTileHovered = src->lastTileHovered;
	ldrh	r3, [r1, #44]	@ _3,
@ Data/FE6_FE7.c:366:     dst->lastTileHovered = src->lastTileHovered;
	strh	r3, [r0, #44]	@ _3, dst_19(D)->lastTileHovered
@ Data/FE6_FE7.c:367:     dst->editing = src->editing;
	movs	r3, #46	@ tmp134,
	ldrsb	r2, [r1, r3]	@ _4,
@ Data/FE6_FE7.c:367:     dst->editing = src->editing;
	strb	r2, [r0, r3]	@ _4, dst_19(D)->editing
@ Data/FE6_FE7.c:368:     dst->actionID = src->actionID;
	adds	r3, r3, #1	@ tmp137,
	ldrb	r2, [r1, r3]	@ _5,
@ Data/FE6_FE7.c:368:     dst->actionID = src->actionID;
	strb	r2, [r0, r3]	@ _5, dst_19(D)->actionID
@ Data/FE6_FE7.c:369:     dst->id = src->id;
	ldrh	r3, [r1, #48]	@ MEM <vector(2) signed char> [(signed char *)src_18(D) + 48B], MEM <vector(2) signed char> [(signed char *)src_18(D) + 48B]
@ Data/FE6_FE7.c:369:     dst->id = src->id;
	strh	r3, [r0, #48]	@ MEM <vector(2) signed char> [(signed char *)src_18(D) + 48B], MEM <vector(2) signed char> [(signed char *)dst_19(D) + 48B]
@ Data/FE6_FE7.c:372:     dst->page = src->page;
	movs	r3, #52	@ tmp142,
@ Data/FE6_FE7.c:362: {
	movs	r5, r1	@ src, tmp152
@ Data/FE6_FE7.c:371:     dst->godMode = src->godMode;
	ldrh	r2, [r1, #50]	@ MEM <vector(2) unsigned char> [(unsigned char *)src_18(D) + 50B], MEM <vector(2) unsigned char> [(unsigned char *)src_18(D) + 50B]
@ Data/FE6_FE7.c:372:     dst->page = src->page;
	ldrb	r1, [r1, r3]	@ _9,
@ Data/FE6_FE7.c:372:     dst->page = src->page;
	strb	r1, [r0, r3]	@ _9, dst_19(D)->page
@ Data/FE6_FE7.c:378:         dst->tmp[i] = src->tmp[i];
	movs	r1, r5	@ tmp148, src
@ Data/FE6_FE7.c:362: {
	movs	r4, r0	@ dst, tmp151
@ Data/FE6_FE7.c:373:     dst->lastFlag = src->lastFlag;
	ldrh	r3, [r5, #54]	@ _10,
@ Data/FE6_FE7.c:373:     dst->lastFlag = src->lastFlag;
	strh	r3, [r0, #54]	@ _10, dst_19(D)->lastFlag
@ Data/FE6_FE7.c:374:     dst->gold = src->gold;
	ldr	r3, [r5, #56]	@ _11, src_18(D)->gold
@ Data/FE6_FE7.c:378:         dst->tmp[i] = src->tmp[i];
	adds	r1, r1, #64	@ tmp148,
@ Data/FE6_FE7.c:374:     dst->gold = src->gold;
	str	r3, [r0, #56]	@ _11, dst_19(D)->gold
@ Data/FE6_FE7.c:371:     dst->godMode = src->godMode;
	strh	r2, [r0, #50]	@ MEM <vector(2) unsigned char> [(unsigned char *)src_18(D) + 50B], MEM <vector(2) unsigned char> [(unsigned char *)dst_19(D) + 50B]
@ Data/FE6_FE7.c:378:         dst->tmp[i] = src->tmp[i];
	ldr	r3, .L100	@ tmp150,
	movs	r2, #30	@,
	adds	r0, r0, #64	@ tmp149,
	bl	.L17		@
@ Data/FE6_FE7.c:380:     dst->unit = src->unit;
	ldr	r3, [r5, #60]	@ _14, src_18(D)->unit
@ Data/FE6_FE7.c:380:     dst->unit = src->unit;
	str	r3, [r4, #60]	@ _14, dst_19(D)->unit
@ Data/FE6_FE7.c:381: }
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
@ Data/FE6_FE7.c:338: {
	movs	r4, r0	@ proc, tmp120
@ Data/FE6_FE7.c:342: }
	@ sp needed	@
@ Data/FE6_FE7.c:339:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	ldr	r3, .L103	@ tmp118,
	ldr	r0, .L103+4	@ tmp117,
	bl	.L17		@
@ Data/FE6_FE7.c:340:     CopyProcVariables(procIdler, proc);
	movs	r1, r4	@, proc
	bl	CopyProcVariables		@
@ Data/FE6_FE7.c:341:     Proc_End(proc);
	movs	r0, r4	@, proc
	ldr	r3, .L103+8	@ tmp119,
	bl	.L17		@
@ Data/FE6_FE7.c:342: }
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
@ Data/FE6_FE7.c:406:     ResetTextFont();
	ldr	r5, .L106	@ tmp115,
@ Data/FE6_FE7.c:417: }
	@ sp needed	@
@ Data/FE6_FE7.c:406:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:407:     SetTextFontGlyphs(0);
	ldr	r4, .L106+4	@ tmp116,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:410:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L106+8	@ tmp117,
	ldr	r3, .L106+12	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:411:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L106+16	@ tmp119,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:412:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:413:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:414:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L106+20	@ tmp122,
	bl	.L17		@
@ Data/FE6_FE7.c:415:     ClearBg0Bg1();
	ldr	r3, .L106+24	@ tmp123,
	bl	.L17		@
@ Data/FE6_FE7.c:416:     ResetText();
	ldr	r3, .L106+28	@ tmp124,
	bl	.L17		@
@ Data/FE6_FE7.c:417: }
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
@ Data/FE6_FE7.c:455:     unit->maxHP = proc->tmp[0];
	movs	r2, #64	@ tmp134,
@ Data/FE6_FE7.c:465: }
	@ sp needed	@
@ Data/FE6_FE7.c:455:     unit->maxHP = proc->tmp[0];
	ldrh	r2, [r0, r2]	@ tmp137,
@ Data/FE6_FE7.c:453:     struct Unit * unit = proc->unit;
	ldr	r3, [r0, #60]	@ unit, proc_20(D)->unit
@ Data/FE6_FE7.c:455:     unit->maxHP = proc->tmp[0];
	strb	r2, [r3, #18]	@ tmp137, unit_21->maxHP
@ Data/FE6_FE7.c:457:     unit->curHP = proc->tmp[1];
	movs	r2, #66	@ tmp138,
@ Data/FE6_FE7.c:457:     unit->curHP = proc->tmp[1];
	ldrh	r2, [r0, r2]	@ tmp141,
	strb	r2, [r3, #19]	@ tmp141, unit_21->curHP
@ Data/FE6_FE7.c:458:     unit->pow = proc->tmp[2];
	movs	r2, #68	@ tmp142,
@ Data/FE6_FE7.c:458:     unit->pow = proc->tmp[2];
	ldrh	r2, [r0, r2]	@ tmp145,
	strb	r2, [r3, #20]	@ tmp145, unit_21->pow
@ Data/FE6_FE7.c:459:     unit->skl = proc->tmp[3];
	movs	r2, #70	@ tmp146,
@ Data/FE6_FE7.c:459:     unit->skl = proc->tmp[3];
	ldrh	r2, [r0, r2]	@ tmp149,
	strb	r2, [r3, #21]	@ tmp149, unit_21->skl
@ Data/FE6_FE7.c:460:     unit->spd = proc->tmp[4];
	movs	r2, #72	@ tmp150,
@ Data/FE6_FE7.c:460:     unit->spd = proc->tmp[4];
	ldrh	r2, [r0, r2]	@ tmp153,
	strb	r2, [r3, #22]	@ tmp153, unit_21->spd
@ Data/FE6_FE7.c:461:     unit->def = proc->tmp[5];
	movs	r2, #74	@ tmp154,
@ Data/FE6_FE7.c:461:     unit->def = proc->tmp[5];
	ldrh	r2, [r0, r2]	@ tmp157,
	strb	r2, [r3, #23]	@ tmp157, unit_21->def
@ Data/FE6_FE7.c:462:     unit->res = proc->tmp[6];
	movs	r2, #76	@ tmp158,
@ Data/FE6_FE7.c:462:     unit->res = proc->tmp[6];
	ldrh	r2, [r0, r2]	@ tmp161,
	strb	r2, [r3, #24]	@ tmp161, unit_21->res
@ Data/FE6_FE7.c:463:     unit->lck = proc->tmp[7];
	movs	r2, #78	@ tmp162,
@ Data/FE6_FE7.c:463:     unit->lck = proc->tmp[7];
	ldrh	r2, [r0, r2]	@ tmp165,
	strb	r2, [r3, #25]	@ tmp165, unit_21->lck
@ Data/FE6_FE7.c:464:     SetUnitMag(unit, proc->tmp[8]);
	movs	r2, #80	@ tmp167,
@ Data/FE6_FE7.c:464:     SetUnitMag(unit, proc->tmp[8]);
	ldrh	r1, [r0, r2]	@ tmp169,
	subs	r2, r2, #9	@ tmp166,
	strb	r1, [r3, r2]	@ tmp169, MEM[(s8 *)unit_21 + 71B]
@ Data/FE6_FE7.c:465: }
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
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	movs	r2, #64	@ tmp126,
@ Data/FE6_FE7.c:468: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:470:     struct Unit * unit = proc->unit;
	ldr	r0, [r0, #60]	@ unit, proc_6(D)->unit
@ Data/FE6_FE7.c:477: }
	@ sp needed	@
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	ldrh	r2, [r3, r2]	@ tmp127,
	strh	r2, [r0, #30]	@ tmp127, unit_7->items[0]
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	movs	r2, #66	@ tmp129,
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	ldrh	r2, [r3, r2]	@ tmp130,
	strh	r2, [r0, #32]	@ tmp130, unit_7->items[1]
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	movs	r2, #68	@ tmp132,
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	ldrh	r2, [r3, r2]	@ tmp133,
	strh	r2, [r0, #34]	@ tmp133, unit_7->items[2]
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	movs	r2, #70	@ tmp135,
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	ldrh	r2, [r3, r2]	@ tmp136,
	strh	r2, [r0, #36]	@ tmp136, unit_7->items[3]
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	movs	r2, #72	@ tmp138,
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r3, r2]	@ tmp139,
	strh	r3, [r0, #38]	@ tmp139, unit_7->items[4]
@ Data/FE6_FE7.c:476:     UnitRemoveInvalidItems(unit);
	ldr	r3, .L110	@ tmp141,
	bl	.L17		@
@ Data/FE6_FE7.c:477: }
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
@ Data/FE6_FE7.c:561:     while (val >= pDigitTable[type][result + 1])
	ldr	r3, .L119	@ tmp124,
	lsls	r1, r1, #2	@ tmp125, tmp133,
	adds	r3, r3, r1	@ tmp126, tmp124, tmp125
	ldr	r3, [r3, #112]	@ _14, pDigitTable[type_10(D)]
@ Data/FE6_FE7.c:561:     while (val >= pDigitTable[type][result + 1])
	ldr	r2, [r3, #4]	@ MEM[(const int *)_14 + 4B], MEM[(const int *)_14 + 4B]
	cmp	r0, r2	@ val, MEM[(const int *)_14 + 4B]
	blt	.L116		@,
@ Data/FE6_FE7.c:560:     int result = 0;
	movs	r2, #0	@ result,
	adds	r3, r3, #8	@ ivtmp.343,
.L114:
@ Data/FE6_FE7.c:561:     while (val >= pDigitTable[type][result + 1])
	adds	r3, r3, #4	@ ivtmp.343,
@ Data/FE6_FE7.c:561:     while (val >= pDigitTable[type][result + 1])
	subs	r1, r3, #4	@ tmp129, ivtmp.343,
@ Data/FE6_FE7.c:561:     while (val >= pDigitTable[type][result + 1])
	ldr	r1, [r1]	@ MEM[(const int *)_8 + 4294967292B], MEM[(const int *)_8 + 4294967292B]
@ Data/FE6_FE7.c:563:         result++;
	adds	r2, r2, #1	@ result,
@ Data/FE6_FE7.c:561:     while (val >= pDigitTable[type][result + 1])
	cmp	r1, r0	@ MEM[(const int *)_8 + 4294967292B], val
	ble	.L114		@,
@ Data/FE6_FE7.c:565:     if (result > 9)
	movs	r0, r2	@ <retval>, result
	cmp	r2, #9	@ <retval>,
	bgt	.L118		@,
.L112:
@ Data/FE6_FE7.c:570: }
	@ sp needed	@
	bx	lr
.L118:
@ Data/FE6_FE7.c:565:     if (result > 9)
	movs	r0, #9	@ <retval>,
	b	.L112		@
.L116:
@ Data/FE6_FE7.c:561:     while (val >= pDigitTable[type][result + 1])
	movs	r0, #0	@ <retval>,
@ Data/FE6_FE7.c:569:     return result;
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
@ Data/FE6_FE7.c:584: }
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
@ Data/FE6_FE7.c:767:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * NumberOfOptions, 0);
	movs	r2, #18	@,
	movs	r3, #0	@,
	movs	r1, #9	@,
	ldr	r5, .L137	@ tmp153,
	ldr	r0, .L137+4	@ tmp152,
	bl	.L28		@
@ Data/FE6_FE7.c:773:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	movs	r3, #66	@ tmp154,
	ldrsh	r3, [r4, r3]	@ tmp155,
@ Data/FE6_FE7.c:773:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	movs	r2, #64	@ tmp157,
	ldrsh	r2, [r4, r2]	@ tmp158,
@ Data/FE6_FE7.c:773:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsls	r3, r3, #16	@ tmp156, tmp155,
@ Data/FE6_FE7.c:773:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	orrs	r3, r2	@ tmp156, tmp158
	mov	r8, r3	@ _7, tmp156
	ldr	r3, .L137+8	@ ivtmp.405,
	mov	fp, r3	@ ivtmp.405, ivtmp.405
	movs	r3, #128	@ _145,
	mov	r4, fp	@ ivtmp.416, ivtmp.405
@ Data/FE6_FE7.c:775:     for (int i = 0; i < NumberOfState; ++i)
	movs	r5, #0	@ i,
	lsls	r3, r3, #1	@ _145, _145,
	add	r3, r3, fp	@ _145, ivtmp.405
	mov	r10, r3	@ _145, _145
	ldr	r3, .L137+12	@ tmp171,
	mov	r9, r3	@ tmp171, tmp171
@ Data/FE6_FE7.c:785:             ClearText(&th[i]);
	ldr	r3, .L137+16	@ tmp173,
	str	r3, [sp, #4]	@ tmp173, %sfp
@ Data/FE6_FE7.c:786:             Text_SetColor(&th[i], c);
	ldr	r3, .L137+20	@ tmp174,
	str	r3, [sp, #8]	@ tmp174, %sfp
@ Data/FE6_FE7.c:787:             Text_DrawString(&th[i], states[i]);
	ldr	r3, .L137+24	@ tmp175,
	ldr	r7, .L137+28	@ ivtmp.418,
	str	r3, [sp, #12]	@ tmp175, %sfp
.L126:
@ Data/FE6_FE7.c:777:         c = state & (1 << i);
	movs	r3, #1	@ tmp161,
	mov	r6, r8	@ c, _7
	lsls	r3, r3, r5	@ tmp160, tmp161, i
@ Data/FE6_FE7.c:778:         if (c)
	mov	r2, r8	@ _7, _7
	ands	r6, r3	@ c, tmp160
	tst	r2, r3	@ _7, tmp160
	beq	.L124		@,
@ Data/FE6_FE7.c:780:             c = TEXT_COLOR_SYSTEM_GOLD;
	movs	r6, #3	@ c,
.L124:
@ Data/FE6_FE7.c:783:         if (Text_GetColor(&th[i]) != c)
	movs	r0, r4	@, ivtmp.416
	bl	.L139		@
@ Data/FE6_FE7.c:783:         if (Text_GetColor(&th[i]) != c)
	cmp	r0, r6	@ tmp177, c
	beq	.L125		@,
@ Data/FE6_FE7.c:785:             ClearText(&th[i]);
	movs	r0, r4	@, ivtmp.416
	ldr	r3, [sp, #4]	@ tmp173, %sfp
	bl	.L17		@
@ Data/FE6_FE7.c:786:             Text_SetColor(&th[i], c);
	movs	r1, r6	@, c
	movs	r0, r4	@, ivtmp.416
	ldr	r3, [sp, #8]	@ tmp174, %sfp
	bl	.L17		@
@ Data/FE6_FE7.c:787:             Text_DrawString(&th[i], states[i]);
	movs	r1, r7	@, ivtmp.418
	movs	r0, r4	@, ivtmp.416
	ldr	r3, [sp, #12]	@ tmp175, %sfp
	bl	.L17		@
.L125:
@ Data/FE6_FE7.c:775:     for (int i = 0; i < NumberOfState; ++i)
	adds	r4, r4, #8	@ ivtmp.416,
@ Data/FE6_FE7.c:775:     for (int i = 0; i < NumberOfState; ++i)
	adds	r5, r5, #1	@ i,
@ Data/FE6_FE7.c:775:     for (int i = 0; i < NumberOfState; ++i)
	adds	r7, r7, #16	@ ivtmp.418,
	cmp	r4, r10	@ ivtmp.416, _145
	bne	.L126		@,
	movs	r3, #132	@ _135,
	rsbs	r3, r3, #0	@ _135, _135
	mov	r8, r3	@ _135, _135
	movs	r3, #128	@ tmp196,
	ldr	r4, .L137+32	@ ivtmp.407,
	lsls	r3, r3, #3	@ tmp196, tmp196,
	ldr	r5, .L137+36	@ tmp172,
	add	r8, r8, r4	@ _135, ivtmp.407
	adds	r6, r4, r3	@ _136, ivtmp.407, tmp196
.L127:
@ Data/FE6_FE7.c:795:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	movs	r1, r4	@, ivtmp.407
	mov	r0, fp	@, ivtmp.405
	bl	.L28		@
@ Data/FE6_FE7.c:793:     for (int i = 0; i < 8; ++i)
	movs	r3, #8	@ tmp197,
	mov	ip, r3	@ tmp197, tmp197
	adds	r4, r4, #128	@ ivtmp.407,
	add	fp, fp, ip	@ ivtmp.405, tmp197
	cmp	r4, r6	@ ivtmp.407, _136
	bne	.L127		@,
	ldr	r7, .L137+40	@ _126,
	ldr	r6, .L137+44	@ ivtmp.394,
	ldr	r4, .L137+48	@ ivtmp.396,
	add	r7, r7, r8	@ _126, _135
.L128:
@ Data/FE6_FE7.c:801:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	movs	r1, r4	@, ivtmp.396
	movs	r0, r6	@, ivtmp.394
@ Data/FE6_FE7.c:799:     for (int i = 0; i < 8; ++i)
	adds	r4, r4, #128	@ ivtmp.396,
@ Data/FE6_FE7.c:801:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	bl	.L28		@
@ Data/FE6_FE7.c:799:     for (int i = 0; i < 8; ++i)
	adds	r6, r6, #8	@ ivtmp.394,
	cmp	r4, r7	@ ivtmp.396, _126
	bne	.L128		@,
	movs	r7, #148	@ _52,
	ldr	r6, .L137+52	@ ivtmp.381,
	lsls	r7, r7, #3	@ _52, _52,
	ldr	r4, .L137+56	@ ivtmp.383,
	add	r7, r7, r8	@ _52, _135
.L129:
@ Data/FE6_FE7.c:807:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	movs	r1, r4	@, ivtmp.383
	movs	r0, r6	@, ivtmp.381
@ Data/FE6_FE7.c:805:     for (int i = 0; i < 8; ++i)
	adds	r4, r4, #128	@ ivtmp.383,
@ Data/FE6_FE7.c:807:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	bl	.L28		@
@ Data/FE6_FE7.c:805:     for (int i = 0; i < 8; ++i)
	adds	r6, r6, #8	@ ivtmp.381,
	cmp	r7, r4	@ _52, ivtmp.383
	bne	.L129		@,
	ldr	r7, .L137+60	@ _83,
	ldr	r6, .L137+64	@ ivtmp.368,
	ldr	r4, .L137+68	@ ivtmp.370,
	add	r7, r7, r8	@ _83, _135
.L130:
@ Data/FE6_FE7.c:813:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	movs	r1, r4	@, ivtmp.370
	movs	r0, r6	@, ivtmp.368
@ Data/FE6_FE7.c:811:     for (int i = 0; i < 8; ++i)
	adds	r4, r4, #128	@ ivtmp.370,
@ Data/FE6_FE7.c:813:         PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, y + (i * 2)));
	bl	.L28		@
@ Data/FE6_FE7.c:811:     for (int i = 0; i < 8; ++i)
	adds	r6, r6, #8	@ ivtmp.368,
	cmp	r7, r4	@ _83, ivtmp.370
	bne	.L130		@,
@ Data/FE6_FE7.c:817:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	ldr	r3, .L137+72	@ tmp170,
	bl	.L17		@
@ Data/FE6_FE7.c:818: }
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
@ Data/FE6_FE7.c:406:     ResetTextFont();
	ldr	r5, .L143	@ tmp123,
@ Data/FE6_FE7.c:735: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:406:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:407:     SetTextFontGlyphs(0);
	ldr	r4, .L143+4	@ tmp124,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:410:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L143+8	@ tmp125,
	ldr	r3, .L143+12	@ tmp126,
	bl	.L17		@
@ Data/FE6_FE7.c:411:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L143+16	@ tmp127,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:412:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:413:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:414:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L143+20	@ tmp130,
	bl	.L17		@
@ Data/FE6_FE7.c:415:     ClearBg0Bg1();
	ldr	r3, .L143+24	@ tmp131,
	bl	.L17		@
@ Data/FE6_FE7.c:416:     ResetText();
	ldr	r3, .L143+28	@ tmp132,
	bl	.L17		@
@ Data/FE6_FE7.c:738:     proc->tmp[0] = unit->state;
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
	ldr	r4, .L143+36	@ ivtmp.429,
	adds	r3, r4, #1	@ _43, ivtmp.429,
	adds	r3, r3, #255	@ _43,
	mov	r8, r3	@ _43, _43
	ldr	r5, .L143+40	@ ivtmp.431,
	ldr	r7, .L143+44	@ tmp141,
	ldr	r6, .L143+48	@ tmp142,
.L141:
@ Data/FE6_FE7.c:758:         InitText(&th[i], StateWidth);
	movs	r0, r4	@, ivtmp.429
	movs	r1, #7	@,
	bl	.L145		@
@ Data/FE6_FE7.c:759:         Text_DrawString(&th[i], states[i]);
	movs	r1, r5	@, ivtmp.431
	movs	r0, r4	@, ivtmp.429
@ Data/FE6_FE7.c:756:     for (int i = 0; i < NumberOfState; ++i)
	adds	r4, r4, #8	@ ivtmp.429,
@ Data/FE6_FE7.c:759:         Text_DrawString(&th[i], states[i]);
	bl	.L38		@
@ Data/FE6_FE7.c:756:     for (int i = 0; i < NumberOfState; ++i)
	adds	r5, r5, #16	@ ivtmp.431,
	cmp	r4, r8	@ ivtmp.429, _43
	bne	.L141		@,
@ Data/FE6_FE7.c:761:     StartGreenText(proc);
	mov	r0, r9	@, proc
	ldr	r3, .L143+52	@ tmp140,
	bl	.L17		@
@ Data/FE6_FE7.c:762:     RedrawStateMenu(proc);
	mov	r0, r9	@, proc
	bl	RedrawStateMenu		@
@ Data/FE6_FE7.c:763: }
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
@ Data/FE6_FE7.c:827:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L183	@ tmp152,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r5, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:828:     if ((keys & START_BUTTON) || (keys & B_BUTTON))
	movs	r3, #10	@ tmp156,
@ Data/FE6_FE7.c:826: {
	movs	r6, r0	@ proc, tmp229
@ Data/FE6_FE7.c:828:     if ((keys & START_BUTTON) || (keys & B_BUTTON))
	tst	r3, r5	@ tmp156, keys
	bne	.L179		@,
.L147:
@ Data/FE6_FE7.c:834:     u32 id = proc->id;
	movs	r3, #48	@ tmp161,
@ Data/FE6_FE7.c:835:     if ((keys & A_BUTTON))
	movs	r2, #1	@ tmp163,
@ Data/FE6_FE7.c:834:     u32 id = proc->id;
	ldrsb	r4, [r6, r3]	@ id,
@ Data/FE6_FE7.c:835:     if ((keys & A_BUTTON))
	tst	r2, r5	@ tmp163, keys
	bne	.L180		@,
.L148:
@ Data/FE6_FE7.c:847:     DisplayUiHand(StateCursorLocationTable[id].x, StateCursorLocationTable[id].y);
	ldr	r3, .L183+4	@ tmp182,
	lsls	r2, r4, #3	@ tmp183, id,
	adds	r1, r3, r2	@ tmp184, tmp182, tmp183
@ Data/FE6_FE7.c:847:     DisplayUiHand(StateCursorLocationTable[id].x, StateCursorLocationTable[id].y);
	ldr	r0, [r2, r3]	@ StateCursorLocationTable[id_34].x, StateCursorLocationTable[id_34].x
	ldr	r1, [r1, #4]	@ StateCursorLocationTable[id_34].y, StateCursorLocationTable[id_34].y
	ldr	r3, .L183+8	@ tmp190,
	bl	.L17		@
@ Data/FE6_FE7.c:849:     if (keys & DPAD_RIGHT)
	lsls	r3, r5, #27	@ tmp230, keys,
	bpl	.L149		@,
@ Data/FE6_FE7.c:851:         id += 8;
	adds	r4, r4, #8	@ id,
.L149:
@ Data/FE6_FE7.c:853:     if (keys & DPAD_LEFT)
	lsls	r3, r5, #26	@ tmp231, keys,
	bpl	.L150		@,
@ Data/FE6_FE7.c:855:         id -= 8;
	subs	r4, r4, #8	@ id,
.L150:
@ Data/FE6_FE7.c:857:     if (keys & DPAD_UP)
	lsls	r3, r5, #25	@ tmp232, keys,
	bpl	.L151		@,
@ Data/FE6_FE7.c:859:         if (!(id % 8))
	lsls	r3, r4, #29	@ tmp233, id,
	beq	.L181		@,
.L152:
@ Data/FE6_FE7.c:863:         id--;
	subs	r4, r4, #1	@ id,
.L151:
@ Data/FE6_FE7.c:865:     if (keys & DPAD_DOWN)
	lsls	r5, r5, #24	@ tmp234, keys,
	bpl	.L153		@,
@ Data/FE6_FE7.c:868:         id++;
	adds	r3, r4, #1	@ id, id,
@ Data/FE6_FE7.c:871:             id -= 8;
	subs	r4, r4, #7	@ id,
@ Data/FE6_FE7.c:869:         if (!(id % 8))
	lsls	r2, r3, #29	@ tmp235, id,
	bne	.L182		@,
.L153:
@ Data/FE6_FE7.c:875:     if (id != (int)proc->id)
	movs	r3, #48	@ tmp223,
@ Data/FE6_FE7.c:875:     if (id != (int)proc->id)
	ldrsb	r2, [r6, r3]	@ tmp224,
@ Data/FE6_FE7.c:875:     if (id != (int)proc->id)
	cmp	r2, r4	@ tmp224, id
	beq	.L146		@,
@ Data/FE6_FE7.c:877:         id %= NumberOfState;
	movs	r2, #31	@ tmp225,
	ands	r2, r4	@ id, id
@ Data/FE6_FE7.c:879:         RedrawStateMenu(proc);
	movs	r0, r6	@, proc
@ Data/FE6_FE7.c:878:         proc->id = id;
	strb	r2, [r6, r3]	@ id, proc_32(D)->id
@ Data/FE6_FE7.c:879:         RedrawStateMenu(proc);
	bl	RedrawStateMenu		@
.L146:
@ Data/FE6_FE7.c:881: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L182:
@ Data/FE6_FE7.c:868:         id++;
	movs	r4, r3	@ id, id
	b	.L153		@
.L181:
@ Data/FE6_FE7.c:861:             id += 8;
	adds	r4, r4, #8	@ id,
	b	.L152		@
.L180:
@ Data/FE6_FE7.c:837:         u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	adds	r3, r3, #18	@ tmp169,
	ldrsh	r3, [r6, r3]	@ tmp170,
@ Data/FE6_FE7.c:837:         u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	movs	r1, #64	@ tmp172,
@ Data/FE6_FE7.c:838:         state ^= (1 << id);
	lsls	r2, r2, r4	@ tmp175, tmp163, id
@ Data/FE6_FE7.c:837:         u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	ldrsh	r1, [r6, r1]	@ tmp173,
@ Data/FE6_FE7.c:837:         u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsls	r3, r3, #16	@ tmp171, tmp170,
@ Data/FE6_FE7.c:837:         u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	orrs	r3, r1	@ tmp174, tmp173
	eors	r3, r2	@ _58, tmp175
@ Data/FE6_FE7.c:841:         proc->tmp[0] = state & 0xffff;
	str	r3, [r6, #64]	@ _58, MEM <unsigned int> [(short int *)proc_32(D) + 64B]
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsrs	r2, r3, #16	@ tmp179, _58,
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsls	r3, r3, #16	@ _58, _58,
@ Data/FE6_FE7.c:822:     proc->unit->state = state;
	ldr	r1, [r6, #60]	@ proc_32(D)->unit, proc_32(D)->unit
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsls	r2, r2, #16	@ tmp178, tmp179,
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	asrs	r3, r3, #16	@ _58, _58,
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	orrs	r3, r2	@ state, tmp178
@ Data/FE6_FE7.c:844:         RedrawStateMenu(proc);
	movs	r0, r6	@, proc
@ Data/FE6_FE7.c:822:     proc->unit->state = state;
	str	r3, [r1, #12]	@ state, _55->state
@ Data/FE6_FE7.c:844:         RedrawStateMenu(proc);
	bl	RedrawStateMenu		@
	b	.L148		@
.L179:
@ Data/FE6_FE7.c:831:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	ldr	r3, .L183+12	@ tmp160,
	bl	.L17		@
@ Data/FE6_FE7.c:597: }
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
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	movs	r3, #66	@ tmp124,
@ Data/FE6_FE7.c:823: }
	@ sp needed	@
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	ldrsh	r3, [r0, r3]	@ tmp125,
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	movs	r1, #64	@ tmp127,
@ Data/FE6_FE7.c:822:     proc->unit->state = state;
	ldr	r2, [r0, #60]	@ proc_9(D)->unit, proc_9(D)->unit
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	ldrsh	r1, [r0, r1]	@ tmp128,
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	lsls	r3, r3, #16	@ tmp126, tmp125,
@ Data/FE6_FE7.c:821:     u32 state = proc->tmp[0] | (proc->tmp[1] << 16);
	orrs	r3, r1	@ state, tmp128
@ Data/FE6_FE7.c:822:     proc->unit->state = state;
	str	r3, [r2, #12]	@ state, _7->state
@ Data/FE6_FE7.c:823: }
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
@ Data/FE6_FE7.c:955:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * NumberOfOptions, 0);
	ldr	r7, .L191	@ tmp129,
	movs	r3, #0	@,
	movs	r2, #18	@,
	movs	r1, #9	@,
	ldr	r4, .L191+4	@ tmp130,
@ Data/FE6_FE7.c:954: {
	mov	r10, r0	@ proc, tmp139
@ Data/FE6_FE7.c:955:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * NumberOfOptions, 0);
	movs	r0, r7	@, tmp129
	bl	.L27		@
@ Data/FE6_FE7.c:956:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L191+8	@ tmp137,
	movs	r0, #1	@,
	mov	r8, r3	@ tmp137, tmp137
	bl	.L17		@
	movs	r3, #158	@ _55,
	rsbs	r3, r3, #0	@ _55, _55
	mov	r9, r3	@ _55, _55
	ldr	r3, .L191+12	@ tmp147,
	movs	r4, r7	@ ivtmp.462, tmp129
	mov	ip, r3	@ tmp147, tmp147
	ldr	r6, .L191+16	@ ivtmp.460,
	ldr	r5, .L191+20	@ tmp138,
	add	r9, r9, r7	@ _55, tmp129
	subs	r4, r4, #68	@ ivtmp.462,
	add	r7, r7, ip	@ _56, tmp147
.L187:
@ Data/FE6_FE7.c:962:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, (Y_HAND - 1) + (i * 2)));
	movs	r1, r4	@, ivtmp.462
	movs	r0, r6	@, ivtmp.460
@ Data/FE6_FE7.c:960:     for (int i = 0; i < NumberOfOptions; ++i)
	adds	r4, r4, #128	@ ivtmp.462,
@ Data/FE6_FE7.c:962:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, (Y_HAND - 1) + (i * 2)));
	bl	.L28		@
@ Data/FE6_FE7.c:960:     for (int i = 0; i < NumberOfOptions; ++i)
	adds	r6, r6, #8	@ ivtmp.460,
	cmp	r4, r7	@ ivtmp.462, _56
	bne	.L187		@,
	mov	r5, r10	@ proc, proc
	ldr	r6, .L191+24	@ _46,
	ldr	r4, .L191+28	@ ivtmp.451,
	ldr	r7, .L191+32	@ tmp136,
	adds	r5, r5, #64	@ proc,
	add	r6, r6, r9	@ _46, _55
.L188:
@ Data/FE6_FE7.c:967:         PutNumber(
	movs	r0, r4	@, ivtmp.451
	movs	r3, #0	@ tmp142,
	ldrsh	r2, [r5, r3]	@ MEM[(short int *)_44], ivtmp.449, tmp142
	movs	r1, #3	@,
@ Data/FE6_FE7.c:965:     for (int i = 0; i < NumberOfOptions; ++i)
	adds	r4, r4, #128	@ ivtmp.451,
@ Data/FE6_FE7.c:967:         PutNumber(
	bl	.L145		@
@ Data/FE6_FE7.c:965:     for (int i = 0; i < NumberOfOptions; ++i)
	adds	r5, r5, #2	@ ivtmp.449,
	cmp	r4, r6	@ ivtmp.451, _46
	bne	.L188		@,
@ Data/FE6_FE7.c:972: }
	@ sp needed	@
@ Data/FE6_FE7.c:971:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	bl	.L193		@
@ Data/FE6_FE7.c:972: }
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
@ Data/FE6_FE7.c:604:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L262	@ tmp211,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r6, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:600: {
	movs	r4, r0	@ proc, tmp442
@ Data/FE6_FE7.c:605:     if (keys & B_BUTTON)
	lsls	r3, r6, #30	@ tmp443, keys,
	bpl	.LCB1511	@
	b	.L257	@long jump	@
.LCB1511:
.L195:
@ Data/FE6_FE7.c:610:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp223,
	tst	r3, r6	@ tmp223, keys
	beq	.LCB1518	@
	b	.L258	@long jump	@
.LCB1518:
.L196:
@ Data/FE6_FE7.c:618:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	movs	r5, #48	@ tmp271,
@ Data/FE6_FE7.c:616:     if (proc->editing)
	movs	r7, #46	@ tmp265,
	movs	r2, #16	@ tmp269,
@ Data/FE6_FE7.c:618:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r5]	@ tmp272,
@ Data/FE6_FE7.c:616:     if (proc->editing)
	ldrsb	r3, [r4, r7]	@ _2,
	ands	r2, r6	@ tmp269, keys
@ Data/FE6_FE7.c:618:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ tmp273, tmp272,
	mov	r8, r2	@ _169, tmp269
	adds	r1, r1, #8	@ _173,
@ Data/FE6_FE7.c:616:     if (proc->editing)
	cmp	r3, #0	@ _2,
	bne	.LCB1532	@
	b	.L197	@long jump	@
.LCB1532:
@ Data/FE6_FE7.c:618:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	movs	r2, #49	@ tmp275,
	ldrsb	r2, [r4, r2]	@ tmp276,
@ Data/FE6_FE7.c:618:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	ldr	r3, .L262+4	@ tmp274,
	lsls	r2, r2, #3	@ tmp277, tmp276,
	adds	r3, r3, r2	@ tmp278, tmp274, tmp277
@ Data/FE6_FE7.c:618:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND - 1 + (proc->id * 2)) * 8);
	ldr	r0, [r3, #120]	@ CursorLocationTable[_4].x, CursorLocationTable[_4].x
	bl	DisplayVertUiHand		@
@ Data/FE6_FE7.c:619:         int max = StatCapLookup[proc->id];
	ldr	r3, .L262+8	@ tmp429,
	mov	r9, r3	@ tmp429, tmp429
	mov	r2, r9	@ tmp285, tmp429
@ Data/FE6_FE7.c:619:         int max = StatCapLookup[proc->id];
	ldrsb	r3, [r4, r5]	@ tmp284,
@ Data/FE6_FE7.c:619:         int max = StatCapLookup[proc->id];
	adds	r2, r2, #56	@ tmp285,
	ldrsb	r7, [r2, r3]	@ _12, StatCapLookup
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	cmp	r7, #10	@ _12,
	bgt	.LCB1547	@
	b	.L221	@long jump	@
.LCB1547:
	mov	r3, r9	@ ivtmp.473, tmp429
@ Data/FE6_FE7.c:546:     int result = 1;
	subs	r5, r5, #47	@ result,
	adds	r3, r3, #76	@ ivtmp.473,
.L199:
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	adds	r3, r3, #4	@ ivtmp.473,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	subs	r1, r3, #4	@ tmp288, ivtmp.473,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	ldr	r1, [r1]	@ MEM[(const int *)_114 + 4294967292B], MEM[(const int *)_114 + 4294967292B]
@ Data/FE6_FE7.c:549:         result++;
	adds	r5, r5, #1	@ result,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	cmp	r7, r1	@ _12, MEM[(const int *)_114 + 4294967292B]
	bgt	.L199		@,
@ Data/FE6_FE7.c:551:     if (result > 9)
	cmp	r5, #9	@ _167,
	ble	.L198		@,
	movs	r5, #9	@ _167,
.L198:
@ Data/FE6_FE7.c:623:         if (keys & DPAD_RIGHT)
	mov	r3, r8	@ _169, _169
	cmp	r3, #0	@ _169,
	beq	.L201		@,
@ Data/FE6_FE7.c:625:             if (proc->digit > 0)
	movs	r3, #49	@ tmp290,
	ldrsb	r3, [r4, r3]	@ _13,
@ Data/FE6_FE7.c:625:             if (proc->digit > 0)
	cmp	r3, #0	@ _13,
	bgt	.LCB1570	@
	b	.L202	@long jump	@
.LCB1570:
@ Data/FE6_FE7.c:627:                 proc->digit--;
	subs	r3, r3, #1	@ tmp294,
	lsls	r3, r3, #24	@ tmp295, tmp294,
	asrs	r3, r3, #24	@ _18, tmp295,
.L203:
	movs	r2, #49	@ tmp302,
@ Data/FE6_FE7.c:634:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _18, proc_87(D)->digit
	bl	RedrawUnitStatsMenu		@
.L201:
@ Data/FE6_FE7.c:636:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp444, keys,
	bpl	.L204		@,
@ Data/FE6_FE7.c:638:             if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp311,
	ldrsb	r3, [r4, r3]	@ _22,
@ Data/FE6_FE7.c:638:             if (proc->digit < (max_digits - 1))
	subs	r5, r5, #1	@ tmp312,
@ Data/FE6_FE7.c:638:             if (proc->digit < (max_digits - 1))
	cmp	r3, r5	@ _22, tmp312
	bge	.LCB1592	@
	b	.L259	@long jump	@
.LCB1592:
@ Data/FE6_FE7.c:645:                 proc->editing = false;
	movs	r3, #46	@ tmp316,
	movs	r2, #0	@ tmp317,
	strb	r2, [r4, r3]	@ tmp317, proc_87(D)->editing
@ Data/FE6_FE7.c:644:                 proc->digit = 0;
	movs	r3, #0	@ _28,
.L206:
	movs	r2, #49	@ tmp319,
@ Data/FE6_FE7.c:647:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _28, proc_87(D)->digit
	bl	RedrawUnitStatsMenu		@
.L204:
@ Data/FE6_FE7.c:650:         if (keys & DPAD_UP)
	movs	r3, #64	@ tmp322,
	tst	r3, r6	@ tmp322, keys
	beq	.L207		@,
@ Data/FE6_FE7.c:652:             if (proc->tmp[proc->id] == max)
	movs	r2, #48	@ tmp328,
	ldrsb	r1, [r4, r2]	@ tmp329,
	lsls	r1, r1, #1	@ tmp330, tmp329,
	adds	r1, r4, r1	@ _125, proc, tmp330
@ Data/FE6_FE7.c:652:             if (proc->tmp[proc->id] == max)
	ldrsh	r2, [r1, r3]	@ _31, MEM <s16> [(struct DebuggerProc *)_125 + 64B]
@ Data/FE6_FE7.c:652:             if (proc->tmp[proc->id] == max)
	cmp	r2, r7	@ _31, _12
	bne	.LCB1617	@
	b	.L222	@long jump	@
.LCB1617:
@ Data/FE6_FE7.c:658:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	movs	r3, #49	@ tmp334,
	ldrsb	r3, [r4, r3]	@ tmp335,
@ Data/FE6_FE7.c:658:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp336, tmp335,
	add	r3, r3, r9	@ tmp337, tmp429
@ Data/FE6_FE7.c:658:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_35], DigitDecimalTable[_35]
	adds	r3, r3, r2	@ tmp342, DigitDecimalTable[_35], _31
@ Data/FE6_FE7.c:659:                 if (proc->tmp[proc->id] > max)
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
@ Data/FE6_FE7.c:654:                 proc->tmp[proc->id] = min;
	movs	r2, #64	@ tmp346,
@ Data/FE6_FE7.c:664:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:654:                 proc->tmp[proc->id] = min;
	strh	r3, [r1, r2]	@ _41, MEM <s16> [(struct DebuggerProc *)_125 + 64B]
@ Data/FE6_FE7.c:664:             RedrawUnitStatsMenu(proc);
	bl	RedrawUnitStatsMenu		@
.L207:
@ Data/FE6_FE7.c:666:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp445, keys,
	bpl	.L194		@,
@ Data/FE6_FE7.c:669:             if (proc->tmp[proc->id] == min)
	movs	r3, #48	@ tmp355,
	ldrsb	r2, [r4, r3]	@ tmp356,
	lsls	r2, r2, #1	@ tmp357, tmp356,
	adds	r2, r4, r2	@ _69, proc, tmp357
@ Data/FE6_FE7.c:669:             if (proc->tmp[proc->id] == min)
	adds	r3, r3, #16	@ tmp358,
	ldrsh	r1, [r2, r3]	@ _42, MEM <s16> [(struct DebuggerProc *)_69 + 64B]
@ Data/FE6_FE7.c:669:             if (proc->tmp[proc->id] == min)
	cmp	r1, #0	@ _42,
	bne	.L260		@,
@ Data/FE6_FE7.c:671:                 proc->tmp[proc->id] = max;
	movs	r3, #64	@ tmp374,
@ Data/FE6_FE7.c:682:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:671:                 proc->tmp[proc->id] = max;
	strh	r7, [r2, r3]	@ _43, MEM <s16> [(struct DebuggerProc *)_69 + 64B]
@ Data/FE6_FE7.c:682:             RedrawUnitStatsMenu(proc);
	bl	RedrawUnitStatsMenu		@
.L194:
@ Data/FE6_FE7.c:719: }
	@ sp needed	@
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L197:
@ Data/FE6_FE7.c:687:         DisplayUiHand(CursorLocationTable[0].x - ((StatWidth + 2) * 8), (Y_HAND - 1 + (proc->id * 2)) * 8);
	ldr	r3, .L262+12	@ tmp376,
	movs	r0, #100	@,
	bl	.L17		@
@ Data/FE6_FE7.c:688:         if (keys & DPAD_RIGHT)
	mov	r3, r8	@ _169, _169
	cmp	r3, #0	@ _169,
	beq	.L215		@,
@ Data/FE6_FE7.c:690:             proc->digit = 1;
	movs	r3, #1	@ tmp378,
	movs	r2, #49	@ tmp377,
	strb	r3, [r4, r2]	@ tmp378, proc_87(D)->digit
@ Data/FE6_FE7.c:691:             proc->editing = true;
	strb	r3, [r4, r7]	@ tmp378, proc_87(D)->editing
.L215:
@ Data/FE6_FE7.c:693:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp446, keys,
	bpl	.L216		@,
@ Data/FE6_FE7.c:695:             proc->digit = 0;
	movs	r3, #49	@ tmp390,
	movs	r2, #0	@ tmp391,
	strb	r2, [r4, r3]	@ tmp391, proc_87(D)->digit
@ Data/FE6_FE7.c:696:             proc->editing = true;
	subs	r3, r3, #3	@ tmp393,
	adds	r2, r2, #1	@ tmp394,
	strb	r2, [r4, r3]	@ tmp394, proc_87(D)->editing
.L216:
@ Data/FE6_FE7.c:699:         if (keys & DPAD_UP)
	lsls	r3, r6, #25	@ tmp447, keys,
	bpl	.L217		@,
@ Data/FE6_FE7.c:701:             proc->id--;
	movs	r3, #48	@ tmp403,
@ Data/FE6_FE7.c:701:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp405,
	subs	r3, r3, #1	@ tmp406,
	lsls	r3, r3, #24	@ tmp407, tmp406,
	asrs	r2, r3, #24	@ _62, tmp407,
@ Data/FE6_FE7.c:702:             if (proc->id < 0)
	cmp	r3, #0	@ tmp407,
	blt	.L261		@,
	movs	r3, #48	@ tmp411,
@ Data/FE6_FE7.c:706:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _62, MEM <struct DebuggerProc> [(void *)proc_87(D)].id
	bl	RedrawUnitStatsMenu		@
.L217:
@ Data/FE6_FE7.c:708:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp448, keys,
	bpl	.L194		@,
@ Data/FE6_FE7.c:710:             proc->id++;
	movs	r1, #48	@ tmp420,
@ Data/FE6_FE7.c:713:                 proc->id = 0;
	movs	r0, #8	@ tmp438,
	movs	r5, #0	@ tmp440,
@ Data/FE6_FE7.c:710:             proc->id++;
	ldrb	r3, [r4, r1]	@ tmp422,
	adds	r3, r3, #1	@ tmp423,
	lsls	r3, r3, #24	@ tmp424, tmp423,
	asrs	r2, r3, #24	@ _68, tmp424,
@ Data/FE6_FE7.c:713:                 proc->id = 0;
	lsrs	r3, r3, #31	@ tmp439, tmp424,
	cmp	r0, r2	@ tmp438, _68
	adcs	r3, r3, r5	@ tmp437, tmp439, tmp440
	rsbs	r3, r3, #0	@ tmp441, tmp437
	ands	r2, r3	@ _68, tmp441
@ Data/FE6_FE7.c:716:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r1]	@ _68, MEM <struct DebuggerProc> [(void *)proc_87(D)].id
	bl	RedrawUnitStatsMenu		@
@ Data/FE6_FE7.c:719: }
	b	.L194		@
.L258:
@ Data/FE6_FE7.c:455:     unit->maxHP = proc->tmp[0];
	movs	r2, #64	@ tmp227,
@ Data/FE6_FE7.c:453:     struct Unit * unit = proc->unit;
	ldr	r3, [r4, #60]	@ unit, proc_87(D)->unit
@ Data/FE6_FE7.c:455:     unit->maxHP = proc->tmp[0];
	ldrh	r2, [r4, r2]	@ tmp230,
	strb	r2, [r3, #18]	@ tmp230, unit_130->maxHP
@ Data/FE6_FE7.c:457:     unit->curHP = proc->tmp[1];
	movs	r2, #66	@ tmp231,
@ Data/FE6_FE7.c:457:     unit->curHP = proc->tmp[1];
	ldrh	r2, [r4, r2]	@ tmp234,
	strb	r2, [r3, #19]	@ tmp234, unit_130->curHP
@ Data/FE6_FE7.c:458:     unit->pow = proc->tmp[2];
	movs	r2, #68	@ tmp235,
@ Data/FE6_FE7.c:458:     unit->pow = proc->tmp[2];
	ldrh	r2, [r4, r2]	@ tmp238,
	strb	r2, [r3, #20]	@ tmp238, unit_130->pow
@ Data/FE6_FE7.c:459:     unit->skl = proc->tmp[3];
	movs	r2, #70	@ tmp239,
@ Data/FE6_FE7.c:459:     unit->skl = proc->tmp[3];
	ldrh	r2, [r4, r2]	@ tmp242,
	strb	r2, [r3, #21]	@ tmp242, unit_130->skl
@ Data/FE6_FE7.c:460:     unit->spd = proc->tmp[4];
	movs	r2, #72	@ tmp243,
@ Data/FE6_FE7.c:460:     unit->spd = proc->tmp[4];
	ldrh	r2, [r4, r2]	@ tmp246,
	strb	r2, [r3, #22]	@ tmp246, unit_130->spd
@ Data/FE6_FE7.c:461:     unit->def = proc->tmp[5];
	movs	r2, #74	@ tmp247,
@ Data/FE6_FE7.c:461:     unit->def = proc->tmp[5];
	ldrh	r2, [r4, r2]	@ tmp250,
	strb	r2, [r3, #23]	@ tmp250, unit_130->def
@ Data/FE6_FE7.c:462:     unit->res = proc->tmp[6];
	movs	r2, #76	@ tmp251,
@ Data/FE6_FE7.c:462:     unit->res = proc->tmp[6];
	ldrh	r2, [r4, r2]	@ tmp254,
	strb	r2, [r3, #24]	@ tmp254, unit_130->res
@ Data/FE6_FE7.c:463:     unit->lck = proc->tmp[7];
	movs	r2, #78	@ tmp255,
@ Data/FE6_FE7.c:463:     unit->lck = proc->tmp[7];
	ldrh	r2, [r4, r2]	@ tmp258,
	strb	r2, [r3, #25]	@ tmp258, unit_130->lck
@ Data/FE6_FE7.c:464:     SetUnitMag(unit, proc->tmp[8]);
	movs	r2, #80	@ tmp260,
@ Data/FE6_FE7.c:464:     SetUnitMag(unit, proc->tmp[8]);
	ldrh	r1, [r4, r2]	@ tmp262,
	subs	r2, r2, #9	@ tmp259,
	strb	r1, [r3, r2]	@ tmp262, MEM[(s8 *)unit_130 + 71B]
@ Data/FE6_FE7.c:613:         Proc_Goto(proc, RestartLabel);
	movs	r0, r4	@, proc
	movs	r1, #1	@,
	ldr	r3, .L262+16	@ tmp264,
	bl	.L17		@
@ Data/FE6_FE7.c:597: }
	b	.L196		@
.L257:
@ Data/FE6_FE7.c:607:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	ldr	r3, .L262+16	@ tmp219,
	bl	.L17		@
@ Data/FE6_FE7.c:597: }
	b	.L195		@
.L260:
@ Data/FE6_FE7.c:675:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	movs	r3, #49	@ tmp361,
	ldrsb	r3, [r4, r3]	@ tmp362,
@ Data/FE6_FE7.c:675:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp363, tmp362,
	add	r3, r3, r9	@ tmp364, tmp429
@ Data/FE6_FE7.c:675:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_46], DigitDecimalTable[_46]
	subs	r1, r1, r3	@ tmp369, _42, DigitDecimalTable[_46]
@ Data/FE6_FE7.c:676:                 if (proc->tmp[proc->id] < min)
	lsls	r7, r1, #16	@ tmp372, tmp369,
	asrs	r7, r7, #16	@ tmp372, tmp372,
	mvns	r7, r7	@ tmp431, tmp372
@ Data/FE6_FE7.c:671:                 proc->tmp[proc->id] = max;
	movs	r3, #64	@ tmp374,
@ Data/FE6_FE7.c:676:                 if (proc->tmp[proc->id] < min)
	asrs	r7, r7, #31	@ tmp435, tmp431,
	ands	r7, r1	@ tmp359, tmp369
	lsls	r7, r7, #16	@ _43, tmp359,
	asrs	r7, r7, #16	@ _43, _43,
@ Data/FE6_FE7.c:682:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:671:                 proc->tmp[proc->id] = max;
	strh	r7, [r2, r3]	@ _43, MEM <s16> [(struct DebuggerProc *)_69 + 64B]
@ Data/FE6_FE7.c:682:             RedrawUnitStatsMenu(proc);
	bl	RedrawUnitStatsMenu		@
	b	.L194		@
.L259:
@ Data/FE6_FE7.c:640:                 proc->digit++;
	adds	r3, r3, #1	@ tmp314,
	lsls	r3, r3, #24	@ tmp315, tmp314,
	asrs	r3, r3, #24	@ _28, tmp315,
	b	.L206		@
.L261:
@ Data/FE6_FE7.c:704:                 proc->id = NumberOfOptions - 1;
	movs	r2, #8	@ _62,
	movs	r3, #48	@ tmp411,
@ Data/FE6_FE7.c:706:             RedrawUnitStatsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _62, MEM <struct DebuggerProc> [(void *)proc_87(D)].id
	bl	RedrawUnitStatsMenu		@
	b	.L217		@
.L202:
@ Data/FE6_FE7.c:632:                 proc->editing = false;
	movs	r2, #46	@ tmp299,
	movs	r1, #0	@ tmp300,
@ Data/FE6_FE7.c:631:                 proc->digit = max_digits - 1;
	subs	r3, r5, #1	@ tmp297, _167,
	lsls	r3, r3, #24	@ tmp298, tmp297,
@ Data/FE6_FE7.c:632:                 proc->editing = false;
	strb	r1, [r4, r2]	@ tmp300, proc_87(D)->editing
@ Data/FE6_FE7.c:631:                 proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _18, tmp298,
	b	.L203		@
.L222:
	movs	r3, #0	@ _41,
	b	.L208		@
.L221:
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
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
@ Data/FE6_FE7.c:406:     ResetTextFont();
	ldr	r5, .L267	@ tmp138,
@ Data/FE6_FE7.c:892: {
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:892: {
	movs	r7, r0	@ proc, tmp209
@ Data/FE6_FE7.c:406:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:407:     SetTextFontGlyphs(0);
	ldr	r4, .L267+4	@ tmp139,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:410:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L267+8	@ tmp140,
	ldr	r3, .L267+12	@ tmp141,
	bl	.L17		@
@ Data/FE6_FE7.c:411:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L267+16	@ tmp142,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:412:     ResetTextFont();
	bl	.L28		@
@ Data/FE6_FE7.c:413:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:414:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L267+20	@ tmp145,
	bl	.L17		@
@ Data/FE6_FE7.c:415:     ClearBg0Bg1();
	ldr	r3, .L267+24	@ tmp146,
	bl	.L17		@
@ Data/FE6_FE7.c:416:     ResetText();
	ldr	r3, .L267+28	@ tmp147,
	bl	.L17		@
@ Data/FE6_FE7.c:895:     proc->tmp[0] = unit->maxHP;
	movs	r1, #18	@ tmp149,
@ Data/FE6_FE7.c:895:     proc->tmp[0] = unit->maxHP;
	movs	r2, #64	@ tmp150,
@ Data/FE6_FE7.c:894:     struct Unit * unit = proc->unit;
	ldr	r3, [r7, #60]	@ unit, proc_24(D)->unit
@ Data/FE6_FE7.c:895:     proc->tmp[0] = unit->maxHP;
	ldrsb	r1, [r3, r1]	@ tmp149,
@ Data/FE6_FE7.c:895:     proc->tmp[0] = unit->maxHP;
	strh	r1, [r7, r2]	@ tmp149, proc_24(D)->tmp[0]
@ Data/FE6_FE7.c:896:     proc->tmp[1] = unit->curHP;
	movs	r1, #19	@ tmp152,
	ldrsb	r1, [r3, r1]	@ tmp152,
@ Data/FE6_FE7.c:896:     proc->tmp[1] = unit->curHP;
	adds	r2, r2, #2	@ tmp153,
	strh	r1, [r7, r2]	@ tmp152, proc_24(D)->tmp[1]
@ Data/FE6_FE7.c:897:     proc->tmp[2] = unit->pow;
	movs	r1, #20	@ tmp155,
	ldrsb	r1, [r3, r1]	@ tmp155,
@ Data/FE6_FE7.c:897:     proc->tmp[2] = unit->pow;
	adds	r2, r2, #2	@ tmp156,
	strh	r1, [r7, r2]	@ tmp155, proc_24(D)->tmp[2]
@ Data/FE6_FE7.c:898:     proc->tmp[3] = unit->skl;
	movs	r1, #21	@ tmp158,
	ldrsb	r1, [r3, r1]	@ tmp158,
@ Data/FE6_FE7.c:898:     proc->tmp[3] = unit->skl;
	adds	r2, r2, #2	@ tmp159,
	strh	r1, [r7, r2]	@ tmp158, proc_24(D)->tmp[3]
@ Data/FE6_FE7.c:899:     proc->tmp[4] = unit->spd;
	movs	r1, #22	@ tmp161,
	ldrsb	r1, [r3, r1]	@ tmp161,
@ Data/FE6_FE7.c:899:     proc->tmp[4] = unit->spd;
	adds	r2, r2, #2	@ tmp162,
	strh	r1, [r7, r2]	@ tmp161, proc_24(D)->tmp[4]
@ Data/FE6_FE7.c:900:     proc->tmp[5] = unit->def;
	movs	r1, #23	@ tmp164,
	ldrsb	r1, [r3, r1]	@ tmp164,
@ Data/FE6_FE7.c:900:     proc->tmp[5] = unit->def;
	adds	r2, r2, #2	@ tmp165,
	strh	r1, [r7, r2]	@ tmp164, proc_24(D)->tmp[5]
@ Data/FE6_FE7.c:901:     proc->tmp[6] = unit->res;
	movs	r1, #24	@ tmp167,
	ldrsb	r1, [r3, r1]	@ tmp167,
@ Data/FE6_FE7.c:901:     proc->tmp[6] = unit->res;
	adds	r2, r2, #2	@ tmp168,
	strh	r1, [r7, r2]	@ tmp167, proc_24(D)->tmp[6]
@ Data/FE6_FE7.c:902:     proc->tmp[7] = unit->lck;
	movs	r1, #25	@ tmp170,
	ldrsb	r1, [r3, r1]	@ tmp170,
@ Data/FE6_FE7.c:902:     proc->tmp[7] = unit->lck;
	adds	r2, r2, #2	@ tmp171,
	strh	r1, [r7, r2]	@ tmp170, proc_24(D)->tmp[7]
@ Data/FE6_FE7.c:83:     return *(s8 *)((u8 *)unit + 0x47);
	subs	r2, r2, #7	@ tmp172,
@ Data/FE6_FE7.c:903:     proc->tmp[8] = GetUnitMag(unit);
	ldrsb	r2, [r3, r2]	@ MEM[(s8 *)unit_26 + 71B], MEM[(s8 *)unit_26 + 71B]
@ Data/FE6_FE7.c:903:     proc->tmp[8] = GetUnitMag(unit);
	movs	r3, #80	@ tmp175,
	strh	r2, [r7, r3]	@ MEM[(s8 *)unit_26 + 71B], proc_24(D)->tmp[8]
@ Data/FE6_FE7.c:76:     PutUiWindowFrame(x, y, width, height, style);
	movs	r3, #0	@ tmp176,
	ldr	r4, .L267+32	@ tmp177,
	str	r3, [sp]	@ tmp176,
	movs	r2, #9	@,
	adds	r3, r3, #20	@,
	movs	r1, #0	@,
	movs	r0, #12	@,
	bl	.L27		@
	ldr	r3, .L267+36	@ tmp207,
	movs	r6, r3	@ _66, tmp207
	mov	r8, r3	@ tmp207, tmp207
	movs	r4, r3	@ ivtmp.485, tmp207
	ldr	r5, .L267+40	@ tmp208,
	adds	r6, r6, #120	@ _66,
.L265:
@ Data/FE6_FE7.c:922:         InitText(&th[i], StatWidth);
	movs	r0, r4	@, ivtmp.485
	movs	r1, #4	@,
@ Data/FE6_FE7.c:920:     for (int i = 0; i < 15; ++i)
	adds	r4, r4, #8	@ ivtmp.485,
@ Data/FE6_FE7.c:922:         InitText(&th[i], StatWidth);
	bl	.L28		@
@ Data/FE6_FE7.c:920:     for (int i = 0; i < 15; ++i)
	cmp	r4, r6	@ ivtmp.485, _66
	bne	.L265		@,
@ Data/FE6_FE7.c:926:     Text_DrawString(&th[c], MaxHPText);
	ldr	r4, .L267+44	@ tmp182,
	mov	r0, r8	@, tmp207
	ldr	r1, .L267+48	@ tmp180,
	bl	.L27		@
@ Data/FE6_FE7.c:928:     Text_DrawString(&th[c], HPText);
	mov	r0, r8	@ tmp184, tmp207
	ldr	r1, .L267+52	@ tmp183,
	adds	r0, r0, #8	@ tmp184,
	bl	.L27		@
@ Data/FE6_FE7.c:930:     Text_DrawString(&th[c], StrText);
	mov	r0, r8	@ tmp187, tmp207
	ldr	r1, .L267+56	@ tmp186,
	adds	r0, r0, #16	@ tmp187,
	bl	.L27		@
@ Data/FE6_FE7.c:932:     Text_DrawString(&th[c], SklText);
	mov	r0, r8	@ tmp190, tmp207
	ldr	r1, .L267+60	@ tmp189,
	adds	r0, r0, #24	@ tmp190,
	bl	.L27		@
@ Data/FE6_FE7.c:934:     Text_DrawString(&th[c], SpdText);
	mov	r0, r8	@ tmp193, tmp207
	ldr	r1, .L267+64	@ tmp192,
	adds	r0, r0, #32	@ tmp193,
	bl	.L27		@
@ Data/FE6_FE7.c:936:     Text_DrawString(&th[c], DefText);
	mov	r0, r8	@ tmp196, tmp207
	ldr	r1, .L267+68	@ tmp195,
	adds	r0, r0, #40	@ tmp196,
	bl	.L27		@
@ Data/FE6_FE7.c:938:     Text_DrawString(&th[c], ResText);
	mov	r0, r8	@ tmp199, tmp207
	ldr	r1, .L267+72	@ tmp198,
	adds	r0, r0, #48	@ tmp199,
	bl	.L27		@
@ Data/FE6_FE7.c:940:     Text_DrawString(&th[c], LckText);
	mov	r0, r8	@ tmp202, tmp207
	ldr	r1, .L267+76	@ tmp201,
	adds	r0, r0, #56	@ tmp202,
	bl	.L27		@
@ Data/FE6_FE7.c:946:     Text_DrawString(&th[c], MagText);
	mov	r0, r8	@ tmp207, tmp207
	ldr	r1, .L267+80	@ tmp204,
	adds	r0, r0, #64	@ tmp207,
	bl	.L27		@
@ Data/FE6_FE7.c:950:     RedrawUnitStatsMenu(proc);
	movs	r0, r7	@, proc
	bl	RedrawUnitStatsMenu		@
@ Data/FE6_FE7.c:951: }
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
	.word	MagText
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
@ Data/FE6_FE7.c:1008:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L308	@ tmp172,
	ldr	r3, .L308+4	@ tmp173,
	bl	.L17		@
@ Data/FE6_FE7.c:1009:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L308+8	@ tmp211,
	movs	r0, #1	@,
	mov	fp, r3	@ tmp211, tmp211
	bl	.L17		@
@ Data/FE6_FE7.c:1010:     ResetIconGraphics();
	ldr	r3, .L308+12	@ tmp175,
	bl	.L17		@
	add	r3, sp, #12	@ ivtmp.528,,
	mov	r8, r3	@ ivtmp.528, ivtmp.528
	movs	r7, r3	@ ivtmp.563, ivtmp.528
	ldr	r3, .L308+16	@ tmp212,
	mov	r10, r3	@ tmp212, tmp212
@ Data/FE6_FE7.c:1016:         itemData[i] = GetItemData(proc->tmp[i] & 0xFF);
	movs	r3, #255	@ tmp181,
	movs	r5, r4	@ ivtmp.502, proc
	mov	r9, r3	@ tmp181, tmp181
	mov	r3, r10	@ tmp212, tmp212
	adds	r5, r5, #64	@ ivtmp.502,
@ Data/FE6_FE7.c:1010:     ResetIconGraphics();
	movs	r6, r5	@ ivtmp.561, ivtmp.502
@ Data/FE6_FE7.c:1016:         itemData[i] = GetItemData(proc->tmp[i] & 0xFF);
	mov	r10, r5	@ ivtmp.502, ivtmp.502
	movs	r5, r3	@ tmp212, tmp212
	adds	r4, r4, #74	@ _186,
.L270:
	mov	r3, r9	@ tmp181, tmp181
	ldrh	r0, [r6]	@ MEM[(short int *)_183], MEM[(short int *)_183]
	ands	r0, r3	@ tmp182, tmp181
	bl	.L28		@
@ Data/FE6_FE7.c:1014:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.561,
@ Data/FE6_FE7.c:1016:         itemData[i] = GetItemData(proc->tmp[i] & 0xFF);
	stmia	r7!, {r0}	@ MEM[(const struct ItemData * *)_184], tmp223
@ Data/FE6_FE7.c:1014:     for (int i = 0; i < NumberOfItems; ++i)
	cmp	r6, r4	@ ivtmp.561, _186
	bne	.L270		@,
	ldr	r3, .L308+20	@ ivtmp.538,
	mov	r9, r3	@ ivtmp.538, ivtmp.538
	movs	r7, r3	@ ivtmp.550, ivtmp.538
	ldr	r3, .L308+24	@ tmp213,
	mov	r5, r10	@ ivtmp.502, ivtmp.502
	mov	r10, r3	@ tmp213, tmp213
@ Data/FE6_FE7.c:1025:             if (GetItemDescId(proc->tmp[i] & 0xFFFF) < 0x4000)
	ldr	r3, .L308+28	@ tmp220,
	str	r3, [sp, #4]	@ tmp220, %sfp
@ Data/FE6_FE7.c:1025:             if (GetItemDescId(proc->tmp[i] & 0xFFFF) < 0x4000)
	mov	r3, r10	@ tmp213, tmp213
@ Data/FE6_FE7.c:1014:     for (int i = 0; i < NumberOfItems; ++i)
	movs	r6, r5	@ ivtmp.552, ivtmp.502
@ Data/FE6_FE7.c:1025:             if (GetItemDescId(proc->tmp[i] & 0xFFFF) < 0x4000)
	mov	r10, r5	@ ivtmp.502, ivtmp.502
	movs	r5, r3	@ tmp213, tmp213
	b	.L274		@
.L272:
@ Data/FE6_FE7.c:1019:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.552,
	adds	r7, r7, #8	@ ivtmp.550,
	cmp	r6, r4	@ ivtmp.552, _186
	beq	.L305		@,
.L274:
@ Data/FE6_FE7.c:1021:         ClearText(&th[i]);
	movs	r0, r7	@, ivtmp.550
	bl	.L28		@
@ Data/FE6_FE7.c:1022:         if (proc->tmp[i])
	movs	r3, #0	@ tmp278,
	ldrsh	r0, [r6, r3]	@ _7, ivtmp.552, tmp278
@ Data/FE6_FE7.c:1022:         if (proc->tmp[i])
	cmp	r0, #0	@ _7,
	beq	.L272		@,
@ Data/FE6_FE7.c:1025:             if (GetItemDescId(proc->tmp[i] & 0xFFFF) < 0x4000)
	lsls	r0, r0, #16	@ tmp186, _7,
	ldr	r3, [sp, #4]	@ tmp220, %sfp
	lsrs	r0, r0, #16	@ tmp185, tmp186,
	bl	.L17		@
@ Data/FE6_FE7.c:1025:             if (GetItemDescId(proc->tmp[i] & 0xFFFF) < 0x4000)
	movs	r3, #128	@ tmp296,
	lsls	r3, r3, #7	@ tmp296, tmp296,
	cmp	r0, r3	@ tmp224, tmp296
	bge	.L272		@,
@ Data/FE6_FE7.c:1027:                 str = GetItemName(proc->tmp[i] & 0xFFFF);
	ldrh	r0, [r6]	@ tmp190, MEM[(short int *)_172]
	ldr	r3, .L308+32	@ tmp192,
	bl	.L17		@
@ Data/FE6_FE7.c:1028:                 if (str && *str)
	cmp	r0, #0	@ str,
	beq	.L272		@,
@ Data/FE6_FE7.c:1028:                 if (str && *str)
	ldrb	r3, [r0]	@ *str_85, *str_85
	cmp	r3, #0	@ *str_85,
	beq	.L272		@,
@ Data/FE6_FE7.c:1030:                     Text_DrawString(&th[i], str);
	movs	r1, r0	@, str
	ldr	r3, .L308+36	@ tmp194,
	movs	r0, r7	@, ivtmp.550
@ Data/FE6_FE7.c:1019:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.552,
@ Data/FE6_FE7.c:1030:                     Text_DrawString(&th[i], str);
	bl	.L17		@
@ Data/FE6_FE7.c:1019:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r7, r7, #8	@ ivtmp.550,
	cmp	r6, r4	@ ivtmp.552, _186
	bne	.L274		@,
.L305:
@ Data/FE6_FE7.c:1041:             PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	ldr	r3, .L308+40	@ tmp219,
	mov	r5, r10	@ ivtmp.502, ivtmp.502
	mov	r10, r3	@ tmp219, tmp219
	movs	r3, r4	@ _186, _186
	ldr	r7, .L308+44	@ ivtmp.540,
@ Data/FE6_FE7.c:1019:     for (int i = 0; i < NumberOfItems; ++i)
	movs	r6, r5	@ ivtmp.536, ivtmp.502
@ Data/FE6_FE7.c:1041:             PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	movs	r4, r7	@ ivtmp.540, ivtmp.540
	mov	r7, r9	@ ivtmp.538, ivtmp.538
	mov	r9, r5	@ ivtmp.502, ivtmp.502
	movs	r5, r3	@ _186, _186
	b	.L276		@
.L275:
@ Data/FE6_FE7.c:1037:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.536,
	adds	r7, r7, #8	@ ivtmp.538,
	adds	r4, r4, #128	@ ivtmp.540,
	cmp	r6, r5	@ ivtmp.536, _186
	beq	.L306		@,
.L276:
@ Data/FE6_FE7.c:1039:         if (proc->tmp[i])
	movs	r2, #0	@ tmp279,
	ldrsh	r3, [r6, r2]	@ MEM[(short int *)_161], ivtmp.536, tmp279
	cmp	r3, #0	@ MEM[(short int *)_161],
	beq	.L275		@,
@ Data/FE6_FE7.c:1041:             PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	movs	r1, r4	@, ivtmp.540
	movs	r0, r7	@, ivtmp.538
@ Data/FE6_FE7.c:1037:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.536,
@ Data/FE6_FE7.c:1041:             PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	bl	.L310		@
@ Data/FE6_FE7.c:1037:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r7, r7, #8	@ ivtmp.538,
	adds	r4, r4, #128	@ ivtmp.540,
	cmp	r6, r5	@ ivtmp.536, _186
	bne	.L276		@,
.L306:
	ldr	r3, .L308+48	@ ivtmp.526,
	ldr	r7, .L308+52	@ tmp209,
	movs	r4, r5	@ _186, _186
	mov	r5, r9	@ ivtmp.502, ivtmp.502
	mov	r9, r3	@ ivtmp.526, ivtmp.526
	movs	r3, r7	@ tmp209, tmp209
	movs	r6, r5	@ ivtmp.524, ivtmp.502
	movs	r7, r4	@ _186, _186
	mov	r4, r9	@ ivtmp.526, ivtmp.526
	mov	r9, r5	@ ivtmp.502, ivtmp.502
	mov	r5, r8	@ ivtmp.528, ivtmp.528
	mov	r8, r3	@ tmp209, tmp209
.L278:
@ Data/FE6_FE7.c:1047:         if (proc->tmp[i])
	movs	r2, #0	@ tmp280,
	ldrsh	r3, [r6, r2]	@ MEM[(short int *)_145], ivtmp.524, tmp280
@ Data/FE6_FE7.c:1053:             n = 0;
	movs	r2, #0	@ n,
@ Data/FE6_FE7.c:1047:         if (proc->tmp[i])
	cmp	r3, #0	@ MEM[(short int *)_145],
	beq	.L277		@,
@ Data/FE6_FE7.c:1049:             n = itemData[i]->number;
	ldr	r3, [r5]	@ MEM[(const struct ItemData * *)_148], MEM[(const struct ItemData * *)_148]
@ Data/FE6_FE7.c:1049:             n = itemData[i]->number;
	ldrb	r2, [r3, #6]	@ n,
.L277:
@ Data/FE6_FE7.c:2772:     PutNumber(tm, color, number);
	movs	r0, r4	@, ivtmp.526
	movs	r1, #3	@,
@ Data/FE6_FE7.c:1045:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.524,
@ Data/FE6_FE7.c:2772:     PutNumber(tm, color, number);
	bl	.L193		@
@ Data/FE6_FE7.c:1045:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r4, r4, #128	@ ivtmp.526,
	adds	r5, r5, #4	@ ivtmp.528,
	cmp	r6, r7	@ ivtmp.524, _186
	bne	.L278		@,
	ldr	r3, .L308+56	@ ivtmp.515,
	movs	r4, r7	@ _186, _186
	mov	r7, r8	@ tmp209, tmp209
	mov	r8, r3	@ ivtmp.515, ivtmp.515
@ Data/FE6_FE7.c:1062:             n = (proc->tmp[i] & 0xFF00) >> 8;
	movs	r3, #255	@ tmp217,
	mov	r5, r9	@ ivtmp.502, ivtmp.502
	mov	r9, r3	@ tmp217, tmp217
	movs	r3, r7	@ tmp209, tmp209
@ Data/FE6_FE7.c:1045:     for (int i = 0; i < NumberOfItems; ++i)
	movs	r6, r5	@ ivtmp.513, ivtmp.502
@ Data/FE6_FE7.c:1062:             n = (proc->tmp[i] & 0xFF00) >> 8;
	mov	r7, r8	@ ivtmp.515, ivtmp.515
	mov	r8, r5	@ ivtmp.502, ivtmp.502
	movs	r5, r3	@ tmp209, tmp209
.L280:
@ Data/FE6_FE7.c:1060:         if (proc->tmp[i])
	movs	r2, #0	@ tmp281,
	ldrsh	r3, [r6, r2]	@ _32, ivtmp.513, tmp281
@ Data/FE6_FE7.c:1066:             n = 0;
	movs	r2, #0	@ n,
@ Data/FE6_FE7.c:1060:         if (proc->tmp[i])
	cmp	r3, #0	@ _32,
	beq	.L279		@,
@ Data/FE6_FE7.c:1062:             n = (proc->tmp[i] & 0xFF00) >> 8;
	asrs	r2, r3, #8	@ tmp200, _32,
@ Data/FE6_FE7.c:1062:             n = (proc->tmp[i] & 0xFF00) >> 8;
	mov	r3, r9	@ tmp217, tmp217
	ands	r2, r3	@ n, tmp217
.L279:
@ Data/FE6_FE7.c:1068:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X + 3, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, n);
	movs	r0, r7	@, ivtmp.515
	movs	r1, #3	@,
@ Data/FE6_FE7.c:1058:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #2	@ ivtmp.513,
@ Data/FE6_FE7.c:1068:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X + 3, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, n);
	bl	.L28		@
@ Data/FE6_FE7.c:1058:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r7, r7, #128	@ ivtmp.515,
	cmp	r6, r4	@ ivtmp.513, _186
	bne	.L280		@,
@ Data/FE6_FE7.c:1079:                 DrawIcon(TILEMAP_LOCATED(gBG0TilemapBuffer, x - 2, Y_HAND + (i * 2)), icon, 0x4000);
	ldr	r3, .L308+60	@ tmp215,
	mov	r5, r8	@ ivtmp.502, ivtmp.502
	ldr	r6, .L308+64	@ ivtmp.504,
	mov	r8, r3	@ tmp215, tmp215
	ldr	r7, .L308+68	@ tmp210,
	b	.L282		@
.L281:
@ Data/FE6_FE7.c:1072:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r5, r5, #2	@ ivtmp.502,
	adds	r6, r6, #128	@ ivtmp.504,
	cmp	r5, r4	@ ivtmp.502, _186
	beq	.L307		@,
.L282:
@ Data/FE6_FE7.c:1074:         icon = GetItemIconId(proc->tmp[i]);
	movs	r3, #0	@ tmp282,
	ldrsh	r0, [r5, r3]	@ MEM[(short int *)_96], ivtmp.502, tmp282
	bl	.L145		@
@ Data/FE6_FE7.c:1075:         if (icon >= 0)
	cmp	r0, #0	@ icon,
	blt	.L281		@,
@ Data/FE6_FE7.c:1077:             if (proc->tmp[i])
	movs	r2, #0	@ tmp283,
	ldrsh	r3, [r5, r2]	@ MEM[(short int *)_96], ivtmp.502, tmp283
	cmp	r3, #0	@ MEM[(short int *)_96],
	beq	.L281		@,
@ Data/FE6_FE7.c:1079:                 DrawIcon(TILEMAP_LOCATED(gBG0TilemapBuffer, x - 2, Y_HAND + (i * 2)), icon, 0x4000);
	movs	r2, #128	@,
	movs	r1, r0	@, icon
	lsls	r2, r2, #7	@,,
	movs	r0, r6	@, ivtmp.504
@ Data/FE6_FE7.c:1072:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r5, r5, #2	@ ivtmp.502,
@ Data/FE6_FE7.c:1079:                 DrawIcon(TILEMAP_LOCATED(gBG0TilemapBuffer, x - 2, Y_HAND + (i * 2)), icon, 0x4000);
	bl	.L193		@
@ Data/FE6_FE7.c:1072:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r6, r6, #128	@ ivtmp.504,
	cmp	r5, r4	@ ivtmp.502, _186
	bne	.L282		@,
.L307:
@ Data/FE6_FE7.c:1084:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	bl	.L311		@
@ Data/FE6_FE7.c:1085: }
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
@ Data/FE6_FE7.c:406:     ResetTextFont();
	ldr	r6, .L315	@ tmp130,
@ Data/FE6_FE7.c:976: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:976: {
	movs	r5, r0	@ proc, tmp161
@ Data/FE6_FE7.c:406:     ResetTextFont();
	bl	.L38		@
@ Data/FE6_FE7.c:407:     SetTextFontGlyphs(0);
	ldr	r4, .L315+4	@ tmp131,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:410:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L315+8	@ tmp132,
	ldr	r3, .L315+12	@ tmp133,
	bl	.L17		@
@ Data/FE6_FE7.c:411:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L315+16	@ tmp134,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:412:     ResetTextFont();
	bl	.L38		@
@ Data/FE6_FE7.c:413:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:414:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L315+20	@ tmp137,
	bl	.L17		@
@ Data/FE6_FE7.c:415:     ClearBg0Bg1();
	ldr	r3, .L315+24	@ tmp138,
	bl	.L17		@
@ Data/FE6_FE7.c:416:     ResetText();
	ldr	r3, .L315+28	@ tmp139,
	bl	.L17		@
@ Data/FE6_FE7.c:978:     LoadIconPalettes(4);
	movs	r0, #4	@,
	ldr	r3, .L315+32	@ tmp140,
	bl	.L17		@
@ Data/FE6_FE7.c:982:         proc->tmp[i] = unit->items[i];
	movs	r2, #64	@ tmp141,
@ Data/FE6_FE7.c:979:     struct Unit * unit = proc->unit;
	ldr	r3, [r5, #60]	@ unit, proc_11(D)->unit
@ Data/FE6_FE7.c:982:         proc->tmp[i] = unit->items[i];
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
	ldr	r4, .L315+40	@ ivtmp.576,
	movs	r7, r4	@ _58, ivtmp.576
	ldr	r6, .L315+44	@ tmp160,
	adds	r7, r7, #40	@ _58,
.L313:
@ Data/FE6_FE7.c:998:         InitText(&th[i], ItemNameWidth);
	movs	r0, r4	@, ivtmp.576
	movs	r1, #8	@,
@ Data/FE6_FE7.c:996:     for (int i = 0; i < NumberOfItems; ++i)
	adds	r4, r4, #8	@ ivtmp.576,
@ Data/FE6_FE7.c:998:         InitText(&th[i], ItemNameWidth);
	bl	.L38		@
@ Data/FE6_FE7.c:996:     for (int i = 0; i < NumberOfItems; ++i)
	cmp	r4, r7	@ ivtmp.576, _58
	bne	.L313		@,
@ Data/FE6_FE7.c:1001:     RedrawItemMenu(proc);
	movs	r0, r5	@, proc
	bl	RedrawItemMenu		@
@ Data/FE6_FE7.c:1002: }
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
@ Data/FE6_FE7.c:1092:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L434	@ tmp292,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r6, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:1089: {
	movs	r4, r0	@ proc, tmp659
@ Data/FE6_FE7.c:1093:     if (keys & B_BUTTON)
	lsls	r3, r6, #30	@ tmp667, keys,
	bpl	.LCB2409	@
	b	.L424	@long jump	@
.LCB2409:
.L318:
@ Data/FE6_FE7.c:1099:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp305,
	tst	r3, r6	@ tmp305, keys
	beq	.LCB2416	@
	b	.L425	@long jump	@
.LCB2416:
.L319:
@ Data/FE6_FE7.c:1108:         u16 item = proc->tmp[proc->id];
	movs	r5, #48	@ tmp327,
	ldrsb	r1, [r4, r5]	@ prephitmp_305,
@ Data/FE6_FE7.c:1106:     if (keys & SELECT_BUTTON)
	lsls	r3, r6, #29	@ tmp668, keys,
	bpl	.L320		@,
@ Data/FE6_FE7.c:1108:         u16 item = proc->tmp[proc->id];
	movs	r3, r1	@ tmp335, prephitmp_305
	adds	r3, r3, #32	@ tmp335,
	lsls	r3, r3, #1	@ tmp336, tmp335,
@ Data/FE6_FE7.c:1108:         u16 item = proc->tmp[proc->id];
	ldrh	r0, [r3, r4]	@ item, *proc_187(D)
@ Data/FE6_FE7.c:1109:         if (item)
	cmp	r0, #0	@ item,
	beq	.LCB2431	@
	b	.L426	@long jump	@
.LCB2431:
.L320:
@ Data/FE6_FE7.c:1121:     if (proc->editing)
	movs	r5, #46	@ tmp347,
	movs	r7, #16	@ tmp351,
	ldrsb	r3, [r4, r5]	@ _26,
@ Data/FE6_FE7.c:1125:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r1, #1	@ tmp353,
@ Data/FE6_FE7.c:1121:     if (proc->editing)
	mov	r8, r3	@ _26, _26
	ands	r7, r6	@ _328, keys
@ Data/FE6_FE7.c:1125:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ _330, tmp353,
@ Data/FE6_FE7.c:1121:     if (proc->editing)
	cmp	r3, #0	@ _26,
	bne	.LCB2443	@
	b	.L322	@long jump	@
.LCB2443:
@ Data/FE6_FE7.c:1125:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r2, #49	@ tmp355,
	ldrsb	r2, [r4, r2]	@ tmp356,
@ Data/FE6_FE7.c:1125:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r3, .L434+4	@ tmp354,
	lsls	r2, r2, #3	@ tmp357, tmp356,
	adds	r3, r3, r2	@ tmp358, tmp354, tmp357
	ldr	r0, [r3, #120]	@ pretmp_325, CursorLocationTable[_324].x
@ Data/FE6_FE7.c:1123:         if (proc->editing == 1)
	mov	r3, r8	@ _26, _26
	cmp	r3, #1	@ _26,
	bne	.LCB2452	@
	b	.L427	@long jump	@
.LCB2452:
@ Data/FE6_FE7.c:546:     int result = 1;
	movs	r5, #1	@ result,
@ Data/FE6_FE7.c:1200:             DisplayVertUiHand(CursorLocationTable[proc->digit].x + (3 * 8), (Y_HAND + (proc->id * 2)) * 8);
	adds	r0, r0, #24	@ tmp496,
@ Data/FE6_FE7.c:1200:             DisplayVertUiHand(CursorLocationTable[proc->digit].x + (3 * 8), (Y_HAND + (proc->id * 2)) * 8);
	bl	DisplayVertUiHand		@
	ldr	r3, .L434+8	@ tmp651,
	mov	r8, r3	@ tmp651, tmp651
	adds	r3, r3, #76	@ ivtmp.595,
.L344:
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	adds	r3, r3, #4	@ ivtmp.595,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	subs	r1, r3, #4	@ tmp499, ivtmp.595,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	ldr	r1, [r1]	@ MEM[(const int *)_146 + 4294967292B], MEM[(const int *)_146 + 4294967292B]
@ Data/FE6_FE7.c:549:         result++;
	adds	r5, r5, #1	@ result,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	cmp	r1, #254	@ MEM[(const int *)_146 + 4294967292B],
	ble	.L344		@,
@ Data/FE6_FE7.c:551:     if (result > 9)
	cmp	r5, #9	@ _265,
	ble	.L345		@,
	movs	r5, #9	@ _265,
.L345:
@ Data/FE6_FE7.c:1205:             if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _328,
	beq	.L346		@,
@ Data/FE6_FE7.c:1207:                 if (proc->digit > 0)
	movs	r3, #49	@ tmp501,
	ldrsb	r3, [r4, r3]	@ _90,
@ Data/FE6_FE7.c:1207:                 if (proc->digit > 0)
	cmp	r3, #0	@ _90,
	bgt	.LCB2477	@
	b	.L347	@long jump	@
.LCB2477:
@ Data/FE6_FE7.c:1209:                     proc->digit--;
	subs	r3, r3, #1	@ tmp505,
	lsls	r3, r3, #24	@ tmp506, tmp505,
	asrs	r3, r3, #24	@ _93, tmp506,
.L348:
	movs	r2, #49	@ tmp513,
@ Data/FE6_FE7.c:1216:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _93, proc_187(D)->digit
	bl	RedrawItemMenu		@
.L346:
@ Data/FE6_FE7.c:1218:             if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp671, keys,
	bpl	.L349		@,
@ Data/FE6_FE7.c:1220:                 if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp522,
	ldrsb	r3, [r4, r3]	@ _97,
@ Data/FE6_FE7.c:1220:                 if (proc->digit < (max_digits - 1))
	subs	r5, r5, #1	@ tmp523,
@ Data/FE6_FE7.c:1220:                 if (proc->digit < (max_digits - 1))
	cmp	r3, r5	@ _97, tmp523
	bge	.LCB2499	@
	b	.L428	@long jump	@
.LCB2499:
@ Data/FE6_FE7.c:1227:                     proc->editing = 1;
	movs	r3, #46	@ tmp527,
	movs	r2, #1	@ tmp528,
	strb	r2, [r4, r3]	@ tmp528, proc_187(D)->editing
@ Data/FE6_FE7.c:1226:                     proc->digit = 0;
	movs	r3, #0	@ cstore_65,
.L351:
	movs	r2, #49	@ tmp530,
@ Data/FE6_FE7.c:1230:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ cstore_65, proc_187(D)->digit
	bl	RedrawItemMenu		@
.L349:
@ Data/FE6_FE7.c:1233:             if (keys & DPAD_UP)
	movs	r3, #64	@ tmp533,
	tst	r3, r6	@ tmp533, keys
	beq	.L352		@,
@ Data/FE6_FE7.c:1235:                 if ((proc->tmp[proc->id] & 0xFF00) == max)
	movs	r2, #48	@ tmp539,
	ldrsb	r2, [r4, r2]	@ tmp540,
	lsls	r2, r2, #1	@ tmp541, tmp540,
	adds	r2, r4, r2	@ _206, proc, tmp541
@ Data/FE6_FE7.c:1235:                 if ((proc->tmp[proc->id] & 0xFF00) == max)
	ldrsh	r1, [r2, r3]	@ _105, MEM <s16> [(struct DebuggerProc *)_206 + 64B]
@ Data/FE6_FE7.c:1235:                 if ((proc->tmp[proc->id] & 0xFF00) == max)
	movs	r3, #255	@ tmp544,
	movs	r0, r1	@ tmp543, _105
	lsls	r3, r3, #8	@ tmp544, tmp544,
	ands	r0, r3	@ tmp543, tmp544
@ Data/FE6_FE7.c:1235:                 if ((proc->tmp[proc->id] & 0xFF00) == max)
	cmp	r0, r3	@ tmp543, tmp544
	bne	.LCB2528	@
	b	.L429	@long jump	@
.LCB2528:
@ Data/FE6_FE7.c:1241:                     proc->tmp[proc->id] += DigitDecimalTable[proc->digit] << 8;
	movs	r3, #49	@ tmp551,
	ldrsb	r3, [r4, r3]	@ tmp552,
@ Data/FE6_FE7.c:1241:                     proc->tmp[proc->id] += DigitDecimalTable[proc->digit] << 8;
	lsls	r3, r3, #2	@ tmp553, tmp552,
	add	r3, r3, r8	@ tmp554, tmp651
@ Data/FE6_FE7.c:1241:                     proc->tmp[proc->id] += DigitDecimalTable[proc->digit] << 8;
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_112], DigitDecimalTable[_112]
	lsls	r3, r3, #8	@ tmp558, DigitDecimalTable[_112],
@ Data/FE6_FE7.c:1241:                     proc->tmp[proc->id] += DigitDecimalTable[proc->digit] << 8;
	adds	r3, r3, r1	@ tmp561, tmp558, _105
	lsls	r3, r3, #16	@ cstore_39, tmp561,
	asrs	r3, r3, #16	@ cstore_39, cstore_39,
.L354:
	movs	r1, #64	@ tmp562,
@ Data/FE6_FE7.c:1247:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strh	r3, [r2, r1]	@ cstore_39, MEM <s16> [(struct DebuggerProc *)_206 + 64B]
	bl	RedrawItemMenu		@
.L352:
@ Data/FE6_FE7.c:1249:             if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp672, keys,
	bpl	.L317		@,
@ Data/FE6_FE7.c:1252:                 if ((proc->tmp[proc->id] & 0xFF00) == min)
	movs	r3, #48	@ tmp571,
@ Data/FE6_FE7.c:1252:                 if ((proc->tmp[proc->id] & 0xFF00) == min)
	movs	r2, #64	@ tmp574,
	ldrsb	r3, [r4, r3]	@ tmp572,
	lsls	r3, r3, #1	@ tmp573, tmp572,
	adds	r3, r4, r3	@ _83, proc, tmp573
	ldrsh	r2, [r3, r2]	@ _126, MEM <s16> [(struct DebuggerProc *)_83 + 64B]
@ Data/FE6_FE7.c:1252:                 if ((proc->tmp[proc->id] & 0xFF00) == min)
	movs	r1, #255	@ tmp576,
	lsls	r1, r1, #8	@ tmp576, tmp576,
@ Data/FE6_FE7.c:1252:                 if ((proc->tmp[proc->id] & 0xFF00) == min)
	tst	r2, r1	@ _126, tmp576
	bne	.LCB2562	@
	b	.L430	@long jump	@
.LCB2562:
@ Data/FE6_FE7.c:1258:                     proc->tmp[proc->id] -= DigitDecimalTable[proc->digit] << 8;
	movs	r1, #49	@ tmp585,
	ldrsb	r1, [r4, r1]	@ tmp586,
@ Data/FE6_FE7.c:1258:                     proc->tmp[proc->id] -= DigitDecimalTable[proc->digit] << 8;
	lsls	r1, r1, #2	@ tmp587, tmp586,
	add	r1, r1, r8	@ tmp588, tmp651
@ Data/FE6_FE7.c:1258:                     proc->tmp[proc->id] -= DigitDecimalTable[proc->digit] << 8;
	ldr	r1, [r1, #68]	@ DigitDecimalTable[_133], DigitDecimalTable[_133]
	lsls	r1, r1, #8	@ tmp592, DigitDecimalTable[_133],
@ Data/FE6_FE7.c:1258:                     proc->tmp[proc->id] -= DigitDecimalTable[proc->digit] << 8;
	subs	r2, r2, r1	@ tmp595, _126, tmp592
	lsls	r2, r2, #16	@ _130, tmp595,
	asrs	r2, r2, #16	@ _130, _130,
.L357:
	movs	r1, #64	@ tmp596,
@ Data/FE6_FE7.c:1265:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strh	r2, [r3, r1]	@ _130, MEM <s16> [(struct DebuggerProc *)_83 + 64B]
	bl	RedrawItemMenu		@
.L317:
@ Data/FE6_FE7.c:1303: }
	@ sp needed	@
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L427:
@ Data/FE6_FE7.c:1125:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	bl	DisplayVertUiHand		@
@ Data/FE6_FE7.c:1651:     const struct ItemData * table = GetItemData(1);
	ldr	r3, .L434+12	@ tmp652,
	movs	r0, #1	@,
	mov	r9, r3	@ tmp652, tmp652
@ Data/FE6_FE7.c:1653:     int i = 1;
	subs	r5, r5, #45	@ i,
@ Data/FE6_FE7.c:1651:     const struct ItemData * table = GetItemData(1);
	bl	.L17		@
@ Data/FE6_FE7.c:1654:     for (; i <= 256; i++)
	b	.L324		@
.L413:
@ Data/FE6_FE7.c:1654:     for (; i <= 256; i++)
	adds	r5, r5, #1	@ i,
.L324:
@ Data/FE6_FE7.c:1656:         table = GetItemData(i);
	movs	r0, r5	@, i
	bl	.L139		@
@ Data/FE6_FE7.c:1657:         if (table->number != i)
	ldrb	r3, [r0, #6]	@ tmp364,
@ Data/FE6_FE7.c:1657:         if (table->number != i)
	cmp	r5, r3	@ i, tmp364
	beq	.L413		@,
@ Data/FE6_FE7.c:1659:             i--;
	subs	r0, r5, #1	@ i, i,
@ Data/FE6_FE7.c:1663:     table = GetItemData(i);
	bl	.L139		@
@ Data/FE6_FE7.c:1664:     c = table->number;
	ldrb	r5, [r0, #6]	@ c,
@ Data/FE6_FE7.c:1669:     if (c <= 1)
	cmp	r5, #1	@ c,
	bgt	.LCB2616	@
	b	.L431	@long jump	@
.LCB2616:
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	cmp	r5, #16	@ c,
	bgt	.LCB2618	@
	b	.L432	@long jump	@
.LCB2618:
.L325:
@ Data/FE6_FE7.c:1671:         c = 0x7F;
	movs	r3, #2	@ prephitmp_306,
	mov	r9, r3	@ prephitmp_306, prephitmp_306
.L329:
@ Data/FE6_FE7.c:1131:             if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _328,
	beq	.L330		@,
@ Data/FE6_FE7.c:1133:                 if (proc->digit > 0)
	movs	r3, #49	@ tmp365,
	ldrsb	r3, [r4, r3]	@ _23,
@ Data/FE6_FE7.c:1133:                 if (proc->digit > 0)
	cmp	r3, #0	@ _23,
	bgt	.LCB2629	@
	b	.L331	@long jump	@
.LCB2629:
@ Data/FE6_FE7.c:1135:                     proc->digit--;
	subs	r3, r3, #1	@ tmp369,
	lsls	r3, r3, #24	@ tmp370, tmp369,
	asrs	r3, r3, #24	@ _26, tmp370,
	mov	r8, r3	@ _26, _26
.L332:
	movs	r3, #49	@ tmp374,
	mov	r2, r8	@ _26, _26
@ Data/FE6_FE7.c:1143:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _26, proc_187(D)->digit
	bl	RedrawItemMenu		@
.L330:
@ Data/FE6_FE7.c:1145:             if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp669, keys,
	bpl	.L333		@,
@ Data/FE6_FE7.c:1147:                 if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp383,
	ldrsb	r2, [r4, r3]	@ _27,
@ Data/FE6_FE7.c:1147:                 if (proc->digit < (max_digits - 1))
	mov	r3, r9	@ prephitmp_306, prephitmp_306
	subs	r3, r3, #1	@ prephitmp_306,
	subs	r1, r3, #1	@ tmp387, tmp386
	sbcs	r3, r3, r1	@ tmp385, tmp386, tmp387
@ Data/FE6_FE7.c:1147:                 if (proc->digit < (max_digits - 1))
	cmp	r2, r3	@ _27, tmp385
	blt	.LCB2655	@
	b	.L334	@long jump	@
.LCB2655:
@ Data/FE6_FE7.c:1149:                     proc->digit++;
	adds	r2, r2, #1	@ tmp389,
	lsls	r3, r2, #24	@ tmp390, tmp389,
	asrs	r3, r3, #24	@ _32, tmp390,
.L335:
	movs	r2, #49	@ tmp394,
@ Data/FE6_FE7.c:1156:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _32, proc_187(D)->digit
	bl	RedrawItemMenu		@
.L333:
@ Data/FE6_FE7.c:1159:             if (keys & DPAD_UP)
	movs	r3, #64	@ tmp397,
	tst	r3, r6	@ tmp397, keys
	beq	.L336		@,
@ Data/FE6_FE7.c:1161:                 if ((proc->tmp[proc->id] & 0xFF) == max)
	movs	r2, #48	@ tmp403,
@ Data/FE6_FE7.c:1161:                 if ((proc->tmp[proc->id] & 0xFF) == max)
	movs	r0, #255	@ tmp408,
	ldrsb	r2, [r4, r2]	@ tmp404,
	lsls	r2, r2, #1	@ tmp405, tmp404,
	adds	r2, r4, r2	@ _81, proc, tmp405
@ Data/FE6_FE7.c:1161:                 if ((proc->tmp[proc->id] & 0xFF) == max)
	ldrsh	r1, [r2, r3]	@ _35, MEM <s16> [(struct DebuggerProc *)_81 + 64B]
@ Data/FE6_FE7.c:1161:                 if ((proc->tmp[proc->id] & 0xFF) == max)
	movs	r3, r0	@ tmp411, tmp408
	ands	r3, r1	@ tmp411, _35
@ Data/FE6_FE7.c:1161:                 if ((proc->tmp[proc->id] & 0xFF) == max)
	cmp	r3, r5	@ tmp411, c
	bne	.LCB2683	@
	b	.L433	@long jump	@
.LCB2683:
@ Data/FE6_FE7.c:1167:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	movs	r7, #49	@ tmp415,
	ldrsb	r7, [r4, r7]	@ tmp416,
@ Data/FE6_FE7.c:1167:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	ldr	r3, .L434+8	@ tmp414,
	lsls	r7, r7, #2	@ tmp417, tmp416,
	adds	r3, r3, r7	@ tmp418, tmp414, tmp417
@ Data/FE6_FE7.c:1167:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	ldr	r3, [r3, #104]	@ *_43, *_43
	adds	r3, r3, r1	@ tmp423, *_43, _35
@ Data/FE6_FE7.c:1168:                     if ((proc->tmp[proc->id] & 0xFF) > max)
	movs	r1, r0	@ tmp427, tmp408
@ Data/FE6_FE7.c:1167:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	lsls	r3, r3, #16	@ tmp424, tmp423,
	lsrs	r3, r3, #16	@ _46, tmp424,
@ Data/FE6_FE7.c:1168:                     if ((proc->tmp[proc->id] & 0xFF) > max)
	ands	r1, r3	@ tmp427, _46
@ Data/FE6_FE7.c:1168:                     if ((proc->tmp[proc->id] & 0xFF) > max)
	cmp	r1, r5	@ tmp427, c
	ble	.LCB2698	@
	b	.L339	@long jump	@
.LCB2698:
@ Data/FE6_FE7.c:1167:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	lsls	r3, r3, #16	@ _38, _46,
@ Data/FE6_FE7.c:1173:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	lsls	r0, r1, #16	@ _311, tmp427,
@ Data/FE6_FE7.c:1167:                     proc->tmp[proc->id] += pDigitTable[1][proc->digit];
	asrs	r3, r3, #16	@ _38, _38,
@ Data/FE6_FE7.c:1173:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	asrs	r0, r0, #16	@ _311, _311,
.L338:
@ Data/FE6_FE7.c:1163:                     proc->tmp[proc->id] = min | (proc->tmp[proc->id] & 0xFF00);
	movs	r1, #64	@ tmp444,
	strh	r3, [r2, r1]	@ _38, MEM <s16> [(struct DebuggerProc *)_81 + 64B]
@ Data/FE6_FE7.c:1173:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	ldr	r3, .L434+16	@ tmp446,
	bl	.L17		@
@ Data/FE6_FE7.c:1173:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	movs	r3, #48	@ tmp447,
	ldrsb	r3, [r4, r3]	@ tmp448,
@ Data/FE6_FE7.c:1173:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	adds	r3, r3, #32	@ tmp449,
	lsls	r3, r3, #1	@ tmp450, tmp449,
	strh	r0, [r4, r3]	@ tmp663, proc_187(D)->tmp[_56]
@ Data/FE6_FE7.c:1174:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	bl	RedrawItemMenu		@
.L336:
@ Data/FE6_FE7.c:1176:             if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp670, keys,
	bmi	.LCB2724	@
	b	.L317	@long jump	@
.LCB2724:
@ Data/FE6_FE7.c:1178:                 if ((proc->tmp[proc->id] & 0xFF) == min)
	movs	r3, #48	@ tmp459,
@ Data/FE6_FE7.c:1178:                 if ((proc->tmp[proc->id] & 0xFF) == min)
	movs	r2, #64	@ tmp462,
	movs	r1, #255	@ tmp466,
	ldrsb	r3, [r4, r3]	@ tmp460,
	lsls	r3, r3, #1	@ tmp461, tmp460,
	adds	r3, r4, r3	@ _222, proc, tmp461
	ldrsh	r0, [r3, r2]	@ _60, MEM <s16> [(struct DebuggerProc *)_222 + 64B]
	movs	r6, r1	@ _147, tmp466
@ Data/FE6_FE7.c:1180:                     proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF00);
	movs	r2, r0	@ _63, _60
	ands	r6, r0	@ _147, _60
	bics	r2, r1	@ _63, tmp466
@ Data/FE6_FE7.c:1178:                 if ((proc->tmp[proc->id] & 0xFF) == min)
	tst	r1, r0	@ tmp466, _60
	beq	.LCB2739	@
	b	.L342	@long jump	@
.LCB2739:
@ Data/FE6_FE7.c:1180:                     proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF00);
	orrs	r2, r5	@ _63, c
@ Data/FE6_FE7.c:1194:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	ands	r1, r2	@ tmp466, _63
	movs	r0, r1	@ _318, tmp466
.L343:
@ Data/FE6_FE7.c:1180:                     proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF00);
	movs	r1, #64	@ tmp488,
	strh	r2, [r3, r1]	@ _63, MEM <s16> [(struct DebuggerProc *)_222 + 64B]
@ Data/FE6_FE7.c:1194:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	ldr	r3, .L434+16	@ tmp490,
	bl	.L17		@
@ Data/FE6_FE7.c:1194:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	movs	r3, #48	@ tmp491,
	ldrsb	r3, [r4, r3]	@ tmp492,
@ Data/FE6_FE7.c:1194:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	adds	r3, r3, #32	@ tmp493,
	lsls	r3, r3, #1	@ tmp494, tmp493,
	strh	r0, [r4, r3]	@ tmp664, proc_187(D)->tmp[_79]
@ Data/FE6_FE7.c:1195:                 RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	bl	RedrawItemMenu		@
	b	.L317		@
.L322:
@ Data/FE6_FE7.c:1271:         DisplayUiHand(CursorLocationTable[0].x - ((ItemNameWidth + 4) * 8), (Y_HAND + (proc->id * 2)) * 8);
	movs	r0, #52	@,
	ldr	r3, .L434+20	@ tmp598,
	bl	.L17		@
@ Data/FE6_FE7.c:1272:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _328,
	beq	.L358		@,
@ Data/FE6_FE7.c:1274:             proc->digit = 1;
	movs	r3, #1	@ tmp600,
	movs	r2, #49	@ tmp599,
	strb	r3, [r4, r2]	@ tmp600, proc_187(D)->digit
@ Data/FE6_FE7.c:1275:             proc->editing = true;
	strb	r3, [r4, r5]	@ tmp600, proc_187(D)->editing
.L358:
@ Data/FE6_FE7.c:1277:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp673, keys,
	bpl	.L359		@,
@ Data/FE6_FE7.c:1279:             proc->digit = 0;
	movs	r3, #49	@ tmp612,
	movs	r2, #0	@ tmp613,
	strb	r2, [r4, r3]	@ tmp613, proc_187(D)->digit
@ Data/FE6_FE7.c:1280:             proc->editing = 2;
	subs	r3, r3, #3	@ tmp615,
	adds	r2, r2, #2	@ tmp616,
	strb	r2, [r4, r3]	@ tmp616, proc_187(D)->editing
.L359:
@ Data/FE6_FE7.c:1283:         if (keys & DPAD_UP)
	lsls	r3, r6, #25	@ tmp674, keys,
	bpl	.L360		@,
@ Data/FE6_FE7.c:1285:             proc->id--;
	movs	r3, #48	@ tmp625,
@ Data/FE6_FE7.c:1285:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp627,
	subs	r3, r3, #1	@ tmp628,
	lsls	r3, r3, #24	@ tmp629, tmp628,
	asrs	r2, r3, #24	@ _155, tmp629,
@ Data/FE6_FE7.c:1286:             if (proc->id < 0)
	cmp	r3, #0	@ tmp629,
	bge	.L361		@,
@ Data/FE6_FE7.c:1288:                 proc->id = NumberOfItems - 1;
	movs	r2, #4	@ _155,
.L361:
	movs	r3, #48	@ tmp633,
@ Data/FE6_FE7.c:1290:             RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _155, MEM <struct DebuggerProc> [(void *)proc_187(D)].id
	bl	RedrawItemMenu		@
.L360:
@ Data/FE6_FE7.c:1292:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp675, keys,
	bmi	.LCB2815	@
	b	.L317	@long jump	@
.LCB2815:
@ Data/FE6_FE7.c:1294:             proc->id++;
	movs	r1, #48	@ tmp642,
@ Data/FE6_FE7.c:1297:                 proc->id = 0;
	movs	r0, #4	@ tmp655,
	movs	r5, #0	@ tmp657,
@ Data/FE6_FE7.c:1294:             proc->id++;
	ldrb	r3, [r4, r1]	@ tmp644,
	adds	r3, r3, #1	@ tmp645,
	lsls	r3, r3, #24	@ tmp646, tmp645,
	asrs	r2, r3, #24	@ _160, tmp646,
@ Data/FE6_FE7.c:1297:                 proc->id = 0;
	lsrs	r3, r3, #31	@ tmp656, tmp646,
	cmp	r0, r2	@ tmp655, _160
	adcs	r3, r3, r5	@ tmp654, tmp656, tmp657
	rsbs	r3, r3, #0	@ tmp658, tmp654
	ands	r2, r3	@ _160, tmp658
@ Data/FE6_FE7.c:1300:             RedrawItemMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r1]	@ _160, MEM <struct DebuggerProc> [(void *)proc_187(D)].id
	bl	RedrawItemMenu		@
@ Data/FE6_FE7.c:1303: }
	b	.L317		@
.L425:
@ Data/FE6_FE7.c:1101:         CloseHelpBox();
	ldr	r3, .L434+24	@ tmp309,
	bl	.L17		@
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	movs	r3, #64	@ tmp310,
@ Data/FE6_FE7.c:470:     struct Unit * unit = proc->unit;
	ldr	r0, [r4, #60]	@ unit, proc_187(D)->unit
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r4, r3]	@ tmp311,
	strh	r3, [r0, #30]	@ tmp311, unit_267->items[0]
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	movs	r3, #66	@ tmp313,
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r4, r3]	@ tmp314,
	strh	r3, [r0, #32]	@ tmp314, unit_267->items[1]
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	movs	r3, #68	@ tmp316,
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r4, r3]	@ tmp317,
	strh	r3, [r0, #34]	@ tmp317, unit_267->items[2]
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	movs	r3, #70	@ tmp319,
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r4, r3]	@ tmp320,
	strh	r3, [r0, #36]	@ tmp320, unit_267->items[3]
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	movs	r3, #72	@ tmp322,
@ Data/FE6_FE7.c:473:         unit->items[i] = proc->tmp[i];
	ldrh	r3, [r4, r3]	@ tmp323,
	strh	r3, [r0, #38]	@ tmp323, unit_267->items[4]
@ Data/FE6_FE7.c:476:     UnitRemoveInvalidItems(unit);
	ldr	r3, .L434+28	@ tmp325,
	bl	.L17		@
@ Data/FE6_FE7.c:1103:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L434+32	@ tmp326,
	bl	.L17		@
@ Data/FE6_FE7.c:597: }
	b	.L319		@
.L424:
@ Data/FE6_FE7.c:1095:         CloseHelpBox();
	ldr	r3, .L434+24	@ tmp300,
	bl	.L17		@
@ Data/FE6_FE7.c:1096:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L434+32	@ tmp301,
	bl	.L17		@
@ Data/FE6_FE7.c:597: }
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
@ Data/FE6_FE7.c:1111:             int msg = GetItemDescId(item);
	ldr	r3, .L436	@ tmp337,
	bl	.L17		@
@ Data/FE6_FE7.c:1112:             if (msg > 0 && msg < 0x4000)
	ldr	r3, .L436+4	@ tmp339,
@ Data/FE6_FE7.c:1112:             if (msg > 0 && msg < 0x4000)
	subs	r1, r0, #1	@ tmp338, msg,
@ Data/FE6_FE7.c:1111:             int msg = GetItemDescId(item);
	movs	r2, r0	@ msg, tmp660
@ Data/FE6_FE7.c:1112:             if (msg > 0 && msg < 0x4000)
	cmp	r1, r3	@ tmp338, tmp339
	bls	.L321		@,
.L423:
@ Data/FE6_FE7.c:1125:             DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r5]	@ prephitmp_305,
	b	.L320		@
.L428:
@ Data/FE6_FE7.c:1222:                     proc->digit++;
	adds	r3, r3, #1	@ tmp525,
	lsls	r3, r3, #24	@ tmp526, tmp525,
	asrs	r3, r3, #24	@ cstore_65, tmp526,
	b	.L351		@
.L430:
@ Data/FE6_FE7.c:1254:                     proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF);
	ldr	r1, .L436+8	@ tmp583,
	orrs	r2, r1	@ _130, tmp583
	b	.L357		@
.L347:
@ Data/FE6_FE7.c:1214:                     proc->editing = false;
	movs	r2, #46	@ tmp510,
	movs	r1, #0	@ tmp511,
@ Data/FE6_FE7.c:1213:                     proc->digit = max_digits - 1;
	subs	r3, r5, #1	@ tmp508, _265,
	lsls	r3, r3, #24	@ tmp509, tmp508,
@ Data/FE6_FE7.c:1214:                     proc->editing = false;
	strb	r1, [r4, r2]	@ tmp511, proc_187(D)->editing
@ Data/FE6_FE7.c:1213:                     proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _93, tmp509,
	b	.L348		@
.L429:
@ Data/FE6_FE7.c:1237:                     proc->tmp[proc->id] = min | (proc->tmp[proc->id] & 0xFF);
	movs	r3, #255	@ tmp549,
	ands	r3, r1	@ cstore_39, _105
	b	.L354		@
.L431:
@ Data/FE6_FE7.c:1671:         c = 0x7F;
	movs	r5, #127	@ c,
	b	.L325		@
.L334:
@ Data/FE6_FE7.c:1154:                     proc->editing = false;
	movs	r3, #46	@ tmp391,
	movs	r2, #0	@ tmp392,
	strb	r2, [r4, r3]	@ tmp392, proc_187(D)->editing
@ Data/FE6_FE7.c:1153:                     proc->digit = 0;
	movs	r3, #0	@ _32,
	b	.L335		@
.L342:
@ Data/FE6_FE7.c:1184:                     val = (proc->tmp[proc->id] & 0xFF) - pDigitTable[1][proc->digit];
	movs	r5, #49	@ tmp476,
	ldrsb	r5, [r4, r5]	@ tmp477,
@ Data/FE6_FE7.c:1184:                     val = (proc->tmp[proc->id] & 0xFF) - pDigitTable[1][proc->digit];
	ldr	r0, .L436+12	@ tmp475,
	lsls	r5, r5, #2	@ tmp478, tmp477,
	adds	r0, r0, r5	@ tmp479, tmp475, tmp478
@ Data/FE6_FE7.c:1184:                     val = (proc->tmp[proc->id] & 0xFF) - pDigitTable[1][proc->digit];
	ldr	r0, [r0, #104]	@ *_69, *_69
	subs	r6, r6, r0	@ val, _147, *_69
	movs	r0, #0	@ _318,
@ Data/FE6_FE7.c:1185:                     if (val < min)
	cmp	r6, #0	@ val,
	bge	.LCB2954	@
	b	.L343	@long jump	@
.LCB2954:
@ Data/FE6_FE7.c:1191:                         proc->tmp[proc->id] = val | (proc->tmp[proc->id] & 0xFF00);
	orrs	r2, r6	@ tmp483, val
	lsls	r2, r2, #16	@ _63, tmp483,
	asrs	r2, r2, #16	@ _63, _63,
@ Data/FE6_FE7.c:1194:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	ands	r1, r2	@ tmp466, _63
	movs	r0, r1	@ _318, tmp466
	b	.L343		@
.L321:
@ Data/FE6_FE7.c:1116:                     (Y_HAND + (proc->id * 2)) * 8,
	ldrsb	r1, [r4, r5]	@ tmp342,
@ Data/FE6_FE7.c:1116:                     (Y_HAND + (proc->id * 2)) * 8,
	adds	r1, r1, #1	@ tmp343,
@ Data/FE6_FE7.c:1114:                 StartHelpBox(
	movs	r0, #52	@,
	ldr	r3, .L436+16	@ tmp345,
	lsls	r1, r1, #4	@ tmp344, tmp343,
	bl	.L17		@
	b	.L423		@
.L339:
@ Data/FE6_FE7.c:1170:                         proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF00);
	bics	r3, r0	@ tmp435, tmp408
@ Data/FE6_FE7.c:1170:                         proc->tmp[proc->id] = max | (proc->tmp[proc->id] & 0xFF00);
	orrs	r3, r5	@ tmp439, c
	lsls	r3, r3, #16	@ _38, tmp439,
	asrs	r3, r3, #16	@ _38, _38,
@ Data/FE6_FE7.c:1173:                 proc->tmp[proc->id] = MakeNewItem(proc->tmp[proc->id] & 0xFF);
	ands	r0, r3	@ _311, _38
	b	.L338		@
.L331:
@ Data/FE6_FE7.c:1140:                     proc->editing = 2;
	movs	r3, #46	@ tmp371,
	movs	r2, #2	@ tmp372,
	strb	r2, [r4, r3]	@ tmp372, proc_187(D)->editing
	b	.L332		@
.L433:
@ Data/FE6_FE7.c:1163:                     proc->tmp[proc->id] = min | (proc->tmp[proc->id] & 0xFF00);
	movs	r3, r1	@ _35, _35
	bics	r3, r0	@ _35, tmp408
	movs	r0, #0	@ _311,
	b	.L338		@
.L432:
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
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
@ Data/FE6_FE7.c:1309: {
	movs	r5, r0	@ unit, tmp145
@ Data/FE6_FE7.c:1310:     if (unit->pClassData->number == classID)
	ldr	r3, [r5, #4]	@ unit_6(D)->pClassData, unit_6(D)->pClassData
	ldrb	r3, [r3, #4]	@ tmp132,
@ Data/FE6_FE7.c:1309: {
	movs	r0, r1	@ classID, tmp146
@ Data/FE6_FE7.c:1310:     if (unit->pClassData->number == classID)
	cmp	r3, r1	@ tmp132, classID
	beq	.L438		@,
@ Data/FE6_FE7.c:1314:     const struct ClassData * table = GetClassData(classID);
	ldr	r3, .L447	@ tmp133,
	bl	.L17		@
	movs	r2, r5	@ ivtmp.609, unit
	movs	r4, r0	@ table, tmp147
@ Data/FE6_FE7.c:1318:     for (int i = 0; i < 8; ++i)
	movs	r3, #0	@ i,
@ Data/FE6_FE7.c:1315:     unit->pClassData = table;
	str	r0, [r5, #4]	@ table, unit_6(D)->pClassData
	adds	r2, r2, #40	@ ivtmp.609,
	adds	r4, r4, #44	@ tmp142,
	b	.L444		@
.L446:
@ Data/FE6_FE7.c:1329:             unit->ranks[i] = 0; // zero out wexp
	strb	r1, [r2]	@ _11, MEM[(unsigned char *)_34]
.L441:
@ Data/FE6_FE7.c:1318:     for (int i = 0; i < 8; ++i)
	adds	r3, r3, #1	@ i,
@ Data/FE6_FE7.c:1318:     for (int i = 0; i < 8; ++i)
	adds	r2, r2, #1	@ ivtmp.609,
	cmp	r3, #8	@ i,
	beq	.L438		@,
.L444:
@ Data/FE6_FE7.c:1320:         classRank = table->baseRanks[i];
	ldrb	r1, [r4, r3]	@ _11, MEM[(unsigned char *)_35 + _36 * 1]
@ Data/FE6_FE7.c:1321:         if (!classRank) // new class has no rank
	cmp	r1, #0	@ _11,
	beq	.L446		@,
@ Data/FE6_FE7.c:1332:         else if (classRank > unit->ranks[i])
	ldrb	r0, [r2]	@ MEM[(unsigned char *)_31], MEM[(unsigned char *)_31]
	cmp	r0, r1	@ MEM[(unsigned char *)_31], _11
	bcs	.L441		@,
@ Data/FE6_FE7.c:1334:             unit->ranks[i] = classRank;
	strb	r1, [r2]	@ _11, MEM[(unsigned char *)_31]
@ Data/FE6_FE7.c:1335:             charRank = unit->pCharacterData->baseRanks[i];
	ldr	r0, [r5]	@ unit_6(D)->pCharacterData, unit_6(D)->pCharacterData
	adds	r0, r0, r3	@ tmp140, unit_6(D)->pCharacterData, i
	ldrb	r0, [r0, #20]	@ _14, *_13
@ Data/FE6_FE7.c:1336:             if (charRank > unit->ranks[i])
	cmp	r1, r0	@ _11, _14
	bcs	.L441		@,
@ Data/FE6_FE7.c:1318:     for (int i = 0; i < 8; ++i)
	adds	r3, r3, #1	@ i,
@ Data/FE6_FE7.c:1338:                 unit->ranks[i] = charRank;
	strb	r0, [r2]	@ _14, MEM[(unsigned char *)_31]
@ Data/FE6_FE7.c:1318:     for (int i = 0; i < 8; ++i)
	adds	r2, r2, #1	@ ivtmp.609,
	cmp	r3, #8	@ i,
	bne	.L444		@,
.L438:
@ Data/FE6_FE7.c:1342: }
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
@ Data/FE6_FE7.c:1346:     int i = faction, last = faction + 0x40;
	movs	r6, r0	@ last, faction
@ Data/FE6_FE7.c:1345: {
	movs	r4, r0	@ faction, tmp122
@ Data/FE6_FE7.c:1346:     int i = faction, last = faction + 0x40;
	adds	r6, r6, #64	@ last,
@ Data/FE6_FE7.c:1347:     if (!i)
	cmp	r0, #0	@ faction,
	bne	.L450		@,
@ Data/FE6_FE7.c:1348:         i = 1;
	adds	r4, r4, #1	@ faction,
.L450:
	ldr	r5, .L460	@ tmp121,
	b	.L452		@
.L459:
@ Data/FE6_FE7.c:1350:     for (; i < last; ++i)
	adds	r4, r4, #1	@ faction,
@ Data/FE6_FE7.c:1350:     for (; i < last; ++i)
	cmp	r6, r4	@ last, faction
	ble	.L458		@,
.L452:
@ Data/FE6_FE7.c:1352:         struct Unit * unit = GetUnit(i);
	movs	r0, r4	@, faction
	bl	.L28		@
@ Data/FE6_FE7.c:1354:         if (unit->pCharacterData == NULL)
	ldr	r3, [r0]	@ unit_11->pCharacterData, unit_11->pCharacterData
	cmp	r3, #0	@ unit_11->pCharacterData,
	bne	.L459		@,
.L449:
@ Data/FE6_FE7.c:1359: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L458:
@ Data/FE6_FE7.c:1358:     return NULL;
	movs	r0, #0	@ <retval>,
	b	.L449		@
.L461:
	.align	2
.L460:
	.word	GetUnit
	.size	GetFreeUnitByFaction, .-GetFreeUnitByFaction
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC209:
	.ascii	"Level\000"
	.align	2
.LC212:
	.ascii	"Exp\000"
	.align	2
.LC215:
	.ascii	"Bonus Con\000"
	.align	2
.LC218:
	.ascii	"Bonus Mov\000"
	.align	2
.LC221:
	.ascii	"Status\000"
	.align	2
.LC224:
	.ascii	"Allegiance\000"
	.align	2
.LC227:
	.ascii	"  Player\000"
	.align	2
.LC230:
	.ascii	"  NPC\000"
	.align	2
.LC232:
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
@ Data/FE6_FE7.c:1462:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
@ Data/FE6_FE7.c:1459: {
	push	{r6, r7, lr}	@
@ Data/FE6_FE7.c:1462:     BG_Fill(gBG0TilemapBuffer, 0);
	ldr	r3, .L488	@ tmp152,
@ Data/FE6_FE7.c:1459: {
	movs	r5, r0	@ proc, tmp215
@ Data/FE6_FE7.c:1462:     BG_Fill(gBG0TilemapBuffer, 0);
	ldr	r0, .L488+4	@ tmp151,
	bl	.L17		@
@ Data/FE6_FE7.c:1463:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L488+8	@ tmp209,
	movs	r0, #1	@,
	mov	r8, r3	@ tmp209, tmp209
	bl	.L17		@
@ Data/FE6_FE7.c:1464:     ResetIconGraphics();
	ldr	r3, .L488+12	@ tmp154,
	bl	.L17		@
	ldr	r3, .L488+16	@ tmp212,
	mov	r10, r3	@ tmp212, tmp212
	movs	r6, r3	@ ivtmp.641, tmp212
	movs	r3, #72	@ _115,
	add	r3, r3, r10	@ _115, tmp212
	mov	r9, r3	@ _115, _115
	mov	r4, r10	@ ivtmp.652, tmp212
	ldr	r7, .L488+20	@ tmp213,
.L463:
@ Data/FE6_FE7.c:1471:         ClearText(&th[i]);
	movs	r0, r4	@, ivtmp.652
@ Data/FE6_FE7.c:1469:     for (i = 0; i <= NumberOfMisc; ++i)
	adds	r4, r4, #8	@ ivtmp.652,
@ Data/FE6_FE7.c:1471:         ClearText(&th[i]);
	bl	.L145		@
@ Data/FE6_FE7.c:1469:     for (i = 0; i <= NumberOfMisc; ++i)
	cmp	r4, r9	@ ivtmp.652, _115
	bne	.L463		@,
@ Data/FE6_FE7.c:1476:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(proc->tmp[0])->nameTextId));
	movs	r3, #64	@ tmp157,
@ Data/FE6_FE7.c:1476:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(proc->tmp[0])->nameTextId));
	ldrsh	r0, [r5, r3]	@ tmp158,
	ldr	r3, .L488+24	@ tmp159,
	bl	.L17		@
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	movs	r3, #128	@ tmp161,
@ Data/FE6_FE7.c:1476:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(proc->tmp[0])->nameTextId));
	ldrh	r0, [r0]	@ _7, *_6
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	subs	r2, r0, #1	@ tmp160, _7,
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	lsls	r3, r3, #7	@ tmp161, tmp161,
	cmp	r2, r3	@ tmp160, tmp161
	bcs	.LCB3170	@
	b	.L481	@long jump	@
.LCB3170:
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	ldr	r1, .L488+28	@ _77,
.L464:
@ Data/FE6_FE7.c:1476:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(proc->tmp[0])->nameTextId));
	mov	r0, r10	@, tmp212
	ldr	r7, .L488+32	@ tmp214,
	bl	.L145		@
@ Data/FE6_FE7.c:1478:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetClassData(proc->tmp[1])->nameTextId));
	movs	r3, #66	@ tmp165,
@ Data/FE6_FE7.c:1478:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetClassData(proc->tmp[1])->nameTextId));
	ldrsh	r0, [r5, r3]	@ tmp166,
	ldr	r3, .L488+36	@ tmp167,
	bl	.L17		@
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	movs	r3, #128	@ tmp169,
@ Data/FE6_FE7.c:1478:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetClassData(proc->tmp[1])->nameTextId));
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
@ Data/FE6_FE7.c:1478:     Text_DrawString(&th[i], GetStringFromIndexSafe(GetClassData(proc->tmp[1])->nameTextId));
	ldr	r4, .L488+40	@ tmp171,
	movs	r0, r4	@, tmp171
	bl	.L145		@
@ Data/FE6_FE7.c:1492:     Text_DrawString(&th[i], "Level");
	movs	r0, r4	@ tmp174, tmp171
	ldr	r1, .L488+44	@ tmp173,
	adds	r0, r0, #8	@ tmp174,
	bl	.L145		@
@ Data/FE6_FE7.c:1494:     Text_DrawString(&th[i], "Exp");
	movs	r0, r4	@ tmp177, tmp171
	ldr	r1, .L488+48	@ tmp176,
	adds	r0, r0, #16	@ tmp177,
	bl	.L145		@
@ Data/FE6_FE7.c:1496:     Text_DrawString(&th[i], "Bonus Con");
	movs	r0, r4	@ tmp180, tmp171
	ldr	r1, .L488+52	@ tmp179,
	adds	r0, r0, #24	@ tmp180,
	bl	.L145		@
@ Data/FE6_FE7.c:1498:     Text_DrawString(&th[i], "Bonus Mov");
	movs	r0, r4	@ tmp183, tmp171
	ldr	r1, .L488+56	@ tmp182,
	adds	r0, r0, #32	@ tmp183,
	bl	.L145		@
@ Data/FE6_FE7.c:1506:     Text_DrawString(&th[i], "Status");
	movs	r0, r4	@ tmp186, tmp171
	ldr	r1, .L488+60	@ tmp185,
	adds	r0, r0, #40	@ tmp186,
	bl	.L145		@
@ Data/FE6_FE7.c:1545:     Text_DrawString(&th[i], "Allegiance");
	movs	r0, r4	@ tmp189, tmp171
	ldr	r1, .L488+64	@ tmp188,
	adds	r0, r0, #48	@ tmp189,
	bl	.L145		@
@ Data/FE6_FE7.c:1550:     if (proc->tmp[7] == 0)
	movs	r3, #78	@ tmp191,
	ldrsh	r3, [r5, r3]	@ _14,
@ Data/FE6_FE7.c:1550:     if (proc->tmp[7] == 0)
	cmp	r3, #0	@ _14,
	beq	.L483		@,
@ Data/FE6_FE7.c:1555:     else if (proc->tmp[7] == 1)
	cmp	r3, #1	@ _14,
	beq	.L484		@,
@ Data/FE6_FE7.c:1559:     else if (proc->tmp[7] == 2)
	cmp	r3, #2	@ _14,
	beq	.L485		@,
.L467:
@ Data/FE6_FE7.c:1565:     PutText(&th[8], gBG0TilemapBuffer + TILEMAP_INDEX(START_X - 3, Y_HAND + (i * 2)));
	ldr	r3, .L488+68	@ tmp201,
	movs	r7, r3	@ tmp201, tmp201
	movs	r1, r3	@, tmp201
	ldr	r3, .L488+72	@ tmp210,
	ldr	r0, .L488+76	@ tmp202,
	mov	r9, r3	@ tmp210, tmp210
	bl	.L17		@
	ldr	r3, .L488+80	@ tmp252,
	adds	r4, r7, r3	@ ivtmp.643, tmp201, tmp252
	adds	r7, r7, #116	@ _109,
.L469:
@ Data/FE6_FE7.c:1569:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	movs	r1, r4	@, ivtmp.643
	movs	r0, r6	@, ivtmp.641
@ Data/FE6_FE7.c:1567:     for (i = 0; i < NumberOfMisc; ++i)
	adds	r4, r4, #128	@ ivtmp.643,
@ Data/FE6_FE7.c:1569:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	bl	.L139		@
@ Data/FE6_FE7.c:1567:     for (i = 0; i < NumberOfMisc; ++i)
	adds	r6, r6, #8	@ ivtmp.641,
	cmp	r4, r7	@ ivtmp.643, _109
	bne	.L469		@,
	movs	r4, #0	@ ivtmp.625,
	ldr	r6, .L488+84	@ ivtmp.632,
	ldr	r7, .L488+88	@ tmp211,
	adds	r5, r5, #64	@ ivtmp.630,
.L470:
@ Data/FE6_FE7.c:2772:     PutNumber(tm, color, number);
	movs	r1, #3	@,
	movs	r0, r6	@, ivtmp.632
@ Data/FE6_FE7.c:1581:                 gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	movs	r3, #0	@ tmp238,
	ldrsh	r2, [r5, r3]	@ pretmp_99, ivtmp.630, tmp238
@ Data/FE6_FE7.c:1578:         else if (i < 2)
	cmp	r4, #1	@ ivtmp.625,
	bls	.L486		@,
.L471:
@ Data/FE6_FE7.c:1574:         if (i == 7)
	adds	r4, r4, #1	@ ivtmp.625,
@ Data/FE6_FE7.c:1585:             PutNumber(
	bl	.L145		@
@ Data/FE6_FE7.c:1574:         if (i == 7)
	cmp	r4, #7	@ ivtmp.625,
	beq	.L487		@,
	adds	r6, r6, #128	@ ivtmp.632,
	adds	r5, r5, #2	@ ivtmp.630,
@ Data/FE6_FE7.c:2772:     PutNumber(tm, color, number);
	movs	r1, #3	@,
	movs	r0, r6	@, ivtmp.632
@ Data/FE6_FE7.c:1581:                 gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	movs	r3, #0	@ tmp238,
	ldrsh	r2, [r5, r3]	@ pretmp_99, ivtmp.630, tmp238
@ Data/FE6_FE7.c:1578:         else if (i < 2)
	cmp	r4, #1	@ ivtmp.625,
	bhi	.L471		@,
.L486:
@ Data/FE6_FE7.c:2772:     PutNumber(tm, color, number);
	bl	.L145		@
@ Data/FE6_FE7.c:1574:         if (i == 7)
	adds	r4, r4, #1	@ ivtmp.625,
	adds	r5, r5, #2	@ ivtmp.630,
	adds	r6, r6, #128	@ ivtmp.632,
	b	.L470		@
.L487:
@ Data/FE6_FE7.c:1596:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
@ Data/FE6_FE7.c:1597: }
	@ sp needed	@
@ Data/FE6_FE7.c:1596:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	bl	.L193		@
@ Data/FE6_FE7.c:1597: }
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
@ Data/FE6_FE7.c:1553:         Text_DrawString(&th[8], "  Player");
	movs	r0, r4	@ tmp171, tmp171
	ldr	r1, .L488+96	@ tmp192,
	adds	r0, r0, #56	@ tmp171,
	bl	.L145		@
	b	.L467		@
.L485:
@ Data/FE6_FE7.c:1561:         Text_DrawString(&th[8], "  Enemy");
	movs	r0, r4	@ tmp171, tmp171
	ldr	r1, .L488+100	@ tmp198,
	adds	r0, r0, #56	@ tmp171,
	bl	.L145		@
	b	.L467		@
.L484:
@ Data/FE6_FE7.c:1557:         Text_DrawString(&th[8], "  NPC");
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
	.word	.LC209
	.word	.LC212
	.word	.LC215
	.word	.LC218
	.word	.LC221
	.word	.LC224
	.word	gBG0TilemapBuffer+1056
	.word	PutText
	.word	gStatScreen+88
	.word	-908
	.word	gBG0TilemapBuffer+166
	.word	PutNumber
	.word	GetStringFromIndex
	.word	.LC227
	.word	.LC232
	.word	.LC230
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
@ Data/FE6_FE7.c:406:     ResetTextFont();
	ldr	r6, .L493	@ tmp144,
	bl	.L38		@
@ Data/FE6_FE7.c:407:     SetTextFontGlyphs(0);
	ldr	r4, .L493+4	@ tmp145,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:410:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L493+8	@ tmp146,
	ldr	r3, .L493+12	@ tmp147,
	bl	.L17		@
@ Data/FE6_FE7.c:411:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L493+16	@ tmp148,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:412:     ResetTextFont();
	bl	.L38		@
@ Data/FE6_FE7.c:413:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:414:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L493+20	@ tmp151,
	bl	.L17		@
@ Data/FE6_FE7.c:415:     ClearBg0Bg1();
	ldr	r3, .L493+24	@ tmp152,
	bl	.L17		@
@ Data/FE6_FE7.c:416:     ResetText();
	ldr	r3, .L493+28	@ tmp153,
	bl	.L17		@
@ Data/FE6_FE7.c:1413:     LoadIconPalettes(4);
	movs	r0, #4	@,
	ldr	r3, .L493+32	@ tmp154,
	bl	.L17		@
@ Data/FE6_FE7.c:1417:         proc->tmp[i] = 0;
	movs	r0, r5	@ tmp155, proc
@ Data/FE6_FE7.c:1414:     struct Unit * unit = proc->unit;
	ldr	r4, [r5, #60]	@ unit, proc_32(D)->unit
@ Data/FE6_FE7.c:1417:         proc->tmp[i] = 0;
	movs	r2, #16	@,
	movs	r1, #0	@,
	ldr	r3, .L493+36	@ tmp158,
	adds	r0, r0, #64	@ tmp155,
	bl	.L17		@
@ Data/FE6_FE7.c:1419:     proc->tmp[0] = unit->pCharacterData->number;
	ldr	r3, [r4]	@ unit_35->pCharacterData, unit_35->pCharacterData
	ldrb	r2, [r3, #4]	@ tmp163,
@ Data/FE6_FE7.c:1419:     proc->tmp[0] = unit->pCharacterData->number;
	movs	r3, #64	@ tmp164,
	strh	r2, [r5, r3]	@ tmp163, proc_32(D)->tmp[0]
@ Data/FE6_FE7.c:1420:     proc->tmp[1] = unit->pClassData->number;
	ldr	r3, [r4, #4]	@ unit_35->pClassData, unit_35->pClassData
	ldrb	r2, [r3, #4]	@ tmp167,
@ Data/FE6_FE7.c:1420:     proc->tmp[1] = unit->pClassData->number;
	movs	r3, #66	@ tmp168,
	strh	r2, [r5, r3]	@ tmp167, proc_32(D)->tmp[1]
@ Data/FE6_FE7.c:1421:     proc->tmp[2] = unit->level;
	movs	r2, #8	@ tmp170,
	ldrsb	r2, [r4, r2]	@ tmp170,
@ Data/FE6_FE7.c:1421:     proc->tmp[2] = unit->level;
	adds	r3, r3, #2	@ tmp171,
	strh	r2, [r5, r3]	@ tmp170, proc_32(D)->tmp[2]
@ Data/FE6_FE7.c:1422:     proc->tmp[3] = unit->exp;
	ldrb	r2, [r4, #9]	@ tmp173,
@ Data/FE6_FE7.c:1422:     proc->tmp[3] = unit->exp;
	adds	r3, r3, #2	@ tmp174,
	strh	r2, [r5, r3]	@ tmp173, proc_32(D)->tmp[3]
@ Data/FE6_FE7.c:1423:     proc->tmp[4] = unit->conBonus;
	movs	r2, #26	@ tmp176,
	ldrsb	r2, [r4, r2]	@ tmp176,
@ Data/FE6_FE7.c:1423:     proc->tmp[4] = unit->conBonus;
	adds	r3, r3, #2	@ tmp177,
	strh	r2, [r5, r3]	@ tmp176, proc_32(D)->tmp[4]
@ Data/FE6_FE7.c:1424:     proc->tmp[5] = unit->movBonus;
	movs	r2, #29	@ tmp179,
	ldrsb	r2, [r4, r2]	@ tmp179,
@ Data/FE6_FE7.c:1424:     proc->tmp[5] = unit->movBonus;
	adds	r3, r3, #2	@ tmp180,
	strh	r2, [r5, r3]	@ tmp179, proc_32(D)->tmp[5]
@ Data/FE6_FE7.c:1425:     proc->tmp[6] = unit->statusIndex;
	movs	r2, #48	@ tmp183,
@ Data/FE6_FE7.c:1425:     proc->tmp[6] = unit->statusIndex;
	movs	r1, #76	@ tmp191,
@ Data/FE6_FE7.c:1425:     proc->tmp[6] = unit->statusIndex;
	ldrb	r3, [r4, r2]	@ *unit_35, *unit_35
	lsls	r3, r3, #28	@ tmp187, *unit_35,
	lsrs	r3, r3, #28	@ tmp189, tmp187,
@ Data/FE6_FE7.c:1425:     proc->tmp[6] = unit->statusIndex;
	strh	r3, [r5, r1]	@ tmp189, proc_32(D)->tmp[6]
@ Data/FE6_FE7.c:1426:     proc->tmp[8] = unit->statusDuration;
	ldrb	r3, [r4, r2]	@ *unit_35, *unit_35
@ Data/FE6_FE7.c:1426:     proc->tmp[8] = unit->statusDuration;
	adds	r2, r2, #32	@ tmp202,
@ Data/FE6_FE7.c:1426:     proc->tmp[8] = unit->statusDuration;
	lsrs	r3, r3, #4	@ tmp200, *unit_35,
@ Data/FE6_FE7.c:1426:     proc->tmp[8] = unit->statusDuration;
	strh	r3, [r5, r2]	@ tmp200, proc_32(D)->tmp[8]
@ Data/FE6_FE7.c:1427:     proc->tmp[7] = (unit->index & 0xC0) >> 6;
	ldrb	r3, [r4, #11]	@ tmp209,
@ Data/FE6_FE7.c:1427:     proc->tmp[7] = (unit->index & 0xC0) >> 6;
	subs	r2, r2, #2	@ tmp210,
@ Data/FE6_FE7.c:1427:     proc->tmp[7] = (unit->index & 0xC0) >> 6;
	lsrs	r3, r3, #6	@ tmp208, tmp209,
@ Data/FE6_FE7.c:1427:     proc->tmp[7] = (unit->index & 0xC0) >> 6;
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
	ldr	r4, .L493+44	@ ivtmp.665,
	movs	r7, r4	@ _75, ivtmp.665
	ldr	r6, .L493+48	@ tmp216,
	adds	r7, r7, #72	@ _75,
.L491:
@ Data/FE6_FE7.c:1442:         InitText(&th[i], MiscNameWidth);
	movs	r0, r4	@, ivtmp.665
	movs	r1, #6	@,
@ Data/FE6_FE7.c:1440:     for (int i = 0; i <= NumberOfMisc; ++i)
	adds	r4, r4, #8	@ ivtmp.665,
@ Data/FE6_FE7.c:1442:         InitText(&th[i], MiscNameWidth);
	bl	.L38		@
@ Data/FE6_FE7.c:1440:     for (int i = 0; i <= NumberOfMisc; ++i)
	cmp	r7, r4	@ _75, ivtmp.665
	bne	.L491		@,
@ Data/FE6_FE7.c:1445:     RedrawMiscMenu(proc);
	movs	r0, r5	@, proc
	bl	RedrawMiscMenu		@
@ Data/FE6_FE7.c:1446: }
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
@ Data/FE6_FE7.c:1600: {
	movs	r3, r0	@ id, tmp123
@ Data/FE6_FE7.c:1647: }
	@ sp needed	@
@ Data/FE6_FE7.c:1602:     switch (id)
	movs	r2, #2	@ tmp121,
	movs	r0, #0	@ tmp122,
	cmp	r2, r3	@ tmp121, id
	adcs	r0, r0, r0	@ tmp120, tmp122, tmp122
@ Data/FE6_FE7.c:1647: }
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
@ Data/FE6_FE7.c:1731: {
	movs	r4, r0	@ id, tmp146
@ Data/FE6_FE7.c:1733:     switch (id)
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
@ Data/FE6_FE7.c:1757:             result = 15;
	movs	r0, #15	@ <retval>,
.L496:
@ Data/FE6_FE7.c:1782: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L498:
@ Data/FE6_FE7.c:1770:             result = 10;
	movs	r0, #10	@ <retval>,
@ Data/FE6_FE7.c:1772:             break;
	b	.L496		@
.L504:
@ Data/FE6_FE7.c:1705:     const struct CharacterData * table = GetCharacterData(1);
	movs	r0, #1	@,
	ldr	r5, .L516+4	@ tmp144,
	bl	.L28		@
@ Data/FE6_FE7.c:1707:     int i = 1;
	movs	r4, #1	@ i,
@ Data/FE6_FE7.c:1708:     for (; i <= c; i++)
	b	.L505		@
.L513:
@ Data/FE6_FE7.c:1708:     for (; i <= c; i++)
	adds	r4, r4, #1	@ i,
.L505:
@ Data/FE6_FE7.c:1710:         table = GetCharacterData(i);
	movs	r0, r4	@, i
	bl	.L28		@
@ Data/FE6_FE7.c:1711:         if (table->number != i)
	ldrb	r3, [r0, #4]	@ tmp137,
@ Data/FE6_FE7.c:1711:         if (table->number != i)
	cmp	r4, r3	@ i, tmp137
	beq	.L513		@,
.L510:
@ Data/FE6_FE7.c:1686:             i--;
	subs	r0, r4, #1	@ i, id,
@ Data/FE6_FE7.c:1690:     table = GetClassData(i);
	bl	.L28		@
@ Data/FE6_FE7.c:1691:     c = table->number;
	ldrb	r0, [r0, #4]	@ <retval>,
@ Data/FE6_FE7.c:1696:     if (c <= 1)
	cmp	r0, #1	@ <retval>,
	bgt	.L496		@,
@ Data/FE6_FE7.c:1725:         c = 0x49;
	movs	r0, #73	@ <retval>,
	b	.L496		@
.L503:
@ Data/FE6_FE7.c:1678:     const struct ClassData * table = GetClassData(1);
	ldr	r5, .L516+8	@ tmp145,
	movs	r0, #1	@,
	bl	.L28		@
@ Data/FE6_FE7.c:1681:     for (; i <= c; i++)
	b	.L509		@
.L514:
@ Data/FE6_FE7.c:1681:     for (; i <= c; i++)
	adds	r4, r4, #1	@ id,
.L509:
@ Data/FE6_FE7.c:1683:         table = GetClassData(i);
	movs	r0, r4	@, id
	bl	.L28		@
@ Data/FE6_FE7.c:1684:         if (table->number != i)
	ldrb	r3, [r0, #4]	@ tmp142,
@ Data/FE6_FE7.c:1684:         if (table->number != i)
	cmp	r4, r3	@ id, tmp142
	beq	.L514		@,
	b	.L510		@
.L502:
@ Data/FE6_FE7.c:1747:             result = 255;
	movs	r0, #255	@ <retval>,
	b	.L496		@
.L512:
@ Data/FE6_FE7.c:1733:     switch (id)
	movs	r0, #100	@ <retval>,
@ Data/FE6_FE7.c:1781:     return result;
	b	.L496		@
.L497:
@ Data/FE6_FE7.c:1777:             result = 2;
	movs	r0, #2	@ <retval>,
@ Data/FE6_FE7.c:1778:             break;
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
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	cmp	r0, #0	@ page,
	ble	.L518		@,
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	movs	r5, #0	@ i,
@ Data/FE6_FE7.c:1942:     int result = 0;
	movs	r2, #0	@ result,
	ldr	r6, .L530	@ ivtmp.701,
.L523:
	movs	r4, r2	@ _29, result
	ldr	r3, [r6]	@ ivtmp.698, MEM[(const struct MenuItemDef * *)_33]
	adds	r4, r4, #255	@ _29,
	b	.L522		@
.L529:
@ Data/FE6_FE7.c:1951:             result++;
	adds	r2, r2, #1	@ result,
@ Data/FE6_FE7.c:1945:         for (int c = 0; c < 255; ++c)
	adds	r3, r3, #36	@ ivtmp.698,
	cmp	r2, r4	@ result, _29
	beq	.L521		@,
.L522:
@ Data/FE6_FE7.c:1947:             if (!ggDebuggerMenuItems[i][c].name)
	ldr	r1, [r3]	@ MEM[(const char * *)_26], MEM[(const char * *)_26]
	cmp	r1, #0	@ MEM[(const char * *)_26],
	bne	.L529		@,
.L521:
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	adds	r5, r5, #1	@ i,
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	adds	r6, r6, #4	@ ivtmp.701,
	cmp	r0, r5	@ page, i
	bne	.L523		@,
@ Data/FE6_FE7.c:1954:     return result + page; // avoid the word 0 terminator offset
	adds	r0, r0, r2	@ <retval>, page, result
.L518:
@ Data/FE6_FE7.c:1955: }
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
@ Data/FE6_FE7.c:1960:     index += CountDebuggerMenuItems(procIdler->page);
	movs	r3, #52	@ tmp132,
@ Data/FE6_FE7.c:1958: {
	push	{r4, r5, r6, r7, lr}	@
@ Data/FE6_FE7.c:1960:     index += CountDebuggerMenuItems(procIdler->page);
	ldrb	r7, [r0, r3]	@ _43,
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	cmp	r7, #0	@ _43,
	beq	.L534		@,
@ Data/FE6_FE7.c:1942:     int result = 0;
	movs	r2, #0	@ result,
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	movs	r5, #0	@ i,
	ldr	r6, .L544	@ ivtmp.717,
.L537:
	movs	r4, r2	@ _32, result
	ldr	r3, [r6]	@ ivtmp.714, MEM[(const struct MenuItemDef * *)_21]
	adds	r4, r4, #255	@ _32,
	b	.L536		@
.L543:
@ Data/FE6_FE7.c:1951:             result++;
	adds	r2, r2, #1	@ result,
@ Data/FE6_FE7.c:1945:         for (int c = 0; c < 255; ++c)
	adds	r3, r3, #36	@ ivtmp.714,
	cmp	r2, r4	@ result, _32
	beq	.L535		@,
.L536:
@ Data/FE6_FE7.c:1947:             if (!ggDebuggerMenuItems[i][c].name)
	ldr	r0, [r3]	@ MEM[(const char * *)_35], MEM[(const char * *)_35]
	cmp	r0, #0	@ MEM[(const char * *)_35],
	bne	.L543		@,
.L535:
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	adds	r5, r5, #1	@ i,
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	adds	r6, r6, #4	@ ivtmp.717,
	cmp	r7, r5	@ _43, i
	bgt	.L537		@,
@ Data/FE6_FE7.c:1954:     return result + page; // avoid the word 0 terminator offset
	adds	r7, r7, r2	@ _43, _43, result
.L534:
@ Data/FE6_FE7.c:1961:     return gDebuggerMenuText[index * 2];
	adds	r1, r1, r7	@ tmp136, index, _43
@ Data/FE6_FE7.c:1961:     return gDebuggerMenuText[index * 2];
	ldr	r3, .L544+4	@ tmp135,
@ Data/FE6_FE7.c:1962: }
	@ sp needed	@
@ Data/FE6_FE7.c:1961:     return gDebuggerMenuText[index * 2];
	lsls	r1, r1, #3	@ tmp138, tmp136,
@ Data/FE6_FE7.c:1961:     return gDebuggerMenuText[index * 2];
	ldr	r0, [r1, r3]	@ gDebuggerMenuText[_3], gDebuggerMenuText[_3]
@ Data/FE6_FE7.c:1962: }
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
@ Data/FE6_FE7.c:1965:     int x = gBmSt.playerCursor.x;
	ldr	r3, .L551	@ tmp162,
	movs	r2, #20	@ tmp165,
	ldrsh	r4, [r3, r2]	@ _1, tmp162, tmp165
@ Data/FE6_FE7.c:1966:     int y = gBmSt.playerCursor.y;
	movs	r2, #22	@ tmp166,
	ldrsh	r1, [r3, r2]	@ _2, tmp162, tmp166
@ Data/FE6_FE7.c:1967:     if (x < 0)
	cmp	r4, #0	@ _1,
	bge	.L547		@,
@ Data/FE6_FE7.c:1969:         gBmSt.playerCursor.x = 0;
	movs	r2, #0	@ tmp133,
@ Data/FE6_FE7.c:1970:         gActiveUnitMoveOrigin.x = 0;
	ldr	r0, .L551+4	@ tmp135,
@ Data/FE6_FE7.c:1969:         gBmSt.playerCursor.x = 0;
	strh	r2, [r3, #20]	@ tmp133, gBmSt.playerCursor.x
@ Data/FE6_FE7.c:1970:         gActiveUnitMoveOrigin.x = 0;
	strh	r2, [r0]	@ tmp133, gActiveUnitMoveOrigin.x
.L547:
@ Data/FE6_FE7.c:1972:     if (y < 0)
	cmp	r1, #0	@ _2,
	bge	.L548		@,
@ Data/FE6_FE7.c:1974:         gBmSt.playerCursor.y = 0;
	movs	r2, #0	@ tmp141,
@ Data/FE6_FE7.c:1975:         gActiveUnitMoveOrigin.y = 0;
	ldr	r0, .L551+4	@ tmp143,
@ Data/FE6_FE7.c:1974:         gBmSt.playerCursor.y = 0;
	strh	r2, [r3, #22]	@ tmp141, gBmSt.playerCursor.y
@ Data/FE6_FE7.c:1975:         gActiveUnitMoveOrigin.y = 0;
	strh	r2, [r0, #2]	@ tmp141, gActiveUnitMoveOrigin.y
.L548:
@ Data/FE6_FE7.c:1977:     if (x >= gBmMapSize.x)
	ldr	r0, .L551+8	@ tmp163,
	movs	r5, #0	@ tmp167,
	ldrsh	r2, [r0, r5]	@ _3, tmp163, tmp167
@ Data/FE6_FE7.c:1977:     if (x >= gBmMapSize.x)
	cmp	r4, r2	@ _1, _3
	blt	.L549		@,
@ Data/FE6_FE7.c:1979:         x = gBmMapSize.x - 1;
	subs	r2, r2, #1	@ x,
@ Data/FE6_FE7.c:1981:         gActiveUnitMoveOrigin.x = x;
	ldr	r5, .L551+4	@ tmp149,
@ Data/FE6_FE7.c:1980:         gBmSt.playerCursor.x = x;
	lsls	r4, r2, #16	@ _5, x,
	asrs	r4, r4, #16	@ _5, _5,
	strh	r4, [r3, #20]	@ _5, gBmSt.playerCursor.x
@ Data/FE6_FE7.c:1981:         gActiveUnitMoveOrigin.x = x;
	strh	r4, [r5]	@ _5, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:1982:         gActiveUnit->xPos = x;
	ldr	r4, .L551+12	@ tmp152,
	ldr	r4, [r4]	@ gActiveUnit, gActiveUnit
	strb	r2, [r4, #16]	@ x, gActiveUnit.46_6->xPos
.L549:
@ Data/FE6_FE7.c:1984:     if (y >= gBmMapSize.y)
	movs	r2, #2	@ _8,
	ldrsh	r2, [r0, r2]	@ _8, tmp163, _8
@ Data/FE6_FE7.c:1984:     if (y >= gBmMapSize.y)
	cmp	r1, r2	@ _2, _8
	blt	.L546		@,
@ Data/FE6_FE7.c:1986:         y = gBmMapSize.y - 1;
	subs	r2, r2, #1	@ y,
@ Data/FE6_FE7.c:1987:         gBmSt.playerCursor.y = y;
	lsls	r1, r2, #16	@ _10, y,
	asrs	r1, r1, #16	@ _10, _10,
	strh	r1, [r3, #22]	@ _10, gBmSt.playerCursor.y
@ Data/FE6_FE7.c:1988:         gActiveUnitMoveOrigin.x = y;
	ldr	r3, .L551+4	@ tmp157,
	strh	r1, [r3]	@ _10, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:1989:         gActiveUnit->yPos = y;
	ldr	r3, .L551+12	@ tmp160,
	ldr	r3, [r3]	@ gActiveUnit, gActiveUnit
	strb	r2, [r3, #17]	@ y, gActiveUnit.47_11->yPos
.L546:
@ Data/FE6_FE7.c:1991: }
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
@ Data/FE6_FE7.c:2044: {
	movs	r4, r0	@ proc, tmp202
@ Data/FE6_FE7.c:2031:     FixCursorOverflow();
	bl	FixCursorOverflow		@
@ Data/FE6_FE7.c:2032:     HandlePlayerCursorMovement();
	ldr	r3, .L562	@ tmp143,
	bl	.L17		@
@ Data/FE6_FE7.c:2046:     u16 keys = gKeyStatusPtr->newKeys;
	ldr	r3, .L562+4	@ tmp145,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r3, [r3, #8]	@ keys,
@ Data/FE6_FE7.c:2047:     if (keys & A_BUTTON)
	lsls	r2, r3, #31	@ tmp204, keys,
	bmi	.L560		@,
@ Data/FE6_FE7.c:2059:     if (keys & B_BUTTON)
	movs	r5, #2	@ tmp172,
	tst	r5, r3	@ tmp172, keys
	bne	.L561		@,
@ Data/FE6_FE7.c:2069:         gBmSt.playerCursorDisplay.x, gBmSt.playerCursorDisplay.y,
	ldr	r3, .L562+8	@ tmp188,
@ Data/FE6_FE7.c:2068:     PutMapCursor(
	movs	r2, #32	@ tmp210,
	ldrsh	r4, [r3, r2]	@ _11, tmp188, tmp210
	movs	r2, #34	@ tmp211,
	ldrsh	r6, [r3, r2]	@ _13, tmp188, tmp211
@ Data/FE6_FE7.c:2070:         IsUnitSpriteHoverEnabledAt(gBmSt.playerCursor.x, gBmSt.playerCursor.y) ? 3 : 0);
	movs	r2, #22	@ tmp212,
	ldrsh	r1, [r3, r2]	@ tmp191, tmp188, tmp212
	movs	r0, #20	@ tmp193,
	ldrsh	r0, [r3, r0]	@ tmp193, tmp188, tmp193
	ldr	r3, .L562+12	@ tmp194,
	bl	.L17		@
@ Data/FE6_FE7.c:2068:     PutMapCursor(
	rsbs	r3, r0, #0	@ tmp199, tmp203
	adcs	r0, r0, r3	@ tmp198, tmp203, tmp199
	rsbs	r2, r0, #0	@ tmp200, tmp198
	bics	r2, r5	@ iftmp.52_19, tmp172
@ Data/FE6_FE7.c:2068:     PutMapCursor(
	movs	r1, r6	@, _13
	movs	r0, r4	@, _11
	ldr	r3, .L562+16	@ tmp197,
@ Data/FE6_FE7.c:2068:     PutMapCursor(
	adds	r2, r2, #3	@ iftmp.52_19,
@ Data/FE6_FE7.c:2068:     PutMapCursor(
	bl	.L17		@
.L553:
@ Data/FE6_FE7.c:2071: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L561:
@ Data/FE6_FE7.c:2061:         gActionData.xMove = gActiveUnitMoveOrigin.x;
	ldr	r3, .L562+20	@ tmp176,
	movs	r1, #0	@ tmp208,
	ldrsh	r2, [r3, r1]	@ _6, tmp176, tmp208
@ Data/FE6_FE7.c:2061:         gActionData.xMove = gActiveUnitMoveOrigin.x;
	ldr	r1, .L562+24	@ tmp177,
	strb	r2, [r1, #14]	@ _6, gActionData.xMove
@ Data/FE6_FE7.c:2062:         gActionData.yMove = gActiveUnitMoveOrigin.y;
	movs	r0, #2	@ tmp209,
	ldrsh	r3, [r3, r0]	@ _8, tmp176, tmp209
@ Data/FE6_FE7.c:2062:         gActionData.yMove = gActiveUnitMoveOrigin.y;
	strb	r3, [r1, #15]	@ _8, gActionData.yMove
.L559:
@ Data/FE6_FE7.c:2037:     gActiveUnit->xPos = gActionData.xMove;
	ldr	r1, .L562+28	@ tmp182,
	ldr	r0, [r1]	@ gActiveUnit.48_46, gActiveUnit
@ Data/FE6_FE7.c:2037:     gActiveUnit->xPos = gActionData.xMove;
	strb	r2, [r0, #16]	@ _6,
@ Data/FE6_FE7.c:2038:     gActiveUnit->yPos = gActionData.yMove;
	strb	r3, [r0, #17]	@ _8,
@ Data/FE6_FE7.c:2039:     UnitFinalizeMovement(gActiveUnit);
	ldr	r3, .L562+32	@ tmp185,
	bl	.L17		@
@ Data/FE6_FE7.c:2040:     ResetTextFont();
	ldr	r3, .L562+36	@ tmp186,
	bl	.L17		@
@ Data/FE6_FE7.c:2065:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L562+40	@ tmp187,
	bl	.L17		@
@ Data/FE6_FE7.c:2066:         return;
	b	.L553		@
.L560:
@ Data/FE6_FE7.c:2049:         gActionData.xMove = gBmSt.playerCursor.x;
	ldr	r3, .L562+8	@ tmp153,
	movs	r1, #20	@ tmp206,
	ldrsh	r2, [r3, r1]	@ _2, tmp153, tmp206
@ Data/FE6_FE7.c:2049:         gActionData.xMove = gBmSt.playerCursor.x;
	ldr	r1, .L562+24	@ tmp154,
	strb	r2, [r1, #14]	@ _2, gActionData.xMove
@ Data/FE6_FE7.c:2050:         gActionData.yMove = gBmSt.playerCursor.y;
	movs	r0, #22	@ tmp207,
	ldrsh	r3, [r3, r0]	@ _4, tmp153, tmp207
@ Data/FE6_FE7.c:2050:         gActionData.yMove = gBmSt.playerCursor.y;
	strb	r3, [r1, #15]	@ _4, gActionData.yMove
@ Data/FE6_FE7.c:2051:         gActiveUnitMoveOrigin.x = gBmSt.playerCursor.x;
	ldr	r1, .L562+20	@ tmp159,
	strh	r2, [r1]	@ _2, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:2052:         gActiveUnitMoveOrigin.y = gBmSt.playerCursor.y;
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
@ Data/FE6_FE7.c:1998:     if (y < 0)
	movs	r2, r0	@ tmp123, x
@ Data/FE6_FE7.c:1993: {
	movs	r3, r0	@ x, tmp141
	push	{r4, r5, lr}	@
@ Data/FE6_FE7.c:1996:         return false;
	movs	r0, #0	@ <retval>,
@ Data/FE6_FE7.c:1998:     if (y < 0)
	orrs	r2, r1	@ tmp123, y
	bmi	.L564		@,
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	ldr	r2, .L570	@ tmp124,
	movs	r5, #0	@ tmp149,
	ldrsh	r4, [r2, r5]	@ gBmMapSize, tmp124, tmp149
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	cmp	r3, r4	@ x, gBmMapSize
	bge	.L564		@,
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	movs	r3, #2	@ tmp127,
	ldrsh	r3, [r2, r3]	@ tmp127, tmp124, tmp127
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	adds	r0, r0, #1	@ tmp128,
	cmp	r1, r3	@ y, tmp127
	bge	.L569		@,
.L564:
@ Data/FE6_FE7.c:2011: }
	@ sp needed	@
	pop	{r4, r5}
	pop	{r1}
	bx	r1
.L569:
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
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
@ Data/FE6_FE7.c:1998:     if (y < 0)
	movs	r4, r1	@ tmp123, x
@ Data/FE6_FE7.c:2016:         return 0;
	movs	r3, #0	@ <retval>,
@ Data/FE6_FE7.c:1998:     if (y < 0)
	orrs	r4, r2	@ tmp123, y
	bmi	.L573		@,
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	ldr	r4, .L577	@ tmp124,
	movs	r6, #0	@ tmp137,
	ldrsh	r5, [r4, r6]	@ gBmMapSize, tmp124, tmp137
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	cmp	r1, r5	@ x, gBmMapSize
	bge	.L573		@,
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	movs	r5, #2	@ tmp138,
	ldrsh	r4, [r4, r5]	@ tmp127, tmp124, tmp138
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	cmp	r2, r4	@ y, tmp127
	bge	.L573		@,
@ Data/FE6_FE7.c:2018:     return EnsureCameraOntoPosition(proc, x, y);
	ldr	r3, .L577+4	@ tmp128,
	bl	.L17		@
	movs	r3, r0	@ <retval>, tmp135
.L573:
@ Data/FE6_FE7.c:2019: }
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
@ Data/FE6_FE7.c:1998:     if (y < 0)
	movs	r3, r0	@ tmp121, x
@ Data/FE6_FE7.c:2021: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:1998:     if (y < 0)
	orrs	r3, r1	@ tmp121, y
	bmi	.L579		@,
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	ldr	r3, .L581	@ tmp122,
	movs	r4, #0	@ tmp130,
	ldrsh	r2, [r3, r4]	@ gBmMapSize, tmp122, tmp130
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	cmp	r0, r2	@ x, gBmMapSize
	bge	.L579		@,
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	movs	r2, #2	@ tmp131,
	ldrsh	r3, [r3, r2]	@ tmp125, tmp122, tmp131
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	cmp	r1, r3	@ y, tmp125
	bge	.L579		@,
@ Data/FE6_FE7.c:2026:     SetCursorMapPosition(x, y);
	ldr	r3, .L581+4	@ tmp126,
	bl	.L17		@
.L579:
@ Data/FE6_FE7.c:2027: }
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
@ Data/FE6_FE7.c:2031:     FixCursorOverflow();
	bl	FixCursorOverflow		@
@ Data/FE6_FE7.c:2033: }
	@ sp needed	@
@ Data/FE6_FE7.c:2032:     HandlePlayerCursorMovement();
	ldr	r3, .L584	@ tmp114,
	bl	.L17		@
@ Data/FE6_FE7.c:2033: }
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
@ Data/FE6_FE7.c:2077:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L587	@ tmp119,
@ Data/FE6_FE7.c:2080: }
	@ sp needed	@
@ Data/FE6_FE7.c:2077:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L587+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2078:     Proc_Goto(proc, PickupUnitLabel);
	movs	r1, #4	@,
	ldr	r3, .L587+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2080: }
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
@ Data/FE6_FE7.c:2948:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r3, .L594	@ tmp131,
	movs	r1, #11	@ tmp132,
	ldr	r2, [r3]	@ gActiveUnit.87_9, gActiveUnit
	movs	r3, #192	@ tmp133,
@ Data/FE6_FE7.c:2082: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2948:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldrsb	r1, [r2, r1]	@ tmp132,
	ands	r3, r1	@ tmp134, tmp132
@ Data/FE6_FE7.c:2948:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r1, .L594+4	@ tmp135,
	ldrb	r1, [r1, #15]	@ tmp136,
@ Data/FE6_FE7.c:2948:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	cmp	r3, r1	@ tmp134, tmp136
	bne	.L593		@,
@ Data/FE6_FE7.c:2953:     int promoted = UNIT_CATTRIBUTES(gActiveUnit) & CA_PROMOTED;
	ldr	r3, [r2]	@ gActiveUnit.87_9->pCharacterData, gActiveUnit.87_9->pCharacterData
	ldr	r1, [r2, #4]	@ _17, gActiveUnit.87_9->pClassData
	ldr	r3, [r3, #40]	@ _15->attributes, _15->attributes
	ldr	r2, [r1, #40]	@ _17->attributes, _17->attributes
	orrs	r3, r2	@ tmp138, _17->attributes
@ Data/FE6_FE7.c:2954:     if (promoted)
	lsls	r3, r3, #23	@ tmp152, tmp138,
	bmi	.L593		@,
@ Data/FE6_FE7.c:2959:     if (!promotionClass)
	ldrb	r3, [r1, #5]	@ tmp143,
	cmp	r3, #0	@ tmp143,
	beq	.L593		@,
@ Data/FE6_FE7.c:2089:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L594+8	@ tmp145,
	ldr	r0, .L594+12	@ tmp144,
	bl	.L17		@
@ Data/FE6_FE7.c:2090:     proc->actionID = ActionID_Promo;
	movs	r3, #47	@ tmp146,
	movs	r2, #1	@ tmp147,
@ Data/FE6_FE7.c:2091:     Proc_Goto(proc, UnitActionLabel);
	movs	r1, #3	@,
@ Data/FE6_FE7.c:2090:     proc->actionID = ActionID_Promo;
	strb	r2, [r0, r3]	@ tmp147, proc_6->actionID
@ Data/FE6_FE7.c:2091:     Proc_Goto(proc, UnitActionLabel);
	ldr	r3, .L594+16	@ tmp149,
	bl	.L17		@
@ Data/FE6_FE7.c:2092:     return MENU_ACT_SKIPCURSOR | MENU_ACT_END | MENU_ACT_SND6A | MENU_ACT_CLEAR;
	movs	r0, #23	@ <retval>,
	b	.L590		@
.L593:
@ Data/FE6_FE7.c:2086:         return MENU_ACT_SKIPCURSOR | MENU_ACT_SND6B;
	movs	r0, #9	@ <retval>,
.L590:
@ Data/FE6_FE7.c:2093: }
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
@ Data/FE6_FE7.c:2098:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L597	@ tmp119,
@ Data/FE6_FE7.c:2102: }
	@ sp needed	@
@ Data/FE6_FE7.c:2098:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L597+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2099:     proc->actionID = ActionID_Arena;
	movs	r3, #47	@ tmp120,
	movs	r2, #2	@ tmp121,
@ Data/FE6_FE7.c:2100:     Proc_Goto(proc, UnitActionLabel); // 0xb7
	movs	r1, #3	@,
@ Data/FE6_FE7.c:2099:     proc->actionID = ActionID_Arena;
	strb	r2, [r0, r3]	@ tmp121, proc_3->actionID
@ Data/FE6_FE7.c:2100:     Proc_Goto(proc, UnitActionLabel); // 0xb7
	ldr	r3, .L597+8	@ tmp123,
	bl	.L17		@
@ Data/FE6_FE7.c:2102: }
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
@ Data/FE6_FE7.c:2109:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L600	@ tmp120,
@ Data/FE6_FE7.c:2113: }
	@ sp needed	@
@ Data/FE6_FE7.c:2109:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L600+4	@ tmp119,
	bl	.L17		@
@ Data/FE6_FE7.c:2110:     Proc_Goto(proc, EndLabel);
	movs	r1, #99	@,
	ldr	r3, .L600+8	@ tmp121,
	bl	.L17		@
@ Data/FE6_FE7.c:2111:     StartBmSupply(gActiveUnit, NULL);
	ldr	r3, .L600+12	@ tmp122,
	movs	r1, #0	@,
	ldr	r0, [r3]	@ gActiveUnit, gActiveUnit
	ldr	r3, .L600+16	@ tmp124,
	bl	.L17		@
@ Data/FE6_FE7.c:2113: }
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
@ Data/FE6_FE7.c:2118:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L603	@ tmp119,
@ Data/FE6_FE7.c:2122: }
	@ sp needed	@
@ Data/FE6_FE7.c:2118:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L603+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2119:     proc->actionID = ActionID_Levelup;
	movs	r3, #47	@ tmp120,
	movs	r2, #3	@ tmp121,
@ Data/FE6_FE7.c:2120:     Proc_Goto(proc, UnitActionLabel); // 0xb7
	movs	r1, #3	@,
@ Data/FE6_FE7.c:2119:     proc->actionID = ActionID_Levelup;
	strb	r2, [r0, r3]	@ tmp121, proc_3->actionID
@ Data/FE6_FE7.c:2120:     Proc_Goto(proc, UnitActionLabel); // 0xb7
	ldr	r3, .L603+8	@ tmp123,
	bl	.L17		@
@ Data/FE6_FE7.c:2122: }
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
@ Data/FE6_FE7.c:2126:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L606	@ tmp119,
@ Data/FE6_FE7.c:2129: }
	@ sp needed	@
@ Data/FE6_FE7.c:2126:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L606+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2127:     Proc_Goto(proc, EditStatsLabel);
	movs	r1, #9	@,
	ldr	r3, .L606+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2129: }
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
@ Data/FE6_FE7.c:2133:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L609	@ tmp119,
@ Data/FE6_FE7.c:2136: }
	@ sp needed	@
@ Data/FE6_FE7.c:2133:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L609+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2134:     Proc_Goto(proc, EditItemsLabel);
	movs	r1, #10	@,
	ldr	r3, .L609+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2136: }
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
@ Data/FE6_FE7.c:2140:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L612	@ tmp119,
@ Data/FE6_FE7.c:2143: }
	@ sp needed	@
@ Data/FE6_FE7.c:2140:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L612+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2141:     Proc_Goto(proc, EditMiscLabel);
	movs	r1, #11	@,
	ldr	r3, .L612+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2143: }
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
@ Data/FE6_FE7.c:2147:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L615	@ tmp119,
@ Data/FE6_FE7.c:2150: }
	@ sp needed	@
@ Data/FE6_FE7.c:2147:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L615+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2148:     Proc_Goto(proc, StateLabel);
	movs	r1, #14	@,
	ldr	r3, .L615+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2150: }
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
@ Data/FE6_FE7.c:2154:     if (menuItem->availability == greyed)
	movs	r3, #61	@ tmp148,
	mov	r9, r2	@ _3, _3
@ Data/FE6_FE7.c:2153: {
	push	{r7, lr}	@
@ Data/FE6_FE7.c:2154:     if (menuItem->availability == greyed)
	ldrb	r3, [r1, r3]	@ tmp149,
@ Data/FE6_FE7.c:2153: {
	movs	r6, r1	@ menuItem, tmp174
	add	r9, r9, r1	@ _3, menuItem
@ Data/FE6_FE7.c:2154:     if (menuItem->availability == greyed)
	cmp	r3, #2	@ tmp149,
	beq	.L630		@,
.L618:
@ Data/FE6_FE7.c:2158:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	ldr	r3, .L632	@ tmp154,
	ldr	r0, .L632+4	@ tmp153,
	bl	.L17		@
@ Data/FE6_FE7.c:2160:     Text_DrawString(&menuItem->text, GetDebuggerMenuText(procIdler, menuItem->itemNumber));
	movs	r3, #60	@ tmp155,
@ Data/FE6_FE7.c:2160:     Text_DrawString(&menuItem->text, GetDebuggerMenuText(procIdler, menuItem->itemNumber));
	ldrsb	r3, [r6, r3]	@ _5,
	mov	r8, r3	@ _5, _5
@ Data/FE6_FE7.c:1960:     index += CountDebuggerMenuItems(procIdler->page);
	movs	r3, #52	@ tmp156,
@ Data/FE6_FE7.c:1960:     index += CountDebuggerMenuItems(procIdler->page);
	ldrb	r7, [r0, r3]	@ _62,
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	cmp	r7, #0	@ _62,
	beq	.L620		@,
@ Data/FE6_FE7.c:1942:     int result = 0;
	movs	r2, #0	@ result,
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	movs	r4, #0	@ i,
	ldr	r5, .L632+8	@ ivtmp.778,
.L623:
	movs	r1, r2	@ _51, result
	ldr	r3, [r5]	@ ivtmp.775, MEM[(const struct MenuItemDef * *)_41]
	adds	r1, r1, #255	@ _51,
	b	.L622		@
.L631:
@ Data/FE6_FE7.c:1951:             result++;
	adds	r2, r2, #1	@ result,
@ Data/FE6_FE7.c:1945:         for (int c = 0; c < 255; ++c)
	adds	r3, r3, #36	@ ivtmp.775,
	cmp	r2, r1	@ result, _51
	beq	.L621		@,
.L622:
@ Data/FE6_FE7.c:1947:             if (!ggDebuggerMenuItems[i][c].name)
	ldr	r0, [r3]	@ MEM[(const char * *)_54], MEM[(const char * *)_54]
	cmp	r0, #0	@ MEM[(const char * *)_54],
	bne	.L631		@,
.L621:
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	adds	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:1943:     for (int i = 0; i < page; ++i)
	adds	r5, r5, #4	@ ivtmp.778,
	cmp	r7, r4	@ _62, i
	bgt	.L623		@,
@ Data/FE6_FE7.c:1954:     return result + page; // avoid the word 0 terminator offset
	adds	r7, r7, r2	@ _62, _62, result
.L620:
@ Data/FE6_FE7.c:1961:     return gDebuggerMenuText[index * 2];
	movs	r3, r7	@ _62, _62
@ Data/FE6_FE7.c:2163: }
	@ sp needed	@
@ Data/FE6_FE7.c:1961:     return gDebuggerMenuText[index * 2];
	ldr	r2, .L632+12	@ tmp158,
@ Data/FE6_FE7.c:1961:     return gDebuggerMenuText[index * 2];
	add	r3, r3, r8	@ _62, _5
@ Data/FE6_FE7.c:1961:     return gDebuggerMenuText[index * 2];
	lsls	r3, r3, #3	@ tmp161, tmp159,
@ Data/FE6_FE7.c:2160:     Text_DrawString(&menuItem->text, GetDebuggerMenuText(procIdler, menuItem->itemNumber));
	ldr	r1, [r3, r2]	@ gDebuggerMenuText[_28], gDebuggerMenuText[_28]
	mov	r0, r9	@, _3
	ldr	r3, .L632+16	@ tmp163,
	bl	.L17		@
@ Data/FE6_FE7.c:2161:     PutText(&menuItem->text, BG_GetMapBuffer_New(0) + TILEMAP_INDEX(menuItem->xTile, menuItem->yTile));
	movs	r3, #44	@ tmp178,
	ldrsh	r1, [r6, r3]	@ tmp164, menuItem, tmp178
	movs	r2, #42	@ tmp179,
	ldrsh	r3, [r6, r2]	@ tmp166, menuItem, tmp179
	lsls	r1, r1, #5	@ tmp165, tmp164,
	adds	r1, r1, r3	@ tmp167, tmp165, tmp166
@ Data/FE6_FE7.c:2161:     PutText(&menuItem->text, BG_GetMapBuffer_New(0) + TILEMAP_INDEX(menuItem->xTile, menuItem->yTile));
	ldr	r3, .L632+20	@ tmp170,
@ Data/FE6_FE7.c:2161:     PutText(&menuItem->text, BG_GetMapBuffer_New(0) + TILEMAP_INDEX(menuItem->xTile, menuItem->yTile));
	lsls	r1, r1, #1	@ tmp168, tmp167,
@ Data/FE6_FE7.c:2161:     PutText(&menuItem->text, BG_GetMapBuffer_New(0) + TILEMAP_INDEX(menuItem->xTile, menuItem->yTile));
	mov	r0, r9	@, _3
	adds	r1, r1, r3	@ tmp169, tmp168, tmp170
	ldr	r3, .L632+24	@ tmp171,
	bl	.L17		@
@ Data/FE6_FE7.c:2163: }
	movs	r0, #0	@,
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L630:
@ Data/FE6_FE7.c:2156:         Text_SetColor(&menuItem->text, 1);
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
@ Data/FE6_FE7.c:2192: {
	movs	r4, r0	@ unit, tmp165
@ Data/FE6_FE7.c:2217: }
	@ sp needed	@
@ Data/FE6_FE7.c:2193:     gActiveUnit = unit;
	ldr	r3, .L635	@ tmp125,
	str	r0, [r3]	@ unit, gActiveUnit
@ Data/FE6_FE7.c:2194:     gActiveUnitId = unit->index;
	ldr	r3, .L635+4	@ tmp126,
	ldrb	r2, [r0, #11]	@ tmp127,
@ Data/FE6_FE7.c:2195:     InitBattleUnit(&gBattleActor, unit);
	movs	r1, r4	@, unit
@ Data/FE6_FE7.c:2194:     gActiveUnitId = unit->index;
	strb	r2, [r3]	@ tmp127, gActiveUnitId
@ Data/FE6_FE7.c:2195:     InitBattleUnit(&gBattleActor, unit);
	ldr	r0, .L635+8	@ tmp129,
	ldr	r3, .L635+12	@ tmp130,
	bl	.L17		@
@ Data/FE6_FE7.c:2196:     ClearUnit(&gBattleTarget.unit); // so a previous unit isn't affected
	ldr	r5, .L635+16	@ tmp131,
	ldr	r3, .L635+20	@ tmp132,
	movs	r0, r5	@, tmp131
	bl	.L17		@
@ Data/FE6_FE7.c:2197:     gBattleTarget.unit.index = 0;   // (fixed bug of promote -> levelup with another char)
	movs	r2, #0	@ tmp134,
@ Data/FE6_FE7.c:2199:     gActiveUnitMoveOrigin.x = unit->xPos;
	movs	r0, #16	@ _3,
@ Data/FE6_FE7.c:2200:     gActiveUnitMoveOrigin.y = unit->yPos;
	movs	r1, #17	@ _5,
@ Data/FE6_FE7.c:2197:     gBattleTarget.unit.index = 0;   // (fixed bug of promote -> levelup with another char)
	strb	r2, [r5, #11]	@ tmp134, gBattleTarget.unit.index
@ Data/FE6_FE7.c:2199:     gActiveUnitMoveOrigin.x = unit->xPos;
	ldr	r3, .L635+24	@ tmp136,
@ Data/FE6_FE7.c:2199:     gActiveUnitMoveOrigin.x = unit->xPos;
	ldrsb	r0, [r4, r0]	@ _3,* _3
@ Data/FE6_FE7.c:2199:     gActiveUnitMoveOrigin.x = unit->xPos;
	strh	r0, [r3]	@ _3, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:2200:     gActiveUnitMoveOrigin.y = unit->yPos;
	ldrsb	r1, [r4, r1]	@ _5,* _5
@ Data/FE6_FE7.c:2200:     gActiveUnitMoveOrigin.y = unit->yPos;
	strh	r1, [r3, #2]	@ _5, gActiveUnitMoveOrigin.y
@ Data/FE6_FE7.c:2201:     gActionData.xMove = unit->xPos;
	ldr	r3, .L635+28	@ tmp140,
	strb	r0, [r3, #14]	@ _3, gActionData.xMove
@ Data/FE6_FE7.c:2202:     gActionData.yMove = unit->yPos;
	strb	r1, [r3, #15]	@ _5, gActionData.yMove
@ Data/FE6_FE7.c:2204:     gActionData.subjectIndex = unit->index;
	ldrb	r1, [r4, #11]	@ tmp145,
@ Data/FE6_FE7.c:2210:     gBmSt.taken_action = 0;
	movs	r0, #0	@ tmp152,
@ Data/FE6_FE7.c:2204:     gActionData.subjectIndex = unit->index;
	strb	r1, [r3, #12]	@ tmp145, gActionData.subjectIndex
@ Data/FE6_FE7.c:2210:     gBmSt.taken_action = 0;
	movs	r1, #61	@ tmp157,
@ Data/FE6_FE7.c:2205:     gActionData.targetIndex = 0;
	strb	r2, [r3, #13]	@ tmp134, gActionData.targetIndex
@ Data/FE6_FE7.c:2208:     gActionData.moveCount = 0;
	strh	r2, [r3, #16]	@ tmp134, MEM <unsigned short> [(unsigned char *)&gActionData + 16B]
@ Data/FE6_FE7.c:2206:     gActionData.itemSlotIndex = -1;
	adds	r2, r2, #255	@ tmp154,
	strb	r2, [r3, #18]	@ tmp154, gActionData.itemSlotIndex
@ Data/FE6_FE7.c:2210:     gBmSt.taken_action = 0;
	ldr	r3, .L635+32	@ tmp156,
	strb	r0, [r3, r1]	@ tmp152, gBmSt.taken_action
@ Data/FE6_FE7.c:2211:     gBmSt.unk3F = 0xFF;
	adds	r1, r1, #2	@ tmp161,
	strb	r2, [r3, r1]	@ tmp154, gBmSt.unk3F
@ Data/FE6_FE7.c:2213:     sub_802C334(); // zeroes out a few bits of unknown ram
	ldr	r3, .L635+36	@ tmp164,
	bl	.L17		@
@ Data/FE6_FE7.c:2217: }
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
@ Data/FE6_FE7.c:1370:     unit->pCharacterData = GetCharacterData(proc->tmp[0]);
	movs	r3, #64	@ tmp161,
@ Data/FE6_FE7.c:1367: {
	push	{r7, lr}	@
@ Data/FE6_FE7.c:1369:     struct Unit * unit = proc->unit;
	ldr	r6, [r0, #60]	@ unit, proc_42(D)->unit
@ Data/FE6_FE7.c:1367: {
	movs	r7, r0	@ proc, tmp290
@ Data/FE6_FE7.c:1370:     unit->pCharacterData = GetCharacterData(proc->tmp[0]);
	ldrsh	r0, [r0, r3]	@ tmp162,
	ldr	r3, .L660	@ tmp163,
	bl	.L17		@
@ Data/FE6_FE7.c:1371:     AdjustWEXPForClass(unit, proc->tmp[1]);
	movs	r3, #66	@ tmp164,
@ Data/FE6_FE7.c:1370:     unit->pCharacterData = GetCharacterData(proc->tmp[0]);
	str	r0, [r6]	@ tmp291, unit_43->pCharacterData
@ Data/FE6_FE7.c:1371:     AdjustWEXPForClass(unit, proc->tmp[1]);
	movs	r0, r6	@, unit
	ldrsh	r1, [r7, r3]	@ tmp165,
	bl	AdjustWEXPForClass		@
@ Data/FE6_FE7.c:1372:     unit->level = proc->tmp[2];
	movs	r3, #68	@ tmp166,
@ Data/FE6_FE7.c:1372:     unit->level = proc->tmp[2];
	ldrh	r3, [r7, r3]	@ tmp169,
	strb	r3, [r6, #8]	@ tmp169, unit_43->level
@ Data/FE6_FE7.c:1373:     unit->exp = proc->tmp[3] & 0xFF;
	movs	r3, #70	@ tmp170,
@ Data/FE6_FE7.c:1373:     unit->exp = proc->tmp[3] & 0xFF;
	ldrh	r3, [r7, r3]	@ tmp173,
	strb	r3, [r6, #9]	@ tmp173, unit_43->exp
@ Data/FE6_FE7.c:1374:     unit->conBonus = proc->tmp[4];
	movs	r3, #72	@ tmp174,
@ Data/FE6_FE7.c:1374:     unit->conBonus = proc->tmp[4];
	ldrh	r3, [r7, r3]	@ tmp177,
	strb	r3, [r6, #26]	@ tmp177, unit_43->conBonus
@ Data/FE6_FE7.c:1375:     unit->movBonus = proc->tmp[5];
	movs	r3, #74	@ tmp178,
	ldrsb	r3, [r7, r3]	@ _13,
@ Data/FE6_FE7.c:1376:     if (UNIT_MOV(unit) > 15)
	ldr	r2, [r6, #4]	@ unit_43->pClassData, unit_43->pClassData
@ Data/FE6_FE7.c:1375:     unit->movBonus = proc->tmp[5];
	strb	r3, [r6, #29]	@ _13, unit_43->movBonus
@ Data/FE6_FE7.c:1376:     if (UNIT_MOV(unit) > 15)
	ldrb	r2, [r2, #18]	@ _16,
	lsls	r2, r2, #24	@ _16, _16,
	asrs	r2, r2, #24	@ _16, _16,
	adds	r3, r3, r2	@ tmp185, _13, _16
@ Data/FE6_FE7.c:1376:     if (UNIT_MOV(unit) > 15)
	cmp	r3, #15	@ tmp185,
	ble	.L638		@,
@ Data/FE6_FE7.c:1378:         unit->movBonus = 15 - UNIT_MOV_BASE(unit);
	movs	r3, #15	@ tmp186,
	subs	r3, r3, r2	@ tmp189, tmp186, _16
@ Data/FE6_FE7.c:1378:         unit->movBonus = 15 - UNIT_MOV_BASE(unit);
	strb	r3, [r6, #29]	@ tmp189, unit_43->movBonus
.L638:
@ Data/FE6_FE7.c:1381:     unit->statusDuration = proc->tmp[8];
	movs	r3, #80	@ tmp192,
@ Data/FE6_FE7.c:1380:     unit->statusIndex = proc->tmp[6] & 0xF;
	movs	r2, #15	@ tmp199,
	movs	r4, #48	@ tmp191,
	ldrh	r1, [r7, r3]	@ tmp195,
	subs	r3, r3, #4	@ tmp197,
	ldrh	r3, [r7, r3]	@ tmp201,
	lsls	r1, r1, #4	@ tmp196, tmp195,
	ands	r3, r2	@ tmp202, tmp199
	orrs	r3, r1	@ tmp206, tmp196
@ Data/FE6_FE7.c:1382:     if (unit->statusIndex && !unit->statusDuration)
	lsls	r1, r3, #24	@ _26, tmp206,
@ Data/FE6_FE7.c:1380:     unit->statusIndex = proc->tmp[6] & 0xF;
	strb	r3, [r6, r4]	@ tmp206, MEM <unsigned char> [(struct Unit *)unit_43 + 48B]
@ Data/FE6_FE7.c:1382:     if (unit->statusIndex && !unit->statusDuration)
	ands	r3, r2	@ tmp211, tmp199
	movs	r0, r3	@ _27, tmp211
	lsrs	r1, r1, #24	@ _26, _26,
@ Data/FE6_FE7.c:1382:     if (unit->statusIndex && !unit->statusDuration)
	cmp	r2, r1	@ tmp199, _26
	bcc	.L639		@,
	cmp	r3, #0	@ _27,
	bne	.L657		@,
.L639:
@ Data/FE6_FE7.c:1388:         unit->statusDuration = 0;
	movs	r2, #0	@ cstore_70,
@ Data/FE6_FE7.c:1386:     if (!unit->statusIndex)
	cmp	r0, #0	@ _27,
	beq	.L640		@,
@ Data/FE6_FE7.c:1388:         unit->statusDuration = 0;
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
@ Data/FE6_FE7.c:1390:     if (proc->tmp[7] != (unit->index & 0xC0))
	movs	r3, #78	@ tmp271,
@ Data/FE6_FE7.c:1390:     if (proc->tmp[7] != (unit->index & 0xC0))
	movs	r2, #11	@ tmp272,
@ Data/FE6_FE7.c:1390:     if (proc->tmp[7] != (unit->index & 0xC0))
	ldrsh	r4, [r7, r3]	@ _31,
@ Data/FE6_FE7.c:1390:     if (proc->tmp[7] != (unit->index & 0xC0))
	movs	r3, #192	@ tmp273,
@ Data/FE6_FE7.c:1390:     if (proc->tmp[7] != (unit->index & 0xC0))
	ldrsb	r2, [r6, r2]	@ tmp272,
@ Data/FE6_FE7.c:1390:     if (proc->tmp[7] != (unit->index & 0xC0))
	ands	r3, r2	@ tmp274, tmp272
@ Data/FE6_FE7.c:1390:     if (proc->tmp[7] != (unit->index & 0xC0))
	cmp	r4, r3	@ _31, tmp274
	bne	.L658		@,
.L637:
@ Data/FE6_FE7.c:1407: }
	@ sp needed	@
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L657:
@ Data/FE6_FE7.c:1384:         unit->statusDuration = 5;
	movs	r1, #80	@ tmp237,
	orrs	r3, r1	@ tmp239, tmp237
@ Data/FE6_FE7.c:1386:     if (!unit->statusIndex)
	ands	r2, r3	@ tmp199, tmp239
	movs	r0, r2	@ _27, tmp199
@ Data/FE6_FE7.c:1384:         unit->statusDuration = 5;
	strb	r3, [r6, r4]	@ tmp239, unit_43->statusDuration
	b	.L639		@
.L658:
@ Data/FE6_FE7.c:1346:     int i = faction, last = faction + 0x40;
	movs	r3, #64	@ last,
	mov	r9, r3	@ last, last
@ Data/FE6_FE7.c:1392:         struct Unit * newUnit = GetFreeUnitByFaction(proc->tmp[7] << 6);
	lsls	r4, r4, #6	@ i, _31,
@ Data/FE6_FE7.c:1346:     int i = faction, last = faction + 0x40;
	add	r9, r9, r4	@ last, i
@ Data/FE6_FE7.c:1347:     if (!i)
	cmp	r4, #0	@ i,
	bne	.L643		@,
@ Data/FE6_FE7.c:1348:         i = 1;
	adds	r4, r4, #1	@ i,
.L643:
	ldr	r3, .L660+4	@ tmp285,
	mov	r8, r3	@ tmp285, tmp285
	b	.L645		@
.L659:
@ Data/FE6_FE7.c:1350:     for (; i < last; ++i)
	adds	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:1350:     for (; i < last; ++i)
	cmp	r9, r4	@ last, i
	beq	.L637		@,
.L645:
@ Data/FE6_FE7.c:1352:         struct Unit * unit = GetUnit(i);
	movs	r0, r4	@, i
	bl	.L193		@
@ Data/FE6_FE7.c:1354:         if (unit->pCharacterData == NULL)
	ldr	r3, [r0]	@ unit_65->pCharacterData, unit_65->pCharacterData
@ Data/FE6_FE7.c:1352:         struct Unit * unit = GetUnit(i);
	movs	r5, r0	@ unit, tmp292
@ Data/FE6_FE7.c:1354:         if (unit->pCharacterData == NULL)
	cmp	r3, #0	@ unit_65->pCharacterData,
	bne	.L659		@,
@ Data/FE6_FE7.c:1397:         int deploymentID = newUnit->index;
	movs	r4, #11	@ _36,
@ Data/FE6_FE7.c:1398:         memcpy((void *)newUnit, (void *)unit, sizeof(struct Unit));
	movs	r2, #72	@,
	movs	r1, r6	@, unit
@ Data/FE6_FE7.c:1397:         int deploymentID = newUnit->index;
	ldrsb	r4, [r0, r4]	@ _36,* _36
@ Data/FE6_FE7.c:1398:         memcpy((void *)newUnit, (void *)unit, sizeof(struct Unit));
	ldr	r3, .L660+8	@ tmp280,
	bl	.L17		@
@ Data/FE6_FE7.c:1399:         ClearUnit(unit);
	movs	r0, r6	@, unit
	ldr	r3, .L660+12	@ tmp283,
	bl	.L17		@
@ Data/FE6_FE7.c:1403:         UnitBeginActionInit(newUnit);
	movs	r0, r5	@, unit
@ Data/FE6_FE7.c:1401:         newUnit->index = deploymentID; // copy unit into a free slot in unit struct ram
	strb	r4, [r5, #11]	@ _36, unit_65->index
@ Data/FE6_FE7.c:1403:         UnitBeginActionInit(newUnit);
	bl	UnitBeginActionInit		@
@ Data/FE6_FE7.c:1404:         proc->unit = newUnit;
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
@ Data/FE6_FE7.c:1788:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L748	@ tmp207,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r5, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:1785: {
	movs	r4, r0	@ proc, tmp392
@ Data/FE6_FE7.c:1789:     if (keys & B_BUTTON)
	lsls	r3, r5, #30	@ tmp394, keys,
	bpl	.LCB4685	@
	b	.L739	@long jump	@
.LCB4685:
.L663:
@ Data/FE6_FE7.c:1794:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp219,
	tst	r3, r5	@ tmp219, keys
	beq	.LCB4692	@
	b	.L740	@long jump	@
.LCB4692:
.L664:
	movs	r2, #16	@ tmp228,
	ands	r2, r5	@ tmp228, keys
	mov	r9, r2	@ _186, tmp228
@ Data/FE6_FE7.c:1802:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r2, #48	@ tmp230,
@ Data/FE6_FE7.c:1800:     if (proc->editing)
	movs	r6, #46	@ tmp224,
@ Data/FE6_FE7.c:1802:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r2]	@ tmp231,
	mov	r10, r2	@ tmp230, tmp230
@ Data/FE6_FE7.c:1800:     if (proc->editing)
	ldrsb	r3, [r4, r6]	@ _2,
	adds	r2, r2, #16	@ tmp236,
@ Data/FE6_FE7.c:1802:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r1, #1	@ tmp232,
	ands	r2, r5	@ tmp236, keys
	mov	r8, r2	@ _191, tmp236
@ Data/FE6_FE7.c:1802:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ _190, tmp232,
@ Data/FE6_FE7.c:1800:     if (proc->editing)
	cmp	r3, #0	@ _2,
	bne	.LCB4712	@
	b	.L665	@long jump	@
.LCB4712:
@ Data/FE6_FE7.c:1802:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r3, #49	@ tmp239,
	ldrsb	r3, [r4, r3]	@ tmp240,
@ Data/FE6_FE7.c:1802:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r7, .L748+4	@ tmp238,
	lsls	r3, r3, #3	@ tmp241, tmp240,
	adds	r3, r7, r3	@ tmp242, tmp238, tmp241
@ Data/FE6_FE7.c:1802:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r0, [r3, #120]	@ CursorLocationTable[_4].x, CursorLocationTable[_4].x
	bl	DisplayVertUiHand		@
@ Data/FE6_FE7.c:1803:         int max = GetMiscMax(proc->id);
	mov	r3, r10	@ tmp230, tmp230
	ldrsb	r0, [r4, r3]	@ tmp246,
	bl	GetMiscMax		@
@ Data/FE6_FE7.c:1602:     switch (id)
	movs	r1, #0	@ tmp251,
@ Data/FE6_FE7.c:1804:         int min = GetMiscMin(proc->id);
	mov	r3, r10	@ tmp230, tmp230
@ Data/FE6_FE7.c:1803:         int max = GetMiscMax(proc->id);
	movs	r6, r0	@ max, tmp393
@ Data/FE6_FE7.c:1602:     switch (id)
	movs	r0, r1	@ tmp249, tmp251
@ Data/FE6_FE7.c:1804:         int min = GetMiscMin(proc->id);
	ldrsb	r2, [r4, r3]	@ _13,
@ Data/FE6_FE7.c:1602:     switch (id)
	subs	r3, r3, #46	@ tmp250,
	cmp	r3, r2	@ tmp250, _13
	adcs	r0, r0, r1	@ tmp249, tmp249, tmp251
	mov	r10, r0	@ _157, tmp249
@ Data/FE6_FE7.c:1805:         int type = (proc->id < 2);
	movs	r0, #1	@ tmp258,
	lsrs	r3, r2, #31	@ tmp259, _13,
	cmp	r0, r2	@ tmp258, _13
	adcs	r3, r3, r1	@ type, tmp259, tmp251
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	lsls	r3, r3, #2	@ tmp261, type,
	adds	r7, r7, r3	@ tmp262, tmp238, tmp261
	ldr	r7, [r7, #112]	@ _52, pDigitTable[type_128]
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	ldr	r3, [r7, #4]	@ MEM[(const int *)_52 + 4B], MEM[(const int *)_52 + 4B]
	cmp	r6, r3	@ max, MEM[(const int *)_52 + 4B]
	bgt	.LCB4740	@
	b	.L697	@long jump	@
.LCB4740:
@ Data/FE6_FE7.c:546:     int result = 1;
	movs	r3, #1	@ result,
.L667:
@ Data/FE6_FE7.c:549:         result++;
	adds	r3, r3, #1	@ result,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	lsls	r2, r3, #2	@ tmp265, result,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	ldr	r2, [r7, r2]	@ MEM[(const int *)_52 + _131 * 1], MEM[(const int *)_52 + _131 * 1]
	cmp	r6, r2	@ max, MEM[(const int *)_52 + _131 * 1]
	bgt	.L667		@,
@ Data/FE6_FE7.c:551:     if (result > 9)
	mov	fp, r3	@ _178, result
	cmp	r3, #9	@ _178,
	ble	.L666		@,
	movs	r3, #9	@ _178,
	mov	fp, r3	@ _178, _178
.L666:
@ Data/FE6_FE7.c:1809:         if (keys & DPAD_RIGHT)
	mov	r3, r9	@ _186, _186
	cmp	r3, #0	@ _186,
	beq	.L669		@,
@ Data/FE6_FE7.c:1811:             if (proc->digit > 0)
	movs	r3, #49	@ tmp267,
	ldrsb	r3, [r4, r3]	@ _15,
@ Data/FE6_FE7.c:1811:             if (proc->digit > 0)
	cmp	r3, #0	@ _15,
	bgt	.LCB4762	@
	b	.L670	@long jump	@
.LCB4762:
@ Data/FE6_FE7.c:1813:                 proc->digit--;
	subs	r3, r3, #1	@ tmp271,
	lsls	r3, r3, #24	@ tmp272, tmp271,
	asrs	r3, r3, #24	@ _19, tmp272,
.L671:
	movs	r2, #49	@ tmp279,
@ Data/FE6_FE7.c:1820:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _19, proc_100(D)->digit
	bl	RedrawMiscMenu		@
.L669:
@ Data/FE6_FE7.c:1822:         if (keys & DPAD_LEFT)
	lsls	r3, r5, #26	@ tmp395, keys,
	bpl	.L672		@,
@ Data/FE6_FE7.c:1824:             if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp288,
	ldrsb	r2, [r4, r3]	@ _23,
@ Data/FE6_FE7.c:1824:             if (proc->digit < (max_digits - 1))
	mov	r3, fp	@ _178, _178
	subs	r3, r3, #1	@ _178,
@ Data/FE6_FE7.c:1824:             if (proc->digit < (max_digits - 1))
	cmp	r2, r3	@ _23, tmp289
	blt	.LCB4785	@
	b	.L673	@long jump	@
.LCB4785:
@ Data/FE6_FE7.c:1826:                 proc->digit++;
	adds	r2, r2, #1	@ tmp291,
	lsls	r3, r2, #24	@ tmp292, tmp291,
	asrs	r3, r3, #24	@ _29, tmp292,
.L674:
	movs	r2, #49	@ tmp296,
@ Data/FE6_FE7.c:1833:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _29, proc_100(D)->digit
	bl	RedrawMiscMenu		@
.L672:
@ Data/FE6_FE7.c:1836:         if (keys & DPAD_UP)
	mov	r3, r8	@ _191, _191
	cmp	r3, #0	@ _191,
	beq	.L675		@,
@ Data/FE6_FE7.c:1838:             if ((proc->tmp[proc->id]) == max)
	movs	r3, #48	@ tmp298,
	ldrsb	r2, [r4, r3]	@ tmp299,
	lsls	r2, r2, #1	@ tmp300, tmp299,
	adds	r2, r4, r2	@ _148, proc, tmp300
@ Data/FE6_FE7.c:1838:             if ((proc->tmp[proc->id]) == max)
	adds	r3, r3, #16	@ tmp301,
	ldrsh	r1, [r2, r3]	@ _32, MEM <s16> [(struct DebuggerProc *)_148 + 64B]
@ Data/FE6_FE7.c:1838:             if ((proc->tmp[proc->id]) == max)
	cmp	r1, r6	@ _32, max
	bne	.LCB4807	@
	b	.L741	@long jump	@
.LCB4807:
@ Data/FE6_FE7.c:1844:                 proc->tmp[proc->id] += pDigitTable[type][proc->digit];
	movs	r3, #49	@ tmp302,
	ldrsb	r3, [r4, r3]	@ tmp303,
@ Data/FE6_FE7.c:1844:                 proc->tmp[proc->id] += pDigitTable[type][proc->digit];
	lsls	r3, r3, #2	@ tmp304, tmp303,
@ Data/FE6_FE7.c:1844:                 proc->tmp[proc->id] += pDigitTable[type][proc->digit];
	ldr	r3, [r3, r7]	@ *_40, *_40
	adds	r3, r3, r1	@ tmp308, *_40, _32
	lsls	r3, r3, #16	@ _44, tmp308,
	asrs	r3, r3, #16	@ _44, _44,
@ Data/FE6_FE7.c:1845:                 if ((proc->tmp[proc->id]) > max)
	cmp	r3, r6	@ _44, max
	ble	.L677		@,
@ Data/FE6_FE7.c:1847:                     proc->tmp[proc->id] = max;
	lsls	r3, r6, #16	@ _44, max,
	asrs	r3, r3, #16	@ _44, _44,
.L677:
@ Data/FE6_FE7.c:1840:                 proc->tmp[proc->id] = min;
	movs	r1, #64	@ tmp309,
@ Data/FE6_FE7.c:1852:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:1840:                 proc->tmp[proc->id] = min;
	strh	r3, [r2, r1]	@ _44, MEM <s16> [(struct DebuggerProc *)_148 + 64B]
@ Data/FE6_FE7.c:1852:             RedrawMiscMenu(proc);
	bl	RedrawMiscMenu		@
.L675:
@ Data/FE6_FE7.c:1854:         if (keys & DPAD_DOWN)
	lsls	r5, r5, #24	@ tmp396, keys,
	bpl	.L662		@,
@ Data/FE6_FE7.c:1856:             if ((proc->tmp[proc->id]) == min)
	movs	r3, #48	@ tmp318,
	ldrsb	r2, [r4, r3]	@ tmp319,
	lsls	r2, r2, #1	@ tmp320, tmp319,
	adds	r2, r4, r2	@ _129, proc, tmp320
@ Data/FE6_FE7.c:1856:             if ((proc->tmp[proc->id]) == min)
	adds	r3, r3, #16	@ tmp321,
	ldrsh	r3, [r2, r3]	@ _50, MEM <s16> [(struct DebuggerProc *)_129 + 64B]
@ Data/FE6_FE7.c:1856:             if ((proc->tmp[proc->id]) == min)
	cmp	r3, r10	@ _50, _157
	bne	.LCB4840	@
	b	.L742	@long jump	@
.LCB4840:
@ Data/FE6_FE7.c:1862:                 val = (proc->tmp[proc->id]) - pDigitTable[type][proc->digit];
	movs	r1, #49	@ tmp322,
	ldrsb	r1, [r4, r1]	@ tmp323,
@ Data/FE6_FE7.c:1862:                 val = (proc->tmp[proc->id]) - pDigitTable[type][proc->digit];
	lsls	r1, r1, #2	@ tmp324, tmp323,
@ Data/FE6_FE7.c:1862:                 val = (proc->tmp[proc->id]) - pDigitTable[type][proc->digit];
	ldr	r1, [r1, r7]	@ *_56, *_56
	subs	r3, r3, r1	@ val, _50, *_56
@ Data/FE6_FE7.c:1863:                 if (val < min)
	cmp	r3, r10	@ val, _157
	blt	.LCB4847	@
	b	.L682	@long jump	@
.LCB4847:
@ Data/FE6_FE7.c:1865:                     proc->tmp[proc->id] = min;
	mov	r3, r10	@ _157, _157
	lsls	r3, r3, #16	@ _51, _157,
	asrs	r3, r3, #16	@ _51, _51,
.L681:
@ Data/FE6_FE7.c:1858:                 proc->tmp[proc->id] = max;
	movs	r1, #64	@ tmp326,
@ Data/FE6_FE7.c:1874:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:1858:                 proc->tmp[proc->id] = max;
	strh	r3, [r2, r1]	@ _51, MEM <s16> [(struct DebuggerProc *)_129 + 64B]
@ Data/FE6_FE7.c:1874:             RedrawMiscMenu(proc);
	bl	RedrawMiscMenu		@
	b	.L662		@
.L665:
@ Data/FE6_FE7.c:1879:         DisplayUiHand(CursorLocationTable[0].x - ((MiscNameWidth + 3) * 8), (Y_HAND + (proc->id * 2)) * 8);
	ldr	r3, .L748+8	@ tmp328,
	movs	r0, #76	@,
	bl	.L17		@
@ Data/FE6_FE7.c:1880:         if (proc->id == (NumberOfMisc - 1))
	mov	r3, r10	@ tmp230, tmp230
	ldrsb	r3, [r4, r3]	@ tmp330,
	cmp	r3, #7	@ tmp330,
	beq	.L743		@,
@ Data/FE6_FE7.c:1907:             if (keys & DPAD_RIGHT)
	mov	r3, r9	@ _186, _186
	cmp	r3, #0	@ _186,
	beq	.L689		@,
@ Data/FE6_FE7.c:1909:                 proc->digit = 1;
	movs	r3, #1	@ tmp342,
	movs	r2, #49	@ tmp341,
	strb	r3, [r4, r2]	@ tmp342, proc_100(D)->digit
@ Data/FE6_FE7.c:1910:                 proc->editing = true;
	strb	r3, [r4, r6]	@ tmp342, proc_100(D)->editing
.L689:
@ Data/FE6_FE7.c:1912:             if (keys & DPAD_LEFT)
	lsls	r3, r5, #26	@ tmp398, keys,
	bmi	.L744		@,
.L688:
@ Data/FE6_FE7.c:1918:         if (keys & DPAD_UP)
	mov	r3, r8	@ _191, _191
	cmp	r3, #0	@ _191,
	beq	.L691		@,
@ Data/FE6_FE7.c:1920:             proc->id--;
	movs	r3, #48	@ tmp360,
@ Data/FE6_FE7.c:1920:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp362,
	subs	r3, r3, #1	@ tmp363,
	lsls	r3, r3, #24	@ tmp364, tmp363,
	asrs	r2, r3, #24	@ _75, tmp364,
@ Data/FE6_FE7.c:1921:             if (proc->id < 0)
	cmp	r3, #0	@ tmp364,
	blt	.L745		@,
.L692:
	movs	r3, #48	@ tmp368,
@ Data/FE6_FE7.c:1925:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _75, MEM <struct DebuggerProc> [(void *)proc_100(D)].id
	bl	RedrawMiscMenu		@
.L691:
@ Data/FE6_FE7.c:1927:         if (keys & DPAD_DOWN)
	lsls	r5, r5, #24	@ tmp399, keys,
	bpl	.L662		@,
@ Data/FE6_FE7.c:1929:             proc->id++;
	movs	r1, #48	@ tmp377,
@ Data/FE6_FE7.c:1932:                 proc->id = 0;
	movs	r0, #7	@ tmp388,
	movs	r5, #0	@ tmp390,
@ Data/FE6_FE7.c:1929:             proc->id++;
	ldrb	r3, [r4, r1]	@ tmp379,
	adds	r3, r3, #1	@ tmp380,
	lsls	r3, r3, #24	@ tmp381, tmp380,
	asrs	r2, r3, #24	@ _80, tmp381,
@ Data/FE6_FE7.c:1932:                 proc->id = 0;
	lsrs	r3, r3, #31	@ tmp389, tmp381,
	cmp	r0, r2	@ tmp388, _80
	adcs	r3, r3, r5	@ tmp387, tmp389, tmp390
	rsbs	r3, r3, #0	@ tmp391, tmp387
	ands	r2, r3	@ _80, tmp391
@ Data/FE6_FE7.c:1935:             RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r1]	@ _80, MEM <struct DebuggerProc> [(void *)proc_100(D)].id
	bl	RedrawMiscMenu		@
.L662:
@ Data/FE6_FE7.c:1938: }
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
@ Data/FE6_FE7.c:1796:         SaveMisc(proc);
	movs	r0, r4	@, proc
	bl	SaveMisc		@
@ Data/FE6_FE7.c:1797:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L748+12	@ tmp223,
	bl	.L17		@
@ Data/FE6_FE7.c:597: }
	b	.L664		@
.L739:
@ Data/FE6_FE7.c:1791:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	ldr	r3, .L748+12	@ tmp215,
	bl	.L17		@
@ Data/FE6_FE7.c:597: }
	b	.L663		@
.L743:
@ Data/FE6_FE7.c:1882:             int val = proc->tmp[proc->id];
	adds	r3, r3, #71	@ tmp331,
@ Data/FE6_FE7.c:1882:             int val = proc->tmp[proc->id];
	ldrsh	r3, [r4, r3]	@ val,
@ Data/FE6_FE7.c:1883:             if (keys & DPAD_RIGHT)
	mov	r2, r9	@ _186, _186
	cmp	r2, #0	@ _186,
	beq	.L684		@,
@ Data/FE6_FE7.c:1891:             if (val < 0)
	movs	r2, #2	@ prephitmp_94,
	adds	r3, r3, #1	@ val, val,
	bmi	.L685		@,
.L738:
@ Data/FE6_FE7.c:1895:             if (val > 2)
	movs	r2, #0	@ prephitmp_94,
	cmp	r3, #2	@ val,
	ble	.L746		@,
.L685:
@ Data/FE6_FE7.c:1901:                 proc->tmp[proc->id] = val;
	movs	r3, #78	@ tmp339,
@ Data/FE6_FE7.c:1902:                 RedrawMiscMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:1901:                 proc->tmp[proc->id] = val;
	strh	r2, [r4, r3]	@ prephitmp_94, proc_100(D)->tmp[7]
@ Data/FE6_FE7.c:1902:                 RedrawMiscMenu(proc);
	bl	RedrawMiscMenu		@
	b	.L688		@
.L744:
@ Data/FE6_FE7.c:1914:                 proc->digit = 0;
	movs	r3, #49	@ tmp354,
	movs	r2, #0	@ tmp355,
	strb	r2, [r4, r3]	@ tmp355, proc_100(D)->digit
@ Data/FE6_FE7.c:1915:                 proc->editing = true;
	subs	r3, r3, #3	@ tmp357,
	adds	r2, r2, #1	@ tmp358,
	strb	r2, [r4, r3]	@ tmp358, proc_100(D)->editing
	b	.L688		@
.L673:
@ Data/FE6_FE7.c:1831:                 proc->editing = false;
	movs	r3, #46	@ tmp293,
	movs	r2, #0	@ tmp294,
	strb	r2, [r4, r3]	@ tmp294, proc_100(D)->editing
@ Data/FE6_FE7.c:1830:                 proc->digit = 0;
	movs	r3, #0	@ _29,
	b	.L674		@
.L745:
@ Data/FE6_FE7.c:1923:                 proc->id = NumberOfMisc - 1;
	movs	r2, #7	@ _75,
	b	.L692		@
.L670:
@ Data/FE6_FE7.c:1817:                 proc->digit = max_digits - 1;
	mov	r3, fp	@ _178, _178
@ Data/FE6_FE7.c:1818:                 proc->editing = false;
	movs	r2, #46	@ tmp276,
	movs	r1, #0	@ tmp277,
@ Data/FE6_FE7.c:1817:                 proc->digit = max_digits - 1;
	subs	r3, r3, #1	@ tmp274,
	lsls	r3, r3, #24	@ tmp275, tmp274,
@ Data/FE6_FE7.c:1818:                 proc->editing = false;
	strb	r1, [r4, r2]	@ tmp277, proc_100(D)->editing
@ Data/FE6_FE7.c:1817:                 proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _19, tmp275,
	b	.L671		@
.L741:
@ Data/FE6_FE7.c:1840:                 proc->tmp[proc->id] = min;
	mov	r3, r10	@ _157, _157
	lsls	r3, r3, #16	@ _44, _157,
	asrs	r3, r3, #16	@ _44, _44,
	b	.L677		@
.L742:
@ Data/FE6_FE7.c:1858:                 proc->tmp[proc->id] = max;
	lsls	r3, r6, #16	@ _51, max,
	asrs	r3, r3, #16	@ _51, _51,
	b	.L681		@
.L697:
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	movs	r3, #1	@ _178,
	mov	fp, r3	@ _178, _178
	b	.L666		@
.L684:
@ Data/FE6_FE7.c:1887:             else if (keys & DPAD_LEFT)
	lsls	r2, r5, #26	@ tmp397, keys,
	bmi	.L747		@,
@ Data/FE6_FE7.c:1891:             if (val < 0)
	cmp	r3, #0	@ val,
	blt	.L702		@,
@ Data/FE6_FE7.c:1895:             if (val > 2)
	movs	r2, #0	@ prephitmp_94,
	cmp	r3, #2	@ val,
	bgt	.L685		@,
@ Data/FE6_FE7.c:1918:         if (keys & DPAD_UP)
	mov	r3, r8	@ _191, _191
	cmp	r3, #0	@ _191,
	beq	.L691		@,
@ Data/FE6_FE7.c:1920:             proc->id--;
	movs	r2, #6	@ _75,
	b	.L692		@
.L682:
@ Data/FE6_FE7.c:1869:                     proc->tmp[proc->id] = val;
	lsls	r3, r3, #16	@ _51, val,
	asrs	r3, r3, #16	@ _51, _51,
	b	.L681		@
.L747:
@ Data/FE6_FE7.c:1891:             if (val < 0)
	movs	r2, #2	@ prephitmp_94,
	subs	r3, r3, #1	@ val, val,
	bpl	.L738		@,
	b	.L685		@
.L746:
@ Data/FE6_FE7.c:1901:                 proc->tmp[proc->id] = val;
	lsls	r2, r3, #16	@ prephitmp_94, val,
	asrs	r2, r2, #16	@ prephitmp_94, prephitmp_94,
	b	.L685		@
.L702:
@ Data/FE6_FE7.c:1891:             if (val < 0)
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
@ Data/FE6_FE7.c:2282:     struct Unit * unit = proc->unit; // GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	ldr	r4, [r0, #60]	@ unit, proc_3(D)->unit
@ Data/FE6_FE7.c:2281: {
	movs	r5, r0	@ proc, tmp266
@ Data/FE6_FE7.c:2283:     if (!unit)
	cmp	r4, #0	@ unit,
	bne	.LCB5089	@
	b	.L762	@long jump	@
.LCB5089:
@ Data/FE6_FE7.c:2288:     EndAllMenus();
	ldr	r3, .L764	@ tmp165,
	bl	.L17		@
@ Data/FE6_FE7.c:2289:     ResetText();
	ldr	r3, .L764+4	@ tmp166,
	bl	.L17		@
@ Data/FE6_FE7.c:2293:     ProcPtr playerPhaseProc = Proc_Find(gProcScr_PlayerPhase);
	ldr	r3, .L764+8	@ tmp168,
	ldr	r0, .L764+12	@ tmp167,
	bl	.L17		@
@ Data/FE6_FE7.c:2295:     Proc_Goto(playerPhaseProc, 9); // wait for menu?
	movs	r1, #9	@,
	ldr	r3, .L764+16	@ tmp169,
	bl	.L17		@
@ Data/FE6_FE7.c:2296:     UnitBeginActionInit(unit);
	movs	r0, r4	@, unit
	bl	UnitBeginActionInit		@
@ Data/FE6_FE7.c:2298:     proc->editing = false;
	movs	r3, #0	@ tmp170,
@ Data/FE6_FE7.c:2300:     proc->id = 0;
	movs	r2, #0	@ tmp171,
@ Data/FE6_FE7.c:2303:         proc->tmp[i] = 0;
	movs	r0, r5	@ tmp175, proc
@ Data/FE6_FE7.c:2298:     proc->editing = false;
	strh	r3, [r5, #46]	@ tmp170, MEM <unsigned short> [(void *)proc_3(D) + 46B]
@ Data/FE6_FE7.c:2300:     proc->id = 0;
	adds	r3, r3, #48	@ tmp172,
	strb	r2, [r5, r3]	@ tmp171, proc_3(D)->id
@ Data/FE6_FE7.c:2303:         proc->tmp[i] = 0;
	movs	r1, #0	@,
	movs	r2, #30	@,
	ldr	r3, .L764+20	@ tmp178,
	adds	r0, r0, #64	@ tmp175,
	bl	.L17		@
@ Data/FE6_FE7.c:2306:     gPlaySt.xCursor = gBmSt.playerCursor.x;
	ldr	r4, .L764+24	@ tmp259,
@ Data/FE6_FE7.c:2306:     gPlaySt.xCursor = gBmSt.playerCursor.x;
	ldr	r3, .L764+28	@ tmp181,
	ldrh	r2, [r4, #20]	@ tmp185,
	strb	r2, [r3, #18]	@ tmp185, gPlaySt.xCursor
@ Data/FE6_FE7.c:2307:     gPlaySt.yCursor = gBmSt.playerCursor.y;
	ldrh	r2, [r4, #22]	@ tmp190,
	strb	r2, [r3, #19]	@ tmp190, gPlaySt.yCursor
@ Data/FE6_FE7.c:2313:     gActiveUnit->state |= US_HIDDEN;
	movs	r2, #1	@ tmp192,
@ Data/FE6_FE7.c:2313:     gActiveUnit->state |= US_HIDDEN;
	ldr	r6, .L764+32	@ tmp191,
	ldr	r0, [r6]	@ gActiveUnit.62_22, gActiveUnit
@ Data/FE6_FE7.c:2313:     gActiveUnit->state |= US_HIDDEN;
	ldr	r3, [r0, #12]	@ gActiveUnit.62_22->state, gActiveUnit.62_22->state
	orrs	r3, r2	@ tmp193, tmp192
	str	r3, [r0, #12]	@ tmp193, gActiveUnit.62_22->state
@ Data/FE6_FE7.c:2314:     HideUnitSprite(gActiveUnit);
	ldr	r7, .L764+36	@ tmp195,
	bl	.L145		@
@ Data/FE6_FE7.c:2272:     if (!MU_Exists())
	ldr	r3, .L764+40	@ tmp196,
	bl	.L17		@
@ Data/FE6_FE7.c:2272:     if (!MU_Exists())
	cmp	r0, #0	@ tmp268,
	beq	.L763		@,
.L753:
@ Data/FE6_FE7.c:2277:     MU_SetDefaultFacing_Auto();
	ldr	r3, .L764+44	@ tmp205,
	bl	.L17		@
@ Data/FE6_FE7.c:2318:     gBmSt.gameStateBits &= ~BM_FLAG_3;
	movs	r2, #11	@ tmp211,
	ldrb	r3, [r4, #4]	@ tmp209,
	bics	r3, r2	@ tmp210, tmp211
	strb	r3, [r4, #4]	@ tmp210, gBmSt.gameStateBits
@ Data/FE6_FE7.c:2319:     PutMapCursor(
	movs	r3, #32	@ tmp281,
	ldrsh	r6, [r4, r3]	@ _28, tmp259, tmp281
	movs	r3, #34	@ tmp282,
	ldrsh	r7, [r4, r3]	@ _30, tmp259, tmp282
@ Data/FE6_FE7.c:2321:         IsUnitSpriteHoverEnabledAt(gBmSt.playerCursor.x, gBmSt.playerCursor.y) ? 3 : 0);
	movs	r3, #22	@ tmp283,
	ldrsh	r1, [r4, r3]	@ tmp216, tmp259, tmp283
	movs	r3, #20	@ tmp284,
	ldrsh	r0, [r4, r3]	@ tmp218, tmp259, tmp284
	ldr	r3, .L764+48	@ tmp219,
	bl	.L17		@
@ Data/FE6_FE7.c:2319:     PutMapCursor(
	rsbs	r2, r0, #0	@ tmp260, tmp269
	adcs	r2, r2, r0	@ tmp260, tmp269
	movs	r3, #2	@ tmp263,
	rsbs	r2, r2, #0	@ tmp262, tmp260
	bics	r2, r3	@ iftmp.65_36, tmp263
@ Data/FE6_FE7.c:2319:     PutMapCursor(
	movs	r1, r7	@, _30
	ldr	r3, .L764+52	@ tmp222,
	movs	r0, r6	@, _28
@ Data/FE6_FE7.c:2319:     PutMapCursor(
	adds	r2, r2, #3	@ iftmp.65_36,
@ Data/FE6_FE7.c:2319:     PutMapCursor(
	bl	.L17		@
@ Data/FE6_FE7.c:2324:     switch (proc->page)
	movs	r3, #52	@ tmp223,
	ldrb	r3, [r5, r3]	@ _37,
@ Data/FE6_FE7.c:2324:     switch (proc->page)
	cmp	r3, #1	@ _37,
	beq	.L755		@,
	cmp	r3, #2	@ _37,
	beq	.L756		@,
	cmp	r3, #0	@ _37,
	bne	.L757		@,
@ Data/FE6_FE7.c:2328:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDef, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r3, #28	@ tmp285,
	ldrsh	r1, [r4, r3]	@ tmp225, tmp259, tmp285
@ Data/FE6_FE7.c:2328:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDef, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r2, #12	@ tmp286,
	ldrsh	r3, [r4, r2]	@ tmp227, tmp259, tmp286
@ Data/FE6_FE7.c:2328:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDef, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	ldr	r0, .L764+56	@ tmp230,
	subs	r1, r1, r3	@ tmp228, tmp225, tmp227
	movs	r2, #1	@,
	movs	r3, #21	@,
	ldr	r4, .L764+60	@ tmp231,
	bl	.L27		@
.L758:
@ Data/FE6_FE7.c:2343:     if (menu)
	cmp	r0, #0	@ menu,
	beq	.L757		@,
@ Data/FE6_FE7.c:2345:         menu->itemCurrent = proc->mainID;
	movs	r3, #53	@ tmp248,
@ Data/FE6_FE7.c:2345:         menu->itemCurrent = proc->mainID;
	movs	r1, #97	@ tmp249,
@ Data/FE6_FE7.c:2345:         menu->itemCurrent = proc->mainID;
	ldrb	r2, [r5, r3]	@ _58,
@ Data/FE6_FE7.c:2345:         menu->itemCurrent = proc->mainID;
	strb	r2, [r0, r1]	@ _58, menu_56->itemCurrent
@ Data/FE6_FE7.c:2346:         int count = menu->itemCount - 1;
	adds	r3, r3, #43	@ tmp251,
	ldrb	r3, [r0, r3]	@ _59,
@ Data/FE6_FE7.c:2346:         int count = menu->itemCount - 1;
	subs	r3, r3, #1	@ count,
@ Data/FE6_FE7.c:2347:         if (menu->itemCurrent >= count)
	cmp	r3, r2	@ count, _58
	bgt	.L757		@,
@ Data/FE6_FE7.c:2349:             menu->itemCurrent = count;
	strb	r3, [r0, r1]	@ count, menu_56->itemCurrent
.L757:
@ Data/FE6_FE7.c:2354:     Decompress(gUnknown_08A02274, (void *)(VRAM + 0x10000 + 0x240 * 0x20)); //
	ldr	r0, .L764+64	@ tmp257,
	ldr	r1, .L764+68	@,
	ldr	r3, .L764+72	@ tmp258,
	bl	.L17		@
.L750:
@ Data/FE6_FE7.c:2355: }
	@ sp needed	@
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L756:
@ Data/FE6_FE7.c:2338:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage3, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r3, #28	@ tmp289,
	ldrsh	r1, [r4, r3]	@ tmp241, tmp259, tmp289
@ Data/FE6_FE7.c:2338:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage3, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r2, #12	@ tmp290,
	ldrsh	r3, [r4, r2]	@ tmp243, tmp259, tmp290
@ Data/FE6_FE7.c:2338:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage3, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	ldr	r0, .L764+76	@ tmp246,
	subs	r1, r1, r3	@ tmp244, tmp241, tmp243
	movs	r2, #1	@,
	movs	r3, #21	@,
	ldr	r4, .L764+60	@ tmp247,
	bl	.L27		@
@ Data/FE6_FE7.c:2339:             break;
	b	.L758		@
.L763:
@ Data/FE6_FE7.c:2274:         MU_Create(gActiveUnit);
	ldr	r0, [r6]	@ gActiveUnit, gActiveUnit
	ldr	r3, .L764+80	@ tmp201,
	bl	.L17		@
@ Data/FE6_FE7.c:2275:         HideUnitSprite(gActiveUnit);
	ldr	r0, [r6]	@ gActiveUnit, gActiveUnit
	bl	.L145		@
	b	.L753		@
.L755:
@ Data/FE6_FE7.c:2333:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage2, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r3, #28	@ tmp287,
	ldrsh	r1, [r4, r3]	@ tmp233, tmp259, tmp287
@ Data/FE6_FE7.c:2333:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage2, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	movs	r2, #12	@ tmp288,
	ldrsh	r3, [r4, r2]	@ tmp235, tmp259, tmp288
@ Data/FE6_FE7.c:2333:             menu = StartOrphanMenuAdjusted(&gDebuggerMenuDefPage2, gBmSt.cursorTarget.x - gBmSt.camera.x, 1, 0x15);
	ldr	r0, .L764+84	@ tmp238,
	subs	r1, r1, r3	@ tmp236, tmp233, tmp235
	movs	r2, #1	@,
	movs	r3, #21	@,
	ldr	r4, .L764+60	@ tmp239,
	bl	.L27		@
@ Data/FE6_FE7.c:2334:             break;
	b	.L758		@
.L762:
@ Data/FE6_FE7.c:2285:         Proc_Goto(proc, EndLabel);
	movs	r1, #99	@,
	ldr	r3, .L764+16	@ tmp164,
	bl	.L17		@
@ Data/FE6_FE7.c:2286:         return;
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
@ Data/FE6_FE7.c:2222:     if (CheckFlag(DebuggerTurnedOff_Flag))
	ldr	r3, .L767	@ tmp118,
@ Data/FE6_FE7.c:2221: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2222:     if (CheckFlag(DebuggerTurnedOff_Flag))
	ldr	r0, [r3]	@ DebuggerTurnedOff_Flag, DebuggerTurnedOff_Flag
@ Data/FE6_FE7.c:2227: }
	@ sp needed	@
@ Data/FE6_FE7.c:2222:     if (CheckFlag(DebuggerTurnedOff_Flag))
	ldr	r3, .L767+4	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2222:     if (CheckFlag(DebuggerTurnedOff_Flag))
	rsbs	r3, r0, #0	@ tmp126, tmp127
	adcs	r0, r0, r3	@ tmp125, tmp127, tmp126
@ Data/FE6_FE7.c:2227: }
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
@ Data/FE6_FE7.c:2231:     Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
@ Data/FE6_FE7.c:2233: }
	@ sp needed	@
@ Data/FE6_FE7.c:2231:     Proc_Goto(proc, RestartLabel);
	ldr	r3, .L770	@ tmp116,
	bl	.L17		@
@ Data/FE6_FE7.c:2233: }
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
@ Data/FE6_FE7.c:2222:     if (CheckFlag(DebuggerTurnedOff_Flag))
	ldr	r3, .L782	@ tmp138,
@ Data/FE6_FE7.c:2236: { // based on PlayerPhase_MainIdle
	movs	r6, r0	@ playerPhaseProc, tmp200
	push	{r7, lr}	@
@ Data/FE6_FE7.c:2222:     if (CheckFlag(DebuggerTurnedOff_Flag))
	ldr	r0, [r3]	@ DebuggerTurnedOff_Flag, DebuggerTurnedOff_Flag
	ldr	r3, .L782+4	@ tmp140,
	bl	.L17		@
	subs	r4, r0, #0	@ tmp141, tmp201,
@ Data/FE6_FE7.c:2222:     if (CheckFlag(DebuggerTurnedOff_Flag))
	bne	.L772		@,
@ Data/FE6_FE7.c:2241:     struct Unit * unit = GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	ldr	r2, .L782+8	@ tmp143,
	movs	r1, #22	@ tmp211,
	ldrsh	r3, [r2, r1]	@ tmp144, tmp143, tmp211
@ Data/FE6_FE7.c:2241:     struct Unit * unit = GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	ldr	r1, .L782+12	@ tmp146,
	ldr	r1, [r1]	@ gBmMapUnit, gBmMapUnit
	lsls	r3, r3, #2	@ tmp147, tmp144,
@ Data/FE6_FE7.c:2241:     struct Unit * unit = GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	ldr	r3, [r3, r1]	@ *_6, *_6
@ Data/FE6_FE7.c:2241:     struct Unit * unit = GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	movs	r0, #20	@ tmp212,
	ldrsh	r2, [r2, r0]	@ tmp149, tmp143, tmp212
@ Data/FE6_FE7.c:2241:     struct Unit * unit = GetUnit(gBmMapUnit[gBmSt.playerCursor.y][gBmSt.playerCursor.x]);
	ldrb	r0, [r3, r2]	@ *_10, *_10
	ldr	r3, .L782+16	@ tmp152,
	bl	.L17		@
	subs	r5, r0, #0	@ unit, tmp202,
@ Data/FE6_FE7.c:2242:     if (!unit)
	beq	.L772		@,
@ Data/FE6_FE7.c:2246:     gActiveUnitMoveOrigin.x = unit->xPos;
	movs	r2, #16	@ tmp155,
@ Data/FE6_FE7.c:2246:     gActiveUnitMoveOrigin.x = unit->xPos;
	ldr	r3, .L782+20	@ tmp153,
@ Data/FE6_FE7.c:2246:     gActiveUnitMoveOrigin.x = unit->xPos;
	ldrsb	r2, [r0, r2]	@ tmp155,
@ Data/FE6_FE7.c:2246:     gActiveUnitMoveOrigin.x = unit->xPos;
	strh	r2, [r3]	@ tmp155, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:2247:     gActiveUnitMoveOrigin.y = unit->yPos;
	movs	r2, #17	@ tmp158,
	ldrsb	r2, [r0, r2]	@ tmp158,
@ Data/FE6_FE7.c:2247:     gActiveUnitMoveOrigin.y = unit->yPos;
	strh	r2, [r3, #2]	@ tmp158, gActiveUnitMoveOrigin.y
@ Data/FE6_FE7.c:2248:     UnitBeginActionInit(unit);
	bl	UnitBeginActionInit		@
@ Data/FE6_FE7.c:2249:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	ldr	r3, .L782+24	@ tmp160,
	movs	r0, r3	@, tmp160
	mov	r9, r3	@ tmp160, tmp160
	ldr	r3, .L782+28	@ tmp199,
	mov	r8, r3	@ tmp199, tmp199
	bl	.L17		@
	subs	r7, r0, #0	@ procIdler, tmp203,
@ Data/FE6_FE7.c:2250:     if (!procIdler)
	beq	.L780		@,
.L776:
@ Data/FE6_FE7.c:2255:     procIdler->unit = unit;
	str	r5, [r7, #60]	@ unit, procIdler_17->unit
@ Data/FE6_FE7.c:2257:     DebuggerProc * proc = Proc_Find(DebuggerProcCmd);
	ldr	r5, .L782+32	@ tmp180,
	movs	r0, r5	@, tmp180
	bl	.L193		@
	subs	r4, r0, #0	@ proc, tmp205,
@ Data/FE6_FE7.c:2258:     if (!proc)
	beq	.L781		@,
.L772:
@ Data/FE6_FE7.c:2268: }
	@ sp needed	@
	pop	{r6, r7}
	mov	r9, r7
	mov	r8, r6
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L781:
@ Data/FE6_FE7.c:2262:         proc = Proc_StartBlocking(DebuggerProcCmd, playerPhaseProc);
	movs	r1, r6	@, playerPhaseProc
	movs	r0, r5	@, tmp180
	ldr	r3, .L782+36	@ tmp183,
	bl	.L17		@
@ Data/FE6_FE7.c:346:     proc->page = 0;
	movs	r3, #128	@ tmp186,
	lsls	r3, r3, #9	@ tmp186, tmp186,
	str	r3, [r0, #52]	@ tmp186, MEM <unsigned int> [(void *)proc_37 + 52B]
@ Data/FE6_FE7.c:352:     proc->tileID = 1;
	movs	r3, #1	@ tmp187,
@ Data/FE6_FE7.c:353:     proc->id = 0;
	movs	r2, #0	@ tmp185,
@ Data/FE6_FE7.c:2262:         proc = Proc_StartBlocking(DebuggerProcCmd, playerPhaseProc);
	movs	r5, r0	@ proc, tmp206
@ Data/FE6_FE7.c:352:     proc->tileID = 1;
	strh	r3, [r0, #42]	@ tmp187, proc_37->tileID
@ Data/FE6_FE7.c:353:     proc->id = 0;
	adds	r3, r3, #47	@ tmp190,
@ Data/FE6_FE7.c:349:     proc->godMode = 0;
	strh	r4, [r0, #50]	@ proc, MEM <vector(2) unsigned char> [(unsigned char *)proc_37 + 50B]
@ Data/FE6_FE7.c:354:     proc->lastTileHovered = 0;
	str	r4, [r0, #44]	@ proc, MEM <unsigned int> [(void *)proc_37 + 44B]
@ Data/FE6_FE7.c:357:         proc->tmp[i] = 0;
	movs	r1, #0	@,
@ Data/FE6_FE7.c:353:     proc->id = 0;
	strb	r2, [r0, r3]	@ tmp185, proc_37->id
@ Data/FE6_FE7.c:357:         proc->tmp[i] = 0;
	movs	r2, #30	@,
	ldr	r3, .L782+40	@ tmp196,
	adds	r0, r0, #64	@ tmp193,
	bl	.L17		@
@ Data/FE6_FE7.c:2264:         CopyProcVariables(proc, procIdler);
	movs	r1, r7	@, procIdler
	movs	r0, r5	@, proc
	bl	CopyProcVariables		@
	b	.L772		@
.L780:
@ Data/FE6_FE7.c:2252:         procIdler = Proc_Start(DebuggerProcCmdIdler, (void *)3);
	movs	r1, #3	@,
	mov	r0, r9	@, tmp160
	ldr	r3, .L782+44	@ tmp164,
	bl	.L17		@
@ Data/FE6_FE7.c:346:     proc->page = 0;
	movs	r3, #128	@ tmp167,
	lsls	r3, r3, #9	@ tmp167, tmp167,
	str	r3, [r0, #52]	@ tmp167, MEM <unsigned int> [(void *)procIdler_30 + 52B]
@ Data/FE6_FE7.c:352:     proc->tileID = 1;
	movs	r3, #1	@ tmp168,
@ Data/FE6_FE7.c:353:     proc->id = 0;
	movs	r2, #0	@ tmp166,
@ Data/FE6_FE7.c:352:     proc->tileID = 1;
	strh	r3, [r0, #42]	@ tmp168, procIdler_30->tileID
@ Data/FE6_FE7.c:353:     proc->id = 0;
	adds	r3, r3, #47	@ tmp171,
@ Data/FE6_FE7.c:349:     proc->godMode = 0;
	strh	r4, [r0, #50]	@ tmp141, MEM <vector(2) unsigned char> [(unsigned char *)procIdler_30 + 50B]
@ Data/FE6_FE7.c:354:     proc->lastTileHovered = 0;
	str	r4, [r0, #44]	@ tmp141, MEM <unsigned int> [(void *)procIdler_30 + 44B]
@ Data/FE6_FE7.c:2252:         procIdler = Proc_Start(DebuggerProcCmdIdler, (void *)3);
	movs	r7, r0	@ procIdler, tmp204
@ Data/FE6_FE7.c:353:     proc->id = 0;
	strb	r2, [r0, r3]	@ tmp166, procIdler_30->id
@ Data/FE6_FE7.c:357:         proc->tmp[i] = 0;
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
@ Data/FE6_FE7.c:2272:     if (!MU_Exists())
	ldr	r3, .L787	@ tmp117,
	bl	.L17		@
@ Data/FE6_FE7.c:2272:     if (!MU_Exists())
	cmp	r0, #0	@ tmp127,
	beq	.L786		@,
.L785:
@ Data/FE6_FE7.c:2278: }
	@ sp needed	@
@ Data/FE6_FE7.c:2277:     MU_SetDefaultFacing_Auto();
	ldr	r3, .L787+4	@ tmp126,
	bl	.L17		@
@ Data/FE6_FE7.c:2278: }
	pop	{r4}
	pop	{r0}
	bx	r0
.L786:
@ Data/FE6_FE7.c:2274:         MU_Create(gActiveUnit);
	ldr	r4, .L787+8	@ tmp120,
	ldr	r3, .L787+12	@ tmp122,
	ldr	r0, [r4]	@ gActiveUnit, gActiveUnit
	bl	.L17		@
@ Data/FE6_FE7.c:2275:         HideUnitSprite(gActiveUnit);
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
@ Data/FE6_FE7.c:2360:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L790	@ tmp136,
@ Data/FE6_FE7.c:2358: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:2358: {
	movs	r4, r0	@ menu, tmp162
@ Data/FE6_FE7.c:2360:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L790+4	@ tmp135,
	bl	.L17		@
@ Data/FE6_FE7.c:2368:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	movs	r3, #96	@ tmp137,
	ldrb	r3, [r4, r3]	@ tmp138,
@ Data/FE6_FE7.c:2368:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	adds	r3, r3, #11	@ tmp139,
	lsls	r3, r3, #2	@ tmp140, tmp139,
	adds	r4, r4, r3	@ tmp141, menu, tmp140
	ldr	r3, [r4, #4]	@ _4, menu_19(D)->menuItems[_3]
@ Data/FE6_FE7.c:2368:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	movs	r2, #42	@ tmp166,
	ldrsh	r4, [r3, r2]	@ tmp143, _4, tmp166
@ Data/FE6_FE7.c:2369:     int y = (menu->menuItems[menu->itemCount - 1]->yTile * 8) + 4;
	movs	r5, #44	@ tmp144,
	ldrsh	r5, [r3, r5]	@ tmp144, _4, tmp144
@ Data/FE6_FE7.c:2371:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	ldr	r2, .L790+8	@ tmp169,
@ Data/FE6_FE7.c:2371:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	movs	r3, #52	@ tmp148,
@ Data/FE6_FE7.c:2371:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	mov	ip, r2	@ tmp169, tmp169
@ Data/FE6_FE7.c:2368:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	lsls	r4, r4, #3	@ _7, tmp143,
@ Data/FE6_FE7.c:2368:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	movs	r1, r4	@ x, _7
@ Data/FE6_FE7.c:2371:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	ldrb	r3, [r0, r3]	@ tmp149,
@ Data/FE6_FE7.c:2371:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	ldr	r6, .L790+12	@ tmp146,
@ Data/FE6_FE7.c:2369:     int y = (menu->menuItems[menu->itemCount - 1]->yTile * 8) + 4;
	lsls	r5, r5, #3	@ tmp145, tmp144,
@ Data/FE6_FE7.c:2371:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	add	r3, r3, ip	@ tmp150, tmp169
@ Data/FE6_FE7.c:2369:     int y = (menu->menuItems[menu->itemCount - 1]->yTile * 8) + 4;
	adds	r5, r5, #4	@ y,
@ Data/FE6_FE7.c:2371:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	ldr	r7, .L790+16	@ tmp151,
	movs	r2, r5	@, y
	str	r3, [sp]	@ tmp150,
	movs	r0, #0	@,
	movs	r3, r6	@, tmp146
@ Data/FE6_FE7.c:2368:     int x = (menu->menuItems[menu->itemCount - 1]->xTile * 8) + 6 + (8 * 3);
	adds	r1, r1, #30	@ x,
@ Data/FE6_FE7.c:2371:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + proc->page + 1);
	bl	.L145		@
@ Data/FE6_FE7.c:2372:     x += 8;
	movs	r1, r4	@ x, _7
@ Data/FE6_FE7.c:2373:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr2, 0) + OAM2_LAYER(0));
	ldr	r3, .L790+20	@ tmp154,
	movs	r2, r5	@, y
	str	r3, [sp]	@ tmp154,
	movs	r0, #0	@,
	movs	r3, r6	@, tmp146
@ Data/FE6_FE7.c:2372:     x += 8;
	adds	r1, r1, #38	@ x,
@ Data/FE6_FE7.c:2373:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr2, 0) + OAM2_LAYER(0));
	bl	.L145		@
@ Data/FE6_FE7.c:2375:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + NumberOfPages);
	movs	r2, #169	@ tmp173,
	lsls	r2, r2, #2	@ tmp173, tmp173,
	mov	ip, r2	@ tmp173, tmp173
@ Data/FE6_FE7.c:2374:     x += 8;
	movs	r1, r4	@ _7, _7
@ Data/FE6_FE7.c:2375:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + NumberOfPages);
	ldr	r3, .L790+24	@ tmp158,
	ldr	r3, [r3]	@ NumberOfPages, NumberOfPages
	add	r3, r3, ip	@ tmp159, tmp173
	str	r3, [sp]	@ tmp159,
	movs	r2, r5	@, y
	movs	r3, r6	@, tmp146
	movs	r0, #0	@,
@ Data/FE6_FE7.c:2374:     x += 8;
	adds	r1, r1, #46	@ _7,
@ Data/FE6_FE7.c:2375:     PutSprite(0, x, y, gObject_8x8, TILEREF(chr, 0) + OAM2_LAYER(0) + NumberOfPages);
	bl	.L145		@
@ Data/FE6_FE7.c:2377: }
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
@ Data/FE6_FE7.c:2383:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L794	@ tmp123,
	ldr	r5, .L794+4	@ tmp124,
	bl	.L28		@
@ Data/FE6_FE7.c:2384:     proc->actionID = 0;
	movs	r2, #0	@ tmp126,
	movs	r3, #47	@ tmp125,
@ Data/FE6_FE7.c:2385:     Proc_Goto(proc, RestartLabel); // 0xb7
	movs	r1, #1	@,
@ Data/FE6_FE7.c:2384:     proc->actionID = 0;
	strb	r2, [r0, r3]	@ tmp126, proc_9->actionID
@ Data/FE6_FE7.c:2385:     Proc_Goto(proc, RestartLabel); // 0xb7
	ldr	r3, .L794+8	@ tmp128,
@ Data/FE6_FE7.c:2383:     proc = Proc_Find(DebuggerProcCmd);
	movs	r4, r0	@ proc, tmp146
@ Data/FE6_FE7.c:2385:     Proc_Goto(proc, RestartLabel); // 0xb7
	bl	.L17		@
@ Data/FE6_FE7.c:2386:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	ldr	r0, .L794+12	@ tmp130,
	bl	.L28		@
@ Data/FE6_FE7.c:2387:     proc->page++;
	movs	r3, #52	@ tmp132,
@ Data/FE6_FE7.c:2388:     if (proc->page > (NumberOfPages - 1))
	ldr	r2, .L794+16	@ tmp137,
@ Data/FE6_FE7.c:2387:     proc->page++;
	ldrb	r3, [r4, r3]	@ tmp134,
@ Data/FE6_FE7.c:2388:     if (proc->page > (NumberOfPages - 1))
	ldr	r2, [r2]	@ NumberOfPages, NumberOfPages
@ Data/FE6_FE7.c:2387:     proc->page++;
	adds	r3, r3, #1	@ tmp135,
	lsls	r3, r3, #24	@ tmp136, tmp135,
	lsrs	r3, r3, #24	@ _2, tmp136,
@ Data/FE6_FE7.c:2388:     if (proc->page > (NumberOfPages - 1))
	cmp	r3, r2	@ _2, NumberOfPages
	blt	.L793		@,
@ Data/FE6_FE7.c:2390:         proc->page = 0;
	movs	r3, #0	@ _2,
.L793:
@ Data/FE6_FE7.c:2394: }
	@ sp needed	@
	movs	r2, #52	@ tmp139,
	strb	r3, [r4, r2]	@ _2, MEM <struct DebuggerProc> [(void *)proc_9].page
@ Data/FE6_FE7.c:2392:     procIdler->page = proc->page;
	strb	r3, [r0, r2]	@ _2, procIdler_13->page
@ Data/FE6_FE7.c:2394: }
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
@ Data/FE6_FE7.c:2412:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	movs	r7, #192	@ tmp125,
	ands	r7, r1	@ _25, allegiance
@ Data/FE6_FE7.c:2412:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	movs	r3, r7	@ tmp126, _25
@ Data/FE6_FE7.c:2409: {
	mov	lr, r8	@,
@ Data/FE6_FE7.c:2412:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	adds	r4, r0, #1	@ i, deployId,
@ Data/FE6_FE7.c:2412:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	adds	r3, r3, #63	@ tmp126,
@ Data/FE6_FE7.c:2409: {
	mov	r8, r0	@ deployId, tmp133
	movs	r5, r1	@ allegiance, tmp134
	push	{lr}	@
@ Data/FE6_FE7.c:2412:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	cmp	r4, r3	@ i, tmp126
	bgt	.L798		@,
	ldr	r6, .L814	@ tmp132,
	adds	r7, r7, #64	@ _26,
.L801:
@ Data/FE6_FE7.c:2414:         unit = GetUnit(i);
	movs	r0, r4	@, i
	bl	.L38		@
@ Data/FE6_FE7.c:2415:         if (UNIT_IS_VALID(unit))
	cmp	r0, #0	@ <retval>,
	beq	.L799		@,
@ Data/FE6_FE7.c:2415:         if (UNIT_IS_VALID(unit))
	ldr	r3, [r0]	@ unit_17->pCharacterData, unit_17->pCharacterData
	cmp	r3, #0	@ unit_17->pCharacterData,
	bne	.L797		@,
.L799:
@ Data/FE6_FE7.c:2412:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	adds	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:2412:     for (int i = deployId + 1; i < ((allegiance & 0xC0) + 0x40); ++i)
	cmp	r4, r7	@ i, _26
	bne	.L801		@,
.L798:
@ Data/FE6_FE7.c:2420:     for (int i = allegiance; i < deployId; ++i)
	cmp	r8, r5	@ deployId, allegiance
	ble	.L804		@,
	ldr	r6, .L814	@ tmp132,
.L802:
@ Data/FE6_FE7.c:2422:         unit = GetUnit(i);
	movs	r0, r5	@, allegiance
	bl	.L38		@
@ Data/FE6_FE7.c:2423:         if (UNIT_IS_VALID(unit))
	cmp	r0, #0	@ <retval>,
	beq	.L803		@,
@ Data/FE6_FE7.c:2423:         if (UNIT_IS_VALID(unit))
	ldr	r3, [r0]	@ unit_21->pCharacterData, unit_21->pCharacterData
	cmp	r3, #0	@ unit_21->pCharacterData,
	bne	.L797		@,
.L803:
@ Data/FE6_FE7.c:2420:     for (int i = allegiance; i < deployId; ++i)
	adds	r5, r5, #1	@ allegiance,
@ Data/FE6_FE7.c:2420:     for (int i = allegiance; i < deployId; ++i)
	cmp	r8, r5	@ deployId, allegiance
	bne	.L802		@,
.L804:
@ Data/FE6_FE7.c:2428:     return NULL;
	movs	r0, #0	@ <retval>,
.L797:
@ Data/FE6_FE7.c:2429: }
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
@ Data/FE6_FE7.c:2436:     for (int i = deployId - 1; i >= allegiance; --i) // should loop back to itself I guess
	subs	r4, r0, #1	@ i, deployId,
@ Data/FE6_FE7.c:2432: {
	movs	r5, r0	@ deployId, tmp130
	movs	r7, r1	@ allegiance, tmp131
@ Data/FE6_FE7.c:2436:     for (int i = deployId - 1; i >= allegiance; --i) // should loop back to itself I guess
	cmp	r4, r1	@ i, allegiance
	blt	.L817		@,
	ldr	r6, .L833	@ tmp129,
.L820:
@ Data/FE6_FE7.c:2438:         unit = GetUnit(i);
	movs	r0, r4	@, i
	bl	.L38		@
@ Data/FE6_FE7.c:2439:         if (UNIT_IS_VALID(unit))
	cmp	r0, #0	@ <retval>,
	beq	.L818		@,
@ Data/FE6_FE7.c:2439:         if (UNIT_IS_VALID(unit))
	ldr	r3, [r0]	@ unit_12->pCharacterData, unit_12->pCharacterData
	cmp	r3, #0	@ unit_12->pCharacterData,
	bne	.L816		@,
.L818:
@ Data/FE6_FE7.c:2436:     for (int i = deployId - 1; i >= allegiance; --i) // should loop back to itself I guess
	subs	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:2436:     for (int i = deployId - 1; i >= allegiance; --i) // should loop back to itself I guess
	cmp	r7, r4	@ allegiance, i
	ble	.L820		@,
.L817:
@ Data/FE6_FE7.c:2444:     for (int i = ((allegiance & 0xC0) + 0x3F); i > deployId; --i) // should loop back to itself I guess
	movs	r4, #192	@ tmp124,
	ands	r4, r7	@ tmp125, allegiance
@ Data/FE6_FE7.c:2444:     for (int i = ((allegiance & 0xC0) + 0x3F); i > deployId; --i) // should loop back to itself I guess
	adds	r4, r4, #63	@ i,
@ Data/FE6_FE7.c:2444:     for (int i = ((allegiance & 0xC0) + 0x3F); i > deployId; --i) // should loop back to itself I guess
	cmp	r5, r4	@ deployId, i
	bge	.L823		@,
	ldr	r6, .L833	@ tmp129,
.L821:
@ Data/FE6_FE7.c:2446:         unit = GetUnit(i);
	movs	r0, r4	@, i
	bl	.L38		@
@ Data/FE6_FE7.c:2447:         if (UNIT_IS_VALID(unit))
	cmp	r0, #0	@ <retval>,
	beq	.L822		@,
@ Data/FE6_FE7.c:2447:         if (UNIT_IS_VALID(unit))
	ldr	r3, [r0]	@ unit_19->pCharacterData, unit_19->pCharacterData
	cmp	r3, #0	@ unit_19->pCharacterData,
	bne	.L816		@,
.L822:
@ Data/FE6_FE7.c:2444:     for (int i = ((allegiance & 0xC0) + 0x3F); i > deployId; --i) // should loop back to itself I guess
	subs	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:2444:     for (int i = ((allegiance & 0xC0) + 0x3F); i > deployId; --i) // should loop back to itself I guess
	cmp	r5, r4	@ deployId, i
	bne	.L821		@,
.L823:
@ Data/FE6_FE7.c:2452:     return NULL;
	movs	r0, #0	@ <retval>,
.L816:
@ Data/FE6_FE7.c:2453: }
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
@ Data/FE6_FE7.c:2458:     int deployId = unit->index & 0xFF;
	movs	r3, #11	@ _2,
@ Data/FE6_FE7.c:2456: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2458:     int deployId = unit->index & 0xFF;
	ldr	r2, [r0, #60]	@ proc_6(D)->unit, proc_6(D)->unit
@ Data/FE6_FE7.c:2456: {
	movs	r4, r0	@ proc, tmp125
@ Data/FE6_FE7.c:2458:     int deployId = unit->index & 0xFF;
	ldrsb	r3, [r2, r3]	@ _2,* _2
	ldrb	r0, [r2, #11]	@ deployId,
@ Data/FE6_FE7.c:2459:     int allegiance = UNIT_FACTION(unit); // 0x00, 0x40, or 0x80
	movs	r2, #192	@ tmp123,
	movs	r1, r2	@ allegiance, tmp123
	ands	r1, r3	@ allegiance, _2
@ Data/FE6_FE7.c:2460:     if (!allegiance)
	tst	r2, r3	@ tmp123, _2
	bne	.L836		@,
@ Data/FE6_FE7.c:2462:         allegiance = 1;
	movs	r1, #1	@ allegiance,
.L836:
@ Data/FE6_FE7.c:2464:     unit = GetPrevUnit(deployId, allegiance);
	bl	GetPrevUnit		@
@ Data/FE6_FE7.c:2465:     if (unit)
	cmp	r0, #0	@ unit,
	beq	.L835		@,
@ Data/FE6_FE7.c:2467:         proc->unit = unit;
	str	r0, [r4, #60]	@ unit, proc_6(D)->unit
.L835:
@ Data/FE6_FE7.c:2469: }
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
@ Data/FE6_FE7.c:2473:     int deployId = unit->index & 0xFF;
	ldr	r3, [r0, #60]	@ proc_5(D)->unit, proc_5(D)->unit
@ Data/FE6_FE7.c:2471: {
	movs	r4, r0	@ proc, tmp127
@ Data/FE6_FE7.c:2474:     int allegiance = UNIT_FACTION(unit);
	movs	r1, #192	@ tmp122,
@ Data/FE6_FE7.c:2473:     int deployId = unit->index & 0xFF;
	movs	r0, #255	@ tmp124,
@ Data/FE6_FE7.c:2473:     int deployId = unit->index & 0xFF;
	ldrb	r3, [r3, #11]	@ _2,
	lsls	r3, r3, #24	@ _2, _2,
	asrs	r3, r3, #24	@ _2, _2,
@ Data/FE6_FE7.c:2474:     int allegiance = UNIT_FACTION(unit);
	ands	r1, r3	@ allegiance, _2
@ Data/FE6_FE7.c:2473:     int deployId = unit->index & 0xFF;
	ands	r0, r3	@ deployId, _2
@ Data/FE6_FE7.c:2475:     unit = GetNextUnit(deployId, allegiance);
	bl	GetNextUnit		@
@ Data/FE6_FE7.c:2476:     if (unit)
	cmp	r0, #0	@ unit,
	beq	.L842		@,
@ Data/FE6_FE7.c:2478:         proc->unit = unit;
	str	r0, [r4, #60]	@ unit, proc_5(D)->unit
.L842:
@ Data/FE6_FE7.c:2480: }
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
@ Data/FE6_FE7.c:2484:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L871	@ tmp155,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r5, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:2483: {
	movs	r4, r0	@ menu, tmp224
@ Data/FE6_FE7.c:2485:     PageMenuItemDrawSprites(menu);
	bl	PageMenuItemDrawSprites		@
@ Data/FE6_FE7.c:2486:     if (!keys)
	cmp	r5, #0	@ keys,
	bne	.L848		@,
.L860:
@ Data/FE6_FE7.c:2488:         return MENU_ITEM_NONE;
	movs	r0, #0	@ <retval>,
.L865:
@ Data/FE6_FE7.c:2546: }
	@ sp needed	@
	pop	{r3, r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L848:
@ Data/FE6_FE7.c:2490:     DebuggerProc * proc = Proc_Find(DebuggerProcCmd);
	ldr	r7, .L871+4	@ tmp157,
	ldr	r0, .L871+8	@ tmp156,
	bl	.L145		@
	movs	r6, r0	@ proc, tmp225
@ Data/FE6_FE7.c:2491:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	ldr	r0, .L871+12	@ tmp159,
	bl	.L145		@
@ Data/FE6_FE7.c:2492:     proc->mainID = menu->itemCurrent;
	movs	r2, #97	@ tmp161,
	ldrsb	r1, [r4, r2]	@ _3,
@ Data/FE6_FE7.c:2492:     proc->mainID = menu->itemCurrent;
	subs	r2, r2, #44	@ tmp162,
	strb	r1, [r6, r2]	@ _3, proc_31->mainID
@ Data/FE6_FE7.c:2493:     procIdler->mainID = menu->itemCurrent;
	strb	r1, [r0, r2]	@ _3, procIdler_33->mainID
@ Data/FE6_FE7.c:2494:     int page = proc->page;
	subs	r2, r2, #1	@ tmp166,
@ Data/FE6_FE7.c:2491:     DebuggerProc * procIdler = Proc_Find(DebuggerProcCmdIdler);
	movs	r3, r0	@ procIdler, tmp226
@ Data/FE6_FE7.c:2494:     int page = proc->page;
	ldrb	r1, [r6, r2]	@ page,
@ Data/FE6_FE7.c:2496:     if (keys & L_BUTTON)
	lsls	r2, r5, #22	@ tmp229, keys,
	bmi	.L868		@,
@ Data/FE6_FE7.c:2507:     if (keys & R_BUTTON)
	lsls	r2, r5, #23	@ tmp230, keys,
	bmi	.L869		@,
	movs	r2, #16	@ tmp202,
	ands	r2, r5	@ _87, keys
@ Data/FE6_FE7.c:2519:     if (keys & DPAD_LEFT)
	lsls	r5, r5, #26	@ tmp231, keys,
	bmi	.L858		@,
@ Data/FE6_FE7.c:2523:     if (keys & DPAD_RIGHT)
	cmp	r2, #0	@ _87,
	beq	.L860		@,
@ Data/FE6_FE7.c:2525:         page++;
	adds	r1, r1, #1	@ page,
.L861:
@ Data/FE6_FE7.c:2533:         if (page >= NumberOfPages)
	ldr	r2, .L871+16	@ tmp215,
@ Data/FE6_FE7.c:2533:         if (page >= NumberOfPages)
	ldr	r0, [r2]	@ NumberOfPages, NumberOfPages
	movs	r2, #0	@ _80,
	cmp	r0, r1	@ NumberOfPages, page
	bgt	.L870		@,
.L862:
@ Data/FE6_FE7.c:2537:         proc->page = page;
	movs	r1, #52	@ tmp218,
@ Data/FE6_FE7.c:2539:         Proc_Goto(proc, RestartLabel);
	movs	r0, r6	@, proc
@ Data/FE6_FE7.c:2537:         proc->page = page;
	strb	r2, [r6, r1]	@ _80, proc_31->page
@ Data/FE6_FE7.c:2538:         procIdler->page = page;
	strb	r2, [r3, r1]	@ _80, procIdler_33->page
@ Data/FE6_FE7.c:2539:         Proc_Goto(proc, RestartLabel);
	ldr	r3, .L871+20	@ tmp222,
	subs	r1, r1, #51	@,
	bl	.L17		@
@ Data/FE6_FE7.c:2505:         return MENU_ACT_SKIPCURSOR | MENU_ACT_CLEAR | MENU_ACT_END | MENU_ACT_SND6A;
	movs	r0, #23	@ <retval>,
	b	.L865		@
.L858:
@ Data/FE6_FE7.c:2523:     if (keys & DPAD_RIGHT)
	cmp	r2, #0	@ _87,
	bne	.L860		@,
@ Data/FE6_FE7.c:2529:         if (page < 0)
	subs	r1, r1, #1	@ page, page
	bcs	.L861		@,
@ Data/FE6_FE7.c:2531:             page = NumberOfPages - 1;
	ldr	r2, .L871+16	@ tmp211,
@ Data/FE6_FE7.c:2531:             page = NumberOfPages - 1;
	ldr	r2, [r2]	@ NumberOfPages, NumberOfPages
	subs	r2, r2, #1	@ page,
@ Data/FE6_FE7.c:2537:         proc->page = page;
	lsls	r2, r2, #24	@ tmp214, page,
	lsrs	r2, r2, #24	@ _80, tmp214,
	b	.L862		@
.L868:
@ Data/FE6_FE7.c:2458:     int deployId = unit->index & 0xFF;
	movs	r3, #11	@ _57,
@ Data/FE6_FE7.c:2458:     int deployId = unit->index & 0xFF;
	ldr	r2, [r6, #60]	@ proc_31->unit, proc_31->unit
@ Data/FE6_FE7.c:2458:     int deployId = unit->index & 0xFF;
	ldrsb	r3, [r2, r3]	@ _57,* _57
	ldrb	r0, [r2, #11]	@ deployId,
@ Data/FE6_FE7.c:2459:     int allegiance = UNIT_FACTION(unit); // 0x00, 0x40, or 0x80
	movs	r2, #192	@ tmp174,
	movs	r1, r2	@ allegiance, tmp174
	ands	r1, r3	@ allegiance, _57
@ Data/FE6_FE7.c:2460:     if (!allegiance)
	tst	r2, r3	@ tmp174, _57
	bne	.L851		@,
@ Data/FE6_FE7.c:2462:         allegiance = 1;
	movs	r1, #1	@ allegiance,
.L851:
@ Data/FE6_FE7.c:2464:     unit = GetPrevUnit(deployId, allegiance);
	bl	GetPrevUnit		@
@ Data/FE6_FE7.c:2465:     if (unit)
	cmp	r0, #0	@ unit,
	beq	.L867		@,
.L856:
@ Data/FE6_FE7.c:2478:         proc->unit = unit;
	str	r0, [r6, #60]	@ unit, proc_31->unit
.L857:
@ Data/FE6_FE7.c:2510:         gActiveUnitMoveOrigin.x = proc->unit->xPos;
	movs	r2, #16	@ tmp194,
@ Data/FE6_FE7.c:2510:         gActiveUnitMoveOrigin.x = proc->unit->xPos;
	ldr	r3, .L871+24	@ tmp192,
@ Data/FE6_FE7.c:2510:         gActiveUnitMoveOrigin.x = proc->unit->xPos;
	ldrsb	r2, [r0, r2]	@ tmp194,
@ Data/FE6_FE7.c:2510:         gActiveUnitMoveOrigin.x = proc->unit->xPos;
	strh	r2, [r3]	@ tmp194, gActiveUnitMoveOrigin.x
@ Data/FE6_FE7.c:2511:         gActiveUnitMoveOrigin.y = proc->unit->yPos;
	movs	r2, #17	@ tmp197,
	ldrsb	r2, [r0, r2]	@ tmp197,
@ Data/FE6_FE7.c:2515:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r6	@, proc
@ Data/FE6_FE7.c:2511:         gActiveUnitMoveOrigin.y = proc->unit->yPos;
	strh	r2, [r3, #2]	@ tmp197, gActiveUnitMoveOrigin.y
@ Data/FE6_FE7.c:2515:         Proc_Goto(proc, RestartLabel);
	ldr	r3, .L871+20	@ tmp198,
	bl	.L17		@
@ Data/FE6_FE7.c:2505:         return MENU_ACT_SKIPCURSOR | MENU_ACT_CLEAR | MENU_ACT_END | MENU_ACT_SND6A;
	movs	r0, #23	@ <retval>,
	b	.L865		@
.L869:
@ Data/FE6_FE7.c:2474:     int allegiance = UNIT_FACTION(unit);
	movs	r1, #192	@ tmp188,
@ Data/FE6_FE7.c:2473:     int deployId = unit->index & 0xFF;
	movs	r0, #255	@ tmp190,
@ Data/FE6_FE7.c:2473:     int deployId = unit->index & 0xFF;
	ldr	r3, [r6, #60]	@ proc_31->unit, proc_31->unit
	ldrb	r3, [r3, #11]	@ _64,
	lsls	r3, r3, #24	@ _64, _64,
	asrs	r3, r3, #24	@ _64, _64,
@ Data/FE6_FE7.c:2474:     int allegiance = UNIT_FACTION(unit);
	ands	r1, r3	@ allegiance, _64
@ Data/FE6_FE7.c:2473:     int deployId = unit->index & 0xFF;
	ands	r0, r3	@ deployId, _64
@ Data/FE6_FE7.c:2475:     unit = GetNextUnit(deployId, allegiance);
	bl	GetNextUnit		@
@ Data/FE6_FE7.c:2476:     if (unit)
	cmp	r0, #0	@ unit,
	bne	.L856		@,
.L867:
@ Data/FE6_FE7.c:2510:         gActiveUnitMoveOrigin.x = proc->unit->xPos;
	ldr	r0, [r6, #60]	@ unit, proc_31->unit
	b	.L857		@
.L870:
@ Data/FE6_FE7.c:2537:         proc->page = page;
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
@ Data/FE6_FE7.c:2556:     if (CheckFlag(flag))
	ldr	r3, .L876	@ tmp116,
@ Data/FE6_FE7.c:2555: {
	movs	r4, r0	@ flag, tmp121
@ Data/FE6_FE7.c:2556:     if (CheckFlag(flag))
	bl	.L17		@
@ Data/FE6_FE7.c:2556:     if (CheckFlag(flag))
	cmp	r0, #0	@ tmp122,
	beq	.L874		@,
@ Data/FE6_FE7.c:2558:         ClearFlag(flag);
	movs	r0, r4	@, flag
	ldr	r3, .L876+4	@ tmp119,
	bl	.L17		@
.L873:
@ Data/FE6_FE7.c:2564: }
	@ sp needed	@
	pop	{r4}
	pop	{r0}
	bx	r0
.L874:
@ Data/FE6_FE7.c:2562:         SetFlag(flag);
	movs	r0, r4	@, flag
	ldr	r3, .L876+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2564: }
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
@ Data/FE6_FE7.c:2615:     int keys = gKeyStatusPtr->newKeys;
	ldr	r3, .L882	@ tmp120,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
@ Data/FE6_FE7.c:2616:     if (!keys)
	ldrh	r3, [r3, #8]	@ tmp121,
	cmp	r3, #0	@ tmp121,
	bne	.L879		@,
.L881:
@ Data/FE6_FE7.c:2618:         return 0;
	movs	r0, #0	@ <retval>,
.L878:
@ Data/FE6_FE7.c:2628: }
	@ sp needed	@
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L879:
@ Data/FE6_FE7.c:2620:     CheatCodeKeyListenerProc * proc = Proc_Find(CheatCodeKeyListenerCmd);
	ldr	r5, .L882+4	@ tmp123,
	ldr	r3, .L882+8	@ tmp124,
	movs	r0, r5	@, tmp123
	bl	.L17		@
	subs	r4, r0, #0	@ proc, tmp130,
@ Data/FE6_FE7.c:2621:     if (proc)
	bne	.L881		@,
@ Data/FE6_FE7.c:2625:     proc = Proc_Start(CheatCodeKeyListenerCmd, PROC_TREE_3);
	movs	r1, #3	@,
	movs	r0, r5	@, tmp123
	ldr	r3, .L882+12	@ tmp127,
	bl	.L17		@
@ Data/FE6_FE7.c:2626:     proc->id = 0;
	str	r4, [r0, #44]	@ proc, proc_10->id
@ Data/FE6_FE7.c:2627:     return true;
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
@ Data/FE6_FE7.c:2772:     PutNumber(tm, color, number);
	ldr	r3, .L885	@ tmp117,
@ Data/FE6_FE7.c:2773: }
	@ sp needed	@
@ Data/FE6_FE7.c:2772:     PutNumber(tm, color, number);
	bl	.L17		@
@ Data/FE6_FE7.c:2773: }
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
@ Data/FE6_FE7.c:2776: {
	movs	r4, r0	@ proc, tmp119
@ Data/FE6_FE7.c:2780: }
	@ sp needed	@
@ Data/FE6_FE7.c:2777:     StartBmPromotion(proc);
	ldr	r3, .L888	@ tmp116,
	bl	.L17		@
@ Data/FE6_FE7.c:2778:     Proc_Goto(proc, PostActionLabel);
	movs	r0, r4	@, proc
	movs	r1, #2	@,
	ldr	r3, .L888+4	@ tmp117,
	bl	.L17		@
@ Data/FE6_FE7.c:2780: }
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
@ Data/FE6_FE7.c:2782: {
	movs	r4, r0	@ proc, tmp119
@ Data/FE6_FE7.c:2786: }
	@ sp needed	@
@ Data/FE6_FE7.c:2783:     StartArenaScreen();
	ldr	r3, .L891	@ tmp116,
	bl	.L17		@
@ Data/FE6_FE7.c:2784:     Proc_Goto(proc, PostActionLabel);
	movs	r0, r4	@, proc
	movs	r1, #2	@,
	ldr	r3, .L891+4	@ tmp117,
	bl	.L17		@
@ Data/FE6_FE7.c:2786: }
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
@ Data/FE6_FE7.c:2807:     gActiveUnit->exp = 99;
	ldr	r3, .L900	@ tmp122,
	ldr	r1, [r3]	@ gActiveUnit.79_1, gActiveUnit
@ Data/FE6_FE7.c:2807:     gActiveUnit->exp = 99;
	movs	r3, #99	@ tmp123,
@ Data/FE6_FE7.c:2805: {
	push	{r4, r5, r6, lr}	@
@ Data/FE6_FE7.c:2808:     InitBattleUnit(&gBattleActor, gActiveUnit);
	ldr	r4, .L900+4	@ tmp125,
@ Data/FE6_FE7.c:2807:     gActiveUnit->exp = 99;
	strb	r3, [r1, #9]	@ tmp123, gActiveUnit.79_1->exp
@ Data/FE6_FE7.c:2805: {
	movs	r5, r0	@ proc, tmp172
@ Data/FE6_FE7.c:2808:     InitBattleUnit(&gBattleActor, gActiveUnit);
	ldr	r3, .L900+8	@ tmp126,
	movs	r0, r4	@, tmp125
	bl	.L17		@
@ Data/FE6_FE7.c:2813:     if (CanBattleUnitGainLevels(&gBattleActor))
	movs	r0, r4	@, tmp125
	ldr	r3, .L900+12	@ tmp128,
	bl	.L17		@
@ Data/FE6_FE7.c:2813:     if (CanBattleUnitGainLevels(&gBattleActor))
	cmp	r0, #0	@ tmp173,
	beq	.L894		@,
@ Data/FE6_FE7.c:2816:         if (!(gPlaySt.chapterStateBits & PLAY_FLAG_EXTRA_MAP))
	ldr	r3, .L900+16	@ tmp131,
@ Data/FE6_FE7.c:2816:         if (!(gPlaySt.chapterStateBits & PLAY_FLAG_EXTRA_MAP))
	ldrb	r3, [r3, #20]	@ tmp134,
	cmp	r3, #127	@ tmp134,
	bls	.L899		@,
.L894:
@ Data/FE6_FE7.c:2843:     Proc_Goto(proc, PostActionLabel);
	movs	r1, #2	@,
	movs	r0, r5	@, proc
	ldr	r3, .L900+20	@ tmp170,
	bl	.L17		@
.L895:
@ Data/FE6_FE7.c:2846: }
	@ sp needed	@
	movs	r0, #0	@,
	pop	{r4, r5, r6}
	pop	{r1}
	bx	r1
.L899:
@ Data/FE6_FE7.c:2819:             gBattleActor.expGain = 1;
	movs	r6, #1	@ tmp137,
	movs	r3, #110	@ tmp136,
	strb	r6, [r4, r3]	@ tmp137, gBattleActor.expGain
@ Data/FE6_FE7.c:2820:             gBattleActor.unit.exp += 1;
	ldrb	r3, [r4, #9]	@ tmp142,
	adds	r3, r3, #1	@ tmp143,
@ Data/FE6_FE7.c:2822:             CheckBattleUnitLevelUp(&gBattleActor);
	movs	r0, r4	@, tmp125
@ Data/FE6_FE7.c:2820:             gBattleActor.unit.exp += 1;
	strb	r3, [r4, #9]	@ tmp143, gBattleActor.unit.exp
@ Data/FE6_FE7.c:2822:             CheckBattleUnitLevelUp(&gBattleActor);
	ldr	r3, .L900+24	@ tmp146,
	bl	.L17		@
@ Data/FE6_FE7.c:2825:             MU_EndAll();
	ldr	r3, .L900+28	@ tmp147,
	bl	.L17		@
@ Data/FE6_FE7.c:2826:             ResetText();
	ldr	r3, .L900+32	@ tmp148,
	bl	.L17		@
@ Data/FE6_FE7.c:2828:             gBattleActor.weaponBefore = 1; // see BeginMapAnimForSummon
	movs	r3, #74	@ tmp150,
@ Data/FE6_FE7.c:2831:             gManimSt.u62 = 0;
	movs	r2, #98	@ tmp154,
	movs	r1, #0	@ tmp155,
@ Data/FE6_FE7.c:2828:             gBattleActor.weaponBefore = 1; // see BeginMapAnimForSummon
	strh	r6, [r4, r3]	@ tmp137, gBattleActor.weaponBefore
@ Data/FE6_FE7.c:2831:             gManimSt.u62 = 0;
	ldr	r3, .L900+36	@ tmp153,
	strb	r1, [r3, r2]	@ tmp155, gManimSt.u62
@ Data/FE6_FE7.c:2832:             gManimSt.actorCount_maybe = 1;
	subs	r2, r2, #4	@ tmp158,
@ Data/FE6_FE7.c:2834:             gManimSt.subjectActorId = 0;
	adds	r1, r1, #1	@ tmp163,
@ Data/FE6_FE7.c:2832:             gManimSt.actorCount_maybe = 1;
	strh	r6, [r3, r2]	@ tmp137, MEM <vector(2) unsigned char> [(unsigned char *)&gManimSt + 94B]
@ Data/FE6_FE7.c:2834:             gManimSt.subjectActorId = 0;
	adds	r1, r1, #255	@ tmp163,
	subs	r2, r2, #6	@ tmp162,
	strh	r1, [r3, r2]	@ tmp163, MEM <vector(2) unsigned char> [(unsigned char *)&gManimSt + 88B]
@ Data/FE6_FE7.c:2837:             SetupMapBattleAnim(&gBattleActor, &gBattleTarget, gBattleHitArray);
	movs	r0, r4	@, tmp125
	ldr	r2, .L900+40	@ tmp165,
	ldr	r1, .L900+44	@ tmp166,
	ldr	r3, .L900+48	@ tmp168,
	bl	.L17		@
@ Data/FE6_FE7.c:2839:             Proc_Goto(proc, LevelupLabel);
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
@ Data/FE6_FE7.c:2880:     switch (proc->actionID)
	movs	r3, #47	@ tmp117,
@ Data/FE6_FE7.c:2879: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2880:     switch (proc->actionID)
	ldrb	r3, [r0, r3]	@ _1,
@ Data/FE6_FE7.c:2879: {
	movs	r4, r0	@ proc, tmp126
@ Data/FE6_FE7.c:2880:     switch (proc->actionID)
	cmp	r3, #2	@ _1,
	beq	.L903		@,
	cmp	r3, #3	@ _1,
	beq	.L904		@,
	cmp	r3, #1	@ _1,
	bne	.L905		@,
@ Data/FE6_FE7.c:2777:     StartBmPromotion(proc);
	ldr	r3, .L906	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2778:     Proc_Goto(proc, PostActionLabel);
	movs	r1, #2	@,
	movs	r0, r4	@, proc
	ldr	r3, .L906+4	@ tmp119,
	bl	.L17		@
.L905:
@ Data/FE6_FE7.c:2902: }
	@ sp needed	@
@ Data/FE6_FE7.c:2900:     proc->actionID = 0;
	movs	r3, #47	@ tmp122,
	movs	r2, #0	@ tmp123,
@ Data/FE6_FE7.c:2902: }
	movs	r0, #0	@,
@ Data/FE6_FE7.c:2900:     proc->actionID = 0;
	strb	r2, [r4, r3]	@ tmp123, proc_4(D)->actionID
@ Data/FE6_FE7.c:2902: }
	pop	{r4}
	pop	{r1}
	bx	r1
.L904:
@ Data/FE6_FE7.c:2894:             LevelupAction(proc);
	bl	LevelupAction		@
@ Data/FE6_FE7.c:2895:             break;
	b	.L905		@
.L903:
@ Data/FE6_FE7.c:2783:     StartArenaScreen();
	ldr	r3, .L906+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2784:     Proc_Goto(proc, PostActionLabel);
	movs	r1, #2	@,
	movs	r0, r4	@, proc
	ldr	r3, .L906+4	@ tmp121,
	bl	.L17		@
@ Data/FE6_FE7.c:2785:     return 0;
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
@ Data/FE6_FE7.c:2851:         GetUnit(gActionData.subjectIndex)->items[gActionData.itemSlotIndex];
	ldr	r5, .L909	@ tmp126,
@ Data/FE6_FE7.c:2858: }
	@ sp needed	@
@ Data/FE6_FE7.c:2851:         GetUnit(gActionData.subjectIndex)->items[gActionData.itemSlotIndex];
	ldr	r7, .L909+4	@ tmp128,
	ldrb	r0, [r5, #12]	@ tmp127,
	bl	.L145		@
@ Data/FE6_FE7.c:2851:         GetUnit(gActionData.subjectIndex)->items[gActionData.itemSlotIndex];
	ldrb	r3, [r5, #18]	@ tmp130,
@ Data/FE6_FE7.c:2851:         GetUnit(gActionData.subjectIndex)->items[gActionData.itemSlotIndex];
	adds	r3, r3, #12	@ tmp131,
	lsls	r3, r3, #1	@ tmp132, tmp131,
	adds	r0, r0, r3	@ tmp133, tmp166, tmp132
@ Data/FE6_FE7.c:2850:     gBattleActor.weaponBefore = gBattleTarget.weaponBefore =
	movs	r3, #74	@ tmp136,
@ Data/FE6_FE7.c:2851:         GetUnit(gActionData.subjectIndex)->items[gActionData.itemSlotIndex];
	ldrh	r2, [r0, #6]	@ _6, *_3
@ Data/FE6_FE7.c:2850:     gBattleActor.weaponBefore = gBattleTarget.weaponBefore =
	ldr	r6, .L909+8	@ tmp138,
@ Data/FE6_FE7.c:2850:     gBattleActor.weaponBefore = gBattleTarget.weaponBefore =
	ldr	r4, .L909+12	@ tmp135,
@ Data/FE6_FE7.c:2850:     gBattleActor.weaponBefore = gBattleTarget.weaponBefore =
	strh	r2, [r6, r3]	@ _6, gBattleActor.weaponBefore
@ Data/FE6_FE7.c:2850:     gBattleActor.weaponBefore = gBattleTarget.weaponBefore =
	strh	r2, [r4, r3]	@ _6, gBattleTarget.weaponBefore
@ Data/FE6_FE7.c:2853:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	ldrb	r0, [r5, #12]	@ tmp142,
	bl	.L145		@
@ Data/FE6_FE7.c:2853:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	ldr	r3, .L909+16	@ tmp144,
	bl	.L17		@
@ Data/FE6_FE7.c:2853:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	movs	r3, #72	@ tmp147,
@ Data/FE6_FE7.c:2854:     gBattleActor.hasItemEffectTarget = 0;
	movs	r2, #0	@ tmp154,
@ Data/FE6_FE7.c:2853:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	lsls	r0, r0, #16	@ tmp145, tmp168,
	lsrs	r0, r0, #16	@ _11, tmp145,
@ Data/FE6_FE7.c:2853:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	strh	r0, [r6, r3]	@ _11, gBattleActor.weapon
@ Data/FE6_FE7.c:2853:     gBattleActor.weapon = gBattleTarget.weapon = GetUnitEquippedWeapon(GetUnit(gActionData.subjectIndex));
	strh	r0, [r4, r3]	@ _11, gBattleTarget.weapon
@ Data/FE6_FE7.c:2854:     gBattleActor.hasItemEffectTarget = 0;
	adds	r3, r3, #54	@ tmp153,
	strb	r2, [r6, r3]	@ tmp154, gBattleActor.hasItemEffectTarget
@ Data/FE6_FE7.c:2855:     gBattleTarget.statusOut = -1;
	adds	r2, r2, #255	@ tmp158,
	subs	r3, r3, #15	@ tmp157,
	strb	r2, [r4, r3]	@ tmp158, gBattleTarget.statusOut
@ Data/FE6_FE7.c:2856:     gActionData.unitActionType = 1;
	subs	r3, r3, #110	@ tmp161,
	strb	r3, [r5, #17]	@ tmp161, gActionData.unitActionType
@ Data/FE6_FE7.c:2857:     UnitBeginAction(gActiveUnit);
	ldr	r3, .L909+20	@ tmp163,
	ldr	r0, [r3]	@ gActiveUnit, gActiveUnit
	ldr	r3, .L909+24	@ tmp165,
	bl	.L17		@
@ Data/FE6_FE7.c:2858: }
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
@ Data/FE6_FE7.c:2861: {
	movs	r4, r0	@ proc, tmp157
@ Data/FE6_FE7.c:2863:     SetupUnitFunc();
	bl	SetupUnitFunc		@
@ Data/FE6_FE7.c:2866:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	ldr	r7, .L916	@ tmp133,
@ Data/FE6_FE7.c:2866:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	ldr	r6, .L916+4	@ tmp135,
	ldrb	r0, [r7, #12]	@ tmp134,
	bl	.L38		@
@ Data/FE6_FE7.c:2866:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	movs	r5, #16	@ _4,
	ldrsb	r5, [r0, r5]	@ _4,* _4
@ Data/FE6_FE7.c:2866:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	ldrb	r0, [r7, #12]	@ tmp137,
	bl	.L38		@
@ Data/FE6_FE7.c:2866:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	movs	r2, #17	@ _9,
@ Data/FE6_FE7.c:1998:     if (y < 0)
	movs	r3, r5	@ tmp143, _4
@ Data/FE6_FE7.c:2866:         proc, GetUnit(gActionData.subjectIndex)->xPos, GetUnit(gActionData.subjectIndex)->yPos);
	ldrsb	r2, [r0, r2]	@ _9,* _9
	movs	r0, #1	@ <retval>,
@ Data/FE6_FE7.c:1998:     if (y < 0)
	orrs	r3, r2	@ tmp143, _9
	bmi	.L911		@,
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	ldr	r3, .L916+8	@ tmp145,
	movs	r6, #0	@ tmp162,
	ldrsh	r1, [r3, r6]	@ gBmMapSize, tmp145, tmp162
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	cmp	r5, r1	@ _4, gBmMapSize
	bge	.L911		@,
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	movs	r1, #2	@ tmp163,
	ldrsh	r3, [r3, r1]	@ tmp148, tmp145, tmp163
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	cmp	r2, r3	@ _9, tmp148
	bge	.L911		@,
@ Data/FE6_FE7.c:2018:     return EnsureCameraOntoPosition(proc, x, y);
	ldr	r3, .L916+12	@ tmp149,
	movs	r1, r5	@, _4
	movs	r0, r4	@, proc
	bl	.L17		@
@ Data/FE6_FE7.c:2867:     cameraReturn ^= 1;
	movs	r3, #1	@ tmp152,
	eors	r0, r3	@ tmp154, tmp152
@ Data/FE6_FE7.c:2875:     return cameraReturn;
	lsls	r0, r0, #24	@ tmp155, tmp154,
	asrs	r0, r0, #24	@ <retval>, tmp155,
.L911:
@ Data/FE6_FE7.c:2876: }
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
@ Data/FE6_FE7.c:2906:     if (gPlaySt.chapterVisionRange != 0)
	ldr	r4, .L926	@ tmp187,
@ Data/FE6_FE7.c:2906:     if (gPlaySt.chapterVisionRange != 0)
	ldrb	r3, [r4, #13]	@ tmp142,
	cmp	r3, #0	@ tmp142,
	beq	.L919		@,
@ Data/FE6_FE7.c:2908:         RenderBmMapOnBg2();
	ldr	r3, .L926+4	@ tmp143,
	bl	.L17		@
@ Data/FE6_FE7.c:2910:         MoveActiveUnit(gActionData.xMove, gActionData.yMove);
	ldr	r3, .L926+8	@ tmp144,
@ Data/FE6_FE7.c:2910:         MoveActiveUnit(gActionData.xMove, gActionData.yMove);
	ldrb	r1, [r3, #15]	@ tmp145,
	ldrb	r0, [r3, #14]	@ tmp147,
	ldr	r3, .L926+12	@ tmp148,
	bl	.L17		@
@ Data/FE6_FE7.c:2912:         RefreshEntityBmMaps();
	ldr	r3, .L926+16	@ tmp149,
	bl	.L17		@
@ Data/FE6_FE7.c:2913:         RenderBmMap();
	ldr	r3, .L926+20	@ tmp150,
	bl	.L17		@
@ Data/FE6_FE7.c:2915:         NewBMXFADE(0);
	ldr	r3, .L926+24	@ tmp151,
	movs	r0, #0	@,
	bl	.L17		@
@ Data/FE6_FE7.c:2917:         RefreshUnitSprites();
	ldr	r3, .L926+28	@ tmp152,
	bl	.L17		@
.L920:
@ Data/FE6_FE7.c:2926:     if (gActiveUnit->curHP != 0)
	movs	r2, #19	@ tmp161,
@ Data/FE6_FE7.c:2926:     if (gActiveUnit->curHP != 0)
	ldr	r3, .L926+32	@ tmp160,
	ldr	r3, [r3]	@ gActiveUnit.82_10, gActiveUnit
@ Data/FE6_FE7.c:2926:     if (gActiveUnit->curHP != 0)
	ldrsb	r2, [r3, r2]	@ tmp161,
	cmp	r2, #0	@ tmp161,
	beq	.L921		@,
@ Data/FE6_FE7.c:2927:         gActiveUnit->state = gActiveUnit->state & ~US_HIDDEN;
	movs	r1, #1	@ tmp164,
	ldr	r2, [r3, #12]	@ gActiveUnit.82_10->state, gActiveUnit.82_10->state
	bics	r2, r1	@ tmp162, tmp164
@ Data/FE6_FE7.c:2927:         gActiveUnit->state = gActiveUnit->state & ~US_HIDDEN;
	str	r2, [r3, #12]	@ tmp162, gActiveUnit.82_10->state
.L921:
@ Data/FE6_FE7.c:2929:     SetCursorMapPositionIfValid(gActiveUnit->xPos, gActiveUnit->yPos);
	movs	r0, #16	@ _14,
@ Data/FE6_FE7.c:2929:     SetCursorMapPositionIfValid(gActiveUnit->xPos, gActiveUnit->yPos);
	movs	r1, #17	@ _16,
@ Data/FE6_FE7.c:2929:     SetCursorMapPositionIfValid(gActiveUnit->xPos, gActiveUnit->yPos);
	ldrsb	r0, [r3, r0]	@ _14,* _14
@ Data/FE6_FE7.c:2929:     SetCursorMapPositionIfValid(gActiveUnit->xPos, gActiveUnit->yPos);
	ldrsb	r1, [r3, r1]	@ _16,* _16
@ Data/FE6_FE7.c:1998:     if (y < 0)
	movs	r3, r0	@ tmp169, _14
	orrs	r3, r1	@ tmp169, _16
	bmi	.L922		@,
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	ldr	r3, .L926+36	@ tmp171,
	movs	r5, #0	@ tmp189,
	ldrsh	r2, [r3, r5]	@ gBmMapSize, tmp171, tmp189
@ Data/FE6_FE7.c:2002:     if (x >= gBmMapSize.x)
	cmp	r0, r2	@ _14, gBmMapSize
	bge	.L922		@,
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	movs	r2, #2	@ tmp190,
	ldrsh	r3, [r3, r2]	@ tmp174, tmp171, tmp190
@ Data/FE6_FE7.c:2006:     if (y >= gBmMapSize.y)
	cmp	r1, r3	@ _16, tmp174
	bge	.L922		@,
@ Data/FE6_FE7.c:2026:     SetCursorMapPosition(x, y);
	ldr	r3, .L926+40	@ tmp175,
	bl	.L17		@
.L922:
@ Data/FE6_FE7.c:2937: }
	@ sp needed	@
@ Data/FE6_FE7.c:2931:     gPlaySt.xCursor = gBmSt.playerCursor.x;
	ldr	r3, .L926+44	@ tmp177,
@ Data/FE6_FE7.c:2931:     gPlaySt.xCursor = gBmSt.playerCursor.x;
	ldrh	r2, [r3, #20]	@ tmp180,
	strb	r2, [r4, #18]	@ tmp180, gPlaySt.xCursor
@ Data/FE6_FE7.c:2932:     gPlaySt.yCursor = gBmSt.playerCursor.y;
	ldrh	r3, [r3, #22]	@ tmp185,
	strb	r3, [r4, #19]	@ tmp185, gPlaySt.yCursor
@ Data/FE6_FE7.c:2934:     MU_EndAll();
	ldr	r3, .L926+48	@ tmp186,
	bl	.L17		@
@ Data/FE6_FE7.c:2937: }
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L919:
@ Data/FE6_FE7.c:2921:         MoveActiveUnit(gActionData.xMove, gActionData.yMove);
	ldr	r3, .L926+8	@ tmp153,
@ Data/FE6_FE7.c:2921:         MoveActiveUnit(gActionData.xMove, gActionData.yMove);
	ldrb	r1, [r3, #15]	@ tmp154,
	ldrb	r0, [r3, #14]	@ tmp156,
	ldr	r3, .L926+12	@ tmp157,
	bl	.L17		@
@ Data/FE6_FE7.c:2923:         RefreshEntityBmMaps();
	ldr	r3, .L926+16	@ tmp158,
	bl	.L17		@
@ Data/FE6_FE7.c:2924:         RenderBmMap();
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
@ Data/FE6_FE7.c:2941:     PlayerPhase_FinishActionNoCanto(proc);
	bl	PlayerPhase_FinishActionNoCanto		@
@ Data/FE6_FE7.c:2944: }
	@ sp needed	@
@ Data/FE6_FE7.c:2942:     ProcPtr playerPhaseProc = Proc_Find(gProcScr_PlayerPhase);
	ldr	r3, .L929	@ tmp117,
	ldr	r0, .L929+4	@ tmp116,
	bl	.L17		@
@ Data/FE6_FE7.c:2943:     Proc_Goto(playerPhaseProc, 0);
	movs	r1, #0	@,
	ldr	r3, .L929+8	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2944: }
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
@ Data/FE6_FE7.c:2948:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r3, .L936	@ tmp128,
	movs	r1, #11	@ tmp129,
	ldr	r2, [r3]	@ gActiveUnit.87_1, gActiveUnit
	movs	r3, #192	@ tmp130,
	ldrsb	r1, [r2, r1]	@ tmp129,
	ands	r3, r1	@ tmp131, tmp129
@ Data/FE6_FE7.c:2948:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r1, .L936+4	@ tmp132,
	ldrb	r1, [r1, #15]	@ tmp133,
@ Data/FE6_FE7.c:2948:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	cmp	r3, r1	@ tmp131, tmp133
	bne	.L934		@,
@ Data/FE6_FE7.c:2953:     int promoted = UNIT_CATTRIBUTES(gActiveUnit) & CA_PROMOTED;
	ldr	r3, [r2]	@ gActiveUnit.87_1->pCharacterData, gActiveUnit.87_1->pCharacterData
	ldr	r1, [r2, #4]	@ _9, gActiveUnit.87_1->pClassData
	ldr	r3, [r3, #40]	@ _7->attributes, _7->attributes
	ldr	r2, [r1, #40]	@ _9->attributes, _9->attributes
	orrs	r3, r2	@ tmp135, _9->attributes
@ Data/FE6_FE7.c:2954:     if (promoted)
	lsls	r3, r3, #23	@ tmp144, tmp135,
	bmi	.L934		@,
@ Data/FE6_FE7.c:2959:     if (!promotionClass)
	ldrb	r0, [r1, #5]	@ tmp140,
@ Data/FE6_FE7.c:2964:     return usable;
	rsbs	r3, r0, #0	@ tmp143, tmp140
	adcs	r0, r0, r3	@ tmp142, tmp140, tmp143
	adds	r0, r0, #1	@ <retval>,
.L932:
@ Data/FE6_FE7.c:2965: }
	@ sp needed	@
	bx	lr
.L934:
@ Data/FE6_FE7.c:2950:         return greyed;
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
@ Data/FE6_FE7.c:2948:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r3, .L943	@ tmp130,
	movs	r1, #11	@ tmp131,
	ldr	r2, [r3]	@ gActiveUnit.87_3, gActiveUnit
	movs	r3, #192	@ tmp132,
	ldrsb	r1, [r2, r1]	@ tmp131,
	ands	r3, r1	@ tmp133, tmp131
@ Data/FE6_FE7.c:2948:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	ldr	r1, .L943+4	@ tmp134,
	ldrb	r1, [r1, #15]	@ tmp135,
@ Data/FE6_FE7.c:2948:     if (UNIT_FACTION(gActiveUnit) != gPlaySt.faction)
	cmp	r3, r1	@ tmp133, tmp135
	bne	.L941		@,
@ Data/FE6_FE7.c:2953:     int promoted = UNIT_CATTRIBUTES(gActiveUnit) & CA_PROMOTED;
	ldr	r3, [r2]	@ gActiveUnit.87_3->pCharacterData, gActiveUnit.87_3->pCharacterData
	ldr	r1, [r2, #4]	@ _11, gActiveUnit.87_3->pClassData
	ldr	r3, [r3, #40]	@ _9->attributes, _9->attributes
	ldr	r2, [r1, #40]	@ _11->attributes, _11->attributes
	orrs	r3, r2	@ tmp137, _11->attributes
@ Data/FE6_FE7.c:2954:     if (promoted)
	lsls	r3, r3, #23	@ tmp146, tmp137,
	bmi	.L941		@,
@ Data/FE6_FE7.c:2959:     if (!promotionClass)
	ldrb	r0, [r1, #5]	@ tmp142,
@ Data/FE6_FE7.c:2964:     return usable;
	rsbs	r3, r0, #0	@ tmp145, tmp142
	adcs	r0, r0, r3	@ tmp144, tmp142, tmp145
	adds	r0, r0, #1	@ <retval>,
.L939:
@ Data/FE6_FE7.c:2969: }
	@ sp needed	@
	bx	lr
.L941:
@ Data/FE6_FE7.c:2950:         return greyed;
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
@ Data/FE6_FE7.c:2973:     if (ArenaIsUnitAllowed(gActiveUnit))
	ldr	r3, .L948	@ tmp119,
@ Data/FE6_FE7.c:2972: {
	push	{r4, lr}	@
@ Data/FE6_FE7.c:2973:     if (ArenaIsUnitAllowed(gActiveUnit))
	ldr	r0, [r3]	@ gActiveUnit, gActiveUnit
@ Data/FE6_FE7.c:2978: }
	@ sp needed	@
@ Data/FE6_FE7.c:2973:     if (ArenaIsUnitAllowed(gActiveUnit))
	ldr	r3, .L948+4	@ tmp121,
	bl	.L17		@
@ Data/FE6_FE7.c:2977:     return greyed;
	rsbs	r3, r0, #0	@ tmp126, tmp127
	adcs	r0, r0, r3	@ tmp125, tmp127, tmp126
	adds	r0, r0, #1	@ <retval>,
@ Data/FE6_FE7.c:2978: }
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
@ Data/FE6_FE7.c:2984:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L951	@ tmp119,
@ Data/FE6_FE7.c:2992: }
	@ sp needed	@
@ Data/FE6_FE7.c:2984:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L951+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2985:     Proc_Goto(proc, EndLabel);
	movs	r1, #99	@,
	ldr	r3, .L951+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:2989:     CallEndEvent();
	ldr	r3, .L951+12	@ tmp121,
	bl	.L17		@
@ Data/FE6_FE7.c:2992: }
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
@ Data/FE6_FE7.c:2997:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L954	@ tmp119,
@ Data/FE6_FE7.c:3000: }
	@ sp needed	@
@ Data/FE6_FE7.c:2997:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L954+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:2998:     Proc_Goto(proc, WExpLabel);
	movs	r1, #16	@,
	ldr	r3, .L954+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:3000: }
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
@ Data/FE6_FE7.c:3005:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L957	@ tmp119,
@ Data/FE6_FE7.c:3008: }
	@ sp needed	@
@ Data/FE6_FE7.c:3005:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L957+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:3006:     Proc_Goto(proc, SupportLabel);
	movs	r1, #17	@,
	ldr	r3, .L957+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:3008: }
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
	movs	r3, r0	@ ivtmp.930, proc
	ldr	r2, [r0, #60]	@ proc_6(D)->unit, proc_6(D)->unit
	adds	r3, r3, #64	@ ivtmp.930,
	adds	r2, r2, #40	@ ivtmp.932,
	adds	r0, r0, #80	@ _24,
.L960:
@ Data/FE6_FE7.c:3136:         unit->ranks[i] = proc->tmp[i];
	ldrh	r1, [r3]	@ MEM[(short int *)_21], MEM[(short int *)_21]
@ Data/FE6_FE7.c:3134:     for (int i = 0; i < WExpOptions; ++i)
	adds	r3, r3, #2	@ ivtmp.930,
@ Data/FE6_FE7.c:3136:         unit->ranks[i] = proc->tmp[i];
	strb	r1, [r2]	@ MEM[(short int *)_21], MEM[(unsigned char *)_22]
@ Data/FE6_FE7.c:3134:     for (int i = 0; i < WExpOptions; ++i)
	adds	r2, r2, #1	@ ivtmp.932,
	cmp	r3, r0	@ ivtmp.930, _24
	bne	.L960		@,
@ Data/FE6_FE7.c:3138: }
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
@ Data/FE6_FE7.c:3142:     gLCDControlBuffer.bg1cnt.priority = 0;
	movs	r1, #3	@ tmp121,
@ Data/FE6_FE7.c:3141: {
	push	{lr}	@
@ Data/FE6_FE7.c:3142:     gLCDControlBuffer.bg1cnt.priority = 0;
	ldr	r2, .L963	@ tmp115,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp120, tmp121
@ Data/FE6_FE7.c:3141: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:3142:     gLCDControlBuffer.bg1cnt.priority = 0;
	strb	r3, [r2, #16]	@ tmp120, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3143:     SetBackgroundTileDataOffset(2, 0);
	movs	r1, #0	@,
	movs	r0, #2	@,
	ldr	r3, .L963+4	@ tmp123,
	bl	.L17		@
@ Data/FE6_FE7.c:3144:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp124,
	movs	r2, #0	@,
	str	r3, [sp]	@ tmp124,
	movs	r1, #1	@,
	movs	r0, #0	@,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3145:     BG_Fill(gBG2TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L963+8	@ tmp125,
	ldr	r3, .L963+12	@ tmp126,
	bl	.L17		@
@ Data/FE6_FE7.c:3146:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT);
	movs	r0, #7	@,
	ldr	r3, .L963+16	@ tmp127,
	bl	.L17		@
@ Data/FE6_FE7.c:3147: }
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
@ Data/FE6_FE7.c:3151:     if (wexp < WPN_EXP_E)
	cmp	r0, #0	@ wexp,
	ble	.L967		@,
@ Data/FE6_FE7.c:3154:     if (wexp < WPN_EXP_D)
	cmp	r0, #30	@ wexp,
	ble	.L968		@,
@ Data/FE6_FE7.c:3157:     if (wexp < WPN_EXP_C)
	cmp	r0, #70	@ wexp,
	ble	.L969		@,
@ Data/FE6_FE7.c:3160:     if (wexp < WPN_EXP_B)
	cmp	r0, #120	@ wexp,
	ble	.L970		@,
@ Data/FE6_FE7.c:3163:     if (wexp < WPN_EXP_A)
	cmp	r0, #180	@ wexp,
	ble	.L971		@,
@ Data/FE6_FE7.c:3166:     if (wexp < WPN_EXP_S)
	cmp	r0, #250	@ wexp,
	ble	.L972		@,
@ Data/FE6_FE7.c:3169:     return WPN_LEVEL_S;
	movs	r0, #6	@ <retval>,
	b	.L965		@
.L968:
@ Data/FE6_FE7.c:3155:         return WPN_LEVEL_E;
	movs	r0, #1	@ <retval>,
.L965:
@ Data/FE6_FE7.c:3170: }
	@ sp needed	@
	bx	lr
.L967:
@ Data/FE6_FE7.c:3152:         return WPN_LEVEL_0;
	movs	r0, #0	@ <retval>,
	b	.L965		@
.L972:
@ Data/FE6_FE7.c:3167:         return WPN_LEVEL_A;
	movs	r0, #5	@ <retval>,
	b	.L965		@
.L969:
@ Data/FE6_FE7.c:3158:         return WPN_LEVEL_D;
	movs	r0, #2	@ <retval>,
	b	.L965		@
.L970:
@ Data/FE6_FE7.c:3161:         return WPN_LEVEL_C;
	movs	r0, #3	@ <retval>,
	b	.L965		@
.L971:
@ Data/FE6_FE7.c:3164:         return WPN_LEVEL_B;
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
@ Data/FE6_FE7.c:3151:     if (wexp < WPN_EXP_E)
	cmp	r0, #0	@ wexp,
	ble	.L980		@,
@ Data/FE6_FE7.c:3154:     if (wexp < WPN_EXP_D)
	cmp	r0, #30	@ wexp,
	ble	.L975		@,
@ Data/FE6_FE7.c:3157:     if (wexp < WPN_EXP_C)
	cmp	r0, #70	@ wexp,
	ble	.L976		@,
@ Data/FE6_FE7.c:3160:     if (wexp < WPN_EXP_B)
	cmp	r0, #120	@ wexp,
	ble	.L977		@,
@ Data/FE6_FE7.c:3163:     if (wexp < WPN_EXP_A)
	cmp	r0, #180	@ wexp,
	ble	.L978		@,
@ Data/FE6_FE7.c:3166:     if (wexp < WPN_EXP_S)
	cmp	r0, #250	@ wexp,
	ble	.L981		@,
.L980:
	movs	r0, #0	@ _2,
	movs	r3, #0	@ _11,
	b	.L974		@
.L975:
@ Data/FE6_FE7.c:3185:             return;
	movs	r3, #30	@ _11,
@ Data/FE6_FE7.c:3183:             *outValue = wexp - WPN_EXP_E;
	subs	r0, r0, #1	@ _2,
.L974:
@ Data/FE6_FE7.c:3203:             *outValue = wexp - WPN_EXP_A;
	str	r0, [r1]	@ _2, *outValue_10(D)
@ Data/FE6_FE7.c:3213: }
	@ sp needed	@
@ Data/FE6_FE7.c:3204:             *outMax = WPN_EXP_S - WPN_EXP_A;
	str	r3, [r2]	@ _11, *outMax_12(D)
@ Data/FE6_FE7.c:3213: }
	bx	lr
.L981:
@ Data/FE6_FE7.c:3205:             return;
	movs	r3, #70	@ _11,
@ Data/FE6_FE7.c:3203:             *outValue = wexp - WPN_EXP_A;
	subs	r0, r0, #181	@ _2,
@ Data/FE6_FE7.c:3205:             return;
	b	.L974		@
.L978:
@ Data/FE6_FE7.c:3200:             return;
	movs	r3, #60	@ _11,
@ Data/FE6_FE7.c:3198:             *outValue = wexp - WPN_EXP_B;
	subs	r0, r0, #121	@ _2,
@ Data/FE6_FE7.c:3200:             return;
	b	.L974		@
.L977:
@ Data/FE6_FE7.c:3195:             return;
	movs	r3, #50	@ _11,
@ Data/FE6_FE7.c:3193:             *outValue = wexp - WPN_EXP_C;
	subs	r0, r0, #71	@ _2,
@ Data/FE6_FE7.c:3195:             return;
	b	.L974		@
.L976:
@ Data/FE6_FE7.c:3190:             return;
	movs	r3, #40	@ _11,
@ Data/FE6_FE7.c:3188:             *outValue = wexp - WPN_EXP_D;
	subs	r0, r0, #31	@ _2,
@ Data/FE6_FE7.c:3190:             return;
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
@ Data/FE6_FE7.c:3063:     UnpackUiBarPalette(BGPAL_WEXP_BAR);
	ldr	r3, .L985	@ tmp145,
@ Data/FE6_FE7.c:3061: {
	movs	r6, r0	@ num, tmp202
@ Data/FE6_FE7.c:3063:     UnpackUiBarPalette(BGPAL_WEXP_BAR);
	movs	r0, #2	@,
@ Data/FE6_FE7.c:3061: {
	movs	r5, r1	@ x, tmp203
@ Data/FE6_FE7.c:3063:     UnpackUiBarPalette(BGPAL_WEXP_BAR);
	bl	.L17		@
@ Data/FE6_FE7.c:3068:     DrawIcon(
	ldr	r3, .L985+4	@ tmp189,
	movs	r1, r7	@ wtype, wtype
	mov	r8, r3	@ tmp189, tmp189
	movs	r2, #160	@,
@ Data/FE6_FE7.c:3069:         gBG0TilemapBuffer + TILEMAP_INDEX(x, y),
	lsls	r4, r4, #5	@ _1, y,
	adds	r0, r4, r5	@ tmp148, _1, x
@ Data/FE6_FE7.c:3069:         gBG0TilemapBuffer + TILEMAP_INDEX(x, y),
	lsls	r0, r0, #1	@ tmp149, tmp148,
@ Data/FE6_FE7.c:3068:     DrawIcon(
	ldr	r3, .L985+8	@ tmp152,
	adds	r1, r1, #112	@ wtype,
	add	r0, r0, r8	@ tmp150, tmp189
	lsls	r2, r2, #7	@,,
	bl	.L17		@
@ Data/FE6_FE7.c:3075:     color = wexp >= WPN_EXP_S ? TEXT_COLOR_SYSTEM_GREEN : TEXT_COLOR_SYSTEM_BLUE;
	ldr	r3, [sp, #48]	@ tmp220, wexp
@ Data/FE6_FE7.c:3075:     color = wexp >= WPN_EXP_S ? TEXT_COLOR_SYSTEM_GREEN : TEXT_COLOR_SYSTEM_BLUE;
	movs	r7, #2	@ iftmp.96_27,
@ Data/FE6_FE7.c:3075:     color = wexp >= WPN_EXP_S ? TEXT_COLOR_SYSTEM_GREEN : TEXT_COLOR_SYSTEM_BLUE;
	cmp	r3, #250	@ tmp220,
	ble	.L983		@,
@ Data/FE6_FE7.c:3075:     color = wexp >= WPN_EXP_S ? TEXT_COLOR_SYSTEM_GREEN : TEXT_COLOR_SYSTEM_BLUE;
	adds	r7, r7, #2	@ iftmp.96_27,
.L983:
@ Data/FE6_FE7.c:3078:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	ldr	r0, [sp, #48]	@, wexp
	ldr	r3, .L985+12	@ tmp153,
	bl	.L17		@
@ Data/FE6_FE7.c:3078:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	movs	r3, r5	@ tmp154, x
	adds	r3, r3, #8	@ tmp154,
	adds	r3, r3, r4	@ tmp155, tmp154, _1
@ Data/FE6_FE7.c:3078:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	lsls	r3, r3, #1	@ tmp156, tmp155,
@ Data/FE6_FE7.c:3078:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	add	r3, r3, r8	@ tmp156, tmp189
	movs	r2, r0	@ _12, tmp206
@ Data/FE6_FE7.c:3078:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	movs	r1, r7	@, iftmp.96_27
@ Data/FE6_FE7.c:3078:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	movs	r0, r3	@ tmp157, tmp156
@ Data/FE6_FE7.c:3078:     PutSpecialChar(gBG0TilemapBuffer + TILEMAP_INDEX(x + 4, y), color, GetDisplayRankStringFromExp(wexp));
	ldr	r3, .L985+16	@ tmp159,
	bl	.L17		@
@ Data/FE6_FE7.c:3083:         0x180 + num * 6, 5, gBG2TilemapBuffer + TILEMAP_INDEX(x + 2, y + 1), TILEREF(0, BGPAL_WEXP_BAR), 0x22,
	adds	r4, r4, r5	@ tmp164, _1, x
@ Data/FE6_FE7.c:3080:     NewGetWeaponExpProgressState(wexp, &progress, &progressMax);
	add	r2, sp, #20	@,,
	ldr	r0, [sp, #48]	@, wexp
	add	r1, sp, #16	@,,
	bl	NewGetWeaponExpProgressState		@
@ Data/FE6_FE7.c:3083:         0x180 + num * 6, 5, gBG2TilemapBuffer + TILEMAP_INDEX(x + 2, y + 1), TILEREF(0, BGPAL_WEXP_BAR), 0x22,
	adds	r4, r4, #38	@ tmp165,
@ Data/FE6_FE7.c:3082:     DrawStatBarGfx(
	ldr	r3, .L985+20	@ tmp168,
@ Data/FE6_FE7.c:3083:         0x180 + num * 6, 5, gBG2TilemapBuffer + TILEMAP_INDEX(x + 2, y + 1), TILEREF(0, BGPAL_WEXP_BAR), 0x22,
	lsls	r4, r4, #1	@ tmp166, tmp165,
@ Data/FE6_FE7.c:3082:     DrawStatBarGfx(
	adds	r4, r4, r3	@ tmp167, tmp166, tmp168
	movs	r3, #0	@ tmp174,
	str	r3, [sp, #8]	@ tmp174,
@ Data/FE6_FE7.c:3084:         (progress * 34) / (progressMax - 1), 0);
	ldr	r3, [sp, #16]	@ progress, progress
@ Data/FE6_FE7.c:3084:         (progress * 34) / (progressMax - 1), 0);
	ldr	r1, [sp, #20]	@ progressMax, progressMax
@ Data/FE6_FE7.c:3084:         (progress * 34) / (progressMax - 1), 0);
	lsls	r0, r3, #4	@ tmp177, progress,
	adds	r0, r0, r3	@ tmp178, tmp177, progress
@ Data/FE6_FE7.c:3084:         (progress * 34) / (progressMax - 1), 0);
	subs	r1, r1, #1	@ tmp180,
@ Data/FE6_FE7.c:3082:     DrawStatBarGfx(
	ldr	r3, .L985+24	@ tmp185,
@ Data/FE6_FE7.c:3084:         (progress * 34) / (progressMax - 1), 0);
	lsls	r0, r0, #1	@ tmp179, tmp178,
@ Data/FE6_FE7.c:3082:     DrawStatBarGfx(
	bl	.L17		@
	movs	r3, #34	@ tmp187,
	str	r3, [sp]	@ tmp187,
	movs	r3, #128	@,
@ Data/FE6_FE7.c:3083:         0x180 + num * 6, 5, gBG2TilemapBuffer + TILEMAP_INDEX(x + 2, y + 1), TILEREF(0, BGPAL_WEXP_BAR), 0x22,
	lsls	r5, r6, #1	@ tmp170, num,
	adds	r5, r5, r6	@ tmp171, tmp170, num
	lsls	r5, r5, #1	@ tmp172, tmp171,
@ Data/FE6_FE7.c:3082:     DrawStatBarGfx(
	adds	r5, r5, #129	@ tmp173,
	adds	r5, r5, #255	@ tmp173,
	movs	r2, r4	@, tmp167
	str	r0, [sp, #4]	@ tmp207,
	movs	r1, #5	@,
	movs	r0, r5	@, tmp173
	ldr	r4, .L985+28	@ tmp188,
	lsls	r3, r3, #6	@,,
	bl	.L27		@
@ Data/FE6_FE7.c:3085: }
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
@ Data/FE6_FE7.c:3089:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * WExpOptions, 0);
	ldr	r5, .L990	@ tmp129,
@ Data/FE6_FE7.c:3088: {
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:3089:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * WExpOptions, 0);
	movs	r2, #16	@,
	movs	r1, #9	@,
@ Data/FE6_FE7.c:3088: {
	movs	r6, r0	@ proc, tmp184
@ Data/FE6_FE7.c:3089:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * WExpOptions, 0);
	movs	r3, #0	@,
	movs	r0, r5	@, tmp129
	ldr	r4, .L990+4	@ tmp130,
	bl	.L27		@
@ Data/FE6_FE7.c:3090:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT);
	ldr	r3, .L990+8	@ tmp182,
	movs	r0, #3	@,
	mov	r8, r3	@ tmp182, tmp182
	bl	.L17		@
@ Data/FE6_FE7.c:3091:     gLCDControlBuffer.bg1cnt.priority = 1;
	movs	r1, #3	@ tmp138,
	movs	r0, #1	@ tmp140,
	ldr	r2, .L990+12	@ tmp132,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp137, tmp138
	orrs	r3, r0	@ tmp142, tmp140
	strb	r3, [r2, #16]	@ tmp142, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3092:     gLCDControlBuffer.bg2cnt.priority = 0;
	ldrb	r3, [r2, #20]	@ gLCDControlBuffer.bg2cnt.priority, gLCDControlBuffer.bg2cnt.priority
	bics	r3, r1	@ tmp149, tmp138
@ Data/FE6_FE7.c:3100:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r1, r5	@ tmp152, tmp129
	ldr	r4, .L990+16	@ tmp153,
	ldr	r7, .L990+20	@ tmp154,
	movs	r0, r4	@, tmp153
	subs	r1, r1, #14	@ tmp152,
@ Data/FE6_FE7.c:3092:     gLCDControlBuffer.bg2cnt.priority = 0;
	strb	r3, [r2, #20]	@ tmp149, gLCDControlBuffer.bg2cnt.priority
@ Data/FE6_FE7.c:3100:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	bl	.L145		@
@ Data/FE6_FE7.c:3102:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r1, r5	@ tmp155, tmp129
	movs	r0, r4	@ tmp156, tmp153
	adds	r1, r1, #114	@ tmp155,
	adds	r0, r0, #8	@ tmp156,
	bl	.L145		@
@ Data/FE6_FE7.c:3104:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r1, r5	@ tmp158, tmp129
	movs	r0, r4	@ tmp159, tmp153
	adds	r1, r1, #242	@ tmp158,
	adds	r0, r0, #16	@ tmp159,
	bl	.L145		@
@ Data/FE6_FE7.c:3106:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r1, r5	@ tmp161, tmp129
	movs	r0, r4	@ tmp162, tmp153
	adds	r1, r1, #115	@ tmp161,
	adds	r1, r1, #255	@ tmp161,
	adds	r0, r0, #24	@ tmp162,
	bl	.L145		@
@ Data/FE6_FE7.c:3108:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r1, r5	@ tmp164, tmp129
	movs	r0, r4	@ tmp165, tmp153
	adds	r1, r1, #243	@ tmp164,
	adds	r1, r1, #255	@ tmp164,
	adds	r0, r0, #32	@ tmp165,
	bl	.L145		@
@ Data/FE6_FE7.c:3110:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r0, r4	@ tmp168, tmp153
	ldr	r3, .L990+24	@ tmp200,
	adds	r0, r0, #40	@ tmp168,
	adds	r1, r5, r3	@ tmp167, tmp129, tmp200
	bl	.L145		@
@ Data/FE6_FE7.c:3112:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r0, r4	@ tmp171, tmp153
	ldr	r3, .L990+28	@ tmp202,
	adds	r0, r0, #48	@ tmp171,
	adds	r1, r5, r3	@ tmp170, tmp129, tmp202
	bl	.L145		@
@ Data/FE6_FE7.c:3114:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	movs	r0, r4	@ tmp153, tmp153
@ Data/FE6_FE7.c:3117:     for (int i = 0; i < WExpOptions; ++i)
	movs	r4, #0	@ _1,
@ Data/FE6_FE7.c:3114:     PutText(&th[c], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (c * 2)));
	ldr	r3, .L990+32	@ tmp204,
	adds	r0, r0, #56	@ tmp153,
	adds	r1, r5, r3	@ tmp173, tmp129, tmp204
	bl	.L145		@
	ldr	r7, .L990+36	@ tmp183,
	adds	r6, r6, #64	@ ivtmp.956,
	adds	r5, r5, #8	@ ivtmp.960,
.L988:
	movs	r0, r4	@ i, _1
@ Data/FE6_FE7.c:3119:         DebuggerDisplayWeaponExp(
	movs	r1, #0	@ tmp188,
	ldrsh	r3, [r6, r1]	@ MEM[(short int *)_42], ivtmp.956, tmp188
@ Data/FE6_FE7.c:3120:             i, x - 2, Y_HAND + (i * 2), i,
	adds	r4, r4, #1	@ _1,
@ Data/FE6_FE7.c:3119:         DebuggerDisplayWeaponExp(
	movs	r1, #6	@,
	str	r3, [sp]	@ MEM[(short int *)_42],
	lsls	r2, r4, #1	@ tmp176, _1,
	movs	r3, r0	@, i
	bl	DebuggerDisplayWeaponExp		@
@ Data/FE6_FE7.c:3122:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	movs	r0, r5	@, ivtmp.960
	movs	r3, #0	@ tmp189,
	ldrsh	r2, [r6, r3]	@ MEM[(short int *)_42], ivtmp.956, tmp189
	movs	r1, #3	@,
	bl	.L145		@
@ Data/FE6_FE7.c:3117:     for (int i = 0; i < WExpOptions; ++i)
	adds	r6, r6, #2	@ ivtmp.956,
	adds	r5, r5, #128	@ ivtmp.960,
	cmp	r4, #8	@ _1,
	bne	.L988		@,
@ Data/FE6_FE7.c:3125:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp180,
	movs	r2, #0	@,
	movs	r1, #1	@,
	str	r3, [sp]	@ tmp180,
	movs	r0, #0	@,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3128:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT);
	movs	r0, #3	@,
	bl	.L193		@
@ Data/FE6_FE7.c:3129: }
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
@ Data/FE6_FE7.c:3018:     LoadIconPalettes(4);
	ldr	r3, .L999	@ tmp137,
@ Data/FE6_FE7.c:3017: {
	sub	sp, sp, #12	@,,
@ Data/FE6_FE7.c:3018:     LoadIconPalettes(4);
	movs	r0, #4	@,
	bl	.L17		@
@ Data/FE6_FE7.c:406:     ResetTextFont();
	ldr	r6, .L999+4	@ tmp138,
	bl	.L38		@
@ Data/FE6_FE7.c:407:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	ldr	r5, .L999+8	@ tmp139,
	bl	.L28		@
@ Data/FE6_FE7.c:410:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r3, .L999+12	@ tmp141,
	ldr	r0, .L999+16	@ tmp140,
	bl	.L17		@
@ Data/FE6_FE7.c:411:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	ldr	r4, .L999+20	@ tmp163,
	bl	.L27		@
@ Data/FE6_FE7.c:412:     ResetTextFont();
	bl	.L38		@
@ Data/FE6_FE7.c:413:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L28		@
@ Data/FE6_FE7.c:414:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L999+24	@ tmp145,
	bl	.L17		@
@ Data/FE6_FE7.c:415:     ClearBg0Bg1();
	ldr	r3, .L999+28	@ tmp146,
	bl	.L17		@
@ Data/FE6_FE7.c:416:     ResetText();
	ldr	r3, .L999+32	@ tmp147,
	bl	.L17		@
	mov	r3, r9	@ proc, proc
	mov	r0, r9	@ _76, proc
	ldr	r2, [r3, #60]	@ proc_18(D)->unit, proc_18(D)->unit
	adds	r0, r0, #80	@ _76,
	adds	r2, r2, #40	@ ivtmp.991,
	adds	r3, r3, #64	@ ivtmp.993,
.L993:
@ Data/FE6_FE7.c:3026:         proc->tmp[i] = unit->ranks[i];
	ldrb	r1, [r2]	@ MEM[(unsigned char *)_73], MEM[(unsigned char *)_73]
	strh	r1, [r3]	@ MEM[(unsigned char *)_73], MEM[(short int *)_74]
@ Data/FE6_FE7.c:3024:     for (int i = 0; i < WExpOptions; ++i)
	adds	r3, r3, #2	@ ivtmp.993,
	adds	r2, r2, #1	@ ivtmp.991,
	cmp	r3, r0	@ ivtmp.993, _76
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
@ Data/FE6_FE7.c:3037:     BG_EnableSyncByMask(BG2_SYNC_BIT);
	movs	r0, #4	@,
	bl	.L27		@
	ldr	r5, .L999+40	@ ivtmp.974,
	movs	r7, r5	@ _64, ivtmp.974
	movs	r4, r5	@ ivtmp.983, ivtmp.974
	ldr	r6, .L999+44	@ tmp164,
	adds	r7, r7, #120	@ _64,
.L994:
@ Data/FE6_FE7.c:3043:         InitText(&th[i], WExpWidth);
	movs	r0, r4	@, ivtmp.983
	movs	r1, #11	@,
@ Data/FE6_FE7.c:3041:     for (int i = 0; i < 15; ++i)
	adds	r4, r4, #8	@ ivtmp.983,
@ Data/FE6_FE7.c:3043:         InitText(&th[i], WExpWidth);
	bl	.L38		@
@ Data/FE6_FE7.c:3041:     for (int i = 0; i < 15; ++i)
	cmp	r4, r7	@ ivtmp.983, _64
	bne	.L994		@,
	ldr	r3, .L999+48	@ tmp165,
	mov	fp, r3	@ tmp165, tmp165
	ldr	r3, .L999+52	@ tmp166,
	mov	r10, r3	@ tmp166, tmp166
	ldr	r3, .L999+56	@ tmp167,
	mov	r8, r3	@ tmp167, tmp167
	ldr	r4, .L999+60	@ ivtmp.976,
	ldr	r7, .L999+64	@ tmp162,
@ Data/FE6_FE7.c:3045:     for (int i = 0; i < WExpOptions; ++i)
	ldr	r6, .L999+68	@ tmp161,
.L995:
@ Data/FE6_FE7.c:3047:         x = Text_GetCursor(&th[i]);
	movs	r0, r5	@, ivtmp.974
	bl	.L311		@
@ Data/FE6_FE7.c:3048:         x++;
	adds	r1, r0, #1	@ x, tmp169,
@ Data/FE6_FE7.c:3049:         Text_SetCursor(&th[i], x);
	movs	r0, r5	@, ivtmp.974
	bl	.L310		@
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	movs	r0, r4	@, ivtmp.976
	bl	.L193		@
@ Data/FE6_FE7.c:3045:     for (int i = 0; i < WExpOptions; ++i)
	adds	r4, r4, #1	@ ivtmp.976,
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	movs	r1, r0	@ _33, tmp170
@ Data/FE6_FE7.c:3051:         Text_DrawString(&th[i], GetStringFromIndexSafe(wexpText + i));
	movs	r0, r5	@, ivtmp.974
	bl	.L145		@
@ Data/FE6_FE7.c:3045:     for (int i = 0; i < WExpOptions; ++i)
	adds	r5, r5, #8	@ ivtmp.974,
	cmp	r4, r6	@ ivtmp.976, tmp161
	bne	.L995		@,
@ Data/FE6_FE7.c:3056:     RedrawUnitWExpMenu(proc);
	mov	r0, r9	@, proc
	bl	RedrawUnitWExpMenu		@
@ Data/FE6_FE7.c:3057: }
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
@ Data/FE6_FE7.c:3220:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L1071	@ tmp198,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r6, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:3216: {
	movs	r4, r0	@ proc, tmp418
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:3221:     if (keys & B_BUTTON)
	lsls	r3, r6, #30	@ tmp419, keys,
	bpl	.LCB7344	@
	b	.L1065	@long jump	@
.LCB7344:
.L1002:
@ Data/FE6_FE7.c:3227:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp223,
	tst	r3, r6	@ tmp223, keys
	beq	.L1003		@,
	movs	r3, r4	@ ivtmp.1012, proc
	movs	r0, r4	@ _7, proc
	ldr	r2, [r4, #60]	@ proc_82(D)->unit, proc_82(D)->unit
	adds	r3, r3, #64	@ ivtmp.1012,
	adds	r2, r2, #40	@ ivtmp.1014,
	adds	r0, r0, #80	@ _7,
.L1004:
@ Data/FE6_FE7.c:3136:         unit->ranks[i] = proc->tmp[i];
	ldrh	r1, [r3]	@ MEM[(short int *)_52], MEM[(short int *)_52]
@ Data/FE6_FE7.c:3134:     for (int i = 0; i < WExpOptions; ++i)
	adds	r3, r3, #2	@ ivtmp.1012,
@ Data/FE6_FE7.c:3136:         unit->ranks[i] = proc->tmp[i];
	strb	r1, [r2]	@ MEM[(short int *)_52], MEM[(unsigned char *)_53]
@ Data/FE6_FE7.c:3134:     for (int i = 0; i < WExpOptions; ++i)
	adds	r2, r2, #1	@ ivtmp.1014,
	cmp	r0, r3	@ _7, ivtmp.1012
	bne	.L1004		@,
@ Data/FE6_FE7.c:3142:     gLCDControlBuffer.bg1cnt.priority = 0;
	movs	r1, #3	@ tmp237,
	ldr	r2, .L1071+4	@ tmp231,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp236, tmp237
	strb	r3, [r2, #16]	@ tmp236, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3143:     SetBackgroundTileDataOffset(2, 0);
	movs	r1, #0	@,
	movs	r0, #2	@,
	ldr	r3, .L1071+8	@ tmp239,
	bl	.L17		@
@ Data/FE6_FE7.c:3144:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp240,
	movs	r2, #0	@,
	movs	r1, #1	@,
	movs	r0, #0	@,
	str	r3, [sp]	@ tmp240,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3145:     BG_Fill(gBG2TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1071+12	@ tmp241,
	ldr	r3, .L1071+16	@ tmp242,
	bl	.L17		@
@ Data/FE6_FE7.c:3146:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT);
	movs	r0, #7	@,
	ldr	r3, .L1071+20	@ tmp243,
	bl	.L17		@
@ Data/FE6_FE7.c:3231:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L1071+24	@ tmp244,
	bl	.L17		@
.L1003:
@ Data/FE6_FE7.c:3236:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r2, #48	@ tmp251,
@ Data/FE6_FE7.c:3234:     if (proc->editing)
	movs	r5, #46	@ tmp245,
	movs	r7, #16	@ tmp249,
@ Data/FE6_FE7.c:3236:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r2]	@ tmp252,
@ Data/FE6_FE7.c:3234:     if (proc->editing)
	ldrsb	r3, [r4, r5]	@ _2,
@ Data/FE6_FE7.c:3236:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r1, #1	@ tmp253,
	ands	r7, r6	@ _106, keys
@ Data/FE6_FE7.c:3236:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ _155, tmp253,
@ Data/FE6_FE7.c:3234:     if (proc->editing)
	cmp	r3, #0	@ _2,
	bne	.LCB7405	@
	b	.L1005	@long jump	@
.LCB7405:
@ Data/FE6_FE7.c:3236:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r2, r2, #1	@ tmp255,
	ldrsb	r2, [r4, r2]	@ tmp256,
@ Data/FE6_FE7.c:3236:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r3, .L1071+28	@ tmp254,
	lsls	r2, r2, #3	@ tmp257, tmp256,
	adds	r3, r3, r2	@ tmp258, tmp254, tmp257
@ Data/FE6_FE7.c:3236:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r0, [r3, #120]	@ CursorLocationTable[_4].x, CursorLocationTable[_4].x
	bl	DisplayVertUiHand		@
	ldr	r3, .L1071+32	@ tmp405,
@ Data/FE6_FE7.c:546:     int result = 1;
	subs	r5, r5, #45	@ result,
	mov	r8, r3	@ tmp405, tmp405
	adds	r3, r3, #76	@ ivtmp.1004,
.L1006:
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	adds	r3, r3, #4	@ ivtmp.1004,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	subs	r1, r3, #4	@ tmp263, ivtmp.1004,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	ldr	r1, [r1]	@ MEM[(const int *)_98 + 4294967292B], MEM[(const int *)_98 + 4294967292B]
@ Data/FE6_FE7.c:549:         result++;
	adds	r5, r5, #1	@ result,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	cmp	r1, #250	@ MEM[(const int *)_98 + 4294967292B],
	ble	.L1006		@,
@ Data/FE6_FE7.c:551:     if (result > 9)
	cmp	r5, #9	@ _129,
	ble	.LCB7426	@
	b	.L1066	@long jump	@
.LCB7426:
@ Data/FE6_FE7.c:3241:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _106,
	beq	.L1008		@,
.L1070:
@ Data/FE6_FE7.c:3243:             if (proc->digit > 0)
	movs	r3, #49	@ tmp265,
	ldrsb	r3, [r4, r3]	@ _11,
@ Data/FE6_FE7.c:3243:             if (proc->digit > 0)
	cmp	r3, #0	@ _11,
	bgt	.LCB7433	@
	b	.L1009	@long jump	@
.LCB7433:
@ Data/FE6_FE7.c:3245:                 proc->digit--;
	subs	r3, r3, #1	@ tmp269,
	lsls	r3, r3, #24	@ tmp270, tmp269,
	asrs	r3, r3, #24	@ _15, tmp270,
.L1010:
	movs	r2, #49	@ tmp277,
@ Data/FE6_FE7.c:3252:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _15, proc_82(D)->digit
	bl	RedrawUnitWExpMenu		@
.L1008:
@ Data/FE6_FE7.c:3254:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp420, keys,
	bpl	.L1011		@,
@ Data/FE6_FE7.c:3256:             if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp286,
	ldrsb	r3, [r4, r3]	@ _19,
@ Data/FE6_FE7.c:3256:             if (proc->digit < (max_digits - 1))
	subs	r5, r5, #1	@ tmp287,
@ Data/FE6_FE7.c:3256:             if (proc->digit < (max_digits - 1))
	cmp	r3, r5	@ _19, tmp287
	bge	.LCB7455	@
	b	.L1067	@long jump	@
.LCB7455:
@ Data/FE6_FE7.c:3263:                 proc->editing = false;
	movs	r3, #46	@ tmp291,
	movs	r2, #0	@ tmp292,
	strb	r2, [r4, r3]	@ tmp292, proc_82(D)->editing
@ Data/FE6_FE7.c:3262:                 proc->digit = 0;
	movs	r3, #0	@ _25,
.L1013:
	movs	r2, #49	@ tmp294,
@ Data/FE6_FE7.c:3265:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _25, proc_82(D)->digit
	bl	RedrawUnitWExpMenu		@
.L1011:
@ Data/FE6_FE7.c:3268:         if (keys & DPAD_UP)
	movs	r3, #64	@ tmp297,
	tst	r3, r6	@ tmp297, keys
	beq	.L1014		@,
@ Data/FE6_FE7.c:3270:             if (proc->tmp[proc->id] == max)
	movs	r2, #48	@ tmp303,
	ldrsb	r1, [r4, r2]	@ tmp304,
	lsls	r1, r1, #1	@ tmp305, tmp304,
	adds	r1, r4, r1	@ _149, proc, tmp305
@ Data/FE6_FE7.c:3270:             if (proc->tmp[proc->id] == max)
	ldrsh	r2, [r1, r3]	@ _28, MEM <s16> [(struct DebuggerProc *)_149 + 64B]
@ Data/FE6_FE7.c:3270:             if (proc->tmp[proc->id] == max)
	cmp	r2, #251	@ _28,
	bne	.LCB7480	@
	b	.L1027	@long jump	@
.LCB7480:
@ Data/FE6_FE7.c:3276:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	movs	r3, #49	@ tmp309,
	ldrsb	r3, [r4, r3]	@ tmp310,
@ Data/FE6_FE7.c:3276:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp311, tmp310,
	add	r3, r3, r8	@ tmp312, tmp405
@ Data/FE6_FE7.c:3276:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_31], DigitDecimalTable[_31]
	adds	r3, r3, r2	@ tmp317, DigitDecimalTable[_31], _28
@ Data/FE6_FE7.c:3277:                 if (proc->tmp[proc->id] > max)
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
@ Data/FE6_FE7.c:3272:                 proc->tmp[proc->id] = min;
	movs	r2, #64	@ tmp322,
@ Data/FE6_FE7.c:3282:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3272:                 proc->tmp[proc->id] = min;
	strh	r3, [r1, r2]	@ _27, MEM <s16> [(struct DebuggerProc *)_149 + 64B]
@ Data/FE6_FE7.c:3282:             RedrawUnitWExpMenu(proc);
	bl	RedrawUnitWExpMenu		@
.L1014:
@ Data/FE6_FE7.c:3284:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp421, keys,
	bpl	.L1001		@,
@ Data/FE6_FE7.c:3287:             if (proc->tmp[proc->id] == min)
	movs	r3, #48	@ tmp331,
	ldrsb	r1, [r4, r3]	@ tmp332,
	lsls	r1, r1, #1	@ tmp333, tmp332,
@ Data/FE6_FE7.c:3287:             if (proc->tmp[proc->id] == min)
	adds	r3, r3, #16	@ tmp334,
	adds	r1, r4, r1	@ _158, proc, tmp333
	ldrsh	r2, [r1, r3]	@ _39, MEM <s16> [(struct DebuggerProc *)_158 + 64B]
	movs	r3, #251	@ _8,
@ Data/FE6_FE7.c:3287:             if (proc->tmp[proc->id] == min)
	cmp	r2, #0	@ _39,
	bne	.L1068		@,
@ Data/FE6_FE7.c:3289:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp350,
@ Data/FE6_FE7.c:3300:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3289:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _8, MEM <s16> [(struct DebuggerProc *)_158 + 64B]
@ Data/FE6_FE7.c:3300:             RedrawUnitWExpMenu(proc);
	bl	RedrawUnitWExpMenu		@
.L1001:
@ Data/FE6_FE7.c:3337: }
	add	sp, sp, #8	@,,
	@ sp needed	@
	pop	{r7}
	mov	r8, r7
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1005:
@ Data/FE6_FE7.c:3305:         DisplayUiHand(CursorLocationTable[0].x - ((WExpWidth + 2) * 8), (Y_HAND + (proc->id * 2)) * 8);
	movs	r0, #44	@,
	ldr	r3, .L1071+36	@ tmp352,
	bl	.L17		@
@ Data/FE6_FE7.c:3306:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _106,
	beq	.L1021		@,
@ Data/FE6_FE7.c:3308:             proc->digit = 1;
	movs	r3, #1	@ tmp354,
	movs	r2, #49	@ tmp353,
	strb	r3, [r4, r2]	@ tmp354, proc_82(D)->digit
@ Data/FE6_FE7.c:3309:             proc->editing = true;
	strb	r3, [r4, r5]	@ tmp354, proc_82(D)->editing
.L1021:
@ Data/FE6_FE7.c:3311:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp422, keys,
	bpl	.L1022		@,
@ Data/FE6_FE7.c:3313:             proc->digit = 0;
	movs	r3, #49	@ tmp366,
	movs	r2, #0	@ tmp367,
	strb	r2, [r4, r3]	@ tmp367, proc_82(D)->digit
@ Data/FE6_FE7.c:3314:             proc->editing = true;
	subs	r3, r3, #3	@ tmp369,
	adds	r2, r2, #1	@ tmp370,
	strb	r2, [r4, r3]	@ tmp370, proc_82(D)->editing
.L1022:
@ Data/FE6_FE7.c:3317:         if (keys & DPAD_UP)
	lsls	r3, r6, #25	@ tmp423, keys,
	bpl	.L1023		@,
@ Data/FE6_FE7.c:3319:             proc->id--;
	movs	r3, #48	@ tmp379,
@ Data/FE6_FE7.c:3319:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp381,
	subs	r3, r3, #1	@ tmp382,
	lsls	r3, r3, #24	@ tmp383, tmp382,
	asrs	r2, r3, #24	@ _58, tmp383,
@ Data/FE6_FE7.c:3320:             if (proc->id < 0)
	cmp	r3, #0	@ tmp383,
	blt	.L1069		@,
	movs	r3, #48	@ tmp387,
@ Data/FE6_FE7.c:3324:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _58, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitWExpMenu		@
.L1023:
@ Data/FE6_FE7.c:3326:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp424, keys,
	bpl	.L1001		@,
@ Data/FE6_FE7.c:3328:             proc->id++;
	movs	r1, #48	@ tmp396,
@ Data/FE6_FE7.c:3331:                 proc->id = 0;
	movs	r0, #7	@ tmp408,
	movs	r5, #0	@ tmp410,
@ Data/FE6_FE7.c:3328:             proc->id++;
	ldrb	r3, [r4, r1]	@ tmp398,
	adds	r3, r3, #1	@ tmp399,
	lsls	r3, r3, #24	@ tmp400, tmp399,
	asrs	r2, r3, #24	@ _63, tmp400,
@ Data/FE6_FE7.c:3331:                 proc->id = 0;
	lsrs	r3, r3, #31	@ tmp409, tmp400,
	cmp	r0, r2	@ tmp408, _63
	adcs	r3, r3, r5	@ tmp407, tmp409, tmp410
	rsbs	r3, r3, #0	@ tmp411, tmp407
	ands	r2, r3	@ _63, tmp411
@ Data/FE6_FE7.c:3334:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r1]	@ _63, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitWExpMenu		@
@ Data/FE6_FE7.c:3337: }
	b	.L1001		@
.L1066:
@ Data/FE6_FE7.c:551:     if (result > 9)
	movs	r5, #9	@ _129,
@ Data/FE6_FE7.c:3241:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _106,
	bne	.LCB7609	@
	b	.L1008	@long jump	@
.LCB7609:
	b	.L1070		@
.L1065:
@ Data/FE6_FE7.c:3142:     gLCDControlBuffer.bg1cnt.priority = 0;
	movs	r1, #3	@ tmp212,
	ldr	r2, .L1071+4	@ tmp206,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp211, tmp212
	strb	r3, [r2, #16]	@ tmp211, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3143:     SetBackgroundTileDataOffset(2, 0);
	movs	r1, #0	@,
	movs	r0, #2	@,
	ldr	r3, .L1071+8	@ tmp214,
	bl	.L17		@
@ Data/FE6_FE7.c:3144:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp215,
	movs	r2, #0	@,
	str	r3, [sp]	@ tmp215,
	movs	r1, #1	@,
	movs	r0, #0	@,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3145:     BG_Fill(gBG2TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1071+12	@ tmp216,
	ldr	r3, .L1071+16	@ tmp217,
	bl	.L17		@
@ Data/FE6_FE7.c:3146:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT);
	movs	r0, #7	@,
	ldr	r3, .L1071+20	@ tmp218,
	bl	.L17		@
@ Data/FE6_FE7.c:3224:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L1071+24	@ tmp219,
	bl	.L17		@
@ Data/FE6_FE7.c:584: }
	b	.L1002		@
.L1068:
@ Data/FE6_FE7.c:3293:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	subs	r3, r3, #202	@ tmp337,
	ldrsb	r3, [r4, r3]	@ tmp338,
@ Data/FE6_FE7.c:3293:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp339, tmp338,
	add	r3, r3, r8	@ tmp340, tmp405
@ Data/FE6_FE7.c:3293:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	ldr	r0, [r3, #68]	@ DigitDecimalTable[_42], DigitDecimalTable[_42]
	subs	r0, r2, r0	@ tmp345, _39, DigitDecimalTable[_42]
@ Data/FE6_FE7.c:3294:                 if (proc->tmp[proc->id] < min)
	lsls	r3, r0, #16	@ tmp348, tmp345,
	asrs	r3, r3, #16	@ tmp348, tmp348,
	mvns	r3, r3	@ tmp413, tmp348
@ Data/FE6_FE7.c:3289:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp350,
@ Data/FE6_FE7.c:3294:                 if (proc->tmp[proc->id] < min)
	asrs	r3, r3, #31	@ tmp417, tmp413,
	ands	r3, r0	@ tmp335, tmp345
	lsls	r3, r3, #16	@ _8, tmp335,
	asrs	r3, r3, #16	@ _8, _8,
@ Data/FE6_FE7.c:3300:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3289:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _8, MEM <s16> [(struct DebuggerProc *)_158 + 64B]
@ Data/FE6_FE7.c:3300:             RedrawUnitWExpMenu(proc);
	bl	RedrawUnitWExpMenu		@
	b	.L1001		@
.L1067:
@ Data/FE6_FE7.c:3258:                 proc->digit++;
	adds	r3, r3, #1	@ tmp289,
	lsls	r3, r3, #24	@ tmp290, tmp289,
	asrs	r3, r3, #24	@ _25, tmp290,
	b	.L1013		@
.L1069:
@ Data/FE6_FE7.c:3322:                 proc->id = WExpOptions - 1;
	movs	r2, #7	@ _58,
	movs	r3, #48	@ tmp387,
@ Data/FE6_FE7.c:3324:             RedrawUnitWExpMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _58, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitWExpMenu		@
	b	.L1023		@
.L1009:
@ Data/FE6_FE7.c:3250:                 proc->editing = false;
	movs	r2, #46	@ tmp274,
	movs	r1, #0	@ tmp275,
@ Data/FE6_FE7.c:3249:                 proc->digit = max_digits - 1;
	subs	r3, r5, #1	@ tmp272, _129,
	lsls	r3, r3, #24	@ tmp273, tmp272,
@ Data/FE6_FE7.c:3250:                 proc->editing = false;
	strb	r1, [r4, r2]	@ tmp275, proc_82(D)->editing
@ Data/FE6_FE7.c:3249:                 proc->digit = max_digits - 1;
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
@ Data/FE6_FE7.c:3441:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * SupportOptions, 0);
	ldr	r6, .L1078	@ tmp130,
@ Data/FE6_FE7.c:3440: {
	push	{r7, lr}	@
@ Data/FE6_FE7.c:3441:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * SupportOptions, 0);
	movs	r3, #0	@,
	movs	r2, #14	@,
	movs	r1, #9	@,
	ldr	r4, .L1078+4	@ tmp131,
@ Data/FE6_FE7.c:3440: {
	mov	r9, r0	@ proc, tmp141
@ Data/FE6_FE7.c:3441:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 2, Y_HAND), 9, 2 * SupportOptions, 0);
	movs	r0, r6	@, tmp130
	bl	.L27		@
@ Data/FE6_FE7.c:3442:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L1078+8	@ tmp139,
	movs	r0, #1	@,
	mov	r8, r3	@ tmp139, tmp139
	bl	.L17		@
	ldr	r3, .L1078+12	@ tmp146,
	mov	ip, r3	@ tmp146, tmp146
	ldr	r5, .L1078+16	@ ivtmp.1038,
	ldr	r7, .L1078+20	@ tmp140,
	subs	r4, r6, #6	@ ivtmp.1040, tmp130,
	add	r6, r6, ip	@ _54, tmp146
.L1074:
@ Data/FE6_FE7.c:3448:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	movs	r1, r4	@, ivtmp.1040
	movs	r0, r5	@, ivtmp.1038
@ Data/FE6_FE7.c:3446:     for (int i = 0; i < SupportOptions; ++i)
	adds	r4, r4, #128	@ ivtmp.1040,
@ Data/FE6_FE7.c:3448:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(x, Y_HAND + (i * 2)));
	bl	.L145		@
@ Data/FE6_FE7.c:3446:     for (int i = 0; i < SupportOptions; ++i)
	adds	r5, r5, #8	@ ivtmp.1038,
	cmp	r4, r6	@ ivtmp.1040, _54
	bne	.L1074		@,
	mov	r4, r9	@ ivtmp.1027, proc
	mov	r7, r9	@ proc, proc
	ldr	r5, .L1078+24	@ ivtmp.1029,
	ldr	r6, .L1078+28	@ tmp138,
	adds	r4, r4, #64	@ ivtmp.1027,
	adds	r7, r7, #78	@ proc,
.L1075:
@ Data/FE6_FE7.c:3453:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	movs	r0, r5	@, ivtmp.1029
	movs	r3, #0	@ tmp144,
	ldrsh	r2, [r4, r3]	@ MEM[(short int *)_42], ivtmp.1027, tmp144
	movs	r1, #3	@,
@ Data/FE6_FE7.c:3451:     for (int i = 0; i < SupportOptions; ++i)
	adds	r4, r4, #2	@ ivtmp.1027,
@ Data/FE6_FE7.c:3453:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	bl	.L38		@
@ Data/FE6_FE7.c:3451:     for (int i = 0; i < SupportOptions; ++i)
	adds	r5, r5, #128	@ ivtmp.1029,
	cmp	r4, r7	@ ivtmp.1027, _44
	bne	.L1075		@,
@ Data/FE6_FE7.c:3457: }
	@ sp needed	@
@ Data/FE6_FE7.c:3456:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	bl	.L193		@
@ Data/FE6_FE7.c:3457: }
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
.LC566:
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}	@
	mov	lr, fp	@,
	mov	r6, r9	@,
	mov	r5, r8	@,
	mov	r7, r10	@,
	push	{r5, r6, r7, lr}	@
	movs	r5, r0	@ proc, tmp183
	sub	sp, sp, #20	@,,
@ Data/FE6_FE7.c:406:     ResetTextFont();
	ldr	r6, .L1112	@ tmp148,
@ Data/FE6_FE7.c:3391: {
	str	r0, [sp, #12]	@ proc, %sfp
@ Data/FE6_FE7.c:406:     ResetTextFont();
	bl	.L38		@
@ Data/FE6_FE7.c:407:     SetTextFontGlyphs(0);
	ldr	r4, .L1112+4	@ tmp149,
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:410:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1112+8	@ tmp150,
	ldr	r3, .L1112+12	@ tmp151,
	bl	.L17		@
@ Data/FE6_FE7.c:411:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L1112+16	@ tmp152,
	movs	r0, #1	@,
	bl	.L17		@
@ Data/FE6_FE7.c:412:     ResetTextFont();
	bl	.L38		@
@ Data/FE6_FE7.c:413:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L27		@
@ Data/FE6_FE7.c:414:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L1112+20	@ tmp155,
	bl	.L17		@
@ Data/FE6_FE7.c:415:     ClearBg0Bg1();
	ldr	r3, .L1112+24	@ tmp156,
	bl	.L17		@
@ Data/FE6_FE7.c:416:     ResetText();
	ldr	r3, .L1112+28	@ tmp157,
	bl	.L17		@
@ Data/FE6_FE7.c:3393:     struct Unit * unit = proc->unit;
	ldr	r3, [r5, #60]	@ unit, proc_24(D)->unit
@ Data/FE6_FE7.c:3394:     u8 * row = GetUnitBwlSupportRow(unit);
	movs	r0, r3	@, unit
@ Data/FE6_FE7.c:3393:     struct Unit * unit = proc->unit;
	mov	r9, r3	@ unit, unit
@ Data/FE6_FE7.c:3394:     u8 * row = GetUnitBwlSupportRow(unit);
	bl	GetUnitBwlSupportRow		@
	movs	r2, r5	@ ivtmp.1079, proc
	movs	r3, r0	@ ivtmp.1081, row
	adds	r2, r2, #64	@ ivtmp.1079,
	adds	r4, r0, #7	@ _105, row,
	b	.L1082		@
.L1110:
@ Data/FE6_FE7.c:3397:         proc->tmp[i] = row ? row[i] : 0;
	ldrb	r1, [r3]	@ iftmp.108_17, MEM[(u8 *)_106]
@ Data/FE6_FE7.c:3395:     for (int i = 0; i < SupportOptions; ++i)
	adds	r3, r3, #1	@ ivtmp.1081,
@ Data/FE6_FE7.c:3397:         proc->tmp[i] = row ? row[i] : 0;
	strh	r1, [r2]	@ iftmp.108_17, MEM[(short int *)_103]
@ Data/FE6_FE7.c:3395:     for (int i = 0; i < SupportOptions; ++i)
	adds	r2, r2, #2	@ ivtmp.1079,
	cmp	r3, r4	@ ivtmp.1081, _105
	beq	.L1109		@,
.L1082:
@ Data/FE6_FE7.c:3397:         proc->tmp[i] = row ? row[i] : 0;
	cmp	r0, #0	@ row,
	bne	.L1110		@,
@ Data/FE6_FE7.c:3397:         proc->tmp[i] = row ? row[i] : 0;
	movs	r1, #0	@ iftmp.108_17,
@ Data/FE6_FE7.c:3395:     for (int i = 0; i < SupportOptions; ++i)
	adds	r3, r3, #1	@ ivtmp.1081,
@ Data/FE6_FE7.c:3397:         proc->tmp[i] = row ? row[i] : 0;
	strh	r1, [r2]	@ iftmp.108_17, MEM[(short int *)_103]
@ Data/FE6_FE7.c:3395:     for (int i = 0; i < SupportOptions; ++i)
	adds	r2, r2, #2	@ ivtmp.1079,
	cmp	r3, r4	@ ivtmp.1081, _105
	bne	.L1082		@,
.L1109:
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	movs	r3, #0	@ tmp161,
	ldr	r4, .L1112+32	@ tmp162,
	str	r3, [sp]	@ tmp161,
	movs	r2, #10	@,
	adds	r3, r3, #16	@,
	movs	r1, #1	@,
	movs	r0, #11	@,
	bl	.L27		@
	movs	r3, #120	@ _95,
	ldr	r7, .L1112+36	@ ivtmp.1057,
	mov	fp, r3	@ _95, _95
	ldr	r3, .L1112+40	@ tmp176,
	movs	r4, r7	@ ivtmp.1071, ivtmp.1057
	mov	r8, r3	@ tmp176, tmp176
	ldr	r5, .L1112+44	@ tmp175,
	ldr	r6, .L1112+48	@ tmp177,
	add	fp, fp, r7	@ _95, ivtmp.1057
.L1083:
@ Data/FE6_FE7.c:3417:         InitText(&th[i], SupportWidth);
	movs	r0, r4	@, ivtmp.1071
	movs	r1, #5	@,
	bl	.L28		@
@ Data/FE6_FE7.c:3418:         Text_DrawString(&th[i], "");
	movs	r0, r4	@, ivtmp.1071
	mov	r1, r8	@, tmp176
@ Data/FE6_FE7.c:3415:     for (int i = 0; i < 15; ++i)
	adds	r4, r4, #8	@ ivtmp.1071,
@ Data/FE6_FE7.c:3418:         Text_DrawString(&th[i], "");
	bl	.L38		@
@ Data/FE6_FE7.c:3415:     for (int i = 0; i < 15; ++i)
	cmp	r4, fp	@ ivtmp.1071, _95
	bne	.L1083		@,
@ Data/FE6_FE7.c:3368:     if (!unit || !unit->pCharacterData)
	mov	r3, r9	@ unit, unit
	cmp	r3, #0	@ unit,
	beq	.L1084		@,
@ Data/FE6_FE7.c:3368:     if (!unit || !unit->pCharacterData)
	ldr	r3, [r3]	@ _49, unit_26->pCharacterData
	mov	r9, r3	@ _49, _49
@ Data/FE6_FE7.c:3368:     if (!unit || !unit->pCharacterData)
	cmp	r3, #0	@ _49,
	beq	.L1084		@,
@ Data/FE6_FE7.c:3373:     if (ch->pSupportData)
	ldr	r3, [r3, #44]	@ _50, _49->pSupportData
@ Data/FE6_FE7.c:3373:     if (ch->pSupportData)
	cmp	r3, #0	@ _50,
	beq	.L1111		@,
.L1085:
	movs	r4, r3	@ ivtmp.1056, _50
	adds	r3, r3, #7	@ _89,
	mov	r8, r3	@ _89, _89
@ Data/FE6_FE7.c:3431:                     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(uid)->nameTextId));
	ldr	r3, .L1112+52	@ tmp179,
	mov	r10, r3	@ tmp179, tmp179
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	ldr	r3, .L1112+56	@ _44,
	mov	r9, r3	@ _44, _44
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	ldr	r3, .L1112+60	@ tmp181,
	mov	fp, r3	@ tmp181, tmp181
	b	.L1090		@
.L1088:
@ Data/FE6_FE7.c:3426:             for (int i = 0; i < SupportOptions; ++i)
	adds	r4, r4, #1	@ ivtmp.1056,
	adds	r7, r7, #8	@ ivtmp.1057,
	cmp	r4, r8	@ ivtmp.1056, _89
	beq	.L1084		@,
.L1090:
@ Data/FE6_FE7.c:3428:                 uid = sdata->characters[i];
	ldrb	r0, [r4]	@ uid, MEM[(unsigned char *)_87]
@ Data/FE6_FE7.c:3429:                 if (uid)
	cmp	r0, #0	@ uid,
	beq	.L1088		@,
@ Data/FE6_FE7.c:3431:                     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(uid)->nameTextId));
	bl	.L310		@
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	movs	r3, #128	@ tmp172,
@ Data/FE6_FE7.c:3431:                     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(uid)->nameTextId));
	ldrh	r0, [r0]	@ _12, *_11
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	subs	r2, r0, #1	@ tmp171, _12,
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	mov	r1, r9	@ _44, _44
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	lsls	r3, r3, #7	@ tmp172, tmp172,
	cmp	r2, r3	@ tmp171, tmp172
	bcs	.L1089		@,
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	bl	.L311		@
	movs	r1, r0	@ _44, tmp187
.L1089:
@ Data/FE6_FE7.c:3431:                     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(uid)->nameTextId));
	movs	r0, r7	@, ivtmp.1057
@ Data/FE6_FE7.c:3426:             for (int i = 0; i < SupportOptions; ++i)
	adds	r4, r4, #1	@ ivtmp.1056,
@ Data/FE6_FE7.c:3431:                     Text_DrawString(&th[i], GetStringFromIndexSafe(GetCharacterData(uid)->nameTextId));
	bl	.L38		@
@ Data/FE6_FE7.c:3426:             for (int i = 0; i < SupportOptions; ++i)
	adds	r7, r7, #8	@ ivtmp.1057,
	cmp	r4, r8	@ ivtmp.1056, _89
	bne	.L1090		@,
.L1084:
@ Data/FE6_FE7.c:3436:     RedrawUnitSupportsMenu(proc);
	ldr	r0, [sp, #12]	@, %sfp
	bl	RedrawUnitSupportsMenu		@
@ Data/FE6_FE7.c:3437: }
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
.L1111:
@ Data/FE6_FE7.c:3378:     for (i = 1; i <= 0x45; ++i)
	movs	r4, #1	@ i,
	ldr	r5, .L1112+52	@ tmp178,
	b	.L1087		@
.L1086:
@ Data/FE6_FE7.c:3378:     for (i = 1; i <= 0x45; ++i)
	adds	r4, r4, #1	@ i,
@ Data/FE6_FE7.c:3378:     for (i = 1; i <= 0x45; ++i)
	cmp	r4, #70	@ i,
	beq	.L1084		@,
.L1087:
@ Data/FE6_FE7.c:3380:         other = GetCharacterData(i);
	movs	r0, r4	@, i
	bl	.L28		@
@ Data/FE6_FE7.c:3381:         if (other && other->nameTextId == ch->nameTextId && other->pSupportData)
	cmp	r0, #0	@ other,
	beq	.L1086		@,
@ Data/FE6_FE7.c:3381:         if (other && other->nameTextId == ch->nameTextId && other->pSupportData)
	mov	r3, r9	@ _49, _49
	ldrh	r2, [r0]	@ *other_52, *other_52
	ldrh	r3, [r3]	@ *_49, *_49
	cmp	r2, r3	@ *other_52, *_49
	bne	.L1086		@,
@ Data/FE6_FE7.c:3381:         if (other && other->nameTextId == ch->nameTextId && other->pSupportData)
	ldr	r3, [r0, #44]	@ _50, other_52->pSupportData
@ Data/FE6_FE7.c:3381:         if (other && other->nameTextId == ch->nameTextId && other->pSupportData)
	cmp	r3, #0	@ _50,
	beq	.L1086		@,
	b	.L1085		@
.L1113:
	.align	2
.L1112:
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
	.word	.LC566
	.word	InitText
	.word	Text_DrawString
	.word	GetCharacterData
	.word	BlankString
	.word	GetStringFromIndex
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
@ Data/FE6_FE7.c:3478:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L1187	@ tmp198,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r6, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:3474: {
	movs	r4, r0	@ proc, tmp392
@ Data/FE6_FE7.c:3479:     if (keys & B_BUTTON)
	lsls	r3, r6, #30	@ tmp394, keys,
	bpl	.LCB8015	@
	b	.L1180	@long jump	@
.LCB8015:
.L1115:
@ Data/FE6_FE7.c:3484:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp210,
	tst	r3, r6	@ tmp210, keys
	beq	.LCB8022	@
	b	.L1181	@long jump	@
.LCB8022:
.L1116:
@ Data/FE6_FE7.c:3492:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r2, #48	@ tmp225,
@ Data/FE6_FE7.c:3490:     if (proc->editing)
	movs	r5, #46	@ tmp219,
	movs	r7, #16	@ tmp223,
@ Data/FE6_FE7.c:3492:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r2]	@ tmp226,
@ Data/FE6_FE7.c:3490:     if (proc->editing)
	ldrsb	r3, [r4, r5]	@ _2,
@ Data/FE6_FE7.c:3492:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r1, #1	@ tmp227,
	ands	r7, r6	@ _109, keys
@ Data/FE6_FE7.c:3492:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ _151, tmp227,
@ Data/FE6_FE7.c:3490:     if (proc->editing)
	cmp	r3, #0	@ _2,
	bne	.LCB8035	@
	b	.L1120	@long jump	@
.LCB8035:
@ Data/FE6_FE7.c:3492:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r2, r2, #1	@ tmp229,
	ldrsb	r2, [r4, r2]	@ tmp230,
@ Data/FE6_FE7.c:3492:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r3, .L1187+4	@ tmp228,
	lsls	r2, r2, #3	@ tmp231, tmp230,
	adds	r3, r3, r2	@ tmp232, tmp228, tmp231
@ Data/FE6_FE7.c:3492:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r0, [r3, #120]	@ CursorLocationTable[_4].x, CursorLocationTable[_4].x
	bl	DisplayVertUiHand		@
	ldr	r3, .L1187+8	@ tmp379,
@ Data/FE6_FE7.c:546:     int result = 1;
	subs	r5, r5, #45	@ result,
	mov	r8, r3	@ tmp379, tmp379
	adds	r3, r3, #76	@ ivtmp.1091,
.L1121:
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	adds	r3, r3, #4	@ ivtmp.1091,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	subs	r1, r3, #4	@ tmp237, ivtmp.1091,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	ldr	r1, [r1]	@ MEM[(const int *)_105 + 4294967292B], MEM[(const int *)_105 + 4294967292B]
@ Data/FE6_FE7.c:549:         result++;
	adds	r5, r5, #1	@ result,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	cmp	r1, #254	@ MEM[(const int *)_105 + 4294967292B],
	ble	.L1121		@,
@ Data/FE6_FE7.c:551:     if (result > 9)
	cmp	r5, #9	@ _123,
	ble	.LCB8056	@
	b	.L1182	@long jump	@
.LCB8056:
@ Data/FE6_FE7.c:3497:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _109,
	beq	.L1123		@,
.L1186:
@ Data/FE6_FE7.c:3499:             if (proc->digit > 0)
	movs	r3, #49	@ tmp239,
	ldrsb	r3, [r4, r3]	@ _11,
@ Data/FE6_FE7.c:3499:             if (proc->digit > 0)
	cmp	r3, #0	@ _11,
	bgt	.LCB8063	@
	b	.L1124	@long jump	@
.LCB8063:
@ Data/FE6_FE7.c:3501:                 proc->digit--;
	subs	r3, r3, #1	@ tmp243,
	lsls	r3, r3, #24	@ tmp244, tmp243,
	asrs	r3, r3, #24	@ _15, tmp244,
.L1125:
	movs	r2, #49	@ tmp251,
@ Data/FE6_FE7.c:3508:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _15, proc_82(D)->digit
	bl	RedrawUnitSupportsMenu		@
.L1123:
@ Data/FE6_FE7.c:3510:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp395, keys,
	bpl	.L1126		@,
@ Data/FE6_FE7.c:3512:             if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp260,
	ldrsb	r3, [r4, r3]	@ _19,
@ Data/FE6_FE7.c:3512:             if (proc->digit < (max_digits - 1))
	subs	r5, r5, #1	@ tmp261,
@ Data/FE6_FE7.c:3512:             if (proc->digit < (max_digits - 1))
	cmp	r3, r5	@ _19, tmp261
	bge	.LCB8085	@
	b	.L1183	@long jump	@
.LCB8085:
@ Data/FE6_FE7.c:3519:                 proc->editing = false;
	movs	r3, #46	@ tmp265,
	movs	r2, #0	@ tmp266,
	strb	r2, [r4, r3]	@ tmp266, proc_82(D)->editing
@ Data/FE6_FE7.c:3518:                 proc->digit = 0;
	movs	r3, #0	@ _25,
.L1128:
	movs	r2, #49	@ tmp268,
@ Data/FE6_FE7.c:3521:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _25, proc_82(D)->digit
	bl	RedrawUnitSupportsMenu		@
.L1126:
@ Data/FE6_FE7.c:3524:         if (keys & DPAD_UP)
	movs	r3, #64	@ tmp271,
	tst	r3, r6	@ tmp271, keys
	beq	.L1129		@,
@ Data/FE6_FE7.c:3526:             if (proc->tmp[proc->id] == max)
	movs	r2, #48	@ tmp277,
	ldrsb	r1, [r4, r2]	@ tmp278,
	lsls	r1, r1, #1	@ tmp279, tmp278,
	adds	r1, r4, r1	@ _146, proc, tmp279
@ Data/FE6_FE7.c:3526:             if (proc->tmp[proc->id] == max)
	ldrsh	r2, [r1, r3]	@ _28, MEM <s16> [(struct DebuggerProc *)_146 + 64B]
@ Data/FE6_FE7.c:3526:             if (proc->tmp[proc->id] == max)
	cmp	r2, #255	@ _28,
	bne	.LCB8110	@
	b	.L1142	@long jump	@
.LCB8110:
@ Data/FE6_FE7.c:3532:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	movs	r3, #49	@ tmp283,
	ldrsb	r3, [r4, r3]	@ tmp284,
@ Data/FE6_FE7.c:3532:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp285, tmp284,
	add	r3, r3, r8	@ tmp286, tmp379
@ Data/FE6_FE7.c:3532:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_31], DigitDecimalTable[_31]
	adds	r3, r3, r2	@ tmp291, DigitDecimalTable[_31], _28
@ Data/FE6_FE7.c:3533:                 if (proc->tmp[proc->id] > max)
	adds	r2, r3, #0	@ tmp281, tmp291
	lsls	r3, r3, #16	@ tmp294, tmp291,
	asrs	r3, r3, #16	@ tmp294, tmp294,
	cmp	r3, #255	@ tmp294,
	ble	.L1131		@,
	movs	r2, #255	@ tmp281,
.L1131:
	lsls	r3, r2, #16	@ _38, tmp281,
	asrs	r3, r3, #16	@ _38, _38,
.L1130:
@ Data/FE6_FE7.c:3528:                 proc->tmp[proc->id] = min;
	movs	r2, #64	@ tmp296,
@ Data/FE6_FE7.c:3538:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3528:                 proc->tmp[proc->id] = min;
	strh	r3, [r1, r2]	@ _38, MEM <s16> [(struct DebuggerProc *)_146 + 64B]
@ Data/FE6_FE7.c:3538:             RedrawUnitSupportsMenu(proc);
	bl	RedrawUnitSupportsMenu		@
.L1129:
@ Data/FE6_FE7.c:3540:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp396, keys,
	bpl	.L1114		@,
@ Data/FE6_FE7.c:3543:             if (proc->tmp[proc->id] == min)
	movs	r3, #48	@ tmp305,
	ldrsb	r1, [r4, r3]	@ tmp306,
	lsls	r1, r1, #1	@ tmp307, tmp306,
@ Data/FE6_FE7.c:3543:             if (proc->tmp[proc->id] == min)
	adds	r3, r3, #16	@ tmp308,
	adds	r1, r4, r1	@ _8, proc, tmp307
	ldrsh	r2, [r1, r3]	@ _39, MEM <s16> [(struct DebuggerProc *)_8 + 64B]
	movs	r3, #255	@ _112,
@ Data/FE6_FE7.c:3543:             if (proc->tmp[proc->id] == min)
	cmp	r2, #0	@ _39,
	bne	.L1184		@,
@ Data/FE6_FE7.c:3545:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp324,
@ Data/FE6_FE7.c:3556:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3545:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _112, MEM <s16> [(struct DebuggerProc *)_8 + 64B]
@ Data/FE6_FE7.c:3556:             RedrawUnitSupportsMenu(proc);
	bl	RedrawUnitSupportsMenu		@
.L1114:
@ Data/FE6_FE7.c:3593: }
	@ sp needed	@
	pop	{r7}
	mov	r8, r7
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1120:
@ Data/FE6_FE7.c:3561:         DisplayUiHand(CursorLocationTable[0].x - ((SupportWidth + 2) * 8), (Y_HAND + (proc->id * 2)) * 8);
	movs	r0, #92	@,
	ldr	r3, .L1187+12	@ tmp326,
	bl	.L17		@
@ Data/FE6_FE7.c:3562:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _109,
	beq	.L1136		@,
@ Data/FE6_FE7.c:3564:             proc->digit = 1;
	movs	r3, #1	@ tmp328,
	movs	r2, #49	@ tmp327,
	strb	r3, [r4, r2]	@ tmp328, proc_82(D)->digit
@ Data/FE6_FE7.c:3565:             proc->editing = true;
	strb	r3, [r4, r5]	@ tmp328, proc_82(D)->editing
.L1136:
@ Data/FE6_FE7.c:3567:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp397, keys,
	bpl	.L1137		@,
@ Data/FE6_FE7.c:3569:             proc->digit = 0;
	movs	r3, #49	@ tmp340,
	movs	r2, #0	@ tmp341,
	strb	r2, [r4, r3]	@ tmp341, proc_82(D)->digit
@ Data/FE6_FE7.c:3570:             proc->editing = true;
	subs	r3, r3, #3	@ tmp343,
	adds	r2, r2, #1	@ tmp344,
	strb	r2, [r4, r3]	@ tmp344, proc_82(D)->editing
.L1137:
@ Data/FE6_FE7.c:3573:         if (keys & DPAD_UP)
	lsls	r3, r6, #25	@ tmp398, keys,
	bpl	.L1138		@,
@ Data/FE6_FE7.c:3575:             proc->id--;
	movs	r3, #48	@ tmp353,
@ Data/FE6_FE7.c:3575:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp355,
	subs	r3, r3, #1	@ tmp356,
	lsls	r3, r3, #24	@ tmp357, tmp356,
	asrs	r2, r3, #24	@ _58, tmp357,
@ Data/FE6_FE7.c:3576:             if (proc->id < 0)
	cmp	r3, #0	@ tmp357,
	blt	.L1185		@,
	movs	r3, #48	@ tmp361,
@ Data/FE6_FE7.c:3580:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _58, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitSupportsMenu		@
.L1138:
@ Data/FE6_FE7.c:3582:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp399, keys,
	bpl	.L1114		@,
@ Data/FE6_FE7.c:3584:             proc->id++;
	movs	r1, #48	@ tmp370,
@ Data/FE6_FE7.c:3587:                 proc->id = 0;
	movs	r0, #6	@ tmp382,
	movs	r5, #0	@ tmp384,
@ Data/FE6_FE7.c:3584:             proc->id++;
	ldrb	r3, [r4, r1]	@ tmp372,
	adds	r3, r3, #1	@ tmp373,
	lsls	r3, r3, #24	@ tmp374, tmp373,
	asrs	r2, r3, #24	@ _64, tmp374,
@ Data/FE6_FE7.c:3587:                 proc->id = 0;
	lsrs	r3, r3, #31	@ tmp383, tmp374,
	cmp	r0, r2	@ tmp382, _64
	adcs	r3, r3, r5	@ tmp381, tmp383, tmp384
	rsbs	r3, r3, #0	@ tmp385, tmp381
	ands	r2, r3	@ _64, tmp385
@ Data/FE6_FE7.c:3590:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r1]	@ _64, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitSupportsMenu		@
@ Data/FE6_FE7.c:3593: }
	b	.L1114		@
.L1182:
@ Data/FE6_FE7.c:551:     if (result > 9)
	movs	r5, #9	@ _123,
@ Data/FE6_FE7.c:3497:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _109,
	bne	.LCB8237	@
	b	.L1123	@long jump	@
.LCB8237:
	b	.L1186		@
.L1181:
@ Data/FE6_FE7.c:3462:     u8 * row = GetUnitBwlSupportRow(unit);
	ldr	r0, [r4, #60]	@ proc_82(D)->unit, proc_82(D)->unit
	bl	GetUnitBwlSupportRow		@
@ Data/FE6_FE7.c:3463:     if (!row)
	cmp	r0, #0	@ row,
	beq	.L1119		@,
	movs	r3, r4	@ ivtmp.1099, proc
	movs	r1, r4	@ _52, proc
	adds	r3, r3, #64	@ ivtmp.1099,
	adds	r1, r1, #78	@ _52,
.L1118:
@ Data/FE6_FE7.c:3469:         row[i] = proc->tmp[i];
	ldrh	r2, [r3]	@ MEM[(short int *)_59], MEM[(short int *)_59]
@ Data/FE6_FE7.c:3467:     for (int i = 0; i < SupportOptions; ++i)
	adds	r3, r3, #2	@ ivtmp.1099,
@ Data/FE6_FE7.c:3469:         row[i] = proc->tmp[i];
	strb	r2, [r0]	@ MEM[(short int *)_59], MEM[(u8 *)_50]
@ Data/FE6_FE7.c:3467:     for (int i = 0; i < SupportOptions; ++i)
	adds	r0, r0, #1	@ ivtmp.1101,
	cmp	r1, r3	@ _52, ivtmp.1099
	bne	.L1118		@,
.L1119:
@ Data/FE6_FE7.c:3487:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L1187+16	@ tmp215,
	bl	.L17		@
@ Data/FE6_FE7.c:584: }
	b	.L1116		@
.L1180:
@ Data/FE6_FE7.c:3481:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	ldr	r3, .L1187+16	@ tmp206,
	bl	.L17		@
@ Data/FE6_FE7.c:584: }
	b	.L1115		@
.L1184:
@ Data/FE6_FE7.c:3549:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	subs	r3, r3, #206	@ tmp311,
	ldrsb	r3, [r4, r3]	@ tmp312,
@ Data/FE6_FE7.c:3549:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp313, tmp312,
	add	r3, r3, r8	@ tmp314, tmp379
@ Data/FE6_FE7.c:3549:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	ldr	r0, [r3, #68]	@ DigitDecimalTable[_42], DigitDecimalTable[_42]
	subs	r0, r2, r0	@ tmp319, _39, DigitDecimalTable[_42]
@ Data/FE6_FE7.c:3550:                 if (proc->tmp[proc->id] < min)
	lsls	r3, r0, #16	@ tmp322, tmp319,
	asrs	r3, r3, #16	@ tmp322, tmp322,
	mvns	r3, r3	@ tmp387, tmp322
@ Data/FE6_FE7.c:3545:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp324,
@ Data/FE6_FE7.c:3550:                 if (proc->tmp[proc->id] < min)
	asrs	r3, r3, #31	@ tmp391, tmp387,
	ands	r3, r0	@ tmp309, tmp319
	lsls	r3, r3, #16	@ _112, tmp309,
	asrs	r3, r3, #16	@ _112, _112,
@ Data/FE6_FE7.c:3556:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3545:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _112, MEM <s16> [(struct DebuggerProc *)_8 + 64B]
@ Data/FE6_FE7.c:3556:             RedrawUnitSupportsMenu(proc);
	bl	RedrawUnitSupportsMenu		@
	b	.L1114		@
.L1183:
@ Data/FE6_FE7.c:3514:                 proc->digit++;
	adds	r3, r3, #1	@ tmp263,
	lsls	r3, r3, #24	@ tmp264, tmp263,
	asrs	r3, r3, #24	@ _25, tmp264,
	b	.L1128		@
.L1185:
@ Data/FE6_FE7.c:3578:                 proc->id = SupportOptions - 1;
	movs	r2, #6	@ _58,
	movs	r3, #48	@ tmp361,
@ Data/FE6_FE7.c:3580:             RedrawUnitSupportsMenu(proc);
	movs	r0, r4	@, proc
	strb	r2, [r4, r3]	@ _58, MEM <struct DebuggerProc> [(void *)proc_82(D)].id
	bl	RedrawUnitSupportsMenu		@
	b	.L1138		@
.L1124:
@ Data/FE6_FE7.c:3506:                 proc->editing = false;
	movs	r2, #46	@ tmp248,
	movs	r1, #0	@ tmp249,
@ Data/FE6_FE7.c:3505:                 proc->digit = max_digits - 1;
	subs	r3, r5, #1	@ tmp246, _123,
	lsls	r3, r3, #24	@ tmp247, tmp246,
@ Data/FE6_FE7.c:3506:                 proc->editing = false;
	strb	r1, [r4, r2]	@ tmp249, proc_82(D)->editing
@ Data/FE6_FE7.c:3505:                 proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _15, tmp247,
	b	.L1125		@
.L1142:
	movs	r3, #0	@ _38,
	b	.L1130		@
.L1188:
	.align	2
.L1187:
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
@ Data/FE6_FE7.c:3460: {
	movs	r4, r0	@ proc, tmp130
@ Data/FE6_FE7.c:3462:     u8 * row = GetUnitBwlSupportRow(unit);
	ldr	r0, [r0, #60]	@ proc_9(D)->unit, proc_9(D)->unit
	bl	GetUnitBwlSupportRow		@
	subs	r2, r0, #0	@ row, tmp131,
@ Data/FE6_FE7.c:3463:     if (!row)
	beq	.L1189		@,
	movs	r3, r4	@ ivtmp.1112, proc
	adds	r4, r4, #78	@ _28,
	adds	r3, r3, #64	@ ivtmp.1112,
.L1191:
@ Data/FE6_FE7.c:3469:         row[i] = proc->tmp[i];
	ldrh	r1, [r3]	@ MEM[(short int *)_25], MEM[(short int *)_25]
@ Data/FE6_FE7.c:3467:     for (int i = 0; i < SupportOptions; ++i)
	adds	r3, r3, #2	@ ivtmp.1112,
@ Data/FE6_FE7.c:3469:         row[i] = proc->tmp[i];
	strb	r1, [r2]	@ MEM[(short int *)_25], MEM[(u8 *)_26]
@ Data/FE6_FE7.c:3467:     for (int i = 0; i < SupportOptions; ++i)
	adds	r2, r2, #1	@ ivtmp.1114,
	cmp	r3, r4	@ ivtmp.1112, _28
	bne	.L1191		@,
.L1189:
@ Data/FE6_FE7.c:3471: }
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
@ Data/FE6_FE7.c:3672:     u8 * skills = GetUnitLearnedSkillRam(proc->unit);
	ldr	r3, [r0, #60]	@ _1, proc_10(D)->unit
@ Data/FE6_FE7.c:3603:     if (!unit)
	cmp	r3, #0	@ _1,
	beq	.L1196		@,
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	movs	r1, #11	@ tmp133,
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	movs	r2, #192	@ tmp134,
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	ldrsb	r1, [r3, r1]	@ tmp133,
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	ands	r2, r1	@ tmp135, tmp133
@ Data/FE6_FE7.c:3620:     return LearnedSkillCount;
	rsbs	r1, r2, #0	@ tmp144, tmp135
	adcs	r2, r2, r1	@ tmp143, tmp135, tmp144
	adds	r2, r2, #6	@ _16,
	adds	r0, r0, #64	@ ivtmp.1122,
	lsls	r2, r2, #1	@ tmp137, _16,
	adds	r3, r3, #50	@ ivtmp.1124,
	adds	r2, r0, r2	@ _34, ivtmp.1122, tmp137
.L1199:
@ Data/FE6_FE7.c:3681:         skills[i] = (u8)proc->tmp[i];
	ldrh	r1, [r0]	@ MEM[(short int *)_12], MEM[(short int *)_12]
@ Data/FE6_FE7.c:3679:     for (i = 0; i < limit; ++i)
	adds	r0, r0, #2	@ ivtmp.1122,
@ Data/FE6_FE7.c:3681:         skills[i] = (u8)proc->tmp[i];
	strb	r1, [r3]	@ MEM[(short int *)_12], MEM[(u8 *)_11]
@ Data/FE6_FE7.c:3679:     for (i = 0; i < limit; ++i)
	adds	r3, r3, #1	@ ivtmp.1124,
	cmp	r0, r2	@ ivtmp.1122, _34
	bne	.L1199		@,
@ Data/FE6_FE7.c:3625:     *(struct Unit **)0x0202A9D4 = NULL;
	movs	r2, #0	@ tmp142,
	ldr	r3, .L1205	@ tmp141,
	str	r2, [r3]	@ tmp142, MEM[(struct Unit * *)33728980B]
.L1196:
@ Data/FE6_FE7.c:3684: }
	@ sp needed	@
	bx	lr
.L1206:
	.align	2
.L1205:
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
@ Data/FE6_FE7.c:3688:     if (!gActiveUnit)
	ldr	r3, .L1210	@ tmp118,
@ Data/FE6_FE7.c:3693: }
	@ sp needed	@
@ Data/FE6_FE7.c:3688:     if (!gActiveUnit)
	ldr	r0, [r3]	@ gActiveUnit, gActiveUnit
@ Data/FE6_FE7.c:3692:     return usable;
	rsbs	r3, r0, #0	@ tmp122, gActiveUnit
	adcs	r0, r0, r3	@ tmp121, gActiveUnit, tmp122
	adds	r0, r0, #1	@ <retval>,
@ Data/FE6_FE7.c:3693: }
	bx	lr
.L1211:
	.align	2
.L1210:
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
@ Data/FE6_FE7.c:3698:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r3, .L1213	@ tmp119,
@ Data/FE6_FE7.c:3701: }
	@ sp needed	@
@ Data/FE6_FE7.c:3698:     proc = Proc_Find(DebuggerProcCmd);
	ldr	r0, .L1213+4	@ tmp118,
	bl	.L17		@
@ Data/FE6_FE7.c:3699:     Proc_Goto(proc, EditSkillsLabel);
	movs	r1, #21	@,
	ldr	r3, .L1213+8	@ tmp120,
	bl	.L17		@
@ Data/FE6_FE7.c:3701: }
	movs	r0, #23	@,
	pop	{r4}
	pop	{r1}
	bx	r1
.L1214:
	.align	2
.L1213:
	.word	Proc_Find
	.word	DebuggerProcCmd
	.word	Proc_Goto
	.size	EditSkillsNow, .-EditSkillsNow
	.section	.rodata.str1.4
	.align	2
.LC583:
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
@ Data/FE6_FE7.c:3748:     int limit = GetUnitLearnedSkillLimit(proc->unit);
	ldr	r3, [r0, #60]	@ _1, proc_35(D)->unit
@ Data/FE6_FE7.c:3747: {
	movs	r4, r0	@ proc, tmp214
	sub	sp, sp, #28	@,,
@ Data/FE6_FE7.c:3612:     if (!unit)
	cmp	r3, #0	@ _1,
	bne	.LCB8471	@
	b	.L1216	@long jump	@
.LCB8471:
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	movs	r2, #192	@ tmp154,
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	ldrb	r3, [r3, #11]	@ tmp153,
	lsls	r3, r3, #24	@ tmp153, tmp153,
	asrs	r3, r3, #24	@ tmp153, tmp153,
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	tst	r2, r3	@ tmp154, tmp153
	beq	.LCB8478	@
	b	.L1229	@long jump	@
.LCB8478:
@ Data/FE6_FE7.c:3620:     return LearnedSkillCount;
	movs	r3, #7	@ _51,
	str	r3, [sp, #4]	@ _51, %sfp
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	subs	r2, r2, #178	@ prephitmp_82,
.L1217:
@ Data/FE6_FE7.c:3758:     for (i = 0; i < limit; ++i)
	movs	r7, #0	@ i,
@ Data/FE6_FE7.c:3754:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 6, Y_HAND), 14, 2 * limit, 0);
	ldr	r6, .L1249	@ tmp156,
	movs	r1, #14	@,
	movs	r0, r6	@, tmp156
	movs	r3, #0	@,
	ldr	r5, .L1249+4	@ tmp157,
	bl	.L28		@
@ Data/FE6_FE7.c:3755:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L1249+8	@ tmp210,
	movs	r0, #1	@,
	str	r3, [sp, #20]	@ tmp210, %sfp
	bl	.L17		@
@ Data/FE6_FE7.c:3756:     ResetIconGraphics();
	ldr	r3, .L1249+12	@ tmp159,
	bl	.L17		@
@ Data/FE6_FE7.c:3757:     LoadIconPalettes(4);
	ldr	r3, .L1249+16	@ tmp160,
	movs	r0, #4	@,
	bl	.L17		@
	ldr	r3, .L1249+20	@ tmp206,
	mov	fp, r3	@ tmp206, tmp206
	ldr	r3, .L1249+24	@ tmp207,
	mov	r10, r3	@ tmp207, tmp207
	ldr	r3, .L1249+28	@ tmp208,
	mov	r9, r3	@ tmp208, tmp208
	ldr	r3, .L1249+32	@ tmp209,
	mov	r8, r3	@ tmp209, tmp209
@ Data/FE6_FE7.c:3633:         return "---";
	ldr	r3, .L1249+36	@ _59,
	str	r3, [sp, #8]	@ _59, %sfp
@ Data/FE6_FE7.c:3631:     if (skillId == 0 || skillId == 0xFF || !SkillDescTable[skillId])
	ldr	r3, .L1249+40	@ tmp212,
	str	r3, [sp, #12]	@ tmp212, %sfp
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	ldr	r3, .L1249+44	@ _59,
	ldr	r5, .L1249+48	@ ivtmp.1143,
	str	r3, [sp, #16]	@ _59, %sfp
	adds	r4, r4, #64	@ ivtmp.1145,
	subs	r6, r6, #8	@ ivtmp.1147,
.L1227:
@ Data/FE6_FE7.c:3760:         ClearText(&th[i]);
	movs	r0, r5	@, ivtmp.1143
	bl	.L311		@
@ Data/FE6_FE7.c:3761:         Text_DrawString(&th[i], GetLearnedSkillName(proc->tmp[i]));
	movs	r2, #0	@ tmp243,
	ldrsh	r3, [r4, r2]	@ _8, ivtmp.1145, tmp243
@ Data/FE6_FE7.c:3631:     if (skillId == 0 || skillId == 0xFF || !SkillDescTable[skillId])
	cmp	r3, #0	@ _8,
	beq	.L1221		@,
	cmp	r3, #255	@ _8,
	beq	.L1221		@,
@ Data/FE6_FE7.c:3631:     if (skillId == 0 || skillId == 0xFF || !SkillDescTable[skillId])
	ldr	r2, [sp, #12]	@ tmp212, %sfp
	lsls	r3, r3, #1	@ tmp174, _8,
	ldrh	r0, [r3, r2]	@ _55, SkillDescTable
@ Data/FE6_FE7.c:3631:     if (skillId == 0 || skillId == 0xFF || !SkillDescTable[skillId])
	cmp	r0, #0	@ _55,
	beq	.L1221		@,
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	movs	r2, #128	@ tmp176,
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	subs	r3, r0, #1	@ tmp175, _55,
@ Data/FE6_FE7.c:69:         return (void *)BlankString;
	ldr	r1, [sp, #16]	@ _59, %sfp
@ Data/FE6_FE7.c:67:     if ((index > 0x4000) || (index <= 0))
	lsls	r2, r2, #7	@ tmp176, tmp176,
	cmp	r3, r2	@ tmp175, tmp176
	bcs	.L1222		@,
@ Data/FE6_FE7.c:71:     return GetStringFromIndex(index);
	ldr	r3, .L1249+52	@ tmp177,
	bl	.L17		@
	subs	r1, r0, #0	@ _59, tmp215,
@ Data/FE6_FE7.c:3636:     if (!desc)
	beq	.L1221		@,
.L1222:
@ Data/FE6_FE7.c:3640:     for (char * it = desc; *it; ++it)
	ldrb	r3, [r1]	@ _61, *_62
	cmp	r3, #0	@ _61,
	beq	.L1220		@,
@ Data/FE6_FE7.c:3640:     for (char * it = desc; *it; ++it)
	movs	r2, r1	@ it, _59
	b	.L1225		@
.L1224:
@ Data/FE6_FE7.c:3640:     for (char * it = desc; *it; ++it)
	ldrb	r3, [r2, #1]	@ _61, MEM[(char *)it_64]
@ Data/FE6_FE7.c:3640:     for (char * it = desc; *it; ++it)
	adds	r2, r2, #1	@ it,
@ Data/FE6_FE7.c:3640:     for (char * it = desc; *it; ++it)
	cmp	r3, #0	@ _61,
	beq	.L1220		@,
.L1225:
@ Data/FE6_FE7.c:3642:         if (*it == ':')
	cmp	r3, #58	@ _61,
	bne	.L1224		@,
@ Data/FE6_FE7.c:3644:             *it = 0;
	movs	r3, #0	@ tmp178,
	strb	r3, [r2]	@ tmp178, *it_75
.L1220:
@ Data/FE6_FE7.c:3761:         Text_DrawString(&th[i], GetLearnedSkillName(proc->tmp[i]));
	movs	r0, r5	@, ivtmp.1143
	bl	.L310		@
@ Data/FE6_FE7.c:3762:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(nameX, Y_HAND + (i * 2)));
	movs	r1, r6	@, ivtmp.1147
	movs	r0, r5	@, ivtmp.1143
	bl	.L139		@
@ Data/FE6_FE7.c:3763:         PutNumber(gBG0TilemapBuffer + TILEMAP_INDEX(START_X, Y_HAND + (i * 2)), TEXT_COLOR_SYSTEM_GOLD, proc->tmp[i]);
	movs	r0, r6	@ tmp183, ivtmp.1147
	movs	r1, #3	@,
	movs	r3, #0	@ tmp244,
	ldrsh	r2, [r4, r3]	@ MEM[(short int *)_94], ivtmp.1145, tmp244
	adds	r0, r0, #24	@ tmp183,
	bl	.L193		@
@ Data/FE6_FE7.c:3764:         if (proc->tmp[i] && proc->tmp[i] != 0xFF)
	movs	r3, #0	@ tmp245,
	ldrsh	r1, [r4, r3]	@ _47, ivtmp.1145, tmp245
@ Data/FE6_FE7.c:3762:         PutText(&th[i], gBG0TilemapBuffer + TILEMAP_INDEX(nameX, Y_HAND + (i * 2)));
	adds	r7, r7, #1	@ i,
@ Data/FE6_FE7.c:3764:         if (proc->tmp[i] && proc->tmp[i] != 0xFF)
	cmp	r1, #0	@ _47,
	beq	.L1226		@,
	cmp	r1, #255	@ _47,
	beq	.L1226		@,
@ Data/FE6_FE7.c:3766:             DrawIcon(
	movs	r2, #128	@,
	adds	r1, r1, #1	@ tmp197,
	ldr	r3, .L1249+56	@ tmp199,
	adds	r1, r1, #255	@ tmp197,
	subs	r0, r6, #4	@ tmp198, ivtmp.1147,
	lsls	r2, r2, #7	@,,
	bl	.L17		@
.L1226:
@ Data/FE6_FE7.c:3758:     for (i = 0; i < limit; ++i)
	ldr	r3, [sp, #4]	@ _51, %sfp
	adds	r5, r5, #8	@ ivtmp.1143,
	adds	r4, r4, #2	@ ivtmp.1145,
	adds	r6, r6, #128	@ ivtmp.1147,
	cmp	r7, r3	@ i, _51
	blt	.L1227		@,
.L1228:
@ Data/FE6_FE7.c:3772:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	movs	r0, #1	@,
	ldr	r3, [sp, #20]	@ tmp210, %sfp
	bl	.L17		@
@ Data/FE6_FE7.c:3773: }
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
.L1221:
@ Data/FE6_FE7.c:3633:         return "---";
	ldr	r1, [sp, #8]	@ _59, %sfp
	b	.L1220		@
.L1229:
@ Data/FE6_FE7.c:3618:         return 6; /* keep supports[6] leader */
	movs	r3, #6	@ _51,
	movs	r2, #12	@ prephitmp_82,
	str	r3, [sp, #4]	@ _51, %sfp
	b	.L1217		@
.L1216:
@ Data/FE6_FE7.c:3754:     TileMap_FillRect(gBG0TilemapBuffer + TILEMAP_INDEX(NUMBER_X - 6, Y_HAND), 14, 2 * limit, 0);
	movs	r2, #0	@,
	movs	r1, #14	@,
	movs	r3, #0	@,
	ldr	r0, .L1249	@ tmp201,
	ldr	r4, .L1249+4	@ tmp202,
	bl	.L27		@
@ Data/FE6_FE7.c:3755:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L1249+8	@ tmp210,
	movs	r0, #1	@,
	str	r3, [sp, #20]	@ tmp210, %sfp
	bl	.L17		@
@ Data/FE6_FE7.c:3756:     ResetIconGraphics();
	ldr	r3, .L1249+12	@ tmp204,
	bl	.L17		@
@ Data/FE6_FE7.c:3757:     LoadIconPalettes(4);
	movs	r0, #4	@,
	ldr	r3, .L1249+16	@ tmp205,
	bl	.L17		@
	b	.L1228		@
.L1250:
	.align	2
.L1249:
	.word	gBG0TilemapBuffer+150
	.word	TileMap_FillRect
	.word	BG_EnableSyncByMask
	.word	ResetIconGraphics
	.word	LoadIconPalettes
	.word	ClearText
	.word	Text_DrawString
	.word	PutText
	.word	PutNumber
	.word	.LC583
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
@ Data/FE6_FE7.c:3706:     int limit = GetUnitLearnedSkillLimit(proc->unit);
	ldr	r3, [r0, #60]	@ _1, proc_20(D)->unit
@ Data/FE6_FE7.c:3704: {
	movs	r5, r0	@ proc, tmp198
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:3612:     if (!unit)
	cmp	r3, #0	@ _1,
	bne	.LCB8690	@
	b	.L1262	@long jump	@
.LCB8690:
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	movs	r2, #192	@ tmp143,
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	ldrb	r3, [r3, #11]	@ tmp142,
	lsls	r3, r3, #24	@ tmp142, tmp142,
	asrs	r3, r3, #24	@ tmp142, tmp142,
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	tst	r2, r3	@ tmp143, tmp142
	bne	.L1263		@,
	movs	r3, #16	@ prephitmp_63,
@ Data/FE6_FE7.c:3620:     return LearnedSkillCount;
	movs	r6, #7	@ _40,
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	mov	r10, r3	@ prephitmp_63, prephitmp_63
.L1252:
@ Data/FE6_FE7.c:406:     ResetTextFont();
	ldr	r3, .L1269	@ tmp145,
	mov	r9, r3	@ tmp145, tmp145
	bl	.L17		@
@ Data/FE6_FE7.c:407:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	ldr	r7, .L1269+4	@ tmp146,
	bl	.L145		@
@ Data/FE6_FE7.c:410:     BG_Fill(gBG0TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1269+8	@ tmp147,
	ldr	r3, .L1269+12	@ tmp148,
	bl	.L17		@
@ Data/FE6_FE7.c:411:     BG_EnableSyncByMask(BG0_SYNC_BIT);
	ldr	r3, .L1269+16	@ tmp191,
	movs	r0, #1	@,
	mov	r8, r3	@ tmp191, tmp191
	bl	.L17		@
@ Data/FE6_FE7.c:412:     ResetTextFont();
	bl	.L139		@
@ Data/FE6_FE7.c:413:     SetTextFontGlyphs(0);
	movs	r0, #0	@,
	bl	.L145		@
@ Data/FE6_FE7.c:414:     SetTextFont(0);
	movs	r0, #0	@,
	ldr	r3, .L1269+20	@ tmp152,
	bl	.L17		@
@ Data/FE6_FE7.c:415:     ClearBg0Bg1();
	ldr	r3, .L1269+24	@ tmp153,
	bl	.L17		@
@ Data/FE6_FE7.c:416:     ResetText();
	ldr	r3, .L1269+28	@ tmp154,
	bl	.L17		@
@ Data/FE6_FE7.c:3712:     LoadIconPalettes(4);
	movs	r0, #4	@,
	ldr	r3, .L1269+32	@ tmp155,
	bl	.L17		@
@ Data/FE6_FE7.c:3625:     *(struct Unit **)0x0202A9D4 = NULL;
	movs	r3, #0	@ tmp157,
	ldr	r2, .L1269+36	@ tmp156,
	str	r3, [r2]	@ tmp157, MEM[(struct Unit * *)33728980B]
@ Data/FE6_FE7.c:3714:     skills = GetUnitLearnedSkillRam(proc->unit);
	ldr	r0, [r5, #60]	@ _2, proc_20(D)->unit
@ Data/FE6_FE7.c:3603:     if (!unit)
	cmp	r0, #0	@ _2,
	beq	.L1268		@,
	movs	r1, r5	@ vectp.1161, proc
@ Data/FE6_FE7.c:3717:         proc->tmp[i] = 0;
	movs	r2, #76	@ tmp170,
	str	r3, [r5, #64]	@ tmp157, MEM <vector(2) short int> [(short int *)proc_20(D) + 64B]
	str	r3, [r5, #68]	@ tmp157, MEM <vector(2) short int> [(short int *)proc_20(D) + 68B]
	str	r3, [r5, #72]	@ tmp157, MEM <vector(2) short int> [(short int *)proc_20(D) + 72B]
	adds	r1, r1, #64	@ vectp.1161,
	strh	r3, [r5, r2]	@ tmp157, proc_20(D)->tmp[6]
@ Data/FE6_FE7.c:3721:         for (i = 0; i < limit; ++i)
	cmp	r6, #0	@ _40,
	beq	.L1256		@,
	lsls	r7, r6, #1	@ tmp174, _40,
	adds	r0, r0, #50	@ ivtmp.1173,
	adds	r7, r1, r7	@ _88, ivtmp.1175, tmp174
.L1258:
@ Data/FE6_FE7.c:3723:             proc->tmp[i] = (skills[i] == 0xFF) ? 0 : skills[i];
	ldrb	r2, [r0]	@ _5, MEM[(u8 *)_82]
@ Data/FE6_FE7.c:3723:             proc->tmp[i] = (skills[i] == 0xFF) ? 0 : skills[i];
	movs	r3, r2	@ tmp195, _5
	subs	r3, r3, #255	@ tmp195,
	subs	r4, r3, #1	@ tmp196, tmp195
	sbcs	r3, r3, r4	@ tmp194, tmp195, tmp196
	rsbs	r3, r3, #0	@ tmp197, tmp194
	ands	r2, r3	@ _5, tmp197
@ Data/FE6_FE7.c:3723:             proc->tmp[i] = (skills[i] == 0xFF) ? 0 : skills[i];
	strh	r2, [r1]	@ _5, MEM[(short int *)_83]
@ Data/FE6_FE7.c:3721:         for (i = 0; i < limit; ++i)
	adds	r1, r1, #2	@ ivtmp.1175,
	adds	r0, r0, #1	@ ivtmp.1173,
	cmp	r1, r7	@ ivtmp.1175, _88
	bne	.L1258		@,
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	movs	r3, #0	@ tmp188,
	movs	r0, #2	@,
	str	r3, [sp]	@ tmp188,
	movs	r2, #22	@,
	mov	r3, r10	@, prephitmp_63
	movs	r1, #1	@,
	ldr	r7, .L1269+40	@ tmp189,
	bl	.L145		@
@ Data/FE6_FE7.c:3733:     BG_EnableSyncByMask(BG2_SYNC_BIT);
	movs	r0, #4	@,
	bl	.L193		@
.L1254:
	ldr	r4, .L1269+44	@ ivtmp.1168,
	lsls	r6, r6, #3	@ tmp178, _40,
	ldr	r7, .L1269+48	@ tmp192,
	adds	r6, r4, r6	@ _66, ivtmp.1168, tmp178
.L1261:
@ Data/FE6_FE7.c:3738:         InitText(&th[i], LearnedSkillNameWidth);
	movs	r0, r4	@, ivtmp.1168
	movs	r1, #12	@,
@ Data/FE6_FE7.c:3736:     for (i = 0; i < limit; ++i)
	adds	r4, r4, #8	@ ivtmp.1168,
@ Data/FE6_FE7.c:3738:         InitText(&th[i], LearnedSkillNameWidth);
	bl	.L145		@
@ Data/FE6_FE7.c:3736:     for (i = 0; i < limit; ++i)
	cmp	r4, r6	@ ivtmp.1168, _66
	bne	.L1261		@,
.L1260:
@ Data/FE6_FE7.c:3740:     proc->id = 0;
	movs	r3, #0	@ tmp180,
@ Data/FE6_FE7.c:3742:     proc->editing = false;
	movs	r2, #0	@ tmp181,
@ Data/FE6_FE7.c:3740:     proc->id = 0;
	strh	r3, [r5, #48]	@ tmp180, MEM <vector(2) signed char> [(signed char *)proc_20(D) + 48B]
@ Data/FE6_FE7.c:3742:     proc->editing = false;
	adds	r3, r3, #46	@ tmp182,
@ Data/FE6_FE7.c:3743:     RedrawLearnedSkillsMenu(proc);
	movs	r0, r5	@, proc
@ Data/FE6_FE7.c:3742:     proc->editing = false;
	strb	r2, [r5, r3]	@ tmp181, proc_20(D)->editing
@ Data/FE6_FE7.c:3743:     RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
@ Data/FE6_FE7.c:3744: }
	add	sp, sp, #8	@,,
	@ sp needed	@
	pop	{r5, r6, r7}
	mov	r10, r7
	mov	r9, r6
	mov	r8, r5
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1263:
	movs	r3, #14	@ prephitmp_63,
@ Data/FE6_FE7.c:3618:         return 6; /* keep supports[6] leader */
	movs	r6, #6	@ _40,
	mov	r10, r3	@ prephitmp_63, prephitmp_63
	b	.L1252		@
.L1268:
@ Data/FE6_FE7.c:3717:         proc->tmp[i] = 0;
	adds	r3, r3, #76	@ tmp161,
	str	r0, [r5, #64]	@ _2, MEM <vector(2) short int> [(short int *)proc_20(D) + 64B]
	str	r0, [r5, #68]	@ _2, MEM <vector(2) short int> [(short int *)proc_20(D) + 68B]
	str	r0, [r5, #72]	@ _2, MEM <vector(2) short int> [(short int *)proc_20(D) + 72B]
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	movs	r2, #22	@,
@ Data/FE6_FE7.c:3717:         proc->tmp[i] = 0;
	strh	r0, [r5, r3]	@ _2, proc_20(D)->tmp[6]
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	movs	r1, #1	@,
	str	r0, [sp]	@ _2,
	mov	r3, r10	@, prephitmp_63
	adds	r0, r0, #2	@,
	ldr	r7, .L1269+40	@ tmp165,
	bl	.L145		@
@ Data/FE6_FE7.c:3733:     BG_EnableSyncByMask(BG2_SYNC_BIT);
	movs	r0, #4	@,
	bl	.L193		@
@ Data/FE6_FE7.c:3736:     for (i = 0; i < limit; ++i)
	cmp	r6, #0	@ _40,
	bne	.L1254		@,
	b	.L1260		@
.L1262:
	movs	r3, #2	@ prephitmp_63,
@ Data/FE6_FE7.c:3614:         return 0;
	movs	r6, #0	@ _40,
	mov	r10, r3	@ prephitmp_63, prephitmp_63
	b	.L1252		@
.L1256:
@ Data/FE6_FE7.c:60:     PutUiWindowFrame(x, y, width, height, style);
	str	r6, [sp]	@ _40,
	mov	r3, r10	@, prephitmp_63
	movs	r2, #22	@,
	movs	r1, #1	@,
	movs	r0, #2	@,
	ldr	r6, .L1269+40	@ tmp186,
	bl	.L38		@
@ Data/FE6_FE7.c:3733:     BG_EnableSyncByMask(BG2_SYNC_BIT);
	movs	r0, #4	@,
	bl	.L193		@
	b	.L1260		@
.L1270:
	.align	2
.L1269:
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
@ Data/FE6_FE7.c:3777:     u16 keys = gKeyStatusPtr->repeatedKeys;
	ldr	r3, .L1352	@ tmp206,
	ldr	r3, [r3]	@ gKeyStatusPtr, gKeyStatusPtr
	ldrh	r6, [r3, #6]	@ keys,
@ Data/FE6_FE7.c:3778:     int limit = GetUnitLearnedSkillLimit(proc->unit);
	ldr	r3, [r0, #60]	@ _2, proc_95(D)->unit
@ Data/FE6_FE7.c:3776: {
	movs	r4, r0	@ proc, tmp455
	sub	sp, sp, #8	@,,
@ Data/FE6_FE7.c:3612:     if (!unit)
	cmp	r3, #0	@ _2,
	bne	.LCB8886	@
	b	.L1298	@long jump	@
.LCB8886:
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	movs	r2, #11	@ tmp207,
	ldrsb	r2, [r3, r2]	@ tmp207,
@ Data/FE6_FE7.c:3616:     if ((unit->index & 0xC0) != 0)
	movs	r3, #192	@ tmp208,
	ands	r3, r2	@ tmp209, tmp207
@ Data/FE6_FE7.c:3620:     return LearnedSkillCount;
	rsbs	r2, r3, #0	@ tmp442, tmp209
	adcs	r3, r3, r2	@ tmp441, tmp209, tmp442
	adds	r5, r3, #6	@ _96, tmp441,
.L1272:
@ Data/FE6_FE7.c:3780:     if (keys & B_BUTTON)
	lsls	r3, r6, #30	@ tmp458, keys,
	bpl	.LCB8900	@
	b	.L1344	@long jump	@
.LCB8900:
.L1273:
@ Data/FE6_FE7.c:3788:     if ((keys & START_BUTTON) || (keys & A_BUTTON))
	movs	r3, #9	@ tmp235,
	tst	r3, r6	@ tmp235, keys
	beq	.LCB8907	@
	b	.L1345	@long jump	@
.LCB8907:
.L1274:
@ Data/FE6_FE7.c:3799:             proc->tmp[proc->id],
	movs	r7, #48	@ tmp254,
	ldrsb	r3, [r4, r7]	@ _189,
@ Data/FE6_FE7.c:3801:             (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r3, #1	@ tmp255, _189,
@ Data/FE6_FE7.c:3798:         TryShowSkillHelp(
	lsls	r1, r1, #4	@ prephitmp_186, tmp255,
@ Data/FE6_FE7.c:3796:     if (keys & SELECT_BUTTON)
	lsls	r2, r6, #29	@ tmp459, keys,
	bpl	.LCB8918	@
	b	.L1346	@long jump	@
.LCB8918:
.L1275:
@ Data/FE6_FE7.c:3803:     if (proc->editing)
	movs	r3, #46	@ tmp282,
	movs	r7, #16	@ tmp286,
	mov	r8, r3	@ tmp282, tmp282
	ldrsb	r3, [r4, r3]	@ _13,
	ands	r7, r6	@ _187, keys
@ Data/FE6_FE7.c:3803:     if (proc->editing)
	cmp	r3, #0	@ _13,
	bne	.LCB8928	@
	b	.L1276	@long jump	@
.LCB8928:
@ Data/FE6_FE7.c:3805:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	movs	r2, #49	@ tmp289,
@ Data/FE6_FE7.c:546:     int result = 1;
	movs	r5, #1	@ result,
@ Data/FE6_FE7.c:3805:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r2, [r4, r2]	@ tmp290,
@ Data/FE6_FE7.c:3805:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r3, .L1352+4	@ tmp288,
	lsls	r2, r2, #3	@ tmp291, tmp290,
	adds	r3, r3, r2	@ tmp292, tmp288, tmp291
@ Data/FE6_FE7.c:3805:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldr	r0, [r3, #120]	@ CursorLocationTable[_15].x, CursorLocationTable[_15].x
	bl	DisplayVertUiHand		@
	ldr	r3, .L1352+8	@ tmp440,
	mov	r8, r3	@ tmp440, tmp440
	adds	r3, r3, #76	@ ivtmp.1185,
.L1277:
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	adds	r3, r3, #4	@ ivtmp.1185,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	subs	r1, r3, #4	@ tmp297, ivtmp.1185,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	ldr	r1, [r1]	@ MEM[(const int *)_175 + 4294967292B], MEM[(const int *)_175 + 4294967292B]
@ Data/FE6_FE7.c:549:         result++;
	adds	r5, r5, #1	@ result,
@ Data/FE6_FE7.c:547:     while (number > pDigitTable[type][result])
	cmp	r1, #254	@ MEM[(const int *)_175 + 4294967292B],
	ble	.L1277		@,
@ Data/FE6_FE7.c:551:     if (result > 9)
	cmp	r5, #9	@ _146,
	ble	.LCB8949	@
	b	.L1347	@long jump	@
.LCB8949:
@ Data/FE6_FE7.c:3810:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _187,
	beq	.L1279		@,
.L1351:
@ Data/FE6_FE7.c:3812:             if (proc->digit > 0)
	movs	r3, #49	@ tmp299,
	ldrsb	r3, [r4, r3]	@ _22,
@ Data/FE6_FE7.c:3812:             if (proc->digit > 0)
	cmp	r3, #0	@ _22,
	bgt	.LCB8956	@
	b	.L1280	@long jump	@
.LCB8956:
@ Data/FE6_FE7.c:3814:                 proc->digit--;
	subs	r3, r3, #1	@ tmp303,
	lsls	r3, r3, #24	@ tmp304, tmp303,
	asrs	r3, r3, #24	@ _26, tmp304,
.L1281:
	movs	r2, #49	@ tmp311,
@ Data/FE6_FE7.c:3821:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _26, proc_95(D)->digit
	bl	RedrawLearnedSkillsMenu		@
.L1279:
@ Data/FE6_FE7.c:3823:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp460, keys,
	bpl	.L1282		@,
@ Data/FE6_FE7.c:3825:             if (proc->digit < (max_digits - 1))
	movs	r3, #49	@ tmp320,
	ldrsb	r3, [r4, r3]	@ _30,
@ Data/FE6_FE7.c:3825:             if (proc->digit < (max_digits - 1))
	subs	r5, r5, #1	@ tmp321,
@ Data/FE6_FE7.c:3825:             if (proc->digit < (max_digits - 1))
	cmp	r3, r5	@ _30, tmp321
	bge	.LCB8978	@
	b	.L1348	@long jump	@
.LCB8978:
@ Data/FE6_FE7.c:3832:                 proc->editing = false;
	movs	r3, #46	@ tmp325,
	movs	r2, #0	@ tmp326,
	strb	r2, [r4, r3]	@ tmp326, proc_95(D)->editing
@ Data/FE6_FE7.c:3831:                 proc->digit = 0;
	movs	r3, #0	@ _35,
.L1284:
	movs	r2, #49	@ tmp328,
@ Data/FE6_FE7.c:3834:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _35, proc_95(D)->digit
	bl	RedrawLearnedSkillsMenu		@
.L1282:
@ Data/FE6_FE7.c:3836:         if (keys & DPAD_UP)
	movs	r3, #64	@ tmp331,
	tst	r3, r6	@ tmp331, keys
	beq	.L1285		@,
@ Data/FE6_FE7.c:3838:             if (proc->tmp[proc->id] == max)
	movs	r2, #48	@ tmp337,
	ldrsb	r1, [r4, r2]	@ tmp338,
	lsls	r1, r1, #1	@ tmp339, tmp338,
	adds	r1, r4, r1	@ _143, proc, tmp339
@ Data/FE6_FE7.c:3838:             if (proc->tmp[proc->id] == max)
	ldrsh	r2, [r1, r3]	@ _38, MEM <s16> [(struct DebuggerProc *)_143 + 64B]
@ Data/FE6_FE7.c:3838:             if (proc->tmp[proc->id] == max)
	cmp	r2, #255	@ _38,
	bne	.LCB9003	@
	b	.L1300	@long jump	@
.LCB9003:
@ Data/FE6_FE7.c:3844:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	movs	r3, #49	@ tmp343,
	ldrsb	r3, [r4, r3]	@ tmp344,
@ Data/FE6_FE7.c:3844:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp345, tmp344,
	add	r3, r3, r8	@ tmp346, tmp440
@ Data/FE6_FE7.c:3844:                 proc->tmp[proc->id] += DigitDecimalTable[proc->digit];
	ldr	r3, [r3, #68]	@ DigitDecimalTable[_41], DigitDecimalTable[_41]
	adds	r3, r3, r2	@ tmp351, DigitDecimalTable[_41], _38
@ Data/FE6_FE7.c:3845:                 if (proc->tmp[proc->id] > max)
	adds	r2, r3, #0	@ tmp341, tmp351
	lsls	r3, r3, #16	@ tmp354, tmp351,
	asrs	r3, r3, #16	@ tmp354, tmp354,
	cmp	r3, #255	@ tmp354,
	ble	.L1287		@,
	movs	r2, #255	@ tmp341,
.L1287:
	lsls	r3, r2, #16	@ _123, tmp341,
	asrs	r3, r3, #16	@ _123, _123,
.L1286:
@ Data/FE6_FE7.c:3840:                 proc->tmp[proc->id] = min;
	movs	r2, #64	@ tmp356,
@ Data/FE6_FE7.c:3850:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3840:                 proc->tmp[proc->id] = min;
	strh	r3, [r1, r2]	@ _123, MEM <s16> [(struct DebuggerProc *)_143 + 64B]
@ Data/FE6_FE7.c:3850:             RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
.L1285:
@ Data/FE6_FE7.c:3852:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp461, keys,
	bpl	.L1271		@,
@ Data/FE6_FE7.c:3854:             if (proc->tmp[proc->id] == min)
	movs	r3, #48	@ tmp365,
	ldrsb	r1, [r4, r3]	@ tmp366,
	lsls	r1, r1, #1	@ tmp367, tmp366,
@ Data/FE6_FE7.c:3854:             if (proc->tmp[proc->id] == min)
	adds	r3, r3, #16	@ tmp368,
	adds	r1, r4, r1	@ _166, proc, tmp367
	ldrsh	r2, [r1, r3]	@ _48, MEM <s16> [(struct DebuggerProc *)_166 + 64B]
	movs	r3, #255	@ _47,
@ Data/FE6_FE7.c:3854:             if (proc->tmp[proc->id] == min)
	cmp	r2, #0	@ _48,
	beq	.LCB9042	@
	b	.L1349	@long jump	@
.LCB9042:
@ Data/FE6_FE7.c:3856:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp384,
@ Data/FE6_FE7.c:3866:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3856:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _47, MEM <s16> [(struct DebuggerProc *)_166 + 64B]
@ Data/FE6_FE7.c:3866:             RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
.L1271:
@ Data/FE6_FE7.c:3901: }
	add	sp, sp, #8	@,,
	@ sp needed	@
	pop	{r7}
	mov	r8, r7
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L1276:
@ Data/FE6_FE7.c:3871:         DisplayUiHand(CursorLocationTable[0].x - ((LearnedSkillNameWidth + 2) * 8), (Y_HAND + (proc->id * 2)) * 8);
	movs	r0, #36	@,
	ldr	r3, .L1352+12	@ tmp386,
	bl	.L17		@
@ Data/FE6_FE7.c:3872:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _187,
	beq	.L1292		@,
@ Data/FE6_FE7.c:3874:             proc->digit = 1;
	movs	r3, #1	@ tmp388,
	movs	r2, #49	@ tmp387,
	strb	r3, [r4, r2]	@ tmp388, proc_95(D)->digit
@ Data/FE6_FE7.c:3875:             proc->editing = true;
	mov	r2, r8	@ tmp282, tmp282
	strb	r3, [r4, r2]	@ tmp388, proc_95(D)->editing
.L1292:
@ Data/FE6_FE7.c:3877:         if (keys & DPAD_LEFT)
	lsls	r3, r6, #26	@ tmp462, keys,
	bpl	.L1293		@,
@ Data/FE6_FE7.c:3879:             proc->digit = 0;
	movs	r3, #49	@ tmp400,
	movs	r2, #0	@ tmp401,
	strb	r2, [r4, r3]	@ tmp401, proc_95(D)->digit
@ Data/FE6_FE7.c:3880:             proc->editing = true;
	subs	r3, r3, #3	@ tmp403,
	adds	r2, r2, #1	@ tmp404,
	strb	r2, [r4, r3]	@ tmp404, proc_95(D)->editing
.L1293:
@ Data/FE6_FE7.c:3882:         if (keys & DPAD_UP)
	lsls	r3, r6, #25	@ tmp463, keys,
	bpl	.L1294		@,
@ Data/FE6_FE7.c:3884:             proc->id--;
	movs	r3, #48	@ tmp413,
@ Data/FE6_FE7.c:3884:             proc->id--;
	ldrb	r3, [r4, r3]	@ tmp415,
	subs	r3, r3, #1	@ tmp416,
	lsls	r3, r3, #24	@ tmp417, tmp416,
	asrs	r2, r3, #24	@ _67, tmp417,
@ Data/FE6_FE7.c:3885:             if (proc->id < 0)
	cmp	r3, #0	@ tmp417,
	bge	.LCB9100	@
	b	.L1350	@long jump	@
.LCB9100:
@ Data/FE6_FE7.c:3884:             proc->id--;
	movs	r3, #48	@ tmp424,
@ Data/FE6_FE7.c:3889:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3884:             proc->id--;
	strb	r2, [r4, r3]	@ _67, proc_95(D)->id
@ Data/FE6_FE7.c:3889:             RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
.L1294:
@ Data/FE6_FE7.c:3891:         if (keys & DPAD_DOWN)
	lsls	r6, r6, #24	@ tmp464, keys,
	bpl	.L1271		@,
@ Data/FE6_FE7.c:3893:             proc->id++;
	movs	r3, #48	@ tmp433,
@ Data/FE6_FE7.c:3893:             proc->id++;
	ldrb	r3, [r4, r3]	@ tmp435,
	adds	r3, r3, #1	@ tmp436,
	lsls	r3, r3, #24	@ tmp437, tmp436,
	asrs	r3, r3, #24	@ _75, tmp437,
@ Data/FE6_FE7.c:3894:             if (proc->id >= limit)
	cmp	r3, r5	@ _75, _96
	blt	.L1297		@,
@ Data/FE6_FE7.c:3896:                 proc->id = 0;
	movs	r3, #0	@ _75,
.L1297:
	movs	r2, #48	@ tmp438,
@ Data/FE6_FE7.c:3898:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
	strb	r3, [r4, r2]	@ _75, MEM <struct DebuggerProc> [(void *)proc_95(D)].id
	bl	RedrawLearnedSkillsMenu		@
@ Data/FE6_FE7.c:3901: }
	b	.L1271		@
.L1347:
@ Data/FE6_FE7.c:551:     if (result > 9)
	movs	r5, #9	@ _146,
@ Data/FE6_FE7.c:3810:         if (keys & DPAD_RIGHT)
	cmp	r7, #0	@ _187,
	bne	.LCB9133	@
	b	.L1279	@long jump	@
.LCB9133:
	b	.L1351		@
.L1346:
@ Data/FE6_FE7.c:3799:             proc->tmp[proc->id],
	adds	r3, r3, #32	@ tmp263,
	lsls	r3, r3, #1	@ tmp264, tmp263,
@ Data/FE6_FE7.c:3798:         TryShowSkillHelp(
	ldrsh	r3, [r3, r4]	@ _6, *proc_95(D)
@ Data/FE6_FE7.c:3653:     if (skillId == 0 || skillId == 0xFF)
	cmp	r3, #0	@ _6,
	bne	.LCB9145	@
	b	.L1275	@long jump	@
.LCB9145:
	cmp	r3, #255	@ _6,
	bne	.LCB9151	@
	b	.L1275	@long jump	@
.LCB9151:
@ Data/FE6_FE7.c:3657:     return SkillDescTable[skillId];
	ldr	r2, .L1352+16	@ tmp276,
	lsls	r3, r3, #1	@ tmp277, _6,
	ldrh	r2, [r3, r2]	@ _151, SkillDescTable
@ Data/FE6_FE7.c:3663:     if (msg)
	cmp	r2, #0	@ _151,
	bne	.LCB9156	@
	b	.L1275	@long jump	@
.LCB9156:
@ Data/FE6_FE7.c:3665:         StartHelpBox(x, y, msg);
	movs	r0, #36	@,
	ldr	r3, .L1352+20	@ tmp278,
	bl	.L17		@
@ Data/FE6_FE7.c:3805:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	ldrsb	r1, [r4, r7]	@ tmp280,
@ Data/FE6_FE7.c:3805:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	adds	r1, r1, #1	@ tmp281,
@ Data/FE6_FE7.c:3805:         DisplayVertUiHand(CursorLocationTable[proc->digit].x, (Y_HAND + (proc->id * 2)) * 8);
	lsls	r1, r1, #4	@ prephitmp_186, tmp281,
	b	.L1275		@
.L1345:
@ Data/FE6_FE7.c:3790:         CloseHelpBox();
	ldr	r3, .L1352+24	@ tmp239,
	bl	.L17		@
@ Data/FE6_FE7.c:3791:         SaveLearnedSkills(proc);
	movs	r0, r4	@, proc
	bl	SaveLearnedSkills		@
@ Data/FE6_FE7.c:3142:     gLCDControlBuffer.bg1cnt.priority = 0;
	movs	r1, #3	@ tmp246,
	ldr	r2, .L1352+28	@ tmp240,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp245, tmp246
	strb	r3, [r2, #16]	@ tmp245, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3143:     SetBackgroundTileDataOffset(2, 0);
	movs	r1, #0	@,
	movs	r0, #2	@,
	ldr	r3, .L1352+32	@ tmp248,
	bl	.L17		@
@ Data/FE6_FE7.c:3144:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp249,
	movs	r2, #0	@,
	str	r3, [sp]	@ tmp249,
	movs	r1, #1	@,
	movs	r0, #0	@,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3145:     BG_Fill(gBG2TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1352+36	@ tmp250,
	ldr	r3, .L1352+40	@ tmp251,
	bl	.L17		@
@ Data/FE6_FE7.c:3146:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT);
	movs	r0, #7	@,
	ldr	r3, .L1352+44	@ tmp252,
	bl	.L17		@
@ Data/FE6_FE7.c:3793:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L1352+48	@ tmp253,
	bl	.L17		@
@ Data/FE6_FE7.c:597: }
	b	.L1274		@
.L1344:
@ Data/FE6_FE7.c:3782:         CloseHelpBox();
	ldr	r3, .L1352+24	@ tmp217,
	bl	.L17		@
@ Data/FE6_FE7.c:3783:         SaveLearnedSkills(proc);
	movs	r0, r4	@, proc
	bl	SaveLearnedSkills		@
@ Data/FE6_FE7.c:3142:     gLCDControlBuffer.bg1cnt.priority = 0;
	movs	r1, #3	@ tmp224,
	ldr	r2, .L1352+28	@ tmp218,
	ldrb	r3, [r2, #16]	@ gLCDControlBuffer.bg1cnt.priority, gLCDControlBuffer.bg1cnt.priority
	bics	r3, r1	@ tmp223, tmp224
	strb	r3, [r2, #16]	@ tmp223, gLCDControlBuffer.bg1cnt.priority
@ Data/FE6_FE7.c:3143:     SetBackgroundTileDataOffset(2, 0);
	movs	r1, #0	@,
	movs	r0, #2	@,
	ldr	r3, .L1352+32	@ tmp226,
	bl	.L17		@
@ Data/FE6_FE7.c:3144:     SetBlendTargetA_(0, 1, 0, 0, 0);
	movs	r3, #0	@ tmp227,
	movs	r2, #0	@,
	str	r3, [sp]	@ tmp227,
	movs	r1, #1	@,
	movs	r0, #0	@,
	bl	SetBlendTargetA_		@
@ Data/FE6_FE7.c:3145:     BG_Fill(gBG2TilemapBuffer, 0);
	movs	r1, #0	@,
	ldr	r0, .L1352+36	@ tmp228,
	ldr	r3, .L1352+40	@ tmp229,
	bl	.L17		@
@ Data/FE6_FE7.c:3146:     BG_EnableSyncByMask(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT);
	movs	r0, #7	@,
	ldr	r3, .L1352+44	@ tmp230,
	bl	.L17		@
@ Data/FE6_FE7.c:3785:         Proc_Goto(proc, RestartLabel);
	movs	r1, #1	@,
	movs	r0, r4	@, proc
	ldr	r3, .L1352+48	@ tmp231,
	bl	.L17		@
@ Data/FE6_FE7.c:584: }
	b	.L1273		@
.L1349:
@ Data/FE6_FE7.c:3860:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	subs	r3, r3, #206	@ tmp371,
	ldrsb	r3, [r4, r3]	@ tmp372,
@ Data/FE6_FE7.c:3860:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	lsls	r3, r3, #2	@ tmp373, tmp372,
	add	r3, r3, r8	@ tmp374, tmp440
@ Data/FE6_FE7.c:3860:                 proc->tmp[proc->id] -= DigitDecimalTable[proc->digit];
	ldr	r0, [r3, #68]	@ DigitDecimalTable[_51], DigitDecimalTable[_51]
	subs	r0, r2, r0	@ tmp379, _48, DigitDecimalTable[_51]
@ Data/FE6_FE7.c:3861:                 if (proc->tmp[proc->id] < min)
	lsls	r3, r0, #16	@ tmp382, tmp379,
	asrs	r3, r3, #16	@ tmp382, tmp382,
	mvns	r3, r3	@ tmp446, tmp382
@ Data/FE6_FE7.c:3856:                 proc->tmp[proc->id] = max;
	movs	r2, #64	@ tmp384,
@ Data/FE6_FE7.c:3861:                 if (proc->tmp[proc->id] < min)
	asrs	r3, r3, #31	@ tmp450, tmp446,
	ands	r3, r0	@ tmp369, tmp379
	lsls	r3, r3, #16	@ _47, tmp369,
	asrs	r3, r3, #16	@ _47, _47,
@ Data/FE6_FE7.c:3866:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3856:                 proc->tmp[proc->id] = max;
	strh	r3, [r1, r2]	@ _47, MEM <s16> [(struct DebuggerProc *)_166 + 64B]
@ Data/FE6_FE7.c:3866:             RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
	b	.L1271		@
.L1348:
@ Data/FE6_FE7.c:3827:                 proc->digit++;
	adds	r3, r3, #1	@ tmp323,
	lsls	r3, r3, #24	@ tmp324, tmp323,
	asrs	r3, r3, #24	@ _35, tmp324,
	b	.L1284		@
.L1350:
@ Data/FE6_FE7.c:3884:             proc->id--;
	movs	r3, #48	@ tmp424,
@ Data/FE6_FE7.c:3887:                 proc->id = limit - 1;
	subs	r2, r5, #1	@ _67, _96,
@ Data/FE6_FE7.c:3889:             RedrawLearnedSkillsMenu(proc);
	movs	r0, r4	@, proc
@ Data/FE6_FE7.c:3884:             proc->id--;
	strb	r2, [r4, r3]	@ _67, proc_95(D)->id
@ Data/FE6_FE7.c:3889:             RedrawLearnedSkillsMenu(proc);
	bl	RedrawLearnedSkillsMenu		@
	b	.L1294		@
.L1280:
@ Data/FE6_FE7.c:3819:                 proc->editing = false;
	movs	r2, #46	@ tmp308,
	movs	r1, #0	@ tmp309,
@ Data/FE6_FE7.c:3818:                 proc->digit = max_digits - 1;
	subs	r3, r5, #1	@ tmp306, _146,
	lsls	r3, r3, #24	@ tmp307, tmp306,
@ Data/FE6_FE7.c:3819:                 proc->editing = false;
	strb	r1, [r4, r2]	@ tmp309, proc_95(D)->editing
@ Data/FE6_FE7.c:3818:                 proc->digit = max_digits - 1;
	asrs	r3, r3, #24	@ _26, tmp307,
	b	.L1281		@
.L1300:
	movs	r3, #0	@ _123,
	b	.L1286		@
.L1298:
@ Data/FE6_FE7.c:3614:         return 0;
	movs	r5, #0	@ _96,
	b	.L1272		@
.L1353:
	.align	2
.L1352:
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
.LC626:
	.ascii	"CheatCodeKeyListenerProc\000"
	.global	KonamiCodeSequence
	.global	StatCapLookup
	.global	gDebuggerMenuDefPage3
	.global	gDebuggerMenuDefPage2
	.global	gDebuggerMenuDef
	.global	DebuggerProcCmdIdler
	.align	2
.LC627:
	.ascii	"DebuggerProcIdler\000"
	.global	DebuggerProcCmd
	.align	2
.LC628:
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
	.word	.LC627
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
	.word	.LC626
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
	.word	.LC628
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
