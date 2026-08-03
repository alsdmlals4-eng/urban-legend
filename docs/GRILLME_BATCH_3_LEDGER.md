# Grill Me Batch 3 Ledger

> 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 카운터: `10 / 10`
> 이전 카운터: `9 / 10`, `8 / 10`
> 현재 식별자: `GRILLME_BATCH_3_10_OF_10`
> 이전 검증 체크포인트: `GRILLME_BATCH_3_9_OF_10`, `GRILLME_BATCH_3_8_OF_10`
> 상태: `BATCH_COMPLETE / PENDING_EXPLICIT_MERGE_APPROVAL`
> 시작일: 2026-08-03
> 완료일: 2026-08-04
> 누적 브랜치: `agent/grillme-batch-3-investigation-manual`
> 누적 Draft PR: `#142`
> 구현: `NOT_AUTHORIZED`
> 사람 검증: `NOT_RUN`

Grill Me Batch 3의 제품 Decision 10개가 모두 승인됐다. 최대 배치 크기에 도달했지만 사용자의 별도 `병합 승인` 전에는 Draft를 해제하거나 병합하지 않는다.

## 운영 계약

```text
현재 정본 확인
→ 핵심 재미·콘텐츠 적합성 검토
→ 벤치마킹·적대적 검토
→ 한 번에 한 개의 고레버리지 질문
→ 사용자 승인
→ Decision·Section·workflow·skill·test 갱신
→ exact HEAD CI 검증
→ PR·Google Sheet 동일 Decision ID 동기화
→ 배치 누적 적대적 검토
→ 별도 병합 승인
```

## 승인 Decision

1. `D-2026-08-03-INVESTIGATION-MANUAL-STRUCTURED-KEYWORD-ASSEMBLY`
   - 5개 의미 슬롯과 읽을 수 있는 구조화 추론문

2. `D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK`
   - 구조·근거·상충·실행 준비도 피드백
   - Decision 8에 의해 세션 중 확인 규칙 표시 제거

3. `D-2026-08-03-INVESTIGATION-CASE-AUTHORING-FORMULA-AND-CLUE-PIPELINE`
   - 실제 규칙에서 조사 경험으로 역설계하는 사건 제작 공식

4. `D-2026-08-03-INVESTIGATION-MUTATED-KEYWORDS-AND-MANUAL-DRIVEN-EXECUTION`
   - 정상 키워드 변수 하나를 바꾸는 `[변조]` 후보
   - 매뉴얼 기반 피해자 구출·가변 회수 전조

5. `D-2026-08-04-INVESTIGATION-PAGE-LOCAL-CANDIDATE-POOL-AND-DIFFICULTY-CURVE`
   - 현재 장의 후보 풀과 비누설 검색·정렬

6. `D-2026-08-04-INVESTIGATION-THREE-TIER-MANUAL-CLEAR-AND-PRECISION-BOUNDARY`
   - 현장 진입 가능·일반 클리어·S 랭크 정밀 기록
   - Decision 7에 의해 현장 진입 Gate 정의 교정

7. `D-2026-08-04-INVESTIGATION-PAGE-COMPLETION-GATE-AND-RESCUE-RISK-RETRY`
   - 빈칸이 많은 괴이 매뉴얼로 시작
   - 조사로 후보·파생 `[변조]` 후보 획득
   - 최종장 완료 시 조사 페이즈 종료
   - 단계형 피해자 위험도와 실질적 변경 재시도

8. `D-2026-08-04-INVESTIGATION-REVISION-EVIDENCE-REUSE-AND-POST-SESSION-TRUTH-REVEAL`
   - 조사 중 이전 페이지 자유 수정
   - 표시 가능한 후보의 임의 배치
   - 비소모 증거 참조와 동일 키워드 재사용
   - 단일 출처·사용 위치 목록 보존
   - 단서 `[기록]` 기반 추론
   - 실행 페이즈 읽기 전용
   - 구출·회수 결과는 관찰 가능한 현상
   - 사건 결과 보고서의 정답 비교

9. `D-2026-08-04-INVESTIGATION-FIRST-RUN-CANON-AND-REPLAY-MASTERY-SEPARATION`
   - 정답 비공개 상태의 `최초 조사 기록`
   - 최초 조사 등급·최초 조사 S 랭크·캠페인 정본 보존
   - 피해자 상태·세력 반응·위험 사례·기본 성장 보상 1회 확정
   - 전체 정답 공개 뒤 `answer_viewed / 비정본 재현`
   - 별도 `재현 숙련 등급`
   - 최초 조사·정본·피해자·세력 결과 덮어쓰기 금지
   - 사건당 1회 선택적 기록·외형 보상과 반복 성장 파밍 금지
   - 정답 보고서 전 체크포인트 재개는 같은 최초 조사 세션
   - 접근성 기능은 최초 조사 자격에 영향 없음

10. `D-2026-08-04-INVESTIGATION-OUTCOME-SCOPED-TRUTH-REVEAL-AND-OPT-IN-FULL-DISCLOSURE`
   - 정상 클리어는 다섯 의미 슬롯 전체 정답 자동 공개
   - 실패·승인 철수는 검증된 슬롯·직접 관찰된 현상·실패 행동·위험 사례만 공개
   - 미검증 슬롯은 숨기고 정답 근접도·교체 답·추천 후보를 제공하지 않음
   - 제한 보고서는 `partial_truth_revealed`이며 answer_viewed 아님
   - 정답 비공개 후속 재조사와 후속 결과 추가 기록
   - 최초 실패·피해자 결과·위험 사례·최초 S 보존
   - `공식 정답 전체 공개`를 명시적 선택하면 사전 경고 뒤 answer_viewed 전환
   - 이후 비정본 재현과 재현 숙련 등급
   - 필수 안전 정보·접근성 등가 선택
   - 정답 공개 자체 보상·유료화·시간 잠금 금지

## Decision 7~10 정합성

```text
빈칸이 많은 매뉴얼
→ 조사와 단서 [기록] 획득
→ 임의 후보 배치
→ 페이지별 키워드 작성
→ 이전 페이지 자유 수정
→ 최종장 모든 빈칸 완료
→ 최종 진입 확인
→ 피해자 구출
→ 회수 전투
→ 현상으로 직접 검증
→ 최초 사건 결과 확정
→ 최초 조사 기록·정본·기본 성장 보상 확정

정상 클리어
→ 전체 정답 자동 공개
→ answer_viewed
→ 비정본 기록 재현
→ 재현 숙련 등급

실패·승인 철수
→ 검증 범위 제한 공개
→ partial_truth_revealed
→ 정답 비공개 후속 재조사
   또는 전체 정답 공개 명시적 선택
→ answer_viewed
→ 비정본 기록 재현
→ 재현 숙련 등급
```

현재 정본:

```text
현장 진입 가능
= 모든 페이지·모든 빈칸 완료
+ 실행 가능한 문장 구조
+ 최종 진입 확인
```

페이지 완료는 잠금이나 정답 확인이 아니다. 제한 보고서는 정답표가 아니라 현장에서 검증한 사실과 위험 원인의 기록이다. 정답 공개 후 재현은 최초 조사 결과를 교정하는 시간 역행이 아니라 별도 숙련 기록이다.

## Decision 10 TDD

RED:

- test commit `1cff4b3d69607cf3dbe0e42d4bc5cfcc1f034072`
- CI wiring commit `5f14c4f8d9c45725cda54e068a737df307748bea`
- Documentation `30860204819`: `FAILED`
- `97 tests / 1 failure / 5 errors`
- Decision 10·Section 20 부재
- 정상 클리어 전체 공개·실패/철수 제한 공개·선택적 전체 공개·후속 재조사·안전/접근성/경제 계약 부재

GREEN exact HEAD와 CI는 PR·Google Sheet exact-head 증거에 기록한다. Ledger 안에 자기 자신의 최종 커밋 SHA를 반복 기입하지 않는다.

## 책임 파일

- `docs/decisions/D-2026-08-04-INVESTIGATION-OUTCOME-SCOPED-TRUTH-REVEAL-AND-OPT-IN-FULL-DISCLOSURE.md`
- `docs/planning/2026-08-04-investigation-system-design-batch-3-section-20-outcome-scoped-truth-reveal.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3.md`
- `docs/GRILLME_BATCH_3_LEDGER.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`
- `tests/test_investigation_outcome_scoped_truth_reveal.py`
- `.github/workflows/validate-base-operating-sync.yml`

## 적대적 누적 감사

- 페이지 완료가 정답 확인이나 페이지 잠금으로 오인되지 않아야 한다.
- 조사 중 이전 페이지를 자유롭게 수정할 수 있어야 한다.
- 표시 가능한 후보를 정답 적합도로 차단하지 않아야 한다.
- 키워드는 소모되지 않고 단일 출처와 여러 사용 위치를 유지해야 한다.
- 단서 [기록]은 관찰 사실을 제공하되 정답 라벨을 숨겨야 한다.
- 세션 중 정답·오답·정답 근접도·성공률을 표시하지 않아야 한다.
- 구출·회수 결과는 현상과 기록이지 자동 정오 판정이 아니어야 한다.
- 실행 페이즈의 매뉴얼은 읽기 전용이어야 한다.
- 사건 결과 확정 뒤 현재 사건의 결과 범위에 맞는 보고서가 열려야 한다.
- 정상 클리어는 현재 사건 전체 답을 공개하되 다음 사건 답은 숨겨야 한다.
- 실패·철수는 실제 검증 범위와 위험 원인을 알려주되 미검증 정답을 자동 공개하지 않아야 한다.
- 제한 보고서의 숨김 표현이 정답을 누설하지 않아야 한다.
- 전체 공개는 명시적·취소 가능한 선택이어야 한다.
- 제한 보고서만 열어도 answer_viewed가 되지 않아야 한다.
- 후속 재조사가 최초 실패·피해자 결과·위험 사례를 삭제하지 않아야 한다.
- 최초 조사 S와 재현 숙련 S를 같은 통계로 합치지 않아야 한다.
- 정답 공개 후 재현이 캠페인 정본·피해자 상태·세력 반응을 덮어쓰지 않아야 한다.
- 재현 보상이 경험치·재화·장비의 반복 파밍을 만들지 않아야 한다.
- 필수 안전 정보와 접근성을 스포일러 명목으로 숨기지 않아야 한다.
- 정답 공개를 보상·유료화·시간 잠금과 연결하지 않아야 한다.
- 외부 공략 열람 여부를 시스템이 판정한다고 주장하지 않아야 한다.

## 역할 경계

- GPT: 핵심 재미, 콘텐츠 기획, 사건·서사·규칙, 이미지·아트 방향과 생성 기획, 적대적 검토, 정본 동기화
- Codex: 별도 구현 승인 후 코드·Scene·Schema·저장·테스트·게임 통합
- 현재 구현·Human QA·Design Spec·이미지 생성·HX·POC·Production은 미승인

## 다음 Gate

Grill Me Batch 3은 `10 / 10`으로 완료됐다.

- exact HEAD CI 검증
- Decision 10 및 Batch 3 전체 누적 적대적 검토
- GitHub·Google Sheet 동일 Decision ID 동기화
- Draft PR #142 유지
- 사용자의 별도 `병합 승인` 전 병합 금지
