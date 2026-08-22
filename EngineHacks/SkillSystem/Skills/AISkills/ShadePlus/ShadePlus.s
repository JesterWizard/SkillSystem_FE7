.thumb
.align

@jumpToHack at FE7 AiAttemptOffensiveAction target check (0x386A0)
@r4 = candidate unit
@continue at 0x386C0, skip at 0x38702 (adds r6,#1 — not 0x38704)

.equ AITargetTrueReturn,0x80386C1
.equ AITargetFalseReturn,0x8038703
.equ SkillTester,EALiterals+0
.equ ShadePlusID,EALiterals+4

cmp r4,#0
beq DoNotTarget
ldr r1,[r4]
cmp r1,#0
beq DoNotTarget
ldr r1,[r4,#0xC]
ldr r2,=0x10025
and r1,r2
cmp r1,#0
bne DoNotTarget

mov r0,r4
ldr r1,[sp,#0x24]
bl BXR1
mov r1,r0
cmp r1,#0
beq DoNotTarget

ldr r0,SkillTester
mov r14,r0
mov r0,r4
ldr r1,ShadePlusID
.short 0xF800
cmp r0,#0
beq DoTarget

DoNotTarget:
ldr r1,=AITargetFalseReturn
b GoBack

DoTarget:
ldr r1,=AITargetTrueReturn

GoBack:
bx r1

.ltorg
.align

BXR1:
bx r1

.ltorg
.align

EALiterals:
@POIN SkillTester
@WORD ShadePlusID
