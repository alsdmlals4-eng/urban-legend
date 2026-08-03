# Grill Me Batch 3 Ledger

> 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 카운터: `3 / 10`
> 상태: `ACTIVE_ACCUMULATION / APPROVED_PENDING_BATCH_MERGE`
> 시작일: 2026-08-03
> 누적 브랜치: `agent/grillme-batch-3-investigation-manual`
> 누적 Draft PR: `#142`
> 구현: `NOT_AUTHORIZED`
> 사람 검증: `NOT_RUN`

Grill Me Batch 3의 제품 Decision 3개가 승인됐다. 최대 배치 크기는 10개이며, 고위험 충돌·세션 종료·정본 영향이 큰 경우·사용자의 명시적 요청에만 조기 체크포인트를 허용한다.

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

- 괴이 매뉴얼을 발생 조건·피해자 연결·금지 행동·구출 절차·회수 전투 대응의 5개 의미 슬롯으로 구성
- 조사 키워드와 공통 관계자로 읽을 수 있는 추론문을 조립
- 문장 표면형과 언어 중립 의미 구조 분리
- 자유 메모 비판정, 미획득 키워드 비노출, 출처 보존
- 구출·회수 전투 자동 해결 금지

책임 문서:

- `docs/decisions/D-2026-08-03-INVESTIGATION-MANUAL-STRUCTURED-KEYWORD-ASSEMBLY.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3.md`
- Draft PR `#142`
- Google Sheet 동일 Decision ID

### 2 / 10 — `D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK`

- 기본 캠페인은 단계형 가설 검증 사용
- 작성 중 구조 오류만 차단하고 정답·오답 비공개
- 조사 체크포인트에서 근거 상태 피드백
- 동일 제출 캐시, 새 증거·실질 의미 변경 때만 재평가
- 구출·회수 전투 전 준비도 경고, 최소 실행 가능 매뉴얼이면 진행 허용
- 실행 결과는 새 증거가 되지만 매뉴얼 자동 수정 금지
- 상세 복기는 사건 결과 보고서에서 제공
- 지연 검증은 기록 재현 전용 선택 변칙으로 격리

책임 문서:

- `docs/decisions/D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3.md`
- Draft PR `#142`
- Google Sheet 동일 Decision ID

### 3 / 10 — `D-2026-08-03-INVESTIGATION-CASE-AUTHORING-FORMULA-AND-CLUE-PIPELINE`

- 사건은 실제 규칙과 완성 괴이 매뉴얼에서 조사 장면으로 역설계
- 조사문은 사건당 2~3장, 장당 3~5개 키워드 슬롯
- 원시 관찰 기록·사건 키워드·추론 키워드의 3계층 구분
- 명확한 물증·증언은 즉시 사건 키워드, 불완전한 정보는 비교·모순·논리 연결로 정제
- 모든 키워드에 출처·획득 행동·선행 조건·의미 주장·사용 슬롯·신뢰 상태·대체 경로 보존
- 일반 명사보다 발견 장면이 기억나는 구체적 키워드 사용
- 3장 표준 사건은 정답 9~12, 보조 4~6, 그럴듯한 오답 3~5, 추론 2~4의 약 18~24개를 제작 시작점으로 사용
- 단간론파의 사용 가능한 단서 명확성과 역전검사의 논리 연결 진행감을 괴이 매뉴얼 구조에 맞게 변환
- 오답은 쓰레기 카드가 아니라 후속 단서로 반증 가능한 합리적 초기 가설
- 조사문이 피해자 구출·회수 전투의 대상·순서·타이밍 판단으로 연결
- 새 스킬을 중복 생성하지 않고 기존 `urban-legend-investigation-case-authoring`을 확장
- 작업구조·스킬·회귀 테스트를 RED→GREEN으로 검증

책임 문서와 파일:

- `docs/decisions/D-2026-08-03-INVESTIGATION-CASE-AUTHORING-FORMULA-AND-CLUE-PIPELINE.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3-section-13-case-authoring.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`
- `tests/test_investigation_case_authoring_formula.py`
- `.github/workflows/validate-base-operating-sync.yml`
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

1. **정답 끼워 맞추기** — 실제 규칙·완성 매뉴얼에서 장면으로 역설계한다.
2. **정답 배급** — 모든 클릭이 완성 키워드를 주지 않게 혼합형 정제 파이프라인을 사용한다.
3. **기계적 카드 결합** — 모든 단서를 두 카드 조합으로 만들지 않는다.
4. **기억되지 않는 단서** — 키워드에 구체적 현상·출처·획득 행동을 보존한다.
5. **쓰레기 오답** — 현재 근거로 합리적이며 후속 단서로 반증 가능한 후보만 사용한다.
6. **단서 누락 진행 차단** — 핵심 단서에 재확인 또는 대체 획득 경로를 둔다.
7. **조사와 실행 분리** — 조사문 규칙을 피해자 구출·회수 전투 판단에 실제 사용한다.
8. **스킬 중복** — 기존 등록 스킬을 확장하고 책임이 겹치는 새 스킬을 생성하지 않는다.
9. **검증 없는 스킬 변경** — 계약 테스트를 먼저 추가해 의도한 RED를 확인한 뒤 GREEN을 검증했다.

## TDD형 스킬 검증

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

위 GREEN은 스킬·워크플로 작성 직후의 증거다. Decision·Ledger·PR·Sheet를 포함한 최종 누적 HEAD는 별도로 재검증한다.

## 현재 PR 체크 범위

이번 누적에는 다음이 포함된다.

- 조사 Design Decision·Section 13 보조 문서
- 사건 제작 워크플로
- 기존 프로젝트 로컬 스킬의 책임 확장
- 스킬 계약 회귀 테스트
- Documentation CI의 신규 계약 테스트 등록

다음은 변경하지 않는다.

- 게임 코드·Scene·사건 데이터·자산
- Investigation Design Spec
- 실제 개별 사건 구현
- 이미지·애니메이션·HX
- Human QA 결과
- POC·Production 상태

배치 완료 전에는 전체 사전 병합 감사 통과나 병합 준비 완료를 선언하지 않는다.

## 다음 Grill Me 질문

질문 4는 상충 증거와 늦은 반증이 기존 `확인 규칙`을 어떻게 변경하고 과거 버전을 어떻게 보존할지 결정한다.

확인할 핵심 충돌:

- 확인 규칙의 신뢰감 대 새로운 증거로 뒤집히는 추리의 역동성
- 즉시 강등의 명확성 대 플레이어가 속았다고 느끼는 문제
- 과거 버전 보존의 복기 가치 대 기록 관리 피로
- 피해가 발생한 오답을 위험 사례로 남기는 방식 대 정답 수정의 편의성

## 남은 Gate

```text
Batch 3 Decision 4~10 또는 허용된 조기 체크포인트
→ 전체 정본·PR·Sheet 적대적 감사
→ exact-head CI·behind·리뷰·댓글 확인
→ 사용자 별도 병합 승인
→ 실제 merge SHA 기반 current authority·Sheet 동기화
```
