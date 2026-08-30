.equ SkillTester, MugList+4
.equ RandomMugID, SkillTester+4
.equ IdentityProblemsID, RandomMugID+4
.equ IdentityRamByte, IdentityProblemsID+4
.equ IdentityProblemsMugs, IdentityRamByte+4
.equ NextRN_N, 0x08000E31

.thumb
@ r0 = this control code.
push { r4, r5, lr }
mov r4, r0

ldr	r0,=#0xFFFF
cmp	r4,r0
beq	CurrentChar

ldr	r0,=#0xFFF0
cmp	r4,r0
beq	GetRandom

ldr	r0,=#0xFFE0
cmp	r4,r0
beq	GetRandom2

b End

CurrentChar:
ldr	r0,=#0x3004690
ldr	r0,[r0]
cmp	r0,#0x00
beq	End

ldr	r1,RandomMugID
ldr     r2,SkillTester
mov	r14,r2
.short	0xF800
cmp	r0,#0x01
beq	GetRandom

ldr	r0,=#0x3004690
ldr	r0,[r0]
ldr	r1,IdentityProblemsID
ldr     r2,SkillTester
mov	r14,r2
.short	0xF800
cmp	r0,#0x00
beq	End
b	GetRandom2

GetRandom:
ldr	r0,MugList
bl	CountMugList
cmp	r0,#0
beq	End
ldr	r3,=NextRN_N
mov	lr,r3
nop
nop
nop
nop
.short	0xF800
ldr	r2,MugList
ldrb	r0,[r2,r0]
b Return

GetRandom2:
ldr	r0,IdentityProblemsMugs
bl	CountMugList
cmp	r0,#0
beq	End
mov	r5,r0
ldr	r1,IdentityRamByte
ldrb	r0,[r1]
cmp	r0,r5
blo	HaveIdMug
mov	r0,r5
ldr	r3,=NextRN_N
mov	lr,r3
nop
nop
nop
nop
.short	0xF800
ldr	r1,IdentityRamByte
strb	r0,[r1]
HaveIdMug:
ldr	r2,IdentityProblemsMugs
ldrb	r0,[r2,r0]
b Return

CountMugList:
	mov r1, r0
	mov r0, #0
CountMugListLoop:
	ldrb r2, [r1, r0]
	cmp r2, #0
	beq CountMugListDone
	add r0, #1
	b CountMugListLoop
CountMugListDone:
	bx lr

End:
mov r0, #0x00
Return:
pop { r4, r5 }
pop { r1 }
bx r1

.ltorg
.align
MugList:
@POIN MugList
@POIN SkillTester
@WORD RandomMugID
@WORD IdentityProblemsID
@WORD IdentityRamByte
@POIN IdentityProblemsMugs
