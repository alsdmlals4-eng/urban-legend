# ANNUAL-MVP-002 Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 기존 ANNUAL-MVP-001 4주×7일 경로를 보존하면서 동료 3명·장비 3개·모듈 6개·연구 노드 8개와 일정 미리보기·반복 편성·지원 투명성·주간 인과 요약을 제공하는 ANNUAL-MVP-002 수직절편을 구현한다.

**Architecture:** 기존 데이터와 StateV2를 직접 확장하지 않고 `data/poc/annual_mvp_002`와 `scripts/poc/annual_mvp_002`에 확장 계약을 격리한다. `AnnualMvp002State`는 `AnnualMvp001StateV2`를 상속해 7일 주간·위험 0/15/30·기존 save version을 유지하며, 별도 planner·support resolver·incident adapter를 조합한다. 새 Scene은 기존 themed/seven-day Scene의 factory hook을 통해 확장 상태와 adapter를 주입하고, 확장 초기화 실패 시 ANNUAL-MVP-001 UI와 CORE 기본 동작을 유지한다.

**Tech Stack:** Godot 4.7.1 GDScript, JSON, Python 3.12 `unittest`, GitHub Actions.

## Global Constraints

- 권나래 고정.
- 1개월 = 4주 × 주당 7일 = 총 28일.
- 일정별 1~3일, 주차 경계 초과 금지, 남은 일수 자동 휴식 계약 유지.
- 출동 위험은 2주차 0 / 3주차 15 / 4주차 강제 30.
- CORE 핵심 단서·정답 가설·미관측 패턴·필수 포획 조건을 신규 데이터가 생성하거나 변경하지 않는다.
- save version은 `annual-mvp-001-save-v1`을 유지하고 `state.annual_mvp_002` 선택 필드만 추가한다.
- 기존 `mvp-039`, `mvp-038` 이관, 기존 ANNUAL ID, 보호 경로를 변경하지 않는다.
- 신규 수치는 `PROVISIONAL_BASELINE`이다.
- 사람 사용성 QA 전 `POC_PASSED`와 제작 확대를 선언하지 않는다.
- 사건 징후 시계, 관측·가설·반박 보드, 연구·괴이 매뉴얼 전체 탐색 UI는 이번 계획에서 제외한다.

---

## File Structure

### Create

- `data/poc/annual_mvp_002/companion_equipment_research.json` — ANNUAL-MVP-002 확장 데이터 정본.
- `scripts/poc/annual_mvp_002/annual_mvp_002_data.gd` — 확장 JSON 로드와 불변성 검증.
- `scripts/poc/annual_mvp_002/annual_mvp_002_planner.gd` — 일정 미리보기, undo, clear, last-week copy, template 3개.
- `scripts/poc/annual_mvp_002/annual_mvp_002_support_resolver.gd` — 고유 스킬 확정 발동과 공용 지원 확률·준비도 판정.
- `scripts/poc/annual_mvp_002/annual_mvp_002_state.gd` — 동료·장비·연구·planner template·save 선택 필드.
- `scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd` — 기존 CORE hook에 확장 효과를 제한적으로 적용.
- `scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd` — 확장 편성·연구·planner UI와 주간 인과 요약.
- `scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn` — 실행 Scene.
- `tests/test_annual_mvp_002_data_contract.py` — JSON·ID·금지 필드 정적 계약.
- `tests/annual_mvp_002_planner_test.gd` — planner focused 테스트.
- `tests/annual_mvp_002_support_resolver_test.gd` — 지원 판정 focused 테스트.
- `tests/annual_mvp_002_state_test.gd` — 편성·연구·save focused 테스트.
- `tests/annual_mvp_002_incident_adapter_test.gd` — adapter·fallback 테스트.
- `tests/annual_mvp_002_scene_test.gd` — UI 상태·문구·조작 테스트.
- `tests/annual_mvp_002_visual_capture.gd` — 720p·1080p 화면 캡처.
- `tests/annual_mvp_002_pointer_qa.gd` — 실제 그래픽 좌표 입력.
- `tests/run_annual_mvp_002_tests.sh` — focused 실행기.

### Modify

