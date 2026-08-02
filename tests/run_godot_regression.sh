#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_TEST_TIMEOUT="${GODOT_TEST_TIMEOUT:-300}"
RUN_ROOT="${GODOT_TEST_TMP:-$(mktemp -d)}"
LOG_ROOT="$RUN_ROOT/logs"
mkdir -p "$LOG_ROOT"

script_tests=(
  annual_mvp_001_data_test
  annual_mvp_001_state_test
  annual_mvp_001_support_resolver_test
  annual_mvp_001_incident_adapter_test
  annual_mvp_001_save_data_test
  annual_mvp_001_scene_test
  accessibility_settings_test
  agent_selection_card_test
  anomaly_manual_drawer_test
  cinematic_ui_redesign_test
  core_mvp_001_case_data_test
  core_mvp_001_playtest_log_test
  core_mvp_001_scene_test
  core_mvp_001_state_test
  core_validation_database_scroll_test
  core_validation_guided_flow_test
  core_validation_manual_promotion_test
  daily_episode_ui_test
  investigation_return_flow_test
  minigame_controls_test
  minigame_formatter_test
  minigame_pipeline_test
  minigame_rules_test
  minigame_scene_smoke_test
  mvp043_afterlife_evidence_flow_test
  mvp043_investigation_ui_test
  mvp043_opening_flow_test
  mvp043_protagonist_support_test
  mvp043_reasoning_ui_test
  mvp043_recovery_loop_test
  post_mvp_visual_data_test
  preparation_agent_ui_test
  preparation_schedule_ui_test
  progressive_disclosure_preparation_test
  runtime_ui_editor_scene_test
  runtime_ui_editor_test
  test_mvp039_manual_ux_validation
  test_mvp040_dead_frequency_slice
  test_mvp042_daily_episodes
  test_three_case_campaign_manual_qa
  test_two_case_campaign_manual_qa
  ui_asset_catalog_test
  ui_layout_store_test
  validation/validation_save_repository_test
  validation/validation_session_test
  validation/validation_game_state_adapter_test
  validation/validation_save_isolation_test
  validation/validation_persistence_summary_test
  validation/validation_route_mapper_test
  validation/validation_runtime_initializer_test
  validation/validation_entry_coordinator_test
  validation/validation_main_menu_contract_test
)

scene_tests=(
  test_agent_system
  test_mvp033_unified_recovery
  test_mvp034_faction_market
  test_mvp035_log_companion
  test_mvp037_campaign_state
  test_mvp038_requests
)

run_test() {
  local name="$1"
  local mode="$2"
  local safe_name="${name//\//_}"
  local home_dir="$RUN_ROOT/home/$safe_name"
  local log_file="$LOG_ROOT/$safe_name.log"
  local target
  rm -rf "$home_dir"
  mkdir -p "$home_dir"

  if [[ "$mode" == "scene" ]]; then
    target=(--scene "res://tests/$name.tscn")
  else
    target=(--script "res://tests/$name.gd")
  fi

  echo "::group::Godot test: $name"
  if ! HOME="$home_dir" \
      XDG_DATA_HOME="$home_dir/.local/share" \
      XDG_CONFIG_HOME="$home_dir/.config" \
      GODOT_SILENCE_ROOT_WARNING=1 \
      timeout "$GODOT_TEST_TIMEOUT" "$GODOT_BIN" \
      --headless --path "$PROJECT_ROOT" "${target[@]}" >"$log_file" 2>&1; then
    cat "$log_file"
    echo "::endgroup::"
    echo "FAILED: $name" >&2
    exit 1
  fi
  if grep -Eq 'SCRIPT ERROR:|Failed to load script|Parse Error:|Compile Error:' "$log_file"; then
    cat "$log_file"
    echo "::endgroup::"
    echo "FAILED: $name emitted a script load/compile error" >&2
    exit 1
  fi
  tail -n 12 "$log_file"
  echo "::endgroup::"
}

for test_name in "${script_tests[@]}"; do
  run_test "$test_name" script
done
for test_name in "${scene_tests[@]}"; do
  run_test "$test_name" scene
done

echo "Godot regression suite: 58/58 test entrypoints passed"
echo "Logs: $LOG_ROOT"
