.thumb
.org 0x0

@ Hooked from 08081414 via callHack_r3 (StatScreen_BackUpStatus).
@ Vanilla leftover after the 12-byte hook:
@   strb r1, [r3, #0x14]  @ chapterStateBits — r3 must stay ChapterData
@   ldr  r0, [r2, #0xC]   @ unit* — r2 must be StatScreenStruct
@   ldrb r0, [r0, #0xB]
@   strb r0, [gStatScreenInfo]  @ last viewed unit; used to restore map cursor
@ FE8 Store_Page loaded StatScreen into r3 and clobbered r2, so the leftover
@ saved unit id 0 and the cursor jumped to 0,0 on exit.

and		r1, r0
ldr		r2, StatScreenStruct
sub		r0, r2, #0x1
ldrb	r0, [r0]
ldr		r4, RamLocation
strb	r0, [r4]
ldrb	r0, [r2]
mov		r4, #0x3
and		r0, r4
orr		r1, r0
bx		r14

.align
StatScreenStruct:
.long 0x0200310C //FE8 -> 0x02003BFC
RamLocation:
