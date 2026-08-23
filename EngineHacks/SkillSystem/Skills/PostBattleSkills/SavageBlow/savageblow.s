.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ SavageBlowID, SkillTester+4
.equ GetUnitsInRange, SavageBlowID+4
.thumb
push	{r4-r7,lr}
@check if dead
ldrb	r0, [r4,#0x13]
cmp	r0, #0x00
beq	End

@check if attacked this turn
ldrb    r0, [r6,#0x11]          @action taken this turn
cmp     r0, #0x2                @attack
bne	End
ldrb    r0, [r6,#0x0C]          @allegiance byte of the current character taking action
ldrb    r1, [r4,#0x0B]          @allegiance byte of the character we are checking
cmp     r0, r1                  @check if same character
bne	End

@check for skill
mov	r0, r4
ldr	r1, SavageBlowID
ldr	r3, SkillTester
mov	lr, r3
.short	0xf800
cmp	r0,#0x00
beq	End

@enemies in 2 spaces
ldr	r0, GetUnitsInRange
mov	lr, r0
mov     r0, r4                  @attacker
mov     r1, #0x03               @are_enemies
mov     r2, #0x02               @range
.short	0xf800
cmp	r0, #0x00
beq	End

mov     r5, r0
mov     r6, #0x00

Savage_loop:
ldrb	r0, [r5,r6]
cmp	r0, #0x00
beq	End
ldr	r2,=#0x8018d0c
mov	lr, r2
.short	0xf800
mov	r7, r0
ldrb    r0, [r7,#0x12]          @max hp
mov	r1, r0
mov	r0, #0x00
Div5:
cmp	r1, #0x05
blt	Div5Done
sub	r1, #0x05
add	r0, #0x01
b	Div5
Div5Done:
ldrb    r1, [r7,#0x13]
cmp	r1, #0x00
beq	NextLoop
sub	r1, r0
cmp	r1, #0x00
bgt	StoreHP
mov     r1, #0x01
StoreHP:
strb	r1, [r7,#0x13]
NextLoop:
add	r6, #0x01
b	Savage_loop

End:
pop	{r4-r7}
pop	{r0}
bx	r0
.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD SavageBlowID
@POIN GetUnitsInRange
