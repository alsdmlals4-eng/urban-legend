# 철회된 설계 기록 — 고정 4턴 전조·패턴 주기

> Decision ID: `DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE`
> 상태: `RETRACTED_MISINTERPRETATION / NOT_ACTIVE_AUTHORITY`
> 카운터: `NON_COUNTING / BATCH_3_3_OF_10`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 배치 병합: `BATCH_MERGE_NOT_STARTED`
> 병합: `MERGE_NOT_AUTHORIZED`

이 문서는 사용자의 예시를 고정 4턴 제품 규칙으로 잘못 해석해 작성된 설계 기록이다. 제품 설계·Codex 구현·Schema·UX의 입력으로 사용하지 않는다.

## 철회된 가정

- 모든 패턴이 네 턴으로 고정된다는 가정
- 패턴마다 전조 세 개를 누적한다는 가정
- 4턴에만 전용 대응을 연다는 가정
- `cycle_turn`, `ordered_telegraphs`, `pattern_cycle_id`가 승인됐다는 가정

4턴은 예시일 뿐 전역 규칙이 아니다. 실제 기준은 **패턴별 전조·판단 단위**이며, 사건과 괴이가 저작한 패턴 수에 따라 회수 길이가 달라진다.

## 활성 참조

- 최신 승인 정본: `DEC-20260805-117-CANON-V2-RESCUE-MINIGAME-AND-RETRIEVAL-RULE-COVERAGE`
- 프로젝트 전수 재감사: `docs/audits/2026-08-06-recovery-pattern-authority-project-wide-reaudit.md`
- 현행 권위: `docs/GAME_DESIGN_DOCUMENT.md`, `docs/VALIDATION_TARGET_CANON.md`

이 파일은 오류 발생 경위와 철회 이력을 보존하기 위해 유지한다.
