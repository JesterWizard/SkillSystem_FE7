@ FE7 definitions for AnimNumbers (lyn)

.macro SET_FUNC name, value
	.global \name
	.type   \name, function
	.set    \name, \value
.endm

.macro SET_DATA name, value
	.global \name
	.type   \name, object
	.set    \name, \value
.endm

SET_FUNC GetAnimPosition,            0x08054679
SET_FUNC GetAnimAnotherSide,         0x080547A9
SET_FUNC CheckFlag,                  0x080798F9
SET_FUNC Proc_Start,                0x08004495
SET_FUNC Proc_Find,                  0x080046A9
SET_FUNC Proc_End,                   0x08004585
SET_FUNC Proc_Break,                 0x080046A1
SET_FUNC EnablePaletteSync,          0x0800105D
SET_FUNC NewEkrsubAnimeEmulator,     0x08067301

SET_DATA ProcScr_efxDamageMojiEffectOBJ, 0x08BA41EC
SET_DATA gPaletteBuffer,             0x02022860
