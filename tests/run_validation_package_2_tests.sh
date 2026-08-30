#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_TEST_TIMEOUT="${GODOT_TEST_TIMEOUT:-300}"
RUN_ROOT="${GODOT_TEST_TMP:-$(mktemp -d)}"
LOG_ROOT="$RUN_ROOT/focused-logs"
mkdir -p "$LOG_ROOT"

script_tests=(
  validation/validation_persistence_summary_test
  validation/validation_route_mapper_test
  validation/validation_runtime_initializer_test
  validation/validation_entry_coordinator_test
  validation/validation_main_menu_contract_test
  validation/main_menu_window_breakpoint_test
  validation/windows_user_data_isolation_test
)

for test_path in "${script_tests[@]}"; do
  test_name="${test_path//\//_}"
  home_dir="$RUN_ROOT/home/$test_name"
  log_file="$LOG_ROOT/$test_name.log"
  rm -rf "$home_dir"
  mkdir -p "$home_dir"

  echo "::group::Godot validation Package 2 test: $test_path"
  if ! HOME="$home_dir" \
      XDG_DATA_HOME="$home_dir/.local/share" \
      XDG_CONFIG_HOME="$home_dir/.config" \
      APPDATA="$home_dir/AppData/Roaming" \
      LOCALAPPDATA="$home_dir/AppData/Local" \
      GODOT_SILENCE_ROOT_WARNING=1 \
      timeout "$GODOT_TEST_TIMEOUT" "$GODOT_BIN" \
      --headless --path "$PROJECT_ROOT" \
      --script "res://tests/$test_path.gd" >"$log_file" 2>&1; then
    cat "$log_file"
    echo "::endgroup::"
    echo "FAILED: $test_path" >&2
    exit 1
  fi
  if grep -Eq 'SCRIPT ERROR:|Failed to load script|Parse Error:|Compile Error:' "$log_file"; then
    cat "$log_file"
    echo "::endgroup::"
    echo "FAILED: $test_path emitted a script load/compile error" >&2
    exit 1
  fi
  tail -n 12 "$log_file"
  echo "::endgroup::"
done

echo "Validation Package 2 focused suite: ${#script_tests[@]}/${#script_tests[@]} test entrypoints passed"
echo "Logs: $LOG_ROOT"
