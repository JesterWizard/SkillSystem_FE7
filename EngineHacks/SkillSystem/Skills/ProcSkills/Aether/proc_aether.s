.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ AetherID, SkillTester+4
.equ LiquidOozeID, AetherID+4
.equ d100Result, 0x802857C

.global Proc_Aether
.type Proc_Aether, %function

@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data
Proc_Aether:
push {r4-r7,lr}
mov r4, r0                  @attacker
mov r5, r1                  @defender
mov r6, r2                  @battle buffer
mov r7, r3                  @battle data

mov r0, r4
add r0, #0x7F
ldrb r1, [r0]
mov r2, #0x40               @Aether bit
tst r1, r2
bne AetherSwing

@check for Aether proc if not set via hit counter
ldr r0, SkillTester
mov lr, r0
mov r0, r4                  @attacker data
ldr r1, AetherID
.short 0xf800
cmp r0, #0
beq End
@if user has Aether, check for proc rate
ldrb r0, [r4, #0x15]        @skill/2 stat as activation rate
lsr r0, #1
mov r1, r4                  @skill user
blh d100Result
cmp r0, #1
bne End
mov r0, #1                  @first hit (Sol)
mov r8, r0
b CheckMiss

AetherSwing:
mov r3, #0x0F
and r3, r1                  @remaining this swing (2 or 1)
cmp r3, #2
beq FirstHit
mov r2, #0                  @second hit (Luna)
mov r8, r2
b DecRemain

FirstHit:
mov r2, #1                  @first hit (Sol)
mov r8, r2

DecRemain:
sub r3, #1
mov r2, #0x0F
bic r1, r2
orr r1, r3
cmp r3, #0
bne StoreRemain
mov r2, #0x40
bic r1, r2
StoreRemain:
strb r1, [r0]

CheckMiss:
ldr r0,[r6]
lsl r0,r0,#0xD
lsr r0,r0,#0xD
mov r1, #0xC0
lsl r1, #8
add r1, #2
tst r0, r1
bne End

mov r0, r8
cmp r0, #1
bne LunaHit

@ First Hit: Sol hit (absorb HP)
@ set attacker skill activated and hp draining flag (0x4100)
ldr     r2,[r6]    
lsl     r1,r2,#0xD
lsr     r1,r1,#0xD
mov     r0, #0x41
lsl     r0, #8              @0x4100
orr     r1, r0
ldr     r0,=#0xFFF80000
and     r0,r2
orr     r0,r1
str     r0,[r6]

@ check Liquid Ooze on defender
mov   r0, r5
ldr   r1, LiquidOozeID
ldr   r3, SkillTester
mov   lr, r3
.short 0xF800
mov   r1, #4
ldsh  r1, [r7, r1]          @ damage
ldrb  r2, [r5, #0x13]       @ defender curr hp
cmp   r1, r2
ble   defLives
mov   r1, r2                @ can't exceed damage dealt to defender
defLives:
cmp   r0, #0
beq   noOoze
neg   r1, r1
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
mov   r2, #3
ldsb  r0, [r6, r2]          @ existing hp change in FE7 (offset 3)
add   r0, r1
strb  r0, [r6, #3]
b End

LunaHit:
@ Second Hit: Luna hit (negate defense)
@ set attacker skill activated flag (0x4000)
ldr     r2,[r6]    
lsl     r1,r2,#0xD
lsr     r1,r1,#0xD
mov     r0, #0x40
lsl     r0, #8              @0x4000
orr     r1, r0
ldr     r0,=#0xFFF80000
and     r0,r2
orr     r0,r1
str     r0,[r6]

@ recalculate damage with def=0
ldrh r0, [r7, #6]           @final mt
ldr r2, [r6]
mov r1, #1
tst r1, r2
beq NoCrit
@if crit, multiply by 3
lsl r1, r0, #1
add r0, r1

NoCrit:
cmp r0, #0x7f               @damage cap of 127
ble NotCap
mov r0, #0x7f
NotCap:
strh r0, [r7, #4]           @final damage

End:
pop {r4-r7}
pop {r15}

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD AetherID
@WORD LiquidOozeID
