#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_TEST_TIMEOUT="${GODOT_TEST_TIMEOUT:-300}"
RUN_ROOT="${GODOT_TEST_TMP:-$(mktemp -d)}"
LOG_ROOT="$RUN_ROOT/focused-logs"
mkdir -p "$LOG_ROOT"

script_tests=(
  validation/validation_save_repository_test
  validation/validation_session_test
  validation/validation_game_state_adapter_test
  validation/validation_save_isolation_test
)

for test_path in "${script_tests[@]}"; do
  test_name="${test_path//\//_}"
  home_dir="$RUN_ROOT/home/$test_name"
  log_file="$LOG_ROOT/$test_name.log"
  rm -rf "$home_dir"
  mkdir -p "$home_dir"

  echo "::group::Godot validation test: $test_path"
  if ! HOME="$home_dir" \
      XDG_DATA_HOME="$home_dir/.local/share" \
      XDG_CONFIG_HOME="$home_dir/.config" \
      GODOT_SILENCE_ROOT_WARNING=1 \
      timeout "$GODOT_TEST_TIMEOUT" "$GODOT_BIN" \
      --headless --path "$PROJECT_ROOT" \
      --script "res://tests/$test_path.gd" >"$log_file" 2>&1; then
    cat "$log_file"
    echo "::endgroup::"
    echo "FAILED: $test_path" >&2
    exit 1
  fi
  tail -n 12 "$log_file"
  echo "::endgroup::"
done

echo "Validation Package 1 focused suite: 4/4 test entrypoints passed"
echo "Logs: $LOG_ROOT"
