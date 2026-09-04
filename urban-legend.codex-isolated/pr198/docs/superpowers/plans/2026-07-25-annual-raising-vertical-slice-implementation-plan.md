# ANNUAL-MVP-001 연도제 육성 수직절편 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.  
> 상태: `PROPOSED_PLAN / NOT_IMPLEMENTED`  
> 선행 계획: `docs/superpowers/plans/2026-07-25-annual-design-canonical-migration-plan.md`

**Goal:** 3주의 주간 육성·출동 준비가 기존 CORE-MVP-001 사건의 정보량·위험·피해 관리에 영향을 주고, 사건 결과가 연구·보조 스킬·분기 결산으로 되돌아오는 독립 수직절편을 구현한다.

**Architecture:** `ANNUAL-MVP-001`은 본편 `GameState`와 저장을 사용하지 않는 격리 PoC다. `AnnualMvp001State`가 일정·성장·출동 마감·연구·분기 결산을 소유한다. `AnnualMvp001IncidentAdapter`는 육성 snapshot을 기존 CORE-MVP-001 데이터 override와 동료 지원 extension으로 변환한다. 기존 `CoreMvp001State`와 `CoreMvp001Scene`에는 기본 실행을 보존하는 선택적 확장점만 추가한다.

**Tech Stack:** Godot 4.7.1, GDScript, JSON, Python 3.12 `unittest`, Bash focused runner, GitHub Actions

## 1. 검증 질문과 판정 경계

### 검증 질문

> 육성·준비에서 내린 선택이 사건의 정보·위험·피해 관리에 체감 가능한 차이를 만들고, 사건 결과가 연구·스킬·분기 결산으로 되돌아오는가?

### 이 슬라이스가 검증하는 것

- 주간 계획과 권나래 성장의 인과
- 준비 기간과 사건 악화의 선택 비용
- 장비 모듈과 동료 자동 지원의 준비 가치
- CORE-MVP-001 사건 결과의 연구·결산 환류
- 실패 결과를 수용한 진행
- 전용 저장의 격리와 난수 재현성

### 이 슬라이스가 검증하지 않는 것

- 1년 4분기 전체 캠페인
- 핵심 사건용 신규 조작형 미니게임 제작
- 동료 2명 동시 편성
- 관계·로맨스 완성도
- 중형·소형 사건 제작성
- 본편 저장 이관
- 최종 수치 밸런스

CORE-MVP-001의 버튼형 현장 검증은 사건 코어 연결 자산으로 재사용한다. 승인 설계의 대표 조작형 미니게임은 제거되지 않으며, 별도 사건 제작 슬라이스에서 검증한다. 이 PoC 통과만으로 전체 핵심 사건 형식이 완성됐다고 판정하지 않는다.

## 2. 전역 제약

- 공식 기관명은 `괴이 기록국`, 직접 육성 주인공은 권나래다.
- 플레이어는 회수 전투에서 권나래만 직접 명령한다.
- 동료는 고유 스킬과 장착한 공용 보조 스킬을 조건부 자동 발동한다.
- 발동 조건·현재 확률·지원 준비도·남은 횟수를 UI에 공개한다.
- 지원은 체력 회복과 위험 완화만 수행한다.
- 지원은 단서, 가설, 이해도, 전조 정답, 포획 표식을 변경하지 않는다.
- 성장 수치는 핵심 단서·가설 정합성·정답을 변경하지 않는다.
- 기존 `관측 → 가설 → 현장 검증 → 전조 → 대응 → 포획 → 매뉴얼` 인과를 유지한다.
- 기존 `scripts/core/game_state.gd`, `data/episodes/**`, 기존 조사·회수 장면, `project.godot`, `knowledge/base-pack/**`를 변경하지 않는다.
- 기존 저장 `mvp-039`와 `mvp-038` 이관을 읽거나 쓰지 않는다.
- 전용 저장은 `user://annual_mvp_001_poc.json`만 사용한다.
- 사건 진행 중 저장은 제공하지 않는다.
- 기존 CORE-MVP-001 F1 진입과 기본 결과는 변경 전과 동일해야 한다.
- 기존 CORE-MVP-001 집중 테스트 4/4와 전체 Godot 회귀 43/43을 보호한다.
- 3주·주당 3슬롯과 아래 수치는 PoC 검증값이며 최종 캠페인 밸런스가 아니다.

## 3. PoC 범위

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
2주차 자율 출동·3주차 지연 위험·강제 출동
CORE-MVP-001 데이터 override와 embedded Scene
사건 결과 반환
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
신규 조작형 미니게임
본편 save migration
기존 GameState 통합
개인 돈·상점
동료 상세 스탯·개인 일정
턴 중 장비 교체
최종 엔딩
```

## 4. 파일 경계

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

## 5. 상태·인터페이스 계약

### 공개 phase

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

### 공통 명령 응답

```gdscript
{
    "ok": true,
    "error": "",
    "state_changed": true,
    "events": [],
    "snapshot": {}
}
```

### `AnnualMvp001State`

```gdscript
class_name AnnualMvp001State
extends RefCounted

