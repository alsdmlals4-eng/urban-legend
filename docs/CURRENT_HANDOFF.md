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

현재 관련 Decision:

- `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
- `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`
- `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`
- `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY`

주의:

- 현재 `START_HERE.md`, `docs/CURRENT_STATUS.md`, `docs/CURRENT_CONFIRMED_DECISIONS.md`에는 과거 상태가 남아 있다. 현재 작업 재개 시 이 파일들의 오래된 상태 문구를 GitHub/Sheet보다 높은 사실로 사용하지 않는다.
- 현재 상태 판정은 `latest main + open PR + 최신 PR comment + Google Sheet + 이 Handoff`를 대조한다.
- 새 중복 Handoff/Progress owner를 만들지 않는다.

## 3. PR Influence Map

### PR #180 — COMPLETED_VERIFIED / MERGED

- Decision: `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
- merged main: `8294aa2eefe03fa7669617675516c9f03f739076`
- Windows Human QA에서 조사 포인터/진행이 실제로 다음 단계와 미니게임까지 진행됨.
- 현재 main의 기반으로 취급한다.

### PR #186 — COMPLETED_NOT_MERGED / BLOCKED

- Decision: `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY`
- PR: `#186` Draft
- branch: `agent/route-endpoint-connectivity-20260810`
- exact implementation head: `4113c2d711d96b87082645acd39166ba502a1c90`
- integration merge candidate used for Windows QA: `3502d8db45504d205a37fdad593192cfffeb545a`
- exact-head CI: GREEN
  - Validate Project Base Adapter `31350458351`
  - Validate full matrix `31350458345`
  - Validate core and documentation baseline `31350458344`
  - Validate ANNUAL-MVP-001 `31350458335`
- Human QA route core: PASS
  - final safe endpoint approaches from WEST
  - actual route manipulation works
  - actual route clear succeeds
  - successful result persists and Continue shows `검증 기록 완료 | 성공`
- new blocker after clear: `POST_CLEAR_RETURN_INPUT_BLOCKED`
- PR body is stale relative to latest PR comments; latest Human QA evidence is issue comment `5235366964`.
- merge: HELD

### PR #183 — COMPLETED_NOT_MERGED / HUMAN_QA_INCOMPLETE

- Decision: `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`
- PR: `#183` Draft
- branch: `agent/main-menu-control-room-v43-implementation-20260809`
- exact implementation head: `42e4f378ef10aebfcd812f737bcdae33cfe8dd3f`
- local visual candidate evidence: `757df80b00f61fc94916bcee65aa6705748fa5f7` (`LOCAL_EVIDENCE`, not PR head)
- automated evidence on implementation head: GREEN
- observed Human visual QA: 1280-class PASS, 1920-class PASS, Ver 4.3/control-room hierarchy PASS
- remaining Human/input gate includes mouse/keyboard/gamepad and other PR contract items; Android NOT_RUN.
- merge: HELD

### Other open PRs

- `#165` P0 audit: separate historical/governance work; do not fold into paused runtime fixes without a new scope review.
- `#149` local Human QA save runner: separate Draft; reference only for this handoff unless its own work is resumed.

## 4. Progress Classification

```yaml
completed_verified:
  - PR180 merged to main 8294aa2e and Windows pointer/progression Human QA passed
  - PR186 route endpoint/reachability implementation automated exact-head CI green
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

## 5. Current Runtime Finding — Do Not Lose

`POST_CLEAR_RETURN_INPUT_BLOCKED` is separate from route reachability.

Observed sequence:

```text
route puzzle solves successfully
→ result is saved
→ saved-result UI shows 성공
→ visible `현장 기록으로 복귀` button does not respond
→ progression stops
```

Root-cause evidence:

- `scripts/scenes/minigame_scene.gd` creates the return button, connects `pressed` to `_return_to_flow()`, and makes it visible after saved/completed result.
- `_return_to_flow()` for successful route restore routes to `res://scenes/battle_scene.tscn`.
- `scripts/ui/canon_v2_operation_overlay.gd` mounts the rescue-mode operation overlay.
- overlay root / SafeArea / RootLayout are pointer-transparent, but `_make_detail_panel()` assigns `MOUSE_FILTER_STOP` to read-only detail panels.
- the bottom read-only `ObligationPanel` occupies the same lower screen area as the visible return button in the Human QA screenshot.

Current hypothesis is evidence-backed but the fix is NOT implemented. Required next implementation begins with a real click-through RED regression; do not blindly change multiple overlay layers.

## 6. Approved Display Settings — Paused

Decision: `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`

Approved direction:

- `1280×720`
- `1600×900`
- `1920×1080`
- windowed / fullscreen
- persistence across restart
- DisplaySettings responsibility remains separate from AccessibilitySettings

