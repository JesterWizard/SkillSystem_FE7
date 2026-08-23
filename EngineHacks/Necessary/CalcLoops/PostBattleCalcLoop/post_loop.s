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
@ asm/ram_map_ewram.s :: gPostCombatProc / gPostCombatYield
.equ PostCombatProc, 0x0203FE0C
.equ PostCombatYield, 0x0203FE08
.equ UNIT_ACTION_WAIT, 0x01
.equ UNIT_ACTION_COMBAT, 0x02
.thumb
mov r5, r0
ldr r4, =CurrentUnit
push	{r4-r7, lr}

@ r5 still holds the proc HandlePostActionTraps was called with. A skill that
@ wants to block the game on a popup needs it as the popup's parent, and
@ nothing further down keeps r5, so park it before it is reused.
ldr	r4, =PostCombatProc
str	r5, [r4]

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
cmp	r0, #0x00
beq	End
cmp	r0, #UNIT_ACTION_WAIT
beq	End

@ r4 must stay the *unit* pointer: every post-combat skill reads the actor
@ through it (curHP +0x13, state +0x0C, index +0x0B) and canto.s/cantoplus.s/
@ Gridmaster.s write US_CANTO_PENDING back to [r4,#0x0C]. Converting it with
@ GetCharPtr pointed those reads and that write at ROM character data, so the
@ pending bit never reached the unit and TryMakeCantoUnit always refused the
@ re-move -- most visibly after healing yourself with a vulnerary.
cmp	r4, #0x00
beq	End

@ Self-heal / items have no defender. Combat-only skills check action themselves.
@ r5 stays the defender *unit* (galeforce.s reads curHP at [r5,#0x13]); it is
@ left null for any non-combat action, which is what a vulnerary produces.
mov	r5, #0x00
ldrb	r0, [r6,#0x11]
cmp	r0, #UNIT_ACTION_COMBAT
bne	RunSkills
ldr	r0, =Defender
ldrb	r1, [r0,#0x0B]
cmp	r1, #0x00
beq	RunSkills
mov	r5, r0

RunSkills:
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

@ Drop the parked proc. It is only valid for the callback that is running now;
@ leaving it behind would let a later skill parent a blocking popup onto a
@ proc that no longer exists.
@ Yield: FE7 opcode 0x16 already advanced past this CALL_2. Returning 0 stops
@ the rest of PlayerPhase this frame (terrain/goal windows). lockCnt from the
@ blocking wrapper then skips PlayerPhase until the popup ends; the next
@ command is the HUD restore, not a second run of this hook.
ldr	r0, =PostCombatYield
ldrb	r1, [r0]
mov	r2, #0
strb	r2, [r0]
ldr	r0, =PostCombatProc
str	r2, [r0]
pop	{r4-r7}
pop {r3}
cmp	r1, #0
beq	ResumeTraps
@ jumpToHack is `ldr r3; bx r3` and does not touch lr. Vanilla already
@ pushed {r4, r5, lr} at 08034520. Returning 0 without popping that
@ frame leaves CALL_2 to bx leftover r4 as if it were lr.
pop	{r4, r5}
pop	{r3}
mov	r0, #0
bx	r3
ResumeTraps:
ldr r0, [r4]
blh 0x8018A70 @GetUnitCurrentHP
ldr r1, =0x803452D
bx r1

.ltorg
.align
