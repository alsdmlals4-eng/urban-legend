# 괴이 기록국 프로젝트 코어 통합 명세

> 문서 ID: `PROJECT-CORE-INTEGRATED-SPEC-2026-07-23`  
> 상태: `CORE_RECORDED / CORE_STRESS_TESTED`  
> 구현 상태: `POC_PENDING`  
> Production gate: `HOLD_UNTIL_PLAYER_EVIDENCE`  
> 적용 범위: 프로젝트 정체성 전체 + `CORE-MVP-001` 구현 계약  
> 구현 기준선: `MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039`

## 1. 문서 목적과 권한

이 문서는 PR 검토, 외부 벤치마킹, 적대적 검토 루프를 거쳐 확정된 **괴이 기록국의 최소 제품 정체성**과 이를 검증할 첫 PoC의 통합 계약을 정의한다.

책임 경계는 다음과 같다.

| 질문 | 책임 원본 |
|---|---|
| 바뀌면 다른 게임이 되는 최소 코어는 무엇인가 | `docs/PROJECT_CORE.md` |
| 상세 규칙·상태·데이터·UI·검증 계약은 무엇인가 | 이 문서 |
| PR·시장·SWOT·VRIO·적대적 검토 근거는 무엇인가 | `docs/planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md` |
| 현재 실제 구현은 무엇인가 | `docs/CURRENT_STATUS.md` |
| 구현 순서와 게이트는 무엇인가 | `MVP_ROADMAP.md` |
| CORE-MVP-001을 어떤 파일·테스트 순서로 구현하는가 | `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md` |

`CORE_RECORDED`는 설계 정체성이 확정됐다는 뜻이다. 실제 재미, 공정성, 시장 적합성, 플레이 시간은 CORE-MVP-001의 신규 플레이어 행동 증거가 생기기 전까지 확정하지 않는다.

## 2. 현재 기준선과 목표선

### 2.1 현행 구현 기준선

현재 `main` 기준 제품은 다음을 이미 보유한다.

- 권나래 고정 주인공과 최대 2인 서포트
- 최대 10일, 오전·오후 반일 캠페인
- 세 사건의 조사·판단·안정화·잔향 회수·보고서·DB
- 저승역의 `가설 → 근거 → 대응` 판단 흐름
- 공식 규칙·후보·위험 사례의 `anomaly_manual_records` 저장
- 자동 전조 예측, 안정도·공포·능력값·장비·소모품·미니게임 보정
- 저장 Schema `mvp-039`, `mvp-038` 이관

이 기준선은 회귀 보호 대상이며 새 코어가 구현됐다는 증거가 아니다.

### 2.2 승인 목표선

```text
관측
→ 매뉴얼 기록과 비교
→ 4개 선택지 중 2개 논리 배제
→ 규칙 가설 카드 작성
→ 위험을 감수한 현장 검증
→ 현장 이해도 갱신
→ 전조 해석
→ 턴제 패턴 대응
→ 포획 창 개방·잔향 회수
→ 후보·공식 규칙·위험 사례 기록
```

## 3. 대상 플레이어와 시장 포지션

### 3.1 대상 플레이어

- 오컬트·괴담 서사를 좋아하지만 수동적인 비주얼 노벨보다 직접 판단하기를 원하는 플레이어
- 정답 찍기보다 관측·비교·설명하는 추리를 선호하는 플레이어
- 실시간 액션보다 낮은 입력 부담의 턴제 판단을 선호하는 플레이어
- 실패가 재시작 명령보다 새 정보와 다음 선택을 남기기를 기대하는 플레이어
- 한 사건 18~25분 안에 조사와 회수가 완결되는 세션을 원하는 PC 플레이어

### 3.2 시장 차별화 문장

> **괴담의 진실을 밝히는 게임이 아니라, 다시 나타날 괴이에서 살아남을 규칙을 직접 기록하고 전투에서 증명하는 팀 수사 게임.**

기관형 도시괴담 조사 자체는 차별 요소로 충분하지 않다. 차별화의 중심은 다음 세 요소의 결합이다.

1. 플레이어가 규칙 문장과 근거 관계를 직접 구성한다.
2. 조사 지식이 회수 전투의 전조 정보로 즉시 변환된다.
3. 성공과 실패가 다음 출현의 실제 판단 자산으로 남는다.

## 4. 프로젝트 정체성과 뾰족한 재미

### 4.1 프로젝트 정체성 한 문장

