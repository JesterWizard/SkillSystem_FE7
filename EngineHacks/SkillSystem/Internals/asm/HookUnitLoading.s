
	.thumb

	@ jumptohack at UnitLoadSupports (FE7 0x080179F0)
	@ supports[] = learned skills. Support exp in gBwlSupportExp for BWL units.
	@ Non-players keep supports[6] as AI leader (set by LoadUnit).

	lAutoloadSkills = EALiterals+0x00
	lInitBwlSupports = EALiterals+0x04

HookUnitLoading:
	push {r4-r7, lr}
	mov r5, r0

	mov r0, r5
	ldr r3, lAutoloadSkills
	bl BXR3

	mov r0, r5
	ldr r3, lInitBwlSupports
	bl BXR3

	mov r0, #0
	ldr r1, =0x202BBE6
	strh r0, [r1]

	@ DEC-85: a freshly loaded unit owes nothing, so drop all sixteen skill
	@ activation flags. This is the once-per-map reset -- the flags live in
	@ unit+0x3A/0x3B and only survive within a chapter.
	mov r0, #0
	strh r0, [r5, #0x3A]

	mov r0, r5
	pop {r4-r7}
	pop {r1}
	bx r1

BXR3:
	bx r3

	.pool
	.align

EALiterals:
	@ POIN (AutoloadSkills|1)
	@ POIN (InitBwlSupportsForUnit|1)
