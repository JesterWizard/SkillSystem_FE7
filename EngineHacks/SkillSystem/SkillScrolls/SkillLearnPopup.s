.thumb
.align

@ FE7 skill-learned popup helpers for CreatePopup (0x0800AD40).
@ Extends vanilla component ids (jumped into from in-function tables):
@   0x0D = skill icon (IconRework sheet, 0x100 | skillId)
@   0x0E = skill name (SkillDescTable text before ':')
@   0x0F = item article only ("a " / "an "), so the name can be a different colour
@   0x10 = weapon rank letter (E/D/C/B/A/S) from the unit that just ranked up
@ Length ABI:  r4=width, r5=def, r6=proc  → resume 0x0800A904
@ Display ABI: r5=def, sp+0x10=TextHandle → resume 0x0800AA00

.macro blh to, reg=r3
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

.equ SetPopupUnit,            0x0800AD1C
.equ SetPopupShort,           0x0800AD28
.equ CreatePopup,             0x0800AD40
.equ ProcStartBlocking,       0x080044F8
.equ ProcStart,               0x08004494
.equ GetStringFromIndex,      0x08012C60
.equ GetItemNameWithArticle,  0x080171E4
.equ GetItemData,             0x080174AD
.equ GetWeaponLevelFromExp,   0x08016949
.equ Text_GetStringTextWidth,  0x080055FC
.equ Text_DrawString,          0x08005718
.equ Text_Advance,             0x08005578
.equ Text_SetColorId,          0x08005580
.equ LoadIconPalette,         0x08004D44
.equ gPopupItem,              0x03000108
.equ gBattleActor,            0x0203A3F0
.equ gBattleTarget,           0x0203A470
.equ PopupLenResume,          0x0800A905
.equ PopupDispResume,         0x0800AA01

.global PopupLen_SkillIcon
.global PopupDisp_SkillIcon
.global PopupLen_SkillName
.global PopupDisp_SkillName
.global PopupLen_ItemArticle
.global PopupDisp_ItemArticle
.global PopupLen_WRankLetter
.global PopupDisp_WRankLetter
.global WRankLetters
.global DrawBattlePopup_WRank
.global LearnScrollSkill
.global CallScrollLearnedPopup

