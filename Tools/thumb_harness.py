"""Real-CPU register/memory verification harness for hand-written Thumb skill ASM.

Hand-tracing a Thumb instruction stream (which struct offset lands in which
register) is exactly how the ChargePlus movement bug slipped through: the
add-into-r0-then-copy-r1 sequence *looked* right on paper but doubled the
movement value in practice. This harness assembles a .s file with the
project's real devkitARM toolchain and executes it under a Unicorn ARM7TDMI
(Thumb) emulator against synthetic struct memory, so a test can assert what
a register actually contains at a given point, instead of trusting a read of
the source.

Usage sketch (see Tests/test_chargeplus_execution.py):

    code = assemble(SRC_PATH)
    offsets = symbol_offsets(SRC_PATH)
    h = Harness(code)
    h.seed(ATTACKER_ADDR + 0x1D, struct.pack("b", 5))     # unit movement
    h.seed(ACTIONDATA_ADDR + 0x10, struct.pack("B", 5))   # spaces moved
    h.run(offsets["GoBack"], regs={"r0": ATTACKER_ADDR, "r1": DEFENDER_ADDR})
    assert h.read(ATTACKER_ADDR + 0x4C, 4)[3] & 0x20  # brave bit
"""
from __future__ import annotations

import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path

from unicorn import Uc, UcError, UC_ARCH_ARM, UC_MODE_THUMB, UC_HOOK_CODE
from unicorn.arm_const import (
    UC_ARM_REG_R0,
    UC_ARM_REG_R1,
    UC_ARM_REG_R2,
    UC_ARM_REG_R3,
    UC_ARM_REG_R4,
    UC_ARM_REG_R5,
    UC_ARM_REG_R6,
    UC_ARM_REG_R7,
    UC_ARM_REG_R8,
    UC_ARM_REG_R9,
    UC_ARM_REG_LR,
    UC_ARM_REG_SP,
)

DEVKITARM = Path(r"C:\devkitPro\devkitARM\bin")
AS = DEVKITARM / "arm-none-eabi-as.exe"
OBJCOPY = DEVKITARM / "arm-none-eabi-objcopy.exe"
NM = DEVKITARM / "arm-none-eabi-nm.exe"

REG_MAP = {
    "r0": UC_ARM_REG_R0,
    "r1": UC_ARM_REG_R1,
    "r2": UC_ARM_REG_R2,
    "r3": UC_ARM_REG_R3,
    "r4": UC_ARM_REG_R4,
    "r5": UC_ARM_REG_R5,
    "r6": UC_ARM_REG_R6,
    "r7": UC_ARM_REG_R7,
    "r8": UC_ARM_REG_R8,
    "r9": UC_ARM_REG_R9,
    "lr": UC_ARM_REG_LR,
    "sp": UC_ARM_REG_SP,
}

CODE_BASE = 0x08000000
STACK_BASE = 0x03000000
STACK_SIZE = 0x1000
PAGE = 0x1000

# Every skill .s in this codebase calls the shared SkillTester routine via a
# hand-spliced trampoline (`ldr r0, SkillTester; mov lr, r0; mov r0, r4;
# ldr r1, <SkillID>; .short 0xf800`), because SkillTester's real address is
# only known once FEBuilder inserts this blob into the final ROM. Real
# ARM7TDMI decodes that lone `0xf800` halfword as a valid (if unusual) 16-bit
# BL-second-half; Unicorn's default core instead reads it as the start of a
# 32-bit Thumb-2 instruction and raises UC_ERR_INSN_INVALID. Since this
# harness doesn't model the external SkillTester routine anyway, the whole
# 5-halfword trampoline is patched out before loading and replaced with
# NOPs + `movs r0, #<skill_present>`, matching the call's only externally
# visible effect (r0 becomes truthy/falsy).
SKILLTESTER_CALL = b"\x00\xf8"  # the raw `.short 0xf800`, little-endian
NOP = 0x46C0  # `mov r8, r8`, the standard Thumb NOP idiom
TRAMPOLINE_HALFWORDS = 5  # ldr/mov/mov/ldr/short-f800


