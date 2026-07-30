# 프로젝트 업데이트 프로토콜

> 목적: 기획·구현·검증 정보가 대화나 단일 PR에만 남아 유실되는 것을 방지한다.
> 상태 원본: `docs/CURRENT_STATUS.md`
> 인수인계 원본: `docs/CURRENT_HANDOFF.md`
> 상세 설계 원본: `docs/GAME_DESIGN_DOCUMENT.md`
> 구현 순서 원본: `MVP_ROADMAP.md`
> 검증 원본: `TEST_CHECKLIST.md`
> 결정 기록: `docs/DECISION_LOG.md`
> Google GDD Sheet: `14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck`
> 즉시 동기화 결정: `D-2026-07-31-CANON-SHEET-SYNC`

## 1. 적용 원칙

1. 중요한 기획 결정은 구현 전에 승인 설계 또는 결정 로그에 기록한다.
2. 주요 변경과 사용자 승인 결정은 같은 작업 단위에서 GitHub 책임 원본과 연결된 Google Sheet에 동일 Decision ID로 반영한다.
3. 구현 PR은 코드뿐 아니라 영향받은 정본·상태·로드맵·체크리스트를 함께 갱신한다.
4. 병합 뒤에는 PR 번호, merge commit, 검증 run과 미실행 게이트를 상태 원본에 기록한다.
5. 자동 검증, 사람 눈 QA, 신규 플레이어 검증, `POC_PASSED`, 제작 확대 승인을 서로 대체하지 않는다.
6. 이전 설계·구현·QA는 삭제하지 않고 `HISTORICAL_REGRESSION_EVIDENCE` 또는 superseded 기록으로 보존한다.
7. 원문을 축약하거나 대체할 때는 기존 의미의 이동 위치와 책임 원본을 명시한다.
8. 브랜치 단계 동기화는 허용하되 branch commit을 main commit으로 표시하지 않고 `BRANCH_SYNCED_PENDING_MAIN`을 사용한다.

## 2. 즉시 정본 동기화 절차

주요 변경 또는 승인 결정이 발생하면 다음 순서로 처리한다.

```text
Decision ID 확인·발급
→ 분야별 GitHub 책임 원본 갱신
→ docs/DECISION_LOG.md 또는 전용 결정 기록 연결
→ 관련 Google Sheet 계획 탭 갱신
→ 02_현재_확정결정 또는 상태 탭 갱신
→ 99_변경이력 기록
→ GitHub 경로·Sheet 범위·commit SHA 재조회
→ Issue·PR·보고서에 증거 기록
```

### 같은 Decision ID

- GitHub 책임 원본, 결정 로그, Sheet 행, Issue·PR 기록에 같은 ID를 사용한다.
- 같은 결정의 초안·검수·승인·구현 상태 변경은 기존 ID를 유지한다.
- 기존 결정을 대체하면 새 ID를 만들고 `supersedes` 또는 `대체 Decision`을 기록한다.
- Sheet 변경이력의 `UL-SYNC-*` ID는 별도 이력 ID이며 변경 내용에 원 Decision ID를 반드시 적는다.

### 브랜치 단계

병합 전 기록 형식:

```text
GitHub ref: <branch commit SHA> / Draft PR #N
main commit: PENDING
동기화 상태: BRANCH_SYNCED_PENDING_MAIN
```

병합 뒤에는 같은 Decision ID의 Sheet 행과 변경이력을 merge commit 기준으로 재검증한다.

## 3. 변경 유형별 필수 갱신

