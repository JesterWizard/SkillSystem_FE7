.thumb
.equ UnitRangeCheck, SkillTester+4
.equ LoyaltyID, UnitRangeCheck+4
.equ GetUnit, 0x8018D0D     //FE8 -> 0x8019431

push {r4-r7, lr}
mov r4, r0                  @atkr
mov r5, r1                  @dfdr


@has Loyalty
ldr r0, SkillTester
mov lr, r0
mov r0, r4                  @Attacker data
ldr r1, LoyaltyID
.short 0xf800
cmp r0, #0
beq End

@now check for the skill
ldr r0, UnitRangeCheck
mov lr, r0
mov r0, r4                  @attacker
mov r1, #0                  @are allies
mov r2, #2                  @range
.short 0xf800
cmp r0, #0
beq End

Loop:
ldrb r2,[r0]
cmp r2,#0x0
beq End
add r0,#0x1
push {r0}
ldr r3,=GetUnit
mov lr, r3
mov r0, r2
.short 0xf800
mov r5, r0
pop {r0}
cmp r5,#0
beq Loop
ldr r5,[r5]                 @pCharacterData
cmp r5,#0
beq Loop
mov r3,#0x4
ldrb r3,[r5,r3]             @character number (Eliwood/Hector/Lyn_t/Lyn)
cmp r3,#0x1
beq Final
cmp r3,#0x2
beq Final
cmp r3,#0x3
beq Final
cmp r3,#0x2D                @Lyn (not tutorial)
beq Final
b Loop


Final:
mov r1, #0x5C
ldrh r2, [r4, r1]
add r2, #0x3
strh r2, [r4,r1]

mov r1, #0x60
ldrh r2, [r4, r1]
add r2, #15
strh r2, [r4,r1]


End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD LoyaltyID
