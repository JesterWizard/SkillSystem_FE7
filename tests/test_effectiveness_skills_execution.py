"""Execute Effectiveness_Skills.s under Unicorn.

Slayer, Skybreaker, Nullify, and Resourceful share SkillTester calls, so a
single skill_present flag would make Nullify cancel every hit. 0xF800
trampolines are rewritten to bx a stub keyed on unit + skill id.

GetItemEffectiveness / GetItemData are mapped as stubs. This does not prove
in-game skill assignment.
"""
from __future__ import annotations

import struct
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from Tools.thumb_harness import CODE_BASE, Harness, assemble, symbol_offsets

SRC = ROOT / (
    "EngineHacks/SkillSystem/Skills/EffectivenessSkills/Nullify/"
    "Effectiveness_Skills.s"
)
HACK = ROOT / "FE7_Hack.gba"
DEFS = ROOT / "EngineHacks/SkillSystem/skill_definitions.event"

ATTACKER = 0x0203A3F0
DEFENDER = 0x0203A470
KLASS = 0x0203A500
ATK_SKILLS = 0x0203F100
DEF_SKILLS = 0x0203F200
EFF_LIST = 0x0203F300
STUB = 0x0203F000
GET_EFF = 0x080173D0
GET_DATA = 0x080174AC
NEXT_BC = 0x08028B52

SLAYER_ID = 201
NULLIFY_ID = 200
SKYBREAKER_ID = 202
RESOURCEFUL_ID = 203
MONSTER = 0x10
FLIER = 0x04

HOOK_POWER = 0x28B30
HOOK_ITEM = 0x16820
JUMP = bytes.fromhex("004b1847")

TAIL = bytes.fromhex("9e4600f8")  # mov lr, r3; .short 0xF800
TAIL_BX = bytes.fromhex("fe461847")  # mov lr, pc; bx r3


def _assemble_stub() -> bytes:
    text = f"""
    .thumb
    ldr r2, attacker
    cmp r0, r2
    bne 1f
    ldr r2, atk_table
    b 2f
1:  ldr r2, def_table
2:  ldrb r0, [r2, r1]
    bx lr
    .align 2
attacker:  .word {ATTACKER:#x}
atk_table: .word {ATK_SKILLS:#x}
def_table: .word {DEF_SKILLS:#x}
    """
    with tempfile.NamedTemporaryFile("w", suffix=".s", delete=False) as fh:
        fh.write(text)
        path = Path(fh.name)
    try:
        return assemble(path)
    finally:
        path.unlink(missing_ok=True)


def _prep(raw: bytes, offs: dict[str, int]) -> bytearray:
    end = offs["ResourcefulID"] + 4
    buf = bytearray(raw)
    if len(buf) < end:
        buf.extend(bytes(end - len(buf)))
    struct.pack_into("<I", buf, offs["SkillTester"], STUB | 1)
    struct.pack_into("<I", buf, offs["SlayerID"], SLAYER_ID)
    struct.pack_into("<I", buf, offs["NullifyID"], NULLIFY_ID)
    struct.pack_into("<I", buf, offs["SlayerClassType"], MONSTER)
    struct.pack_into("<I", buf, offs["SkybreakerID"], SKYBREAKER_ID)
    struct.pack_into("<I", buf, offs["SkybreakerClassType"], FLIER)
    struct.pack_into("<I", buf, offs["ResourcefulID"], RESOURCEFUL_ID)
    return buf


