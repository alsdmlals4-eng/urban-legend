# Grill Me Batch 2 Ledger

> 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 카운터: `7 / 10`
> 상태: `OPEN`
> 갱신일: 2026-08-03
> 누적 Draft PR: `#140`

이 문서는 Batch 2 진행 중 새 제품 Decision을 즉시 추적한다. Batch 종료 시 `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`와 현재 권위 문서에 병합 정리한다.

## 카운트 규칙

- 승인된 새 제품 선택 Decision만 1개로 계산한다.
- 같은 질문의 Design·Spec·구현·병합 후속 Gate는 새 질문이 아니면 중복 카운트하지 않는다.
- 정본 충돌 교정·오탈자·동기화 작업은 카운트하지 않는다.
- 10/10에 도달하면 새 질문을 중지하고 적대적 batch audit와 별도 병합 승인을 수행한다.

## Grill Me·작업 운영 계약

향후 Grill Me 질문과 주요 작업 제안은 다음을 기본 구성으로 사용한다.

```text
현재 정본 확인
→ 게임·현업 사례 벤치마킹
→ 적용 가능한 점과 적용하면 안 되는 점 분리
→ 제작비·UX·밸런스·재플레이 관점 비교
→ 적대적 검토
→ 선택지와 권장안
→ 사용자 승인 뒤 정본 동기화
```

이 운영 계약은 제품 선택이 아니므로 별도 카운트하지 않는다.

## 승인 Decision

1. `D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING`
2. `D-2026-08-02-INVESTIGATION-RANK-CONDITION-DISCLOSURE`
3. `D-2026-08-03-INCIDENT-MULTIAXIS-GATED-RANKING`
4. `D-2026-08-03-INCIDENT-RANK-STAGES-AND-LABELS`
5. `D-2026-08-03-INCIDENT-REPLAY-CANON-AND-MASTERY-RECORDS`
6. `D-2026-08-03-INCIDENT-CHECKPOINT-RETRY-AND-CANON-CONFIRMATION`
7. `D-2026-08-03-CAMPAIGN-REWIND-UNLOCK-AND-BRANCH-SLOTS`

## 7 / 10 최신 결정

- 첫 1년차 캠페인 완료 뒤 캠페인 되감기 해금
- S 랭크·특정 엔딩·난이도·유료 상품 요구 금지
- 횟수 제한과 재화 비용 없음
- 최대 3개 캠페인 분기 슬롯 제공
- 최초 완료 캠페인 자동 보호
- 분기별 캠페인 정본 분리, 숙련 기록은 전 분기 공유
- 되감기 전 폐기 범위 표시와 슬롯 덮어쓰기 재확인
- 구현·사람 검증 미승인

책임 원본:

- `docs/decisions/D-2026-08-03-CAMPAIGN-REWIND-UNLOCK-AND-BRANCH-SLOTS.md`
- `docs/planning/2026-08-02-investigation-system-design.md`
- Google Sheet 동일 Decision ID

## 다음 질문

캠페인 정본을 실제로 바꾸는 되감기의 대상 단위를 사건 시작으로 제한할지, 조사·피해자 구출·회수 전투의 주요 결정 지점까지 허용할지 결정한다.
