.thumb
.align

.global TriangleAttackSkill1
.type TriangleAttackSkill1, %function

.global TriangleAttackSkill2
.type TriangleAttackSkill2, %function

@ FE7 CheckForTriangleAttack actor-ability check at 08029334.
TriangleAttackSkill1:
push {r2, r3}
mov r0, r2
ldr r1, =TriangleAttackIDLink
ldrb r1, [r1]
bl SkillTester
cmp r0, #0
beq TriAttack1_RetFalse

ldr r0, =0x0802933F
b TriAttack1_GoBack

TriAttack1_RetFalse:
ldr r0, =0x0802938D

TriAttack1_GoBack:
pop {r2, r3}
bx r0

.ltorg
.align

@ FE7 partner CA_TRIANGLE test. Hook at 080291E0 (aligned).
@ Vanilla continue is adds r3,#1 at 080291E8.
TriangleAttackSkill2:
push {r2, r3}
mov r0, r2
ldr r1, =TriangleAttackIDLink
ldrb r1, [r1]
bl SkillTester
cmp r0, #0
beq TriAttack2_RetFalse

pop {r2, r3}
ldr r0, =0x080291E9
bx r0

TriAttack2_RetFalse:
pop {r2, r3}
ldr r0, =0x0802920D
bx r0

.ltorg
.align
