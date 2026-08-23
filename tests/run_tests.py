"""Run Skill System tests as one suite with a combined terminal list."""
from __future__ import annotations

import argparse
import inspect
import os
import sys
import traceback
import unittest
from pathlib import Path

TEST_DIR = Path(__file__).resolve().parent
ROOT = TEST_DIR.parent

ROM_MARKERS = (
    "HACK_ROM",
    "FE7_Hack.gba",
    "SkillsTest.gba",
    "BUILT",
    "self.hack",
    "cls.hack",
    "cls.rom",
    "self.rom",
    "self.is_built",
)


def _color(code: str, text: str) -> str:
    if not sys.stdout.isatty() or os.environ.get("NO_COLOR"):
        return text
    return f"\033[{code}m{text}\033[0m"


def _flatten(suite: unittest.TestSuite):
    for item in suite:
        if isinstance(item, unittest.TestSuite):
            yield from _flatten(item)
        else:
            yield item


def _source(obj) -> str:
    if obj is None:
        return ""
    try:
        return inspect.getsource(obj)
    except (OSError, TypeError):
        return ""


def needs_built_rom(test: unittest.TestCase) -> bool:
    # subTest wraps the parent; classify the parent or we miss helper-based loads.
    parent = getattr(test, "test_case", None)
    if type(test).__name__ == "_SubTest" and parent is not None:
        test = parent
    cls = type(test)
    method = getattr(test, getattr(test, "_testMethodName", ""), None)
    module = sys.modules.get(getattr(cls, "__module__", ""), None)
    blobs = (
        _source(method),
        _source(getattr(cls, "setUpClass", None)),
        _source(getattr(cls, "setUp", None)),
    )
    blob = "\n".join(blobs)
    if any(marker in blob for marker in ROM_MARKERS):
        return True
    # load() often lives in a helper; the method text then has no marker.
    return "built_rom" in _source(module)


def _label(test: unittest.TestCase) -> str:
    return f"{type(test).__name__}.{getattr(test, '_testMethodName', type(test).__name__)}"


def _format_err(err) -> str:
    exc_type, exc, tb = err
    frames = []
    for frame in traceback.extract_tb(tb):
        if "unittest" in Path(frame.filename).parts:
            continue
        frames.append(f'  File "{frame.filename}", line {frame.lineno}, in {frame.name}')
        if frame.line:
            frames.append(f"    {frame.line}")
    message = "".join(traceback.format_exception_only(exc_type, exc)).strip()
    if len(message) > 400:
        message = message[:397] + "..."
    return "\n".join(frames + [message])


class ListResult(unittest.TestResult):
    def __init__(self):
        super().__init__(stream=sys.stdout, descriptions=True, verbosity=0)
        self.rows: list[tuple[str, str, str]] = []

    def addSuccess(self, test):
        super().addSuccess(test)
        self.rows.append(("OK", _label(test), ""))

    def addSkip(self, test, reason):
        super().addSkip(test, reason)
        extra = f"  ({reason})" if reason else ""
        self.rows.append(("SKIP", _label(test) + extra, ""))

    def addFailure(self, test, err):
        super().addFailure(test, err)
        self.rows.append(("FAIL", _label(test), _format_err(err)))

    def addError(self, test, err):
        super().addError(test, err)
        self.rows.append(("ERR", _label(test), _format_err(err)))

    def addExpectedFailure(self, test, err):
        super().addExpectedFailure(test, err)
        self.rows.append(("XFAIL", _label(test), ""))

    def addUnexpectedSuccess(self, test):
        super().addUnexpectedSuccess(test)
        self.rows.append(("UXOK", _label(test), ""))


STATUS_STYLE = {
    "OK": ("32", "  OK  "),
    "SKIP": ("33", " SKIP "),
    "FAIL": ("31", " FAIL "),
    "ERR": ("31", " ERR  "),
    "XFAIL": ("33", "XFAIL "),
    "UXOK": ("31", " UXOK "),
}


