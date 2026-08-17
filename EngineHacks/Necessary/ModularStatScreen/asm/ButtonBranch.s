.thumb
.org 0x0

@ Hooked from 080813EE (FE8: 08088896) after R|Select key mask matches.
@ r0 = NewPresses & 0x104. R bit (0x100) → help text; else Select → toggle growths.

mov		r1,#0x80
lsl		r1,r1,#0x1
tst		r0,r1
beq		SelectButton
ldr		r0,Func1
mov		r14,r0
mov		r0,r5
mov		r1,#0x0
.short	0xF800
ldr		r0,StatScreenStruct
ldr		r1,ReturnRButton
bx		r1
SelectButton:
ldr		r1,StatScreenStruct
ldrb	r0,[r1]
cmp		r0,#0x0				@stat screen page 1
bne		NotStatScreen
ldr		r2,[r1,#0xC]
ldrb	r2,[r2,#0xB]
mov		r3,#0xC0
tst		r2,r3
bne		NotStatScreen
sub		r1,#0x2
mov		r3,#0x1
strb	r3,[r1]
ldrb	r2,[r1,#0x1]
mov		r3,#0x1
eor		r2,r3
strb	r2,[r1,#0x1]
ldr		r1,Func2
mov		r14,r1
.short	0xF800
NotStatScreen:
@ FE7 key handler pushes {r4,r5,r6,lr} only (no local stack frame).
pop		{r4-r6}
pop		{r0}
bx		r0

.align
Func1:
.long 0x08004720			@ Goto6CLabel (FE8: 0x08002F24)
Func2:
.long 0x080804C8			@ redraw current stat page (FE8: 0x080878CC)
StatScreenStruct:
.long 0x0200310C			@ FE8: 0x02003BFC
ReturnRButton:
.long 0x080813F8+1			@ FE8: 0x080888A0+1
