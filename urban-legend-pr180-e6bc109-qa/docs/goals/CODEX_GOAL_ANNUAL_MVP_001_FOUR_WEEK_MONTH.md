# Codex Goal — ANNUAL-MVP-001 4주 월간 루프 보정

## Goal

기존 `3주 × 3슬롯` ANNUAL-MVP-001을 `4주 × 3슬롯`으로 전환한다. 2주차 조기 출동과 3주차 위험 자율 출동을 유지하고, 3주차 지연 시 4주차 활동 3슬롯을 모두 처리한 뒤 주간 결과 확인과 함께 긴급 강제 출동으로 전환한다.

## Player Value

달력상 한 달과 게임의 월간 육성 단위를 일치시켜 시간 감각을 직관적으로 만든다. 플레이어가 마지막 3슬롯의 성장 이득과 위험 +30 강제 출동을 교환하는 명확한 선택을 경험하게 한다.

## Required Reading Order

1. 최신 사용자 지시
2. `START_HERE.md`
3. `AGENTS.md`
4. `docs/OPERATING_MODEL.md`
5. `docs/WORK_MODE_AND_SKILL_ROUTING.md`
6. `docs/CURRENT_STATUS.md`
7. `docs/DOCUMENTATION_MAP.md`
8. `docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md`
9. `docs/superpowers/plans/2026-07-25-annual-mvp-001-four-week-month-implementation-plan.md`
10. 실제 ANNUAL 데이터·상태·Scene·테스트

## Scope

- JSON 계약 `annual-mvp-001-v2`
- 데이터 검증기
- 주간·출동 상태 머신
- 주차 및 출동 안내 UI
- 데이터·상태·Scene·정적 계약 테스트
- 활성 정본·로드맵·체크리스트·DOCX 동기화
- Issue·PR·CI·병합 후 상태 갱신

## Out of Scope

- 신규 콘텐츠
- 본편 GameState 통합
- 저장 Schema 변경
- ANNUAL-MVP-002
- POC_PASSED 선언
- 사람 플레이 검증 완료 선언

## Fixed Rules

```text
1주차: 3슬롯, 출동 결정 없음
2주차: 3슬롯, 출동 위험 0 / 지연 가능
3주차: 3슬롯, 출동 위험 15 / 지연 가능
4주차: 3슬롯, 결과 확인 후 강제 출동 위험 30
```

## Protected Paths

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `project.godot`
- `knowledge/base-pack/**`
- save `mvp-039`, migration `mvp-038`

## TDD Contract

1. 데이터 v2/4주 기대 테스트를 먼저 실패시킨다.
2. 3주 지연 후 4주 계획을 기대하는 상태 테스트를 먼저 실패시킨다.
3. `/4` UI와 3주차 지연 안내 테스트를 먼저 실패시킨다.
4. 최소 구현으로 Green을 만든다.
5. CORE focused, ANNUAL focused, 전체 Godot 회귀를 실행한다.
6. 활성 문서의 현재형 3주 계약을 0건으로 만든다.

## Acceptance Criteria

- `max_weeks=4`, `slots_per_week=3`, `deadline_week=4`
- 강제 경로 `weeks_used=4`
- 4주차 계획에서 정확히 3개 활동 필요
- 4주차 결과 확인 뒤 `PREPARATION`, `forced_deployment=true`, 위험 30
- save version `annual-mvp-001-save-v1` 유지
- 기존 CORE 4/4 이상 회귀 유지
- 기존 ANNUAL 집중 테스트와 신규 4주 테스트 통과
- 보호 경로 diff 없음
- 현재형 정본 문서에서 3주 월간 계약 제거
- 사람 QA와 신규 플레이어 검증은 `NOT_RUN` 유지

## Final Report

다음을 반드시 보고한다.

- Work Mode 및 사용 Skill
- 변경 파일과 변경 이유
- Red 실패 증거
- Green·전체 회귀 증거
- 저장·CORE 호환성
- 현재형 3주 참조 감사 결과
- PR 번호·병합 commit
- 미검증 사람 QA
- 다음 게이트: 2주차 조기·3주차 자율·4주차 강제 수동 플레이
