# CASE-01 Investigation Device UI Implementation Plan

> **Required execution skill:** `superpowers:test-driven-development` for every behavior slice, followed by `superpowers:verification-before-completion` before any completion claim.
>
> **Primary project discipline:** `urban-legend-ux-ui-accessibility` — modes `architecture`, `accessibility`, `interaction-review`.
> **Approval Decision:** `D-2026-08-11-CASE01-UI-SEPARATION-SPEC-APPROVED`
> **Consolidated Spec:** `docs/specs/CASE01_ACTUAL_GAME_UI_SEPARATION_SPEC_2026-08-11.md`
> **Planning PR:** #197 (`agent/lume-integrated-companion-ui-20260811`)
> **Planning baseline project main:** `c903d557399abfc0e44ee79f531a8d37ba5968d9`
> **Existing UI hierarchy runtime already merged:** `8294aa2eefe03fa7669617675516c9f03f739076` / PR #180
> **Project Base release identity:** Base v9.4.3, payload `7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8`
> **Legacy project registry pin:** `c987647d01ad2baa028a16e03d85ddfc1572a727`
> **Base remote main observed during planning:** `23d5b292f619022cdd8ab7a33fb1debc2d294861`
> **Base freshness rule:** newer Base remote state is recorded only; this plan does not silently adopt it.
> **Godot authoring authority:** persistent Scene/Node/Resource/Project Settings mutation requires the HiGodot-authorized execution path. GUT/headless tests are verification authorities, not persistent authoring authorities.

## Goal

Implement the approved CASE-01 `저승역` investigation UI as a thin presentation/adaptation layer on top of the current Canon v2 and already-merged investigation hierarchy:

- keep the field scene focused on location, dialogue, investigation points/methods, result feedback, and team status;
- open one reusable `InvestigativeDeviceShell` for `[기록] [괴이 매뉴얼] [지도]`;
- keep `루메` contextual rather than a separate log tab;
- make records text-only;
- expose the approved five player-facing manual sections over the existing three Canon v2 logic pages without changing the 4/5/5 slot counts;
- make keyword placement complete by click/tap and keyboard/gamepad, with drag optional;
- route map travel and field `[이동]` through one presentation travel service;
- preserve tab/UI context without causing save, time, or judgment side effects;
- retain the same information composition on PC, tablet, and phone landscape.

This implementation must not change the anomaly truth, clue outcomes, rescue/recovery truth, campaign semantics, or save version.

## Architecture

Use **ADAPT_EXISTING + THIN CASE01 ADAPTER**, not a replacement investigation scene and not a second game-state authority.

```text
existing GameState / AfterlifeMigratingGameState
├─ current episode + investigation point state
├─ Canon v2 manual state (`filled_slots`, evidence records)
└─ existing save checkpoints
             │
             │ narrow read/write intent
             ▼
Case01DeviceDataAdapter
├─ reads current Canon v2 episode projection
├─ reads/writes Canon v2 manual draft through a narrow state API
├─ filters acquired records/candidates
└─ never calculates truth correctness
             │
             ├───────────────┐
             ▼               ▼
Case01TravelSession      Case01DeviceCatalog
├─ current UI location    ├─ 5 UI section mapping
├─ same travel request    ├─ canonical candidate labels/IDs
└─ point filtering        ├─ location→existing point mapping
                          └─ Lume non-answer copy
             │
             ▼
InvestigativeDeviceShell
├─ RecordsTab
├─ ManualTab
├─ MapTab
└─ LumeCompanion
             │
             ▼
existing investigation_scene
├─ LocationPreview / narrative
├─ PointsBox / MethodButtonBox
├─ team / progress / result
├─ device entry buttons
└─ [이동]
```

### State ownership

- **Domain truth / flags / clue collection / rescue / recovery / save:** existing GameState and Canon v2 runtime.
- **Manual draft placement:** existing Canon v2 `manual.filled_slots`, exposed through one narrow `AfterlifeMigratingGameState` method; no new save key and no save-version bump.
- **Shell UI context:** shell instance only; never triggers `save_game()` on tab change/open/close.
- **Current presentation location:** one `Case01TravelSession` owned by the investigation scene for this field session. It filters existing investigation points only; it does not invent new `field_node_id` values.
- **Truth correctness:** never owned by shell/catalog/theme.

### Runtime activation boundary

The new shell is enabled only when the active data is compatible with the Canon v2 CASE-01 contract. The adapter must fail closed when the active contract is not `afterlife-station-canon-v2`.

This plan does **not** make the UI layer silently activate Canon v2 or rewrite legacy/new-run domain routing. Canon activation is a separate product/canon concern. Existing legacy UI remains the fallback when the compatible contract is not active.

## Tech Stack

- Godot 4.7.1 stable
- GDScript
- Godot `Control`, `Container`, `ScrollContainer`, `Button`, `TextureRect`, `Theme`
- existing `AfterlifeMigratingGameState`, Canon v2 loader/projection, investigation scene and PR #180 hierarchy
- deterministic headless SceneTree tests under `tests/case01_ui/`
- existing GUT suite for broader non-authoring regression
- GitHub Actions exact-head validation
- Windows `START_HUMAN_QA.cmd` for actual human/save/input validation after runtime integration

## Global Constraints

1. **No changes to `scripts/core/game_state.gd`.** PR #196 currently touches this protected file; this feature does not need it.
2. **No changes to `project.godot`.** Phone landscape Project Settings remain a separate protected/HiGodot decision; runtime layout tests can use landscape viewports without changing Project Settings.
3. **No episode JSON edits for this UI slice.** `data/episodes/episode_001_afterlife_station.json`, Canon v2 sidecar, and runtime projection are read-only inputs in this plan.
4. **No save-version bump.** Reuse existing Canon v2 `manual.filled_slots` storage.
5. **No new domain truth.** UI catalog labels and mappings must come from approved CASE-01 canon/Decisions; no new clue, answer, risk, rescue, or recovery semantics.
6. **No independent log/AI log tab.** Internal legacy node/file IDs may remain for compatibility, but player-facing CASE-01 shell exposes only `[기록] [괴이 매뉴얼] [지도]` and contextual `루메`.
7. **No audio assets/player/waveform.** Audio-origin records are displayed as text records only.
8. **No answer leakage.** Candidate cards cannot visually encode correct/wrong/mutated/fitness state before the canon explicitly allows disclosure.
9. **No drag dependency.** Click/tap and keyboard/gamepad must complete every manual placement/replacement/clear action; drag is optional.
10. **Same composition in landscape.** PC/tablet/phone keep the same semantic column order; smaller screens use tighter metrics/scrolling rather than mobile-only drawers that move the manual index/candidate rail.
11. **HiGodot boundary.** `.tscn` persistent edits happen only through authorized Godot authoring. If unavailable, stop before scene mutation and report `BLOCKED_HIGODOT_UNAVAILABLE`.
12. **Planning/runtime separation.** PR #197 remains planning/Decision only. Actual runtime work starts from the latest main after planning merge in a separate implementation branch/PR.
13. **Open-PR collision check.** Before runtime branch creation, reread open PRs. In particular, #196 currently changes `game_state.gd`/`project.godot`; #189 changes Canon overlay tests. Rebase/sequence rather than merging stale assumptions.
14. **Human truth.** Automated 1280×720/1920×1080/2340×1080 checks are not Human QA; actual phone/Android validation remains `NOT_RUN` until executed on device/export.

---

## Pre-code Gate A — Freeze the missing presentation-data mapping as one Decision

The consolidated Spec deliberately left three runtime-projection details unapproved: section 1/2 slot split, stable keyword IDs/unlock provenance, and exact UI location→existing-point grouping. Before Task 1 production code, create one Decision and mirror it to the Sheet. The implementation plan uses the following **exact proposed mapping**; runtime execution must stop if this mapping is not approved.

### A1. Five-section slot projection

```text
section_afterlife_occurrence_condition / 발생 조건
  slot_afterlife_p01_broadcast_blank
  slot_afterlife_p01_official_absence

section_afterlife_victim_link / 피해자 연결
  slot_afterlife_p01_listener_memory
  slot_afterlife_p01_destination_mismatch

section_afterlife_forbidden_action / 금지 행동
  all 5 `slot_afterlife_p02_*`

section_afterlife_rescue_procedure / 구출 절차
  all 5 `slot_afterlife_p03_*`

section_afterlife_recovery_response / 회수 대응
  editable slots: none
  read-only links: existing three Canon v2 recovery patterns
```

Sections 1 and 2 share the Canon v2 page-1 candidate pool. Splitting the UI does not add slots or a new completion gate.

### A2. Stable presentation keyword IDs

Page 1 / shared by sections 1–2:

```text
kw_afterlife_p01_destination_silence                   = 목적지 구간의 무음 공백
kw_afterlife_p01_listener_return_memory              = 듣는 사람의 귀환 기억
kw_afterlife_p01_concurrent_destination_mismatch     = 동시간대 목적지 불일치
kw_afterlife_p01_official_route_absence              = 공식 노선에 없는 추가 목적지
kw_afterlife_p01_original_testimony_mismatch         = 원본과 증언의 불일치
kw_afterlife_p01_personal_memory_projection          = 개인별 기억 투영
kw_afterlife_p01_mutated_start_silence               = [변조] 방송 시작 구간의 무음 공백
kw_afterlife_p01_mutated_same_destination            = [변조] 모두가 같은 목적지를 들음
```

Page 2 / section 3:

```text
kw_afterlife_p02_before_announcement_end             = 안내 종료 전
kw_afterlife_p02_projected_destination_direction     = 자신이 들은 목적지 방향
kw_afterlife_p02_directional_boundary                = 승차선·계단·출구 경계
kw_afterlife_p02_position_only_reset                 = 위치만 초기화
kw_afterlife_p02_time_record_persistence             = 시간·기록 유지
kw_afterlife_p02_internal_movement_safe              = 승강장 내부 이동은 안전
kw_afterlife_p02_victim_link_deepens                 = 반복할수록 피해자 연결 심화
kw_afterlife_p02_mutated_after_announcement_end      = [변조] 안내 종료 후
kw_afterlife_p02_mutated_time_and_position_reset     = [변조] 시간과 위치가 함께 초기화
```

Page 3 / section 4:

```text
kw_afterlife_p03_real_return_route                    = 현실 귀환 경로
kw_afterlife_p03_wait_for_announcement_end           = 안내 종료 대기
kw_afterlife_p03_official_station_identifier         = 공식 역 식별음
kw_afterlife_p03_matching_ticket                     = 노선색·노선명·역 코드 일치 승차권
kw_afterlife_p03_joint_boarding_and_disembarkation   = 피해자 동행 탑승·표 보관·지정 역 하차
kw_afterlife_p03_projected_destination_not_real      = 투영된 목적지는 현실 노선이 아님
kw_afterlife_p03_multichannel_ticket_verification    = 색상 외 문양·텍스트 교차 확인
kw_afterlife_p03_mutated_desired_ticket              = [변조] 개인의 바람에 맞는 승차권
kw_afterlife_p03_mutated_early_disembark             = [변조] 한 정거장 앞 하차
kw_afterlife_p03_mutated_victim_solo_boarding        = [변조] 피해자 단독 탑승
```

These are stable presentation/save-reference IDs only. They do not encode correctness in their player-facing styling.

### A3. Unlock/provenance rule

