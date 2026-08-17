.thumb
.align 2

@ FE7U Expanded Modular Save core (DEC-68)

.equ WriteSaveBlockInfo,           0x0809E7A1
.equ ClearSaveBlock,               0x080A10D9
.equ UpdateLastUsedGameSaveSlot,   0x080A05D5
.equ WriteAndVerifySramFast,       0x080BFBD9
.equ ReadSramFastPtr,              0x03005E70
.equ IsSramWorking,                0x0809E479
.equ gChapterData,                 0x0202BBF8
.equ gGenericBuffer,               0x02020140
.equ gBmSt,                        0x0202BBB8

.equ MAGIC_GAME,                   0x00011217
.equ MAGIC_SUSPEND,                0x00020509

.global MS_GetSaveAddressBySlot
.type MS_GetSaveAddressBySlot, %function
MS_GetSaveAddressBySlot:
	cmp r0, #6
	bhi bad_slot
	ldr r1, =gSaveBlockDecl
	lsl r2, r0, #2
	add r1, r2
	ldrh r0, [r1]
	ldr r1, =0x0E000000
	add r0, r1
	bx lr
bad_slot:
	mov r0, #0
	bx lr

.align 2
.global MS_FindGameSaveChunk
.type MS_FindGameSaveChunk, %function
MS_FindGameSaveChunk:
	ldr r1, =gGameSaveChunks
	b FindChunk

.align 2
.global MS_FindSuspendSaveChunk
.type MS_FindSuspendSaveChunk, %function
MS_FindSuspendSaveChunk:
	ldr r1, =gSuspendSaveChunks
