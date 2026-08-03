# Grill Me Batch 2 사전 병합 적대적 감사

> 상태: `CONTENT_AUDIT_COMPLETE / FINAL_EXACT_HEAD_CI_PENDING`
> 감사일: 2026-08-03
> 대상 PR: `#140`
> base: `main@ad912c7a20e2adcf9ff2aef60cc3ef60db0eb828`
> 내용 감사 snapshot head: `7f9e72f666e18d3cababe6dcc714ef0f06c2724a`
> Base: `9.4.3`
> 별도 병합 승인: `REQUIRED / NOT_YET_GRANTED`
> 구현: `NOT_AUTHORIZED`
> 사람 검증: `NOT_RUN`

이 문서는 Grill Me Batch 2의 승인 Decision 10개, 조사 시스템 Design, 프로젝트 코어 정합성, Google Sheet 동기화와 PR #140 병합 경계를 적대적으로 검토한 기록이다. 이 감사 통과는 병합 승인이 아니다.

## 1. 감사 범위

내용 감사 snapshot에서 PR #140은 main보다 앞서 있고 뒤처진 커밋은 없었다.

```yaml
base: ad912c7a20e2adcf9ff2aef60cc3ef60db0eb828
snapshot_head: 7f9e72f666e18d3cababe6dcc714ef0f06c2724a
behind_by: 0
changed_files_before_audit_record: 13
scope: DOCS_ONLY
```

내용 감사 대상:

- `docs/GRILLME_BATCH_2_LEDGER.md`
- 승인 Decision 10개
- `docs/planning/2026-08-02-investigation-system-design.md`
- `docs/PROJECT_CORE.md`
- Google Sheet의 작업 순서·현재 결정·감사·핵심 시스템·메인 콘텐츠·변경 이력
- PR #140 리뷰·댓글·CI 경계

이 감사 문서가 추가된 뒤 최종 변경 파일 수와 exact head는 다시 검증한다.

## 2. Decision 카운터·Sheet 대조

Batch 2의 승인 Decision은 정확히 10개다.

1. `D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING`
2. `D-2026-08-02-INVESTIGATION-RANK-CONDITION-DISCLOSURE`
3. `D-2026-08-03-INCIDENT-MULTIAXIS-GATED-RANKING`
4. `D-2026-08-03-INCIDENT-RANK-STAGES-AND-LABELS`
5. `D-2026-08-03-INCIDENT-REPLAY-CANON-AND-MASTERY-RECORDS`
6. `D-2026-08-03-INCIDENT-CHECKPOINT-RETRY-AND-CANON-CONFIRMATION`
7. `D-2026-08-03-CAMPAIGN-REWIND-UNLOCK-AND-BRANCH-SLOTS`
8. `D-2026-08-03-CAMPAIGN-REWIND-CANON-ANCHOR-SCOPE`
9. `D-2026-08-03-ACCESSIBILITY-EQUIVALENCE-AND-MASTERY-GATES`
10. `D-2026-08-03-MASTERY-REWARD-SCOPE-AND-CAMPAIGN-NEUTRALITY`

다음 Sheet 범위에서 같은 순서와 Decision ID를 확인했다.

```text
01_작업순서!A43:N52
02_현재_확정결정!A44:L53
99_변경이력!A67:H76
```

카운트 결과:

```yaml
approved_new_product_decisions: 10
missing_decision_id: 0
duplicate_counted_decision: 0
same_question_followup_double_count: 0
sheet_id_mismatch: 0
batch_counter: 10_OF_10
```

중간 행에 기록된 과거 PR head는 각 승인 시점의 변경 이력이며 최신 exact head를 뜻하지 않는다. 최신 head와 감사 상태는 프로젝트 허브·마지막 변경 이력·PR 메타데이터에서 별도로 갱신한다.

## 3. 핵심 계약 대조

### 조사 공정성

- 일반 클리어의 필수 진실에는 비판정 또는 확정 우회 경로가 있다.
- 능력·태그·판정은 비용·근거·위험·구출·전투 우위와 S 랭크 가능성을 바꾼다.
- 확률과 빌드가 괴이의 객관적 진실을 변경하거나 필수 진행을 영구 차단하지 않는다.

