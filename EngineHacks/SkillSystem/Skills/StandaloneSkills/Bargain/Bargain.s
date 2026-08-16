.thumb
.align

@FE7 GetItemPurchasePrice replacement
@8 byte jumpToHack @ B1D40
@r0 = unit struct
@r1 = item

.equ GetItemCost,0x8017341
.equ UnitHasItem,0x80176F9
.equ BargainID,SkillTester+4
.equ SilverCardList,BargainID+4
.equ DoesBargainStack,SilverCardList+4

.macro blh to, reg
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push {r4-r7,lr}
mov r5, r0 @unit
mov r0, r1 @item
blh GetItemCost, r3
mov r4, r0 @price

@while we're at it, let's let you make a bunch of silver cards

ldr r0, SkillTester
mov lr, r0
mov r0, r5
ldr r1, BargainID
.short 0xf800
cmp r0, #0
beq SilverCardCheck
lsr r4,#1 @halve price of item
ldr r0, DoesBargainStack
cmp r0,#1
bne GoBack

SilverCardCheck:
ldr r6,SilverCardList
LoopStart:
mov r0,r5
ldrb r1,[r6]
cmp r1,#0
beq GoBack
blh UnitHasItem,r7
cmp r0,#1
beq LoopEnd
add r6,#1
b LoopStart
LoopEnd:
lsr r4,#1 @halve price of item

GoBack:
mov r0,r4
lsl r0,r0,#16
lsr r0,r0,#16

pop {r4-r7}
pop {r1}
bx r1

.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD BargainID
@POIN SilverCardList
@WORD DoesBargainStack
