.thumb
.include "mss_defs.s"

.global MSS_page3
.type MSS_page3, %function


MSS_page3:

page_start

@ Vanilla page 3 (08080424): 083FCB30 onto page BG1 with overlay 0x1000.
@ SSS_PageWepSupportTSA is FE6 and leaves a garbled divider under the 2x2 ranks.
ldr     r0, =#0x83FCB30
ldr     r4, =gGenericBuffer
mov     r1, r4
blh     Decompress
ldr     r0, =#0x200373C
mov     r2, #0x80
lsl     r2, r2, #0x5
mov     r1, r4
blh     BgMap_ApplyTsa

mov r0, r8
blh      MagCheck
cmp     r0,#0x0
beq     NotMag
draw_weapon_rank_at 1, 1, Anima, 0
draw_weapon_rank_at 1, 3, Light, 1
draw_weapon_rank_at 9, 1, Dark, 2
draw_weapon_rank_at 9, 3, Staff, 3
b       EndRanks
.ltorg

NotMag:
draw_weapon_rank_at 1, 1, Sword, 0
draw_weapon_rank_at 1, 3, Lance, 1
draw_weapon_rank_at 9, 1, Axe, 2
draw_weapon_rank_at 9, 3, Bow, 3

EndRanks:

blh      DrawSupports

page_end
