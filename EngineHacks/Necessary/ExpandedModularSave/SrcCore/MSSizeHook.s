.thumb

@ FE7U: size literals in WriteSaveBlockInfo are patched from
@ ExModularSaveInternals.event. This file is kept so the lyn include
@ still resolves; the LynJump site was FE8-only.

.global MS_SaveSizeHook
.type   MS_SaveSizeHook, %function

MS_SaveSizeHook:
	bx lr

	.align
	.ltorg
