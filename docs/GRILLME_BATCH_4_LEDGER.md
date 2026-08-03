# Grill Me Batch 4 Ledger

- 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
- 주제: 저승역 대표 사건 완전 설계
- 현재 카운터: `1 / 10`
- 현재 식별자: `GRILLME_BATCH_4_1_OF_10`
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
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4.md`
- `tests/test_afterlife_station_case_batch_4.py`
- `.github/workflows/validate-afterlife-station-case-batch-4.yml`

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

## 범위 경계

이번 누적은 설계 문서·계약 테스트·CI만 변경한다. 게임 코드·Scene·사건 데이터·자산은 변경하지 않는다. 구현·Codex·Human QA·이미지 생성·POC·Production은 승인하지 않는다.

## 다음 Gate

Grill Me Batch 4 질문 2/10. 별도 병합 승인 전 PR #143은 Draft·미병합 상태를 유지한다.
