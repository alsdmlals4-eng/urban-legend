# Package 2 메인 메뉴 진입·이어하기·라우팅 Design Spec

> 상태: `APPROVED`
> 작성일: 2026-08-02
> 승인 시각: 2026-08-02 16:17 KST
> 추적 PR: #129
> Spec 승인: `D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL`
> Design 승인: `D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL`
> 제품 위계 승인: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
> 영속 경계: `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`
> 구현 계획: `docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`
> 제품 구현 권한: `NOT_AUTHORIZED`

## 1. 목적

Package 1에서 구현된 독립 `ValidationSession`과 Validation 저장소를 SCREEN-01 메인 메뉴에 안전하게 연결한다.

플레이어는 메인 메뉴에서 다음을 혼동 없이 수행할 수 있어야 한다.

1. Legacy 본편의 새 캠페인 시작
2. Legacy 본편 이어하기
3. Validation 새 기록 시작
4. Validation 진행 기록 이어하기
5. Validation 완료 기록 보기
6. Validation 저장 오류·호환 상태 확인

Legacy와 Validation은 파일·메모리·행동·오류 표시에서 독립한다. 어느 한쪽의 오류가 다른 쪽의 정상 행동을 차단하지 않는다.

## 2. 범위

### 2.1 포함

- SCREEN-01 정보 구조와 상태 모델
- Legacy·Validation 독립 행동 카드
- Validation 저장 read-only summary
- Validation 시작·이어하기·완료 기록 보기 orchestration
- 기존 Validation 기록 교체 확인
- flow-stage allowlist route mapping
- single-flight mutation lock
- Validation 전용 whitelist 초기화
- 실패 시 메인 잔류와 상태 복구
- 자동·런타임·사람 검증 계약

### 2.2 제외

- Validation 전용 준비 Scene의 상세 게임 디자인
- Validation 전용 추론 Scene의 상세 게임 디자인
- Validation 전용 결과 Scene의 상세 게임 디자인
- 저승역 전체 콘텐츠·대사·증거·회수 패턴 재기획
- Legacy 저장 schema 변경
- Validation 저장 schema 변경
- 자동 backup 승격·복구·마이그레이션
- 모바일 UI
- 본격적인 전체 게임 기획

아직 존재하지 않는 Validation 전용 Scene은 route mapper에서 `NOT_AVAILABLE`로 처리한다. 존재하지 않는 화면을 완료된 기능처럼 가장하지 않는다.

## 3. 설계 원칙

### 3.1 저장 경계가 UI 위계와 일치해야 한다

```text
Legacy 저장 = 기존 진행 카드
Validation 저장 = Validation 기록 카드
```

한 버튼이 두 저장을 추론하거나 자동 선택하지 않는다.

### 3.2 메뉴 렌더링은 무부작용이어야 한다

메뉴 표시를 위해 다음을 호출하지 않는다.

- `ValidationSession.load()`
- GameState restore
- 저장 삭제
- backup 승격
- quarantine
- migration
- Scene 이동

메뉴 렌더링은 read-only inspection 결과만 사용한다.

### 3.3 실패는 fail-closed다

저장 상태, lifecycle, episode, flow-stage, route, 초기화, 저장 중 하나라도 불명확하면 Validation mutation을 중단하고 SCREEN-01에 남는다.

### 3.4 Legacy 무부작용은 파일과 메모리 모두 포함한다

Validation 시작·이어하기·완료 기록 보기에서 다음이 유지되어야 한다.

- `user://urban_legend_save.json` bytes
- campaign state
- 관계·신뢰·이벤트
- 해금·보상·경제
- 보고서·괴이 매뉴얼
- 일일 진행
- 세력·시장·소비 아이템

### 3.5 UI는 상태를 숨기지 않는다

진행·완료·손상·호환 불가·복구 가능 상태를 같은 `있음/없음` 문구로 축약하지 않는다.

## 4. SCREEN-01 정보 구조

### 4.1 상단

- 게임 제목
- 짧은 세계관 설명
- Validation이 본편과 별도 기록임을 알리는 짧은 보조 문구

긴 소개·대형 이미지가 두 행동 카드보다 먼저 과도한 세로 공간을 차지하지 않도록 축약한다.

### 4.2 주 행동 영역

```text
┌ 기존 진행 ───────────────┐  ┌ Validation 기록 ──────────┐
│ 사건·저장 상태             │  │ 사건·단계·저장 시각          │
│ [이어하기]                 │  │ [이어하기 / 완료 기록 보기] │
│ [새 캠페인]                │  │ [새 기록 시작]              │
└──────────────────────────┘  └──────────────────────────┘
```