func start(config: Dictionary, run_seed: int = 2001) -> Dictionary
func get_snapshot() -> Dictionary
func commit_week(activity_ids: Array[String]) -> Dictionary
func acknowledge_week_result() -> Dictionary
func choose_deployment_decision(decision_id: String) -> Dictionary
func complete_research_project(project_id: String) -> Dictionary
func configure_loadout(companion_id: String, public_skill_id: String, module_ids: Array[String]) -> Dictionary
func begin_incident() -> Dictionary
func apply_incident_result(result: Dictionary, manual_delta: Dictionary, support_log: Array[Dictionary]) -> Dictionary
func confirm_quarter_summary() -> Dictionary
func build_save_payload() -> Dictionary
func restore(config: Dictionary, payload: Dictionary) -> Dictionary
```

### phase 전이

```text
BOOT --start--> WEEK_PLANNING
WEEK_PLANNING --commit_week--> WEEK_RESULT
WEEK_RESULT --acknowledge week 1--> WEEK_PLANNING week 2
WEEK_RESULT --acknowledge week 2/3--> DEPLOYMENT_DECISION
DEPLOYMENT_DECISION --delay week 2--> WEEK_PLANNING week 3
DEPLOYMENT_DECISION --deploy/delay at deadline--> PREPARATION
PREPARATION --complete research/configure/begin--> INCIDENT_ACTIVE
INCIDENT_ACTIVE --apply result--> INCIDENT_RESULT
INCIDENT_RESULT --acknowledge--> POST_INCIDENT_RESEARCH
POST_INCIDENT_RESEARCH --complete or skip--> QUARTER_SUMMARY
QUARTER_SUMMARY --confirm--> COMPLETE
```

---

### Task 1: JSON 데이터 계약

**Files:**
- Create: `data/poc/annual_mvp_001/spring_vertical_slice.json`
- Create: `tests/test_annual_mvp_001_data_contract.py`

**Interfaces:**
- Consumes: 승인 설계의 일정·성장·연구·동료·장비 구조
- Produces: 신규 런타임의 고정 config

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

    def test_campaign_shape(self) -> None:
        self.assertEqual("annual-mvp-001-v1", self.data["contract_version"])
        campaign = self.data["campaign"]
        self.assertEqual(3, campaign["max_weeks"])
        self.assertEqual(3, campaign["slots_per_week"])
        self.assertEqual(2, campaign["voluntary_entry_week"])
        self.assertEqual(3, campaign["deadline_week"])
```

- [ ] **Step 2: 수량·ID·참조 테스트를 추가한다**

```python
def test_fixed_counts(self) -> None:
    self.assertEqual(7, len(self.data["activities"]))
    self.assertEqual(1, len(self.data["companions"]))
    self.assertEqual(3, len(self.data["support_skills"]))
    self.assertEqual(1, len(self.data["base_equipment"]))
    self.assertEqual(1, len(self.data["modules"]))
    self.assertEqual(2, len(self.data["research_projects"]))


def test_ids_and_references(self) -> None:
    groups = (
        "activities", "companions", "support_skills",
        "base_equipment", "modules", "research_projects",
    )
    ids = [entry["id"] for group in groups for entry in self.data[group]]
    self.assertEqual(len(ids), len(set(ids)))
    self.assertTrue(all(value.startswith("annual001_") for value in ids))

    skills = {entry["id"] for entry in self.data["support_skills"]}
    modules = {entry["id"] for entry in self.data["modules"]}
    companion = self.data["companions"][0]
    self.assertIn(companion["unique_skill_id"], skills)
    for skill_id in companion["allowed_public_skill_ids"]:
        self.assertIn(skill_id, skills)
    for project in self.data["research_projects"]:
        for module_id in project.get("unlock_module_ids", []):
            self.assertIn(module_id, modules)
        for skill_id in project.get("unlock_skill_ids", []):
            self.assertIn(skill_id, skills)
```

- [ ] **Step 3: Red를 확인한다**

Run:

```bash
python -m unittest tests/test_annual_mvp_001_data_contract.py -v
```

Expected: `FileNotFoundError`.

- [ ] **Step 4: 고정 config를 작성한다**

Campaign:

```json
{
  "id": "annual001_spring_slice",
  "max_weeks": 3,
  "slots_per_week": 3,
  "voluntary_entry_week": 2,
  "deadline_week": 3,
  "week_3_entry_risk": 15,
  "forced_entry_risk": 30,
  "incident_case_path": "res://data/poc/core_mvp_001/afterlife_station_poc.json"
}
```

Starting state:

```json
{
  "competencies": {
    "observation": 1,
    "analysis": 1,
    "field_response": 1,
    "interpersonal": 1
  },
  "fatigue": 10,
  "institution_support": 0,
  "residual_data": 0,
  "companion_trust": {"annual001_companion_oh_hyun": 0}
}
```

Fixed IDs:

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

Equipment / module
annual001_equipment_field_recorder
annual001_module_signal_buffer

