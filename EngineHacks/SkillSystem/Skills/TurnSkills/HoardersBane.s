.thumb 
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ DarkBargain_ExpSpent, 0x02026B8C
.equ EventEngine, 0x800D07C
.equ ActionData, 0x203A868 
.equ VulneraryHealAmount, 0x802D1E2 
.equ ProcStartBlocking, 0x80044F8 
.equ ProcGoto, 0x8004720 
.equ GetUnit, 0x8018d0c
.equ HasConvoyAccess, 0x802E819
@ Convoy slot count. Do NOT read this from 0x802E7B8: that address is the
@ `cmp r3, #0x63` instruction inside AddItemToConvoy, not a variable. The old
@ code scraped its immediate byte as the size, which only ever worked by
@ accident and went stale-by-one once ExpandedConvoy patched it to 0xC7 (199)
@ for a 200-slot convoy -- hiding the last slot from the search and the pack.
.equ ConvoyItemCount, 200
.equ ConvoyPointer, 0x802E7B0 
.equ GetItemAfterUse, 0x801672e
.equ RemoveUnitBlankItems, 0x8017688 

.equ DeployByte,                        0   @ 0x2c 
.equ FuncCoun,                          1   @ 0x2d 
.equ Destructor,                        2   @ 0x2e 
.equ TryPhaseBool,                      3   @ 0x2f 
.equ EndOfDeployByte,           4           @ 0x30 
.equ SkillBufferCounter,        5           @ 0x31 
.equ healAmount,                        7   @ 0x32 
.equ SkillBuffer,                       8   @ 0x34 
.equ pUnit,                             12  @ 0x38 
.equ FirstFunc,                         16  @ 0x3c 


.global CallEndOfTurnHealLoop
.type CallEndOfTurnHealLoop, %function 
CallEndOfTurnHealLoop: 
push {r4, lr} 
mov r4, r0                                  @ proc 
mov r1, r4                                  @ to block 
ldr r0, =EndOfTurnHealLoopProc
blh ProcStartBlocking 
add r0, #0x2c 
add r4, #0x2c 

