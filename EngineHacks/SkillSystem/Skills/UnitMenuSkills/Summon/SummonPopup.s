.thumb
.align

@ ============================================================================
@ "Summoned a <class>" instead of "Stole a <item>"
@
@ The summon awards its exp through ActionSteal's tail, so it runs the map
@ battle sequence (proc 0x08C9D50C).  That sequence's tail script 0x08C9D6DC
@ calls 0x0806E2FC, which is
@
@     if (*(u8*)0x0203E15E == 1)
@         PopupStoleItem(*(u16*)(*(u32*)0x0203E114 + 0x48), proc);
@
@ StartMapBattleSequence (0x0806F0DC) forces 0x0203E15E to 1, so the steal
@ popup always fires -- naming whatever gBattleTarget's weapon is, which for a
@ summon is the dragon's own Flametongue.
@
@ This replaces that routine.  When the action being applied is the summon it
@ raises our own popup; for anything else it does exactly what vanilla did, so
@ Matthew still says "Stole a ...".
@
@ Popup definitions are (opcode, argument) word pairs terminated by 0, walked
@ by 0x0800A7E4 (measure) and 0x0800A918 (draw).  The opcodes used here:
@
@   0x0C  proc[0x48] = arg      -- the popup's sound, no glyphs
@   0x08  segment marker
@   0x06  draw GetStringFromIndex(arg)   -- a literal text id
@   0x01  advance arg pixels
@   0x00  end
@
@ Two text ids are needed and both come from UnitMenuSkills.event: the phrase
@ itself, and the summoned class's name.  A class's name id is ClassTable +
@ 0x54*id + 0x00, so it is fixed per class, not per unit -- there is no popup
@ opcode that resolves a class name at runtime (0x05 resolves a CHARACTER name
@ only).  SUMMON_CLASS_NAME_TEXT therefore has to track SUMMON_CLASS_ID, and
@ Tests/test_summon_popup_and_class_card.py fails the build if they disagree.
@ ============================================================================

.equ gActionData,      0x0203A85C
.equ MapBattleConfig,  0x0203E0FC
.equ PopupStoleItem,   0x0800EEF5  @ r0 = item id, r1 = parent proc
.equ NewPopupSimple,   0x0800AD41  @ r0 = definition, r1, r2, r3 = parent proc
.equ SummonActionID,   0x05

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.global SummonPopupHook
.type   SummonPopupHook, %function
.global SummonPopupLinks

SummonPopupHook:
	push {r4,lr}
	mov r4,r0                   @ the map battle proc; the popup blocks on it

	ldr r0,=gActionData
	ldrb r0,[r0,#0x11]
	cmp r0,#SummonActionID
	beq SummonPopupHook_Summon

	@ --- vanilla 0x0806E2FC, unchanged --------------------------------------
	ldr r0,=MapBattleConfig
	mov r1,#0x62
	ldrb r1,[r0,r1]
	cmp r1,#1
	bne SummonPopupHook_Ret
	ldr r0,[r0,#0x18]           @ the battle unit the sequence acted on
	mov r1,#0x48
	ldrh r0,[r0,r1]             @ its weapon
	mov r1,r4
	blh PopupStoleItem
	b SummonPopupHook_Ret

SummonPopupHook_Summon:
	ldr r0,=SummonPopupLinks
	ldr r0,[r0,#0]              @ the "Summoned a <class>" definition
	mov r1,#0x60
	mov r2,#0
	mov r3,r4
	blh NewPopupSimple, r4      @ r3 is an argument, so scratch in r4

SummonPopupHook_Ret:
	pop {r4}
	pop {r0}
	bx r0

.align 4
.ltorg

@ Filled in by UnitMenuSkills.event:
@ POIN SummonPopupDef
SummonPopupLinks:
