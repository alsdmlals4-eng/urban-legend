#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_TEST_TIMEOUT="${GODOT_TEST_TIMEOUT:-300}"
RUN_ROOT="${GODOT_TEST_TMP:-$(mktemp -d)}"
LOG_ROOT="$RUN_ROOT/afterlife-canon-v2-logs"
mkdir -p "$LOG_ROOT"

entrypoints=(
  "res://tests/afterlife_migration/afterlife_canon_v2_loader_test.gd"
  "res://tests/afterlife_migration/afterlife_id_migration_registry_test.gd"
  "res://tests/afterlife_migration/afterlife_legacy_save_inspector_test.gd"
  "res://tests/afterlife_migration/afterlife_main_save_migrator_test.gd"
  "res://tests/afterlife_migration/afterlife_validation_save_migrator_test.gd"
  "res://tests/afterlife_migration/afterlife_migration_transaction_test.gd"
  "res://tests/afterlife_migration/afterlife_migration_integration_test.gd"
  "res://tests/afterlife_migration/afterlife_runtime_projection_test.gd"
  "res://tests/afterlife_migration/afterlife_real_fixture_contract_test.gd"
  "res://tests/monthly_state/monthly_state_policy_test.gd"
  "res://tests/monthly_state/monthly_state_save_compatibility_test.gd"
  "res://tests/monthly_state/monthly_state_cross_case_persistence_test.gd"
  "res://tests/first_session/m01_first_session_orchestration_test.gd"
  "res://tests/first_session/m01_first_session_runtime_sync_test.gd"
)

run_entrypoint() {
  local entrypoint="$1"
  local file_name="${entrypoint##*/}"
  local safe_name="${file_name%.gd}"
  local home_dir="$RUN_ROOT/home/$safe_name"
  local log_file="$LOG_ROOT/$safe_name.log"

  rm -rf "$home_dir"
  mkdir -p "$home_dir"

  echo "::group::Afterlife Canon v2 test: $safe_name"
  if ! HOME="$home_dir" \
      XDG_DATA_HOME="$home_dir/.local/share" \
      XDG_CONFIG_HOME="$home_dir/.config" \
      APPDATA="$home_dir/AppData/Roaming" \
      LOCALAPPDATA="$home_dir/AppData/Local" \
      GODOT_SILENCE_ROOT_WARNING=1 \
      timeout "$GODOT_TEST_TIMEOUT" "$GODOT_BIN" \
      --headless --path "$PROJECT_ROOT" --script "$entrypoint" >"$log_file" 2>&1; then
    cat "$log_file"
    echo "::endgroup::"
    echo "FAILED: $safe_name" >&2
    exit 1
  fi

  if grep -Eq 'SCRIPT ERROR:|Failed to load script|Parse Error:|Compile Error:' "$log_file"; then
    cat "$log_file"
    echo "::endgroup::"
    echo "FAILED: $safe_name emitted a script load/compile error" >&2
    exit 1
  fi

  tail -n 16 "$log_file"
  echo "::endgroup::"
}

for entrypoint in "${entrypoints[@]}"; do
  run_entrypoint "$entrypoint"
done

echo "Afterlife canon v2 migration: 14/14 entrypoints passed"
echo "Logs: $LOG_ROOT"