def _include_flags(src: Path, include_dirs=None) -> list[str]:
    """-I for the source's own directory, plus any extra dirs it .includes from
    (stat screen page wrappers live outside pages/ but include mss_defs.s)."""
    dirs = [src.parent, *(include_dirs or ())]
    return [f"-I{d}" for d in dirs]


@dataclass(frozen=True)
class _Asm:
    code: bytes
    offsets: dict[str, int]


_ASM_CACHE: dict[tuple, _Asm] = {}


def _cache_key(src: Path, include_dirs=None) -> tuple:
    src = Path(src).resolve()
    extras = tuple(str(Path(d).resolve()) for d in (include_dirs or ()))
    return (str(src), src.stat().st_mtime_ns, extras)


def _assemble_once(src: Path, include_dirs=None) -> _Asm:
    """One `as` + objcopy + nm; reused by assemble() and symbol_offsets()."""
    src = Path(src)
    key = _cache_key(src, include_dirs)
    hit = _ASM_CACHE.get(key)
    if hit is not None:
        return hit
    with tempfile.TemporaryDirectory() as tmp:
        elf = Path(tmp) / (src.stem + ".elf")
        binf = Path(tmp) / (src.stem + ".bin")
        flags = _include_flags(src, include_dirs)
        subprocess.run(
            [str(AS), "-mcpu=arm7tdmi", "-mthumb", "-mthumb-interwork",
             *flags, str(src), "-o", str(elf)],
            check=True, capture_output=True, text=True,
        )
        subprocess.run(
            [str(OBJCOPY), "-O", "binary", str(elf), str(binf)],
            check=True, capture_output=True, text=True,
        )
        out = subprocess.run(
            [str(NM), str(elf)], check=True, capture_output=True, text=True,
        ).stdout
        code = binf.read_bytes()
    offsets: dict[str, int] = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) == 3:
            addr_hex, _kind, name = parts
            offsets[name] = int(addr_hex, 16)
    result = _Asm(code=code, offsets=offsets)
    _ASM_CACHE[key] = result
    return result


def assemble(src: Path, include_dirs=None) -> bytes:
    """Assemble src with the project's ARM toolchain; return raw .text bytes."""
    return _assemble_once(src, include_dirs).code


def symbol_offsets(src: Path, include_dirs=None) -> dict[str, int]:
    """Label -> byte offset within the assembled .text, via nm (not hand-counted)."""
    return dict(_assemble_once(src, include_dirs).offsets)


def _is_trampoline_at(code: bytes, idx: int) -> bool:
    """True when `idx` really is the `.short 0xf800` of a SkillTester call.

    The byte pair 0xF800 also occurs inside ordinary Thumb encodings and
    literal pools -- compiled C hits this constantly, since gcc calls through
    a normal long-call thunk and never emits a bare BL suffix at all. Patching
    on a bare byte match therefore NOPs out four halfwords of unrelated code
    and produces a corrupt blob that faults far from the real cause.

    A genuine trampoline is `ldr rX, =fn ; mov lr, rX ; ... ; .short 0xf800`,
    so require a `mov lr, rX` (0x46 in the high byte, 0xE in the low nibble of
    the destination field) somewhere in the four halfwords before it.
    """
    span_start = idx - 2 * (TRAMPOLINE_HALFWORDS - 1)
    if span_start < 0:
        return False
    for i in range(TRAMPOLINE_HALFWORDS - 1):
        hw = int.from_bytes(code[span_start + 2 * i: span_start + 2 * i + 2], "little")
        # `mov lr, rX` == 0x46F0 | (rX & 7), plus the H1 bit for the destination.
        if (hw & 0xFF87) == 0x4686:
            return True
    return False


