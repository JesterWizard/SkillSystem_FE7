.thumb

@ Identity Problems name IDs. Faces stay in SummonPortraitGuard.
@ Shared index in IdentityRamByte; generate when it is past the list.

.equ IdentityProblemsID, SkillTester+4
.equ IdentityRamByte, IdentityProblemsID+4
.equ IdentityProblemsNames, IdentityRamByte+4
.equ NextRN_N, 0x08000E31
.equ GetStringFromIndex, 0x08012C61
.equ PopupUnitPtr, 0x03000104
.equ PopupResume, 0x0800A8B5
.equ Stat1Resume, 0x08023081
.equ Stat2Resume, 0x0802309D
.equ Battle1Resume, 0x0802AC41
.equ Battle2Resume, 0x0802AC6D

@ r0 = Unit*. Returns name text ID.
.global IdentityNameId
IdentityNameId:
	push {r4, r5, lr}
	mov r4, r0
	ldr r3, SkillTester
	mov lr, r3
	mov r0, r4
	ldr r1, IdentityProblemsID
	.short 0xf800
	cmp r0, #0
	beq Original
	ldr r1, IdentityProblemsNames
	mov r5, #0
IdCountLoop:
	ldrh r2, [r1, r5]
	cmp r2, #0
	beq IdCountDone
	add r5, #2
	b IdCountLoop
IdCountDone:
	lsr r5, #1
	cmp r5, #0
	beq Original
	ldr r1, IdentityRamByte
	ldrb r0, [r1]
	cmp r0, r5
	blo HaveIdx
	mov r0, r5
	ldr r3, =NextRN_N
	mov lr, r3
	nop
	nop
	nop
	nop
	.short 0xf800
	ldr r1, IdentityRamByte
	strb r0, [r1]
HaveIdx:
	lsl r0, #1
	ldr r1, IdentityProblemsNames
	ldrh r0, [r1, r0]
	b IdentityNameIdDone
Original:
	ldr r0, [r4]
	ldrh r0, [r0]
IdentityNameIdDone:
	pop {r4, r5}
	pop {r1}
	bx r1

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
@POIN IdentityProblemsNames
