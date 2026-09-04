# Current Handoff — 2026-08-10

> 상태: `FEATURE_WORK_PAUSED_BY_USER / HANDOFF_MERGED_POST_MERGE_RECONCILED`
> 현재 대상: `alsdmlals4-eng/urban-legend + alsdmlals4-eng/Base`
> 역할: 다음 세션이 과거 대화 없이 현재 저장소·PR·Sheet를 다시 읽고 안전하게 이어가기 위한 live continuation router.

## 1. Live Authority

```yaml
last_updated_kst: 2026-08-10T13:15+09:00
project:
  repo: alsdmlals4-eng/urban-legend
  default_branch: main
  current_main_source: READ_GITHUB_MAIN_REF_ON_RESUME
  handoff_delivery_pr: 187
  handoff_delivery_state: MERGED
  handoff_merge_commit: e724cd14908368b436f2e5976da57100e8414e0f
base:
  repo: alsdmlals4-eng/Base
  default_branch: main
  last_observed_main: d5cfcfa96fcf33bf7e01dc617d7f68e8d5bbbeaf
  proposal_display_name: "BCP - 괴이기록국(urban-legend)"
  proposal_id: BCP-2026-014-handoff-machine-consumer-compatibility-closeout
  proposal_status: SUBMITTED
  active_implementation: NOT_STARTED
feature_work:
  state: PAUSED_BY_USER
```

`handoff_merge_commit`은 PR #187이 실제 통합된 역사적 증거다. 이 문서는 자신을 전달하는 후속 reconciliation commit SHA를 `current main`으로 계속 추적하지 않는다. 다음 세션은 반드시 GitHub `main` ref를 다시 읽는다.

## 2. Current Decisions