| 변경 유형 | GitHub 필수 원본 | Google Sheet 기본 연결 |
|---|---|---|
| 운영 원칙·정본 관리 | `AGENTS`, `OPERATING_MODEL`, `PROJECT_UPDATE_PROTOCOL`, 결정 로그 | `01_작업순서`, `02_현재_확정결정`, `99_변경이력` |
| 코어 정체성·장르·승리 조건 | `PROJECT_CORE`, GDD, `CURRENT_STATUS`, 결정 로그 | `02`, `05`, `10`, `12`, `20`, `99` |
| 일정·성장·사건·연구 시스템 | 승인 spec, GDD, 데이터 계약, `CURRENT_STATUS`, Roadmap, Checklist, 결정 로그 | `01`, `02`, `12`, `30`, `40`, `41`, `50`, `80`, `99` |
| 사건·서사·콘텐츠 구조 | 분야 기획서, 사건 설계, GDD, 결정 로그 | `02`, `11`, `13`, `14`, `50`, `52`, `80`, `99` |
| 미니게임·회수·UX 흐름 | 시스템 spec, UX 기획, GDD, Checklist, 결정 로그 | `02`, `15`, `20`, `40`, `51`, `60`, `80`, `99` |
| 구현 상태 변경 | `CURRENT_STATUS`, `CURRENT_HANDOFF`, Roadmap, Checklist | `01`, `04`, `05`, `80`, `99` |
| PR 병합·CI 결과 | `CURRENT_STATUS`, `CURRENT_HANDOFF`, Checklist, 관련 QA 문서 | `01`, `04`, `80`, `99` |
| 저장·ID·호환 변경 | GDD, 상태, 인수인계, migration 계획, 회귀 테스트 | `02`, `04`, 관련 시스템 탭, `99` |
| 사람 QA·플레이 검증 | 상태, 인수인계, Checklist, 판정 기록 | `04`, `80`, `99` |

표의 Sheet 번호는 탭 접두사다. 실제로는 변경과 직접 관련된 최소 탭만 갱신한다.

## 4. PR 작성 전 확인

- 영향 문서 목록과 Decision ID를 PR 본문에 적는다.
- 최신 승인 설계와 데이터 계약이 코드와 일치하는지 확인한다.
- `ON_BRANCH`, `CI_PENDING`, `NOT_RUN`, `NOT_DECLARED`를 사실에 맞게 사용한다.
- 이전 증거를 삭제하거나 현재 증거로 오인하지 않는다.
- 보호 경로·저장·ID·CORE 불변 계약의 영향 여부를 기록한다.
- Sheet 쓰기 대상 탭과 예상 A1 범위를 적는다.

## 5. 병합 전 확인

- required workflow가 현재 head에서 성공했다.
- review thread가 0건이다.
- changed-file 목록이 계획 범위와 일치한다.
- 상태·인수인계·정본·로드맵·체크리스트의 상태 어휘가 일치한다.
- `docs/DECISION_LOG.md` 또는 전용 결정 기록에 새 결정 또는 supersession이 기록됐다.
- 승인 결정의 Sheet 행이 같은 Decision ID와 branch commit을 가진다.
- 사람 검증이 없으면 `POC_PASSED`와 제작 확대를 선언하지 않는다.

## 6. 병합 후 증거 형식

```text
Decision ID: D-YYYY-MM-DD-...
Issue: #N / completed|open
PR: #N / merged
Merge commit: <sha>
GitHub canonical paths: <paths>
Sheet ranges: <tab!range>
Sheet sync: SYNCED|PARTIAL|BLOCKED
Documentation run: #N PASS|FAIL|NOT_RUN
Implementation run: #N PASS|FAIL|NOT_RUN
Visual/input run: #N PASS|FAIL|NOT_RUN
Human usability QA: PASS|FAIL|NOT_RUN
New-player validation: PASS|FAIL|NOT_RUN
POC_PASSED: DECLARED|NOT_DECLARED
Production expansion: APPROVED|NOT_APPROVED
```

## 7. 동기화 완료 기준

다음을 모두 확인해야 `SYNCED`로 보고한다.

- GitHub 책임 원본에서 Decision ID와 결정 내용을 재조회했다.
- GitHub commit SHA와 변경 경로를 기록했다.
- 관련 Sheet 탭에서 같은 Decision ID와 상태를 재조회했다.
- `99_변경이력`에 GitHub ref, Sheet 범위, 동기화 상태, 재검증 내용을 기록했다.
- 브랜치 단계라면 `BRANCH_SYNCED_PENDING_MAIN`, 병합 뒤라면 `SYNCED`를 사용했다.
- 미실행 runtime·사람 검증을 숨기지 않았다.

## 8. 현재 기준

- Issue #75 / PR #76 / commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478`: 7일 주간·가변 일정 구현 병합
- 문서 run #273, ANNUAL run #121, Visual run #51: PASS
- PR #77 / commit `229c74a80b8aefd71d16befb95758f4dcc7f591f`: 상태 원본·인수인계 병합
- 사람 사용성·신규 플레이어 검증: `NOT_RUN`
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`