def _print_report(title: str, rows: list[tuple[str, str, str]]) -> None:
    width = 72
    print()
    print("=" * width)
    print(f" {title}")
    print("=" * width)
    rows = sorted(rows, key=lambda row: row[1].lower())
    for status, label, _tb in rows:
        code, tag = STATUS_STYLE[status]
        print(f"{_color(code, tag)} {label}")
    failed = [(label, tb) for status, label, tb in rows if status in ("FAIL", "ERR") and tb]
    if failed:
        print("-" * width)
        for label, tb in failed:
            print(_color("31", f" {label}"))
            print(tb.rstrip())
            print()
    n_ok = sum(1 for s, *_ in rows if s == "OK")
    n_skip = sum(1 for s, *_ in rows if s == "SKIP")
    n_fail = sum(1 for s, *_ in rows if s in ("FAIL", "ERR", "UXOK"))
    print("-" * width)
    print(f" {n_ok} passed, {n_skip} skipped, {n_fail} failed  ({len(rows)} total)")
    print("=" * width)
    print()


def _rows_ok(rows: list[tuple[str, str, str]]) -> bool:
    return not any(status in ("FAIL", "ERR", "UXOK") for status, *_ in rows)


def load_suite(phase: str) -> unittest.TestSuite:
    loader = unittest.TestLoader()
    discovered = loader.discover(start_dir=str(TEST_DIR), pattern="test_*.py", top_level_dir=str(TEST_DIR))
    if phase == "all":
        return discovered
    want_rom = phase == "rom"
    suite = unittest.TestSuite()
    for test in _flatten(discovered):
        if needs_built_rom(test) == want_rom:
            suite.addTest(test)
    return suite


def _module_names() -> list[str]:
    names = []
    seen = set()
    for path in sorted(TEST_DIR.glob("test_*.py")):
        stem = path.stem
        if stem not in seen:
            seen.add(stem)
            names.append(stem)
    return names


def _prepare_imports() -> None:
    os.chdir(ROOT)
    for path in (str(ROOT), str(TEST_DIR)):
        if path not in sys.path:
            sys.path.insert(0, path)


def _run_modules(module_names: list[str], phase: str) -> list[tuple[str, str, str]]:
    """Run matching tests from the named modules. Safe for a worker process."""
    _prepare_imports()
    loader = unittest.TestLoader()
    suite = unittest.TestSuite()
    result = ListResult()
    want_rom = None if phase == "all" else (phase == "rom")
    for name in module_names:
        try:
            loaded = loader.loadTestsFromName(name)
        except Exception:
            result.rows.append(("ERR", name, traceback.format_exc()))
            continue
        for test in _flatten(loaded):
            if want_rom is None or needs_built_rom(test) == want_rom:
                suite.addTest(test)
    suite.run(result)
    return list(result.rows)


def _run_one_module(payload: tuple[str, str]) -> list[tuple[str, str, str]]:
    name, phase = payload
    return _run_modules([name], phase)


def _resolve_jobs(requested: int | None) -> int:
    if requested is not None:
        return max(1, requested)
    env = os.environ.get("SKILL_TEST_JOBS")
    if env:
        return max(1, int(env))
    return max(1, os.cpu_count() or 1)


def _collect(phase: str, jobs: int) -> list[tuple[str, str, str]]:
    modules = _module_names()
    if jobs == 1 or len(modules) <= 1:
        return _run_modules(modules, phase)
    from concurrent.futures import ProcessPoolExecutor

    rows: list[tuple[str, str, str]] = []
    workers = min(jobs, len(modules))
    with ProcessPoolExecutor(max_workers=workers) as pool:
        for chunk in pool.map(_run_one_module, ((name, phase) for name in modules)):
            rows.extend(chunk)
    return rows


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--pre-assemble",
        action="store_true",
        help="source tests only (skip anything that reads FE7_Hack.gba)",
    )
    parser.add_argument(
        "--rom",
        action="store_true",
        help="only tests that read the built ROM",
    )
    parser.add_argument(
        "-j",
        "--jobs",
        type=int,
        default=None,
        help="parallel worker processes (default: CPUs, or SKILL_TEST_JOBS)",
    )
    args = parser.parse_args(argv)
    if args.pre_assemble and args.rom:
        print("Use only one of --pre-assemble or --rom", file=sys.stderr)
        return 2
    if args.pre_assemble:
        phase, title = "source", "Source tests (before assemble)"
    elif args.rom:
        phase, title = "rom", "ROM tests (after assemble)"
    else:
        phase, title = "all", "All tests"

    _prepare_imports()
    rows = _collect(phase, _resolve_jobs(args.jobs))
    _print_report(title, rows)
    return 0 if _rows_ok(rows) else 1


if __name__ == "__main__":
    raise SystemExit(main())