def _harness(buf: bytearray, atk=(), deff=(), ctype=0) -> Harness:
    h = Harness(bytes(buf), skill_present=False)
    h.seed(STUB, _assemble_stub())
    h.seed(ATK_SKILLS, bytes(256))
    h.seed(DEF_SKILLS, bytes(256))
    for sid in atk:
        h.seed(ATK_SKILLS + sid, b"\x01")
    for sid in deff:
        h.seed(DEF_SKILLS + sid, b"\x01")
    h.seed(KLASS + 0x50, struct.pack("<H", ctype))
    h.seed(DEFENDER + 0x4, struct.pack("<I", KLASS))
    h.seed(ATTACKER + 0x4, struct.pack("<I", KLASS))
    h.seed(GET_EFF, bytes.fromhex("00487047") + struct.pack("<I", EFF_LIST))
    h.seed(GET_DATA, bytes.fromhex("00207047"))
    h.seed(EFF_LIST, b"\x00\x00\x00\x00")
    h.seed(NEXT_BC, bytes.fromhex("0000"))
    return h


class SlayerCheckTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not SRC.is_file():
            raise unittest.SkipTest(f"missing {SRC}")
        cls.raw = assemble(SRC)
        cls.offs = symbol_offsets(SRC)

    def _run(self, *, atk=(), deff=(), ctype=0, class_ptr=KLASS) -> int:
        buf = _prep(self.raw, self.offs)
        h = _harness(buf, atk, deff, ctype)
        h.seed(DEFENDER + 0x4, struct.pack("<I", class_ptr))
        stop = self.offs["SlayerDone"]
        regs = h.run(
            stop,
            regs={"r0": ATTACKER, "r1": DEFENDER},
            entry_offset=self.offs["SlayerCheck"],
        )
        return regs["r0"]

    def test_no_skill_returns_zero(self):
        self.assertEqual(self._run(ctype=MONSTER), 0)

    def test_slayer_vs_monster_returns_six(self):
        self.assertEqual(self._run(atk=(SLAYER_ID,), ctype=MONSTER), 6)

    def test_slayer_vs_non_monster_returns_zero(self):
        self.assertEqual(self._run(atk=(SLAYER_ID,), ctype=FLIER), 0)

    def test_nullify_blocks_slayer(self):
        self.assertEqual(self._run(atk=(SLAYER_ID,), deff=(NULLIFY_ID,), ctype=MONSTER), 0)

    def test_skybreaker_vs_flier_returns_six(self):
        self.assertEqual(self._run(atk=(SKYBREAKER_ID,), ctype=FLIER), 6)

    def test_skybreaker_vs_non_flier_returns_zero(self):
        self.assertEqual(self._run(atk=(SKYBREAKER_ID,), ctype=MONSTER), 0)

    def test_nullify_blocks_skybreaker(self):
        self.assertEqual(
            self._run(atk=(SKYBREAKER_ID,), deff=(NULLIFY_ID,), ctype=FLIER), 0
        )

    def test_null_class_returns_zero(self):
        self.assertEqual(self._run(atk=(SLAYER_ID,), ctype=MONSTER, class_ptr=0), 0)


class ApplyEffectivenessTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not SRC.is_file():
            raise unittest.SkipTest(f"missing {SRC}")
        cls.raw = assemble(SRC)
        cls.offs = symbol_offsets(SRC)

    def _apply(self, *, atk=(), deff=(), ctype=0, might=10) -> int:
        buf = _prep(self.raw, self.offs)
        h = _harness(buf, atk, deff, ctype)
        h.seed(ATTACKER + 0x5A, struct.pack("<H", 0))
        h.seed(ATTACKER + 0x48, struct.pack("<H", 0x002D))
        # Hooked at the 4-aligned 0x28B30, so ApplyEffectiveness re-emits the
        # displaced `strh r1,[r0]`: r0 = attacker+0x5A, r1 = base might.
        h.run(
            0x28B52,
            regs={
                "r0": ATTACKER + 0x5A,
                "r1": might,
                "r4": DEFENDER,
                "r5": ATTACKER,
                "r6": ATTACKER + 0x48,
            },
            entry_offset=self.offs["ApplyEffectiveness"],
        )
        return struct.unpack_from("<H", h.read(ATTACKER + 0x5A, 2))[0]

    def test_slayer_triples_might_wta(self):
        self.assertEqual(self._apply(atk=(SLAYER_ID,), ctype=MONSTER), 30)

    def test_resourceful_doubles_coeff(self):
        self.assertEqual(
            self._apply(atk=(SLAYER_ID, RESOURCEFUL_ID), ctype=MONSTER), 60
        )

    def test_nullify_leaves_attack(self):
        self.assertEqual(
            self._apply(atk=(SLAYER_ID,), deff=(NULLIFY_ID,), ctype=MONSTER), 10
        )

    def test_no_match_leaves_attack(self):
        self.assertEqual(self._apply(ctype=MONSTER), 10)


class WeaponEffectivenessTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not SRC.is_file():
            raise unittest.SkipTest(f"missing {SRC}")
        cls.raw = assemble(SRC)
        cls.offs = symbol_offsets(SRC)

    def _item(self, *, deff=(), ctype=FLIER, types=FLIER, coeff=6) -> int:
        buf = _prep(self.raw, self.offs)
        h = _harness(buf, deff=deff, ctype=ctype)
        h.seed(EFF_LIST, struct.pack("<BBH", 0, coeff, types) + b"\x00\x00\x00\x00")
        h.seed(DEFENDER + 0x1E, bytes(10))
        regs = h.run(
            self.offs["WeaponEffDone"],
            regs={"r0": 0x002D, "r1": DEFENDER},
            entry_offset=self.offs["WeaponEffectiveness"],
        )
        return regs["r0"]

    def test_matching_type_is_effective(self):
        self.assertEqual(self._item(), 1)

    def test_mismatch_is_not_effective(self):
        self.assertEqual(self._item(ctype=MONSTER, types=FLIER), 0)

    def test_nullify_negates_weapon(self):
        self.assertEqual(self._item(deff=(NULLIFY_ID,)), 0)


class EffectiveIconFlagTests(unittest.TestCase):
    """The flashing 'effective' icon on the forecast and battle screens is
    battle-struct +0x52, set at 0x80335AE from IsItemEffectiveAgainst alone.
    Slayer/Skybreaker grant effectiveness in BC_Power, which never touches
    +0x52, so before this the damage tripled with no icon. Runs the real ROM
    bytes of the display path and reads the flag back."""

    ACTOR = 0x0203A3F0  # gBattleActor
    TARGET = 0x0203A470  # gBattleTarget
    KLASS = 0x02030000
    ATK_TBL = 0x02060000
    DEF_TBL = 0x02061000
    IRON_SWORD = 0x4E  # no weapon effectiveness of its own
    ARMORSLAYER = 0x0E

    @classmethod
    def setUpClass(cls):
        try:
            import unicorn  # noqa: F401
        except ImportError:
            raise unittest.SkipTest("unicorn not installed")
        if not HACK.exists():
            raise unittest.SkipTest("FE7_Hack.gba missing")
        sym = ROOT / "FE7_Hack.sym"
        if not sym.is_file():
            raise unittest.SkipTest("FE7_Hack.sym missing")
        import re

        cls.rom = HACK.read_bytes()
        cls.syms = {}
        for line in sym.read_text(encoding="utf-8", errors="replace").splitlines():
            m = re.match(r"([0-9A-Fa-f]{8})\s+(\S+)", line)
            if m:
                cls.syms[m.group(2)] = int(m.group(1), 16)
        if "SkillTester" not in cls.syms:
            raise unittest.SkipTest("SkillTester not in symbol file")
        cls.stub = cls._build_stub()

    @classmethod
    def _build_stub(cls) -> bytes:
        """r0=unit r1=skillID -> r0 = table[skillID], one table per unit."""
        src = f"""
        .thumb
        ldr r2, =0x{cls.ACTOR:08X}
        cmp r0, r2
        bne 1f
        ldr r2, =0x{cls.ATK_TBL:08X}
        b 2f
    1:  ldr r2, =0x{cls.DEF_TBL:08X}
    2:  ldrb r0, [r2, r1]
        bx lr
        .align 2
        .ltorg
        """
        with tempfile.NamedTemporaryFile("w", suffix=".s", delete=False) as fh:
            fh.write(src)
            path = Path(fh.name)
        try:
            return assemble(path)
        finally:
            path.unlink(missing_ok=True)

    def _flag(self, *, weapon, ctype, atk=(), deff=()) -> int:
        from unicorn import UC_ARCH_ARM, UC_MODE_THUMB, Uc, UcError
        from unicorn.arm_const import UC_ARM_REG_LR, UC_ARM_REG_R6, UC_ARM_REG_SP

        uc = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
        uc.mem_map(0x08000000, 0x02000000)
        uc.mem_write(0x08000000, self.rom)
        uc.mem_map(0x02000000, 0x00100000)
        uc.mem_map(0x03000000, 0x00010000)
        uc.reg_write(UC_ARM_REG_SP, 0x03007000)

        uc.mem_write(self.syms["SkillTester"] & ~1, self.stub)
        uc.mem_write(self.ATK_TBL, bytes(256))
        uc.mem_write(self.DEF_TBL, bytes(256))
        for sid in atk:
            uc.mem_write(self.ATK_TBL + sid, b"\x01")
        for sid in deff:
            uc.mem_write(self.DEF_TBL + sid, b"\x01")

        uc.mem_write(self.KLASS + 0x50, struct.pack("<H", ctype))
        uc.mem_write(self.TARGET + 0x4, struct.pack("<I", self.KLASS))
        uc.mem_write(self.ACTOR + 0x4, struct.pack("<I", self.KLASS))
        uc.mem_write(self.ACTOR + 0x4A, struct.pack("<H", weapon))
        uc.mem_write(self.TARGET + 0x1E, bytes(10))

        uc.reg_write(UC_ARM_REG_R6, self.ACTOR)
        uc.mem_write(self.ACTOR + 0x52, b"\x00")
        uc.reg_write(UC_ARM_REG_LR, 0x03000001)
        try:
            uc.emu_start(0x08033594 | 1, 0x080335B0, count=300000)
        except UcError as exc:  # pragma: no cover - failure detail
            self.fail(f"display path faulted: {exc}")
        return uc.mem_read(self.ACTOR + 0x52, 1)[0]

    def test_weapon_effectiveness_still_lights_icon(self):
        self.assertEqual(self._flag(weapon=self.ARMORSLAYER, ctype=0x01), 1)

    def test_plain_weapon_no_skill_stays_dark(self):
        self.assertEqual(self._flag(weapon=self.IRON_SWORD, ctype=MONSTER), 0)

    def test_slayer_lights_icon_vs_monster(self):
        self.assertEqual(
            self._flag(weapon=self.IRON_SWORD, ctype=MONSTER, atk=(SLAYER_ID,)), 1
        )

    def test_slayer_stays_dark_vs_non_monster(self):
        self.assertEqual(
            self._flag(weapon=self.IRON_SWORD, ctype=FLIER, atk=(SLAYER_ID,)), 0
        )

    def test_skybreaker_lights_icon_vs_flier(self):
        self.assertEqual(
            self._flag(weapon=self.IRON_SWORD, ctype=FLIER, atk=(SKYBREAKER_ID,)), 1
        )

    def test_skybreaker_stays_dark_vs_non_flier(self):
        self.assertEqual(
            self._flag(weapon=self.IRON_SWORD, ctype=MONSTER, atk=(SKYBREAKER_ID,)), 0
        )

    def test_nullify_keeps_icon_dark(self):
        self.assertEqual(
            self._flag(
                weapon=self.IRON_SWORD,
                ctype=MONSTER,
                atk=(SLAYER_ID,),
                deff=(NULLIFY_ID,),
            ),
            0,
        )