PopupLen_SkillIcon:
    @ Vanilla item-icon length stores current width in +0x44 as draw X.
    mov r0, r6
    add r0, #0x44
    strb r4, [r0]

    ldr r0, =gPopupItem
    ldrh r0, [r0]
    mov r1, #0x01
    lsl r1, #8
    orr r0, r1
    strh r0, [r6, #0x3E]

    mov r0, r6
    add r0, #0x42
    ldrb r1, [r0]
    mov r0, #0
    blh LoadIconPalette

    add r4, #16
    ldr r0, =PopupLenResume
    bx r0

.ltorg
.align

PopupDisp_SkillIcon:
    add r0, sp, #0x10
    mov r1, #16
    blh Text_Advance
    ldr r0, =PopupDispResume
    bx r0

.ltorg
.align

PopupLen_SkillName:
    ldr r0, =gPopupItem
    ldrb r0, [r0]
    bl ResolveSkillName
    blh Text_GetStringTextWidth
    add r4, r0
    ldr r0, =PopupLenResume
    bx r0

.ltorg
.align

PopupDisp_SkillName:
    ldr r0, =gPopupItem
    ldrb r0, [r0]
    bl ResolveSkillName
    mov r1, r0
    add r0, sp, #0x10
    blh Text_DrawString
    ldr r0, =PopupDispResume
    bx r0

.ltorg
.align

@ Anims-on DrawBattlePopup (hook at 0x6B298, 4-aligned). Type 0 vanilla
@ draws icon + text 0x750 and stops. Draw the ASCII letter after it.
@ Other types resume at the vanilla type-1/2 path (0x6B2C0).
DrawBattlePopup_WRank:
    mov r2, r8
    cmp r2, #0
    beq DrawBattlePopup_WRank_Type0
    ldr r0, =0x0806B2C1
    bx r0

DrawBattlePopup_WRank_Type0:
    push {r4-r7, lr}
    sub sp, #4
    mov r0, r6
    mov r1, #16
    blh Text_Advance

    mov r0, #0xEA
    lsl r0, #3
    blh GetStringFromIndex
    mov r5, r0

    mov r0, r6
    mov r1, #0
    blh Text_SetColorId
    mov r0, r6
    mov r1, r5
    blh Text_DrawString

    bl ResolveWRankLetter
    cmp r0, #0
    beq DrawBattlePopup_WRank_Done
    @ Color 2 is unreadably dark on this banner; use white (color 0).
    mov r1, sp
    strb r0, [r1]
    mov r2, #0
    strb r2, [r1, #1]
    mov r0, r6
    mov r1, #0
    blh Text_SetColorId
    mov r0, r6
    mov r1, sp
    blh Text_DrawString

DrawBattlePopup_WRank_Done:
    add sp, #4
    pop {r4-r7}
    pop {r0}
    ldr r0, =0x0806B329
    bx r0

.ltorg
.align

@ 0x10: letter from the player battle unit's equipped-weapon rank.
PopupLen_WRankLetter:
    sub sp, #4
    bl ResolveWRankLetter
    cmp r0, #0
    beq PopupLen_WRankLetter_Done
    mov r1, sp
    strb r0, [r1]
    mov r0, #0
    strb r0, [r1, #1]
    mov r0, sp
    blh Text_GetStringTextWidth
    add r4, r0
PopupLen_WRankLetter_Done:
    add sp, #4
    ldr r0, =PopupLenResume
    bx r0

.ltorg
.align

PopupDisp_WRankLetter:
    sub sp, #4
    bl ResolveWRankLetter
    cmp r0, #0
    beq PopupDisp_WRankLetter_Done
    mov r1, sp
    strb r0, [r1]
    mov r0, #0
    strb r0, [r1, #1]
    mov r1, sp
    add r0, sp, #0x14
    blh Text_DrawString
PopupDisp_WRankLetter_Done:
    add sp, #4
    ldr r0, =PopupDispResume
    bx r0

.ltorg
.align

@ r0 = ASCII rank letter ('E'..'S') or 0.
@ Player battle unit, equipped weapon at +0x48 (then +0x4A), ranks[+0x28+wtype].
ResolveWRankLetter:
    push {r4-r5, lr}
    ldr r0, =gBattleActor
    ldrb r1, [r0, #0x0B]
    lsr r1, r1, #6
    cmp r1, #0
    beq ResolveWRankLetter_HaveUnit
    ldr r0, =gBattleTarget
ResolveWRankLetter_HaveUnit:
    mov r4, r0
    bl EquippedWeaponId
    cmp r0, #0
    bne ResolveWRankLetter_HaveItem
    ldr r0, =gBattleActor
    cmp r0, r4
    bne ResolveWRankLetter_TryActor
    ldr r0, =gBattleTarget
    b ResolveWRankLetter_TryOther
ResolveWRankLetter_TryActor:
    ldr r0, =gBattleActor
ResolveWRankLetter_TryOther:
    mov r4, r0
    bl EquippedWeaponId
    cmp r0, #0
    beq ResolveWRankLetter_None
ResolveWRankLetter_HaveItem:
    blh GetItemData
    ldrb r5, [r0, #7]
    mov r0, r4
    add r0, #0x28
    ldrb r0, [r0, r5]
    blh GetWeaponLevelFromExp
    cmp r0, #6
    bge ResolveWRankLetter_Index
    add r0, #1
ResolveWRankLetter_Index:
    ldr r1, =WRankLetters
    ldrb r0, [r1, r0]
    b ResolveWRankLetter_Ret
ResolveWRankLetter_None:
    mov r0, #0
ResolveWRankLetter_Ret:
    pop {r4-r5}
    pop {r1}
    bx r1

.ltorg
.align

@ r0 = unit. r0 = item id of +0x48, else +0x4A, else 0.
EquippedWeaponId:
    mov r1, r0
    mov r2, r1
    add r2, #0x48
    ldrh r0, [r2]
    lsl r0, #24
    lsr r0, #24
    cmp r0, #0
    bne EquippedWeaponId_Ret
    mov r2, r1
    add r2, #0x4A
    ldrh r0, [r2]
    lsl r0, #24
    lsr r0, #24
EquippedWeaponId_Ret:
    bx lr

.ltorg
.align

@ index = GetWeaponLevelFromExp: 0 none, 1=E .. 6=S
WRankLetters:
    .byte 0x00, 0x45, 0x44, 0x43, 0x42, 0x41, 0x53
    .align

@ 0x0F: "a " / "an " only, so Despoil can keep the article white.
PopupLen_ItemArticle:
    bl ItemArticleString
    blh Text_GetStringTextWidth
    add r4, r0
    ldr r0, =PopupLenResume
    bx r0

.ltorg
.align

PopupDisp_ItemArticle:
    bl ItemArticleString
    mov r1, r0
    add r0, sp, #0x10
    blh Text_DrawString
    ldr r0, =PopupDispResume
    bx r0

.ltorg
.align

@ r0 = "a "/"an " in ArticleBuf (copy through first space).
ItemArticleString:
    push {r4, lr}
    ldr r0, =gPopupItem
    ldrh r0, [r0]
    mov r1, #0
    blh GetItemNameWithArticle
    ldr r4, =ArticleBuf
    mov r1, r4
ItemArticleCopy:
    ldrb r2, [r0]
    strb r2, [r1]
    add r0, #1
    add r1, #1
    cmp r2, #0x20
    beq ItemArticleDone
    cmp r2, #0
    beq ItemArticleDone
    b ItemArticleCopy
ItemArticleDone:
    mov r2, #0
    strb r2, [r1]
    mov r0, r4
    pop {r4}
    pop {r1}
    bx r1

.ltorg
.align
ArticleBuf:
    .space 8

@ r0 = skill id → r0 = name cstr (colon-truncated desc)
ResolveSkillName:
    push {r4, lr}
    ldr r1, =SkillDescTable
    lsl r0, #1
    add r0, r1
    ldrh r0, [r0]
    cmp r0, #0
    beq ResolveSkillName_Empty
    blh GetStringFromIndex
    mov r4, r0
    sub r2, r0, #1
ResolveSkillName_Loop:
    add r2, #1
    ldrb r1, [r2]
    cmp r1, #0
    beq ResolveSkillName_Done
    cmp r1, #0x3A
    bne ResolveSkillName_Loop
    mov r1, #0
    strb r1, [r2]
ResolveSkillName_Done:
    mov r0, r4
    b ResolveSkillName_Ret
ResolveSkillName_Empty:
    ldr r0, =SkillNameFallback
ResolveSkillName_Ret:
    pop {r4}
    pop {r1}
    bx r1

.ltorg
.align

SkillNameFallback:
    .byte 0x3F, 0x00
    .align

@ r0=unit, r1=skillId, r2=parent proc
@ Starts a blocking wrapper proc (parent waits) that runs CreatePopup.
LearnScrollSkill:
    push {r4-r6, lr}
    mov r4, r0
    mov r5, r1
    mov r6, r2
    lsl r5, r5, #24
    lsr r5, r5, #24

    mov r0, r4
    mov r1, r5
    blh SkillAdder

    mov r0, r4
    blh SetPopupUnit

    mov r0, r5
    blh SetPopupShort

    ldr r0, =LearnScrollPopupProc
    cmp r6, #0
    beq LearnScrollSkill_NonBlock
    mov r1, r6
    blh ProcStartBlocking
    b LearnScrollSkill_End

LearnScrollSkill_NonBlock:
    mov r1, #3
    blh ProcStart

LearnScrollSkill_End:
    pop {r4-r6}
    pop {r1}
    bx r1

.ltorg
.align

@ r0 = LearnScrollPopupProc — start CreatePopup blocking on self.
@ Return 0 so CALL_ROUTINE_2 yields this frame (END runs only after popup lock clears).
CallScrollLearnedPopup:
    push {r4, lr}
    mov r4, r0

    ldr r0, =CreatePopup
    mov lr, r0
    ldr r0, =SkillLearnedPopupDef
    mov r1, #90
    mov r2, #0
    mov r3, r4
    .short 0xF800

    mov r0, #0
    pop {r4}
    pop {r1}
    bx r1

.ltorg
.align