### 4.3 하단 보조 행동

- 기록국 DB
- 설정·접근성
- 저장 오류 상세

개발·테스트 패널은 기존처럼 debug build에서만 접근한다.

### 4.4 시각 위계

- Legacy와 Validation 카드의 너비·기본 강조는 동등하다.
- Validation 카드에는 `본편과 별도 기록` badge를 표시한다.
- 오류는 색만으로 표시하지 않고 상태명과 설명을 함께 제공한다.
- disabled 버튼은 비활성 이유를 인접 문구로 설명한다.

## 5. 상태 모델

### 5.1 Legacy 카드

Package 2는 Legacy 저장 동작을 재설계하지 않는다.

```yaml
EMPTY:
  primary: 새 캠페인
  continue: disabled
SAVE_AVAILABLE:
  primary: 이어하기
  secondary: 새 캠페인
LOAD_FAILED:
  primary: 새 캠페인
  continue: disabled
  message: 기존 진행을 불러올 수 없음
```

Legacy 새 캠페인 시작의 기존 삭제 의미는 Legacy 카드 내부에만 머문다. Validation 행동에서 호출하지 않는다.

### 5.2 Validation persistence code

Repository inspection code:

- `EMPTY`
- `EXACT`
- `RECOVERABLE_BACKUP`
- `INTERRUPTED_WRITE`
- `INCOMPATIBLE_OLDER`
- `INCOMPATIBLE_NEWER`
- `CORRUPT_JSON`
- `CORRUPT_SCHEMA`
- `READ_FAILED`
- 기타 unknown

### 5.3 Validation lifecycle

EXACT payload lifecycle:

- `active`
- `suspended`
- `completed`

다른 값은 정상 이어하기 대상으로 취급하지 않는다.

### 5.4 Validation 카드 행동표

| Persistence | Lifecycle | 기본 행동 | 보조 행동 | mutation 허용 |
|---|---|---|---|---|
| EMPTY | 없음 | 새 기록 시작 | 없음 | 예 |
| EXACT | active | 이어하기 | 새 기록 시작 | 교체 확인 후 |
| EXACT | suspended | 이어하기 | 새 기록 시작 | 교체 확인 후 |
| EXACT | completed | 완료 기록 보기 | 새 기록 시작 | 교체 확인 후 |
| RECOVERABLE_BACKUP | 없음 | 상태 상세 | 없음 | 아니오 |
| INTERRUPTED_WRITE | 없음 | 상태 상세 | 없음 | 아니오 |
| INCOMPATIBLE_OLDER | 없음 | 상태 상세 | 없음 | 아니오 |
| INCOMPATIBLE_NEWER | 없음 | 상태 상세 | 없음 | 아니오 |
| CORRUPT_JSON | 없음 | 상태 상세 | 없음 | 아니오 |
| CORRUPT_SCHEMA | 없음 | 상태 상세 | 없음 | 아니오 |
| READ_FAILED | 없음 | 상태 상세 | 없음 | 아니오 |
| unknown | 없음 | 상태 상세 | 없음 | 아니오 |

`상태 상세`는 read-only다. 삭제·quarantine·backup 승격 버튼을 Package 2에 추가하지 않는다.

## 6. 컴포넌트 경계

### 6.1 `ValidationPersistenceSummary`

역할: repository inspection 결과를 메뉴용 불변 summary로 변환한다.

권장 API:

```gdscript
func inspect_persistence() -> Dictionary
```

반환 계약:

```yaml
ok: bool
repository_code: String
lifecycle: String
episode_id: String
episode_title: String
flow_stage: String
checkpoint_id: String
updated_at_utc: String
completed_at_utc: String
can_start: bool
can_continue: bool
can_view_completed: bool
requires_replace_confirmation: bool
status_label: String
status_message: String
```

제약:

- GameState를 변경하지 않는다.
- Session mode를 변경하지 않는다.
- 파일을 변경하지 않는다.
- payload 전체를 UI에 노출하지 않는다.
- 허용된 summary field만 복사한다.

### 6.2 `ValidationEntryCoordinator`

역할: SCREEN-01의 Validation mutation 흐름을 단일 책임으로 조정한다.

권장 public command:

```gdscript
func start_new_validation() -> Dictionary
func continue_validation() -> Dictionary
func view_completed_validation() -> Dictionary
func confirm_replace_and_start() -> Dictionary
func cancel_replace() -> Dictionary
```

책임:

- single-flight lock
- 최신 summary 재확인
- lifecycle·episode 검증
- Session create·activate·load 호출 순서
- hidden Legacy guard capture·검증
- Validation runtime 초기화
- Validation 저장
- route mapping
- Scene change 요청
- 오류 코드 정규화
- 성공·실패 후 UI refresh

비책임:

- 카드 위젯 생성
- 저장 format parsing
- Legacy 새 캠페인 구현
- 전문 절차 Scene 내부 로직

### 6.3 `ValidationRouteMapper`

역할: 저장된 flow-stage를 허용 Scene으로 변환한다.

권장 API:

```gdscript
func resolve(flow_stage: String, lifecycle: String) -> Dictionary
```

반환:

```yaml
ok: bool
code: String
route_id: String
scene_path: String
```

허용 mapping:

| flow-stage | route | 현재 사용 가능성 |
|---|---|---|
| SIT-001 | dialogue | 사용 가능 |
| SIT-002 | dialogue | 사용 가능 |
| SIT-003 | validation_preparation | Scene 구현 전 NOT_AVAILABLE |
| SIT-004 | investigation | 사용 가능 여부 구현 시 검증 |
| SIT-005 | validation_reasoning | Scene 구현 전 NOT_AVAILABLE |
| SIT-006 | validation_safe_route | Scene 구현 전 NOT_AVAILABLE |
| SIT-007 | validation_recovery | Scene 구현 전 NOT_AVAILABLE |
| SIT-008 | validation_result | Scene 구현 전 NOT_AVAILABLE |
| completed | completed_record | read-only viewer 구현 전 NOT_AVAILABLE |

규칙:

- payload의 `scene_path`를 직접 신뢰하지 않는다.
- unknown stage는 `UNKNOWN_FLOW_STAGE`다.
- 알려진 stage라도 Scene이 준비되지 않았으면 `NOT_AVAILABLE`이다.
- route 실패 시 SCREEN-01에 남는다.

### 6.4 `initialize_validation_runtime()`

위치: `validation_game_state.gd` 또는 같은 경계를 유지하는 좁은 adapter.

권장 API:

```gdscript
func initialize_validation_runtime(episode_id: String, agent_ids: Array) -> Dictionary
```

허용 변경 필드:

- episode id·path·data
- current scene·dialogue·field·minigame
- selected agents
- flags
- collected clues
- seen hints
- method results
- minigame results
- resolution
- recovery
- agent case states
- victim state

금지 필드:

- campaign state
- seen log tutorial ids
- agent trust·trust changes
- triggered agent events
- support 사용 기록
- unlocked records·equipment·research
- equipped items
- completed reports·manual records
- daily episode records
- echo fragments
- granted rewards
- faction state
- market purchases
- consumable state
- rewarded resolution grades

금지 호출:

- `clear_save_file()`
- `reset_run_state()`
- `restart_afterlife_station_flow()`
- Legacy `save_game()` routing

## 7. 데이터 흐름

### 7.1 메뉴 진입

```text
SCREEN-01 _ready
→ Legacy 상태 조회
→ ValidationSession.inspect_persistence()
→ 두 카드 독립 렌더링
→ mutation 없음
```

### 7.2 새 Validation 시작 — EMPTY

```text
single-flight lock 획득
→ read-only summary 재조회
→ EMPTY 확인
→ Legacy file bytes snapshot
→ hidden Legacy memory snapshot
→ ValidationSession.create(episode_001_afterlife_station)
→ ValidationSession.activate(token)
→ hidden guard capture
→ GameState.initialize_validation_runtime(...)
→ hidden Legacy memory equality 검증
→ ValidationSession.save(GameState)
→ Legacy file bytes equality 검증
→ route mapper로 SIT-001 확인
→ dialogue Scene 이동
```

### 7.3 새 Validation 시작 — 기존 기록 존재

```text
summary 재조회
→ EXACT + active/suspended/completed 확인
→ 사건·단계·저장 시각 표시
→ 교체 확인 modal
→ 취소: mutation 없이 메뉴 복귀
→ 확정: Validation persistence만 delete
→ EMPTY 재확인
→ 새 시작 흐름 수행
```

corrupt·incompatible·recoverable·read-failed 상태에서는 교체 modal을 열지 않는다.

### 7.4 Validation 이어하기

```text
single-flight lock 획득
→ summary 재조회
→ EXACT + active/suspended 확인
→ Legacy file bytes snapshot
→ hidden Legacy memory snapshot
→ ValidationSession.load(GameState)
→ hidden Legacy memory equality 검증
→ Legacy file bytes equality 검증
→ route mapper
→ 허용 Scene 이동
```

