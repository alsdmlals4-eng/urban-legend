# CORE-MVP-001 구현 계획

> 상태: `APPROVED_PLAN / NOT_IMPLEMENTED`  
> 마일스톤 계약: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`  
> 목표: 조사에서 작성한 규칙 가설이 회수 전투의 전조 정보 우위로 변환되고, 대응으로 포획 창을 여는 뾰족한 재미를 독립 PoC로 검증한다.  
> 기준선: `MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039`

## 1. 실행 원칙

- TDD로 실패 테스트를 먼저 작성한다.
- 한 작업은 한 계약만 바꾸고 즉시 회귀한다.
- UI는 상태를 계산하거나 저장하지 않는다.
- 자동 테스트·수동 QA·신규 플레이어 테스트를 분리한다.
- 신규 플레이어 행동 증거 전 CORE-MVP-002 이후 작업을 시작하지 않는다.
- 보호 경로 또는 저장 Schema가 변경되면 즉시 중단하고 별도 승인을 요청한다.

## 2. 격리 아키텍처

```text
main_menu.gd의 F1 개발 패널
→ scenes/poc/core_mvp_001/core_mvp_001_scene.tscn
→ CoreMvp001Scene
   ├─ CoreMvp001CaseData
   ├─ CoreMvp001State
   └─ CoreMvp001PlaytestLog
