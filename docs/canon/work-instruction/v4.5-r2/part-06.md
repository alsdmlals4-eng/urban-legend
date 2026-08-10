build_size_policy:
  objective: PRESERVE_PERCEIVED_QUALITY_WHILE_REMOVING_WASTED_BYTES
  measure_separately:
    - DOWNLOAD
    - INSTALLED
    - RUNTIME
    - PATCH
  font_policy: UNIFY_FAMILY_AND_THEME_ROLES_NOT_FORCE_SINGLE_FILE
  platform_delivery_profiles: WINDOWS_AND_ANDROID_SEPARATE

project_google_sheet:
google_sheet_required_tabs_or_ranges: []
decision_ledger_source:
unresolved_items_source:
image_review_sheet_tab_or_range:
entry_state_reconciliation_required: true

project_asset_vault:
  local_root: "<project-root>/.asset-vault/"
  godot_local_projection: "res://assets/_vault_local/"
  tracked_manifest: "ASSET_MANIFEST.yml"
  approval_boundary: PROJECT_ASSET_APPROVED
  tracked_promotion_required: true

local_godot_reference_library:
  path: "C:/Users/user/Documents/GitHub/Godot_Reference"
  authority: REFERENCE_ONLY
  expected_categories:
    - Templates
    - Official_Demos
    - Plugins_Reference
    - Sandbox
    - Archive/Source_Zips
  known_reference_candidates:
    - godot-demo-projects-master
    - loading_serialization
    - gui_multiple_resolutions
    - 3d_graphics_settings
    - Global-Asset-Manager-2.0.1
    - Maaack_Game_Template_if_present

shared_audio_vault_path: "C:/Users/user/Documents/GitHub/shered audio vault"
shared_audio_vault_access: READ_ONLY_SOURCE_LIBRARY
shared_audio_vault_first: true
audio_runtime_reference_policy: COPY_APPROVED_ASSETS_INTO_RES_NOT_ABSOLUTE_PATH

current_goal:
requested_deliverables:
vertical_slice_scope:

protected_decisions: []
protected_behaviors: []
protected_files_or_assets: []
explicit_exclusions: []

planning_first: true
test_first_every_task: true
numeric_detail_policy: GPT_RECOMMENDED_WITH_EVIDENCE_AND_TUNING_RANGE
planning_conflict_policy: GRILL_ME_AND_REQUIRE_USER_APPROVAL
grill_me_approval_batch_max: 10
benchmark_policy: OFFICIAL_AND_PROFESSIONAL_RESEARCH_REQUIRED_WHEN_DECISION_RELEVANT

codex_handoff_policy: ON_DEMAND_CODEX_HANDOFF
codex_handoff_trigger: USER_REQUESTED_CODEX_HANDOFF
codex_package_definition_of_ready: REQUIRED
codex_preflight_policy: OPTIONAL_RISK_BASED
gpt_godot_preproduction_allowed: true

new_skill_policy: CONSOLIDATION_FIRST_BUT_ALLOWED_WITH_INDEPENDENT_BOUNDARY
base_promotion_policy: BCP_PROPOSAL_THEN_SEPARATE_APPROVED_IMPLEMENTATION_PR

implementation_authority: APPROVED_CANON_AND_RECOMMENDED_NON_CONFLICTING_DETAILS
merge_authority: APPROVED_ITEM_INHERITS_MERGE_AUTHORITY
merge_reapproval_required_for_same_approved_scope: false
post_merge_local_sync_authority: AUTHORIZED_AFTER_MERGE
