.thumb

@ FE7 StatScreen_Init at 08081132 (12-byte trampoline; vanilla BL is overwritten).
@ Apply window palettes by allegiance, then return to 0808113E.

ldr   r0, StatScreen
ldr   r0, [r0, #0xC]
cmp   r0, #0
beq   TryMap
ldrb  r0, [r0, #0xB]
b     CheckAlleg

TryMap:
ldr   r2, CursorPos
ldrh  r0, [r2]
ldrh  r1, [r2, #2]
bl    GetUnitFromCoords
cmp   r0, #0
bne   CheckAlleg
ldr   r0, ActiveUnitId
ldrb  r0, [r0]

CheckAlleg:
mov   r1, #0xC0
and   r1, r0
lsr   r1, r1, #6
mov   r2, #3
and   r1, r2
adr   r2, IndexLut
ldrb  r1, [r2, r1]
ldr   r0, PalTable
lsl   r1, r1, #2
ldr   r0, [r0, r1]

push  {r4, lr}
mov   r4, r0
mov   r1, #0x20
bl    ApplyPal
mov   r0, r4
mov   r1, #0x12
lsl   r1, r1, #5
bl    ApplyPal
mov   r0, r4
mov   r1, #0xD0
lsl   r1, r1, #2
bl    ApplyPal
pop   {r4}
pop   {r3}
mov   lr, r3
ldr   r3, ReturnAddr
bx    r3

ApplyPal:
mov   r2, #0x20
ldr   r3, CopyPal
bx    r3

GetUnitFromCoords:
ldr   r2, UnitMap
ldr   r2, [r2]
lsl   r1, r1, #2
add   r1, r2
ldr   r1, [r1]
ldrb  r0, [r1, r0]
bx    lr

.align 2
IndexLut:
.byte 0, 3, 1, 2
.align 2
StatScreen:
.long 0x0200310C
CursorPos:
.long 0x0202BBCC
ActiveUnitId:
.long 0x0202BD48
PalTable:
.long 0x08B9A830
UnitMap:
.long 0x0202E3DC
CopyPal:
.long 0x08001085
ReturnAddr:
.long 0x0808113F
