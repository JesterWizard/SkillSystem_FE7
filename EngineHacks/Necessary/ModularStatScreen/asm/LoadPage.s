.thumb
.org 0x0

@ @branched to from 8895C via r1
@ @loads the byte to store at 2003BFC-1 from a place in ram, which I use to determine which aspect of a page should be shown.

@ ldrb	r4,[r5,#0x14]		@stat screen page //1
@ mov		r1,#0x3 //2
@ and		r1,r4 //3
@ strb	r1,[r2] //4
@ str		r0,[r2,#0xC] //5
@ sub		r3,r2,#0x1 
@ ldr		r1,RamLocation
@ ldrb	r1,[r1]
@ strb	r1,[r3]
@ mov		r3,#0x0
@ str		r3,[r2,#0x14] //6
@ bx		r14

@FE7 Addresses
@ 080814AC 2103   mov r1, #0x3   //Display Growths@@EA
@ 080814AE 7D27   ldrb r7, [r4, #0x14] # pointer:0202BC0C (ChapterData@ChapterData.Chapter Stuff &01=Stat screen page 1 (Inventory) (0=stats) (these are set after backing out of the stat menu) &02=Stat screen page 2 (Difficulty) &10=Set when on prep screen &40=Set for hard mode &80=Don't gain weapon exp (not sure what this is for))
@ 080814B0 4039   and r1 ,r7
@ 080814B2 7011   strb r1, [r2, #0x0]   //Stat Screens StatScreenStruct
@ 080814B4 60D0   str r0, [r2, #0xc]
@ 080814B6 6153   str r3, [r2, #0x14]

@ FE8 Addresses
@ 0808895C 7D2C   ldrb r4, [r5, #0x14] # pointer:0202BD04 (ChapterData@gChapterData.Chapter Stuff &01=Stat screen page 1 (Inventory) (0=stats) (these are set after backing out of stat menu) &02=Stat screen page 2 (Difficulty) &10=Set when on prep screen &40=Set for hard mode &80=Don't gain weapon exp (not sure what this is for))   //Fixed Skill SkillSystems 20171130@0008895C.bin@BIN
@ 0808895E 2103   mov r1, #0x3
@ 08088960 4021   and r1 ,r4
@ 08088962 7011   strb r1, [r2, #0x0]   //Stat Screens StatScreenStruct
@ 08088964 60D0   str r0, [r2, #0xc]   //gpStatScreenUnit
@ 08088966 6153   str r3, [r2, #0x14]   //gpCurrentHelpTextStruct

mov     r1, #0x3 
ldrb	r7,[r4,#0x14] //2		@stat screen page
and     r1,r7 //3
strb	r1,[r2] //4
str		r0,[r2,#0xC] //5
sub		r3,r2,#0x1
ldr		r1,RamLocation
ldrb	r1,[r1]
strb	r1,[r3]
mov		r3,#0x0
str		r3,[r2,#0x14] //6
bx		r14

.align
RamLocation:
