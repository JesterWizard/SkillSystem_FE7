.thumb
@ FE7 has no SADD. Copy event slot 2 into slot 1 (heal target).
CopySlot2ToSlot1:
	ldr r3, =0x030004B8
	ldr r1, [r3, #8]
	str r1, [r3, #4]
	bx lr
.align
.ltorg
