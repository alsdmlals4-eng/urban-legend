# Protection Obligation Follow-up, Re-entry, Reward, and Evaluation Linkage Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 보호 의무 종결 상태를 중복 없는 후속 기록, 별도 재진입 자격, 다축 평가, 캠페인 중립 보상으로 연결한다.

**Architecture:** `scripts/core/protection_follow_up_policy.gd`가 보호 의무에서 append-only 후속 기록을 생성·활성화·종결한다. `scripts/core/protection_obligation_policy.gd`와 `scripts/core/recovery_outcome_policy.gd`의 기존 축은 수정하지 않고 참조하며, `scripts/core/game_state.gd`가 원래 사건 결과와 후속 현재 상태를 분리 저장한다. `scripts/scenes/result_scene.gd`는 incident-end와 current follow-up, 다축 평가, 재진입·대체 경로를 표시한다.

**Tech Stack:** Godot 4.7.1, GDScript, Python 3.12 planning contracts, GUT/프로젝트 기존 테스트 러너, GitHub Actions

## Global Constraints

- Decision ID: `DEC-20260806-123-CANON-V2-PROTECTION-OBLIGATION-FOLLOW-UP-REENTRY-REWARD-AND-EVALUATION-LINKAGE`
- `completed`, `transferred`, `deferred_with_owner`, `breached`, `unresolved`는 상태별 후속 의미가 다르다.
- 후속 기록은 append-only이며 원래 구출 결과·회수 결과·보호 의무 이력을 덮어쓰지 않는다.
- 하나의 `dedupe_key`에는 하나의 활성 루트 후속 기록만 허용한다.
- 재진입은 자동 생성하지 않으며 보호 의무 상태와 별도 평가한다.
- 후속은 사건별 저작된 단계 상한을 가진다.
- 현상 통제·보호 책임·증거 무결성·후속 실행·숙련 평가는 분리한다.
- 보상은 캠페인 필수 전력과 분리하며 피해·위반 파밍을 금지한다.
- 정확한 랭크 임계값과 수치·보상 목록은 미승인이다.
- 접근성 대체 입력과 시간 완화에는 평가·보상·재진입 자격 불이익이 없다.
- save migration은 원자적·rollback-safe·idempotent해야 한다.
- 현재 실행 상태: `IMPLEMENTATION_NOT_AUTHORIZED`.

---

## File Structure

### Create

- `scripts/core/protection_follow_up_policy.gd` — 후속 기록 생성·dedupe·trigger·단계 상한·종결·재진입 자격
- `tests/test_protection_follow_up_policy.gd` — 상태별 생성, 중복 방지, 단계 상한, 재진입 분리 테스트
- `tests/test_protection_follow_up_save_migration.gd` — save migration과 legacy provenance 테스트
- `tests/test_protection_follow_up_result_reporting.gd` — 다축 결과와 원래 사건 결과 보존 테스트

### Modify

- `scripts/core/protection_obligation_policy.gd` — 후속 정책이 읽을 안정된 의무 상태 조회 인터페이스 제공
- `scripts/core/recovery_outcome_policy.gd` — 현상 통제 축을 read-only 결과로 노출
- `scripts/core/game_state.gd` — 후속 기록·후속 이력·평가·보상 claim 저장
- `scripts/scenes/result_scene.gd` — incident-end/current 비교와 다축 결과 표시
- 사건별 저작 데이터 파일 — 구현 승인 뒤 `step_limit`, trigger, owner, mastery constraint 추가

## Interfaces

```gdscript
# scripts/core/protection_follow_up_policy.gd
static func build_follow_up_records(
    case_id: String,
    campaign_canon_id: String,
    obligations: Array[Dictionary],
    incident_end_packet: Dictionary,
    authoring_rules: Dictionary
) -> Dictionary

static func evaluate_reentry(
    follow_up_record: Dictionary,
    current_context: Dictionary
) -> Dictionary

static func advance_follow_up(
    follow_up_record: Dictionary,
    action_result: Dictionary
) -> Dictionary

static func build_evaluation_packet(
    incident_end_packet: Dictionary,
    follow_up_records: Array[Dictionary],
    mastery_rules: Dictionary
) -> Dictionary
```

반환 패킷은 `ok`, `errors`, `records`, `history_events`, `reward_claims`를 명시한다. 오류 시 원본 상태를 변경하지 않는다.

---

### Task 1: Follow-up Record Creation and Status Mapping

**Files:**
- Create: `scripts/core/protection_follow_up_policy.gd`
- Create: `tests/test_protection_follow_up_policy.gd`
- Modify: `scripts/core/protection_obligation_policy.gd`

