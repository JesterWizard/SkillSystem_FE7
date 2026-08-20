@ FE7 map level-up (anims off): Mag between Str and Skl, Con removed.
@ Indices: 0 Lv, 1 HP, 2 Str, 3 Mag, 4 Skl, 5 Spd, 6 Lck, 7 Def, 8 Res

	.thumb
	.align 2

	gManimSt = 0x0203E0FC

	.global GetManimLevelUpStatGainMag
	.type GetManimLevelUpStatGainMag, %function
GetManimLevelUpStatGainMag:
	push	{lr}
	ldr	r2, =gManimSt
	lsl	r3, r0, #2
	add	r3, r3, r0
	lsl	r3, r3, #2
	add	r2, r3
	ldr	r2, [r2]
	cmp	r1, #0
	beq	.gain_lv
	cmp	r1, #1
	beq	.gain_hp
	cmp	r1, #2
	beq	.gain_str
	cmp	r1, #3
	beq	.gain_mag
	cmp	r1, #4
	beq	.gain_skl
	cmp	r1, #5
	beq	.gain_spd
	cmp	r1, #6
	beq	.gain_lck
	cmp	r1, #7
	beq	.gain_def
	cmp	r1, #8
	beq	.gain_res
	mov	r0, #0
	b	.gain_end
.gain_lv:
	mov	r0, #1
	b	.gain_end
.gain_hp:
	mov	r0, #0x73
	b	.gain_load
.gain_str:
	mov	r0, #0x74
	b	.gain_load
.gain_mag:
	mov	r0, #0x7A
	b	.gain_load
.gain_skl:
	mov	r0, #0x75
	b	.gain_load
.gain_lck:
	mov	r0, #0x79
	b	.gain_load
.gain_def:
	mov	r0, #0x77
	b	.gain_load
.gain_res:
	mov	r0, #0x78
	b	.gain_load
.gain_spd:
	mov	r0, #0x76
.gain_load:
	ldsb	r0, [r2, r0]
.gain_end:
	pop	{r1}
	bx	r1

	.global GetManimLevelUpBaseStatMag
	.type GetManimLevelUpBaseStatMag, %function
GetManimLevelUpBaseStatMag:
	push	{r4, lr}
	mov	r4, r1
	ldr	r2, =gManimSt
	lsl	r3, r0, #2
	add	r3, r3, r0
	lsl	r3, r3, #2
	add	r2, r3
	ldr	r3, [r2]
	cmp	r4, #0
	beq	.base_lv
	mov	r0, #0x0B
	ldsb	r0, [r3, r0]
	ldr	r1, =0x08018D0D
	bl	BXR1
	mov	r2, r0
	mov	r1, r4
	cmp	r1, #1
	beq	.base_hp
	cmp	r1, #2
	beq	.base_str
	cmp	r1, #3
	beq	.base_mag
	cmp	r1, #4
	beq	.base_skl
	cmp	r1, #5
	beq	.base_spd
	cmp	r1, #6
	beq	.base_lck
	cmp	r1, #7
	beq	.base_def
	cmp	r1, #8
	beq	.base_res
	mov	r0, #0
	b	.base_end
.base_lv:
	mov	r0, #0x70
	ldsb	r0, [r3, r0]
	b	.base_end
.base_hp:
	mov	r0, #0x12
	b	.base_unit
.base_str:
	mov	r0, #0x14
	b	.base_unit
.base_mag:
	mov	r0, #0x47
	b	.base_unit
.base_skl:
	mov	r0, #0x15
	b	.base_unit
.base_lck:
	mov	r0, #0x19
	b	.base_unit
.base_def:
	mov	r0, #0x17
	b	.base_unit
.base_res:
	mov	r0, #0x18
	b	.base_unit
.base_spd:
	mov	r0, #0x16
.base_unit:
	ldsb	r0, [r2, r0]
.base_end:
	pop	{r4}
	pop	{r1}
	bx	r1

BXR1:
	bx	r1

	.pool
