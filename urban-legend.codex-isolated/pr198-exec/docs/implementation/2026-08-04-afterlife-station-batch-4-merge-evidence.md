# 저승역 Batch 4 병합 증거

- 증거 ID: `MERGE-2026-08-04-AFTERLIFE-STATION-BATCH-4`
- 제품 Batch: `GRILLME_BATCH_4_10_OF_10`
- 제품 PR: `#143`
- 검증된 제품 HEAD: `a500778897541125d5ff5fb0a68e73f66ce8167b`
- main 병합 커밋: `5c1f298db43275391bf7ce4c7b1acad841daf295`
- 병합 방식: `merge commit`
- 현재 제품 상태: `MERGED_CANON`
- 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
- Human QA: `NOT_RUN`
- 이미지·게임 자산: `NOT_STARTED`

## 1. 병합 결과

PR #143은 사용자 정본 확정·병합 승인에 따라 main으로 병합됐다.

- PR 상태: `closed / merged`
- 검증된 제품 HEAD와 merge commit 비교: `ahead 1 / file differences 0`
- RED/GREEN·제품 Decision·적대적 리뷰의 개별 커밋 이력을 보존하기 위해 squash하지 않았다.

## 2. 병합 전 exact-head 검증

검증 대상:

`a500778897541125d5ff5fb0a68e73f66ce8167b`

- Afterlife Station contract `30868118227`: `PASS`
- Documentation contracts `30868118221`: `PASS`
- BCA `30868118242`: `PASS`
- ANNUAL/Godot full regression `30868118207`: `PASS`
- main 대비: ahead `58`, behind `0`
- changed files: `30`
- unresolved review threads: `0`
- 최종 적대적 감사 review: `4849764822`

## 3. 병합된 정본

- `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
- `docs/planning/2026-08-04-afterlife-station-complete-case-batch-4.md`
- `docs/GRILLME_BATCH_4_LEDGER.md`
- Decision 1~10
- Section 01~10
- `docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`
- `docs/audits/2026-08-04-afterlife-station-batch-4-canonicalization-audit.md`
- `START_HERE.md` 저승역 라우팅
- 계약 테스트와 전용 CI

## 4. Google Sheet 동기화

병합 전 exact HEAD와 동일 Decision ID로 다음 범위를 기록하고 재조회했다.

- `00_프로젝트_허브!E2:K2`
- `01_작업순서!A70:N75`
- `02_현재_확정결정!A69:M74`
- `04_누락_충돌_감사!A70:H75`
- `40_핵심시스템_메인콘텐츠!A42:K47`
- `50_메인콘텐츠!A41:J46`
- `99_변경이력!A95:H100`

제품 Decision ID와 감사 ID:

- Decision 6~10
- `AUDIT-2026-08-04-AFTERLIFE-STATION-CANONICALIZATION`

사후 정본 동기화 PR이 병합되면 허브·감사·변경이력에 실제 merge SHA와 동기화 merge SHA를 추가한다.

## 5. 구형 자료 처리

Source Map이 다음 상태를 강제한다.

- 구형 Episode·CORE-VALIDATION·PoC 제품 의미: `[대체됨]`
- 기존 JSON·Scene·스크립트·테스트: `[보류]` 구현 이관 입력
- `같은 시각으로 되돌아왔다`: `[폐기]`
- 검은 승차권 접촉·파괴 중심 해법: `[폐기]`
- 범용 로더·Scene 기반: `[유지]`, 새 정본 적합성 `NOT_RUN`

구형 파일은 이관·저장 호환 계획 없이 삭제하거나 ID를 변경하지 않는다.

## 6. 사후 동기화 범위

사후 동기화는 다음만 수행한다.

- Current canon을 `MERGED_CANON`으로 갱신
- Batch·Ledger에 merge SHA와 최종 상태 기록
- START_HERE의 PR #143 상태 갱신
- 이 병합 증거 문서 추가
- Google Sheet에 실제 merge SHA 기록

제품 규칙·게임 코드·Scene·Episode/PoC JSON·저장 Schema·이미지·게임 자산은 변경하지 않는다.

## 7. 다음 Gate

1. 구현 이관 Design Spec
2. 구형 ID → 새 ID migration matrix
3. save `mvp-039`·Validation 저장 호환 정책
4. 실제 전투 패턴 수·수치·UI 결정
5. 첫 10분·공정성·접근성·인지 부하 Human QA 계획
6. 사용자 별도 승인 뒤 Codex 구현
