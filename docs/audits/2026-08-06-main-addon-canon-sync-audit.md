# 2026-08-06 Main Addon and Canon Sync Audit

## Status

```yaml
audit_id: UL-AUDIT-2026-08-06-P0-ADDON-CANON
project: alsdmlals4-eng/urban-legend
audit_time_zone: Asia/Seoul
observed_main_head: 47f1e86ea594c2f349d230b245192bae2de67eb0
last_reviewed_merge: 47e4bff7ea66d6f6a3792afe846f8a5d9320e966
state: OPEN_CONFLICT_WITH_APPROVED_DIRECTION
product_changes_in_this_audit: false
merge_authority: REQUIRE_EXPLICIT_APPROVAL
human_qa: NOT_RUN
ui_accessibility_qa: NOT_RUN
addon_decision_id: UL-DEC-ADDON-001
addon_decision: ADOPT_GUT_9_7_1
gut_adoption_phase: TRIAL_APPROVED
higodot_authority: SOLE_GODOT_AUTHORING_AUTHORITY
gut_authority: TEST_EXECUTION_AND_ASSERTION_ONLY
mandatory_entry_gate: DESIGN_AUTHORIZED_NOT_IMPLEMENTED
```

## Purpose

PR #164 이후 `main`에 직접 추가된 GUT 9.7.1·UID 변경과 GitHub·Base·Google Sheet 현재 상태 불일치를 복원한다. 사용자는 GUT 제거가 아니라 정식 테스트 프레임워크 채택을 승인했으며, HiGodot과 GUT의 권위를 분리하고 누락 방지 규칙을 작업 진입 차단 게이트로 만들도록 지시했다.

이 감사 PR은 사실관계, 상태 상한, 승인된 방향과 후속 설계 경계만 기록한다. 게임 기획, 런타임, 저장 데이터, 사건 콘텐츠, `project.godot`, 애드온 파일을 변경하지 않는다.

## Approved Direction

### `UL-DEC-ADDON-001 — ADOPT_GUT_9_7_1`

- GUT 9.7.1을 괴이기록국의 정식 Godot 테스트 프레임워크로 채택한다.
- 현재 설치 파일 존재만으로 `ADOPTED_ACTIVE`를 주장하지 않는다.
- 설계·출처·라이선스·호환성·소비 경로·CI·제거 절차가 기록된 상태를 `TRIAL_APPROVED`로 정의한다.
- 대표 프로젝트 테스트, CLI 실행, CI 결과, 전체 회귀를 exact HEAD에서 확인한 뒤에만 `ADOPTED_ACTIVE`로 승격한다.

### Authority separation

| 도구 | 허용 권위 | 금지 영역 |
|---|---|---|
| HiGodot | Godot Scene·Node·Resource·Project Settings의 생성·편집·저장, Godot 저작 자동화 | 테스트 결과를 임의로 PASS 처리, GUT 결과 파일 위조, 테스트 실패 은폐 |
| GUT | 테스트 검색·실행·assertion·double·JUnit 결과 생성, 실패 시 CI 차단 | 제품 Scene·Resource·`project.godot`·에피소드·save 정본의 임의 수정, HiGodot 저작 명령 실행 |
| CI Gate | 권위 계약·테스트 소비 경로·상태 원장·누락 게이트 검증 | 제품 저작, 사람 QA PASS 대체 |

GUT 테스트가 파일 시스템을 사용해야 할 경우 저장소 정본이 아니라 격리된 임시 경로 또는 `user://` 테스트 전용 경로만 사용한다. 테스트 종료 후 정본 diff가 생기면 실패로 처리한다.

## Evidence Snapshot

### Project GitHub

- `main` head: `47f1e86ea594c2f349d230b245192bae2de67eb0`
- 마지막 PR 검수 병합: PR #164 / `47e4bff7ea66d6f6a3792afe846f8a5d9320e966`
- PR #164 이후 직접 커밋:
  - `5e06fa4230ec73e50b8ed856a23bc3940c7c5814` — `addons/gut/` 추가, `project.godot` GUT 활성화
  - `47f1e86ea594c2f349d230b245192bae2de67eb0` — `.uid`와 추가 GUT 파일 반영
- 현재 `main`은 branch protection이 적용되지 않았다.
- 현재 head에 연결된 combined status check는 없다.
- `project.godot`의 editor plugin은 `godot_ai`와 `gut` 두 개가 활성화되어 있다.
- 프로젝트 코드 검색에서 GUT 자체 파일 외 `GutTest` 소비자와 `gut_cmdln.gd` CI 호출은 확인되지 않았다.

