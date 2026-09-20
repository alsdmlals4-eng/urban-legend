"""Structural routing checks; these do not prove agent compliance or game fun."""
from pathlib import Path
import json
import unittest

ROOT = Path(__file__).resolve().parents[1]


class LeanAuthorityAdoptionTests(unittest.TestCase):
    def setUp(self):
        self.adapter = json.loads((ROOT / "skills/PROJECT_BASE_ADAPTER.json").read_text(encoding="utf-8"))
        self.operating = self.adapter["shared_overrides"]["managing-game-project-operating-system"]

    def test_current_routes_do_not_resolve_to_compatibility_history(self):
        owners = self.operating.get("current_authority", {})
        self.assertEqual(owners.get("active_context"), "docs/CURRENT_HANDOFF.md")
        self.assertEqual(owners.get("decisions"), "docs/CURRENT_DECISION_OVERLAY.md")
        self.assertEqual(owners.get("planning"), "docs/CURRENT_PLANNING_CANON.md")
        for owner in owners.values():
            self.assertTrue((ROOT / owner).is_file(), owner)

    def test_policy_delta_does_not_replace_the_released_identity(self):
        policy = self.operating.get("selective_policy_adoption", {})
        self.assertEqual(self.adapter["base_release"]["version"], "9.4.4")
        self.assertEqual(policy.get("source_prs"), [883, 885])
        self.assertEqual(policy.get("release_identity_changed"), False)
        self.assertEqual(policy.get("refresh_policy"), "FETCH_COMPARE_APPROVE_DELTA")
        self.assertTrue((ROOT / policy.get("project_contract", "missing")).is_file())

    def test_reference_routes_select_only_adopted_policy_modules(self):
        policy = self.operating.get("selective_policy_adoption", {})
        refs = policy.get("references", {})
        self.assertIn("intake", refs)
        self.assertIn("experience", refs)
        for entry in refs.values():
            self.assertRegex(entry["commit"], r"^[0-9a-f]{40}$")
            self.assertTrue(entry["path"].endswith(".md"))
            self.assertRegex(entry["sha256"], r"^[0-9a-f]{64}$")
        self.assertEqual(policy.get("unlisted_routes"), "RETAIN_RELEASED_PACKAGE")

    def test_discipline_read_lists_do_not_promote_historical_ledger(self):
        for path in (ROOT / "skills/disciplines").glob("*/SKILL.md"):
            text = path.read_text(encoding="utf-8")
            section = text.split("## Read first", 1)[1].split("\n## ", 1)[0]
            self.assertNotIn("CURRENT_STATUS.md", section, str(path))
            self.assertNotIn("PROJECT_PATH_ADAPTER.json", section, str(path))
            self.assertIn("AGENTS.md", section, str(path))

    def test_experience_binding_points_to_existing_owners_not_new_director(self):
        ux = self.adapter["shared_overrides"]["auditing-and-refining-ui-art"]
        binding = ux.get("experience_verification", {})
        self.assertEqual(binding.get("human_evidence"), "NOT_RUN")
        self.assertEqual(binding.get("authority"), "METHOD_ADOPTION_NOT_FUN_PASS")
        for key in ("project_contract", "experience_source", "verification_owner"):
            self.assertTrue((ROOT / binding.get(key, "missing")).is_file(), key)
        self.assertFalse(binding.get("new_runtime_director", True))

    def test_experience_anchor_and_existing_consumers_resolve(self):
        text = (ROOT / "docs/UX_UI_SYSTEM.md").read_text(encoding="utf-8")
        self.assertIn('<a id="experience-verification"></a>', text)
        import re
        targets = re.findall(r"`(scripts/[^ `]+\.gd)`", text)
        self.assertGreaterEqual(len(set(targets)), 5)
        for target in targets:
            self.assertTrue((ROOT / target).is_file(), target)


if __name__ == "__main__":
    unittest.main()