**Interfaces:**
- Consumes: Decision 122 의무 상태 패킷과 `source_reason`
- Produces: `build_follow_up_records(...) -> Dictionary`

- [ ] **Step 1: Write the failing test**

상태별 기대를 테스트한다.

```gdscript
func test_completed_does_not_create_rework_without_authored_monitoring() -> void:
    var result := ProtectionFollowUpPolicy.build_follow_up_records(
        "case_afterlife_station",
        "campaign_a",
        [{"obligation_id": "protect_victim", "status": "completed", "source_reason": "victim_safe"}],
        _incident_packet(),
        {}
    )
    assert_true(result.ok)
    assert_eq(result.records.size(), 0)

func test_breached_creates_mitigation_record_without_rewriting_breach() -> void:
    var result := ProtectionFollowUpPolicy.build_follow_up_records(
        "case_afterlife_station",
        "campaign_a",
        [{"obligation_id": "contain_exposure", "status": "breached", "source_reason": "public_exposure"}],
        _incident_packet_with_breach(),
        _rules_with_mitigation()
    )
    assert_eq(result.records[0].source_status, "breached")
    assert_eq(result.records[0].resolution_state, "open")
    assert_eq(result.records[0].case_canon_reference, "incident:end:afterlife_station")
```

- [ ] **Step 2: Run test to verify it fails**

Run: existing Godot focused test command for `tests/test_protection_follow_up_policy.gd`

Expected: FAIL because `ProtectionFollowUpPolicy` is missing.

- [ ] **Step 3: Write minimal implementation**

구현한다.

- completed는 저작된 monitoring rule 없으면 기록을 만들지 않는다.
- transferred는 owner acceptance를 검증한다.
- deferred_with_owner는 trigger 전 비활성 기록만 만든다.
- breached는 mitigation 목적을 만든다.
- unresolved는 actionable reason이 있을 때만 활성 후보를 만든다.
- 상태가 다르면 자동으로 같은 후속 임무를 생성하지 않는다.

- [ ] **Step 4: Run test to verify it passes**

Expected: 상태별 테스트 모두 PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/protection_follow_up_policy.gd scripts/core/protection_obligation_policy.gd tests/test_protection_follow_up_policy.gd
git commit -m "feat: add protection follow-up status mapping"
```

---

### Task 2: Dedupe, Trigger, Bounded Steps, and Resolution

**Files:**
- Modify: `scripts/core/protection_follow_up_policy.gd`
- Modify: `tests/test_protection_follow_up_policy.gd`

**Interfaces:**
- Consumes: follow-up record, authoring `step_limit`, trigger state
- Produces: stable `dedupe_key`, `advance_follow_up(...)`

- [ ] **Step 1: Write the failing test**

```gdscript
func test_same_dedupe_key_creates_one_active_root() -> void:
    var result := _build_twice_same_reason()
    assert_eq(result.records.filter(func(r): return r.active).size(), 1)

func test_step_limit_closes_without_infinite_reentry() -> void:
    var record := _record({"step_index": 1, "step_limit": 1})
    var result := ProtectionFollowUpPolicy.advance_follow_up(record, {"outcome": "failed"})
    assert_true(result.ok)
    assert_true(result.record.resolution_state in ["accepted_residual_risk", "failed_with_record", "transferred", "closed_no_action"])
    assert_false(result.record.active)
```

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because dedupe and step limit are not implemented.

- [ ] **Step 3: Write minimal implementation**

- `case_id + source_obligation_id + normalized_source_reason + campaign_canon_id`로 dedupe key 생성
- 같은 키의 활성 루트 중복 금지
- trigger 미성립 deferred는 비활성
- `step_index >= step_limit`에서 새 현장 단계 금지
- `escalated_once` 이후 추가 escalation 금지

- [ ] **Step 4: Run test to verify it passes**

Expected: 중복·상한·종결 테스트 PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/protection_follow_up_policy.gd tests/test_protection_follow_up_policy.gd
git commit -m "feat: bound and deduplicate protection follow-ups"
```

---

### Task 3: Separate Re-entry Eligibility

**Files:**
- Modify: `scripts/core/protection_follow_up_policy.gd`
- Modify: `tests/test_protection_follow_up_policy.gd`

**Interfaces:**
- Consumes: actionable_reason, hazard_state, route_state, authority_state, capability_state
- Produces: `evaluate_reentry(...) -> Dictionary`

- [ ] **Step 1: Write the failing test**

```gdscript
func test_unresolved_does_not_automatically_allow_reentry() -> void:
    var result := ProtectionFollowUpPolicy.evaluate_reentry(
        _record({"source_status": "unresolved"}),
        {"actionable_reason": false, "hazard_state": "unknown", "route_state": "closed", "authority_state": "none", "capability_state": "insufficient"}
    )
    assert_eq(result.status, "not_actionable")
    assert_true(result.alternative_follow_up.size() > 0)
```

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because re-entry evaluator is missing.

