# Grill Me Batch 3 Ledger

> 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 카운터: `7 / 10`
> 상태: `ACTIVE_ACCUMULATION / APPROVED_PENDING_BATCH_MERGE`
> 시작일: 2026-08-03
> 누적 브랜치: `agent/grillme-batch-3-investigation-manual`
> 누적 Draft PR: `#142`
> 구현: `NOT_AUTHORIZED`
> 사람 검증: `NOT_RUN`

Grill Me Batch 3의 제품 Decision 7개가 승인됐다. 최대 배치 크기는 10개이며 사용자의 별도 병합 승인 전에는 Draft를 해제하거나 병합하지 않는다.

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
→ 다음 질문
```

## 승인 Decision

1. `D-2026-08-03-INVESTIGATION-MANUAL-STRUCTURED-KEYWORD-ASSEMBLY`
   - 5개 의미 슬롯과 읽을 수 있는 구조화 추론문

2. `D-2026-08-03-INVESTIGATION-HYPOTHESIS-STAGED-VALIDATION-AND-FEEDBACK`
   - 단계 검증·정보 비누설 피드백·실행 결과 증거화

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
   - 1장부터 최종장까지 모든 빈칸을 순서대로 채움
   - 최종장 완료 시 조사 페이즈 종료
   - 피해자 구출 미니게임 → 회수 페이즈
   - 단계형 피해자 위험도와 실질적 변경 재시도
   - 숨은 확률·즉사·무비용 전수 대입 금지

## Decision 7 정합성 교정

Decision 6의 기존 `일부 실행 핵심 슬롯만 채우면 현장 진입 가능` 해석은 폐기한다.

현재 정본:

```text
현장 진입 가능
= 모든 페이지·모든 빈칸 완료
+ 실행 가능한 문장 구조
+ 이미 판명된 치명적 상충 없음
```

근거 확실성, 후보 진실성, `[변조]` 판별은 불완전할 수 있다. 페이지에 빈칸을 남길 수는 없다.

## 핵심 게임 흐름

```text
빈칸이 많은 매뉴얼
→ 조사와 후보 획득
→ 페이지별 키워드 배치
→ 최종장 완료
→ 조사 페이즈 종료
→ 피해자 구출
→ 회수 전투
→ 일반 클리어
→ 기록 복기·S 랭크 정밀화
```

## Decision 7 TDD

RED:

- commit `0686f56691604e5b6f2b0d626db27185f46a4e6f`
- Documentation `30855089136`: `FAILED`
- `79 tests / 3 failures`
- Decision 7·Section 17 부재
- 페이지 완료 Gate·구출 위험도·재시도 계약 부재
- BCA `30855089129`: `SUCCESS`

GREEN 증거는 final exact HEAD 검증 후 이 문서와 PR에 기록한다.

## 책임 파일

- `docs/decisions/D-2026-08-04-INVESTIGATION-PAGE-COMPLETION-GATE-AND-RESCUE-RISK-RETRY.md`
- `docs/decisions/D-2026-08-04-INVESTIGATION-THREE-TIER-MANUAL-CLEAR-AND-PRECISION-BOUNDARY.md`
- `docs/planning/2026-08-04-investigation-system-design-batch-3-section-17-page-gate-and-rescue-risk.md`
- `docs/planning/2026-08-03-investigation-system-design-batch-3.md`
- `docs/workflows/INVESTIGATION_CASE_AUTHORING_WORKFLOW.md`
- `skills/urban-legend-investigation-case-authoring/SKILL.md`
- `tests/test_investigation_case_authoring_formula.py`

## 적대적 누적 감사

- 매뉴얼 빈칸이 남은 채 피해자 구출로 넘어갈 수 없어야 한다.
- 페이지 완료는 정답 확인과 분리돼야 한다.
- 잘못 판별한 `[변조]` 후보를 넣은 구조적 완성은 가능해야 한다.
- 첫 구출 실패는 즉시 피해자 상실이나 전체 재시작이 아니어야 한다.
- 실패는 관찰 증거를 주되 정답을 직접 공개하지 않아야 한다.
- 동일 의미 상태를 반복해 모든 선택지를 전수 대입할 수 없어야 한다.
- 임계 결과는 숨은 확률이 아니라 명확히 예고돼야 한다.
- 매뉴얼 열람·접근성 기능은 위험도를 높이지 않아야 한다.
- 조사 후퇴는 위험도·위험 사례를 삭제하는 리셋이 아니어야 한다.
- 구출 성공 뒤 같은 매뉴얼이 회수 전투 판단에 이어져야 한다.

## 역할 경계

- GPT: 핵심 재미, 콘텐츠 기획, 사건·서사·규칙, 이미지·아트 방향과 생성 기획, 적대적 검토, 정본 동기화
- Codex: 별도 구현 승인 후 코드·Scene·Schema·저장·테스트·게임 통합
- 현재 구현·Human QA·Design Spec·이미지 생성·HX·POC·Production은 미승인

## 다음 Gate

Grill Me Batch 3 질문 8/10:

`페이지를 완료한 뒤 이전 페이지를 자유롭게 수정할 수 있는가, 그리고 동일 키워드를 여러 슬롯·페이지에서 재사용할 수 있는가?`
