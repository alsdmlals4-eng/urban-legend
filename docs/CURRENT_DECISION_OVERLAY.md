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
ten_day_half_day_case_cadence: USER_APPROVED / IMPLEMENTED_NON_NUMERIC_CONTEXT / FOCUSED_MACHINE_VERIFIED
one_main_case_runtime_enforcement: IMPLEMENTED / CYCLE_LOCK_REJECTS_SECOND_OPERATION / FOCUSED_MACHINE_VERIFIED
keyword_composition: IMPLEMENTED_M01_M04 / AUTOMATED_REGRESSION_GREEN / OTHER_CASES_PENDING
player_authored_manual_keyword_verification: USER_APPROVED / IMPLEMENTED_M01_M04 / MACHINE_VERIFIED
player_authored_manual_decision: D-2026-08-29-PLAYER-AUTHORED-MANUAL-KEYWORD-VERIFICATION
m01_manual_input_consumer: IMPLEMENTED / FULLSCREEN_DOSSIER_WORKBENCH / DRAFT_ONLY
m04_manual_input_consumer: IMPLEMENTED / FULLSCREEN_DOSSIER_WORKBENCH / DRAFT_ONLY / EXISTING_THREE_CLUE_SOURCE_ONLY
m04_manual_guide: IMPLEMENTED / CASE04_LUME_FIELD_PORTRAIT / NON_ANSWER_PROCEDURAL_GUIDANCE
m01_normal_clear_manual_answer_reveal: IMPLEMENTED_FALSE / NO_AUTO_REVEAL
ten_day_half_day_case_decision: D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE
m04_week4_numeric_cadence: SUPERSEDED
m04_sequential_narrative_result_vignettes: IMPLEMENTED_M04_ONLY / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_PENDING
m04_sequential_narrative_result_decision: D-2026-08-28-M04-SEQUENTIAL-NARRATIVE-RESULT-VIGNETTES
m04_bounded_preparation_capacity: USER_APPROVED / IMPLEMENTED_M04_ONLY / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN
m04_bounded_preparation_capacity_decision: D-2026-08-30-M04-BOUNDED-PREPARATION-CAPACITY
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
ten_day_half_day_cadence: USER_APPROVED / IMPLEMENTED_NON_NUMERIC_CONTEXT / FOCUSED_MACHINE_VERIFIED
one_main_case_runtime_enforcement: IMPLEMENTED / FOCUSED_MACHINE_VERIFIED
keyword_composition: IMPLEMENTED_M01_M04 / MACHINE_VERIFIED / OTHER_CASES_PENDING
player_authored_manual_keyword_verification: USER_APPROVED / IMPLEMENTED_M01_M04 / MACHINE_VERIFIED
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

판정: `SHARED_SYSTEM_BASELINE_AND_PLAYER_AUTHORED_MANUAL_IMPLEMENTED / FINAL_VISUAL_GATE_PENDING`.

- M04-specific record/investigation/minigame/recovery IDs를 shared grammar에 연결.
- M04의 실제 사건 데이터가 세 기존 clue ID, 두 기존 rule page, rescue gate, candidate provenance를 단일 source로 보유하고 fullscreen dossier workbench가 draft-only placement를 소비한다. 강제 위험 전환을 제외한 자발 회수는 확보 기록 `2`개와 출처가 유효한 완성 매뉴얼 규칙 `1`개를 요구하며, 이 gate는 정답·오답 판정 없이 준비 정도만 표시한다.
- M04 guide는 **루메**를 표시한다. CASE-04 전용 현장 복장 초상과 짧은 비정답성 절차 안내를 사용하며, CASE-01 저승역 복장을 재사용하지 않는다.
- Composite Result axes 공유.
- M01 truth ID를 M04 current truth로 재사용하지 않는다.
- `PRODUCT_REFERENCE_ASSET_PENDING`, `final_visuals_authorized=false` 유지.

### Ten-day half-day case cadence — 2026-08-28

판정: `USER_APPROVED / IMPLEMENTED_NON_NUMERIC_CONTEXT / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_PENDING`.

- 한 cycle은 10일, 하루는 오전/오후 두 반일 슬롯이며 메인 사건은 cycle마다 하나만 해결한다.
- Day 1~9 해결은 조기 해결, Day 10 해결은 정규 해결이다. Day 10은 지연·강제 escalation·준비 상실이 아니다.
- 조기 해결은 더 이른 보호, 정규 해결은 남은 반일 준비 기회의 선택이다. 새 numeric balance는 `UNDEFINED`; 옛 2/3/4주, `0/15/30`, `0/+4/+8`은 `SUPERSEDED`이며 날짜에 환산하지 않는다.
- `CampaignState`는 첫 실제 operation에서 cycle main case를 고정하고 다른 사건의 same-cycle 계획/시작을 거부한다. dispatch kind/day/slot은 resolution까지 보존되고 Preparation docket과 M04 결과의 귀가 기억 페이지가 이를 소비한다. Day 10은 정규 대응으로 기록되며 새 수치 보정은 만들지 않는다.

