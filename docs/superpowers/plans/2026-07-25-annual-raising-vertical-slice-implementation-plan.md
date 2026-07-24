# ANNUAL-MVP-001 연도제 육성 수직절편 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 3주의 주간 육성·출동 준비가 기존 CORE-MVP-001 사건의 정보·위험·피해 관리에 영향을 주고, 사건 결과가 연구·공용 보조 스킬·분기 결산으로 되돌아오는 독립 수직절편을 구현한다.

**Architecture:** `ANNUAL-MVP-001`은 기존 본편 `GameState`와 저장을 사용하지 않는 격리 PoC다. 신규 `AnnualMvp001State`가 일정·성장·마감·연구·결산을 소유하고, `AnnualMvp001IncidentAdapter`가 상태 snapshot을 기존 CORE-MVP-001 데이터 override와 사건 결과 보상으로 변환한다. 기존 `CoreMvp001State`와 `CoreMvp001Scene`에는 외부 지원 효과와 세션 완료 신호를 위한 하위 호환 확장점만 추가한다.

**Tech Stack:** Godot 4.7.1, GDScript, JSON, Python 3.12 `unittest`, Bash focused runner, GitHub Actions

## Global Constraints

- 기준 설계는 `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`다.
- 이 계획은 `docs/superpowers/plans/2026-07-25-annual-design-canonical-migration-plan.md` 실행 완료 뒤 시작한다.
- 공식 기관명은 `괴이 기록국`, 직접 육성 주인공은 권나래다.
- 플레이어는 회수 전투에서 권나래만 직접 명령한다.
- 동료는 고유 스킬과 장착한 공용 보조 스킬을 조건부 자동 발동한다.
- 스킬 발동 조건·현재 확률·지원 준비도를 UI에 공개한다.
- 동료 지원은 숨은 정답을 표시하거나 잘못된 판단을 정답으로 교정하지 않는다.
- 성장 수치는 핵심 단서·가설 정합성·정답을 변경하지 않는다.
- 기존 CORE-MVP-001의 `관측 → 가설 → 현장 검증 → 전조 → 대응 → 포획 → 매뉴얼` 인과를 유지한다.
- 기존 `scripts/core/game_state.gd`, `data/episodes/**`, 기존 조사·회수 장면, `project.godot`, `knowledge/base-pack/**`를 변경하지 않는다.
- 기존 저장 `mvp-039`와 `mvp-038` 이관을 읽거나 쓰지 않는다.
- PoC 전용 저장은 `user://annual_mvp_001_poc.json`만 사용한다.
- 사건 진행 중 저장은 제공하지 않는다. 주간 계획 전, 주간 결과 뒤, 사건 결과 뒤에만 저장한다.
- 기존 CORE-MVP-001 기본 실행은 변경 전과 동일하게 동작해야 한다.
- 기존 CORE-MVP-001 집중 테스트 4/4와 전체 Godot 회귀 43/43을 보호한다.
- 정확한 3주·주당 3슬롯·수치 범위는 이 PoC만의 검증 수치이며 최종 캠페인 밸런스가 아니다.

---

## Scope

### 포함

```text
3주 × 주당 3개 일정 슬롯
권나래 기초 역량 4종
피로 1개
오현 동료 1명
업무 신뢰 0~3
고유 보조 스킬 1개
기관 공용 보조 스킬 1개
연구 공용 보조 스킬 1개
기본 장비 1개 + 모듈 슬롯 1개
출동 가능 주차·지연 위험·강제 출동
CORE-MVP-001 사건 데이터 override
사건 완료 결과 반환
잔향 자료·기관 지원·연구 해금
분기 결산 모형
전용 저장·복원
F1 개발 패널 진입
```

### 제외

```text
본편 1년 4분기 전체
동료 2명 동시 편성
로맨스
중형·소형 사건
새 조작형 미니게임 제작
기존 본편 save migration
기존 GameState 통합
경제·개인 돈·상점
동료 상세 스탯·개인 일정
턴 중 장비 교체
최종 엔딩
```

---

## File Map

### Create

```text
data/poc/annual_mvp_001/spring_vertical_slice.json
scripts/poc/annual_mvp_001/annual_mvp_001_data.gd
scripts/poc/annual_mvp_001/annual_mvp_001_state.gd
scripts/poc/annual_mvp_001/annual_mvp_001_support_resolver.gd
scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd
scripts/poc/annual_mvp_001/annual_mvp_001_save_data.gd
scripts/poc/annual_mvp_001/annual_mvp_001_scene.gd
scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn
tests/test_annual_mvp_001_data_contract.py
tests/annual_mvp_001_data_test.gd
tests/annual_mvp_001_state_test.gd
tests/annual_mvp_001_support_resolver_test.gd
tests/annual_mvp_001_incident_adapter_test.gd
tests/annual_mvp_001_save_data_test.gd
tests/annual_mvp_001_scene_test.gd
tests/run_annual_mvp_001_tests.sh
.github/workflows/validate-annual-mvp-001.yml
```

### Modify

```text
scripts/poc/core_mvp_001/core_mvp_001_state.gd
scripts/poc/core_mvp_001/core_mvp_001_scene.gd
tests/core_mvp_001_state_test.gd
tests/core_mvp_001_scene_test.gd
scripts/ui/main_menu.gd
tests/run_godot_regression.sh
tests/test_active_document_references.py
TEST_CHECKLIST.md
docs/CURRENT_STATUS.md
docs/CURRENT_HANDOFF.md
MVP_ROADMAP.md
```

### Protected

```text
scripts/core/game_state.gd
data/episodes/**
scripts/scenes/investigation_scene.gd
scripts/scenes/battle_scene.gd
project.godot
knowledge/base-pack/**
```

---

## Public State Contract

`AnnualMvp001State`는 다음 공개 phase만 사용한다.

```text
BOOT
WEEK_PLANNING
WEEK_RESULT
DEPLOYMENT_DECISION
PREPARATION
INCIDENT_ACTIVE
INCIDENT_RESULT
POST_INCIDENT_RESEARCH
QUARTER_SUMMARY
COMPLETE
```

모든 공개 명령은 다음 응답을 반환한다.

```gdscript
{
    "ok": true,
    "error": "",
    "state_changed": true,
    "events": [],
    "snapshot": {}
}
```

공개 인터페이스는 다음으로 고정한다.