Research
annual001_research_signal_buffer
annual001_research_ticket_protocol
```

Activity deltas:

```text
observation_drill: observation +1, fatigue +12
analysis_desk: analysis +1, fatigue +10
field_training: field_response +1, fatigue +15, institution_support +1
interview_duty: interpersonal +1, fatigue +10, institution_support +1
signal_research: annual001_research_signal_buffer progress +1, fatigue +10
companion_drill: 오현 trust +1, fatigue +8
rest: fatigue -25
```

Ranges:

```text
competency 0~5
fatigue 0~100
institution_support 0~3
trust 0~3
```

Research:

```text
annual001_research_signal_buffer
- timing: pre_incident
- progress_required: 2
- unlock: annual001_module_signal_buffer

annual001_research_ticket_protocol
- timing: post_incident
- residual_data_cost: 1
- required_manual_status: verified
- unlock: annual001_skill_signal_cross_check
```

Support skills:

```text
annual001_skill_procedural_check
- type unique
- trigger omen_failed
- base_chance 40
- readiness_gain 30
- readiness_max 90
- risk_reduction 4
- battle_limit 2

annual001_skill_emergency_cover
- type public / institution
- unlock institution_support >= 1
- trigger damage_at_least_12
- base_chance 50
- readiness_gain 25
- readiness_max 100
- health_restore 6, risk_reduction 4
- battle_limit 2

annual001_skill_signal_cross_check
- type public / research
- trigger first_hidden_pattern_resolved
- base_chance 55
- readiness_gain 25
- readiness_max 100
- health_restore 4, risk_reduction 6
- battle_limit 1
```

- [ ] **Step 5: Green을 확인한다**

Run:

```bash
python -m unittest tests/test_annual_mvp_001_data_contract.py -v
```

Expected: `OK`.

- [ ] **Step 6: 커밋한다**

```bash
git add data/poc/annual_mvp_001/spring_vertical_slice.json tests/test_annual_mvp_001_data_contract.py
git commit -m "test: define annual mvp 001 data contract"
```

---

### Task 2: 데이터 로더·검증기

**Files:**
- Create: `scripts/poc/annual_mvp_001/annual_mvp_001_data.gd`
- Create: `tests/annual_mvp_001_data_test.gd`

**Interfaces:**

```gdscript
class_name AnnualMvp001Data
extends RefCounted

static func load_config(path: String) -> Dictionary
static func validate_config(data: Dictionary) -> Array[String]
static func index_by_id(entries: Array) -> Dictionary
```

- [ ] **Step 1: 정상·오류 fixture 테스트를 작성한다**

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

- [ ] **Step 2: preload 실패를 확인한다**

Run:

```bash
"${GODOT_BIN:-godot}" --headless --path . --script res://tests/annual_mvp_001_data_test.gd
```

Expected: 신규 script preload 실패.

- [ ] **Step 3: 검증기를 구현한다**

검사항목:

```text
contract_version
3주·3슬롯·2주 자율 출동·3주 마감
고정 수량
annual001_ ID prefix와 중복
companion skill 참조
research unlock 참조
activity delta 필드·수치 범위
skill chance 0~100
readiness gain 양수
readiness max 1~100
effect key는 health_restore·risk_reduction만 허용
incident_case_path 파일 존재
```

- [ ] **Step 4: Green을 확인한다**

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

### Task 3: 주간 육성·마감·연구·결산 상태 머신

**Files:**
- Create: `scripts/poc/annual_mvp_001/annual_mvp_001_state.gd`
- Create: `tests/annual_mvp_001_state_test.gd`

**Interfaces:**
- Consumes: 검증된 annual config
- Produces: 일정·성장·출동·연구·결산 snapshot

Snapshot keys:

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
completed_research_ids
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

- [ ] **Step 1: 초기 상태 Red 테스트를 작성한다**

```gdscript
extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const State = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_state.gd")

func _init() -> void:
    var config := Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
    var state := State.new()
    assert(state.start(config, 2001)["ok"])
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

- [ ] **Step 3: `start`, `get_snapshot`, 공통 응답을 구현한다**

- config deep copy
- 모든 mutable collection deep copy
- 실패 명령은 snapshot 불변
- run seed 저장

- [ ] **Step 4: `commit_week`를 구현한다**

계약:

```text
WEEK_PLANNING에서만 실행
정확히 3개 activity ID 필요
같은 활동 중복 허용
입력 순서대로 delta 적용
competency 0~5 clamp
fatigue 0~100 clamp
institution support 0~3 clamp
trust 0~3 clamp
슬롯 시작 피로 60 이상이면 해당 슬롯의 양수 competency 증가를 1 감소, 최소 0
rest는 항상 실행 가능
결과·delta를 last_week_result에 기록
성공 뒤 WEEK_RESULT
```

테스트:

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

- [ ] **Step 5: 주차 확인과 출동 결정을 구현한다**

```text
week 1 result 확인 → week 2 WEEK_PLANNING
week 2 result 확인 → DEPLOYMENT_DECISION
week 2 deploy → PREPARATION, risk 0
week 2 delay → week 3 WEEK_PLANNING
week 3 deploy → PREPARATION, risk 15
week 3 delay → PREPARATION, risk 30, forced_deployment true
```

Decision IDs:

```text
annual001_decision_deploy
annual001_decision_delay
```

