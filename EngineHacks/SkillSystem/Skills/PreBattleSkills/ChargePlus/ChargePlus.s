.thumb
.equ ChargePlusID, SkillTester+4

push {r4-r7, lr}
ldr     r5,=0x203A3F0   @attacker
cmp     r0,r5
bne     GoBack
mov r4, r0              @atkr
mov r5, r1              @dfdr

cmp r5,#0
beq GoBack

@not at stat screen
ldr r1, [r5,#4]         @class data ptr
cmp r1, #0
beq GoBack

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, ChargePlusID
.short 0xf800
cmp r0, #0
beq GoBack

mov r0, #0x1D
ldrsb r0, [r4, r0]      @unit's total movement (already accounts for class + bonuses; not a delta to add)
cmp r0, #0
ble GoBack
mov r6, r0              @unit movement

ldr r3, =0x203A85C
ldrb r1, [r3, #0x10]    @spaces moved this turn (ActionData+0x10)
cmp r1, r6
bne GoBack

mov r0, r4
add r0, #0x4C
ldr r1, [r0]
mov r2, #0x20           @brave
orr r1, r2
str r1, [r0]

GoBack:
pop {r4-r7}
pop {r0}
bx r0

.ltorg
.align

SkillTester:
@POIN SkillTester
@WORD ChargePlusID