```gdscript
class_name AnnualMvp001State
extends RefCounted

func start(config: Dictionary, run_seed: int = 2001) -> Dictionary
func get_snapshot() -> Dictionary
func commit_week(activity_ids: Array[String]) -> Dictionary
func acknowledge_week_result() -> Dictionary
func choose_deployment_decision(decision_id: String) -> Dictionary
func configure_loadout(companion_id: String, public_skill_id: String, module_ids: Array[String]) -> Dictionary
func begin_incident() -> Dictionary
func apply_incident_result(result: Dictionary, manual_delta: Dictionary, support_log: Array[Dictionary]) -> Dictionary
func complete_post_incident_research(project_id: String) -> Dictionary
func confirm_quarter_summary() -> Dictionary
func build_save_payload() -> Dictionary
func restore(config: Dictionary, payload: Dictionary) -> Dictionary
```

---

### Task 1: PoC 데이터 계약

**Files:**
- Create: `data/poc/annual_mvp_001/spring_vertical_slice.json`
- Create: `tests/test_annual_mvp_001_data_contract.py`

**Interfaces:**
- Consumes: 승인 설계의 일정·성장·연구·동료·장비 구조
- Produces: 모든 신규 런타임이 공유하는 고정 JSON 계약

- [ ] **Step 1: 파일 부재 Red 테스트를 작성한다**

```python
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = ROOT / "data/poc/annual_mvp_001/spring_vertical_slice.json"


class AnnualMvp001DataContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.data = json.loads(DATA_PATH.read_text(encoding="utf-8"))

    def test_contract_version_and_campaign_shape(self) -> None:
        self.assertEqual("annual-mvp-001-v1", self.data["contract_version"])
        campaign = self.data["campaign"]
        self.assertEqual(3, campaign["max_weeks"])
        self.assertEqual(3, campaign["slots_per_week"])
        self.assertEqual(2, campaign["voluntary_entry_week"])
        self.assertEqual(3, campaign["deadline_week"])
```

- [ ] **Step 2: 정확한 수량·ID 계약 테스트를 추가한다**

```python
def test_fixed_counts(self) -> None:
    self.assertEqual(7, len(self.data["activities"]))
    self.assertEqual(1, len(self.data["companions"]))
    self.assertEqual(3, len(self.data["support_skills"]))
    self.assertEqual(1, len(self.data["base_equipment"]))
    self.assertEqual(1, len(self.data["modules"]))
    self.assertEqual(2, len(self.data["research_projects"]))


def test_all_ids_use_annual001_prefix(self) -> None:
    groups = (
        "activities", "companions", "support_skills", "base_equipment",
        "modules", "research_projects",
    )
    ids: list[str] = []
    for group in groups:
        ids.extend(entry["id"] for entry in self.data[group])
    self.assertEqual(len(ids), len(set(ids)))
    self.assertTrue(all(value.startswith("annual001_") for value in ids))
```

- [ ] **Step 3: 참조 무결성 테스트를 추가한다**

```python
def test_references_resolve(self) -> None:
    skills = {entry["id"] for entry in self.data["support_skills"]}
    modules = {entry["id"] for entry in self.data["modules"]}
    projects = {entry["id"] for entry in self.data["research_projects"]}
    companion = self.data["companions"][0]
    self.assertIn(companion["unique_skill_id"], skills)
    for skill_id in companion["allowed_public_skill_ids"]:
        self.assertIn(skill_id, skills)
    for project in self.data["research_projects"]:
        for module_id in project.get("unlock_module_ids", []):
            self.assertIn(module_id, modules)
        for skill_id in project.get("unlock_skill_ids", []):
            self.assertIn(skill_id, skills)
    self.assertEqual(projects, {
        "annual001_research_signal_buffer",
        "annual001_research_ticket_protocol",
    })
```

- [ ] **Step 4: 테스트가 파일 부재로 실패하는지 확인한다**

Run:

```bash
python -m unittest tests/test_annual_mvp_001_data_contract.py -v
```

Expected: `FileNotFoundError`.

- [ ] **Step 5: 다음 고정 데이터로 JSON을 작성한다**

```json
{
  "contract_version": "annual-mvp-001-v1",
  "campaign": {
    "id": "annual001_spring_slice",
    "max_weeks": 3,
    "slots_per_week": 3,
    "voluntary_entry_week": 2,
    "deadline_week": 3,
    "week_2_delay_risk": 15,
    "forced_entry_risk": 30,
    "incident_case_path": "res://data/poc/core_mvp_001/afterlife_station_poc.json"
  },
  "starting_state": {
    "competencies": {"observation": 1, "analysis": 1, "field_response": 1, "interpersonal": 1},
    "fatigue": 10,
    "institution_support": 0,
    "residual_data": 0,
    "companion_trust": {"annual001_companion_oh_hyun": 0}
  }
}
```

나머지 배열은 다음 고정 ID를 사용한다.

```text
Activities
annual001_activity_observation_drill
annual001_activity_analysis_desk
annual001_activity_field_training
annual001_activity_interview_duty
annual001_activity_signal_research
annual001_activity_companion_drill
annual001_activity_rest

Companion
annual001_companion_oh_hyun

Skills
annual001_skill_procedural_check
annual001_skill_emergency_cover
annual001_skill_signal_cross_check

Equipment / Module
annual001_equipment_field_recorder
annual001_module_signal_buffer

Research
annual001_research_signal_buffer
annual001_research_ticket_protocol
```

- [ ] **Step 6: 활동 수치를 정확히 작성한다**

```text
observation_drill: observation +1, fatigue +12
analysis_desk: analysis +1, fatigue +10
field_training: field_response +1, fatigue +15, institution_support +1
interview_duty: interpersonal +1, fatigue +10, institution_support +1
signal_research: signal_buffer progress +1, fatigue +10
companion_drill: 오현 trust +1, fatigue +8
rest: fatigue -25
```

모든 역량 최대값은 5, 피로 범위는 0~100, 기관 지원 범위는 0~3, 신뢰 범위는 0~3으로 고정한다.

- [ ] **Step 7: 연구·스킬 계약을 작성한다**

```text
annual001_research_signal_buffer
- pre-incident
- signal_buffer progress 2 필요
- annual001_module_signal_buffer 해금

annual001_research_ticket_protocol
- post-incident
- residual_data 1 이상
- manual status verified 필요
- annual001_skill_signal_cross_check 해금

annual001_skill_procedural_check
- unique
- trigger omen_failed
- base 40
- readiness_gain 30
- readiness_max 90
- effect risk_reduction 4
- per_battle_limit 2

annual001_skill_emergency_cover
- public / institution
- unlock institution_support 1
- trigger damage_at_least_12
- base 50
- readiness_gain 25
- readiness_max 100
- effect health_restore 6, risk_reduction 4
- per_battle_limit 2

annual001_skill_signal_cross_check
- public / research
- trigger first_hidden_pattern_resolved
- base 55
- readiness_gain 25
- readiness_max 100
- effect health_restore 4, risk_reduction 6
- per_battle_limit 1
```

