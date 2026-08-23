@ Hooked at FE7 0x0801CBA0 (TryMakeCantoUnit) with jumpToHack.
@ Incoming: r2 = gActiveUnit, r5 = &gActiveUnit (0x03004690), r6 = the proc.
@ r5/r6/r7 must survive; r0-r4 are free (vanilla clobbers r4 at 0x0801CBBC).
@
@ Vanilla decided canto from the class/character CA_CANTO ability alone. Here
@ the post-combat loop (canto.s, cantoplus.s, Gridmaster.s) has already applied
@ each skill's own action rules and, when the skill grants a re-move, set
@ US_CANTO_PENDING (0x8000 -- FE8's unused US_BIT15) on the unit.
@
@ So this routine only:
@   1. consumes that pending bit, so one action can never grant two cantos,
@   2. re-applies the vanilla US_DEAD | US_HAS_MOVED | US_HAS_MOVED_AI guard.
@      The old port nopped that guard out (0x1CBB6) and then treated an
@      already-set US_HAS_MOVED as *permission* to canto, so a unit that had
@      finished its canto move was handed another one every time it waited.
@   3. falls through to the leftover-movement check at 0x0801CBCA, which needs
@      r2 = gActiveUnit and r4 = gActionData.
@
@ US_HAS_MOVED / US_UNSELECTABLE are left to the vanilla code at 0x0801CC04
@ (CheckGaleforce), which runs only once the canto has actually been granted.
.equ UNIT_STATE,       0x0C
.equ ActionStruct,     0x0203A85C
.equ CantoResume,      0x0801CBCB   @ leftover-movement check (thumb)
.equ CantoFail,        0x0801CBE5   @ "return 0" (thumb)
.thumb

ldr	r2, [r5]

@ read the pending bit and consume it in the same breath
ldr	r0, [r2, #UNIT_STATE]
ldr	r1, =0x00008000		@ US_CANTO_PENDING
mov	r4, r0
and	r4, r1
bic	r0, r1
str	r0, [r2, #UNIT_STATE]

@ dead / already cantoed / turn already ended
ldr	r1, =0x00010044
and	r0, r1
cmp	r0, #0x00
bne	Fail

cmp	r4, #0x00
bne	Ok

@ Legacy path: the vanilla class/character Canto ability, only when
@ ENABLE_LEGACY_CANTO says both systems apply.
ldr	r0, Option
cmp	r0, #0x00
beq	Fail
ldr	r0, [r2]
cmp	r0, #0x00
beq	NoCharAbility
ldr	r0, [r0, #0x28]
NoCharAbility:
ldr	r1, [r2, #0x04]
cmp	r1, #0x00
beq	NoClassAbility
ldr	r1, [r1, #0x28]
NoClassAbility:
orr	r0, r1
mov	r1, #0x02		@ CA_CANTO
and	r0, r1
cmp	r0, #0x02
bne	Fail

@ vanilla rule for the ability: no canto after combat (0x02) or a staff (0x03)
ldr	r1, =ActionStruct
ldrb	r0, [r1, #0x11]
sub	r0, #0x02
lsl	r0, r0, #24
lsr	r0, r0, #24
cmp	r0, #0x01
bls	Fail

Ok:
ldr	r4, =ActionStruct	@ 0x0801CBD0 reads [r4,#0x10], squares moved
ldr	r0, =CantoResume
bx	r0

Fail:
ldr	r0, =CantoFail
bx	r0

.align
.ltorg
.align
Option:
@WORD ENABLE_LEGACY_CANTO