- [ ] **Step 6: `complete_research_project`를 구현한다**

Pre-incident:

```text
phase PREPARATION
annual001_research_signal_buffer progress >= 2
완료 시 module unlock
residual data 비용 없음
```

Post-incident:

```text
phase POST_INCIDENT_RESEARCH
annual001_research_ticket_protocol
residual_data >= 1
manual status verified
완료 시 residual_data -1, public skill unlock
```

같은 연구의 중복 완료는 상태 불변 성공으로 처리한다.

- [ ] **Step 7: loadout을 구현한다**

```text
companion은 annual001_companion_oh_hyun만 허용
unique skill은 자동 고정
public skill 슬롯 1개
module 슬롯 1개
해금되지 않은 skill/module 거부
public skill 공란 허용
module 빈 배열 허용
```

- [ ] **Step 8: 사건 handoff와 결과 환류를 구현한다**

`begin_incident()` 성공 응답 event payload:

```gdscript
{
    "event": "annual_incident_requested",
    "case_path": "res://data/poc/core_mvp_001/afterlife_station_poc.json",
    "run_seed": 2001
}
```

`apply_incident_result()`:

```text
normal capture → residual_data +2, institution_support +1
costly capture → residual_data +1
emergency capture → residual_data +1, institution_support -1
manual verified → ticket protocol 연구 가능
manual candidate → 연구 잠금 사유와 위험 사례를 결산에 보존
성공 뒤 INCIDENT_RESULT
```

- [ ] **Step 9: 사후 연구 확인과 분기 결산을 구현한다**

`acknowledge_week_result()`는 INCIDENT_RESULT에서도 호출 가능하게 하지 않는다. 별도 내부 명령을 추가하지 않고 Scene은 `complete_research_project` 또는 `confirm_quarter_summary` 전에 state helper `advance_from_incident_result()`를 호출해야 한다.

공개 인터페이스에 다음을 추가한다.

```gdscript
func advance_from_incident_result() -> Dictionary
func skip_post_incident_research() -> Dictionary
```

Quarter summary:

```text
weeks_used
forced_deployment
competency_focus
fatigue_band
companion_trust
recovery_quality
knowledge_quality
support_trigger_count
completed_research_ids
unlocked_module_ids
unlocked_skill_ids
next_cycle_flags
```

Flags:

```text
annual001_flag_signal_module_known
annual001_flag_ticket_protocol_known
annual001_flag_emergency_deployment
annual001_flag_manual_candidate
annual001_flag_manual_verified
```

- [ ] **Step 10: 전체 상태 경로를 테스트한다**

테스트는 다음 세 경로를 포함한다.

```text
week 2 early deployment + normal verified result
week 3 voluntary deployment + costly candidate result
week 3 forced deployment + emergency result
```

- [ ] **Step 11: Green을 확인한다**

Run:

```bash
"${GODOT_BIN:-godot}" --headless --path . --script res://tests/annual_mvp_001_state_test.gd
```

Expected: `ANNUAL MVP 001 STATE: PASS`.

- [ ] **Step 12: 커밋한다**

```bash
git add scripts/poc/annual_mvp_001/annual_mvp_001_state.gd tests/annual_mvp_001_state_test.gd
git commit -m "feat: add annual schedule and quarter state"
```

---

### Task 4: 동료 지원 resolver

**Files:**
- Create: `scripts/poc/annual_mvp_001/annual_mvp_001_support_resolver.gd`
- Create: `tests/annual_mvp_001_support_resolver_test.gd`

**Interfaces:**

```gdscript
class_name AnnualMvp001SupportResolver
extends RefCounted

func start(
    skill_entries: Array[Dictionary],
    trust: int,
    interpersonal: int,
    run_seed: int,
    test_rolls: Array[int] = []
) -> Dictionary
func resolve(event_key: String, context: Dictionary) -> Array[Dictionary]
func get_snapshot() -> Dictionary
```

`test_rolls`는 테스트 전용이다. production에서는 빈 배열을 전달하고 seeded `RandomNumberGenerator`를 사용한다.

- [ ] **Step 1: 같은 event key 캐시 Red 테스트를 작성한다**

```gdscript
var resolver := Resolver.new()
resolver.start(skills, 0, 1, 2001, [100])
var context := {"event": "omen_read", "success": false}
var first := resolver.resolve("omen:1:poc001_pattern_false_terminal", context)
var second := resolver.resolve("omen:1:poc001_pattern_false_terminal", context)
assert(first == second)
```

- [ ] **Step 2: 준비도 보장 Red 테스트를 작성한다**

Fixture:

```text
base_chance 0
readiness_gain 50
readiness_max 100
test_rolls [100, 100, 100]
```

Expected:

```text
event 1 miss → readiness 50
event 2 miss → readiness 100
event 3 guaranteed trigger → readiness 0
```

- [ ] **Step 3: 확률·준비도 계약을 구현한다**

```text
current_chance = min(100, base_chance + trust * 5 + interpersonal_bonus + readiness)
interpersonal_bonus = 5 when interpersonal >= 2, otherwise 0
readiness >= readiness_max면 roll 전에 guaranteed
miss면 readiness = min(max, readiness + gain)
trigger면 readiness = 0
battle_limit 도달 뒤 부적합 처리
```

