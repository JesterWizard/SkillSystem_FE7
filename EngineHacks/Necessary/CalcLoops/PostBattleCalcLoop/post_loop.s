@called at 08034524 (FE7: GetUnitCurrentHP then post-action traps)
@ Wait from the unit menu hits this. Auto-wait after move does not.
@ Vanilla here is only GetUnitCurrentHP(gActiveUnit). Do not call FE8 SMS update.
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ GetCharPtr, 0x08018D0C
.equ ActionStruct, 0x0203A85C
.equ Defender, 0x203A470
.equ CurrentUnit, 0x3004690
.equ UNIT_ACTION_COMBAT, 0x02
.thumb
mov r5, r0
ldr r4, =CurrentUnit
push	{r4-r7, lr}

ldr	r4, =CurrentUnit
ldr	r4, [r4]
cmp	r4, #0x00
beq	End

@ Wait from the menu hits this hook; auto-wait after move does not.
@ Gray the unit so a lone actor still ends the phase.
ldr	r0, [r4,#0x0C]
mov	r1, #0x02
orr	r0, r1
str	r0, [r4,#0x0C]

ldr	r6, =ActionStruct
ldrb	r0, [r6,#0x11]	@ unitActionType
cmp	r0, #UNIT_ACTION_COMBAT
bne	End

ldrb	r0, [r4,#0x0B]
blh	GetCharPtr
mov	r4, r0
cmp	r4, #0x00
beq	End
ldr	r5, =Defender
ldrb	r0, [r5,#0x0B]
cmp	r0, #0x00
beq	End
blh	GetCharPtr
mov	r5, r0
cmp	r5, #0x00
beq	End
ldr	r7, =PostCombatSkills

Loop:
ldr	r3, [r7]
cmp	r3, #0x00
beq	End
mov	lr, r3
mov r0, r4
mov r1, r5
.short	0xf800
add	r7, #0x04
b	Loop
End:
ldr	r0,=#0x203A3D8
mov	r1,#0
strb	r1,[r0]
pop	{r4-r7}
pop {r3}
ldr r0, [r4]
blh 0x8018A70 @GetUnitCurrentHP
ldr r1, =0x803452D
bx r1

.ltorg
.align
