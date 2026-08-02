# D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL

> 상태: `APPROVED`
> 승인 시각: 2026-08-02 11:20 KST
> 승인 출처: 사용자 `Spec 승인`
> 상위 Decision:
> - `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL`
> - `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`
> 승인 Spec: `docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md`
> 구현 권한: `NOT_AUTHORIZED`
> 병합 권한: `NOT_REQUESTED`

## 1. 결정

Package 1 `Validation Session·Save Isolation` Design Spec을 현행 구현 계획의 승인된 입력으로 채택한다.

승인된 핵심은 다음과 같다.

- Validation 진행·완료 기록은 Legacy·본편과 완전히 독립한다.
- `ValidationSession`은 stage·checkpoint·return/focus·snapshot·ledger만 소유한다.
- `ValidationSaveRepository`는 별도 namespace·버전·원자적 저장·백업·손상 격리를 소유한다.
- `GameState`는 Legacy 권위를 유지하고 field-level whitelist adapter만 추가한다.
- Validation 활성화는 명시적이며 token·version·episode·lifecycle 불일치 시 fail-closed한다.
- Validation 저장 실패를 Legacy 저장 성공으로 대체하지 않는다.
- Legacy 파일 bytes뿐 아니라 campaign·economy·relationship·faction·market 메모리도 무변경으로 보호한다.
- 단일 Validation 슬롯, 정상 백업 1세대, 손상 원본 자동 삭제 금지를 초기 기본값으로 사용한다.
- 메인 메뉴 UX·준비/Reasoning/결과 Scene·episode JSON·노선/회수 adapter는 Package 1에서 제외한다.

## 2. 승인된 구현 계획 작성 범위

`superpowers:writing-plans`로 다음을 작성할 수 있다.

- 정확한 생성·수정 파일 목록
- RED→GREEN 테스트 순서
- 저장소·Session·GameState adapter·Autoload·routing 작업 단위
- 오류·버전·손상·lifecycle fixture
- CORE·ANNUAL·전체 Godot 회귀 실행 명령
- CI 경로와 실패 증거 보존
- 커밋 경계·롤백·정본·Sheet 동기화 절차

## 3. 구현 계획 제약

- 각 Task는 독립적인 실패 테스트와 최소 구현, 통과 테스트, 커밋으로 끝난다.
- 존재하지 않는 파일·함수·테스트명을 전제로 하지 않는다.
- 기존 `GameState.save_game()`, `load_game()`, `clear_save_file()`의 Legacy 의미를 보존한다.
- `ValidationSession` Autoload는 `GameState`보다 먼저 로드한다.
- Autoload 이름과 전역 `class_name` 충돌을 피하기 위해 Session 스크립트는 전역 class 등록을 강제하지 않는다.
- 기존 ANNUAL atomic save 구현은 참고하되 corrupt 보존·백업·readback 검증을 추가한다.
- 구현과 무관한 리팩터링은 별도 Goal로 분리한다.

## 4. GitHub 실행 경계

기본 경로:

```text
PR #125 문서 정본 병합
→ 최신 main exact SHA 확인
→ isolated worktree/branch `agent/package-1-session-save-isolation`
→ Package 1 구현 Draft PR
```

PR #125 병합 전에 구현이 별도 승인되면:

```text
PR #125 exact HEAD에서 stacked branch 생성
→ base = agent/v9-4-canon-reconciliation
→ 문서 PR 병합 뒤 main으로 rebase/retarget
```

main 직접 push와 PR #125에 제품 코드를 혼합하는 방식은 금지한다.

## 5. Gate

현재 허용:

- 구현 계획 작성
- 계획 자기검수
- 정본·PR·Sheet 동기화

현재 금지:

- GDScript·project.godot·테스트·workflow 변경
- Codex 실행
- Draft 해제·병합·auto-merge
- Runtime·CI·Human PASS 주장

다음 Gate:

```text
Implementation Plan REVIEW_READY
→ 사용자 Package 1 구현 승인
→ isolated execution branch
→ TDD 구현
```

## 6. 검증 상태

```yaml
spec_approval: APPROVED
implementation_plan: IN_PROGRESS
product_diff: 0
runtime: NOT_RUN
ci: NOT_RUN
human_qa: NOT_RUN
merge: NOT_REQUESTED
```