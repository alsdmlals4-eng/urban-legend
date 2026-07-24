# 괴이 기록국 CORE-MVP-001 마일스톤 계약

> 문서 ID: `CORE-MVP-001-MILESTONE-CONTRACT-2026-07-23`  
> 상태: `APPROVED_CONTRACT / NOT_IMPLEMENTED`  
> 프로젝트 코어: `CORE_RECORDED / CORE_STRESS_TESTED`  
> 구현 상태: `POC_PENDING`  
> Production gate: `HOLD_UNTIL_PLAYER_EVIDENCE`  
> 적용 범위: `CORE-MVP-001` 마일스톤 계약  
> 구현 기준선: `MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039`

## 1. 목적과 권한

이 문서는 확정된 프로젝트 코어를 변경하지 않는다. 단일 사건 PoC에서 다음 질문을 구현·검증하기 위한 **고정 마일스톤 계약**만 소유한다.

> 조사에서 플레이어가 작성한 규칙 가설이 회수 전투의 전조 정보 우위로 변환되고, 준비한 대응으로 포획 창을 여는 순간이 실제 중심 재미로 작동하는가?

책임 경계는 다음과 같다.

| 질문 | 책임 원본 |
|---|---|
| 바뀌면 다른 게임이 되는 최소 코어 | `docs/PROJECT_CORE.md` |
| 프로젝트 전체 상세 게임 설계 | `docs/GAME_DESIGN_DOCUMENT.md` |
| 현재 실제 구현 | `docs/CURRENT_STATUS.md` |
| 단계 순서와 Production gate | `MVP_ROADMAP.md` |
| PR·시장·SWOT·VRIO·적대적 검토 근거 | `docs/planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md` |
| CORE-MVP-001 고정 ID·상태·데이터·UI·수용 계약 | 이 문서 |
| 정확한 파일·TDD·커밋 순서 | `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md` |

충돌 시 `PROJECT_CORE → GDD → CURRENT_STATUS → 이 마일스톤 계약 → 구현 계획` 순으로 판단하고 임의 병합하지 않는다.

`APPROVED_CONTRACT`는 구현 완료나 재미 검증을 뜻하지 않는다. `POC_PASSED`는 자동 테스트만으로 선언할 수 없다.

## 2. 플레이어 약속과 뾰족한 재미

### 플레이어 약속

> 내가 조사한 만큼 전투에서 괴이를 더 정확히 읽을 수 있고, 내가 직접 기록한 만큼 다음 출현에서 더 안전하고 더 나은 결말을 선택할 수 있다.

### 뾰족한 재미

> 조사에서 읽은 규칙이 회수 전투의 전조로 실제 나타나고, 준비한 대응으로 포획 창을 여는 순간.

### PoC 세션 루프

```text
관측
→ 관련 매뉴얼 기록 비교
→ 4개 선택지 중 2개 논리 배제
→ 경쟁 가설 카드 작성
→ 위험을 감수한 현장 검증
→ 현장 이해도 갱신
→ 전조 해석
→ 턴제 패턴 대응
→ 포획 창 개방·잔향 회수
→ 후보·공식 규칙·위험 사례 비교
```

## 3. 범위

### 포함

- 저승역 소재의 독립 PoC 사건 1개
- 목표 플레이 시간 18~25분
- 조사 장면 3개
- 핵심 단서 6개: 지지 3, 반박 2, 미해결 1
- 시작 매뉴얼 기록 3개
- 선택지 4개, 논리 배제 2개
- 경쟁 규칙 가설 2개
- 현장 이해도 4단계
- 회수 패턴 3개: 사전 관측 2, 미관측 핵심 1
- 고정 회수 순서 5턴, 최대 8턴
- 포획 표식 3개
- 정상 포획 / 비용 있는 포획 / 긴급 포획
- 체력, 괴이 위험도, 범용 방어
- 세션 JSONL 플레이테스트 로그

### 제외

- 기존 `scripts/core/game_state.gd` 변경
- 저장 `mvp-039` 증가 또는 이관 변경
- 기존 세 사건 JSON 수정
- 기존 조사·회수 장면 직접 개조
- 장비·시장·세력·경제
- 서포트 능력값과 자동 최적 행동
- 부상·회복 일정
- 연구 트리·히든 분기·엔딩
- 실제 캠페인 합류
- CORE-MVP-002 이후 기능

## 4. 격리 아키텍처

```text
main_menu.gd의 F1 개발 패널
→ scenes/poc/core_mvp_001/core_mvp_001_scene.tscn
→ CoreMvp001Scene
   ├─ CoreMvp001CaseData
   ├─ CoreMvp001State
   └─ CoreMvp001PlaytestLog
```

### 신규 파일 책임

| 경로 | 책임 |
|---|---|
| `data/poc/core_mvp_001/afterlife_station_poc.json` | 단일 PoC의 단서·기록·선택지·가설·패턴·결과 |
| `scripts/poc/core_mvp_001/core_mvp_001_case_data.gd` | JSON 로드·Schema·참조 무결성 검증 |
| `scripts/poc/core_mvp_001/core_mvp_001_state.gd` | 순수 상태·논리 배제·이해도·전조·포획 판정 |
| `scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd` | 세션 이벤트 JSONL 기록 |
| `scripts/poc/core_mvp_001/core_mvp_001_scene.gd` | `CoreMvp001Scene` UI 렌더·입력 연결 |
| `scenes/poc/core_mvp_001/core_mvp_001_scene.tscn` | 16:9 단일 PoC 장면과 명명된 노드 |

### 변경 허용

- `scripts/ui/main_menu.gd`: F1 개발 패널 버튼 1개
- `tests/run_godot_regression.sh`: 신규 테스트 4개 등록·총계 갱신
- `tests/test_active_document_references.py`: 계약·참조 검사
- `TEST_CHECKLIST.md`: 조건부 검증 계약

### 보호 경로

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `project.godot`
- `knowledge/base-pack/**`

PoC는 기존 저장 파일을 읽거나 수정하지 않는다. 로그는 `user://core_mvp_001_playtest.jsonl`만 사용한다.

## 5. 공개 상태 계약

`CoreMvp001State`의 공개 상태는 다음 15개뿐이다.

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

- `INVESTIGATION_SITUATION은 UI 도입 단계`이며 공개 상태 enum이 아니다. 장면 소개 뒤 `ELIMINATION`으로 시작한다.
- `RESPONSE_RESOLUTION은 명령 내부 원자 전이`이며 공개 상태 enum이 아니다. `resolve_recovery_action()` 한 호출 안에서 판정·이벤트·다음 상태를 확정한다.
- UI는 상태를 계산하거나 저장하지 않는다.
- 실패한 명령은 상태·체력·위험·선택 기록을 변경하지 않는다.

### 조사 전이

| 현재 | 입력 | 조건 | 다음 | 결과 |
|---|---|---|---|---|
| `BOOT` | `start` | 유효 데이터 | `ELIMINATION` | 상황·선택지 4·관련 기록 2~3 표시 |
| `ELIMINATION` | 기록-선택지 연결 | 유효 모순 | `ELIMINATION` | 선택지 1개 배제 |
| `ELIMINATION` | 기록-선택지 연결 | 부적합 | `ELIMINATION` | 비용 없이 이유 표시 |
| `ELIMINATION` | 계속 | 서로 다른 배제 2개 | `HYPOTHESIS_AUTHORING` | 경쟁 가설 2개 고정 |
| `HYPOTHESIS_AUTHORING` | 가설 제출 | 지지 근거 1개 이상 | `FIELD_TEST` | 카드·미해결 조건 보존 |
| `FIELD_TEST` | 검증 | 성공 | `RECOVERY_READY` | 이해도 승격·회수 준비 |
| `FIELD_TEST` | 검증 | 실패·위험 미만 | `HYPOTHESIS_REFRESH` | 반응 단서·위험 사례·부분 갱신 |
| `FIELD_TEST` | 검증 | 위험 100 | `EMERGENCY_RECOVERY` | 추가 검증 금지 |

### 회수 전이

| 현재 | 입력 | 조건 | 다음 | 결과 |
|---|---|---|---|---|
| `RECOVERY_READY`/`EMERGENCY_RECOVERY` | 턴 시작 | 패턴 존재 | `OMEN_READ` | 실제 패턴 먼저 잠금 |
| `OMEN_READ` | 해석 | 성공/실패 | `RESPONSE_SELECTION` | 실제 정보 또는 정보 비공개 |
| `RESPONSE_SELECTION` | 행동 | 유효 입력 | 턴 시작/포획/긴급 포획 | 피해·위험·표식·기록 원자 반영 |
| `CAPTURE_WINDOW` | 포획 | 턴·표식 충족 | `RESULT_COMPARE` | 정상/비용 포획 |
| `EMERGENCY_CAPTURE` | 긴급 포획 | 위험·체력·턴 한계 | `RESULT_COMPARE` | 낮은 회수 품질·잔류 위험 |
| `RESULT_COMPARE` | 승격 확인 | 결과 존재 | `MANUAL_PROMOTION` | 후보·공식·위험 분류 |
| `MANUAL_PROMOTION` | 완료 | 기록 확정 | `COMPLETE` | 세션 종료 |

