@graphics and text
.equ CopyToPaletteBuffer, 0x08001084 //FE8 -> 0x08000DB8 not sure if this is correct for FE7
.equ _ResetIconGraphics, 0x08004CF4 //FE8 -> 0x08003578
.equ DrawIcon, 0x08004E28 //FE8 -> 0x080036BC
.equ Text_InitFont, 0x080053B0 //FE8 -> 0x08003C94 not sure if this is correct for FE7
.equ Text_GetColorID, 0x08005584 //FE8 -> 0x08003E64
.equ Text_Display, 0x08005590 //FE8 -> 0x08003E70
.equ Text_GetStringTextWidth, 0x080055FC //FE8 -> 0x08003EDC
.equ Text_GetStringTextCenteredPos, 0x080056A8 //FE8 -> 0x08003F90
.equ Text_DrawString, 0x08005718 //FE8 -> 0x08004004
.equ DrawTextInline, 0x08005AD4  //FE8 -> 0x0800443C
.equ Text_InsertString, 0x08005B18 //FE8 -> 0x08004480
.equ DrawSpecialUiChar, 0x0800615C //FE8 -> 0x08004B0C
.equ DrawDecNumber, 0x080061E4 //FE8 -> 0x08004B94
.equ DrawUiSmallNumber, 0x08006234 //FE8 -> 0x08004BE4
.equ DrawStatScreenBonusNumber, 0x08006240 //FE8 -> 0x08004BF0
.equ DrawLargeFont, 0x080063AC //FE8 -> 0x08004D5C
.equ String_GetFromIndex, 0x08012C60 //FE8 -> 0x0800A240
.equ String_ExpandTactName, 0x08012CBC //FE8 -> 0x0800A3B8 not sure if this is correct for FE7

@Menus and boxes
.equ FillBgMap, 0x08001810 //FE8 -> 0x08001220
.equ Decompress, 0x08013168 //FE8 -> 0x08012F50
.equ LoadNewUIPal, 0x08049A94 //FE8 -> 0x0804E0A8
.equ MakeUIWindowTileMap_BG0BG1, 0x08049CE4 //FE8 -> 0x0804E368 not sure if this is correct for FE7
.equ MovingMapSprite_CreateForUI, 0x0806BA88 //FE8 -> 0x080784F4
.equ MovingMapSprite_EndAll, 0x0806CCB8  //FE8 -> 0x080790A4
.equ BgMap_ApplyTsa, 0x080C57B4 //FE8 -> 0x080D74A0
.equ BgMapFillRect, 0x080C57CC //FE8 -> 0x080D74B8

@getters
.equ UnitHasMagicRank, 0x080184DC //FE8 -> 0x08018A58
.equ MountedIconHelper, 0x08018578 //FE8 0x08018578
.equ MagCheck, 0x080184DC //FE8 -> 0x8018A58  this is the same as UnitHasMagicRank, I guess whoever set it up missed that?
.equ AidCheck, 0x08018450 //FE8 -> 0x080189B8
.equ CurHPGetter, 0x08018A70 //FE8 -> 0x08019150
.equ MaxHPGetter, 0x08018AB0 //FE8 -> 0x08019190       
.equ StrGetter, 0x08018AD0 //FE8 -> 0x080191b0
.equ MagGetter, 0x08018AD8 // Mag modular getter (USE_STRMAG_SPLIT); FE8 was 0x080191b8
.equ SklGetter, 0x08018AF0 //FE8 -> 0x080191d0
.equ SpdGetter, 0x08018B30 //FE8 -> 0x08019210
.equ LuckGetter, 0x08018BB8 //FE8 -> 0x08019298
.equ DefGetter, 0x08018B70 //FE8 -> 0x08019250
.equ ResGetter, 0x08018B90 //FE8 -> 0x08019270
.equ MagConGetter, 0x08018BA4 //FE8 -> 0x08019284 @defined in the modularstatgetter
.equ MovGetter, 0x08018B44 //FE8 -> 0x08019224 @defined in the modularstatgetter
.equ AffinityGetter, 0x08026B24 //FE8 -> 0x080286BC not sure if this will work since it's missing the push opcode that FE8 has
.equ EquippedWeaponGetter, 0x08016764 //FE8 -> 0x08016B28
.equ EquippedItemSlotGetter, 0x08016794 //FE8 -> 0x08016B58
.equ GetItemRangeString, 0x080168AC //FE8 -> 0x08016CC0
.equ IsItemUsable, 0x08016AB0 //FE8 -> 0x08016EE4
.equ ItemWeightGetter, 0x08017310 //FE8 -> 0x0801760C
.equ GetUnitItemCount, 0x080176DA //FE8 -> 0x080179D8 not sure if this is right for FE7 on account of the fact it starts on a bx opcode instead of a push like FE8
.equ SetupBattleStructFromUnitAndWeapon, 0x0802848C //FE8 -> 0x0802A400
.equ GetBallistaItemAt, 0x080346C8 //FE8 -> 0x0803798C
.equ CheckGameLinkArenaBit, 0x0803DA14 //FE8 -> 0x08042E98

@Statscreen-specific stuff
.equ DrawItemOnStatscreen, 0x08016668 //FE8 -> 0x08016A2C
.equ WriteTrvText, 0x08018CC0 //FE8 -> 0x080193E8
.equ WriteStatusText, 0x08018CF0 //FE8 -> 0x08019414
.equ Statscreen_ClearBuffer, 0x0807FA38 //FE8 -> 0x08086DF0 @clears 2003c00 region
.equ DrawStatscreenTextMap, 0x0807FA48 //FE8 -> 0x08086E00
.equ Statscreen_StartLeftPanel, 0x0807FA8C //FE8 -> 0x08086E44
.equ DrawBWLNumbers, 0x0807FBF0 //FE8 -> 0x08086FAC
.equ DrawBar, 0x0807FD28 //FE8 -> 0x080870BC
.equ DrawSupports, 0x08080270 //FE8 -> 0x08087698
.equ DrawWeaponRank, 0x08080360 //FE8 -> 0x08087788