`load()` 결과가 성공이어도 mapper가 실패하면 Scene 이동을 하지 않는다. Session이 활성화된 채 메뉴에 남는 상태를 피하기 위해 coordinator가 명시적으로 deactivate 또는 안전한 rollback을 수행한다. 구현 계획은 route preflight와 runtime rollback 순서를 테스트 우선으로 고정한다.

### 7.5 완료 기록 보기

Package 2의 완료 기록 보기는 read-only summary만 표시한다.

```text
summary 재조회
→ EXACT + completed 확인
→ GameState restore 없음
→ 완료 시각·사건·결과 요약 표시
→ 닫기 시 SCREEN-01 카드로 포커스 복귀
```

결과 4축 상세 viewer는 전용 결과 Scene Package에서 확장한다.

## 8. 교체 확인 UX

표시 정보:

- 사건명
- lifecycle 또는 단계
- 마지막 저장 시각
- 삭제 대상이 Validation 기록뿐이라는 문구
- Legacy 본편 기록은 변경되지 않는다는 문구

문구 계약:

```text
현재 Validation 기록을 새 기록으로 교체합니다.
삭제되는 것은 Validation 기록뿐입니다.
기존 캠페인 기록은 변경되지 않습니다.
```

행동:

- 기본 포커스: 취소
- 확인: `새 기록 시작`
- 취소: `기록 유지`
- Esc: 취소
- Enter가 파괴적 확인으로 자동 연결되지 않도록 명시적 포커스 이동 후에만 허용

## 9. 오류 처리

### 9.1 오류 원칙

- 내부 code와 사용자 문구를 분리한다.
- 오류 발생 단계와 다음 가능한 행동을 표시한다.
- 오류 뒤 mutation lock을 반드시 해제한다.
- 오류 뒤 두 카드 상태를 다시 read-only 조회한다.
- Validation 오류가 Legacy 카드 버튼을 비활성화하지 않는다.

### 9.2 사용자 문구 예시

| Code | 문구 |
|---|---|
| RECOVERABLE_BACKUP | 복구 가능한 Validation 기록이 있습니다. 이 버전에서는 자동 복구하지 않습니다. |
| INTERRUPTED_WRITE | 저장이 완료되지 않은 흔적이 있습니다. 기록을 자동 변경하지 않았습니다. |
| INCOMPATIBLE_NEWER | 더 최신 버전에서 만든 Validation 기록입니다. |
| INCOMPATIBLE_OLDER | 이 버전에서 직접 열 수 없는 Validation 기록입니다. |
| CORRUPT_JSON / CORRUPT_SCHEMA | 손상된 Validation 기록을 보존했습니다. |
| READ_FAILED | Validation 기록을 읽을 수 없습니다. 기존 캠페인은 계속 이용할 수 있습니다. |
| UNKNOWN_FLOW_STAGE | 저장된 단계가 현재 라우팅 규칙과 맞지 않습니다. |
| NOT_AVAILABLE | 해당 Validation 단계의 화면은 아직 이 빌드에 포함되지 않았습니다. |
| LEGACY_GUARD_VIOLATION | 기존 캠페인 상태 보호에 실패해 Validation 진입을 중단했습니다. |

## 10. Single-flight 상태

메뉴 mutation state:

```yaml
IDLE:
  mutation_buttons_enabled: true
LOADING:
  mutation_buttons_enabled: false
  navigation_buttons_enabled: false
  status_refresh_allowed: false
RESULT:
  mutation_buttons_enabled: false
  next: scene_change_or_IDLE
```

규칙:

- double-click·Enter repeat·동시 포인터 입력을 한 요청으로 수렴한다.
- 실패와 취소에서 반드시 `IDLE`로 복귀한다.
- Scene change 요청 후 추가 command를 받지 않는다.

## 11. 접근성·해상도

### 11.1 키보드

포커스 순서:

```text
Legacy 기본 행동
→ Legacy 보조 행동
→ Validation 기본 행동
→ Validation 보조 행동
→ 기록국 DB
→ 설정·접근성
```

상태 상세·교체 modal을 닫으면 이전 의미 있는 버튼으로 포커스를 복귀한다.

### 11.2 1280×720

필수:

- 두 카드 제목·상태·기본 행동이 첫 viewport 또는 한 번의 자연스러운 세로 스크롤 안에 보임
- 수평 카드가 너무 좁아지면 동일 위계를 유지한 세로 stack으로 전환 가능
- disabled 이유가 잘리지 않음
- 한국어 긴 상태 문구가 겹치지 않음

### 11.3 1920×1080

- 카드가 과도하게 넓어지지 않도록 최대 너비 적용
- 시선이 대형 빈 공간보다 주 행동에 머물도록 중앙 정렬

