.thumb

.equ LockTouchID, SkillTester+4
.equ CunningID, LockTouchID+4
.equ VanillaCont, 0x0801852D

@ FE7 GetUnitKeyItemSlotForTerrain (08018524). jumpToHack overwrites the
@ push {r4-r6,lr} / mov r4,r0 / mov r5,r1 / mov r6,#0 prologue.
@ Return 0xFF = open without consuming a key/pick.

.thumb
push {r4-r6, lr}
mov r4, r0
mov r5, r1
mov r6, #0

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, LockTouchID
.short 0xf800
cmp r0, #0
bne HasLocktouch

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, CunningID
.short 0xf800
cmp r0, #0
bne HasLocktouch

ldr r0, =VanillaCont
bx r0

HasLocktouch:
mov r0, #0xFF
LockTouchDone:
pop {r4-r6}
pop {r1}
bx r1

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD LockTouchID
@WORD CunningID