- [ ] **Step 3: Write minimal implementation**

지원 결과:

- eligible
- eligible_with_conditions
- not_eligible_use_alternative
- not_actionable
- unsafe_hold

보호 의무 상태 단독으로 eligible을 반환하지 않는다.

- [ ] **Step 4: Run test to verify it passes**

Expected: 재진입 분리와 대체 경로 테스트 PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/protection_follow_up_policy.gd tests/test_protection_follow_up_policy.gd
git commit -m "feat: evaluate reentry separately from obligation status"
```

---

### Task 4: Atomic Save Migration and Idempotency

**Files:**
- Modify: `scripts/core/game_state.gd`
- Create: `tests/test_protection_follow_up_save_migration.gd`

**Interfaces:**
- Consumes: policy records/history/evaluation/reward claims
- Produces: save keys `protection_follow_up_records`, `protection_follow_up_history`, `protection_evaluation_packet`, `follow_up_reward_claims`

- [ ] **Step 1: Write the failing test**

```gdscript
func test_save_resume_does_not_duplicate_follow_up_or_reward_claim() -> void:
    var state := _state_with_follow_up()
    var saved := state.to_save_dict()
    var loaded := GameState.from_save_dict(saved)
    loaded.reconcile_follow_ups()
    assert_eq(loaded.protection_follow_up_records.size(), 1)
    assert_eq(loaded.follow_up_reward_claims.size(), 1)

func test_legacy_bool_does_not_invent_breach_or_completion() -> void:
    var loaded := GameState.from_save_dict({"core_recovered": true})
    assert_eq(loaded.protection_follow_up_records.size(), 0)
    assert_eq(loaded.follow_up_legacy_provenance.status, "legacy_unknown_follow_up")
```

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because new save keys and migration are missing.

- [ ] **Step 3: Write minimal implementation**

- atomic save migration
- rollback on partial validation failure
- idempotent reconciliation
- same dedupe key and reward claim duplicate prevention
- legacy provenance preservation
- past bool values do not infer breach/completed/owner/trigger

- [ ] **Step 4: Run test to verify it passes**

Expected: save migration tests PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/game_state.gd tests/test_protection_follow_up_save_migration.gd
git commit -m "feat: persist protection follow-ups atomically"
```

---

### Task 5: Independent Evaluation Axes and Mastery Constraints

**Files:**
- Modify: `scripts/core/protection_follow_up_policy.gd`
- Modify: `scripts/core/recovery_outcome_policy.gd`
- Create: `tests/test_protection_follow_up_result_reporting.gd`

**Interfaces:**
- Consumes: immutable incident packet, current follow-up records, pre-authored mastery rules
- Produces: `build_evaluation_packet(...)`

- [ ] **Step 1: Write the failing test**

```gdscript
func test_follow_up_mitigation_does_not_erase_original_breach() -> void:
    var packet := ProtectionFollowUpPolicy.build_evaluation_packet(
        _incident_packet_with_breach(),
        [_mitigated_follow_up()],
        {}
    )
    assert_eq(packet.protection_responsibility_axis.incident_end, "breached")
    assert_eq(packet.follow_up_execution_axis.current, "mitigated")
    assert_eq(packet.control_axis.status, "containment_complete")

func test_only_pre_authored_avoidable_severe_breach_can_apply_mastery_ceiling() -> void:
    var packet := _build_packet_with_authored_constraint()
    assert_true(packet.mastery_axis.ceiling_applied)
    assert_eq(packet.mastery_axis.reason, "avoidable_severe_breach")
```

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because independent evaluation packet is missing.

- [ ] **Step 3: Write minimal implementation**

분리 축:

- control_axis
- protection_responsibility_axis
- evidence_integrity_axis
- follow_up_execution_axis
- mastery_axis

모든 미완료 의무가 자동으로 S 랭크를 차단하지 않는다. 정확한 랭크 임계값은 구현하지 않는다.

- [ ] **Step 4: Run test to verify it passes**

