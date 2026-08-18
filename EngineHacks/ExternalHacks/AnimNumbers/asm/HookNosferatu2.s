@ Hooked at 0x4DA24 (aligned). Displays numbers for HP healed by Nosferatu.
@ Overwrites: ldr r0,[r6,#0x5C] ; bl GetAnimPosition ; lsl r0,#1
@ Continues at add r0,r4 (0x4DA2C).
.thumb

ldr   r0, [r6, #0x5C]
mov   r5, r0


@ Attacker's AIS. r1=2 → heal style (green "+").
mov   r1, #0x2
mov   r2, #0x0
mov   r3, #0x0
bl    BAN_DisplayDamage


@ Vanilla. Overwritten by jumpToHack.
mov   r0, r5
ldr   r3, =GetAnimPosition
bl    GOTO_R3
lsl   r0, #0x1
ldr   r3, =0x0804DA2D
GOTO_R3:
bx    r3
