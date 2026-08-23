"""FE7 CodeDrift entry: register EA/Thumb adapters, then init/update/mcp."""
from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
os.chdir(ROOT)
sys.path.insert(0, str(Path(__file__).parent))
os.environ.setdefault("PYTHONUTF8", "1")
os.environ.setdefault("PYTHONIOENCODING", "utf-8")

from codedrift_languages import register_fe7_languages  # noqa: E402

_DRIFT_DIR = ".codecodedrift"
_DB_NAME = "index.db"


def _db(create: bool):
    from codedrift.db import CodeDriftDB

    db_dir = ROOT / _DRIFT_DIR
    db_dir.mkdir(exist_ok=True)
    db = CodeDriftDB(db_dir / _DB_NAME)
    return db.connect() if hasattr(db, "connect") else db


def cmd_init(quiet: bool) -> None:
    register_fe7_languages()
    from codedrift.indexer import index_project

    db = _db(create=True)
    try:
        stats = index_project(str(ROOT), db, incremental=False, quiet=quiet)
        if not quiet:
            print(
                f"Indexed {stats['files_indexed']} files, "
                f"{stats['symbols']} symbols in {stats['elapsed']:.2f}s  "
                f"({stats['files_skipped']} skipped)"
            )
    finally:
        db.close()


def cmd_update(quiet: bool) -> None:
    register_fe7_languages()
    from codedrift.indexer import index_project

    db = _db(create=True)
    try:
        stats = index_project(str(ROOT), db, incremental=True, quiet=quiet)
        if not quiet:
            print(
                f"Updated: {stats['files_indexed']} changed, "
                f"{stats['files_skipped']} unchanged, "
                f"{stats['elapsed']:.2f}s"
            )
    finally:
        db.close()


def cmd_mcp() -> None:
    register_fe7_languages()
    from codedrift.mcp_server import run_mcp_server

    run_mcp_server(str(ROOT))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="FE7 CodeDrift wrapper")
    parser.add_argument("command", choices=("init", "update", "mcp"))
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args(argv)
    if args.command == "init":
        cmd_init(args.quiet)
    elif args.command == "update":
        cmd_update(args.quiet)
    else:
        cmd_mcp()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
