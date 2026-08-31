.thumb
.align

.global SkillActivationChanceCalcLoopFunc
.type SkillActivationChanceCalcLoopFunc, %function

SkillActivationChanceCalcLoopFunc: @ r0 is chance, r1 is user (or default sim result if <= 1)
push {r4-r7, lr}
mov r4, r0          @ r4 = chance
mov r5, #0          @ r5 = default simulation result (0)
mov r6, r1          @ r6 = unit ptr (if > 1)

@ Check if r1 is a unit pointer (> 1) or a default sim value (0 or 1)
cmp r1, #1
bhi HasUnitPtr
mov r5, r1          @ default sim result = r1 (0 or 1)
b CheckSimulation

HasUnitPtr:
ldr r7, =SkillActivationChanceCalcLoop
LoopStart:
ldr r0, [r7]
cmp r0, #0
beq CheckSimulation
mov lr, r0
mov r0, r4
mov r1, r6
.short 0xF800
mov r4, r0
add r7, #4
b LoopStart

CheckSimulation:
ldr r0, =#0x0203A3D8 @ gBattleStats
ldrh r0, [r0]
mov r1, #2           @ BATTLE_CONFIG_SIMULATE / Forecast bit
tst r0, r1
bne ReturnSimResult

@ Real battle: Roll 1RN
mov r0, r4
ldr r1, =#0x08000E60 @ Roll1RN
mov lr, r1
.short 0xF800
b Return

ReturnSimResult:
mov r0, r5

Return:
pop {r4-r7}
pop {r1}
bx r1

.ltorg
.align
