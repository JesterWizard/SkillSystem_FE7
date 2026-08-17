.thumb
.org 0x0

@ FE7 jumpToHack at 0x2860C (InitBattleUnit).
@ Vanilla was: strb Def; Mag; Luk into battle unit.
@ Mag at unit+0x47.

strb	r0, [r5, #0x17]
ldr		r0, Mag_Getter
mov		r14, r0
mov		r0, r6
.short	0xF800
mov		r1, r5
add		r1, #0x47
strb	r0, [r1]
ldr		r0, Luk_Getter
mov		r14, r0
mov		r0, r6
.short	0xF800
strb	r0, [r5, #0x19]
mov		r0, r6
ldr		r1, ReturnAddr
bx		r1

.align
Luk_Getter:
.long 0x08018BB9
ReturnAddr:
.long 0x08028617
Mag_Getter:
@ POIN MagGetter
