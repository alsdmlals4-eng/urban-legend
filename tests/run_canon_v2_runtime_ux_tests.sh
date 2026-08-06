#!/usr/bin/env bash
set -euo pipefail

GODOT_BIN="${GODOT_BIN:-godot}"
TESTS=(
  "tests/canon_v2_runtime/canon_v2_policy_test.gd"
  "tests/canon_v2_runtime/canon_v2_runtime_state_test.gd"
  "tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd"
)

for test_path in "${TESTS[@]}"; do
  echo "=== CANON V2 RUNTIME UX: ${test_path} ==="
  "${GODOT_BIN}" --headless --path . --script "res://${test_path}"
done
