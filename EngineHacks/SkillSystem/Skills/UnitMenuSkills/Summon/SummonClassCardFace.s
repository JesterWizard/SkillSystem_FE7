.thumb
.align

@ ============================================================================
@ Let the sprite face proc draw a class card
@
@ The weapon-select screen (MenuDef9_NormalEffect, 0x08021AE4) draws the active
@ unit's portrait with NewFace.  NewFace only records the portrait table entry
@ on the face proc (proc+0x2C); the graphics are loaded one frame later by the
@ proc's first script command, 0x08006B9C in scripts 0x08B907C0 / 0x08B907F8:
@
@     entry = proc[0x2C]
@     UnLZ77Decompress(entry[0x00], OBJ VRAM + slot offset)
@
@ entry[0x00] is the MUG graphics pointer, and for a class card it is NULL.
@ Portrait entries are 0x1C bytes (0x08006B20 computes base + id*28); a class
@ card carries its PALETTE at +0x08 and its GRAPHICS at +0x10, leaving the two
@ mug pointers at +0x00 and +0x04 zero.  Every vanilla class card 0xBE..0xE3
@ has that shape -- Fire Dragon's 0xDE is +00=0, +08=0x08BE9D9C, +10=0x08BE9DBC.
@
@ So the summon's class card sends UnLZ77Decompress a null source.  On hardware
@ that read is open bus, the LZ77 header is garbage, and it writes an arbitrary
@ length into VRAM: the weapon-select crash.
@
@ Vanilla already knows the convention and branches on it everywhere it draws a
@ class card properly -- DisplayBgFaceCore (0x080072D0) does
@
@     if (entry[0x00]) UnLZ77Decompress(entry[0x00], ...)   // mug
@     else             UnLZ77Decompress(entry[0x10], ...)   // class card
@
@ and the stat screen at 0x080811E4 uses the same `entry[0x00] == 0` test to
@ pick the class-card palette.  Only the SPRITE face path, this routine, was
@ never given the branch.  Adding it is what "use the class card" means: same
@ call, same destination, the pointer vanilla itself reads for a class card.
@
@ This fixes every NewFace site at once (weapon select, trade, item use), not
@ just the summon, and is a no-op for any unit that has a real mug.
@ ============================================================================

.equ gFaceGfxData,       0x0202A58C
.equ FaceObjVramBase,    0x06010000
.equ UnLZ77Decompress,   0x08013169

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.global SummonClassCardFace
.type   SummonClassCardFace, %function

SummonClassCardFace:
	push {r4,lr}
	mov r4,r0                   @ the face proc

	ldr r1,[r4,#0x2C]           @ portrait table entry
	ldr r2,[r1,#0]              @ mug graphics
	cmp r2,#0
	bne SummonClassCardFace_Load
	ldr r2,[r1,#0x10]           @ class card graphics
	cmp r2,#0
	beq SummonClassCardFace_Ret @ neither: draw nothing rather than from null

SummonClassCardFace_Load:
	ldr r1,=gFaceGfxData
	mov r0,#0x40
	ldrb r0,[r4,r0]             @ which of the four face slots this proc owns
	lsl r0,#3
	add r0,r1
	ldr r1,[r0,#0]              @ that slot's OBJ VRAM offset
	ldr r0,=FaceObjVramBase
	add r1,r0
	mov r0,r2
	blh UnLZ77Decompress

SummonClassCardFace_Ret:
	pop {r4}
	pop {r0}
	bx r0

.align
.ltorg
