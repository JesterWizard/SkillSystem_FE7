.thumb
.align

@jumpToHack at FE7 AiGetLowHpScoreComponent (0x39218)
@caller keeps combat score in r4; returning 0 leaves the r4 we set

.equ SkillTester,EALiterals+0
.equ ShadeID,EALiterals+4
.equ gActiveBattleUnit,0x203A3F0
.equ gDefendingBattleUnit,0x203A470
.equ gpAiBattleWeightFactorTable,0x30013C0

ShadeCheck:
ldr r0,=gDefendingBattleUnit
ldr r1,SkillTester
mov r14,r1
ldr r1,ShadeID
.short 0xF800
cmp r0,#0
beq VanillaFunc

mov r4,#1
mov r1,#0
b GoBack

VanillaFunc:
ldr r0,=gActiveBattleUnit
mov r1,#0x13
ldsb r1,[r0,r1]
mov r0,#0x14
sub r1,r0,r1
ldr r0,=gpAiBattleWeightFactorTable
ldr r0,[r0]
ldrb r0,[r0,#7]
mul r1,r0
cmp r1,#0
bge GoBack
mov r1,#0
GoBack:
mov r0,r1
Done:
bx lr

.ltorg
.align

EALiterals:
@POIN SkillTester
@WORD ShadeID
