.thumb
.align

@ FE7 inventory draws icons inline (ItemTable+0x1D), not only via GetItemIconId.
@ Four DrawItemMenuLine-style sites + GetItemIconId generic.

.global CheckIfSkillBookIcon_MenuA
.type CheckIfSkillBookIcon_MenuA, %function
.global CheckIfSkillBookIcon_MenuB
.type CheckIfSkillBookIcon_MenuB, %function
.global CheckIfSkillBookIcon_MenuC
.type CheckIfSkillBookIcon_MenuC, %function
.global CheckIfSkillBookIcon_MenuD
.type CheckIfSkillBookIcon_MenuD, %function
.global CheckIfSkillBookIcon_Generic
.type CheckIfSkillBookIcon_Generic, %function

@ ResolveDurabilityIcon:
@   in  r0 = item halfword
@   out r1 = (sheet<<8)|durability if on list, else 0xFFFFFFFF (signed < 0)

ResolveDurabilityIcon:
	push {r2, r3, lr}
	mov r3, r0
	mov r1, #0xFF
	and r0, r1
	ldr r2, =DurabilityBasedItemIconList
Resolve_Loop:
	ldrb r1, [r2]
	cmp r1, #0
	beq Resolve_Miss
	cmp r0, r1
	beq Resolve_Hit
	add r2, #2
	b Resolve_Loop
Resolve_Hit:
	mov r0, r3
	lsr r0, r0, #8
	lsl r0, r0, #24
	lsr r0, r0, #24
	ldrb r1, [r2, #1]
	lsl r1, r1, #8
	orr r1, r0
	b Resolve_End
Resolve_Miss:
	mov r1, #1
	neg r1, r1
Resolve_End:
	pop {r2, r3}
	pop {r0}
	bx r0

.ltorg
.align

@ Menu A @ 0x080164E6: r6=item, r4=itemData, r7=mapOut → BL DrawIcon @ 0x080164FC
CheckIfSkillBookIcon_MenuA:
	mov r0, r6
	bl ResolveDurabilityIcon
	cmp r1, #0
	blt MenuA_Vanilla
	b MenuA_Draw
MenuA_Vanilla:
	cmp r6, #0
	beq MenuA_Neg
	ldrb r1, [r4, #0x1D]
	b MenuA_Draw
MenuA_Neg:
	mov r1, #1
	neg r1, r1
MenuA_Draw:
	mov r2, #0x80
	lsl r2, r2, #7
	mov r0, r7
	ldr r3, =0x080164FD
	bx r3

.ltorg
.align

@ Menu B @ 0x080165B2: r8=item, r5=itemData, r7=mapOut → BL DrawIcon @ 0x080165CC
CheckIfSkillBookIcon_MenuB:
	mov r0, r8
	bl ResolveDurabilityIcon
	cmp r1, #0
	blt MenuB_Vanilla
	b MenuB_Draw
MenuB_Vanilla:
	mov r0, r8
	cmp r0, #0
	beq MenuB_Neg
	ldrb r1, [r5, #0x1D]
	b MenuB_Draw
MenuB_Neg:
	mov r1, #1
	neg r1, r1
MenuB_Draw:
	mov r2, #0x80
	lsl r2, r2, #7
	mov r0, r7
	ldr r3, =0x080165CD
	bx r3

.ltorg
.align

@ Menu C @ 0x08016640: r6=item, r5=itemData, r7=mapOut → BL DrawIcon @ 0x08016658
CheckIfSkillBookIcon_MenuC:
	mov r0, r6
	bl ResolveDurabilityIcon
	cmp r1, #0
	blt MenuC_Vanilla
	b MenuC_Draw
MenuC_Vanilla:
	cmp r6, #0
	beq MenuC_Neg
	ldrb r1, [r5, #0x1D]
	b MenuC_Draw
MenuC_Neg:
	mov r1, #1
	neg r1, r1
MenuC_Draw:
	mov r2, #0x80
	lsl r2, r2, #7
	mov r0, r7
	ldr r3, =0x08016659
	bx r3

.ltorg
.align

@ Menu D @ 0x08016706: r9=item, r5=itemData, r7=mapOut → BL DrawIcon @ 0x08016720
CheckIfSkillBookIcon_MenuD:
	mov r0, r9
	bl ResolveDurabilityIcon
	cmp r1, #0
	blt MenuD_Vanilla
	b MenuD_Draw
MenuD_Vanilla:
	mov r0, r9
	cmp r0, #0
	beq MenuD_Neg
	ldrb r1, [r5, #0x1D]
	b MenuD_Draw
MenuD_Neg:
	mov r1, #1
	neg r1, r1
MenuD_Draw:
	mov r2, #0x80
	lsl r2, r2, #7
	mov r0, r7
	ldr r3, =0x08016721
	bx r3

.ltorg
.align

@ FE7 GetItemIconId 0x08017400; full function replace
CheckIfSkillBookIcon_Generic:
	push {r4, lr}
	mov r4, r0
	bl ResolveDurabilityIcon
	cmp r1, #0
	blt GenericVanilla
	mov r0, r1
	b GenericGoBack
GenericVanilla:
	mov r0, r4
	cmp r0, #0
	beq RetNegOne
	mov r1, #0xFF
	and r0, r1
	mov r1, #36
	mul r0, r1
	ldr r1, =ItemTable
	add r0, r1
	ldrb r0, [r0, #0x1D]
	b GenericGoBack
RetNegOne:
	sub r0, #1
GenericGoBack:
	pop {r4}
	pop {r1}
	bx r1

.ltorg
.align
