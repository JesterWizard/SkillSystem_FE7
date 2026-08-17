.thumb
.align

.global ScrollDurabilityGetter
.type ScrollDurabilityGetter, %function

.global ScrollDurabilityGetter_StatScreen
.type ScrollDurabilityGetter_StatScreen, %function

.global ScrollDurabilityGetter_MenuA
.type ScrollDurabilityGetter_MenuA, %function

.global ScrollDurabilityGetter_MenuB
.type ScrollDurabilityGetter_MenuB, %function


@ FE7 GetItemUses 0x08017294; full replace (hook must be 4-byte aligned).
@ r0 = item halfword. Does not push lr.
ScrollDurabilityGetter:
mov r2,r0
mov r1,#0xFF
and r1,r2
lsl r0,r1,#3
add r0,r0,r1
lsl r0,r0,#2
ldr r1,=ItemTable
add r0,r0,r1
ldr r0,[r0,#8]
mov r1,#8
and r0,r1
cmp r0,#0
bne RetUnbreakable

mov r0,r2
mov r1,#0xFF
and r0,r1

ldr r3,=DurabilityItemList

DurabilityLoop1Start:
ldrb r1,[r3]
cmp r1,#0
beq RetActualDurability
cmp r0,r1
beq DurabilityLoop1Succeed
add r3,#1
b DurabilityLoop1Start

DurabilityLoop1Succeed:
mov r0,#1
b GoBack

RetActualDurability:
asr r0,r2,#8
b GoBack

.ltorg
.align


RetUnbreakable:
mov r0,#0xFF

GoBack:
bx lr

.ltorg
.align


@ r0 = item id. Z clear if on DurabilityItemList, Z set if not.
IsDurabilityItem:
	ldr r1, =DurabilityItemList
IsDurabilityLoop:
	ldrb r2, [r1]
	cmp r2, #0
	beq IsDurabilityNo
	cmp r2, r0
	beq IsDurabilityYes
	add r1, #1
	b IsDurabilityLoop
IsDurabilityYes:
	mov r1, #1
	cmp r1, #0
	bx lr
IsDurabilityNo:
	mov r1, #0
	cmp r1, #0
	bx lr

.ltorg
.align


@-----------------------------------------------------------------------------
@ DrawItemOnStatscreen @ 0x080166B0
@ jumpToHack overwrites 166B0..166B7; resume vanilla at 166B8 (slash draw).
@ Skill scrolls skip '/' + both use numbers → 166FE.
@-----------------------------------------------------------------------------
.equ StatScreenAfterUses,0x80166FF
.equ StatScreenResume,0x80166B9

ScrollDurabilityGetter_StatScreen:
	mov r0, r9
	mov r1, #0xFF
	and r0, r1
	bl IsDurabilityItem
	beq StatScreenVanilla
	ldr r3, =StatScreenAfterUses
	bx r3

StatScreenVanilla:
	cmp r6, #1
	bne StatScreenResumeSlash
	mov r4, #1
StatScreenResumeSlash:
	mov r0, r7
	ldr r3, =StatScreenResume @ add r0, #0x18; mov r1,r4; mov r2,#0x16; bl
	bx r3

.ltorg
.align


@-----------------------------------------------------------------------------
@ DrawItemMenuLine (Menu A) @ 0x080164C8
@ Overwrites 164C8..164CF; resume at 164D0.
@-----------------------------------------------------------------------------
.equ MenuAAfterUses,0x80164E9
.equ MenuAResume,0x80164D1

ScrollDurabilityGetter_MenuA:
	mov r0, r8
	mov r1, #0xFF
	and r0, r1
	bl IsDurabilityItem
	beq MenuAVanilla
	ldr r3, =MenuAAfterUses
	bx r3

MenuAVanilla:
	@ overwritten: mov r0,r8; cmp r0,#0; beq +2; mov r5,#2
	mov r0, r8
	cmp r0, #0
	beq MenuAResumeUses
	mov r5, #2
MenuAResumeUses:
	ldr r3, =MenuAResume @ ldr r0, [r4, #8]; ...
	bx r3

.ltorg
.align


@-----------------------------------------------------------------------------
@ DrawItemMenuLineLong (Menu B) @ 0x08016570
@ Overwrites 16570..16577; resume at 16578.
@ Before hook: r0=[itemData+8], r4=#8 (from 1656C/1656E).
@-----------------------------------------------------------------------------
.equ MenuBAfterUses,0x80165B5
.equ MenuBResume,0x8016579

ScrollDurabilityGetter_MenuB:
	mov r0, r8
	mov r1, #0xFF
	and r0, r1
	bl IsDurabilityItem
	beq MenuBVanilla
	ldr r3, =MenuBAfterUses
	bx r3

MenuBVanilla:
	@ overwritten: and r0,r4; mov r3,r8; asr r2,r3,#8; cmp r0,#0
	ldr r0, [r5, #8]
	mov r4, #8
	and r0, r4
	mov r3, r8
	asr r2, r3, #8
	cmp r0, #0
	beq MenuBResumeUses
	mov r2, #0xFF
MenuBResumeUses:
	ldr r3, =MenuBResume @ mov r0, r12/r4...; bl DrawNumber
	bx r3

.ltorg
.align