- `scripts/poc/annual_mvp_001/annual_mvp_001_themed_scene.gd` — `_create_runtime_state()`와 `_create_incident_adapter()` factory hook 추가.
- `scripts/ui/main_menu.gd` — ANNUAL-MVP-002 격리 진입 추가.
- `.github/workflows/validate-annual-mvp-001.yml` — ANNUAL-MVP-002 Python·focused 실행 등록.
- `.github/workflows/capture-annual-mvp-001-visuals.yml` — ANNUAL-MVP-002 capture·pointer QA 등록.
- `docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md` — 구현 상태와 벤치마크 P0 반영.
- `MVP_ROADMAP.md`, `docs/CURRENT_STATUS.md`, `docs/CURRENT_HANDOFF.md`, `TEST_CHECKLIST.md`, `docs/DECISION_LOG.md` — 상태·증거 동기화.

---

### Task 1: Expansion Data Contract

**Files:**
- Create: `data/poc/annual_mvp_002/companion_equipment_research.json`
- Create: `scripts/poc/annual_mvp_002/annual_mvp_002_data.gd`
- Create: `tests/test_annual_mvp_002_data_contract.py`

**Interfaces:**
- Produces: `AnnualMvp002Data.load_config(path: String) -> Dictionary`
- Produces: `AnnualMvp002Data.validate_config(data: Dictionary, base_config: Dictionary) -> Array[String]`
- Produces: `AnnualMvp002Data.index_by_id(entries: Array) -> Dictionary`

- [ ] **Step 1: Write failing Python contract tests**

Assert exact contract `annual-mvp-002-v1`, companion count 3, unique skill count 3, public support count 6, equipment count 3, module count 6, research node count 8, unique IDs, valid references, module family compatibility, acyclic prerequisites, non-negative costs, and absence of `clue_id`, `hypothesis_id`, `pattern_id`, `capture_condition`, `answer`, `auto_solution` effect keys.

- [ ] **Step 2: Run RED**

Run: `python -m unittest tests/test_annual_mvp_002_data_contract.py -v`
Expected: FAIL because the expansion JSON and validator do not exist.

- [ ] **Step 3: Create expansion JSON**

Use the first PoC subset from the approved design:

```json
{
  "contract_version": "annual-mvp-002-v1",
  "base_contract_version": "annual-mvp-001-v3",
  "companions": [
    {"id":"annual002_companion_ohyun","display_name":"오현","role_primary":"field_control","role_secondary":"observation","unique_skill_id":"annual002_unique_ohyun_field_anchor","public_skill_ids":["annual002_support_damage_buffer","annual002_support_risk_dampening"],"work_trust":20,"personal_bond":10,"availability":"AVAILABLE"},
    {"id":"annual002_companion_han_serin","display_name":"한세린","role_primary":"analysis","role_secondary":"counterexample","unique_skill_id":"annual002_unique_han_cross_index","public_skill_ids":["annual002_support_second_read","annual002_support_counterexample"],"work_trust":15,"personal_bond":5,"availability":"AVAILABLE"},
    {"id":"annual002_companion_park_doyun","display_name":"박도윤","role_primary":"containment","role_secondary":"protection","unique_skill_id":"annual002_unique_park_safe_perimeter","public_skill_ids":["annual002_support_damage_buffer","annual002_support_containment_window"],"work_trust":10,"personal_bond":5,"availability":"AVAILABLE"}
  ]
}
```

Complete the file with the six approved public skills, three equipment entries, six modules, four resource types, and eight research nodes from the design.

- [ ] **Step 4: Implement minimal validator**

Validate exact counts and references. Reject unknown effect keys rather than ignoring them.

- [ ] **Step 5: Run GREEN**