ldrb r1, [r4, #DeployByte] 
strb r1, [r0, #DeployByte] 
ldrb r1, [r4, #FuncCoun] 
strb r1, [r0, #FuncCoun] 
ldrb r1, [r4, #Destructor] 
strb r1, [r0, #Destructor] 
ldrb r1, [r4, #TryPhaseBool] 
strb r1, [r0, #TryPhaseBool] 
ldrb r1, [r4, #EndOfDeployByte] 
strb r1, [r0, #EndOfDeployByte] 
ldrb r1, [r4, #SkillBufferCounter] 
strb r1, [r0, #SkillBufferCounter] 
ldr r1, [r4, #SkillBuffer] 
str r1, [r0, #SkillBuffer] 
ldr r1, [r4, #pUnit] 
str r1, [r0, #pUnit] 
ldr r1, [r4, #FirstFunc] 
str r1, [r0, #FirstFunc] 

mov r1, #0 
strb r1, [r0, #healAmount] 



pop {r4} 
pop {r0} 
bx r0 
.ltorg 

.global EndOfTurnCalcLoop_CanUnitHeal
.type EndOfTurnCalcLoop_CanUnitHeal, %function 
EndOfTurnCalcLoop_CanUnitHeal:
@ given r0 = valid unit 
ldrb r1, [r0, #0x13]                        @ curr hp 
ldrb r2, [r0, #0x12]                        @ max 
cmp r1, r2 
bge CannotHeal 
mov r0, #1                                  @ can heal 
b Exit_CanUnitHeal 

CannotHeal: 
mov r0, #0 
Exit_CanUnitHeal: 
bx lr 
.ltorg 

FindItemInInv:
@ r0 = unit 
@ r1 = item ID 
mov r2, #0x1C                               @ inv - 2
InvLoop: 
add r2, #2 
cmp r2, #0x28                               @ wexp start 
bge BreakInvLoop2 
ldrh r3, [r0, r2] 
cmp r3, #0 
beq BreakInvLoop2 
lsl r3, #24 
lsr r3, #24                                 @ item id only 
cmp r1, r3
bne InvLoop 
mov r0, r2                                  @ unit offset 
b ExitFindItemInInv

BreakInvLoop2: 
mov r0, #0                                  @ no item 

ExitFindItemInInv: 
bx lr 
.ltorg 


FindItemInConvoy: 
@ r0 = item ID 
mov  r3, #ConvoyItemCount                   @ slots, not a scraped opcode byte
ldr  r2, =ConvoyPointer	
ldr  r2, [r2]
lsl  r3, #0x01                              @end = size*2 + convoy
add  r3, r2
sub r2, #2 
ConvoyLoop: 
add r2, #2 
cmp r2, r3 
bge NoItemFoundInConvoy 
ldrb r1, [r2] 
cmp r1, r0 
bne ConvoyLoop 
ldr r0, =ConvoyPointer                      @pointer to convoy	
ldr r0, [r0] 
sub r2, r0                                  @ offset 
mov r0, r2 
b ExitFoundInConvoy


NoItemFoundInConvoy: 
mov r0, #0 
sub r0, #1 
ExitFoundInConvoy: 
bx lr 
.ltorg 




.global HoardersBane_CanUnitHeal 
.type HoardersBane_CanUnitHeal, %function 
HoardersBane_CanUnitHeal: 
push {r4-r6, lr} 
@ given r0 = valid unit with the skill 
@ check if they meet any other requirements (eg. have vulneraries in supply & aren't at full hp) 

mov r4, r0                                  @ unit 
ldr r5, =VulneraryItemID_Link 
ldr r5, [r5] 
mov r1, r5 
bl FindItemInInv 
cmp r0, #0 
bne HoardersBaneUsability_True

BreakInvLoop: 
ldrb r3, [r4, #0x0B]                        @ NPCs / Enemies cannot access the supply 
lsr r3, #6 
cmp r3, #0 
bne HoardersBaneUsability_False 
ldr r3, HoardersBane_UseConvoyLink 
cmp r3, #0 
beq HoardersBaneUsability_False

mov r0, r4                                  @ unit 
blh HasConvoyAccess 
cmp r0, #0 
beq HoardersBaneUsability_False 
@ search convoy for vulnerary 
mov r0, r5                                  @ vuln item ID 
bl FindItemInConvoy
mov r1, #0 
sub r1, #1 
cmp r0, r1
bne HoardersBaneUsability_True

HoardersBaneUsability_False:
mov r0, #0 
b HoardersBaneUsability_Exit

HoardersBaneUsability_True:
mov r0, #1 

HoardersBaneUsability_Exit: 

pop {r4-r6} 
pop {r1} 
bx r1 
.ltorg 


.global HoardersBane_HealAmount
.type HoardersBane_HealAmount, %function 
HoardersBane_HealAmount: 
push {r4-r6, lr} 
@ remove 1 use of vulnerary, wherever it may be 
mov r4, r0                                  @ unit id 
ldr r5, =VulneraryItemID_Link 
ldr r5, [r5] 
mov r1, r5 
bl FindItemInInv 
cmp r0, #0 
beq TrySupply 
mov r6, r0                                  @ item offset 
ldrh r0, [r4, r6] 
blh GetItemAfterUse 
strh r0, [r4, r6] 
cmp r0, #0 
bne NoPack 
mov r0, r4 
blh RemoveUnitBlankItems 
NoPack: 
b Exit_HoardersBane_HealAmount 
TrySupply: 
mov r0, r5                                  @ vuln 
bl FindItemInConvoy                         @ returns offset in convoy if found, 0xFFFFFFFF otherwise 
mov r1, #0 
sub r1, #1 
cmp r0, r1
beq Exit_HoardersBane_HealAmount 
mov r6, r0 
ldr r5, =ConvoyPointer 
ldr r5, [r5] 
ldrh r0, [r5, r6] 
blh GetItemAfterUse 
strh r0, [r5, r6] 
cmp r0, #0 
bne NoPackSupply 

mov r4, #ConvoyItemCount 
lsl r4, #1                                  @ 2 bytes per entry 
add r4, r5                                  @ end of convoy 
add r5, r6                                  @ where to start 
PackSupplyLoop: 

ldrh r0, [r5, #2]
strh r0, [r5] 
add r5, #2  
cmp r5, r4 
bge NoPackSupply 
b PackSupplyLoop 
NoPackSupply: 

Exit_HoardersBane_HealAmount: 
@ this is the only part the parent cares about 
ldr r0, =VulneraryHealAmount 
ldrb r0, [r0] 
pop {r4-r6}
pop {r1} 
bx r1 
.ltorg 

.global EndOfTurn_HealLoop_FindNextValidUnit
.type EndOfTurn_HealLoop_FindNextValidUnit, %function 
EndOfTurn_HealLoop_FindNextValidUnit: 
push {r4-r7, lr} 
@ given r0 = deployment byte to search from, 
@ r1 = deployment byte to stop at 
@ find the next unit meeting the criteria 

mov r4, r0                                  @ deployment byte 

@ r5 = unit 
mov r6, r1                                  @ where to stop 

mov r7, r2                                  @ proc + 0x2c 

UnitLoop: 
mov r5, #0 
strb r5, [r7, #healAmount] 
strb r5, [r7, #SkillBufferCounter] 
mov r0, r4                                  @ deployment byte 
add r4, #1 
cmp r0, r6
bge NoValidUnit 

blh GetUnit
mov r5, r0                                  @ unit 

mov r0, r5                                  @ unit 
bl IsUnitOnField 
cmp r0, #1 
bne UnitLoop 
mov r0, r5                                  @ unit 
bl EndOfTurnCalcLoop_CanUnitHeal
cmp r0, #0 
beq UnitLoop 

mov r0, r5                                  @ unit 
ldr r1, [r7, #SkillBuffer]
bl MakeSkillBuffer 

SkillBufferLoop: 
ldr r1, [r7, #SkillBuffer] 
ldrb r2, [r7, #SkillBufferCounter] 
add r2, #1 
strb r2, [r7, #SkillBufferCounter] 
ldrb r0, [r1, r2]                           @ current skill 
cmp r0, #0 
beq MaybeHeal 
ldr r3, =EndOfTurn_HealSkillTable
lsl r0, #3                                  @ 8 bytes per 
add r3, r0 
ldr r0, [r3]                                @ usability 
cmp r0, #0 
beq SkillBufferLoop 
mov lr, r0 
mov r0, r5                                  @ unit 
push {r3} 
.short 0xf800                               @ returns if usable or not 
pop {r3} 
cmp r0, #0 
beq SkillBufferLoop
ldr r0, [r3, #4]                            @ returns amount to heal 
mov lr, r0 
mov r0, r5                                  @ unit (in case it matters fsr) 
.short 0xf800 
cmp r0, #0 
beq SkillBufferLoop 
@r0 = amount to heal 


@ r5 has a valid unit 
ldrb r1, [r7, #healAmount] 
add r1, r0 
cmp r1, #127 
blt NoCap 
mov r1, #127 
NoCap: 
strb r1, [r7, #healAmount] 
b SkillBufferLoop 
MaybeHeal: 
ldrb r0, [r7, #healAmount] 
cmp r0, #0 
beq UnitLoop 

NoValidUnit: 
mov r0, r5 

pop {r4-r7} 
pop {r1} 
bx r1
.ltorg 


.global ExecuteFirstUnitHeal 
.type ExecuteFirstUnitHeal, %function 
ExecuteFirstUnitHeal: 
push {lr} 
mov r3, #0x2C 
add r3, r0
ldrb r2, [r3, #healAmount] 
mov r1, #0 
strb r1, [r3, #healAmount] 
ldr r1, [r3, #pUnit] 
bl HealAnim                                 @ starts a blocking proc 

mov r0, #0                                  @ always yield 
pop {r1} 
bx r1 
.ltorg 

.global EndOfTurn_HealLoop_End
.type EndOfTurn_HealLoop_End, %function 
EndOfTurn_HealLoop_End: 
ldr r1, [r0, #0x14]                         @ parent proc 
add r1, #0x2c 
ldrb r2, [r1, #FuncCoun] 
add r2, #2                                  @ we finished this function 
strb r2, [r1, #FuncCoun] 
bx lr 
.ltorg 

.global EndOfTurn_HealLoop_IterateLoop
.type EndOfTurn_HealLoop_IterateLoop, %function 
EndOfTurn_HealLoop_IterateLoop: 
push {r4-r5, lr}  
mov r4, r0                                  @ parent proc 
add r4, #0x2C 
ldrb r0, [r4, #DeployByte] 
ldrb r1, [r4, #EndOfDeployByte] 
mov r2, r4                                  @ parent proc + 0x2c 
bl EndOfTurn_HealLoop_FindNextValidUnit
cmp r0, #0 
beq BreakHoardersBane 
ldrb r1, [r0, #0x0B]                        @ deployment byte 
strb r1, [r4, #DeployByte]                  @ next search will start +1 higher 
str r0, [r4, #pUnit]                        @ unit +0x3C 
mov r5, r0                                  @ unit 
mov r0, r4                                  @ proc 
mov r1, #0x2C 
sub r0, r1 
mov r1, r5                                  @ unit 
ldrb r2, [r4, #healAmount] 
bl HealAnim                                 @ starts a blocking proc 
ldrb r0, [r4, #DeployByte] 
add r0, #1 
strb r0, [r4, #DeployByte] 
b HoardersBane_True 


BreakHoardersBane: 
mov r0, r4 
sub r0, #0x2C 
mov r1, #1                                  @ label 
blh ProcGoto 
mov r0, #1
b HoardersBane_False                        @ don't yield for a frame 


HoardersBane_True: 
mov r0, #0                                  @ has a child proc, so yield for a frame (0) 
b ExitHoardersBane 
HoardersBane_False: 
mov r0, #1                                  @ skipped this time 

ExitHoardersBane: 
pop {r4-r5} 
pop {r1} 
bx r1
.ltorg 

@ r0 = unit. Hide SMS, clear grey so the MU is active. r0 = original state.
.global HealAnim_PrepSprite
.type HealAnim_PrepSprite, %function 
HealAnim_PrepSprite:
ldr r1, [r0, #0x0C] 
mov r2, r1 
mov r3, #0x42                       @ unselectable | has moved 
bic r2, r3 
mov r3, #1                          @ hidden (SMS off while MU plays) 
orr r2, r3 
str r2, [r0, #0x0C] 
mov r0, r1 
.global HealAnim_PrepSprite_Exit
HealAnim_PrepSprite_Exit:
bx lr 
.ltorg 

@ r0 = unit, r1 = saved state. Do not invent unselectable.
.global HealAnim_RestoreSprite
.type HealAnim_RestoreSprite, %function 
HealAnim_RestoreSprite:
str r1, [r0, #0x0C] 
.global HealAnim_RestoreSprite_Exit
HealAnim_RestoreSprite_Exit:
bx lr 
.ltorg 

HealAnim:
	push {r4-r7, lr}

        mov  r4, r0                         @ var r4 = proc
        mov  r5, r1                         @ var r5 = unit
        mov r6, r2                          @ var r6 = heal amount 

        mov r0, r5 
        bl HealAnim_PrepSprite 
        mov r7, r0                          @ original unit state 

        mov r0, r5                          @ arg1: Unit
        mov r1, r6                          @ arg2: Heal value
        blh  0x08032858                     @BeginUnitHealAnim	{U}

        @ Dark Bargain: EXP bar counts from expPrevious down by expGain.
        ldr r0, =DarkBargain_ExpSpent 
        ldrb r1, [r0] 
        cmp r1, #0 
        beq SkipDarkBargainExp 
        mov r2, #0 
        strb r2, [r0] 
        ldr r0, =0x0203A3F0                 @ gBattleActor 
        mov r3, #0x71 
        ldrb r2, [r0, r3]                   @ expPrevious (copied remaining) 
        add r2, r1 
        strb r2, [r0, r3]                   @ original exp 
        neg r1, r1 
        mov r3, #0x6E 
        strb r1, [r0, r3]                   @ expGain = -spent 
SkipDarkBargainExp: 

	@アニメーションが終わるまでイベントを待機させる
	ldr r0, =WaitForVulneraryEndProc
	mov r1 ,r4
        blh  0x080044f8                     @NewBlocking6C	@{U}

        ldr r1, =0x8C9D634                  @gProc_MapAnimBattle	{U}
	add r0, #0x2c 
	str	r7, [r0]                        @ saved unit state 
	str	r1, [r0, #FirstFunc]
	str	r5, [r0, #pUnit]

        @ Keep the MOVEUNIT visible (0 = shown). Unit Hidden keeps SMS off.
ldr r0, =0x8C9D00C                          @gProc_MoveUnit
blh 0x80046A8                               @ ProcFind 
cmp r0, #0 
beq SkipHidingInProc
add r0, #0x40 
mov r1, #0 
strb r1, [r0] 
SkipHidingInProc: 

ldr r0, =0x202E3DC                          @ Unit map	{U}
ldr r0, [r0] 
mov r1, #0
blh 0x080190AC                              @ FillMap 
blh 0x08019868                              @UpdateUnitMapAndVision
blh 0x08019A68                              @UpdateTrapHiddenStates
blh  0x08025724                             @SMS_UpdateFromGameData
blh  0x08019504                             @UpdateGameTilesGraphics
pop {r4-r7} 
pop {r0} 
bx r0 
.ltorg 




.type WaitForVulneraryEnd, %function 
.global WaitForVulneraryEnd 
WaitForVulneraryEnd:
push {r4,r5,r6,lr}
mov r4 ,r0

@ 0x2Cで指定しているアニメーションProcsが終わるまで待ちます
@ arg r0 = target proc 
add r0, #0x2c 
ldr r0, [r0, #FirstFunc]
blh 0x080046a8                              @Fin6C	{U}



@blh 0x08002DEC	@Fin6C	{J}
cmp r0 ,#0x0
bne ExitWait
	@ユニットが移動中のモーションが残ってしまうので消す
        blh 0x0806CCB8                      @ClearMOVEUNITs	{U}
	@blh 0x0807B4B8       @ClearMOVEUNITs	{J}

        ldr  r6, =0x0203A3F0                @BattleUnit@gBattleActor	{U}	戦闘アニメで右側.CopyUnit
	@ldr r6, =0x0203A4E8 @BattleUnit@gBattleActor	{J}	戦闘アニメで右側.CopyUnit
	ldrb r0, [r6, #0xb]
        blh 0x08018d0c                      @GetUnitStruct	{U}
	@blh 0x08019108       @GetUnitStruct	{J}
        mov r5, r0                          @Unit

	@回復やダメージの結果をRAMUnitに書き戻して確定させます
        mov r0, r5                          @Arg1: Unit
        mov r1, r6                          @Arg2: 戦闘アニメで右側.CopyUnit
        blh 0x08029c24                      @SaveUnitFromBattle	{U}
	@blh 0x0802C134   @SaveUnitFromBattle	{J}

	@もしユニットのHPが0になってしまっているなら死亡させる
        mov r0, r5                          @Arg1 Unit
        blh 0x08032710                      @KillUnitIfNoHealth	{U}

        blh 0x08019ABC                      @RefreshEntityBmMaps	{U}

	@マップアニメーションが終わったのでループを抜ける
	mov r0 ,r4
        blh 0x080046a0                      @Break6CLoop	{U}
	@blh 0x08002DE4   @Break6CLoop	{J}
ldr r0, =0x8C9D00C                          @gProc_MoveUnit
blh 0x80046A8                               @ ProcFind 
cmp r0, #0 
beq SkipHidingInProc2
add r0, #0x40                               @this is what MU_Hide does @MU_Hide, 0x80797D5
mov r1, #1 
strb r1, [r0]                               @ store back 0 to show active MMS again aka @MU_Show, 0x80797DD
SkipHidingInProc2: 
mov r0, r5 
ldr r1, [r4, #0x2C]                         @ state from before the anim 
bl HealAnim_RestoreSprite 
ldr r3, =0x03004690                         @CurrentUnit 
ldr r3, [r3]
cmp r3, #0 
beq NoActiveUnit2
NoActiveUnit2:

ldr r0, =0x202E3DC                          @ Unit map	{U}
ldr r0, [r0] 
mov r1, #0
blh 0x080190AC                              @ FillMap 
blh 0x08019868                              //UpdateUnitMapAndVision
blh 0x08019A68                              //UpdateTrapHiddenStates
blh  0x08025724                             @SMS_UpdateFromGameData
blh  0x08019504                             @UpdateGameTilesGraphics

ExitWait:
pop {r4,r5,r6}
pop {r0}
bx r0

.ltorg 
HoardersBane_UseConvoyLink: 
