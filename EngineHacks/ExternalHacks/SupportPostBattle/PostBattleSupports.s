@ Vesly Support After Battle, ported to FE7U.
@ Support exp lives in gBwlSupportExp (unit+0x32 is learned skills).

.thumb
.align 2

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xf800
.endm

.equ GetUnit, 0x08018D0C
.equ GetCharacterData, 0x08018D38
.equ GetItemType, 0x0801725C
.equ CurrentUnit, 0x03004690
.equ gBattleActor, 0x0203A3F0
.equ gBattleTarget, 0x0203A470
.equ ActionStruct, 0x0203A85C
.equ gBwlSupportExp, 0x0203FE10
.equ gSupportAuraDisplayArray, 0x0203FDF8
.equ gSupportIndexArray, 0x0203FDF0
.equ UNIT_ACTION_COMBAT, 2
.equ UNIT_ACTION_STAFF, 3
.equ UNIT_ACTION_DANCE, 4
.equ ITEM_TYPE_STAFF, 4
.equ SUPPORT_EXP_CAP, 0xF1
.equ BWL_PID_MAX, 0x45
.equ ProcStartBlocking, 0x080044F8
.equ EndPlayerPhaseSideWindows, 0x08085C7C
.equ PostCombatProc, 0x0203FE0C
.equ PostCombatYield, 0x0203FE08

