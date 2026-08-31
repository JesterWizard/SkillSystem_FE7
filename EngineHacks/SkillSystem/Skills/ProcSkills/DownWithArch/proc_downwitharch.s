@this is just an edited version of proc_lethality.s
.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ DownWithArchID, SkillTester+4
.equ d100Result, 0x802857c

.global DownWithArch
.type DownWithArch, %function

@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data
DownWithArch:
push {r4-r7,lr}
mov r4, r0                  @attacker
mov r5, r1                  @defender
mov r6, r2                  @battle buffer
mov r7, r3                  @battle data
ldr     r0,[r2]             @r0 = battle buffer
lsl     r0,r0,#0xD
lsr     r0,r0,#0xD          @Without damage data
mov r1, #0xC0               @skill flag
lsl r1, #8                  @0xC000
add r1, #2                  @miss
tst r0, r1
bne End

ldr r0, SkillTester
mov lr, r0
mov r0, r4                  @attacker data
ldr r1, DownWithArchID
.short 0xf800
cmp r0, #0x00
beq End

@check enemy name
CheckName:
cmp     r5, #0
beq     End
ldr	r0,[r5]             @character data
cmp	r0, #0
beq	End
ldrh	r0,[r0]             @name text id
ldr	r1, =0x08012C61     @GetStringFromIndex (FE7)
mov	lr, r1
.short	0xf800
cmp	r0, #0
beq	End
ldrb	r1,[r0]
cmp	r1,#0x41            @'A'
bne	End
ldrb	r1,[r0,#1]
cmp	r1,#0x72            @'r'
bne	End
ldrb	r1,[r0,#2]
cmp	r1,#0x63            @'c'
bne	End
ldrb	r1,[r0,#3]
cmp	r1,#0x68            @'h'
bne	End

@if we proc, set offensive skill flag
ldr     r2,[r6]    
lsl     r1,r2,#0xD
lsr     r1,r1,#0xD
mov     r0, #0x40
lsl     r0, #8              @0x4000, attacker skill activated
orr     r1, r0
ldr     r0,=#0xFFF80000
and     r0,r2
orr     r0,r1
str     r0,[r6]

@set the lethality flag
ldr     r3,[r6]    
lsl     r1,r3,#0xD
lsr     r1,r1,#0xD
mov     r0,#0x80
lsl     r0,r0,#0x4          @0x800, lethality flag
orr     r1,r0
ldr     r2,=#0xFFF80000
mov     r0,r2
and     r0,r3
orr     r0,r1
str     r0,[r6]

mov	r0,#0x7F
strh    r0,[r7,#0x4]        @final damage = 127

End:
pop {r4-r7}
pop {r15}

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD DownWithArchID
