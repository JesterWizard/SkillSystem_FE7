.thumb
@ Same skill-icon path as the status screen (SkillIcons sheet).

	.macro blh to, reg=r3
		ldr \reg, =\to
		mov lr, \reg
		.short 0xf800
	.endm

.global DrawSkillIcon
DrawSkillIcon:
push    {r4,r5,r14}
mov     r4,r0
mov     r0,r1
mov     r5,r2
cmp     r0,#0x0
bge     DrawSkillIcon.draw
mov     r0,#0x0
strh    r0,[r4]
strh    r0,[r4,#0x2]
mov     r1,r4
add     r1,#0x40
strh    r0,[r1]
add     r1,#0x2
b       DrawSkillIcon.end
DrawSkillIcon.draw:
bl      DrawAlternateIcon
add     r0,r0,r5
lsl     r0,r0,#0x10
lsr     r1,r0,#0x10
mov     r2,#0x80
lsl     r2,r2,#0x9
add     r0,r0,r2
strh    r1,[r4]
lsr     r1,r0,#0x10
add     r0,r0,r2
strh    r1,[r4,#0x2]
mov     r2,r4
add     r2,#0x40
lsr     r1,r0,#0x10
mov     r3,#0x80
lsl     r3,r3,#0x9
add     r0,r0,r3
lsr     r0,r0,#0x10
strh    r1,[r2]
mov     r1,r4
add     r1,#0x42
DrawSkillIcon.end:
strh    r0,[r1]
pop     {r4,r5}
pop     {r0}
bx      r0

DrawAlternateIcon:
push {r4,r5,lr}
mov r4,r0
ldr r0, =0x2026A50
lsl r1,r4,#2
add r5,r1,r0
ldrb r0, [r5,#1]
cmp r0, #0
beq DrawAlternateIcon.new
ldrb r0, [r5]
cmp r0, #0xfe
bhi DrawAlternateIcon.got
add r0, #1
strb r0, [r5]
b DrawAlternateIcon.got
DrawAlternateIcon.new:
add r0, #1
strb r0, [r5]
mov r0, r4
blh 0x8004D91 @ GetIconGfxIndex
add r0, #1
strb r0, [r5,#1]
lsl r4, #7
ldr r0, IconGraphic
add r4, r0
ldrb r0, [r5,#1]
blh 0x8004D7D @ GetIconGfxTileIndex
mov r1,r0
lsl r1, #0x10
lsr r1, #0xb
mov r2, #0xc0
lsl r2, #0x13
ldr r0, =0x1ffe0
and r1, r0
add r1, r2
mov r0, r4
mov r2, #0x80
blh 0x8003079 @ TileTransferInfoAdd
DrawAlternateIcon.got:
ldrb r0, [r5, #1]
blh 0x8004D7D
pop {r4-r5}
pop {r1}
bx r1

	.pool
	.align
IconGraphic:
	@ POIN SkillIcons
