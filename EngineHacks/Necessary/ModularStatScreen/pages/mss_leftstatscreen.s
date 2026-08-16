.thumb
@draws the left panel of the stat screen
.include "mss_defs.s"

.global MSS_leftpage
.type MSS_leftpage, %function


MSS_leftpage:

leftpage_start
bl RestoreVanillaLeftWindow

draw_character_name_at 4,10
draw_class_name_at 1,13

draw_lv_icon_at 1, 15
draw_level_at 4, 15

draw_exp_icon_at 5, 15
draw_exp_at 7, 15

draw_hp_icon_at 1, 17
draw_ui_slash_at 5, 17
draw_hp_at 4, 17
draw_max_hp 7, 17

ldr r0,=#0x442
bl HP_Name_Color


page_end

@ Vanilla statscreen init (080810E4) puts 083FC9FC on BG1. That is the
@ parchment behind LV/E/HP. Re-apply it here; do not use the FE6 portrait box.
.global RestoreVanillaLeftWindow
.type RestoreVanillaLeftWindow, %function
RestoreVanillaLeftWindow:
  push {r4,lr}
  ldr r0, =0x083FC9FC
  ldr r4, =gGenericBuffer
  mov r1, r4
  blh Decompress
  ldr r0, =0x02023460
  mov r2, #0x80
  lsl r2, r2, #5
  mov r1, r4
  blh BgMap_ApplyTsa
  mov r0, #2
  ldr r1, =0x08000FFC+1
  mov lr, r1
  .short 0xF800
  pop {r4}
  pop {r0}
  bx r0
  .align
  .ltorg
