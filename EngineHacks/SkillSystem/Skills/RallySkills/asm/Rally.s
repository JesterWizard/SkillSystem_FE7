
	.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
	@ build using lyn
	@ requires MapAuraFx functions to be visible

	RALLY_EFFECT_RANGE = 2

@ Event ASMC. Do not blh 0x0800BC50: that site is pop/bx, not
@ GetUnitByEventParameter. Menu select used to land here.
.global BuffAnim_ASMC
.type BuffAnim_ASMC, %function
.global BuffFx_ASMC
.type BuffFx_ASMC, %function
BuffAnim_ASMC:
BuffFx_ASMC:
	bx lr
	.align

	GetUnit = 0x08018d0c|1
	StartProc = 0x08004494|1
	FindProc = 0x080046A8|1
	EndProc = 0x08004584|1
	BWL_GetEntry = 0x080A0550|1

	gActiveUnit = 0x03004690
	gActionData = 0x0203A85C
	gChapterData = 0x0202BBF8
	BWL_RALLY_BYTE = 0x0F
	BWL_RALLY_MAG_BYTE = 0x0E
	BWL_RALLY_MAG_BIT = 0x80
	BWL_PID_MAX = 0x45

	.type   RallyCommandUsability, function
	.global RallyCommandUsability

	.type   RallyCommandSwitchIn, function
	.global RallyCommandSwitchIn

	.type   RallyCommandEffect, function
	.global RallyCommandEffect

	.type   RallyCommandSwitchOut, function
	.global RallyCommandSwitchOut

	.type   GetUnitRallyBits, function
	.global GetUnitRallyBits

	.type   ForEachRalliedUnit, function
	.global ForEachRalliedUnit

	.type RallyAuraCheck, function
	.global RallyAuraCheck

	.type   GetUnitBwlRallyFlags, function
	.global GetUnitBwlRallyFlags
	.type   GetUnitRallyMagFlag, function
	.global GetUnitRallyMagFlag
	.type   ClearBwlRallies, function
	.global ClearBwlRallies
	.type   RallyStrCommandUsability, function
	.global RallyStrCommandUsability
	.type   RallyMagCommandUsability, function
	.global RallyMagCommandUsability
	.type   RallySklCommandUsability, function
	.global RallySklCommandUsability
	.type   RallySpdCommandUsability, function
	.global RallySpdCommandUsability
	.type   RallyDefCommandUsability, function
	.global RallyDefCommandUsability
	.type   RallyResCommandUsability, function
	.global RallyResCommandUsability
	.type   RallyLukCommandUsability, function
	.global RallyLukCommandUsability
	.type   RallyMovCommandUsability, function
	.global RallyMovCommandUsability
	.type   RallySpectrumCommandUsability, function
	.global RallySpectrumCommandUsability
	.type   RallyStrCommandEffect, function
	.global RallyStrCommandEffect
	.type   RallyMagCommandEffect, function
	.global RallyMagCommandEffect
	.type   RallySklCommandEffect, function
	.global RallySklCommandEffect
	.type   RallySpdCommandEffect, function
	.global RallySpdCommandEffect
	.type   RallyDefCommandEffect, function
	.global RallyDefCommandEffect
	.type   RallyResCommandEffect, function
	.global RallyResCommandEffect
	.type   RallyLukCommandEffect, function
	.global RallyLukCommandEffect
	.type   RallyMovCommandEffect, function
	.global RallyMovCommandEffect
	.type   RallySpectrumCommandEffect, function
	.global RallySpectrumCommandEffect

