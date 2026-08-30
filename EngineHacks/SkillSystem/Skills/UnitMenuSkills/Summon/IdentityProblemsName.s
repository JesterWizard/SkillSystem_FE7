.thumb

@ Identity Problems names. Faces stay in SummonPortraitGuard.
@ Combo is a random valid character (name + portrait != 0). Reuse while
@ the same unit is fetched on consecutive frames so status does not
@ overdraw a new name every VBlank; a clock gap starts a new combo.

.equ IdentityProblemsID, SkillTester+4
.equ IdentityRamByte, IdentityProblemsID+4
.equ CharacterTable, IdentityRamByte+4
.equ IdentityCharMax, CharacterTable+4
.equ NextRN_N, 0x08000E31
.equ GetStringFromIndex, 0x08012C61
.equ PopupUnitPtr, 0x03000104
.equ PopupResume, 0x0800A8B5
.equ Stat1Resume, 0x08023081
.equ Stat2Resume, 0x0802309D
.equ Battle1Resume, 0x0802AC41
.equ Battle2Resume, 0x0802AC6D

@ r0 = Unit*. Returns name text ID from a random valid character.
.global IdentityNameId
IdentityNameId:
	push {r4, r5, r6, r7, lr}
	mov r4, r0
	ldr r3, SkillTester
	mov lr, r3
	mov r0, r4
	ldr r1, IdentityProblemsID
	.short 0xf800
	cmp r0, #0
	beq Original
	ldr r7, IdentityCharMax
	cmp r7, #0
	beq Original
	ldr r1, IdentityRamByte
	ldr r2, [r1, #4]
	cmp r2, r4
	bne IdCount
	ldr r2, =0x03000010
	ldr r2, [r2]
	ldr r3, [r1, #8]
	sub r2, r3
	cmp r2, #1
	bhi IdCount
	ldr r2, =0x03000010
	ldr r2, [r2]
	str r2, [r1, #8]
	ldrb r0, [r1]
	cmp r0, #0
	beq IdCount
	cmp r0, r7
	bls HaveIdx
IdCount:
	mov r5, #0
	mov r6, #1
IdCountLoop:
	mov r0, r6
	bl IdCharPtr
	ldrh r2, [r0]
	cmp r2, #0
	beq IdCountNext
	ldrh r2, [r0, #6]
	cmp r2, #0
	beq IdCountNext
	add r5, #1
IdCountNext:
	add r6, #1
	cmp r6, r7
	bls IdCountLoop
	cmp r5, #0
	beq Original
	mov r0, r5
	ldr r3, =NextRN_N
	mov lr, r3
	nop
	.short 0xf800
	mov r5, r0
	mov r6, #1
IdWalk:
	cmp r6, r7
	bhi Original
	mov r0, r6
	bl IdCharPtr
	ldrh r2, [r0]
	cmp r2, #0
	beq IdWalkNext
	ldrh r2, [r0, #6]
	cmp r2, #0
	beq IdWalkNext
	cmp r5, #0
	beq IdFound
	sub r5, #1
IdWalkNext:
	add r6, #1
	b IdWalk
IdFound:
	mov r0, r6
	ldr r1, IdentityRamByte
	strb r0, [r1]
	str r4, [r1, #4]
	ldr r2, =0x03000010
	ldr r2, [r2]
	str r2, [r1, #8]
HaveIdx:
	bl IdCharPtr
	ldrh r0, [r0]
	b IdentityNameIdDone
Original:
	ldr r0, [r4]
	ldrh r0, [r0]
IdentityNameIdDone:
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1

@ r0 = character id. Returns r0 = character data*.
IdCharPtr:
	ldr r1, CharacterTable
	mov r2, #0x34
	mul r2, r0
	add r1, r2
	mov r0, r1
	bx lr
	.ltorg

@ r0 = unit, r1 = resume (thumb).
IdentityNameThenString:
	push {r4, lr}
	mov r4, r1
	bl IdentityNameId
	ldr r3, =GetStringFromIndex
	mov lr, r3
	.short 0xf800
	mov r1, r4
	pop {r4}
	pop {r3}
	bx r1

.macro ident_hook name, resume
	.global \name
\name:
	ldr r1, =\resume
	b IdentityNameThenString
.endm

.macro ident_hook_from name, resume, src
	.global \name
\name:
	mov r0, \src
	ldr r1, =\resume
	b IdentityNameThenString
.endm

@ Vanilla 0x18CD4 is ldr pCharacterData / ldrh nameId / b GetString (0x18CE4).
@ jumpToHack ate that branch; resuming at hook+9 (0x18CDD) falls into the
@ "---" literal. IdentityNameThenString already called GetStringFromIndex,
@ so resume at the pop/bx (0x18CE8).
ident_hook IdentityName_18CD4, 0x08018CE9
ident_hook IdentityName_4D234, 0x0804D23D
ident_hook IdentityName_4D2F4, 0x0804D2FD
ident_hook IdentityName_7FA98, 0x0807FAA1
ident_hook IdentityName_8ADBC, 0x0808ADC5
ident_hook IdentityName_94508, 0x08094511
ident_hook IdentityName_96410, 0x08096419
ident_hook IdentityName_97984, 0x0809798D
@ Minimug box, status-window name, help box, prep list.  r0 is not Unit*.
ident_hook_from IdentityName_85134, 0x0808513D, r8
ident_hook_from IdentityName_86CB4, 0x08086CBD, r4
ident_hook_from IdentityName_8530C, 0x08085315, r2
.ltorg

.global IdentityNamePopup
IdentityNamePopup:
	push {lr}
	ldr r0, =PopupUnitPtr
	ldr r0, [r0]
	bl IdentityNameId
	pop {r3}
	ldr r3, =PopupResume
	bx r3

.global IdentityNameStat1
IdentityNameStat1:
	push {lr}
	bl IdentityNameId
	ldr r3, =GetStringFromIndex
	mov lr, r3
	.short 0xf800
	pop {r3}
	ldr r3, =Stat1Resume
	bx r3

.global IdentityNameStat2
IdentityNameStat2:
	push {lr}
	bl IdentityNameId
	ldr r3, =GetStringFromIndex
	mov lr, r3
	.short 0xf800
	pop {r3}
	ldr r3, =Stat2Resume
	bx r3

.global IdentityNameBattle1
IdentityNameBattle1:
	push {lr}
	bl IdentityNameId
	ldr r3, =GetStringFromIndex
	mov lr, r3
	.short 0xf800
	mov r7, r0
	pop {r3}
	ldr r3, =Battle1Resume
	bx r3

.global IdentityNameBattle2
IdentityNameBattle2:
	push {lr}
	bl IdentityNameId
	ldr r3, =GetStringFromIndex
	mov lr, r3
	.short 0xf800
	mov r7, r0
	pop {r3}
	ldr r3, =Battle2Resume
	bx r3

.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD IdentityProblemsID
@WORD IdentityRamByte
@POIN CharacterTable
@WORD IdentityCharMax