> 플레이어는 고정 주인공 **권나래**로서 관측 가능한 단서로 괴이의 규칙 가설을 만들고, 위험을 감수한 검증으로 이해를 갱신한 뒤, 그 이해로 턴제 회수 전투의 전조를 읽어 포획 조건을 열고, 성공과 실패를 다음 출현의 **괴이 매뉴얼**로 기록한다.

### 4.2 플레이어 약속

> 내가 조사한 만큼 전투에서 괴이를 더 정확히 읽을 수 있고, 내가 직접 기록한 만큼 다음 출현에서 더 안전하고 더 나은 결말을 선택할 수 있다.

### 4.3 뾰족한 재미

> **조사에서 읽은 규칙이 회수 전투의 전조로 실제 나타나고, 준비한 대응으로 포획 창을 여는 순간.**

### 4.4 감정 목표

| 단계 | 감정 |
|---|---|
| 관측·배제 | 가능성이 줄어드는 `Aha` |
| 위험 검증 | 아직 모르는 조건에 결단하는 `Dread` |
| 전조 해석 | 조사 성과가 전투 정보가 되는 `Mastery` |
| 매뉴얼 기록 | 내가 지식을 만들었다는 `Authorship` |
| 히든 결과 | 인간과 괴이의 비극을 줄이는 `Care` |

## 5. 최소 코어·지원 시스템·변경 경계

### 5.1 PROJECT_CORE — 불변 계약

1. **관측 가능한 페어플레이 정보**  
   핵심 단서와 모순 관계는 플레이어가 확인 가능한 정보로 판정한다.

2. **플레이어 작성형 규칙 가설**  
   플레이어가 규칙 문장에 지지·반박·미해결 근거를 연결한다.

3. **합리적 확신 뒤 위험 검증**  
   조사는 위험을 제거하지 않고 감당 가능한 불확실성으로 줄인다.

4. **조사 지식의 전투 정보 우위 변환**  
   현장 이해도는 공격력 대신 전조·대상·범위·조건의 정보량을 바꾼다.

5. **패턴 대응형 회수**  
   괴이를 처치하지 않고 올바른 대응 누적으로 안정화·봉쇄·포획 조건을 연다.

6. **성공과 실패의 영구 기록**  
   성공은 공식 규칙, 실패는 위험 사례와 배제 근거로 남는다.

### 5.2 정체성 앵커

- 주인공은 권나래로 고정한다.
- 플레이어는 권나래의 관측·가설·결단을 책임진다.
- 공식 기관명은 **괴이 기록국**이다.
- 통제 완료는 **안정화 상태**, 실패 기록은 **위험 사례**, 회수 대상은 **잔향**, 지식 보상은 **괴이 매뉴얼**이다.

### 5.3 CORE_SUPPORT — 승인됐지만 교체·감량 가능한 방향

- 최대 2인 서포트 편성
- 체력·부상·회복과 3축 결과 등급
- 포획·연구·괴이 전용 대응
- 기간제 챕터와 핵심 사건 마감
- 연계 의뢰 1개 + 독립 의뢰 1개
- 신뢰도·잔향 파편·연구도 소량 보상
- 조사에서 조건을 만들고 회수에서 실행하는 히든 분기
- 괴이 구제·민간인 보호·기관 명령 준수·진실 공개 엔딩 축
- 기록관 아카, DB, 보고서, 일상·후일담·컷인
- 기존 미니게임의 조건부 재사용

### 5.4 CHANGEABLE

- 이해도 단계별 실제 전조 해석 확률
- 선택지·단서·패턴·턴 수
- 체력·위험도·부상·등급 수치
- 챕터 길이와 의뢰 수
- 연구 비용과 보상량
- UI 배치와 연출 밀도

### 5.5 REQUIRES_REAPPROVAL

- `관측 → 가설 → 검증 → 전조 → 대응 → 기록` 인과 제거
- 플레이어 가설 작성을 자동 판정으로 대체
- 턴제 회수를 일반 화력전·자동전투로 변경
- 괴이 처치를 기본 승리 조건으로 변경
- 실패의 정보 가치·위험 사례·잔향·매뉴얼 의미 변경
- 권나래 고정 주인공 또는 플레이어 역할 변경
- 실제 저장 Schema·캠페인·경제·엔딩 통합

## 6. CORE-MVP-001 범위

### 6.1 목표

> 조사에서 만든 규칙 가설이 회수 전투의 전조 정보가 되고, 준비한 대응으로 포획 창을 여는 순간이 실제 플레이의 중심 재미로 작동하는지 검증한다.

### 6.2 포함

- 저승역을 소재로 한 독립 PoC 사건 1개
- 플레이 시간 18~25분
- 조사 장면 3개
- 핵심 단서 6개: 지지 3, 반박 2, 미해결 1
- 4개 선택지, 논리 배제 2개
- 경쟁 가설 카드 2개
- 현장 이해도 4단계
- 회수 패턴 3개: 관측 가능 2, 미관측 핵심 1
- 회수 5~8턴
- 정상 포획 / 비용 있는 포획 / 긴급 포획
- 체력, 괴이 위험도, 범용 방어
- 로컬 플레이테스트 이벤트 로그

### 6.3 제외

- `game_state.gd` 저장 필드 추가
- `mvp-039` 버전 증가
- 기존 세 사건 데이터 수정
- 기존 `investigation_scene.gd`, `battle_scene.gd` 직접 개조
- 장비·시장·세력·서포트 능력값
- 부상·회복 일정
- 연구 트리·히든 분기·엔딩
- 실제 캠페인 합류

## 7. PoC 기술 아키텍처

### 7.1 격리 원칙

CORE-MVP-001은 기존 캠페인과 저장을 오염시키지 않는 독립 경로로 구현한다.

```text
main_menu.gd의 debug 전용 버튼
→ core_mvp_001_scene.tscn
→ CoreMvp001Controller
   ├─ CoreMvp001CaseData
   ├─ CoreMvp001State
   └─ CoreMvp001PlaytestLog
```

### 7.2 신규 파일 책임

| 경로 | 책임 |
|---|---|
| `data/poc/core_mvp_001/afterlife_station_poc.json` | 단일 PoC 사건의 모든 규칙·단서·가설·패턴·결과 |
| `scripts/poc/core_mvp_001/core_mvp_001_case_data.gd` | JSON 로드·필수 필드·참조 무결성 검증 |
| `scripts/poc/core_mvp_001/core_mvp_001_state.gd` | 순수 상태 머신, 논리 배제, 이해도, 전조 판정, 포획 조건 |
| `scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd` | 세션 이벤트를 JSONL로 기록·내보내기 |
| `scripts/poc/core_mvp_001/core_mvp_001_scene.gd` | UI 렌더와 입력을 상태 인터페이스에 연결 |
| `scenes/poc/core_mvp_001/core_mvp_001_scene.tscn` | 16:9 PoC 화면과 명명된 UI 노드 |

### 7.3 기존 파일 변경 허용

| 경로 | 허용 변경 |
|---|---|
| `scripts/ui/main_menu.gd` | F1 개발 패널에 PoC 장면 버튼 1개 추가 |
| `tests/run_godot_regression.sh` | 신규 테스트 엔트리 등록·총계 갱신 |
| `TEST_CHECKLIST.md` | CORE-MVP-001 조건부 검증 추가 |
| `docs/CURRENT_STATUS.md` | 실제 구현 완료 후에만 상태 갱신 |
| `MVP_ROADMAP.md` | 실제 플레이테스트 판정 후 다음 게이트 갱신 |

### 7.4 보호 파일

다음 파일은 CORE-MVP-001에서 수정하지 않는다.

- `scripts/core/game_state.gd`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `data/episodes/**`
- `project.godot`
- `knowledge/base-pack/**`

## 8. 상태 머신

### 8.1 전체 단계

```text
BOOT
→ INVESTIGATION_SITUATION
→ ELIMINATION
→ HYPOTHESIS_AUTHORING
→ FIELD_TEST
├─ HYPOTHESIS_REFRESH
├─ RECOVERY_READY
└─ EMERGENCY_RECOVERY
→ RECOVERY_TURN_START
→ OMEN_READ
→ RESPONSE_SELECTION
→ RESPONSE_RESOLUTION
├─ RECOVERY_TURN_START
├─ CAPTURE_WINDOW
└─ EMERGENCY_CAPTURE
→ RESULT_COMPARE
→ MANUAL_PROMOTION
→ COMPLETE
```

### 8.2 조사 전이