class Fe7ReworkDataTests(unittest.TestCase):
    """ItemEffectivenessPtr uses ExpandedItemTable (after SkillScrolls
    redefines ItemTable). Comments were FE8 IDs: Fire 0x37 got
    FlierEffectiveness, and brigand class+0x50 is a leftover pointer
    (0x08BE467F) whose low half looks like every type bit."""

    CLASS_TABLE = 0xBE015C
    CLASS_SIZE = 0x54
    GET_ITEM_DATA = 0x16060
    BRIGAND = 0x39
    FIRE = 0x37
    KILLER_BALLISTA = 0x36
    HORSESLAYER = 0x1B
    JAVELIN = 0x1C

    @classmethod
    def setUpClass(cls):
        if not HACK.exists():
            raise unittest.SkipTest("FE7_Hack.gba missing")
        cls.rom = HACK.read_bytes()

    def _item_table(self) -> int:
        return struct.unpack_from("<I", self.rom, self.GET_ITEM_DATA)[0] & 0x01FFFFFF

    def _item_eff(self, item: int) -> int:
        return struct.unpack_from(
            "<I", self.rom, self._item_table() + 0x24 * item + 0x10
        )[0]

    def _eff_types(self, item: int) -> int:
        ptr = self._item_eff(item)
        if ptr == 0:
            return 0
        off = ptr & 0x01FFFFFF
        _zero, _coeff, types = struct.unpack_from("<BBH", self.rom, off)
        return types

    def _class_type(self, class_id: int) -> int:
        return struct.unpack_from(
            "<H", self.rom, self.CLASS_TABLE + self.CLASS_SIZE * class_id + 0x50
        )[0]

    def test_brigand_has_no_class_type(self):
        self.assertEqual(self._class_type(self.BRIGAND), 0)

    def test_fire_has_no_effectiveness(self):
        self.assertEqual(self._item_eff(self.FIRE), 0)

    def test_killer_ballista_is_flier_type(self):
        self.assertEqual(self._eff_types(self.KILLER_BALLISTA), FLIER)

    def test_horseslayer_is_horse_type(self):
        self.assertEqual(self._eff_types(self.HORSESLAYER), 0x02)

    def test_javelin_has_no_effectiveness(self):
        self.assertEqual(self._item_eff(self.JAVELIN), 0)


