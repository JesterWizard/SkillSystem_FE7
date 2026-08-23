.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ CantoID, SkillTester+4
.equ Option, CantoID+4
.equ CurrentUnit, 0x03004690
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

blh 0x8019868           //FE8 -> 0x801A1F5 @UpdateUnitMapAndVision
@ Do not call 0x80180EC (UnitBeginAction). FE8's "can move again" was misported.

@ Canto: remaining move after staff (0x03) or item use.
@ FE7 self-heal (Vulnerary/Elixir/...) writes 0x17 at 0x08027674; that is
@ the ApplyUnitAction slot that actually runs ActionStaffDoorChestUseItem.
@ 0x1A is the targeted-item setter at 0x08021E88 (unused apply stub).
ldrb  r0, [r6,#0x11]    @action taken this turn
cmp r0, #0x1E           @check if found enemy in the fog
beq End
cmp r0, #0x03           @ staff
beq ActionOk
cmp r0, #0x17           @ self-use item (vulnerary)
beq ActionOk
cmp r0, #0x1A           @ targeted item
beq ActionOk
b End
ActionOk:
@ Confirm the unit we were handed really is the one that just acted.
@ This used to compare ActionData.subjectIndex (+0x0C) against Unit.index,
@ but the item-use action setter at 0x08021E88 writes only unitActionType
@ (+0x11) and leaves subjectIndex holding whatever the previous action left
@ there. After a self-targeted vulnerary that stale index rarely matched, so
@ Canto bailed here -- while staff use (0x03), whose setup does refresh the
@ field, worked. gActiveUnit is maintained on every action path, so compare
@ against that pointer instead of a field the item path never updates.
ldr   r0, =CurrentUnit
ldr   r0, [r0]
cmp   r0, r4
bne   End

@check if already cantoing/pending, and is not in a ballista
ldr     r0, [r4,#0x0C]  @status bitfield
ldr	r1, =0x00008840   @US_CANTO_PENDING | US_HAS_MOVED | US_IN_BALLISTA
and	r0, r1
cmp	r0, #0x00
bne	End

@check for option and ability
ldr	r0,Option
cmp	r0,#0
beq	HasSkill
ldr     r0,[r4]         @load character data
cmp     r0,#0x00        @just in case there's no pointer (was doing weird things with generics without this)
beq	JumpLoad1
ldr     r0,[r0,#0x28]   @load character abilities
JumpLoad1:
ldr     r1,[r4,#0x04]   @load class data
cmp     r1,#0x00        @just in case there's no pointer
beq	JumpLoad2
ldr     r1,[r1,#0x28]   @load class abilities
JumpLoad2:
orr	r0,r1
mov     r1,#2           @canto bit
and	r0,r1
cmp	r0,#2
beq     CanCanto        @if the option is set and has the ability, skip skill check


@check for skill
HasSkill:
mov	r0, r4
ldr	r1, CantoID
ldr	r3, SkillTester
mov	lr, r3
.short	0xf800
cmp	r0,#0x00
beq	End

CanCanto:
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

@ @add unit to the AI list so enemies act twice
@ ldr	r0,=#0x203AA03
@ ldrb	r1, [r4,#0x0B]	@allegiance byte of the character we are checking
@ AddAILoop:
@ add	r0, #0x01
@ ldrb	r2, [r0]
@ cmp	r2, #0x00
@ bne	AddAILoop
@ strb	r1, [r0]
@ add	r0, #0x01
@ strb	r2, [r0]

End:
pop	{r0}
bx	r0
.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD CantoID
@WORD Option
