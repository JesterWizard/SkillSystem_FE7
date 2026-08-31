.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ AdeptID, SkillTester+4
.equ AstraID, SkillTester+8
.equ AetherID, SkillTester+12
.equ BattleCheckBraveEffect, 0x8029129
.equ d100Result, 0x802857C

@ r0 = attacker. BattleUnit+0x7F (pad):
@ bit7 = Astra owns this swing, low 4 bits = remaining hits.
@ bit6 = Aether owns this swing, low 4 bits = remaining hits.
@ Do not use +0x7E (hasItemEffectTarget).
@ Astra/Aether rolls once per swing (doubles can proc twice).
GetBattleUnitHitCount_Adept:
push {r4-r5, lr}
mov r4, r0
add r0, #0x7F
mov r1, #0
strb r1, [r0]
mov r5, #1
mov r0, r4
blh BattleCheckBraveEffect
lsl r5, r0

ldr r1, AstraID
cmp r1, #255
beq CheckAether
ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, AstraID
.short 0xf800
cmp r0, #0
beq CheckAether
@if user has Astra, check for proc rate (also in proc_astra.s)
ldrb r0, [r4, #0x15]    @skill stat as activation rate
mov r1, r4              @skill user
blh d100Result
cmp r0, #1
bne CheckAether
mov r5, #5              @5 consecutive attacks this swing
mov r0, r4
add r0, #0x7F
mov r1, #0x85           @5 | this-swing (Astra bit 7)
strb r1, [r0]
b Return

CheckAether:
ldr r1, AetherID
cmp r1, #255
beq CheckAdept
ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, AetherID
.short 0xf800
cmp r0, #0
beq CheckAdept
@if user has Aether, check for proc rate (Skill/2 %)
ldrb r0, [r4, #0x15]    @skill stat as activation rate
lsr r0, r0, #1          @Skill/2 %
mov r1, r4              @skill user
blh d100Result
cmp r0, #1
bne CheckAdept
mov r5, #2              @2 consecutive attacks this swing
mov r0, r4
add r0, #0x7F
mov r1, #0x42           @2 | this-swing (Aether bit 6)
strb r1, [r0]
b Return

CheckAdept:
ldr r1, AdeptID
cmp r1, #255
beq Return

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, AdeptID
.short 0xf800
cmp r0, #0
beq Return

ldrb r0, [r4, #0x16]    @speed stat as activation rate
@mov r0, #0x64
mov r1, r4
blh d100Result
cmp r0, #1
bne Return
add r5, #1
mov r0, r4
add r0, #0x7F
strb r5, [r0]           @ remaining hits; Proc_Adept marks when this hits 0

Return:
mov r0, r5
pop {r4-r5}
pop {r1}
bx r1

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD AdeptID
@WORD AstraID
@WORD AetherID
