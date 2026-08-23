.thumb
.align

@ FE7 GetItemName 0x080171BC; hook at 171C0
.global GetItemNameString
.type GetItemNameString, %function

@ FE7 GetItemDescId 0x08017244; hook at function start
.global GetItemDescStringIndex
.type GetItemDescStringIndex, %function

@ Inline name loads (DrawItemMenuLine / DrawItemOnStatscreen) skip GetItemName.
.global NewItemNameGetter1
.type NewItemNameGetter1, %function
.global NewItemNameGetter2
.type NewItemNameGetter2, %function
.global NewItemNameGetter3
.type NewItemNameGetter3, %function
.global NewItemNameGetter4
.type NewItemNameGetter4, %function

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


@ DrawItemOnStatscreen @ 0x08016668; hook at lsl r1,#2 (0x16690)
@ item halfword in r9; itemData ptr ends in r5
.equ ReturnPointStatOk,0x801669D
.equ ReturnPointStatVan,0x8016697

NewItemNameGetter1: @hook at 16690
lsl r1,r1,#2
ldr r0,=ItemTable
add r5,r1,r0
ldrh r0,[r5]

ldr r3,=DurabilityBasedItemNameList

LoopStatStart:
ldrh r1,[r3]
cmp r1,#0
beq VanillaStat
cmp r0,r1
beq LoopStatExit
add r3,#8
b LoopStatStart

