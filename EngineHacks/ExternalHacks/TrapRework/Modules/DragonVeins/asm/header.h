.set ActiveUnitPtr, 0x3004690
.set AddToTargetList, 0x804acfc
.set GetCharData, 0x8018d0c

.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