Trust 2 이상이면 unique skill의 첫 적합 event에 전투당 1회 signature guarantee를 사용한다.

- [ ] **Step 4: trigger 조건을 구현한다**

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

- [ ] **Step 5: 결과 형식을 고정한다**

```gdscript
{
    "skill_id": "annual001_skill_emergency_cover",
    "eligible": true,
    "triggered": true,
    "chance": 65,
    "roll": 31,
    "readiness_before": 25,
    "readiness_after": 0,
    "guaranteed": false,
    "effect": {"health_restore": 6, "risk_reduction": 4},
    "event_key": "action:3:poc001_pattern_ticket_imprint:poc001_action_guard"
}
```

부적합 event는 캐시하지 않는다. 적합 event는 성공·실패를 모두 캐시한다.

- [ ] **Step 6: 같은 seed·같은 event 순서 재현성을 테스트한다**

두 resolver를 같은 seed로 시작해 같은 context 순서를 입력하고 snapshot과 결과가 동일한지 검사한다. 이 PoC는 사건 중 저장을 지원하지 않으므로 resolver cache를 파일 저장하지 않는다. 사건 시작 전 save를 다시 불러오면 저장된 run seed와 동일한 입력 순서로 같은 판정열을 재현한다.

- [ ] **Step 7: Green을 확인한다**

Run:

```bash
"${GODOT_BIN:-godot}" --headless --path . --script res://tests/annual_mvp_001_support_resolver_test.gd
```

Expected: `ANNUAL MVP 001 SUPPORT: PASS`.

- [ ] **Step 8: 커밋한다**

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
- Consumes: 기존 CORE-MVP-001 상태·Scene
- Produces: 선택적 외부 지원 효과, session override, 완료 signal

- [ ] **Step 1: 기존 기본 실행 회귀를 먼저 고정한다**

```gdscript
var state := State.new()
assert(state.start(case_data, 1001)["ok"])
assert(state.get_snapshot()["health"] == 100)
assert(state.get_snapshot()["risk"] == 0)
```

기존 정상·비용·긴급 포획 테스트도 변경 전 결과를 유지한다.

- [ ] **Step 2: 외부 지원 중복 적용 Red 테스트를 추가한다**

```gdscript
var first := state.apply_external_support(
    "annual001_skill_emergency_cover",
    "action:3:poc001_pattern_ticket_imprint:poc001_action_guard",
    {"health_restore": 6, "risk_reduction": 4}
)
var second := state.apply_external_support(
    "annual001_skill_emergency_cover",
    "action:3:poc001_pattern_ticket_imprint:poc001_action_guard",
    {"health_restore": 6, "risk_reduction": 4}
)
assert(first["ok"])
assert(second["ok"])
assert(second["state_changed"] == false)
```

- [ ] **Step 3: State 확장 메서드를 구현한다**

```gdscript
func apply_external_support(source_id: String, event_key: String, effect: Dictionary) -> Dictionary
```

계약:

```text
recovery 관련 phase에서만 허용
source_id·event_key 필수
health_restore·risk_reduction 외 key 거부
음수 효과 거부
health는 starting_health 초과 금지
risk는 0 미만 금지
동일 event_key 중복 적용 금지
understanding·hypothesis·observed pattern·capture mark 변경 금지
external_support_applied event 반환
```

Snapshot에 `applied_external_support_event_keys`를 추가한다.

- [ ] **Step 4: Scene 구성 Red 테스트를 추가한다**

```gdscript
var scene := SceneScript.new()
scene.configure_session(case_override, 3001, extension)
root.add_child(scene)
await process_frame
assert(scene.debug_snapshot()["risk"] == 15)
```

- [ ] **Step 5: Scene 확장 인터페이스를 구현한다**

```gdscript
signal session_completed(
    result: Dictionary,
    manual_delta: Dictionary,
    support_log: Array[Dictionary]
)

func configure_session(
    case_data_override: Dictionary,
    run_seed: int = 1001,
    session_extension: Object = null
) -> void
```

계약:

```text
configure_session은 tree 진입 전에만 허용
override가 비면 기존 JSON load
extension은 선택적 duck-typed object
extension.after_omen(state, snapshot_before, omen_result)
extension.after_recovery_action(state, snapshot_before, action_id, action_result)
extension.get_status_lines()
COMPLETE 최초 진입 시 session_completed 1회 emit
기본 F1 진입은 extension 없이 기존 동작 유지
```

Scene에는 `ExtensionStatusLabel`을 추가한다. 이 Label은 extension 문구만 표시하며 행동 버튼을 추가하거나 정답을 강조하지 않는다.

- [ ] **Step 6: 기존 focused suite를 실행한다**

Run:

```bash
GODOT_BIN="${GODOT_BIN:-godot}" tests/run_core_mvp_001_tests.sh
```

Expected: `CORE-MVP-001 focused suite: 4/4 passed`.

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

### Task 6: Incident adapter

**Files:**
- Create: `scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd`
- Create: `tests/annual_mvp_001_incident_adapter_test.gd`

