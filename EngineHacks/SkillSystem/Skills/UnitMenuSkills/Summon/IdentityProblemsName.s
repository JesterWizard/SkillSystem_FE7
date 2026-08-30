.thumb

@ Identity Problems name IDs. Faces stay in SummonPortraitGuard.
@ Shared index in IdentityRamByte (0..2); generate if unset (>=3).

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
	push {r4, lr}
	mov r4, r0
	ldr r3, SkillTester
	mov lr, r3
	mov r0, r4
	ldr r1, IdentityProblemsID
	.short 0xf800
	cmp r0, #0
	beq Original
	ldr r1, IdentityRamByte
	ldrb r0, [r1]
	cmp r0, #3
	blo HaveIdx
	mov r0, #3
	ldr r3, =NextRN_N
	mov lr, r3
	mov r1, r1
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
	pop {r4}
	pop {r1}
	bx r1

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
