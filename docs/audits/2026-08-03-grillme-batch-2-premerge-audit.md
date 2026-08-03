# Grill Me Batch 2 사전 병합 적대적 감사

> 상태: `CONTENT_AUDIT_PASS / SEPARATE_MERGE_APPROVAL_REQUIRED`
> 감사일: 2026-08-03
> 대상 PR: `#140`
> base: `main@ad912c7a20e2adcf9ff2aef60cc3ef60db0eb828`
> Base: `9.4.3`
> 별도 병합 승인: `REQUIRED / NOT_YET_GRANTED`
> 구현: `NOT_AUTHORIZED`
> 사람 검증: `NOT_RUN`

이 문서는 Grill Me Batch 2의 승인 Decision 10개, 조사 시스템 Design, 프로젝트 코어 정합성, Google Sheet 동기화와 PR #140 병합 경계를 적대적으로 검토한 기록이다. 이 감사 통과는 병합 승인이 아니다.

## 1. 범위 판정

PR #140은 다음 문서만 변경한다.

- Batch 2 Ledger 1개
- 조사 시스템 Design 1개
- 승인 Decision 10개
- 프로젝트 코어 정합성 교정 1개
- 본 감사 1개

```yaml
changed_files: 14
code_files: 0
data_files: 0
scene_files: 0
project_settings: 0
scope: DOCS_ONLY
main_behind: 0
```

변경 파일의 정확한 최종 HEAD·파일 목록·ahead/behind 값은 PR #140의 최종 검증 기록을 사용한다. 이 문서에 HEAD를 기록한 뒤 다시 커밋하는 자기참조는 피한다.

## 2. Decision·Sheet 대조

승인 Decision은 정확히 10개다.

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

Google Sheet에서 같은 순서와 ID를 확인한 범위:

```text
01_작업순서!A43:N52
02_현재_확정결정!A44:L53
99_변경이력!A67:H76
```

```yaml
approved_new_product_decisions: 10
missing_decision_id: 0
duplicate_counted_decision: 0
same_question_followup_double_count: 0
sheet_id_mismatch: 0
batch_counter: 10_OF_10
```

각 중간 행의 PR HEAD는 해당 승인 시점의 역사 기록이다. 최신 exact head는 프로젝트 허브·최종 감사 행·PR 메타데이터에서 별도로 관리한다.

## 3. 핵심 계약 감사

### 조사 공정성

- 일반 클리어 필수 진실에는 비판정 또는 확정 우회 경로가 있다.
- 능력·태그·판정은 비용·근거·위험·구출·전투 우위와 S 랭크 가능성을 바꾼다.
- 확률과 빌드가 객관적 진실을 변경하거나 필수 진행을 영구 차단하지 않는다.

판정: `CONSISTENT`

### 랭크와 연도 결산

- 조사 정확도·피해자 보호·현장 통제·기록 완성도 네 축과 관문형 `C/B/A/S` 랭크를 사용한다.
- 기관 강제 봉쇄·정상 종결 실패에는 종합 랭크를 부여하지 않는다.
- 사건 랭크는 연도 결산 평균 점수나 도덕 등급으로 사용하지 않는다.
- 연도 결산은 조사 성향·보호 원칙·기관 위치·남은 책임의 복합 기록을 유지한다.

판정: `CONSISTENT_WITH_YEAR_ONE_AUTHORITY`

### 정본과 재도전

- `기록 재현`은 숙련 기록만 갱신한다.
- 피해자·관계·기관·분기 환류·연도 결산은 캠페인 정본만 참조한다.
- 실제 서사 변경은 첫 1년차 완료 뒤 해금되는 캠페인 되감기로만 수행한다.
- 되감기는 출동 준비 확정 직전 정본 앵커에서 사건 전체를 다시 진행한다.
- 과거 결과와 미래 진행을 임의로 혼합하지 않는다.

판정: `CONSISTENT / DATA_SPEC_PENDING`

### 접근성

- 표현·입력·시간 등가 기능은 랭크와 업적에 중립이다.
- 판단 자동 해결도 일반 클리어와 핵심 서사를 막지 않는다.
- 자동 해결이 대신한 해당 숙련 관문만 등가 과제로 대체한다.
- 대체 가능한 방식이 없는 운동·감각 과제는 S 필수 조건에서 제거한다.

판정: `CONSISTENT / HUMAN_ACCESSIBILITY_VALIDATION_REQUIRED`

### 숙련 보상

- S 랭크와 업적은 캠페인 필수 전력·필수 서사를 독점하지 않는다.
- 보상은 인장·칭호·코스메틱·전시품·문서 테마·비필수 부록 중심이다.
- 게임플레이 확장은 캠페인에 반입할 수 없는 기록 재현 전용 변칙으로 제한한다.
- 특수 업적은 S 랭크 관문과 분리한다.

판정: `CONSISTENT / REWARD_MOTIVATION_NOT_VALIDATED`

## 4. 발견 사항과 보완

### F-01 — 구형 프로젝트 코어 표현

발견:

- `조작형 위험 검증`
- 육성·준비와 사건·회수의 `이중 코어`
- 회수 행동군의 공격 누락
- 포획 중심 구형 표현

보완:

- 최신 권위를 `조사 → 피해자 구출 → 회수 전투`로 교정
- 일정·육성·동료·장비·연구·기관을 준비·지원·환류 계층으로 명시
- 공격은 현현·매개체 약화와 대응·봉쇄 기회 생성 행동으로 명시
- 공격 반복 승리와 HP 0 처치 금지 유지