## 6. 공통 명령 응답

모든 공개 명령은 다음 `Dictionary`를 반환한다.

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
class_name CoreMvp001State
extends RefCounted

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

오류는 예외 대신 `ok=false`와 사람이 읽을 수 있는 `error`를 반환한다.

## 7. 데이터 계약

### 최상위 Schema

```json
{
  "contract_version": "core-mvp-001-v1",
  "case": {},
  "clues": [],
  "manual_records": [],
  "investigation_scenes": [],
  "choices": [],
  "elimination_rules": [],
  "hypotheses": [],
  "field_tests": [],
  "understanding": {},
  "recovery_patterns": [],
  "recovery_sequence": [],
  "recovery_actions": [],
  "capture_rule": {},
  "outcomes": []
}
```

### ID 공통 규칙

- 모든 PoC 전용 ID는 `poc001_`로 시작한다.
- ID는 JSON 전체에서 중복될 수 없다.
- 기존 에피소드·단서·선택·패턴 ID를 복제하거나 덮어쓰지 않는다.
- 모든 참조는 같은 JSON 안에서 해소한다.
- 배열 순서는 작성된 플레이 순서이며 임의 재정렬하지 않는다.

### 고정 ID

```text
Scenes
poc001_scene_broadcast_archive
poc001_scene_platform_display
poc001_scene_ticket_gate

Clues / unresolved question
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

### 단서와 가설

- 단서 역할은 `support / contradiction / unresolved`만 사용한다.
- `observable=false`인 정보는 핵심 판정에 사용할 수 없다.
- 가설 제출은 플레이어가 실제로 선택한 `supporting`, `contradiction`, `unresolved` ID를 별도 보존한다.
- 지지 근거가 0개면 제출할 수 없다.
- 반박 근거가 존재하면 숨기거나 자동 제거하지 않는다.
- 잘못된 기록 연결은 체력·위험·시간 비용이 없다.

### 현장 이해도

```json
{
  "tiers": ["unknown", "clue", "likely", "understood"],
  "omen_read_rates": {
    "unknown": 0,
    "clue": 35,
    "likely": 70,
    "understood": 100
  }
}
```

| 단계 | 결정론적 승격 조건 |
|---|---|
| `unknown` | 유효 지지 근거 없음 |
| `clue` | 유효 지지 근거 1개 이상 |
| `likely` | 선택지 2개 배제 + 필수 지지 충족 + 반박 확인 |
| `understood` | 결정적 현장 검증 성공 + 핵심 미해결 조건 해소 |

단계 승격에는 난수를 사용하지 않는다.

## 8. 회수 계약

### 고정 5턴 순서

```json
[
  "poc001_pattern_false_terminal",
  "poc001_pattern_boundary_fold",
  "poc001_pattern_ticket_imprint",
  "poc001_pattern_false_terminal",
  "poc001_pattern_ticket_imprint"
]
```

- 실제 패턴은 해석 판정 전에 잠근다.
- 같은 턴의 반복 해석은 처음 확정된 결과를 반환한다.
- 3턴의 `ticket_imprint`는 미관측 첫 발동이다.
- 5턴 재발동부터 관측된 패턴으로 취급한다.

### 미관측 핵심 패턴

- 첫 발동은 이해도와 관계없이 행동명·대상·범위·조건을 공개하지 않는다.
- 미관측 핵심 전조라는 사실은 텍스트와 아이콘으로 표시한다.
- `poc001_action_guard`, `poc001_action_cover`, `poc001_action_protect_trace` 중 최소 하나는 항상 유효하다.
- 최초 관측 피해 상한은 18이다.
- 체력 최저값은 1이며 첫 발동만으로 행동 불능이 되지 않는다.
- 첫 발동은 패턴 관측만 등록하고 `ticket_isolated` 표식을 주지 않는다.
- 5턴 재발동에서 `poc001_action_isolate_ticket`으로 표식을 얻는다.

### 전조 해석

- 난수는 `clue`와 `likely`에서 이미 관측한 패턴의 실제 세부 정보를 이번 턴에 읽는지에만 사용한다.
- `forced_roll`은 테스트용 의존성 주입이다.
- `clue`: 35 이하 성공, 36 이상 실패.
- `likely`: 70 이하 성공, 71 이상 실패.
- `understood`: 관측 패턴 100% 성공.
- 실패 문구는 `놈은 무언가 하려 한다.`다.
- 실패 결과에 거짓 행동명·대상·범위·조건을 넣지 않는다.
- 시스템은 대응을 추천하거나 최적 행동을 강조하지 않는다.

### 포획 규칙

```json
{
  "required_capture_marks": [
    "broadcast_cut",
    "boundary_fixed",
    "ticket_isolated"
  ],
  "min_capture_turn": 5,
  "max_recovery_turn": 8,
  "normal_max_damage": 20,
  "costly_max_damage": 45,
  "emergency_risk_threshold": 100
}
```

- 괴이 HP와 `enemy_hp` 필드를 사용하지 않는다.
- 올바른 대응은 포획 표식을 추가한다.
- 오대응은 회복 가능한 피해·위험·배제 이유·위험 사례를 남긴다.
- 오대응은 이미 얻은 포획 표식을 삭제하지 않는다.
- 위험 100, 체력 15 이하 또는 8턴 도달 시 긴급 포획으로 전환한다.
- 긴급 포획은 최고 회수 품질을 받을 수 없다.

## 9. 매뉴얼 결과 계약

| 상태 | 조건 | 의미 |
|---|---|---|
| `candidate` | 대응은 맞았지만 가설·근거·미해결 조건이 불완전 | 재검증 필요 |
| `verified` | 규칙·필수 지지·반박 검토·결정적 검증 일치 | 공식 규칙 |
| `danger_case` | 잘못된 가설·대응과 관측 결과 | 이후 배제 근거 |

- 성공 뒤에도 기존 위험 사례를 삭제하지 않는다.
- 같은 위험 사례 반복은 행을 늘리지 않고 `attempts`를 증가시킨다.
- 결과는 회수 품질·피해 관리·지식 품질을 분리한다.
- CORE-MVP-001은 세션 내 전달만 검증한다. 영구 저장·재출현 활용은 CORE-MVP-002의 별도 저장 승인 대상이다.

## 10. UI·접근성 계약

### 단계별 표시

- 한 장면을 사용하지만 `현재 단계 패널만 표시`한다.
- 조사, 가설, 현장 검증, 회수, 결과 패널을 동시에 노출하지 않는다.
- `Footer는 고정`하고 뒤로가기·확인·로그 내보내기를 현재 단계에 맞게 활성화한다.
- 현재 단계 콘텐츠가 720p 높이를 초과하면 해당 단계 내부 `ScrollContainer`만 사용한다.
- 단계 전환과 뒤로가기 후 `첫 유효 컨트롤로 포커스를 복구`한다.
- 뒤로가기는 이미 선택한 근거와 가설을 보존한다.

### 정보 위계

| 단계 | 전면 정보 | 제외·접기 |
|---|---|---|
| 조사 | 상황, 선택지 4, 관련 기록 2~3, 체력·위험 | 장비·세력·관계·능력값 |
| 가설 | 남은 2가설, 지지·반박·미해결, 직전 배제 이유 | 시장·보상·자동 추천 |
| 회수 | 전조, 해석 결과, 대응 의도, 직전 결과, 포획 표식, 체력 | 안정도·공포·예측률 숫자·공식 |
| 결과 | 회수 품질, 피해, 지식 품질, 매뉴얼 delta | 전체 경제·장기 성장 |

### 접근성

- 1280×720과 1920×1080에서 현재 단계의 핵심 선택을 식별할 수 있어야 한다.
- 긴 한국어 자동 줄바꿈과 버튼 텍스트 잘림을 금지한다.
- 마우스·키보드를 동등 지원한다.
- `Esc`는 한 단계 뒤로 이동한다.
- 색상·음향만으로 전조·성공·위험을 전달하지 않는다.
- 시간 제한을 두지 않는다.
- 기존 화면 흔들림·섬광·왜곡 접근성 설정을 존중한다.

## 11. 플레이테스트 로그

```gdscript
class_name CoreMvp001PlaytestLog
extends RefCounted

