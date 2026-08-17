.thumb
.global PowGetter
.type PowGetter, %function

@ r0 = unit*; returns Str in r0
PowGetter:
	push	{lr}
	mov		r1, #0x14
	ldsb	r0, [r0, r1]
	pop		{r1}
	bx		r1
