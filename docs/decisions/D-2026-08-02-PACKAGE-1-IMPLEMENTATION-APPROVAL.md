# D-2026-08-02-PACKAGE-1-IMPLEMENTATION-APPROVAL

> 상태: `APPROVED`
> 승인 시각: 2026-08-02 14:45 KST
> 승인 출처: 사용자 `구현 승인`
> 상위 Decision:
> - `D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL`
> - `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`
> 실행 Plan: `docs/superpowers/plans/2026-08-02-validation-session-save-isolation-implementation-plan.md`
> PR #125 병합: `NOT_REQUESTED`

## 1. 결정

Package 1 `Validation Session·Save Isolation`의 구현을 승인한다.

승인 범위는 다음으로 제한한다.

- 별도 Validation 저장 namespace와 단일 슬롯
- 원자적 temp→readback→replace 저장과 정상 backup 1세대
- corrupt·incompatible·interrupted 저장의 보존·판정·격리
- `ValidationSession` lifecycle·token·stage·checkpoint·snapshot·completion ledger
- `GameState` 권위를 유지하는 field-level whitelist adapter
- active Validation Session의 명시적 fail-closed 저장 routing
- Legacy 저장 파일 bytes와 campaign·economy·relationship·faction·market 메모리 무변경 검증
- focused Package 1 tests, 기존 CORE·ANNUAL·전체 회귀, CI 증거
- 동일 Decision ID의 GitHub·Google Sheet 동기화

## 2. 실행 경계

PR #125는 아직 Draft·미병합이므로 승인된 stacked 경로를 사용한다.

```text
PR #125 exact HEAD
→ branch agent/package-1-session-save-isolation
→ base agent/v9-4-canon-reconciliation
→ test-only RED commit
→ GitHub Actions RED 증거
→ 최소 GREEN 구현
→ 별도 Draft implementation PR
```

PR #125 브랜치에는 제품 코드를 추가하지 않는다. PR #125가 병합되면 구현 브랜치를 최신 `main`으로 rebase하고 구현 PR base를 `main`으로 retarget한다.

## 3. TDD 계약

- production code보다 실패 테스트를 먼저 커밋한다.
- RED는 GitHub Actions에서 실제 실패 원인과 exact SHA로 확인한다.
- RED가 기능 부재 이외의 이유라면 production code를 작성하지 않고 테스트를 수정한다.
- GREEN 구현은 테스트를 통과시키는 최소 범위로 제한한다.
- 신규 결함은 재현 실패 테스트 없이 수정하지 않는다.
- 전체 회귀와 CI가 실제 통과하기 전 PASS를 선언하지 않는다.

## 4. 구현 상세 보정 권한

승인 Spec의 의미와 보호 경계를 보존하는 범위에서 파일 배치는 최소 위험 구조로 조정할 수 있다.

특히 거대한 Legacy `scripts/core/game_state.gd`를 직접 광범위 수정하는 대신, 동일 `GameState` Autoload 이름을 유지하는 얇은 상속 wrapper를 사용해 adapter와 routing을 격리할 수 있다. 이 경우:

- 기존 Legacy 구현은 상속·보존한다.
- inactive Session의 동작은 `super.save_game()`을 사용해 유지한다.
- 장기 상태를 Validation payload에 직렬화하지 않는다.
- wrapper 도입은 테스트와 diff에서 명시한다.

## 5. 범위 밖

- main menu UX
- Validation 준비·Reasoning·결과 Scene
- episode JSON 및 저승역 콘텐츠 수정
- minigame·battle·result calculator 구현
- Legacy migration schema 변경
- 본편 보상·프로필 import
- 모바일
- PR #125 병합·auto-merge

## 6. Gate

```yaml
spec: APPROVED
implementation: AUTHORIZED_PACKAGE_1_ONLY
execution_mode: STACKED_ISOLATED_BRANCH
red_evidence: PENDING
product_code: NOT_STARTED
runtime: NOT_RUN
ci: NOT_RUN
human_qa: NOT_RUN
merge: NOT_REQUESTED
```

다음 상태 전이는 test-only RED commit과 Actions 실패 증거가 확인된 뒤에만 `IMPLEMENTATION_IN_PROGRESS`로 변경한다.