| 현재 | 입력 | 조건 | 다음 | 결과 |
|---|---|---|---|---|
| `INVESTIGATION_SITUATION` | 장면 진행 | 없음 | `ELIMINATION` | 선택지 4개·관련 기록 2~3개 표시 |
| `ELIMINATION` | 기록-선택지 연결 | 유효한 모순 | `ELIMINATION` | 선택지 1개 배제 |
| `ELIMINATION` | 기록-선택지 연결 | 부적합 | `ELIMINATION` | 비용 없이 실패 이유 표시 |
| `ELIMINATION` | 계속 | 배제 2개 | `HYPOTHESIS_AUTHORING` | 경쟁 가설 2개 고정 |
| `HYPOTHESIS_AUTHORING` | 가설 제출 | 지지 근거 ≥1 | `FIELD_TEST` | 카드와 미해결 조건 저장 |
| `FIELD_TEST` | 검증 행동 | 가설 적중 | `RECOVERY_READY` | 이해도 승격·위험 소폭 변화 |
| `FIELD_TEST` | 검증 행동 | 가설 실패·위험 미만 | `HYPOTHESIS_REFRESH` | 반응 단서·위험 사례·부분 갱신 |
| `FIELD_TEST` | 검증 행동 | 위험 한계 | `EMERGENCY_RECOVERY` | 추가 검증 금지 |

### 8.3 회수 전이

| 현재 | 입력 | 조건 | 다음 | 결과 |
|---|---|---|---|---|
| `RECOVERY_TURN_START` | 턴 시작 | 패턴 존재 | `OMEN_READ` | 실제 패턴 먼저 잠금 |
| `OMEN_READ` | 해석 | 성공 | `RESPONSE_SELECTION` | 허용 범위의 실제 정보 공개 |
| `OMEN_READ` | 해석 | 실패 | `RESPONSE_SELECTION` | `놈은 무언가 하려 한다.` |
| `RESPONSE_SELECTION` | 행동 선택 | 없음 | `RESPONSE_RESOLUTION` | 대응 판정 |
| `RESPONSE_RESOLUTION` | 결과 | 올바른 대응 | `RECOVERY_TURN_START` 또는 `CAPTURE_WINDOW` | 포획 표식 증가 |
| `RESPONSE_RESOLUTION` | 결과 | 오대응 | `RECOVERY_TURN_START` 또는 `EMERGENCY_CAPTURE` | 피해·위험·위험 사례 |
| `CAPTURE_WINDOW` | 포획 | 조건 충족 | `RESULT_COMPARE` | 정상/비용 포획 |
| `EMERGENCY_CAPTURE` | 긴급 포획 | 위험 한계 | `RESULT_COMPARE` | 낮은 회수 품질·잔류 위험 |

## 9. 데이터 계약

### 9.1 최상위 Schema

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

### 9.2 ID 규칙

- PoC 전용 ID는 `poc001_` 접두사를 사용한다.
- 기존 `episode_001_afterlife_station`의 ID를 복제하거나 덮어쓰지 않는다.
- 모든 참조 ID는 같은 JSON 안에서 해소돼야 한다.
- 배열 순서는 플레이 순서이며 런타임에서 임의 재정렬하지 않는다.

### 9.3 단서

```json
{
  "id": "poc001_clue_broadcast_blank",
  "title": "목적지 공백이 있는 방송 원본",
  "text": "방송 원본의 목적지 구간은 비어 있다.",
  "role": "support",
  "scene_id": "poc001_scene_control_room",
  "observable": true
}
```

`role`은 `support / contradiction / unresolved` 중 하나다. `observable=false` 단서는 핵심 판정에 사용할 수 없다.

### 9.4 매뉴얼 기록

```json
{
  "id": "poc001_manual_early_movement_reset",
  "title": "안내 종료 전 이동 사례",
  "statement": "안내가 끝나기 전에 이동하면 출발 위치로 되돌아왔다.",
  "status": "danger_case",
  "known_at_start": true
}
```

### 9.5 조사 선택지

```json
{
  "id": "poc001_choice_follow_display",
  "label": "전광판에 표시된 종착지를 따라간다",
  "hypothesis_id": "poc001_hypothesis_display_route"
}
```

### 9.6 논리 배제 규칙

```json
{
  "record_id": "poc001_manual_early_movement_reset",
  "choice_id": "poc001_choice_move_before_end",
  "relation": "contradiction",
  "feedback": "기존 위험 사례와 충돌한다. 이 선택지는 배제할 수 있다."
}
```

부적합한 조합은 상태·체력·위험도를 변경하지 않는다.

### 9.7 규칙 가설

```json
{
  "id": "poc001_hypothesis_broadcast_blank",
  "rule_text": "방송의 빈 목적지를 개인 기억으로 채워 듣고, 안내 종료 전 이동하면 공간이 초기화된다.",
  "required_supporting_clue_ids": [
    "poc001_clue_broadcast_blank",
    "poc001_clue_reset_timing"
  ],
  "authored_contradiction_clue_ids": [],
  "unresolved_question_ids": [
    "poc001_question_safe_identifier"
  ],
  "field_test_id": "poc001_test_wait_for_end"
}
```

