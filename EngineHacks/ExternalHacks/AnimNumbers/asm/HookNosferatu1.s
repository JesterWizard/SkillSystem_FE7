@ Hooked at 0x4D86C. Displays numbers for damage dealt by Nosferatu. Args:
@   r0: Recipient's AIS.
.thumb

push  {r4-r6, r14}
mov   r4, r0


@ Recipient's AIS.
mov   r1, #0x0
mov   r2, #0x0
mov   r3, #0x0
bl    BAN_DisplayDamage


@ Vanilla. Overwritten by jumpToHack.
ldr   r1, =0x02017728      @ gBattleAnimeCounter
ldr   r0, [r1]
ldr   r3, =0x0804D875
GOTO_R3:
bx    r3