**Interfaces:**

```gdscript
class_name AnnualMvp001IncidentAdapter
extends RefCounted

func configure(config: Dictionary, annual_snapshot: Dictionary, run_seed: int) -> Dictionary
func build_case_override(base_case: Dictionary) -> Dictionary
func after_omen(state: Object, snapshot_before: Dictionary, omen_result: Dictionary) -> Array[Dictionary]
func after_recovery_action(
    state: Object,
    snapshot_before: Dictionary,
    action_id: String,
    action_result: Dictionary
) -> Array[Dictionary]
func get_status_lines() -> Array[String]
func get_support_log() -> Array[Dictionary]
func build_annual_reward(result: Dictionary, manual_delta: Dictionary) -> Dictionary
```

- [ ] **Step 1: case override Red 테스트를 작성한다**

```gdscript
var annual_snapshot := {
    "competencies": {
        "observation": 2,
        "analysis": 2,
        "field_response": 2,
        "interpersonal": 2,
    },
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

- [ ] **Step 2: 변환 규칙을 구현한다**

```text
fatigue 0~40 → starting health 100
41~50 → 95
51~60 → 90
61~70 → 85
71~80 → 80
81~100 → 75

deployment risk를 starting risk에 더하고 100 clamp
observation >= 2 → clue·likely omen rate +10, likely 최대 90
field_response >= 2 → field test damage와 recovery failure damage -4, 최소 0
signal buffer module → hidden first observation damage cap 18에서 12
analysis >= 2 → 중립 분석 메모 추가
```

중립 분석 메모:

```text
전광판 변동 기록과 방송 원본의 불일치 항목을 분리해 비교할 수 있다.
```

이 메모는 어느 가설이 옳은지, 어떤 행동이 유효한지 표시하지 않는다.

- [ ] **Step 3: support hook을 구현한다**

Event keys:

```text
omen:{turn}:{pattern_id}
action:{turn}:{pattern_id}:{action_id}
```

Resolver 결과가 triggered면 `state.apply_external_support`를 호출하고 다음을 support log에 저장한다.

```text
skill_id
turn
pattern_id
event_key
chance
roll
readiness_before
readiness_after
guaranteed
effect
```

- [ ] **Step 4: 상태 문구를 구현한다**

```text
오현 · 절차 교차 확인 | 조건: 전조 해석 실패 | 확률 55% | 준비도 30/90 | 남은 1회
공용 · 긴급 엄호 | 조건: 피해 12 이상 | 확률 65% | 준비도 0/100 | 남은 2회
```

- [ ] **Step 5: annual reward를 구현한다**

```gdscript
{
    "recovery_quality": result["recovery_quality"],
    "knowledge_quality": manual_delta["status"],
    "residual_data_gain": 2,
    "institution_support_delta": 1,
    "danger_case_count": manual_delta["danger_cases"].size(),
}
```

Quality별 gain은 `AnnualMvp001State.apply_incident_result` 계약과 일치해야 한다.

- [ ] **Step 6: Green을 확인한다**

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
assert(SaveData.read_payload(path) == payload)
```

- [ ] **Step 2: 저장 계약을 구현한다**

```text
save_version annual-mvp-001-save-v1 필수
INCIDENT_ACTIVE 저장 거부
run_seed 보존
week·phase·육성·연구·loadout·결산 상태 보존
기존 GameState save path 문자열 참조 금지
깨진 JSON은 {}
temp file 작성 후 rename으로 원자 교체
```

- [ ] **Step 3: 재추첨 방지 테스트를 작성한다**

```text
1. PREPARATION save 작성
2. 같은 save를 두 개의 State로 restore
3. 두 adapter를 저장된 같은 run seed로 configure
4. 같은 사건 event 순서를 입력
5. support chance·roll·trigger·readiness 결과가 동일
```

사건 중간 save는 없으므로 resolver cache를 디스크에 저장하지 않는다. 사건 재시작은 같은 seed와 같은 입력 순서에서 같은 결과를 내며, 다른 결과가 나올 때까지 반복 load하는 재추첨을 허용하지 않는다.

- [ ] **Step 4: Green을 확인한다**

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
- Consumes: annual state, adapter, save data, CORE-MVP-001 PackedScene
- Produces: 주간 계획→준비→사건→연구→결산 단일 UI

Required nodes:

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

- [ ] **Step 1: node·viewport Red 테스트를 작성한다**

테스트 해상도:

```text
1280×720
1920×1080
```

`SafeFrame`, `Footer`, 현재 panel이 viewport 안에 있어야 한다.

- [ ] **Step 2: phase별 panel 하나만 표시한다**

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

```text
7개 activity 버튼
선택 순서 1/3·2/3·3/3
같은 활동 중복 허용
계획 확정 전 state 불변
결과 panel에 역량·피로·기관 지원·신뢰 delta 표시
```

- [ ] **Step 4: 출동 결정·준비 UI를 구현한다**

```text
week 2: 지금 출동 / 1주 더 준비
week 3: 지금 출동 / 지연 시 긴급 출동 경고
오현 고유 스킬 고정
공용 스킬 공란 또는 긴급 엄호
기본 장비 현장 기록기 고정
모듈 공란 또는 신호 완충
사건 시작 health·risk·omen 보정 preview
```