Run: `python -m unittest tests/test_annual_mvp_002_data_contract.py -v`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add data/poc/annual_mvp_002 scripts/poc/annual_mvp_002/annual_mvp_002_data.gd tests/test_annual_mvp_002_data_contract.py
git commit -m "feat: add ANNUAL-MVP-002 data contract"
```

---

### Task 2: Planner Preview and Repetition Tools

**Files:**
- Create: `scripts/poc/annual_mvp_002/annual_mvp_002_planner.gd`
- Create: `tests/annual_mvp_002_planner_test.gd`

**Interfaces:**
- Consumes: base activity entries containing `id`, `name`, `day_cost`, `deltas`.
- Produces: `configure(activities: Array[Dictionary], days_per_week: int = 7) -> Dictionary`
- Produces: `set_plan(activity_ids: Array[String]) -> Dictionary`
- Produces: `append_activity(activity_id: String) -> Dictionary`
- Produces: `undo() -> Dictionary`
- Produces: `clear() -> Dictionary`
- Produces: `copy_last_week(last_week_result: Dictionary) -> Dictionary`
- Produces: `save_template(slot: int) -> Dictionary`
- Produces: `apply_template(slot: int) -> Dictionary`
- Produces: `preview() -> Dictionary`
- Produces: `restore(snapshot: Dictionary) -> Dictionary`

- [ ] **Step 1: Write failing planner tests**

Cover:
- preview aggregates day cost, remaining days, fatigue, competency categories, institution, research, trust;
- a plan exceeding seven days is rejected without mutation;
- undo restores the exact previous plan;
- clear can be undone once;
- last-week copy uses `planned_activity_ids`, not localized `activity_ids`;
- exactly three template slots persist and invalid copied/template plans are rejected against current activity data.

- [ ] **Step 2: Run RED**

Run: `godot --headless --path . -s res://tests/annual_mvp_002_planner_test.gd`
Expected: parser/load failure because the planner does not exist.

- [ ] **Step 3: Implement minimal planner**

Use one-level undo history and a fixed `Array[Array[String]]` of three templates. `preview()` returns:

```gdscript
{
  "ok": true,
  "activity_ids": [],
  "used_days": 0,
  "remaining_days": 7,
  "aggregate": {
    "fatigue": 0,
    "competencies": {},
    "institution_support": 0,
    "research_progress": {},
    "companion_trust": {}
  },
  "lines": []
}
```

- [ ] **Step 4: Run GREEN**

Run the focused planner test and then `tests/run_annual_mvp_001_tests.sh`.
Expected: planner PASS and existing ANNUAL-MVP-001 PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/poc/annual_mvp_002/annual_mvp_002_planner.gd tests/annual_mvp_002_planner_test.gd
git commit -m "feat: add annual planner preview and templates"
```

---

### Task 3: Expanded State, Loadout, Research, and Save

**Files:**
- Create: `scripts/poc/annual_mvp_002/annual_mvp_002_state.gd`
- Create: `tests/annual_mvp_002_state_test.gd`

**Interfaces:**
- Extends: `AnnualMvp001StateV2`.
- Produces: `start(config: Dictionary, run_seed: int = 2001) -> Dictionary` loading the default expansion path.
- Produces: `configure_loadout_v2(companion_ids: Array[String], support_skill_by_companion: Dictionary, equipment_id: String, module_ids: Array[String]) -> Dictionary`.
- Produces: `save_schedule_template(slot: int, activity_ids: Array[String]) -> Dictionary`.
- Produces: `start_research(node_id: String) -> Dictionary`, `advance_research(node_id: String, amount: int = 1) -> Dictionary`, `cancel_research(node_id: String) -> Dictionary`.
- Extends snapshot with `annual_mvp_002` dictionary.

- [ ] **Step 1: Write failing state tests**

Cover:
- start creates three companion states and four zero-valued research resources;
- 0, 1, 2 companions are valid; third companion is rejected without mutation;
- duplicate primary role produces `role_overlap_efficiency = 70` warning data;
- equipment requires one exact family and no duplicate module;
- support skills must belong to the selected companion;
- at most two research projects can be active;
- starting reserves resources, completion consumes reservation, cancellation refunds floor(75%);
- incident results grant the approved resource table;
- old save without `annual_mvp_002` restores defaults;
- unknown IDs are preserved in `orphaned_ids` but excluded from effects;
- planner templates, last loadout, readiness and research state round-trip inside `annual-mvp-001-save-v1`.

- [ ] **Step 2: Run RED**

Run: `godot --headless --path . -s res://tests/annual_mvp_002_state_test.gd`
Expected: load failure because `AnnualMvp002State` does not exist.

- [ ] **Step 3: Implement minimal state**

