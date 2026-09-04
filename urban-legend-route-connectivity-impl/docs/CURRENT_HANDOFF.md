# Current Codex Handoff

> 상태 원본: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`  
> 최신 시간 설계: `docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md`  
> ANNUAL-MVP-002 상세 설계: `docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md`  
> 최신 구현 계획: `docs/superpowers/plans/2026-07-26-annual-mvp-002-vertical-slice-implementation-plan.md`  
> 벤치마크 권장안: `docs/planning/ANNUAL_BENCHMARK_RECOMMENDATIONS.md`

이 문서는 ANNUAL-MVP-001의 4주×7일 계약과 ANNUAL-MVP-002 동료·장비·연구 수직절편 구현을 사람 사용성·신규 플레이어 검증과 분리한다. 자동 검증은 제품 승인이나 제작 확대를 의미하지 않는다.

```yaml
status: ANNUAL_MVP_002_MERGED_AUTOMATED_QA_PASSED_REVIEW_HARDENING
implemented_baseline: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039
annual_design: APPROVED_DESIGN_BASELINE
core_mvp_001:
  implementation: POC_BUILD_READY
  focused_suite: PASSED_IN_RUN_167
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
    pr: 76
    commit: 57c1f3d92e0fdae658826a23e5c2326fe9efe478
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
    implementation: MERGED
    documentation_run: 273_PASS
    annual_validation_run: 121_PASS
    visual_run: 51_PASS
  save_version: annual-mvp-001-save-v1
annual_mvp_002:
  issue: 88
  pr: 89
  branch: agent/annual-mvp-002-vertical-slice
  implementation: MERGED
  automated_qa: PASSED
  contract_version: annual-mvp-002-v1
  base_contract_version: annual-mvp-001-v3
  companions: 3
  max_selected_companions: 2
  unique_skills: 3
  active_unique_skills: 2
  cross_index_runtime_status: DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK
  public_support_skills: 6
  active_public_support_skills: 2
  equipment: 3
  modules: 6
  research_resources: 4
  research_nodes: 8
  max_active_research: 2
  schedule_template_slots: 3
  schedule_template_lifetime: CROSS_WEEK
  save_version: annual-mvp-001-save-v1
  save_extension_field: state.annual_mvp_002
  old_save_behavior: DEFAULT_EXTENSION_STATE
  unknown_id_behavior: PRESERVE_IN_ORPHANED_IDS_AND_IGNORE_EFFECTS
  fallback: ANNUAL_MVP_001_AND_CORE_DEFAULT
  documentation_run: 333_PASS
  annual_validation_run: 167_PASS
  visual_run: 55_PASS
  visual_artifact: 8625300008
  human_usability_qa: NOT_RUN
  new_player_validation: NOT_RUN
  POC_PASSED: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 필수 읽기

