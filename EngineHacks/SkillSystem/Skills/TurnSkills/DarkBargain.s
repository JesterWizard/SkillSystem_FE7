.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
@ EWRAM scratch (ROM .byte cannot be written on hardware)
.equ DarkBargain_ExpSpent, 0x02026B8C

.global DarkBargain_CanUnitHeal
.type DarkBargain_CanUnitHeal, %function 
DarkBargain_CanUnitHeal:
ldrb r1, [r0, #9]       @ exp 
cmp r1, #0 
beq CannotHeal 
cmp r1, #100 
bge CannotHeal 
mov r0, #1 
b Exit_DarkBargain_CanUnitHeal 

CannotHeal: 
mov r0, #0 
Exit_DarkBargain_CanUnitHeal: 
bx lr 
.ltorg 


.global DarkBargain_HealAmount
.type DarkBargain_HealAmount, %function 
DarkBargain_HealAmount: 
ldrb r1, [r0, #9]       @ exp 
ldrb r2, [r0, #0x12]    @ max hp 
ldrb r3, [r0, #0x13]    @ current hp 
sub r2, r3              @ missing hp 
cmp r1, r2 
ble NoCapHeal 
mov r1, r2              @ spend only as much exp as hp missing 
NoCapHeal: 
ldrb r2, [r0, #9] 
sub r2, r1              @ remaining exp 
strb r2, [r0, #9] 
ldr r2, =DarkBargain_ExpSpent 
strb r1, [r2] 
mov r0, r1              @ amount to heal by 
bx lr 
.ltorg 

@ Vanilla MapAnimExpBar only increments. Dark Bargain needs a countdown.
.global MapAnimExpBar_Step
.type MapAnimExpBar_Step, %function 
MapAnimExpBar_Step:
push {r4-r6, lr} 
mov r4, r0 
mov r1, #0x64 
ldrh r5, [r4, r1]       @ expFrom 
mov r1, #0x66 
ldrh r6, [r4, r1]       @ expTo 
cmp r5, r6 
blt IncBar 
bgt DecBar 
b MapAnimExpBar_Step_Drawn 
IncBar: 
add r5, #1 
cmp r5, #100 
blt StoreBar 
mov r5, #0 
b StoreBar 
DecBar: 
sub r5, #1 
StoreBar: 
mov r1, #0x64 
strh r5, [r4, r1] 
.global MapAnimExpBar_Step_Drawn
MapAnimExpBar_Step_Drawn: 
mov r0, #6 
mov r1, #8 
mov r3, #0x64 
ldrh r2, [r4, r3] 
blh 0x0806FF18          @ DrawMAExpBar 
mov r3, #0x64 
ldrh r5, [r4, r3] 
mov r3, #0x66 
ldrh r0, [r4, r3] 
mov r1, #100 
swi #6                  @ Div: r1 = expTo % 100 
cmp r5, r1 
bne ExpBarStep_Exit 
mov r0, r4 
blh 0x080046A0          @ Proc_Break 
mov r0, #0xE5 
lsl r0, #2              @ FE7 EXP bar song 
blh 0x080BE660          @ m4aSongNumStop 
ExpBarStep_Exit: 
pop {r4-r6} 
pop {r1} 
bx r1 
.ltorg 
