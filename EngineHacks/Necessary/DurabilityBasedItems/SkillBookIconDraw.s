.thumb
.align

.global CheckIfSkillBookIcon_Generic
.type CheckIfSkillBookIcon_Generic, %function


@ FE7 GetItemIconId 0x08017400; full function replace
CheckIfSkillBookIcon_Generic:
push {r4,r14}
mov r4,r0 @r4 = item halfword

@is the item on the list?
mov r0,r4
mov r1,#0xFF
and r0,r1

ldr r2,=DurabilityBasedItemIconList

Loop6Start:
ldrb r1,[r2]
cmp r1,#0
beq DoVanillaIconThing
cmp r0,r1
beq Loop6Exit
add r2,#2
b Loop6Start

Loop6Exit:

@get durability
mov r0,r4
lsr r0,r0,#8

ldrb r1,[r2,#1]
lsl r1,r1,#8
orr r0,r1

@r0 = icon ID
b GenericGoBack

.ltorg
.align

DoVanillaIconThing:
@get icon from item table
mov r0,r4
cmp r0,#0
beq RetNegOne
mov r1,#0xFF
and r0,r1
mov r1,#36
mul r0,r1
ldr r1,=ItemTable
add r0,r1
ldrb r0,[r0,#0x1D]
b GenericGoBack

RetNegOne:
sub r0,#1

GenericGoBack:
pop {r4}
pop {r1}
bx r1

.ltorg
.align