상태: `RESOLVED`

### F-02 — 숙련 부록과 캠페인 정본 혼합 위험

발견:

- S 보상 예시의 피해자 근황이 기록 재현 S 결과로 캠페인 정본을 덮어쓸 수 있는 해석 여지

보완:

- 캠페인 종속 후일담은 활성 캠페인 정본만 참조
- 기록 재현 대안 결과는 `기록 재현 / 가상 대응 기록 / 비정본 대안`으로 표시
- 기록 재현 S가 실제 피해자·관계·기관 상태를 변경하지 않음

상태: `RESOLVED`

### F-03 — PROJECT_CORE 문서 계약 훼손

첫 교정 뒤 자동 검증에서 다음이 발견됐다.

- 고정 문자열 `상태: CORE_RECORDED`와 `검토 상태: CORE_STRESS_TESTED`가 확장 상태 문자열로 변경됨
- CORE-MVP-001 상세 설계·구현계획 참조 누락
- Markdown 후행 공백으로 `git diff --check` 실패

보완:

- 고정 상태 문자열 복원
- 최신 정합성·Batch 감사 상태는 별도 줄로 분리
- 다음 참조 복원:
  - `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`
  - `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md`
- `REQUIRES_REAPPROVAL` 경계 복원
- 후행 공백 제거

교정 검증:

```yaml
documentation_run_30774593728: PASS
bca_run_30774593727: PASS
```

상태: `RESOLVED`

### F-04 — main 현재 권위 문서의 Batch 2 카운터

main의 다음 문서는 아직 Batch 2 `0/10`을 기록한다.

- `docs/CURRENT_CONFIRMED_DECISIONS.md`
- `docs/CURRENT_HANDOFF_VALIDATION.md`
- `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`

PR #140이 미병합인 현재 main 기준으로는 정확하다. 병합 전에 `MERGED`를 선반영하지 않는다.

처리:

- PR #140 병합 뒤 실제 merge SHA를 사용해 세 현재 권위 문서를 post-merge sync PR로 갱신
- Google Sheet도 `MERGED_ON_MAIN`과 실제 merge SHA로 후속 갱신

상태: `NON_BLOCKING / POST_MERGE_SYNC_REQUIRED`

## 5. 자동 검증 범위

이번 PR 변경 경로가 자동 실행하는 워크플로:

- `Validate documentation contracts`
- `Validate Urban Legend BCA Adoption`

CORE·ANNUAL 워크플로는 코드·테스트·현재 권위 문서 등 각 workflow의 `paths` 목록이 변경될 때만 자동 실행된다. 이번 신규 Decision·Design·감사 문서에는 해당 경로가 없으므로:

```yaml
core_workflow: NOT_TRIGGERED_BY_PATH_FILTER
annual_workflow: NOT_TRIGGERED_BY_PATH_FILTER
```

이를 PASS로 가장하지 않는다. Documentation suite는 PROJECT_CORE 고정 계약과 활성 문서 참조를 포함한 65개 테스트를 실행한다.

최종 문서 커밋 뒤의 exact-head run ID와 결론은 PR 설명과 Sheet 감사 행에 기록한다. 이 문서에 최종 HEAD를 적어 다시 HEAD가 바뀌는 자기참조는 피한다.

## 6. 구현·검증 경계

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

각 신규 Decision은 `IMPLEMENTATION_NOT_AUTHORIZED`와 `HUMAN_VALIDATION_NOT_RUN` 경계를 유지한다. 접근성 등가성, 랭크 명칭, 보상 만족도와 재도전 동기는 사람 검증 전까지 `NOT_VALIDATED`다.

## 7. 남은 미확정

이번 Design 병합으로 자동 승인되지 않는 항목:

- 축별 최소·상위·최고 관문의 사건별 상세 조건
- 사건별 치명적 결과·정상 종결 실패·랭크 상한 표
- 판정 모델과 재추첨 방지 구현
- 기능별 접근성 등가 과제·자동 해결 목록
- 장애 당사자·접근성 컨설턴트 검증 계획
- 캠페인 정본·숙련 기록·정본 앵커 상세 데이터 스키마
- 자동·수동 저장과 클라우드 충돌 복구 정책
- 사건별 S 보상 수량·제작 예산·기록 재현 변칙
- 결과·출동 준비·확정 Gate·분기 슬롯·접근성·보상 UX
- 저승역 버티컬 슬라이스 사건 Spec
- 구현 계획·코드·사람 플레이테스트·POC 통과·Production 확대

## 8. 최종 Gate

```text
최종 문서 HEAD 확정
→ path-triggered exact-head CI 성공
→ main 대비 behind 0·14 docs-only 재확인
→ 리뷰·댓글 차단 0 재확인
→ Draft 해제
→ 사용자 별도 병합 승인
→ PR #140 병합
→ 실제 merge SHA 기반 post-merge authority sync
```

현재 내용 감사 판정:

```yaml
content_audit: PASS_AFTER_CORRECTIONS
scope_audit: PASS_DOCS_ONLY
canon_conflict: RESOLVED
sheet_decision_ids: 10_OF_10_MATCHED
implementation_boundary: PRESERVED
post_merge_authority_sync: REQUIRED
separate_merge_authorization: NOT_GRANTED
```

사용자의 명시적인 `병합 승인` 전에는 PR #140을 병합하지 않는다.
