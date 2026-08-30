.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ AddUnitHp, 0x8018c7d
.equ GetUnit, 0x8018d0d
.equ LiveToServeID, SkillTester+4
.equ VanillaAfterHeal, 0x802C36D

@ FE7 staff heal at 0802C360. jumpToHack replaces
@ ldrb r0,[r4,#13] / bl GetUnit / mov r1,r5.
@ r5 = heal amount, r4 = gActionData.

.thumb
ldrb    r0, [r4, #0xD]
blh     GetUnit
mov     r1, r5
blh     AddUnitHp

ldrb    r0, [r4, #0xC]
blh     GetUnit
ldr     r1, LiveToServeID
ldr     r3, SkillTester
mov     lr, r3
.short  0xf800
cmp     r0, #0
beq     GoBack

ldrb    r0, [r4, #0xC]
blh     GetUnit
mov     r1, r5
blh     AddUnitHp

GoBack:
ldr     r0, =VanillaAfterHeal
bx      r0

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD LiveToServeID