Call `super.start(config, run_seed)` first. If expansion validation fails, set `annual_mvp_002.enabled = false`, preserve the base state, and return an `ok: true` response with a warning event `annual_mvp_002_disabled`.

Store the optional save block as:

```gdscript
"annual_mvp_002": {
  "enabled": true,
  "companion_states": {},
  "equipped_support_skills": {},
  "readiness_by_skill": {},
  "owned_equipment": [],
  "installed_modules": {},
  "research_resources": {},
  "research_projects": {},
  "completed_research": [],
  "last_loadout": {},
  "schedule_templates": [[], [], []],
  "orphaned_ids": []
}
```

- [ ] **Step 4: Run GREEN**

Run state test, existing save test, existing state test, then full ANNUAL focused suite.
Expected: all PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/poc/annual_mvp_002/annual_mvp_002_state.gd tests/annual_mvp_002_state_test.gd
git commit -m "feat: add ANNUAL-MVP-002 state and save extension"
```

---

### Task 4: Transparent Support Resolver

**Files:**
- Create: `scripts/poc/annual_mvp_002/annual_mvp_002_support_resolver.gd`
- Create: `tests/annual_mvp_002_support_resolver_test.gd`

**Interfaces:**
- Produces: `start(skill_entries: Array[Dictionary], companion_states: Dictionary, preparation_tags: Array[String], readiness_by_skill: Dictionary, run_seed: int, test_rolls: Array[int] = []) -> Dictionary`.
- Produces: `preview(context: Dictionary = {}) -> Array[Dictionary]`.
- Produces: `resolve(event_key: String, context: Dictionary) -> Array[Dictionary]`.
- Produces: `get_snapshot() -> Dictionary`.

- [ ] **Step 1: Write failing resolver tests**

Cover:
- unique skills trigger once with no random roll when their explicit condition is met;
- public chance = base + preparation 10 + trust bonus 0/5/10, capped at 90;
- readiness is displayed but does not increase ordinary chance;
- eligible failure gains 20, or 25 with `annual002_research_failure_learning`;
- readiness 100 guarantees the next eligible trigger and resets to 0;
- same seed and event key reproduce the same result;
- duplicate event keys are idempotent;
- preview exposes `eligible`, `ineligible_reason`, `chance`, `readiness`, `guaranteed_next`, `effect_category`, and `forbidden_outputs`.

- [ ] **Step 2: Run RED**

Run the focused resolver test.
Expected: load failure.

- [ ] **Step 3: Implement minimal resolver**

Trust bonus:

```gdscript
func _trust_bonus(work_trust: int) -> int:
    if work_trust >= 70: return 10
    if work_trust >= 40: return 5
    return 0
```

Every preview item must include:

```gdscript
"forbidden_outputs": ["new_core_clue", "answer_hypothesis", "unobserved_pattern", "capture_condition"]
```

- [ ] **Step 4: Run GREEN**

Run new resolver test and existing `annual_mvp_001_support_resolver_test.gd`.
Expected: both PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/poc/annual_mvp_002/annual_mvp_002_support_resolver.gd tests/annual_mvp_002_support_resolver_test.gd
git commit -m "feat: add transparent companion support resolver"
```

---

### Task 5: Incident Adapter and Safe Fallback

**Files:**
- Create: `scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd`
- Create: `tests/annual_mvp_002_incident_adapter_test.gd`

**Interfaces:**
- Extends: `AnnualMvp001IncidentAdapter`.
- Produces: `configure(config: Dictionary, annual_snapshot: Dictionary, run_seed: int) -> Dictionary`.
- Reuses CORE hooks: `after_omen`, `after_recovery_action`, `get_status_lines`, `get_support_log`, `build_case_override`.

- [ ] **Step 1: Write failing adapter tests**

Cover:
- two selected companions contribute both unique skills and selected public skills;
- equipment/module effects only modify allowed tolerance, damage, risk, capture-window, or research reward fields;
- duplicate primary roles scale the second same-category effect to 70%;
- status lines contain owner, eligibility, probability, readiness, guarantee distance, and ineligibility reason;
- missing expansion data sets `fallback_active = true` and delegates to the existing adapter or CORE default without changing the base case;
- no generated override contains forbidden clue/hypothesis/pattern/capture-condition fields.

