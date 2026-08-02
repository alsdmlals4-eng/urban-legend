# Grill Me Batch 2 Ledger

> 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 카운터: `1 / 10`
> 상태: `OPEN`
> 갱신일: 2026-08-02
> 누적 Draft PR: `PENDING`

이 문서는 Batch 2 진행 중 새 제품 Decision을 즉시 추적한다. Batch 종료 시 `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`와 현재 권위 문서에 병합 정리한다.

## 카운트 규칙

- 승인된 새 제품 선택 Decision만 1개로 계산한다.
- 같은 질문의 Design·Spec·구현·병합 후속 Gate는 새 질문이 아니면 중복 카운트하지 않는다.
- 정본 충돌 교정·오탈자·동기화 작업은 카운트하지 않는다.
- 10/10에 도달하면 새 질문을 중지하고 적대적 batch audit와 별도 병합 승인을 수행한다.

## 1 / 10

### `D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING`

- 일반 클리어 필수 키워드는 비판정 또는 확정 우회 경로로 확보 가능
- 능력·태그·판정은 비용·깊이·위험·구출·전투 정보 우위를 변화
- 최고 랭크·업적은 요구 능력·태그 보유 또는 지정 판정 성공을 요구할 수 있음
- 최고 랭크 미달이어도 일반 클리어·다음 분기·핵심 서사 진행 가능
- 업적·완전 달성 플레이어만 준비를 바꿔 재도전하도록 설계
- 구현·사람 검증 미승인

책임 원본:

- `docs/decisions/D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING.md`
- `docs/planning/2026-08-02-investigation-system-design.md`
- Google Sheet 동일 Decision ID

## 다음 질문

최고 랭크에 필요한 능력·태그 조건의 공개 시점과 정보량.
