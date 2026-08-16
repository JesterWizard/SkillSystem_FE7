.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ AdeptID, SkillTester+4
.equ BattleCheckBraveEffect, 0x8029129
.equ d100Result, 0x802857C

@ r0 = attacker. BattleUnit+0x7F (pad): hits to skip before the extra
@ Adept strike. Do not use +0x7E (hasItemEffectTarget).
GetBattleUnitHitCount_Adept:
push {r4-r5, lr}
mov r4, r0
mov r0, r4
add r0, #0x7F
mov r1, #0
strb r1, [r0]
mov r5, #1
mov r0, r4
blh BattleCheckBraveEffect
lsl r5, r0

ldr r1, AdeptID
cmp r1, #255
beq Return

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, AdeptID
.short 0xf800
cmp r0, #0
beq Return

mov r0, #0x64 @ 100% (was speed at [r4,#0x16])
mov r1, r4
blh d100Result
cmp r0, #1
bne Return
add r5, #1
mov r0, r4
add r0, #0x7F
strb r5, [r0] @ remaining hits; Proc_Adept marks when this hits 0

Return:
mov r0, r5
pop {r4-r5}
pop {r1}
bx r1

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD AdeptID
