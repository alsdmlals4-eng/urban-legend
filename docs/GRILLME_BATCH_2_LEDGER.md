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
- 네 축 위에 관문형 종합 랭크 제공
- 단순 점수 합산·평균과 치명적 실패 상쇄 금지
- 시간은 공통 핵심 평가축에서 제외
- 특수 업적은 종합 랭크와 분리 가능
- 연도 결산은 사건 랭크 평균이 아닌 복합 요원 기록 유지
- 구현·사람 검증 미승인

책임 원본:

- `docs/decisions/D-2026-08-03-INCIDENT-MULTIAXIS-GATED-RANKING.md`
- `docs/planning/2026-08-02-investigation-system-design.md`
- Google Sheet 동일 Decision ID

## 4 / 10

### `D-2026-08-03-INCIDENT-RANK-STAGES-AND-LABELS`

- 정상 종결 사건 종합 랭크는 `C 조건부 대응 / B 적정 대응 / A 우수 대응 / S 정밀 대응`
- 축별 평가는 `미달 / 충족 / 우수 / 정밀`로 통일
- 사건 종결 상태와 종합 랭크 별도 표시
- 출동 실패·정상 종결 전 철수·기관 강제 봉쇄에는 종합 랭크 미부여
- S+·SS·SSS 같은 랭크 인플레이션 금지
- 구현·사람 검증 미승인

책임 원본:

- `docs/decisions/D-2026-08-03-INCIDENT-RANK-STAGES-AND-LABELS.md`
- `docs/planning/2026-08-02-investigation-system-design.md`
- Google Sheet 동일 Decision ID

## 5 / 10

### `D-2026-08-03-INCIDENT-REPLAY-CANON-AND-MASTERY-RECORDS`

- 첫 클리어 뒤 일반 재도전은 `기록 재현`으로 처리
- 기록 재현은 최고 종합 랭크·축별 최고 기록·업적·비필수 보상만 갱신
- 피해자 상태·관계·기관 변화·분기 환류·연도 결산의 캠페인 정본은 유지
- 캠페인 정본과 숙련 기록을 별도 데이터로 보존
- 실제 서사 결과 변경은 별도 `캠페인 되감기`로만 허용
- 되감기 시 선택 사건 이후의 캠페인 진행을 폐기하고 다시 진행
- 과거 사건만 바꾸고 이후 분기를 유지하는 부분 덮어쓰기 금지
- 숙련 기록·업적·비필수 보상은 되감기 뒤에도 유지
- 구현·사람 검증 미승인

책임 원본:

- `docs/decisions/D-2026-08-03-INCIDENT-REPLAY-CANON-AND-MASTERY-RECORDS.md`
- `docs/planning/2026-08-02-investigation-system-design.md`
- Google Sheet 동일 Decision ID

## 6 / 10

### `D-2026-08-03-INCIDENT-CHECKPOINT-RETRY-AND-CANON-CONFIRMATION`

- 조사 소단락·피해자 구출 시작·회수 전투 시작에 주요 체크포인트 제공
- 결과 반영 뒤 선택 단위 자유 되감기와 턴 단위 자유 되감기는 기본 미지원
- 피해자 구출 첫 실패와 회수 전투 패배는 짧은 구간에서 즉시 재시도 가능
- 이미 본 텍스트 빠른 넘김과 중요 행동 실행 전 확인 제공
- 사건 결과 보고서에서 명시적으로 `결과 확정`해야 캠페인 정본 생성
- 결과 확정 전 사건당 1회 `출동 재개`로 마지막 주요 체크포인트 복귀 가능
- 결과 확정 뒤에는 기록 재현 또는 캠페인 되감기 계약 적용
- 접근성 완화는 일반 클리어를 막지 않으며 최고 랭크 처리는 후속 Spec에서 공개
- 구현·사람 검증 미승인

책임 원본:

- `docs/decisions/D-2026-08-03-INCIDENT-CHECKPOINT-RETRY-AND-CANON-CONFIRMATION.md`
- `docs/planning/2026-08-02-investigation-system-design.md`
- Google Sheet 동일 Decision ID

## 7 / 10

### `D-2026-08-03-CAMPAIGN-REWIND-UNLOCK-AND-BRANCH-SLOTS`

- 캠페인 되감기는 첫 1년차 캠페인을 어떤 결과로든 완료한 뒤 해금
- 첫 플레이 도중에는 캠페인 되감기 사용 불가
- 해금에 S 랭크·특정 엔딩·특정 난이도·유료 상품 요구 금지
- 횟수 제한과 게임 내 재화 비용 없음
- 이후 캠페인을 새 정본에 맞춰 다시 진행하는 플레이 시간이 실제 비용
- 최대 3개의 캠페인 분기 슬롯 제공
- 첫 번째 완료 캠페인은 자동 보호 기록으로 보관
- 분기별 캠페인 정본·피해자·관계·결과 패킷·연도 결산 분리
- 최고 숙련 랭크·축별 최고 기록·업적·비필수 보상은 전 분기 공유
- 되감기 전 폐기 범위 표시와 슬롯 삭제·덮어쓰기 재확인 필수
- 구현·사람 검증 미승인

책임 원본:

- `docs/decisions/D-2026-08-03-CAMPAIGN-REWIND-UNLOCK-AND-BRANCH-SLOTS.md`
- `docs/planning/2026-08-02-investigation-system-design.md`
- Google Sheet 동일 Decision ID

## 다음 질문

캠페인 정본을 실제로 바꾸는 되감기의 대상 단위를 사건 시작으로 제한할지, 조사·피해자 구출·회수 전투의 주요 결정 지점까지 허용할지 결정한다.
