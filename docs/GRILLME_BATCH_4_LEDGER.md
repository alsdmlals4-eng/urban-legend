# Grill Me Batch 4 Ledger

- 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
- 주제: 저승역 대표 사건 완전 설계
- 현재 카운터: `5 / 10`
- 현재 식별자: `GRILLME_BATCH_4_5_OF_10`
- 이전 체크포인트: `4 / 10 / GRILLME_BATCH_4_4_OF_10`, `3 / 10 / GRILLME_BATCH_4_3_OF_10`, `2 / 10 / GRILLME_BATCH_4_2_OF_10`, `1 / 10 / GRILLME_BATCH_4_1_OF_10`
- 상태: `ACTIVE_ACCUMULATION / APPROVED_PENDING_BATCH_MERGE`
- 기준 main: `830b0ac41f5f0f549d34cd703194db2a6e7e63b0`
- 누적 브랜치: `agent/grillme-batch-4-afterlife-station-complete-case`
- 누적 Draft PR: `#143`
- 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
- 사람 검증: `NOT_RUN`

## 승인 Decision 1

`D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION`

### 제품 결론

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

### 책임 파일

- `docs/decisions/D-2026-08-04-AFTERLIFE-STATION-DESTINATION-BOUNDARY-RESET.md`
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-02-destination-boundary-reset.md`

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

## 승인 Decision 3

`D-2026-08-04-AFTERLIFE-STATION-OFFICIAL-ROUTE-TICKET-AND-CORRECT-DISEMBARKATION`

### 제품 결론

```text
공식 운행 기록과 피해자 흔적으로 현실 귀환 경로 확인
→ 안내 종료 대기
→ 공식 역 식별음으로 현재 위치·노선 고정
→ 노선색·노선명·역 코드가 맞는 자신에게 맞는 승차권 회수
→ 피해자와 함께 탑승
→ 승차권을 끝까지 보관
→ 승차권에 적힌 알맞은 역에서 함께 하차
= 피해자 구출 성공
```

- 자신에게 맞는 승차권은 개인의 바람에 맞는 표가 아니다.
- 투영된 목적지와 현실 귀환 경로를 분리한다.
- 승차권 색상은 현실 노선의 노선색과 일치해야 한다.
- 색상만으로 판별하지 않고 노선명·역 코드·문양·텍스트를 함께 사용한다.
- 구출 성공은 회수 전투 진입 조건이며 사건을 자동 종결하지 않는다.

### 책임 파일

- `docs/decisions/D-2026-08-04-AFTERLIFE-STATION-OFFICIAL-ROUTE-TICKET-AND-CORRECT-DISEMBARKATION.md`
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-03-official-route-ticket-and-correct-disembarkation.md`

### TDD RED

- test commit: `d963d77eec8acfdb1544818f7ec9c22ffbefdff4`
- workflow run: `30863502236`
- 결과: `16 tests / 2 failures / 4 errors`

### 적대적 검토 Guardrail

- 개인이 돌아가고 싶어 하는 장소를 정답 하차 역으로 사용하지 않는다.
- 승차권 색상 하나만 맞추는 퍼즐로 축소하지 않는다.
- 색각 차이가 있는 플레이어에게 불리한 색상 단독 판별을 금지한다.
- 잘못된 승차권이나 역 선택을 숨겨진 확률로 판정하지 않는다.
- 첫 구출 실패로 피해자를 즉시 사망시키지 않는다.
- 매뉴얼이 승차권·열차·하차 역을 자동 선택하지 않는다.
- 구출 성공과 괴이 회수 전투를 분리한다.

## 승인 Decision 4

`D-2026-08-04-AFTERLIFE-STATION-NONSTOP-FAREWELL-TICKET-COUNTER`

### 제품 결론

```text
목적지 없는 전광판과 잘못된 노선 전조
→ 최종 턴 사전 대응
→ 구출 단계에서 보관한 공식 승차권을 개찰기에 제시
→ 투영 노선 무효화
→ [파훼]
→ 괴이 [취약]
→ 유효 공격 기회
```