- [ ] **Step 8: 데이터 테스트를 실행한다**

Run:

```bash
python -m unittest tests/test_annual_mvp_001_data_contract.py -v
```

Expected: `OK`.

- [ ] **Step 9: 커밋한다**

```bash
git add data/poc/annual_mvp_001/spring_vertical_slice.json tests/test_annual_mvp_001_data_contract.py
git commit -m "test: define annual mvp 001 data contract"
```

---

### Task 2: 데이터 로더와 런타임 검증기

**Files:**
- Create: `scripts/poc/annual_mvp_001/annual_mvp_001_data.gd`
- Create: `tests/annual_mvp_001_data_test.gd`

**Interfaces:**
- Consumes: `annual-mvp-001-v1` JSON
- Produces: 검증된 config Dictionary와 ID index

- [ ] **Step 1: 실패 테스트를 작성한다**

```gdscript
extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")

func _init() -> void:
    var valid := Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
    assert(not valid.is_empty())
    assert(Data.validate_config(valid).is_empty())
    assert(Data.load_config("res://missing.json").is_empty())
    var broken := valid.duplicate(true)
    broken["campaign"]["slots_per_week"] = 2
    assert(not Data.validate_config(broken).is_empty())
    print("ANNUAL MVP 001 DATA: PASS")
    quit()
```

- [ ] **Step 2: 테스트가 preload 실패하는지 확인한다**

Run:

```bash
GODOT_BIN="${GODOT_BIN:-godot}"
"$GODOT_BIN" --headless --path . --script res://tests/annual_mvp_001_data_test.gd
```

Expected: script preload 실패.

- [ ] **Step 3: 다음 인터페이스를 구현한다**

```gdscript
class_name AnnualMvp001Data
extends RefCounted

static func load_config(path: String) -> Dictionary
static func validate_config(data: Dictionary) -> Array[String]
static func index_by_id(entries: Array) -> Dictionary
```

`validate_config`는 다음을 검사한다.

```text
contract_version
3주·3슬롯·2주 자율 출동·3주 마감
고정 수량
annual001_ ID prefix와 중복
companion unique/public skill 참조
research unlock 참조
활동 delta 필드와 수치 범위
스킬 base chance 0~100
readiness_gain 양수
readiness_max 1~100
효과는 health_restore·risk_reduction만 허용
incident_case_path 존재
```

- [ ] **Step 4: 테스트를 실행한다**

Run:

```bash
"${GODOT_BIN:-godot}" --headless --path . --script res://tests/annual_mvp_001_data_test.gd
```

Expected: `ANNUAL MVP 001 DATA: PASS`.

- [ ] **Step 5: 커밋한다**

```bash
git add scripts/poc/annual_mvp_001/annual_mvp_001_data.gd tests/annual_mvp_001_data_test.gd
git commit -m "feat: add annual mvp 001 data loader"
```

---

### Task 3: 주간 육성·마감·결산 상태 머신

**Files:**
- Create: `scripts/poc/annual_mvp_001/annual_mvp_001_state.gd`
- Create: `tests/annual_mvp_001_state_test.gd`

**Interfaces:**
- Consumes: `AnnualMvp001Data` config
- Produces: 일정·성장·출동·연구·분기 결산 snapshot

- [ ] **Step 1: 초기 상태 Red 테스트를 작성한다**

```gdscript
extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const State = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_state.gd")

func _init() -> void:
    var config := Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
    var state := State.new()
    var started := state.start(config, 2001)
    assert(started["ok"])
    var snapshot := state.get_snapshot()
    assert(snapshot["phase"] == "WEEK_PLANNING")
    assert(snapshot["week"] == 1)
    assert(snapshot["fatigue"] == 10)
    print("ANNUAL MVP 001 STATE: PASS")
    quit()
```

- [ ] **Step 2: preload 실패를 확인한다**

Run:

```bash
"${GODOT_BIN:-godot}" --headless --path . --script res://tests/annual_mvp_001_state_test.gd
```

Expected: 신규 state preload 실패.

- [ ] **Step 3: 공통 응답과 snapshot을 구현한다**

Snapshot은 정확히 다음 키를 가진다.

```text
phase
week
planned_activity_ids
last_week_result
competencies
fatigue
institution_support
residual_data
companion_trust
research_progress
unlocked_module_ids
unlocked_skill_ids
selected_companion_id
selected_public_skill_id
equipped_module_ids
deployment_risk
forced_deployment
incident_result
manual_delta
support_log
quarter_summary
run_seed
```

- [ ] **Step 4: `commit_week`를 구현하고 테스트한다**

계약:

```text
- WEEK_PLANNING에서만 실행
- 정확히 3개 활동 ID 필요
- 유효하지 않은 ID는 상태 불변
- 활동은 입력 순서대로 적용
- 역량 0~5, 피로 0~100, 기관 지원 0~3, 신뢰 0~3 clamp
- 슬롯 시작 피로가 60 이상이면 해당 슬롯의 양수 역량 증가를 1 감소, 최소 0
- rest는 항상 실행 가능
- 주차 결과와 delta를 last_week_result에 기록
- week 1 완료: WEEK_RESULT
- week 2·3 완료: WEEK_RESULT 뒤 acknowledge 시 DEPLOYMENT_DECISION
```

테스트 예시:

```gdscript
var result := state.commit_week([
    "annual001_activity_observation_drill",
    "annual001_activity_field_training",
    "annual001_activity_rest",
])
assert(result["ok"])
var snapshot := state.get_snapshot()
assert(snapshot["competencies"]["observation"] == 2)
assert(snapshot["competencies"]["field_response"] == 2)
assert(snapshot["fatigue"] == 12)
assert(snapshot["institution_support"] == 1)
```

- [ ] **Step 5: `acknowledge_week_result`와 출동 결정을 구현한다**

계약:

```text
week 1 결과 확인 → week 2 WEEK_PLANNING
week 2 결과 확인 → DEPLOYMENT_DECISION
week 2 deploy → PREPARATION, deployment_risk 0
week 2 delay → week 3 WEEK_PLANNING
week 3 deploy → PREPARATION, deployment_risk 15
week 3 delay → PREPARATION, deployment_risk 30, forced_deployment true
```

허용 decision ID:

```text
annual001_decision_deploy
annual001_decision_delay
```

- [ ] **Step 6: 연구 해금과 loadout을 구현한다**

계약:

```text
signal_research progress 2가 되면 annual001_research_signal_buffer 완료 가능
완료 시 annual001_module_signal_buffer 해금
institution_support 1 이상이면 annual001_skill_emergency_cover 사용 가능
공용 스킬 슬롯은 1개
모듈 슬롯은 1개
오현만 선택 가능
허용되지 않거나 잠기지 않은 skill/module 선택은 상태 불변
```

PoC에서는 pre-incident 연구 완료를 `acknowledge_week_result` 시 자동 처리하지 않는다. `configure_loadout` 전에 이미 progress 2이면 module을 해금한다.

- [ ] **Step 7: 사건 결과와 사후 연구를 구현한다**

`apply_incident_result` 보상:

```text
recovery_quality normal → residual_data +2, institution_support +1
recovery_quality costly → residual_data +1
recovery_quality emergency → residual_data +1, institution_support -1
manual status verified → annual001_research_ticket_protocol 연구 가능
manual status candidate → 위험 사례는 결산에 남지만 연구 완료 불가
```

`complete_post_incident_research("annual001_research_ticket_protocol")`는 residual_data 1을 소비하고 `annual001_skill_signal_cross_check`를 해금한다.

- [ ] **Step 8: 분기 결산을 구현한다**

`quarter_summary` 필드:

```text
weeks_used
forced_deployment
competency_focus
fatigue_band
companion_trust
recovery_quality
knowledge_quality
support_trigger_count
unlocked_module_ids
unlocked_skill_ids
next_cycle_flags
```

`next_cycle_flags`는 다음 문자열만 사용한다.

```text
annual001_flag_signal_module_known
annual001_flag_ticket_protocol_known
annual001_flag_emergency_deployment
annual001_flag_manual_candidate
annual001_flag_manual_verified
```

- [ ] **Step 9: 상태 테스트를 실행한다**

Run:

```bash
"${GODOT_BIN:-godot}" --headless --path . --script res://tests/annual_mvp_001_state_test.gd
```

Expected: `ANNUAL MVP 001 STATE: PASS`.

- [ ] **Step 10: 커밋한다**

```bash
git add scripts/poc/annual_mvp_001/annual_mvp_001_state.gd tests/annual_mvp_001_state_test.gd
git commit -m "feat: add annual schedule and quarter state"
```

---

### Task 4: 조건부 확률·지원 준비도 resolver

**Files:**
- Create: `scripts/poc/annual_mvp_001/annual_mvp_001_support_resolver.gd`
- Create: `tests/annual_mvp_001_support_resolver_test.gd`

**Interfaces:**
- Consumes: 장착된 unique/public 스킬, trust, interpersonal, 사건 event context
- Produces: 캐시된 발동 결과와 허용된 외부 지원 효과

```gdscript
class_name AnnualMvp001SupportResolver
extends RefCounted

func start(skill_entries: Array[Dictionary], trust: int, interpersonal: int, run_seed: int) -> Dictionary
func resolve(event_key: String, context: Dictionary) -> Array[Dictionary]
func get_snapshot() -> Dictionary
func restore(payload: Dictionary) -> Dictionary
```

- [ ] **Step 1: 같은 event key 재호출이 같은 결과를 반환하는 Red 테스트를 작성한다**

```gdscript
var resolver := Resolver.new()
resolver.start(skills, 0, 1, 2001)
var first := resolver.resolve("omen:1:poc001_pattern_false_terminal", {
    "event": "omen_failed",
    "damage": 0,
    "first_hidden": false,
})
var second := resolver.resolve("omen:1:poc001_pattern_false_terminal", {
    "event": "omen_failed",
    "damage": 0,
    "first_hidden": false,
})
assert(first == second)
```

- [ ] **Step 2: readiness 보장 테스트를 작성한다**

고정 roll을 테스트에서 주입하지 않는다. base chance 0, readiness gain 50, max 100인 fixture를 사용해 세 번째 적합 event가 확정 발동하는지 검사한다.

```text
event 1 miss → readiness 50
event 2 miss → readiness 100
event 3 guaranteed trigger → readiness 0
```

- [ ] **Step 3: 현재 확률 계산을 구현한다**

```text
current_chance = min(100, base_chance + trust * 5 + interpersonal_bonus + readiness)
interpersonal_bonus = 5 if interpersonal >= 2 else 0
```

신뢰 2 이상이면 unique 스킬의 첫 적합 event에 `signature_guarantee_available`을 적용해 1회 확정 발동한다.

- [ ] **Step 4: 적합 조건을 구현한다**

```text
omen_failed
- context.event == omen_read
- context.success == false

damage_at_least_12
- context.event == recovery_action_resolved
- context.damage >= 12

first_hidden_pattern_resolved
- context.event == recovery_action_resolved
- context.first_hidden == true
```

- [ ] **Step 5: 결과 형식을 구현한다**

```gdscript
{
    "skill_id": "annual001_skill_emergency_cover",
    "eligible": true,
    "triggered": true,
    "chance": 65,
    "readiness_before": 25,
    "readiness_after": 0,
    "guaranteed": false,
    "effect": {"health_restore": 6, "risk_reduction": 4},
    "event_key": "action:3:poc001_action_guard"
}
```

부적합 event는 캐시하지 않는다. 적합 event는 성공·실패 모두 캐시한다.

- [ ] **Step 6: 테스트를 실행한다**

Run:

```bash
"${GODOT_BIN:-godot}" --headless --path . --script res://tests/annual_mvp_001_support_resolver_test.gd
```

Expected: `ANNUAL MVP 001 SUPPORT: PASS`.

- [ ] **Step 7: 커밋한다**

```bash
git add scripts/poc/annual_mvp_001/annual_mvp_001_support_resolver.gd tests/annual_mvp_001_support_resolver_test.gd
git commit -m "feat: add deterministic companion support resolver"
```

---

### Task 5: CORE-MVP-001 하위 호환 확장점