LoopStatExit:
ldr r1,[r3,#4]
mov r0,r9
lsr r0,r0,#8
lsl r0,r0,#1
add r0,r1
ldrh r0,[r0]
blh String_GetFromIndex

ldrh r0,[r3,#2]
cmp r0,#0
beq SkipColonStat

ldr r0,=gCurrentTextString
LoopColonStat:
ldrb r1,[r0]
cmp r1,#0
beq SkipColonStat
cmp r1,#0x3A
beq FoundColonStat
add r0,#1
b LoopColonStat
FoundColonStat:
mov r1,#0
strb r1,[r0]

SkipColonStat:
ldr r3,=ReturnPointStatOk
bx r3

VanillaStat:
ldr r3,=ReturnPointStatVan
bx r3

.ltorg
.align


@ DrawItemMenuLine (Menu A) @ hook at 0x1649C; item in r6; itemData in r4
.equ ReturnPointMenuAOk,0x80164A9
.equ ReturnPointMenuAVan,0x80164A3

NewItemNameGetter2: @hook at 1649C
lsl r1,r1,#2
ldr r0,=ItemTable
add r4,r1,r0
ldrh r0,[r4]

ldr r3,=DurabilityBasedItemNameList

LoopMenuAStart:
ldrh r1,[r3]
cmp r1,#0
beq VanillaMenuA
cmp r0,r1
beq LoopMenuAExit
add r3,#8
b LoopMenuAStart

LoopMenuAExit:
ldr r1,[r3,#4]
mov r0,r6
lsr r0,r0,#8
lsl r0,r0,#1
add r0,r1
ldrh r0,[r0]
blh String_GetFromIndex

ldrh r1,[r3,#2]
cmp r1,#0
beq SkipColonMenuA

ldr r0,=gCurrentTextString
LoopColonMenuA:
ldrb r1,[r0]
cmp r1,#0
beq SkipColonMenuA
cmp r1,#0x3A
beq FoundColonMenuA
add r0,#1
b LoopColonMenuA
FoundColonMenuA:
mov r1,#0
strb r1,[r0]

SkipColonMenuA:
ldr r3,=ReturnPointMenuAOk
bx r3

VanillaMenuA:
ldr r3,=ReturnPointMenuAVan
bx r3

.ltorg
.align


@ DrawItemMenuLineLong-style (Menu B) @ hook at 0x16538; item in r8; itemData in r5
.equ ReturnPointMenuBOk,0x8016545
.equ ReturnPointMenuBVan,0x801653F

NewItemNameGetter3: @hook at 16538
lsl r1,r1,#2
ldr r0,=ItemTable
add r5,r1,r0
ldrh r0,[r5]

ldr r3,=DurabilityBasedItemNameList

LoopMenuBStart:
ldrh r1,[r3]
cmp r1,#0
beq VanillaMenuB
cmp r0,r1
beq LoopMenuBExit
add r3,#8
b LoopMenuBStart

LoopMenuBExit:
ldr r1,[r3,#4]
mov r0,r8
lsr r0,r0,#8
lsl r0,r0,#1
add r0,r1
ldrh r0,[r0]
blh String_GetFromIndex

ldrh r1,[r3,#2]
cmp r1,#0
beq SkipColonMenuB

ldr r0,=gCurrentTextString
LoopColonMenuB:
ldrb r1,[r0]
cmp r1,#0
beq SkipColonMenuB
cmp r1,#0x3A
beq FoundColonMenuB
add r0,#1
b LoopColonMenuB
FoundColonMenuB:
mov r1,#0
strb r1,[r0]

SkipColonMenuB:
ldr r3,=ReturnPointMenuBOk
bx r3

VanillaMenuB:
ldr r3,=ReturnPointMenuBVan
bx r3

.ltorg
.align


@ DrawItemMenuLineNoColor-style (Menu C) @ hook at 0x165F4 (aligned)
@ On entry: r0 = item id, r1 = id<<3; item halfword in r6; itemData in r5
.equ ReturnPointMenuCOk,0x8016603
.equ ReturnPointMenuCVan,0x80165F9

NewItemNameGetter4: @hook at 165F4
add r1,r1,r0
lsl r1,r1,#2
ldr r0,=ItemTable
add r5,r1,r0
ldrh r0,[r5]

ldr r3,=DurabilityBasedItemNameList

LoopMenuCStart:
ldrh r1,[r3]
cmp r1,#0
beq VanillaMenuC
cmp r0,r1
beq LoopMenuCExit
add r3,#8
b LoopMenuCStart

LoopMenuCExit:
ldr r1,[r3,#4]
mov r0,r6
lsr r0,r0,#8
lsl r0,r0,#1
add r0,r1
ldrh r0,[r0]
blh String_GetFromIndex

ldrh r1,[r3,#2]
cmp r1,#0
beq SkipColonMenuC

ldr r0,=gCurrentTextString
LoopColonMenuC:
ldrb r1,[r0]
cmp r1,#0
beq SkipColonMenuC
cmp r1,#0x3A
beq FoundColonMenuC
add r0,#1
b LoopColonMenuC
FoundColonMenuC:
mov r1,#0
strb r1,[r0]

SkipColonMenuC:
ldr r3,=ReturnPointMenuCOk
bx r3

VanillaMenuC:
ldr r3,=ReturnPointMenuCVan
bx r3

.ltorg
.align


@ FE7 GetItemDescId 0x0801722C — ItemDescGetter / item-select R-text (vanilla ldrh +2).
@ For durability scrolls (desc 0xFFFF) return SkillDescTable[durability].
.global GetItemNameIdStringIndex
.type GetItemNameIdStringIndex, %function

GetItemNameIdStringIndex: @hook at 1722C
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
NameIdLoopStart:
ldrh r1,[r2]
cmp r1,#0
beq NameIdGoBack
cmp r0,r1
beq NameIdLoopExit
add r2,#8
b NameIdLoopStart

NameIdLoopExit:
mov r0,r4
lsr r0,r0,#8
lsl r0,r0,#1
ldr r1,[r2,#4]
add r0,r1
ldrh r0,[r0]

NameIdGoBack:
pop {r4}
bx r14

.ltorg
.align


@ FE7 GetItemUseDescId 0x08017244 (vanilla ldrh +4).
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
ldrh r0,[r1,#4] @r0 = use desc ID

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
