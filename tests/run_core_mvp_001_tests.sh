#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
RUN_ROOT="${GODOT_TEST_TMP:-$(mktemp -d)}"
LOG_ROOT="$RUN_ROOT/focused-logs"
mkdir -p "$LOG_ROOT"

tests=(
  core_mvp_001_case_data_test
  core_mvp_001_playtest_log_test
  core_mvp_001_state_test
  core_mvp_001_scene_test
)

for name in "${tests[@]}"; do
  home_dir="$RUN_ROOT/focused-home/$name"
  log_file="$LOG_ROOT/$name.log"
  rm -rf "$home_dir"
  mkdir -p "$home_dir"
  echo "::group::CORE-MVP-001 focused test: $name"
  if ! HOME="$home_dir" \
      XDG_DATA_HOME="$home_dir/.local/share" \
      XDG_CONFIG_HOME="$home_dir/.config" \
      GODOT_SILENCE_ROOT_WARNING=1 \
      timeout 90 "$GODOT_BIN" --headless --path "$PROJECT_ROOT" \
      --script "res://tests/$name.gd" >"$log_file" 2>&1; then
    cat "$log_file"
    echo "::endgroup::"
    echo "FAILED: $name" >&2
    exit 1
  fi
  cat "$log_file"
  echo "::endgroup::"
done

echo "CORE-MVP-001 focused suite: 4/4 passed"
