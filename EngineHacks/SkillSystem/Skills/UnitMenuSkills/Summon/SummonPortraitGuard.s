.thumb
.align

@ ============================================================================
@ Never hand NewFace a portrait id it cannot draw
@
@ The weapon-select popup pipes GetUnitPortraitId straight into NewFace with no
@ range check, in both variants:
@
@   08021AA8 / 08021AF4   bl GetUnitPortraitId
@   08021AB8 / 08021B04   bl NewFace
@
@ NewFace resolves an id through 0x08006B20, which is just
@ `base 0x08C96584 + id*0x1C` with no bounds test, then dereferences the
@ graphics pointer out of that entry.  Executing every id from 0x00..0x0F and
@ 0xBE..0xE3 under Unicorn, exactly one faults: **id 0**.  Entry 0 is not a
@ portrait, and its "graphics pointer" is table header data, so the read walks
@ off into nothing and the popup hangs.
@
@ id 0 is precisely what GetUnitPortraitId returns when a unit has neither a
@ character portrait (char+0x06) nor a class portrait (class+0x08) -- its
@ documented "no face" answer.  Vanilla never hits it because every vanilla
@ unit has one or the other; a summon whose class pointer is not the summon
@ class does.
@
@ So the guard belongs on the getter, where the 0 is produced, rather than on
@ the two call sites: the stat screen and the battle forecast read the same
@ routine, and all three want the same answer.  0xDE, the generic class card,
@ is what FE7 already falls back to for classes with no portrait of their own,
@ and it draws correctly (verified alongside the fault above).
@
@ Returning 0xFFFF instead would NOT work: it faults in NewFace exactly like 0
@ does.  The 0xFFFF "leave the face alone" convention belongs to the mug
@ loading loop (0x08007898), not to NewFace.
@ ============================================================================

.equ FallbackPortrait, 0xDE     @ the generic class card
.equ NextRN_N, 0x08000E31
.equ RandomMugID, SkillTester+4
.equ IdentityProblemsID, RandomMugID+4
.equ IdentityRamByte, IdentityProblemsID+4
.equ IdentityMugs, IdentityRamByte+4
.equ IdentityProblemsMugs, IdentityMugs+4
.equ CharacterTable, IdentityProblemsMugs+4
.equ IdentityCharMax, CharacterTable+4