RallyCommandUsability:
	push {lr}

	ldr r0, =gActiveUnit
        ldr r0, [r0]                    @ r0 = active unit

	@ Check if unit is canto-ing

	ldr r1, [r0, #0x0C]
	mov r2, #0x40

	tst r1, r2
	bne RallyCommandUsability.no

	@ Check if unit can perform any rallies

	@ implied @ arg r0 = unit

	bl GetUnitRallyBits

	cmp r0, #0
	beq RallyCommandUsability.no

	@ Check if anybody would be rallied

	bl RallyAuraCheck

	@ implied @ ret r0 = unit count

	cmp r0, #0
	beq RallyCommandUsability.no

        mov r0, #1                      @ return 1 (command usable)

	b RallyCommandUsability.end

RallyCommandUsability.no:
        mov r0, #3                      @ return 3 (command hidden)

RallyCommandUsability.end:
	pop {r1}
	bx r1

	.pool
	.align

RallyStrCommandUsability:
	mov r1, #0
	b RallyIndexedUsability
RallyMagCommandUsability:
	mov r1, #8
	b RallyIndexedUsability
RallySklCommandUsability:
	mov r1, #1
	b RallyIndexedUsability
RallySpdCommandUsability:
	mov r1, #2
	b RallyIndexedUsability
RallyDefCommandUsability:
	mov r1, #3
	b RallyIndexedUsability
RallyResCommandUsability:
	mov r1, #4
	b RallyIndexedUsability
RallyLukCommandUsability:
	mov r1, #5
	b RallyIndexedUsability
RallyMovCommandUsability:
	mov r1, #6
	b RallyIndexedUsability
RallySpectrumCommandUsability:
	mov r1, #7
	b RallyIndexedUsability

RallyIndexedUsability:
	push {r4-r5, lr}
	mov r5, r1
	ldr r0, =gActiveUnit
	ldr r4, [r0]
	ldr r1, [r4, #0x0C]
	mov r2, #0x40
	tst r1, r2
	bne RallyIndexedUsability.no
	ldr r2, =RallySkillList
	ldrb r1, [r2, r5]
	mov r0, r4
	ldr r3, =SkillTester
	mov lr, r3
	.short 0xF800
	cmp r0, #0
	beq RallyIndexedUsability.no
	bl RallyAuraCheck
	cmp r0, #0
	beq RallyIndexedUsability.no
	mov r0, #1
	b RallyIndexedUsability.end
RallyIndexedUsability.no:
	mov r0, #3
RallyIndexedUsability.end:
	pop {r4-r5}
	pop {r1}
	bx r1

	.pool
	.align

RallyStrCommandEffect:
	mov r1, #0x01
	b RallyBitCommandEffect
RallyMagCommandEffect:
	mov r1, #1
	lsl r1, r1, #8
	b RallyBitCommandEffect
RallySklCommandEffect:
	mov r1, #0x02
	b RallyBitCommandEffect
RallySpdCommandEffect:
	mov r1, #0x04
	b RallyBitCommandEffect
RallyDefCommandEffect:
	mov r1, #0x08
	b RallyBitCommandEffect
RallyResCommandEffect:
	mov r1, #0x10
	b RallyBitCommandEffect
RallyLukCommandEffect:
	mov r1, #0x20
	b RallyBitCommandEffect
RallyMovCommandEffect:
	mov r1, #0x40
	b RallyBitCommandEffect
RallySpectrumCommandEffect:
	mov r1, #0x80
	b RallyBitCommandEffect

RallyBitCommandEffect:
	push {lr}
	adr r0, RallyCommandEffect_apply
	add r0, #1
	ldr r2, =gActiveUnit
	ldr r2, [r2]
	bl ForEachRalliedUnit
	ldr r3, =StartRallyFx
	bl  BXR3
	ldr  r0, =gActionData
	mov  r1, #1
	strb r1, [r0, #0x11]
	mov r0, #0x17
	pop {r1}
	bx r1

	.pool
	.align

RallyCommandEffect:
	push {lr}

	ldr r0, =gActiveUnit
        ldr r0, [r0]                    @ arg r0 = active unit

	bl GetUnitRallyBits

        mov r1, r0                      @ arg r1 = user argument

	adr r0, RallyCommandEffect_apply
        add r0, #1                      @ arg r0 = function
	ldr r2, =gActiveUnit
        ldr r2, [r2]                    @ arg r2 = active unit
	bl ForEachRalliedUnit

	ldr r3, =StartRallyFx
	bl  BXR3

	ldr  r0, =gActionData
	mov  r1, #1
	strb r1, [r0, #0x11]

	mov r0, #0x17

	pop {r1}
	bx r1
	
.equ ProcFind, 0x80046A9
.ltorg 
.global RallyCommandEffect_NoneActive
.type RallyCommandEffect_NoneActive, %function 
RallyCommandEffect_NoneActive:
	push {r4-r5, lr}
        mov r4, r0                      @ unit 
        mov r5, r1                      @ r1 = rally bits 


	adr r0, RallyCommandEffect_apply
        add r0, #1                      @ arg r0 = function
        mov r2, r4                      @ unit 
	mov r1, #RALLY_EFFECT_RANGE
	bl ForEachRalliedUnit_NoneActive

	ldr r0, =BuffFxProc
	blh ProcFind 
	cmp r0, #0 
	beq NewProc 
	
	str r4, [r0, #0x30] 
	str r5, [r0, #0x34] 
	bl BuffFx_OnInit 
	
	b ExitRallyCommandEffect_NoneActive
	
	NewProc: 
        mov r0, r4                      @ unit 
        mov r1, r5                      @ bits 
	mov r2, #RALLY_EFFECT_RANGE 
	ldr r3, =StartBuffFx
	bl  BXR3

	ExitRallyCommandEffect_NoneActive: 
	mov r0, #0x17
	pop {r4-r5} 
	pop {r1}
	bx r1

	.align
.global RallyCommandEffect_apply
.type RallyCommandEffect_apply, %function 
RallyCommandEffect_apply:
	@ args: r0 = unit, r1 = rally bits
	@ bits 0-7 OR into BWL+0x0F; bit 8 sets BWL+0x0E bit 7 (Rally Mag)

	push {r4, lr}
	mov r4, r1
	bl GetBwlEntryForUnit
	cmp r0, #0
	beq RallyCommandEffect_apply.end
	ldrb r1, [r0, #BWL_RALLY_BYTE]
	orr r1, r4
	strb r1, [r0, #BWL_RALLY_BYTE]
	lsr r1, r4, #8
	cmp r1, #0
	beq RallyCommandEffect_apply.end
	ldrb r1, [r0, #BWL_RALLY_MAG_BYTE]
	mov r2, #BWL_RALLY_MAG_BIT
	orr r1, r2
	strb r1, [r0, #BWL_RALLY_MAG_BYTE]
RallyCommandEffect_apply.end:
	pop {r4}
	pop {r1}
	bx r1

	.pool
	.align

RallyCommandSwitchIn:
RallyCommandSwitchOut:
	@ Preview proc StartProc(..., 3) is FE8 tree-root. On FE7 that
	@ parent is not a tree id; execution lands in BuffAnim_ASMC
	@ ($902276C, next to RalliesNumberOfBits_Link). Aura is already stubbed.
        mov r0, #0
	bx lr

	.pool
	.align

GetBwlEntryForUnit:
	@ r0 = unit -> r0 = BWL entry or 0
	push {lr}
	cmp r0, #0
	beq GetBwlEntryForUnit.fail
	ldr r0, [r0]
	cmp r0, #0
	beq GetBwlEntryForUnit.fail
	ldrb r0, [r0, #4]
	cmp r0, #1
	blt GetBwlEntryForUnit.fail
	cmp r0, #BWL_PID_MAX
	bgt GetBwlEntryForUnit.fail
	blh BWL_GetEntry
	pop {r1}
	bx r1
GetBwlEntryForUnit.fail:
	mov r0, #0
	pop {r1}
	bx r1

	.align
	.pool

GetUnitBwlRallyFlags:
	@ r0 = unit -> r0 = applied rally bits (BWL+0x0F), or 0
	push {lr}
	bl GetBwlEntryForUnit
	cmp r0, #0
	beq GetUnitBwlRallyFlags.end
	ldrb r0, [r0, #BWL_RALLY_BYTE]
GetUnitBwlRallyFlags.end:
	pop {r1}
	bx r1

	.align
	.pool

GetUnitRallyMagFlag:
	@ r0 = unit -> r0 = 1 if Rally Mag is applied
	push {lr}
	bl GetBwlEntryForUnit
	cmp r0, #0
	beq GetUnitRallyMagFlag.end
	ldrb r0, [r0, #BWL_RALLY_MAG_BYTE]
	lsr r0, r0, #7
GetUnitRallyMagFlag.end:
	pop {r1}
	bx r1

	.align
	.pool

ClearBwlRallies:
	@ Player phase: zero BWL+0x0F for pid 1..0x45 (rallies last one turn).
	push {r4, lr}
	ldr r0, =gChapterData
	ldrb r0, [r0, #0x0F]
	cmp r0, #0
	bne ClearBwlRallies.end
	mov r4, #1
ClearBwlRallies.lop:
	mov r0, r4
	blh BWL_GetEntry
	cmp r0, #0
	beq ClearBwlRallies.next
	mov r1, #0
	strb r1, [r0, #BWL_RALLY_BYTE]
	ldrb r1, [r0, #BWL_RALLY_MAG_BYTE]
	mov r2, #0x7F
	and r1, r2
	strb r1, [r0, #BWL_RALLY_MAG_BYTE]
ClearBwlRallies.next:
	add r4, #1
	cmp r4, #BWL_PID_MAX
	ble ClearBwlRallies.lop
ClearBwlRallies.end:
	mov r0, #0
	pop {r4}
	pop {r1}
	bx r1

	.align
	.pool

GetUnitRallyBits:
	@ Arguments: r0 = unit
	@ Returns:   r0 = bitfield of what rallies this unit can perform

	push {r4-r7, lr}

        mov r4, r0                      @ var r4 = unit

        ldr r7, =RallySkillList         @ var r7 = rally skill list it

        mov r5, #0                      @ var r5 = rally bits
        mov r6, #0                      @ var r6 = shift

GetUnitRallyBits.lop:
	ldrb r1, [r7]

	cmp r1, #0
	beq GetUnitRallyBits.end

        mov r0, r4                      @ arg r0 = unit
	@ implied  @ arg r1 = skill id

	@ doing this because SkillTester may not have the thumb bit encoded into its address
	ldr r3, =SkillTester
	mov lr, r3
	.short 0xF800

	cmp r0, #0
	beq GetUnitRallyBits.continue

	@ Set corresponding bit
	mov r0, #1
	lsl r0, r6
	orr r5, r0

GetUnitRallyBits.continue:
	add r7, #1
	add r6, #1

	b GetUnitRallyBits.lop

GetUnitRallyBits.end:
	mov r0, r5

	pop {r4-r7}

	pop {r1}
	bx r1

	.align
	.pool

RallyAuraCheck:
	ldr r0, =GetUnitsInRange
	mov ip, r0

	ldr r0, =gActiveUnit
        ldr r0, [r0]                    @ arg r0 = unit
        mov r1, #0                      @ arg r1= check type
        mov r2, #RALLY_EFFECT_RANGE     @ arg r2 = range

        bx  ip                          @ jump (it will return to wherever this was called)

	.pool
	.align
	
RallyAuraCheck_NoneActive:
	ldr r0, =GetUnitsInRange
	mov ip, r0

        mov r0, r2                      @ arg r0 = unit 
        mov r2, r1                      @ arg r2 = range
        mov r1, #0                      @ arg r1= check type


        bx  ip                          @ jump (it will return to wherever this was called)

	.pool
	.align

.global ForEachRalliedUnit_NoneActive
.type ForEachRalliedUnit_NoneActive, %function 
ForEachRalliedUnit_NoneActive:
	@ Arguments: r0 = function (void(*)(struct Unit*, void*)), r1 = second argument to give to function
	@ r2 = unit, r1 = rally effect range 
	@ Returns:   nothing

        push {r0-r1, r4-r5, lr}         @ note: [sp] = function, [sp+4] = second argument
        mov r5, r2                      @ unit 
	bl RallyAuraCheck_NoneActive
	cmp r0, #0 
	beq ForEachRalliedUnit.end
	b NextPart

ForEachRalliedUnit:
	@ Arguments: r0 = function (void(*)(struct Unit*, void*)), r1 = second argument to give to function
	@ Returns:   nothing

        push {r0-r1, r4-r5, lr}         @ note: [sp] = function, [sp+4] = second argument
        mov r5, r2                      @ unit 
	bl RallyAuraCheck

	NextPart: 
	mov r4, r0

ForEachRalliedUnit.lop:
	ldrb r0, [r4]

	cmp r0, #0
	beq ForEachRalliedUnit.end

	@ implied @ arg r0 = unit id

	ldr r3, =GetUnit
	bl  BXR3

	@ implied @ ret r0 = unit

	ldr r3, [sp]
	@ implied        @ arg r0 = unit
	@mov r0, r5 @ unit 
        ldr r1, [sp, #4]                @ arg r1 = extra data
	bl BXR3

	add r4, #1

	b ForEachRalliedUnit.lop

ForEachRalliedUnit.end:
	pop {r1-r2, r4-r5}

	pop {r1}
	bx r1

	.pool
	.align

	.type RallyPreviewFx_OnInit, function
	.type RallyPreviewFx_OnLoop, function
	.type RallyPreviewFx_OnEnd,  function

RallyPreviewFxProc:
	.word 1, RallyPreviewFxProc.name

	.word 2, RallyPreviewFx_OnInit
	.word 4, RallyPreviewFx_OnEnd
	.word 3, RallyPreviewFx_OnLoop

	.word 0, 0

RallyPreviewFxProc.name:
	.asciz "Rally Preview Fx"

	.align

RallyPreviewFx_OnInit:
	push {lr}

        mov r1, #0                      @ timer (unneeded?)
	str r1, [r0, #0x2C]

	@ start map aura fx

	ldr r3, =StartMapAuraFx
	bl  BXR3

        ldr r0, =AddMapAuraFxUnit       @ arg r0 = function
	@ unused                  @ arg r1 = user argument
	ldr r2, =gActiveUnit
        ldr r2, [r2]                    @ arg r2 = active unit
	bl ForEachRalliedUnit

	@ set map aura fx palette

	ldr r3, =SetMapAuraFxPalette

        ldr r0, =gRallyPreviewPalette   @ arg r0 = palette pointer

	bl BXR3

	bl RallyPreviewFx_OnLoop

	pop {r1}
	bx r1

	.pool
	.align

RallyPreviewFx_OnLoop:
	ldr r1, [r0, #0x2C]
	add r1, #1
	str r1, [r0, #0x2C]

	mov r0, #31
        and r0, r1                      @ r0 = timer % 32

        lsr r0, #1                      @ r0 = (timer % 32) / 2

	cmp r0, #8
	ble 1f

	mov r1, #0x10
	sub r0, r1, r0

1:
	cmp r0, #6
	bge 1f

	cmp r0, #2
	blt 2f

	sub r0, #2
	b 0f

2:
	mov r0, #0
	b 0f

1:
	mov r0, #4

0:
	ldr r3, =SetMapAuraFxBlend

	@ implied @ arg r0 = blend

	bx r3

	.pool
	.align

RallyPreviewFx_OnEnd:
	ldr r3, =EndMapAuraFx

BXR3:
	bx r3
