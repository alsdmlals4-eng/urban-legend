from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SYNC = ROOT / "scripts/core/m01_first_session_runtime_sync.gd"
BRIDGE = ROOT / "scripts/ui/canon_v2_runtime_bridge.gd"


class M01FirstSessionRuntimeWiringTests(unittest.TestCase):
    def test_runtime_sync_is_bounded_to_public_orchestration_apis(self) -> None:
        self.assertTrue(SYNC.is_file(), SYNC)
        text = SYNC.read_text(encoding="utf-8")
        for token in (
            'M01_CASE_ID := "episode_001_afterlife_station"',
            "func sync_scene_mode(",
            '"investigation"',
            '"rescue"',
            '"recovery"',
            '"result"',
            '"get_current_episode_id"',
            '"get_monthly_state"',
            '"transition_monthly_state"',
            '"get_m01_first_session_state"',
            '"apply_m01_first_session_event"',
        ):
            self.assertIn(token, text)
        for forbidden in (
            "correct_response_id",
            "required_hidden_answer_id",
            "true_answer_id",
            "true_hypothesis_id",
        ):
            self.assertNotIn(forbidden, text)

    def test_runtime_bridge_syncs_after_runtime_packet_refresh_before_mount(self) -> None:
        self.assertTrue(BRIDGE.is_file(), BRIDGE)
        text = BRIDGE.read_text(encoding="utf-8")
        self.assertIn(
            'preload("res://scripts/core/m01_first_session_runtime_sync.gd")',
            text,
        )
        build_index = text.index("var state := _build_overlay_state(mode)")
        sync_index = text.index("_sync_m01_first_session(mode, game_state)")
        mount_index = text.index("_mount_overlay(current_scene, state, mode)")
        self.assertLess(build_index, sync_index)
        self.assertLess(sync_index, mount_index)
        self.assertIn("func sync_m01_first_session_for_test(", text)
        self.assertIn("M01FirstSessionRuntimeSyncScript.new().sync_scene_mode", text)


if __name__ == "__main__":
    unittest.main()
