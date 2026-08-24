---
name: implement-skill
description: Resolves a named FE7 skill to its file pack and edits only those paths. Use when the user wants to implement, enable, port, wire, fix, add, install, or debug a skill (Nullify, Provoke, Adept, etc.).
---

# Implement skill

## First action

User `@` paths win. Else extract the skill name and run:

```
python Tools/build_skill_index.py --skill <Name>
```

`--json` if you need a machine pack. Do not read `Documentation/skill-index.md`. Do not Grep/Glob/CodeDrift unless lookup exits 1.

## Then

Read listed `sources`, `tests`, and `installer` only (slice). Toggle ID in `EngineHacks/SkillSystem/skill_definitions.event`. Toggle category live in `EngineHacks/SkillSystem/Skills/MasterSkillInstaller.event`.

No skill name / unknown hook: `codedrift_search`, then stop.

## Humans

A project hook intercepts prompts containing `implement`: it injects the file pack and denies Grep/Glob/explore when a skill matches. Still `@` the folder when you have it.

Rewrite before sending:

```
python Tools/skill_prompt.py implement Nullify
```

Paste the printed brief as the agent prompt. Best shape: skill name + one intent sentence. No "please look around".