Expected: 다축·원본 보존·숙련 제약 테스트 PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/protection_follow_up_policy.gd scripts/core/recovery_outcome_policy.gd tests/test_protection_follow_up_result_reporting.gd
git commit -m "feat: report follow-up and mastery axes independently"
```

---

### Task 6: Result Scene and Accessible Follow-up Presentation

**Files:**
- Modify: `scripts/scenes/result_scene.gd`
- Modify: result scene resource only after explicit implementation authorization
- Modify: `tests/test_protection_follow_up_result_reporting.gd`

**Interfaces:**
- Consumes: evaluation packet and follow-up records
- Produces: accessible incident-end/current comparison, re-entry and alternative path preview

- [ ] **Step 1: Write the failing test**

테스트한다.

- incident-end와 current 상태를 구분 표시
- owner·trigger·actionable reason 표시
- 재진입 차단 이유와 대체 후속 경로 표시
- 색·음향 단독이 아닌 텍스트·포커스·스크린리더 정보
- 접근성 대체 입력과 시간 완화가 평가·보상·재진입 자격을 변경하지 않음

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because result scene presentation is missing.

- [ ] **Step 3: Write minimal implementation**

결과 화면은 단일 성공/실패 배너 대신 축별 요약과 근거 펼치기를 사용한다. 원래 breach와 현재 mitigated를 동시에 표시한다.

- [ ] **Step 4: Run test to verify it passes**

Expected: UI contract test PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/scenes/result_scene.gd tests/test_protection_follow_up_result_reporting.gd
git commit -m "feat: present protection follow-up outcomes accessibly"
```

---

### Task 7: Campaign-neutral Reward Claims

**Files:**
- Modify: `scripts/core/protection_follow_up_policy.gd`
- Modify: `scripts/core/game_state.gd`
- Modify: `tests/test_protection_follow_up_policy.gd`
- Modify: `tests/test_protection_follow_up_save_migration.gd`

**Interfaces:**
- Consumes: incident canon namespace, follow-up resolution, authored reward rule
- Produces: one-time campaign-neutral reward claim

- [ ] **Step 1: Write the failing test**

```gdscript
func test_breach_and_mitigation_cannot_be_farmed_for_repeat_rewards() -> void:
    var first := _claim_follow_up_reward()
    var second := _claim_same_follow_up_reward()
    assert_true(first.granted)
    assert_false(second.granted)
    assert_eq(second.reason, "already_claimed")

func test_reward_does_not_include_campaign_power() -> void:
    var reward := _authored_reward()
    assert_false(reward.has("permanent_stat"))
    assert_false(reward.has("mandatory_skill"))
    assert_false(reward.has("best_campaign_equipment"))
```

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL because reward claims are missing.

- [ ] **Step 3: Write minimal implementation**

허용 보상만 반환한다.

- 사건 기록
- 표창
- 비필수 부록
- 코스메틱
- 전시품
- 문서 테마
- 기록 재현 전용 도전

기본 진행 보상을 박탈하지 않는다.

- [ ] **Step 4: Run test to verify it passes**

Expected: 보상 중립성과 중복 방지 테스트 PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/protection_follow_up_policy.gd scripts/core/game_state.gd tests/test_protection_follow_up_policy.gd tests/test_protection_follow_up_save_migration.gd
git commit -m "feat: add campaign-neutral follow-up rewards"
```

---

### Task 8: Full Verification and Human QA Handoff

**Files:**
- Modify only verification records after implementation authorization

- [ ] **Step 1: Run planning contracts**

Run the Decision 123 Python contract and full documentation workflow.

- [ ] **Step 2: Run focused Godot tests**

Run all protection follow-up policy, migration, evaluation, and UI tests.

- [ ] **Step 3: Run Canon v2 migration suite**

Expected: existing rescue/recovery contracts remain green.

- [ ] **Step 4: Run full Godot regression**

Expected: zero failures.

- [ ] **Step 5: Prepare Human QA matrix**

Include:

- each obligation status
- trigger before/after
- re-entry eligible/ineligible
- step limit
- breach mitigation without erasure
- reward dedupe
- campaign vs replay namespace
- keyboard/gamepad/screen-reader/time-relief equivalence

- [ ] **Step 6: Preserve closed gates**

Until separate approval and actual execution:

- `IMPLEMENTATION_NOT_AUTHORIZED`
- `HUMAN_QA_NOT_RUN`
- `UI_ACCESSIBILITY_NOT_RUN`
- `MERGE_NOT_AUTHORIZED`

## Plan Self-review

- Spec coverage: status mapping, append-only history, dedupe, bounded steps, re-entry, evaluation, mastery, reward, save migration, accessibility all mapped to tasks.
- Placeholder scan: no TODO or TBD placeholders.
- Type consistency: all tasks use the four declared policy functions and the same save keys.
- Scope: one subsystem, protection obligation post-incident linkage; exact numbers and event authoring remain outside scope.

## Execution Gate

이 계획은 구현 가능한 TDD 순서를 제공하지만 실행 권한을 부여하지 않는다. 실제 GDScript·Scene·Episode JSON·save schema 변경은 별도 사용자 승인 뒤에만 시작한다.
