
	.thumb

	@ build using lyn
	@ requires MapAuraFx functions to be visible

	LockGame   = 0x08015308|1
	UnlockGame = 0x08015318|1

	StartProc = 0x08004494|1
	BreakProcLoop = 0x080046A0|1

	m4aSongNumStart = 0x080BE594|1

	gChapterData = 0x0202BBF8
	gActiveUnit = 0x03004690

	.type   StartRallyFx, function
	.global StartRallyFx

	.type RallyFx_OnInit, function
	.type RallyFx_OnLoop, function
	.type RallyFx_OnEnd,  function

RallyFxProc:
	.word 1, RallyFxProc.name

	.word 2, LockGame

	.word 14, 0

	.word 2, RallyFx_OnInit
	.word 4, RallyFx_OnEnd

	.word 3, RallyFx_OnLoop

	.word 2, UnlockGame

        .word 0, 0                  @ end

RallyFxProc.name:
	.asciz "Rally Fx"

	.align

RallyFx_OnInit:
	push {lr}

	@ Set [proc+2C] to 0
	@ It will be our clock
	mov r1, #0
	str r1, [r0, #0x2C]

	@ start map aura fx

	ldr r3, =StartMapAuraFx
	bl  BXR3

	@ add units to aura fx

	ldr r3, =ForEachRalliedUnit
	ldr r2, =gActiveUnit
        ldr r2, [r2]                @ arg r2 = active unit

        ldr r0, =AddMapAuraFxUnit   @ arg r0 = function
	@ unused                  @ arg r1 = user argument

	bl BXR3

	ldr r0, =gActiveUnit
	ldr r0, [r0]
	bl AddMapAuraFxUnit

	@ set aura fx thing speed

	ldr r3, =SetMapAuraFxSpeed

        mov r0, #32                 @ arg r0 = speed

	bl BXR3

	ldr  r0, =gChapterData+0x41
	ldrb r0, [r0]

	lsl r0, r0, #0x1E
        blt 0f                      @ Skip sound

	ldr r3, =m4aSongNumStart

        mov r0, #136                @ arg r0 = sound ID (some kind of staff sound?)

	bl BXR3

0:
	@ TODO: use another palette for aura effect

	ldr r0, =gActiveUnit
	ldr r0, [r0]

	bl GetUnitRallyBits

	mov r1, #0

0:
	mov r2, #1
	tst r0, r2
	beq 1f

	lsr r2, r0
	bne 2f

	@ load palette corresponding to rally type

	ldr r0, =RallyFxPaletteLookup
	lsl r1, #2

	ldr r0, [r0, r1]

	b 3f

1:
	add r1, #1
	lsr r0, #1

	b 0b

2:
	@ if 2 or more different rallies, use generic palette
	ldr r0, =gRallyGenericPalette

3:
	ldr r3, =SetMapAuraFxPalette

	@ implied @ arg r0 = palette

	bl BXR3

	pop {r1}
	bx r1

	.pool
	.align

RallyFx_OnEnd:
	push {lr}

	@ end map aura fx

	ldr r3, =EndMapAuraFx
	bl  BXR3

	pop {r1}
	bx r1

	.pool
	.align

RallyFx_OnLoop:
	ldr r1, [r0, #0x2C]
	add r1, #1
	str r1, [r0, #0x2C]

	cmp r1, #0x20
	beq RallyFx_OnLoop.break

	cmp r1, #0x10
	bge 1f

2:
	cmp r1, #0x08
	blt 3f

	mov r0, #0x10
	b 0f

3:
	lsl r0, r1, #1
	b 0f

1:
	@ r1 = 0x20 - r1
	mov r0, #0x20
	sub r1, r0, r1

	b 2b

0:
	ldr r3, =SetMapAuraFxBlend

	@ implied @ arg r0 = blend

        bx r3                       @ jump

RallyFx_OnLoop.break:
	ldr r3, =BreakProcLoop

	@ implied @ r0 = proc

        bx r3                       @ jump

	.pool
	.align
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
	RALLY_FX_PERIOD = 0x28
	GetUnit = 0x08018d0c|1

StartRallyFx:
	push {lr}
	ldr r0, =RallySeqProc
	mov r1, #3
	ldr r3, =StartProc
	bl BXR3
	pop {r3}
BXR3:
	bx r3
.ltorg

.align

.global RallySeqProc
RallySeqProc:
	.word 1, RallyFxProc.name
	.word 2, LockGame
	.word 2, RallySeq_OnInit
	.word 3, RallySeq_OnLoop
	.word 2, UnlockGame
	.word 0, 0

.align

.global RallySeq_OnInit
.type RallySeq_OnInit, %function
RallySeq_OnInit:
	push {r4-r6, lr}
	mov r4, r0
	mov r0, #0
	str r0, [r4, #0x2C]
	mov r1, #0x2E
	strb r0, [r4, r1]
	ldr r3, =RallyAuraCheck
	bl BXR3
	cmp r0, #0
	beq RallySeq_OnInit.start
	mov r5, r0
	mov r6, r4
	add r6, #0x38
	mov r1, #15
RallySeq_OnInit.copy:
	ldrb r0, [r5]
	strb r0, [r6]
	add r5, #1
	add r6, #1
	cmp r0, #0
	beq RallySeq_OnInit.start
	sub r1, #1
	bne RallySeq_OnInit.copy
	mov r0, #0
	strb r0, [r6]
RallySeq_OnInit.start:
	mov r0, r4
	bl RallySeq_GetNextUnit
	cmp r0, #0
	beq RallySeq_OnInit.end
	ldr r3, =GetUnit
	bl BXR3
	mov r1, r4
	bl StartBarrierOnUnit
RallySeq_OnInit.end:
	pop {r4-r6}
	pop {r1}
	bx r1
	.pool

.align

.global RallySeq_OnLoop
.type RallySeq_OnLoop, %function
RallySeq_OnLoop:
	push {r4, lr}
	mov r4, r0
	mov r0, r4
	bl RallySeq_GetNextUnit
	cmp r0, #0
	beq RallySeq_OnLoop.break
	ldr r3, =GetUnit
	bl BXR3
	mov r1, r4
	bl StartBarrierOnUnit
	b RallySeq_OnLoop.end
RallySeq_OnLoop.break:
	mov r0, r4
	ldr r3, =BreakProcLoop
	bl BXR3
RallySeq_OnLoop.end:
	pop {r4}
	pop {r1}
	bx r1
	.pool

.align

.global RallySeq_GetNextUnit
.type RallySeq_GetNextUnit, %function
RallySeq_GetNextUnit:
	mov r3, #0x2E
	ldrb r1, [r0, r3]
	mov r2, r0
	add r2, #0x38
	ldrb r3, [r2, r1]
	cmp r3, #0
	beq RallySeq_GetNextUnit_done
	add r1, #1
	mov r2, #0x2E
	strb r1, [r0, r2]
	mov r0, r3
	b RallySeq_GetNextUnit_End
RallySeq_GetNextUnit_done:
	mov r0, #0
.global RallySeq_GetNextUnit_End
RallySeq_GetNextUnit_End:
	bx lr

.align

.global StartBarrierOnUnit
.type StartBarrierOnUnit, %function
StartBarrierOnUnit:
	@ r0 = unit, r1 = parent proc (blocking). Map Barrier AP at unit x/y.
	@ Do not start MapAnimBattle: that spawns a dummy at (0,0) and death quotes.
	push {r4-r6, lr}
	cmp r0, #0
	beq StartBarrierOnUnit.end
	mov r5, r0
	mov r6, r1
	blh 0x08073878
	cmp r6, #0
	beq StartBarrierOnUnit.end
	ldr r0, =WaitForBarrierEndProc
	mov r1, r6
	blh 0x080044F8
	add r0, #0x2C
	ldr r1, =0x08C9DD24
	str r1, [r0, #0x10]
StartBarrierOnUnit.end:
	pop {r4-r6}
	pop {r1}
.global StartBarrierOnUnit_End
StartBarrierOnUnit_End:
	bx r1
	.pool

.align

.global WaitForBarrierEnd
.type WaitForBarrierEnd, %function
WaitForBarrierEnd:
	push {r4, lr}
	mov r4, r0
	add r0, #0x2C
	ldr r0, [r0, #0x10]
	blh 0x080046A8
	cmp r0, #0
	bne WaitForBarrierEnd.busy
	mov r0, r4
	blh 0x080046A0
WaitForBarrierEnd.busy:
	pop {r4}
	pop {r1}
	bx r1
	.pool

.align

.global WaitForBarrierEndProc
WaitForBarrierEndProc:
	.word 1, RallyFxProc.name
	.word 3, WaitForBarrierEnd
	.word 0, 0

.align

.global AddMapAuraFxUnit
.type AddMapAuraFxUnit, %function
AddMapAuraFxUnit:
	bx lr

.align

.global BuffFxProc
BuffFxProc:
	.word 1, RallyFxProc.name
	.word 2, LockGame
	.word 14, 0
	.word 2, BuffFx_OnInit
	.word 4, RallyFx_OnEnd
	.word 3, RallyFx_OnLoop
	.word 2, UnlockGame
	.word 0, 0
.align

.type StartBuffFx, %function
.global StartBuffFx
StartBuffFx:
	@ FE7: callers pass (unit, anim bits, range). Do not forward that to
	@ StartBarrierOnUnit, which takes (unit, parent proc) — anim bits as a
	@ proc pointer hard-crashes on the first Hone/Oath/Init/Footed tick.
	bx lr 



.equ ProcFind, 0x80046A9

	.align
.global BuffFx_OnInit
.type BuffFx_OnInit, function
BuffFx_OnInit:
	push {r4, lr}
	@ Set [proc+2C] to 0
	@ It will be our clock
	mov r1, #0
	str r1, [r0, #0x2C]
        mov r4, r0                  @ proc 
	ldr r3, =StartMapAuraFx
	bl  BXR3


ldr r0, [r4, #0x38]                 @ range of units to buff 
mov r1, #0xF 
and r0, r1 
cmp r0, #0 
bne BuffAllies
@ show animation on self as first digit is 0 
ldr r0, [r4, #0x30]                 @ unit 
bl AddMapAuraFxUnit
b AuraSpeed 

BuffAllies: 
	@ add units to aura fx

	ldr r3, =ForEachRalliedUnit_NoneActive
	@ ldr r3, =SelfBuff 
        ldr r0, =AddMapAuraFxUnit   @ arg r0 = function
	@ unused                  @ arg r1 = user argument
        ldr r2, [r4, #0x30]         @ unit 
        ldr r1, [r4, #0x38]         @ effect range 
	bl BXR3

AuraSpeed: 
	@ set aura fx thing speed

	ldr r3, =SetMapAuraFxSpeed

        mov r0, #32                 @ arg r0 = speed

	bl BXR3
	


	ldr  r0, =gChapterData+0x41
	ldrb r0, [r0]

	lsl r0, r0, #0x1E
        blt SkipSound               @ Skip sound

	ldr r3, =m4aSongNumStart

        mov r0, #136                @ arg r0 = sound ID (some kind of staff sound?)

	bl BXR3

SkipSound:
	@ TODO: use another palette for aura effect

ldr r0, [r4, #0x34]                 @ bits 

	mov r1, #0

0:
	mov r2, #1
	tst r0, r2
	beq 1f

	lsr r2, r0
	bne 2f

	@ load palette corresponding to rally type

	ldr r0, =RallyFxPaletteLookup
	lsl r1, #2

	ldr r0, [r0, r1]

	b 3f

1:
	add r1, #1
	lsr r0, #1

	b 0b

2:
	@ if 2 or more different rallies, use generic palette
	ldr r0, =gRallyGenericPalette

3:
	ldr r3, =SetMapAuraFxPalette

	@ implied @ arg r0 = palette

	bl BXR3

	pop {r4} 
	pop {r1}
	bx r1

	.pool
	.align