- A core keyword becomes available when its directly supporting Canon v2 record is present in the player's manual/evidence record set.
- A comparison/support keyword becomes available only when all records needed by that comparison are present.
- A `[변조]` candidate is derived from one normal keyword and becomes available no earlier than its source normal keyword; no independent fake evidence source is created.
- The UI catalog stores `source_record_ids` and optional `source_keyword_id`; it does not store a `correct` boolean used by presentation.
- Page/section filtering never narrows candidates by slot fitness.

### A4. Presentation location projection over existing point IDs

No new field nodes are created. Travel changes only the visible location grouping of existing investigation points.

```text
location_afterlife_platform / 승강장
  point_victim_phone
  point_platform_speaker
  point_frequency_terminal
  point_terminal_sign

location_afterlife_ticket_gate / 개찰구
  point_black_ticket

location_afterlife_staff_room / 역무원실
  point_staff_room_door
  point_staff_room_log
```

Unavailable/condition-locked investigation points stay visible according to the existing point condition/locked-text contract; travel does not bypass them.

**Decision ID to create at execution gate:** `D-2026-08-11-CASE01-UI-RUNTIME-PROJECTION-MAPPING`

**Commit (planning/Decision only):**

```bash
git add docs/decisions/D-2026-08-11-CASE01-UI-RUNTIME-PROJECTION-MAPPING.md
git commit -m "docs: freeze CASE-01 UI runtime projection mapping"
```

---

## Pre-code Gate B — Visual Requirement Gate

Current Sheet state has no approved CASE-01 UI/Lume product-asset entry in `72_이미지검수_승인로그`. Before binding any new Lume image or custom image ornament/background into tracked product runtime:

1. register each intended reference in `71_이미지기획_생성목록`;
2. perform visual review and record the approved item in `72_이미지검수_승인로그`;
3. reach `PROJECT_ASSET_APPROVED`;
4. add the approved tracked asset to root `ASSET_MANIFEST.yml` in the separate asset workflow;
5. only then bind the asset path in `LumeCompanion` or other product UI.

Native Godot panels, typography, borders, and layout can be implemented without adding unapproved image bytes. If Lume image approval is still missing, the runtime component remains text/comment-capable but its product image binding remains intentionally disabled and the visual completion status is `BLOCKED_ASSET_APPROVAL`, not PASS.

---

## Task 1 — Characterize latest main and establish CASE-01 RED contracts

**Purpose:** prove the new shell is absent while preserving the already-merged PR #180 hierarchy and Canon v2 behavior.

**Create tests only:**
- `tests/case01_ui/case01_device_model_test.gd`
- `tests/case01_ui/case01_device_shell_contract_test.gd`
- `tests/case01_ui/case01_manual_draft_state_test.gd`
- `tests/case01_ui/case01_shared_travel_test.gd`

**Do not modify production files yet.**

### Step 1.1 — Device model RED

Use dynamic `load()` so the expected failure is an assertion rather than a parser failure:

```gdscript
var model_script := load("res://scripts/ui/case01_device_data_adapter.gd")
_expect(model_script != null, "CASE-01 device adapter must exist")
```

When present later, assert its canonical snapshot contains:

- tabs exactly `records`, `manual`, `map`;
- no player-facing `log` / `ai_log` tab;
- five UI section IDs in approved order;
- existing Canon v2 page slot counts remain 4 / 5 / 5;
- records are derived from Canon v2 projected `clues` and contain text title/description;
- no audio-player capability flag.

Run and expect RED:

```bash
godot --headless --path . --script res://tests/case01_ui/case01_device_model_test.gd
```

### Step 1.2 — Shell RED

Dynamically load `res://scenes/ui/case01_investigative_device_shell.tscn` and assert the scene exists. After implementation assert:

- header has exactly three nav buttons plus `ReturnToFieldButton`;
- `RecordsHost`, `ManualHost`, `MapHost` exist;
- switching tabs changes only shell view state;
- last-tab state is restored after close/reopen on the same shell controller;
- full-screen noninteractive surfaces do not consume pointer input outside intended controls;
- `ui_cancel` closes topmost shell/modal layer before field-return behavior.

Run and expect RED:

```bash
godot --headless --path . --script res://tests/case01_ui/case01_device_shell_contract_test.gd
```

### Step 1.3 — Manual draft state RED

Instantiate `AfterlifeMigratingGameState` in a test fixture with a Canon v2-compatible manual and assert a narrow method exists for updating `manual.filled_slots` without saving or changing unrelated runtime state.

Required future API:

```gdscript
apply_afterlife_manual_draft(candidate_manual: Dictionary) -> Dictionary
```

RED expectations:

- method currently absent;
- candidate with valid existing slot IDs can later commit in memory;
- invalid/unknown slot ID must fail closed;
- unrelated Canon v2 runtime/protection state must remain byte-for-byte equal;
- save is not invoked by this API.

Run:

```bash
godot --headless --path . --script res://tests/case01_ui/case01_manual_draft_state_test.gd
```

### Step 1.4 — Shared travel RED

Dynamically load `res://scripts/ui/case01_travel_session.gd`. After implementation assert both `request_from_map(location_id)` and `request_from_field(location_id)` call the same internal `request_travel(location_id)` path and produce identical success/blocked results.

Also assert travel does not mutate `GameState.current_field_node_id` and cannot bypass the existing investigation-point condition gate.

Run:

```bash
godot --headless --path . --script res://tests/case01_ui/case01_shared_travel_test.gd
```

### Step 1.5 — Preserve PR #180 regression baseline

Before any production change, run the existing focused hierarchy tests and record their current result:

```bash
godot --headless --path . --script res://tests/anomaly_manual_drawer_test.gd
godot --headless --path . --script res://tests/mvp043_investigation_ui_test.gd
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd
godot --headless --path . --script res://tests/cinematic_ui_redesign_test.gd
```

The new CASE-01 tests must be RED for missing new behavior; existing PR #180 tests must not be made RED merely to begin this feature.

**Commit after clean RED evidence:**

