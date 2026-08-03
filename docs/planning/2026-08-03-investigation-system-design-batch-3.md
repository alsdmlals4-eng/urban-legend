# 괴이기록국 조사 시스템 Design — Grill Me Batch 3 연속 설계

> 상태: `ACTIVE_DESIGN_ACCUMULATION / GRILLME_BATCH_3_9_OF_10`
> 이전 검증 체크포인트: `GRILLME_BATCH_3_8_OF_10`
> 기준 Design: `docs/planning/2026-08-02-investigation-system-design.md`
> 시작일: 2026-08-03
> 누적 Draft PR: `#142`
> 구현: `NOT_AUTHORIZED`
> 사람 검증: `NOT_RUN`

Batch 2에서 병합된 조사 시스템 Design Sections 1~10을 변경하지 않고, Batch 3 승인 Decision을 Section 11부터 누적한다. 10개 승인 또는 허용된 조기 체크포인트 전까지 Draft PR을 유지한다.

## 승인 Decision 색인

### Section 11 — 구조화된 키워드 추론문과 괴이 매뉴얼

- Decision: `D-2026-08-03-INVESTIGATION-MANUAL-STRUCTURED-KEYWORD-ASSEMBLY`
- 5개 의미 슬롯
- 읽을 수 있는 구조화 추론문
- 언어 중립 의미 구조와 출처 보존

### Section 12 — 단계 검증과 피드백

- Decision: `D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK`
- 작성 중 저장 불가능한 구조 오류만 차단
- 구조·근거·상충·실행 준비도만 피드백
- Decision 8에 따라 세션 중 `확인 규칙`과 정답 판정 표시 제거

### Section 13 — 사건 제작 공식과 단서 파이프라인

- Decision: `D-2026-08-03-INVESTIGATION-CASE-AUTHORING-FORMULA-AND-CLUE-PIPELINE`
- 실제 규칙·완성 매뉴얼에서 조사 경험으로 역설계
- 2~3장 조사문과 혼합형 단서 정제
- 책임 문서: `docs/planning/2026-08-03-investigation-system-design-batch-3-section-13-case-authoring.md`

### Section 14 — 변조 후보와 매뉴얼 기반 실행

- Decision: `D-2026-08-03-INVESTIGATION-MUTATED-KEYWORDS-AND-MANUAL-DRIVEN-EXECUTION`
- `[변조]`는 정상 키워드의 변수 하나만 변경
- 피해자 구출과 가변 `N ≥ 2` 회수 패턴
- 책임 문서: `docs/planning/2026-08-03-investigation-system-design-batch-3-section-14-manual-driven-execution.md`

### Section 15 — 장별 후보 풀과 난이도 곡선

- Decision: `D-2026-08-04-INVESTIGATION-PAGE-LOCAL-CANDIDATE-POOL-AND-DIFFICULTY-CURVE`
- 사건 전체가 아닌 현재 페이지의 장별 후보 풀
- 검색·정렬은 기억 탐색만 보조
- 책임 문서: `docs/planning/2026-08-04-investigation-system-design-batch-3-section-15-candidate-pool.md`

### Section 16 — 일반 클리어와 S 랭크 정밀 기록

- Decision: `D-2026-08-04-INVESTIGATION-THREE-TIER-MANUAL-CLEAR-AND-PRECISION-BOUNDARY`
- 현장 진입 가능·일반 클리어·S 랭크 정밀 매뉴얼 분리
- Decision 7에 따라 현장 진입 가능은 모든 페이지·모든 빈칸 완료 상태로 교정
- 책임 문서: `docs/planning/2026-08-04-investigation-system-design-batch-3-section-16-manual-clear-boundary.md`

### Section 17 — 페이지 완료 Gate와 피해자 구출 위험도

- Decision: `D-2026-08-04-INVESTIGATION-PAGE-COMPLETION-GATE-AND-RESCUE-RISK-RETRY`
- 빈칸이 많은 괴이 매뉴얼로 시작
- 조사로 후보·파생 `[변조]` 후보 획득
- 1장부터 최종장까지 모든 빈칸을 순서대로 작성
- 최종장 완료 시 조사 페이즈 종료
- 피해자 구출 미니게임 뒤 회수 페이즈로 진행
- `안정 → 불안정 → 위험 → 임계 → 예고된 비가역 결과`
- 동일 의미 반복 캐시와 실질적 변경 재시도
- 책임 문서: `docs/planning/2026-08-04-investigation-system-design-batch-3-section-17-page-gate-and-rescue-risk.md`

### Section 18 — 이전 페이지 수정·증거 재사용·세션 종료 정답 공개

- Decision: `D-2026-08-04-INVESTIGATION-REVISION-EVIDENCE-REUSE-AND-POST-SESSION-TRUTH-REVEAL`
- 조사 중 이전 페이지 자유 수정
- 표시 가능한 후보의 임의 배치 허용
- 키워드는 비소모 증거 참조이며 여러 슬롯·페이지에서 재사용 가능
- 단일 출처와 사용 위치 목록 보존
- 단서 `[기록]`으로 후보를 추론
- 구출·회수 실행 중 매뉴얼 읽기 전용
- 실행 결과는 관찰 가능한 현상이며 자동 정오 판정 금지
- 사건 결과 확정 뒤 세션 종료 보고서에서 슬롯별 정답 공개
- 책임 문서: `docs/planning/2026-08-04-investigation-system-design-batch-3-section-18-revision-and-truth-reveal.md`

### Section 19 — 최초 조사 정본과 기록 재현 숙련 분리

- Decision: `D-2026-08-04-INVESTIGATION-FIRST-RUN-CANON-AND-REPLAY-MASTERY-SEPARATION`
- 정답 비공개 상태의 `최초 조사 기록`이 최초 조사 등급·최초 조사 S 랭크·캠페인 정본을 소유
- 피해자 상태·세력 반응·위험 사례·기본 성장 보상은 최초 사건 결과 확정 시 기록
- 정답 공개 후에는 `answer_viewed / 비정본 재현`
- 별도 `재현 숙련 등급`을 제공하되 최초 조사 S·캠페인 정본·피해자 상태·세력 반응을 덮어쓰지 않음
- 재현 보상은 사건당 1회 선택적 기록·외형 보상이며 반복 성장 파밍 금지
- 정답 보고서가 열리기 전 체크포인트 재개는 같은 최초 조사 세션
- 접근성 기능은 최초 조사 자격과 정답 공개 상태에 영향을 주지 않음
- 책임 문서: `docs/planning/2026-08-04-investigation-system-design-batch-3-section-19-first-run-and-replay-mastery.md`

## Batch 3 현재 핵심 흐름

```text
빈칸이 많은 괴이 매뉴얼 보유
→ 조사로 정상 후보와 단서 [기록] 획득
→ 정상 후보에서 파생된 [변조] 후보 개입
→ 임의 후보 배치
→ 페이지를 순서대로 작성
→ 조사 중 이전 페이지 자유 수정
→ 최종장 모든 빈칸 완료
→ 최종 진입 확인
→ 조사 페이즈 종료
→ 피해자 구출 미니게임
→ 회수 페이즈의 턴제 전투
→ 구출·회수 결과를 현상으로 관찰
→ 필요 시 위험 이력을 유지하고 조사로 후퇴
→ 최초 사건 결과 확정
→ 최초 조사 기록·캠페인 정본·기본 성장 보상 확정
→ 세션 종료 후 슬롯별 정답 비교
→ answer_viewed
→ 정답 공개 후 기록 재현
→ 비정본 재현과 재현 숙련 등급
```

`모든 빈칸 완료`는 구조적 실행 Gate이며 모든 후보가 옳거나 확인됐다는 뜻은 아니다. 세션 중에는 어떤 키워드도 정답·오답으로 표시하지 않는다.

## Decision 간 정합성

- Decision 1의 5개 의미 슬롯을 Decision 3 사건 제작 공식이 역설계한다.
- Decision 4의 `[변조]`와 구출·회수 실행을 Decision 5의 장별 후보 풀이 노출한다.
- Decision 6의 판정 경계는 Decision 7의 페이지 완료 Gate에 맞춰 교정됐다.
- Decision 8은 Decision 2의 세션 중 `확인 규칙` 표시를 폐기하고 정답 공개를 사건 결과 보고서로 이동한다.
- Decision 9는 Decision 8의 정답 공개 이후 상태를 `answer_viewed / replay_mastery`로 분리한다.
- 빈칸이 남은 매뉴얼로 구출에 진입할 수 없다.
- 잘못된 후보를 채운 구조적 완성은 가능하며 구출·회수 결과가 관찰 증거가 된다.
- 페이지 완료는 잠금이 아니며 조사 종료 전 이전 페이지를 수정할 수 있다.
- 키워드는 소모되지 않으며 단일 출처에서 여러 사용 위치로 참조된다.
- 구출 실패는 즉사보다 단계형 위험과 관찰 증거를 제공한다.
- 일시정지·저장·메뉴 이탈은 세션 종료나 정답 보고서 해금이 아니다.
- 정답 공개 뒤 재현은 최초 조사 S 랭크·캠페인 정본·피해자 상태·세력 반응을 덮어쓰지 않는다.
- 재현 숙련은 선택적 성취이며 성장 경제와 캠페인 진행의 필수 Gate가 아니다.

## GPT·Codex 역할

- GPT: 핵심 재미, 콘텐츠 기획, 사건·서사·규칙, 이미지·아트 방향, 적대적 검토와 정본 동기화
- Codex: 별도 구현 승인 후 코드·Scene·Schema·저장·테스트·게임 통합
- 현재 이미지 생성·HX·POC·Production은 시작하지 않는다.

## 현재 Gate

- Grill Me Batch 3: `9 / 10`
- Draft PR #142 유지
- 구현·Human QA·Design Spec·이미지·Codex 미승인
- 다음 질문은 실패·철수 종결에서 공개할 정답 범위와 마지막 Batch 3 Decision