- [ ] **Step 5: embedded CORE-MVP-001을 실행한다**

```gdscript
var packed := preload("res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn")
var incident := packed.instantiate() as CoreMvp001Scene
incident.configure_session(case_override, run_seed, adapter)
incident.session_completed.connect(_on_incident_completed)
_incident_host.add_child(incident)
```

완료 signal에서 adapter reward를 만들고 `state.apply_incident_result`를 호출한다.

- [ ] **Step 6: 지원 상태와 발동 결과를 표시한다**

Extension status:

```text
skill name
trigger condition
current chance
readiness
remaining uses
```

발동 feedback은 스킬명과 `체력 +N / 위험 -N`만 표시한다. 유효 행동명이나 정답은 추가하지 않는다.

- [ ] **Step 7: 사후 연구·분기 결산 UI를 구현한다**

```text
verified + residual data 1이면 ticket protocol 연구 가능
candidate면 잠금 사유와 위험 사례 수 표시
연구를 건너뛰는 선택 제공
결산은 성장 방향·출동 시점·회수 품질·지식 품질·동료 협업·해금 결과를 6~10문장으로 표시
다음 해 시작 버튼 없이 PoC 완료
```

연도 결산이 아니라 **분기 결산 모형**임을 화면에 명시한다.

- [ ] **Step 8: 저장 UI를 구현한다**

```text
INCIDENT_ACTIVE에서 SaveButton disabled
그 외 허용 phase에서 save
load 시 Scene을 state snapshot에서 재구성
기존 GameState와 본편 save를 조회하지 않음
```

- [ ] **Step 9: Green을 확인한다**

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

### Task 9: 개발 진입점·회귀 등록

**Files:**
- Modify: `scripts/ui/main_menu.gd`
- Modify: `tests/run_godot_regression.sh`
- Modify: `tests/test_active_document_references.py`

- [ ] **Step 1: F1 진입 Red 테스트를 추가한다**

```python
def test_annual_mvp_001_dev_entry_exists(self) -> None:
    menu = (ROOT / "scripts/ui/main_menu.gd").read_text(encoding="utf-8")
    self.assertIn("ANNUAL-MVP-001 육성→사건→연구 PoC", menu)
    self.assertIn(
        "res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn",
        menu,
    )
```

- [ ] **Step 2: 기존 F1 패널에 버튼을 추가한다**

```gdscript
_add_scene_button(
    dev_content,
    "ANNUAL-MVP-001 육성→사건→연구 PoC",
    "res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn"
)
```

기존 CORE-MVP-001 버튼을 유지한다.

- [ ] **Step 3: 전체 runner에 신규 6개 테스트를 등록한다**

```text
annual_mvp_001_data_test
annual_mvp_001_state_test
annual_mvp_001_support_resolver_test
annual_mvp_001_incident_adapter_test
annual_mvp_001_save_data_test
annual_mvp_001_scene_test
```

기존 43개에 신규 6개를 더해 49개로 갱신한다.

- [ ] **Step 4: 보호 경로 정적 계약을 추가한다**

PR 변경 목록에 다음 경로가 없어야 한다.

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

### Task 10: Focused runner·CI

**Files:**
- Create: `tests/run_annual_mvp_001_tests.sh`
- Create: `.github/workflows/validate-annual-mvp-001.yml`

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
  HOME="$home_dir" \
  XDG_DATA_HOME="$home_dir/.local/share" \
  XDG_CONFIG_HOME="$home_dir/.config" \
  timeout 90 "$GODOT_BIN" --headless --path "$PROJECT_ROOT" \
    --script "res://tests/$name.gd"
done

