.thumb
.align

.global SkillsUsability
.type SkillsUsability, %function
.global SkillsEffect
.type SkillsEffect, %function

SkillsUsability:
push {r4-r7,r14}

ldr r4,=SkillsMenu
add r4,#0xC

LoopStart:
ldr r0,[r4]
cmp r0,#0
beq RetFalse
mov r14,r0
.short 0xF800
cmp r0,#1
beq GoBack
add r4,#36
b LoopStart

RetFalse:
mov r0,#3

GoBack:
pop {r4-r7}
pop {r1}
bx r1

.ltorg
.align

.equ StartMenuAdjusted,0x804A225

SkillsEffect:
push {r14}

ldr r0,=StartMenuAdjusted
mov r14,r0
ldr r0,=SkillsMenuDef
mov r1,#0
mov r2,#0
mov r3,#0
.short 0xF800

mov r0,#0x94
pop {r1}
bx r1

.ltorg
.align
