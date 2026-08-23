@801849c updates rescuee's coords (called at 80187ac)

@at 80187b0 hook with jumptohack

@ Snek:
	@ Integrated into Post-Action calc loop to resolve lunge/stairs/escape-arrive conflict

.thumb
push { lr }
ldr r0, =0x8018d0c
mov lr, r0
ldr r0, =0x203A85C      @action struct
ldrb r0, [r0, #0xd]     @target
cmp r0, #0
beq End
.short 0xf800
@r0 is the target
ldr r1, =0x8017f28      @update rescuee
mov lr, r1
.short 0xf800
End:
pop { r0 }
bx r0

@End:
@pop {r4-r6}
@pop {r0}
@bx r0