def _patch_skilltester_trampoline(code: bytes, skill_present: bool) -> bytes:
    patched = bytearray(code)
    idx = -1
    found = False
    while True:
        idx = code.find(SKILLTESTER_CALL, idx + 1)
        if idx == -1:
            break
        if not _is_trampoline_at(code, idx):
            continue
        found = True
        span_start = idx - 2 * (TRAMPOLINE_HALFWORDS - 1)
        for i in range(TRAMPOLINE_HALFWORDS - 1):
            patched[span_start + 2 * i: span_start + 2 * i + 2] = NOP.to_bytes(2, "little")
        movs_r0 = 0x2000 | (1 if skill_present else 0)  # `movs r0, #imm8`
        patched[idx: idx + 2] = movs_r0.to_bytes(2, "little")
    return bytes(patched) if found else code


def _patch_f800_to_nop(code: bytes) -> tuple[bytes, list[int]]:
    """Replace each trampoline `.short 0xf800` with NOP; leave the ldr/mov setup.

    Used when the test needs the original r0/r1/lr at the call site (multi-skill
    routines, vanilla helpers via `blh`) so a Unicorn hook can dispatch.
    """
    patched = bytearray(code)
    sites: list[int] = []
    idx = -1
    while True:
        idx = code.find(SKILLTESTER_CALL, idx + 1)
        if idx == -1:
            break
        if not _is_trampoline_at(code, idx):
            continue
        patched[idx: idx + 2] = NOP.to_bytes(2, "little")
        sites.append(idx)
    return bytes(patched), sites


class Harness:
    """Executes assembled Thumb code against caller-seeded struct memory."""

    def __init__(self, code: bytes, skill_present: bool = True, intercept_calls=None):
        self._intercept = intercept_calls
        if intercept_calls is not None:
            code, sites = _patch_f800_to_nop(code)
            if not sites:
                raise ValueError("intercept_calls set but no 0xf800 trampolines found")
        else:
            code = _patch_skilltester_trampoline(code, skill_present)
            sites = []
        self.uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        code_size = ((len(code) + PAGE - 1) // PAGE) * PAGE or PAGE
        self.uc.mem_map(CODE_BASE, code_size)
        self.uc.mem_write(CODE_BASE, code)
        self.uc.mem_map(STACK_BASE, STACK_SIZE)
        self.uc.reg_write(UC_ARM_REG_SP, STACK_BASE + STACK_SIZE - 0x100)
        self._call_addrs = {CODE_BASE + off for off in sites}
        if self._call_addrs:
            # Per-site [addr, addr+2] fires twice on Thumb (NOP then the next
            # halfword). Filter by exact call-site PC instead.
            self.uc.hook_add(
                UC_HOOK_CODE,
                self._on_intercepted_call,
                begin=CODE_BASE,
                end=CODE_BASE + code_size,
            )

    def _on_intercepted_call(self, uc, address, size, user_data):
        if (address & ~1) not in self._call_addrs:
            return
        result = self._intercept(
            uc.reg_read(UC_ARM_REG_LR),
            uc.reg_read(UC_ARM_REG_R0),
            uc.reg_read(UC_ARM_REG_R1),
        )
        uc.reg_write(UC_ARM_REG_R0, result & 0xFFFFFFFF)

    def map_page(self, addr: int, size: int = 4):
        base = addr & ~(PAGE - 1)
        top = (addr + max(size, 1) + PAGE - 1) & ~(PAGE - 1)
        try:
            self.uc.mem_map(base, top - base)
        except UcError:
            pass  # already mapped (or overlaps a mapped page); fine either way

    def seed(self, addr: int, data: bytes):
        self.map_page(addr, len(data))
        self.uc.mem_write(addr, data)

    def read(self, addr: int, size: int) -> bytes:
        return bytes(self.uc.mem_read(addr, size))

    def run(self, stop_offset: int, regs: dict[str, int], entry_offset: int = 0,
             timeout_us: int = 200_000) -> dict[str, int]:
        for name, value in regs.items():
            self.uc.reg_write(REG_MAP[name], value)
        entry = CODE_BASE + entry_offset
        stop = CODE_BASE + stop_offset
        self.uc.emu_start(entry | 1, stop, timeout=timeout_us)
        return {name: self.uc.reg_read(reg) for name, reg in REG_MAP.items()}
