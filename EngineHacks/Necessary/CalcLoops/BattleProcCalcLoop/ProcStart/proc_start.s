.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ proc_truehit, 0x80285A8 //FE8 -> 0x802A558
.equ d100Result, 0x802857C //FE8 -> 0x802a52c
.global ProcLoop_Start
.type ProcLoop_Start, %function
ProcLoop_Start: @ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data
push {r4-r7,lr}
mov r4, r0 @attacker
mov r5, r1 @defender
@ ldr r2,=#0x203A50C 	@load the battle buffer
mov r6, r2 @battle buffer
mov r7, r3 @battle data

@ First round of this combat: forget leftover Barricade hit counts.
@ Counts live in BattleUnit+0x7F because r11 is clobbered by proc_truehit
@ at the start of every round.
ldr r0, =#0x203A5EC
cmp r6, r0
bne NotFirstRound
mov r1, #0
mov r2, #0x7F
ldr r0, =#0x203A3F0
strb r1, [r0, r2]
ldr r0, =#0x203A470
strb r1, [r0, r2]
NotFirstRound:

ldr     r0,[r6]           		@r0 = battle buffer                @ 0802B40A 6800     
lsl     r0,r0,#0xD              @ 0802B40C 0340     
lsr     r0,r0,#0xD        		@Without damage data                @ 0802B40E 0B40     
mov r1, #2 @miss flag
tst r0, r1
bne EndLadder
@if we missed, don't bother doing anything
@removed sure shot check, just unset the miss flag if needed.
ldrh    r0,[r7,#0xA]      		@final hit rate                @ 0802B41A 8960     
mov     r1,#0x1           		@Default depending on where battle is called, leave it alone             @ 0802B41C 2101     
blh     proc_truehit        	@Proc hit rate                @ 0802B41E F7FFF89B     
cmp     r0,#0x0                	@ 0802B424 2800     
bne     SuccessfulHit        	@If we hit, branch                @ 0802B426 D111   
@if we missed, set the miss flag  
ldr     r2,[r6]    
lsl     r1,r2,#0xD              @ 0802B42C 0351     
lsr     r1,r1,#0xD              @ 0802B42E 0B49     
mov     r0,#0x2           		@miss flag     @ 0802B430 2002  
orr     r1,r0                	@ 0802B432 4301     
ldr     r0,=#0xFFF80000         @ 0802B434 4804     
and     r0,r2                	@ 0802B436 4010     
orr     r0,r1                	@ 0802B438 4308     
str     r0,[r6]    				@store the new battle buffer   
b End

EndLadder:
b End

SuccessfulHit:
@ The proc loop hardcodes r1 = gBattleTarget. The unit taking this hit is
@ the other battle struct from r4 (the inflicter).
ldr r0, =#0x203A3F0
cmp r4, r0
bne HitTakerIsActor
ldr r5, =#0x203A470
b HaveHitTaker
HitTakerIsActor:
mov r5, r0
HaveHitTaker:

@now calculate normal damage
ldrh r0, [r7, #6] @final mt
lsl r0, #0x10
asr r0, #0x10
ldrh r1, [r7, #8] @final def
lsl r1, #0x10
asr r1, #0x10
sub r0, r1

@ BarricadePlus, then Barricade. r0 = damage, r5 = unit taking this hit.
cmp r0, #0x00
beq StoreDamage2
push { r0 }
mov r0, r5
ldr r1, =BarricadePlusIDLink
ldrb r1, [ r1 ]
blh SkillTester, r3
cmp r0, #0x00
pop { r0 }
beq SkipBarricadePlus

mov r2, #0x7F
ldrb r1, [r5, r2]
lsr r0, r0, r1 @ r0 has corrected damage.
add r1, r1, #1
strb r1, [r5, r2]
b StoreDamage2

SkipBarricadePlus:
push { r0 }
mov r0, r5
ldr r1, =BarricadeIDLink
ldrb r1, [ r1 ]
blh SkillTester, r3
cmp r0, #0x00
pop { r0 }
beq StoreDamage2

mov r2, #0x7F
ldrb r1, [r5, r2]
cmp r1, #0x00
beq BarricadeFirstHit
lsr r0, r0, #0x01 @ r0 has the corrected damage.
BarricadeFirstHit:
mov r1, #0x01
strb r1, [r5, r2]

StoreDamage2:
strh r0, [r7, #4] @final damage

@now to check for a crit
ldrh r0, [r7, #0xc] @crit rate
mov r1, #0
blh d100Result
cmp r0, #1
bne End

@if crit:
mov r0,r5		@defender
ldr r1, =ExpertiseIDLink
ldrb r1, [ r1 ]
blh SkillTester, r3

mov r1, #4
ldrsh r1, [r7, r1]
lsl r2, r1, #1
cmp r0,#0
bne StoreDamage
add r2, r1 @damagex3
StoreDamage:
strh r2, [r7, #4] @final damage

@set crit flag
ldr     r2,[r6]    
lsl     r1,r2,#0xD                @ 0802B42C 0351     
lsr     r1,r1,#0xD                @ 0802B42E 0B49     
mov r0, #1
orr r1, r0
ldr     r0,=#0x7FFFF                @ 0802B516 4815     
and     r1,r0                @ 0802B518 4001
ldr     r0,=#0xFFF80000                @ 0802B434 4804     
and     r0,r2                @ 0802B436 4010     
orr     r0,r1                @ 0802B438 4308     
str     r0,[r6]                @ 0802B43A 6018   

End:
pop {r4-r7}
pop {r15}

.align 2
.ltorg
