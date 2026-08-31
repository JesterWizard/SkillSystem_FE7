.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ CounterID, SkillTester+4
.equ d100Result, 0x802857c

.global Proc_Counter
.type Proc_Counter, %function

@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data
Proc_Counter:
push {r4-r7,lr}
mov r4, r0                  @attacker
mov r5, r1                  @defender
mov r6, r2                  @battle buffer
mov r7, r3                  @battle data
ldr     r0,[r2]             @r0 = battle buffer
lsl     r0,r0,#0xD
lsr     r0,r0,#0xD          @Without damage data
mov r1, #0x82               @devil flag OR miss
tst r0, r1
bne End

@only when attacker initiates
ldr r0, =0x203a3f0
cmp r4, r0
bne End

@make sure attacker has non-magic weapon
mov r0, r4
mov r1, #0x4c               @Move to the attacker's weapon ability
ldr r1, [r0,r1]
mov r2, #0x42
tst r1, r2
bne End                     @do nothing if magic bit set
mov r0, #0x50
ldrb r0, [r4, r0]        @weapon type
cmp r0, #5
bge End

@make sure attack is at 1-2 range
ldrb r0, [r7, #2]
cmp r0, #3
bge End

@make sure damage > 0
mov r0, #4
ldrsh r0, [r7, r0]
cmp r0, #0
ble End

@check for Counter proc
ldr r0, SkillTester
mov lr, r0
mov r0, r5                  @defender data
ldr r1, CounterID
.short 0xf800
cmp r0, #0
beq End
@passive skill, no proc

@check if defender will die
ldrh r2, [r7, #4]           @final damage
mov r0, #0x13
ldrb r0, [r5, r0]           @remaining hp
cmp r2, r0
bge End                     @gonna kill, so don't activate

@if we proc, set the hp update flag
ldr     r2,[r6]    
lsl     r1,r2,#0xD
lsr     r1,r1,#0xD
mov     r0, #0x1
lsl     r0, #8              @0x100, hp drain/update
orr     r1, r0

ldr     r0,=#0xFFF80000
and     r0,r2
orr     r0,r1
str     r0,[r6]

@grab damage dealt
ldrh r2, [r7, #4]           @final damage

@subtract damage from attacker's HP in unit struct (skip if simulation)
ldrh r0, [r7]
mov r1, #2
tst r0, r1
bne SkipHpWrite

ldrb r0, [r4, #0x13]        @attacker's current HP
cmp r0, r2
bgt NotDead
mov r0, #0
b StoreAttackerHP
NotDead:
sub r0, r2
StoreAttackerHP:
strb r0, [r4, #0x13]

SkipHpWrite:
@set hpChange in round buffer
neg r2, r2                  @damage to attacker
mov r0, #3
ldsb r0, [r6, r0]           @current hp change
add r2, r0
strb r2, [r6, #3]           @set damage

End:
pop {r4-r7}
pop {r15}

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD CounterID
