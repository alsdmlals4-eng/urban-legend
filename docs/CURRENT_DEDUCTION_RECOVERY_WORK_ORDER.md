# 괴이기록국 · Current Deduction Recovery Work Order

> Status: `PLANNING_COMPLETE / IMPLEMENTATION_HANDOFF_READY / IMPLEMENTATION_NOT_AUTHORIZED`
> Source PR: #211
> Parent canon: `docs/CURRENT_PLANNING_CANON.md`
> Current implementation design: `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`

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
- 출처 확인 → 경쟁 가설 → 지지/반박/미해결 → 규칙 작성 흐름을 유지한다.
- Manual slot: 발생 조건 / 피해자 연결 / 금지 행동 / 구출 절차 / 회수 대응.
- 추리는 언제든 현장으로 복귀 가능해야 한다.

## Rescue Anchor

- 구출은 추리에서 정리한 규칙을 피해자 분리·보호 행동으로 적용하는 Phase다.
- 별도 정답 퍼즐을 추가하지 않는다.
- 추론 부족과 입력/적용 실패의 이유를 구분한다.
- 구출 결과는 회수 결과와 별도 snapshot으로 보존한다.

## Recovery Anchor

- 회수의 주체는 괴이 현상, 전조, 보호 대상이다.
- 캐릭터는 작은 상태 표현 중심, 중요 지원 순간만 Cut-in.
- 행동: 보호 / 관찰 / 대응 / 공격 / 장비 / 봉쇄 / 후퇴.
- 공격 반복으로 해결하는 구조 금지.
- M01 상세 전조·대응은 `docs/M01_RECOVERY_SCENE_PACKET.md`가 소유한다.
- `SERIAL_EXAM_FATIGUE_GUARD`: 새 정답 체계가 아니라 이미 학습한 규칙의 실행 형태로 이어진다.

## Composite Result

- 피해자 상태
- 확인 규칙 / 증거 무결성
- 위험 사례 / 보호 책임
- 회수·안정화 상태
- 잔향 / 미회수
- 미해결 질문 / 후속 실행

단일 S/A/B/S-rank가 이 축을 덮어쓰지 않는다.

## Current work order

1. M01 Investigation/Deduction/Rescue/Recovery planning — COMPLETE.
2. M01/M04 역할·화면 문법 — COMPLETE.
3. Visual planning — COMPLETE.
4. 사용자 최종 `기획완료` — APPROVED.
5. fresh-main Reality Gate — `HANDOFF_READY_WITH_KNOWN_REALIGNMENT`.
6. existing Canon v2 runtime — REUSE.
7. `COMPOSITE_RESULT` semantic realignment.
8. additive `monthly_state`.
9. M01 First Session orchestration.
10. #181 existing plan reuse for main menu / Ver 4.3.
11. M04 shared-system preparation.
12. concrete product-reference image/asset — `PRODUCT_REFERENCE_ASSET_PENDING`.
13. runtime/Human QA.

Current execution plan: `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`.

## Guardrail

- 이 문서 작업 자체에서는 코드/데이터/Scene/save 변경 없음.
- `runtime_implementation: NOT_AUTHORIZED` 전에는 product mutation 금지.
- product asset promotion 없음.
- `PRODUCT_REFERENCE_ASSET_PENDING`을 planning 미완료와 혼동하지 않는다.
- Human QA PASS 주장 금지.
- 이미지/asset 승인과 runtime 구현 승인을 같은 Gate로 합치지 않는다.
- 진행 중 unrelated PR은 read-only로 유지한다.
