# 괴이기록국 조사 시스템 Design — Grill Me Batch 3 연속 설계

> 상태: `ACTIVE_DESIGN_ACCUMULATION / GRILLME_BATCH_3_6_OF_10`
> 기준 Design: `docs/planning/2026-08-02-investigation-system-design.md`
> 시작일: 2026-08-03
> 누적 Draft PR: `#142`
> 구현: `NOT_AUTHORIZED`
> 사람 검증: `NOT_RUN`

이 문서는 Batch 2에서 병합된 조사 시스템 Design Sections 1~10을 변경하지 않고, Batch 3의 승인 Decision을 Section 11부터 누적·추적하는 상위 색인이다. 세부 규칙은 각 Decision·Section·워크플로·프로젝트 스킬이 소유한다. 10개 승인 또는 허용된 조기 체크포인트에서 전체 정본·PR·Sheet 적대적 감사를 수행한다.

## Batch 3 핵심 설계 흐름

```text
증거·증언 키워드 획득
→ 읽을 수 있는 추론문과 5개 의미 슬롯
→ 단계형 가설 검증
→ 실제 규칙에서 조사 장면으로 역설계
→ 정상 키워드에서 파생한 [변조] 후보
→ 장별 후보 풀에서 문맥 비교
→ 현장 진입 가능
→ 피해자 구출·회수 전투 실행
→ 일반 클리어
→ 추가 조사·반증·기록 정리
→ S 랭크 정밀 매뉴얼
```

## Section 11 — 구조화된 키워드 추론문과 괴이 매뉴얼 의미 슬롯

책임 Decision:

- `D-2026-08-03-INVESTIGATION-MANUAL-STRUCTURED-KEYWORD-ASSEMBLY`

핵심 계약:

- 발생 조건·피해자 연결·금지 행동·구출 절차·회수 전투 대응의 5개 의미 슬롯
- 번호 키워드 기반의 읽을 수 있는 추론문과 언어 중립 의미 구조 분리
- 미획득 키워드 비노출, 출처·근거 보존, 자유 메모 비판정
- 그럴듯한 오답 가설 허용
- 매뉴얼은 구출·회수 판단에 사용하지만 행동을 자동 실행하지 않음

책임 문서:

- `docs/decisions/D-2026-08-03-INVESTIGATION-MANUAL-STRUCTURED-KEYWORD-ASSEMBLY.md`

## Section 12 — 단계형 가설 검증과 피드백 강도

책임 Decision:

- `D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK`

핵심 계약:

```text
작성 중 구조 오류만 차단
→ 조사 체크포인트에서 근거 상태 검증
→ 진입 전 준비도 경고
→ 실행 결과를 새 증거로 기록
→ 사건 보고서에서 상세 복기
```

- 정답 키워드·틀린 슬롯·정답과의 거리 비공개
- 동일 의미 제출 캐시, 새 증거 또는 실질 의미 변경 때만 재평가
- 검증 횟수에 재화·랭크·캠페인 불이익 없음
- 실행 결과는 증거가 되지만 매뉴얼 자동 수정 금지
- 지연 검증은 기록 재현 선택 변칙이며 첫 플레이·S 랭크 의무가 아님

책임 문서:

- `docs/decisions/D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK.md`

## Section 13 — 사건 역설계 공식과 단서·키워드 파이프라인

책임 Decision과 상세 설계:

- `D-2026-08-03-INVESTIGATION-CASE-AUTHORING-FORMULA-AND-CLUE-PIPELINE`
- `docs/planning/2026-08-03-investigation-system-design-batch-3-section-13-case-authoring.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`

핵심 공식:

```text
괴이의 실제 규칙
→ 완성 괴이 매뉴얼
→ 2~3장 조사문
→ 장당 3~5개 정답 슬롯
→ 원시 단서와 획득 장면
→ 그럴듯한 오답과 후속 반증
→ 피해자 구출·회수 전투 검증
→ 공식 규칙·위험 사례·미해결 기록
```

명확한 직접 물증·증언은 즉시 사건 키워드가 될 수 있다. 불완전한 현상·간접 증언·상충 기록은 원시 관찰 기록으로 보존한 뒤 비교·모순·논리 연결을 통해 정제 키워드 또는 추론 키워드로 발전시킨다. 모든 정상 키워드는 출처·획득 행동·사용 슬롯·신뢰 상태·대체 경로를 보존한다.

## Section 14 — 변조 후보와 매뉴얼 기반 구출·회수 실행

책임 Decision과 상세 설계:

- `D-2026-08-03-INVESTIGATION-MUTATED-KEYWORDS-AND-MANUAL-DRIVEN-EXECUTION`
- `docs/planning/2026-08-03-investigation-system-design-batch-3-section-14-manual-driven-execution.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`

핵심 계약:

- `[변조]` 후보는 기존 정상 키워드의 횟수·시간·순서·방향·대상·주체·재질·조건 중 변수 하나만 변경
- 별도 획득·생성 경로와 독립 가짜 장면 금지
- 조사 기억·원본 출처·완성 중인 매뉴얼 문맥으로 판별
- 완성된 구출 절차를 피해자 구출 미니게임에서 직접 사용
- 회수 패턴은 가변 `N ≥ 2`, 전조 횟수는 `N - 1`

```text
첫 턴: [전조] → 선택 → 평상 진행
중간 턴: 선택 → [전조] → 평상 진행
마지막 턴: 대응 선택 → 패턴 발현 → 결과 산출 → 평상 진행
```

패턴 준비 완료·다음 턴 발현·정답 대응 안내를 제공하지 않는다. 정확한 대응만 `[파훼]`와 `[취약]`을 만들고 유효 공격·연결 절단·잔향 노출 기회를 제공한다.

## Section 15 — 장별 후보 풀과 난이도 곡선

책임 Decision과 상세 설계:

- `D-2026-08-04-INVESTIGATION-PAGE-LOCAL-CANDIDATE-POOL-AND-DIFFICULTY-CURVE`
- `docs/planning/2026-08-04-investigation-system-design-batch-3-section-15-candidate-pool.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`

핵심 계약:

| 단계 | 장 슬롯 | 표시 후보 권장 | `[변조]` 시작점 |
|---|---:|---:|---:|
| 초반 사건 | 3개 | 5~6개 | 0~1개 |
| 표준 사건 | 4~5개 | 7~10개 | 1~2개 |
| 핵심 사건 | 4~5개 | 9~12개 | 2~3개 |

- 사건 전체 또는 슬롯 전용이 아닌 현재 조사문 `장별 후보 풀`
- 키워드 이름·원본 출처 검색과 획득 순서·출처·locale 정렬 허용
- 정상/변조·정답/오답·정답 적합도·슬롯 호환도·추천 순위 필터 금지
- `이 슬롯에 들어갈 수 있는 후보만 보기`와 슬롯 선택 시 자동 축소 금지
- 미획득 키워드 비노출·무관한 쓰레기 카드 금지
- 수치는 제작·Human QA 시작점이며 런타임 고정값이 아님

## Section 16 — 현장 진입·일반 클리어·S 랭크 정밀 매뉴얼 경계

책임 Decision과 상세 설계:

- `D-2026-08-04-INVESTIGATION-THREE-TIER-MANUAL-CLEAR-AND-PRECISION-BOUNDARY`
- `docs/planning/2026-08-04-investigation-system-design-batch-3-section-16-manual-clear-boundary.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`

### 16.1 현장 진입 가능

- 금지 행동·구출 절차·회수 전투 대응의 실행 핵심 3슬롯이 최소 `실행 가능 후보`
- 치명적 상충 또는 핵심 행동 공백이 있으면 진입 금지
- 발생 조건·피해자 연결은 근거 부족 상태여도 진입 가능
- 진입은 성공이나 일반 클리어를 보장하지 않음

### 16.2 일반 클리어

- 피해자 구출과 잔향 회수 또는 승인된 동등 종결에 실제 성공
- 실행 핵심 3슬롯이 결과로 지지·확인
- 발생 조건과 피해자 연결은 최소 근거 확보
- 치명적 상충 없음
- 실행 성공만으로 모든 슬롯 자동 확인 금지
- 비치명적 미해결·반증된 가설·위험 사례·선택적 미스터리 보존 가능

### 16.3 S 랭크 정밀 매뉴얼

- 5개 의미 슬롯 모두 확인 규칙
- 슬롯별 원본 출처·근거 연결
- 핵심 오답 가설과 `[변조]` 후보 반증·분류
- 치명적 상충·필수 미해결·핵심 증거 누락 없음
- 예방 가능한 중대한 위험 사례 없음
- 정밀 조건·예외·전조·구출 순서·취약 조건 기록
- 접근성 기능과 검증 요청 횟수는 랭크 감점 금지
- `선택적 미스터리`는 S 랭크를 막지 않음

## GPT·Codex 협업 역할 경계

이 항목은 제품 Decision 개수를 추가하지 않는 운영 규칙이다.

- GPT: 핵심 재미, 콘텐츠 기획, 사건·서사·규칙 설계, 이미지·아트 방향과 생성 기획, 벤치마킹, 적대적 검토, 정본 동기화
- 실제 이미지 생성: Design과 아트 방향 승인 뒤 GPT에서 별도 요청으로 진행
- Codex: 구현 승인 후 코드·Scene·Schema·저장·테스트·게임 통합
- 현재 단계에서 코드 구현·실제 이미지 생성·HX·POC·Production 시작 금지

## Batch 3 적대적 검토 기록 — 6/10

### 확인된 적합성

- 관찰한 증거를 규칙으로 바꾸고 현장에서 시험하는 핵심 재미를 유지한다.
- 즉시 정답 공개와 사건 종료까지 무피드백의 양극단을 피한다.
- 실제 규칙·완성 매뉴얼에서 조사 장면으로 역설계한다.
- 정상 키워드와 `[변조]` 파생 관계로 콘텐츠 제작량을 억제한다.
- 장별 후보 풀로 목록 피로를 제한하되 슬롯 정답을 시스템이 대신 좁히지 않는다.
- 일반 클리어와 S 랭크를 분리해 캠페인 진행과 정밀 추리 숙련을 함께 보존한다.
- 실행 성공만으로 모든 규칙을 확정하지 않아 조사·근거망의 가치를 유지한다.
- 접근성 기능과 검증 요청을 랭크 불이익에서 분리한다.
- 기존 사건 제작 스킬을 확장해 중복 스킬을 만들지 않는다.

### 발견한 위험

1. 현장 진입 가능 상태가 사실상 정답 보증으로 오해될 수 있다.
2. `실행 가능 후보` 임계값이 낮으면 반복 시도가 조사를 대체할 수 있다.
3. 치명적 상충 분류가 작가 재량에만 의존하면 사건 간 공정성이 흔들린다.
4. 한 번의 실행 성공이 과도한 슬롯 자동 승격으로 이어질 수 있다.
5. S 랭크가 모든 텍스트 수집 체크리스트로 비대해질 수 있다.
6. 선택적 미스터리와 필수 미해결의 구분이 불명확하면 랭크 판정이 자의적이다.
7. 후보 수·상태 문구·필터가 정답 근접도를 노출할 수 있다.
8. 복수 회수 패턴과 구출 실패 비용은 아직 미확정이다.
9. 실제 UI·접근성·현지화·좌절도는 Human QA 전 검증되지 않았다.
10. GPT 기획 단계와 Codex 구현 단계가 섞이면 Design 승인 Gate가 무력화될 수 있다.

### 이번 누적에서 적용한 보완

- 구조 오류와 세계 내 오답 분리
- 사용자 요청형 체크포인트 검증과 동일 제출 캐시
- 실제 규칙·완성 매뉴얼에서 조사 장면으로 역설계
- 원시 관찰·사건·추론 키워드의 3계층과 혼합형 정제
- 정상 키워드 출처·획득 행동·사용 슬롯·대체 경로 보존
- `[변조]` 후보는 정상 키워드의 변수 하나만 변경
- 변조 후보의 별도 획득·생성 경로 금지
- 장별 후보 풀·중립 검색/정렬·미획득 비노출
- 현장 진입·일반 클리어·S 랭크의 3단계 분리
- 실행 핵심 3슬롯과 치명적 상충 Gate
- 실행 성공의 전체 슬롯 자동 확인 금지
- 선택적 미스터리와 필수 미해결 분리
- 접근성 기능·검증 요청 횟수 랭크 불이익 금지
- GPT 기획/아트 논의와 Codex 구현 역할 분리
- 기존 프로젝트 스킬 확장과 계약 테스트 RED→GREEN 검증

## 다음 Decision 후보

최우선 질문은 **피해자 구출 미니게임 실패·재시도와 피해자 위험도를 어떻게 연결할 것인가**이다.

그 뒤에 다음을 다룬다.

1. 복수 회수 패턴 중첩과 전조 우선순위
2. 취약 상태의 지속·소비·잔향 노출 규칙
3. 검증 패널의 정보 설계와 Human QA 기준
4. 결과 보고서·재조사·S 랭크 복기 UX

## Gate

```text
Batch 3 제품 Decision 7~10 또는 허용된 조기 체크포인트
→ 전체 적대적 감사·정본 충돌 점검·PR exact-head 검증
→ 사용자 별도 병합 승인
→ main 병합·Sheet 실제 merge SHA 동기화
→ Design 완결 승인
→ Design Spec
→ 이미지·아트 세부 논의와 생성 승인
→ 구현 승인
→ Codex
```

현재는 Design 누적 단계다. Design Spec·이미지 생성·Codex 구현을 시작하지 않는다.