플레이어 상태에는 `selected_supporting_clue_ids`, `selected_contradiction_clue_ids`, `selected_unresolved_question_ids`를 별도로 저장한다.

### 9.8 현장 이해도

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

단계 승격은 확률이 아니라 근거 계약으로 결정한다.

| 단계 | 승격 조건 |
|---|---|
| `unknown` | 유효한 지지 근거 없음 |
| `clue` | 지지 근거 1개 이상 |
| `likely` | 선택지 2개 배제 + 지지 근거 충족 + 반박 확인 |
| `understood` | 결정적 현장 검증 성공 + 미해결 질문의 핵심 조건 해소 |

### 9.9 회수 패턴

```json
{
  "id": "poc001_pattern_false_terminal",
  "name": "존재하지 않는 종착 안내",
  "omen_text": "방송이 반복될 때마다 전광판의 글자가 한 칸씩 사라진다.",
  "observed_before_recovery": true,
  "readable_fields": ["action_name", "target", "condition"],
  "action_name": "거짓 종착 유도",
  "target": "권나래",
  "range": "단일",
  "condition": "안내 종료 전에 이동한 대상",
  "valid_action_ids": ["poc001_action_hold_position"],
  "capture_mark": "broadcast_cut"
}
```

### 9.10 회수 순서

```json
{
  "recovery_sequence": [
    "poc001_pattern_false_terminal",
    "poc001_pattern_boundary_fold",
    "poc001_pattern_ticket_imprint",
    "poc001_pattern_false_terminal",
    "poc001_pattern_ticket_imprint"
  ]
}
```

정상 경로는 최소 5턴을 사용한다. 미관측 핵심 패턴은 첫 발동에 관측만 되고, 두 번째 발동에서 전용 대응으로 포획 표식을 얻는다.

### 9.11 미관측 핵심 패턴

```json
{
  "id": "poc001_pattern_ticket_imprint",
  "name": "검은 승차권의 승객 각인",
  "omen_text": "검은 천공 자국이 사람 이름과 비슷한 획으로 번진다.",
  "observed_before_recovery": false,
  "first_use_hidden": true,
  "generic_mitigation_action_ids": [
    "poc001_action_guard",
    "poc001_action_cover",
    "poc001_action_protect_trace"
  ],
  "max_first_observation_damage": 18,
  "valid_action_ids_after_observation": ["poc001_action_isolate_ticket"],
  "capture_mark": "ticket_isolated"
}
```

최초 발동은 체력 0, 강제 중상, 진행 차단, 영구 분기 실패를 만들 수 없다.

### 9.12 회수 행동

```json
{
  "id": "poc001_action_hold_position",
  "category": "rule_response",
  "label": "안내가 끝날 때까지 현재 위치를 고정한다",
  "generic": false
}
```

카테고리는 `observe / guard / support / rule_response / capture` 중 하나다.

### 9.13 포획 규칙

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

## 10. 런타임 인터페이스

### 10.1 `CoreMvp001CaseData`

```gdscript
class_name CoreMvp001CaseData
extends RefCounted

static func load_case(path: String) -> Dictionary
static func validate_case(data: Dictionary) -> Array[String]
static func index_by_id(entries: Array) -> Dictionary
```

- `load_case`는 파일 오류나 JSON 오류 시 `{}`를 반환한다.
- `validate_case`는 사람이 읽을 수 있는 오류 문자열 배열을 반환한다.
- 검증 실패 데이터로 PoC를 시작하지 않는다.

### 10.2 `CoreMvp001State`

```gdscript
class_name CoreMvp001State
extends RefCounted

func start(case_data: Dictionary, run_seed: int = 1001) -> void
func get_snapshot() -> Dictionary
func link_record_to_choice(record_id: String, choice_id: String) -> Dictionary
func submit_hypothesis(hypothesis_id: String, supporting_ids: Array[String], contradiction_ids: Array[String], unresolved_ids: Array[String]) -> Dictionary
func resolve_field_test(field_test_id: String) -> Dictionary
func begin_recovery_turn() -> Dictionary
func read_current_omen(forced_roll: int = -1) -> Dictionary
func resolve_recovery_action(action_id: String) -> Dictionary
func execute_capture() -> Dictionary
func build_manual_delta() -> Dictionary
func build_result() -> Dictionary
```

모든 명령은 다음 공통 응답 구조를 사용한다.

```gdscript
{
    "ok": true,
    "error": "",
    "state_changed": true,
    "events": [],
    "snapshot": {}
}
```

