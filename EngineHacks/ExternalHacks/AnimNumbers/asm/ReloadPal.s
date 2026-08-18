@ Hooked at 0x62524 (callHack_r3).
@ Re-loads the Miss/NoDamage palette.
@ r0 holds AISSubjectID.
.thumb

push  {r14}

@ Vanilla, arg to StartEkrSubAnimeEmulator.
str   r2, [sp, #0x4]

mov   r3, r0               @ AISSubjectId (selects blue variant)
ldr   r0, =0x081D9330      @ Blue palette (FE7)
lsl   r2, r3, #0x5
add   r0, r2               @ source: left/right blue variant

@ Digits use OBJ pal 1 — keep miss flash on the same slot.
ldr   r1, =gPaletteBuffer+0x220
mov   r2, #0x8
swi   #0xC                 @ CpuFastSet

ldr   r3, =EnablePaletteSync
bl    GOTO_R3

@ Vanilla stuff overwritten by hook.
@ These prepare args to a StartEkrSubAnimeEmulator call.
mov   r1, #0x2
ldsh  r0, [r5, r1]
mov   r3, #0x4
ldsh  r1, [r5, r3]
sub   r1, #0x28

pop   {r3}
GOTO_R3:
bx    r3
