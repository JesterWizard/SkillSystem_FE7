.thumb

.global GetTalkee
.type GetTalkee, %function
GetTalkee:
@ r0 = character id of the viewed unit
@ return Talk_Check partner character id, or 0
	push	{r4, r5, r6, lr}
	mov		r4, r0
	mov		r5, #1

GetTalkee_Loop:
	cmp		r5, #0xBF
	bgt		GetTalkee_None
	mov		r0, r5
	ldr		r3, GetUnit
	mov		lr, r3
	.short	0xF800
	cmp		r0, #0
	beq		GetTalkee_Next
	ldr		r2, [r0]
	cmp		r2, #0
	beq		GetTalkee_Next
	ldrb	r6, [r2, #4]
	cmp		r6, r4
	beq		GetTalkee_Next
	mov		r0, r4
	mov		r1, r6
	ldr		r3, Talk_Check
	mov		lr, r3
	.short	0xF800
	cmp		r0, #0
	beq		GetTalkee_Next
	mov		r0, r6
	b		GetTalkee_Done

GetTalkee_Next:
	add		r5, #1
	b		GetTalkee_Loop

GetTalkee_None:
	mov		r0, #0

GetTalkee_Done:
	pop		{r4, r5, r6, pc}

.align 2
GetUnit:
.word 0x08018D0C
Talk_Check:
.word 0x080789FC
