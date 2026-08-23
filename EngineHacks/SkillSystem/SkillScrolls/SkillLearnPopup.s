.thumb
.align

@ FE7 skill-learned popup helpers for CreatePopup (0x0800AD40).
@ Extends vanilla component ids (jumped into from in-function tables):
@   0x0D = skill icon (IconRework sheet, 0x100 | skillId)
@   0x0E = skill name (SkillDescTable text before ':')
@   0x0F = item article only ("a " / "an "), so the name can be a different colour
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
.equ Text_GetStringTextWidth,  0x080055FC
.equ Text_DrawString,          0x08005718
.equ Text_Advance,             0x08005578
.equ LoadIconPalette,         0x08004D44
.equ gPopupItem,              0x03000108
.equ PopupLenResume,          0x0800A905
.equ PopupDispResume,         0x0800AA01

.global PopupLen_SkillIcon
.global PopupDisp_SkillIcon
.global PopupLen_SkillName
.global PopupDisp_SkillName
.global PopupLen_ItemArticle
.global PopupDisp_ItemArticle
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
