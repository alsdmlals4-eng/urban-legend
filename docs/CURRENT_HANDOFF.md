# Current Handoff — 2026-08-10

> 상태: `FEATURE_WORK_PAUSED_BY_USER / HANDOFF_CHECKPOINT`
> 현재 대상: `alsdmlals4-eng/urban-legend + alsdmlals4-eng/Base`
> 이 문서는 현재 상태·위험·읽기 순서·다음 실행 단계만 압축하는 인수인계 라우터다. 저장소/GitHub/Google Sheet가 더 최신이면 그 사실을 우선한다.

## 1. Baseline

```yaml
last_updated_kst: 2026-08-10T11:55+09:00
project:
  repo: alsdmlals4-eng/urban-legend
  default_branch: main
  main_sha: 8294aa2eefe03fa7669617675516c9f03f739076
  main_fact: PR180 merged
base:
  repo: alsdmlals4-eng/Base
  default_branch: main
  main_sha: 637dad32c773c56a27d44d847518580848dee493
handoff:
  branch: agent/handoff-checkpoint-20260810
  feature_work_paused_by_user: true
```

## 2. Authority / Decisions

- `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
- `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`
- `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`
- `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY`

주의:

- `START_HERE.md`, `docs/CURRENT_STATUS.md`, `docs/CURRENT_CONFIRMED_DECISIONS.md`에는 과거 상태가 남아 있다. 현재 작업 재개 시 오래된 상태 문구를 GitHub/Sheet보다 높은 사실로 사용하지 않는다.
- 현재 상태는 `latest main + open PR + 최신 PR comment + Google Sheet + 이 Handoff`를 대조한다.
- 새 중복 Handoff/Progress owner를 만들지 않는다.

## 3. PR Influence Map

### PR #180 — COMPLETED_VERIFIED / MERGED

- Decision: `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
- merged main: `8294aa2eefe03fa7669617675516c9f03f739076`
- Windows Human QA에서 조사 포인터/진행이 실제로 다음 단계와 미니게임까지 진행됨.

### PR #186 — COMPLETED_NOT_MERGED / BLOCKED

- Decision: `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY`
- Draft, branch `agent/route-endpoint-connectivity-20260810`
- exact implementation head: `4113c2d711d96b87082645acd39166ba502a1c90`
- Windows QA integration candidate: `3502d8db45504d205a37fdad593192cfffeb545a`
- exact-head CI GREEN: `31350458351 / 31350458345 / 31350458344 / 31350458335`
- Human route core PASS: WEST safe endpoint, actual manipulation, actual clear, persisted successful result.
- latest Human QA evidence: PR comment `5235366964`.
- blocker: `POST_CLEAR_RETURN_INPUT_BLOCKED`.
- PR body is stale relative to latest comments.
- merge: HELD.

### PR #183 — COMPLETED_NOT_MERGED / HUMAN_QA_INCOMPLETE

- Decision: `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`
- Draft, branch `agent/main-menu-control-room-v43-implementation-20260809`
- exact implementation head: `42e4f378ef10aebfcd812f737bcdae33cfe8dd3f`
- local visual candidate: `757df80b00f61fc94916bcee65aa6705748fa5f7` (`LOCAL_EVIDENCE`, not PR head)
- automated implementation-head evidence: GREEN.
- Human visual evidence: 1280-class PASS, 1920-class PASS, Ver 4.3/control-room hierarchy PASS.
- remaining Human/input contract includes mouse/keyboard/gamepad; Android NOT_RUN.
- merge: HELD.

### Other open PRs

- `#165`: separate audit/governance work; do not fold into paused runtime fixes without scope review.
- `#149`: separate Human-QA save-runner Draft; reference only unless explicitly resumed.

## 4. Progress Classification

```yaml
completed_verified:
  - PR180 merged and Windows pointer/progression Human QA passed
  - PR186 route endpoint/reachability exact-head CI green
  - PR186 route endpoint/core Windows Human QA passed
  - PR183 local 1280-class and 1920-class visual QA passed
completed_not_merged:
  - PR186 route implementation head 4113c2d7
  - PR183 main-menu implementation head 42e4f378
in_progress_paused_by_user:
  - POST_CLEAR_RETURN_INPUT_BLOCKED root cause isolated; no fix authored
  - Main Menu return control request captured; design scope not approved
  - display resolution/window-mode implementation not started
blocked:
  - PR186 merge blocked by post-clear return input failure
  - PR183 merge blocked by remaining Human/input/Android evidence
not_started:
  - display settings implementation
  - main-menu-return implementation
user_decision_required:
  - when feature work resumes, choose Main Menu return-control scope; no choice was approved before pause
```

## 5. Runtime Finding — Do Not Lose

`POST_CLEAR_RETURN_INPUT_BLOCKED` is separate from route reachability.

