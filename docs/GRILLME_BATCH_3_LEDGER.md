# Grill Me Batch 3 Ledger

> 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 카운터: `5 / 10`
> 상태: `ACTIVE_ACCUMULATION / APPROVED_PENDING_BATCH_MERGE`
> 시작일: 2026-08-03
> 누적 브랜치: `agent/grillme-batch-3-investigation-manual`
> 누적 Draft PR: `#142`
> 구현: `NOT_AUTHORIZED`
> 사람 검증: `NOT_RUN`

Grill Me Batch 3의 제품 Decision 5개가 승인됐다. 최대 배치 크기는 10개이며, 고위험 충돌·세션 종료·정본 영향이 큰 경우·사용자의 명시적 요청에만 조기 체크포인트를 허용한다.

## 운영 계약

```text
현재 정본 확인
→ 핵심 시스템·핵심 재미 적합성 확인
→ 게임·현업·TRPG 사례 벤치마킹
→ 적용점/비적용점 분리
→ 제작비·UX·현지화·QA 비교
→ 적대적 검토
→ 선택지와 권장안
→ 사용자 승인
→ GitHub·Sheet 동일 Decision ID 동기화
```

정본 충돌 교정·오탈자·동기화·같은 질문의 후속 Spec은 새 제품 Decision으로 중복 계산하지 않는다.

## 승인 Decision

### 1 / 10 — `D-2026-08-03-INVESTIGATION-MANUAL-STRUCTURED-KEYWORD-ASSEMBLY`

- 발생 조건·피해자 연결·금지 행동·구출 절차·회수 전투 대응의 5개 의미 슬롯
- 읽을 수 있는 키워드 추론문과 언어 중립 의미 구조 분리
- 자유 메모 비판정, 미획득 키워드 비노출, 출처 보존
- 구출·회수 전투 자동 해결 금지

책임 문서:

- `docs/decisions/D-2026-08-03-INVESTIGATION-MANUAL-STRUCTURED-KEYWORD-ASSEMBLY.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3.md`

### 2 / 10 — `D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK`

- 작성 중 구조 오류만 차단하고 정답·오답 비공개
- 조사 체크포인트에서 정답 위치가 아닌 근거 상태 피드백
- 동일 제출 캐시, 새 증거·실질 의미 변경 때만 재평가
- 최소 실행 가능 매뉴얼이면 위험 감수 후 구출·회수 진입 가능
- 실행 결과는 새 증거가 되지만 매뉴얼 자동 수정 금지
- 지연 검증은 기록 재현 전용 선택 변칙

책임 문서:

- `docs/decisions/D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3.md`

### 3 / 10 — `D-2026-08-03-INVESTIGATION-CASE-AUTHORING-FORMULA-AND-CLUE-PIPELINE`

- 실제 규칙·완성 괴이 매뉴얼에서 조사 장면으로 역설계
- 조사문 2~3장, 장당 3~5개 키워드 슬롯
- 원시 관찰 기록·사건 키워드·추론 키워드 구분
- 직접 물증은 즉시 키워드, 불완전 정보는 비교·모순·논리 연결로 정제
- 정상 키워드에 출처·획득 행동·사용 슬롯·신뢰 상태·대체 경로 보존
- 그럴듯한 오답과 후속 반증 설계
- 기존 `urban-legend-investigation-case-authoring` 스킬 확장

책임 문서와 파일:

- `docs/decisions/D-2026-08-03-INVESTIGATION-CASE-AUTHORING-FORMULA-AND-CLUE-PIPELINE.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3-section-13-case-authoring.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`
- `tests/test_investigation_case_authoring_formula.py`

### 4 / 10 — `D-2026-08-03-INVESTIGATION-MUTATED-KEYWORDS-AND-MANUAL-DRIVEN-EXECUTION`

- 진짜 조사 단서는 같은 실제 규칙을 향해 일관성을 유지
- `[변조]` 후보는 기존 정상 키워드의 횟수·시간·순서·방향·대상·주체·재질·조건 중 변수 하나만 변경
- 변조 후보마다 별도 획득·생성 경로·독립 가짜 장면을 만들지 않음
- 플레이어는 조사 기억·정상 키워드 원본 출처·완성 중인 매뉴얼 문맥으로 올바른 후보를 선택
- 완성된 구출 절차를 피해자 구출 미니게임의 도구·순서·횟수·제한 시간·안전 지점 판단에 사용
- 회수 전투 패턴은 고정 4턴이 아닌 가변 `N ≥ 2`, 전조 횟수는 `N - 1`
- 첫 턴은 `[전조] → 선택 → 평상 진행`
- 중간 턴은 `선택 → [전조] → 평상 진행`
- 마지막 턴은 `대응 선택 → 패턴 발현 → 결과 산출 → 평상 진행`
- 패턴 준비 완료·다음 턴 발현 안내·선공개 금지
- 정확한 대응만 `[파훼]`와 `[취약]`을 만들고 유효 공격·연결 절단·잔향 노출 기회를 제공

