# 괴이기록국 · Current Deduction Recovery Work Order

> Status: PLAN_LOCK / VISUAL_DIRECTION_CONTINUATION / IMPLEMENTATION_NOT_AUTHORIZED

## Approved sequence

```text
Investigation Anchor
→ Deduction / Anomaly Manual Anchor
→ Recovery Anchor
→ Shared UI Component
→ Visual asset structure
→ M04 validation
```

## Deduction Anchor

- 조사에서 얻은 raw observation / record / keyword를 별도 괴이 매뉴얼 화면에서 사용한다.
- 키워드 단순 조합 정답이 아니라 출처 확인 → 경쟁 가설 → 지지/반박/미해결 → 규칙 작성 흐름을 유지한다.
- Manual slot:
  1. 발생 조건
  2. 피해자 연결
  3. 금지 행동
  4. 구출 절차
  5. 회수 대응
- 추리는 언제든 현장으로 복귀 가능해야 한다.

## Recovery Anchor

- 회수의 주체는 괴이 현상, 전조, 보호 대상이다.
- 캐릭터는 작은 상태 표현 중심.
- 스킬 사용·중요 지원 순간에만 Cut-in 허용.
- 행동 우선순위:
  - 보호
  - 관찰
  - 대응
  - 공격
  - 장비
  - 봉쇄
  - 후퇴
- 공격 반복으로 해결하는 구조 금지.

## Current work order

1. Deduction Manual Anchor 검토
2. Recovery Anchor 검토
3. M01/M04 공통 적용 검증
4. UI Component 재사용 계약
5. 이미지 승인 및 자산 구조화
6. 구현 전 Planning Canon 재동기화

## Guardrail

- 코드/데이터/Scene/save 변경 없음.
- 제품 asset promotion 없음.
- Human QA PASS 주장 금지.
- 다른 open/draft PR 수정 대상으로 삼지 않음.
