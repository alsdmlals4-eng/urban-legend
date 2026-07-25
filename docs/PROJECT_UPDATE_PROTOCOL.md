# 프로젝트 업데이트 프로토콜

> 목적: 기획·구현·검증 정보가 대화나 단일 PR에만 남아 유실되는 것을 방지한다.  
> 상태 원본: `docs/CURRENT_STATUS.md`  
> 인수인계 원본: `docs/CURRENT_HANDOFF.md`  
> 상세 설계 원본: `docs/GAME_DESIGN_DOCUMENT.md`  
> 구현 순서 원본: `MVP_ROADMAP.md`  
> 검증 원본: `TEST_CHECKLIST.md`  
> 결정 기록: `docs/DECISION_LOG.md`

## 1. 적용 원칙

1. 중요한 기획 결정은 구현 전에 승인 설계 또는 결정 로그에 기록한다.
2. 구현 PR은 코드뿐 아니라 영향받은 정본·상태·로드맵·체크리스트를 함께 갱신한다.
3. 병합 뒤에는 PR 번호, merge commit, 검증 run과 미실행 게이트를 상태 원본에 기록한다.
4. 자동 검증, 사람 눈 QA, 신규 플레이어 검증, `POC_PASSED`, 제작 확대 승인을 서로 대체하지 않는다.
5. 이전 설계·구현·QA는 삭제하지 않고 `HISTORICAL_REGRESSION_EVIDENCE` 또는 superseded 기록으로 보존한다.
6. 원문을 축약하거나 대체할 때는 기존 의미의 이동 위치와 책임 원본을 명시한다.

## 2. 변경 유형별 필수 갱신

| 변경 유형 | 반드시 확인·갱신할 문서 |
|---|---|
| 코어 정체성·장르·승리 조건 | `PROJECT_CORE`, GDD, `CURRENT_STATUS`, 결정 로그 |
| 일정·성장·사건·연구 시스템 | 승인 spec, GDD, 데이터 계약, `CURRENT_STATUS`, Roadmap, Checklist, 결정 로그 |
| 구현 상태 변경 | `CURRENT_STATUS`, `CURRENT_HANDOFF`, Roadmap, Checklist |
| PR 병합·CI 결과 | `CURRENT_STATUS`, `CURRENT_HANDOFF`, Checklist, 관련 QA 문서 |
| 저장·ID·호환 변경 | GDD, 상태, 인수인계, migration 계획, 회귀 테스트 |
| 사람 QA·플레이 검증 | 상태, 인수인계, Checklist, 판정 기록 |

## 3. PR 작성 전 확인

- 영향 문서 목록을 PR 본문에 적는다.
- 최신 승인 설계와 데이터 계약이 코드와 일치하는지 확인한다.
- `ON_BRANCH`, `CI_PENDING`, `NOT_RUN`, `NOT_DECLARED`를 사실에 맞게 사용한다.
- 이전 증거를 삭제하거나 현재 증거로 오인하지 않는다.
- 보호 경로·저장·ID·CORE 불변 계약의 영향 여부를 기록한다.

## 4. 병합 전 확인

- required workflow가 현재 head에서 성공했다.
- review thread가 0건이다.
- changed-file 목록이 계획 범위와 일치한다.
- 상태·인수인계·정본·로드맵·체크리스트의 상태 어휘가 일치한다.
- `docs/DECISION_LOG.md`에 새 결정 또는 supersession이 기록됐다.
- 사람 검증이 없으면 `POC_PASSED`와 제작 확대를 선언하지 않는다.

## 5. 병합 후 증거 형식

```text
Issue: #N / completed|open
PR: #N / merged
Merge commit: <sha>
Documentation run: #N PASS|FAIL|NOT_RUN
Implementation run: #N PASS|FAIL|NOT_RUN
Visual/input run: #N PASS|FAIL|NOT_RUN
Human usability QA: PASS|FAIL|NOT_RUN
New-player validation: PASS|FAIL|NOT_RUN
POC_PASSED: DECLARED|NOT_DECLARED
Production expansion: APPROVED|NOT_APPROVED
```

## 6. 현재 기준

- Issue #75 / PR #76 / commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478`: 7일 주간·가변 일정 구현 병합
- 문서 run #273, ANNUAL run #121, Visual run #51: PASS
- PR #77 / commit `229c74a80b8aefd71d16befb95758f4dcc7f591f`: 상태 원본·인수인계 병합
- 사람 사용성·신규 플레이어 검증: `NOT_RUN`
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`
