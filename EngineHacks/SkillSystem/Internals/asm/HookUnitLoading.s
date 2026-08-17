
	.thumb

	@ unit loading routine

	@ 8017ef4 handles supports, this oughta be a good place to branch off imo

	@ jumptohack at 8017EF4

	lAutoloadSkills   = EALiterals+0x00
@	lGetSkills        = EALiterals+0x04
@	lChargeupTable    = EALiterals+0x08

	.macro blh to, reg=r3
		ldr \reg, =\to
		mov lr, \reg
		.short 0xf800
	.endm

HookUnitLoading:
	@r0 contains ram data
	push {r4-r7, lr}
	mov r5, r0

	@ Do not wipe BWL+1..4 here: that is the saved learned-skill blob.
	@ Favval/act/statView writers are stubbed in SkillSystem.event instead.
	mov r0, r5
	ldr r3, lAutoloadSkills
	bl BXR3

	@ avoid skill forgetting issues after loading units that learn more than 4 skills
	mov  r0, #0
	ldr  r1, =0x202BBE6 @ fe7 -> FE8 0x0202BCDE
	strh r0,[r1]

	@ original UnitLoadSupports: jumpToHack ate the BL to GetUnitSupporterCount.
	@ Resume at hook+8 (0x080179F0 + 8).
	mov r0, r5
	blh 0x08026628 @ GetUnitSupporterCount; FE8 0x080281C8
	ldr r6, =0x080179F9 @ UnitLoadSupports+9; FE8 0x08017EFD
	bx  r6

BXR3:
	bx r3

	.pool
	.align

EALiterals:
	@ POIN (AutoloadSkills|1)
	@ POIN (Skill_Getter|1)
	@ POIN ChargeupTable
