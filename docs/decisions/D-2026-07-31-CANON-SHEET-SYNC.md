# D-2026-07-31-CANON-SHEET-SYNC — 승인 결정 즉시 정본·Sheet 동기화

> 상태: `APPROVED_PROJECT_GOVERNANCE`
> 승인일: 2026-07-31
> 사용자 승인: 주요 변경사항 및 승인된 내용은 즉시 GitHub 권위 문서와 연결된 Google Sheet에 같은 결정 ID로 반영한다.
> 추적: Issue #121 / Draft PR #122
> Benchmark Gate: `NOT_APPLICABLE`

## 1. 결정

주요 기획 변경, 승인된 결정, 구현·검증 상태 변경은 대화·초안·PR 본문에만 남기지 않는다.

같은 작업 단위에서 다음을 함께 수행한다.

```text
결정 ID 발급
→ GitHub 분야별 책임 원본 갱신
→ docs/DECISION_LOG.md 또는 전용 결정 기록 연결
→ 관련 Google Sheet 계획 탭 갱신
→ 02_현재_확정결정 또는 상태 탭 갱신
→ 99_변경이력 기록
→ GitHub 경로·Sheet 범위·커밋 SHA·동기화 상태 재조회
```

## 2. 동일 결정 ID 규칙

- GitHub 권위 문서, 결정 로그, Sheet 행, Issue·PR 기록은 동일한 `Decision ID`를 사용한다.
- 초안·검수·승인·구현 상태가 바뀌어도 같은 결정을 설명하는 경우 ID를 새로 만들지 않고 상태와 근거를 갱신한다.
- 기존 결정을 대체하면 새 Decision ID를 만들고 `supersedes` 또는 `대체 Decision`을 기록한다.
- 단순 변경이력 ID는 `UL-SYNC-YYYYMMDD-NN` 형식을 사용할 수 있지만 반드시 원래 Decision ID를 변경 내용에 포함한다.

## 3. 즉시 동기화 대상

다음은 승인 직후 같은 작업 단위에서 동기화한다.

- 프로젝트 코어·장르·플레이어 약속
- 핵심 시스템·규칙·보상·실패 구조
- 콘텐츠 구조·사건 규격·서사 축
- 주요 UX 흐름·온보딩·접근성 계약
- Vertical Slice 범위·Gate·플레이테스트 계약
- 구현·검증·병합·사람 QA 상태
- 제작 확대·보류·폐기 결정
- 프로젝트 운영 원칙과 정본 관리 규칙

## 4. GitHub와 Sheet 역할

### GitHub

- 세부 근거·설계·대체 관계·검증 상태의 권위 원본이다.
- 분야별 책임 원본과 `docs/DECISION_LOG.md`가 결정의 의미를 소유한다.
- PR이 병합 전이면 브랜치 커밋을 기록하고 `PENDING_MAIN_MERGE`를 표시한다.

### Google Sheet

- 승인 결정, 계획 순서, 영향 영역, 검증 상태를 탐색하는 작업면이다.
- GitHub 상세 설계를 대체하지 않는다.
- 주요 결정은 `02_현재_확정결정`, 변경 이력은 `99_변경이력`에 반드시 남긴다.
- 분야별 연결 탭은 변경 유형에 따라 함께 갱신한다.

## 5. 브랜치 단계 동기화

병합 전이라도 사용자 승인과 주요 변경을 Sheet에 기록할 수 있다.

이 경우 다음을 명시한다.

```text
GitHub ref: branch commit SHA / Draft PR #N
동기화 상태: BRANCH_SYNCED_PENDING_MAIN
main commit: PENDING
```

병합 후에는 같은 Decision ID의 행과 변경이력을 main merge commit으로 재검증한다.

## 6. 필수 증거

완료 보고에는 다음을 포함한다.

- Decision ID
- 변경한 GitHub 경로
- GitHub commit SHA
- 관련 Issue·PR
- 변경한 Sheet 탭과 A1 범위
- Sheet 재조회 결과
- 동기화 상태
- 아직 미검증인 runtime·사람 QA·main 병합 상태

## 7. 금지

- 승인 결정을 대화에만 남김
- GitHub와 Sheet에 서로 다른 Decision ID 사용
- 브랜치 커밋을 main commit처럼 표시
- Sheet 요약이 GitHub 상세 설계를 덮어씀
- 승인 전 초안을 `CURRENT` 또는 `APPROVED`로 기록
- 커밋·범위·재검증 기록 없이 동기화 완료 선언

## 8. 책임 원본

- 동기화 절차: `docs/PROJECT_UPDATE_PROTOCOL.md`
- 운영 생명주기: `docs/OPERATING_MODEL.md`
- 승인 결정 인덱스: `docs/DECISION_LOG.md`
- 상세 결정 기록: 이 문서
- Sheet 승인 결정: `02_현재_확정결정`
- Sheet 변경이력: `99_변경이력`

## 9. 최초 적용 증거

```yaml
decision_id: D-2026-07-31-CANON-SHEET-SYNC
github:
  branch: plan/urban-legend-planning-audit
  pull_request: 122
  paths:
    - docs/decisions/D-2026-07-31-CANON-SHEET-SYNC.md
    - docs/PROJECT_UPDATE_PROTOCOL.md
    - docs/OPERATING_MODEL.md
  pre_sheet_commit: f6e2c7fa7c6d8928cb3100e69ca90c4c3a499b55
sheet:
  spreadsheet_id: 14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck
  ranges:
    - 01_작업순서!A6:J6
    - 02_현재_확정결정!A6:J6
    - 99_변경이력!A6:H6
  status: BRANCH_SYNCED_PENDING_MAIN
verification:
  github_paths_reread: true
  sheet_ranges_reread: true
  main_merge: PENDING
  runtime: NOT_RUN
  human_qa: NOT_RUN
```