## 12. 테스트 전략

### 12.1 순수·headless 계약 테스트

1. persistence code → summary mapping
2. EXACT lifecycle → 행동 mapping
3. summary가 파일·GameState·Session mode를 변경하지 않음
4. route allowlist와 unknown fail-closed
5. initialize_validation_runtime whitelist
6. initialize 전후 hidden Legacy snapshot semantic equality
7. Legacy save bytes equality
8. single-flight 중복 command 차단
9. failure마다 lock 해제
10. completed viewer read-only

### 12.2 통합 테스트

1. Legacy만 존재
2. Validation만 존재
3. 두 저장 동시 존재
4. Validation active
5. Validation suspended
6. Validation completed
7. recoverable backup
8. interrupted temp
9. newer·older incompatible
10. corrupt JSON·schema
11. 교체 취소
12. 교체 확정
13. route `NOT_AVAILABLE`
14. route unknown
15. 시작 단계별 실패
16. 이어하기 단계별 실패
17. 기존 Legacy 새 캠페인·이어하기 회귀

### 12.3 UI·사람 검증

- 1280×720 마우스
- 1280×720 키보드 only
- 1920×1080
- 두 저장이 동시에 있을 때 사용자가 목표 기록을 첫 시도에 선택하는지
- Validation이 본편과 별도 기록임을 이해하는지
- 파괴적 교체 문구를 이해하는지
- 오류 상태에서도 Legacy 진입 가능성을 발견하는지

## 13. 완료 기준

Package 2 구현 완료를 선언하려면 다음이 모두 필요하다.

```yaml
design_spec: APPROVED
implementation_plan: APPROVED
product_implementation: COMPLETE
documentation_contracts: PASS
bca_adoption: PASS
validation_entry_focused: PASS
package_1_validation_focused: 4_OF_4_PASS
full_godot_regression: PASS
legacy_file_no_effect: PASS
legacy_memory_no_effect: PASS
keyboard_1280x720: PASS_OR_EXPLICIT_NOT_RUN
mouse_1280x720: PASS_OR_EXPLICIT_NOT_RUN
human_qa: PASS_OR_EXPLICIT_NOT_RUN
```

자동 검증을 통과해도 사람·시각 검증을 실행하지 않았다면 `NOT_RUN`으로 보고한다.

## 14. 대안과 기각 이유

### 단일 시작·이어하기 뒤 모드 선택

기각 이유:

- 저장 상태와 오류를 한 단계 뒤에 숨김
- 두 저장 동시 존재 시 비교 어려움
- 어떤 기록을 여는지 예측성이 낮음

### Validation을 주 행동으로 전면화

기각 이유:

- Validation을 본편으로 오인할 위험
- Legacy 접근성 저하
- 장기 제품 구조와 충돌

### 기존 `restart_afterlife_station_flow()` 재사용

기각 이유:

- `reset_run_state()`를 통해 숨은 Legacy 상태를 변경
- `FILE_AND_MEMORY_NO_EFFECT` 계약 위반

### 저장된 `scene_path` 직접 이동

기각 이유:

- 허용하지 않은 Scene 이동 가능
- 아직 구현되지 않은 stage를 완료된 route처럼 취급할 위험

## 15. Spec self-review

### Placeholder scan

- 미정 필드 없음
- 구현 전 결정이 필요한 항목은 `NOT_AVAILABLE`·`NOT_AUTHORIZED`로 명시

### Internal consistency

- 독립 카드 위계와 독립 저장 경계가 일치함
- read-only summary와 mutation coordinator 책임이 분리됨
- route mapper는 현재 Scene 가용성을 과장하지 않음
- completed viewer는 상세 결과 Scene과 충돌하지 않도록 요약 전용으로 제한됨

### Scope check

- SCREEN-01 진입·이어하기·상태·라우팅에 한정됨
- 전용 준비·추론·결과 화면과 전체 게임 기획은 제외됨
- 하나의 implementation plan으로 분해 가능한 범위임

### Ambiguity check

- active·suspended·completed 행동이 명시됨
- 오류 상태의 overwrite 금지가 명시됨
- 기존 기록 교체 가능 상태와 불가 상태가 구분됨
- Validation 초기화 허용·금지 필드가 명시됨
- 구현하지 않은 route의 처리 방식이 `NOT_AVAILABLE`로 고정됨

## 16. 다음 Gate

구현 계획은 `superpowers:writing-plans` 형식으로 작성·self-review 완료됐다.

제품 코드·Scene·JSON·Save Schema·workflow는 별도 제품 구현 승인 전 변경하지 않는다.