```

### 신규 파일

```text
data/poc/core_mvp_001/afterlife_station_poc.json
scripts/poc/core_mvp_001/core_mvp_001_case_data.gd
scripts/poc/core_mvp_001/core_mvp_001_state.gd
scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd
scripts/poc/core_mvp_001/core_mvp_001_scene.gd
scenes/poc/core_mvp_001/core_mvp_001_scene.tscn
tests/test_core_mvp_001_data_contract.py
tests/core_mvp_001_case_data_test.gd
tests/core_mvp_001_state_test.gd
tests/core_mvp_001_playtest_log_test.gd
tests/core_mvp_001_scene_test.gd
```

### 변경 허용

```text
scripts/ui/main_menu.gd
tests/run_godot_regression.sh
tests/test_active_document_references.py
TEST_CHECKLIST.md
```

### 수정 금지

```text
scripts/core/game_state.gd
data/episodes/**
scripts/scenes/investigation_scene.gd
scripts/scenes/battle_scene.gd
project.godot
knowledge/base-pack/**
```

PoC는 기존 저장을 읽거나 변경하지 않는다. 로그는 `user://core_mvp_001_playtest.jsonl`만 사용한다.

## 3. 공통 상태·응답 계약

### 공개 상태

```text
BOOT
ELIMINATION
HYPOTHESIS_AUTHORING
FIELD_TEST
HYPOTHESIS_REFRESH
RECOVERY_READY
EMERGENCY_RECOVERY
RECOVERY_TURN_START
OMEN_READ
RESPONSE_SELECTION
CAPTURE_WINDOW
EMERGENCY_CAPTURE
RESULT_COMPARE
MANUAL_PROMOTION
COMPLETE
```

- `INVESTIGATION_SITUATION은 UI 도입 단계`이며 공개 enum이 아니다.
- `RESPONSE_RESOLUTION은 명령 내부 원자 전이`이며 공개 enum이 아니다.

### 공통 응답

모든 공개 상태 명령은 다음 `Dictionary`를 반환한다.

```gdscript
{
    "ok": true,
    "error": "",
    "state_changed": true,
    "events": [],
    "snapshot": {}
}
```

```gdscript
func start(case_data: Dictionary, run_seed: int = 1001) -> Dictionary
func get_snapshot() -> Dictionary
func link_record_to_choice(record_id: String, choice_id: String) -> Dictionary
func advance_to_hypothesis() -> Dictionary
func submit_hypothesis(hypothesis_id: String, supporting_ids: Array[String], contradiction_ids: Array[String], unresolved_ids: Array[String]) -> Dictionary
func resolve_field_test(field_test_id: String) -> Dictionary
func begin_recovery_turn() -> Dictionary
func read_current_omen(forced_roll: int = -1) -> Dictionary
func resolve_recovery_action(action_id: String) -> Dictionary
func execute_capture() -> Dictionary
func build_manual_delta() -> Dictionary
func build_result() -> Dictionary
func confirm_manual_promotion() -> Dictionary
```

오류는 예외 대신 `ok=false`와 사람이 읽을 수 있는 `error`로 반환한다. 실패한 명령은 snapshot을 변경하지 않는다.

## 4. 공통 검증 명령

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

- 해결할 finding: 구현 전 고정 ID·범위·참조 무결성 부재
- 사용자 가치: 모든 단서와 선택이 관측 가능한 동일 계약을 따른다.
- 현재 상태: 데이터 파일 없음
- 목표 상태: 정확한 범위와 ID를 Python 계약 테스트가 고정
- 수정할 책임 원본: 마일스톤 계약
- 수정할 코드·데이터: 신규 JSON과 Python 테스트
- 수정 금지: 기존 `data/episodes/**`
- Red 검증: 데이터 부재·ID 누락으로 실패
- Green 구현: 아래 고정 ID와 참조를 가진 JSON 작성
- Refactor 범위: 중복 ID indexing helper만 허용
- 회귀 검사: 기존 사건 JSON byte/diff 비변경
- 완료 기준: Python unittest `OK`
- 롤백 방법: 신규 JSON·테스트 삭제
- 예상 독립 커밋: `test: define core mvp 001 case contract`

### 파일

- Create: `data/poc/core_mvp_001/afterlife_station_poc.json`
- Create: `tests/test_core_mvp_001_data_contract.py`

### 실패 테스트

- `contract_version == core-mvp-001-v1`
- 모든 ID가 `poc001_`로 시작하고 중복 없음
- 조사 장면 3, 단서 6, 기록 3, 선택지 4, 가설 2, 패턴 3
- 단서 역할 지지 3·반박 2·미해결 1
- 논리 배제 가능한 선택지 정확히 2개
- 모든 참조가 같은 JSON 안에서 해소
- 미관측 패턴 1개, 범용 대응 1개 이상, 최초 피해 상한 18
- `enemy_hp` 없음, 포획 표식 3개
- 회수 순서 5턴, 미관측 패턴 3·5턴
- 최소 포획 턴 5, 최대 회수 턴 8

### 고정 ID

```text
Scenes
poc001_scene_broadcast_archive
poc001_scene_platform_display
poc001_scene_ticket_gate

Clues / unresolved
poc001_clue_broadcast_blank
poc001_clue_reset_timing
poc001_clue_official_identifier
poc001_clue_display_mismatch
poc001_clue_passenger_count
poc001_question_ticket_trigger

Manual records
poc001_manual_early_movement_reset
poc001_manual_personal_destination
poc001_manual_ticket_contact_danger

Choices
poc001_choice_move_before_end
poc001_choice_follow_passenger_count
poc001_choice_follow_display
poc001_choice_hold_official_signal

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

### 회수 순서

```json
[
  "poc001_pattern_false_terminal",
  "poc001_pattern_boundary_fold",
  "poc001_pattern_ticket_imprint",
  "poc001_pattern_false_terminal",
  "poc001_pattern_ticket_imprint"
]
```

---

## Task 2. 데이터 로더·검증기

- 해결할 finding: 런타임이 잘못된 fixture를 조용히 수용할 위험
- 사용자 가치: 제작 오류가 플레이 중 불공정으로 노출되기 전에 차단된다.
- 현재 상태: 없음
- 목표 상태: 읽을 수 있는 오류 배열과 실패 안전 로드
- 수정할 코드·데이터: loader와 SceneTree 테스트
- 수정 금지: 기존 `episode_loader.gd`
- Red 검증: 없는 파일·깨진 JSON·dangling ref fixture
- Green 구현: `CoreMvp001CaseData`
- Refactor 범위: 순수 helper만 추출
- 회귀 검사: 기존 loader 미변경
- 완료 기준: `CORE MVP 001 CASE DATA: PASS`
- 롤백 방법: 신규 loader·테스트 삭제
- 예상 독립 커밋: `feat: add core mvp 001 case loader`

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

### 테스트

- 정상 JSON 로드
- 없는 파일·깨진 JSON은 `{}`
- 비표준·중복 ID 거부
- 존재하지 않는 record·choice·action 참조 거부
- 잘못된 회수 순서 거부
- 범용 방어가 없는 미관측 패턴 거부

---

## Task 3. 조사 배제 상태 머신

- 해결할 finding: 선택지 배제 비용·중복·단계 경계 불명확
- 사용자 가치: 플레이어가 기록을 적용해 직접 가능성을 줄인다.
- 현재 상태: 없음
- 목표 상태: 결정론적 배제와 비용 없는 무효 연결
- 수정할 코드·데이터: state와 테스트
- Red 검증: 잘못된 pair·중복·두 개 미만 진행
- Green 구현: `link_record_to_choice`, `advance_to_hypothesis`
- Refactor 범위: 응답 생성 helper
- 회귀 검사: 체력·위험 불변 assertion
- 완료 기준: 조사 상태 테스트 통과
- 롤백 방법: 신규 state·테스트 삭제
- 예상 독립 커밋: `feat: add deterministic investigation elimination state`

### 파일

- Create: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`
- Create: `tests/core_mvp_001_state_test.gd`

### 테스트

- `start()` 성공 뒤 `ELIMINATION`, 선택지 4, 배제 0, 체력 100, 위험 0
- 유효한 record-choice pair만 배제
- 같은 선택지 재배제는 중복 없음
- 부적합 연결은 `ok=false`, `state_changed=false`
- 부적합 연결 전후 snapshot 동일
- 서로 다른 2개 배제 뒤에만 `HYPOTHESIS_AUTHORING`
- 경쟁 가설 선택지는 배제할 수 없음

---

## Task 4. 규칙 가설 카드·현장 검증

- 해결할 finding: 가설 저작감과 실패 정보 가치가 상태로 고정되지 않음
- 사용자 가치: 플레이어가 지지·반박·미해결을 직접 연결한다.
- 현재 상태: 배제만 존재
- 목표 상태: 결정론적 이해도와 정보가 남는 현장 검증
- 수정할 코드·데이터: state·테스트
- Red 검증: 지지 0, 무관 근거, 실패 결과 정보 없음
- Green 구현: `submit_hypothesis`, `resolve_field_test`
- Refactor 범위: 이해도 계산 pure function
- 회귀 검사: 정답 자동 공개 없음
- 완료 기준: 카드·실패·긴급 전이 테스트 통과
- 롤백 방법: Task 4 commit revert
- 예상 독립 커밋: `feat: add hypothesis authorship and understanding tiers`

### 테스트

- 배제 2개 전 제출 거부
- 지지 근거 0개 제출 거부
- 미획득·무관 근거 거부
- 규칙 문장·지지·반박·미해결 보존
- 제출 뒤 `likely`
- 결정적 검증 성공 뒤 `understood`
- 실패는 정답을 공개하지 않고 피해·위험·반응 단서·위험 사례 생성
- 실패 뒤 기존 가설 1 + 변형 가설 1
- 위험 100에서 `EMERGENCY_RECOVERY`

---

## Task 5. 패턴 잠금·전조 해석

- 해결할 finding: 해석 난수가 실제 패턴을 바꾸거나 거짓 정보를 줄 위험
- 사용자 가치: 조사 성과가 공정한 정보 우위가 된다.
- 현재 상태: 회수 전조 없음
- 목표 상태: 패턴 선잠금·정보 비공개 실패·결정적 경계
- 수정할 코드·데이터: state·테스트
- Red 검증: roll에 따라 pattern 변경, 거짓 field 노출
- Green 구현: `begin_recovery_turn`, `read_current_omen`
- Refactor 범위: seeded roll helper
- 회귀 검사: 같은 턴 재호출 동일 결과
- 완료 기준: 모든 이해도 경계 통과
- 롤백 방법: Task 5 commit revert
- 예상 독립 커밋: `feat: lock recovery patterns before omen reads`

### 경계 테스트

- roll 차이가 pattern ID를 바꾸지 않음
- `clue`: 35 성공, 36 실패
- `likely`: 70 성공, 71 실패
- `understood`: 100 성공
- 실패 결과에 action·target·range·condition 없음
- 성공은 `readable_fields`만 공개
- 3턴 ticket은 미관측, 5턴 ticket은 관측 상태

---

## Task 6. 턴제 대응·포획 창

- 해결할 finding: 일반 HP 전투화·미관측 함정·소프트락 위험
- 사용자 가치: 규칙 대응으로 포획 조건을 연다.
- 현재 상태: 전조 해석만 존재
- 목표 상태: 표식 기반 포획과 안전한 폴백
- 수정할 코드·데이터: state·테스트
- Red 검증: 5턴 전 포획, 첫 패턴 치명 피해, 정보 없는 손실
- Green 구현: `resolve_recovery_action`, `execute_capture`
- Refactor 범위: 피해·표식 적용 helper
- 회귀 검사: snapshot에 `enemy_hp` 없음
- 완료 기준: 정상·비용·긴급 결과 경계 통과
- 롤백 방법: Task 6 commit revert
- 예상 독립 커밋: `feat: add pattern responses and capture window`

### 안전 규칙

```text
미관측 첫 발동 피해 상한 = 18
체력 최저값 = 1
정상 포획 최소 턴 = 5
최대 회수 턴 = 8
필수 포획 표식 = 3
```

### 테스트

- 올바른 대응은 표식 추가
- 오대응은 피해·위험·배제 이유·위험 사례 생성
- 정보 없는 체력 손실 금지
- 첫 미관측 패턴의 범용 방어 유효
- 첫 발동에는 전용 표식 없음
- 5턴 재발동에서 마지막 표식 획득
- 5턴 전 포획 금지
- 위험 100, 체력 15 이하, 8턴은 긴급 포획

---

## Task 7. 결과·괴이 매뉴얼 delta

- 해결할 finding: 성공과 정확한 이해가 한 결과로 뭉칠 위험
- 사용자 가치: 플레이어의 가설·근거·실수가 기록으로 남는다.
- 현재 상태: 결과 없음
- 목표 상태: candidate·verified·danger_case 분리
- 수정할 코드·데이터: state·테스트
- Red 검증: 맞는 행동만으로 verified, 위험 사례 삭제
- Green 구현: `build_manual_delta`, `build_result`, `confirm_manual_promotion`
- Refactor 범위: 분류 pure function
- 회귀 검사: 반복 위험 사례 `attempts`
- 완료 기준: 결과 3축과 COMPLETE 전이
- 롤백 방법: Task 7 commit revert
- 예상 독립 커밋: `feat: add core mvp 001 manual promotion`

---

## Task 8. 플레이테스트 로그

- 해결할 finding: 성공 지표를 계산할 행동 증거 부재
- 사용자 가치: 자기보고와 실제 행동을 분리해 판단한다.
- 현재 상태: 없음
- 목표 상태: 독립 JSONL 로그
- 수정할 코드·데이터: logger·테스트·runner
- Red 검증: sequence·deep copy·한 줄 한 객체·save path 접근
- Green 구현: `CoreMvp001PlaytestLog`
- Refactor 범위: event validation helper
- 회귀 검사: 기존 save bytes 불변
- 완료 기준: 로그 테스트 PASS
- 롤백 방법: logger·테스트·JSONL 삭제
- 예상 독립 커밋: `feat: add isolated core poc playtest log`

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

---

## Task 9. `CoreMvp001Scene` 단일 장면 UI

- 해결할 finding: 상태는 있어도 플레이어가 핵심 인과를 읽을 화면 없음
- 사용자 가치: 현재 질문·근거·대응·결과를 낮은 입력 부담으로 이해한다.
- 현재 상태: 없음
- 목표 상태: 단계별 단일 장면, 720p/1080p, 마우스·키보드
- 수정할 코드·데이터: scene·script·test·runner
- Red 검증: 모든 단계 패널 동시 노출, 포커스 유실, 720p clipping
- Green 구현: 단계별 패널 렌더와 고정 Footer
- Refactor 범위: 공용 card/drawer/theme/accessibility 재사용
- 회귀 검사: TestSaveGuard bytes 동일
- 완료 기준: scene test와 수동 QA blocker 0
- 롤백 방법: 신규 scene·script·test 삭제
- 예상 독립 커밋: `feat: add core mvp 001 playable scene`

### 노드 계약

```text
CoreMvp001Scene
└─ SafeFrame
   └─ RootColumn
      ├─ Header: PhaseLabel, UnderstandingLabel, HealthLabel, RiskLabel
      ├─ PhaseHost
      │  ├─ InvestigationPanel/ScrollContainer
      │  ├─ HypothesisPanel/ScrollContainer
      │  ├─ FieldTestPanel/ScrollContainer
      │  ├─ RecoveryPanel/ScrollContainer
      │  └─ ResultPanel/ScrollContainer
      ├─ FeedbackLabel
      └─ Footer: BackButton, ConfirmButton, ExportLogButton
```

### 표시·포커스 계약

- `현재 단계 패널만 표시`하고 나머지 단계 패널은 `visible=false`와 focus 제외 상태로 둔다.
- `Footer는 고정`하며 스크롤 영역 밖에 둔다.
- 넘침은 현재 단계 내부 `ScrollContainer`에서만 처리한다.
- 단계 진입·뒤로가기 뒤 `첫 유효 컨트롤로 포커스를 복구`한다.
- 뒤로가기는 선택한 근거·가설을 보존한다.
- 조사 단계: 선택지 4, 관련 기록 2~3, 최소 체력·위험
- 회수 단계: 전조, 해석, 대응 의도, 직전 결과, 포획 표식, 체력
- 장비·소모품·세력·관계·능력값·안정도·공포·예측률 숫자 제외

### 재사용

- `res://scenes/ui/action_choice_card.tscn`
- `res://scripts/ui/anomaly_manual_drawer.gd`
- `res://scripts/ui/ui_theme_factory.gd`
- `res://scripts/ui/accessibility_settings.gd`

### 장면 테스트

- 장면 로드 성공
- 기존 저장 bytes 전후 동일
- 현재 단계 패널 하나만 visible
- 첫 키보드 포커스가 Button
- 유효·무효 배제 이유 표시
- Back/Esc와 선택 근거 보존
- 전조 실패 문구 정확
- 포획 표식 텍스트 식별
- 1280×720·1920×1080 핵심 노드 viewport 내부

---

## Task 10. 개발 패널 진입·전체 회귀

- 해결할 finding: PoC 진입점과 기존 회귀 runner 연결 부재
- 사용자 가치: 릴리스 UI를 오염시키지 않고 반복 검증한다.
- 현재 상태: 신규 장면 직접 경로만 존재
- 목표 상태: F1 debug 버튼과 43개 runner
- 수정할 코드·데이터: main menu·runner·reference test
- 수정 금지: 릴리스 기본 화면
- Red 검증: debug 버튼 없음·runner 미등록
- Green 구현: 버튼 1개·신규 4 tests
- Refactor 범위: 없음
- 회귀 검사: 기존 39 tests 유지
- 완료 기준: `43/43` 출력과 전체 Python 계약 통과
- 롤백 방법: 버튼·runner 신규 엔트리 제거
- 예상 독립 커밋: `test: connect isolated core poc to regression suite`

```gdscript
_add_scene_button(
    dev_content,
    "CORE-MVP-001 조사→전조→포획 PoC",
    "res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn"
)
```

### 보호 범위 감사

```bash
git diff --name-only <BASE_SHA>...HEAD
```

보호 경로가 출력되면 중단하고 해당 작업 commit을 revert한다.

---

## Task 11. 수동 UI·접근성 QA

- 해결할 finding: 자동 scene tree 검사로 실제 가독성과 입력을 보장할 수 없음
- 사용자 가치: 핵심 판단을 읽고 조작할 수 있다.
- 현재 상태: `NOT_RUN`
- 목표 상태: blocker·major 0
- 수정할 책임 원본: 실제 결과가 있을 때만 플레이테스트 증거 파일
- Red 검증: 720p/1080p 전체 시나리오
- Green 구현: 검증된 UI 결함만 최소 수정
- Refactor 범위: 동작 불변 레이아웃 정리
- 회귀 검사: scene test·전체 Godot runner
- 완료 기준: blocker·major 0, minor 기록
- 롤백 방법: 해당 UI commit revert
- 예상 독립 커밋: `fix: resolve core poc visual qa blockers`

실제 검수 결과가 있을 때만 `docs/playtests/CORE_MVP_001_VISUAL_QA.md`를 만든다.

### 해상도·입력

- 1280×720
- 1920×1080
- 마우스
- 키보드 Tab/Enter/Space/Esc
- 긴 한국어
- 색상·음향 비의존
- 시간 제한 없음
- 화면 흔들림·섬광·왜곡 설정 존중

BLOCKING 또는 MAJOR 장벽이 있으면 신규 플레이어 테스트를 시작하지 않는다.

---

## Task 12. 신규 플레이어 테스트·Production gate

- 해결할 finding: 문서·자동 테스트만으로 코어 재미를 확정할 위험
- 사용자 가치: 실제 행동과 이해로 제작 확대를 결정한다.
- 현재 상태: `NOT_RUN`
- 목표 상태: 사전 선언 6지표 판정
- 수정할 책임 원본: 실제 결과가 생긴 뒤에만 protocol/results
- 수정할 코드·데이터: 없음 또는 검증된 단일 변경안
- Red 검증: 신규 5~8명 관찰
- Green 구현: 없음; 결과 미달 시 한 변수만 변경
- Refactor 범위: 없음
- 회귀 검사: 변경 후 동일 프로토콜 재실행
- 완료 기준: `POC_PASSED / RETEST_REQUIRED / HOLD`
- 롤백 방법: 실험 변경 commit revert
- 예상 독립 커밋: `docs: record core mvp 001 playtest gate`

### 결과 파일

```text
docs/playtests/CORE_MVP_001_TEST_PROTOCOL.md
docs/playtests/CORE_MVP_001_RESULTS.md
```

### 지표

| 지표 | 통과 |
|---|---:|
| 규칙·대응 이유 설명 | 80% 이상 |
| 근거 기반 배제 | 70% 이상 |
| 조사-회수 인과 체감 | 70% 이상 |
| 핵심 실패의 난수 탓 | 20% 이하 |
| 매뉴얼 저작감 | 80% 이상 |
| 미관측 패턴 무대응 인식 | 20% 이하 |

```text
코드·장면·QA 완료 → POC_BUILD_READY
테스트 진행 → POC_TESTING
지표 통과 → POC_PASSED
부분 미달 → RETEST_REQUIRED
핵심 인과 실패 → HOLD
```

자동 테스트만으로 `POC_PASSED`를 선언하지 않는다.

---

## Task 13. 최종 적대적 재검토·PR 판정

- 해결할 finding: 구현 중 코어·범위·호환성 회귀 가능성
- 사용자 가치: 실제 diff가 플레이어 약속과 일치한다.
- 현재 상태: 구현 뒤 실행
- 목표 상태: MUST_FIX 0, required checks 통과, 미검증 명시
- 수정할 책임 원본: 상태·로드맵·검증·PR
- 수정할 코드·데이터: 검증된 결함만
- Red 검증: 아래 공격 질문과 전체 diff
- Green 구현: MUST_FIX·승인 SHOULD_FIX만 최소 수정
- Refactor 범위: 기능 변경과 분리
- 회귀 검사: 전체 Python·Godot·수동 QA·플레이 증거
- 완료 기준: 증거와 PR 본문 일치
- 롤백 방법: finding별 독립 commit revert
- 예상 독립 커밋: `docs: close core mvp 001 validation gate`

### 증거 명령

```bash
git status -sb
git diff --stat origin/main...HEAD
git diff --name-status origin/main...HEAD
git diff --check
```

### 공격 질문

1. 매뉴얼이 자동 정답 버튼처럼 보이는가?
2. 전조 확률이 조사 성과를 무효화하는가?
3. 회수가 HP·안정도 숫자 경쟁으로 돌아갔는가?
4. 미관측 패턴이 제작자 함정인가?
5. 실패가 정보 없이 체력만 깎는가?
6. 지원 시스템이 PoC 화면에 침투했는가?
7. 기존 저장이나 세 사건이 바뀌었는가?
8. 현재 단계가 아닌 UI가 720p 화면과 포커스를 차지하는가?
9. 문서·테스트의 고정 ID와 상태가 일치하는가?

각 finding을 `MUST_FIX / SHOULD_FIX / DEFER / REJECT / UNVERIFIED`로 판정한다. `MUST_FIX`가 남으면 PR을 ready로 전환하지 않는다.

## 5. 전체 롤백

CORE-MVP-001을 철회할 때 다음만 제거한다.

```text
data/poc/core_mvp_001/**
scripts/poc/core_mvp_001/**
scenes/poc/core_mvp_001/**
tests/core_mvp_001_*.gd
tests/test_core_mvp_001_*.py
F1 개발 패널 PoC 버튼
regression runner 신규 4개 엔트리
user://core_mvp_001_playtest.jsonl
```

기존 저장, 세 사건, 캠페인, 시장, GDD와 프로젝트 코어는 롤백 대상이 아니다.

## 6. 후속 경계

- CORE-MVP-002: 영구 매뉴얼 재사용, 포획·연구, 부상·회복
- CORE-MVP-003: 기간제 챕터, 연계/독립 의뢰, 미니게임 재사용
- CORE-MVP-004: 연구 기반 히든 분기, 가치관 엔딩

CORE-MVP-001 플레이 증거 없이 후속 계획을 실행하지 않는다.
