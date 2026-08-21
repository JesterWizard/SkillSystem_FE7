# Narrow Font

---

## Index

- [Introduction](#introduction)
- [Plan](#plan)
- [Code Locations](#code-locations)
- [TODO](#todo)
- [Limitations & Bugs](#limitations--bugs)

## Introduction

Vanilla FE7 menu and serif fonts are too wide for long Skill System names and help text. Narrow Font installs extra glyphs into unused `0x81+` slots of the two ASCII font pointer tables, then TextProcess rewrites marked strings to those character codes.

This is Bly’s glyph-table hack (same authoring rules as FE8 Skill System’s `NARROW_FONT`). It is not the UTF-8 font rewrite under `ExternalHacks/Fonts`.

Player-facing effect: strings tagged with `*` or `^` draw narrower letters where a narrow glyph exists. Untagged text is unchanged.

## Plan

Keep the hack off the critical path unless you opt in.

1. Leave `#define NARROW_FONT` in `EngineHacks/Config.event` to install glyphs. Comment it out to skip install; the ROM still builds.
2. Tag text in `Text/*.txt` with the markers below.
3. Rebuild **without** `quick` so `text-process-classic.py` runs (`MAKE_HACK_full.cmd`).

### Which marker

| Marker | Font | Typical UI |
|--------|------|------------|
| `*` | Serif (talk / bubbles) | Dialogue, some flavour strings |
| `^` | Menu (system) | Stat screen labels, RText, skill descriptions, menus |

Stat screen labels and help use the menu font. Use `^` there. `*` on a stat-screen string still emits serif codes; those glyphs will not show correctly in menu drawing.

### Marker priority (lowest to highest)

| Syntax | Scope |
|--------|--------|
| `*{text}` or `^{text}` | Only the span inside the braces. Braces must stay on that line. |
| `*` or `^` on the header line | The whole text ID. |
| `{*` or `{^` on the header line | This ID and every later ID until a header with `}`. |
| `}` on the header line | Stop the persistent block. The ID that has `}` is still narrow. |

Header examples (`## Name` auto-IDs and `#0x123 Name` both work):

```
## SS_SkillsText ^
Skills[X]

## SS_TalkRText
^{Character} with whom this unit[N]
may talk on the battlefield.[X]

## SS_TalkText {^
Talk[X]

## SS_SkillsText
Skills[X]

## SS_MovRText }
Movement. The normal distance[N]
you can cross in 1 turn.[X]
```

`Text/text_buildfile.txt` already uses a span: `*{Dislikes}:[X]` (serif). `Text/unitinfo_text.txt` uses a header: `## EirikaLike2ID *`.

Do not put `{^` in the **body** of a line. `{Name}` in a body is a TextProcess macro, not a narrow-font switch.

### Letters that actually shrink

TextProcess only remaps characters that exist in `NARROW_DICT` (`*`) or `NARROW_MENU_DICT` (`^`). Everything else stays vanilla width.

| Set | Converts | Stays vanilla |
|-----|----------|----------------|
| Serif `*` | `a–h k n–t u v x–z`, `A–H J K L O P Q R S U V X Y Z`, space, `0–9`, `. , : + - / ( ) ' "` | `i j l m w`, `I M N T W`, other punctuation, control codes in `[brackets]` |
| Menu `^` | `a–h j k n–s u v x–z`, same capitals as serif, space | `i l m t w`, `I M N T W`, digits, most punctuation |

`[N]`, `[X]`, `[A]`, and other parse tags are left alone.

### Rebuild

`MAKE_HACK_full.cmd` calls `Tools/TextProcess/text-process-classic.py` (not the stale `.exe`). A `quick` build skips text, so marker edits will not appear.

## Code Locations

| Feature | Location | Description |
|--------|----------|-------------|
| Feature gate | `#define NARROW_FONT` in `EngineHacks/Config.event` | Comment out to skip glyph install. |
| Install include | `_MasterHackInstaller.event` | Always includes the installer; the `#ifdef` inside no-ops when the define is off. |
| Glyph install | `EngineHacks/ExternalHacks/NarrowFont/NarrowFontInstaller.event` | FE7U tables: menu `0xB896B0`, serif `0xB8B5B0`. `_FE7_` only. |
| Glyph packs | `NarrowFont/MenuLowercase/`, `MenuUppercase/`, `SerifLowercase/`, `SerifUppercase/` | Bitmap + `mGlyphEntry` / `tGlyphEntry` into `0x81+`. |
| Marker rewrite | `narrowText` / `NARROW_DICT` / `NARROW_MENU_DICT` in `Tools/TextProcess/text-process-classic.py` | Turns `*` / `^` into `[0x81]`-style codes. |
| Marker syntax note | `Tools/TextProcess/TextREADME.txt` | Same `*` / `^` rules as this doc. |
| Authoring files | `Text/*.txt` | Put markers on the header or in the body. |

## TODO

- [ ] Add missing menu/serif glyphs (`i`, `l`, `m`, `t` on menu, `I M N T W`, digits on menu) if long skill names still overflow.
- [ ] Decide whether FE8 class-type icons (armor/flier/etc.) should live in unused high slots instead of being omitted.
- [ ] Keep `text-process-classic.exe` in sync or stop shipping it; the build already uses the `.py`.

## Limitations & Bugs

- Occupied FE7 slots `0x7B–0x7F` (`{ | } ~`) are **not** overwritten. FE8 NarrowFont’s class-type icons that used those codes are not installed.
- Serif digit/punctuation codes `0xC0–0xD5` are emitted by TextProcess, but this pack does not install those glyphs. Prefer letters that exist in the table, or they will draw blank/wrong.
- Narrow and vanilla glyphs mix in one string when a letter has no mapping (`Skills` still has wide `i` and `l`).
- `#define NARROW_FONT` and a future UTF-8 font rewrite must not both own the same character slots.
- File a bug if a tagged string corrupts a vanilla ASCII letter (`0x20–0x7E`) or if commenting out `NARROW_FONT` fails to assemble.
