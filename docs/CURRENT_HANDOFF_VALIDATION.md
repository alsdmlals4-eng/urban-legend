# 괴이기록국 Validation 현재 인수인계

> 상태: `CHANGE_PROPOSAL_READY_PENDING_IMPLEMENTATION_APPROVAL`
> 갱신일: 2026-08-02
> Decision: `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
> Proposal: `P-2026-08-02-VALIDATION-CHANGE-PROPOSAL`
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> 제품 구현 권한: `NONE`

## 현재 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/planning/POST_V94_CANON_RECONCILIATION_AUDIT_2026-08-02.md
→ docs/superpowers/plans/2026-08-02-validation-change-proposal.md
→ 실제 main 코드·데이터·테스트
```

읽기 전용 기술 Plan은 완료 증거로 보존한다.

- `docs/superpowers/plans/2026-08-02-validation-read-only-technical-plan.md`

## 현재 상태

```yaml
base: 9.4.0
base_adoption_main: 7277b9cececa56532f7b0d11c1a02fd3d5642750
planning: APPROVED_FINAL_PLANNING_BASELINE
canon: RECONCILED_ON_BRANCH_PENDING_MAIN
technical_readback: COMPLETE
change_proposal: READY_FOR_ADVERSARIAL_REVIEW
implementation: CURRENT_IMPLEMENTATION_LEGACY
validation_build: NOT_AUTHORIZED
runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
platform: PC_16_9_MOUSE_KEYBOARD
mobile: FUTURE_CONSIDERATION_NOT_IN_CURRENT_SCOPE
```

## 승인 Target

```text
무인 메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 가설·시간순 증거
→ 안전 노선 복원
→ 회수 2패턴
→ 결과 4축·최소 환류
→ 메인 복귀
```

상세는 `docs/VALIDATION_TARGET_CANON.md`가 소유한다.

## 기술 검수 결론

### 확인한 실제 구조

- `project.godot`의 시작 Scene은 `res://scenes/main_menu.tscn`이다.
- `scripts/core/game_bootstrap.gd`는 최신 `main`에 존재하지 않는다.
- `main_menu.gd`가 Legacy 새 시작·이어하기·`current_scene_path` 이동을 직접 소유한다.
- `GameState`의 `mvp-039` 단일 저장은 캠페인·조사·회수·보고서·경제까지 함께 직렬화한다.
- 기존 대화·조사·노선 복원·guided 회수는 재사용 가치와 현재 회귀 테스트가 있다.
- `preparation_scene.gd`는 반일 일정·일상·외부 접점·시장까지 초기화한다.
- `result_scene.gd::_ready()`는 진입 즉시 Legacy 보고서와 캠페인 상태를 갱신한다.
- 실제 전체 회귀 기준은 `tests/run_godot_regression.sh`의 49개 진입점이다.

### 권장 구조

```text
별도 ValidationSession Autoload
+ 별도 Validation Save Repository
+ 기존 dialogue/investigation/minigame/battle 전문 절차 재사용
+ 전용 validation_preparation_scene
+ 전용 validation_reasoning_scene
+ 전용 validation_result_scene
+ pure result calculator
+ apply-once effect ledger
```

`GameState`는 Legacy 도메인 runtime engine으로 유지하고, ValidationSession은 stage·checkpoint·return/focus·별도 저장·완료 요약·effect ledger만 소유한다.

## 기존 계획 처리

- 별도 저장·Legacy 보존·RED 우선: 유지
- `ValidationFlowState`의 전 도메인 상태 소유: 변경
- 별도 범용 Text Novel Shell: 제거
- Legacy preparation 단순 모드 숨김: 전용 축약 준비 Scene으로 대체
- Legacy result 모드 분기: 전용 Validation 결과 Scene으로 대체
- route/battle: 기존 검증된 전문 절차를 명시적 Validation adapter로 재사용
- 구형 테스트 파일명: 실제 49-entry regression 기준으로 교체

상세 `KEEP / CHANGE / REPLACE` 표와 예상 파일·RED 테스트·롤백은 Change Proposal이 소유한다.

## 현재 P0 위험

1. 기존 Scene의 자동 `save_game()`가 Validation 중 Legacy 파일을 덮어쓸 수 있음
2. 준비 UI를 숨겨도 캠페인·일상·시장 상태가 초기화·변경될 수 있음
3. Legacy 결과 Scene 재진입이 보고서·캠페인·보상을 다시 적용할 수 있음
4. 신규 Flow state가 battle의 가설·근거·응답 상태를 중복 소유할 수 있음
5. runtime route 문구 override와 JSON 정본이 충돌할 수 있음
6. 사람 검증 없이 Build Ready·POC Passed로 오판할 수 있음

## 다음 작업

현재 필요한 승인은 **Package 1 Session·Save isolation** 한정이다.

승인 대상:

- `project.godot`에 ValidationSession Autoload 추가
- 별도 `user://urban_legend_validation_save.json`
- `GameState`의 최소 whitelist runtime adapter
- Validation 활성 시 자동 save를 별도 저장으로 라우팅
- Legacy save/load/clear의 비활성 mode 의미 보존
- Legacy bytes 불변·corrupt 격리·full regression RED/GREEN 테스트

승인하지 않은 범위:

- main menu UI 변경
- 새 준비·Reasoning·결과 Scene
- episode JSON
- 노선·회수 제품 변경
- Codex Build 전체 패키지
- PR 병합

다음 Gate:

```text
Package 1 범위 승인
→ RED Legacy-byte safety
→ 최소 구현
→ CORE/ANNUAL/49-entry full regression
→ 독립 적대적 검토
→ Package 2~4 승인 여부 재판정
```

## GitHub·Sheet 상태

- PR #120: `CLOSED_UNMERGED / SUPERSEDED_BY_BASE_V9_4_MAIN`
- PR #122: `SOURCE_BRANCH / DO_NOT_MERGE_AS_IS`
- Draft PR #125: Canon·Audit·Technical Plan·Change Proposal
- 브랜치: `agent/v9-4-canon-reconciliation`
- 제품 경로 diff: 0
- Google Sheet: 동일 Decision ID로 Proposal 상태까지 동기화·재조회
