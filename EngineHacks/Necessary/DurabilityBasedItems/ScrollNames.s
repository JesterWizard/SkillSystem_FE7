.thumb
.align

@ FE7 GetItemName 0x080171BC; hook at 171C0
.global GetItemNameString
.type GetItemNameString, %function

@ FE7 GetItemDescId 0x08017244; hook at function start
.global GetItemDescStringIndex
.type GetItemDescStringIndex, %function


.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ ReturnPoint1,0x80171CF
.equ String_GetFromIndex,0x08012C61
.equ gCurrentTextString,0x202A5B4
.equ ReturnPoint2,0x80171D3

GetItemNameString: @hook at 171C0

push {r4-r7}
mov r4,r0

@get ID from item table
mov r1,#0xFF
and r0,r1
lsl r1,r0,#3
add r1,r1,r0
lsl r1,r1,#2
ldr r0,=ItemTable
add r1,r0
ldrh r0,[r1]

@r0 = name ID string

ldr r5,=DurabilityBasedItemNameList

Loop1Start:
ldrh r1,[r5]
cmp r1,#0
beq VanillaFunc1
cmp r0,r1
beq Loop1Exit
add r5,#8
b Loop1Start

Loop1Exit:


ldr r1,[r5,#4]

mov r0,r4
lsr r0,r0,#8 @just durability
lsl r0,r0,#1 @*2

add r0,r1
ldrh r0,[r0] @r0 = text ID for skill desc text for current item



blh String_GetFromIndex

ldrh r1,[r5,#2] @boolean
cmp r1,#0
beq SkipDoingColonTerminaton

@string is now loaded in memory to gCurrentTextString, now we go through and look for a colon (0x3A) byte by byte

ldr r0,=gCurrentTextString

LoopStart:
ldrb r1,[r0]
cmp r1,#0
beq LoopExit
cmp r1,#0x3A @ ":"
beq FoundColon
add r0,#1
b LoopStart

FoundColon:
@address in r0
mov r1,#0
strb r1,[r0]

SkipDoingColonTerminaton:
LoopExit:
pop {r4-r7}
ldr r3,=ReturnPoint2
bx r3


VanillaFunc1:
pop {r4-r7}
ldr r3,=ReturnPoint1
bx r3

.ltorg
.align


GetItemDescStringIndex: @hook at 17244
push {r4}
mov r4,r0

mov r1,#0xFF
and r0,r1
lsl r1,r0,#3
add r1,r0
lsl r1,r1,#2
ldr r0,=ItemTable
add r1,r0
ldrh r0,[r1,#2] @r0 = desc ID

ldr r2,=DurabilityBasedItemDescList
DescLoopStart:
ldrh r1,[r2]
cmp r1,#0
beq GoBack
cmp r0,r1
beq DescLoopExit
add r2,#8
b DescLoopStart

DescLoopExit:
mov r0,r4
lsr r0,r0,#8
lsl r0,r0,#1 @*2

ldr r1,[r2,#4]
add r0,r1
ldrh r0,[r0]

GoBack:
pop {r4}
bx r14

.ltorg
.align
