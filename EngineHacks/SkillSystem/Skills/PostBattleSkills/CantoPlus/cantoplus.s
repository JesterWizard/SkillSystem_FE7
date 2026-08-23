.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ CantoPlusID, SkillTester+4
.thumb
push	{lr}
@check if dead
ldrb	r0, [r4,#0x13]
cmp	r0, #0x00
beq	End

@check if moved all the squares
mov     r0, r4
blh     0x8018B44
ldrb    r1, [r6,#0x10]  @squares moved this turn
cmp	r0, r1
beq	End

@check if flag 0x3 set; if so, cannot canto
mov r0,#3
blh 0x80798F8
cmp r0,#1
beq End

blh 0x8019868           @UpdateUnitMapAndVision
@ Do not call 0x80180EC (UnitBeginAction). FE8's "can move again" was misported.

@check if attacked this turn
ldrb  r0, [r6,#0x11]    @action taken this turn
cmp r0, #0x1E           @found enemy in the fog
beq End
cmp r0, #0x1            @wait or none
ble End
ldrb  r0, [r6,#0x0C]    @allegiance byte of the current character taking action
ldrb  r1, [r4,#0x0B]    @allegiance byte of the character we are checking
cmp r0, r1              @check if same character
bne End

@check if already cantoing/pending, and is not in a ballista
ldr     r0, [r4,#0x0C]  @status bitfield
ldr	r1, =0x00008840   @US_CANTO_PENDING | US_HAS_MOVED | US_IN_BALLISTA
and	r0, r1
cmp	r0, #0x00
bne	End

@check for skill
mov	r0, r4
ldr	r1, CantoPlusID
ldr	r3, SkillTester
mov	lr, r3
.short	0xf800
cmp	r0,#0x00
beq	End

@ Flag the re-move for TryMakeCantoUnit (US_CANTO_PENDING, FE8's unused
@ US_BIT15). Setting US_HAS_MOVED here is what made an already-cantoed unit
@ look eligible for another canto, and clearing US_UNSELECTABLE here left the
@ unit selectable again whenever the canto was afterwards refused. The vanilla
@ code at 0x0801CC04 does both, once, when the canto really starts.
ldr     r0, [r4,#0x0C]  @status bitfield
mov	r1, #0x80
lsl	r1, #0x08
orr	r0, r1
str	r0, [r4,#0x0C]

End:
pop	{r0}
bx	r0
.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD CantoPlusID
