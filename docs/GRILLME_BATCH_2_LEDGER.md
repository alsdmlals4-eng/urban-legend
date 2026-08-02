# Grill Me Batch 2 Ledger

> 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 카운터: `3 / 10`
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

## 2 / 10

### `D-2026-08-02-INVESTIGATION-RANK-CONDITION-DISCLOSURE`

- 최고 랭크 요구 능력·태그 이름과 수치는 출동 전에 공개
- 정확한 사용 지점·정답·최적 순서·봉쇄 해법은 숨김
- 현재 준비로 최고 랭크 달성 불가 시 출동 전에 경고
- 조건이 없어도 일반 클리어 진행 가능
- 첫 클리어 후 미달 이유와 상세 숙련 체크리스트 공개
- 첫 플레이에서도 준비 조건을 충족하면 최고 랭크 가능
- 완전히 숨겨진 업적은 최고 랭크 조건에서 제외
- 구현·사람 검증 미승인

책임 원본:

- `docs/decisions/D-2026-08-02-INVESTIGATION-RANK-CONDITION-DISCLOSURE.md`
- `docs/planning/2026-08-02-investigation-system-design.md`
- Google Sheet 동일 Decision ID

## 3 / 10

### `D-2026-08-03-INCIDENT-MULTIAXIS-GATED-RANKING`

- 사건 결과를 조사 정확도·피해자 보호·현장 통제·기록 완성도 네 축으로 평가
- 네 축 위에 관문형 종합 랭크를 제공
- 단순 점수 합산·평균 금지
- 치명적 실패는 다른 축의 고득점으로 상쇄할 수 없음
- 피해자 사망·핵심 규칙 오판·기관 강제 봉쇄 등은 랭크 상한 설정 가능
- 시간은 공통 핵심 평가축에서 제외하고 사건별 숙련 목표로만 제한 사용
- 특수 업적은 종합 랭크와 분리 가능
- 연도 결산은 사건 랭크 평균이 아닌 복합 요원 기록 유지
- 구현·사람 검증 미승인

책임 원본:

- `docs/decisions/D-2026-08-03-INCIDENT-MULTIAXIS-GATED-RANKING.md`
- `docs/planning/2026-08-02-investigation-system-design.md`
- Google Sheet 동일 Decision ID

## 다음 질문

종합 랭크와 축별 평가의 단계 수·명칭을 S/A/B 같은 게임식 등급, 기록국 세계관 용어, 또는 혼합 표시 중 어떤 구조로 사용할 것인가.
