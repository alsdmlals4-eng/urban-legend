# 저승역 현재 정본

> 문서 역할: `CURRENT_AFTERLIFE_STATION_CANON`
> 상태: `MERGED_CANON / IMPLEMENTATION_NOT_AUTHORIZED`
> 병합 PR: `#143`
> 검증된 제품 HEAD: `a500778897541125d5ff5fb0a68e73f66ce8167b`
> main 병합 커밋: `5c1f298db43275391bf7ce4c7b1acad841daf295`
> 정본 Source Map: `docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`
> 적대적 감사: `docs/audits/2026-08-04-afterlife-station-batch-4-canonicalization-audit.md`
> 병합 증거: `docs/implementation/2026-08-04-afterlife-station-batch-4-merge-evidence.md`

저승역 관련 기획·콘텐츠·아트 논의는 이 문서에서 시작한다. `docs/CURRENT_CONFIRMED_DECISIONS.md`, `docs/CURRENT_HANDOFF_VALIDATION.md`, 구형 Episode·PoC·CORE-VALIDATION 문서가 이 문서와 충돌하면 이 문서와 Source Map의 상태 분류를 우선한다.

Batch 4 PR #143은 2026-08-04에 merge commit `5c1f298db43275391bf7ce4c7b1acad841daf295`로 main에 통합됐다. 검증된 제품 HEAD와 병합 커밋 사이의 파일 차이는 0개다.

## 현재 제품 흐름

```text
빈칸이 많은 3장 괴이 매뉴얼로 시작
→ 단서 [기록] 조사
→ 후보·[변조] 키워드 획득과 자유 배치
→ 최종장 모든 빈칸 완료
→ 피해자 구출 미니게임
→ 전조형 회수 전투
→ 사건 결과·정답 공개·후속 재조사·기록 재현
```

빈칸 완료는 정답 확인이 아니다. 정답 여부는 구출·회수 실행 중 관찰 현상으로 추론하고, 세션 종료 뒤 결과 범위에 따라 확인한다.

## 승인 Decision 1~10

1. `D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION`
2. `D-2026-08-04-AFTERLIFE-STATION-DESTINATION-BOUNDARY-RESET`
3. `D-2026-08-04-AFTERLIFE-STATION-OFFICIAL-ROUTE-TICKET-AND-CORRECT-DISEMBARKATION`
4. `D-2026-08-04-AFTERLIFE-STATION-NONSTOP-FAREWELL-TICKET-COUNTER`
5. `D-2026-08-04-AFTERLIFE-STATION-RECURRING-PLATFORM-PERSISTENT-TRACE-ANCHOR`
6. `D-2026-08-04-AFTERLIFE-STATION-DESTINATION-CHORUS-SILENCE-COUNTER`
7. `D-2026-08-04-AFTERLIFE-STATION-THREE-CHAPTER-MANUAL-AND-CANDIDATE-POOLS`
8. `D-2026-08-04-AFTERLIFE-STATION-FIRST-TEN-MINUTES-INVESTIGATION-PACING`
9. `D-2026-08-04-AFTERLIFE-STATION-OUTCOME-GRADE-AND-REINVESTIGATION`
10. `D-2026-08-04-AFTERLIFE-STATION-VISUAL-ART-AND-INFORMATION-LANGUAGE`

상세 문서는 `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4.md`와 Section 01~10을 따른다.

## 핵심 규칙

- 방송 목적지 공백은 듣는 사람의 귀환 기억으로 채워진다.
- 안내 종료 전 자신이 들은 목적지를 향해 경계를 넘으면 시간·기록은 유지되고 위치만 초기화된다.
- 피해자의 현실 귀환 경로와 일치하는 승차권을 회수하고 지정 역에서 함께 하차한다.
- 회수 전투는 조사 기록을 다시 사용한다.
  - 1장 → `[목적지 합창]`
  - 2장 → `[회귀 승강장]`
  - 3장 → `[무정차 환송]`
- 매뉴얼·접근성 기능은 정답 대응·좌표·타이밍을 자동 표시하지 않는다.

## 피해자와 아트

- 대표 피해자: 이하린, 28세
- 감정 앵커: 철거된 옛집에 마지막으로 돌아가지 못한 후회
- 돌아가고 싶은 장소는 현실 귀환 경로의 정답이 아니다.
- 아트 축: 심야 도시철도 현실감, 개인 기억의 미세한 침입, 공식 교통 정보 문법, 공간 반복 공포, 기록국 현장 문서
- 이미지 생성과 게임 자산 제작은 후속 승인이다.

## 구형 자료 상태

정확한 파일별 상태는 Source Map이 소유한다.

- 구형 Episode·CORE-VALIDATION·PoC 데이터: `[보류]` 구현 이관 입력 / 제품 의미 `[대체됨]`
- 같은 시각으로 되돌아온다는 규칙: `[폐기]`
- 검은 승차권 접촉·파괴 중심 해법: `[폐기]`
- 기존 PoC Scene·스크립트·테스트: `[보류]` 이관 전 삭제 금지

Batch·Ledger·Audit 안에 남아 있는 `BATCH_COMPLETE_PENDING_EXPLICIT_MERGE_APPROVAL` 또는 `READY_FOR_EXPLICITLY_AUTHORIZED_MERGE` 문구는 병합 전 역사 상태다. 현재 상태는 이 문서의 `MERGED_CANON`이 우선한다.

## 다음 Gate

1. 구현 이관 Design Spec 작성
2. 구형 ID → 새 매뉴얼·기록·패턴 ID migration matrix
3. save `mvp-039`·Validation 저장 호환 정책
4. 실제 패턴 수·수치·UI·전투 인지 부하 결정
5. 첫 10분·접근성·공정성 Human QA 계획
6. 별도 사용자 승인 뒤 Codex 구현

구현·Human QA·이미지 생성·게임 자산 제작은 계속 `NOT_AUTHORIZED / NOT_RUN / NOT_STARTED`다.
