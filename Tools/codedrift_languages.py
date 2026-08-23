"""Register Event Assembler / Thumb adapters with CodeDrift's indexer."""
from __future__ import annotations

import os
import re
from typing import List

from codedrift.languages.base import CallSite, ImportRef, LanguageAdapter, Symbol

LABEL_RE = re.compile(r"^([A-Za-z_][\w]*)\s*:")
DEFINE_RE = re.compile(r"^#define\s+(\w+)\b")
GLOBAL_RE = re.compile(r"^\s*\.global\s+(\S+)")
INCLUDE_RE = re.compile(r'^\s*#include\s+"([^"]+)"')
DOT_INCLUDE_RE = re.compile(r'^\s*\.include\s+"([^"]+)"')
BL_RE = re.compile(r"\b(?:bl|blh)\s+(\w+)", re.I)
POIN_RE = re.compile(r"\bPOIN\s+(\w+)")

_SKIP_SUFFIXES = (".lyn.event", ".dmp")


class LineAdapter(LanguageAdapter):
    """Regex adapter: CodeDrift only ships Python/JS/Go/Rust parsers."""

    def parse(self, source: bytes):
        return None

    def extract_functions(self, tree, source_lines: List[str], filepath: str) -> List[Symbol]:
        return []

    def extract_classes(self, tree, source_lines: List[str], filepath: str) -> List[Symbol]:
        return []

    def extract_symbols(self, tree, source_lines: List[str], filepath: str) -> List[Symbol]:
        symbols: List[Symbol] = []
        seen: set[str] = set()
        for i, raw in enumerate(source_lines, start=1):
            line = raw.split("//", 1)[0].split("@", 1)[0].rstrip()
            name = None
            kind = "function"
            m = LABEL_RE.match(line)
            if m:
                name, kind = m.group(1), "function"
            else:
                m = DEFINE_RE.match(line)
                if m:
                    name, kind = m.group(1), "variable"
                else:
                    m = GLOBAL_RE.match(line)
                    if m:
                        name, kind = m.group(1).lstrip("_"), "function"
            if not name or name in seen:
                continue
            seen.add(name)
            symbols.append(
                Symbol(
                    name=name,
                    kind=kind,
                    file=filepath,
                    start_line=i,
                    end_line=i,
                    signature=line.strip(),
                    language=self.language_name,
                )
            )
        return symbols

    def extract_imports(self, tree, source_lines: List[str], filepath: str) -> List[ImportRef]:
        refs: List[ImportRef] = []
        for raw in source_lines:
            line = raw.strip()
            m = INCLUDE_RE.match(line) or DOT_INCLUDE_RE.match(line)
            if not m:
                continue
            refs.append(ImportRef(symbol_name=m.group(1), file=filepath, import_line=line))
        return refs

    def extract_calls(self, tree, source_lines: List[str], filepath: str) -> List[CallSite]:
        sites: List[CallSite] = []
        for i, raw in enumerate(source_lines, start=1):
            line = raw.split("//", 1)[0].rstrip()
            for regex in (BL_RE, POIN_RE):
                for m in regex.finditer(line):
                    sites.append(
                        CallSite(
                            symbol_name=m.group(1),
                            caller_file=filepath,
                            line=i,
                            context=raw.strip(),
                            full_name=m.group(1),
                        )
                    )
        return sites


class ThumbAdapter(LineAdapter):
    language_name = "thumb"
    file_extensions = (".s",)


class EventAdapter(LineAdapter):
    language_name = "event"
    file_extensions = (".event",)


def register_fe7_languages() -> None:
    """Patch CodeDrift so `.s` / `.event` index; skip generated `.lyn.event`."""
    from codedrift import indexer, languages

    thumb = ThumbAdapter()
    event = EventAdapter()
    languages._ext_map[".s"] = thumb
    languages._ext_map[".event"] = event

    orig = languages.get_adapter

    def get_adapter(filepath: str):
        lower = filepath.replace("\\", "/").lower()
        if lower.endswith(_SKIP_SUFFIXES):
            return None
        return orig(filepath)

    languages.get_adapter = get_adapter
    indexer.get_adapter = get_adapter
    os.environ.setdefault("PYTHONUTF8", "1")
    os.environ.setdefault("PYTHONIOENCODING", "utf-8")
