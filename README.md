
# FE7 Skill System

[Main discussion on Fire Emblem Universe](https://feuniverse.us/t/fe7-skill-system-wip/23148/)

## What is this?

This is a system for implementing modern FE skills into Fire Emblem 7.

This repository is intended to be installed via Event Assembler. Other methods
of installation, such as FEBuilderGBA, are not officially supported.

## Installation

1. Download or clone this repository onto your device.
2. Get a clean FE7U ROM, name it "FE7_clean.gba" and put it in the extracted folder.
3. Run `MAKE_HACK_full` to generate SkillsTest.gba, an edited copy of FE7_clean with skills added.
4. `MAKE_HACK_full` should be run whenever changes are intended to be made to the ROM. `MAKE_HACK_quick` can be run instead if not inserting any new text or tables.

## Basic Usage Notes

- Only 254 skills can be used at a time. To configure which skills are in use, use `EngineHacks/SkillSystem/skill_definitions.event`. This also doubles as a list of all skills and their effects.
- Skill effects themselves are sorted by skill type and located in `EngineHacks/SkillSystem/Skills`. To customize their effects, change the skill's corresponding .s file and drag it over `AssembleARM.bat`.
- Several optional toggles for other assembly hacks (such as the STR/MAG split, save expansion, etc) as well as the configuration of the effects of various skills can be found in `EngineHacks/Config.event`.
- To customize skill learnsets (what skills learned, at what level), see `EngineHacks/SkillSystem/Skill_lists.event`.
- To customize things like personal skills, class skills, and other miscellaneous things, see the CSVs in `Tables/NightmareModules`.
- For a more in-depth guide on using the Skill System, refer to [this topic](https://feuniverse.us/t/the-skill-system-and-you-maximizing-your-usage-of-fe8s-most-prolific-bundle-of-wizardry/8232).

## Credits

See `CREDITS.md` for a more detailed list.

Special thanks go to:
  - Circleseverywhere, for creating and releasing the original system.
  - Crazycolorz5, for debuffs, freeze and Dragon's Veins.
  - Primefusion, for the test map.
  - Kirb, for implementing the Str/Mag split into FE8 based off Tequila's original FE7 version.
  - Jester, for beginning the FE7 port of the skill system

## WARNINGS

- Currently only half of the FE8 skills have been ported. You can check which ones work in this list:
https://docs.google.com/spreadsheets/d/1hlkGIUFIDyFyyWMwDWQPyMOO3CJFKaAXz4ZUXC9G1bA/edit?hl=en&pli=1#gid=1259938747

- The ModularStatScreen and IconRework gave me too much trouble, so I couldn't continue with them. Many of the offsets for these two hacks have been changed (with the originals listed beside for comparison), but I can't gurantee they're all correct. 

- Without the above two hacks, you'll have to keep track of what skills your units have using the build file, as they won't show up in game.

- Things like skills scrolls and adding/removing skills in-game aren't currently supported for similar reasons as above.
