# 괴이기록국 Current Handoff

> 상태: `PLANNING_COMPLETE / USER_APPROVED_VISUAL_DIRECTION_LOCK / RUNTIME_RECONCILIATION_MERGED / HUMAN_QA_PENDING`
> latest-main reconciliation: PR #322 merge `9fa32d32e8a5a2ad7d34a388695986b4ab81c6a7` (runtime implementation: `8d303f0f9414950273be934fd28c8fb1b3a21e18` · PR #224)
> 사람용 정본: repository `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`와 user PDF GDD
> 구조화 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`
> Notion 이전 영수증: `docs/migrations/NOTION_CURRENT_WORK_MIGRATION_2026-08-28.md` (Notion은 `HISTORICAL_READ_ONLY_NO_WRITE`)

이 문서는 다음 GPT/Codex가 구현 전 handoff나 과거 annual next-step을 현재 권한으로 오인하지 않도록 하는 continuation router다. 실제 구현 사실은 latest `main`의 code/data/Scene/test를 우선한다.

```yaml
status: RUNTIME_RECONCILIATION_MERGED
planning: COMPLETE
user_final_planning_declaration: APPROVED
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
runtime_implementation: MERGED_MAIN
runtime_merge_commit: 8d303f0f9414950273be934fd28c8fb1b3a21e18
product_reference_asset: PENDING
visual_direction_lock: USER_APPROVED
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
ten_day_half_day_cadence: USER_APPROVED / IMPLEMENTED_NON_NUMERIC_CONTEXT / FOCUSED_MACHINE_VERIFIED
one_main_case_runtime_enforcement: IMPLEMENTED / FOCUSED_MACHINE_VERIFIED
keyword_composition: IMPLEMENTED_M01_M04 / DRAFT_ONLY / FOCUSED_MACHINE_VERIFIED / OTHER_CASES_PENDING
player_authored_manual_keyword_verification: USER_APPROVED / IMPLEMENTED_M01_M04 / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN
primary_playable_core: INVESTIGATION_DEDUCTION_AND_RECOVERY
calendar_role: SUPPORTING_CAMPAIGN_CONTEXT_NOT_PRIMARY_FUN
```

`PLAN_LOCK`은 predecessor 기획 잠금 식별자이며 현재 값은 `RELEASED_TO_IMPLEMENTATION_GATE`다. 이를 runtime 미승인 상태로 되돌려 해석하지 않는다.

현재 시각 방향은 `D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION`의 **현실적 한국 도시 누아르 환경 + 애니풍 인물·괴이 + 손그림 기록물 UI**다. 이 방향은 `docs/visual/VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md`가 소유하며, 첨부 Core Scene Board는 기획 검증용 `GENERATED_EXPLORATION`일 뿐 runtime asset/Scene/UI/Human QA가 아니다.

현재 accepted frontier는 `D-2026-08-29-PLAYER-AUTHORED-MANUAL-KEYWORD-VERIFICATION`, `D-2026-08-29-CORE-LOOP-PRIORITY`, `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE`, `D-2026-08-28-M04-SEQUENTIAL-NARRATIVE-RESULT-VIGNETTES`, `D-2026-08-28-VISUAL-CANDIDATE-GENERATION-LOCK-ONLY-APPROVAL`다. **1차 플레이 경험은 조사·추리와 회수**이며, M01과 M04는 원본 출처가 남은 정상 키워드를 만들고 플레이어가 빈칸 추리문을 직접 채운다. 매뉴얼은 정답·변조·호환 점수를 알려 주지 않으며, 구출 미니게임과 `전조 → 가설 → 근거 → 대응` 회수 결과에서만 후보 규칙을 검증한다. M04는 세 기존 clue ID와 두 기존 rule page를 사건 데이터 하나에서 소비하며, 기록관 아카는 텍스트 안내만 제공한다. 10일·반일 일정은 준비·후일담·관계의 리듬을 주는 보조 캠페인 시스템이다. 현재 `CampaignState`는 첫 operation을 cycle main case로 고정하고 다른 사건의 same-cycle 계획/시작을 거부하며, dispatch kind/day/slot을 M04의 `피해자 → 잔향 → 귀가 기억 → 기록국` 순차 후일담까지 보존한다. 예전 M04 주차 수치와 tier bonus는 `SUPERSEDED`; 새 숫자는 user decision 전 `UNDEFINED`다. M05+ keyword/manual 확장, M01/M04 entrance candidate의 최종 user `LOCK`, Human/new-player/accessibility/release QA는 여전히 별도 Gate다.

## 1. 재개 순서

```text
최신 사용자 지시
→ GitHub latest main + open PR/Issue + exact-head CI
→ repository current GDD / decision / handoff
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ 실제 current code/data/Scene/test
→ 필요 시 2026-08-22 design/implementation plan과 역사 Ledger
```

## 2. 현재 구현된 제품 계약

- primary playable core: `INVESTIGATION → DEDUCTION / MANUAL → RECOVERY`; the calendar is supporting campaign context, not primary fun.
- approved cadence: `ONE_MAIN_CASE_PER_TEN_DAY_CYCLE / TWO_HALF_DAY_SLOTS_PER_DAY`; runtime implements the first-operation cycle lock, persisted non-numeric dispatch context, and Preparation docket; numeric balance remains undefined.
- result authority: `COMPOSITE_RESULT`.
- legacy S/A/B/S grade는 history/mastery compatibility이며 current incident result를 덮어쓰지 않는다.
- additive optional `monthly_state`는 historical generic orchestration이며 case truth를 저장하지 않는다. 새 10일 timing consumer를 아직 소유하지 않는다.
- M01 저승역은 `M01_FIRST_SESSION` 10단계 causal orchestration과 `SERIAL_EXAM_FATIGUE_GUARD`를 사용한다.
- M01은 기존 Canon v2 loader/save migration/result runtime을 재사용한다.
- 메인 메뉴 제품 버전은 `scripts/core/product_version.gd`의 `Ver 4.3`이 중앙 owner다.
- 메인 메뉴는 관제실형 3-rail 구조를 사용하고 Legacy / Validation save·route 분리를 유지한다.
- M04 빨간 우산은 shared Investigation/Manual/Rescue/Recovery/Composite Result validation baseline까지 구현됐다.
- current keyword/manual state is split by coverage: CASE-01 and M04 page-local keyword composition are `IMPLEMENTED / MACHINE_VERIFIED`, while M05+ rollout and any mutated-candidate field-verification extension remain outside this slice.
- clarified manual contract: the player must fill readable blank sentences from investigation memory and provenance; the UI cannot reveal semantic correctness. Rescue/minigame and recovery are the field verification, not an automatic answer checker. CASE-01 and M04 candidate arrays/input consumers are implemented, CASE-01 complete-manual auto-reveal is disabled, and every player draft remains separate from Canon migration slots.

## 3. PR #224 postmerge Reality Gate

완료:
- `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED` → `REALIGNED_TO_LEGACY_MASTERY_COMPATIBILITY`.
- `MONTHLY_STATE_NOT_IMPLEMENTED` → `IMPLEMENTED_ADDITIVE_OPTIONAL`.
- M01 First Session orchestration → `IMPLEMENTED`.
- #181 main menu / Ver 4.3 → `IMPLEMENTED`; Issue #181 closed after merged-main readback.
- M04 shared-system validation baseline → `IMPLEMENTED`.

보존:
- 기존 Episode/victim/report/ANNUAL IDs rename 금지.
- legacy report만으로 month completion 추론 금지.
- 필수 진실을 성장·동료·장비·자동행동이 제공하지 않음.
- Human PASS를 자동화로 생성하지 않음.

## 4. 자동 검증 증거

PR #224 exact head에서 다음 계열이 GREEN이었다.
- core and documentation baseline
- full matrix
- Afterlife Station Canon v2 migration
- Canon v2 Runtime UX
- ANNUAL-MVP-001 / CORE-MVP-001
- Windows platform preflight
- documentation contracts
- visual capture automation

`Project Base Adapter`의 fail-closed 신호는 PR #226에서 공식 Base generator로 reconciliation했다. protected baseline은 `6b4a9e8080898536139c8e825179b389f8bf9d64`으로 갱신됐고, adapter/generated views 검증과 core full Godot regression이 GREEN인 exact head를 `9073b4730993149f89970a13fbe32d49f8f473e7`로 병합했다.

## 5. Product reference / Human gate

### 2026-08-28 visual-status clarification

`PRODUCT_REFERENCE_ASSET_PENDING`은 모든 자산이 미승격이라는 뜻이 아니다. 개별 제품 승인·runtime 상태는 `ASSET_MANIFEST.yml`과 `CURRENT_VISUAL_WORK_ORDER.md`가 소유한다. 현재 root manifest의 9개 entry 중 M01 Investigation/Recovery background, M01 B/C·D cutout, CASE-01 루메 매뉴얼 보조 초상, M04 Investigation/Recovery background, M04 B/C·D cutout은 각각의 승인·구현·runtime evidence를 가진다. 반면 M01 Entrance, M04 Entrance와 Human/new-player/accessibility/release QA는 별도 Gate에 남는다.


`PRODUCT_REFERENCE_ASSET_PENDING` 유지:
- concrete M01/M04 이미지·레이어
- rights/source approval
- 최종 1280×720 / 1920×1080 가독성
- release-near M04 visual/audio/VFX polish

Exception recorded: M01 D-risk `afterlife_d_cutout.png` is `PROJECT_ASSET_APPROVED / IMPLEMENTED / 1280_RUNTIME_VERIFIED` under Issue #246. Its 1920×1080 capture and Human QA remain pending; this exception does not promote other M01/M04 assets.

Human QA는 계속 `NOT_RUN`:
- M01 첫 세션 이해도
- serial-exam fatigue 체감
- M04 재미/첫인상/차별화
- 접근성·실제 입력 체감

## 6. Base governance reconciliation 완료

- PR #226에서 project-pinned Base generator를 사용해 adapter + generated views를 갱신했다.
- protected baseline: `6b4a9e8080898536139c8e825179b389f8bf9d64`.
- reconciliation merge: `9073b4730993149f89970a13fbe32d49f8f473e7`.
- 제품 `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot` 재변경 없이 Project Base Adapter 및 Base 9.4.x 검증을 GREEN으로 닫았다.
- 남은 제품 Gate는 실제 Human QA와 product-reference asset 승인/후속 release-near 구현이다.

## 7. 이전 구현 계약의 역할

다음 문서는 완료된 구현의 설계·계획 provenance로 보존한다.
- `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`
- `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

이 문서들을 다시 Task 1부터 실행하지 않는다. 새 작업은 latest main의 실제 상태에서 successor를 판정한다.

## 8. 완료 판정 경계

현재 **runtime reconciliation implementation은 main 병합 완료**다. 그러나 프로젝트 전체 제품 완료를 의미하지 않는다.

```yaml
runtime_reconciliation: COMPLETE_MERGED
human_qa: NOT_RUN
product_reference_asset: PENDING
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
```
