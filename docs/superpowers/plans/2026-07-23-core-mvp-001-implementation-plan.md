# CORE-MVP-001 구현 계획

> 수행 방식: TDD, 작은 end-to-end 단위, 완료 전 독립 검증  
> 정본 명세: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`  
> 목표: 조사에서 작성한 규칙 가설이 회수 전투의 전조 정보 우위로 변환되고, 대응으로 포획 창을 여는 뾰족한 재미를 독립 PoC로 검증한다.  
> 현재 기준선: `MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039`

## 1. 보호 범위와 아키텍처

CORE-MVP-001에서는 다음을 수정하지 않는다.

```text
scripts/core/game_state.gd
data/episodes/**
scripts/scenes/investigation_scene.gd
scripts/scenes/battle_scene.gd
project.godot
knowledge/base-pack/**
```

현행 회수 화면은 안정도·공포·자동 예측·능력값·장비·소모품·미니게임 효과와 결합돼 있다. 직접 개조하면 조사-전투 인과 실험과 기존 캠페인 회귀가 동시에 오염된다. 따라서 다음 독립 구조를 사용한다.

```text
main_menu.gd의 debug 전용 버튼
→ scenes/poc/core_mvp_001/core_mvp_001_scene.tscn
→ CoreMvp001Scene
   ├─ CoreMvp001CaseData
   ├─ CoreMvp001State
   └─ CoreMvp001PlaytestLog
```

신규 경로:

```text
data/poc/core_mvp_001/
scripts/poc/core_mvp_001/
scenes/poc/core_mvp_001/
tests/core_mvp_001_*.gd
tests/test_core_mvp_001_*.py
```

## 2. 공통 검증 명령

```bash
python -m unittest tests/test_core_mvp_001_data_contract.py
GODOT_BIN="${GODOT_BIN:-godot}"
"$GODOT_BIN" --headless --path . --script res://tests/core_mvp_001_case_data_test.gd
"$GODOT_BIN" --headless --path . --script res://tests/core_mvp_001_state_test.gd
"$GODOT_BIN" --headless --path . --script res://tests/core_mvp_001_playtest_log_test.gd
"$GODOT_BIN" --headless --path . --script res://tests/core_mvp_001_scene_test.gd
GODOT_BIN="$GODOT_BIN" tests/run_godot_regression.sh
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py tests/test_core_validation_contract.py
git diff --check
```

Windows에서는 `GODOT_BIN`을 Godot 4.7 console 실행 파일로 지정한다.

---

## Task 1. PoC 사건 데이터 계약

### 파일

- Create: `data/poc/core_mvp_001/afterlife_station_poc.json`
- Create: `tests/test_core_mvp_001_data_contract.py`

### 실패 테스트

Python unittest로 다음을 먼저 고정한다.

- `contract_version == core-mvp-001-v1`
- 모든 ID가 `poc001_` 접두사이며 중복 없음
- 조사 장면 3, 단서 6, 선택지 4, 가설 2, 패턴 3
- 단서 역할이 지지 3·반박 2·미해결 1
- 논리 배제 가능한 선택지는 정확히 2개
- 모든 record·choice·clue·field test·pattern·action 참조가 해소됨
- 미관측 패턴 1개, 범용 대응 1개 이상, 최초 피해 상한 18
- 승리 계약에 `enemy_hp`가 없고 포획 표식 3개를 사용
- `recovery_sequence`가 정확히 5턴이며 미관측 패턴이 3턴과 5턴에 등장
- `capture_rule.min_capture_turn == 5`, `max_recovery_turn == 8`

핵심 테스트 구조:

```python
class CoreMvp001DataContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.data = json.loads(DATA_PATH.read_text(encoding="utf-8"))

    def test_exact_scope(self) -> None:
        self.assertEqual(len(self.data["investigation_scenes"]), 3)
        self.assertEqual(len(self.data["clues"]), 6)
        self.assertEqual(len(self.data["choices"]), 4)
        self.assertEqual(len(self.data["hypotheses"]), 2)
        self.assertEqual(len(self.data["recovery_patterns"]), 3)

    def test_unknown_pattern_is_recoverably_fair(self) -> None:
        hidden = [p for p in self.data["recovery_patterns"] if p.get("first_use_hidden")]
        self.assertEqual(len(hidden), 1)
        self.assertTrue(hidden[0]["generic_mitigation_action_ids"])
        self.assertLessEqual(hidden[0]["max_first_observation_damage"], 18)
```

### 정확한 ID

```text
Scenes
poc001_scene_broadcast_archive
poc001_scene_platform_display
poc001_scene_ticket_gate

Clues
poc001_clue_broadcast_blank          support
poc001_clue_reset_timing             support
poc001_clue_official_identifier      support
poc001_clue_display_mismatch         contradiction
poc001_clue_passenger_count          contradiction
poc001_question_ticket_trigger       unresolved

Manual records
poc001_manual_early_movement_reset
poc001_manual_personal_destination
poc001_manual_ticket_contact_danger

Choices
poc001_choice_move_before_end        eliminated
poc001_choice_follow_passenger_count eliminated
poc001_choice_follow_display         hypothesis A
poc001_choice_hold_official_signal   hypothesis B

Hypotheses
poc001_hypothesis_display_route
poc001_hypothesis_broadcast_blank

Patterns
poc001_pattern_false_terminal
poc001_pattern_boundary_fold
poc001_pattern_ticket_imprint

Actions
poc001_action_observe
poc001_action_guard
poc001_action_cover
poc001_action_protect_trace
poc001_action_hold_position
poc001_action_fix_boundary
poc001_action_isolate_ticket
poc001_action_capture
```

회수 순서:

```json
[
  "poc001_pattern_false_terminal",
  "poc001_pattern_boundary_fold",
  "poc001_pattern_ticket_imprint",
  "poc001_pattern_false_terminal",
  "poc001_pattern_ticket_imprint"
]
```

### 실행

```bash
python -m unittest tests/test_core_mvp_001_data_contract.py
```

Expected: 첫 실행은 데이터 파일 부재로 실패, 데이터 작성 뒤 `Ran ... tests / OK`.

### Commit

```bash
git add data/poc/core_mvp_001/afterlife_station_poc.json tests/test_core_mvp_001_data_contract.py
git commit -m "test: define core mvp 001 case contract"
```

---

## Task 2. 데이터 로더와 런타임 검증기

### 파일

- Create: `scripts/poc/core_mvp_001/core_mvp_001_case_data.gd`
- Create: `tests/core_mvp_001_case_data_test.gd`
- Modify: `tests/run_godot_regression.sh`

### 인터페이스

```gdscript
class_name CoreMvp001CaseData
extends RefCounted

static func load_case(path: String) -> Dictionary
static func validate_case(data: Dictionary) -> Array[String]
static func index_by_id(entries: Array) -> Dictionary
```

`load_case`는 파일·JSON·계약 오류 시 `{}`를 반환한다. `validate_case`는 사람이 읽을 수 있는 오류 배열을 반환한다.

### 테스트

- 정상 JSON 로드
- `poc001_`가 아닌 ID 거부
- 중복 ID 거부
- 존재하지 않는 record·choice·action 참조 거부
- 잘못된 회수 순서 거부
- 범용 방어가 없는 미관측 패턴 거부

테스트 runner는 `SceneTree`를 확장하고 성공 시 다음을 출력한다.

```text
CORE MVP 001 CASE DATA: PASS
```

### 최소 구현 핵심

```gdscript
static func load_case(path: String) -> Dictionary:
    if not FileAccess.file_exists(path):
        return {}
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return {}
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if typeof(parsed) != TYPE_DICTIONARY:
        return {}
    var data: Dictionary = parsed
    return data if validate_case(data).is_empty() else {}
```

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_case_data.gd tests/core_mvp_001_case_data_test.gd tests/run_godot_regression.sh
git commit -m "feat: add core mvp 001 case loader"
```

---

## Task 3. 조사 배제 상태 머신

### 파일

- Create: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`
- Create: `tests/core_mvp_001_state_test.gd`

### 인터페이스

```gdscript
class_name CoreMvp001State
extends RefCounted

enum Phase {
    BOOT,
    ELIMINATION,
    HYPOTHESIS_AUTHORING,
    FIELD_TEST,
    HYPOTHESIS_REFRESH,
    RECOVERY_READY,
    EMERGENCY_RECOVERY,
    RECOVERY_TURN_START,
    OMEN_READ,
    RESPONSE_SELECTION,
    CAPTURE_WINDOW,
    EMERGENCY_CAPTURE,
    RESULT_COMPARE,
    MANUAL_PROMOTION,
    COMPLETE
}

func start(case_data: Dictionary, run_seed: int = 1001) -> void
func get_snapshot() -> Dictionary
func link_record_to_choice(record_id: String, choice_id: String) -> Dictionary
func advance_to_hypothesis() -> Dictionary
```

명령 공통 응답:

```gdscript
{
    "ok": true,
    "error": "",
    "state_changed": true,
    "events": [],
    "snapshot": {}
}
```

### 테스트

- 시작 시 선택지 4개, 배제 0개, 체력 100, 위험도 0
- 유효한 record-choice 쌍만 배제
- 같은 배제 반복 시 중복 없음
- 부적합 연결은 `ok=false`, `state_changed=false`
- 부적합 연결 전후 체력·위험·단계 동일
- 서로 다른 2개 배제 뒤에만 가설 단계 진입
- 경쟁 가설 두 선택지는 배제 불가

### 핵심 구현

```gdscript
func link_record_to_choice(record_id: String, choice_id: String) -> Dictionary:
    if _phase != Phase.ELIMINATION:
        return _reply(false, "기록 연결 단계가 아닙니다.")
    var key := "%s|%s" % [record_id, choice_id]
    if not _elimination_rule_by_pair.has(key):
        return _reply(false, "이 기록은 해당 선택지를 배제하지 못합니다.")
    if not _eliminated_choice_ids.has(choice_id):
        _eliminated_choice_ids.append(choice_id)
    return _reply(true, "", true, [{
        "type": "choice_eliminated",
        "record_id": record_id,
        "choice_id": choice_id
    }])
```

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_state.gd tests/core_mvp_001_state_test.gd
git commit -m "feat: add deterministic investigation elimination state"
```

---

## Task 4. 규칙 가설 카드와 현장 검증

### 파일

- Modify: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`
- Modify: `tests/core_mvp_001_state_test.gd`

### 인터페이스

```gdscript
func submit_hypothesis(
    hypothesis_id: String,
    supporting_ids: Array[String],
    contradiction_ids: Array[String],
    unresolved_ids: Array[String]
) -> Dictionary

func resolve_field_test(field_test_id: String) -> Dictionary
```

### 테스트

- 배제 2개 전 제출 거부
- 지지 근거 0개 제출 거부
- 미획득·무관 근거 거부
- 제출 카드에 규칙 문장·지지·반박·미해결 보존
- 유효 제출 뒤 이해도 `likely`
- 결정적 현장 검증 성공 뒤 `understood`
- 오답은 정답을 공개하지 않음
- 오답은 피해·위험도·반응 단서·위험 사례를 모두 생성
- 실패 뒤 `기존 가설 1 + 변형 가설 1`
- 위험도 100에서 `EMERGENCY_RECOVERY`

### 이해도 계산

```gdscript
func _calculate_understanding() -> String:
    if _selected_supporting_ids.is_empty():
        return "unknown"
    if _eliminated_choice_ids.size() < 2:
        return "clue"
    if not _field_test_completed:
        return "likely"
    if _field_test_correct and _resolved_core_question:
        return "understood"
    return "likely"
```

단계 승격에는 난수를 사용하지 않는다.

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_state.gd tests/core_mvp_001_state_test.gd
git commit -m "feat: add hypothesis authorship and understanding tiers"
```

---

## Task 5. 패턴 잠금과 전조 해석

### 파일

- Modify: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`
- Modify: `tests/core_mvp_001_state_test.gd`

### 인터페이스

```gdscript
func begin_recovery_turn() -> Dictionary
func read_current_omen(forced_roll: int = -1) -> Dictionary
```

### 규칙

- `recovery_sequence` 순서로 실제 패턴을 먼저 고정한다.
- 같은 턴의 반복 해석은 첫 결과를 반환한다.
- `unknown=0`, `clue=35`, `likely=70`, `understood=100`.
- 실패는 정보 비공개이며 거짓 정보가 아니다.
- 첫 미관측 패턴은 roll 없이 자동 실패 문구를 보여준다.

### 테스트

- roll 1과 100이 pattern ID를 바꾸지 않음
- clue 경계: 35 성공, 36 실패
- likely 경계: 70 성공, 71 실패
- understood는 100에도 성공
- 실패 결과에는 action·target·range·condition 정보 없음
- 성공은 `readable_fields`만 공개
- 실제 authored 값 외 정보 반환 금지
- 3턴 ticket 패턴은 미관측, 5턴 재발동은 관측 상태

### 핵심 구현

```gdscript
func read_current_omen(forced_roll: int = -1) -> Dictionary:
    if _phase != Phase.OMEN_READ:
        return _reply(false, "전조 해석 단계가 아닙니다.")
    if not _current_omen_result.is_empty():
        return _current_omen_result.duplicate(true)

    var pattern := _pattern_by_id(_current_pattern_id)
    if bool(pattern.get("first_use_hidden", false)) and not _observed_pattern_ids.has(_current_pattern_id):
        _current_omen_result = {
            "ok": true,
            "success": false,
            "hidden_first_use": true,
            "message": "놈은 무언가 하려 한다.",
            "roll": -1,
            "rate": 0,
            "revealed_fields": []
        }
        _phase = Phase.RESPONSE_SELECTION
        return _current_omen_result.duplicate(true)

    var rate := int(_understanding_rates.get(_understanding, 0))
    var roll := forced_roll if forced_roll >= 1 else _rng.randi_range(1, 100)
    var success := roll <= rate
    var result := {
        "ok": true,
        "success": success,
        "message": "놈은 무언가 하려 한다.",
        "roll": roll,
        "rate": rate,
        "revealed_fields": []
    }
    if success:
        result["message"] = "놈은 %s을(를) 하려 한다." % String(pattern["action_name"])
        for field in pattern.get("readable_fields", []):
            result[field] = pattern.get(field)
            result["revealed_fields"].append(field)
    _current_omen_result = result
    _phase = Phase.RESPONSE_SELECTION
    return result.duplicate(true)
```

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_state.gd tests/core_mvp_001_state_test.gd
git commit -m "feat: lock recovery patterns before omen reads"
```

---

## Task 6. 턴제 대응과 포획 창

### 파일

- Modify: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`
- Modify: `tests/core_mvp_001_state_test.gd`

### 인터페이스

```gdscript
func resolve_recovery_action(action_id: String) -> Dictionary
func execute_capture() -> Dictionary
```

### 테스트

- 관측 패턴의 valid action은 포획 표식 추가
- 오대응은 피해·위험·배제 이유·위험 사례를 생성
- 정보 없는 체력 손실 금지
- 미관측 첫 발동의 범용 방어는 피해를 18 이하로 제한
- 첫 발동은 패턴을 관측 상태로 등록하지만 `ticket_isolated` 표식은 주지 않음
- 5턴 재발동에서 전용 대응으로 `ticket_isolated` 획득
- 표식 3개가 있어도 5턴 전에는 포획 창이 열리지 않음
- 5턴 이후 표식 3개면 `CAPTURE_WINDOW`
- 위험 100, 체력 15 이하 또는 8턴 도달 시 `EMERGENCY_CAPTURE`
- snapshot 어디에도 `enemy_hp` 없음

### 핵심 구현 규칙

```gdscript
var first_hidden := bool(pattern.get("first_use_hidden", false)) \
    and not _observed_pattern_ids.has(_current_pattern_id)

if first_hidden:
    valid_ids = pattern.get("generic_mitigation_action_ids", [])

if valid and first_hidden:
    damage = mini(8, int(pattern.get("max_first_observation_damage", 18)))
    _observed_pattern_ids.append(_current_pattern_id)
elif valid:
    _add_capture_mark(String(pattern.get("capture_mark", "")))
else:
    damage = 14
    _risk = mini(100, _risk + 20)
    _add_danger_case(pattern, action_id)

_health = maxi(1, _health - damage)
_phase = Phase.CAPTURE_WINDOW \
    if _has_all_capture_marks() and _recovery_turn >= int(_capture_rule.get("min_capture_turn", 5)) \
    else Phase.RECOVERY_TURN_START
if _risk >= 100 or _health <= 15 or _recovery_turn >= int(_capture_rule.get("max_recovery_turn", 8)):
    _phase = Phase.EMERGENCY_CAPTURE
```

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_state.gd tests/core_mvp_001_state_test.gd
git commit -m "feat: add pattern responses and capture window"
```

---

## Task 7. 결과와 괴이 매뉴얼 delta

### 파일

- Modify: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`
- Modify: `tests/core_mvp_001_state_test.gd`

### 인터페이스

```gdscript
func build_manual_delta() -> Dictionary
func build_result() -> Dictionary
func confirm_manual_promotion() -> Dictionary
```

### 테스트

- 올바른 가설 + 필수 지지 + 반박 검토 + 결정적 검증만 `verified`
- 올바른 대응이지만 근거 불충분이면 `candidate`
- 오답은 `danger_case`
- 이후 성공해도 기존 위험 사례 유지
- 같은 위험 사례 반복 시 `attempts` 증가
- 결과가 회수 품질·피해·지식 품질을 분리
- 승격 확인 뒤 `COMPLETE`

### 결과 구조

```gdscript
{
    "outcome_id": "poc001_outcome_normal_capture",
    "recovery_quality": "normal",
    "damage_total": 18,
    "risk_final": 40,
    "knowledge_quality": "verified",
    "capture_marks": ["broadcast_cut", "boundary_fixed", "ticket_isolated"],
    "hypothesis_id": "poc001_hypothesis_broadcast_blank",
    "danger_case_count": 1
}
```

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_state.gd tests/core_mvp_001_state_test.gd
git commit -m "feat: add core mvp 001 manual promotion"
```

---

## Task 8. 플레이테스트 로그

### 파일

- Create: `scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd`
- Create: `tests/core_mvp_001_playtest_log_test.gd`
- Modify: `tests/run_godot_regression.sh`

### 인터페이스

```gdscript
class_name CoreMvp001PlaytestLog
extends RefCounted

func start_session(session_id: String, build_label: String, run_seed: int) -> void
func record(event_name: String, payload: Dictionary = {}) -> void
func get_events() -> Array[Dictionary]
func write_jsonl(path: String) -> Error
```

### 필수 이벤트

```text
poc_started
investigation_scene_viewed
manual_record_linked
choice_eliminated
hypothesis_submitted
field_test_resolved
understanding_changed
recovery_turn_started
omen_read
recovery_action_resolved
capture_window_opened
poc_completed
```

각 이벤트는 `session_id`, `build_label`, `sequence`, `elapsed_ms`, `event`, `payload`를 가진다.

### 테스트

- 시작 이벤트 자동 기록
- sequence가 1부터 연속 증가
- payload deep copy
- JSONL 한 줄당 한 객체
- `user://core_mvp_001_playtest.jsonl` 외 기존 save path 접근 없음

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd tests/core_mvp_001_playtest_log_test.gd tests/run_godot_regression.sh
git commit -m "feat: add isolated core poc playtest log"
```

---

## Task 9. 단일 장면 UI

### 파일

- Create: `scenes/poc/core_mvp_001/core_mvp_001_scene.tscn`
- Create: `scripts/poc/core_mvp_001/core_mvp_001_scene.gd`
- Create: `tests/core_mvp_001_scene_test.gd`
- Modify: `tests/run_godot_regression.sh`

### 노드 계약

```text
CoreMvp001Scene
└─ SafeFrame
   └─ RootColumn
      ├─ Header
      │  ├─ PhaseLabel
      │  ├─ UnderstandingLabel
      │  ├─ HealthLabel
      │  └─ RiskLabel
      ├─ MainSplit
      │  ├─ SituationPanel/SituationLabel
      │  └─ WorkPanel
      │     ├─ ChoiceGrid
      │     ├─ ManualList
      │     ├─ HypothesisSummary
      │     ├─ EvidenceList
      │     └─ RecoveryActionGrid
      ├─ FeedbackLabel
      └─ Footer
         ├─ BackButton
         ├─ ConfirmButton
         └─ ExportLogButton
```

재사용:

- `res://scenes/ui/action_choice_card.tscn`
- `res://scripts/ui/anomaly_manual_drawer.gd`
- `res://scripts/ui/ui_theme_factory.gd`
- `res://scripts/ui/accessibility_settings.gd`

사용 금지:

- TeamStatusChip
- 장비·소모품·능력값
- StabilityBar·FearBar·예측률 숫자

### 장면 script 인터페이스

```gdscript
extends Control

const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const State = preload("res://scripts/poc/core_mvp_001/core_mvp_001_state.gd")
const PlaytestLog = preload("res://scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd")
const CASE_PATH := "res://data/poc/core_mvp_001/afterlife_station_poc.json"

var _state := State.new()
var _log := PlaytestLog.new()

func _ready() -> void:
    var data := CaseData.load_case(CASE_PATH)
    if data.is_empty():
        _show_fatal_error("CORE-MVP-001 사건 데이터를 불러오지 못했습니다.")
        return
    _state.start(data, 1001)
    _log.start_session(_make_session_id(), "core-mvp-001-v1", 1001)
    _render_snapshot(_state.get_snapshot())
```

상태별 렌더 함수:

```text
_render_elimination
_render_hypothesis
_render_field_test
_render_recovery
_render_result
```

UI는 상태를 계산하거나 저장하지 않는다.

### 장면 테스트

- 장면 로드 성공
- `TestSaveGuard`로 기존 저장 bytes 전후 동일
- 시작 선택지 4개, 관련 기록 2~3개
- 첫 키보드 포커스가 Button
- 유효 배제와 이유 표시
- Back/Esc가 동일하게 한 단계 역행하고 선택 근거 보존
- 회수 기본 화면에 안정도·공포·예측률·능력 숫자 없음
- 전조 실패 문구가 `놈은 무언가 하려 한다.`
- 포획 표식이 텍스트로 식별 가능
- 1280×720, 1920×1080에서 핵심 노드가 viewport 밖으로 나가지 않음

### Commit

```bash
git add scenes/poc/core_mvp_001/core_mvp_001_scene.tscn scripts/poc/core_mvp_001/core_mvp_001_scene.gd tests/core_mvp_001_scene_test.gd tests/run_godot_regression.sh
git commit -m "feat: add core mvp 001 playable scene"
```

---

## Task 10. 개발 패널 진입과 전체 회귀

### 파일

- Modify: `scripts/ui/main_menu.gd`
- Modify: `tests/run_godot_regression.sh`
- Modify: `tests/test_active_document_references.py`

### debug 버튼

기존 F1 개발 패널에만 추가한다.

```gdscript
_add_scene_button(
    dev_content,
    "CORE-MVP-001 조사→전조→포획 PoC",
    "res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn"
)
```

릴리스 기본 화면에는 노출하지 않는다.

### 회귀 runner

신규 script tests:

```text
core_mvp_001_case_data_test
core_mvp_001_playtest_log_test
core_mvp_001_scene_test
core_mvp_001_state_test
```

기존 39개 + 신규 4개이므로 마지막 문구:

```bash
echo "Godot regression suite: 43/43 test entrypoints passed"
```

### 문서 참조 테스트

```python
CORE_INTEGRATED_SPEC = ROOT / "docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md"
CORE_MVP_001_PLAN = ROOT / "docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md"


def test_core_integrated_spec_and_plan_exist(self) -> None:
    self.assertTrue(CORE_INTEGRATED_SPEC.is_file())
    self.assertTrue(CORE_MVP_001_PLAN.is_file())
```

### 전체 검증

```bash
python -m unittest tests/test_core_mvp_001_data_contract.py
GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_BIN="$GODOT_BIN" tests/run_godot_regression.sh
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py tests/test_core_validation_contract.py
git diff --check
```

Expected:

```text
CoreMvp001DataContractTests: OK
Godot regression suite: 43/43 test entrypoints passed
Python suites: OK
git diff --check: no output
```

### 보호 범위 감사

```bash
git diff --name-only <BASE_SHA>...HEAD
```

다음이 출력되면 중단하고 범위를 되돌린다.

```text
scripts/core/game_state.gd
data/episodes/
scripts/scenes/investigation_scene.gd
scripts/scenes/battle_scene.gd
project.godot
knowledge/base-pack/
```

### Commit

```bash
git add scripts/ui/main_menu.gd tests/run_godot_regression.sh tests/test_active_document_references.py
git commit -m "test: connect isolated core poc to regression suite"
```

---

## Task 11. 수동 UI·접근성 QA

구현 뒤 실제 검수 결과가 있을 때만 `docs/qa/CORE_MVP_001_VISUAL_QA.md`를 만든다.

해상도:

- 1280×720
- 1920×1080

필수 시나리오:

1. 첫 선택지와 기록 확인
2. 부적합 기록 연결
3. 유효 배제 2회
4. 가설 제출
5. 잘못된 현장 검증 1회
6. 갱신 후 올바른 검증
7. 전조 해석 실패
8. 전조 해석 성공
9. 미관측 핵심 패턴 범용 방어
10. 5턴 포획 창
11. 결과·매뉴얼·로그 내보내기

장벽 등급:

| 등급 | 기준 |
|---|---|
| BLOCKING | 선택·근거·전조·대응이 보이지 않거나 입력 불가 |
| MAJOR | 잘못된 판단을 유발하는 위계·포커스·문구 |
| MODERATE | 반복 탐색·과도한 스크롤·세부 가독성 |
| MINOR | 비핵심 정렬·간격·연출 |

BLOCKING 또는 MAJOR가 있으면 플레이테스트를 시작하지 않는다.

---

## Task 12. 신규 플레이어 테스트와 Production gate

### 결과가 생긴 뒤 만들 파일

- `docs/playtests/CORE_MVP_001_TEST_PROTOCOL.md`
- `docs/playtests/CORE_MVP_001_RESULTS.md`

### 표본

- 신규 플레이어 5~8명
- 기존 프로젝트 노출 플레이어는 별도 코호트
- 신규 플레이어 결과를 주 판정으로 사용

### 사전 선언 지표

| 지표 | 통과 |
|---|---:|
| 규칙·대응 이유 설명 | 80% 이상 |
| 근거 기반 배제 | 70% 이상 |
| 조사-회수 인과 체감 | 70% 이상 |
| 핵심 실패의 난수 탓 | 20% 이하 |
| 매뉴얼 저작감 | 80% 이상 |
| 미관측 패턴 무대응 인식 | 20% 이하 |

### 인터뷰 질문

1. 이 괴이는 어떤 규칙으로 움직였습니까?
2. 그렇게 판단한 근거는 무엇입니까?
3. 조사에서 한 일이 회수에서 어떤 차이를 만들었습니까?
4. 가장 불공정하거나 찍기처럼 느껴진 순간은 어디였습니까?
5. 매뉴얼은 시스템이 준 정답입니까, 직접 만든 기록입니까?
6. 처음 본 핵심 전조에서 사용할 수 있는 대응이 있었습니까?

### 상태 전이

```text
코드·장면·QA 완료, 플레이 전 → POC_BUILD_READY
테스트 진행 → POC_TESTING
지표 통과 → POC_PASSED
부분 미달 → RETEST_REQUIRED
핵심 인과 실패 → HOLD
```

자동 테스트만으로 `POC_PASSED`를 선언하지 않는다.

PASS일 때만 다음을 갱신한다.

- `docs/CURRENT_STATUS.md`
- `MVP_ROADMAP.md`
- `TEST_CHECKLIST.md`
- `docs/playtests/CORE_MVP_001_RESULTS.md`

---

## Task 13. 최종 PR 검토

### 증거 명령

```bash
git status -sb
git diff --stat origin/main...HEAD
git diff --name-status origin/main...HEAD
git diff --check
```

완료 보고에는 실제 실행 결과를 다음처럼 구분한다.

```text
PASS: 자동 테스트 이름과 마지막 출력
PASS: 수동 QA 시나리오와 캡처
NOT_RUN: 실행 환경이 없는 검증
BLOCKED: 플레이테스트 미수행 또는 표본 부족
```

### 적대적 재검토 질문

1. 매뉴얼이 자동 정답 버튼처럼 보이는가?
2. 전조 확률이 조사 성과를 무효화하는가?
3. 회수가 다시 HP·안정도 숫자 경쟁이 됐는가?
4. 미관측 패턴이 제작자 함정인가?
5. 실패가 정보 없이 체력만 깎는가?
6. 지원 시스템이 PoC 화면에 침투했는가?
7. 기존 저장이나 세 사건이 바뀌었는가?

각 finding을 `MUST_FIX / SHOULD_FIX / DEFER / REJECT / UNVERIFIED`로 판정한다. `MUST_FIX`가 남으면 PR을 ready로 전환하지 않는다.

## 후속 경계

이 계획은 CORE-MVP-001만 책임진다. 다음은 별도 설계·계획 승인이 필요하다.

- CORE-MVP-002: 영구 매뉴얼 재사용, 포획·연구, 부상·회복
- CORE-MVP-003: 기간제 챕터, 연계/독립 의뢰, 미니게임 재사용
- CORE-MVP-004: 연구 기반 히든 분기, 가치관 엔딩

CORE-MVP-001 플레이 증거 없이 후속 계획을 실행하지 않는다.
