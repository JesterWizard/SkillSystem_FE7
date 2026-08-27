.thumb
.align

@ FE7 Multi-Skill Scrolls
@ Learned skills live in unit->supports[] (see Internals/addSkill.s):
@   players: 7 slots, others: 6 (keep leader at [6]).

.macro blh to, reg=r3
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

.equ GetUnit,                0x08018D0C
.equ UnitRemoveInvalidItems, 0x08017688
.equ GetItemIndex,           0x080171B4
.equ gActionData,            0x0203A85C
.equ DoItemAction_CommonEnd, 0x0802D235
.equ ApplyItemStatBoost_Resume, 0x0802CD41
.equ UNIT_SUPPORTS,          0x32
.equ LEARNED_SKILL_COUNT_PLAYER, 7
.equ LEARNED_SKILL_COUNT_OTHER,  6

.global MultiScrollUsability
.type MultiScrollUsability, %function

.global MultiScrollPrepUsability
.type MultiScrollPrepUsability, %function

.global MultiScrollEffect
.type MultiScrollEffect, %function

.global MultiScrollPrepEffect
.type MultiScrollPrepEffect, %function

.global MultiScrollTargeting
.type MultiScrollTargeting, %function

.global PrepScrollEffectDispatch
.type PrepScrollEffectDispatch, %function


@-----------------------------------------------------------------------------
@ Map usability — FE7 CanUnitUseItem @ 0x08016B68:
@   push {r4,lr}; r3=unit, r2=item; mov pc, handler
@ Handler must pop that {r4,lr} itself (vanilla ends at 0x08016D02).
@ Use is shown when r0!=0; disabled (hidden) when already has skill or full.
@-----------------------------------------------------------------------------
MultiScrollUsability:
    push {r4-r5}
    mov r4, r3
    mov r5, r2

    mov r0, r5
    bl GetScrollSkillId
    mov r1, r0
    mov r0, r4
    blh SkillTester
    cmp r0, #1
    beq UsabilityFalse

    mov r0, r4
    bl CountLearnedSkills
    mov r1, r0              @ count
    mov r0, r4
    push {r1}
    bl GetLearnedSkillCap
    pop {r1}
    cmp r1, r0              @ count >= cap?
    bge UsabilityFalse

    mov r0, #1
    b UsabilityReturn

UsabilityFalse:
    mov r0, #0

UsabilityReturn:
    pop {r4-r5}
    pop {r4}            @ CanUnitUseItem's saved r4
    pop {r1}            @ CanUnitUseItem's lr
    bx r1

.ltorg
.align


@-----------------------------------------------------------------------------
@ Prep usability — FE7 CanUnitUseItemPrepScreen trampoline:
@   r4=item, r5=unit, stack={r4,r5,lr}; handler pops and returns.
@-----------------------------------------------------------------------------
MultiScrollPrepUsability:
    mov r0, r5
    mov r5, r4
    mov r4, r0

    mov r0, r5
    bl GetScrollSkillId
    mov r1, r0
    mov r0, r4
    blh SkillTester
    cmp r0, #1
    beq PrepUse_False

    mov r0, r4
    bl CountLearnedSkills
    mov r1, r0              @ count
    mov r0, r4
    push {r1}
    bl GetLearnedSkillCap
    pop {r1}
    cmp r1, r0              @ count >= cap?
    bge PrepUse_False

    mov r0, #1
    b PrepUse_Return

PrepUse_False:
    mov r0, #0

PrepUse_Return:
    pop {r4-r5}
    pop {r1}
    bx r1

.ltorg
.align


@-----------------------------------------------------------------------------
@ Map effect — DoItemAction mov-pc entry: r4=slot, r5=parent
@-----------------------------------------------------------------------------
MultiScrollEffect:
    push {r4, r6-r7}            @ keep r5 = parent for common end

    ldr r6, =gActionData
    ldr r0, =GetUnit
    mov lr, r0
    ldrb r0, [r6, #0xC]
    .short 0xF800

    ldrb r1, [r6, #0x12]
    mov r6, r0
    mov r4, r1

    mov r2, r6
    add r2, #0x1E
    lsl r1, r4, #1
    add r2, r1
    ldrh r0, [r2]
    bl GetScrollSkillId
    mov r7, r0

    mov r0, #0
    strh r0, [r2]
    mov r0, r6
    blh UnitRemoveInvalidItems

    mov r0, r6
    mov r1, r7
    mov r2, r5                  @ parent: blocking CreatePopup (FE8 LearnNewSkill style)
    blh LearnScrollSkill

    pop {r4, r6-r7}
    ldr r0, =DoItemAction_CommonEnd
    bx r0

.ltorg
.align


@-----------------------------------------------------------------------------
@ Prep effect — r4=unit, r6=item, r7=slot; returns text id
@-----------------------------------------------------------------------------
MultiScrollPrepEffect:
    mov r0, r6
    bl GetScrollSkillId
    mov r1, r0
    mov r0, r4
    blh SkillAdder

    mov r1, r7
    mov r2, r4
    add r2, #0x1E
    lsl r1, r1, #1
    add r2, r1
    mov r0, #0
    strh r0, [r2]
    mov r0, r4
    blh UnitRemoveInvalidItems

    ldr r0, =SkillScrollMessageReturnLink
    ldrh r0, [r0]

    pop {r4-r7}
    pop {r1}
    bx r1

.ltorg
.align


@-----------------------------------------------------------------------------
@ Prep apply entry — replaces ApplyItemStatBoost start (0x2CD28).
@ Vanilla: r0=unit, r1=slot. Sets r4/r6/r7 then Metis/stat-boost path.
@-----------------------------------------------------------------------------
PrepScrollEffectDispatch:
    push {r4-r7, lr}
    mov r4, r0
    mov r7, r1

    lsl r0, r7, #1
    mov r1, r4
    add r1, #0x1E
    add r1, r0
    ldrh r6, [r1]

    mov r0, r6
    blh GetItemIndex
    ldr r1, =SkillScrollIDLink
    ldrb r1, [r1]
    cmp r0, r1
    beq PrepScrollEffectDispatch_Scroll

    mov r5, #0
    ldr r1, =ApplyItemStatBoost_Resume
    bx r1

PrepScrollEffectDispatch_Scroll:
    b MultiScrollPrepEffect

.ltorg
.align


MultiScrollTargeting:
@ FE7 Item Use menu calls 0x08026CD0, which mov-pc's here with:
@   r4=unit, r5=item, stack={r4,r5,lr}
@ Return 1 → Use enabled; 0 → Use grayed.
@ (Byte item+0x1E must also be nonzero or Use is hidden entirely.)
    mov r0, r5
    bl GetScrollSkillId
    mov r1, r0
    mov r0, r4
    blh SkillTester
    cmp r0, #1
    beq TargetingFalse

    mov r0, r4
    bl CountLearnedSkills
    mov r1, r0              @ count
    mov r0, r4
    push {r1}
    bl GetLearnedSkillCap
    pop {r1}
    cmp r1, r0              @ count >= cap?
    bge TargetingFalse

    mov r0, #1
    b TargetingReturn

TargetingFalse:
    mov r0, #0

TargetingReturn:
    pop {r4-r5}
    pop {r1}
    bx r1

.ltorg
.align


@-----------------------------------------------------------------------------
@ Helpers
@-----------------------------------------------------------------------------
@ r0 = item halfword (ldrsh-safe). r0 = skill id 0-255.
.global GetScrollSkillId
.type GetScrollSkillId, %function
GetScrollSkillId:
    lsr r0, r0, #8
    lsl r0, r0, #24
    lsr r0, r0, #24
GetScrollSkillId_Done:
    bx lr

.ltorg
.align


CountLearnedSkills:
    push {r4-r5, lr}
    mov r4, r0
    bl GetLearnedSkillCap
    mov r5, r0
    add r4, #UNIT_SUPPORTS
    mov r0, #0
    mov r1, #0
CountLoop:
    cmp r1, r5
    bge CountDone
    ldrb r2, [r4, r1]
    cmp r2, #0
    beq CountDone
    cmp r2, #0xFF
    beq CountDone
    add r0, #1
    add r1, #1
    b CountLoop
CountDone:
    pop {r4-r5}
    pop {r1}
    bx r1

.ltorg
.align


GetLearnedSkillCap:
    ldrb r1, [r0, #0x0B]
    mov r2, #0xC0
    and r1, r2
    cmp r1, #0
    bne CapOther
    mov r0, #LEARNED_SKILL_COUNT_PLAYER
    bx lr
CapOther:
    mov r0, #LEARNED_SKILL_COUNT_OTHER
    bx lr

.ltorg
.align