.global SummonPortraitGuard
.type SummonPortraitGuard, %function
SummonPortraitGuard:
	@ Vanilla GetUnitPortraitId, inlined.  It cannot be called: replaceWithHack
	@ writes 16 bytes over 0x08018BD8 and the whole routine is only 0x1A bytes,
	@ so the original body no longer exists to jump back to.
	mov r2,r0                   @ r2 = Unit*
	cmp r2,#0
	beq SummonPortraitGuard_Fallback

	ldr r1,[r2,#0x0]            @ pCharacterData
	cmp r1,#0
	beq SummonPortraitGuard_Class
	ldrh r0,[r1,#0x6]
	cmp r0,#0
	bne SummonPortraitGuard_Out

SummonPortraitGuard_Class:
	ldr r1,[r2,#0x4]            @ pClassData
	cmp r1,#0
	beq SummonPortraitGuard_Fallback
	ldrh r0,[r1,#0x8]
	cmp r0,#0
	bne SummonPortraitGuard_Out

SummonPortraitGuard_Fallback:
	@ Vanilla would return 0 here and NewFace would hang on it.
	mov r0,#FallbackPortrait

SummonPortraitGuard_Out:
	@ r0 = portrait, r2 = Unit* (or 0)
	cmp r2,#0
	beq SummonPortraitGuard_Return
	push {r4,r5,r6,r7,lr}
	mov r4,r2
	mov r5,r0
	ldr r0,SkillTester
	mov lr,r0
	mov r0,r4
	ldr r1,RandomMugID
	.short 0xf800
	cmp r0,#0
	bne SummonPortraitGuard_Quantum
	ldr r0,SkillTester
	mov lr,r0
	mov r0,r4
	ldr r1,IdentityProblemsID
	.short 0xf800
	cmp r0,#0
	beq SummonPortraitGuard_Keep
	bl IdentityPickChar
	cmp r0,#0
	beq SummonPortraitGuard_Keep
	ldr r1,CharacterTable
	mov r2,#0x34
	mul r2,r0
	add r1,r2
	ldrh r5,[r1,#6]
	cmp r5,#0
	bne SummonPortraitGuard_Keep
	mov r5,#FallbackPortrait
	b SummonPortraitGuard_Keep

SummonPortraitGuard_Quantum:
	ldr r0,IdentityMugs
	bl CountMugs
	cmp r0,#0
	beq SummonPortraitGuard_Keep
	ldr r3,=NextRN_N
	mov lr,r3
	nop
	nop
	nop
	nop
	.short 0xf800
	ldr r1,IdentityMugs
	ldrb r5,[r1,r0]

SummonPortraitGuard_Keep:
	mov r0,r5
SummonPortraitGuard_HaveMug:
	pop {r4,r5,r6,r7}
	pop {r1}
	bx r1

SummonPortraitGuard_Return:
	bx lr

@ ============================================================================
@ GetUnitMiniPortraitId (0x08018BF4).  Minimug box, trade, and the status
@ face all call this instead of GetUnitPortraitId.  Vanilla inlines the
@ portrait read from character+0x06 when miniPortrait is 0, so the hook
@ above never sees those draws.
@ ============================================================================
.global SummonMiniPortraitGuard
.type SummonMiniPortraitGuard, %function
SummonMiniPortraitGuard:
	mov r2,r0
	cmp r2,#0
	beq SummonMiniPortraitGuard_Fallback
	ldr r1,[r2,#0x0]
	cmp r1,#0
	beq SummonMiniPortraitGuard_Class
	ldrb r0,[r1,#0x8]
	cmp r0,#0
	beq SummonMiniPortraitGuard_Portrait
	mov r3,#0xFE
	lsl r3,r3,#7
	orr r0,r3
	b SummonPortraitGuard_Out

SummonMiniPortraitGuard_Portrait:
	ldrh r0,[r1,#0x6]
	cmp r0,#0
	bne SummonPortraitGuard_Out

SummonMiniPortraitGuard_Class:
	ldr r1,[r2,#0x4]
	cmp r1,#0
	beq SummonMiniPortraitGuard_Fallback
	ldrh r0,[r1,#0x8]
	cmp r0,#0
	bne SummonPortraitGuard_Out

SummonMiniPortraitGuard_Fallback:
	mov r0,#FallbackPortrait
	b SummonPortraitGuard_Out

@ r0 = byte list. Returns entry count (stops at 0).
CountMugs:
	mov r1, r0
	mov r0, #0
CountMugsLoop:
	ldrb r2, [r1, r0]
	cmp r2, #0
	beq CountMugsDone
	add r0, #1
	b CountMugsLoop
CountMugsDone:
	bx lr

@ in r4 = Unit*. out r0 = character id, or 0.
IdentityPickChar:
	push {r5, r6, r7, lr}
	ldr r7, IdentityCharMax
	cmp r7, #0
	beq IdentityPickFail
	ldr r1, IdentityRamByte
	ldr r2, [r1, #4]
	cmp r2, r4
	bne IdentityPickCount
	ldr r2, =0x03000010
	ldr r2, [r2]
	ldr r3, [r1, #8]
	sub r2, r3
	cmp r2, #1
	bhi IdentityPickCount
	ldr r2, =0x03000010
	ldr r2, [r2]
	str r2, [r1, #8]
	ldrb r0, [r1]
	cmp r0, #0
	beq IdentityPickCount
	cmp r0, r7
	bls IdentityPickDone
IdentityPickCount:
	mov r5, #0
	mov r6, #1
IdentityPickCountLoop:
	ldr r1, CharacterTable
	mov r2, #0x34
	mul r2, r6
	add r1, r2
	ldrh r2, [r1]
	cmp r2, #0
	beq IdentityPickCountNext
	ldrh r2, [r1, #6]
	cmp r2, #0
	beq IdentityPickCountNext
	add r5, #1
IdentityPickCountNext:
	add r6, #1
	cmp r6, r7
	bls IdentityPickCountLoop
	cmp r5, #0
	beq IdentityPickFail
	mov r0, r5
	ldr r3, =NextRN_N
	mov lr, r3
	nop
	.short 0xf800
	mov r5, r0
	mov r6, #1
IdentityPickWalk:
	cmp r6, r7
	bhi IdentityPickFail
	ldr r1, CharacterTable
	mov r2, #0x34
	mul r2, r6
	add r1, r2
	ldrh r2, [r1]
	cmp r2, #0
	beq IdentityPickWalkNext
	ldrh r2, [r1, #6]
	cmp r2, #0
	beq IdentityPickWalkNext
	cmp r5, #0
	beq IdentityPickFound
	sub r5, #1
IdentityPickWalkNext:
	add r6, #1
	b IdentityPickWalk
IdentityPickFound:
	mov r0, r6
	ldr r1, IdentityRamByte
	strb r0, [r1]
	str r4, [r1, #4]
	ldr r2, =0x03000010
	ldr r2, [r2]
	str r2, [r1, #8]
	b IdentityPickDone
IdentityPickFail:
	mov r0, #0
IdentityPickDone:
	pop {r5, r6, r7}
	pop {r1}
	bx r1

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD RandomMugID
@WORD IdentityProblemsID
@WORD IdentityRamByte
@POIN IdentityMugList
@POIN IdentityProblemsMugs
@POIN CharacterTable
@WORD IdentityCharMax
