# Validation CHANGE_PROPOSAL — 최신 main 기반 격리 아키텍처

> Proposal ID: `P-2026-08-02-VALIDATION-CHANGE-PROPOSAL`
> Parent Decision: `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
> 제품 Target: `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL`
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> 상태: `READY_FOR_ADVERSARIAL_REVIEW / IMPLEMENTATION_NOT_AUTHORIZED`
> 제품 파일 변경: `NONE`
> Runtime / Human QA: `NOT_RUN`

## 1. 결론

구형 구현 계획의 제품 목표·별도 저장·Legacy 보존·RED 우선 원칙은 유지한다. 그러나 다음 구조는 그대로 구현하지 않는다.

1. 존재하지 않는 `scripts/core/game_bootstrap.gd`를 baseline으로 사용
2. 존재하지 않는 여러 smoke test 이름을 현행 회귀로 사용
3. `ValidationFlowState`가 조사·가설·시간순·노선·회수·결과 도메인 상태를 모두 다시 소유
4. 기존 `GameState.save_game()`을 그대로 둔 채 기존 Scene을 Validation에 사용
5. 거대한 `preparation_scene`·`result_scene`를 단순 모드 분기로 재사용
6. 기존 대화·조사 UI 위에 별도 `validation_text_novel_shell`을 중복 구축

권장 아키텍처:

```text
SCREEN-01 기존 main_menu
→ ValidationSession Autoload
→ 별도 Validation Save Repository
→ 기존 dialogue/investigation/minigame/battle의 검증된 전문 절차를 명시적 Validation mode로 재사용
→ 부작용이 큰 준비·결과는 전용 Validation Scene
→ ValidationResultCalculator + apply_once ledger
→ SCREEN-01 복귀
```

핵심 원칙:

```text
ValidationSession = 경로·checkpoint·return target·저장 namespace·effect ledger의 단일 소유자
GameState = 기존 사건 도메인 runtime engine, Legacy save 권위 유지
ValidationSaveRepository = 별도 파일·별도 버전·손상 격리
전문 Scene = 도메인 판단의 활성 소유자
Validation 전용 준비/결과 Scene = Legacy 캠페인·경제 부작용 차단
```

## 2. 최신 main에서 확인한 실제 계약

### 2.1 시작점·Autoload

`project.godot`:

```text
main scene = res://scenes/main_menu.tscn
UrbanLegendState = static section data
GameState = 전체 Legacy runtime/save/domain state
_mcp_game_helper = 도구 runtime
viewport = 1280×720
stretch = canvas_items / expand
renderer = mobile
```

`UrbanLegendState`는 정적 DB 섹션만 제공하므로 Validation 세션 저장소로 재사용하지 않는다.

### 2.2 Legacy 저장

`GameState`:

```text
SAVE_FILE_PATH = user://urban_legend_save.json
SAVE_VERSION = mvp-039
save_game() = _make_save_data() 전체를 Legacy 파일에 기록
load_game() = 캠페인·사건·조사·회수·보고서·경제·관계·Scene 경로 복원
clear_save_file() = Legacy 파일 삭제
```

`_make_save_data()`는 다음을 함께 저장한다.

- campaign state
- episode·scene·dialogue·field·minigame
- flags·clues·hints·method/minigame results
- 요원 편성·HP·정신력·신뢰·이벤트
- 기록·장비·연구·보고서·괴이 매뉴얼
- 일상 에피소드
- 잔향·세력·의뢰·시장·소모품
- 위험·이해·안정도·예측
- 회수 패턴·결과

기존 Scene의 많은 함수가 `GameState.save_game()`을 직접 호출한다. 별도 Validation 저장소만 추가하고 이 호출을 라우팅하지 않으면 Validation 진행이 Legacy 파일을 덮어쓴다.

### 2.3 시작·이어하기

`main_menu.gd`:

- 단일 Legacy 저장 상태를 표시
- 새 시작은 `clear_save_file()` 호출
- `restart_afterlife_station_flow()` 뒤 `save_game()`
- 이어하기는 `load_game()` 뒤 `current_scene_path`로 이동

현행 시작·이어하기를 Validation과 Legacy로 구분하려면 메뉴 모델과 저장 namespace를 함께 바꿔야 한다.

### 2.4 대화·조사

`dialogue_scene.gd`:

- 저승역 브리핑과 일반 VN UI가 이미 존재
- JSON 대화 선택은 `apply_story_effects()`와 `save_game()`을 호출
- 다음 node·next_scene_path를 사용

`investigation_scene.gd`:

- 텍스트 조사
- 기록 Drawer
- 현장 node·선택
- 전문 절차 진입
- 조사·가설·회수 전환 UI

별도 범용 Text Novel Shell을 새로 만들면 화면·포커스·저장·기록 Drawer 책임이 중복된다.

### 2.5 준비

`preparation_scene.gd`는 진입 즉시 Legacy Scene 경로를 저장하고 다음 전체 기능을 구성한다.

- 반일 일정
- 사건 선택
- 일상 에피소드
- 편성
- 장비
- 외부 접점
- 시장·소모품
- 기록
- 캠페인 operation/result

Validation에서 단순히 패널을 숨겨도 초기화·refresh·상태 조회·후속 변경 경로가 남는다. 승인된 축약 준비보다 책임 면적이 크다.

### 2.6 노선 복원

`minigame_scene.gd`:

- `minigame_frequency_sync`를 runtime에서 `route_restore`로 override
- 완료 전 저장 금지
- 완료 시 `save_minigame_result()`로 Legacy story effects 적용
- 성공 시 `clue_black_ticket` 추가
- 결과 존재 시 저장된 결과 표시
- 노선 성공 뒤 battle scene으로 복귀

재사용 가치가 높지만 Validation 완료 저장을 Legacy story effects와 분리해야 한다.

### 2.7 회수

`battle_scene.gd`는 이미 다음을 소유한다.

- GuidedDecisionStep: DIRECT / HYPOTHESIS / EVIDENCE / RESPONSE
- 현재 pattern
- 선택 hypothesis·evidence
- 안정도·두려움·회수 threshold
- 지원 행동·소모품
- 괴이 매뉴얼 판정

`core_validation_guided_flow_test.gd`와 `mvp043_recovery_loop_test.gd`는 다음을 이미 검증한다.

- 가설→근거→대응 흐름
- 첫 선택에서 정답·능력 수치 비노출
- Esc 복귀와 근거 보존
- 공식 규칙·위험 사례 기록
- 저승역과 비대상 사건 폴백

따라서 신규 Flow state가 동일 판단 상태를 소유하면 정본이 이중화된다.

### 2.8 결과·부작용

`result_scene.gd::_ready()`는 Scene 진입 즉시 `GameState.record_current_case_report()`를 호출한다.

`record_current_case_report()`:

- episode ID 기준 보고서 upsert
- `resolve_campaign_case()` 호출
- Legacy save 기록

`save_recovery_result()`:

- 회수 성공 상태 저장
- unlock 적용
- 잔향 보상 적용
- Legacy save 기록

보고서 배열은 episode ID 기준 upsert지만 캠페인·해금·경제가 Validation 비노출 계약과 충돌할 수 있다. 결과 Scene을 단순 모드 분기로 재사용하면 `_ready()` 선행 부작용을 먼저 제거해야 한다.

### 2.9 실제 회귀 기준

현재 `tests/run_godot_regression.sh`는 49개 진입점을 실행한다. 중요 기준:

- `core_validation_guided_flow_test`
- `core_validation_manual_promotion_test`
- `investigation_return_flow_test`
- `minigame_pipeline_test`
- `minigame_scene_smoke_test`
- `mvp043_opening_flow_test`
- `mvp043_investigation_ui_test`
- `mvp043_reasoning_ui_test`
- `mvp043_recovery_loop_test`
- `preparation_schedule_ui_test`
- `progressive_disclosure_preparation_test`
- CORE/ANNUAL focused suites

구형 계획의 `afterlife_main_menu_flow_test.gd`, `preparation_scene_smoke_test.gd`, `investigation_scene_smoke_test.gd`, `battle_scene_smoke_test.gd`, `result_scene_smoke_test.gd`는 최신 `main` 기준으로 검증되지 않았거나 존재하지 않는다.

## 3. 상태·효과 소유권

| 상태·효과 | 현재 소유자 | 현재 저장 | 재적용·오염 위험 | Validation 권장 소유자 |
|---|---|---|---|---|
| 활성 mode | 없음 | 없음 | Legacy/Validation 암묵 추론 | `ValidationSession.mode` |
| SCREEN/SIT stage | `current_scene_path` 중심 | Legacy save | Scene과 제품 stage 혼합 | `ValidationSession.flow_stage` |
| checkpoint | 부분 node/minigame ID | Legacy save | 전문 절차 복귀 불완전 | `ValidationSession.checkpoint_id` |
| return target·focus | Scene 지역 변수 | 일부 미저장 | 저장 후 복귀 유실 | `ValidationSession.return_target/focus_token` |
| 편성·장비·우선순위 | GameState·preparation | Legacy save | 캠페인 일정·시장과 혼합 | Validation 전용 snapshot, stable ID |
| 대화·현장 node | GameState | Legacy save | Validation save가 Legacy 덮어씀 | GameState runtime + Validation snapshot whitelist |
| 단서·기록 | GameState/CaseData | Legacy save | 보상·해금 동반 | GameState runtime, Validation repository snapshot |
| 사건 원인 가설·시간순 | 승인 Target만 존재 | 없음 | 회수 pattern 가설과 혼동 | 전용 Reasoning Scene + ValidationSession |
| 노선 board | RouteRestoreGame local + minigame result | Legacy save | story effect·clue 자동 적용 | Route Scene active / ValidationSession final snapshot |
| 회수 가설·근거·대응 | battle + GameState | Legacy save | 신규 state 이중 권위 | battle active / ValidationSession checkpoint summary |
| 회수 복구 사용 | 현행 pattern learning에 부분 표현 | Legacy save | 패턴별 1회 계약 불명확 | ValidationSession pattern ledger |
| 회수 해금·잔향 | GameState | Legacy save | 숨긴 경제 변화 | Validation에서는 적용 금지 |
| 결과 원시 4축 | 없음 | 없음 | 요약값이 권위가 될 위험 | pure `ValidationResultCalculator` 입력·ValidationSession 저장 |
| 보고서·매뉴얼 후보 | GameState | Legacy save | Scene 재진입·campaign mutation | Validation apply-once ledger |
| 연구·보급 후보 | GameState 장기 해금 | Legacy save | 실제 해금과 후보 혼동 | Validation 후보 record만 저장 |
| Legacy campaign/economy | GameState | Legacy save | Validation 중 배경 변화 | Validation에서 read/write 금지 |

## 4. 아키텍처 대안 비교

### A — GameState 내부 Validation Dictionary

구조:

```text
GameState.validation_flow
+ GameState.save_game 내부 mode 분기
```

장점:

- Scene 접근이 단순
- Autoload 추가 없음

위험:

- 이미 과대 책임인 GameState에 stage·save·effect ledger 추가
- reset/load/save·테스트 회귀 면적 최대
- Legacy와 Validation의 메모리·저장 소유권이 계속 혼합

판정: `REJECT`

### B — 별도 ValidationSession Autoload + 별도 저장 + GameState runtime adapter

구조:

```text
ValidationSession
├─ flow/checkpoint/return/focus
├─ validation snapshot
├─ applied effect IDs
├─ save repository
└─ GameState runtime import/export adapter
```

장점:

- 저장 namespace와 제품 stage 분리
- main menu가 두 save를 독립 inspection 가능
- Validation 종료·손상·삭제가 Legacy 파일에 영향 없음
- effect ledger와 결과 4축의 명확한 권위

위험:

- `project.godot` Autoload 변경 필요
- 기존 Scene의 자동 `save_game()` 라우팅 계약 필요
- runtime snapshot whitelist 설계 필요

판정: `RECOMMENDED_FOUNDATION`

### C — 모든 Validation Scene·상태 완전 신규 구현

장점:

- Legacy 부작용 최저
- 설계 자유도 높음

위험:

- 대화·조사·노선·회수·접근성·기록 UI 중복
- 기존 검증된 CORE-VALIDATION/MVP-043 기능을 버림
- 구현·QA 비용 최대

판정: `REJECT_EXCESS_DUPLICATION`

### D — B 기반 + 전문 절차 재사용 + 준비/결과 전용 Scene

구조:

```text
main_menu
→ ValidationSession / separate save
→ existing dialogue/investigation
→ dedicated validation_preparation_scene
→ dedicated validation_reasoning_scene
→ existing route minigame with explicit Validation result adapter
→ existing battle with explicit Validation pattern filter
→ dedicated validation_result_scene
→ main_menu
```

장점:

- 기존 CORE-VALIDATION/MVP-043 검증 자산 최대 재사용
- 준비·결과의 캠페인·경제 부작용 차단
- 기존 대화·조사·회수 UX 중복 최소화
- 결과 Scene `_ready()` 부작용을 건드리지 않고 격리

판정: `RECOMMENDED`

## 5. 권장 구성요소

### 5.1 ValidationSession

Create: `scripts/core/validation_session.gd`
Modify: `project.godot`

```gdscript
class_name ValidationSession
extends Node

const MODE_INACTIVE := "inactive"
const MODE_VALIDATION := "validation"
const SAVE_VERSION := "validation-save-v1"

var mode := MODE_INACTIVE
var episode_id := ""
var flow_stage := ""
var checkpoint_id := ""
var return_target := ""
var focus_token := ""
var preparation_snapshot: Dictionary = {}
var reasoning_state: Dictionary = {}
var route_state: Dictionary = {}
var recovery_progress: Dictionary = {}
var result_axes: Dictionary = {}
var applied_effect_ids: Dictionary = {}
var runtime_snapshot: Dictionary = {}
```

소유:

- Validation 활성 여부
- 제품 stage/checkpoint/return/focus
- 별도 저장 lifecycle
- specialist 완료 요약
- 패턴별 복구 사용
- 결과 원시 4축
- apply-once ledger

소유하지 않음:

- battle의 현재 카드 선택·UI 단계
- Route board의 프레임별 조작
- GameState의 Legacy campaign/economy
- 장기 제품 저장

### 5.2 ValidationSaveRepository

Create: `scripts/core/validation_save_repository.gd`

경로:

```text
user://urban_legend_validation_save.json
```

필수:

- temp write → flush → rename/replace의 원자적 저장
- corrupt/incompatible/recoverable inspection
- Legacy 파일 read/write/delete 금지
- version·episode·stage·checkpoint·timestamp metadata
- unknown ID는 orphan metadata로 보존하되 효과 적용 금지

### 5.3 GameState Validation adapter

Modify: `scripts/core/game_state.gd`

허용 변경을 최소화한다.

```gdscript
func export_validation_runtime_snapshot() -> Dictionary
func restore_validation_runtime_snapshot(snapshot: Dictionary) -> bool
func save_active_session() -> bool
```

`save_game()` 호출 호환:

```text
ValidationSession active
→ ValidationSession.capture_runtime(GameState)
→ ValidationSaveRepository.save
→ Legacy SAVE_FILE_PATH write 금지

Validation inactive
→ 기존 save_game byte/semantic behavior 유지
```

`load_game()`와 `clear_save_file()`은 Legacy 전용 의미를 유지한다. Validation 이어하기·삭제는 Session API만 사용한다.

Snapshot whitelist:

- episode path/ID
- dialogue/field/minigame IDs
- selected agents
- Validation에 필요한 flags
- collected clue IDs·seen hints
- method/minigame result
- selected resolution/recovery runtime
- recovery pattern learning·manual record
- agent/victim case state

제외:

- campaign schedule·operation
- daily episode
- faction/request/market
- economy inventory·purchase
- 장기 relationship unlock
- ANNUAL PoC state

복원 시 제외 상태를 reset/default 이상으로 변경하지 않는 no-effect 테스트가 필요하다.

### 5.4 Main menu save model

Modify: `scripts/ui/main_menu.gd`
Modify: `scenes/main_menu.tscn` only if programmatic UI cannot satisfy layout

Pure model:

```gdscript
func _build_continue_entries() -> Array[Dictionary]
```

종류:

- `legacy`
- `validation`

새 Validation 기록:

- Legacy 저장 삭제 금지
- 기존 Validation 저장만 확인 후 교체
- Session start → 별도 save → approved cold open

기존 `restart_afterlife_station_flow()`은 Legacy 경로의 회귀 기준으로 보존한다.

### 5.5 Flow Router

Create: `scripts/core/validation_flow_router.gd`

얇은 route table만 소유한다.

```gdscript
func scene_for_stage(stage_id: String) -> String
func advance(stage_id: String, checkpoint_id: String) -> Error
func enter_specialist(stage_id: String, return_target: String, focus_token: String) -> Error
func return_from_specialist() -> Error
```

도메인 상태·결과 계산·저장 파일 I/O는 소유하지 않는다.

### 5.6 화면 재사용·전용화

#### 재사용

- `dialogue_scene`: SIT-001/002 authored node
- `investigation_scene`: SIT-004 text investigation·record drawer·specialist transition
- `minigame_scene` + `route_restore_game`: SIT-006
- `battle_scene`: SIT-007 guided decision engine

#### 전용 Scene

Create:

- `scripts/scenes/validation_preparation_scene.gd`
- `scenes/validation_preparation_scene.tscn`
- `scripts/scenes/validation_reasoning_scene.gd`
- `scenes/validation_reasoning_scene.tscn`
- `scripts/scenes/validation_result_scene.gd`
- `scenes/validation_result_scene.tscn`

이유:

- 준비: Legacy 반일·일상·의뢰·시장 초기화와 분리
- Reasoning: 사건 원인 가설·시간순과 회수 pattern 가설을 의미적으로 분리
- 결과: Legacy result `_ready()`의 report/campaign 부작용과 분리

공통 UI는 기존 Theme·ActionChoiceCard·Record Drawer·Team components를 재사용한다.

### 5.7 데이터

Modify: `data/episodes/episode_001_afterlife_station.json`
Modify `CaseData`/loader only if typed access가 필요할 때

Additive:

```json
"validation_case": {
  "version": 1,
  "cold_open_node_id": "...",
  "briefing_node_id": "...",
  "reasoning": {
    "hypotheses": [],
    "timeline_evidence": [],
    "relationship_rules": []
  },
  "route": {},
  "recovery_pattern_ids": [
    "recovery_nonexistent_terminus",
    "recovery_black_ticket_imprint"
  ],
  "result_candidate_ids": []
}
```

기존 ID·필드 삭제·개명 금지. `minigame_scene.gd`의 저승역 runtime 문구 override는 JSON으로 이동하되 Legacy fallback을 한 릴리스 이상 유지한다.

## 6. 구형 Task 처리표

| 구형 Task | 판정 | 보정 |
|---|---|---|
| 1 ValidationFlowState | `CHANGE_OWNER / SPLIT` | Autoload Session은 navigation·ledger만 소유; 도메인 state 중복 금지 |
| 2 별도 Save | `KEEP / CHANGE_INTEGRATION` | repository 유지; 모든 자동 save가 Legacy를 쓰지 않도록 active-session routing 필수 |
| 3 Main Menu | `KEEP / CHANGE_TESTS` | 실제 `mvp043_opening_flow_test`와 신규 save matrix 사용; 없는 테스트명 제거 |
| 4 Router + Text Novel Shell | `SPLIT / REMOVE_DUPLICATION` | 얇은 Router 유지; 새 범용 Shell 제거, 기존 dialogue/investigation 재사용 |
| 5 Preparation mode | `REPLACE_WITH_DEDICATED_SCENE` | 거대 Legacy scene 모드 숨김 대신 전용 축약 준비 Scene |
| 6 Hypothesis + Timeline | `KEEP / DEDICATED_SPECIALIST` | 사건 원인 전용 Reasoning Scene; 회수 pattern 가설과 분리 |
| 7 Safe Route | `KEEP / CHANGE_SAVE_OWNER` | 기존 minigame 재사용, JSON 정본화, Validation result adapter |
| 8 Recovery 2 patterns | `KEEP / CHANGE_OWNER` | battle guided flow 재사용, 두 pattern filter·복구 ledger만 Session 소유 |
| 9 Result 4 axes | `REPLACE_WITH_DEDICATED_SCENE` | Legacy result `_ready()` 부작용 회피, pure calculator + apply-once |
| 10 E2E/Accessibility | `KEEP / UPDATE_BASELINE` | 실제 49-entry regression과 CORE/ANNUAL workflow 사용 |
| 11 Human package | `KEEP / GATE_ONLY` | 실제 build·자동 검증 뒤 6명 신규 플레이어 세션 |

## 7. 결과·Idempotency 계약

Create: `scripts/core/validation_result_calculator.gd`

```gdscript
func calculate_summary(result_axes: Dictionary) -> Dictionary
```

입력 원시 축:

- field_stabilization
- victim_rescue
- rule_validation
- core_residue_recovery

출력은 표시 요약이며 원시 축을 변경하지 않는다. `rule_validation`이 unresolved/refuted면 temporary stabilization 상한을 적용한다.

Apply once:

```gdscript
func apply_once(effect_id: String, payload: Dictionary) -> String
# APPLIED | ALREADY_APPLIED | REJECTED
```

필수 ID:

- `validation:afterlife:report:v1`
- `validation:afterlife:manual:v1`
- `validation:afterlife:research:signal-identity:v1`
- `validation:afterlife:supply:dead-frequency-filter:v1`
- `validation:afterlife:completion:v1`

Scene `_ready()`는 효과를 적용하지 않는다. 명시적 completion transaction이 계산→검증→apply_once→save를 한 번 수행한다.

Validation 결과는 다음을 하지 않는다.

- `resolve_campaign_case()`
- Legacy 잔향 지급
- 장기 장비 해금
- 시장 inventory 변경
- 일상·의뢰·세력 변경

## 8. 회수 계약 보정

기존 battle 판단 엔진을 유지하고 Validation adapter가 다음만 추가한다.

- 허용 pattern ID 두 개 filter
- 패턴별 recovery_used
- field_outcome과 reasoning_outcome 분리
- 완료 후 Session checkpoint summary
- Legacy reward/unlock suppress

```gdscript
{
  "pattern_id": "...",
  "classification_id": "...",
  "linked_record_ids": [],
  "neutral_action_id": "...",
  "field_outcome": "stabilized|failed",
  "reasoning_outcome": "verified|refuted|unresolved",
  "recovery_used": false,
  "danger_case_recorded": false
}
```

현재 `core_validation_guided_flow_test`의 중립 tooltip·근거 보존·비대상 폴백은 수정 후에도 유지한다.

## 9. 구현 Package 순서

### Package 0 — Baseline lock

- actual file map
- test entrypoint map
- save fixture backup
- current main/branch lock
- 제품 변경 없음

### Package 1 — Session·Save isolation

RED:

1. Validation save path와 Legacy path 다름
2. Validation 진행 중 `GameState.save_game()` 뒤 Legacy bytes 불변
3. corrupt Validation save가 Legacy bytes 불변
4. Validation delete가 Legacy bytes 불변
5. inactive mode에서 기존 Legacy save round-trip 동일
6. unknown stage/effect 거부

GREEN:

- Session Autoload
- Repository
- GameState whitelist adapter·active save routing

### Package 2 — Main menu distinction

RED:

- no save / Legacy / Validation / both / recoverable / incompatible
- save kind·사건·stage·time 표시
- 새 Validation 기록은 Legacy 삭제 금지
- Esc overwrite 취소

### Package 3 — Cold open·Investigation routing

- 기존 dialogue/investigation 재사용
- authored stage/checkpoint 연결
- record drawer·focus restore
- 별도 text novel shell 없음

### Package 4 — Dedicated reduced preparation

- 권나래 고정
- 동료 최대 2
- 장비 1
- 지원 1
- 조사 우선순위 1
- Legacy campaign/economy diff 0

### Package 5 — Reasoning specialist

- 4 hypothesis
- 2 eliminate
- timeline 23:57:42 < 23:59:08
- cause/carrier unresolved 분리
- 실패 feedback·재제출

### Package 6 — Safe route adapter

- runtime override JSON 정본화
- retry/withdraw/safe-route
- route board snapshot
- Legacy minigame result readable
- story effect·clue 자동 적용 분리

### Package 7 — Recovery two-pattern adapter

- 기존 guided flow 유지
- 두 pattern만 노출
- pattern당 복구 1회
- second failure → danger case → result
- Legacy 4-pattern/비대상 폴백 유지

### Package 8 — Dedicated result

- pure 4-axis calculator
- apply-once completion
- candidate 기록만 저장
- main menu 복귀
- Legacy result scene 무변경 우선

### Package 9 — Full regression·visual·human gate

- Validation focused suite
- 실제 CORE/ANNUAL suites
- 49-entry full Godot regression
- 1280×720 / 1920×1080
- keyboard/pointer/Esc/long Korean text
- six new-player sessions

## 10. 변경 예상 파일

### Create

- `scripts/core/validation_session.gd`
- `scripts/core/validation_save_repository.gd`
- `scripts/core/validation_flow_router.gd`
- `scripts/core/validation_result_calculator.gd`
- `scripts/scenes/validation_preparation_scene.gd`
- `scenes/validation_preparation_scene.tscn`
- `scripts/scenes/validation_reasoning_scene.gd`
- `scenes/validation_reasoning_scene.tscn`
- `scripts/scenes/validation_result_scene.gd`
- `scenes/validation_result_scene.tscn`
- `tests/validation/validation_session_test.gd`
- `tests/validation/validation_save_isolation_test.gd`
- `tests/validation/validation_main_menu_test.gd`
- `tests/validation/validation_preparation_test.gd`
- `tests/validation/validation_reasoning_test.gd`
- `tests/validation/validation_route_test.gd`
- `tests/validation/validation_recovery_test.gd`
- `tests/validation/validation_result_test.gd`
- `tests/validation/validation_end_to_end_test.gd`
- `tests/validation/validation_hidden_feature_no_effect_test.gd`
- `tests/validation/validation_save_restart_matrix_test.gd`
- `tests/validation/validation_accessibility_test.gd`
- `tests/run_validation_tests.sh`
- `.github/workflows/validate-validation-cut.yml`

### Modify, conditional

- `project.godot`
- `scripts/core/game_state.gd`
- `scripts/ui/main_menu.gd`
- `scenes/main_menu.tscn` only if needed
- `scripts/scenes/dialogue_scene.gd`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/minigame_scene.gd`
- `scripts/minigames/route_restore_game.gd`
- `scripts/scenes/battle_scene.gd`
- `data/episodes/episode_001_afterlife_station.json`
- `scripts/data/case_data.gd` only if typed access needed
- `tests/run_godot_regression.sh`
- `TEST_CHECKLIST.md`
- `docs/CURRENT_HANDOFF_VALIDATION.md`