- 패턴 길이는 고정하지 않고 `N ≥ 2`, `N-1개의 전조` 계약을 따른다.
- 최종 턴은 `대응 선택 → 패턴 발현 → 결과 산출 → 평상 진행` 순서다.
- 공식 승차권은 소모되지 않으며 공식 검표 흔적이 추가된다.
- 방어는 피해만 감소시키고 취약을 만들지 않는다.
- 공격·잘못된 승차권·조기 사용은 서로 다른 결정적 결과를 만든다.
- 모든 회수 전투 패턴을 승차권으로 해결하지 않는다.

### 책임 파일

- `docs/decisions/D-2026-08-04-AFTERLIFE-STATION-NONSTOP-FAREWELL-TICKET-COUNTER.md`
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-04-nonstop-farewell-ticket-counter.md`
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4.md`
- `tests/test_afterlife_station_case_batch_4.py`
- `.github/workflows/validate-afterlife-station-case-batch-4.yml`

### TDD RED

- test commit: `5d20ba2b4284a1578808e6596f0b322d126b7996`
- workflow run: `30864878227`
- 결과: `23 tests / 2 failures / 5 errors`

### 적대적 검토 Guardrail

- 단순한 방송 횟수 카운트·방어 퍼즐로 축소하지 않는다.
- 열차 발현 뒤 정답을 누르는 반응형 QTE로 만들지 않는다.
- 공식 승차권을 소모하거나 파괴하지 않는다.
- 방어와 정확한 파훼에 같은 보상을 주지 않는다.
- 공격만으로 전조를 무시하고 취약을 만들지 못하게 한다.
- 잘못된 승차권 결과를 숨겨진 확률로 판정하지 않는다.
- 색상·음향 단독 신호에 의존하지 않는다.
- 모든 후속 회수 패턴을 승차권으로 반복하지 않는다.

## 승인 Decision 5

`D-2026-08-04-AFTERLIFE-STATION-RECURRING-PLATFORM-PERSISTENT-TRACE-ANCHOR`

### 제품 결론

```text
위치는 반복해서 초기화
+ 시간·기록·흔적은 유지
+ 복수 초기화 주기의 지속 흔적을 교차 비교
→ 실제 잔향 좌표 지정
→ 지속 흔적 고정
→ 전체 위치 초기화 실패
→ [파훼]·잔향 노출·괴이 [취약]
```

- 두 번째 대표 회수 패턴은 `[회귀 승강장]`이다.
- 승차권을 파훼 수단으로 사용하지 않는다.
- 공식 검표 흔적은 선택적 근거이며 필수 선행 조건이 아니다.
- 최소 2개 초기화 주기와 2종 독립 지속 흔적을 제공한다.
- 매뉴얼·접근성 기능은 실제 잔향이나 정답 좌표를 자동 표시·선택하지 않는다.

### 책임 파일

- `docs/decisions/D-2026-08-04-AFTERLIFE-STATION-RECURRING-PLATFORM-PERSISTENT-TRACE-ANCHOR.md`
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-05-recurring-platform-persistent-trace-anchor.md`
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4.md`
- `tests/test_afterlife_station_case_batch_4.py`
- `.github/workflows/validate-afterlife-station-case-batch-4.yml`

### TDD RED

- test commit: `cbc571f0d51ad5420949abc5df15e55eb288ac25`
- workflow run: `30865611630`
- 결과: `31 tests / 2 failures / 6 errors`
- 의도한 원인: Decision 5·Section 05·5/10 누적 계약 부재

### 적대적 검토 Guardrail

- 승차권 제시를 두 번째 패턴에서도 반복하지 않는다.
- 공식 검표 흔적이 없어도 다른 지속 흔적으로 해결 가능하게 한다.
- 단일 빛나는 흔적 클릭이나 허상 밝기 비교로 축소하지 않는다.
- 복수 주기와 복수 출처 기록을 비교해야 한다.
- 매뉴얼이 실제 잔향을 자동 표시하거나 정답 좌표를 선택하지 않는다.
- 화면·음향 효과만으로 판단하게 하지 않는다.
- 조기 시도는 행동 손실만 주며 즉사·영구 실패를 만들지 않는다.

## 범위 경계

이번 누적은 설계 문서·계약 테스트·CI만 변경한다. 게임 코드·Scene·사건 데이터·전투 데이터·자산은 변경하지 않는다. 구현·Codex·Human QA·이미지 생성·POC·Production은 승인하지 않는다.

## 다음 Gate

Grill Me Batch 4 질문 6/10. 별도 병합 승인 전 PR #143은 Draft·미병합 상태를 유지한다.
