# CORE-MVP-001 구현 계획

> 상태: `APPROVED_PLAN / NOT_IMPLEMENTED`  
> 정본 명세: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`  
> 목표: 조사에서 작성한 규칙 가설이 회수 전투의 전조 정보 우위로 변환되고, 대응으로 포획 창을 여는 뾰족한 재미를 독립 PoC로 검증한다.  
> 기준선: `MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039`

## 1. 구현 원칙

- TDD로 실패 테스트를 먼저 작성한다.
- 한 작업은 한 계약만 바꾸고 즉시 회귀한다.
- UI는 상태를 계산하거나 저장하지 않는다.
- 자동 테스트 통과와 플레이테스트 통과를 분리한다.
- 신규 플레이어 행동 증거 전 CORE-MVP-002 이후 작업을 시작하지 않는다.

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

### 보호 경로

```text
scripts/core/game_state.gd
data/episodes/**
scripts/scenes/investigation_scene.gd
scripts/scenes/battle_scene.gd
project.godot
knowledge/base-pack/**
```

CORE-MVP-001은 기존 저장을 읽거나 변경하지 않는다. PoC 로그는 `user://core_mvp_001_playtest.jsonl`만 사용한다.

## 3. 공통 응답 계약

모든 상태 명령은 다음 구조를 반환한다.

```gdscript
{
    "ok": true,
    "error": "",
    "state_changed": true,
    "events": [],
    "snapshot": {}
}
```

오류는 예외 대신 `ok=false`와 사람이 읽을 수 있는 `error`로 반환한다.

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

### 파일

- Create: `data/poc/core_mvp_001/afterlife_station_poc.json`
- Create: `tests/test_core_mvp_001_data_contract.py`

### 먼저 작성할 실패 테스트

- `contract_version == core-mvp-001-v1`
- 모든 ID가 `poc001_` 접두사이며 중복 없음
- 조사 장면 3, 단서 6, 선택지 4, 가설 2, 패턴 3
- 단서 역할: 지지 3, 반박 2, 미해결 1
- 논리 배제 가능한 선택지는 정확히 2개
- 모든 참조 ID가 같은 JSON 안에서 해소됨
- 미관측 패턴 1개, 범용 대응 1개 이상, 최초 피해 상한 18
- `enemy_hp` 필드 없음
- 포획 표식 3개
- 회수 순서 5턴, 미관측 패턴은 3턴과 5턴에 등장
- 최소 포획 턴 5, 최대 회수 턴 8

### 고정 ID

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

### 완료 조건

```bash
python -m unittest tests/test_core_mvp_001_data_contract.py
```

결과가 `OK`이고 데이터 범위가 정확할 것.

### Commit

```bash
git add data/poc/core_mvp_001/afterlife_station_poc.json tests/test_core_mvp_001_data_contract.py
git commit -m "test: define core mvp 001 case contract"
```

---

## Task 2. 데이터 로더·검증기

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
- 비표준 ID·중복 ID 거부
- 존재하지 않는 record·choice·action 참조 거부
- 잘못된 회수 순서 거부
- 범용 방어가 없는 미관측 패턴 거부

### 완료 출력

```text
CORE MVP 001 CASE DATA: PASS
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

func start(case_data: Dictionary, run_seed: int = 1001) -> void
func get_snapshot() -> Dictionary
func link_record_to_choice(record_id: String, choice_id: String) -> Dictionary
func advance_to_hypothesis() -> Dictionary
```

### 단계 enum

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

### 테스트

- 시작: 선택지 4, 배제 0, 체력 100, 위험 0
- 유효한 record-choice 쌍만 배제
- 같은 배제 반복은 중복 없음
- 부적합 연결은 `state_changed=false`
- 부적합 연결 전후 체력·위험·단계 동일
- 서로 다른 2개 배제 뒤에만 가설 단계 진입
- 경쟁 가설 선택지는 배제 불가

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_state.gd tests/core_mvp_001_state_test.gd
git commit -m "feat: add deterministic investigation elimination state"
```

---

## Task 4. 규칙 가설 카드·현장 검증

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
- 카드에 규칙 문장·지지·반박·미해결 보존
- 제출 뒤 이해도 `likely`
- 결정적 현장 검증 성공 뒤 `understood`
- 오답은 정답 공개 금지
- 오답은 피해·위험·반응 단서·위험 사례 생성
- 실패 뒤 기존 가설 1 + 변형 가설 1
- 위험 100에서 긴급 회수

### 이해도 계약

```text
unknown: 유효 지지 근거 없음
clue: 지지 근거 1개 이상
likely: 선택지 2개 배제 + 지지 충족 + 반박 확인
understood: 결정적 검증 성공 + 핵심 미해결 조건 해소
```

단계 승격에는 난수를 사용하지 않는다.

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_state.gd tests/core_mvp_001_state_test.gd
git commit -m "feat: add hypothesis authorship and understanding tiers"
```

---

## Task 5. 패턴 잠금·전조 해석

### 파일

- Modify: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`
- Modify: `tests/core_mvp_001_state_test.gd`

### 인터페이스

```gdscript
func begin_recovery_turn() -> Dictionary
func read_current_omen(forced_roll: int = -1) -> Dictionary
```

### 규칙

- 실제 패턴을 먼저 고정한다.
- 같은 턴의 반복 해석은 첫 결과를 반환한다.
- 해석률: unknown 0, clue 35, likely 70, understood 100.
- 실패 문구: `놈은 무언가 하려 한다.`
- 실패는 거짓 정보가 아니라 비공개다.
- 첫 미관측 패턴은 roll 없이 해석 실패 처리한다.

### 경계 테스트

- roll 차이가 pattern ID를 바꾸지 않음
- clue: 35 성공, 36 실패
- likely: 70 성공, 71 실패
- understood: 100 성공
- 실패 결과에 action·target·range·condition 없음
- 성공은 `readable_fields`만 공개
- 3턴 ticket 패턴은 미관측, 5턴 재발동은 관측 상태

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_state.gd tests/core_mvp_001_state_test.gd
git commit -m "feat: lock recovery patterns before omen reads"
```

---

## Task 6. 턴제 대응·포획 창

### 파일

- Modify: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`
- Modify: `tests/core_mvp_001_state_test.gd`

### 인터페이스

```gdscript
func resolve_recovery_action(action_id: String) -> Dictionary
func execute_capture() -> Dictionary
```

### 테스트

- 올바른 대응은 포획 표식 추가
- 오대응은 피해·위험·배제 이유·위험 사례 생성
- 정보 없는 체력 손실 금지
- 미관측 첫 발동의 범용 방어는 피해 18 이하
- 첫 발동은 패턴 관측만 하고 전용 표식은 주지 않음
- 5턴 재발동에서 전용 대응으로 마지막 표식 획득
- 5턴 전에는 포획 창 금지
- 5턴 이후 표식 3개면 포획 창
- 위험 100, 체력 15 이하, 8턴 도달은 긴급 포획
- snapshot에 `enemy_hp` 없음

### 안전 규칙

```text
첫 미관측 패턴 유효 행동 = generic_mitigation_action_ids
체력 최저값 = 1
정상 포획 최소 턴 = 5
최대 회수 턴 = 8
```

### Commit

```bash
git add scripts/poc/core_mvp_001/core_mvp_001_state.gd tests/core_mvp_001_state_test.gd
git commit -m "feat: add pattern responses and capture window"
```

---

## Task 7. 결과·괴이 매뉴얼 delta

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

- 규칙·필수 지지·반박 검토·결정적 검증 일치만 `verified`
- 올바른 대응이나 근거 불충분은 `candidate`
- 오답은 `danger_case`
- 성공 뒤에도 기존 위험 사례 유지
- 같은 위험 사례 반복은 `attempts` 증가
- 결과가 회수 품질·피해·지식 품질을 분리
- 승격 확인 뒤 COMPLETE

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

### 테스트

- 시작 이벤트 자동 기록
- sequence 1부터 연속 증가
- payload deep copy
- JSONL 한 줄당 한 객체
- 기존 save path 접근 없음

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
      ├─ Header: PhaseLabel, UnderstandingLabel, HealthLabel, RiskLabel
      ├─ MainSplit
      │  ├─ SituationPanel/SituationLabel
      │  └─ WorkPanel
      │     ├─ ChoiceGrid
      │     ├─ ManualList
      │     ├─ HypothesisSummary
      │     ├─ EvidenceList
      │     └─ RecoveryActionGrid
      ├─ FeedbackLabel
      └─ Footer: BackButton, ConfirmButton, ExportLogButton
```

### 재사용

- `res://scenes/ui/action_choice_card.tscn`
- `res://scripts/ui/anomaly_manual_drawer.gd`
- `res://scripts/ui/ui_theme_factory.gd`
- `res://scripts/ui/accessibility_settings.gd`

### 기본 화면에서 제외

- 장비·소모품·세력·관계
- 요원 능력값
- 안정도·공포·예측률 숫자
- 자동 최적 대응 표시

### 장면 테스트

- 장면 로드 성공
- TestSaveGuard로 기존 저장 bytes 전후 동일
- 선택지 4개, 관련 기록 2~3개
- 첫 키보드 포커스가 Button
- 유효 배제와 이유 표시
- Back/Esc 역행과 선택 근거 보존
- 전조 실패 문구 일치
- 포획 표식이 텍스트로 식별 가능
- 1280×720, 1920×1080에서 핵심 노드가 viewport 내부

### Commit

```bash
git add scenes/poc/core_mvp_001/core_mvp_001_scene.tscn scripts/poc/core_mvp_001/core_mvp_001_scene.gd tests/core_mvp_001_scene_test.gd tests/run_godot_regression.sh
git commit -m "feat: add core mvp 001 playable scene"
```

---

## Task 10. 개발 패널 진입·전체 회귀

### 파일

- Modify: `scripts/ui/main_menu.gd`
- Modify: `tests/run_godot_regression.sh`
- Modify: `tests/test_active_document_references.py`

### debug 버튼

```gdscript
_add_scene_button(
    dev_content,
    "CORE-MVP-001 조사→전조→포획 PoC",
    "res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn"
)
```

릴리스 기본 화면에는 노출하지 않는다.

### regression runner

신규 script tests:

```text
core_mvp_001_case_data_test
core_mvp_001_playtest_log_test
core_mvp_001_scene_test
core_mvp_001_state_test
```

기존 39 + 신규 4이므로 마지막 문구를 `43/43`으로 갱신한다.

### 전체 검증

```bash
python -m unittest tests/test_core_mvp_001_data_contract.py
GODOT_BIN="${GODOT_BIN:-godot}" tests/run_godot_regression.sh
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py tests/test_core_validation_contract.py
git diff --check
```

### 보호 범위 감사

```bash
git diff --name-only <BASE_SHA>...HEAD
```

보호 경로가 출력되면 중단하고 되돌린다.

### Commit

```bash
git add scripts/ui/main_menu.gd tests/run_godot_regression.sh tests/test_active_document_references.py
git commit -m "test: connect isolated core poc to regression suite"
```

---

## Task 11. 수동 UI·접근성 QA

실제 검수 결과가 있을 때만 다음 파일을 만든다.

```text
docs/playtests/CORE_MVP_001_VISUAL_QA.md
```

### 해상도

- 1280×720
- 1920×1080

### 필수 시나리오

1. 첫 선택지와 기록 확인
2. 부적합 기록 연결
3. 유효 배제 2회
4. 가설 제출
5. 잘못된 현장 검증 1회
6. 갱신 뒤 올바른 검증
7. 전조 해석 실패·성공
8. 미관측 핵심 패턴 범용 방어
9. 5턴 포획 창
10. 결과·매뉴얼·로그 내보내기

BLOCKING 또는 MAJOR 장벽이 있으면 플레이테스트를 시작하지 않는다.

---

## Task 12. 신규 플레이어 테스트·Production gate

### 결과가 생긴 뒤 만들 파일

```text
docs/playtests/CORE_MVP_001_TEST_PROTOCOL.md
docs/playtests/CORE_MVP_001_RESULTS.md
```

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

### 상태 전이

```text
코드·장면·QA 완료 → POC_BUILD_READY
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

## Task 13. 최종 적대적 재검토·PR 판정

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

각 finding을 `MUST_FIX / SHOULD_FIX / DEFER / REJECT / UNVERIFIED`로 판정한다. `MUST_FIX`가 남으면 PR을 ready로 전환하지 않는다.

## 5. 후속 경계

이 계획은 CORE-MVP-001만 책임진다.

- CORE-MVP-002: 영구 매뉴얼 재사용, 포획·연구, 부상·회복
- CORE-MVP-003: 기간제 챕터, 연계/독립 의뢰, 미니게임 재사용
- CORE-MVP-004: 연구 기반 히든 분기, 가치관 엔딩

CORE-MVP-001 플레이 증거 없이 후속 계획을 실행하지 않는다.
