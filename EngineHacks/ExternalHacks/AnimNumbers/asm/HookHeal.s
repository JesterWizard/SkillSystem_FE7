@ Hooked at 0x4DC98. Displays numbers for heals. Args:
@   r0: Recipient's AIS.
.thumb

push  {r4-r7, r14}
mov   r7, r0


@ Recipient only (FE7 has no LiveToServe opposing-heal path here).
@ r1=2 → heal style (green "+").
mov   r1, #0x2
mov   r2, #0x0
mov   r3, #0x0
bl    BAN_DisplayDamage


@ Vanilla. Overwritten by jumpToHack.
ldr   r1, =0x02017728      @ gBattleAnimeCounter
ldr   r0, [r1]
ldr   r3, =0x0804DCA1
GOTO_R3:
bx    r3