### Upstream GUT identity

- 공식 저장소: `bitwes/Gut`
- 공식 Godot 4.7 브랜치: `godot_4_7`
- 확인한 upstream commit: `aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605`
- upstream commit message: `Version bump, documentation for 9.7.1 release (#847)`
- upstream `plugin.cfg`: version `9.7.1`
- 호환성 선언: GUT `9.7.1` / Godot `4.7.x`
- 라이선스: MIT, `addons/gut/LICENSE.md`
- 설치본의 `plugin.cfg`와 bundled MIT license는 확인했다.
- 설치본 전체 tree가 upstream commit과 동일한지에 대한 hash 검증은 `NOT_RUN`이다.

### Base

- `skills/PROJECT_BASE_ADAPTER.json`: Base `9.4.3`
- `docs/BASE_RULES_VERSION.md`: Base `9.4.0`
- Base main `4f98f968a377f7b6a11aafa4fc94d11bddbebedc`는 선택적 애드온 활용, 실제 소비 경로, 제거·rollback 기록을 요구한다.
- 최신 Base 정책을 프로젝트 release identity로 승격하는 작업은 별도 검증 전 `NOT_APPLIED`다.

### Google Sheet actual state

- `02_현재_확정결정`에서 `READY` 문자열이 포함된 기존 기록 9건을 확인했다.
- 일부는 오래된 Draft PR·설계 계획의 역사 기록인데도 `CURRENT`, `CANON_READY`, `IMPLEMENTATION_PLAN_READY`, `AUTOMATED_PACKAGE_READY`처럼 현재 진입 권위로 오인될 수 있다.
- `04_누락_충돌_감사`에는 `NOT_BUILD_READY`처럼 안전한 기록도 있지만 `CHANGE_PROPOSAL_READY`, `READY_FOR_SEPARATE_MERGE_APPROVAL`, `CANON_READY`, `IMPLEMENTATION_PLAN_READY` 역사 기록이 섞여 있다.
- `71_이미지기획_생성목록`의 현재 상태는 `PLANNED`, `BLOCKED_BY_DEMO`, 빈 상태, 또는 `GENERATED_EXPLORATION_REVIEWED / NOT_PRODUCT_ASSET`다.
- `72_이미지검수_승인로그`에는 이미지 미생성, 실제 화면 가독성 `NOT_RUN`, 1280 검증 `NOT_RUN`, 제품 에셋 승인 금지가 남아 있다.
- 따라서 이미지 단계는 `IMAGE_PRODUCT_READY`도, 현재 제품 구현 진입 허가도 아니다.
- 네 표면에서 영문 `AWAITING` 직접 표기는 발견되지 않았으나 빈 상태·`IN_REVIEW`·후속 승인 필요가 있어 명시적 차단 상태로 정규화해야 한다.

## Adversarial Findings

### P0-1 — Protected-path mutation bypassed review evidence

`addons/`와 `project.godot`은 보호 경로다. 두 직접 커밋은 PR 검수, 승인 ID, 자동 회귀, Godot import, rollback 기록과 연결되지 않았다. GUT 채택 결정은 이 우회를 사후 승인하지 않는다.

### P0-2 — Adopted direction has no active consumption evidence yet

GUT 채택은 승인됐지만 프로젝트 테스트·CLI·CI 소비 경로는 아직 없다. 따라서 현재 상태는 `ADOPTED_BY_DECISION / TRIAL_APPROVED / CONSUMPTION_NOT_IMPLEMENTED`다.

### P0-3 — HiGodot/GUT authority boundary is not machine-enforced

역할 분리 의도만 있고 테스트가 정본 파일을 변경하지 않는지, GUT이 저작 권위를 갖지 않는지 검사하는 계약 테스트와 CI Gate가 없다.

### P0-4 — Generic READY can bypass actual unresolved and image state

결정 원장 하나만 읽으면 오래된 `READY`를 현재 작업 허가로 오인할 수 있다. 미확정·감사·이미지 기획·이미지 검수 상태를 모두 읽고 차단 finding이 없을 때만 진입해야 한다.

### P1-1 — Canon surfaces disagree

Sheet 허브, 상세 장부, GitHub status 문서, Base 버전 문서가 서로 다른 시점을 현재로 주장한다.

### P1-2 — UID validation remains separate and open

GUT 채택은 `.uid` 변경의 유효성을 증명하지 않는다. Godot 4.7.1 import와 전체 회귀를 별도로 수행해야 한다.

### P1-3 — Human QA remains open

PR #164의 one-click 패키지는 준비됐지만 실제 Windows 화면·입력·저장·접근성 판정은 `NOT_RUN`이다.

## Superseded Recommendation

이 문서의 이전 `REMOVE_DEFER` 권고는 사용자 결정으로 폐기한다.

```yaml
superseded_recommendation: REMOVE_DEFER
superseded_by: UL-DEC-ADDON-001
current_decision: ADOPT_GUT_9_7_1
```

## Mandatory Entry Gate

작업 시작 전에 다음을 모두 읽고 하나의 Gate 결과를 계산한다.

1. `02_현재_확정결정`: 승인 결정과 현재 권위
2. `04_누락_충돌_감사`: P0/P1 및 재검증 상태
3. 별도 미확정 원장 또는 명시적 open-decision record
4. `71_이미지기획_생성목록`: 생성·차단·제품 자산 여부
5. `72_이미지검수_승인로그`: 검수·권리·런타임·제품 승인 여부
6. GitHub exact HEAD, PR 상태, checks, review threads, mergeability

다음 중 하나라도 해당하면 진입을 차단한다.

- P0/P1 open finding
- 승인되지 않은 Decision 또는 open decision
- generic `READY`만 있고 exact HEAD·구현·검수 증거가 없음
- 필요한 이미지가 `PLANNED`, `BLOCKED`, 미생성, `NOT_RUN`, `OPEN_P2`, `NOT_PRODUCT_ASSET`
- 제품 자산 승인 또는 권리·유사성 검수 누락
- GUT 테스트 소비 경로·CLI·CI 미구현
- HiGodot/GUT 권위 침범 또는 정본 diff 발생
- Human QA가 필요한 작업인데 `NOT_RUN`

허용 상태는 `ENTRY_ALLOWED_FOR_<SCOPE>`처럼 범위를 포함해야 한다. 단독 `READY`와 단독 `AWAITING`은 유효 상태로 사용하지 않는다.

## Recovery Sequence

1. PR #165에 승인된 방향과 상태 상한을 기록한다.
2. 별도 브랜치에서 GUT 9.7.1 채택·권위 분리·필수 진입 게이트 설계와 TDD 계획을 작성한다.
3. Sheet의 오래된 generic READY와 빈 이미지 검수 상태를 증거 기반 명시 상태로 교정한다.
4. 별도 구현 승인 후 representative GUT test, CLI, JUnit, CI Gate, 정본 무변경 검사를 구현한다.
5. 설치본 전체와 upstream commit의 identity를 검증한다.
6. `.uid`를 Godot 4.7.1 import·전체 회귀로 독립 검증한다.
7. exact HEAD 자동 검증 후에만 GUT을 `ADOPTED_ACTIVE`로 승격한다.
8. 실제 Windows Human QA와 UI 접근성은 로컬 증거가 있을 때만 상태를 올린다.

## Approval Gates

- `UL-DEC-ADDON-001`: **APPROVED — ADOPT_GUT_9_7_1**
- `UL-DEC-AUTHORITY-001`: **APPROVED — HIGODOT_AUTHORING / GUT_TEST_ONLY**
- `UL-DEC-ENTRY-GATE-001`: **APPROVED_FOR_DESIGN — mandatory blocking gate**
- protected-path implementation: 별도 구현 PR과 exact HEAD 검증 필요
- branch protection 변경: 별도 승인 필요
- merge: 명시적 exact HEAD 병합 승인 필요

## Current Claim Ceiling

```text
REMOTE_REPOSITORY_READABLE
SHEET_ACTUAL_STATE_READ
GUT_9_7_1_UPSTREAM_IDENTITY_PARTIALLY_VERIFIED
GUT_ADOPTED_BY_DECISION
GUT_TRIAL_APPROVED
GUT_PROJECT_CONSUMPTION_NOT_IMPLEMENTED
HIGODOT_GUT_AUTHORITY_SEPARATION_APPROVED_FOR_DESIGN
MANDATORY_ENTRY_GATE_APPROVED_FOR_DESIGN
CURRENT_MAIN_HEAD_UNREVIEWED
CURRENT_MAIN_CI_NOT_EVIDENCED
UID_VALIDATION_NOT_RUN
CANON_SYNC_OPEN_CONFLICT
LOCAL_GODOT_EXECUTION_NOT_RUN
HUMAN_QA_NOT_RUN
UI_ACCESSIBILITY_QA_NOT_RUN
MERGE_NOT_AUTHORIZED
```
