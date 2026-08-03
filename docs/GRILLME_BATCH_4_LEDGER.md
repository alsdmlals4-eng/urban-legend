# Grill Me Batch 4 Ledger

- 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
- 주제: 저승역 대표 사건 완전 설계
- 현재 카운터: `2 / 10`
- 현재 식별자: `GRILLME_BATCH_4_2_OF_10`
- 이전 체크포인트: `1 / 10 / GRILLME_BATCH_4_1_OF_10`
- 상태: `ACTIVE_ACCUMULATION / APPROVED_PENDING_BATCH_MERGE`
- 기준 main: `830b0ac41f5f0f549d34cd703194db2a6e7e63b0`
- 누적 브랜치: `agent/grillme-batch-4-afterlife-station-complete-case`
- 누적 Draft PR: `#143`
- 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
- 사람 검증: `NOT_RUN`

## 승인 Decision 1

`D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION`

### 제품 결론

저승역 괴이 매뉴얼의 1장은 방송 공백 하나를 발견하는 문제가 아니라 네 기록을 교차검증하는 추리다.

```text
안내방송 원본의 목적지 무음 공백
+ 피해자 휴대전화의 귀환 목적지 기록
+ 같은 순간 서로 다른 목적지 표시
+ 공식 운행 기록상 추가 목적지·추가 열차 부재
= 공백에 듣는 사람의 귀환 기억이 투영된다
```

### 책임 파일

- `docs/decisions/D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION.md`
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-01-personal-destination-projection.md`

### TDD RED

- test commit: `e197fac8a7ba29d308d33a5b6abbe7fb9c2de078`
- CI wiring commit: `d6b447c4c95fdad55d8c8890438ab6d907552a5e`
- workflow run: `30861831923`
- 결과: `5 tests / 2 failures / 3 errors`
- 의도한 원인: Decision·Section·Batch·Ledger 부재

### 적대적 검토 Guardrail

- 목적지 공백 하나만으로 최종 규칙을 자동 확정하지 않는다.
- 피해자의 특정 목적지를 실제 노선 정답으로 취급하지 않는다.
- 장치 오류 가설을 즉시 배제하지 않고 공식 기록·복수 관찰과 비교한다.
- 1장에서 2장의 금지 행동과 3장의 구출·회수 정답을 선공개하지 않는다.
- `[변조]` 후보는 정상 후보의 변수 하나만 바꾸며 별도 가짜 출처를 만들지 않는다.
- 접근성은 음성 차이만이 아니라 텍스트·시간·출처 비교를 제공한다.

## 승인 Decision 2

`D-2026-08-04-AFTERLIFE-STATION-DESTINATION-BOUNDARY-RESET`

### 제품 결론

```text
목적지 공백을 자신의 귀환 장소로 인식
+ 안내 종료 전
+ 자신이 들은 목적지를 향해 승차선·계단·출구 경계를 넘음
= 시간은 유지되고 위치만 초기화
```

- 승강장 내부 조사 이동은 안전하다.
- 모든 이동이나 검은 승차권 접촉이 발동 조건은 아니다.
- 휴대전화 시각·녹음 길이·배터리·소지품 위치·요원 기록은 초기화되지 않는다.
- 첫 초기화는 즉사나 즉시 실패가 아니라 관찰 가능한 위험 사례다.
- 반복 횟수에 따라 피해자 연결과 위험도가 심화된다.
- 안전한 이동·구출·회수 절차는 3장 책임으로 남긴다.

### 책임 파일

- `docs/decisions/D-2026-08-04-AFTERLIFE-STATION-DESTINATION-BOUNDARY-RESET.md`
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-02-destination-boundary-reset.md`
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4.md`
- `tests/test_afterlife_station_case_batch_4.py`
- `.github/workflows/validate-afterlife-station-case-batch-4.yml`

### TDD RED

- first test commit: `a46a92266ba1ece06080700f1ed439761c2c9686`
- counter-contract test commit: `9557454fbf4efb70daa45c9f5f99239438d63565`
- workflow run: `30862621524`
- 결과: Decision 2·Section 02·2/10 누적 계약 부재로 실패

### 적대적 검토 Guardrail

- 방송 중 조금이라도 움직이면 실패하는 정지 퍼즐로 만들지 않는다.
- 검은 승차권을 피하기만 하는 단순 물건 퍼즐로 축소하지 않는다.
- 시간까지 되돌려 단서가 사라지는 구조를 만들지 않는다.
- 첫 실수로 피해자를 즉시 상실시키지 않는다.
- 위치·시간·증거의 비대칭을 텍스트 기록으로도 확인할 수 있게 한다.
- 2장에서 3장의 안전 이동 정답을 선공개하지 않는다.

## 범위 경계

이번 누적은 설계 문서·계약 테스트·CI만 변경한다. 게임 코드·Scene·사건 데이터·자산은 변경하지 않는다. 구현·Codex·Human QA·이미지 생성·POC·Production은 승인하지 않는다.

## 다음 Gate

Grill Me Batch 4 질문 3/10. 별도 병합 승인 전 PR #143은 Draft·미병합 상태를 유지한다.
