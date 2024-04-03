
.macro SET_FUNC name, value
    .global \name
    .type   \name, %function
    .set    \name, \value
.endm

SET_FUNC EXPCalcLoop, (0x080295A0+1) //FE8 -> (0x0802b960+1)
