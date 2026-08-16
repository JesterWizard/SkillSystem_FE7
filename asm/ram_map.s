.section .rodata

@ =============================================================================
@ FE7 RAM map — assembles region fragments into one object
@ =============================================================================
@
@ Region sources (edit these, not this file, when adding symbols):
@ ram_map_iwram.s — IWRAM (0x03007A00–0x03007E00)
@ ram_map_ewram.s — EWRAM SkillSys window (0x0203F000–0x02040000)
@ ram_map_sram.s  — SRAM (0x0E000000–0x0E008000)
@
@ Fragments are .included here (not compiled separately) so bump-allocator
@ cursors carry across regions in a single assembly pass.
@ Guide: documentation/ram-map.md
@ =============================================================================

.macro SET_DATA name, value
 .global \name
 .type \name, object
 .set \name, \value
.endm

.macro SET_ARRAY name, value, size
 SET_DATA \name, \value
 .global \name\()End
 .type \name\()End, object
 .set \name\()End, (\value + \size)
.endm

.include "ram_map_iwram.s"
.include "ram_map_ewram.s"
.include "ram_map_sram.s"
