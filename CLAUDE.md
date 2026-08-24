# CLAUDE.md

FE7U Skill System **buildfile** (Event Assembler → `FE7_Hack.gba`). Not FEBuilder.

Always-on agent policy: `.cursor/rules/cheap.mdc` (Claude Code: `.claude/rules/cheap.mdc`).

Do **not** load these on a known-file patch. Request or open matching files only:

| When | File |
|------|------|
| Install order, skill layers, where-to-look | `.cursor/rules/build-wiring.mdc` |
| Domain words | `CONTEXT.md` |
| Table expansion | `.cursor/rules/fe7-freespace-tables.md` |
| New skill behavior / tests | `.cursor/rules/tdd.md` |
| Skill ASM must execute | `.cursor/rules/skill-unicorn-verification.md` |

When operating as Claude Fable, use the /efficient-fable skill always.
When using a high-cost frontier model for codebase-heavy work, use the /efficient-frontier skill always.
When writing final response status indicators, use the /quick-recap skill always.
When long-running or parallel work needs usage-limit checks, use the /stay-within-limits skill always.