.thumb

@ Applied rally bits live in BWL+0x0F (see Documentation/BWLData.md).
@ Bit order matches RallySkillList: Str Skl Spd Def Res Luk Mov Spectrum Mag.
@ Mag lives in BWL+0x0E bit 7; the rest in BWL+0x0F.

.equ RALLY_FLAG_STR,  0x01
.equ RALLY_FLAG_SKL,  0x02
.equ RALLY_FLAG_SPD,  0x04
.equ RALLY_FLAG_DEF,  0x08
.equ RALLY_FLAG_RES,  0x10
.equ RALLY_FLAG_LUK,  0x20
.equ RALLY_FLAG_MOV,  0x40
.equ RALLY_FLAG_SPEC, 0x80

.global prRallyMag
.type prRallyMag, %function
prRallyMag:
push { r4 - r5, lr }
mov r5, r0 @ Stat
mov r4, r1 @ Unit
bl AddRallySpectrum
add r5, r0
mov r0, r4
bl GetUnitRallyMagFlag
cmp r0, #0
beq ExitMag
ldr r0, =MagRallyAmount_Link
ldr r0, [r0]
add r5, r0
ExitMag:
mov r0, r5
pop {r4-r5}
pop {r2}
bx r2
.ltorg

AddRallySpectrum:
push {lr}
mov r0, r1 @ unit
bl GetUnitBwlRallyFlags
mov r1, #RALLY_FLAG_SPEC
and r0, r1
cmp r0, #0
beq AddZero
ldr r0, =SpecRallyAmount_Link
ldr r0, [r0]
b ExitSpec
AddZero:
mov r0, #0
ExitSpec:
pop {r1}
bx r1
.ltorg

IsRallySet:
@ r1 = unit, r2 = bit mask
push {r4, lr}
mov r4, r2
mov r0, r1
bl GetUnitBwlRallyFlags
and r0, r4
cmp r0, #0
beq Exit
mov r0, #1
Exit:
pop {r4}
pop {r1}
bx r1
.ltorg

.global prRallyStr
.type prRallyStr, %function
prRallyStr:
push { r4 - r5, lr }
mov r5, r0 @ Stat
mov r4, r1 @ Unit
bl AddRallySpectrum
add r5, r0
mov r1, r4
mov r2, #RALLY_FLAG_STR
bl IsRallySet
cmp r0, #0
beq ExitStr
ldr r0, =StrRallyAmount_Link
ldr r0, [r0]
add r5, r0
ExitStr:
mov r0, r5
pop {r4-r5}
pop {r2}
bx r2
.ltorg

.global prRallySkl
.type prRallySkl, %function
prRallySkl:
push { r4 - r5, lr }
mov r5, r0 @ Stat
mov r4, r1 @ Unit
bl AddRallySpectrum
add r5, r0
mov r1, r4
mov r2, #RALLY_FLAG_SKL
bl IsRallySet
cmp r0, #0
beq ExitSkl
ldr r0, =SklRallyAmount_Link
ldr r0, [r0]
add r5, r0
ExitSkl:
mov r0, r5
pop {r4-r5}
pop {r2}
bx r2
.ltorg

.global prRallySpd
.type prRallySpd, %function
prRallySpd:
push { r4 - r5, lr }
mov r5, r0 @ Stat
mov r4, r1 @ Unit
bl AddRallySpectrum
add r5, r0
mov r1, r4
mov r2, #RALLY_FLAG_SPD
bl IsRallySet
cmp r0, #0
beq ExitSpd
ldr r0, =SpdRallyAmount_Link
ldr r0, [r0]
add r5, r0
ExitSpd:
mov r0, r5
pop {r4-r5}
pop {r2}
bx r2
.ltorg

.global prRallyDef
.type prRallyDef, %function
prRallyDef:
push { r4 - r5, lr }
mov r5, r0 @ Stat
mov r4, r1 @ Unit
bl AddRallySpectrum
add r5, r0
mov r1, r4
mov r2, #RALLY_FLAG_DEF
bl IsRallySet
cmp r0, #0
beq ExitDef
ldr r0, =DefRallyAmount_Link
ldr r0, [r0]
add r5, r0
ExitDef:
mov r0, r5
pop {r4-r5}
pop {r2}
bx r2
.ltorg

.global prRallyRes
.type prRallyRes, %function
prRallyRes:
push { r4 - r5, lr }
mov r5, r0 @ Stat
mov r4, r1 @ Unit
bl AddRallySpectrum
add r5, r0
mov r1, r4
mov r2, #RALLY_FLAG_RES
bl IsRallySet
cmp r0, #0
beq ExitRes
ldr r0, =ResRallyAmount_Link
ldr r0, [r0]
add r5, r0
ExitRes:
mov r0, r5
pop {r4-r5}
pop {r2}
bx r2
.ltorg

.global prRallyLuk
.type prRallyLuk, %function
prRallyLuk:
push { r4 - r5, lr }
mov r5, r0 @ Stat
mov r4, r1 @ Unit
bl AddRallySpectrum
add r5, r0
mov r1, r4
mov r2, #RALLY_FLAG_LUK
bl IsRallySet
cmp r0, #0
beq ExitLuk
ldr r0, =LukRallyAmount_Link
ldr r0, [r0]
add r5, r0
ExitLuk:
mov r0, r5
pop {r4-r5}
pop {r2}
bx r2
.ltorg

.global prRallyMov
.type prRallyMov, %function
prRallyMov:
push { r4 - r5, lr }
mov r5, r0 @ Stat
mov r4, r1 @ Unit
mov r1, r4
mov r2, #RALLY_FLAG_MOV
bl IsRallySet
cmp r0, #0
beq ExitMov
ldr r0, =MovRallyAmount_Link
ldr r0, [r0]
add r5, r0
ExitMov:
mov r0, r5
pop {r4-r5}
pop {r2}
bx r2
.ltorg