Planning branch:

```text
agent/display-settings-route-connectivity-design-20260810
HEAD 66c3e24fdffa5502a827f0265f5d1ef8e8ab21f9
```

Status: `PLAN_READY / IMPLEMENTATION_NOT_STARTED / PAUSED_BY_USER`

## 7. Main Menu Return Control — User Request, Not Yet Approved Design

User requested adding a way to go to the main menu from gameplay.

The last design question had two scopes, but the user paused work before selecting one:

- A: gameplay screens broadly expose `메뉴`; save current progress, go to main menu, Continue returns to the saved screen.
- B: add it only around the current minigame/result flow.

Status: `USER_DECISION_REQUIRED_WHEN_RESUMED`.
Do not infer that A was approved.

## 8. Verification State

```yaml
project_main_8294aa2e:
  repository_truth: PASS
route_pr186_head_4113c2d7:
  exact_head_ci: PASS
route_human_core:
  windows_1280x720: PASS
post_clear_return_flow:
  human_qa: FAIL
pr183_42e4f378:
  automated: PASS
  local_visual_1280_class: PASS
  local_visual_1920_class: PASS
  complete_human_input_gate: NOT_RUN
  gamepad: NOT_RUN
android:
  status: NOT_RUN
display_settings_implementation:
  status: NOT_RUN
main_menu_return_feature:
  design_approval: NOT_RUN
```

`NOT_RUN`을 PASS로 승격하지 않는다.

## 9. Resume Read Order

새 세션에서 사용자가 기능 작업 재개를 요청하면 “어디까지 했나요?”를 먼저 묻지 않는다.

```text
1. urban-legend latest main SHA
2. open PRs, 특히 #186/#183와 최신 comments/checks
3. Base latest main SHA + maintaining-project-context-and-handoff owner
4. Google Sheet 00_프로젝트_허브
5. 이 docs/CURRENT_HANDOFF.md
6. scripts/scenes/minigame_scene.gd
7. scripts/ui/canon_v2_operation_overlay.gd
8. PR186 route source/test
9. display planning branch 66c3e24f and PR183 42e4f378
```

저장된 SHA가 현재 GitHub와 다르면 먼저 이 Handoff를 stale로 표시하고 현재 저장소 사실로 교정한다.

## 10. Next Executable Step — Only After User Resumes Feature Work

우선순위는 다음과 같다.

1. latest main / PR186 / Base / Sheet 다시 조회.
2. `POST_CLEAR_RETURN_INPUT_BLOCKED`를 같은 조건에서 재현.
3. 실제 포인터 click-through RED regression 작성.
4. read-only CanonV2 detail panel이 뒤의 실제 control을 가로채지 않도록 최소 input-policy fix. Confirmation/backdrop처럼 실제 상호작용이 필요한 layer의 pointer blocking은 보존.
5. focused regression + maintained relevant suites + exact-head PR CI.
6. Windows Human QA에서 route clear → `현장 기록으로 복귀` 실제 클릭 → battle/recovery 전환 확인.
7. 그 뒤에만 PR186 merge gate 재판정.
8. 별도 사용자 결정으로 Main Menu return-control 범위 확정.
9. 그 다음 display settings implementation 재개.

## 11. Stop Conditions

- 사용자 현재 지시: 기능 수정은 여기서 중단하고 인수인계만 수행.
- 이 checkpoint에서는 product `.gd` / Scene / data / asset 구현을 하지 않는다.
- PR #186 / #183을 merge-ready로 올리거나 merge하지 않는다.
- Main Menu return-control 범위를 임의 확정하지 않는다.
- display implementation을 시작하지 않는다.
- persistent `.gd` 저작을 재개할 때는 프로젝트의 HiGodot authority를 다시 확인한다.

## 12. Base Existing-Solution Verdict / Learning

```yaml
handoff_operating_pattern:
  verdict: REUSE
  base_owner: skills/maintaining-project-context-and-handoff/SKILL.md
  new_project_handoff_skill: NO
  new_base_candidate_for_this_checkpoint: NO_PROMOTION
```

이번 checkpoint에서 확인된 runtime 문제들은 프로젝트 고유 구현/QA 상태다. 현재 인수인계 자체를 위해 새 Base Skill이나 새 BCP를 만들 이유는 없다.

## 13. Known Freshness Conflict

Google Sheet가 직전까지 기록한 Base remote `b37c9def...`보다 Base main이 다시 전진했다.
현재 확인된 Base main은:

```text
637dad32c773c56a27d44d847518580848dee493
```

Sheet/Handoff를 갱신할 때 이 SHA를 사용한다.
