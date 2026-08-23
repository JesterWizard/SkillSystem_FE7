@ Lunge -- after the unit wins a fight it trades places with its target.
@
@ Hooked at FE7 0x080181D4 with jumpToHack. 0x080181D0 is the routine that
@ commits gActiveUnit's moved-to tile; the post-action proc calls it at
@ 0x0801CCCE once the action (and therefore the fight) is over, which is the
@ only moment where both tiles are still known and nothing has been drawn yet.
@
@ jumpToHack overwrites 0x181D4-0x181DB -- the two coordinate stores -- and
@ costs r3, so this routine writes the coordinates itself (swapped or not) and
@ returns to 0x080181DC with r3 restored to &gActiveUnit, which the rest of
@ the vanilla routine still reads.
@
@ The old port hooked 0x18744. In FE7 that is the middle of IsPosMagicSealed
@ (an FE8 address that was never re-derived), so Lunge never ran at all and
@ the magic-seal scan was being corrupted. It also keyed off the unit-menu
@ marker at 0x0203F101, but UnitMenuSkills is not installed in this port, so
@ the marker was never set; the skill itself is the trigger now.
@
@ Incoming: r0 = moved-to x, r1 = moved-to y, r3 = &gActiveUnit (clobbered).
.equ ActionStruct,   0x0203A85C
.equ gActiveUnitPtr, 0x03004690
.equ GetUnitStruct,  0x08018D0C
.equ GetUnitByCharId,0x08017D34
.equ gBmMapTerrain,  0x0202E3E0
.equ Resume,         0x080181DD   @ thumb, back into the vanilla routine
.equ LungeID, SkillTester+4
.thumb
push	{r4-r7, lr}
mov	r4, r0			@ moved-to x
mov	r7, r1			@ moved-to y
ldr	r5, =ActionStruct
ldr	r6, =gActiveUnitPtr

ldrb	r2, [r5,#0x11]		@ action taken this turn
cmp	r2, #0x02		@ combat
bne	NotLunge
ldrb	r2, [r5,#0x0D]		@ target's allegiance byte; 0 means wall/snag
cmp	r2, #0x00
beq	NotLunge

ldr	r2, [r6]
ldrb	r2, [r2,#0x13]		@ did the attacker survive?
cmp	r2, #0x00
beq	NotLunge

@ does the attacker have Lunge?
ldr	r0, [r6]
ldr	r1, LungeID
ldr	r3, SkillTester
mov	lr, r3
.short	0xf800
cmp	r0, #0x00
beq	NotLunge

ldrb	r0, [r5,#0x0D]
ldr	r3, =GetUnitStruct
mov	lr, r3
.short	0xf800			@ r0 = the target's unit struct
cmp	r0, #0x00
beq	NotLunge
ldrb	r2, [r0,#0x13]		@ nothing to swap with if the target died
cmp	r2, #0x00
beq	NotLunge

@ immovable target (AI byte 4 == 0x20, "guard this tile")
mov	r2, #0x41
ldrb	r2, [r0,r2]
cmp	r2, #0x20
beq	NotLunge

@ can the attacker even stand on the target's tile?
mov	r3, r0
ldrb	r0, [r3,#0x10]
ldrb	r1, [r3,#0x11]
ldr	r2, =gBmMapTerrain
ldr	r2, [r2]		@ table of row pointers
lsl	r1, #0x02
add	r2, r1
ldr	r2, [r2]		@ start of the target's row
add	r2, r0
ldrb	r0, [r2]		@ terrain id under the target
ldr	r1, [r6]
ldr	r1, [r1,#0x04]		@ attacker's class
ldr	r1, [r1,#0x38]		@ clear-weather movement costs
add	r1, r0
ldrb	r0, [r1]
cmp	r0, #0xFF		@ impassable in clear weather, so impassable
beq	NotLunge

@ swap the two units' coordinates
mov	r0, r3
ldr	r2, [r6]
ldrb	r1, [r0,#0x10]
strb	r1, [r2,#0x10]
ldrb	r1, [r0,#0x11]
strb	r1, [r2,#0x11]
ldrb	r1, [r5,#0x0E]		@ the attacker's moved-to x
strb	r1, [r0,#0x10]
ldrb	r1, [r5,#0x0F]
strb	r1, [r0,#0x11]

@ drag whoever the target is rescuing along with them
ldrb	r0, [r0,#0x1B]
cmp	r0, #0x00
beq	GoBack
ldr	r1, =GetUnitByCharId
mov	lr, r1
.short	0xf800
cmp	r0, #0x00
beq	GoBack
ldrb	r1, [r5,#0x0E]
strb	r1, [r0,#0x10]
ldrb	r1, [r5,#0x0F]
strb	r1, [r0,#0x11]
b	GoBack

NotLunge:
ldr	r2, [r6]
strb	r4, [r2,#0x10]
strb	r7, [r2,#0x11]

GoBack:
mov	r3, r6			@ the vanilla tail still reads &gActiveUnit
pop	{r4-r7}
pop	{r0}
mov	lr, r0
ldr	r0, =Resume
bx	r0

.align
.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD LungeID
