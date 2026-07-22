from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
HELPER = ROOT / "addons" / "godot_ai" / "runtime" / "game_helper.gd"
IMPLEMENTATION = ROOT / "addons" / "godot_ai" / "runtime" / "game_helper_impl.gd"
PLUGIN = ROOT / "addons" / "godot_ai" / "plugin.gd"


class GodotAiHeadlessContractTest(unittest.TestCase):
    def test_runtime_helper_matches_editor_headless_opt_in(self) -> None:
        helper = HELPER.read_text(encoding="utf-8")
        plugin = PLUGIN.read_text(encoding="utf-8")
        for source in (helper, plugin):
            self.assertIn("GODOT_AI_ALLOW_HEADLESS", source)
            self.assertIn("DisplayServer.get_name()", source)
            self.assertIn("--headless", source)
        self.assertIn("if _disabled_for_headless_launch():", helper)
        self.assertIn("GameHelperImpl.new()", helper)
        self.assertTrue(IMPLEMENTATION.is_file())
        self.assertIn("EngineDebugger.register_message_capture", IMPLEMENTATION.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