```bash
git add tests/case01_ui
git commit -m "test: define CASE-01 investigation device contracts"
```

---

## Task 2 — Add the canonical presentation catalog and read-only data adapter

**Create:**
- `scripts/ui/case01_device_catalog.gd`
- `scripts/ui/case01_device_data_adapter.gd`

**Modify:**
- `tests/case01_ui/case01_device_model_test.gd`

### Step 2.1 — `Case01DeviceCatalog`

Implement immutable static dictionaries/arrays for:

- header/tab IDs and player labels;
- five UI section IDs and page/slot projection from Gate A;
- the 27 stable keyword IDs/labels and page pools from Gate A;
- keyword provenance/unlock record references;
- the three presentation locations and existing point IDs from Gate A;
- non-answer Lume copy IDs, with separate short copy for records/manual/map/field-call contexts.

The catalog must not contain a player-facing correctness rank or slot-fitness score.

### Step 2.2 — `Case01DeviceDataAdapter`

Required public API:

```gdscript
func bind_game_state(game_state: Node) -> void
func is_supported() -> bool
func get_shell_snapshot() -> Dictionary
func get_records_snapshot() -> Dictionary
func get_manual_snapshot() -> Dictionary
func get_map_snapshot(travel_session: RefCounted) -> Dictionary
func request_manual_slot_assignment(slot_id: String, keyword_id: String) -> Dictionary
func request_manual_slot_clear(slot_id: String) -> Dictionary
```

Rules:

- `is_supported()` requires CASE-01 and Canon v2 contract compatibility.
- read records from current Canon v2 episode `clues` projection, preserving `id/title/description/record_state`.
- merge collected/unverified state from the player's Canon v2 manual/evidence state without inventing proof.
- derive available candidates only from catalog provenance + currently available records.
- derive section display state from existing page/slot fill state.
- never expose `correct_response_id`, response correctness, or canonical answer fitness to ManualTab.
- fail closed with explicit error dictionaries when the contract or IDs are incompatible.

### Step 2.3 — Verify model

```bash
godot --headless --path . --script res://tests/case01_ui/case01_device_model_test.gd
```

Expected: PASS.

**Commit:**

```bash
git add scripts/ui/case01_device_catalog.gd \
        scripts/ui/case01_device_data_adapter.gd \
        tests/case01_ui/case01_device_model_test.gd
git commit -m "feat: add CASE-01 investigation device adapter"
```

---

## Task 3 — Add the narrow Canon v2 manual-draft write API

**Modify:**
- `scripts/core/afterlife_migrating_game_state.gd`
- `tests/case01_ui/case01_manual_draft_state_test.gd`
- `tests/afterlife_migration/afterlife_migration_integration_test.gd`

**Do not modify:**
- `scripts/core/game_state.gd`
- save version constants
- episode JSON

### Step 3.1 — Implement `apply_afterlife_manual_draft`

Required behavior:

```gdscript
func apply_afterlife_manual_draft(candidate_manual: Dictionary) -> Dictionary:
    # require active Canon v2 content contract
    # require `filled_slots` Dictionary
    # validate every slot id against current episode investigation_manual.slots
    # preserve evidence_records and unrelated manual fields unless explicitly supplied by the owned draft operation
    # update only _afterlife_v2_state.manual in memory
    # do not call save_game()
    # return {"ok": true, "manual": get_afterlife_manual_state()} on success
```

Validation:

- unknown slot IDs fail with `unknown_manual_slot`;
- non-string keyword references fail with `invalid_keyword_reference`;
- clearing is represented by removing the slot key, not an empty truth value;
- no correctness validation occurs here;
- no candidate is rejected because it is wrong for a slot.

### Step 3.2 — Adapter assignment/clear

`Case01DeviceDataAdapter` validates the keyword ID exists in the approved page-local catalog and is currently unlocked, then sends a whole updated manual draft through the narrow GameState API.

Do not call `save_game()` from slot selection, tab switch, shell close, or clear.

### Step 3.3 — Run focused state/migration tests

```bash
godot --headless --path . --script res://tests/case01_ui/case01_manual_draft_state_test.gd
godot --headless --path . --script res://tests/afterlife_migration/afterlife_migration_integration_test.gd
```

Expected: PASS with save migration/state isolation preserved.

**Commit:**

```bash
git add scripts/core/afterlife_migrating_game_state.gd \
        scripts/ui/case01_device_data_adapter.gd \
        tests/case01_ui/case01_manual_draft_state_test.gd \
        tests/afterlife_migration/afterlife_migration_integration_test.gd
git commit -m "feat: expose safe Canon v2 manual draft updates"
```

---

## Task 4 — Implement the shared presentation travel session

**Create:**
- `scripts/ui/case01_travel_session.gd`

**Modify:**
- `tests/case01_ui/case01_shared_travel_test.gd`

### Step 4.1 — API

```gdscript
class_name Case01TravelSession
extends RefCounted

func configure(location_catalog: Array, start_location_id: String) -> void
func get_current_location_id() -> String
func get_location_snapshot() -> Array
func request_from_map(location_id: String) -> Dictionary
func request_from_field(location_id: String) -> Dictionary
func request_travel(location_id: String) -> Dictionary
func visible_point_ids() -> Array[String]
```

Travel result shape:

```gdscript
{
    "ok": true,
    "location_id": "location_afterlife_staff_room",
    "visible_point_ids": ["point_staff_room_door", "point_staff_room_log"]
}
```

Blocked result shape:

```gdscript
{
    "ok": false,
    "reason": "unknown_location",
    "location_id": requested_id
}
```

The service owns only presentation grouping. It does not change flags, clue collection, field node, time, save, or investigation point conditions.

### Step 4.2 — Verify identical entry paths

```bash
godot --headless --path . --script res://tests/case01_ui/case01_shared_travel_test.gd
```