### 10.3 `CoreMvp001PlaytestLog`

```gdscript
class_name CoreMvp001PlaytestLog
extends RefCounted

func start_session(session_id: String, build_label: String, run_seed: int) -> void
func record(event_name: String, payload: Dictionary = {}) -> void
func get_events() -> Array[Dictionary]
func write_jsonl(path: String) -> Error
```

PoC 로그는 `user://core_mvp_001_playtest.jsonl`에 쓴다. 기존 저장 파일을 읽거나 수정하지 않는다.

## 11. 페어플레이와 확률 계약

### 11.1 난수 금지

- 단서 내용·획득 여부
- 기록과 선택지의 모순
- 가설의 지지·반박 관계
- 이해도 승격
- 실제 회수 패턴
- 올바른 대응과 포획 조건
- 공식 규칙·후보·위험 사례 승격

### 11.2 난수 허용

중간 이해도에서 **이미 관측한 패턴**의 세부 전조를 이번 턴에 읽는지에만 사용한다.

- 실제 패턴을 먼저 고정한다.
- 해석 실패가 패턴 자체를 바꾸지 않는다.
- 실패 시 거짓 정보가 아니라 정보 비공개만 발생한다.
- `understood`는 관측 패턴을 100% 해석한다.
- 테스트는 `forced_roll`을 주입해 경계를 검증한다.
- PoC는 이어하기를 지원하지 않으므로 재추첨 경로가 없다.

### 11.3 표시 문구

- 실패: `놈은 무언가 하려 한다.`
- 성공: `놈은 [행동명]을 하려 한다.`
- 정보 공개량은 이해한 필드까지만 허용한다.
- 대응 추천, 최적 행동 강조, 거짓 대상·범위는 금지한다.

## 12. 실패·위험·회복 가능성

### 12.1 조사 오답

- 체력 감소
- 괴이 위험도 상승
- 현상 심화
- 반응 단서 생성
- 위험 사례 생성
- 기존 가설 1개 + 신규 변형 가설 1개로 갱신

정보 없는 자원 손실은 금지한다.

### 12.2 회수 오대응

- 회복 가능한 체력 손실
- 괴이 위험도 상승
- 해당 행동이 배제되는 이유 기록
- 포획 표식은 감소시키지 않되 긴급 포획 조건이 가까워질 수 있음

### 12.3 소프트락 방지

- 체력이 0이 되기 전에 긴급 포획으로 전환한다.
- 미관측 패턴 첫 발동은 최대 피해 상한을 가진다.
- 모든 불명 전조에는 최소 1개의 유효한 범용 방어가 있다.
- 잘못된 기록 연결에는 체력·시간·위험 비용이 없다.

## 13. 괴이 매뉴얼 결과 계약

### 13.1 기록 상태

| 상태 | 조건 | 의미 |
|---|---|---|
| `candidate` | 대응은 맞았지만 가설·근거·미해결 조건이 불완전 | 재검증 필요 |
| `verified` | 규칙 문장·지지·반박·결정적 검증이 일치 | 공식 규칙 |
| `danger_case` | 잘못된 가설·대응과 관측 결과 | 이후 배제 근거 |

### 13.2 PoC에서 검증하는 영속성

CORE-MVP-001은 한 세션 안에서 다음을 검증한다.

- 조사 가설이 결과 화면으로 전달됨
- 회수 관측이 가설 카드에 합쳐짐
- 공식·후보·위험 사례가 구분됨
- 위험 사례가 성공 후에도 삭제되지 않음

실제 저장·재출현 활용은 CORE-MVP-002에서 새 저장 계약 승인 뒤 검증한다.

## 14. UI·접근성 계약

### 14.1 화면 우선순위

| 단계 | 전면 정보 | 접거나 제외할 정보 |
|---|---|---|
| 조사 | 현재 상황, 선택지 4개, 관련 기록 2~3개, 가설 카드, 체력·위험 | 장비·세력·관계·능력값·시장 |
| 회수 | 전조, 해석 결과, 대응 의도, 직전 결과, 포획 표식, 체력 | 안정도·공포·예측률 숫자, 요원 능력 공식, 소모품 |
| 결과 | 회수 품질, 피해, 지식 품질, 매뉴얼 변화 | 전체 경제 보상·장기 성장 |

### 14.2 필수 접근성

