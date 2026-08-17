.thumb

.global MS_BWLSaveHook
.type   MS_BWLSaveHook, %function

@ FE7U: hook at 0809FE76, return to 0809FECC
ReturnLocation = (0x0809FECC+1)

GetSaveWriteAddr     = (0x0809E870+1)
ReadSaveBlockInfo    = (0x0809E6FC+1)
WriteSaveBlockInfo   = (0x0809E7A0+1)
WriteAndVerifySramFast = (0x080BFBD8+1)

MS_BWLSaveHook:
	@ KNOWN STATE (FE7):
	@  r0-r4 free
	@  r5 = RAM BWL entry
	@  r6 = BWL offset (CharID*$10)
	@  r7 = gChapterData
	@  r8 = CharID

	@ STEP 1 : SUSPEND SAVE
	mov r0, #3
	ldr r3, =GetSaveWriteAddr
	bl  BXR3

	mov r4, r0

	ldr  r0, =gMS_BWLChunkId
	ldrb r0, [r0]

	ldr r3, =MS_FindSuspendSaveChunk
	bl  BXR3

	ldrh r1, [r0, #0x00]
	sub  r1, #0x10
	add  r1, r6
	add  r1, r4

	mov r0, r5
	mov r2, #1
	ldr r3, =WriteAndVerifySramFast
	bl  BXR3

	mov r0, sp
	mov r1, #3
	ldr r3, =ReadSaveBlockInfo
	bl  BXR3

	mov r0, sp
	mov r1, #3
	ldr r3, =WriteSaveBlockInfo
	bl  BXR3

	@ STEP 2 : GAME SAVE
	ldrb r0, [r7, #0x0C]
	ldr r3, =GetSaveWriteAddr
	bl  BXR3

	mov r4, r0

	ldr  r0, =gMS_BWLChunkId
	ldrb r0, [r0]

	ldr r3, =MS_FindGameSaveChunk
	bl  BXR3

	ldrh r1, [r0, #0x00]
	sub  r1, #0x10
	add  r1, r6
	add  r1, r4

	mov r0, r5
	mov r2, #1
	ldr r3, =WriteAndVerifySramFast
	bl  BXR3

	mov  r0, sp
	ldrb r1, [r7, #0x0C]
	ldr r3, =ReadSaveBlockInfo
	bl  BXR3

	mov  r0, sp
	ldrb r1, [r7, #0x0C]
	ldr r3, =WriteSaveBlockInfo
	bl  BXR3

	ldr r3, =ReturnLocation
BXR3:	bx  r3

	.align
	.ltorg
