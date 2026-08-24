@ FE7 effectiveness skills. One blob, two hooks.
@ ApplyEffectiveness  @ BC_Power 0x28B32. r4=defender r5=attacker r6=atk+0x48
@ WeaponEffectiveness @ IsItemEffectiveAgainst 0x16820. r0=item r1=defender
@
@ Class type halfword at class+0x50. Coeff is doubled (6 -> 3x after lsr #1).

.thumb
.align 2
.global ApplyEffectiveness
.global WeaponEffectiveness

.equ SlayerID,              SkillTester + 4
.equ NullifyID,             SlayerID + 4
.equ SlayerClassType,       NullifyID + 4
.equ SkybreakerID,          SlayerClassType + 4
.equ SkybreakerClassType,   SkybreakerID + 4
.equ ResourcefulID,         SkybreakerClassType + 4
.equ NextBC,                0x08028B53
.equ GetItemEffectiveness,  0x080173D1
.equ GetItemData,           0x080174AD

ApplyEffectiveness:
	@ Hooked at 0x28B30 (4-aligned so the jumpToHack POIN lands at hook+4).
	@ Re-emit the displaced `strh r1,[r0,#0]`; r0 = attacker+0x5A, r1 = base might.
	strh	r1, [r0]
	push	{r4-r7, lr}
	mov	r7, r5			@ attacker
	mov	r6, r4			@ defender

	mov	r0, r7
	mov	r1, r6
	bl	SlayerCheck
	mov	r4, r0			@ best coeff

	mov	r0, r7
	add	r0, #0x48
	ldrh	r0, [r0]
	mov	r1, r6
	bl	WeaponCoeff
	cmp	r0, r4
	ble	AE_HaveCoeff
	mov	r4, r0
AE_HaveCoeff:
	cmp	r4, #0
	beq	AE_Done

	mov	r0, r7
	ldr	r1, ResourcefulID
	ldr	r3, SkillTester
	bl	call_r3
	cmp	r0, #0
	beq	AE_Mul
	lsl	r4, r4, #1
AE_Mul:
	mov	r0, r7
	add	r0, #0x5A
	ldrh	r1, [r0]
	mul	r1, r4
	lsr	r1, #1
	strh	r1, [r0]
AE_Done:
	pop	{r4-r7}
	pop	{r0}
	ldr	r1, =NextBC
	bx	r1

	.align 2
	.ltorg

@ r0=item r1=defender -> r0 = 0/1
@ Vanilla only asks the weapon, so Slayer/Skybreaker tripled damage in BC_Power
@ without ever lighting the flashing "effective" icon (battle struct +0x52) that
@ the forecast and battle screens draw. Ask the skills here too, so the display
@ path agrees with the damage path.
WeaponEffectiveness:
	push	{r4, r5, lr}
	mov	r4, r1			@ defender
	bl	WeaponCoeff
	cmp	r0, #0
	bne	WeaponEffTrue

	@ Skill check. This hook is only handed the defender, but the two battle
	@ structs are the fixed globals gBattleActor / gBattleTarget, 0x80 apart,
	@ so the attacker is whichever one the defender is not.
	ldr	r0, gBattleActor
	cmp	r4, r0
	bne	WE_HaveAttacker
	ldr	r0, gBattleTarget
WE_HaveAttacker:
	mov	r1, r4
	bl	SlayerCheck
	cmp	r0, #0
	beq	WeaponEffDone
WeaponEffTrue:
	mov	r0, #1
WeaponEffDone:
	pop	{r4, r5}
	pop	{r1}
	bx	r1

	.align 2
gBattleActor:
	.word	0x0203A3F0
gBattleTarget:
	.word	0x0203A470

@ r0=attacker r1=defender -> r0 coeff (0 or 6)
SlayerCheck:
	push	{r4-r6, lr}
	mov	r4, r0
	mov	r5, r1
	ldr	r0, [r5, #0x4]
	cmp	r0, #0
	beq	SC_False

	mov	r0, r4
	ldr	r1, SlayerID
	ldr	r3, SkillTester
	bl	call_r3
	cmp	r0, #0
	beq	SC_Skybreaker

	ldr	r2, [r5, #0x4]
	mov	r1, #0x50
	ldrh	r2, [r2, r1]
	ldrh	r0, SlayerClassType
	and	r0, r2
	cmp	r0, #0
	bne	SC_Nullify

SC_Skybreaker:
	mov	r0, r4
	ldr	r1, SkybreakerID
	ldr	r3, SkillTester
	bl	call_r3
	cmp	r0, #0
	beq	SC_False

	ldr	r2, [r5, #0x4]
	mov	r1, #0x50
	ldrh	r2, [r2, r1]
	ldrh	r0, SkybreakerClassType
	and	r0, r2
	cmp	r0, #0
	bne	SC_Nullify
	b	SC_False

SC_Nullify:
	mov	r0, r5
	ldr	r1, NullifyID
	ldr	r3, SkillTester
	bl	call_r3
	cmp	r0, #0
	bne	SC_False
	mov	r6, #6
	b	SC_Done
SC_False:
	mov	r6, #0
SC_Done:
	mov	r0, r6
SlayerDone:
	pop	{r4-r6}
	pop	{r1}
	bx	r1

@ r0=item r1=defender -> r0 coeff
WeaponCoeff:
	push	{r4-r7, lr}
	mov	r4, r0
	mov	r5, r1
	ldr	r0, [r5, #0x4]
	cmp	r0, #0
	beq	WC_False

	mov	r0, r4
	ldr	r3, =GetItemEffectiveness
	bl	call_r3
	cmp	r0, #0
	beq	WC_False
	mov	r4, r0			@ effectiveness list

	ldr	r1, [r5, #0x4]
	mov	r6, #0x50
	ldrh	r6, [r1, r6]
	cmp	r6, #0
	beq	WC_False

	mov	r7, #0
WC_ProtLoop:
	lsl	r0, r7, #1
	add	r0, #0x1E
	ldrh	r0, [r5, r0]
	cmp	r0, #0
	beq	WC_EffLoop
	mov	r1, #0xFF
	and	r0, r1
	ldr	r3, =GetItemData
	bl	call_r3
	ldr	r1, [r0, #0x8]
	mov	r2, #0x80
	lsl	r2, #7			@ IA 0x4000, Delphi Shield
	tst	r1, r2
	beq	WC_NextItem
	ldr	r1, [r0, #0x10]
	cmp	r1, #0
	beq	WC_NextItem
	ldrh	r1, [r1, #2]
	bic	r6, r1
	cmp	r6, #0
	beq	WC_False
WC_NextItem:
	add	r7, #1
	cmp	r7, #4
	ble	WC_ProtLoop

WC_EffLoop:
	ldrh	r1, [r4, #2]
	cmp	r1, #0
	beq	WC_False
	and	r1, r6
	cmp	r1, #0
	bne	WC_Nullify
	add	r4, #4
	b	WC_EffLoop

WC_Nullify:
	mov	r0, r5
	ldr	r1, NullifyID
	ldr	r3, SkillTester
	bl	call_r3
	cmp	r0, #0
	bne	WC_False
	ldrb	r0, [r4, #1]		@ coeff
	b	WC_Done
WC_False:
	mov	r0, #0
WC_Done:
	pop	{r4-r7}
	pop	{r1}
	bx	r1

call_r3:
	bx	r3

	.align 2
	.ltorg
SkillTester:
@ POIN SkillTester
@ WORD SlayerID NullifyID MonsterType SkybreakerID FlierType ResourcefulID