@RAM
.equ gActiveBattleUnit, 0x203A3F0 //FE8 -> 0x203A4EC
.equ StatScreenStruct, 0x200310C //FE8 -> 0x2003BFC
.equ BgBitfield, 0x300000C //FE8 -> 0x300000D not sure if this is right for FE7
.equ TileBufferBase, 0x200313C //FE8 -> 0x2003C2C
.equ tile_origin, 0x020031A4 //FE8 -> 0x2003C94
.equ gpStatScreenPageBg0Map, 0x200323C //FE8 -> 0x2003D2C
.equ gpStatScreenPageBg1Map, 0x200373C //FE8 -> 0x200422C
.equ gpStatScreenPageBg2Map, 0x2003C3C //FE8 -> 0x200472C
.equ gGenericBuffer, 0x2020140 //FE8 -> 0x2020188
.equ gBg0MapBuffer, 0x2022C60 //FE8 -> 0x2022CA8
.equ gCurrentTextString, 0x202A5B4 //FE8 -> 0x202A6AC 
.equ Const_2022D40, 0x2022CF8 //FE8 -> 0x2022D40  @ BG0 screen (vanilla 08081268)
@ Growth-toggle refresh copies BG2 page → BG2 screen. FE8's 0x2023D40 is BG2;
@ FE7 BG2 screen is 0x2023CF8. 0x20234F8 is BG1 (page frame) — writing there
@ erases the personal-data container on Select.
.equ Const_2023D40, 0x2023CF8 //FE8 -> 0x2023D40  @ BG2 screen (vanilla 08081278)
.equ Const_2003D2C, 0x200323C //FE8 -> 0x2003D2C  @ BG0 page buffer
.equ Const_200472C, 0x2003C3C //FE8 -> 0x200472C  @ BG2 page buffer

@With this in mind, any unlabeled RAM addresses beginning with 0x200 can reasonably be assumed to be offsets within the tilemap

@Colours
.equ Green, 4
.equ Yellow, 3
.equ Blue, 2
.equ Grey, 1
.equ White, 0

@ FE7 stat-screen labels. FE8 0x4Ex/0x4Fx IDs are character names in FE7.
.equ TID_HP,    0x10F4
.equ TID_Str,   0x10F8
.equ TID_Mag,   0x10F9
.equ TID_Skl,   0x10FB
.equ TID_Spd,   0x10FC
.equ TID_Luck,  0x10FD
.equ TID_Def,   0x10FE
.equ TID_Res,   0x10FF
.equ TID_Affin, 0x1100
.equ TID_Move,  0x1106
.equ TID_Con,   0x1107
.equ TID_Aid,   0x1108
.equ TID_Trv,   0x1109
.equ TID_Cond,  0x110A

@Hardcoded classIDs (Gorgon Eggs)
.equ Deny_Statscreen_Class_Lo, 0x34
.equ Deny_Statscreen_Class_Hi, 0x62

.macro blh to, reg=r3
  push   {\reg}
  ldr    \reg, =\to
  mov    lr, \reg
  pop    {\reg}
  .short 0xf800
.endm

.macro blm to, from=origin
  .equ   func_\to, . + \to - \from
  bl     func_\to
.endm