class WiringTests(unittest.TestCase):
    def test_skill_ids_are_live(self):
        text = DEFS.read_text(encoding="utf-8")
        self.assertIn("#define NullifyID 200", text)
        self.assertIn("#define SlayerID 201", text)
        self.assertIn("#define SkybreakerID 202", text)
        self.assertIn("#define ResourcefulID 203", text)

    @unittest.skipUnless(HACK.exists(), "FE7_Hack.gba missing")
    def test_hooks_are_jumpToHack(self):
        rom = HACK.read_bytes()
        self.assertEqual(rom[HOOK_POWER : HOOK_POWER + 4], JUMP)
        self.assertEqual(rom[HOOK_ITEM : HOOK_ITEM + 4], JUMP)

    @unittest.skipUnless(HACK.exists(), "FE7_Hack.gba missing")
    def test_hook_literals_sit_where_the_ldr_reads(self):
        """`ldr r3,[pc,#0]` reads from (pc+4)&~3, which is NOT hook+4 at a
        2-aligned hook. 0x28B32 once padded its POIN out to 0x28B38, so the
        load returned the `bx r3` opcode (0x00004718) and the game crashed at
        0x28B34 on opening the stat screen's second page."""
        rom = HACK.read_bytes()
        for hook in (HOOK_POWER, HOOK_ITEM):
            literal = (hook + 4) & ~3
            target = struct.unpack_from("<I", rom, literal)[0]
            self.assertEqual(
                target & 1, 1, f"hook 0x{hook:X}: target 0x{target:08X} not thumb"
            )
            self.assertGreaterEqual(
                target & ~1, CODE_BASE, f"hook 0x{hook:X}: target 0x{target:08X}"
            )


if __name__ == "__main__":
    unittest.main()
