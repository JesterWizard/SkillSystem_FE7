@ Hooked at 0x6256C (aligned).
@ Nulls [DamageMoji+0x60] pointer to subAnimeEmulator
@ procstate when subAnimeEmulator proc gets killed.
@ BAN_KillDigits uses this NULLed pointer so it won't
@ kill [DamageMoji+0x60] which can otherwise be a
@ re-allocated procstate (an unrelated procstate).
@
@ Overwrites: ldr r0,[r4,#0x60] ; bl Proc_End ; mov r0,r4
@ Plus two NOPs wipe bl Proc_Break. Continues at pop (0x62578).
.thumb

ldr   r0, [r4, #0x60]
ldr   r3, =Proc_End
bl    GOTO_R3

mov   r0, #0x0
str   r0, [r4, #0x60]         @ NULL [DamageMoji+0x60], pointer to subAnimeEmulator procstate.

mov   r0, r4
ldr   r3, =Proc_Break
bl    GOTO_R3

ldr   r3, =0x08062579
GOTO_R3:
bx    r3
