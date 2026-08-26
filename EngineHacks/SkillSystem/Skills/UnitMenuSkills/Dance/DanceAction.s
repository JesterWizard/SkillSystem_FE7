.thumb
.align

.equ gActionData,0x0203A85C
.equ gBattleStats,0x0203A3D8
.equ GetUnit,0x08018D0D
.equ BattleInitItemEffect,0x0802A4B5
.equ BattleInitItemEffectTarget,0x0802A561
.equ ApplyDanceBattleAction,0x0802A5D1
.equ BeginBattleAnimations,0x0802A3B1

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

@ FE7U ActionDance, 0x0802F4C4
@ Dance uses the special full-screen animation only for classes with
@ the vanilla dancer class attribute. Other classes still get the
@ battle-state update, but skip BeginBattleAnimations entirely.
DanceAction:
push {r4-r7,lr}
mov r7,r0
mov r4,#0
ldr r5,=gActionData

@ class attribute check: CA_DANCE
ldrb r0,[r5,#0xC]
blh GetUnit,r3
ldr r0,[r0,#4]
ldr r0,[r0,#0x28]
mov r1,#0x10
and r0,r1
cmp r0,#0
bne DanceAction_Original

mov r4,#1

DanceAction_Original:
ldrb r0,[r5,#0xD]
blh GetUnit,r3
ldr r1,[r0,#0xC]
ldr r2,=0xFFFFFBBD
and r1,r2
str r1,[r0,#0xC]

ldrb r0,[r5,#0xC]
blh GetUnit,r3
mov r1,#1
neg r1,r1
blh BattleInitItemEffect,r3

ldrb r0,[r5,#0xD]
blh GetUnit,r3
blh BattleInitItemEffectTarget,r3

ldr r1,=gBattleStats
mov r0,#0x40
strh r0,[r1]
mov r0,r7
blh ApplyDanceBattleAction,r3
cmp r4,#0
beq DanceAction_BeginAnimation
b DanceAction_NoAnimation

DanceAction_BeginAnimation:
blh BeginBattleAnimations,r3

DanceAction_NoAnimation:
mov r0,#0
pop {r4-r7}
pop {r1}
bx r1

.ltorg
