# 괴이기록국 · Current Deduction Recovery Work Order

> Status: `PLAN_LOCK / PLANNING_CLOSURE_READY / IMPLEMENTATION_NOT_AUTHORIZED`
> Source PR: #211
> Parent canon: `docs/CURRENT_PLANNING_CANON.md`
> Closure owner: `docs/planning/2026-08-21-visual-ui-planning-closure.md`

## Approved sequence

```text
Investigation Anchor
→ Deduction / Anomaly Manual Anchor
→ Victim Rescue Anchor
→ Recovery Anchor
→ Composite Result
→ Shared UI Component
→ Product-reference asset gate
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

## Rescue Anchor

- 구출은 추리에서 정리한 규칙을 피해자 분리·보호 행동으로 적용하는 Phase다.
- 별도 정답 퍼즐을 추가하지 않는다.
- 추론 부족과 입력/적용 실패의 이유를 구분한다.
- 구출 결과는 회수 결과와 별도 snapshot으로 보존한다.

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
- M01 상세 전조·대응은 `docs/M01_RECOVERY_SCENE_PACKET.md`가 소유한다.

## Composite Result

- 피해자 상태
- 확인 규칙
- 위험 사례
- 회수/안정화 상태
- 잔향/미회수
- 미해결 질문

단일 S/A/B 등급 하나가 이 축을 덮어쓰지 않는다.

## Current work order

1. M01 Investigation/Deduction/Rescue/Recovery packet과 저승역 Canon v2 정합 완료
2. M01/M04 공통 화면 문법과 서로 다른 검증 역할 확인 완료
3. UI Component 재사용 계약과 Visual Anchor 연결 완료
4. Visual planning `CLOSURE_READY`
5. concrete product-reference image/asset은 `PRODUCT_REFERENCE_ASSET_PENDING`
6. 사용자 최종 `기획 완료` 선언
7. fresh-main Reality Gate
8. ID/save migration matrix + 단일 구현 계약
9. 별도 Codex/HiGodot 구현
10. runtime/Human QA

## Guardrail

- 코드/데이터/Scene/save 변경 없음.
- 제품 asset promotion 없음.
- `PRODUCT_REFERENCE_ASSET_PENDING`을 전체 기획 OPEN의 동의어로 사용하지 않는다.
- Human QA PASS 주장 금지.
- 이미지/asset 승인과 runtime 구현 승인을 같은 Gate로 합치지 않는다.
- 진행 중인 다른 PR을 후속 수정 대상으로 삼지 않는다.