@08087184
.macro page_start
  push    {r4-r7, r14}
  mov     r7, r8
  push    {r7}
  add     sp, #-0x50     
  ldr     r7, =TileBufferBase     @r7 contains the latest buffer. starts at 2003c2c.
  ldr     r5, =StatScreenStruct
  ldr     r0, [r5, #0xC]
  mov     r8, r0                  @r8 contains the current unit's data
  clear_buffers
  ldr     r0, =SSS_Flag
  ldr     r0, [r0]
  cmp     r0, #0x0                  @ If no Scrolling StatScreen, no TSA unpackaging.
  beq     PageStartEnd
    ldr     r0, =StatScreenStruct   @Update PageTSA. TODO make depend on condition SSS is defined!
    ldrb    r0, [r0]                @r0 contains current pagenumber.
    lsl     r0, #0x2
    ldr     r1, =SSS_PageTSATable
    ldr     r0, [r0, r1]            @pointer to TSA for right page.
    ldr     r1, =gGenericBuffer
    blh     Decompress
    ldr     r0, =gpStatScreenPageBg1Map
    ldr     r1, =gGenericBuffer
    mov     r2, #0x0
    blh     BgMap_ApplyTsa          @ Apply right page tsa.
    ldr     r0, =SSS_StatsBoxGfx    @ Restore FE6 box tiles after the items page overwrites them.
    ldr     r1, =#0x6004E00
    blh     Decompress
  PageStartEnd:
.endm

.macro page_end
  add     sp, #0x50   
  pop     {r7}
  mov     r8, r7
  pop     {r4-r7}
  pop     {r0}
  bx      r0 
.endm

.macro draw_textID_at tile_x, tile_y, textID=0, width=3, colour=3, growth_func=-1        @growth func is # of growth getter in growth_getters_table; 0=hp, 1=str, 2=skl, etc
  mov r3, r7
  mov r1, #\width
  @r3 is current buffer location, r1 is width.
  ldrh r2, [r3] @current number
  add r2, r1 @for the next one.
  strb r1, [r3, #4] @store width
  strb r2, [r3, #8] @assign the next one.
  .if \textID
    ldr r0, =\textID @otherwise assume it's in r0
  .endif
  blh String_GetFromIndex
  mov r2, #0x0
  str r2, [sp]
  str r0, [sp, #4]
  mov r2, #\colour @colour
  .ifge \growth_func
  ldr r1, [sp, #0xC]            @growth getters table
  mov r0, #\growth_func-1
  lsl r0, #2
  ldr r1, [r1, r0]            @relevant growth getter function
  mov r0, r8
  mov r14, r1
  .short 0xF800                @returns growth
  mov r1, sp
  add r1, #0x18
  ldr r2, [sp, #0x14]            @growth options word and'd with 0x10, so non-zero if stat name color should reflect growth
  ldr r3, =Get_Palette_Index
  mov r14, r3
  .short 0xF800    @given growth, returns palette index, and does some shenanigans
  mov r2, r0
  .endif
  mov r0, r7
  ldr r1, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
  mov r3, #0
  blh DrawTextInline, r4
  .ifge \growth_func
  ldr r1, [sp, #0x14]
  ldr r0, [sp, #0x18]
  bl  Restore_Palette        @see that func for an explanation (mss_page1_skills)
  .endif
  add r7, #8
.endm

.macro draw_buffered_text, tile_x, tile_y, width=10, colour=3
  mov r0, sp
  mov r1, #\width
  str r1, [r0]
  mov r0, #0
  ldr r1, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
  mov r2, #\colour
  mov r3, #0
  blh DrawTextInline, r4
  bl  Restore_Palette
.endm

.macro draw_skillname_at tile_x, tile_y, textID=0, width=14, colour=3, growth_func=-1        @growth func is # of growth getter in growth_getters_table; 0=hp, 1=str, 2=skl, etc
  mov r3, r7
  mov r1, #\width
  @r3 is current buffer location, r1 is width.
  ldrh r2, [r3] @current number
  add r2, r1 @for the next one.
  strb r1, [r3, #4] @store width
  strb r2, [r3, #8] @assign the next one.
  .if \textID
    ldr r0, =#\textID @otherwise assume it's in r0
  .endif
  blh String_GetFromIndex
  bl GetSkillNameFromSkillDesc
  mov r2, #0x0
  str r2, [sp]
  str r0, [sp, #4]
  mov r2, #\colour @colour
  .ifge \growth_func
  ldr r1, [sp, #0xC]            @growth getters table
  mov r0, #\growth_func-1
  lsl r0, #2
  ldr r1, [r1, r0]            @relevant growth getter function
  mov r0, r8
  mov r14, r1
  .short 0xF800                @returns growth
  mov r1, sp
  add r1, #0x18
  ldr r2, [sp, #0x14]            @growth options word and'd with 0x10, so non-zero if stat name color should reflect growth
  .set pal_index, (Get_Palette_Index - . - 6)
  ldr r3, =pal_index
  add r3, pc
  ldr r3, [r3]
  mov r14, r3
  .short 0xF800    @given growth, returns palette index, and does some shenanigans
  mov r2, r0
  .endif
  mov r0, r7
  ldr r1, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
  mov r3, #0
  blh DrawTextInline, r4
  .ifge \growth_func
  ldr r1, [sp, #0x14]
  ldr r0, [sp, #0x18]
  bl  Restore_Palette        @see that func for an explanation (mss_page1_skills)
  .endif
  add     r7, #8
.endm
 
.macro draw_bar_at bar_x, bar_y, getter, offset, bar_id
  mov     r0, r8
  blh     \getter
  mov     r1, r8  
  mov     r3, #\offset
  ldsb    r3, [r1, r3]     
  str     r0, [sp]     
  ldr     r0, [r1, #0x4]  @class
  ldrb    r0, [r0, #\offset]  @stat cap
  lsl     r0, r0, #0x18    
  asr     r0, r0, #0x18    
  str     r0, [sp, #0x4]    
  mov     r0, #(\bar_id)     
  mov     r1, #(\bar_x-11)
  mov     r2, #(\bar_y-2)
  blh     DrawBar, r4
.endm

.macro draw_bar_at_with_cap_getter bar_x, bar_y, statgetter, capgetter, offset, bar_id  
  mov     r0, r8
  blh     \statgetter
  mov     r1, r8  
  mov     r3, #\offset
  ldsb    r3, [r1, r3]     
  str     r0, [sp]     
  ldr     r0, [r1, #0x4]  @class
  ldrb    r0, [r0, #0x4]  @class id
  blh     \capgetter
  lsl     r0, r0, #0x18    
  asr     r0, r0, #0x18    
  str     r0, [sp, #0x4]    
  mov     r0, #(\bar_id)     
  mov     r1, #(\bar_x-11)
  mov     r2, #(\bar_y-2)
  blh     DrawBar, r4
.endm

.macro draw_halved_bar_at bar_x, bar_y, getter, offset, bar_id
  mov     r0, r8
  blh     \getter
  mov     r1, r8  
  mov     r3, #\offset
  ldsb    r3, [r1, r3]   @base stat
  asr     r3, #1
  str     r0, [sp]     
  ldr     r0, [r1, #0x4]  @class
  ldrb    r0, [r0, #\offset]  @stat cap
  lsl     r0, r0, #0x18    
  asr     r0, r0, #0x19   @divided by 2    
  str     r0, [sp, #0x4]    
  mov     r0, #(\bar_id)     
  mov     r1, #(\bar_x-11)
  mov     r2, #(\bar_y-2)
  blh     DrawBar, r4
.endm

.macro draw_str_bar_at, bar_x, bar_y
  draw_bar_at \bar_x, \bar_y, StrGetter, 0x14, 0
.endm

.macro draw_mag_bar_at, bar_x, bar_y
  @ Vanilla FE7 has no mag byte; MagDisplayGetter returns Pow for magic ranks, else 0.
  mov     r0, r8
  blh     MagDisplayGetter
  mov     r3, r0
  str     r0, [sp]
  mov     r0, #0x1e
  str     r0, [sp, #0x4]
  mov     r0, #0x1
  mov     r1, #(\bar_x-11)
  mov     r2, #(\bar_y-2)
  blh     DrawBar, r4
.endm

.macro draw_skl_bar_at, bar_x, bar_y
  draw_bar_at \bar_x, \bar_y, SklGetter, 0x15, 2
.endm

.macro draw_skl_reduced_bar_at, bar_x, bar_y @for rescuing
  draw_halved_bar_at \bar_x, \bar_y, SklGetter, 0x15, 2
.endm

.macro draw_spd_bar_at, bar_x, bar_y
  draw_bar_at \bar_x, \bar_y, SpdGetter, 0x16, 3
.endm

.macro draw_spd_reduced_bar_at, bar_x, bar_y @for rescuing
  draw_halved_bar_at \bar_x, \bar_y, SpdGetter, 0x16, 3
.endm

.macro draw_luck_bar_at, bar_x, bar_y
  mov     r0, r8
  blh     LuckGetter
  mov     r1, r8  
  mov     r3, #0x19
  ldsb    r3, [r1, r3]     
  str     r0, [sp]     
  mov     r0, #0x1e  @cap is always 30
  str     r0, [sp, #0x4]    
  mov     r0, #0x6   
  mov     r1, #(\bar_x-11)
  mov     r2, #(\bar_y-2)
  blh     DrawBar, r4
.endm

.macro draw_def_bar_at, bar_x, bar_y
  draw_bar_at \bar_x, \bar_y, DefGetter, 0x17, 4
.endm

.macro draw_res_bar_at, bar_x, bar_y
  draw_bar_at \bar_x, \bar_y, ResGetter, 0x18, 5
.endm

.macro draw_growth_at, bar_x, bar_y
  mov     r14, r0        @r0 = growth getter to bl to
  mov     r0, r8
  .short  0xF800        @returns total growth in r0, base growth in r1
  sub     r0, r0, r1    @difference between total and base
  str     r0, [sp, #0x10]
  mov     r2, r1        @base in r2
  mov     r1, #0x2        @palette index
  ldr     r0, =(tile_origin+(0x20*2*\bar_y)+(2*\bar_x))
  blh     DrawDecNumber
  ldr     r0, [sp, #0x10]    @difference from earlier
  ldr     r1, =(tile_origin+(0x20*2*\bar_y)+(2*(\bar_x+1)))
  blh     DrawStatScreenBonusNumber
.endm

.macro draw_move_bar_at, bar_x, bar_y
  mov     r1, r8
  @check AI
  mov     r3, #0x41
  ldrb    r3, [r1, r3] @AI byte 4
  cmp     r3, #0x20
  beq     NoMove
  mov     r3, #0x30
  ldrb    r3, [r1, r3] @status
  mov     r0, #0xF
  and     r3, r0
  cmp     r3, #0x9 @freeze status
  beq     NoMove
  ldr     r0, [r1, #0x4] @class
  mov     r3, #0x12     @move
  ldsb    r3, [r0, r3]  
  mov     r0, #0x1D     @bonus
  ldsb    r0, [r1, r0]   
  b       NormalMove
  
  NoMove:
  mov     r0, #0
  mov     r3, #1
  neg     r3, r3
  b       DrawMove
  
  NormalMove:
  DrawMove:
  add     r0, r0, r3     
  str     r0, [sp]     @r0 is total, r3 is base
  mov     r6, #0xF     
  str     r6, [sp, #0x4]
  mov     r0, #0x6      @why 6?
  mov     r1, #(\bar_x-11)
  mov     r2, #(\bar_y-2)   
  blh     DrawBar, r4
.endm

.macro draw_move_bar_with_getter_at, bar_x, bar_y
@base in r3, final in sp, cap in sp+4, call getter
  mov     r1, r8
  ldr     r0, [r1, #0x4] @class
  mov     r3, #0x12     @move
  ldsb    r3, [r0, r3]  
  @ mov     r0, #0x1D     @bonus
  @ ldsb    r0, [r1, r0]   
  @ add     r0, r0, r3    

  push    {r1-r3}
  mov     r0, r8
  blh     MovGetter
  pop     {r1-r3}
  cmp     r0, #0
  bne MoveNotNegated
    mvn     r0, r0
    mov     r3, r0
  MoveNotNegated:
  str     r0, [sp] @final
  mov     r6, #0xF
  str     r6, [sp, #4]
  mov     r0, #0x8    
  mov     r1, #(\bar_x-11)
  mov     r2, #(\bar_y-2)      
  blh     DrawBar, r4
.endm

.macro draw_move_number_at, tile_x, tile_y
  mov     r1, r8
  ldr     r0, [r1, #0x4] @class
  mov     r3, #0x12     @move
  ldsb    r3, [r0, r3]  
  mov     r0, #0x1D     @bonus
  ldsb    r0, [r1, r0]   
  cmp     r0, #0
  beq     MoveNotBoosted
  mov     r1, #Green
  b       FromMoveBoosted
  MoveNotBoosted:
  mov     r1, #Blue
  FromMoveBoosted:
  add     r0, r0, r3
  draw_number_at \tile_x, \tile_y
.endm

.macro draw_con_bar_at, bar_x, bar_y
  mov     r1, r8
  ldr     r0, [r1, #0x4]  @class
  mov     r3, #0x11      @con
  ldsb    r3, [r0, r3]   
  ldr     r0, [r1]      
  ldrb    r0, [r0, #0x13] @bonus
  lsl     r0, r0, #0x18  
  asr     r0, r0, #0x18  
  add     r3, r3, r0     
  mov     r0, #0x1A     
  ldsb    r0, [r1, r0]   
  add     r0, r3, r0     
  str     r0, [sp]      
  ldr     r0, [r1, #0x4] 
  ldrb    r0, [r0, #0x19]
  lsl     r0, r0, #0x18  
  asr     r0, r0, #0x18  
  str     r0, [sp, #0x4] 
  mov     r0, #0x7      
  mov     r1, #(\bar_x-11)
  mov     r2, #(\bar_y-2)      
  blh     DrawBar, r4
.endm

.macro draw_rating_at, tile_x, tile_y
  push    {r4}
  mov     r4, #0x0
  mov     r0, r8
  blh     MaxHPGetter
  add     r4, r4, r0
  mov     r0, r8
  blh     StrGetter
  add     r4, r4, r0
  mov     r0, r8
  blh     SklGetter
  add     r4, r4, r0
  mov     r0, r8
  blh     SpdGetter
  add     r4, r4, r0
  mov     r0, r8
  blh     LuckGetter
  add     r4, r4, r0
  mov     r0, r8
  blh     DefGetter
  add     r4, r4, r0
  mov     r0, r8
  blh     ResGetter
  add     r4, r4, r0
  mov     r0, r4
  pop     {r4}
  mov     r1, #Blue
  draw_number_at \tile_x, \tile_y
.endm

.macro draw_con_number_at, tile_x, tile_y
  mov     r1, r8
  ldr     r0, [r1, #0x4]  @class
  mov     r3, #0x11      @con
  ldsb    r3, [r0, r3]   
  ldr     r0, [r1]      
  ldrb    r0, [r0, #0x13] @bonus
  lsl     r0, r0, #0x18  
  asr     r0, r0, #0x18  
  add     r3, r3, r0     
  mov     r0, #0x1A     
  ldsb    r0, [r1, r0]   
  cmp     r0, #0
  beq     ConNotBoosted
  mov     r1, #Green
  b       FromConBoosted
  ConNotBoosted:
  mov     r1, #Blue
  FromConBoosted:
  add     r0, r0, r3
  draw_number_at \tile_x, \tile_y
.endm

.macro draw_con_bar_with_getter_at, bar_x, bar_y
@base in r3, final in sp, cap in sp+4, call getter
  mov     r1, r8
  ldr     r0, [r1, #0x4]  @class
  mov     r3, #0x11      @con
  ldsb    r3, [r0, r3]   
  ldr     r0, [r1]      
  ldrb    r0, [r0, #0x13] @bonus
  lsl     r0, r0, #0x18  
  asr     r0, r0, #0x18  
  add     r3, r3, r0     

  push    {r1-r3}
  mov     r0, r8
  blh     MagConGetter
  pop     {r1-r3}
  str     r0, [sp] @final
  ldr     r0, [r1, #0x4] 
  ldrb    r0, [r0, #0x19]
  lsl     r0, r0, #0x18  
  asr     r0, r0, #0x18  
  str     r0, [sp, #0x4]  @store cap
  mov     r0, #0x7      
  mov     r1, #(\bar_x-11)
  mov     r2, #(\bar_y-2)      
  blh     DrawBar, r4
.endm

.macro draw_number_at, num_x, num_y, routine=0, colour=2 @r0 is number and r1 is colour
  .if \routine
  mov     r0, r8
  blh \routine
  .endif
  mov     r1, #\colour @defaults to blue
  mov     r2, r0
  ldr     r0, =(tile_origin+(0x20*2*\num_y)+(2*\num_x))
  blh     DrawDecNumber
.endm

.macro draw_charge_at, num_x, num_y, colour=2 @r0 is number and r1 is colour
  mov     r0, r8
  mov     r1, #0x47
  ldrb    r0, [r0, r1]
  sub     r0, #0x10
  cmp     r0, #0x0
  beq     Greeny
  mov     r1, #0x2
  b       Naxty
  Greeny:
  mov     r1, #0x4
  Naxty:
  mov     r2, r0
  ldr     r0, =(tile_origin+(0x20*2*\num_y)+(2*\num_x))
  blh     DrawDecNumber
.endm

.macro draw_aid_icon_at tile_x, tile_y
  mov     r0, r8
  ldr     r1, [r0]
  ldr     r2, [r0, #4]
  ldr     r0, [r1, #0x28]
  ldr     r1, [r2, #0x28]
  orr     r0, r1
  blh     MountedIconHelper
  mov     r1, #3 @sheet ID
  lsl     r1, r1, #8 @shifted 8 bits left
  orr     r1, r0
  mov     r2, #0xA0
  lsl     r2, #7
  ldr     r0, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
  blh     DrawIcon
.endm

.macro draw_trv_text_at, tile_x, tile_y, colour=Blue
  draw_textID_at \tile_x, \tile_y, TID_Trv, width=9 @trv
  mov     r4, r7
  sub     r4, #8 @un-advance the buffer
  mov     r0, r8
  blh     WriteTrvText
  mov     r3, r0
  mov     r0, r4
  mov     r1, #0x18 @what is this?
  mov     r2, #\colour
  blh     Text_InsertString, r4
.endm

.macro draw_talk_text_at, tile_x, tile_y, colour=Blue
  draw_textID_at \tile_x, \tile_y, width=9 @ideally you want a diff id.
  blh     CheckGameLinkArenaBit, r4
  mov     r4, r7
  sub     r4, #8
  cmp     r0, #1
  beq     DidntFindAPerson
  mov     r0, r8
  ldr     r0, [r0]
  ldrb    r0, [r0, #0x4]    @char byte
  bl      GetTalkee
  cmp     r0, #0x0
  bne     FoundAPerson
  DidntFindAPerson:
  ldr     r1, =0x7f7f7f @---[X]
  ldr     r0, =gCurrentTextString
  str     r1, [r0]
  b       TextBuffered
  FoundAPerson:
  mov     r1, #0x34
  mul     r0, r1
  ldr     r1, =0x8017890 //FE8 -> 0x8017d64 @pointer to character table (in case repointed)
  ldr     r1, [r1]  @actual character table
  add     r0, r1
  ldrh    r0, [r0]
  ldr     r1, =String_GetFromIndex
  mov     r14, r1
  .short  0xF800
  TextBuffered:
  mov     r3, r0
  ldr     r0, =Text_InsertString
  mov     r14, r0
  mov     r0, r4
  @ add     r0, #0x90
  mov     r1, #0x18
  mov     r2, #\colour
  .short  0xF800
.endm

.macro rescue_check
  mov     r1, r8
  ldr     r0, [r1, #0xc] @status
  mov     r1, #0x10 @rescuing?
  and     r0, r1
.endm

.macro draw_status_text_at, tile_x, tile_y, colour=Blue  
  draw_textID_at \tile_x, \tile_y, TID_Cond, width=9 @cond
  mov     r4, r7
  sub     r4, #8
  mov     r1, r8  
  mov     r0, r1   
  blh     WriteStatusText
  mov     r3, r0     
  mov     r0, r4 
  mov     r1, #0x16        @16 if status, otherwise 18???
  mov     r2, #\colour   
  blh     Text_InsertString, r4
  mov     r1, r8
  add     r1, #0x30
  ldrb    r2, [r1]
  cmp     r2, #0
  beq     NoStatusCount
  ldr     r0, =(0x2003CA2+(0x20*2*\tile_y)+(2*\tile_x))
  lsr     r2, #4
  mov     r1, #0
  blh     DrawUiSmallNumber
  NoStatusCount:
.endm

.macro draw_affinity_icon_at, tile_x, tile_y
  ldr     r4, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
  mov     r0, r8
  blh     AffinityGetter
  @ FE7 AffinityGetter already returns item-icon index (affinity+0x79).
  @ IconRework sheet 2 is not installed; ORing 0x0200 makes DrawIcon garbage.
  mov     r1, r0
  mov     r2, #0xA0       
  lsl     r2, r2, #0x7      
  mov     r0, r4    
  blh     DrawIcon 
.endm

.macro draw_icon_at, tile_x, tile_y, number=0
  @assumes icon number in r0 or else in number
  .if \number
    mov     r0, #\number
  .endif
  ldr     r4, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
  mov     r1, r0      
  mov     r2, #0xA0       
  lsl     r2, r2, #0x7      
  mov     r0, r4    
  blh     DrawIcon 
.endm

.macro draw_stats_box showBallista=0
  @ Vanilla items page (080800BA): 083FCAC0 onto page BG1 with overlay 0x1000.
  @ SSS_StatsBoxTSA is the FE6 equipment box and does not cover item-name rows.
  @ "Equipment" is baked into 083FD62C at 0x6004E00. SSS_StatsBoxGfx replaces that.
  ldr     r0, =#0x83FD62C
  ldr     r1, =#0x6004E00
  blh     Decompress
  ldr     r0, =#0x83FCAC0
  ldr     r4, =gGenericBuffer
  mov     r1, r4
  blh     Decompress
  ldr     r0, =#0x200373C
  mov     r2, #0x80
  lsl     r2, r2, #0x5
  mov     r1, r4
  blh     BgMap_ApplyTsa
  ldr     r0, =#0x83FCE2C
  ldr     r4, =gGenericBuffer
  mov     r1, r4
  blh     Decompress
  ldr     r0, =#0x2003EFE
  ldr     r2, =#0x7060
  mov     r1, r4
  blh     BgMap_ApplyTsa
  ldr     r0, =#0x8404A60 //FE8 -> #0x8205A24     @map of text labels and positions
  blh     DrawStatscreenTextMap
  b       SS_AfterStatsBoxTsa
  .ltorg
  SS_AfterStatsBoxTsa:
  ldr     r6, =StatScreenStruct
  ldr     r0, [r6, #0xC]
  ldr     r0, [r0, #0x4]
  ldrb    r0, [r0, #0x4]
  cmp     r0, #Deny_Statscreen_Class_Hi
    beq     SS_DoneEquipHighlightBar
  cmp     r0, #Deny_Statscreen_Class_Lo
    beq     SS_DoneEquipHighlightBar
  
    .if \showBallista

        ldr     r2, [r6, #0xC]
        ldr     r0, [r2, #0xC]
        mov     r1, #0x80        
        lsl     r1, r1, #0x4        @Check "in ballista" bit
        and     r0, r1
        cmp     r0, #0x0
        beq     NoBallistaEquipped_Box
        
        @get a non-empty ballista at unit position
        mov     r0, #0x10
        mov     r1, #0x11
        ldsb    r0, [r2, r0]
        ldsb    r1, [r2, r1]
        blh     GetBallistaItemAt
        cmp     r0, #0x0
        beq     NoBallistaEquipped_Box
        mov     r5, r0
        mov     r4, #0x0             @slot id
        b       SS_DrawEquippedItemHighlight
        
    .endif
  
  NoBallistaEquipped_Box:
  ldr     r0, [r6, #0xC] 
  blh     EquippedItemSlotGetter
  mov     r4, r0
  mov     r5, #0x0
  cmp     r4, #0x0             @no equipped item will be -1
  blt     SS_DoneEquipHighlightBar
  
  SS_DrawEquippedItemHighlight:
  lsl     r4, r4, #0x1
  add     r0, r4, #1
  lsl     r0, r0, #0x6
  ldr     r1, =#0x200325C //FE8 -> #0x2003D4C
  add     r0, r0, r1
  mov     r1, #0x0
  mov     r2, #0x1F
  blh     DrawSpecialUiChar
  add     r0, r4, #2
  lsl     r0, r0, #0x6
  ldr     r1, =#0x2003C3E
  add     r0, r0, r1
  ldr     r1, =#0x83FCE68
  ldr     r2, =#0x7060
  blh     BgMap_ApplyTsa
  
  cmp     r5, #0x0
  bne     SS_DoneEquipHighlightBar
  
  SS_ItemBox_GetID:
  ldr     r0, [r6, #0xC]
  add     r0, #0x1E
  add     r0, r0, r4
  ldrh    r5, [r0]
  
  SS_DoneEquipHighlightBar:
  ldr     r0, =StatScreenStruct
  ldr     r0, [r0, #0xC]
  ldr     r0, [r0, #0x4]
  ldrb    r0, [r0, #0x4]
  cmp     r0, #Deny_Statscreen_Class_Hi
  beq     SS_DrawItemBox_Unarmed
  cmp     r0, #Deny_Statscreen_Class_Lo
  beq     SS_DrawItemBox_Unarmed
  
  ldr     r4, =#0x200358C //FE8 -> #0x200407C    @bgmap offset
  ldr     r6, =gActiveBattleUnit
  mov     r0, r6
  add     r0, #0x5A         @load battle atk
  mov     r1, #0x0
  ldsh    r2, [r0, r1]
  mov     r0, r4
  mov     r1, #0x2
  blh     DrawDecNumber
  mov     r0, r4
  add     r0, #0x80
  mov     r1, r6
  add     r1, #0x60         @load battle hit
  mov     r3, #0x0
  ldsh    r2, [r1, r3]
  mov     r1, #0x2
  blh     DrawDecNumber
  mov     r0, r4
  add     r0, #0xE
  mov     r1, r6
  add     r1, #0x66         @load battle crit
  mov     r3, #0x0
  ldsh    r2, [r1, r3]
  mov     r1, #0x2
  blh     DrawDecNumber
  add     r4, #0x8E
  mov     r0, r6
  add     r0, #0x62         @load battle avoid
  mov     r6, #0x0
  ldsh    r2, [r0, r6]
  mov     r0, r4
  mov     r1, #0x2
  blh     DrawDecNumber
  b       SS_DrawItemBox_RangeText
  
  SS_DrawItemBox_Unarmed:
  ldr     r4, =#0x200358C //FE8 -> #0x200407C
  mov     r0, r4
  mov     r1, #0x2
  mov     r2, #0xFF
  blh     DrawDecNumber
  mov     r0, r4
  add     r0, #0x80
  mov     r1, #0x2
  mov     r2, #0xFF
  blh     DrawDecNumber
  mov     r0, r4
  add     r0, #0xE
  mov     r1, #0x2
  mov     r2, #0xFF
  blh     DrawDecNumber
  add     r4, #0x8E
  ldr     r0, =gActiveBattleUnit
  add     r0, #0x62         @load battle avoid
  mov     r1, #0x0
  ldsh    r2, [r0, r1]
  mov     r0, r4
  mov     r1, #0x2
  blh     DrawDecNumber
  mov     r5, #0x0            @set item as blank
  
  SS_DrawItemBox_RangeText:
  mov     r0, r5
  blh     GetItemRangeString
  mov     r5, r0
  ldr     r4, =#0x20031C4
  blh     Text_GetStringTextWidth
  mov     r1, #0x2F
  sub     r1, r1, r0
  mov     r0, r4
  mov     r2, #0x2
  mov     r3, r5
  blh     Text_InsertString, r4
  mov     r4, #0x0
  ldr     r0, =#0x5278
  mov     r5, r0
  ldr     r2, =#0x200358C
  sub     r2, #0x8C
  ldr     r1, =#0x5270
  mov     r3, r1
  ldr     r1, =#0x200358C
  sub     r1, #0x4C
  
  loc_0x8087660:
  add     r0, r4, r5
  strh    r0, [r2]
  add     r0, r4, r3
  strh    r0, [r1]
  add     r2, #0x2
  add     r1, #0x2
  add     r4, #0x1
  cmp     r4, #0x7
  ble     loc_0x8087660
  
.endm

.macro draw_items_text showBallista=0
  push    {r7}
  mov     r7, r8
  push    {r7}
  ldr     r2, =StatScreenStruct
  ldr     r1, [r2, #0xC]
  ldr     r0, [r1, #0x4]
  ldrb    r0, [r0, #0x4]
  cmp     r0, #Deny_Statscreen_Class_Hi
  beq     GorgonEggSkip_ItemList
  cmp     r0, #Deny_Statscreen_Class_Lo
  beq     GorgonEggSkip_ItemList

  SS_StartItemsList:
  mov     r6, #0x40
  mov     r7, r2
  
  .if \showBallista

        ldr     r2, [r7, #0xC]
        ldr     r0, [r2, #0xC]
        mov     r1, #0x80        
        lsl     r1, r1, #0x4        @Check "in ballista" bit
        and     r0, r1
        cmp     r0, #0x0
        beq     NoBallistaEquipped
        
        @get a non-empty ballista at unit position
        mov     r0, #0x10
        mov     r1, #0x11
        ldsb    r0, [r2, r0]
        ldsb    r1, [r2, r1]
        blh     GetBallistaItemAt
        cmp     r0, #0x0
        beq     NoBallistaEquipped
        mov     r5, r0
        
        mov     r4, #0x2
        neg     r4, r4
        mov     r8, r4
        mov     r4, #0x0        @draws item 1 in slot 2
        mov     r2, #Yellow
        b       SS_DrawItemName

  .endif
  
  NoBallistaEquipped:
  ldr     r1, [r7, #0xC]
  mov     r4, #0x0
  ldrh    r5, [r1, #0x1E]
  cmp     r5, #0x0            @does unit have items left?
  beq     GorgonEggSkip_ItemList
  mov     r8, r4
  b       SS_LoopItemsList
  
  GorgonEggSkip_ItemList:
  b       SS_FinishItemsList
  
  SS_LoopItemsList:
  ldr     r2, [r7, #0xC]
  ldr     r0, [r2, #0xC]
  mov     r1, #0x80        
  lsl     r1, r1, #0x5        @Check "drop item" bit
  and     r0, r1
  cmp     r0, #0x0
  beq     SS_NotDroppableItem
  
  mov     r0, r2
  blh     GetUnitItemCount
  sub     r0, #0x1
  cmp     r4, r0
  bne     SS_NotDroppableItem
  mov     r2, #Green
  b       SS_DrawItemName
  
  .ltorg
  
  SS_NotDroppableItem:
  ldr     r0, [r7, #0xC]
  mov     r1, r5
  blh     IsItemUsable
  mov     r2, #White
  lsl     r0, r0, #0x18
  cmp     r0, #0x0
  bne     SS_DrawItemName
    mov     r2, #Grey
  SS_DrawItemName:
  lsl     r0, r4, #0x3
  ldr     r1, =#0x200319C //FE8 -> #0x2003C8C
  add     r0, r0, r1
  ldr     r3, =#0x200323E //FE8 -> #0x2003D2E    @ypos?
  add     r3, r6, r3
  mov     r1, r5
  blh     DrawItemOnStatscreen, r5
  mov     r0, #0x2
  add     r8, r0
  add     r6, #0x80
  add     r4, #0x1
  cmp     r4, #0x4
  bgt     SS_FinishItemsList
  ldr     r0, [r7, #0xC]
  add     r0, #0x1E
  add     r0, r8
  ldrh    r5, [r0]
  cmp     r5, #0x0
  bne     SS_LoopItemsList
  b       SS_FinishItemsList
  
  .ltorg
  
  SS_FinishItemsList:
  pop     {r7}
  mov     r8, r7
  pop     {r7}
.endm

.macro clear_buffers
  blh     Text_InitFont
  blh     _ResetIconGraphics
  @ blh     Statscreen_ClearBuffer
  blh     DontBlinkLeft
  @ blh     MovingMapSprite_EndAll
  @ ldr     r4, =StatScreenStruct
  @ ldr     r0, [r4, #0xc]
  @ mov     r1, #0x50
  @ mov     r2, #0x8A
  @ blh     MovingMapSprite_CreateForUI
  @ str     r0, [r4, #0x10]
  blh     Statscreen_StartLeftPanel
  mov     r0, #0
  str     r0, [sp]
  mov     r0, sp
  ldr     r1, =0x6001380 //No idea if I should change this for FE7 - Jester
  ldr     r2, =0x1000a68 //No idea if I should change this for FE7 - Jester
  swi     0xC @clear vram
  ldr     r0, =SSS_Flag
  ldr     r0, [r0]
  cmp     r0, #0x0                  @ If no Scrolling StatScreen, no TSA clearing.
  beq     ClearBuffersEnd
    mov     r0, #0
    str     r0, [sp]
    mov     r0, sp
    ldr     r1, =gpStatScreenPageBg1Map
    ldr     r2, =0x1000140 //No idea if I should change this for FE7 - Jester
    swi     0xC @clear BG1TSA (0x878CC only clears BG0 and BG2)
  ClearBuffersEnd:
.endm


.equ Sword, 0
.equ Lance, 1
.equ Axe, 2
.equ Bow, 3
.equ Staff, 4
.equ Anima, 5
.equ Light, 6
.equ Dark, 7

.macro draw_weapon_rank_at, tile_x, tile_y, weapon, id
  mov     r0, #\id
  mov     r1, #\tile_x
  mov     r2, #\tile_y
  mov     r3, #\weapon
  blh     DrawWeaponRank, r4
.endm

.macro get_attack_speed
  mov     r0, r8
  blh     SpdGetter
  mov     r4, r0 @speed in r4
  mov     r0, r8
  blh     EquippedWeaponGetter
  blh     ItemWeightGetter
  mov     r5, r0 @weight in r5
  mov     r1, r8
  ldr     r0, [r1, #0x4] @class
  mov     r3, #0x11     @con
  ldsb    r3, [r0, r3]   
  ldr     r0, [r1]      
  ldrb    r0, [r0, #0x13]@char bonus
  lsl     r0, r0, #0x18  
  asr     r0, r0, #0x18  
  add     r3, r3, r0     
  mov     r0, #0x1A     
  ldsb    r0, [r1, r0]   @body ring bonus
  add     r0, r3, r0     @total con in r0
  cmp     r0, r5
  blt WeighedDown
  mov     r0, r4       @put speed directly
  b AS_End
  WeighedDown:
  sub     r5, r0       @weight - con in r5
  sub     r0, r4, r5
  AS_End:
.endm

.macro get_attack
  ldr     r6, =gActiveBattleUnit
  mov     r0, r6
  add     r0, #0x5A
  mov     r1, #0x0
  ldsh    r0, [r0, r1]
.endm

.macro get_hit
  mov     r1, r6
  add     r1, #0x60
  mov     r3, #0x0
  ldsh    r0, [r1, r3]
.endm

.macro get_avoid
  ldr     r0, =gActiveBattleUnit
  add     r0, #0x62
  mov     r1, #0x0
  ldsh    r0, [r0, r1]
.endm

@requires alternateicondraw
.macro draw_skill_icon_at, tile_x, tile_y, number=0
    .if NoAltIconDraw
        .if \number
            mov     r0, #\number
        .endif
        
        @ r1 = 0x0100
        mov     r1, #1
        lsl     r1, #8
        
        @ r1 = [0x01][SkillIndex]
        orr     r1, r0
        
        @ r2 = 0x4000 (aka tiles have palette #4)
        mov     r2, #0x40
        lsl     r2, #8
        
        ldr     r0, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
        
        blh     DrawIcon
    .else
        @assumes icon number in r0 or else in number
        .if \number
            mov     r0, #\number
        .endif
        
        ldr     r4, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
        mov     r1, r0      
        mov     r2, #0x80
        lsl     r2, r2, #0x7      
        mov     r0, r4    
        bl      DrawSkillIcon 
    .endif
.endm


.macro draw_rating_icon_at, tile_x, tile_y, number=0
    .if NoAltIconDraw
        .if \number
            mov     r0, #\number
        .endif
        
        @ r1 = 0x0100
        mov     r1, #1
        lsl     r1, #9
        
        @ r1 = [0x01][SkillIndex]
        orr     r1, r0
        
        @ r2 = 0x4000 (aka tiles have palette #4)
        mov     r2, #0x20
        lsl     r2, #8
        
        ldr     r0, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
        
        blh     DrawIcon
    .else
        @assumes icon number in r0 or else in number
        .if \number
            mov     r0, #\number
        .endif
        
        ldr     r4, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
        mov     r1, r0      
        mov     r2, #0x80
        lsl     r2, r2, #0x7      
        mov     r0, r4    
        bl      DrawSkillIcon 
    .endif
.endm

.macro setup_menu
  ldr     r0, =0x02023460 //FE8 -> 0x020234A8
  mov     r1, #0
  blh     FillBgMap
  mov     r0, #0x0
  mvn     r0, r0        @-1
  blh     LoadNewUIPal+1 
.endm

.macro draw_menu, tile_x, tile_y, width, height
  push    {r4}
  sub     sp, #4
  mov     r0, #0
  str     r0, [sp]
  mov     r0, #\tile_x+0xC
  mov     r1, #\tile_y+0x2
  mov     r2, #\width
  mov     r3, #\height
  blh     MakeUIWindowTileMap_BG0BG1+1, reg=r4
  add     sp, #4
  pop     {r4}
.endm


.macro draw_character_name_at, tile_x, tile_y
  ldr     r0, [r7, #0xC]    @load unit's pointer
  ldr     r0, [r0]            @load character pointer
  ldrh    r0, [r0]        @load name
  blh     String_GetFromIndex
  mov     r5, r0
  mov     r0, #0x38         @ vanilla FE7U: 7-tile name box (8*7)
  mov     r1, r5
  blh     Text_GetStringTextCenteredPos
  mov     r6, r0

  mov     r0, r7
  add     r0, #0x18
  ldr     r1, =(0x20*2*\tile_y)+(2*\tile_x)
  add     r1, r8
  mov     r4, #0
  str     r4, [sp]
  str     r5, [sp, #4]
  mov     r2, #0
  mov     r3, r6
  blh     DrawTextInline
.endm

.macro draw_class_name_at, tile_x, tile_y
  ldr     r0, [r7, #0xC]    @load unit's pointer
  ldr     r0, [r0, #4]    @load class pointer
  ldrh    r0, [r0]        @load class name
  blh     String_GetFromIndex
  mov     r2, r7
  add     r2, #0x20
  ldr     r1, =(0x20*2*\tile_y)+(2*\tile_x) @#0x342
  add     r1, r8
  str     r4, [sp]
  str     r0, [sp, #4]
  mov     r0, r2
  mov     r2, #0
  mov     r3, #0            @ vanilla FE7U: class name is left-aligned
  blh     DrawTextInline
.endm

.macro draw_lv_icon_at, tile_x, tile_y
  ldr     r0, =(0x20*2*\tile_y)+(2*\tile_x) @#0x3C2
  add     r0, r8
  mov     r1, #3
  mov     r2, #0x24
  mov     r3, #0x25
  blh     DrawLargeFont
.endm

.macro draw_exp_icon_at, tile_x, tile_y
  ldr     r0, =(0x20*2*\tile_y)+(2*\tile_x) @#0x3CA
  add     r0, r8
  mov     r1, #3
  mov     r2, #0x1D
  blh     DrawSpecialUiChar
.endm

.macro draw_hp_icon_at, tile_x, tile_y
  ldr     r0, =(0x20*2*\tile_y)+(2*\tile_x) @#0x442
  add     r0, r8
  mov     r1, #3
  mov     r2, #0x22
  mov     r3, #0x23
  blh     DrawLargeFont
.endm

.macro draw_ui_slash_at, tile_x, tile_y
  ldr     r0, =(0x20*2*\tile_y)+(2*\tile_x) @#0x44A
  add     r0, r8
  mov     r1, #3
  mov     r2, #0x16
  blh     DrawSpecialUiChar
.endm

.macro draw_level_at, tile_x, tile_y
  ldr     r0, =(0x20*2*\tile_y)+(2*\tile_x) @#0xF2
  add     r0, r8
  ldr     r1, [r7, #0xC]    @unit pointer
  mov     r2, #8
  ldrb    r2, [r1, r2]    @level
  mov     r1, #2
  blh     DrawDecNumber
.endm

.macro draw_exp_at, tile_x, tile_y
  ldr     r0, =(0x20*2*\tile_y)+(2*\tile_x) @#0x3CE
  add     r0, r8
  ldr     r1, [r7, #0xC]    @unit pointer
  ldrb    r2, [r1, #9]    @exp
  mov     r1, #2
  blh     DrawDecNumber
.endm

.macro draw_hp_at, tile_x, tile_y
  ldr     r0, [r7, #0xC]    @unit pointer
  blh     CurHPGetter
  cmp     r0, #100
  ble     DrawHP
  mov     r0, #0
  sub     r0, #1
  DrawHP:
  mov     r4, #0x89
  lsl     r4, #3
  add     r4, r8
  @ldr     r0, [r7, #0xC]    @unit pointer
  @blh     CurHPGetter
  mov     r2, r0
  mov     r0, r4
  mov     r1, #2
  blh     DrawDecNumber
.endm

.macro draw_max_hp, tile_x, tile_y
  ldr     r0, [r7, #0xC]    @unit pointer
  blh     MaxHPGetter
  cmp     r0, #100
  blt     DrawMaxHP
  mov     r0, #0
  sub     r0, #1
  DrawMaxHP:
  ldr     r4, =#0x20230AE //FE8 -> #0x20230F6 @somewhere in bg0 buffer
  mov     r2, r0
  mov     r0, r4
  mov     r1, #2
  blh     DrawDecNumber
  DrawMaxHP_End:
.endm

.macro leftpage_start
  push    {r4-r7, r14}     
  mov     r7, r8
  push    {r7}
  add     sp, #-0x50   
  ldr     r7, =TileBufferBase  @r7 contains the latest buffer. starts at 2003c2c.
  ldr     r5, =StatScreenStruct
  ldr     r0, [r5, #0xC]
  mov     r8, r0             @r8 contains the current unit's data
  blh     Text_InitFont
  blh     _ResetIconGraphics
  @blh     Statscreen_ClearBuffer
  blh     DontBlinkLeft
  mov     r0, #0
  str     r0, [sp]
  mov     r0, sp
  ldr     r1, =0x6001380 //No idea if I should change this for FE7 - Jester
  ldr     r2, =0x1000a68 //No idea if I should change this for FE7 - Jester
  swi     0xC @clear vram
  ldr     r7, =0x200310C //FE8 -> 0x2003BFC
  ldr     r0, =gBg0MapBuffer
  mov     r8, r0
  mov     r1, #0
  blh     FillBgMap
  ldr     r4, [r7, #0xC]    @load unit's pointer
  mov     r0, r4
  blh     EquippedItemSlotGetter
  mov     r1, r0
  lsl     r1, #0x18
  lsr     r1, #0x18
  mov     r0, r4
  blh     SetupBattleStructFromUnitAndWeapon
.endm

.macro draw_left_affinity_icon_at, tileX, tileY
  ldr     r0, [r7, #0xC]    @load unit's pointer
  blh     AffinityGetter
  mov     r1, #2
  lsl     r1, #8
  orr     r1, r0      
  mov     r2, #0xA0       
  lsl     r2, r2, #0x7     
  ldr     r0, =(gBg0MapBuffer+(0x20*2*\tileY)+(2*\tileX))
  blh     DrawIcon 
.endm

.macro draw_gaiden_spells_at, tile_x, tile_y, gaidenStatScreenRoutine
@ This will do nothing if Gaiden Magic is not installed.
  ldr    r0, =\gaidenStatScreenRoutine
  ldr    r1, [ r0 ]
  cmp    r1, #0x00
  beq    SkipGaidenDraw
    @ Gaiden magic is installed. Call the function for stat screen drawing.
    mov    lr, r0
    mov    r0, #\tile_x @ X coordinate.
    mov    r1, #\tile_y @ Y coordinate.
    mov    r2, r7  @ Current TextHandle.
    .short 0xF800
    mov    r0, r7 @ Next "blank" TextHandle.
  SkipGaidenDraw:
.endm
