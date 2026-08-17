.thumb
.align 2

@ FE7U EMS chunk helpers used by game + suspend saves

.equ GetGameClock,             0x08000F15
.equ SetGameClock,             0x08000F2D
.equ WriteAndVerifySramFast,   0x080BFBD9
.equ ReadSramFastPtr,          0x03005E70
.equ gChapterData,             0x0202BBF8
.equ BonusClaimFlags,          0x0203ECC0

.global MSa_SaveChapterState
.type MSa_SaveChapterState, %function
MSa_SaveChapterState:
	push {r4, r5, lr}
	mov r4, r0
	mov r5, r1
	ldr r3, =GetGameClock
	bl bx_r3
	ldr r1, =gChapterData
	str r0, [r1]
	mov r0, r1
	mov r1, r4
	mov r2, r5
	ldr r3, =WriteAndVerifySramFast
	bl bx_r3
	pop {r4, r5}
	pop {r0}
	bx r0

.align 2
.global MSa_LoadChapterState
.type MSa_LoadChapterState, %function
MSa_LoadChapterState:
	push {r4, lr}
	mov r4, r1
	ldr r1, =gChapterData
	mov r2, r4
	ldr r3, =ReadSramFastPtr
	ldr r3, [r3]
	bl bx_r3
	ldr r0, =gChapterData
	ldr r0, [r0]
	ldr r3, =SetGameClock
	bl bx_r3
	pop {r4}
	pop {r0}
	bx r0

.align 2
.global MSa_SaveBonusClaim
.type MSa_SaveBonusClaim, %function
MSa_SaveBonusClaim:
	push {lr}
	mov r2, r1
	mov r1, r0
	ldr r0, =BonusClaimFlags
	ldr r3, =WriteAndVerifySramFast
	bl bx_r3
	pop {r0}
	bx r0

.align 2
.global MSa_LoadBonusClaim
.type MSa_LoadBonusClaim, %function
MSa_LoadBonusClaim:
	push {lr}
	mov r2, r1
	ldr r1, =BonusClaimFlags
	ldr r3, =ReadSramFastPtr
	ldr r3, [r3]
	bl bx_r3
	pop {r0}
	bx r0

bx_r3:
	bx r3

.ltorg
.align 2