echo "ANNUAL-MVP-001 focused suite: 6/6 passed"
```

- [ ] **Step 2: workflow를 작성한다**

Path triggers:

```text
data/poc/annual_mvp_001/**
scripts/poc/annual_mvp_001/**
scenes/poc/annual_mvp_001/**
scripts/poc/core_mvp_001/**
scripts/ui/main_menu.gd
tests/**
.github/workflows/validate-annual-mvp-001.yml
```

Job order:

```bash
python -m unittest tests/test_annual_mvp_001_data_contract.py tests/test_active_document_references.py -v
godot --headless --path . --import
bash tests/run_core_mvp_001_tests.sh
bash tests/run_annual_mvp_001_tests.sh
bash tests/run_godot_regression.sh
```

- [ ] **Step 3: concurrency와 failure artifact를 설정한다**

```yaml
concurrency:
  group: annual-mvp-001-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

실패할 때만 로그 artifact를 7일 보존한다.

- [ ] **Step 4: 로컬 검증을 실행한다**

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
Python failures 0, errors 0
CORE-MVP-001 4/4
ANNUAL-MVP-001 6/6
Godot regression 49/49
```

- [ ] **Step 5: 커밋한다**

```bash
git add tests/run_annual_mvp_001_tests.sh .github/workflows/validate-annual-mvp-001.yml
git commit -m "ci: validate annual mvp 001 vertical slice"
```

---

### Task 11: 상태 문서 갱신

**Files:**
- Modify: `TEST_CHECKLIST.md`
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Modify: `MVP_ROADMAP.md`

- [ ] **Step 1: 실제 결과만 기록한다**

```text
ANNUAL-MVP-001 implementation: BUILD_READY 또는 BUILD_BLOCKED
automated_verification: PASSED 또는 FAILED
human_visual_qa: 실제 상태
player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

- [ ] **Step 2: 구현·미구현 범위를 분리한다**

Implemented slice:

```text
3주·주당 3슬롯
권나래 역량 4종·피로
오현 1명·고유+공용 자동 지원
기본 장비·모듈 1개
출동 위험
CORE-MVP-001 embedded 실행
사건 결과·연구·분기 결산
전용 save
```

Not implemented:

```text
1년 4분기 전체
동료 2명
관계·로맨스
중형·소형 사건
신규 조작형 미니게임
본편 save integration
```

- [ ] **Step 3: 플레이 검증 질문을 기록한다**

```text
주간 선택과 사건 보정의 인과를 설명하는가
피로와 지연 위험이 준비 판단에 영향을 주는가
지원 확률·준비도가 공정하게 느껴지는가
지원이 정답 대체가 아니라 실패 비용 완화로 인식되는가
사건 결과가 연구·다음 준비로 되돌아온다고 느끼는가
분기 결산이 최종 엔딩이 아닌 중간 결과로 읽히는가
```

- [ ] **Step 4: 문서 계약을 실행한다**

```bash
python -m unittest tests/test_active_document_references.py -v
```

Expected: `OK`.

- [ ] **Step 5: 커밋한다**

```bash
git add TEST_CHECKLIST.md docs/CURRENT_STATUS.md docs/CURRENT_HANDOFF.md MVP_ROADMAP.md
git commit -m "docs: record annual mvp 001 build status"
```

---

### Task 12: 최종 검증·리뷰·Draft PR

**Files:**
- No new files

- [ ] **Step 1: 전체 자동 검증을 새 환경에서 실행한다**

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
Godot regression 49/49
git diff --check output empty
```

- [ ] **Step 2: 보호 경로 diff를 확인한다**

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

- [ ] **Step 3: 사람 눈 UI QA를 실행한다**

Resolutions:

```text
1280×720
1920×1080
```

Checks:

```text
3개 일정 선택과 결과 읽기
2주차 출동·지연
3주차 강제 출동 경고
모듈·공용 스킬 잠금·해금
사건 화면 지원 조건·확률·준비도
지원 발동 feedback
사건 완료 뒤 연구·분기 결산
Save/Load와 INCIDENT_ACTIVE 저장 비활성
Esc·포커스·스크롤
한국어 장문 줄바꿈
```

실행하지 못한 항목은 `NOT_RUN`으로 기록한다.

- [ ] **Step 4: 자체 리뷰를 수행한다**

```text
3주 PoC 수치가 최종 밸런스로 오인되지 않는가
성장 효과가 정답이 아닌 정보·위험·피해에만 작용하는가
동료 지원이 capture mark·understanding·hypothesis를 변경하지 않는가
같은 save·seed·입력 순서에서 지원 판정이 재현되는가
기본 CORE-MVP-001 진입이 변하지 않았는가
분기 결산이 최종 엔딩 문구를 사용하지 않는가
기존 save와 GameState를 참조하지 않는가
실패 결과도 잠금 사유·위험 사례·결산으로 진행되는가
신규 조작형 미니게임이 이 슬라이스의 통과 항목으로 잘못 기록되지 않았는가
```

- [ ] **Step 5: Draft PR을 연다**

Title:

```text
feat: build annual raising vertical slice
```

Body:

```text
## 목표
3주 육성→출동 준비→CORE-MVP-001→연구→분기 결산 인과를 검증한다.

## 핵심 구현
- 주간 일정·역량·피로·출동 마감
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
- 사람 눈 QA 상태

## 판정 경계
BUILD_READY는 자동 검증 통과를 뜻한다. 플레이 증거 없이 annual loop passed나 production expansion을 선언하지 않는다. 신규 조작형 미니게임은 이 PR의 검증 범위가 아니다.
```

## 실행 완료 조건

- [ ] 모든 신규 파일 경로와 인터페이스가 Task에 정의돼 있다.
- [ ] JSON 고정 ID와 테스트가 일치한다.
- [ ] phase와 메서드 이름이 모든 Task에서 동일하다.
- [ ] support effect 허용 키가 `health_restore`, `risk_reduction`으로 일치한다.
- [ ] 사건 중 저장 금지와 seed 재현성 계약이 일치한다.
- [ ] 기존 CORE 기본 실행 회귀가 포함돼 있다.
- [ ] 보호 경로와 기존 저장 비침범 검사가 포함돼 있다.
- [ ] 대표 조작형 미니게임 미검증 상태가 명시돼 있다.

## Execution Handoff

Plan saved to `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`.

Recommended execution order:

```text
1. 정본 전환 계획 실행·병합
2. 이 구현 계획 재검토
3. 격리 worktree에서 Task 1부터 TDD 실행
```
