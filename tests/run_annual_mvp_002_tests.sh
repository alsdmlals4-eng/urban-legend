#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_TEST_TIMEOUT="${GODOT_TEST_TIMEOUT:-180}"
RUN_ROOT="${GODOT_TEST_TMP:-$(mktemp -d)}"
LOG_ROOT="$RUN_ROOT/focused-logs"
mkdir -p "$LOG_ROOT"

script_tests=(
  validation/windows_user_data_isolation_test
  annual_mvp_002_planner_test
  annual_mvp_002_state_test
  annual_mvp_002_support_resolver_test
  annual_mvp_002_incident_adapter_test
  annual_mvp_002_scene_test
  annual_mvp_002_review_test
  annual_mvp_002_review_followup_test
  annual_mvp_002_disabled_unique_test
)

run_test() {
  local name="$1"
  local safe_name="${name//\//_}"
  local home_dir="$RUN_ROOT/home/$safe_name"
  local log_file="$LOG_ROOT/$safe_name.log"
  rm -rf "$home_dir"
  mkdir -p "$home_dir"
  echo "::group::ANNUAL-MVP-002 test: $name"
  if ! HOME="$home_dir" \
      XDG_DATA_HOME="$home_dir/.local/share" \
      XDG_CONFIG_HOME="$home_dir/.config" \
      APPDATA="$home_dir/AppData/Roaming" \
      LOCALAPPDATA="$home_dir/AppData/Local" \
      GODOT_SILENCE_ROOT_WARNING=1 \
      timeout "$GODOT_TEST_TIMEOUT" "$GODOT_BIN" \
      --headless --path "$PROJECT_ROOT" --script "res://tests/$name.gd" >"$log_file" 2>&1; then
    cat "$log_file"
    echo "::endgroup::"
    echo "FAILED: $name" >&2
    exit 1
  fi
  tail -n 20 "$log_file"
  echo "::endgroup::"
}

for test_name in "${script_tests[@]}"; do
  run_test "$test_name"
done

echo "ANNUAL-MVP-002 focused suite: ${#script_tests[@]}/${#script_tests[@]} test entrypoints passed"
echo "Logs: $LOG_ROOT"