FindChunk:
	ldrh r2, [r1]
	ldr r3, =0xFFFF
	cmp r2, r3
	beq find_miss
	ldrh r2, [r1, #0x0C]
	cmp r2, r0
	beq find_hit
	add r1, #0x10
	b FindChunk
find_miss:
	mov r0, #0
	bx lr
find_hit:
	mov r0, r1
	bx lr

.align 2
.global MS_LoadChapterStateFromGameSave
.type MS_LoadChapterStateFromGameSave, %function
MS_LoadChapterStateFromGameSave:
	push {r4, r5, lr}
	mov r5, r1
	bl MS_GetSaveAddressBySlot
	mov r4, r0
	ldr r0, =gMS_ChapterStateChunkId
	ldrb r0, [r0]
	bl MS_FindGameSaveChunk
	ldrh r1, [r0]
	ldrh r2, [r0, #2]
	add r0, r4, r1
	mov r1, r5
	ldr r3, =ReadSramFastPtr
	ldr r3, [r3]
	bl bx_r3
	pop {r4, r5}
	pop {r1}
	bx r1

.align 2
.global MS_LoadChapterStateFromSuspendSave
.type MS_LoadChapterStateFromSuspendSave, %function
MS_LoadChapterStateFromSuspendSave:
	push {r4, r5, lr}
	mov r5, r1
	bl MS_GetSaveAddressBySlot
	mov r4, r0
	ldr r0, =gMS_ChapterStateChunkId
	ldrb r0, [r0]
	bl MS_FindSuspendSaveChunk
	ldrh r1, [r0]
	ldrh r2, [r0, #2]
	add r0, r4, r1
	mov r1, r5
	ldr r3, =ReadSramFastPtr
	ldr r3, [r3]
	bl bx_r3
	pop {r4, r5}
	pop {r1}
	bx r1

.align 2
.global MS_GetClaimFlagsFromGameSave
.type MS_GetClaimFlagsFromGameSave, %function
MS_GetClaimFlagsFromGameSave:
	push {r4, lr}
	sub sp, #4
	bl MS_GetSaveAddressBySlot
	mov r4, r0
	ldr r0, =gMS_ClaimFlagsChunkId
	ldrb r0, [r0]
	bl MS_FindGameSaveChunk
	ldrh r1, [r0]
	add r0, r4, r1
	mov r1, sp
	mov r2, #4
	ldr r3, =ReadSramFastPtr
	ldr r3, [r3]
	bl bx_r3
	ldr r0, [sp]
	add sp, #4
	pop {r4}
	pop {r1}
	bx r1

.align 2
.global MS_CopyGameSave
.type MS_CopyGameSave, %function
MS_CopyGameSave:
	push {r4, r5, r6, r7, lr}
	mov r4, r0
	mov r5, r1
	bl MS_GetSaveAddressBySlot
	mov r6, r0
	mov r0, r5
	bl MS_GetSaveAddressBySlot
	mov r7, r0
	ldr r0, =gSaveBlockTypeSizeLookup
	ldrh r2, [r0]
	ldr r3, =ReadSramFastPtr
	ldr r3, [r3]
	mov r0, r6
	ldr r1, =gGenericBuffer
	bl bx_r3
	ldr r0, =gSaveBlockTypeSizeLookup
	ldrh r2, [r0]
	ldr r0, =gGenericBuffer
	mov r1, r7
	ldr r3, =WriteAndVerifySramFast
	bl bx_r3
	sub sp, #0x10
	mov r0, sp
	ldr r1, =MAGIC_GAME
	str r1, [r0]
	mov r1, #0
	strb r1, [r0, #6]
	mov r1, r5
	ldr r3, =WriteSaveBlockInfo
	bl bx_r3
	add sp, #0x10
	pop {r4, r5, r6, r7}
	pop {r0}
	bx r0

.align 2
.global MS_SaveGame
.type MS_SaveGame, %function
MS_SaveGame:
	push {r4, r5, r6, lr}
	mov r4, r0
	bl MS_GetSaveAddressBySlot
	mov r5, r0
	mov r0, #3
	ldr r3, =ClearSaveBlock
	bl bx_r3
	ldr r0, =gChapterData
	strb r4, [r0, #0x0C]
	ldr r6, =gGameSaveChunks
save_game_loop:
	ldrh r0, [r6]
	ldr r1, =0xFFFF
	cmp r0, r1
	beq save_game_meta
	ldr r3, [r6, #4]
	cmp r3, #0
	beq save_game_next
	ldrh r1, [r6, #2]
	add r0, r5, r0
	bl bx_r3
save_game_next:
	add r6, #0x10
	b save_game_loop
save_game_meta:
	sub sp, #0x10
	mov r0, sp
	ldr r1, =MAGIC_GAME
	str r1, [r0]
	mov r1, #0
	strb r1, [r0, #6]
	mov r1, r4
	ldr r3, =WriteSaveBlockInfo
	bl bx_r3
	add sp, #0x10
	mov r0, r4
	ldr r3, =UpdateLastUsedGameSaveSlot
	bl bx_r3
	pop {r4, r5, r6}
	pop {r0}
	bx r0

.align 2
.global MS_LoadGame
.type MS_LoadGame, %function
MS_LoadGame:
	push {r4, r5, r6, lr}
	mov r4, r0
	bl MS_GetSaveAddressBySlot
	mov r5, r0
	ldr r0, =gChapterData
	ldrb r0, [r0, #0x14]
	mov r1, #0x40
	and r0, r1
	cmp r0, #0
	bne load_game_chunks
	mov r0, #3
	ldr r3, =ClearSaveBlock
	bl bx_r3
load_game_chunks:
	ldr r6, =gGameSaveChunks
load_game_loop:
	ldrh r0, [r6]
	ldr r1, =0xFFFF
	cmp r0, r1
	beq load_game_done
	ldr r3, [r6, #8]
	cmp r3, #0
	beq load_game_next
	ldrh r1, [r6, #2]
	add r0, r5, r0
	bl bx_r3
load_game_next:
	add r6, #0x10
	b load_game_loop
load_game_done:
	mov r0, r4
	ldr r3, =UpdateLastUsedGameSaveSlot
	bl bx_r3
	pop {r4, r5, r6}
	pop {r0}
	bx r0

.align 2
.global MS_SaveSuspend
.type MS_SaveSuspend, %function
MS_SaveSuspend:
	push {r4, r5, r6, lr}
	mov r4, r0
	ldr r0, =gChapterData
	ldrb r0, [r0, #0x14]
	mov r1, #8
	and r0, r1
	cmp r0, #0
	bne sus_done
	ldr r3, =IsSramWorking
	bl bx_r3
	cmp r0, #0
	beq sus_done
	mov r0, r4
	bl MS_GetSaveAddressBySlot
	mov r5, r0
	ldr r6, =gSuspendSaveChunks
sus_loop:
	ldrh r0, [r6]
	ldr r1, =0xFFFF
	cmp r0, r1
	beq sus_meta
	ldr r3, [r6, #4]
	cmp r3, #0
	beq sus_next
	ldrh r1, [r6, #2]
	add r0, r5, r0
	bl bx_r3
sus_next:
	add r6, #0x10
	b sus_loop
sus_meta:
	sub sp, #0x10
	mov r0, sp
	ldr r1, =MAGIC_SUSPEND
	str r1, [r0]
	mov r1, #1
	strb r1, [r0, #6]
	mov r1, r4
	ldr r3, =WriteSaveBlockInfo
	bl bx_r3
	add sp, #0x10
	ldr r0, =gBmSt
	mov r1, #0
	@ just_resumed (FE8 offset; FE7 BmSt layout matches)
	add r0, #0x3C
	strb r1, [r0]
sus_done:
	pop {r4, r5, r6}
	pop {r0}
	bx r0

.align 2
.global MS_LoadSuspend
.type MS_LoadSuspend, %function
MS_LoadSuspend:
	push {r4, r5, r6, lr}
	mov r4, r0
	bl MS_GetSaveAddressBySlot
	mov r5, r0
	ldr r6, =gSuspendSaveChunks
load_sus_loop:
	ldrh r0, [r6]
	ldr r1, =0xFFFF
	cmp r0, r1
	beq load_sus_done
	ldr r3, [r6, #8]
	cmp r3, #0
	beq load_sus_next
	ldrh r1, [r6, #2]
	add r0, r5, r0
	bl bx_r3
load_sus_next:
	add r6, #0x10
	b load_sus_loop
load_sus_done:
	pop {r4, r5, r6}
	pop {r0}
	bx r0

bx_r3:
	bx r3

.ltorg
.align 2
