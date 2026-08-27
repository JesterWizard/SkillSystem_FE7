"""A minimal GBA machine for running real FE7 ROM code under Unicorn.

Real ROM, real RAM, only the BIOS SWIs emulated.  Two FE7-specific details are
handled here because nothing else can run without them:

* the project's ``blh`` trampoline (``ldr r3,=fn; mov lr,r3; .short 0xF800``).
  On ARM7 that lone 0xF800 is the second half of a BL pair and branches to lr;
  Unicorn decodes it as the *first* half and raises UC_ERR_INSN_INVALID, so
  without the hook no ``blh`` call site executes at all.  The hook is not a
  stub -- it sets lr and jumps to the genuine routine.
* ``stub(address, fn)`` lets a test intercept one routine (a graphics proc, a
  skill lookup) while everything around it still runs for real.  Anything
  stubbed is a stated gap in what the test proves.
"""
from __future__ import annotations

import math
import struct

try:
    from unicorn import (
        UC_ARCH_ARM,
        UC_HOOK_CODE,
        UC_HOOK_INTR,
        UC_HOOK_MEM_UNMAPPED,
        UC_MODE_THUMB,
        Uc,
        UcError,
    )
    from unicorn.arm_const import (
        UC_ARM_REG_LR,
        UC_ARM_REG_PC,
        UC_ARM_REG_R0,
        UC_ARM_REG_R1,
        UC_ARM_REG_R2,
        UC_ARM_REG_R3,
        UC_ARM_REG_SP,
    )

    UNICORN_ERROR = ""
except ImportError as exc:  # pragma: no cover - depends on local tooling
    Uc = None
    UNICORN_ERROR = str(exc)

ROM_LOAD = 0x08000000
EWRAM = 0x02000000
EWRAM_SIZE = 0x40000
IWRAM = 0x03000000
IWRAM_SIZE = 0x8000
IO = 0x04000000
PALETTE = 0x05000000
VRAM = 0x06000000
OAM = 0x07000000
BIOS = 0x00000000
RETURN_MAGIC = 0x00F00000