- 1280×720과 1920×1080에서 핵심 선택이 스크롤 없이 식별 가능
- 긴 한국어 자동 줄바꿈과 버튼 텍스트 잘림 금지
- 마우스·키보드 동등 지원
- `Esc`는 한 단계 뒤로 가며 선택한 근거를 보존
- 색상·음향만으로 전조·성공·위험을 전달하지 않음
- 시간 제한 없음
- 화면 흔들림·섬광·왜곡은 기존 접근성 설정을 존중
- 미관측 전조는 텍스트와 아이콘으로 함께 표시

## 15. 플레이테스트 이벤트와 퍼널

### 15.1 이벤트

| 이벤트 | 필수 payload |
|---|---|
| `poc_started` | `session_id`, `run_seed`, `build_label` |
| `investigation_scene_viewed` | `scene_id`, `elapsed_ms` |
| `manual_record_linked` | `record_id`, `choice_id`, `valid` |
| `choice_eliminated` | `choice_id`, `record_id` |
| `hypothesis_submitted` | `hypothesis_id`, `support_count`, `contradiction_count`, `unresolved_count` |
| `field_test_resolved` | `field_test_id`, `correct`, `damage`, `risk_delta` |
| `understanding_changed` | `from`, `to`, `reason` |
| `recovery_turn_started` | `turn`, `pattern_id`, `first_use_hidden` |
| `omen_read` | `tier`, `roll`, `success`, `revealed_fields` |
| `recovery_action_resolved` | `action_id`, `valid`, `damage`, `capture_mark` |
| `capture_window_opened` | `turn`, `marks` |
| `poc_completed` | `outcome_id`, `duration_ms`, `damage`, `danger_case_count` |

### 15.2 퍼널

```text
PoC 시작
→ 첫 기록 열람
→ 첫 유효 배제
→ 2개 배제 완료
→ 가설 제출
→ 현장 검증
→ 회수 진입
→ 첫 전조 대응
→ 포획 창
→ 매뉴얼 결과 확인
```

각 단계의 이탈, 소요 시간, 무효 연결 반복 횟수를 기록한다.

## 16. 사전 선언 성공 지표

| 지표 | 통과 기준 | 측정 |
|---|---:|---|
| 규칙·대응 이유 설명 | 80% 이상 | 종료 인터뷰, 자기 말 설명 |
| 근거 기반 배제 | 70% 이상 | 유효 연결 로그, 무작위 반복 제외 |
| 조사-회수 인과 체감 | 70% 이상 | 행동 로그 + 인터뷰 일치 |
| 핵심 실패의 난수 탓 | 20% 이하 | 실패 직후 질문 |
| 매뉴얼 저작감 | 80% 이상 | “내가 만든 기록” 인식 |
| 미관측 패턴 무대응 인식 | 20% 이하 | 첫 패턴 직후·종료 질문 |

### 16.1 표본

- 신규 플레이어 5~8명 1차 관찰
- 기존 프로젝트 노출 플레이어는 별도 코호트로 기록
- 신규 플레이어 지표를 주 판정으로 사용
- 관찰 행동, 로그 수치, 인터뷰 자기보고를 분리

### 16.2 판정

| 결과 | 결정 |
|---|---|
| 전 지표 통과 | `KEEP / AMPLIFY`, CORE-MVP-002 계획 작성 |
| 규칙 설명 통과, 전투 연결 실패 | 전조 UI·포획 행동 `CHANGE / RETEST` |
| 배제가 찍기·자동 정답처럼 보임 | 가설 카드·근거 연결 `CHANGE / RETEST` |
| 난수 불공정 반복 | 중간 단계 확률 축소 또는 결정적 정보 단계로 `CHANGE` |
| 조사와 회수가 별개로 인식 | `HOLD`, 지원 시스템 확장 금지 |

## 17. 벤치마킹 판정

