Edit the .event files under NightmareModules/. Tables/TableInstaller.event includes them all.

Vanilla overwrite tables use PUSH/ORG at the FE7 pointer. New tables are ALIGN 4 labels (PersonalSkillTable, MagCharTable, ...).

Tools/C2EA remains as a one-shot converter if you ever need to dump a CSV again. It is not part of the regular build.
