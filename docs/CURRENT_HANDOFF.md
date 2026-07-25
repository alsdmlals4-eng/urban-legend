# Current Codex Handoff

> 상태 원본: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`  
> 최신 시간 설계: `docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md`  
> 최신 구현 계획: `docs/superpowers/plans/2026-07-25-annual-mvp-001-seven-day-scheduling-implementation-plan.md`

이 문서는 4주 월간 구조 안의 7일 주간·가변 일정 일수 구현과 사람 사용성·신규 플레이어 검증을 분리한다. 연도제 설계 상태는 `APPROVED_DESIGN_BASELINE`이다.

```yaml
status: ANNUAL_MVP_001_SEVEN_DAY_SCHEDULING_ON_BRANCH_CI_PENDING
implemented_baseline: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039
annual_design: APPROVED_DESIGN_BASELINE
core_mvp_001:
  implementation: POC_BUILD_READY
  player_validation: NOT_RUN
  POC_PASSED: NOT_DECLARED
annual_mvp_001:
  original_implementation:
    pr: 62
    commit: 88522ce08f261bce6d61a8043c64caa3b982bd47
    status: HISTORICAL_REGRESSION_EVIDENCE
  rendered_and_pointer_qa:
    prs: [65, 67]
    status: HISTORICAL_REGRESSION_EVIDENCE
  four_week_three_slot_contract:
    issue: 69
    pr: 70
    commit: 20a0d052e4d48863481af7c3acc53805105d6a01
    contract_version: annual-mvp-001-v2
    status: HISTORICAL_REGRESSION_EVIDENCE
  canonical_document_sync:
    issue: 72
    pr: 73
    commit: 932bc39300bb6ba7f3169b98c25d910f0e01413a
    status: COMPLETE
  seven_day_contract:
    issue: 75
    contract_version: annual-mvp-001-v3
    max_weeks: 4
    days_per_week: 7
    total_days: 28
    activity_day_cost_range: 1..3
    cross_week_activity: FORBIDDEN
    underfilled_first_confirm: WARNING_AND_RETURN
    unchanged_second_confirm: AUTO_REST
    direct_rest_fatigue: -25
    auto_rest_fatigue_per_day: -5
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
→ docs/GAME_DESIGN_DOCUMENT.md
→ docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md
→ docs/superpowers/plans/2026-07-25-annual-mvp-001-seven-day-scheduling-implementation-plan.md
→ ANNUAL-MVP-001 데이터·StateV2·Scene·테스트
→ 기존 CORE-MVP-001 회귀
```

## 활성 시간 계약

```text
1주차 7일
→ 2주차 7일 → 자율 출동 위험 0 / 지연
→ 3주차 7일 → 자율 출동 위험 15 / 지연
→ 4주차 7일 → 결과 확인 → 긴급 강제 출동 위험 30
→ 사건 → 연구 → 월말/분기 결산 모형
```

- 일정별 비용은 1~3일이다.
- 일정은 주차 경계를 넘지 못한다.
- 7일 미만 첫 확정은 경고만 하고 편성을 유지한다.
- 같은 편성 재확정 시 남은 일수를 자동 휴식 처리한다.
- 직접 휴식은 1일·피로 -25·상태 회복 가능이다.
- 자동 휴식은 하루당 피로 5만 회복하며 관계 이벤트·특수 회복·추가 보상이 없다.

## 구현 사실

- 데이터 계약은 `annual-mvp-001-v3`다.
- 기존 활동·동료·스킬·장비·연구 ID를 유지한다.
- `AnnualMvp001StateV2`가 일수 합계와 자동 휴식을 소유한다.
- Scene은 경고 후 재확정 여부만 임시 UI 상태로 관리한다.
- 주간 결과는 `planned_days`, `used_days`, `auto_rest_days`, `activity_results`를 기록한다.
- 기존 `slot_results`는 회귀 호환 alias로 유지한다.
- 4주차 결과 뒤 `annual_forced_deployment`, 위험 30으로 전환한다.
- `annual-mvp-001-save-v1`, 본편 `mvp-039`, `mvp-038` 이관은 유지한다.
- 사건 중 저장 금지와 저장 seed 재현성을 유지한다.
- 성장·동료 지원은 정답·가설·이해도·포획 표식을 변경하지 않는다.

## GDD DOCX 정책

- 편집 원본은 `docs/GAME_DESIGN_DOCUMENT.md`다.
- `tools/docs/build_game_design_doc.py`가 결정적 DOCX 미러를 생성한다.
- 생성기 포맷은 `urban-legend-gdd-index-v5`, GDD 표기는 v3.2다.
- `docs/URBAN_LEGEND_GAME_DESIGN.docx`는 Git에 추적하지 않는다.
- PR 검증에서 build·source hash·구조 검사를 수행한다.

## HISTORICAL QA

- PR #65·#67의 3주 구조 렌더링·입력 QA
- PR #70의 4주×3슬롯 구현
- visual run #28, ANNUAL run #94, 전체 49/49
- 문서 run #253/#255, ANNUAL run #101/#103, Visual run #34

위 증거는 회귀 자료로 보존하지만 현재 7일 주간 계약의 사람 플레이 증거가 아니다.

## 보호 계약

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `project.godot`
- `knowledge/base-pack/**`
- save `mvp-039`, `mvp-038`, `annual-mvp-001-save-v1`
- 기존 CORE 사건·ID와 독립 F1 진입
- 동료·육성 수치가 정답을 대신하지 않는 규칙

## 다음 작업

1. Issue #75 자동 검증과 PR 병합
2. 7일 편성·경고·자동 휴식의 사람 반복 조작
3. 2주차 조기·3주차 자율·4주차 강제 사람 플레이
4. 육성→사건→연구 인과와 지원 공정성 설명 수집
5. `KEEP / AMPLIFY / CHANGE / RETEST / HOLD` 판정
6. 별도 사용자 승인 전 ANNUAL-MVP-002 시작 금지
