.thumb
.align

.global SkillsUsability
.type SkillsUsability, %function
.global SkillsEffect
.type SkillsEffect, %function
.global SkillsMenuOnEnd
.type SkillsMenuOnEnd, %function
.global SkillsMenuBPress
.type SkillsMenuBPress, %function

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

@ FE7 StartMenu(def, parent). Blocking child; parent stays on screen.
.equ StartMenuChild,0x804A255
.equ TileMap_FillRect,0x80C57BD
.equ BG_EnableSyncByMask,0x8000FFD
.equ gBG0TilemapBuffer,0x02022C60
.equ gBG1TilemapBuffer,0x02023460
.equ gUiTmScratchA,0x0200323C
.equ gUiTmScratchB,0x0200373C

SkillsEffect:
push {r4-r7,r14}
mov r4,r0                      @ parent MenuProc

mov r0,r4
bl SaveParentMenu

ldr r0,=StartMenuChild
mov r14,r0
ldr r0,=SkillsMenuDef
mov r1,r4
.short 0xF800
mov r5,r0                      @ child MenuProc

@ Put the child immediately beside the parent. Prefer the left side when
@ there is room; otherwise put it to the right.
mov r3,#0x2C
ldrb r6,[r4,r3]                @ parent x
add r3,#2
ldrb r7,[r4,r3]                @ parent width
mov r0,#10                     @ child width
cmp r6,r0
blo PlaceSkillsMenuRight
sub r6,r6,r0
b SetSkillsMenuX

PlaceSkillsMenuRight:
add r6,r7

SetSkillsMenuX:
mov r3,#0x2C
strb r6,[r5,r3]                @ child rect.x
add r6,#1                      @ child item x = rect.x + 1
mov r3,#0x60
ldrb r7,[r5,r3]                @ child item count
mov r1,#0x34
add r1,r5                      @ child menuItems array
mov r2,#0

MoveSkillsMenuItems:
cmp r2,r7
bge MoveSkillsMenuItemsDone
ldr r0,[r1]
cmp r0,#0
beq MoveSkillsMenuItemsDone
mov r3,#0x2A
strh r6,[r0,r3]                @ MenuItemProc.xTile
add r1,#4
add r2,#1
b MoveSkillsMenuItems

MoveSkillsMenuItemsDone:
mov r0,#0x04                   @ MENU_ACT_SND6A; do not END/CLEAR/DOOM parent
pop {r4-r7}
pop {r1}
bx r1

.ltorg
.align

SkillsMenuBPress:
mov r3,#0x68                   @ MenuProc.unk68; RAM marker for B return
mov r2,#1
strh r2,[r0,r3]
mov r0,#0x0B                   @ SKIPCURSOR | END | SND6B (no CLEAR)
bx lr

SkillsMenuOnEnd:
push {r4-r7,r14}
mov r4,r0                      @ child MenuProc
ldr r5,[r4,#0x14]              @ proc_parent

mov r3,#0x68
ldrh r1,[r4,r3]                @ B-return marker

cmp r5,#0
beq OnEndDone
cmp r1,#0
beq DoomParent

@ B: erase child window; the adjacent parent remains visible
mov r3,#0x2C
ldrb r0,[r4,r3]                @ x
add r3,#1
ldrb r1,[r4,r3]                @ y
add r3,#1
ldrb r7,[r4,r3]                @ w
add r3,#1
ldrb r2,[r4,r3]                @ h
cmp r2,#0
bne GotH
mov r3,#0x60
ldrb r2,[r4,r3]                @ itemCount
add r2,#2
GotH:
lsl r6,r1,#5
add r6,r0
lsl r6,r6,#1                   @ (y*32+x)*2

ldr r0,=gBG0TilemapBuffer
add r0,r6
mov r1,r7
ldr r3,=TileMap_FillRect
mov r14,r3
mov r3,#0
.short 0xF800

mov r3,#0x2F
ldrb r2,[r4,r3]
cmp r2,#0
bne GotH2
mov r3,#0x60
ldrb r2,[r4,r3]
add r2,#2
GotH2:
ldr r0,=gBG1TilemapBuffer
add r0,r6
mov r1,r7
ldr r3,=TileMap_FillRect
mov r14,r3
mov r3,#0
.short 0xF800

@ Restore the exact parent tilemaps saved before the child opened.
mov r0,r5
bl RestoreParentMenu

mov r0,#3
ldr r1,=BG_EnableSyncByMask
mov r14,r1
.short 0xF800
b OnEndDone

DoomParent:
mov r1,#0x63
ldrb r0,[r5,r1]
mov r2,#0x80                   @ MENU_STATE_DOOMED
orr r0,r2
strb r0,[r5,r1]

OnEndDone:
pop {r4-r7}
pop {r1}
bx r1

SaveParentMenu:
push {r4-r7,r14}
mov r4,r0
mov r3,#0x2C
ldrb r0,[r4,r3]                @ x
add r3,#1
ldrb r1,[r4,r3]                @ y
add r3,#1
ldrb r2,[r4,r3]                @ width
add r3,#1
ldrb r3,[r4,r3]                @ height
lsl r1,r1,#5
add r1,r0
lsl r1,r1,#1                   @ (y*32+x)*2

ldr r0,=gBG0TilemapBuffer
add r0,r1
mov r4,r0
ldr r0,=gBG1TilemapBuffer
add r0,r1
mov r5,r0
ldr r6,=gUiTmScratchA
ldr r7,=gUiTmScratchB
mov r1,r3                      @ remaining rows
cmp r1,#0
beq SaveParentMenuDone

SaveParentMenuRow:
mov r3,r2                      @ remaining columns
SaveParentMenuColumn:
ldrh r0,[r4,#0]
strh r0,[r6,#0]
ldrh r0,[r5,#0]
strh r0,[r7,#0]
add r4,#2
add r5,#2
add r6,#2
add r7,#2
sub r3,#1
bne SaveParentMenuColumn

mov r0,#32
sub r0,r0,r2
lsl r0,r0,#1
add r4,r0
add r5,r0
sub r1,#1
bne SaveParentMenuRow

SaveParentMenuDone:
pop {r4-r7}
pop {r1}
bx r1

RestoreParentMenu:
push {r4-r7,r14}
mov r4,r0
mov r3,#0x2C
ldrb r0,[r4,r3]                @ x
add r3,#1
ldrb r1,[r4,r3]                @ y
add r3,#1
ldrb r2,[r4,r3]                @ width
add r3,#1
ldrb r3,[r4,r3]                @ height
lsl r1,r1,#5
add r1,r0
lsl r1,r1,#1                   @ (y*32+x)*2

ldr r0,=gBG0TilemapBuffer
add r0,r1
mov r4,r0
ldr r0,=gBG1TilemapBuffer
add r0,r1
mov r5,r0
ldr r6,=gUiTmScratchA
ldr r7,=gUiTmScratchB
mov r1,r3                      @ remaining rows
cmp r1,#0
beq RestoreParentMenuDone

RestoreParentMenuRow:
mov r3,r2                      @ remaining columns
RestoreParentMenuColumn:
ldrh r0,[r6,#0]
strh r0,[r4,#0]
ldrh r0,[r7,#0]
strh r0,[r5,#0]
add r4,#2
add r5,#2
add r6,#2
add r7,#2
sub r3,#1
bne RestoreParentMenuColumn

mov r0,#32
sub r0,r0,r2
lsl r0,r0,#1
add r4,r0
add r5,r0
sub r1,#1
bne RestoreParentMenuRow

RestoreParentMenuDone:
pop {r4-r7}
pop {r1}
bx r1

.ltorg
.align
