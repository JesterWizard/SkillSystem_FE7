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
.equ VanillaEpilogue, 0x802C38F
.equ BattleHitPtr, 0x0203A50C
.equ gBattleActor, 0x0203A3F0
.equ gBattleTarget, 0x0203A470
.equ LiveToServeHealFlag, 0x0203AA02

@ FE7 staff heal at 0802C360. jumpToHack replaces
@ ldrb r0,[r4,#13] / bl GetUnit / mov r1,r5.
@ r5 = heal amount, r4 = gActionData, r6 must reach the epilogue.
@ FE7 BattleHit is 4 bytes; do not write +5 (next round).
@
@ Ported from the C SkillSystem's ExecStandardHeal:
@     AddUnitHp(unit_tar, amount);
@     hit->hpChange = gBattleTarget.unit.curHP - GetUnitCurrentHp(unit_tar);
@     gBattleTarget.unit.curHP = GetUnitCurrentHp(unit_tar);
@     if (SkillTester(unit_act, SID_LiveToServe)) {
@         AddUnitHp(unit_act, amount);
@         gBattleActor.unit.curHP = GetUnitCurrentHp(unit_act);
@     }
@
@ The heal is NOT pre-capped here. AddUnitHp already clamps to max HP, and
@ the SkillSystem repoints GetUnitMaxHP (0x8018AB0 -> its own stat-getter
@ chain); a wrong max there turned the capped amount negative and damaged
@ instead of healing. hpChange is taken from the target's real delta, the
@ way vanilla computes it, so the bars still match what was actually healed.
@
@ Unit pointers are re-fetched after every call rather than kept in a
@ register across SkillTester and the repointed getters.

.thumb
push    {r5, r6, r7}

@ --- target: vanilla heal, uncapped ---
ldr     r1, =gBattleTarget
ldrb    r7, [r1, #0x13]         @ target HP before

ldrb    r0, [r4, #0xD]
blh     GetUnit
mov     r1, r5
blh     AddUnitHp

ldrb    r0, [r4, #0xD]
blh     GetUnit
blh     GetUnitCurrentHP        @ target HP after
mov     r2, r0
ldr     r1, =gBattleTarget
strb    r2, [r1, #0x13]
sub     r7, r7, r2              @ before - after = -actualHeal
ldr     r0, =BattleHitPtr
ldr     r0, [r0]
strb    r7, [r0, #3]

@ --- Live to Serve ---
ldrb    r0, [r4, #0xC]
blh     GetUnit
ldr     r1, LiveToServeID
ldr     r3, SkillTester
mov     lr, r3
.short  0xf800
cmp     r0, #0
beq     NoSkill

ldrb    r0, [r4, #0xC]
blh     GetUnit
blh     GetUnitCurrentHP
mov     r6, r0                  @ healer HP before

ldrb    r0, [r4, #0xC]
blh     GetUnit
mov     r1, r5
blh     AddUnitHp

ldrb    r0, [r4, #0xC]
blh     GetUnit
blh     GetUnitCurrentHP        @ healer HP after
ldr     r1, =gBattleActor
strb    r0, [r1, #0x13]

@ Publish the healer's real gain for the anim's HP-round builder.
sub     r0, r0, r6
ldr     r1, =LiveToServeHealFlag
strb    r0, [r1]

pop     {r5, r6, r7}
ldr     r0, =VanillaEpilogue
bx      r0

NoSkill:
@ No skill: clear the flag so the anim gives the healer no round.
ldr     r1, =LiveToServeHealFlag
mov     r0, #0
strb    r0, [r1]
pop     {r5, r6, r7}
ldr     r0, =VanillaEpilogue
bx      r0

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD LiveToServeID
