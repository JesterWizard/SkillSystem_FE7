@ Start Damage/Heal numbers animations. Args:
@   r0: AIS.
@   r1: 0 if OverDamage or OverHeal (recipient). 1 otherwise.
@   r2: X of previous damage display. 0 if there is none.
@   r3: Digitcount of previous damage display. 0 if there is none.
@ Return:
@   Digitcount of new damage display.
.thumb

.equ BATTLE_ANIMATION_NUMBERS_FLAG, 0xEE
.equ gBattleHitArray, 0x0203F000
.equ BattleBufferWidth, 4

push  {r4-r7, r14}
sub   sp, #0xC
mov   r4, r0
str   r1, [sp, #0x8]       @ Hook style: 0 = damage, 2 = heal. Keep off r5.
str   r2, [sp]
str   r3, [sp, #0x4]


ldr   r0, =BATTLE_ANIMATION_NUMBERS_FLAG
lsl   r0, #0x5
lsr   r0, #0x5
ldr   r3, =CheckFlag
bl    GOTO_R3
cmp   r0, #0x0
bne   End

  @ Flag unset, display damage numbers.
  @ Recipient's AIS might still be finishing up their round,
  @ so we grab the highest round.
  mov   r0, r4
  ldr   r3, =GetAnimAnotherSide
  bl    GOTO_R3
  ldrh  r0, [r0, #0xE]
  ldrh  r1, [r4, #0xE]
  cmp   r0, r1
  bge   Max
    mov   r0, r1
  Max:
  
  sub   r0, #0x1
  mov   r1, #BattleBufferWidth
  mul   r0, r1
  ldr   r1, =gBattleHitArray
  add   r6, r0, r1          @ Current round in battle buffer.

  @ FE7 BattleHit is 4 bytes: attributes, info, s8 hpChange at +0x3.
  mov   r7, #0x3
  ldsb  r7, [r6, r7]      @ Damage/heal.
  cmp   r7, #0x0
  beq   End
  
    @ Pick damage vs heal blit proc from hook arg (stack), not r5.
    ldr   r0, =BAN_Proc_DelayDigitsDamage
    ldr   r1, [sp, #0x8]
    cmp   r1, #0x2
    bne   ProcOk
      ldr   r0, =BAN_Proc_DelayDigitsHeal
    ProcOk:
    mov   r1, #0x3
    ldr   r3, =Proc_Start
    bl    GOTO_R3
    strh  r7, [r0, #0x2A]   @ Amount (blitter takes abs).
    mov   r7, r0
    mov   r0, #0x2A
    ldsh  r0, [r7, r0]
    cmp   r0, #0x0
    bge   Abs
      neg   r0, r0
    Abs:
    mov   r6, #0x1
    FindDigitCountLoop:
      mov   r1, #0xA
      swi   #0x6
      cmp   r0, #0x0
      beq   EndLoop
        add   r6, #0x1
        b     FindDigitCountLoop
    EndLoop:
    cmp   r6, #0x5
    ble   DigitCountOk
      mov   r6, #0x5
    DigitCountOk:
    mov   r0, #0x29
    strb  r6, [r7, r0]      @ Number of digits.
    mov   r0, r4
    ldr   r3, =GetAnimPosition
    bl    GOTO_R3
    mov   r1, #0x2C
    strb  r0, [r7, r1]      @ AISSubjectId. 0 if left, 1 if right.

    @ Start AIS. FE7 banim UI: pals 5/7/9. Weapon icons: 13/14.
    @ Pal 1 has no banim refs — use for both sides.
    mov   r3, r6
    mov   r2, r0
    mov   r1, #0x1             @ OBJ pal 1
    mov   r0, r4
    bl    StartAIS
    mov   r0, r6              @ Return digit count (not the r1 flag).


End:
add   sp, #0xC
pop   {r4-r7}
pop   {r1}
bx    r1
GOTO_R3:
bx    r3
GOTO_R7:
bx    r7


@ Starts an EkrsubAnimeEmulator which mimics an AIS.
@ Also starts an gProc_efxDamageMojiEffectOBJ to align
@ the EkrsubAnimeEmulator X value and end it when it finishes.
@ Args:
@   r0:     AIS. Used for its X and Y values.
@   r1:     palette index
@   r2:     AISSubjectId. 0 if left, 1 if right.
@   r3:     Number of digits. Determines which frameData to use.
@   [sp]:   X of previous damage display. 0 if there is none.
@   [sp+4]: Digitcount of previous damage display. 0 if there is none.
@ Returns:
@   The EkrsubAnimeEmulator proc.
StartAIS:
push  {r4-r7, r14}
mov   r4, r0
mov   r5, r1
mov   r6, r3
sub   sp, #0xC


@ Prep stack args (must be full words — NewEkrsubAnimeEmulator ldr's them).
mov   r0, #0x0
str   r0, [sp]
str   r0, [sp, #0x4]
str   r0, [sp, #0x8]
mov   r0, #0x3
str   r0, [sp, #0x8]      @ Parent proc (tree 3).
lsl   r0, r5, #0x4
add   r0, #0x1
lsl   r0, #0x8
lsl   r2, #0x4
add   r0, r2
str   r0, [sp]            @ OAM2.


@ Check if digits overlap.
@ If they do, raise current AIS' digits.
mov   r7, #0x28           @ Y if no overlap.
ldr   r2, [sp, #0x24]     @ Digitcount0.
cmp   r2, #0x0
beq   NoOverlap
  mov   r1, #0x2
  ldsh  r1, [r4, r1]      @ X0.
  ldr   r0, [sp, #0x20]   @ X1.
  @mov   r3, r6           @ Digitcount1.
  cmp   r0, r1
  ble   NoFlip
    mov   r7, r0          @ Ensure X0 <= X1.
    mov   r0, r1 
    mov   r1, r7
    mov   r7, r2
    mov   r2, r3
    mov   r3, r7
    mov   r7, #0x28       @ Y if no overlap.
  NoFlip:
  lsl   r2, #0x3          @ Half of length of digits (16 pixels each).
  add   r2, #0x4          @ Half of length of plus or minus (8 pixels).
  add   r2, r0            @ Right-most pixel of left number.
  lsl   r3, #0x3          @ Half of length of digits (16 pixels each).
  add   r3, #0x4          @ Half of length of plus or minus (8 pixels).
  sub   r3, r1, r3        @ Left-most pixel of right number.
  sub   r0, r3, r2
  cmp   r0, #0x0
  bge   Abs2
    neg   r0, r0          @ Take absolute value of distance.
  Abs2:
  cmp   r0, #0x8
  bgt   NoOverlap
    mov   r7, #0x38       @ Heighten digits to avoid overlap.
NoOverlap:


@ Prep other args.
mov   r3, #0x2
ldr   r0, =frameData-4
lsl   r1, r6, #0x2
ldr   r2, [r0, r1]        @ frameData, differs depending on number of digits.
mov   r0, #0x2
ldsh  r0, [r4, r0]        @ X.
mov   r1, #0x4
ldsh  r1, [r4, r1]
sub   r1, r7              @ Y.
ldr   r7, =NewEkrsubAnimeEmulator
bl    GOTO_R7
mov   r5, r0

@ Start gProc_efxDamageMojiEffectOBJ
ldr   r0, =ProcScr_efxDamageMojiEffectOBJ
mov   r1, #0x3
ldr   r3, =Proc_Start
bl    GOTO_R3
mov   r6, r0
str   r4, [r6, #0x5C]     @ AIS.
mov   r0, #0x0
strh  r0, [r6, #0x2C]     @ Timer.
mov   r0, #0x32
strh  r0, [r6, #0x2E]     @ Endtime, 50 frames.
str   r5, [r6, #0x60]     @ EkrsubAnimeEmulator proc.


mov   r0, r5
add   sp, #0xC
pop   {r4-r7}
pop   {r1}
bx    r1

.align
frameData:
.word BAN_Digits1FD
.word BAN_Digits2FD
.word BAN_Digits3FD
.word BAN_Digits4FD
.word BAN_Digits5FD
