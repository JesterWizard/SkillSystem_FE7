.thumb
.set ActiveUnit,                   0x03004690
.equ StatScreenStruct,             0x0200310C

.macro _blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.macro _blx to, reg=r3
ldr 	\reg, =\to
bl 	Jumpr3
.endm

.set Item_GetMaxRange, 0x8017384
.set Item_GetMinRange, 0x801736C
.equ GetRangeText, OffsetList + 0x0
.equ RangeText, OffsetList + 0x4

@r0 has item id/uses short
push	{r4-r5,r14}
mov 	r5, r0
_blh Item_GetMinRange
mov 	r4, r0
mov 	r0, r5
_blh Item_GetMaxRange
mov 	r5, r0
mov 	r1, r4
@ldr 	r3, GetRangeText
@bl 	Jumpr3
bl 	RangeTextGetter
cmp 	r0, #0x0
beq RangeInNumbers
_blh 	#0x8012C60
b End
RangeInNumbers:
mov 	r0, r5
mov 	r1, r4
@ldr 	r3, RangeText
ldr 	r3, =MakeRangeText+1
bl 	Jumpr3
End:
pop 	{r4-r5}
pop 	{r3}
Jumpr3:
bx	r3
.align
.ltorg
OffsetList:
