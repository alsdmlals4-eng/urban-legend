# 괴이기록국 Current Decision Overlay

> 문서 역할: `CURRENT_MUTABLE_DECISION_OVERLAY`
> 상태: `CURRENT / PLANNING_COMPLETE / USER_APPROVED_VISUAL_DIRECTION_LOCK / RUNTIME_RECONCILIATION_MERGED`
> 갱신 기준: PR #322 merge commit `9fa32d32e8a5a2ad7d34a388695986b4ab81c6a7` + merged-main canon readback (runtime merge `8d303f0f9414950273be934fd28c8fb1b3a21e18`)
> 상세 역사 결정 원장: `docs/CURRENT_CONFIRMED_DECISIONS.md`

이 파일은 현재 작업자가 즉시 판단해야 하는 mutable decision과 verified successor state만 소유한다. 역사 원장이 current state와 충돌하면 최신 사용자 지시 → GitHub latest main → repository current GDD / `CURRENT_PLANNING_CANON.md` / `current-planning-canon.json` → 이 Overlay 순으로 해석한다.

## 1. 현재 제품 구조

```yaml
cadence: TEN_DAY_CYCLE / TWO_HALF_DAY_SLOTS_PER_DAY / ONE_MAIN_CASE_PER_CYCLE
initial_slate: M01_TO_M12
continuous_after_m12: true
signature_cases: [M01, M04, M07, M10]
first_session: M01_AFTERLIFE_STATION
release_near_vertical_slice: M04_RED_UMBRELLA
primary_playable_core: INVESTIGATION_DEDUCTION_AND_RECOVERY
calendar_role: SUPPORTING_CAMPAIGN_CONTEXT_NOT_PRIMARY_FUN
core_flow: INVESTIGATION_DEDUCTION_MANUAL_RESCUE_RECOVERY_COMPOSITE_RESULT
core_loop_priority_decision: D-2026-08-29-CORE-LOOP-PRIORITY
visual_treatment: SOFT_ANIME_NOIR_LOCKED
presentation_language: DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM
visual_direction_lock: USER_APPROVED
visual_direction_decision: D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION
ten_day_half_day_case_cadence: USER_APPROVED / IMPLEMENTATION_CONTRACT_PENDING
one_main_case_runtime_enforcement: NOT_IMPLEMENTED / CURRENT_RUNTIME_ALLOWS_M01_M04_M07_IN_ONE_DEMO_CYCLE
keyword_composition: APPROVED_DESIGN / NOT_IMPLEMENTED
ten_day_half_day_case_decision: D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE
m04_week4_numeric_cadence: SUPERSEDED
m04_sequential_narrative_result_vignettes: USER_APPROVED
m04_sequential_narrative_result_decision: D-2026-08-28-M04-SEQUENTIAL-NARRATIVE-RESULT-VIGNETTES
```

## 2. 현재 Gate

```yaml
PLANNING_COMPLETE: true
USER_FINAL_PLANNING_DECLARATION_APPROVED: true
non_visual_planning: COMPLETE
visual_planning: COMPLETE
visual_direction_lock: USER_APPROVED
product_reference_asset: PENDING
overall_plan: COMPLETE
runtime_implementation: MERGED_MAIN
runtime_merge_commit: 8d303f0f9414950273be934fd28c8fb1b3a21e18
canonical_root_runtime_receipt: AUTOMATED_EXACT_HEAD_GREEN
ten_day_half_day_cadence: USER_APPROVED / NOT_IMPLEMENTED
one_main_case_runtime_enforcement: NOT_IMPLEMENTED
keyword_composition: APPROVED_DESIGN / NOT_IMPLEMENTED
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
```

## 3. Verified successor state

### Canon v2 / Composite Result

판정:
- `EXISTING_CANON_V2_RUNTIME_REUSE` 유지.
- `COMPOSITE_RESULT`가 current result authority.
- legacy S/A/B/S grade는 history/mastery compatibility로만 보존.
- PR #224에서 stale current-like S-rank ownership을 realign 완료.

### monthly_state

판정: `IMPLEMENTED_ADDITIVE_OPTIONAL`.

- top-level optional orchestration state.
- legacy report에서 month completion을 추론하지 않는다.
- case truth를 저장하지 않는다.
- 같은 달 해결 뒤 두 번째 main case를 막는다.

### M01 First Session

판정: `IMPLEMENTED / AUTOMATED_REGRESSION_GREEN`.

- 10단계 causal orchestration을 사용한다.
- 조사에서 얻은 기록/규칙을 추리→구출→회수에 재사용한다.
- `correct_response_id` 같은 별도 hidden truth ownership을 orchestrator에 만들지 않는다.
- Human comprehension / serial-exam fatigue 체감은 `NOT_RUN`.

### 메인 메뉴 Ver 4.3 — #181

판정: `IMPLEMENTED / ISSUE_181_CLOSED`.

- `scripts/core/product_version.gd`가 제품 버전 중앙 owner.
- direct `Ver 4.2` ownership 제거.
- 관제실형 3-rail UI 구현.
- Legacy / Validation route 및 save isolation 유지.
- keyboard focus 계약 유지.
- Human/UI usability는 `NOT_RUN`.

### M04 release-near preparation

판정: `SHARED_SYSTEM_BASELINE_IMPLEMENTED / FINAL_VISUAL_GATE_PENDING`.

- M04-specific record/investigation/minigame/recovery IDs를 shared grammar에 연결.
- Composite Result axes 공유.
- M01 truth ID를 M04 current truth로 재사용하지 않는다.
- `PRODUCT_REFERENCE_ASSET_PENDING`, `final_visuals_authorized=false` 유지.

### Ten-day half-day case cadence — 2026-08-28

판정: `USER_APPROVED / PLANNING_CANON / IMPLEMENTATION_CONTRACT_PENDING`.

- 한 cycle은 10일, 하루는 오전/오후 두 반일 슬롯이며 메인 사건은 cycle마다 하나만 해결한다.
- Day 1~9 해결은 조기 해결, Day 10 해결은 정규 해결이다. Day 10은 지연·강제 escalation·준비 상실이 아니다.
- 조기 해결은 더 이른 보호, 정규 해결은 남은 반일 준비 기회의 선택이다. 새 numeric balance는 `UNDEFINED`; 옛 2/3/4주, `0/15/30`, `0/+4/+8`은 `SUPERSEDED`이며 날짜에 환산하지 않는다.
- `CampaignState`의 10일/오전·오후 구조는 구현되어 있지만 timing record, Preparation docket, Day 10 판정, M04 result consumer는 구현되지 않았다.

### Core-loop priority — 2026-08-29

판정: `USER_APPROVED / PLANNING_CANON / NO_RUNTIME_MUTATION`.

- **1차 플레이 경험은 조사·추리와 회수**다. 관찰 가능한 단서를 경쟁 가설과 매뉴얼에 연결하고, 전조에 맞는 대응으로 그 가설을 회수에서 검증한다.
- 키워드/매뉴얼은 추리의 표현·검증 도구다. 피해자 구출과 복합 결과는 판단의 인간적 결과를 분리해 보존한다.
- 10일·반일 일정은 준비·후일담·관계의 리듬을 제공하는 **보조 캠페인 시스템**이다. 일정은 핵심 진실/정답을 제공하거나 회수를 자동 해결하지 않으며, 일정만으로 Vertical Slice 핵심 재미를 검증하지 않는다.
- 이 우선순위는 기존 cadence 규칙이나 M01/M04의 사건 의미를 바꾸지 않는다. runtime 구현, save, 숫자 밸런스, asset, Human QA는 이번 결정으로 승인되지 않는다.

### M04 sequential narrative result vignettes — 2026-08-28

판정: `USER_APPROVED / PLANNING_CANON / IMPLEMENTATION_NOT_AUTHORIZED`.

- M04 결과를 한 scroll surface의 카드·점수·목록으로 묶지 않는다. `피해자 → 잔향 → 귀가 기억 → 기록국`의 short narrative page를 순서대로 제시한다.
- 각 페이지는 한 가지 원인과 그 여파만 다룬다. 귀가 기억 페이지에서는 조기/정규·해결일·실제 권나래 지원 사용만 하나의 인과로 연결한다.
- Day 10 정규 해결을 벌점으로 되돌리지 않고, 구출·회수·추리·보상·M01의 의미를 변경하지 않는다. logical page는 새 Godot Scene, asset, runtime/Human QA PASS가 아니다.

### M04 predecessor decisions — 2026-08-28