**Files:**
- Modify: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`
- Modify: `scripts/poc/core_mvp_001/core_mvp_001_scene.gd`
- Modify: `tests/core_mvp_001_state_test.gd`
- Modify: `tests/core_mvp_001_scene_test.gd`

**Interfaces:**
- Consumes: 기존 CORE-MVP-001 공개 상태와 기본 JSON
- Produces: 외부 지원 효과, session override, 완료 signal

- [ ] **Step 1: 기존 기본 실행 snapshot을 고정하는 회귀 테스트를 추가한다**

```gdscript
var state := State.new()
var started := state.start(case_data, 1001)
assert(started["ok"])
assert(state.get_snapshot()["health"] == 100)
assert(state.get_snapshot()["risk"] == 0)
```

- [ ] **Step 2: 외부 지원 중복 적용 방지 Red 테스트를 추가한다**

```gdscript
var first := state.apply_external_support(
    "annual001_skill_emergency_cover",
    "action:3:poc001_action_guard",
    {"health_restore": 6, "risk_reduction": 4}
)
var second := state.apply_external_support(
    "annual001_skill_emergency_cover",
    "action:3:poc001_action_guard",
    {"health_restore": 6, "risk_reduction": 4}
)
assert(first["ok"])
assert(second["ok"])
assert(second["state_changed"] == false)
```

- [ ] **Step 3: `CoreMvp001State`에 다음 메서드를 추가한다**

```gdscript
func apply_external_support(source_id: String, event_key: String, effect: Dictionary) -> Dictionary
```

계약:

```text
- recovery 관련 phase에서만 허용
- source_id와 event_key 비어 있으면 거부
- health_restore·risk_reduction 외 키 거부
- 음수 효과 거부
- health는 starting_health를 초과하지 않음
- risk는 0 미만이 되지 않음
- 동일 event_key는 두 번 적용하지 않음
- hidden answer, capture mark, understanding, hypothesis를 변경하지 않음
- event external_support_applied 기록
```

Snapshot에 `applied_external_support_event_keys`를 추가한다.

- [ ] **Step 4: Scene 세션 구성 Red 테스트를 추가한다**

```gdscript
var scene := SceneScript.new()
scene.configure_session(case_override, 3001, extension)
root.add_child(scene)
await process_frame
assert(scene.debug_snapshot()["risk"] == 15)
```

- [ ] **Step 5: `CoreMvp001Scene`에 세션 확장 인터페이스를 추가한다**

```gdscript
signal session_completed(result: Dictionary, manual_delta: Dictionary, support_log: Array[Dictionary])

func configure_session(case_data_override: Dictionary, run_seed: int = 1001, session_extension: Object = null) -> void
```

계약:

```text
- configure_session은 tree 진입 전에만 허용
- override가 없으면 기존 JSON을 그대로 load
- extension은 선택적 duck-typed object
- extension.after_omen(state, snapshot, omen_result) 호출 가능
- extension.after_recovery_action(state, snapshot_before, action_id, action_result) 호출 가능
- extension.get_status_lines()가 있으면 UI에 조건·확률·준비도 표시
- COMPLETE 최초 진입 시 session_completed 1회 emit
- 기본 F1 CORE-MVP-001 진입은 extension 없이 기존 동작 유지
```

- [ ] **Step 6: 기존 CORE focused suite를 실행한다**

Run:

```bash
GODOT_BIN="${GODOT_BIN:-godot}" tests/run_core_mvp_001_tests.sh
```

Expected: `4/4 passed`.

- [ ] **Step 7: 커밋한다**

```bash
git add \
  scripts/poc/core_mvp_001/core_mvp_001_state.gd \
  scripts/poc/core_mvp_001/core_mvp_001_scene.gd \
  tests/core_mvp_001_state_test.gd \
  tests/core_mvp_001_scene_test.gd
git commit -m "feat: add core poc session extension hooks"
```

---

### Task 6: 육성 상태를 사건 override로 변환하는 adapter

**Files:**
- Create: `scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd`
- Create: `tests/annual_mvp_001_incident_adapter_test.gd`

**Interfaces:**
- Consumes: annual snapshot, CORE-MVP-001 base case, support resolver
- Produces: case override, extension hooks, annual reward

```gdscript
class_name AnnualMvp001IncidentAdapter
extends RefCounted

func configure(config: Dictionary, annual_snapshot: Dictionary, run_seed: int) -> Dictionary
func build_case_override(base_case: Dictionary) -> Dictionary
func after_omen(state: Object, snapshot: Dictionary, omen_result: Dictionary) -> Array[Dictionary]
func after_recovery_action(state: Object, snapshot_before: Dictionary, action_id: String, action_result: Dictionary) -> Array[Dictionary]
func get_status_lines() -> Array[String]
func get_support_log() -> Array[Dictionary]
func build_annual_reward(result: Dictionary, manual_delta: Dictionary) -> Dictionary
```

- [ ] **Step 1: case override Red 테스트를 작성한다**

```gdscript
var annual_snapshot := {
    "competencies": {"observation": 2, "analysis": 2, "field_response": 2, "interpersonal": 2},
    "fatigue": 70,
    "deployment_risk": 15,
    "companion_trust": {"annual001_companion_oh_hyun": 2},
    "selected_public_skill_id": "annual001_skill_emergency_cover",
    "equipped_module_ids": ["annual001_module_signal_buffer"],
}
var override := adapter.build_case_override(base_case)
assert(override["case"]["starting_health"] == 85)
assert(override["case"]["starting_risk"] == 15)
assert(override["understanding"]["omen_read_rates"]["clue"] == 45)
```

- [ ] **Step 2: 다음 변환 규칙을 구현한다**

```text
fatigue <= 40: starting_health 100
fatigue 41~50: 95
fatigue 51~60: 90
fatigue 61~70: 85
fatigue 71~80: 80
fatigue 81~100: 75

starting_risk += deployment_risk, max 100
observation >=2: clue·likely omen_read_rates +10, likely max 90
field_response >=2: field_tests.damage와 recovery_patterns.damage_on_failure -4, 최소 0
signal_buffer module: max_first_observation_damage 18 → 12
analysis >=2: annual_context_notes에 '전광판 변동보다 방송 원본의 공백 조건을 우선 비교할 수 있다.' 추가
```

`annual_context_notes`는 UI 설명용이며 선택지·가설·정답 데이터는 변경하지 않는다.

- [ ] **Step 3: support hook을 구현한다**

`after_omen` event key:

```text
omen:{turn}:{pattern_id}
```

`after_recovery_action` event key:

```text
action:{turn}:{pattern_id}:{action_id}
```

Resolver 결과가 triggered면 `state.apply_external_support`를 호출하고 support log에 다음을 저장한다.

```text
skill_id
turn
pattern_id
event_key
chance
readiness_before
readiness_after
guaranteed
effect
```

- [ ] **Step 4: 상태 표시 문구를 구현한다**

`get_status_lines()` 예시:

```text
오현 · 절차 교차 확인 | 조건: 전조 해석 실패 | 확률 55% | 준비도 30/90
공용 · 긴급 엄호 | 조건: 피해 12 이상 | 확률 65% | 준비도 0/100
```

- [ ] **Step 5: annual reward 변환을 구현한다**

```gdscript
{
    "recovery_quality": result["recovery_quality"],
    "knowledge_quality": manual_delta["status"],
    "residual_data_gain": 2,
    "institution_support_delta": 1,
    "danger_case_count": manual_delta["danger_cases"].size(),
}
```

quality별 수치는 Task 3 계약과 일치해야 한다.

- [ ] **Step 6: 테스트를 실행한다**

Run:

```bash
"${GODOT_BIN:-godot}" --headless --path . --script res://tests/annual_mvp_001_incident_adapter_test.gd
```

Expected: `ANNUAL MVP 001 ADAPTER: PASS`.

- [ ] **Step 7: 커밋한다**

```bash
git add scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd tests/annual_mvp_001_incident_adapter_test.gd
git commit -m "feat: bridge annual preparation into core incident"
```

---

### Task 7: 격리 저장·복원

**Files:**
- Create: `scripts/poc/annual_mvp_001/annual_mvp_001_save_data.gd`
- Create: `tests/annual_mvp_001_save_data_test.gd`

**Interfaces:**
- Consumes: `AnnualMvp001State.build_save_payload()`
- Produces: 전용 JSON 저장과 안전한 복원

```gdscript
class_name AnnualMvp001SaveData
extends RefCounted

