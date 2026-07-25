# Current Codex Handoff

> 상태 원본: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 최신 4주 설계: `docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md`  
> 최신 구현 계획: `docs/superpowers/plans/2026-07-25-annual-mvp-001-four-week-month-implementation-plan.md`

이 문서는 4주 월간 계약의 구현·자동 검증과 사람 사용성·신규 플레이어 검증을 분리한다.

```yaml
status: ANNUAL_MVP_001_FOUR_WEEK_INTEGRATION_PENDING_CI
implemented_baseline: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039
core_mvp_001:
  implementation: POC_BUILD_READY
  focused_suite: 4/4_BASELINE
  player_validation: NOT_RUN
  POC_PASSED: NOT_DECLARED
annual_mvp_001:
  original_implementation:
    pr: 62
    commit: 88522ce08f261bce6d61a8043c64caa3b982bd47
  rendered_qa:
    pr: 65
    commit: b4f2e224bf7a2a6ee511c83bbbd45cd9e0b8570a
    status: HISTORICAL_REGRESSION_EVIDENCE
  pointer_qa:
    pr: 67
    commit: 0f24efa204a04cca62a58e55628e6b831b9bef2d
    status: HISTORICAL_REGRESSION_EVIDENCE
  four_week_contract:
    issue: 69
    contract_version: annual-mvp-001-v2
    max_weeks: 4
    slots_per_week: 3
    total_slots: 12
    week_2_risk: 0
    week_3_risk: 15
    week_4_forced_risk: 30
    implementation: ON_BRANCH
    automated_verification: PENDING
  save_version: annual-mvp-001-save-v1
  human_usability_qa: NOT_RUN
  new_player_validation: NOT_RUN
  annual_loop_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 필수 읽기

```text
AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md
→ docs/superpowers/plans/2026-07-25-annual-mvp-001-four-week-month-implementation-plan.md
→ docs/goals/CODEX_GOAL_ANNUAL_MVP_001_FOUR_WEEK_MONTH.md
→ ANNUAL-MVP-001 데이터·StateV2·Scene·테스트
→ 기존 CORE-MVP-001 회귀
```

## 활성 시간 계약

```text
1주차 3슬롯
→ 2주차 3슬롯 → 자율 출동 위험 0 / 지연
→ 3주차 3슬롯 → 자율 출동 위험 15 / 지연
→ 4주차 3슬롯 → 결과 확인 → 긴급 강제 출동 위험 30
→ 사건 → 연구 → 월말/분기 결산 모형
```

## 구현 사실

- 데이터 계약은 `annual-mvp-001-v2`다.
- 활성 Scene은 기존 3주 State를 삭제하지 않고 `AnnualMvp001StateV2`를 사용한다.
- 3주차 지연은 4주차 `WEEK_PLANNING`으로 이동한다.
- 4주차에는 활동 3개를 모두 처리한다.
- 4주차 결과 확인 뒤 `annual_forced_deployment` 이벤트와 위험 30으로 `PREPARATION`에 진입한다.
- 강제 경로 결산은 `weeks_used=4`를 기록한다.
- 기존 `annual-mvp-001-save-v1` payload, 본편 `mvp-039`, `mvp-038` 이관은 유지한다.
- 기존 활동·동료·스킬·장비·연구 ID를 변경하지 않는다.
- 렌더링 Theme·한글·포인터 typed-array 수정은 보존한다.

## HISTORICAL QA

PR #65·#67의 3주차 강제 출동 결과는 당시 구현의 실제 증거로 보존한다. 다음 항목은 4주 변경 후에도 회귀 기준이지만, 4주차 강제 출동의 신규 플레이 증거는 아니다.

- 1280×720·1920×1080 렌더링
- 한국어 글리프·현지화
- 키보드 포커스·`ui_accept`·Esc
- 그래픽 좌표 클릭
- 저장·불러오기
- 연구·공용 스킬·모듈 선택
- embedded CORE 사건과 매뉴얼·조사 선택지
- 모듈 toggle typed-array 수정

과거 자동 증거: visual run #28, ANNUAL run #94, CORE 4/4, ANNUAL 6/6, 전체 49/49.

## 보호 계약

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `project.godot`
- `knowledge/base-pack/**`
- 기존 save `mvp-039`, `mvp-038`
- `annual-mvp-001-save-v1`
- 기존 CORE 사건·ID와 독립 F1 진입
- 동료·육성 수치가 정답을 대신하지 않는 규칙

## 다음 작업

1. 4주 브랜치의 Python 계약과 Godot import 실행
2. CORE focused, ANNUAL focused, 전체 Godot 회귀 실행
3. 4주차 렌더링·포인터 경로 재확인
4. PR 검토와 squash merge
5. 2주차 조기·3주차 자율·4주차 강제 사람 플레이
6. `KEEP / AMPLIFY / CHANGE / RETEST / HOLD` 판정
7. 별도 사용자 승인 전 ANNUAL-MVP-002 시작 금지
