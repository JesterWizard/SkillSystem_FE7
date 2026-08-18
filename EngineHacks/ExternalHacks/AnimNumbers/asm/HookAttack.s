@ Hooked at 0x4D5A4. Displays numbers for most attacks. Args:
@   r0: Recipient's AIS. Can be initiator if devil effect.
.thumb

push  {r4-r6, r14}
mov   r4, r0


@ FE7 BattleHit has a single hpChange field. Showing on the
@ opposing AIS too (FE8 Sol/Counter path) duplicates the same
@ value on both sides — only display on the HP-bar recipient.
mov   r1, #0x0
mov   r2, #0x0
mov   r3, #0x0
bl    BAN_DisplayDamage


@ Vanilla. Overwritten by jumpToHack (push/mov/ldr counter/ldr [r1]).
ldr   r1, =0x02017728      @ gBattleAnimeCounter / gEkrHpBarCount
ldr   r0, [r1]
ldr   r3, =0x0804D5AD
GOTO_R3:
bx    r3
