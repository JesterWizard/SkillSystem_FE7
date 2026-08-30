.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.thumb 
.equ GetUnit, 0x8018d0d
.equ NextRN_N, 0x8000E31

.global IsRallyApplicable
.type IsRallyApplicable, %function 
IsRallyApplicable: 
	@ Start-of-turn even with nobody in range (self still gets the rally).
	mov r0, #1 
	bx lr 
.ltorg 

.global RallyChaosFunc 
.type RallyChaosFunc, %function 
RallyChaosFunc: 
	push {r4-r7, lr} 
	mov r4, r0                      @ valid unit with this skill 

	mov r0, #8                      @ 0..7 -> bits 1<<n 
	blh NextRN_N 
	mov r7, #1 
	lsl r7, r0                      @ rally bit to do 

	mov r0, r4 
	mov r1, r7 
	bl RallyCommandEffect_apply 

	mov r0, r4                      @ unit with skill 
	mov r1, r7                      @ rally anim bits 
	mov r2, #2                      @ range 
	bl StartBuffFx

	mov r0, r4 
	mov r1, #0                      @ can trade 
	mov r2, #2                      @ range 
	bl GetUnitsInRange 
	cmp r0, #0 
	beq ExitRallyChaos 
	mov r5, r0                      @ units in range pointer 

	mov r6, #0 
	sub r6, #1 

RallyChaosLoop:                     @ apply the buff bits 
	add r6, #1 
	ldrb r0, [r5, r6] 
	cmp r0, #0 
	beq ExitRallyChaos 
	blh GetUnit 
	mov r1, r7                      @ rally anim bits 
	bl RallyCommandEffect_apply     @ args: r0 = unit, r1 = rally bits
	b RallyChaosLoop

ExitRallyChaos: 
	pop {r4-r7} 
	pop {r0} 
	bx r0 
.ltorg 