```text
AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/GAME_DESIGN_DOCUMENT.md
→ docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md
→ docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md
→ docs/superpowers/plans/2026-07-26-annual-mvp-002-vertical-slice-implementation-plan.md
→ docs/planning/ANNUAL_PROVISIONAL_DATA_BASELINE.md
→ docs/planning/ANNUAL_BENCHMARK_RECOMMENDATIONS.md
→ ANNUAL-MVP-001 데이터·StateV2·Scene·테스트
→ ANNUAL-MVP-002 데이터·Planner·State·Resolver·Adapter·Scene·테스트
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

## ANNUAL-MVP-002 구현 사실

### 격리 경계

- 신규 파일은 `data/poc/annual_mvp_002`, `scripts/poc/annual_mvp_002`, `scenes/poc/annual_mvp_002`에 둔다.
- 기존 ANNUAL-MVP-001 Scene·State·데이터 계약을 대체하지 않는다.
- 확장 데이터 또는 adapter 실패 시 기존 ANNUAL-MVP-001과 CORE 기본 동작을 유지한다.
- 기존 save version과 본편 `mvp-039`·`mvp-038`을 변경하지 않는다.

### 일정 UX

- 일정 결과 미리보기는 사용·남은 일수, 피로·역량·기관 영향을 보여준다.
- 사건 정답과 숨은 분기는 미리보기에서 공개하지 않는다.
- 지난주 복사, 전체 초기화, 한 단계 undo, 템플릿 3개를 제공한다.
- 템플릿은 주차 전환 뒤에도 유지한다.
- 주간 결과는 `무엇이 변했는가 / 왜 변했는가 / 다음 주 영향`을 표시한다.
- 직접 휴식과 자동 휴식의 차이를 인과 요약에서 명시한다.

### 동료·지원

- 동료는 오현·한세린·박도윤 3명이며 최대 2명을 선택한다.
- 오현·박도윤의 런타임 `ACTIVE` 고유 스킬은 명시 조건 충족 시 사건당 1회 확정 발동한다.
- 한세린 `교차 색인`은 데이터·이름·조건·효과를 보존하지만 `DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK`이며 선택·발동·성공 로그를 금지한다.
- 준비 화면은 `교차 색인`에 관측·가설 보드 hook 필요 사유를 표시한다.
- 공용 지원 일반 확률은 기본 + 준비 일정 10%p + 업무 신뢰 0/5/10%p이고 상한은 90%다.
- 준비도는 일반 확률에 직접 더하지 않는다.
- 적격 실패 시 준비도 +20, 실패 학습 연구 완료 시 +25다.
- 준비도 100이면 다음 적격 발동을 보장하고 성공 후 0으로 초기화한다.
- UI는 적격·비적격 사유, 확률, 준비도, 보장 거리를 공개한다.
- 신규 핵심 단서, 정답 가설, 미관측 패턴, 필수 회수 조건은 제공하지 않는다.

### 장비·연구·저장

- 주 장비 3개와 계열 호환 모듈 6개다.
- 장비·모듈은 피해·위험·표시 시간·허용 오차·회수 창만 보조한다.
- 연구 자원은 관측 기록·잔향 자료·위험 사례·기관 협력 점수 4종이다.
- 연구 노드는 8개, 동시 진행은 최대 2개다.
- 연구 시작 시 자원을 예약하고 취소 시 75%를 내림 반환한다.
- save에는 `state.annual_mvp_002` 선택 블록만 추가한다.
- 구 저장에는 기본 확장 상태를 생성한다.
- 알 수 없는 ID는 `orphaned_ids`에 보존하고 효과 계산에서는 제외한다.

## 자동 검증 사실

- 문서 run #333 PASS
- ANNUAL run #167 PASS
  - Python 데이터·활성 문서 계약
  - Godot 4.7.1 import
  - CORE-MVP-001 focused
  - ANNUAL-MVP-001 focused
  - ANNUAL-MVP-002 focused
  - 전체 Godot 회귀
- Visual run #55 PASS
  - 기존 ANNUAL-MVP-001 키보드·Esc·실제 포인터
  - ANNUAL-MVP-002 실제 포인터: 7일 편성, undo, 템플릿, W2 출동, 동료 2명, 사건 진입
  - 1280×720·1920×1080 계획 초기·미리보기·인과 요약·편성 캡처
- visual artifact `8625300008`
- 캡처 8장 직접 검사 완료: 한글 누락·겹침·핵심 정보 잘림 없음

## GDD DOCX 정책

- 편집 원본은 `docs/GAME_DESIGN_DOCUMENT.md`다.
- `tools/docs/build_game_design_doc.py`가 결정적 DOCX 미러를 생성한다.
- 생성기 포맷은 `urban-legend-gdd-index-v5`, GDD 표기는 v3.2다.
- `docs/URBAN_LEGEND_GAME_DESIGN.docx`는 Git에 추적하지 않는다.
- 생성기와 source hash·구조 계약은 Python 문서 테스트가 보호한다.

## HISTORICAL QA

- PR #65·#67의 3주 구조 렌더링·입력 QA
- PR #70의 4주×3슬롯 구현
- visual run #28, ANNUAL run #94, 전체 49/49
- 문서 run #253/#255, ANNUAL run #101/#103, Visual run #34

위 증거는 회귀 자료로 보존하지만 현재 7일·ANNUAL-MVP-002 계약의 사람 플레이 증거가 아니다.

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

1. PR #89 squash merge 완료 — commit `c790bf747c0fa4f4427d9e4b49b22adbfce92824`
2. Issue #90 / PR #91 적대적 검수 보정
3. 7일 편성·템플릿·동료·장비·지원 정보의 사람 반복 조작
4. 2주차 조기·3주차 자율·4주차 강제 사람 플레이
5. 동료별 장점과 지원 확률·준비도·보장 발동 설명 수집
6. 육성→사건→연구 인과와 장비·동료의 정답 비대체 경계 확인
7. `KEEP / AMPLIFY / CHANGE / RETEST / HOLD` 판정
8. 별도 사용자 승인 전 ANNUAL-MVP-003 시작 금지
