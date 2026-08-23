.thumb
push	{lr}

@ r5 = &gActiveUnit (FE7 TryMakeCantoUnit). Vanilla at 1CC04:
@   state |= 0x40 (cantoing); state &= ~0x02 (selectable).
@ Do not default to Galeforce: that skipped 0x40, so 1C4D0 drew
@ attack range (red/green) and never entered the blue path-arrow state.
ldr	r2, [r5]
ldr	r0, [r2, #0x0C]
mov	r1, #0x80
lsl	r1, r1, #3		@ 0x400 galeforce pending
and	r1, r0
cmp	r1, #0
bne	Galeforce

Canto:
ldr	r2, [r5]
ldr	r0, [r2, #0x0C]
mov	r1, #0x40
orr	r0, r1
mov	r1, #0x02
mvn	r1, r1
and	r0, r1
b	End

Galeforce:
ldr	r2, =#0x203A85C
mov	r0, #0x00
strb	r0, [r2, #0x10]
ldr	r2, [r5]
ldr	r0, [r2, #0x0C]
mov	r1, #0x04
lsl	r1, r1, #0x08
orr	r0, r1
mov	r1, #0x02
mvn	r1, r1
and	r0, r1

End:
str	r0, [r2, #0x0C]
pop	{r0}
mov	lr, r0
ldr	r0, =#0x801CC12
mov	pc, r0
Returned:
bx	lr
.align
.ltorg
