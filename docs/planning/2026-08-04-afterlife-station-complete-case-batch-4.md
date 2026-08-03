# 저승역 완전 사건 설계 — Grill Me Batch 4

- 기준 main: `830b0ac41f5f0f549d34cd703194db2a6e7e63b0`
- 브랜치: `agent/grillme-batch-4-afterlife-station-complete-case`
- Draft PR: `#143`
- 현재 카운터: `3 / 10`
- 현재 식별자: `GRILLME_BATCH_4_3_OF_10`
- 이전 체크포인트: `2 / 10 / GRILLME_BATCH_4_2_OF_10`, `1 / 10 / GRILLME_BATCH_4_1_OF_10`
- 상태: `ACTIVE_ACCUMULATION / APPROVED_PENDING_BATCH_MERGE`
- 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
- Human QA: `NOT_RUN`

## 목적

Batch 3에서 확정한 괴이 매뉴얼·단서 `[기록]`·피해자 구출·전조형 회수 전투 계약을 저승역 대표 사건 한 건에 실제 콘텐츠로 적용한다.

```text
저승역 실제 규칙
→ 3장 괴이 매뉴얼
→ 장별 단서 [기록]과 후보 키워드
→ 정상·보조·오답·[변조] 후보
→ 피해자 구출 미니게임
→ 회수 전투 패턴
→ 정상 클리어·실패·승인 철수
→ 결과 범위 정답 공개·후속 재조사·기록 재현
```

## 승인 Decision

### 1. 개인 목적지 투영과 1장 교차검증

`D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION`

- 안내방송 원본의 목적지 구간은 비어 있다.
- 피해자는 자신의 귀환 장소를 목적지로 들었다고 기록한다.
- 같은 순간 서로 다른 목적지가 관찰자와 장치마다 남는다.
- 공식 운행 기록에는 추가 목적지와 추가 열차가 없다.
- 네 기록을 교차검증해 `공백에 귀환 기억이 투영된다`를 추론한다.

책임 Section:

- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-01-personal-destination-projection.md`

### 2. 투영 목적지 경계 통과와 위치 초기화

`D-2026-08-04-AFTERLIFE-STATION-DESTINATION-BOUNDARY-RESET`

- 목적지 공백을 자신의 귀환 장소로 인식한 상태에서 발동한다.
- 안내 종료 전 자신이 들은 목적지를 향해 승차선·계단·출구 경계를 넘으면 위치만 진입점으로 초기화된다.
- 승강장 내부의 관찰·기록 수집·짧은 위치 이동은 안전하다.
- 시간과 기록은 유지되고 첫 초기화는 관찰 가능한 위험 사례다.

책임 Section:

- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-02-destination-boundary-reset.md`

### 3. 현실 귀환 승차권 회수와 알맞은 역 하차

`D-2026-08-04-AFTERLIFE-STATION-OFFICIAL-ROUTE-TICKET-AND-CORRECT-DISEMBARKATION`

- 공식 운행 기록과 피해자의 교통 이용 흔적으로 현실 귀환 경로를 확인한다.
- 자신에게 맞는 승차권은 개인의 바람에 맞는 표가 아니며 투영된 목적지와 구분한다.
- 승차권 색상은 현실 노선의 노선색과 일치해야 한다.
- 색상만으로 판별하지 않고 노선명·역 코드·문양·텍스트를 함께 확인한다.
- 안내 종료 후 공식 역 식별음을 재생한다.
- 노선색·노선명·역 코드가 맞는 승차권을 회수한다.
- 피해자와 함께 공식 열차에 탑승하고 승차권을 끝까지 보관한다.
- 승차권에 적힌 알맞은 역에서 함께 하차해야 구출이 완성된다.
- 구출 성공은 회수 전투 진입 조건이며 사건을 자동 종결하지 않는다.

책임 Section:

- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-03-official-route-ticket-and-correct-disembarkation.md`

## GPT 역할 경계

이번 Batch에서 GPT는 다음을 담당한다.

- 저승역의 핵심 재미와 사건 인과
- 장별 조사 콘텐츠와 단서 기록
- 후보·오답·[변조] 키워드
- 피해자 구출과 회수 전투의 콘텐츠 설계
- 이미지·아트 방향의 후속 논의
- 벤치마킹과 적대적 검토

게임 코드·Scene·사건 데이터·자산, UI 구현, 저장 Schema, 자동화 구현은 전체 기획과 별도 승인을 마친 뒤 Codex 단계에서 다룬다.

## 누적 Gate

- 한 번에 하나의 고레버리지 질문만 승인한다.
- 승인 Decision은 같은 ID로 Decision·Section·Ledger·Google Sheet에 동기화한다.
- 10개 Decision 완료 전 Draft PR을 병합하지 않는다.
- Batch 완료 뒤에도 별도의 명시적 병합 승인이 필요하다.