판정: `CONSISTENT`

### 랭크와 연도 결산

- 사건은 네 축과 관문형 `C/B/A/S` 랭크로 평가한다.
- 기관 강제 봉쇄·정상 종결 실패에는 종합 랭크를 부여하지 않는다.
- 사건 랭크는 연도 결산의 평균 점수·도덕 등급으로 사용하지 않는다.
- 연도 결산은 조사 성향·보호 원칙·기관 위치·남은 책임의 복합 기록을 유지한다.

판정: `CONSISTENT_WITH_YEAR_ONE_AUTHORITY`

### 정본과 재도전

- `기록 재현`은 숙련 기록만 갱신한다.
- 피해자·관계·기관·분기 환류·연도 결산은 캠페인 정본만 참조한다.
- 실제 서사 변경은 첫 1년차 완료 뒤 해금되는 캠페인 되감기로만 수행한다.
- 되감기는 출동 준비 확정 직전 정본 앵커로 돌아가 사건 전체를 다시 진행한다.
- 과거 사건 결과만 바꾸고 미래 진행을 유지하는 혼합 정본은 금지한다.

판정: `CONSISTENT / DATA_SPEC_PENDING`

### 접근성

- 표현·입력·시간 등가 기능은 랭크와 업적에 중립이다.
- 판단 자동 해결도 일반 클리어와 핵심 서사를 막지 않는다.
- 자동 해결이 대신한 숙련 관문만 등가 과제로 대체한다.
- 대체 가능한 운동·감각 방식이 없는 행동은 S 필수 조건에서 제거한다.

판정: `CONSISTENT / HUMAN_ACCESSIBILITY_VALIDATION_REQUIRED`

### 숙련 보상

- S 랭크와 업적은 캠페인 필수 전력·필수 서사를 독점하지 않는다.
- 보상은 인장·칭호·코스메틱·전시품·문서 테마·비필수 부록 중심이다.
- 게임플레이 확장은 캠페인에 반입할 수 없는 기록 재현 전용 변칙으로 제한한다.
- 특수 업적은 S 랭크 관문과 분리한다.

판정: `CONSISTENT / REWARD_MOTIVATION_NOT_VALIDATED`

## 4. 발견 사항과 보완

### F-01 — 프로젝트 코어의 구형 미니게임·이중 코어 표현

초기 상태:

- 미니게임 목적이 `조작형 위험 검증`으로 남아 있었음
- 육성·준비와 사건·회수가 `이중 코어`로 표현됨
- 회수 전투 행동군에 공격이 빠져 있었음
- 안정화·봉쇄·잔향 회수 대신 포획 중심 구형 표현이 남아 있었음

위험:

- 구현 담당자가 피해자 구출이 아닌 규칙 실험 미니게임을 제작할 수 있음
- 지원 시스템이 메인 사건 콘텐츠와 동급 또는 자동 해결 계층으로 확대될 수 있음
- 공격이 금지되거나 HP 처치 중심으로 오해될 수 있음

보완:

- `docs/PROJECT_CORE.md`를 최신 `조사 → 피해자 구출 → 회수 전투` 권위로 교정
- 육성·준비를 지원·환류 계층으로 명시
- 공격을 현현·매개체 약화와 대응·봉쇄 기회 생성 행동으로 명시
- 공격 반복 승리와 HP 0 처치 금지 유지
- Batch 2 조사·랭크·재도전·접근성·보상 계약은 `NOT_IMPLEMENTED`로 경계 표시

상태: `RESOLVED_IN_PR_140`

### F-02 — 숙련 부록이 캠페인 정본 후일담을 덮어쓸 위험

초기 상태:

- S 보상 예시에 피해자 근황이 포함됐으나 기록 재현 S 결과와 캠페인 정본 결과의 관계가 명시되지 않았음

위험:

- 캠페인 정본은 B 결과인데 기록 재현 S 보상에서 피해자가 완전 회복한 것처럼 표시될 수 있음
- 숙련 기록과 피해자·관계·기관 정본이 다시 혼합될 수 있음

보완:

- 캠페인 종속 후일담은 활성 캠페인 정본만 참조
- 기록 재현의 대안 결과는 `기록 재현/가상 대응 기록/비정본 대안`으로 표시
- 기록 재현 S가 실제 피해자·관계·기관 상태를 덮어쓰지 못하도록 Decision 10에 보호 규칙 추가

상태: `RESOLVED_IN_PR_140`

### F-03 — main 현재 권위 문서의 Batch 2 카운터

현재 main의 다음 문서는 Batch 2 `0/10`을 기록한다.

- `docs/CURRENT_CONFIRMED_DECISIONS.md`
- `docs/CURRENT_HANDOFF_VALIDATION.md`
- `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`

이는 PR #140이 아직 병합되지 않은 현재 main 기준으로는 정확하다. 병합 전 문서에서 `MERGED`로 바꾸면 미래 상태를 선반영하게 된다.

처리:

- PR #140 안에는 Batch 2 전용 Ledger와 Decision·Design·PROJECT_CORE를 포함
- 병합 뒤 실제 merge SHA와 함께 위 세 현재 권위 문서를 갱신하는 post-merge authority sync PR 필요
- Google Sheet도 merge SHA와 `MERGED_ON_MAIN` 상태로 후속 갱신

상태: `NON_BLOCKING / POST_MERGE_SYNC_REQUIRED`

## 5. 구현·검증 경계 감사

PR #140의 내용 감사 snapshot에서 다음을 확인했다.

```yaml
code_files_changed: 0
data_files_changed: 0
scene_files_changed: 0
project_settings_changed: 0
implementation_claim: NONE
poc_passed_claim: NONE
human_validation_claim: NONE
production_expansion_claim: NONE
```

각 신규 Decision은 `IMPLEMENTATION_NOT_AUTHORIZED`와 `HUMAN_VALIDATION_NOT_RUN` 경계를 유지한다. 접근성 등가성, 랭크 명칭, 보상 만족도와 재도전 동기는 실제 사람 검증 전까지 `NOT_VALIDATED`다.

## 6. 남은 미확정

다음은 이번 Design 병합으로 자동 승인되지 않는다.

- 축별 최소·상위·최고 관문의 사건별 상세 조건
- 사건별 치명적 결과·정상 종결 실패·랭크 상한 표
- 판정 모델과 재추첨 방지 구현
- 기능별 접근성 등가 과제·자동 해결 목록
- 장애 당사자·접근성 컨설턴트 검증 계획
- 캠페인 정본·숙련 기록·정본 앵커의 상세 데이터 스키마
- 자동·수동 저장과 클라우드 충돌 복구 정책
- 사건별 S 보상 수량·제작 예산·기록 재현 변칙
- 결과·출동 준비·확정 Gate·분기 슬롯·접근성·보상 UX
- 저승역 버티컬 슬라이스 사건 Spec
- 구현 계획·코드·사람 플레이테스트·POC 통과·Production 확대

## 7. 리뷰·CI Gate

내용 감사 snapshot 기준:

```yaml
review_threads: 0
submitted_reviews: 0
conversation_comments: 0
mergeable: true
```

이 감사 문서와 최종 Ledger·PR 설명 갱신 뒤 새로운 exact head에서 다음을 다시 확인한다.

```text
Documentation contracts
BCA Adoption
CORE workflow
ANNUAL workflow
```

모든 exact-head workflow가 성공하고 branch가 main보다 뒤처지지 않으며 리뷰 차단이 없을 때 최종 판정을 `READY_FOR_SEPARATE_MERGE_APPROVAL`로 올릴 수 있다.

## 8. 현재 판정

```yaml
content_audit: PASS_AFTER_CORRECTIONS
scope_audit: PASS_DOCS_ONLY
canon_conflict: RESOLVED
sheet_decision_ids: 10_OF_10_MATCHED
implementation_boundary: PRESERVED
review_blocker: NONE
final_exact_head_ci: PENDING
post_merge_authority_sync: REQUIRED
separate_merge_authorization: NOT_GRANTED
```

현재 판정은 `FINAL_EXACT_HEAD_CI_PENDING`이다. 자동 검증 성공은 병합 승인이 아니며, 사용자의 별도 `병합 승인` 전에는 PR #140을 병합하지 않는다.