Expected: map and field entry paths yield the same result for the same location.

**Commit:**

```bash
git add scripts/ui/case01_travel_session.gd \
        tests/case01_ui/case01_shared_travel_test.gd
git commit -m "feat: add shared CASE-01 travel session"
```

---

## Task 5 — Build the reusable InvestigativeDeviceShell skeleton

**Create through HiGodot for persistent scenes:**
- `scenes/ui/case01_investigative_device_shell.tscn`
- `scenes/ui/case01_records_tab.tscn`
- `scenes/ui/case01_manual_tab.tscn`
- `scenes/ui/case01_map_tab.tscn`
- `scenes/ui/case01_lume_companion.tscn`

**Create scripts:**
- `scripts/ui/case01_investigative_device_shell.gd`
- `scripts/ui/case01_records_tab.gd`
- `scripts/ui/case01_manual_tab.gd`
- `scripts/ui/case01_map_tab.gd`
- `scripts/ui/case01_lume_companion.gd`

**Modify:**
- `tests/case01_ui/case01_device_shell_contract_test.gd`

### Step 5.1 — Stable node contract

Required shell tree roles:

```text
Case01InvestigativeDeviceShell
├─ DeviceFrame
│  ├─ Header
│  │  ├─ BureauCaseLabel
│  │  ├─ RecordsTabButton
│  │  ├─ ManualTabButton
│  │  ├─ MapTabButton
│  │  └─ ReturnToFieldButton
│  └─ ContentHost
│     ├─ RecordsHost
│     ├─ ManualHost
│     └─ MapHost
└─ ModalHost
```

No fourth log button.

### Step 5.2 — Shell controller

Required API/signals:

```gdscript
signal return_to_field_requested
signal tab_changed(tab_id: String)

func configure(adapter: RefCounted, travel_session: RefCounted) -> void
func open(tab_id: String = "") -> void
func close() -> void
func switch_tab(tab_id: String) -> void
func is_open() -> bool
func capture_ui_state() -> Dictionary
func restore_ui_state(state: Dictionary) -> void
```

Persist in shell memory:

- last tab;
- records category/selection/list+body scroll;
- manual section/slot/keyword/body+candidate scroll;
- map selected location/view state.

Do not call GameState save/time/progression functions from these methods.

### Step 5.3 — Input and pointer behavior

- Header buttons are keyboard/gamepad focusable in visual order.
- `ui_cancel` closes current modal, then shell, never clicks through into the field.
- decorative/background Controls use non-blocking mouse filter unless they are intentional modal blockers.
- `ReturnToFieldButton` restores the prior meaningful field focus through the investigation scene owner.

### Step 5.4 — Verify shell

```bash
godot --headless --path . --script res://tests/case01_ui/case01_device_shell_contract_test.gd
```

Expected: PASS.

**Commit:**

```bash
git add scenes/ui/case01_*.tscn scripts/ui/case01_*.gd tests/case01_ui/case01_device_shell_contract_test.gd
git commit -m "feat: add CASE-01 investigative device shell"
```

---

## Task 6 — Implement RecordsTab as a text-only investigation archive

**Create:**
- `tests/case01_ui/case01_records_tab_test.gd`

**Modify:**
- `scripts/ui/case01_records_tab.gd`
- `scenes/ui/case01_records_tab.tscn` via HiGodot
- `scripts/ui/case01_device_data_adapter.gd`

### Step 6.1 — RED archive contract

Assert:

- semantic three-column order is category/list → record body → meta/links;
- minimum categories exist: 전체, 현장 기록, 증거, 증언, 통신·방송 기록;
- record body uses title + text description/context;
- no `AudioStreamPlayer`, play/pause button, waveform control, or audio timeline exists;
- related links only reference already available record/keyword/manual locations;
- no `정답`, `오답`, `추천`, `적합도` labels are generated;
- selecting `[괴이 매뉴얼에서 보기]` emits navigation intent only.

Run RED then implement:

```bash
godot --headless --path . --script res://tests/case01_ui/case01_records_tab_test.gd
```

### Step 6.2 — Implement and pass

RecordsTab public API:

```gdscript
signal manual_link_requested(section_id: String)
func set_snapshot(snapshot: Dictionary) -> void
func capture_ui_state() -> Dictionary
func restore_ui_state(state: Dictionary) -> void
```

**Commit:**

```bash
git add scripts/ui/case01_records_tab.gd \
        scenes/ui/case01_records_tab.tscn \
        scripts/ui/case01_device_data_adapter.gd \
        tests/case01_ui/case01_records_tab_test.gd
git commit -m "feat: implement CASE-01 text records archive"
```

---

## Task 7 — Implement ManualTab 5-section layout and input contract

**Create:**
- `tests/case01_ui/case01_manual_tab_test.gd`
- `tests/case01_ui/case01_manual_input_test.gd`

**Modify:**
- `scripts/ui/case01_manual_tab.gd`
- `scenes/ui/case01_manual_tab.tscn` via HiGodot
- `scripts/ui/case01_device_data_adapter.gd`

### Step 7.1 — RED layout contract

Required semantic order at all supported landscape sizes:

```text
ManualSectionIndex | DeductionWorkspace | KeywordCandidateGrid + Lume
```

Assert section labels exactly:

1. 발생 조건
2. 피해자 연결
3. 금지 행동
4. 구출 절차
5. 회수 대응

Assert sections 1/2 share page-1 completion/candidate context and do not create additional Canon slots.

Section 5 is read-only and references the existing Canon recovery patterns; it has no new editable deduction slot.

### Step 7.2 — RED neutral candidate styling

Given a fixture with canonical, support, and `[변조]` keyword IDs, all undisclosed candidate buttons must resolve to the same StyleBox/font/icon treatment. The player-facing label may contain the canon-approved `[변조]` text only when that candidate's current disclosed state actually permits it; the UI must not infer or color-code it.

