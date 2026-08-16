.thumb

WTYPE_AXE         = 0x02
GetItemAfterUse   = 0x08016730+1
RollBattleRN      = 0x0802857C+1
_ReturnLocation   = 0x080294C8+1

LUnitHasSkill      = EALiterals+0x00
LArmsthriftSkillID = EALiterals+0x04
LAxeFaithSkillID   = EALiterals+0x08

@ Hook from 0x08029498 (FE7 BattleGenerateHitEffects durability check)
@ r2 is &gBattleHitIterator
@ r5 is this round's striker (initiator or countering defender)
@ r4 is already &striker->weapon (set at function start)
@ Branch back to the function epilogue
ArmsthriftHook:
	ldr  r0, [r2]
	ldrh r0, [r0] @ current hit attributes

	mov r1, #2   @ Miss flag

	tst r0, r1  @ <void> = CurrentRound & 2
	beq NonMiss @ goto NonMiss if zero (Miss flag is not set)

	ldr r1, [r5, #0x4C]    @ BattleUnit.weaponAttributes
	mov r2, #(0x02 | 0x80) @ IA_MAGIC | IA_UNCOUNTERABLE

	tst r1, r2 @ <void> = BattleUnit.weaponAttributes & (IA_MAGIC | IA_UNCOUNTERABLE)
	beq End    @ goto End if zero (weapon is neither magic or uncounterable)

NonMiss:
	@ ACTUAL ARMSTHRIFT CHECK BEGIN

	mov r0, r5                 @ arg r0 = (Battle) Unit
	ldr r1, LArmsthriftSkillID @ arg r1 = Skill Index

	ldr r3, LUnitHasSkill
	bl CallR3

	cmp r0, #0        @ compare result
	beq NonArmsthrift @ goto NonArmsthrift if zero (unit does not have armsthrift)

	@ Getting Armsthrift proc chance (=luck)
	ldrb r0, [r5, #0x19] @ BattleUnit.luck
@	lsl  r0, #1          @ multiply by 2
	mov r1, r5           @ get attacker for future checks

	@ ROLL
	ldr r3, =RollBattleRN
	bl CallR3

	cmp r0, #0 @ compare result
	bne End    @ goto End if non-zero (Armsthrift proc)

NonArmsthrift:
	@ ACTUAL ARMSTHRIFT CHECK END

	@ AxeFaith: skip durability when this round's weapon is an axe
	mov r0, r5                 @ arg r0 = (Battle) Unit
	ldr r1, LAxeFaithSkillID   @ arg r1 = Skill Index

	ldr r3, LUnitHasSkill
	bl CallR3

	cmp r0, #0        @ compare result
	beq NonAxeFaith   @ goto NonAxeFaith if zero (unit does not have axefaith)

	mov  r0, #0x50
	ldrb r0, [r5, r0] @ BattleUnit.weaponType for this round
	cmp  r0, #WTYPE_AXE
	beq  End

NonAxeFaith:
	@ Same sequence as vanilla 0x080294AE: r4 = &weapon, then GetItemAfterUse
	mov r4, r5
	add r4, #0x48
	ldrh r0, [r4]

	ldr r3, =GetItemAfterUse
	bl CallR3

	strh r0, [r4] @ Store used weapon

	cmp r0, #0 @ Compare weapon
	bne End    @ goto End if weapon != 0

	mov  r1, #0x7D @ BattleUnit.weaponBroke
	mov  r0, #1

	strb r0, [r5, r1] @ BattleUnit.weaponBroke = true

End:
	ldr r3, =_ReturnLocation
CallR3:
	bx  r3

.ltorg
.align

EALiterals:
	@ POIN SkillTester|1
	@ WORD ArmsthriftID
	@ WORD AxeFaithID
