.thumb

@ FE7 ApplyItemStatBoost (0x0802CD60) and prep preview (0x08027594).
@ Extra +Amount on each non-zero bonus, including mag at unit+0x47.
@ Mov (table[8]) stays vanilla: no extra.

.equ ShrewdPotentialID, SkillTester+4
.equ ShrewdPotentialAmount, ShrewdPotentialID+4
.equ GetItemStatBonuses, 0x080173E9
.equ ApplyResume, 0x0802CDB7
.equ PreviewResume, 0x080275DD

@ r0 = bonus table, r1 = source / skill unit, r4 = dest unit
.global ShrewdPotential
ShrewdPotential:
	push {r5-r7, lr}
	mov r5, r0
	mov r6, r1
	mov r7, #0
	mov r0, r6
	ldr r1, ShrewdPotentialID
	ldr r3, SkillTester
	mov lr, r3
	.short 0xf800
	cmp r0, #0
	beq NoExtra
	ldr r7, ShrewdPotentialAmount
NoExtra:
	@ HP max / cur: table[0] -> 0x12, 0x13
	ldrb r1, [r5, #0]
	cmp r1, #0
	beq HpMaxNo
	add r1, r7
HpMaxNo:
	ldrb r2, [r6, #0x12]
	add r1, r2
	strb r1, [r4, #0x12]
	ldrb r1, [r5, #0]
	cmp r1, #0
	beq HpCurNo
	add r1, r7
HpCurNo:
	ldrb r2, [r6, #0x13]
	add r1, r2
	strb r1, [r4, #0x13]
	@ str table[1] -> 0x14
	ldrb r1, [r5, #1]
	cmp r1, #0
	beq StrNo
	add r1, r7
StrNo:
	ldrb r2, [r6, #0x14]
	add r1, r2
	strb r1, [r4, #0x14]
	@ skl table[2] -> 0x15
	ldrb r1, [r5, #2]
	cmp r1, #0
	beq SklNo
	add r1, r7
SklNo:
	ldrb r2, [r6, #0x15]
	add r1, r2
	strb r1, [r4, #0x15]
	@ spd table[3] -> 0x16
	ldrb r1, [r5, #3]
	cmp r1, #0
	beq SpdNo
	add r1, r7
SpdNo:
	ldrb r2, [r6, #0x16]
	add r1, r2
	strb r1, [r4, #0x16]
	@ def table[4] -> 0x17
	ldrb r1, [r5, #4]
	cmp r1, #0
	beq DefNo
	add r1, r7
DefNo:
	ldrb r2, [r6, #0x17]
	add r1, r2
	strb r1, [r4, #0x17]
	@ res table[5] -> 0x18
	ldrb r1, [r5, #5]
	cmp r1, #0
	beq ResNo
	add r1, r7
ResNo:
	ldrb r2, [r6, #0x18]
	add r1, r2
	strb r1, [r4, #0x18]
	@ lck table[6] -> 0x19
	ldrb r1, [r5, #6]
	cmp r1, #0
	beq LckNo
	add r1, r7
LckNo:
	ldrb r2, [r6, #0x19]
	add r1, r2
	strb r1, [r4, #0x19]
	@ con table[7] -> 0x1D
	ldrb r1, [r5, #7]
	cmp r1, #0
	beq ConNo
	add r1, r7
ConNo:
	ldrb r2, [r6, #0x1D]
	add r1, r2
	strb r1, [r4, #0x1D]
	@ mov table[8] -> 0x1A, no extra
	ldrb r1, [r5, #8]
	ldrb r2, [r6, #0x1A]
	add r1, r2
	strb r1, [r4, #0x1A]
	@ mag table[9] -> unit+0x47 (str/mag split)
	ldrb r1, [r5, #9]
	cmp r1, #0
	beq MagNo
	add r1, r7
MagNo:
	mov r3, #0x47
	ldrb r2, [r6, r3]
	add r1, r2
	strb r1, [r4, r3]
	mov r0, r4
ShrewdPotentialDone:
	pop {r5-r7}
	pop {r1}
	bx r1

.global ShrewdPotentialApply
ShrewdPotentialApply:
	push {r5, lr}
	mov r0, r6
	ldr r3, =GetItemStatBonuses
	mov lr, r3
	.short 0xf800
	mov r1, r4
	bl ShrewdPotential
	pop {r5}
	pop {r3}
	ldr r3, =ApplyResume
	bx r3

.global ShrewdPotentialPreview
ShrewdPotentialPreview:
	push {r4, r5, lr}
	mov r0, r4
	mov r1, r5
	mov r4, r6
	bl ShrewdPotential
	pop {r4, r5}
	pop {r3}
	ldr r3, =PreviewResume
	bx r3

.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD ShrewdPotentialID
@WORD ShrewdPotentialAmount
