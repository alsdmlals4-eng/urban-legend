# Grill Me Batch 4 Ledger

- 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
- 주제: 저승역 대표 사건 완전 설계
- 현재 카운터: `10 / 10`
- 현재 식별자: `GRILLME_BATCH_4_10_OF_10`
- 이전 체크포인트: `5 / 10 / GRILLME_BATCH_4_5_OF_10`, `4 / 10 / GRILLME_BATCH_4_4_OF_10`, `3 / 10 / GRILLME_BATCH_4_3_OF_10`, `2 / 10 / GRILLME_BATCH_4_2_OF_10`, `1 / 10 / GRILLME_BATCH_4_1_OF_10`
- 병합 전 상태: `BATCH_COMPLETE_PENDING_EXPLICIT_MERGE_APPROVAL`
- 현재 상태: `MERGED_CANON / IMPLEMENTATION_NOT_AUTHORIZED`
- 기준 main: `830b0ac41f5f0f549d34cd703194db2a6e7e63b0`
- 검증된 제품 HEAD: `a500778897541125d5ff5fb0a68e73f66ce8167b`
- 병합 PR: `#143`
- main 병합 커밋: `5c1f298db43275391bf7ce4c7b1acad841daf295`
- 사람 검증: `NOT_RUN`

## 운영 원칙

- 각 제품 Decision은 별도 정본과 책임 Section을 가진다.
- Ledger는 결정·증거·Gate의 색인이며 세부 설계 원문을 중복하지 않는다.
- 게임 코드·Scene·Episode/PoC JSON·전투 데이터·자산·이미지 생성은 Batch 4 범위가 아니다.
- 구현·Codex·Human QA는 별도 승인 전 진행하지 않는다.

## Decision 1 — 개인 목적지 투영

`D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION`

- 방송 원본의 목적지 공백
- 피해자의 귀환 목적지 증언
- 동시간대 서로 다른 목적지 기록
- 공식 운행 기록상 추가 노선 부재
- 결론: 듣는 사람의 귀환 기억 투영

RED: commit `e197fac8a7ba29d308d33a5b6abbe7fb9c2de078`, CI wiring `d6b447c4c95fdad55d8c8890438ab6d907552a5e`, run `30861831923` — `5 tests / 2 failures / 3 errors`.

## Decision 2 — 목적지 경계 위치 초기화

`D-2026-08-04-AFTERLIFE-STATION-DESTINATION-BOUNDARY-RESET`

- 안내 종료 전 자신이 들은 목적지 방향 경계 통과
- 시간·기록 유지, 사람 위치만 초기화
- 첫 초기화는 즉사 아닌 위험 사례

RED: commits `a46a92266ba1ece06080700f1ed439761c2c9686`, `9557454fbf4efb70daa45c9f5f99239438d63565`, run `30862621524`.

## Decision 3 — 현실 귀환 승차권과 알맞은 역 하차

`D-2026-08-04-AFTERLIFE-STATION-OFFICIAL-ROUTE-TICKET-AND-CORRECT-DISEMBARKATION`

- 공식 기록으로 현실 귀환 경로 확인
- 노선색·노선명·역 코드·문양·텍스트 일치
- 피해자와 동행 탑승, 승차권 보관, 지정 역에서 함께 하차

RED: commit `d963d77eec8acfdb1544818f7ec9c22ffbefdff4`, run `30863502236` — `16 tests / 2 failures / 4 errors`.

## Decision 4 — `[무정차 환송]`

`D-2026-08-04-AFTERLIFE-STATION-NONSTOP-FAREWELL-TICKET-COUNTER`

- 가변 전조와 최종 턴 사전 대응
- 공식 승차권으로 투영 노선 무효화
- `[파훼]`·괴이 `[취약]`

RED: commit `5d20ba2b4284a1578808e6596f0b322d126b7996`, run `30864878227` — `23 tests / 2 failures / 5 errors`.

## Decision 5 — `[회귀 승강장]`

`D-2026-08-04-AFTERLIFE-STATION-RECURRING-PLATFORM-PERSISTENT-TRACE-ANCHOR`

- 시간·로그·소지품·잔향 흔적 유지
- 복수 주기 독립 흔적 비교
- 실제 잔향 좌표 고정으로 `[파훼]`·잔향 노출·괴이 `[취약]`

RED: commit `cbc571f0d51ad5420949abc5df15e55eb288ac25`, run `30865611630` — `31 tests / 2 failures / 6 errors`.

## Decision 6 — `[목적지 합창]`

`D-2026-08-04-AFTERLIFE-STATION-DESTINATION-CHORUS-SILENCE-COUNTER`

- 서로 다른 개인 목적지 기록의 공통 무음 구간
- 최종 턴 공식 역 식별음 삽입
- 개인 투영 붕괴·`[파훼]`·기억 매듭 노출·괴이 `[취약]`

## Decision 7 — 3장 매뉴얼과 후보 풀

`D-2026-08-04-AFTERLIFE-STATION-THREE-CHAPTER-MANUAL-AND-CANDIDATE-POOLS`

- 1장 4슬롯·후보 8개
- 2장 5슬롯·후보 9개
- 3장 5슬롯·후보 10개
- 자유 배치·비소모 증거·세션 중 정답 비공개
- 1장→`[목적지 합창]`, 2장→`[회귀 승강장]`, 3장→`[무정차 환송]`

## Decision 8 — 첫 10분 조사 흐름

`D-2026-08-04-AFTERLIFE-STATION-FIRST-TEN-MINUTES-INVESTIGATION-PACING`

- 피해자 이하린과 철거된 옛집 후회
- 기록 비교·후보 배치·오답 가설 반증
- 첫 초기화 예방 가능, CCTV·연속 녹음 대체 경로

## Decision 9 — 결과·등급·후속 재조사

`D-2026-08-04-AFTERLIFE-STATION-OUTCOME-GRADE-AND-REINVESTIGATION`

- 구출·회수 독립 기록
- 일반 클리어·S 랭크·승인 철수 분리
- 최초 조사 정본·부분 공개·후속 재조사·기록 재현 분리

## Decision 10 — 시각·아트·정보 언어

`D-2026-08-04-AFTERLIFE-STATION-VISUAL-ART-AND-INFORMATION-LANGUAGE`

- 심야 도시철도 현실감
- 개인 기억의 미세한 침입
- 공식 교통 정보 문법
- 공간 반복 공포
- 기록국 현장 문서
- 이미지·게임 자산 제작은 후속 승인

## Decision 6~10 통합 RED

- test commit `a4224fc1dbc4193d2b731fa0f44a4344597f5a2a`
- CI wiring commit `ab6e484ac4688180f8e45344c04e564b760fe856`
- run `30866511654`
- 결과: `53 tests / 6 failures / 16 errors`
- 의도한 원인: Decision 6~10·Section 06~10·10/10 상태 부재

## 최종 GREEN·적대적 감사

- exact HEAD: `a500778897541125d5ff5fb0a68e73f66ce8167b`
- Afterlife Station `30868118227`: PASS
- Documentation `30868118221`: PASS
- BCA `30868118242`: PASS
- ANNUAL/Godot `30868118207`: PASS
- 적대적 감사 리뷰: `4849764822`
- main 대비 ahead 58 / behind 0 / changed files 30 / threads 0

핵심 재미:

```text
규칙 조사
→ 가설을 매뉴얼에 작성
→ 구출 절차 실행
→ 전투 전조 예측
→ 결과로 가설 검증
```

구형 자료 상태:

- Episode·CORE-VALIDATION·PoC 제품 의미: `[대체됨]`
- 기존 런타임·테스트: `[보류]` 이관 입력
- 같은 시각 초기화·검은 승차권 접촉/파괴 해법: `[폐기]`
- 범용 로더·Scene 기반: `[유지]`, 실제 적합성 `NOT_RUN`

## 병합 결과

- PR #143: `MERGED`
- merge commit: `5c1f298db43275391bf7ce4c7b1acad841daf295`
- 검증된 HEAD와 merge commit 사이 파일 차이: `0`
- Google Sheet Decision 1~10·감사 exact-head 동기화 완료

## 다음 Gate

1. 구현 이관 Design Spec
2. 구형 ID migration matrix
3. 저장 호환 정책
4. 수치·UI·패턴 수 결정
5. Human QA 계획
6. 사용자 별도 승인 뒤 Codex 구현