- [ ] **Step 2: Run RED**

Run focused adapter test.
Expected: load failure.

- [ ] **Step 3: Implement minimal adapter**

Compose `AnnualMvp002SupportResolver`; do not edit CORE scripts. Return configuration metadata:

```gdscript
{"ok": true, "fallback_active": false, "warning": ""}
```

On expansion failure return:

```gdscript
{"ok": true, "fallback_active": true, "warning": "ANNUAL-MVP-002 지원을 비활성화하고 기본 사건 동작을 사용합니다."}
```

- [ ] **Step 4: Run GREEN**

Run new adapter test, existing adapter test, CORE focused tests.
Expected: all PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd tests/annual_mvp_002_incident_adapter_test.gd
git commit -m "feat: connect ANNUAL-MVP-002 support to CORE hooks"
```

---

### Task 6: Scene, Loadout UI, Preview, and Causal Summary

**Files:**
- Modify: `scripts/poc/annual_mvp_001/annual_mvp_001_themed_scene.gd`
- Create: `scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd`
- Create: `scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn`
- Create: `tests/annual_mvp_002_scene_test.gd`
- Modify: `scripts/ui/main_menu.gd`

**Interfaces:**
- Base hook: `_create_runtime_state() -> Object` defaults to `AnnualMvp001StateV2.new()`.
- Base hook: `_create_incident_adapter() -> Object` defaults to `AnnualMvp001IncidentAdapter.new()`.
- ANNUAL-MVP-002 overrides both hooks.

- [ ] **Step 1: Write failing Scene tests**

Cover named controls and behavior:
- `ActivityPreviewLabel` shows used/remaining days and aggregate effects before commit;
- `CopyLastWeekButton`, `UndoPlanButton`, `ClearPlanButton`, template save/apply buttons modify the plan and preserve seven-day validation;
- `CompanionCard_*` allows maximum two selections and explains rejection of a third;
- `SupportStatusLabel` contains eligible/ineligible, chance, readiness, guarantee distance, and forbidden-output explanation;
- equipment and module controls reject family mismatch;
- `WeekCausalSummaryLabel` explains each changed value with the source activity and distinguishes direct/automatic rest;
- expansion initialization failure leaves the Scene usable with a fallback message.

- [ ] **Step 2: Run RED**

Run Scene test.
Expected: missing Scene or node names.

- [ ] **Step 3: Add factory hooks without behavior change**

In the existing themed Scene:

```gdscript
func _create_runtime_state() -> Object:
    return FourWeekState.new()

func _create_incident_adapter() -> Object:
    return Adapter.new()