No correctness icon, red warning, green success, pulse/glitch, special border, or sort rank may reveal answer fitness.

### Step 7.3 — Input state machine

ManualTab owns only selection intent:

```text
none
→ slot selected
→ keyword selected
→ adapter assignment request
→ refreshed snapshot
```

and the reverse order:

```text
none
→ keyword selected
→ slot selected
→ adapter assignment request
→ refreshed snapshot
```

Required API/signals:

```gdscript
signal assignment_requested(slot_id: String, keyword_id: String)
signal clear_requested(slot_id: String)
func select_slot(slot_id: String) -> void
func select_keyword(keyword_id: String) -> void
func clear_selected_slot() -> void
func capture_ui_state() -> Dictionary
func restore_ui_state(state: Dictionary) -> void
```

- replacement is the same assignment path;
- clear removes one filled-slot reference;
- candidate keyword remains non-consumed;
- drag may call the same assignment method but no test may require drag for completion.

### Step 7.4 — Touch-equivalent contract

Buttons use one semantic `pressed` path independent of pointer source. Do not create a mobile-only long-press or drag-only handler.

Headless tests must prove the full placement sequence through button/selection APIs without mouse motion. Actual device touch remains Human/Android gate later.

Run:

```bash
godot --headless --path . --script res://tests/case01_ui/case01_manual_tab_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_manual_input_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_manual_draft_state_test.gd
```

Expected: PASS.

**Commit:**

```bash
git add scripts/ui/case01_manual_tab.gd \
        scenes/ui/case01_manual_tab.tscn \
        scripts/ui/case01_device_data_adapter.gd \
        tests/case01_ui/case01_manual_tab_test.gd \
        tests/case01_ui/case01_manual_input_test.gd
git commit -m "feat: implement CASE-01 manual deduction workspace"
```

---

## Task 8 — Implement MapTab and shared explicit travel confirmation

**Create:**
- `tests/case01_ui/case01_map_tab_test.gd`

**Modify:**
- `scripts/ui/case01_map_tab.gd`
- `scenes/ui/case01_map_tab.tscn` via HiGodot
- `scripts/ui/case01_investigative_device_shell.gd`

### Step 8.1 — RED map contract

Assert:

- selecting a place does **not** immediately travel;
- selection opens/refreshes detail with location name/description/status;
- explicit `[이동]` calls the shared travel session;
- current location cannot create a duplicate domain transition;
- map and field entry use the same travel result shape;
- Lume is hidden until a place detail is selected;
- locked investigation content stays locked according to existing domain conditions.

Run RED:

```bash
godot --headless --path . --script res://tests/case01_ui/case01_map_tab_test.gd
```

### Step 8.2 — Implement MapTab

Required API/signals:

```gdscript
signal travel_requested(location_id: String)
func set_snapshot(snapshot: Dictionary) -> void
func select_location(location_id: String) -> void
func confirm_travel() -> void
func capture_ui_state() -> Dictionary
func restore_ui_state(state: Dictionary) -> void
```

Do not put separate `지도로 이동하기 / 조사 화면에서 이동하기` method-choice cards inside the map. The two entry paths live in their respective surfaces but converge in `Case01TravelSession`.

### Step 8.3 — Pass

```bash
godot --headless --path . --script res://tests/case01_ui/case01_map_tab_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_shared_travel_test.gd
```

**Commit:**

```bash
git add scripts/ui/case01_map_tab.gd \
        scenes/ui/case01_map_tab.tscn \
        scripts/ui/case01_investigative_device_shell.gd \
        tests/case01_ui/case01_map_tab_test.gd
git commit -m "feat: implement CASE-01 map travel UI"
```

---

## Task 9 — Implement contextual Lume behavior without answer leakage

**Create:**
- `tests/case01_ui/case01_lume_companion_test.gd`

**Modify:**
- `scripts/ui/case01_lume_companion.gd`
- `scenes/ui/case01_lume_companion.tscn` via HiGodot
- `case01_records_tab.gd`
- `case01_manual_tab.gd`
- `case01_map_tab.gd`

### Step 9.1 — RED visibility contract

Assert:

- records/manual: compact Lume visible;
- map: hidden until location detail selected;
- field: companion body hidden by default; only a small call indicator may appear for a new non-answer comment;
- no independent Lume/log tab exists;
- comments never include target slot ID, correct keyword ID, answer fitness, undiscovered record ID, or mutation truth metadata.

Run:

```bash
godot --headless --path . --script res://tests/case01_ui/case01_lume_companion_test.gd
```

### Step 9.2 — Asset binding gate

If Gate B has produced a `PROJECT_ASSET_APPROVED` fixed Lume image, bind only the manifest-approved asset ID/path. If not, keep image binding disabled and report `BLOCKED_ASSET_APPROVAL`; do not substitute a redesigned character.

The component's text/comment logic may pass automated tests without the image, but visual completion cannot be declared.

**Commit:**

```bash
git add scripts/ui/case01_lume_companion.gd \
        scenes/ui/case01_lume_companion.tscn \
        scripts/ui/case01_records_tab.gd \
        scripts/ui/case01_manual_tab.gd \
        scripts/ui/case01_map_tab.gd \
        tests/case01_ui/case01_lume_companion_test.gd
git commit -m "feat: add contextual Lume companion behavior"
```

---

## Task 10 — Integrate shell and field travel into the existing investigation scene

**Modify through HiGodot where persistent Scene mutation is needed:**
- `scenes/investigation_scene.tscn`

**Modify script:**
- `scripts/scenes/investigation_scene.gd`

**Modify tests:**
- `tests/mvp043_investigation_ui_test.gd`
- `tests/cinematic_ui_redesign_test.gd`
- `tests/investigation_return_flow_test.gd`
- `tests/case01_ui/case01_device_shell_contract_test.gd`
- `tests/case01_ui/case01_shared_travel_test.gd`

