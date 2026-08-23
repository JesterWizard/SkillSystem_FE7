.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ DespoilID, SkillTester+4
.equ DespoilPopupProc, DespoilID+4
.equ DespoilPopup, DespoilPopupProc+4
.equ RedGem, 0x75
@ FE7 routines the popup needs. GetItemMaxUses reads the item table rather than
@ assuming 1, so an edited Red Gem still lands in the inventory at full uses.
.equ GetItemMaxUses, 0x080172BC
.equ SetPopupUnit,   0x0800AD1C
.equ SetPopupItem,   0x0800AD28
.equ NewPopupSimple, 0x0800AD40
.equ ProcStartBlocking, 0x080044F8
.equ EndPlayerPhaseSideWindows, 0x08085C7C
.equ PopupFrames,    0x60
@ asm/ram_map_ewram.s :: gPostCombatProc / gPostCombatYield -- parked by post_loop.s
.equ PostCombatProc, 0x0203FE0C
.equ PostCombatYield, 0x0203FE08
.thumb
.global CallDespoilPopup
@ post_loop.s hands every skill r4 = unit, r5 = defender, r6 = gActionData and
@ keeps its own skill-list cursor in r7, so r4-r7 have to come back unchanged.
push	{r4-r7, lr}

@check if dead
ldrb	r0, [r4,#0x13]
cmp	r0, #0x00
beq	End

@check if attacked this turn
ldrb    r0, [r6,#0x11]      @action taken this turn
cmp     r0, #0x2            @attack
bne	End
ldrb    r0, [r6,#0x0C]      @allegiance byte of the current character taking action
ldrb    r1, [r4,#0x0B]      @allegiance byte of the character we are checking
cmp     r0, r1              @check if same character
bne	End

@check if killed enemy
ldrb    r0, [r5,#0x13]      @currhp
cmp	r0, #0
bne	End

@check for skill
mov	r0, r4
ldr	r1, DespoilID
ldr	r3, SkillTester
mov	lr, r3
.short	0xf800
cmp	r0, #0x00
beq	End

@killed enemy, roll luck
ldr     r0,=#0x8018BB8      @luck getter
mov	lr, r0
mov     r0, r4              @attacker
.short	0xF800
ldr     r2,=#0x802857C      @1rn routine
mov     r1, r4              @attacker
mov	lr, r2
.short	0xF800
cmp	r0, #0x01
bne	End

@give Red Gem to first empty inventory slot
mov	r1, r4
add	r1, #0x1E
mov	r2, #0x00
FindSlot:
ldrh	r0, [r1]
cmp	r0, #0x00
beq	StoreGem
add	r1, #0x02
add	r2, #0x01
cmp	r2, #0x05
bge	End
b	FindSlot
StoreGem:
mov	r7, r1			@ the free slot

@ An item halfword is id | (uses << 8). Storing the bare id gave a Red Gem
@ with 0 uses, which the inventory draws as 0/1.
mov	r0, #RedGem
blh	GetItemMaxUses
lsl	r0, r0, #0x08
mov	r1, #RedGem
orr	r0, r1
strh	r0, [r7]
mov	r7, r0			@ keep the full halfword for the popup icon

@ "<unit> obtained a <item>"
mov	r0, r4
blh	SetPopupUnit
mov	r0, r7
blh	SetPopupItem
@ NewPopupSimple(parent=PlayerPhase) still lets CALL_2 (opcode 0x16) run the
@ next PlayerPhase commands this frame — lockCnt is only checked on entry —
@ so the terrain window comes back under the popup. Skill-scroll style: a
@ blocking wrapper whose CALL_2 starts the popup as *its* child and returns 0,
@ plus PostCombatYield so post_loop returns 0 and PlayerPhase yields too.
@ 0x08073324 is class-change VRAM, not EndPlayerPhaseSideWindows.
ldr	r0, =PostCombatProc
ldr	r1, [r0]
cmp	r1, #0x00
beq	End
mov	r2, #0x01
ldr	r3, =PostCombatYield
strb	r2, [r3]
push	{r1}
blh	EndPlayerPhaseSideWindows
pop	{r1}
ldr	r0, DespoilPopupProc
blh	ProcStartBlocking

End:
pop	{r4-r7}
pop	{r0}
bx	r0

@ r0 = DespoilPopupProc. CreatePopup as a blocking child of self, return 0
@ so CALL_2 yields; the wrapper holds lockCnt until the popup ends.
CallDespoilPopup:
push	{r4, lr}
mov	r4, r0
blh	EndPlayerPhaseSideWindows
ldr	r0, DespoilPopup
mov	r1, #PopupFrames
mov	r2, #0x00
mov	r3, r4
blh	NewPopupSimple, r5
mov	r0, #0x00
CallDespoilPopupDone:
pop	{r4}
pop	{r1}
bx	r1
.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD DespoilID
@POIN DespoilPopupProc
@POIN DespoilPopup