```

Use these in `_ready()` before `super()`; existing tests must remain unchanged.

- [ ] **Step 4: Implement ANNUAL-MVP-002 Scene**

Override planning and preparation builders. Use the planner for UI-only plan editing, then pass its activity IDs to inherited commit methods. Keep the base auto-rest two-step confirmation.

The weekly causal summary format is:

```text
무엇이 변했는가
- 피로 +12 — 관측 훈련 2일
- 관찰 +1 — 관측 훈련 2일
왜 중요한가
- 관찰 역량은 관측 허용 오차와 기록 확인 기회를 개선한다.
다음 주 영향
- 자동 휴식 1일은 피로 5만 회복하고 관계·특수 회복·추가 보상을 만들지 않았다.
```

- [ ] **Step 5: Run GREEN**

Run Scene test, existing Scene/input/pointer tests, and Godot import.
Expected: all PASS.

- [ ] **Step 6: Commit**

```bash
git add scripts/poc/annual_mvp_001/annual_mvp_001_themed_scene.gd scripts/poc/annual_mvp_002 scenes/poc/annual_mvp_002 tests/annual_mvp_002_scene_test.gd scripts/ui/main_menu.gd
git commit -m "feat: add ANNUAL-MVP-002 planning and loadout UI"
```

---

### Task 7: Focused Runner, Visual Capture, and Pointer QA

**Files:**
- Create: `tests/run_annual_mvp_002_tests.sh`
- Create: `tests/annual_mvp_002_visual_capture.gd`
- Create: `tests/annual_mvp_002_pointer_qa.gd`
- Modify: `.github/workflows/validate-annual-mvp-001.yml`
- Modify: `.github/workflows/capture-annual-mvp-001-visuals.yml`

**Interfaces:**
- Runner executes data, planner, state, resolver, adapter, and Scene tests.
- Visual artifact names include `annual-mvp-002-720p`, `annual-mvp-002-1080p`, and `annual-mvp-002-pointer`.

- [ ] **Step 1: Write failing QA scripts**

Pointer path:
1. enter ANNUAL-MVP-002;
2. select a valid seven-day plan;
3. undo and re-add one activity;
4. save and apply template 1;
5. advance to W2;
6. select deploy;
7. select two companion cards;
8. select one equipment and compatible module;
9. verify support status text;
10. start incident.

- [ ] **Step 2: Run RED**

Run the new focused runner and visual scripts.
Expected: failure before implementation registration.

- [ ] **Step 3: Register workflows**

Keep workflow permissions `contents: read`. Add the new focused runner after existing ANNUAL focused tests and before full regression. Capture both resolutions and preserve failure evidence.

- [ ] **Step 4: Run GREEN**

Run Python contracts, Godot import, CORE focused, ANNUAL-MVP-001 focused, ANNUAL-MVP-002 focused, full regression, visual capture, keyboard and pointer QA.
Expected: all PASS.

- [ ] **Step 5: Commit**

```bash
git add tests/run_annual_mvp_002_tests.sh tests/annual_mvp_002_visual_capture.gd tests/annual_mvp_002_pointer_qa.gd .github/workflows
git commit -m "test: validate ANNUAL-MVP-002 vertical slice"
```

---

### Task 8: Canonical Documentation and Merge Evidence

**Files:**
- Modify: `docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md`
- Modify: `MVP_ROADMAP.md`
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Modify: `TEST_CHECKLIST.md`
- Modify: `docs/DECISION_LOG.md`
- Create: `docs/qa/ANNUAL_MVP_002_AUTOMATED_QA_2026-07-26.md`

**Interfaces:**
- Status vocabulary before merge: `ON_BRANCH / CI_PENDING`.
- Status vocabulary after merge: `MERGED / AUTOMATED_QA_PASSED`.

- [ ] **Step 1: Update branch-state documents**

Record Issue #88, exact scope, excluded follow-ups, data contract, save compatibility, and CI run IDs. Keep:

```text
human_usability_qa: NOT_RUN
new_player_validation: NOT_RUN
POC_PASSED: NOT_DECLARED
production_expansion: NOT_APPROVED
ANNUAL-MVP-003: NOT_APPROVED
```

- [ ] **Step 2: Run document contracts**

Run all documentation unit tests and placeholder scan.
Expected: PASS and no active `TODO`/`TBD`.

- [ ] **Step 3: Review changed files and protected paths**

Confirm no CORE case data, `mvp-039`, `mvp-038`, production save, or unrelated archive files changed.

- [ ] **Step 4: Open PR and record final evidence**

PR body must include changed files, document run, ANNUAL run, visual run, review thread count, and explicit human-validation boundary.

- [ ] **Step 5: Squash merge and final status sync**

After all checks pass and review threads are zero, squash merge. Update Issue #88 and active status documents with the merge commit and verification runs.

---

## Self-Review

- Spec coverage: 동료 3명·최대 2명, 지원 6개, 장비 3개, 모듈 6개, 연구 8개, save 선택 필드, fallback, planner P0, 지원 투명성, 주간 인과 요약이 각각 Task 1~7에 배치됐다.
- Excluded scope: 사건 징후 시계, 가설 보드, 전체 매뉴얼 탐색, ANNUAL-MVP-003은 구현 작업에 포함되지 않는다.
- Placeholder scan: 실행 단계에 `TODO`·`TBD`·미정 구현 지시가 없다.
- Type consistency: State·resolver·adapter·Scene 함수명이 각 Task의 Consumes/Produces에서 동일하다.
- Regression safety: 기존 Data/StateV2/SupportResolver/Adapter/Scene 계약은 삭제하거나 대체하지 않고 새 확장 경로가 실패하면 fallback한다.