`D-2026-08-28-M04-ONE-DELAY-PREPARATION-VICTIM-RISK-TRADEOFF`, `D-2026-08-28-M04-ROUTE-MEMORY-ANCHOR-PREPARATION-BENEFIT`, `D-2026-08-28-M04-BOUNDED-FORCED-DISPATCH-REACHABILITY`, `D-2026-08-28-M04-EARLY-DISPATCH-REGULAR-WEEK4-CADENCE`는 `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE`로 current authority를 넘긴 historical predecessor다. 원문·승인 계보는 각 decision file에 보존하고, 현재 판단에는 사용하지 않는다.

### Visual direction lock — 2026-08-28

판정: `USER_APPROVED / PLANNING_ONLY`.

- 현실적 한국 도시 누아르 환경 + 애니풍 인물·괴이 + 손그림 기록물 UI의 혼합 문법을 현행 `SOFT_ANIME_NOIR_LOCKED`의 구체화로 채택했다.
- `docs/visual/VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md`의 Keep/Avoid/Do Not Drift가 후속 시각 자료에 적용된다.
- `PROJECT_CORE_SCENE_VISUAL_BOARD`는 AI 이해/기획 검토용 생성 보드다. 자체로 product asset, Godot UI/Scene 구현, target-resolution PASS, Human/Player Experience PASS를 만들지 않는다.

### Visual candidate generation / lock-only approval — 2026-08-28

판정: `USER_APPROVED / PROJECT_WORKFLOW_POLICY`.

- consumer brief·visual lock·reuse/rights preflight가 있으면 후보 이미지는 사전 건별 승인 없이 생성·검수한다.
- 사용자에게는 후보의 `LOCK / REVISE / REJECT`만 요청한다.
- 후보 생성은 product asset promotion, runtime wiring, Human QA를 의미하지 않는다.

## 4. 자동 검증

PR #224 exact head에서 core/docs, full matrix, Canon v2 migration/runtime UX, ANNUAL/CORE, Windows platform preflight, documentation 및 visual capture 계열이 GREEN이었다.

`Project Base Adapter`의 protected-path fail-closed 신호는 PR #226에서 project-pinned Base generator로 reconciliation 완료했다. protected baseline `6b4a9e8080898536139c8e825179b389f8bf9d64`, reconciliation merge `9073b4730993149f89970a13fbe32d49f8f473e7` 기준으로 adapter 및 Base 9.4.x 검증이 GREEN이다.

## 5. Workspace authority

- Repository: 사람이 보는 전체 그림, Flow, 비교표, 구조화 기획 계약, 구현, 테스트, runtime evidence의 단일 owner.
- Notion / Google Sheet: `HISTORICAL_READ_ONLY_NO_WRITE` legacy inventory. 현재 Notion 구조·작업물과 Notion-only reference mockup은 `docs/migrations/NOTION_CURRENT_WORK_MIGRATION_2026-08-28.md`에 이전·등록했다.

Notion의 과거 상태 동기화는 historical record다. 신규 변경은 repository commit/push/remote readback으로만 확인한다.

## 6. Base authority / governance reconciliation

프로젝트가 채택한 Base 릴리스·payload·trusted evidence·registry hash는 `docs/BASE_RULES_VERSION.md`와 `skills/PROJECT_BASE_ADAPTER.json`이 소유한다.

PR #226에서 공식 Base generator로 snapshot / compatibility views / dashboard를 함께 갱신했고, protected baseline `6b4a9e8080898536139c8e825179b389f8bf9d64`을 merged main에 고정했다. 이 runtime reconciliation 관련 Base governance 후속은 `COMPLETE`다.

## 7. 구현 provenance

완료된 구현의 설계·계획 근거로 다음을 보존한다.
- `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`
- `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

이들은 현재 next-step owner가 아니라 구현 provenance다.

## 8. Issue authority

Issue #181은 merged-main readback 뒤 `completed`로 닫혔다. 새 Issue/PR의 open 상태만으로 구현 권한이나 current truth를 만들지 않는다.

## 9. 다음 검증 진입점

- M01: 실제 First Session comprehension / input / fatigue Human QA.
- M04: product-reference asset 승인 후 release-near player-experience Human QA.
- Base adapter: PR #226 merged-main readback 완료; runtime reconciliation 관련 추가 technical gate 없음.

실행하지 않은 Human·device·visual 검증은 PASS로 승격하지 않는다.
