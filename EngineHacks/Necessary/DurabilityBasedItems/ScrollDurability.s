.thumb
.align

.global ScrollDurabilityGetter
.type ScrollDurabilityGetter, %function


@ FE7 GetItemUses 0x08017294; full replace (hook must be 4-byte aligned).
@ r0 = item halfword. Does not push lr.
ScrollDurabilityGetter:
mov r2,r0
mov r1,#0xFF
and r1,r2
lsl r0,r1,#3
add r0,r0,r1
lsl r0,r0,#2
ldr r1,=ItemTable
add r0,r0,r1
ldr r0,[r0,#8]
mov r1,#8
and r0,r1
cmp r0,#0
bne RetUnbreakable

mov r0,r2
mov r1,#0xFF
and r0,r1

ldr r3,=DurabilityItemList

DurabilityLoop1Start:
ldrb r1,[r3]
cmp r1,#0
beq RetActualDurability
cmp r0,r1
beq DurabilityLoop1Succeed
add r3,#1
b DurabilityLoop1Start

DurabilityLoop1Succeed:
mov r0,#1
b GoBack

RetActualDurability:
asr r0,r2,#8
b GoBack

.ltorg
.align


RetUnbreakable:
mov r0,#0xFF

GoBack:
bx lr

.ltorg
.align
