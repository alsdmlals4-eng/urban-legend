# Grill Me Batch 3 Ledger

> 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 카운터: `6 / 10`
> 상태: `ACTIVE_ACCUMULATION / APPROVED_PENDING_BATCH_MERGE`
> 시작일: 2026-08-03
> 누적 브랜치: `agent/grillme-batch-3-investigation-manual`
> 누적 Draft PR: `#142`
> 구현: `NOT_AUTHORIZED`
> 사람 검증: `NOT_RUN`

Grill Me Batch 3의 제품 Decision 6개가 승인됐다. 최대 배치 크기는 10개이며, 고위험 충돌·세션 종료·정본 영향이 큰 경우·사용자의 명시적 요청에만 조기 체크포인트를 허용한다.

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

### 2 / 10 — `D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK`

- 작성 중 구조 오류만 차단하고 정답·오답 비공개
- 조사 체크포인트에서 정답 위치가 아닌 근거 상태 피드백
- 동일 제출 캐시, 새 증거·실질 의미 변경 때만 재평가
- 최소 실행 가능 매뉴얼이면 위험 감수 후 구출·회수 진입 가능
- 실행 결과는 새 증거가 되지만 매뉴얼 자동 수정 금지
- 지연 검증은 기록 재현 전용 선택 변칙

책임 문서:

- `docs/decisions/D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK.md`

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

- `[변조]` 후보는 기존 정상 키워드의 변수 하나만 변경
- 변조 후보마다 별도 획득·생성 경로·독립 가짜 장면을 만들지 않음
- 조사 기억·원본 출처·완성 중인 매뉴얼 문맥으로 판별
- 완성된 구출 절차를 피해자 구출 미니게임에서 사용
- 회수 전투는 가변 `N ≥ 2`, 전조 횟수 `N - 1`
- 첫 턴 전조 선표시·중간 턴 선택 후 전조·마지막 턴 선대응
- 정확한 대응만 `[파훼]`와 `[취약]` 발생

책임 문서와 파일:

- `docs/decisions/D-2026-08-03-INVESTIGATION-MUTATED-KEYWORDS-AND-MANUAL-DRIVEN-EXECUTION.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3-section-14-manual-driven-execution.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`

### 5 / 10 — `D-2026-08-04-INVESTIGATION-PAGE-LOCAL-CANDIDATE-POOL-AND-DIFFICULTY-CURVE`

- 현재 조사문 한 장의 `장별 후보 풀`
- 초반 5~6개·표준 7~10개·핵심 9~12개 후보를 제작/Human QA 시작점으로 사용
- `[변조]` 시작점 0~1 / 1~2 / 2~3개, 한 장의 다수 금지
- 키워드 이름·원본 출처 검색, 획득 순서·출처·locale 정렬만 허용
- 정상/변조·정답/오답·정답 적합도·슬롯 호환도 필터 금지
- 슬롯 선택 시 후보 자동 축소 금지
- 미획득 키워드 비노출·무관한 쓰레기 카드 금지

책임 문서와 파일:

- `docs/decisions/D-2026-08-04-INVESTIGATION-PAGE-LOCAL-CANDIDATE-POOL-AND-DIFFICULTY-CURVE.md`
- `docs/planning/2026-08-04-investigation-system-design-batch-3-section-15-candidate-pool.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`

### 6 / 10 — `D-2026-08-04-INVESTIGATION-THREE-TIER-MANUAL-CLEAR-AND-PRECISION-BOUNDARY`

- `현장 진입 가능 → 일반 클리어 → S 랭크 정밀 매뉴얼`의 3단계 판정
- 현장 진입에는 금지 행동·구출 절차·회수 전투 대응의 실행 핵심 3슬롯과 치명적 상충 부재 필요
- 일반 클리어에는 실제 피해자 구출·잔향 회수 성공, 실행 핵심 3슬롯 결과 지지, 발생 조건·피해자 연결 최소 근거 필요
- 실행 성공만으로 모든 슬롯 자동 확인 금지
- S 랭크는 5슬롯 확인·출처/근거·가설 반증·변조 분류·필수 미해결 해소를 요구
- 선택적 미스터리·접근성 기능·검증 요청 횟수는 S 랭크를 막거나 감점하지 않음
- 일반 클리어 뒤 추가 조사·기록 보완 허용

책임 문서와 파일:

- `docs/decisions/D-2026-08-04-INVESTIGATION-THREE-TIER-MANUAL-CLEAR-AND-PRECISION-BOUNDARY.md`
- `docs/planning/2026-08-04-investigation-system-design-batch-3-section-16-manual-clear-boundary.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`
- `tests/test_investigation_case_authoring_formula.py`
- Draft PR `#142`
- Google Sheet 동일 Decision ID

## GPT·Codex 역할 경계

이 항목은 제품 Decision 수에 추가하지 않는 운영 계약이다.

- GPT: 핵심 재미, 콘텐츠 기획, 사건·서사·규칙 설계, 이미지·아트 방향과 생성 기획, 적대적 검토, 정본 동기화
- 실제 이미지 생성: Design과 아트 방향 승인 뒤 GPT에서 별도 진행
- Codex: 구현 승인 후 코드·Scene·Schema·저장·테스트·게임 통합
- GPT 단계에서 구현 완료·POC 완료·Production 진입 선언 금지

## 적대적 검토 — Decision 6

판정: `FIT_WITH_GUARDRAILS`

1. 모든 슬롯 완전 확인을 일반 클리어에 강제하지 않는다.
2. 실행 성공만으로 조사 없이 일반 클리어하지 못하도록 최소 근거를 요구한다.
3. 한 번의 성공으로 발생 원인·피해자 연결·예외 전체를 자동 확인하지 않는다.
4. 치명적 상충 또는 실행 핵심 공백 상태로 현장 진입을 허용하지 않는다.
5. 일반 클리어 뒤 재조사·반증·기록 보완을 허용한다.
6. S 랭크는 핵심 규칙·근거망·반증을 평가하며 모든 텍스트 수집을 요구하지 않는다.
7. 선택적 미스터리와 필수 미해결을 구분한다.
8. 접근성 기능과 검증 요청 횟수를 랭크 감점으로 사용하지 않는다.
9. GPT 기획/아트 논의와 Codex 구현 Gate를 분리한다.
10. 상세 Schema·랭크 산식·UI·Human QA는 아직 미확정이다.

## TDD형 스킬 검증

### Decision 3

```text
RED
commit b6660a348d8be169530b0bb6fec9bcb197a5f259
Documentation 30819122571 FAILED
원인: workflow 부재·기존 skill 공식 누락

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
Documentation 30824334510 FAILED
결과: 72 tests / 3 failures

GREEN
exact head 57a93ba0fdb18cd72a17ad88cb754702c84d36d8
Documentation 30825394598 SUCCESS
BCA 30825396937 SUCCESS
ANNUAL 30825393212 SUCCESS
```

### Decision 5

```text
RED
commit 811f836baa0681d3678ea09e156dd91a2a699790
Documentation 30826204248 FAILED
결과: 74 tests / 2 failures

GREEN
exact head 34cb29fe3b6152f4901e68cfad0062b1a6fec973
Documentation 30827164420 SUCCESS
BCA 30827165358 SUCCESS
ANNUAL 30827170050 SUCCESS
```

### Decision 6

```text
RED
commit b3a920dfdaa759b8a77f71492c66dfc21bf366b6
Documentation 30828000110 FAILED
결과: 76 tests / 2 failures
원인: Decision 6·Section 16 부재, 3단계 매뉴얼 경계와 GPT/Codex 역할 분리 누락
BCA 30828000106 SUCCESS

GREEN
validated head e09085a9378ea554f4e5532e31985345593afd2c
Documentation 30828773459 SUCCESS
BCA 30828774380 SUCCESS
ANNUAL/Godot regression 30828773462 SUCCESS
```

## 현재 PR 체크 범위

이번 누적에는 다음이 포함된다.

- 조사 Design Decision·Sections 11~16
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

질문 7은 **피해자 구출 미니게임 실패·재시도와 피해자 위험도를 어떻게 연결할지** 결정한다.

확인할 핵심 충돌:

- 실패의 긴장과 결과 대 영구 손실·재시작 강요
- 잘못된 매뉴얼의 책임 대 시행착오 학습
- 재시도 허용 대 반복 대입 악용
- 피해자 보호 정체성 대 플레이어 좌절

## 남은 Gate

```text
Batch 3 Decision 7~10 또는 허용된 조기 체크포인트
→ 전체 정본·PR·Sheet 적대적 감사
→ exact-head CI·behind·리뷰·댓글 확인
→ 사용자 별도 병합 승인
→ 실제 merge SHA 기반 current authority·Sheet 동기화
```
