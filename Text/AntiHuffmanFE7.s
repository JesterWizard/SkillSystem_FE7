.thumb
.align 2

@ r0 = string pointer (bit 31 set = uncompressed), r1 = dest buffer
AntiHuffmanFE7:
	push	{r4,r5,lr}
	mov	r4, r0
	mov	r5, r1
	cmp	r4, #0
	bge	Huffman
	lsl	r0, r4, #1
	lsr	r0, r0, #1
CopyLoop:
	ldrb	r2, [r0]
	strb	r2, [r5]
	add	r0, #1
	add	r5, #1
	cmp	r2, #0
	bne	CopyLoop
	pop	{r4,r5}
	pop	{r1}
	bx	r1
Huffman:
	ldr	r2, =0x03003940
	ldr	r2, [r2]
	mov	r0, r4
	mov	r1, r5
	pop	{r4,r5}
	pop	{r3}
	mov	lr, r3
	bx	r2
	.align
	.ltorg