### M04 bounded preparation capacity — 2026-08-30

판정: `USER_APPROVED / IMPLEMENTED_M04_ONLY / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN`.

- 공식 자료 13개를 대상으로 한 추리·사건기록·조사/지원 흐름의 역공학은 `docs/benchmarks/M04_BOUNDED_PREPARATION_CAPACITY_2026-08-30.md`가 소유한다. 이 프로젝트에는 player-authored evidence, 명시적 가용 조건, 결과의 인과 기록만 **ADAPT**하며 타 게임의 아트·서사·정확한 화면 구조는 채택하지 않는다.
- M04에서만 실제 완료된 `대기·회복` 반일이 `현장 준비 1/1`을 만든다. 아직 완료하지 않았거나 legacy save에 기록이 없으면 명시적으로 `0/1`이다.
- `support_kwon_return_route`의 기존 `fear_delta: -16 / threshold_delta: 2`와 one-use 성격은 바꾸지 않는다. 단, M04에서는 출동 context가 `1/1`일 때만 **Canon V2 작전 상태의 요원 지원 버튼**이 활성화되고, `0/1`이면 이유를 tooltip과 버튼 아래 상태 메시지로 함께 보여 준다. 이미 쓴 지원은 같은 surface에서 `사용 완료`로 남는다.
- `CampaignState` preparation ledger와 dispatch context가 이 상태를 저장한다. Preparation docket, Recovery support, M04 귀가 기억 결과 페이지가 같은 `0/1` 또는 `1/1` 사실을 소비한다.
- 이것은 수치 보너스·정답/키워드·단서·피해자 구조 결과·추가 지원 횟수·자동 발동을 만들지 않으며 M01과 다른 요원 지원을 바꾸지 않는다.

### Core-loop priority — 2026-08-29

판정: `USER_APPROVED / PLANNING_CANON / NO_RUNTIME_MUTATION`.

- **1차 플레이 경험은 조사·추리와 회수**다. 관찰 가능한 단서를 경쟁 가설과 매뉴얼에 연결하고, 전조에 맞는 대응으로 그 가설을 회수에서 검증한다.
- 키워드/매뉴얼은 추리의 표현·검증 도구다. 피해자 구출과 복합 결과는 판단의 인간적 결과를 분리해 보존한다.
- 10일·반일 일정은 준비·후일담·관계의 리듬을 제공하는 **보조 캠페인 시스템**이다. 일정은 핵심 진실/정답을 제공하거나 회수를 자동 해결하지 않으며, 일정만으로 Vertical Slice 핵심 재미를 검증하지 않는다.
- 이 우선순위는 기존 cadence 규칙이나 M01/M04의 사건 의미를 바꾸지 않는다. runtime 구현, save, 숫자 밸런스, asset, Human QA는 이번 결정으로 승인되지 않는다.

### Player-authored manual keyword verification — 2026-08-29

판정: `USER_APPROVED / IMPLEMENTED_M01_M04 / MACHINE_VERIFIED / HUMAN_QA_NOT_RUN`.

- 조사는 정상 키워드의 원본 출처와 획득 맥락을 만들고, 플레이어는 빈칸이 있는 추리문에서 그 기억·출처·문맥으로 후보를 배치한다.
- UI는 구조 불가능만 막는다. 정답/오답, 변조, 호환성, 추천 점수를 직접 알려 주지 않는다. 그럴듯한 오답은 구출 미니게임 및 회수의 `전조 → 가설 → 근거 → 대응` 결과로 검증·반증된다.
- 한 변수만 달라진 변조 후보는 별도 가짜 단서를 갖지 않는다. 사실이지만 해당 슬롯에 쓰이지 않는 보조 후보와 구분한다.
- M01에는 Canon record ID를 source로 갖는 candidate pool과 deduction segment가 구현돼 있고, M04에는 세 기존 clue ID만 source로 갖는 두 rule page와 candidate pool이 구현돼 있다. source record가 확보된 후보만 표시되며, 정답/오답, 변조, 호환성, 추천 점수는 UI·저장 데이터·policy 결과에 없다.
- full-screen dossier workbench는 `anomaly_manual_records[episode_id].draft_slots`만 저장한다. Canon V2 이관 보호 상태인 `afterlife_canon_v2.manual.filled_slots`는 빈 상태를 보존하고, `normal_clear.reveal_complete_manual`은 `false`다. M04는 별도 save version이나 answer-state를 추가하지 않는다.
- 실제 GameState/조사 씬 통합·저장 재로딩·1280×720/1920×1080 frame containment은 automated runtime-scene test로 검증했다. Human comprehension, visual acceptance, accessibility observation은 `NOT_RUN`이다.
- 사용자 제공 비교 이미지는 planning UI reference일 뿐 asset, runtime UI, Scene, product approval이 아니다.