### Step 10.1 — Preserve PR #180 hierarchy

Do not restore the old persistent manual-heavy layout. Reuse the current environment-first workspace and stable nodes from PR #180.

Add only one shell host/owner and CASE-01 utility entry points.

Required field-facing controls for supported Canon v2 CASE-01:

```text
[기록] [괴이 매뉴얼] [지도] [이동]
```

These are field utility entries, not a fourth log function.

Legacy internal `LogUtilityButton`/`LogGuide` identities may remain for compatibility, but they must not be visible as an independent player-facing CASE-01 `로그` or `AI 로그` surface.

### Step 10.2 — Shell integration

On CASE-01 Canon v2:

- create/configure one shell instance;
- Records/Manual/Map entry opens the same shell on the requested tab;
- opening the shell captures meaningful field focus;
- `[현장으로 돌아가기]` closes shell and restores focus/context;
- tab switching does not advance field dialogue or trigger point actions;
- shell opening/closing does not save or spend time.

On unsupported/legacy contracts:

- do not mount the new shell;
- preserve existing fallback behavior.

### Step 10.3 — Field `[이동]`

- open a location selector/detail surface driven by the same `Case01TravelSession` snapshot;
- require explicit `[이동]` confirmation;
- after success, update `LocationPreview`/location label and filter/re-render `%PointsBox` to `visible_point_ids()`;
- existing point condition evaluation remains authoritative;
- do not mutate `current_field_node_id`.

### Step 10.4 — Pointer/focus regression

When shell or travel selection is open:

- field action buttons behind it cannot be activated;
- decorative transparent surfaces do not consume unrelated pointer events;
- closing top layer restores valid prior focus or the first meaningful field action.

Run:

```bash
godot --headless --path . --script res://tests/mvp043_investigation_ui_test.gd
godot --headless --path . --script res://tests/cinematic_ui_redesign_test.gd
godot --headless --path . --script res://tests/investigation_return_flow_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_device_shell_contract_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_shared_travel_test.gd
```

Expected: PASS.

**Commit:**

```bash
git add scenes/investigation_scene.tscn \
        scripts/scenes/investigation_scene.gd \
        tests/mvp043_investigation_ui_test.gd \
        tests/cinematic_ui_redesign_test.gd \
        tests/investigation_return_flow_test.gd \
        tests/case01_ui
git commit -m "feat: integrate CASE-01 device shell with investigation"
```

---

## Task 11 — Same-composition landscape sizing and accessibility

**Create:**
- `tests/case01_ui/case01_landscape_layout_test.gd`

**Modify:**
- CASE-01 shell/tab scenes through HiGodot
- `scripts/ui/afterlife_station_theme.gd` only if theme tokens are reusable and do not affect unrelated scenes unexpectedly
- relevant CASE-01 UI scripts

### Step 11.1 — Deterministic viewport matrix

Test at:

```text
1280×720   — minimum PC validation target
1920×1080  — primary reference target
2340×1080  — representative wide phone landscape viewport
```

Assert for all three:

- same semantic order remains visible: left/index/list → center/body → right/meta/candidates;
- no core nav control is clipped;
- manual section index, deduction workspace, candidate rail all remain reachable without moving into a separate mobile drawer/bottom sheet;
- scroll containers expose overflow rather than clipping text;
- minimum touch/click target sizing is applied consistently to actionable controls;
- Korean labels do not rely on ellipsis for critical action meaning;
- focus order follows visual order.

No `project.godot` orientation mutation is part of this task.

### Step 11.2 — Input matrix

Automated:

- pointer/click through `pressed` actions;
- keyboard focus + `ui_accept`/`ui_cancel`;
- gamepad uses the same focus/accept path;
- manual semantic placement APIs prove no drag dependency.

Human/device later:

- actual touch accuracy;
- Android landscape orientation/export behavior;
- safe-area/notch behavior.

Run:

```bash
godot --headless --path . --script res://tests/case01_ui/case01_landscape_layout_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_manual_input_test.gd
```

**Commit:**

```bash
git add scenes/ui/case01_*.tscn \
        scripts/ui/case01_*.gd \
        scripts/ui/afterlife_station_theme.gd \
        tests/case01_ui/case01_landscape_layout_test.gd \
        tests/case01_ui/case01_manual_input_test.gd
git commit -m "fix: make CASE-01 device UI landscape accessible"
```

---

## Task 12 — Visual capture, full regression, exact-head review, and Human gate

**Modify/create only as required by existing test harness:**
- `tests/ui_visual_capture.gd`
- `TEST_CHECKLIST.md` only if the repository's current test governance requires adding the new CASE-01 route
- implementation evidence doc under `docs/implementation/`

### Step 12.1 — Capture matrix

Add deterministic capture routes for:

- field with device entry controls;
- RecordsTab;
- ManualTab section 1 and a filled-slot state;
- MapTab with one selected location detail;

At 1280×720 and 1920×1080. Add one 2340×1080 phone-landscape capture for composition verification.

Do not mark captures as human-approved automatically.

### Step 12.2 — Focused CASE-01 suite

```bash
godot --headless --path . --script res://tests/case01_ui/case01_device_model_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_device_shell_contract_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_manual_draft_state_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_shared_travel_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_records_tab_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_manual_tab_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_manual_input_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_map_tab_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_lume_companion_test.gd
godot --headless --path . --script res://tests/case01_ui/case01_landscape_layout_test.gd
```

### Step 12.3 — Existing UI/Canon regressions

```bash
godot --headless --path . --script res://tests/anomaly_manual_drawer_test.gd
godot --headless --path . --script res://tests/mvp043_investigation_ui_test.gd
godot --headless --path . --script res://tests/mvp043_reasoning_ui_test.gd
godot --headless --path . --script res://tests/investigation_return_flow_test.gd
godot --headless --path . --script res://tests/canon_v2_runtime/canon_v2_operation_overlay_test.gd
godot --headless --path . --script res://tests/afterlife_migration/afterlife_migration_integration_test.gd
godot --headless --path . --script res://tests/cinematic_ui_redesign_test.gd
```

