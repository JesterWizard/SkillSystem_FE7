.thumb
.org 0x0

@ FE7 replacement for func_0802F960 (the post-battle death handler).
@ r0 = the battle-action proc.
@ The vanilla handler drops carried units and then kills units at 0 HP.

.macro blh to, reg=r3
	ldr	\reg, =\to
	mov	lr, \reg
	.short	0xF800
.endm

.equ SkillTester, Is_Capture_Set+4
.equ CaptureID, SkillTester+4

	push	{r4, r5, r6, lr}
	mov	r5, r0

	movs	r1, #0x64
	add	r0, r1
	movs	r1, #0
	ldrsh	r0, [r0, r1]
	blh	0x08018D0C			@ GetUnit
	mov	r6, r0				@ acting unit

	mov	r0, r5
	movs	r1, #0x66
	add	r0, r1
	movs	r1, #0
	ldrsh	r0, [r0, r1]
	blh	0x08018D0C			@ GetUnit
	mov	r4, r0				@ target unit

	mov	r0, r5
	mov	r1, r6
	blh	0x0802F754			@ vanilla carried-unit drop handling
	mov	r0, r5
	mov	r1, r4
	blh	0x0802F754

	ldr	r3, Is_Capture_Set
	mov	lr, r3
	mov	r0, r6
	.short	0xF800
	cmp	r0, #0
	beq	KillUnits

	@ The menu selection is single-use, including when the target survives.
	ldr	r0, [r6, #0xC]
	movs	r1, #0x80
	lsl	r1, #0x17
	mvn	r1, r1
	and	r0, r1
	str	r0, [r6, #0xC]

	@ Winning unit must have Capture; the menu flag is not enough.
	mov	r0, r6
	ldr	r1, CaptureID
	ldr	r3, SkillTester
	mov	lr, r3
	.short	0xF800
	cmp	r0, #0
	beq	KillUnits

	@ Only rescue a defeated enemy while the capturer is still alive.
	ldrb	r0, [r4, #0x13]
	cmp	r0, #0
	bne	KillUnits
	ldrb	r0, [r4, #0xB]
	movs	r1, #0x80
	tst	r0, r1
	beq	KillUnits
	ldrb	r0, [r6, #0x13]
	cmp	r0, #0
	beq	KillUnits

	mov	r0, r6
	mov	r1, r4
	blh	0x08017DE4			@ UnitRescue
	movs	r0, #1
	strb	r0, [r4, #0x13]			@ captured units survive at 1 HP

KillUnits:
	mov	r0, r6
	mov	r1, r4
	blh	0x0802F808			@ vanilla acting-unit death handling
	mov	r0, r4
	mov	r1, r6
	blh	0x0802F808			@ vanilla target-unit death handling

	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0

.align
.ltorg

.align
Is_Capture_Set:
@SkillTester
@CaptureID