### Avoid unless evidence requires

- `scripts/scenes/preparation_scene.gd`
- `scripts/scenes/result_scene.gd`
- existing Legacy `.tscn`
- campaign/economy/market/daily episode files
- ANNUAL PoC files

## 11. RED 테스트 우선순위

### P0 Save safety

1. Legacy bytes remain identical across Validation start/save/load/delete/corrupt recovery
2. Validation result reentry applies every effect once
3. inactive session preserves existing Legacy save/load behavior
4. Validation restore does not mutate hidden campaign/economy/relationship state

### P0 Flow safety

5. every SIT stage routes to one known Scene
6. specialist return restores node/checkpoint/focus
7. route failure never resets whole case
8. recovery second failure always reaches result
9. result completion always returns main menu

### P1 Content integrity

10. exact two timestamps and cause/carrier relation
11. only approved two recovery patterns
12. no first-choice answer/ability/probability leak
13. result summary derived from raw axes

### P1 Regression

14. `mvp043_opening_flow_test`
15. `core_validation_guided_flow_test`
16. `mvp043_recovery_loop_test`
17. `investigation_return_flow_test`
18. `minigame_pipeline_test`
19. CORE focused suite
20. ANNUAL-001/002 focused suites
21. full 49-entry regression

## 12. Rollback