const SAVE_PATH := "user://annual_mvp_001_poc.json"

static func write_payload(payload: Dictionary, path: String = SAVE_PATH) -> Error
static func read_payload(path: String = SAVE_PATH) -> Dictionary
static func delete_payload(path: String = SAVE_PATH) -> Error
```

- [ ] **Step 1: round-trip Red 테스트를 작성한다**

```gdscript
var path := "user://annual_mvp_001_test.json"
var payload := state.build_save_payload()
assert(SaveData.write_payload(payload, path) == OK)
var loaded := SaveData.read_payload(path)
assert(loaded == payload)
```

- [ ] **Step 2: 저장 계약을 구현한다**

```text
save_version annual-mvp-001-save-v1 필수
phase INCIDENT_ACTIVE 저장 거부
run_seed 보존
support resolver cached results·readiness 보존
기존 GameState save path 문자열 참조 금지
깨진 JSON은 {}
temp file 작성 후 rename으로 원자 교체
```

- [ ] **Step 3: restore가 같은 support event를 재추첨하지 않는 테스트를 작성한다**

```text
1. 적합 event resolve
2. state/resolver payload 저장
3. 새 resolver restore
4. 동일 event key resolve
5. triggered·chance·readiness 결과 동일
```

- [ ] **Step 4: 테스트를 실행한다**

Run:

```bash
"${GODOT_BIN:-godot}" --headless --path . --script res://tests/annual_mvp_001_save_data_test.gd
```

Expected: `ANNUAL MVP 001 SAVE: PASS`.

- [ ] **Step 5: 커밋한다**

```bash
git add scripts/poc/annual_mvp_001/annual_mvp_001_save_data.gd tests/annual_mvp_001_save_data_test.gd
git commit -m "feat: add isolated annual slice save"
```

---

### Task 8: 연도제 수직절편 Scene

**Files:**
- Create: `scripts/poc/annual_mvp_001/annual_mvp_001_scene.gd`
- Create: `scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn`
- Create: `tests/annual_mvp_001_scene_test.gd`

**Interfaces:**
- Consumes: data, annual state, incident adapter, save data, CORE-MVP-001 PackedScene
- Produces: 주간 계획→준비→사건→연구→결산 단일 UI

- [ ] **Step 1: Scene node 계약 Red 테스트를 작성한다**

필수 노드:

```text
AnnualMvp001Scene
SafeFrame
RootColumn
Header
PhaseLabel
WeekLabel
StatsLabel
ResourceLabel
PhaseHost
WeekPlanningPanel
WeekResultPanel
DeploymentPanel
PreparationPanel
IncidentHost
ResearchPanel
QuarterSummaryPanel
FeedbackLabel
Footer
BackButton
ConfirmButton
SaveButton
LoadButton
```

테스트는 1280×720과 1920×1080에서 `SafeFrame`, `Footer`, 현재 panel이 viewport 안에 있는지 검사한다.

- [ ] **Step 2: 현재 phase panel 하나만 표시하는 UI를 구현한다**

```text
WEEK_PLANNING → WeekPlanningPanel
WEEK_RESULT → WeekResultPanel
DEPLOYMENT_DECISION → DeploymentPanel
PREPARATION → PreparationPanel
INCIDENT_ACTIVE → IncidentHost
INCIDENT_RESULT / POST_INCIDENT_RESEARCH → ResearchPanel
QUARTER_SUMMARY / COMPLETE → QuarterSummaryPanel
```

- [ ] **Step 3: 주간 계획 UI를 구현한다**

- 7개 활동 버튼
- 선택 순서 1/3, 2/3, 3/3 표시
- 같은 활동 중복 허용
- `계획 확정` 전 snapshot 미변경
- 결과 panel에서 역량·피로·지원·신뢰 delta 표시

- [ ] **Step 4: 출동 결정과 준비 UI를 구현한다**

출동 결정:

```text
2주차: 지금 출동 / 1주 더 준비
3주차: 지금 출동 / 지연 선택 시 긴급 출동 경고
```

준비:

```text
동료: 오현 고정
고유 스킬: 절차 교차 확인 고정
공용 스킬: 긴급 엄호 또는 해금된 신호 교차 확인
기본 장비: 현장 기록기 고정
모듈: 없음 또는 신호 완충 모듈
사건 시작 위험·체력·전조 보정 preview
```

- [ ] **Step 5: CORE-MVP-001 Scene을 embedded instance로 실행한다**

```gdscript
var packed := preload("res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn")
var incident := packed.instantiate() as CoreMvp001Scene
incident.configure_session(case_override, run_seed, adapter)
incident.session_completed.connect(_on_incident_completed)
_incident_host.add_child(incident)
```

완료 signal에서 annual reward를 만들고 `state.apply_incident_result`를 호출한다.

- [ ] **Step 6: 지원 상태를 사건 화면에 표시한다**

CORE scene의 extension status 영역에 unique/public 스킬 각각 다음을 표시한다.

```text
이름
발동 조건
현재 확률
지원 준비도
남은 발동 횟수
```

발동 시 `FeedbackLabel`과 사건 로그에 스킬명·효과를 표시한다. 정답·유효 행동명은 추가하지 않는다.

- [ ] **Step 7: 연구·분기 결산 UI를 구현한다**

- verified + residual_data 1이면 승차권 접촉 대응 연구 버튼 활성
- candidate면 위험 사례 수와 미완료 사유 표시
- 결산은 현재 성장 방향, 출동 시점, 회수 품질, 지식 품질, 동료 협업, 해금 결과를 6~10문장 이내로 표시
- `다음 해 시작` 버튼은 만들지 않고 `PoC 완료`로 종료

- [ ] **Step 8: 저장·불러오기 UI를 구현한다**

- INCIDENT_ACTIVE에서는 SaveButton disabled
- Load 시 Scene을 재구성하고 동일 phase·수치·선택·RNG cache 복원
- 기존 save 존재 여부나 `GameState`를 조회하지 않음

- [ ] **Step 9: Scene 테스트를 실행한다**

Run:

```bash
"${GODOT_BIN:-godot}" --headless --path . --script res://tests/annual_mvp_001_scene_test.gd
```

Expected: `ANNUAL MVP 001 SCENE: PASS`.

- [ ] **Step 10: 커밋한다**

```bash
git add \
  scripts/poc/annual_mvp_001/annual_mvp_001_scene.gd \
  scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn \
  tests/annual_mvp_001_scene_test.gd
