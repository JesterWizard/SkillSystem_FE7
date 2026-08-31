.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ LiquidOozeID, SkillTester+4
.equ d100Result, 0x802857c

.global Proc_StealHP
.type Proc_StealHP, %function

@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data
Proc_StealHP:
push {r4-r7,lr}
mov r4, r0 @ inflicter
mov r6, r2 @ battle buffer
mov r7, r3 @ battle data

@ Proc loop hardcodes r1 = gBattleTarget. Victim is the other battle unit.
ldr r0, =0x203A3F0
cmp r4, r0
bne VictimIsActor
ldr r5, =0x203A470
b HaveSides
VictimIsActor:
mov r5, r0
HaveSides:

@check for miss
ldr     r0,[r6]
lsl     r0,r0,#0xD
lsr     r0,r0,#0xD
mov	r1,#0x82 @miss + devil
and	r0,r1
cmp	r0,#2
beq	End

@check for draining weapon
mov	r0,#0x4A
ldrh	r0,[r4,r0]	@equipped item
ldr	r1,=#0x8017424	@GetItemEffect
mov	lr,r1
.short	0xf800
cmp	r0,#2		@steal hp effect
bne	End

@make sure damage > 0
mov	r0,#4
ldrsh	r0,[r7,r0]
cmp	r0,#0
ble	End

@ Devil / Counter already reversed this hit: do not steal, and do not
@ clear their 0x80 flag or zero the damage they just set.
ldr     r0,[r6]
lsl     r0,r0,#0xD
lsr     r0,r0,#0xD
mov	r1,#0x80
tst	r0,r1
bne	End

@if we proc, set the hp update flag
ldr     r2,[r6]
lsl     r1,r2,#0xD
lsr     r1,r1,#0xD
mov     r0, #0x1
lsl     r0, #8           @0x100, hp drain/update
orr     r1, r0

ldr     r0,=#0xFFF80000
and     r0,r2
orr     r0,r1
str     r0,[r6]

@check for liquid ooze on the hit-taker
ldr r0, SkillTester
mov lr, r0
mov r0, r5
ldr r1, LiquidOozeID
.short 0xf800
mov	  r1, #4
ldsh	r1, [r7, r1]    @ damage
ldrb  r2, [r5, #0x13] @ defender's curr hp
cmp   r1, r2
ble   defLives        @ Damage taken / HP healed by attacker.
  mov   r1, r2        @ can't exceed damage dealt to defender.
defLives:
cmp r0, #0
beq noOoze
  neg   r1, r1
  @ Keep 0x100 so both bars get a LUT round (vanilla simultaneous tick).
  @ 0x1000: stealer arithmetic subtracts instead of heals. No 0x80.
  ldr     r2, [r6]
  lsl     r3, r2, #0xD
  lsr     r3, r3, #0xD
  mov     r0, #0x80
  bic     r3, r0
  mov     r0, #0x10
  lsl     r0, #8
  orr     r3, r0
  ldr     r0, =#0xFFF80000
  and     r0, r2
  orr     r0, r3
  str     r0, [r6]
  mov     r0, #1
  ldr     r3, =#0x0203AA01
  strb    r0, [r3]
noOoze:
mov   r2, #0x3
ldsb	r2,[r6,r2]	@hp change
add   r2, r1
strb	r2,[r6,#3]	@hp change

End:
pop {r4-r7}
pop {r15}

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD LiquidOozeID
