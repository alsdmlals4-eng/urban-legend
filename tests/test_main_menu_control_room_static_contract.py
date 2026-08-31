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
        for node_name in [
            "MenuShell",
            "IdentityRail",
            "ActionRail",
            "IntelligenceRail",
            "WorldTitleLockup",
            "WorldTitle",
            "WorldTitleSuffix",
            "WorldSubtitle",
            "VersionLabel",
            "PrimaryActionHint",
            "SettingsButton",
            "ExitButton",
        ]:
            self.assertIn(f'"{node_name}"', menu)

    def test_reference_mockup_fiction_is_not_baked_into_runtime(self) -> None:
        menu = MENU.read_text(encoding="utf-8")
        for forbidden in ["김하람", "SYSTEM ALERT", "슬롯 01", "매우 높음", "2011. 08. 11"]:
            self.assertNotIn(forbidden, menu)

    def test_user_approved_bureau_archive_background_is_the_runtime_menu_backdrop(self) -> None:
        menu = MENU.read_text(encoding="utf-8")
        catalog = (ROOT / "scripts" / "ui" / "ui_asset_catalog.gd").read_text(encoding="utf-8")
        manifest = (ROOT / "ASSET_MANIFEST.yml").read_text(encoding="utf-8")

        self.assertIn('MAIN_MENU_BACKGROUND_ID := "bureau_archive_menu"', menu)
        self.assertIn('get_texture(MAIN_MENU_BACKGROUND_ID)', menu)
        self.assertIn('"bureau_archive_menu": "res://assets/backgrounds/bureau_archive_menu.png"', catalog)
        self.assertIn('asset_id: "ULAB-MAIN-MENU-BACKGROUND-001"', manifest)
        self.assertIn('canonical_path: "assets/backgrounds/bureau_archive_menu.png"', manifest)

    def test_world_title_lockup_displays_the_approved_product_title_without_renaming_the_agency(self) -> None:
        menu = MENU.read_text(encoding="utf-8")
        self.assertIn('title_lockup.name = "WorldTitleLockup"', menu)
        self.assertIn('title.name = "WorldTitle"', menu)
        self.assertIn('title.text = "괴이기록국"', menu)
        self.assertIn('report_title.name = "WorldTitleSuffix"', menu)
        self.assertIn('report_title.text = "잔향 보고서"', menu)
        self.assertIn('subtitle.name = "WorldSubtitle"', menu)
        self.assertIn('subtitle.text = "BUREAU OF ANOMALIES: ECHO REPORT"', menu)


if __name__ == "__main__":
    unittest.main()