.global PostBattleSupports_Hook
.type PostBattleSupports_Hook, %function
PostBattleSupports_Hook:
	push {r4-r7, lr}
	mov r4, r0
	mov r5, r1
	cmp r5, #0
	beq PostBattleSupports_Hook.go
	ldrb r0, [r5, #0xB]
	cmp r0, #0
	beq PostBattleSupports_Hook.noTarget
	blh GetUnit
	mov r5, r0
	b PostBattleSupports_Hook.go
PostBattleSupports_Hook.noTarget:
	mov r5, #0
PostBattleSupports_Hook.go:
	ldr r6, =ActionStruct
	cmp r4, #0
	beq PostBattleSupports_Hook.end
	bl PostBattleSupports
PostBattleSupports_Hook.end:
	pop {r4-r7}
	pop {r0}
	bx r0
	.align
	.ltorg

.global PostBattleSupports
.type PostBattleSupports, %function
PostBattleSupports:
	push {r7, lr}
	mov r7, r8
	push {r7}
	ldr r2, =gSupportAuraDisplayArray
	mov r0, #0
	mov r1, #0
PostBattleSupports.clear:
	strb r0, [r2, r1]
	add r1, #1
	cmp r1, #0x10
	ble PostBattleSupports.clear

	cmp r4, #0
	beq PostBattleSupports.end
	mov r1, #0xB
	ldsb r1, [r4, r1]
	mov r0, #0xC0
	and r0, r1
	cmp r0, #0
	bne PostBattleSupports.defender

	ldrb r0, [r4, #0x13]
	cmp r0, #0
	beq PostBattleSupports.end
	bl UnitIsImmobile
	cmp r0, #1
	beq PostBattleSupports.end

	ldr r0, =CurrentUnit
	ldr r0, [r0]
	cmp r0, r4
	bne PostBattleSupports.end

	cmp r5, #0
	beq PostBattleSupports.notStaff
	mov r1, #0xB
	ldsb r1, [r5, r1]
	mov r0, #0xC0
	and r0, r1
	cmp r0, #0
	bne PostBattleSupports.notStaff

	ldrb r0, [r6, #0x11]
	cmp r0, #UNIT_ACTION_STAFF
	beq PostBattleSupports.Staff
	cmp r0, #UNIT_ACTION_DANCE
	beq PostBattleSupports.MiscAction
	b PostBattleSupports.notStaff

PostBattleSupports.Staff:
	ldr r3, =gBattleActor
	add r3, #0x48
	ldrh r0, [r3]
	blh GetItemType
	cmp r0, #ITEM_TYPE_STAFF
	bne PostBattleSupports.end

PostBattleSupports.MiscAction:
	mov r0, r4
	mov r1, r5
	bl ApplyBonusFromHeal
	cmp r0, #0
	beq PostBattleSupports.end
	mov r3, r4
	b PostBattleSupports.addPlayer

PostBattleSupports.defender:
	ldr r1, =PlayerPhaseOnly
	ldr r1, [r1]
	cmp r1, #1
	beq PostBattleSupports.end
	cmp r5, #0
	beq PostBattleSupports.end
	mov r1, #0xB
	ldsb r1, [r5, r1]
	mov r0, #0xC0
	and r0, r1
	cmp r0, #0
	bne PostBattleSupports.end
	mov r0, r5
	bl UnitIsImmobile
	cmp r0, #1
	beq PostBattleSupports.end
	ldrb r0, [r6, #0x11]
	cmp r0, #UNIT_ACTION_COMBAT
	bne PostBattleSupports.end
	ldr r0, =SupportRateCombat
	ldr r0, [r0]
	cmp r0, #0
	bne PostBattleSupports.chipDfdr
	ldrb r0, [r4, #0x13]
	cmp r0, #0
	bne PostBattleSupports.end
PostBattleSupports.chipDfdr:
	mov r0, r5
	b PostBattleSupports.list

PostBattleSupports.notStaff:
	ldrb r0, [r6, #0x11]
	cmp r0, #UNIT_ACTION_COMBAT
	bne PostBattleSupports.end
	ldr r0, =SupportRateCombat
	ldr r0, [r0]
	cmp r0, #0
	bne PostBattleSupports.chipAtkr
	cmp r5, #0
	beq PostBattleSupports.end
	ldrb r0, [r5, #0x13]
	cmp r0, #0
	bne PostBattleSupports.end
PostBattleSupports.chipAtkr:
	mov r0, r4

PostBattleSupports.list:
	bl PopulateSupportIncreaseList
	cmp r0, #0
	beq PostBattleSupports.end
	mov r8, r0
	mov r3, r4
	cmp r5, #0
	beq PostBattleSupports.addPlayer
	mov r1, #0xB
	ldsb r1, [r5, r1]
	mov r2, #0xC0
	and r2, r1
	cmp r2, #0
	bne PostBattleSupports.addPlayer
	mov r3, r5

PostBattleSupports.addPlayer:
	mov r7, r3
	ldr r2, =gSupportAuraDisplayArray
	add r2, r0
	mov r1, #0xB
	ldsb r1, [r3, r1]
	strb r1, [r2]
	mov r0, r8
	ldr r2, =HeartEmoticonLink
	cmp r0, #0xFF
	bne PostBattleSupports.normalHeart
	ldr r2, =GoldHeartEmoticonLink
PostBattleSupports.normalHeart:
	ldrb r0, [r7, #0x10]
	ldrb r1, [r7, #0x11]
	ldr r2, [r2]
	bl Show_map_emotion_params
	bl StartHeartWait

PostBattleSupports.end:
	pop {r7}
	mov r8, r7
	pop {r7}
	pop {r0}
	bx r0
	.align
	.ltorg

@ r0 = unit. r0 = 1 if sleep/berserk.
UnitIsImmobile:
	mov r1, #0x30
	ldrb r1, [r0, r1]
	mov r0, #0xF
	and r0, r1
	cmp r0, #2
	beq UnitIsImmobile.yes
	cmp r0, #4
	beq UnitIsImmobile.yes
	mov r0, #0
	bx lr
UnitIsImmobile.yes:
	mov r0, #1
	bx lr

@ Hold PlayerPhase ~40 frames so tree-3 hearts can draw.
StartHeartWait:
	push {lr}
	ldr r0, =PostCombatProc
	ldr r1, [r0]
	cmp r1, #0
	beq StartHeartWait.end
	mov r2, #1
	ldr r3, =PostCombatYield
	strb r2, [r3]
	push {r1}
	blh EndPlayerPhaseSideWindows
	pop {r1}
	ldr r0, =HeartWaitProc
	blh ProcStartBlocking
StartHeartWait.end:
	pop {r0}
	bx r0
	.align
	.ltorg

@ r0 = unit. returns count of partners that gained points (or 0xFF for gold).
PopulateSupportIncreaseList:
	push {r4-r7, lr}
	mov r4, r0
	mov r7, #0
	ldr r2, =gSupportIndexArray
	mov r1, #0
PopulateSupportIncreaseList.clrIdx:
	strb r7, [r2, r1]
	add r1, #1
	cmp r1, #8
	blt PopulateSupportIncreaseList.clrIdx
	bl GetSupportPartnerCount
	cmp r0, #0
	beq PopulateSupportIncreaseList.none
	mov r6, r8
	push {r6}
	mov r8, r0
	mov r6, #0
	mov r7, #0
PopulateSupportIncreaseList.loop:
	mov r0, r4
	mov r1, r6
	bl GetSupportPartnerUnit
	mov r5, r0
	cmp r5, #0
	beq PopulateSupportIncreaseList.next
	ldr r1, [r5, #0xC]
	ldr r0, =0x0001000C
	and r0, r1
	cmp r0, #0
	bne PopulateSupportIncreaseList.next
	mov r0, #0x20
	and r0, r1
	cmp r0, #0
	bne PopulateSupportIncreaseList.next
	mov r1, #0xB
	ldsb r1, [r5, r1]
	mov r0, #0xC0
	and r0, r1
	cmp r0, #0
	bne PopulateSupportIncreaseList.next
	mov r0, r5
	bl UnitIsImmobile
	cmp r0, #1
	beq PopulateSupportIncreaseList.next
	mov r0, r4
	mov r1, r5
	bl AreUnitsWithinSupportDistance
	cmp r0, #1
	bne PopulateSupportIncreaseList.next
	ldr r2, =gSupportIndexArray
	add r2, r7
	add r1, r6, #1
	strb r1, [r2]
	add r7, #1
PopulateSupportIncreaseList.next:
	add r6, #1
	cmp r6, r8
	blt PopulateSupportIncreaseList.loop
	pop {r6}
	mov r8, r6
	cmp r7, #0
	beq PopulateSupportIncreaseList.none
	adr r0, MarkForSupportIncrease
	add r0, #1
	mov r1, r4
	mov r2, #1
	bl ForEachSupportPartner
	b PopulateSupportIncreaseList.end
PopulateSupportIncreaseList.none:
	mov r0, r7
PopulateSupportIncreaseList.end:
	pop {r4-r7}
	pop {r1}
	bx r1
	.align
	.ltorg

@ r0 = unit, r1 = support index, r2 = buffer position
MarkForSupportIncrease:
	push {r4-r7, lr}
	mov r4, r0
	mov r5, r1
	mov r6, r2
	mov r7, r8
	push {r7}
	mov r0, r4
	mov r1, r5
	bl GetBwlSlotExp
	ldr r1, =SUPPORT_EXP_CAP
	cmp r0, r1
	bge MarkForSupportIncrease.invalid
	mov r0, r4
	mov r1, r5
	bl GetSupportPartnerUnit
	cmp r0, #0
	beq MarkForSupportIncrease.invalid
	mov r7, r0
	mov r1, r4
	bl FindReciprocalSlot
	cmp r0, #0xFF
	beq MarkForSupportIncrease.invalid
	mov r8, r0
	mov r0, r4
	mov r1, r5
	bl GetBwlSlotExp
	mov r6, r0
	bl GetActionSupportRate
	push {r0}
	mov r2, r0
	mov r0, r4
	mov r1, r5
	bl AddSupportPointsN
	pop {r2}
	mov r0, r7
	mov r1, r8
	bl AddSupportPointsN
	mov r0, r4
	mov r1, r5
	bl GetBwlSlotExp
	mov r1, r6
	mov r6, #0
	cmp r0, r1
	bls MarkForSupportIncrease.noGold
	cmp r0, #0x50
	beq MarkForSupportIncrease.gold
	cmp r0, #0xA0
	beq MarkForSupportIncrease.gold
	cmp r0, #0xF0
	bne MarkForSupportIncrease.noGold
MarkForSupportIncrease.gold:
	mov r6, #1
MarkForSupportIncrease.noGold:
	ldrb r0, [r7, #0x10]
	ldrb r1, [r7, #0x11]
	ldr r2, =HeartEmoticonLink
	cmp r6, #0
	beq MarkForSupportIncrease.show
	ldr r2, =GoldHeartEmoticonLink
MarkForSupportIncrease.show:
	ldr r2, [r2]
	bl Show_map_emotion_params
	mov r0, #1
	cmp r6, #0
	beq MarkForSupportIncrease.end
	mov r0, #0xFF
	b MarkForSupportIncrease.end
MarkForSupportIncrease.invalid:
	mov r0, #0
MarkForSupportIncrease.end:
	pop {r7}
	mov r8, r7
	pop {r4-r7}
	pop {r1}
	bx r1
	.align
	.ltorg

@ r0 = unit, r1 = slot. r0 = exp or 0.
GetBwlSlotExp:
	push {r4, lr}
	mov r4, r1
	ldr r0, [r0]
	cmp r0, #0
	beq GetBwlSlotExp.fail
	ldrb r0, [r0, #4]
	cmp r0, #1
	blt GetBwlSlotExp.fail
	cmp r0, #BWL_PID_MAX
	bgt GetBwlSlotExp.fail
	mov r1, #7
	mul r0, r1
	ldr r1, =gBwlSupportExp
	add r0, r1
	ldrb r0, [r0, r4]
	pop {r4}
	pop {r1}
	bx r1
GetBwlSlotExp.fail:
	mov r0, #0
	pop {r4}
	pop {r1}
	bx r1

@ r0 = BWL support exp. r0 = 0-3. C at 81, B at 161, A at 241.
.global SupportLevelFromExp
.type SupportLevelFromExp, %function
SupportLevelFromExp:
	cmp r0, #0xF0
	ble SupportLevelFromExp.not_a
	mov r0, #3
	b SupportLevelFromExp_end
SupportLevelFromExp.not_a:
	cmp r0, #0xA0
	ble SupportLevelFromExp.not_b
	mov r0, #2
	b SupportLevelFromExp_end
SupportLevelFromExp.not_b:
	cmp r0, #0x50
	ble SupportLevelFromExp.zero
	mov r0, #1
	b SupportLevelFromExp_end
SupportLevelFromExp.zero:
	mov r0, #0
.global SupportLevelFromExp_end
SupportLevelFromExp_end:
	bx lr

@ r0 = unit, r1 = slot, r2 = points. One add into gBwlSupportExp, capped.
.global AddSupportPointsN
.type AddSupportPointsN, %function
AddSupportPointsN:
	push {r4-r6, lr}
	mov r4, r0
	mov r5, r1
	mov r6, r2
	cmp r6, #0
	beq AddSupportPointsN.end
	ldr r0, [r4]
	cmp r0, #0
	beq AddSupportPointsN.end
	ldrb r0, [r0, #4]
	cmp r0, #1
	blt AddSupportPointsN.end
	cmp r0, #BWL_PID_MAX
	bgt AddSupportPointsN.end
	mov r1, #7
	mul r0, r1
	ldr r1, =gBwlSupportExp
	add r0, r1
	add r0, r5
	ldrb r3, [r0]
	cmp r3, #0x50
	beq AddSupportPointsN.end
	cmp r3, #0xA0
	beq AddSupportPointsN.end
	cmp r3, #0xF0
	beq AddSupportPointsN.end
	add r1, r3, r6
	mov r2, #0x50
	cmp r3, #0x50
	blt AddSupportPointsN.cap
	mov r2, #0xA0
	cmp r3, #0xA0
	blt AddSupportPointsN.cap
	mov r2, #0xF0
	cmp r3, #0xF0
	blt AddSupportPointsN.cap
	mov r2, #SUPPORT_EXP_CAP
AddSupportPointsN.cap:
	cmp r1, r2
	ble AddSupportPointsN.store
	mov r1, r2
AddSupportPointsN.store:
	strb r1, [r0]
AddSupportPointsN.end:
.global AddSupportPointsN_end
AddSupportPointsN_end:
	pop {r4-r6}
	pop {r1}
	bx r1

GetActionSupportRate:
	push {lr}
	ldr r3, =ActionStruct
	ldrb r3, [r3, #0x11]
	cmp r3, #UNIT_ACTION_COMBAT
	beq GetActionSupportRate.combat
	cmp r3, #UNIT_ACTION_STAFF
	beq GetActionSupportRate.staff
	cmp r3, #UNIT_ACTION_DANCE
	beq GetActionSupportRate.dance
	mov r0, #1
	b GetActionSupportRate.out
GetActionSupportRate.staff:
	ldr r0, =SupportRateStaff
	ldr r0, [r0]
	b GetActionSupportRate.out
GetActionSupportRate.dance:
	ldr r0, =SupportRateDance
	ldr r0, [r0]
	b GetActionSupportRate.out
GetActionSupportRate.combat:
	ldr r3, =gBattleActor
	ldrb r0, [r3, #0x13]
	cmp r0, #0
	beq GetActionSupportRate.kill
	ldr r3, =gBattleTarget
	ldrb r0, [r3, #0x13]
	cmp r0, #0
	beq GetActionSupportRate.kill
	ldr r0, =SupportRateCombat
	ldr r0, [r0]
	b GetActionSupportRate.out
GetActionSupportRate.kill:
	ldr r0, =SupportRateKill
	ldr r0, [r0]
GetActionSupportRate.out:
	pop {r1}
	bx r1
	.align
	.ltorg

@ r0 = actor, r1 = target
ApplyBonusFromHeal:
	push {r4-r6, lr}
	mov r4, r0
	mov r5, r1
	mov r0, r4
	mov r1, r5
	bl FindReciprocalSlot
	cmp r0, #0xFF
	beq ApplyBonusFromHeal.none
	mov r1, r0
	mov r0, r4
	mov r2, #0
	bl MarkForSupportIncrease
	b ApplyBonusFromHeal.end
ApplyBonusFromHeal.none:
	mov r0, #0
ApplyBonusFromHeal.end:
	pop {r4-r6}
	pop {r1}
	bx r1
	.align
	.ltorg

@ r0 = func, r1 = unit
ForEachSupportPartner:
	push {r4-r7, lr}
	mov r5, r0
	mov r6, r1
	mov r7, #0
	ldr r4, =gSupportIndexArray
ForEachSupportPartner.lop:
	ldrb r1, [r4]
	cmp r1, #0
	beq ForEachSupportPartner.end
	sub r1, #1
	mov r3, r5
	mov r0, r6
	mov r2, r7
	bl BXR3
	add r4, #1
	cmp r0, #0xFF
	beq ForEachSupportPartner.special
	cmp r0, #0
	beq ForEachSupportPartner.lop
	add r7, #1
	b ForEachSupportPartner.lop
ForEachSupportPartner.end:
	mov r0, r7
ForEachSupportPartner.special:
	pop {r4-r7}
	pop {r1}
	bx r1

BXR3:
	bx r3

@ r0 = unit. SupportData* (ROM partners), Lyn-mode clone fallback by name.
GetUnitSupportData:
	push {r4, r5, lr}
	ldr r0, [r0]
	cmp r0, #0
	beq GetUnitSupportData.fail
	mov r4, r0
	ldr r0, [r4, #0x2C]
	cmp r0, #0
	bne GetUnitSupportData.end
	ldrh r5, [r4]
	mov r4, #1
GetUnitSupportData.scan:
	mov r0, r4
	blh GetCharacterData
	ldrh r1, [r0]
	cmp r1, r5
	bne GetUnitSupportData.next
	ldr r1, [r0, #0x2C]
	cmp r1, #0
	beq GetUnitSupportData.next
	mov r0, r1
	b GetUnitSupportData.end
GetUnitSupportData.next:
	add r4, #1
	cmp r4, #BWL_PID_MAX
	ble GetUnitSupportData.scan
GetUnitSupportData.fail:
	mov r0, #0
GetUnitSupportData.end:
	pop {r4, r5}
	pop {r1}
	bx r1
	.align
	.ltorg

GetSupportPartnerCount:
	push {lr}
	bl GetUnitSupportData
	cmp r0, #0
	beq GetSupportPartnerCount.end
	ldrb r0, [r0, #0x15]
GetSupportPartnerCount.end:
	pop {r1}
	bx r1

@ r0 = unit, r1 = slot. Partner RAM unit, matching pid or Lyn-mode name clone.
GetSupportPartnerUnit:
	push {r4-r7, lr}
	mov r4, r0
	mov r5, r1
	bl GetUnitSupportData
	cmp r0, #0
	beq GetSupportPartnerUnit.fail
	ldrb r6, [r0, r5]
	cmp r6, #0
	beq GetSupportPartnerUnit.fail
	mov r0, r6
	blh GetCharacterData
	cmp r0, #0
	beq GetSupportPartnerUnit.fail
	ldrh r7, [r0]
	mov r1, #0xB
	ldsb r1, [r4, r1]
	mov r0, #0xC0
	and r0, r1
	add r5, r0, #1
	add r0, #0x40
	push {r0}
GetSupportPartnerUnit.lop:
	ldr r0, [sp]
	cmp r5, r0
	bge GetSupportPartnerUnit.failPop
	mov r0, r5
	blh GetUnit
	add r5, #1
	cmp r0, #0
	beq GetSupportPartnerUnit.lop
	cmp r0, r4
	beq GetSupportPartnerUnit.lop
	ldr r1, [r0]
	cmp r1, #0
	beq GetSupportPartnerUnit.lop
	ldrb r2, [r1, #4]
	cmp r2, r6
	beq GetSupportPartnerUnit.ok
	ldrh r2, [r1]
	cmp r2, r7
	bne GetSupportPartnerUnit.lop
GetSupportPartnerUnit.ok:
	add sp, #4
	b GetSupportPartnerUnit.end
GetSupportPartnerUnit.failPop:
	add sp, #4
GetSupportPartnerUnit.fail:
	mov r0, #0
GetSupportPartnerUnit.end:
	pop {r4-r7}
	pop {r1}
	bx r1
	.align
	.ltorg

@ r0 = list owner, r1 = other unit. Slot of other in owner's list, or 0xFF.
FindReciprocalSlot:
	push {r4-r7, lr}
	mov r4, r0
	ldr r0, [r1]
	cmp r0, #0
	beq FindReciprocalSlot.fail
	ldrb r6, [r0, #4]
	ldrh r7, [r0]
	mov r0, r4
	bl GetUnitSupportData
	cmp r0, #0
	beq FindReciprocalSlot.fail
	mov r4, r0
	mov r5, #0
FindReciprocalSlot.lop:
	ldrb r0, [r4, r5]
	cmp r0, #0
	beq FindReciprocalSlot.next
	cmp r0, r6
	beq FindReciprocalSlot.found
	blh GetCharacterData
	cmp r0, #0
	beq FindReciprocalSlot.next
	ldrh r0, [r0]
	cmp r0, r7
	beq FindReciprocalSlot.found
FindReciprocalSlot.next:
	add r5, #1
	cmp r5, #7
	blt FindReciprocalSlot.lop
FindReciprocalSlot.fail:
	mov r0, #0xFF
	b FindReciprocalSlot.end
FindReciprocalSlot.found:
	mov r0, r5
FindReciprocalSlot.end:
	pop {r4-r7}
	pop {r1}
	bx r1
	.align
	.ltorg

.global AreUnitsWithinSupportDistance
.type AreUnitsWithinSupportDistance, %function
AreUnitsWithinSupportDistance:
	ldrb r3, [r1, #0x10]
	ldrb r2, [r1, #0x11]
	ldrb r1, [r0, #0x10]
	ldrb r0, [r0, #0x11]
	sub r1, r3
	sub r0, r2
	asr r3, r0, #31
	add r0, r0, r3
	eor r0, r3
	asr r3, r1, #31
	add r1, r1, r3
	eor r1, r3
	add r0, r1
	ldr r1, SupportDistanceLink
	cmp r0, r1
	ble AreUnitsWithinSupportDistance.yes
	mov r0, #0
	b AreUnitsWithinSupportDistance_end
AreUnitsWithinSupportDistance.yes:
	mov r0, #1
.global AreUnitsWithinSupportDistance_end
AreUnitsWithinSupportDistance_end:
	bx lr
	.align
	.ltorg

.align 2
.global SupportDistanceLink
SupportDistanceLink:
	.word 3
.global SupportRateKill
SupportRateKill:
	.word 2
.global SupportRateCombat
SupportRateCombat:
	.word 1
.global SupportRateStaff
SupportRateStaff:
	.word 2
.global SupportRateDance
SupportRateDance:
	.word 2
.global PlayerPhaseOnly
PlayerPhaseOnly:
	.word 1
.global HeartEmoticonLink
HeartEmoticonLink:
	.word 2
.global GoldHeartEmoticonLink
GoldHeartEmoticonLink:
	.word 21
