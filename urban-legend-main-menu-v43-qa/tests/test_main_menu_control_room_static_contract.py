from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
MENU = ROOT / "scripts" / "ui" / "main_menu.gd"
VERSION_OWNER = ROOT / "scripts" / "core" / "product_version.gd"


class MainMenuControlRoomStaticContract(unittest.TestCase):
    def test_product_version_has_one_owner(self) -> None:
        self.assertTrue(VERSION_OWNER.exists(), "canonical product_version.gd must exist")
        owner = VERSION_OWNER.read_text(encoding="utf-8")
        menu = MENU.read_text(encoding="utf-8")
        self.assertIn('const CURRENT := "4.3"', owner)
        self.assertIn('return "Ver %s" % CURRENT', owner)
        self.assertIn('preload("res://scripts/core/product_version.gd")', menu)
        self.assertNotIn("const GAME_VERSION", menu)
        self.assertNotIn("Ver 4.2", menu)
        self.assertNotIn('"4.3"', menu, "main_menu.gd must not duplicate the version literal")

    def test_main_menu_is_not_a_document_wall(self) -> None:
        menu = MENU.read_text(encoding="utf-8")
        self.assertNotIn("ScrollContainer.new()", menu)
        for required_name in [
            'name = "MenuShell"',
            'name = "IdentityRail"',
            'name = "ActionRail"',
            'name = "IntelligenceRail"',
            'name = "VersionLabel"',
            'name = "PrimaryActionHint"',
            'name = "SettingsButton"',
            'name = "ExitButton"',
        ]:
            self.assertIn(required_name, menu)

    def test_reference_mockup_fiction_is_not_baked_into_runtime(self) -> None:
        menu = MENU.read_text(encoding="utf-8")
        for forbidden in ["김하람", "SYSTEM ALERT", "슬롯 01", "매우 높음", "2011. 08. 11"]:
            self.assertNotIn(forbidden, menu)


if __name__ == "__main__":
    unittest.main()