책임 문서와 파일:

- `docs/decisions/D-2026-08-03-INVESTIGATION-MUTATED-KEYWORDS-AND-MANUAL-DRIVEN-EXECUTION.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3-section-14-manual-driven-execution.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`
- `tests/test_investigation_case_authoring_formula.py`
- Draft PR `#142`
- Google Sheet 동일 Decision ID

### 5 / 10 — `D-2026-08-04-INVESTIGATION-PAGE-LOCAL-CANDIDATE-POOL-AND-DIFFICULTY-CURVE`

- 후보 목록의 기본 단위를 사건 전체 또는 슬롯 전용이 아닌 `장별 후보 풀`로 확정
- 현재 조사문과 관련되고 이미 획득·해금된 정상·보조·합리적 오답·`[변조]`·명시적 교차 페이지 후보만 표시
- 초반 사건은 3슬롯·5~6개 후보, 표준 사건은 4~5슬롯·7~10개 후보, 핵심 사건은 4~5슬롯·9~12개 후보를 제작 시작점으로 사용
- `[변조]` 시작점은 초반 0~1개, 표준 1~2개, 핵심 2~3개이며 한 장 후보 풀의 다수를 차지하지 않음
- `키워드 이름`·`원본 출처` 검색 허용
- `획득 순서`·`원본 출처`·`가나다순`/locale 정렬 허용
- 정상·변조·정답·오답·정답 적합도·슬롯 호환도·성공 확률·추천 순위 검색/정렬 금지
- `이 슬롯에 들어갈 수 있는 후보만 보기`와 슬롯 선택 시 후보 자동 축소 금지
- 미획득 키워드는 검색·후보 목록·개수로 노출하지 않음
- 난이도는 무관한 카드 수가 아니라 의미가 가까운 후보·교차 페이지 관계·구출/회수 실행 위험으로 상승

책임 문서와 파일:

- `docs/decisions/D-2026-08-04-INVESTIGATION-PAGE-LOCAL-CANDIDATE-POOL-AND-DIFFICULTY-CURVE.md`
- `docs/planning/2026-08-04-investigation-system-design-batch-3-section-15-candidate-pool.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`
- `tests/test_investigation_case_authoring_formula.py`
- Draft PR `#142`
- Google Sheet 동일 Decision ID

## 적대적 검토 — Decision 1

판정: `FIT_WITH_GUARDRAILS`

1. 문장 틀을 최종 판정기로 쓰지 않고 5개 의미 슬롯과 분리한다.
2. 미획득 키워드 비노출·출처 보존·단계 검증으로 브루트포스를 줄인다.
3. 문법이 아니라 언어 중립 의미 구조를 저장한다.
4. 매뉴얼이 구출·전투 행동을 대신하지 않는다.

## 적대적 검토 — Decision 2

판정: `FIT_WITH_GUARDRAILS`

1. 즉시 정오 판정 대신 구조 오류만 차단한다.
2. 체크포인트에서 정답 위치가 아닌 근거 상태를 제공한다.
3. 동일 의미 구조는 캐시 결과를 반환한다.
4. 최소 실행 가능 매뉴얼이면 위험을 감수하고 진행할 수 있다.
5. 지연 검증은 첫 플레이·S 랭크 의무가 아니다.

## 적대적 검토 — Decision 3

판정: `FIT_WITH_GUARDRAILS`

1. 실제 규칙·완성 매뉴얼에서 장면으로 역설계한다.
2. 모든 클릭이 완성 키워드를 지급하지 않게 혼합형 정제를 사용한다.
3. 모든 단서를 두 카드 조합으로 만들지 않는다.
4. 정상 키워드에 구체적 현상·출처·획득 행동을 보존한다.
5. 핵심 단서에 재확인 또는 대체 획득 경로를 둔다.
6. 조사 규칙을 피해자 구출·회수 전투 판단에 사용한다.
7. 기존 등록 스킬을 확장하고 중복 스킬을 만들지 않는다.

## 적대적 검토 — Decision 4

판정: `FIT_WITH_GUARDRAILS`

1. 정상 핵심 단서끼리 진위가 불명확한 경쟁을 만들지 않는다.
2. `[변조]`는 정상 키워드의 변수 하나만 바꿔 원본과 비교 가능하게 한다.
3. 변조마다 독립 가짜 단서와 장면을 만들지 않아 제작량·정보 피로를 억제한다.
4. 변조 수가 과도해 모든 정보를 의심하게 만들지 않는다.
5. 완성 매뉴얼은 구출·회수 행동을 알려 주되 자동 실행하지 않는다.
6. 첫 전조만 선택 전에 표시하고 후속 전조는 선택 뒤 표시한다.
7. 마지막 턴에는 플레이어가 먼저 대응을 선택하고 이후 패턴을 발현한다.
8. 패턴 준비 완료·발현 경고가 매뉴얼 판단을 대체하지 않는다.
9. 패턴은 가변 `N ≥ 2`이며 4턴은 예시일 뿐이다.
10. 정확한 대응만 파훼·취약을 만들며 조기 대응은 비효율적이되 치명적 함정은 아니다.

