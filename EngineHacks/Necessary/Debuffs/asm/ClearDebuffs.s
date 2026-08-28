.thumb
	CpuSet           = 0x080BFA10|1
	ChapterData      = 0x0202BBF8

.global ClearAllDebuffs 
.type ClearAllDebuffs, %function 
ClearAllDebuffs:
	mov r0, #0

	push {r0, lr}

	mov r0, sp
	ldr r1, =DebuffTableRam_Link
	ldr r1, [r1] 

	mov r3, #1
	lsl r3, #24

	ldr r2, =DebuffTableSize_Link
	ldr r2, [r2] 
	lsr r2, #1
	orr r2, r3

	ldr r3, =CpuSet

	bl BXR3

	pop {r0, r3}

BXR3:
	bx r3
.ltorg 

@ Wipe leftover Init/Hone/Taker buffs when a new chapter's first player phase starts.
.global ClearDebuffsOnNewChapter
.type ClearDebuffsOnNewChapter, %function
ClearDebuffsOnNewChapter:
	push {lr}
	ldr r0, =ChapterData
	ldrh r1, [r0, #0x10]
	cmp r1, #1
	bne ClearDebuffsOnNewChapter.done
	ldrb r1, [r0, #0xF]
	cmp r1, #0
	bne ClearDebuffsOnNewChapter.done
	bl ClearAllDebuffs
ClearDebuffsOnNewChapter.done:
	mov r0, #0
	pop {r1}
	bx r1
.ltorg 

.global ClearUnitDebuffs 
.type ClearUnitDebuffs, %function 
ClearUnitDebuffs: 
push {lr} 
@ given r0 = unit 
bl GetUnitDebuffEntry
mov r1, #0x0
mov r2, #0 
sub r2, #1 
ldr r3, =DebuffEntrySize_Link
ldr r3, [r3] 
Loop: 
add r2, #1 
cmp r2, r3 
bge Break 
strb r1, [r0, r2]                @Clear out this byte 
b Loop 

Break: 
pop {r0} 
bx r0 
.ltorg 



