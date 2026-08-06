# 2026-08-06 Main Addon and Canon Sync Audit

## Status

```yaml
audit_id: UL-AUDIT-2026-08-06-P0-ADDON-CANON
project: alsdmlals4-eng/urban-legend
audit_time_zone: Asia/Seoul
observed_main_head: 47f1e86ea594c2f349d230b245192bae2de67eb0
last_reviewed_merge: 47e4bff7ea66d6f6a3792afe846f8a5d9320e966
state: OPEN_CONFLICT
product_changes_in_this_audit: false
merge_authority: REQUIRE_EXPLICIT_APPROVAL
human_qa: NOT_RUN
ui_accessibility_qa: NOT_RUN
```

## Purpose

PR #164 이후 `main`에 직접 추가된 Godot GUT 애드온·UID 변경과, GitHub 문서·Base 어댑터·Google Sheet 사이의 현재 상태 불일치를 복원한다. 이 문서는 사실관계와 승인 게이트만 기록하며 게임 기획, 런타임, 저장 데이터, 사건 콘텐츠를 변경하지 않는다.

## Evidence Snapshot

### GitHub

- `main` head: `47f1e86ea594c2f349d230b245192bae2de67eb0`
- 마지막 PR 검수 병합: PR #164 / `47e4bff7ea66d6f6a3792afe846f8a5d9320e966`
- PR #164 이후 직접 커밋:
  - `5e06fa4230ec73e50b8ed856a23bc3940c7c5814` — 메시지 `d`; `addons/gut/` 대량 추가, `project.godot`에서 GUT 플러그인 활성화
  - `47f1e86ea594c2f349d230b245192bae2de67eb0` — 메시지 `d`; 다수의 `.uid`와 추가 GUT 파일 반영
- 현재 `main`은 branch protection이 적용되지 않았다.
- 현재 head에 연결된 combined status check는 없다.
- `project.godot`의 editor plugin은 `godot_ai`와 `gut` 두 개가 활성화되어 있다.
- GUT 버전은 `9.7.1`이다.
- 저장소 코드 검색에서 `GutTest` 상속 또는 `gut_cmdln` 실행 소비자는 GUT 자체 파일 외에는 확인되지 않았다.

### Base

- 프로젝트 `skills/PROJECT_BASE_ADAPTER.json`은 Base `9.4.3`에 고정되어 있다.
- `docs/BASE_RULES_VERSION.md`는 Base `9.4.0`을 기록한다.
- Base 최신 `main` `4f98f968a377f7b6a11aafa4fc94d11bddbebedc`는 선택적 Godot 애드온 활용 정책을 추가했다.
- 최신 정책은 프로젝트별 필요, 정확한 버전, 라이선스, 실제 소비 경로, 검증, 제거·rollback 기록을 요구한다.
- 실제 소비 경로가 없는 애드온은 `INSTALLED_UNUSED`로 판정해 제거하거나 도입을 연기한다.

### Google Sheet

- `01_작업순서`, `02_현재_확정결정`, `04_누락_충돌_감사`, `99_변경이력`은 PR #164 병합과 `HUMAN_QA_NOT_RUN`까지 기록한다.
- `00_프로젝트_허브`는 여전히 PR #149, 구형 `main` SHA, `MERGE_NOT_AUTHORIZED` 상태를 가리킨다.
- PR #164 뒤 직접 커밋 두 개는 작업 순서, 결정, 감사, 변경 이력에 기록되지 않았다.

## Adversarial Findings

### P0-1 — Protected-path mutation bypassed review evidence

`addons/`와 `project.godot`은 프로젝트 보호 경로다. 두 직접 커밋은 PR 검수, 승인 ID, 자동 회귀, Godot import 검증, rollback 기록과 연결되지 않았다. 따라서 현재 head를 `AUTOMATED_QA_PASSED` 또는 `HUMAN_QA_READY`로 승격할 수 없다.

### P0-2 — GUT is currently an `INSTALLED_UNUSED` candidate

플러그인은 활성화되었으나 프로젝트 테스트·CI의 실제 소비 경로가 확인되지 않았다. GUT 자체 파일이 존재하는 것은 소비 증거가 아니다. 유지하려면 최소 하나의 프로젝트 테스트 전환, 실행 명령, CI 또는 로컬 검증 결과, 라이선스·버전·rollback 경계를 기록해야 한다.

### P0-3 — Canon surfaces disagree

최상위 Sheet 허브, 상세 Sheet 장부, GitHub handoff/status 문서, Base 버전 문서가 서로 다른 시점을 현재로 주장한다. 사용자가 어느 표면에서 시작하느냐에 따라 다음 작업이 달라지는 상태다.

### P1-1 — Base adoption identity is split

`BASE_RULES_VERSION.md`의 9.4.0과 어댑터의 9.4.3이 불일치한다. 최신 Base 정책은 아직 프로젝트 채택 기록에 반영되지 않았다. 최신 Base를 무조건 복사하지 말고, 프로젝트 보호 경계와 충돌하지 않는 운영 계약만 선택적으로 채택해야 한다.

### P1-2 — `main` allows direct protected-path writes

branch protection이 없어 동일 문제가 반복될 수 있다. 설정 변경은 저장소 권한·비용·운영 영향이 있으므로 이 감사에서는 자동 변경하지 않는다.

### P1-3 — Human QA remains open

PR #164의 one-click Windows Human QA 패키지는 병합되었지만 실제 Windows 실행, 실제 저장 생성, 화면·입력·접근성 검수는 여전히 `NOT_RUN`이다. 현재 unreviewed head에서 실행한 결과를 PR #164의 검증으로 소급 해석하면 안 된다.

## Options Considered

### A. GUT를 즉시 유지하고 통합

장점: Godot 네이티브 단위 테스트 도구를 활용할 수 있다.

위험: 현재 소비 경로와 테스트 전환 설계가 없고, 기존 검증 체계와 중복될 수 있다. 직접 커밋 상태를 사후 승인하는 결과가 된다.

판정: `DEFERRED_PENDING_EVIDENCE`.

### B. GUT만 제거하고 UID 변경을 별도 검증

장점: 미사용 애드온과 `project.godot` 변경을 최소 범위로 되돌리면서, Godot가 생성한 UID는 별도 import·회귀 검증할 수 있다.

위험: GUT가 다른 작업에서 의도적으로 추가된 경우 그 의도를 확인해야 한다. UID 대량 변경도 검증 없이 현재 정본으로 승격할 수 없다.

판정: **RECOMMENDED**, 단 사용자 승인 후 별도 구현 PR에서 수행.

### C. 두 직접 커밋 전체를 되돌림

장점: 마지막 검수 병합 상태로 가장 빠르게 복귀한다.

위험: UID가 의도된 Godot 4.7 정리 결과라면 유효 변경까지 잃는다.

판정: `FALLBACK_ONLY`.

## Recommended Recovery Sequence

1. 이 감사 PR을 통해 사실관계와 상태 상한을 먼저 고정한다.
2. Sheet 최상위 허브와 상세 장부를 `OPEN_CONFLICT / CURRENT_HEAD_UNVERIFIED`로 동기화한다.
3. 사용자에게 GUT 처리 방향 하나를 승인받는다.
4. 권장안 승인 시 별도 구현 PR에서 GUT 활성화와 `addons/gut/`을 제거하고 UID 변경만 격리한다.
5. Godot 4.7.1 import, 기존 Python 계약, 전체 Godot 회귀, one-click Human QA preflight를 새 head에서 다시 실행한다.
6. 검증 성공 후 Base 어댑터·Base 버전 문서·handoff·Sheet를 같은 결정 ID로 갱신한다.
7. 실제 Windows Human QA와 UI 접근성 검수는 사용자가 로컬에서 수행한 증거가 있을 때만 상태를 올린다.

## Approval Gates

- `UL-DEC-ADDON-001`: GUT를 제거·연기할지, 실제 테스트 소비 경로를 구현해 유지할지 사용자 승인 필요
- `UL-DEC-BRANCH-001`: `main` branch protection 적용 여부 사용자 승인 필요
- `UL-DEC-BASE-001`: Base 최신 애드온 정책을 프로젝트 운영 계약으로 채택할지 사용자 승인 필요

## Current Claim Ceiling

```text
REMOTE_REPOSITORY_READABLE
SHEET_READABLE
PR_164_AUTOMATED_PACKAGE_EVIDENCE_PRESERVED
CURRENT_MAIN_HEAD_UNREVIEWED
CURRENT_MAIN_CI_NOT_EVIDENCED
GUT_INSTALLED_UNUSED_CANDIDATE
CANON_SYNC_OPEN_CONFLICT
LOCAL_GODOT_EXECUTION_NOT_RUN
HUMAN_QA_NOT_RUN
UI_ACCESSIBILITY_QA_NOT_RUN
MERGE_NOT_AUTHORIZED
```
