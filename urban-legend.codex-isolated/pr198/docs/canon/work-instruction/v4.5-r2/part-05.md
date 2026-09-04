base_repository_review_policy: RECURSIVE_INVENTORY_THEN_RELEVANCE_DRIVEN_DEEP_READ

project_repository:
project_default_branch: "main"

project_local_path: "C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle"
canonical_local_checkout: "C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle"
godot_project_path: "C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle"

godot_executable:
godot_target_family: "4.7.x"
godot_recommended_exact_version_observed_at_v4_5_update: "4.7.1-stable"
godot_exact_version_to_verify:
godot_project_file: "project.godot"
startup_scene:
application_run_main_scene:

higodot:
  canonical_source_repository: "hi-godot/godot-ai"
  pinned_version_or_commit:
  adoption_record:
  authority: SOLE_PERSISTENT_GODOT_AUTHORING_AUTHORITY
  authoring_scope:
    - scene
    - node
    - script
    - resource
    - theme
    - animation
    - signal
    - project_settings
    - input_map
    - autoload
    - godot_project_filesystem
  adoption_status: NOT_VERIFIED

gut:
  canonical_source_repository: "bitwes/Gut"
  expected_version_when_godot_4_7_x: "9.7.1"
  source_branch_or_release: "godot_4_7"
  pinned_source_commit:
  license_expected: "MIT"
  authority: DETERMINISTIC_GDSCRIPT_TEST_AUTHORITY_WHEN_ADOPTED
  adoption_record:
  adoption_status: NOT_VERIFIED

hera_agent:
  canonical_asset_store: "https://store.godotengine.org/asset/notnull92/hera-agent-godot/"
  canonical_source:
  exact_cli_version:
  exact_addon_version:
  role: LIVE_QA_AND_OBSERVABILITY_ONLY
  persistent_source_mutation: FORBIDDEN
  transport: LOCALHOST_ONLY
  acceptance_source_delta: NONE
  adoption_status: NOT_VERIFIED

github:
  gh_cli_expected_installed: true
  gh_version:
  gh_auth_status:
  repository_visibility:
  actions_budget_usd: 0
  default_ci_mode: REMOTE_CI
  allowed_runner_class: STANDARD_GITHUB_HOSTED
  forbidden_by_budget:
    - LARGER_RUNNER
    - GPU_RUNNER
    - PAID_CUSTOM_IMAGE
  required_check: ci-gate
  merge_method_preference: squash
  local_user_handoff: FETCH_ORIGIN_THEN_PULL_ORIGIN

target_platforms:
  - Windows
  - Android

shared_core_policy: SINGLE_GAME_LOGIC_AND_DATA_CORE
platform_separation_policy: INPUT_UI_PLATFORM_INTEGRATION_AND_DELIVERY_PROFILE_ONLY
windows_export_required: true
android_export_required: true
target_resolutions: []
target_aspect_ratios: []
input_methods:
  - keyboard_mouse
  - gamepad_when_applicable
  - touch
  - android_back
accessibility_requirements: []

