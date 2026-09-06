.thumb

.global TalkCommandUsability
.type TalkCommandUsability, %function
TalkCommandUsability:
@ Talk if an adjacent unit (including enemies) passes Talk_Check.
@ Same pair as the HP-bar bubble. Do not skip deployment ids >= 0x80.
	push	{r4, r5, r6, r7, lr}
	ldr		r0, gActiveUnit
	ldr		r5, [r0]
	cmp		r5, #0
	beq		TalkCommandUsability_Hidden
	ldr		r2, [r5]
	cmp		r2, #0
	beq		TalkCommandUsability_Hidden
	ldr		r0, [r5, #0xC]
	mov		r1, #0x40
	tst		r0, r1
	bne		TalkCommandUsability_Hidden
	ldrb	r4, [r2, #4]
	mov		r7, #0
	ldr		r6, AdjacentOffsets

TalkCommandUsability_AdjLoop:
	mov		r1, #0x10
	ldrsb	r1, [r5, r1]
	mov		r0, #0
	ldrsb	r0, [r6, r0]
	add		r1, r0
	mov		r2, #0x11
	ldrsb	r2, [r5, r2]
	mov		r0, #1
	ldrsb	r0, [r6, r0]
	add		r2, r0
	ldr		r0, gMapUnitRows
	ldr		r0, [r0]
	lsl		r2, r2, #2
	add		r0, r2
	ldr		r0, [r0]
	add		r0, r1
	ldrb	r0, [r0]
	cmp		r0, #0
	beq		TalkCommandUsability_NextAdj
	ldr		r3, GetUnit
	mov		lr, r3
	.short	0xF800
	cmp		r0, #0
	beq		TalkCommandUsability_NextAdj
	ldr		r2, [r0]
	cmp		r2, #0
	beq		TalkCommandUsability_NextAdj
	ldrb	r1, [r2, #4]
	cmp		r1, r4
	beq		TalkCommandUsability_NextAdj
	mov		r0, r4
	ldr		r3, Talk_Check
	mov		lr, r3
	.short	0xF800
	cmp		r0, #0
	bne		TalkCommandUsability_Enabled

TalkCommandUsability_NextAdj:
	add		r6, #2
	add		r7, #1
	cmp		r7, #3
	ble		TalkCommandUsability_AdjLoop
	b		TalkCommandUsability_Hidden

TalkCommandUsability_Enabled:
	mov		r0, #2
	b		TalkCommandUsability_Done

TalkCommandUsability_Hidden:
	mov		r0, #3

TalkCommandUsability_Done:
	pop		{r4, r5, r6, r7, pc}

.align 2
AdjacentOffsets:
.byte  0, -1
.byte  0,  1
.byte -1,  0
.byte  1,  0
.align 2
gMapUnitRows:
.word 0x0202E3DC
GetUnit:
.word 0x08018D0C
Talk_Check:
.word 0x080789FC
gActiveUnit:
.word 0x03004690
