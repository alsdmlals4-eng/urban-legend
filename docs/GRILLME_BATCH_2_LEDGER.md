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

```text
현재 정본 확인
→ 게임·현업 사례 벤치마킹
→ 적용 가능한 점과 적용하면 안 되는 점 분리
→ 제작비·UX·밸런스·재플레이 관점 비교
→ 적대적 검토
→ 선택지와 권장안
→ 사용자 승인 뒤 정본 동기화
```

## 1 / 10

### `D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING`

- 필수 진실은 비판정 또는 확정 우회 경로로 획득
- 능력·태그·판정은 비용·근거·위험·구출·전투 우위를 변화
- 최고 랭크·업적에는 지정 준비 조건을 사용할 수 있음
- 일반 클리어와 캠페인 진행은 차단하지 않음

## 2 / 10

### `D-2026-08-02-INVESTIGATION-RANK-CONDITION-DISCLOSURE`

- 최고 랭크 요구 능력·태그와 수치를 출동 전 공개
- 정확한 사용 지점·정답·최적 순서는 비공개
- 첫 클리어 뒤 미달 이유와 숙련 체크리스트 공개

## 3 / 10

### `D-2026-08-03-INCIDENT-MULTIAXIS-GATED-RANKING`

- 조사 정확도·피해자 보호·현장 통제·기록 완성도 네 축
- 단순 합산이 아닌 관문형 종합 랭크
- 치명적 실패 상쇄 금지

## 4 / 10

### `D-2026-08-03-INCIDENT-RANK-STAGES-AND-LABELS`

- `C 조건부 대응 / B 적정 대응 / A 우수 대응 / S 정밀 대응`
- 축별 `미달 / 충족 / 우수 / 정밀`
- 정상 종결 실패에는 종합 랭크 없음

## 5 / 10

### `D-2026-08-03-INCIDENT-REPLAY-CANON-AND-MASTERY-RECORDS`

- 일반 재도전은 숙련 기록만 갱신
- 실제 서사 변경은 이후 진행 폐기형 캠페인 되감기만 허용
- 캠페인 정본과 숙련 기록 분리

## 6 / 10

### `D-2026-08-03-INCIDENT-CHECKPOINT-RETRY-AND-CANON-CONFIRMATION`

- 조사 소단락·구출 시작·전투 시작 체크포인트
- 선택·턴 단위 자유 되감기 미지원
- 결과 보고서에서 명시적으로 정본 확정
- 확정 전 사건당 1회 출동 재개

## 7 / 10

### `D-2026-08-03-CAMPAIGN-REWIND-UNLOCK-AND-BRANCH-SLOTS`

- 첫 1년차 완료 뒤 조건 없이 해금
- 첫 플레이 중 사용 불가
- 횟수·재화 비용 없음
- 최대 3개 캠페인 분기 슬롯
- 최초 완료 캠페인 자동 보호
- 분기별 정본 분리·숙련 기록 공유
- 폐기 범위 표시·덮어쓰기 재확인
- 구현·사람 검증 미승인

책임 원본:

- 각 Decision 파일
- `docs/planning/2026-08-02-investigation-system-design.md`
- Google Sheet 동일 Decision ID

## 다음 질문

캠페인 되감기의 대상 단위를 사건 시작으로 제한할지, 사건 내부 주요 결정 지점까지 허용할지 결정한다.