func start_session(session_id: String, build_label: String, run_seed: int) -> void
func record(event_name: String, payload: Dictionary = {}) -> void
func get_events() -> Array[Dictionary]
func write_jsonl(path: String) -> Error
```

필수 이벤트:

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

- sequence는 1부터 연속 증가한다.
- payload는 deep copy한다.
- JSONL 한 줄에 한 객체를 쓴다.
- 기존 save path를 참조하지 않는다.
- 행동 로그, 퍼널, 종료 인터뷰를 서로 대체하지 않는다.

## 12. 사전 선언 지표

| 지표 | 통과 기준 | 주 증거 |
|---|---:|---|
| 규칙·대응 이유 설명 | 80% 이상 | 종료 인터뷰의 자기 말 설명 |
| 근거 기반 배제 | 70% 이상 | 유효 연결 로그·관찰 |
| 조사-회수 인과 체감 | 70% 이상 | 행동과 인터뷰 일치 |
| 핵심 실패의 난수 탓 | 20% 이하 | 실패 직후 질문 |
| 매뉴얼 저작감 | 80% 이상 | 결과 확인 뒤 인터뷰 |
| 미관측 패턴 무대응 인식 | 20% 이하 | 첫 발동 직후·종료 질문 |

- 신규 플레이어 5~8명을 주 코호트로 사용한다.
- 기존 프로젝트 노출 플레이어는 별도 코호트로 기록한다.
- 결과를 본 뒤 기준을 바꾸지 않는다.

## 13. 수용 기준

| ID | 요구 | 자동 증거 | 수동·플레이 증거 |
|---|---|---|---|
| AC-01 | 선택지 4·논리 배제 2 | JSON 계약 | 배제 이유 설명 |
| AC-02 | 부적합 연결 비용 없음 | 상태 테스트 | 피드백 이해 |
| AC-03 | 가설 지지 1개 이상 | 상태 테스트 | 저작감 |
| AC-04 | 이해도 결정론적 | 경계 테스트 | 단계 이해 |
| AC-05 | 패턴 해석 전 잠금 | 상태 테스트 | - |
| AC-06 | 거짓 전조 없음 | 모든 roll 테스트 | 실패 공정성 |
| AC-07 | 미관측 첫 패턴 범용 방어 | 상태 테스트 | 무대응 인식 20% 이하 |
| AC-08 | HP 0 대신 표식 포획 | 상태·장면 테스트 | 추리 증명 인식 |
| AC-09 | 실패가 위험 사례 생성 | 상태 테스트 | 다음 선택 변화 |
| AC-10 | 후보·공식·위험 분리 | 상태 테스트 | 결과 이해 |
| AC-11 | 기존 저장·세 사건 미변경 | diff·회귀 | 기존 캠페인 smoke |
| AC-12 | 720p/1080p·키보드·Esc | 장면 테스트 일부 | 실제 렌더·입력 QA |
| AC-13 | 이벤트 로그 완전성 | 로그 테스트 | 퍼널 계산 |
| AC-14 | 18~25분 | - | 세션 실측 |

## 14. 상태 전이와 게이트

```text
POC_PENDING
→ POC_BUILD_READY
→ POC_TESTING
├─ POC_PASSED → CORE-MVP-002 계획 승인 요청
├─ RETEST_REQUIRED → 변경안 1개만 적용 후 재검증
└─ HOLD → 지원 시스템 구현 금지
```

- 자동 테스트와 수동 QA 통과만으로 `POC_BUILD_READY`까지 가능하다.
- `POC_PASSED`에는 신규 플레이어 행동 증거와 사전 선언 지표가 필요하다.
- 조사와 회수가 별개로 인식되면 `HOLD`다.
- 난수 불공정이 반복되면 중간 이해도 확률을 축소하거나 결정적 정보 단계로 변경하고 재검증한다.

## 15. 롤백

CORE-MVP-001 구현을 철회할 때 다음만 제거한다.

- `data/poc/core_mvp_001/**`
- `scripts/poc/core_mvp_001/**`
- `scenes/poc/core_mvp_001/**`
- `tests/core_mvp_001_*`
- `tests/test_core_mvp_001_*`
- F1 개발 패널의 PoC 버튼
- regression runner의 신규 4개 엔트리
- `user://core_mvp_001_playtest.jsonl`

기존 저장·세 사건·시장·캠페인·GDD 코어 계약은 롤백 대상이 아니다.
