.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ AddUnitHp, 0x8018c7d
.equ GetUnit, 0x8018d0d
.equ GetUnitCurrentHP, 0x8018A71
.equ LiveToServeID, SkillTester+4
.equ VanillaAfterHeal, 0x802C36D
.equ VanillaEpilogue, 0x802C38F
.equ BattleHitPtr, 0x0203A50C
.equ gBattleActor, 0x0203A3F0
.equ gBattleTarget, 0x0203A470

@ FE7 staff heal at 0802C360. jumpToHack replaces
@ ldrb r0,[r4,#13] / bl GetUnit / mov r1,r5.
@ r5 = heal amount, r4 = gActionData, r6 must reach the epilogue.

.thumb
push    {r5, r7}

ldrb    r0, [r4, #0xD]
blh     GetUnit
mov     r1, r5
blh     AddUnitHp

ldrb    r0, [r4, #0xC]
blh     GetUnit
mov     r7, r0
ldr     r1, LiveToServeID
ldr     r3, SkillTester
mov     lr, r3
.short  0xf800
cmp     r0, #0
beq     NoSkill

mov     r0, r7
ldr     r1, [sp]
blh     AddUnitHp

ldr     r3, =BattleHitPtr
ldr     r3, [r3]

ldrb    r0, [r4, #0xD]
blh     GetUnit
blh     GetUnitCurrentHP
ldr     r5, =gBattleTarget
ldrb    r2, [r5, #0x13]
sub     r2, r0
strb    r2, [r3, #3]
strb    r0, [r5, #0x13]

ldr     r5, =gBattleActor
ldrb    r2, [r5, #0x13]
mov     r0, r7
blh     GetUnitCurrentHP
sub     r1, r0, r2
strb    r1, [r3, #5]
strb    r0, [r5, #0x13]

ldr     r0, [r3]
lsl     r1, r0, #13
lsr     r1, r1, #13
mov     r2, #1
lsl     r2, #8
orr     r1, r2
ldr     r2, =0xFFF80000
and     r0, r2
orr     r0, r1
str     r0, [r3]

pop     {r5, r7}
ldr     r0, =VanillaEpilogue
bx      r0

NoSkill:
pop     {r5, r7}
ldr     r0, =VanillaAfterHeal
bx      r0

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD LiveToServeID
