"""The Modular Stat Getter (MSG) chains must actually be installed.

Without this, every stat modifier in the project -- Defiant, Rally, Push,
Resolve, Fury, debuffs, item passives -- is silently inert, because vanilla
GetUnit* runs instead of the modifier chain. The stat screen and combat both
call GetUnit*, so an uninstalled chain shows up as "the boost does nothing,
anywhere" with no build error (the installer file was simply never included).

Each hook replaces the vanilla getter body with jumpToHack:
    00 4b   ldr r3, [pc]
    18 47   bx  r3
    <4-byte pointer to the modular getter>

Also pins a safety invariant: EngineHacks/Necessary/MSG/3rdParty/Inject*.event
carry FE8 addresses in places (e.g. ORG $87300 / $8731E, which in FE7 are
RegisterObjectSafe OAM sprite code, not stat-screen getter calls). Those
injectors must stay out of the FE7 build.
"""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MASTER = ROOT / "EngineHacks" / "_MasterHackInstaller.event"
MSG_DIR = ROOT / "EngineHacks" / "Necessary" / "MSG"
INSTALL_CORE = MSG_DIR / "InstallCore.event"
INSTALL_HELPERS = MSG_DIR / "InstallHelpers.event"
HELPER_DEFS = MSG_DIR / "HelperDefinitions.event"
STRMAG = MSG_DIR / "Extensions" / "Strmag.event"

# FE8 literals that land in FE7 sprite / UnitLoadSupports code.
# GetUnitMov (resume move-map) and item-passive getters call these.
FE8_MSG_HELPER_MARKERS = (
    "0x080163F0",  # GetItemHpBonus (FE8); FE7 is mid-function there
    "0x08016040",  # GetItemPowBonus (FE8)
    "0x4D8C 0x0802",  # AreUnitsAllied FE8 == StartUiSMS neighbourhood in FE7
    "0x4DA4 0x0802",  # IsSameAllegiance FE8
    "0x79D8 0x0801",  # GetUnitItemCount FE8 == UnitLoadSupports in FE7
    "0x76DC 0x0801",  # not GetUnitItemCount; returns item+index, inflates passives
    "0x97E4 0x0801",  # BmMapFill FE8
    "0xAABC 0x0801",  # MapAddInRange FE8
    "0x9430 0x0801",  # GetUnit FE8
    "0xE4D4 0x0202",  # gBmMapSize FE8
)

HACK = ROOT / "FE7_Hack.gba"
CLEAN = ROOT / "FE7_clean.gba"

JUMP_TO_HACK = bytes.fromhex("004b1847")

# FE7 GetUnit* entry points, confirmed against FE7 Decomp.txt.
GETTERS = {
    "MaxHP": 0x18AB0,
    "CurHP": 0x18A70,
    "Power": 0x18AD0,
    "Skill": 0x18AF0,
    "Speed": 0x18B30,
    "Defense": 0x18B70,
    "Resistance": 0x18B90,
    "Luck": 0x18BB8,
    "Aid": 0x18450,
    "Movement": 0x18B44,
    "Constitution": 0x18BA4,
}

# Sites the FE8-addressed 3rdParty injectors would clobber in FE7.
FE8_ADDRESSED_SITES = {
    "InjectMovGetters ORG $87300": 0x87300,
    "InjectConGetters ORG $8731E": 0x8731E,
}


def _read(path: Path) -> bytes:
    return path.read_bytes()


class ModularStatGetterSourceTests(unittest.TestCase):
    def test_master_installer_includes_stat_getters(self):
        src = MASTER.read_text(encoding="utf-8")
        self.assertRegex(
            src,
            r'#include\s+"Necessary/StatGetters/_InstallStatGetters\.event"',
            "MSG installer is not wired into the master hack installer",
        )

    def test_third_party_injectors_are_not_installed_unguarded(self):
        """Each Inject* include must sit inside an #ifdef ... #endif block."""
        src = INSTALL_CORE.read_text(encoding="utf-8")
        injectors = ("InjectMovGetters", "InjectConGetters", "InjectHPGetters")
        found = {name: False for name in injectors}
        depth = 0
        for line in src.splitlines():
            stripped = line.strip()
            if stripped.startswith("//"):
                continue
            if stripped.startswith(("#ifdef", "#ifndef")):
                depth += 1
                continue
            if stripped.startswith("#endif"):
                depth = max(0, depth - 1)
                continue
            if not stripped.startswith("#include"):
                continue
            for name in injectors:
                if f"{name}.event" in stripped:
                    found[name] = True
                    self.assertGreater(
                        depth,
                        0,
                        f"{name} is included unguarded; it carries FE8 "
                        "addresses that corrupt FE7 sprite code",
                    )
        self.assertTrue(
            any(found.values()),
            "no Inject* includes found at all -- test is no longer meaningful",
        )

    def test_msg_helpers_do_not_embed_fe8_runtime_addresses(self):
        """Resume black-screens when getters BL into FE8 UnitLoadSupports / SMS."""
        blob = HELPER_DEFS.read_text(encoding="utf-8") + INSTALL_HELPERS.read_text(
            encoding="utf-8"
        )
        for marker in FE8_MSG_HELPER_MARKERS:
            self.assertNotIn(
                marker,
                blob,
                f"MSG still embeds FE8 address {marker}; chapter resume hangs",
            )
        defs = HELPER_DEFS.read_text(encoding="utf-8")
        self.assertNotIn(
            "POIN prGetUnitItemCount",
            defs,
            "POIN after the item loop word-aligns; ldr/F800 then jumps into padding",
        )
        self.assertIn("0x301E 0x2105 0x2300 0x8802", defs)
        self.assertIn("0xF000 0xF805", defs)

    def test_power_getter_is_defined_exactly_once(self):
        """Strmag.event and InstallCore.event must not both define prPowGetter."""
        strmag = STRMAG.read_text(encoding="utf-8")
        core = INSTALL_CORE.read_text(encoding="utf-8")
        defs = 0
        for src in (strmag, core):
            for line in src.splitlines():
                if line.strip().startswith("prPowGetter:"):
                    defs += 1
        self.assertEqual(defs, 1, "prPowGetter defined in both files (duplicate label)")


class ModularStatGetterRomTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not HACK.exists() or not CLEAN.exists():
            raise unittest.SkipTest("FE7_Hack.gba / FE7_clean.gba missing")
        cls.hack = _read(HACK)
        cls.rom = _read(CLEAN)

    def test_every_stat_getter_is_hooked(self):
        for name, addr in GETTERS.items():
            with self.subTest(getter=name):
                got = self.hack[addr : addr + 4]
                self.assertEqual(
                    got,
                    JUMP_TO_HACK,
                    f"{name} getter at {addr:#x} is not hooked "
                    f"(found {got.hex()}); modifier chain is inert",
                )

    def test_hooked_getters_differ_from_clean_rom(self):
        for name, addr in GETTERS.items():
            with self.subTest(getter=name):
                self.assertNotEqual(
                    self.hack[addr : addr + 8],
                    self.rom[addr : addr + 8],
                    f"{name} getter still matches vanilla",
                )

    def test_getter_hook_targets_point_into_rom(self):
        import struct

        for name, addr in GETTERS.items():
            with self.subTest(getter=name):
                ptr = struct.unpack_from("<I", self.hack, addr + 4)[0]
                self.assertTrue(
                    ptr & 1, f"{name} hook target {ptr:#x} lacks the Thumb bit"
                )
                offset = (ptr & ~1) - 0x08000000
                self.assertTrue(
                    0 < offset < len(self.hack),
                    f"{name} hook target {ptr:#x} is outside the ROM",
                )

    def test_defense_chain_reaches_the_defiant_routine(self):
        """Walk DefGetter -> pDefenseModifiers and find Defiant's HP check.

        This is the end-to-end version of the original bug: Defiant Defense
        produced no boost anywhere because the chain was never reachable.
        """
        import struct

        def rom_off(addr: int) -> int:
            return (addr & ~1) - 0x08000000

        # jumpToHack target of GetUnitDefense.
        getter = rom_off(struct.unpack_from("<I", self.hack, GETTERS["Defense"] + 4)[0])

        # rGetterWrapper is 10 shorts, then POIN prCallSequence, POIN <list>.
        modifier_list = struct.unpack_from("<I", self.hack, getter + 24)[0]

        entries = []
        cursor = rom_off(modifier_list)
        while True:
            ptr = struct.unpack_from("<I", self.hack, cursor)[0]
            if ptr == 0:
                break
            entries.append(ptr)
            cursor += 4
            self.assertLess(len(entries), 64, "modifier list is not terminated")

        self.assertTrue(entries, "pDefenseModifiers is empty")

        # DefiantSkill.lyn.event prologue + the 25%-of-max-HP threshold check:
        # push {r4-r6,lr}; mov r4,r0; mov r5,r1;
        # ldrb r0,[r5,#0x12]; ldrb r1,[r5,#0x13]; lsl r1,r1,#2; cmp r1,r0
        defiant_sig = bytes.fromhex("70b5041c0d1ca87ce97c89008142")
        found = any(
            defiant_sig in self.hack[rom_off(p) : rom_off(p) + 0x30] for p in entries
        )
        self.assertTrue(
            found,
            "no Defiant routine in the Defense modifier chain; "
            "Defiant Defense would apply no boost",
        )

    def test_fe8_addressed_injection_sites_remain_untouched(self):
        for name, addr in FE8_ADDRESSED_SITES.items():
            with self.subTest(site=name):
                self.assertEqual(
                    self.hack[addr : addr + 8],
                    self.rom[addr : addr + 8],
                    f"{name} clobbered FE7 sprite code at {addr:#x}",
                )


if __name__ == "__main__":
    unittest.main()
