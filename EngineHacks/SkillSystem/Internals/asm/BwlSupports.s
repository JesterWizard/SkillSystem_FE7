
	.thumb

	@ DEC-59: support exp for BWL units in gBwlSupportExp[pid][7].
	@ unit->supports[] = learned skills; non-players keep supports[6] as leader.

	gBwlSupportExp = 0x0203FE10
	BWL_GetEntry = 0x080A0550|1
	GetUnitSupporterCount = 0x08026628|1
	GetUnitSupporterInitialExp = 0x080267F4|1
	AddSupportPoints_VanillaContinue = 0x08026753

	SUPPORT_SLOTS = 7

	.global GetBwlSupportRow
	.global InitBwlSupportsForUnit
	.global GetUnitSupportLevel_Bwl
	.global AddSupportPoints_Bwl
	.global ClearBwlSupportExp
	.global SUD_SaveBwlSupports
	.global SUD_LoadBwlSupports

	.macro blh to, reg=r3
		ldr \reg, =\to
		mov lr, \reg
		.short 0xF800
	.endm

@ r0 = char id -> r0 = &gBwlSupportExp[pid*7] or NULL
GetBwlSupportRow:
	push {r4, lr}
	mov r4, r0
	cmp r4, #1
	blt GetBwlSupportRow.fail
	cmp r4, #0x45
	bgt GetBwlSupportRow.fail
	mov r0, r4
	blh BWL_GetEntry
	cmp r0, #0
	beq GetBwlSupportRow.fail
	mov r0, #SUPPORT_SLOTS
	mul r0, r4
	ldr r1, =gBwlSupportExp
	add r0, r1
	pop {r4}
	pop {r1}
	bx r1
GetBwlSupportRow.fail:
	mov r0, #0
	pop {r4}
	pop {r1}
	bx r1

@ r0 = Unit. Fill BWL support row from character base exp when BWL exists.
InitBwlSupportsForUnit:
	push {r4-r7, lr}
	mov r4, r0
	ldr r0, [r4]
	cmp r0, #0
	beq InitBwlSupportsForUnit.end
	ldrb r0, [r0, #4]
	bl GetBwlSupportRow
	cmp r0, #0
	beq InitBwlSupportsForUnit.end
	mov r6, r0
	@ Ensure table inited (EWRAM may hold garbage after boot).
	ldr r0, =gBwlSupportExp
	ldr r1, =0x1EC
	ldrb r0, [r0, r1]
	cmp r0, #0x42
	beq InitBwlSupportsForUnit.inited
	bl ClearBwlSupportExp
InitBwlSupportsForUnit.inited:
	@ Only seed bases when row still empty (do not wipe save progress).
	mov r1, #0
	mov r2, #0
InitBwlSupportsForUnit.check:
	ldrb r3, [r6, r2]
	orr r1, r3
	add r2, #1
	cmp r2, #SUPPORT_SLOTS
	blt InitBwlSupportsForUnit.check
	cmp r1, #0
	bne InitBwlSupportsForUnit.end
	mov r0, r4
	blh GetUnitSupporterCount
	mov r7, r0
	mov r5, #0
InitBwlSupportsForUnit.lop:
	cmp r5, r7
	bge InitBwlSupportsForUnit.end
	cmp r5, #SUPPORT_SLOTS
	bge InitBwlSupportsForUnit.end
	mov r0, r4
	mov r1, r5
	blh GetUnitSupporterInitialExp
	strb r0, [r6, r5]
	add r5, #1
	b InitBwlSupportsForUnit.lop
InitBwlSupportsForUnit.end:
	mov r0, r4
	pop {r4-r7}
	pop {r1}
	bx r1

@ Replaces FE7 GetUnitSupportLevel (0x08026694)
GetUnitSupportLevel_Bwl:
	push {r4, lr}
	mov r4, r1
	ldr r0, [r0]
	cmp r0, #0
	beq GetUnitSupportLevel_Bwl.zero
	ldrb r0, [r0, #4]
	bl GetBwlSupportRow
	cmp r0, #0
	beq GetUnitSupportLevel_Bwl.zero
	ldrb r0, [r0, r4]
	cmp r0, #0xF0
	ble GetUnitSupportLevel_Bwl.not_a
	mov r0, #3
	b GetUnitSupportLevel_Bwl.end
GetUnitSupportLevel_Bwl.not_a:
	cmp r0, #0xA0
	ble GetUnitSupportLevel_Bwl.not_b
	mov r0, #2
	b GetUnitSupportLevel_Bwl.end
GetUnitSupportLevel_Bwl.not_b:
	cmp r0, #0x50
	blt GetUnitSupportLevel_Bwl.zero
	mov r0, #1
	b GetUnitSupportLevel_Bwl.end
GetUnitSupportLevel_Bwl.zero:
	mov r0, #0
GetUnitSupportLevel_Bwl.end:
	pop {r4}
	pop {r1}
	bx r1

@ Replaces FE7 AddSupportPoints (0x08026744)
@ Same stack frame as vanilla; on success tails into vanilla after supports++.
AddSupportPoints_Bwl:
	push {r4, lr}
	mov r4, r0
	mov r2, r1
	ldr r0, [r4]
	cmp r0, #0
	beq AddSupportPoints_Bwl.fail
	ldrb r0, [r0, #4]
	mov r1, r2
	push {r1}
	bl GetBwlSupportRow
	pop {r1}
	cmp r0, #0
	beq AddSupportPoints_Bwl.fail
	ldrb r3, [r0, r1]
	cmp r3, #0xFF
	beq AddSupportPoints_Bwl.cont
	add r3, #1
	strb r3, [r0, r1]
AddSupportPoints_Bwl.cont:
	mov r0, r4
	@ r1 = slot
	ldr r3, =AddSupportPoints_VanillaContinue
	bx r3

AddSupportPoints_Bwl.fail:
	pop {r4}
	pop {r1}
	bx r1

ClearBwlSupportExp:
	ldr r0, =gBwlSupportExp
	mov r1, #0
	ldr r2, =0x1F0
ClearBwlSupportExp.lop:
	strb r1, [r0]
	add r0, #1
	sub r2, #1
	bne ClearBwlSupportExp.lop
	@ sentinel at end-4
	ldr r0, =gBwlSupportExp
	ldr r1, =0x1EC
	add r0, r1
	mov r1, #0x42
	strb r1, [r0]
	bx lr

	WriteAndVerifySramFast = 0x080BFBD8|1
	ReadSramFastAddr       = 0x03005E70

SUD_SaveBwlSupports:
	ldr r3, =WriteAndVerifySramFast
	mov r2, r1
	mov r1, r0
	ldr r0, =gBwlSupportExp
	bx r3

SUD_LoadBwlSupports:
	ldr r3, =ReadSramFastAddr
	ldr r3, [r3]
	mov r2, r1
	ldr r1, =gBwlSupportExp
	bx r3

	.pool
	.align