- Session Autoload 제거
- Validation save file만 삭제
- main menu Validation entry 제거
- 전용 Validation Scene 제거
- additive `validation_case` 필드 제거
- runtime override Legacy fallback 유지
- Legacy `mvp-039`, `mvp-038` migration, ANNUAL save·Scene·tests 변경 없음

각 Package는 독립 commit·PR checkpoint를 가진다. 다음 Package 전에 이전 Package의 focused + full regression을 통과한다.

## 13. 적대적 검토

### 공격 1 — 별도 저장인데 Legacy가 바뀐다

원인: 기존 Scene의 `save_game()` 직접 호출.

방어: active-session save routing + Legacy byte fixture.

### 공격 2 — 준비 UI만 숨기고 캠페인이 진행된다

원인: preparation `_ready/refresh/start`가 Legacy campaign을 읽고 쓴다.

방어: 전용 Validation preparation Scene + hidden-state diff test.

### 공격 3 — 결과를 다시 열면 보상·보고서가 누적된다

원인: Legacy result `_ready()`와 recovery reward side effect.

방어: 전용 result Scene + explicit completion transaction + apply-once ledger.

### 공격 4 — 사건 원인 가설과 회수 pattern 가설이 섞인다

원인: 둘 다 hypothesis라는 이름을 사용.