class Gba:
    def __init__(self, rom: bytes):
        self.uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        self.rom = rom
        rom_size = (len(rom) + 0xFFFF) & ~0xFFFF
        for base, size in (
            (BIOS, 0x4000),
            (EWRAM, EWRAM_SIZE),
            (IWRAM, IWRAM_SIZE),
            (IO, 0x10000),
            (PALETTE, 0x400),
            (VRAM, 0x20000),
            (OAM, 0x400),
            (ROM_LOAD, rom_size),
            (RETURN_MAGIC & ~0xFFF, 0x1000),
        ):
            self.uc.mem_map(base, size)
        self.uc.mem_write(ROM_LOAD, rom)
        self.swi_counts: dict[int, int] = {}
        self.unmapped: list[tuple[int, int]] = []
        self.calls: list[int] = []
        self.stubs: dict[int, object] = {}
        self.uc.hook_add(UC_HOOK_INTR, self._on_swi)
        self.uc.hook_add(UC_HOOK_MEM_UNMAPPED, self._on_unmapped)
        self.uc.hook_add(UC_HOOK_CODE, self._on_blh)

    # -- calling --------------------------------------------------------
    def stub(self, address: int, fn=None) -> None:
        """Intercept calls to `address`; `fn(gba)` may set r0."""
        self.stubs[address & ~1] = fn

    def _on_blh(self, uc, address, size, _user):
        try:
            if struct.unpack("<H", uc.mem_read(address, 2))[0] != 0xF800:
                return
        except UcError:
            return
        target = uc.reg_read(UC_ARM_REG_LR)
        self.calls.append(target)
        fn = self.stubs.get(target & ~1, "missing")
        if fn != "missing":
            if fn is not None:
                fn(self)
            uc.reg_write(UC_ARM_REG_PC, (address + 2) | 1)
            return
        uc.reg_write(UC_ARM_REG_LR, (address + 2) | 1)
        uc.reg_write(UC_ARM_REG_PC, target | 1)

    # Unicorn's timeout is wall-clock microseconds and is spent in full when a
    # run ends by any means other than reaching the stop address, so an
    # over-generous value costs real seconds on every call.  The summon chain
    # is ~3M instructions; 3s leaves ample headroom.
    def run(self, entry: int, *, sp: int = IWRAM + 0x7F00, timeout=3_000_000):
        self.uc.reg_write(UC_ARM_REG_SP, sp)
        self.uc.reg_write(UC_ARM_REG_LR, RETURN_MAGIC | 1)
        self.uc.emu_start(entry | 1, RETURN_MAGIC, timeout=timeout)

    def set_args(self, *args):
        for reg, value in zip(
            (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3), args
        ):
            self.uc.reg_write(reg, value & 0xFFFFFFFF)

    @property
    def r0(self):
        return self.uc.reg_read(UC_ARM_REG_R0)

    @property
    def r1(self):
        return self.uc.reg_read(UC_ARM_REG_R1)

    @property
    def pc(self):
        return self.uc.reg_read(UC_ARM_REG_PC)

    # -- BIOS -----------------------------------------------------------
    def _on_swi(self, uc, intno, _user):
        if intno != 2:
            return
        pc = uc.reg_read(UC_ARM_REG_PC)
        num = struct.unpack("<H", uc.mem_read(pc - 2, 2))[0] & 0xFF
        self.swi_counts[num] = self.swi_counts.get(num, 0) + 1
        handler = {
            0x06: self._swi_div,
            0x08: self._swi_sqrt,
            0x0B: self._swi_cpuset,
            0x0C: self._swi_cpufastset,
        }.get(num)
        if handler:
            handler(uc)

    def _swi_div(self, uc):
        num = struct.unpack("<i", struct.pack("<I", uc.reg_read(UC_ARM_REG_R0)))[0]
        den = struct.unpack("<i", struct.pack("<I", uc.reg_read(UC_ARM_REG_R1)))[0] or 1
        q = abs(num) // abs(den)
        q = -q if (num < 0) != (den < 0) else q
        r = abs(num) % abs(den)
        r = -r if num < 0 else r
        uc.reg_write(UC_ARM_REG_R0, q & 0xFFFFFFFF)
        uc.reg_write(UC_ARM_REG_R1, r & 0xFFFFFFFF)
        uc.reg_write(UC_ARM_REG_R3, abs(q) & 0xFFFFFFFF)

    def _swi_sqrt(self, uc):
        uc.reg_write(UC_ARM_REG_R0, math.isqrt(uc.reg_read(UC_ARM_REG_R0)) & 0xFFFFFFFF)

    def _copy(self, uc, word_only: bool):
        src = uc.reg_read(UC_ARM_REG_R0)
        dst = uc.reg_read(UC_ARM_REG_R1)
        ctl = uc.reg_read(UC_ARM_REG_R2)
        count = ctl & 0x1FFFFF
        unit = 4 if (word_only or ctl & (1 << 26)) else 2
        if ctl & (1 << 24):
            uc.mem_write(dst, bytes(uc.mem_read(src, unit)) * count)
        else:
            uc.mem_write(dst, bytes(uc.mem_read(src, unit * count)))

    def _swi_cpuset(self, uc):
        self._copy(uc, False)

    def _swi_cpufastset(self, uc):
        self._copy(uc, True)

    def _on_unmapped(self, uc, access, address, size, value, _user):
        self.unmapped.append((address, access))
        try:
            uc.mem_map(address & ~0xFFF, 0x1000)
        except UcError:
            pass
        return True

    # -- memory ---------------------------------------------------------
    def w8(self, addr, val):
        self.uc.mem_write(addr, bytes([val & 0xFF]))

    def w16(self, addr, val):
        self.uc.mem_write(addr, struct.pack("<H", val & 0xFFFF))

    def w32(self, addr, val):
        self.uc.mem_write(addr, struct.pack("<I", val & 0xFFFFFFFF))

    def r8(self, addr):
        return self.uc.mem_read(addr, 1)[0]

    def s8(self, addr):
        return struct.unpack("<b", bytes(self.uc.mem_read(addr, 1)))[0]

    def r16(self, addr):
        return struct.unpack("<H", self.uc.mem_read(addr, 2))[0]

    def r32(self, addr):
        return struct.unpack("<I", self.uc.mem_read(addr, 4))[0]