### Step 12.4 — Repository-required static/smoke verification

Run from the implementation worktree using the configured Windows Godot path when on the target machine:

```powershell
& 'C:\Program Files\Git\cmd\git.exe' -C $worktree diff --check
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path $worktree --quit
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path $worktree --scene 'res://scenes/dialogue_scene.tscn' --quit-after 2
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path $worktree --scene 'res://scenes/investigation_scene.tscn' --quit-after 2
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path $worktree --scene 'res://scenes/battle_scene.tscn' --quit-after 2
```

Then run the repository's maintained full GUT/Godot regression command exactly as defined on the fresh implementation head/CI; do not substitute a partial suite for a full-regression claim.

### Step 12.5 — Exact-head GitHub review

Before requesting merge:

1. reread latest main and all open PRs touching the implementation files;
2. rebase/update the implementation branch if main moved;
3. rerun focused + full regression on the exact candidate head;
4. inspect diff for protected paths and unintended `.godot/`/asset changes;
5. confirm no `AI 로그`/independent `[로그]` player-facing string was reintroduced in CASE-01 shell;
6. confirm no audio player/waveform node was added;
7. confirm no answer-fit styling exists;
8. confirm PR #189/#196 changes, if merged meanwhile, are preserved rather than overwritten.

### Step 12.6 — Human/UI validation

After automated exact-head verification and only after approved product visuals are available:

- run `START_HUMAN_QA.cmd` on the user's actual Windows environment;
- inspect 1280×720 and 1920×1080 Korean density, clipping, focus, and first-action visibility;
- keyboard navigation and Esc stack;
- gamepad focus/accept/back;
- manual click placement/replace/clear;
- actual touch on phone/tablet landscape when Android/export scope is authorized;
- Lume visibility and non-answer behavior;
- map select→detail→explicit move from both entry paths;
- field→device→field context restoration.

Record each item as `PASS / FAIL / BLOCKED / NOT_RUN`. Do not infer Human PASS from capture scripts.

### Step 12.7 — Post-change adversarial review

Because Base remote now includes a newer post-change adversarial-monitor policy not yet adopted as project release identity, do **not** silently import Base implementation. Still perform the project's already-required adversarial review on the final diff:

- attempt to trigger pointer click-through;
- attempt to reveal candidate correctness through style/order;
- attempt to consume a keyword after reuse;
- attempt map vs field travel divergence;
- attempt tab switching to change domain state;
- attempt invalid slot/keyword IDs;
- attempt unsupported legacy contract mount;
- attempt unapproved Lume asset binding.

Record findings as `MUST_FIX / SHOULD_FIX / DEFER / REJECT / UNVERIFIED` and rerun regression after each accepted fix.

**Final implementation commit/evidence:**

```bash
git add tests/ui_visual_capture.gd docs/implementation/CASE01_INVESTIGATION_DEVICE_UI_IMPLEMENTATION_EVIDENCE.md
git commit -m "docs: record CASE-01 investigation device UI evidence"
```

---

## Rollback Strategy

The implementation is intentionally isolated behind a CASE-01 Canon v2 support check.

Rollback order:

1. disable shell mount in `investigation_scene.gd` and fall back to the current PR #180 investigation UI;
2. leave Canon v2/manual/save state untouched;
3. remove only new `case01_*` scene/script/test files if the feature is abandoned;
4. do not downgrade save version or rewrite episode data;
5. retain any already-approved asset in manifest/history even if no longer bound; asset deletion is a separate approved workflow.

The narrow `apply_afterlife_manual_draft` API can remain unused without affecting legacy flows; if rollback removes it, rerun migration/save regressions to prove no payload change.

## Completion Criteria

Runtime implementation may be called automated-complete only when all of the following are freshly evidenced on the exact candidate head:

- approved Gate A Decision is in GitHub + Sheet with the same Decision ID;
- CASE-01 shell mounts only on supported Canon v2 contract;
- `[기록] [괴이 매뉴얼] [지도]` are the only shell nav tabs;
- no independent player-facing log/AI log tab;
- records are text-only with no audio player/waveform;
- 5-section UI preserves 3-page 4/5/5 slot counts;
- manual placement/replacement/clear works via click/tap-equivalent and keyboard/gamepad focus path;
- candidate UI does not disclose correctness/fitness;
- map and field travel share one service and explicit confirmation;
- shell/tab state restoration works without save/time/progression side effects;
- PR #180 investigation hierarchy regressions remain green;
- save/migration regressions remain green;
- 1280×720, 1920×1080, 2340×1080 automated layout checks pass;
- full maintained project regression passes;
- exact-head GitHub checks pass.

Visual completion additionally requires Gate B product-asset approval and Human/UI review. Android/touch-device completion remains separate until actual device/export validation is run.

## Self-review Checklist for This Plan

- [x] Uses current live project main, not stale status text, as implementation baseline.
- [x] Records Base remote drift without auto-adoption.
- [x] Reuses merged PR #180 hierarchy rather than reimplementing it.
- [x] Avoids `game_state.gd`, episode JSON, and `project.godot` changes.
- [x] Keeps save version unchanged and reuses Canon v2 `filled_slots`.
- [x] Provides exact files, APIs, tests, commands, commits, rollback, and gates.
- [x] Identifies the three missing runtime projection decisions and supplies an exact proposed mapping instead of leaving TBDs.
- [x] Includes Visual Requirement Gate before product image binding.
- [x] Distinguishes automated validation from Human/Android validation.
- [x] Protects no-answer-leak, no-audio-player, shared-travel, same-composition, and Lume visibility contracts.
