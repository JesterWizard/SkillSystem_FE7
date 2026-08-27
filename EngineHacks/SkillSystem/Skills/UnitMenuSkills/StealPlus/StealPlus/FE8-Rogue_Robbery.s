.thumb

@ Replace FE7 IsItemStealable (0x08016D38).
@ r0 = item short (vanilla callers) OR unit* (steal list / item menu).
@ r1 = inventory slot when r0 is a unit*.

.equ SkillTester, Con_Getter+4
.equ StealPlusID, SkillTester+4
.equ WatchfulID, StealPlusID+4

push	{r4-r7,r14}
lsr		r2, r0, #16
cmp		r2, #0
beq		VanillaStealable

mov		r4, r0
mov		r5, r1
ldr		r1, WatchfulID
cmp		r1, #0xFF
beq		SkipWatchful
ldr		r3, SkillTester
mov		r14, r3
.short	0xF800
cmp		r0, #1
beq		RetFalse
SkipWatchful:
lsl		r6, r5, #1
add		r6, #0x1E
ldrh	r6, [r4, r6]
cmp		r6, #0
beq		RetFalse
mov		r0, r6
ldr		r3, =0x0801725D
mov		r14, r3
.short	0xF800
cmp		r0, #9
beq		RetTrue
mov		r7, r0
ldr		r0, =0x03004690
ldr		r0, [r0]
ldr		r1, StealPlusID
ldr		r3, SkillTester
mov		r14, r3
.short	0xF800
cmp		r0, #0
beq		RetFalse
mov		r0, r7
cmp		r0, #4
beq		RetTrue
cmp		r0, #0xB
bgt		RetTrue
ldr		r7, =0x03004690
ldr		r7, [r7]
mov		r0, r4
ldr		r3, =0x08016795
mov		r14, r3
.short	0xF800
cmp		r0, r5
beq		RetFalse
mov		r0, r6
ldr		r3, =0x08017311
mov		r14, r3
.short	0xF800
mov		r5, r0
mov		r0, r7
ldr		r3, Con_Getter
mov		r14, r3
.short	0xF800
cmp		r0, r5
blt		RetFalse
b		RetTrue

VanillaStealable:
cmp		r0, #0
beq		RetFalse
ldr		r3, =0x0801725D
mov		r14, r3
.short	0xF800
cmp		r0, #9
beq		RetTrue
b		RetFalse

RetTrue:
mov		r0, #1
b		GoBack
RetFalse:
mov		r0, #0
GoBack:
pop		{r4-r7}
pop		{r1}
bx		r1

.ltorg
Con_Getter:
