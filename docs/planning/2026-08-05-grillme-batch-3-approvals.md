# GrillMe Batch 3 승인 원장

> 상태: `OPEN / 3_OF_10 / EARLY_CANON_CHECKPOINT`
> 배치 병합: `BATCH_MERGE_NOT_STARTED`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 병합 권한: `MERGE_NOT_AUTHORIZED`
> 기반 Draft PR: PR #149
> 현재 Draft PR: #151

이 문서는 GrillMe Batch 3의 실제 사용자 승인만 카운트한다. 철회·오해·비승인 기록은 역사로 남기되 승인 수에 포함하지 않는다.

## 승인 현황

| 순번 | Decision ID | 주제 | 사용자 응답 | 상태 | 정본·시트 |
|---:|---|---|---|---|---|
| 1 | `DEC-20260805-115-CANON-V2-RULE-STRIP-CONTINUITY` | 조사·구출·회수 전 단계의 괴이 매뉴얼 표시 방식 | `권장안대로 진행` | `APPROVED` | GitHub·Google Sheet 동기화 완료 |
| 2 | `DEC-20260805-116-CANON-V2-RESCUE-RETRIEVAL-ROLE-BOUNDARY` | 피해자 구출과 회수 전투의 역할 경계 | `권장안대로 진행` | `APPROVED` | GitHub·Google Sheet 동기화 완료 |
| 3 | `DEC-20260805-117-CANON-V2-RESCUE-MINIGAME-AND-RETRIEVAL-RULE-COVERAGE` | 공통 구출 문법·사건별 변주·회수 규칙 범위 | `권장안대로 진행` | `APPROVED` | GitHub·Google Sheet 동기화 완료 |
| 철회 | `DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE` | 예시를 고정 4턴 규칙으로 잘못 승격 | 사용자 정정: `4턴 확정이 아님` | `RETRACTED / NON_COUNTING` | 활성 정본·Sheet 결정에서 제거 |
| 4–10 | — | 후속 GrillMe | — | `NOT_ASKED` | 미반영 |

## 1번 승인 — 규칙 정보 연속성

- 조사·보고는 전체 괴이 매뉴얼 작업공간을 사용한다.
- 구출·회수는 같은 권위 상태에서 파생된 현행 규칙 스트립을 사용한다.
- 정답 자동 공개는 금지하며 전체 매뉴얼은 비용 없이 재열람한다.

## 2번 승인 — 같은 규칙, 다른 책임

- 구출은 피해자 분리·보호·생존·후유증을 담당한다.
- 회수는 현상 통제·안정화·봉쇄·잔향 회수·승인 철수를 담당한다.
- 구출 결과는 회수 초기 조건과 보호 의무에 영향을 주되 승패를 대신하지 않는다.

## 3번 승인 — 공통 구출 문법과 회수 범위

- 공통 4단계는 구출 미니게임에만 적용한다.
- 회수 행동 범위는 보호·관찰·대응·공격·장비·봉쇄·후퇴다.
- `core_recovered` 단일 결과는 구형 호환 상태이며 최종 제품 계약이 아니다.
- 정확한 회수 턴 수·패턴 개수·행동 비용은 승인되지 않았다.

## 철회 기록 — Decision 118

4턴은 예시일 뿐 전역 규칙이 아니다. 실제 회수는 **패턴별 전조·판단 단위**다.

```text
괴이가 가진 패턴 집합
→ 완성된 패턴 하나 선택
→ 단일 전조 공개
→ 가설·근거·대응
→ 즉시 정오 판정
→ 안정도 또는 피해
→ 기록
→ 다음 패턴 또는 종결
```

사건과 괴이가 저작한 패턴 수에 따라 회수 길이가 달라진다. 고정 4턴·전조 세 개 누적·4턴 전용 대응은 활성 권위가 아니다.

상세 재감사:
`docs/audits/2026-08-06-recovery-pattern-authority-project-wide-reaudit.md`

## 배치 운영 경계

- 현재 카운터: `3_OF_10`.
- Decision 118은 `RETRACTED / NON_COUNTING`이다.
- 현재 PR은 조기 기획 체크포인트일 뿐 배치 병합 완료가 아니다.
- PR #149의 실제 저장·UI·접근성 QA 상태는 변경하지 않는다.
- PR #151의 제품 구현과 병합은 승인하지 않는다.

## 다음 질문 후보

다음 GrillMe는 회수 페이즈의 패턴 선택·전조·판단 구조를 실제 프로젝트 기준으로 다시 확인한 뒤, 괴이별 패턴 풀이 언제·어떻게 선택되고 반복되는지를 다룬다.
