# 괴이기록국 · Current Deduction Recovery Work Order

> Status: PLAN_LOCK / INTEGRATED_CANON / IMPLEMENTATION_NOT_AUTHORIZED
> Source PR: #211
> Parent canon: `docs/CURRENT_PLANNING_CANON.md`

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

1. M01 Investigation/Deduction/Rescue Packet을 저승역 Canon v2와 대조
2. M01/M04 공통 적용과 서로 다른 검증 역할 확인
3. UI Component 재사용 계약과 Visual Anchor 연결
4. 사용자 보유 시각 시안 검토
5. 승인/보류된 레이어·자산 범위 구조화
6. 사용자 전체 `기획 완료` 선언 뒤 fresh main 재감사
7. 별도 구현 계약과 TDD/HiGodot Gate

## Guardrail

- 코드/데이터/Scene/save 변경 없음.
- 제품 asset promotion 없음.
- 사용자 보유 시안 검토 전 이미지 생성 없음.
- Human QA PASS 주장 금지.
- 이 문서의 통합은 다른 PR의 고유 내용을 누락하거나 구현 승인으로 전환하지 않는다.