- `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
- `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`
- `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`
- `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY`

`START_HERE.md`, `docs/CURRENT_STATUS.md`, `docs/CURRENT_CONFIRMED_DECISIONS.md`의 오래된 상태 문구가 GitHub·Sheet의 최신 사실과 충돌하면 최신 저장소/Sheet를 우선한다.

## 3. Completed / Merged

### PR #180

- `MERGED / HUMAN POINTER-PROGRESSION PASS`
- 조사 입력과 진행이 실제 Windows QA에서 다음 단계 및 미니게임까지 진행됨.

### PR #187

- `MERGED / HANDOFF_ONLY`
- exact pre-merge head: `e762398a349ff2658c7159c420c6e8e0314f992e`
- changed files: `docs/CURRENT_HANDOFF.md` only.
- exact-head workflows all PASS:
  - documentation `31354655174`
  - BCA `31354655165`
  - Base Adapter `31354655151`
  - core/docs/full Godot regression `31354655195`
  - ANNUAL `31354655203`
- merge commit: `e724cd14908368b436f2e5976da57100e8414e0f`.

## 4. Open Product Work — Do Not Merge During Handoff

### PR #186 — route restore

```yaml
decision: D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY
head: 4113c2d711d96b87082645acd39166ba502a1c90
route_core_human_qa: PASS
post_clear_return_flow: FAIL
merge: HELD
```

Verified route behavior:
- final safe endpoint enters from WEST;
- route manipulation works;
- actual route clear works;
- successful result persists.

Current blocker: `POST_CLEAR_RETURN_INPUT_BLOCKED`.

Observed sequence:

```text
route clear succeeds
→ result persists
→ saved-result UI shows 성공
→ visible `현장 기록으로 복귀` does not respond
→ progression blocked
```

Evidence-backed root cause to retest before changing code:
- `scripts/scenes/minigame_scene.gd` owns the visible return button and `_return_to_flow()`.
- `scripts/ui/canon_v2_operation_overlay.gd` mounts a read-only bottom detail/obligation panel.
- `_make_detail_panel()` uses `MOUSE_FILTER_STOP`.
- Human QA screenshot placed that panel over the return-control area.

Fix is `NOT_IMPLEMENTED`. Resume with a real pointer click-through RED regression first.

### PR #183 — main menu Ver 4.3

```yaml
decision: D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING
head: 42e4f378ef10aebfcd812f737bcdae33cfe8dd3f
local_visual_candidate: 757df80b00f61fc94916bcee65aa6705748fa5f7
automated: PASS
human_visual_1280_class: PASS
human_visual_1920_class: PASS
complete_input_gate: NOT_RUN
gamepad: NOT_RUN
android: NOT_RUN
merge: HELD
```

## 5. Approved Display Settings — Implementation Paused

Decision: `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`

Approved scope:
- `1280×720`
- `1600×900`
- `1920×1080`
- windowed / fullscreen
- persistence across restart
- DisplaySettings responsibility separate from AccessibilitySettings

Planning branch: `agent/display-settings-route-connectivity-design-20260810`
Planning head: `66c3e24fdffa5502a827f0265f5d1ef8e8ab21f9`
Status: `PLAN_READY / IMPLEMENTATION_NOT_STARTED / PAUSED_BY_USER`.

## 6. Gameplay → Main Menu Control — Decision Still Open

User requested a Main Menu return control, but work was paused before scope approval.

- A: gameplay screens broadly expose `메뉴`; save current progress, go to main menu, Continue returns to the saved screen.
- B: only current minigame/result flow exposes it.

Status: `USER_DECISION_REQUIRED_WHEN_RESUMED`.
Do not infer A or B as approved.

## 7. Base Proposal Result

```yaml
display_name: "BCP - 괴이기록국(urban-legend)"
proposal_id: BCP-2026-014-handoff-machine-consumer-compatibility-closeout
status: SUBMITTED
existing_solution_verdict: ABSORB
primary_owner: skills/maintaining-project-context-and-handoff/SKILL.md
supporting_owner: skills/auditing-canonical-reference-freshness/SKILL.md
canonical_machine_path: "[수정제안서]/BCP-2026-014-handoff-machine-consumer-compatibility-closeout/PROPOSAL.md"
initial_storage_pr: 236
naming_alignment_pr: 241
canonical_wording_correction_pr: 244
last_observed_base_main: d5cfcfa96fcf33bf7e01dc617d7f68e8d5bbbeaf
active_base_implementation: NOT_STARTED_IN_THIS_STAGE
```

사용자 표시명은 `BCP - 프로젝트 이름` 규칙을 따른다. 현재 Base validator는 Proposal ID와 Registry path 일치를 요구하므로 machine canonical path는 BCP-ID 경로를 유지한다. 긴 원본 제안과 Urban Legend/Ten-Paces 증거는 동일 BCP evidence 경로에 보존됐다.

관련 제안 `BCP-2026-013-post-merge-continuation-state-reconciliation`은 별도 lifecycle edge로 유지된다. 이번 post-merge reconciliation이 바로 그 원칙을 적용한 사례다.

## 8. Verification Boundary

```yaml
route_pr186_exact_head_ci: PASS
route_human_core_windows_1280x720: PASS
post_clear_return_flow_human_qa: FAIL
pr183_automated: PASS
pr183_local_visual_1280_class: PASS
pr183_local_visual_1920_class: PASS
pr183_complete_human_input_gate: NOT_RUN
gamepad: NOT_RUN
android: NOT_RUN
display_settings_implementation: NOT_RUN
main_menu_return_design_approval: NOT_RUN
base_bcp014_proposal_storage_and_naming: PASS
base_bcp014_active_implementation: NOT_RUN
handoff_pr187_exact_head_ci: PASS
handoff_pr187_merge: PASS
```

`NOT_RUN`을 PASS로 승격하지 않는다.

## 9. Resume Read Order

새 세션에서 사용자가 기능 작업 재개를 요청하면 먼저 다음을 다시 읽는다.

```text
1. urban-legend current main ref / latest commit
2. open PRs, 특히 #186/#183와 최신 comments/checks
3. Base current main + BCP-2026-013/014 + handoff owner
4. Google Sheet 00_프로젝트_허브 / 98_Base_반영후보
5. docs/CURRENT_HANDOFF.md
6. scripts/scenes/minigame_scene.gd
7. scripts/ui/canon_v2_operation_overlay.gd
8. PR186 route source/test
9. display planning branch 66c3e24f and PR183 42e4f378
```

GitHub/Sheet와 이 파일이 다르면 먼저 live authority를 교정한다.

## 10. Next Executable Product Step — Only After User Resumes

1. current project main / PR186 / Base / Sheet 재조회.
2. `POST_CLEAR_RETURN_INPUT_BLOCKED` 같은 조건 재현.
3. 실제 포인터 click-through RED regression 작성.
4. read-only CanonV2 detail panel만 pointer passthrough가 되도록 최소 input-policy 수정.
5. confirmation/backdrop 등 실제 상호작용 layer의 pointer blocking은 보존.
6. focused regression + maintained suites + exact-head PR CI.
7. Windows Human QA: route clear → `현장 기록으로 복귀` 실제 클릭 → 다음 battle/recovery 전환 확인.
8. 그 뒤에만 PR186 merge gate 재판정.
9. Main Menu return-control 범위를 사용자와 확정.
10. 이후 approved display settings implementation 재개.

## 11. Stop Conditions

- 기능 수정은 현재 중단 상태다.
- product `.gd` / Scene / data / asset 구현 금지.
- PR #186 / #183 merge 금지.
- Main Menu return 범위 임의 확정 금지.
- display implementation 시작 금지.
- persistent `.gd` 저작 재개 시 HiGodot authority 재확인.
- Base 활성 Skill/Docs/Template/Test/Tool/Workflow 구현 금지; BCP-2026-014 활성 구현은 별도 승인 단계다.

## 12. Historical Compatibility Anchors

아래 값은 현재 버전/상태가 아니라 기존 machine consumers가 요구하는 역사·호환 앵커다.

```yaml
historical_compatibility_only: true
annual_design: APPROVED_DESIGN_BASELINE
ANNUAL-MVP-001: HISTORICAL_COMPATIBILITY_ANCHOR
POC_PASSED: NOT_DECLARED
legacy_baseline_tokens:
  - CORE-VALIDATION-001
  - UX-PD-001 2A
  - Ver 4.2
  - mvp-039
```

`Ver 4.2`는 현재 제품 버전 선언이 아니다. PR #183의 승인된 목표는 Ver 4.3이며 아직 Draft/미병합이다.