```text
route puzzle solves successfully
→ result is saved
→ saved-result UI shows 성공
→ visible `현장 기록으로 복귀` button does not respond
→ progression stops
```

Evidence:

- `scripts/scenes/minigame_scene.gd`: return button exists, is connected to `_return_to_flow()`, becomes visible after result; successful route should go to `res://scenes/battle_scene.tscn`.
- `scripts/ui/canon_v2_operation_overlay.gd`: rescue-mode overlay mounts; root/SafeArea/RootLayout are pointer-transparent but `_make_detail_panel()` gives read-only detail panels `MOUSE_FILTER_STOP`.
- Human QA shows bottom read-only `ObligationPanel` over the return-control area.

Fix is NOT implemented. Resume with a real click-through RED regression before changing the overlay input policy.

## 6. Approved Display Settings — Paused

Decision: `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`

Approved: `1280×720 / 1600×900 / 1920×1080`, windowed/fullscreen, persistence, separate DisplaySettings ownership.

```text
planning branch: agent/display-settings-route-connectivity-design-20260810
HEAD: 66c3e24fdffa5502a827f0265f5d1ef8e8ab21f9
status: PLAN_READY / IMPLEMENTATION_NOT_STARTED / PAUSED_BY_USER
```

## 7. Main Menu Return Control — Not Yet Approved Design

User requested a gameplay → main-menu control. Work paused before scope choice:

- A: broadly on gameplay screens; save, menu, Continue returns to saved screen.
- B: only around current minigame/result flow.

Status: `USER_DECISION_REQUIRED_WHEN_RESUMED`.
Do not infer that A was approved.

## 8. Verification State

```yaml
project_main_8294aa2e: PASS
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
```

`NOT_RUN`을 PASS로 승격하지 않는다.

## 9. Resume Read Order

```text
1. urban-legend latest main SHA
2. open PRs, 특히 #186/#183와 최신 comments/checks
3. Base latest main SHA + maintaining-project-context-and-handoff owner
4. Google Sheet 00_프로젝트_허브
5. docs/CURRENT_HANDOFF.md
6. scripts/scenes/minigame_scene.gd
7. scripts/ui/canon_v2_operation_overlay.gd
8. PR186 route source/test
9. display planning branch 66c3e24f and PR183 42e4f378
```

저장된 SHA가 GitHub와 다르면 먼저 Handoff를 stale로 표시하고 current truth로 교정한다.

## 10. Next Executable Step — Only After User Resumes Feature Work

1. latest project main / PR186 / Base / Sheet 재조회.
2. `POST_CLEAR_RETURN_INPUT_BLOCKED` same-condition 재현.
3. 실제 포인터 click-through RED regression 작성.
4. read-only CanonV2 detail panel만 pointer passthrough가 되도록 최소 수정; 실제 confirmation/backdrop 상호작용은 보존.
5. focused regressions + relevant suites + exact-head PR CI.
6. Windows Human QA: route clear → `현장 기록으로 복귀` 클릭 → battle/recovery 전환 확인.
7. 그 뒤 PR186 gate 재판정.
8. Main Menu return-control 범위를 사용자와 확정.
9. 그 다음 display settings implementation 재개.

## 11. Stop Conditions

- 현재 사용자 지시: 기능 수정 중단, 인수인계만 수행.
- product `.gd` / Scene / data / asset 구현 금지.
- PR #186 / #183 merge-ready 전환·merge 금지.
- Main Menu return 범위 임의 확정 금지.
- display implementation 시작 금지.
- persistent `.gd` 저작 재개 시 HiGodot authority 재확인.

## 12. Base Existing-Solution Verdict / Learning

```yaml
handoff_operating_pattern:
  verdict: REUSE
  base_owner: skills/maintaining-project-context-and-handoff/SKILL.md
  new_project_handoff_skill: NO
  new_base_candidate_for_this_checkpoint: NO_PROMOTION
```

현재 runtime findings는 프로젝트 고유 구현/QA 상태다. 이 인계만을 위해 새 Base Skill/BCP를 만들지 않는다.

## 13. Freshness Conflict

직전 Sheet의 Base remote보다 Base main이 전진했다. 현재 확인 Base main:

```text
637dad32c773c56a27d44d847518580848dee493
```

Sheet와 이 Handoff는 해당 SHA로 동기화한다.

## 14. Historical Compatibility Anchors

아래는 현재 버전을 주장하지 않는다. 기존 활성 문서 계약 테스트가 `docs/CURRENT_HANDOFF.md`에서 계속 찾는 **역사/호환 앵커**이며 현재 상태는 위 절들을 따른다.

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

`Ver 4.2`는 현재 제품 버전 선언이 아니다. PR #183의 승인된 구현 목표는 Ver 4.3이며 아직 Draft/미병합이다.
