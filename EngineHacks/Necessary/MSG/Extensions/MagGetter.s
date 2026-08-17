.thumb
.global MagGetter
.global prMagGetter
.type MagGetter, %function

@ r0 = unit*; returns Mag in r0 (signed)
MagGetter:
prMagGetter:
	push	{lr}
	mov		r1, #0x47
	ldsb	r0, [r0, r1]
	pop		{r1}
	bx		r1
