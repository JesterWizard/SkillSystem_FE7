.thumb

@ r0 = stat, r1 = unit. Half if rescuing unless Savior.
@ Call SkillTester with bl+bx so lr keeps the Thumb bit. A lone .short 0xF800
@ is a BL suffix without a prefix; on hardware that does not reliably call
@ SkillTester, so Savior never skipped the rescue half.
.equ SaviorID, SkillTester+4

.global HalveIfRescuing
.type HalveIfRescuing, %function
HalveIfRescuing:
	push {r4, r5, lr}
	mov r4, r0
	mov r5, r1
	ldr r0, [r5, #0xC]
	mov r1, #0x10
	and r0, r1
	cmp r0, #0
	beq SkipHalf
	mov r0, r5
	ldr r1, SaviorID
	ldr r3, SkillTester
	bl CallTester
	cmp r0, #0
	bne SkipHalf
	lsr r4, #1
SkipHalf:
	mov r0, r4
HalveIfRescuingDone:
	pop {r4, r5}
	pop {r1}
	bx r1

.thumb_func
CallTester:
	mov r2, #1
	orr r3, r2
	bx r3

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD SaviorID