| 사례 | 원리 | 적용 | 제외 | 판정 |
|---|---|---|---|---|
| Urban Myth Dissolution Center | 기관형 도시괴담, 정황 증거·소셜 기록, 에피소드 조사 | 팀·실패 학습·장기 매뉴얼·회수 인과로 차별화 | 기관 외형·픽셀 연출·해체 구조 복제 | `ADAPT` |
| PARANORMASIGHT | 실제 지역성과 인물 갈등을 초자연 규칙에 결합 | 한국 도시 장소·공공 기록·소문을 규칙에 연결 | 다중 시점·저주 대결 복제 | `ADAPT` |
| Golden Idol | 관찰 정보를 플레이어가 이론으로 조립 | 규칙 가설 카드와 근거 관계 | 단어 끼워넣기 외형·브루트포스 | `ADOPT 원리 / ADAPT UI` |
| Return of the Obra Dinn | 기록장이 핵심 추론 도구 | 매뉴얼에 불확실성·반증·부분 확정 유지 | 시각 외형·장면 재생 장치 | `ADAPT` |
| No Case Should Remain Unsolved | 압축된 범위와 기억 연결, 감정적 종결 | 첫 공개 빌드 사건 수 축소·후일담 강화 | 모든 사건을 같은 기억 퍼즐로 제작 | `ADOPT` |
| Lobotomy Corporation | 개체별 시행착오와 정보 축적 | 괴이별 매뉴얼을 다음 판단 자산으로 사용 | 영구 사망·시설 경영·반복 노동·제압 중심 | `ADAPT` |
| Disco Elysium | 실패가 정보·대화·관계 반응을 생성 | 위험 사례가 보고서·관계·다음 질문을 변화 | 핵심 판정 난수·장문 내면 독백 | `ADAPT` |
| WORLD OF HORROR | 모듈형 괴담·턴제 공포·강한 시각 문법 | 공통 사건 카드·전조 대응 문법 | 로그라이트 랜덤·화력전·불친절 | `ADAPT / AVOID` |

## 18. 적대적 검토 결과

### 18.1 MUST_FIX 반영

- 코어 범위 팽창 → 최소 코어와 CORE_SUPPORT 분리
- 추리와 확률 충돌 → 논리 영역과 정보 해석 확률 분리
- 매뉴얼 결과 요약화 → 규칙 가설 카드 도입
- 미관측 패턴 불공정 → 범용 방어·피해 상한·비가역 처벌 금지
- 문서 확정과 플레이 검증 혼동 → `POC_PENDING / HOLD_UNTIL_PLAYER_EVIDENCE`
- 기존 화면 개조로 실험 오염 → 독립 PoC 경로

### 18.2 SHOULD_FIX 반영

- 영구 지식과 현장 이해도 분리
- 회수 승리 조건을 포획 창으로 명시
- 기본 UI 수치 감량
- 서포트 정답 독점 금지
- 미니게임 공통 인지 문법
- 히든 분기 상위 정답화 금지

### 18.3 DEFER

- MVP-044~046 대량 서사·관계·연출
- 시장·세력·연구 트리 확장
- 복수 챕터와 대규모 엔딩 조합
- 추가 괴이 수량 확정

## 19. 수용 기준 매트릭스

| ID | 요구 | 자동 검증 | 수동/플레이 검증 |
|---|---|---|---|
| AC-01 | 4개 선택지와 정확히 2개 논리 배제 | JSON 계약 테스트 | 배제 이유 설명 |
| AC-02 | 부적합 연결 비용 없음 | 상태 테스트 | 피드백 가독성 |
| AC-03 | 가설 카드 지지 ≥1 | 상태 테스트 | 저작감 인터뷰 |
| AC-04 | 이해도 승격 결정론적 | 경계 테스트 | 단계 의미 이해 |
| AC-05 | 실제 패턴이 해석 전에 잠금 | 상태 테스트 | 없음 |
| AC-06 | 거짓 전조 없음 | 모든 roll 테스트 | 실패 공정성 |
| AC-07 | 미관측 첫 패턴 범용 방어 유효 | 상태 테스트 | 무대응 인식 ≤20% |
| AC-08 | HP 0 대신 포획 표식 승리 | 상태·장면 테스트 | 전투가 추리 증명으로 인식 |
| AC-09 | 실패가 위험 사례 생성 | 상태 테스트 | 다음 선택 변화 |
| AC-10 | 매뉴얼 후보·공식·위험 분리 | 상태 테스트 | 결과 이해 |
| AC-11 | 기존 저장·세 사건 미변경 | diff·회귀 테스트 | 기존 캠페인 smoke |
| AC-12 | 720p/1080p와 키보드·Esc | 장면 테스트 일부 | 실제 렌더·입력 QA |
| AC-13 | 이벤트 로그 완전성 | 로그 테스트 | 퍼널 계산 |
| AC-14 | PoC 18~25분 | 없음 | 세션 측정 |

## 20. 구현 이후 문서 상태 전이

```text
POC_PENDING
→ POC_BUILD_READY
→ POC_TESTING
├─ POC_PASSED → CORE-MVP-002 계획 승인 요청
├─ RETEST_REQUIRED → 변경안 1개만 적용 후 재검증
└─ HOLD → 지원 시스템 구현 금지
```

`POC_PASSED`는 자동 테스트 통과만으로 부여하지 않는다. 신규 플레이어 행동 증거와 사전 선언 지표 판정이 필요하다.