git commit -m "feat: add annual raising vertical slice scene"
```

---

### Task 9: 개발 진입점과 보호 회귀

**Files:**
- Modify: `scripts/ui/main_menu.gd`
- Modify: `tests/run_godot_regression.sh`
- Modify: `tests/test_active_document_references.py`

**Interfaces:**
- Consumes: 기존 F1 개발 패널
- Produces: ANNUAL-MVP-001 전용 진입과 보호 경계 검사

- [ ] **Step 1: F1 버튼 정적 계약을 추가한다**

```python
def test_annual_mvp_001_dev_entry_exists(self) -> None:
    menu = (ROOT / "scripts/ui/main_menu.gd").read_text(encoding="utf-8")
    self.assertIn("ANNUAL-MVP-001 육성→사건→연구 PoC", menu)
    self.assertIn("res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn", menu)
```

- [ ] **Step 2: 개발 패널에 버튼을 추가한다**

```gdscript
_add_scene_button(
    dev_content,
    "ANNUAL-MVP-001 육성→사건→연구 PoC",
    "res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn"
)
```

기존 CORE-MVP-001 버튼은 유지한다.

- [ ] **Step 3: 전체 회귀 runner에 신규 테스트를 등록한다**

다음 6개 Godot 테스트를 추가한다.

```text
annual_mvp_001_data_test
annual_mvp_001_state_test
annual_mvp_001_support_resolver_test
annual_mvp_001_incident_adapter_test
annual_mvp_001_save_data_test
annual_mvp_001_scene_test
```

기존 전체 수가 43이면 신규 6개 포함 49로 갱신한다.

- [ ] **Step 4: 보호 경로 정적 계약을 추가한다**

Python 테스트에서 구현 PR diff 대상이 다음을 포함하지 않는지 검사한다.

```text
scripts/core/game_state.gd
data/episodes/
scripts/scenes/investigation_scene.gd
scripts/scenes/battle_scene.gd
project.godot
knowledge/base-pack/
```

- [ ] **Step 5: 커밋한다**

```bash
git add scripts/ui/main_menu.gd tests/run_godot_regression.sh tests/test_active_document_references.py
git commit -m "feat: expose annual mvp 001 dev entry"
```

---

### Task 10: Focused runner와 CI

**Files:**
- Create: `tests/run_annual_mvp_001_tests.sh`
- Create: `.github/workflows/validate-annual-mvp-001.yml`

**Interfaces:**
- Consumes: Python 데이터 테스트, 신규 Godot 테스트, 기존 CORE suite
- Produces: 코드 PR 단일 검증 job

- [ ] **Step 1: focused runner를 작성한다**

```bash
#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
RUN_ROOT="${GODOT_TEST_TMP:-$(mktemp -d)}"

names=(
  annual_mvp_001_data_test
  annual_mvp_001_state_test
  annual_mvp_001_support_resolver_test
  annual_mvp_001_incident_adapter_test
  annual_mvp_001_save_data_test
  annual_mvp_001_scene_test
)

for name in "${names[@]}"; do
  home_dir="$RUN_ROOT/home/$name"
  mkdir -p "$home_dir"
  HOME="$home_dir" XDG_DATA_HOME="$home_dir/.local/share" XDG_CONFIG_HOME="$home_dir/.config" \
    timeout 90 "$GODOT_BIN" --headless --path "$PROJECT_ROOT" --script "res://tests/$name.gd"
done

