.thumb
@ FE7 CheckBattleUnitStatCaps — Mag cap before Luk check.
@ Hook at 0x29A50 (start of Luk cap block).

mov r0, #0x47  @ mag
ldsb r0, [r2, r0] @ Unit->Mag

mov r3, r12
add r3, #0x7A
mov r1, #0x0
ldsb r1, [r3, r1] @ BattleUnit->changeCon (Mag)
add r0, r0, r1

@ get mag cap
mov r3, r12
ldr r3, [r3, #0x4]
ldrb r3, [r3, #0x4]  @ Class ID
lsl r3, #0x2

ldr r1, MagClassTable
add r3, r1

ldrb r1, [r3, #0x2] @ Mag cap
cmp r0, r1
ble ContinueLuk
    mov r0, #0x47
    ldrb r0, [r2, r0]
    sub r0, r1, r0
    mov r3, r12
    add r3, #0x7A
    strb r0, [r3, #0x0]

ContinueLuk:
@ Original Luk cap check entry
mov r0, #0x19
ldsb r0, [r2, r0]
mov r3, r12
add r3, #0x79

ldr r1, =0x08029A59|1
bx r1

.ltorg
.align 4
MagClassTable:
