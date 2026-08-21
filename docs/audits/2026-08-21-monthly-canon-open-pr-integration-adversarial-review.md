# 2026-08-21 월간 정본·열린 PR 통합 적대적 검토

Status: `PREMERGE_CORRECTED / FIVE_WHOLE_SCOPE_LOOPS_COMPLETE / EXACT_HEAD_CI_PENDING`

## 1. 범위와 기준

- 기준 main: `96febd3630d52e75d2eb007dca0e7f9701bf7f42`
- 검토한 열린 PR: `#211`, `#213`, `#214`, `#215`, `#216`, `#217`, `#218`
- 사람용 기획 정본: Notion 프로젝트 홈과 Core Systems, Vertical Slice, Content Budget, First Session, Closure Matrix, 5-loop review
- 구조화 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`, Repository 구현·테스트·runtime evidence
- 보호 범위: `data/**`, `scripts/**`, `scenes/**`, `assets/**`, `addons/**`, `project.godot`
- 권한 경계: `PLAN_LOCK`; 사용자 시안 검토와 전체 기획 완료 선언 전 runtime·asset 구현 금지

7개 PR은 서로 다른 문서 1개씩만 추가하며 변경 파일 충돌, review thread, 실패 CI가 없었다. 그러나 PR 단독 설명만으로는 최신 월간 정본, M01/M04 역할, 저승역 Canon v2, workspace 권위와 완전히 정렬되지 않았다. 따라서 원문을 개별 병합하지 않고 하나의 정본 통합 범위에서 교정했다.

## 2. 외부 운영 사례 대조

- GitHub 공식 문서는 required status check가 **latest commit SHA**에서 성공해야 한다고 설명한다. 이 작업은 과거 PR의 초록색 결과를 재사용하지 않고 통합 PR의 최종 HEAD CI를 새로 확인한다.
  <https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks>
- GitHub 공식 문서는 새 push 뒤 최신 reviewable 변경의 재승인 또는 stale approval 해제를 보호 옵션으로 제공한다. 이 저장소에서는 큰 통합의 5회 whole-scope 검토와 expected-head merge 확인으로 같은 위험을 문서·검증 Gate에 반영한다.
  <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches>
- Notion 공식 문서는 Status·Date·URL·Last edited time 같은 database property를 진행·최신성 추적에 사용하도록 제공한다. Repository merge 뒤 `Repo Main SHA`, `Sync State`, `Last Synced`를 갱신하고 대상 페이지를 다시 읽는 방식을 유지한다.
  <https://www.notion.com/help/database-properties>

판정: `ADOPT` exact-head CI와 postmerge readback, `ADAPT` 5회 whole-scope 검토를 현재 1인 작업 구조에 적용, `AVOID` 오래된 PR check·고정 SHA를 현재 상태 증거로 재사용.

## 3. 적대적 검토 5회

### Loop 1 — 정본·cadence·진입 경로

Attack: 월 1사건 M01+보다 과거 ANNUAL/분기 문구가 먼저 발견되거나 실행 권한처럼 보이는가.

Finding:

- `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`, `CURRENT_STATUS.md` 일부가 병합된 PR #89를 여전히 `ON_BRANCH / PENDING` 또는 다음 Gate로 표시했다.
- `PROJECT_CORE.md` 상단 Overlay는 월간이었지만 최소 정체성 계약은 여전히 `1년 4분기`와 연도 결산을 현재 계약으로 유지했다.
- `planning/ROADMAP_AND_HANDOFF.md`가 과거 ANNUAL 확대 순서를 현재 실행 문서처럼 노출했다.

Decision: `MUST_FIX`.

Correction:

- PR #89 상태를 `MERGED / COMPLETE`로 정렬했다.
- 현재 최소 정체성 계약을 월 1사건, M01~M12 초기 Slate, M13+ 연속, 월간 복합 결과로 전환했다.
- ANNUAL 로드맵은 `HISTORICAL_ANNUAL_RUNTIME_ROADMAP`으로 명시하고 실행 권한을 제거했다.

Recheck: 구형 `ON_BRANCH / PENDING / 병합 대기` 활성 문구 0건, 월간 정체성 표식 확인.

### Loop 2 — 핵심 경험·사건 인과 추적성

Attack: Investigation → Deduction → Anomaly Manual → Victim Rescue → Recovery → Composite Result가 M01 Packet까지 손실 없이 이어지는가.

Finding:

- M01 Rescue Packet의 짧은 Flow가 `Anomaly Manual`을 생략했다.
- PR #217 원안은 최신 4개 경쟁 가설을 충분히 표현하지 못했으며, PR #218 원안은 공식 승차권과 검은 승차권의 역할 경계를 약하게 표현했다.

Decision: `MUST_FIX`.

Correction:

- Rescue Flow를 `Investigation → Deduction / Anomaly Manual → Victim Rescue → Recovery`로 교정했다.
- H1 공식 원본 목적지설, H2 단일 가짜 목적지설, H3 개인 기억 투영설, H4 검은 승차권 원인설과 지지·반박 상태를 고정했다.
- 승차권 없는 청취자 반증, 공식 승차권 구출, 검은 승차권 접촉·파괴 폐기를 테스트로 고정했다.

Recheck: 4가설, Canon v2 관측, 구출→회수 경계, M01/M04 역할이 문서와 기계 정본에 모두 존재.

### Loop 3 — 폐기 설정·workspace 충돌 재유입

Attack: Google Sheet 또는 존재하지 않는 prompt가 현재 작업면으로 재활성화되는가. 검은 승차권 구형 정답이 되살아나는가.

Finding:

- Base 호환 schema의 `USER_FACING_GDD_WORKSPACE` 필드는 제거할 수 없지만, 현재 운영 의미가 없으면 consumer가 오해할 수 있었다.
- Registry는 존재하지 않는 `VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v8.md`를 참조했다.

Decision: schema 필드는 `KEEP_FOR_BASE_COMPATIBILITY`, 운영 의미는 `MUST_FIX`.

Correction:

- Notion=`human_facing`, Repository=`structured_implementation`, Sheet=`MIGRATION_ONLY / DO_NOT_USE_FOR_NEW_WORK / NO_NEW_WRITES`를 adapter·registry·문서·테스트에 고정했다.
- 존재하지 않는 prompt route를 제거하고 실제 adapter를 통합 실행 계약으로 사용한다.
- 검은 승차권은 원인 경쟁 가설/잔향 후보로만 남고 구출·회수 자동 정답은 금지한다.

Recheck: 활성 nonexistent prompt 참조 0건, workspace split과 legacy sheet 금지 표식 확인.

### Loop 4 — 테스트·CI의 거짓 양성

Attack: 새 정본을 만들었지만 선택 CI가 테스트하지 않거나 generated Base view가 이전 adapter hash를 유지하는가.

Finding:

- 기존 main에는 현재 월간 정본을 기계적으로 검증하는 단일 계약이 없었다.
- adapter 변경 뒤 generated view를 재생성하지 않으면 hash 검사가 실패한다.

Decision: `MUST_FIX`.

Correction:

- `tests/test_current_planning_canon.py`를 RED부터 추가해 cadence, M01/M04, Gate, workspace, PR 7건, 4가설, Canon v2, stale ledger, 5-loop/readback을 검사한다.
- Base pin `19d936a3048115ab1bf8d94a6400d9bedbe09b2f`의 공식 builder로 생성물 5개와 dashboard를 재생성했다.
- selective documentation CI와 full Python discovery가 새 테스트를 실행한다.

Recheck: focused 10/10, 전체 Python 430/430, Base operating contract `PASS`.

### Loop 5 — 권한·보호 경로·병합 후 인수인계

Attack: 문서 통합이 runtime 구현 승인처럼 보이거나 보호 경로를 건드리는가. 병합만 하고 GitHub/Notion 상태가 다시 갈라지는가.

Finding:

- 기존 PR 템플릿에는 적대적 검토 칸이 있었지만 최소 5회, latest-head CI, GitHub·Notion postmerge readback을 필수 체크로 고정하지 않았다.

Decision: `MUST_FIX`.

Correction:

- `AGENTS.md`, PR template, MVP workflow, current handoff에 최소 5회 whole-scope 검토, expected-head merge, GitHub·Notion readback을 추가했다.
- `PLAN_LOCK`, `WAITING_USER_DRAFT`, `runtime_implementation_authorized=false`, Human QA `NOT_RUN`, `POC_PASSED=NOT_DECLARED`, Production `NOT_APPROVED`를 유지했다.
- 보호 runtime/data/Scene/asset 경로 변경 0건을 확인했다.

Recheck: scope guard와 postmerge 절차 표식 확인. 실제 exact-head CI·merge·Notion readback은 통합 PR 단계에서 수행한다.

## 4. TDD·검증 증거

1. 새 월간 정본 부재 상태에서 `tests/test_current_planning_canon.py` 6건이 RED.
2. 1차 구현 뒤 focused 33건 PASS.
3. 커밋 전 generated hash 검사는 의도대로 1건 실패; adapter와 생성물을 커밋한 HEAD에서는 해소.
4. 1차 전체 discovery: Python 430/430 PASS.
5. 5-loop 추가 finding용 테스트 4건 RED.
6. 교정 뒤 focused current canon 10/10 PASS.
7. 최종 전체 discovery: Python 434/434 PASS.
8. Base operating contract: PASS.
9. `git diff --check`: PASS.
10. 보호 경로 변경: 0건.

## 5. 병합 전 판정

- 7개 원 PR 내용: `INTEGRATED_WITH_CANON_CORRECTIONS`
- 현재 Repository 정본: `PASS_PREMERGE`
- exact-head GitHub CI: `PENDING`
- 원 PR 정리: 통합 PR main readback 뒤 `SUPERSEDED_BY_INTEGRATED_CANON`으로 close 예정
- Notion sync/readback: 통합 PR main readback 뒤 실행 예정
- runtime·asset 구현: `NOT_AUTHORIZED / NOT_CHANGED`
- Human QA: `NOT_RUN`
- POC/Production: `NOT_DECLARED / NOT_APPROVED`
