.thumb
.equ BellePersonalID, SkillTester+4

push {r4-r7, lr}
mov r4, r0              @atkr
mov r5, r1              @dfdr

@Is Belle
ldr r0, SkillTester
mov lr, r0
mov r0, r4              @defender data
ldr r1, BellePersonalID
.short 0xf800
cmp r0, #0
beq End

ldrb r0, [r4, #0x12]    @max hp
ldrb r1, [r4, #0x13]    @curr hp
cmp r1, r0
bge End                 @full (or overheal): 0 stacks

sub r0, r1              @missing hp
lsl r1, r0, #2          @missing * 4
ldrb r0, [r4, #0x12]    @max hp

@stacks = min(3, floor(missing*4 / max))
@compare missing*4 against max, 2*max, 3*max (no BIOS SWI)
cmp r1, r0
blt End                 @< 25% missing
mov r2, #0x1
lsl r3, r0, #1          @2*max
cmp r1, r3
blt Effect              @25–49%
mov r2, #0x2
add r3, r0              @3*max
cmp r1, r3
blt Effect              @50–74%
mov r2, #0x3            @>= 75% missing (cap)

Effect:
mov r3, #0x2
mul r2, r3

mov r1, #0x5A
ldrh r0, [r4, r1]       @Attack
add r0, r2
strh r0, [r4, r1]

mov r1, #0x5C           @Def
ldrh r0, [r4, r1]
add r0, r2
strh r0, [r4, r1]

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD BellePersonalID
