# Package 1 Validation Session·Save Isolation 구현 증거

> Decision: `D-2026-08-02-PACKAGE-1-IMPLEMENTATION-APPROVAL`
> 구현 PR: #126
> 실행 방식: `STACKED_ISOLATED_BRANCH`
> 검증된 코드 HEAD: `a11064505c732f535cf809dae0c380409b12c677`
> 문서 기준 부모: `b3d38576b37c60fd36c1b7bdc9018803b917c000`
> 구현 상태: `IMPLEMENTED_AND_AUTOMATED_CI_VERIFIED`
> PR 병합: `NOT_REQUESTED`

## 1. 구현 범위

Package 1에서 다음 기반만 구현했다.

- `ValidationSaveRepository`
  - `user://urban_legend_validation_save.json` 독립 namespace
  - Legacy 경로 접근 거부
  - temp write → readback → replace
  - 정상 backup 1세대
  - corrupt·schema·older/newer·interrupted·recoverable 판정
  - 명시적 quarantine
- `ValidationSession`
  - create·activate·save·load·suspend·resume·complete·abandon·delete lifecycle
  - token·episode·lifecycle fail-closed
  - completion apply-once ID
  - hidden Legacy memory guard
- `validation_game_state.gd`
  - 기존 `game_state.gd` 상속 wrapper
  - inactive 시 기존 `super.save_game()` 의미 유지
  - active valid 시 Validation 저장으로 routing
  - active invalid 시 양쪽 저장 금지
  - field-level runtime snapshot whitelist와 restore prevalidation
- Autoload
  - `ValidationSession`을 `GameState`보다 먼저 등록
  - `GameState` 이름은 wrapper가 유지
- 테스트·CI
  - focused Validation 4개
  - 기존 49개 회귀에 신규 4개를 추가한 53-entry runner
  - CORE·ANNUAL workflow 양쪽에서 동일 계약 검증

## 2. 변경 범위 검토

문서 부모 대비 검증된 코드 HEAD:

```text
base: b3d38576b37c60fd36c1b7bdc9018803b917c000
head: a11064505c732f535cf809dae0c380409b12c677
ahead: 25
behind: 0
changed files: 14
```

변경 파일:

```text
.github/workflows/validate-annual-mvp-001.yml
.github/workflows/validate-core-mvp-001.yml
project.godot
scripts/core/validation_game_state.gd
scripts/core/validation_save_repository.gd
scripts/core/validation_session.gd
tests/run_godot_regression.sh
tests/run_validation_package_1_tests.sh
tests/test_annual_mvp_001_static_contract.py
tests/validation/validation_game_state_adapter_test.gd
tests/validation/validation_save_isolation_test.gd
tests/validation/validation_save_repository_test.gd
tests/validation/validation_session_test.gd
tests/validation/validation_test_support.gd
```

범위 밖 변경 없음:

- main menu UX
- preparation·reasoning·result Scene
- episode JSON
- dialogue·investigation·minigame·battle 제품 흐름
- Legacy `scripts/core/game_state.gd` 본체
- 본편 campaign·economy·relationship·faction·market Schema
- 모바일

## 3. TDD RED 증거

### 최초 기능 부재 RED

```text
head: 2e952047bc693dabaafcda6f923bff3521d6c895
run: 30734799162
job: 91461540263
result: FAILURE_EXPECTED
```

Python 계약과 Godot import는 통과했고, focused suite는 `scripts/core/validation_save_repository.gd` 부재로 실패했다. 생산 코드보다 테스트가 먼저 실패하는 것을 확인했다.

### 승인 Plan 정렬 RED

```text
head: 3879afff70b63cc89bc448d878757731ad05dc56
run: 30735040138
job: 91462196736
result: FAILURE_EXPECTED
```

강화된 persistence/lifecycle/whitelist/isolation Matrix가 repository constructor와 승인 API 부재를 정확히 검출했다.

## 4. 최종 GREEN 증거

검증된 코드 HEAD:

```text
a11064505c732f535cf809dae0c380409b12c677
```

### ANNUAL workflow

```text
workflow: Validate ANNUAL-MVP-001
run: 30735427632
job: 91463258423
conclusion: success
```

성공 단계:

- annual·active-document Python contracts
- Godot 4.7.1 import
- Validation Package 1 focused 4/4
- CORE focused
- ANNUAL-MVP-001 focused
- ANNUAL-MVP-002 focused
- full Godot regression 53/53

### CORE workflow

```text
workflow: Validate CORE-MVP-001
run: 30735427667
job: 91463282381
conclusion: success
```

성공 증거:

```text
Python: 12 tests / OK
Validation Package 1 focused suite: 4/4 test entrypoints passed
CORE-MVP-001 focused suite: 4/4 passed
Godot regression suite: 53/53 test entrypoints passed
```

## 5. 보호 계약 검증

자동 테스트에서 다음을 검증했다.

- Validation primary와 Legacy primary가 다르다.
- repository가 Legacy path로 구성되면 `LEGACY_GUARD_VIOLATION`이다.
- active Validation 저장은 Legacy bytes를 변경하지 않는다.
- invalid active Session은 Validation·Legacy 양쪽 파일을 변경하지 않는다.
- Validation 삭제는 Legacy 파일을 변경하지 않는다.
- Legacy load·clear는 Validation 파일을 변경하지 않는다.
- runtime snapshot은 명시적 whitelist만 포함한다.
- campaign·economy·relationship·faction·market·report 상태는 snapshot에서 제외한다.
- invalid episode·잘못된 field type은 restore 전에 거부되어 부분 적용되지 않는다.
- hidden Legacy memory drift가 있으면 저장을 차단한다.
- completion effect는 중복 적용되지 않는다.
- corrupt primary는 자동 삭제하지 않고 명시적 quarantine만 허용한다.
- newer save는 inspect-only이며 덮어쓰지 않는다.
- temp-only와 backup-only 상태는 자동 승격하지 않는다.

## 6. 적대적 코드 검토

결론:

```yaml
critical: 0
important: 0
minor_follow_up: 2
scope_violation: 0
merge_ready: REVIEW_REQUIRED
```

Minor follow-up:

1. 기존 UI·manual 회귀 일부가 RID/ObjectDB leak warning을 출력한다. 이번 변경 이전부터 존재하는 비차단 품질 부채이며 별도 Goal로 다룬다.
2. corrupt JSON 음성 fixture가 Godot parser error 로그를 의도적으로 출력한다. 테스트는 PASS하지만 로그 소음 개선은 별도 선택 작업이다.

## 7. 증거 한계

```yaml
github_actions_headless_runtime: PASS
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
mobile: DEFERRED
product_flow_integration: NOT_IN_PACKAGE_1
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

이번 결과는 **Session·Save isolation 기반의 자동화 검증 완료**를 뜻한다. 플레이 가능한 전체 Validation 흐름 완료나 POC 통과를 뜻하지 않는다.

## 8. 다음 Gate

```text
PR #126 코드 리뷰
→ PR #125 문서 정본 병합 여부 결정
→ PR #126을 최신 main으로 rebase·retarget
→ 병합 승인
→ Package 2 main-menu·entry routing 기획/구현
```

PR #125와 PR #126은 사용자의 별도 병합 승인 전까지 Draft·미병합으로 유지한다.
