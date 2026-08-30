.thumb

@ Discipline / Discipline+: double weapon EXP.
@ callHack_r3 at 08029B88 is 12 bytes: ldrb/lsl/asr/mul plus vanilla
@ add r6, r1, r6 / mov r1, #0. Return continues at 08029B94.
@ r1 already unit+0x7B, r0 is item wexp, r6 is current rank.

.equ Skill_ID, SkillTester+4
.equ SkillPlus_ID, Skill_ID+4
.equ DisciplinePlusReturn, 0x8029BBF

.thumb
push {r4-r5,r14}

ldrb    r1, [r1]
lsl     r1, r1, #0x18
asr     r1, r1, #0x18
mul     r1, r0
mov     r4, r1

ldr     r1, SkillPlus_ID
ldr     r2, SkillTester
mov     r0, r7
mov     lr, r2
.short  0xF800
mov     r5, r0
ldr     r1, Skill_ID
ldr     r2, SkillTester
mov     r0, r7
mov     lr, r2
.short  0xF800
orr     r0, r5
cmp     r0, #0x0
beq     NoSkill
lsl     r4, r4, #0x1
cmp     r5, #0x0
bne     DisciplinePlus

NoSkill:
add     r6, r6, r4
mov     r0, r4
pop     {r4-r5}
pop     {r3}
mov     r1, #0x0
DisciplineDone:
bx      r3

@ Skip the "already has an S-rank" uniqueness loop.
DisciplinePlus:
mov     r0, r4
pop     {r4-r5}
pop     {r1}
add     r6, r6, r0
DisciplinePlusDone:
ldr     r0, =DisciplinePlusReturn
bx      r0

.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD Skill_ID
@WORD SkillPlus_ID
