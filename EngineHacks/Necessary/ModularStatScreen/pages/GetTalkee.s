.thumb

GetTalkee:
@r0=char number
push	{r4,r5,r14}
mov		r4,r0
ldr		r0,GetChapterEvents
mov		r14,r0
ldr		r0,ChapterData
ldrb	r0,[r0,#0xE]			@chapter number
.short	0xF800
ldr		r5,[r0,#0x4]			@Talk events
TalkEventsLoop:
ldrb	r0,[r5,#0x2]			@that talk event's id
cmp		r0,#0x0
beq		GoBack
ldrb	r1,[r5,#0x8]			@char id that instigates the talk
cmp		r1,r4
bne		GetNextTalk
ldr		r1,CheckEventID			@make sure the talk hasn't occurred yet
mov		r14,r1
.short	0xF800
cmp		r0,#0x0
bne		GetNextTalk
ldrb	r0,[r5,#0x9]			@char id of person being talked to
bl		CheckIfOnField
cmp		r0,#0x0
beq		GetNextTalk
ldrb	r0,[r5,#0x9]
b		GoBack
GetNextTalk:
add		r5,#0x10
b		TalkEventsLoop
GoBack:
pop		{r4-r5}
pop		{r1}
bx		r1

.align
ChapterData:
.long 0x0202BBF8 //FE8 -> 0x0202BCF0
GetChapterEvents:
.long 0x080315BC //FE8 -> 0x080346B0
CheckEventID:
.long 0x08079910 //FE8 -> 0x08083DA8 not sure if this is right for FE7

CheckIfOnField:
push	{r4-r5,r14}
mov		r5,r0
mov		r4,#0x1
LoopThroughAll:
ldr		r0,GetCharData
mov		r14,r0
mov		r0,r4
.short	0xF800
cmp		r0,#0x0
beq		GetNextPerson
ldr		r2,[r0]
cmp		r2,#0x0
beq		GetNextPerson
ldr		r0,[r0,#0xC]
ldr		r1,BadTurnWord
tst		r0,r1
bne		GetNextPerson
ldrb	r2,[r2,#0x4]
cmp		r2,r5
bne		GetNextPerson
mov		r0,#0x1
b		FoundChar
GetNextPerson:
add		r4,#0x1
cmp		r4,#0xBF
ble		LoopThroughAll
mov		r0,#0x0
FoundChar:
pop		{r4-r5}
pop		{r1}
bx		r1

.align
GetCharData:
.long 0x08018D0C //FE8 -> 0x08019430
BadTurnWord:
.long 0x0001000C //FE7? 0x00010004 //FE8 -> 0x0001000C not sure if this is correct for FE7
