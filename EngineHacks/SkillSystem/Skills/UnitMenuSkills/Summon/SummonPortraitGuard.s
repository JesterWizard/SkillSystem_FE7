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
	bx lr

.align
.ltorg
