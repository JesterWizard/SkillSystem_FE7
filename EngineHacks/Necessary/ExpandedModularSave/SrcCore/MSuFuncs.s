.thumb
.align 2

@ FE7U EMS suspend-only chunk helpers

.equ StoreRNStateToActionStruct, 0x0802F1F9
.equ LoadRNStateFromActionStruct, 0x0802F209
.equ WriteAndVerifySramFast,     0x080BFBD9
.equ ReadSramFastPtr,            0x03005E70
.equ SetBonusContentClaimFlags,  0x080A0589
.equ gActionData,                0x0203A85C
.equ gChapterData,               0x0202BBF8

.global MSu_SaveActionState
.type MSu_SaveActionState, %function
MSu_SaveActionState:
	push {r4, r5, lr}
	mov r4, r0
	mov r5, r1
	ldr r3, =StoreRNStateToActionStruct
	bl bx_r3
	ldr r0, =gActionData
	mov r1, r4
	mov r2, r5
	ldr r3, =WriteAndVerifySramFast
	bl bx_r3
	pop {r4, r5}
	pop {r0}
	bx r0

.align 2
.global MSu_LoadActionState
.type MSu_LoadActionState, %function
MSu_LoadActionState:
	push {r4, lr}
	mov r4, r1
	ldr r1, =gActionData
	mov r2, r4
	ldr r3, =ReadSramFastPtr
	ldr r3, [r3]
	bl bx_r3
	ldr r3, =LoadRNStateFromActionStruct
	bl bx_r3
	pop {r4}
	pop {r0}
	bx r0

.align 2
.global MSu_LoadClaimFlagsFromParentSave
.type MSu_LoadClaimFlagsFromParentSave, %function
MSu_LoadClaimFlagsFromParentSave:
	push {lr}
	ldr r0, =gChapterData
	ldrb r0, [r0, #0x0C]
	ldr r3, =MS_GetClaimFlagsFromGameSave
	bl bx_r3
	ldr r3, =SetBonusContentClaimFlags
	bl bx_r3
	pop {r0}
	bx r0

bx_r3:
	bx r3

.ltorg
.align 2