### Contextual Lume companion and scenario costume — 2026-08-30

판정: `USER_APPROVED / CASE-01_AND_CASE-04_ASSET_IMPLEMENTED / SCENARIO_BOUND / HUMAN_QA_NOT_RUN`.

- CASE-01 조사 디바이스·현장·매뉴얼의 기록 보조 이름은 **루메**다. 전임
  블루프린트 후보에 들어간 ‘아카’ 표기는 정체성 오류로 `SUPERSEDED`다.
- M04의 전역 기관 보조도 **루메**다. M04 workbench에는 동일한 루메 정체성을 유지한 CASE-04 전용 현장 복장 초상을 표시하며, CASE-01 저승역 복장은 재사용하지 않는다.
- 루메는 귀여운 소형 치비 비율, 은빛 웨이브 머리, 큰 호박빛 눈의 정체성을
  유지한다. 성숙한 전신 요원 체형으로 대체하지 않는다.
- 복장은 입장한 사건의 장소·분위기와 맞춰 달라질 수 있다. CASE-04 빨간 우산 골목에는
  사용자 전체 승인 범위의 독립 현장 복장 후보 `M04-LUME-GUIDE-001`을 적용한다. 후속 사건은
  각 사건 ID별 독립 후보와 사용자 승인·asset manifest·consumer 검증을 거친다.
- `CASE-01 저승역` 예시의 검정·금색 도시철도 기록 보조 복장은 저승역 전용이다.
  루메는 어느 복장에서도 정답·변조·후보 적합성·미관측 정보를 알려주지 않는다.

### CASE-01 player-authored manual workbench implementation — 2026-08-30

판정: `USER_APPROVED / M01_ONLY / IMPLEMENTED / MACHINE_VERIFIED / HUMAN_QA_NOT_RUN`.

- 사용자는 2026-08-30 저승역의 기록철형 루메 매뉴얼 권장안을 승인하고 구현을
  지시했다. 세부 계약은
  `docs/superpowers/specs/2026-08-30-case01-player-authored-manual-workbench-design.md`가
  소유한다.
- 최초 slice는 M01의 후보 키워드, 빈칸 작성, 출처 표시, `anomaly_manual_records` 저장까지 구현됐다. 후보 선택은 source record 획득만 gate로 삼으며, 기존 구출·회수의 semantic evaluation을 새로 자동 해결하지 않는다. M04와 전역 화면은 이 승인에 포함하지 않는다.
- Canon V2 이관 보호 상태인 `afterlife_canon_v2.manual.filled_slots`와 save version은
  바꾸지 않는다. player-authored draft는 기존 persistent
  `anomaly_manual_records[episode_id].draft_slots`에서만 소유한다.
- `HGB-AUX-09` 루메 초상은 CASE-01 매뉴얼 UI의 `LumePortrait`에 product asset으로 적용됐다. 전체 `HGB-UI-09` screenshot은 계속 blueprint reference-only다.
- 현재 자동 증거: `tests/case01_ui/manual_keyword_composition_policy_test.gd`,
  `m01_manual_canon_contract_test.gd`, `manual_draft_persistence_test.gd`,
  `manual_deduction_workbench_test.gd`, `m01_manual_workbench_integration_test.gd`.
  Visual/human approval, device input observation, release-rights sign-off는 아직 완료 증거가 아니다.

### M04 sequential narrative result vignettes — 2026-08-28

판정: `USER_APPROVED / IMPLEMENTED_M04_ONLY / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_PENDING`.

- M04 결과를 한 scroll surface의 카드·점수·목록으로 묶지 않는다. `피해자 → 잔향 → 귀가 기억 → 기록국`의 short narrative page를 순서대로 제시한다.
- 각 페이지는 한 가지 원인과 그 여파만 다룬다. 귀가 기억 페이지에서는 조기/정규·해결일·실제 `현장 준비 0/1 또는 1/1`·실제 권나래 지원 사용만 하나의 인과로 연결한다.
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

- M01: player-authored manual의 실제 First Session comprehension / input / fatigue Human QA와 visual acceptance.
- M04: product-reference asset 승인 후 release-near player-experience Human QA.
- Base adapter: PR #226 merged-main readback 완료; runtime reconciliation 관련 추가 technical gate 없음.

실행하지 않은 Human·device·visual 검증은 PASS로 승격하지 않는다.
