.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ AstraID, SkillTester+4

@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data
@
@ Extra hits come from GetBattleUnitHitCount (FE7 r5), Skill % rolled there.
@ BattleUnit+0x7F bit7 = this swing is Astra; low 4 bits = remaining hits.
@ Vanilla rounds are 4 bytes — do not write +4.
@ Stamp 0x4000 only on the first Astra hit so C03 does not replay on the foe.
push {r4-r7,lr}
mov r4, r0 @attacker
mov r5, r1 @defender
mov r6, r2 @battle buffer
mov r7, r3 @battle data

mov r0, r4
add r0, #0x7F
ldrb r1, [r0]
mov r2, #0x80 @Astra this-swing flag
tst r1, r2
beq End

@first hit of the swing? (count still 5) — save flag in r5
mov r3, #0x0F
mov r2, r1
and r2, r3 @count
mov r5, #0
cmp r2, #5
bne DecRemain
mov r5, #1 @stamp skill flag this round
DecRemain:
sub r2, #1
bic r1, r3
orr r1, r2
cmp r2, #0
bne StoreRemain
mov r2, #0x80
bic r1, r2
StoreRemain:
strb r1, [r0]

ldr     r0,[r6]
lsl     r0,r0,#0xD
lsr     r0,r0,#0xD
mov r1, #0xC0
lsl r1, #8
add r1, #0x2 @miss
tst r0, r1
bne End

@half damage every Astra hit
mov     r2, #4
ldrsh   r3, [r7, r2]
asr     r3, #1
strh    r3, [r7, #4]

cmp r5, #1
bne End

ldrb r0, [r4, #0x0B]
ldr r1, =0x0203F0FC
strb r0, [r1]

@0x4000 on the first hit only
ldr     r2,[r6]
lsl     r1,r2,#0xD
lsr     r1,r1,#0xD
mov     r0, #0x40
lsl     r0, #8
orr     r1, r0
ldr     r0,=#0xFFF80000
and     r0,r2
orr     r0,r1
str     r0,[r6]

End:
pop {r4-r7}
pop {r15}

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD AstraID
