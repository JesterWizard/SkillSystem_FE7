.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ MoonbowID, SkillTester+4
.equ d100Result, 0x802857c

.global Proc_Moonbow
.type Proc_Moonbow, %function

@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data
Proc_Moonbow:
push {r4-r7,lr}
mov r4, r0                  @attacker
mov r5, r1                  @defender
mov r6, r2                  @battle buffer
mov r7, r3                  @battle data
ldr     r0,[r2]             @r0 = battle buffer
lsl     r0,r0,#0xD
lsr     r0,r0,#0xD          @Without damage data
mov r1, #0xC0               @skill flag
lsl r1, #8                  @0xC000
add r1, #2                  @miss
tst r0, r1
bne End

@check for moonbow proc
ldr r0, SkillTester
mov lr, r0
mov r0, r4                  @attacker data
ldr r1, MoonbowID
.short 0xf800
cmp r0, #0
beq End

ldrb r0, [r4, #0x15]        @skill stat as activation rate
mov r1, r4                  @skill user
blh d100Result
cmp r0, #1
bne End

@if we proc, set the offensive skill flag
ldr     r2,[r6]    
lsl     r1,r2,#0xD
lsr     r1,r1,#0xD
mov     r0, #0x40
lsl     r0, #8              @0x4000, attacker skill activated
orr     r1, r0
ldr     r0,=#0xFFF80000
and     r0,r2
orr     r0,r1
str     r0,[r6]

@and recalculate damage with def reduced by 25%
ldrh r0, [r7, #6]           @final mt
ldrh r1, [r7, #8]           @final def
mov r2,#0x3
mul r1,r2
lsr r1,#0x2
sub r0, r1

ldr r2, [r6]
mov r1, #1
tst r1, r2
beq NoCrit
@if crit, multiply by 3
lsl r1, r0, #1
add r0, r1

NoCrit:
cmp r0, #0
bge NotBelowZero
mov r0, #0
NotBelowZero:
cmp r0, #0x7f
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
@WORD MoonbowID