echo "ANNUAL-MVP-001 focused suite: 6/6 passed"
```

- [ ] **Step 2: workflow를 작성한다**

Trigger path:

```text
data/poc/annual_mvp_001/**
scripts/poc/annual_mvp_001/**
scenes/poc/annual_mvp_001/**
scripts/poc/core_mvp_001/**
scripts/ui/main_menu.gd
tests/**
.github/workflows/validate-annual-mvp-001.yml
```

Job 순서:

```bash
python -m unittest tests/test_annual_mvp_001_data_contract.py tests/test_active_document_references.py
Godot 4.7.1 --import
bash tests/run_core_mvp_001_tests.sh
bash tests/run_annual_mvp_001_tests.sh
bash tests/run_godot_regression.sh
```

- [ ] **Step 3: concurrency와 failure artifact 계약을 적용한다**

```yaml
concurrency:
  group: annual-mvp-001-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

실패할 때만 로그 artifact를 7일 보존한다.

- [ ] **Step 4: 로컬 검증을 실행한다**

Run:

```bash
python -m unittest tests/test_annual_mvp_001_data_contract.py tests/test_active_document_references.py -v
GODOT_BIN="${GODOT_BIN:-godot}"
"$GODOT_BIN" --headless --path . --import
GODOT_BIN="$GODOT_BIN" tests/run_core_mvp_001_tests.sh
GODOT_BIN="$GODOT_BIN" tests/run_annual_mvp_001_tests.sh
GODOT_BIN="$GODOT_BIN" tests/run_godot_regression.sh
```

Expected:

```text
Python OK
CORE-MVP-001 4/4 passed
ANNUAL-MVP-001 6/6 passed
Godot regression 49/49 passed
```

- [ ] **Step 5: 커밋한다**

```bash
git add tests/run_annual_mvp_001_tests.sh .github/workflows/validate-annual-mvp-001.yml
git commit -m "ci: validate annual mvp 001 vertical slice"
```

---

### Task 11: 구현 상태 문서 갱신

**Files:**
- Modify: `TEST_CHECKLIST.md`
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Modify: `MVP_ROADMAP.md`

**Interfaces:**
- Consumes: 실제 자동 검증 결과
- Produces: `ANNUAL_MVP_001_BUILD_READY` 또는 실제 실패 상태

- [ ] **Step 1: 실행된 검증만 기록한다**

다음 형식을 사용한다.

```text
ANNUAL-MVP-001 implementation: BUILD_READY 또는 BUILD_BLOCKED
automated_verification: PASSED 또는 FAILED
player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

- [ ] **Step 2: 수직절편 구현 범위를 기록한다**

```text
3주·주당 3슬롯
권나래 역량 4종·피로
오현 1명·고유+공용 자동 지원
기본 장비·모듈 1개
주차별 출동 위험
CORE-MVP-001 embedded 실행
사건 결과·연구·분기 결산
전용 save
```

- [ ] **Step 3: 미구현 범위를 명시한다**

```text
1년 4분기 전체
동료 2명
관계·로맨스
중형·소형 사건
신규 미니게임
본편 save integration
```

- [ ] **Step 4: 플레이 검증 질문을 기록한다**

```text
- 플레이어가 주간 선택과 사건 보정의 인과를 설명하는가
- 피로와 지연 위험이 준비 판단에 영향을 주는가
- 동료 지원 확률·준비도가 공정하게 느껴지는가
- 지원이 정답 대체가 아니라 실패 비용 완화로 인식되는가
- 사건 결과가 연구·다음 준비 보상으로 되돌아온다고 느끼는가
- 분기 결산이 최종 엔딩이 아니라 다음 기간의 중간 결과로 읽히는가
```

- [ ] **Step 5: 문서 계약을 실행한다**

Run:

```bash
python -m unittest tests/test_active_document_references.py -v
```

Expected: `OK`.

- [ ] **Step 6: 커밋한다**

```bash
git add TEST_CHECKLIST.md docs/CURRENT_STATUS.md docs/CURRENT_HANDOFF.md MVP_ROADMAP.md
git commit -m "docs: record annual mvp 001 build status"
```

---

### Task 12: 최종 검증·자체 리뷰·Draft PR

**Files:**
- No new files

**Interfaces:**
- Consumes: Task 1~11 전체 변경
- Produces: 리뷰 가능한 구현 PR

- [ ] **Step 1: 전체 자동 검증을 새 환경에서 실행한다**

Run:

```bash
python -m unittest \
  tests/test_base_operating_sync.py \
  tests/test_skill_package_integrity.py \
  tests/test_active_document_references.py \
  tests/test_core_validation_contract.py \
  tests/test_core_mvp_001_data_contract.py \
  tests/test_core_mvp_001_static_contract.py \
  tests/test_annual_mvp_001_data_contract.py -v

GODOT_BIN="${GODOT_BIN:-godot}"
"$GODOT_BIN" --headless --path . --import
GODOT_BIN="$GODOT_BIN" tests/run_core_mvp_001_tests.sh
GODOT_BIN="$GODOT_BIN" tests/run_annual_mvp_001_tests.sh
GODOT_BIN="$GODOT_BIN" tests/run_godot_regression.sh

git diff --check
```

Expected:

```text
Python failures 0, errors 0
CORE-MVP-001 4/4
ANNUAL-MVP-001 6/6
전체 Godot 49/49
git diff --check 출력 없음
```

- [ ] **Step 2: 보호 경로 diff를 확인한다**

Run:

```bash
changed="$(git diff --name-only origin/main...HEAD)"
printf '%s\n' "$changed"
for forbidden in \
  scripts/core/game_state.gd \
  scripts/scenes/investigation_scene.gd \
  scripts/scenes/battle_scene.gd \
  project.godot; do
  ! grep -Fxq "$forbidden" <<<"$changed"
done
! grep -q '^data/episodes/' <<<"$changed"
! grep -q '^knowledge/base-pack/' <<<"$changed"
```

Expected: exit 0.

- [ ] **Step 3: 수동 UI QA를 실행한다**

해상도:

```text
1280×720
1920×1080
```

확인:

```text
3개 일정 선택과 결과 읽기
2주차 출동·지연
3주차 강제 출동 경고
모듈·공용 스킬 잠금·해금 표시
사건 화면 지원 조건·확률·준비도
지원 발동 feedback
사건 완료 뒤 연구·결산
Save/Load와 INCIDENT_ACTIVE 저장 비활성
Esc·포커스·스크롤
한국어 장문 줄바꿈
```

사람 눈 QA를 실행하지 못하면 PASS로 기록하지 않고 `NOT_RUN`으로 남긴다.

- [ ] **Step 4: Self-review를 수행한다**

```text
- 3주 PoC 수치가 최종 밸런스로 오인되지 않는가
- 모든 성장 효과가 정답이 아닌 정보·위험·피해에만 작용하는가
- 동료 지원이 capture mark·understanding·hypothesis를 변경하지 않는가
- 저장 복원 뒤 같은 event key가 재추첨되지 않는가
- 기본 CORE-MVP-001 진입이 변하지 않았는가
- 연도 결산이 최종 엔딩 문구를 사용하지 않는가
- 기존 save와 GameState를 참조하지 않는가
- 실패 결과도 연구 불가 사유·위험 사례·결산으로 진행되는가
```

- [ ] **Step 5: Draft PR을 연다**

PR 제목:

```text
feat: build annual raising vertical slice
```

PR 본문:

```text
## 목표
3주 육성→출동 준비→CORE-MVP-001→연구→분기 결산 인과를 검증한다.

## 핵심 구현
- 주간 일정·역량·피로·마감
- 장비 모듈과 오현 자동 지원
- 조건·확률·지원 준비도 공개
- 기존 CORE-MVP-001 session extension
- 사건 결과·연구·분기 결산
- 전용 save

## 보호 경계
- GameState·기존 사건·본편 save 미변경
- 기존 CORE focused 4/4 보호

## 검증
- Python 결과
- Godot import 결과
- CORE focused 결과
- ANNUAL focused 결과
- 전체 회귀 결과
- 사람 눈 QA 실행 여부

## 판정 경계
BUILD_READY는 자동 검증 통과를 뜻한다. 플레이 증거 없이 annual loop passed나 production expansion을 선언하지 않는다.
```

## Self-Review Checklist

- [ ] 모든 신규 파일 경로와 인터페이스가 Task에 정의돼 있다.
- [ ] JSON 고정 ID와 테스트가 일치한다.
- [ ] phase와 메서드 이름이 전 Task에서 동일하다.
- [ ] support effect 허용 키가 `health_restore`, `risk_reduction`으로 일치한다.
- [ ] 저장 가능 phase와 금지 phase가 명시돼 있다.
- [ ] 기존 CORE 기본 실행 회귀가 포함돼 있다.
- [ ] 보호 경로와 기존 저장 비침범 검사가 포함돼 있다.
- [ ] `TBD`, `TODO`, `similar to`, `appropriate error handling`이 없다.

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`.

1. Subagent-Driven (recommended) - task별 독립 구현·리뷰
2. Inline Execution - 현재 세션에서 batch별 실행·체크포인트 리뷰
