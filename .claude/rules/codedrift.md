# CodeDrift — Scope-Aware Code Intelligence

## Overview

CodeDrift indexes your codebase into a SQLite+FTS5 database and exposes four
MCP tools that replace expensive Glob/Grep/Read chains with targeted, ranked
lookups. Use CodeDrift tools **before** native file-read tools.

## Tool priority (use in this order)

0. `codedrift_memory <question>` — BEFORE EVERYTHING. Check if this task was
   solved before. If a match is returned, use that context set directly and
   skip steps 1–2 entirely.

1. `codedrift_search <keywords>` — FIRST CHOICE. FTS5 fuzzy search across all
   symbol names, signatures, file paths, and call-site context lines.
   Use instead of Grep or Glob.

2. `codedrift_resolve <symbol>` — Full context for a symbol: source code,
   every caller, every importer, related tests, git history.
   Use instead of reading full files.

3. `codedrift_overview` — Project structural map (modules, entry points, test
   summary). Use when you have no idea where to start.

4. `codedrift_read <file>` — Smart file read: full content on first access,
   unified diff on re-reads. Use instead of the native Read tool.

## Rules

- ALWAYS call `codedrift_memory` first, before any other tool.
- ALWAYS try `codedrift_search` before Grep or Glob.
- ALWAYS try `codedrift_resolve` before reading full files.
- After editing files, run `codedrift update` to refresh the index.
- After a `codedrift_search`, pick the most relevant symbol names and call
  `codedrift_resolve` on each one — do NOT read the full file first.

## MCP server registration

Cursor: `.cursor/mcp.json` in this repo (and `%USERPROFILE%\.cursor\mcp.json`)
must run `Tools/codedrift_cli.py mcp` with Python 3.13, `PYTHONUTF8=1`.
CodeDrift 0.1.0 needs `mcp>=1.0,<2` (`mcp` 2.0 dropped `Server.list_tools`).

Index `.s` / `.event` via the wrapper, not bare `codedrift mcp`:

```bash
python Tools/codedrift_cli.py init
python Tools/codedrift_cli.py update
```

Claude Code only: `claude mcp add --scope local codedrift -- codedrift mcp`
(that path does not load the FE7 adapters).