방어: Reasoning Scene의 `case_hypothesis_id`, battle의 `pattern_response_id` 타입·경로 분리.

### 공격 5 — 새로운 Shell이 기존 UX를 회귀시킨다

원인: 검증된 dialogue/investigation UI 중복 구현.

방어: 기존 Scene 재사용, 새 Shell 제거.

### 공격 6 — Validation state가 battle state를 복제한다

원인: 프레임별 선택과 영속 checkpoint를 같은 객체가 소유.

방어: battle은 활성 판단, Session은 완료 요약·복구 ledger만 소유.

### 공격 7 — 기존 테스트 이름이 틀려 검증을 건너뛴다

원인: stale plan path.

방어: `run_godot_regression.sh`를 실제 source of truth로 사용.

## 14. 승인 요청 범위

다음 구현 패키지는 별도 사용자 승인 전 시작하지 않는다.

- `project.godot` Autoload 추가
- `GameState.save_game()` active-session routing
- 별도 Validation save·Scene·episode data
- 제품 코드·Scene·JSON·테스트·workflow 변경

권장 승인 단위:

```text
Package 1 Session·Save isolation만 우선 승인
→ Legacy byte safety + full regression 증거
→ Package 2~4 승인
→ 중간 적대적 검토
→ Package 5~8 승인
→ 전체 자동 검증
→ Human playtest 승인
```

## 15. 현재 판정

```text
CANON = RECONCILED_ON_PR_125_PENDING_MAIN
READ_ONLY_TECHNICAL_PLAN = COMPLETE
CHANGE_PROPOSAL = READY
PRODUCT_BUILD = NOT_AUTHORIZED
RUNTIME/HUMAN = NOT_RUN
MOBILE = DEFERRED_AFTER_PC_VALIDATION
```