## 적대적 검토 — Decision 5

판정: `FIT_WITH_GUARDRAILS`

1. 사건 전체 후보 목록은 스크롤·검색 피로가 추론보다 커지므로 기본 표시로 사용하지 않는다.
2. 슬롯 전용 후보 축소는 의미 타입과 정답 Schema를 노출하므로 금지한다.
3. 장별 후보 풀은 작업 기억 범위를 줄이면서 장 전체 문맥 비교를 유지한다.
4. 검색은 이름·원본 출처·획득 맥락만 다루고 정답 적합도를 계산하지 않는다.
5. 정렬은 획득 순서·출처·locale 순으로 제한한다.
6. 미획득 키워드를 검색 결과·후보 수·빈자리로 노출하지 않는다.
7. 난이도 상승을 위해 무관한 쓰레기 카드를 추가하지 않는다.
8. `[변조]` 후보는 한 장 후보 풀의 다수가 되지 않는다.
9. 권장 상한을 넘기면 후보 추가보다 장 분리와 문장 재설계를 우선한다.
10. 검색·정렬 접근성은 같은 후보 정보 해상도를 유지하며 랭크 불이익을 만들지 않는다.

## TDD형 스킬 검증

### Decision 3

```text
RED
commit b6660a348d8be169530b0bb6fec9bcb197a5f259
Documentation run 30819122571 FAILED
원인: workflow 부재·기존 skill 공식 누락
결과: 1 failure / 2 errors

GREEN
head 1b9a030201e293b8024522289a9c22d0763b612b
Documentation 30819350441 SUCCESS
BCA 30819350513 SUCCESS
ANNUAL 30819350438 SUCCESS
```

### Decision 4

```text
RED
commit 04ef12dd8cac3ab21be87d9aa8bd8b29fbf07b05
Documentation run 30824334510 FAILED
결과: 72 tests / 3 failures
원인: Decision 4·Section 14 부재, 변조·구출·가변 전조 계약 누락

회귀 교정
head 7ba59efd1fddb1e9021f481d8f810b899b967f71
Documentation run 30824794701 FAILED
결과: 72 tests / 1 failure
원인: 기존 통합 계약 문구 `구출·회수 전투` 누락
조치: 테스트를 완화하지 않고 워크플로 문구 복원

GREEN
head 57a93ba0fdb18cd72a17ad88cb754702c84d36d8
Documentation 30825394598 SUCCESS
BCA 30825396937 SUCCESS
ANNUAL 30825393212 SUCCESS
```

### Decision 5

```text
RED
commit 811f836baa0681d3678ea09e156dd91a2a699790
Documentation run 30826204248 FAILED
결과: 74 tests / 2 failures
원인: Decision 5·Section 15 부재, 후보 검색·정렬 계약 누락
BCA 30826205974 SUCCESS

MINIMUM GREEN
head 390627f78e2b7e62d81819189f5c211680d6ba39
Documentation 30826692467 SUCCESS

최종 정본·Ledger·PR·Sheet를 포함한 exact-head 전체 검증은 별도로 기록한다.
```

## 현재 PR 체크 범위

이번 누적에는 다음이 포함된다.

- 조사 Design Decision·Sections 11~15
- 사건 제작 워크플로
- 기존 프로젝트 로컬 스킬 확장
- 스킬 계약 회귀 테스트
- Documentation CI 등록

다음은 변경하지 않는다.

- 게임 코드·Scene·사건 데이터·자산
- Investigation Design Spec
- 실제 개별 사건 구현
- 이미지·애니메이션·HX
- Human QA 결과
- POC·Production 상태

배치 완료 전에는 전체 사전 병합 감사 통과나 병합 준비 완료를 선언하지 않는다.

## 다음 Grill Me 질문

질문 6은 **일반 클리어용 최소 실행 가능 매뉴얼과 S 랭크용 정밀 매뉴얼의 데이터 경계**를 결정한다.

확인할 핵심 충돌:

- 캠페인 진행 접근성 대 괴이 규칙 완전 규명 보상
- 최소 실행 가능 규칙 대 위험한 불완전 지식
- S 랭크 정밀 기록 대 필수 반복 조사
- 미확정·위험 사례 보존 대 완성도 판정의 명확성

## 남은 Gate

```text
Batch 3 Decision 6~10 또는 허용된 조기 체크포인트
→ 전체 정본·PR·Sheet 적대적 감사
→ exact-head CI·behind·리뷰·댓글 확인
→ 사용자 별도 병합 승인
→ 실제 merge SHA 기반 current authority·Sheet 동기화
```
