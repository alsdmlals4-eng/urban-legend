#!/usr/bin/env bash
set -uo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_TEST_TIMEOUT="${GODOT_TEST_TIMEOUT:-300}"
RUN_ROOT="${GODOT_TEST_TMP:-$(mktemp -d)}/case01-ui"
LOG_ROOT="$RUN_ROOT/logs"
mkdir -p "$LOG_ROOT"

baseline_entrypoints=(
  "res://tests/anomaly_manual_drawer_test.gd"
  "res://tests/mvp043_investigation_ui_test.gd"
  "res://tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd"
  "res://tests/cinematic_ui_redesign_test.gd"
)

contract_entrypoints=(
  "res://tests/case01_ui/case01_device_model_test.gd"
  "res://tests/case01_ui/case01_device_shell_contract_test.gd"
  "res://tests/case01_ui/case01_manual_draft_state_test.gd"
  "res://tests/case01_ui/case01_shared_travel_test.gd"
)

run_entrypoint() {
  local entrypoint="$1"
  local file_name="${entrypoint##*/}"
  local safe_name="${file_name%.gd}"
  local home_dir="$RUN_ROOT/home/$safe_name"
  local log_file="$LOG_ROOT/$safe_name.log"

  rm -rf "$home_dir"
  mkdir -p "$home_dir"

  echo "::group::CASE-01 UI test: $safe_name"
  if ! HOME="$home_dir" \
      XDG_DATA_HOME="$home_dir/.local/share" \
      XDG_CONFIG_HOME="$home_dir/.config" \
      GODOT_SILENCE_ROOT_WARNING=1 \
      timeout "$GODOT_TEST_TIMEOUT" "$GODOT_BIN" \
      --headless --path "$PROJECT_ROOT" --script "$entrypoint" >"$log_file" 2>&1; then
    cat "$log_file"
    echo "::endgroup::"
    return 1
  fi

  if grep -Eq 'SCRIPT ERROR:|Failed to load script|Parse Error:|Compile Error:' "$log_file"; then
    cat "$log_file"
    echo "::endgroup::"
    return 1
  fi

  tail -n 16 "$log_file"
  echo "::endgroup::"
  return 0
}

baseline_failures=0
contract_failures=0

for entrypoint in "${baseline_entrypoints[@]}"; do
  if ! run_entrypoint "$entrypoint"; then
    echo "BASELINE_FAILED: $entrypoint" >&2
    baseline_failures=$((baseline_failures + 1))
  fi
done

for entrypoint in "${contract_entrypoints[@]}"; do
  if ! run_entrypoint "$entrypoint"; then
    echo "CONTRACT_FAILED: $entrypoint" >&2
    contract_failures=$((contract_failures + 1))
  fi
done

if (( baseline_failures > 0 )); then
  echo "CASE-01 UI baseline regression failed: $baseline_failures/4" >&2
  echo "Logs: $LOG_ROOT" >&2
  exit 2
fi

if (( contract_failures > 0 )); then
  echo "CASE-01 UI contracts RED: $contract_failures/4 failing" >&2
  echo "Logs: $LOG_ROOT" >&2
  exit 1
fi

echo "CASE-01 UI: 4/4 baseline + 4/4 contract entrypoints passed"
echo "Logs: $LOG_ROOT"
