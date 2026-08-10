# Current Handoff — 2026-08-11

> 상태: `FEATURE_WORK_RESUMED / LIVE_AUTHORITY_RECONCILED / PRODUCT_MUTATION_GATED`
> 현재 대상: `alsdmlals4-eng/urban-legend + alsdmlals4-eng/Base`
> 역할: 다음 세션이 과거 대화 없이 GitHub·Base·Google Sheet를 다시 읽고 현재 승인·PR·검증 경계에서 이어가기 위한 live continuation router.

## 1. Live Authority

```yaml
last_updated_kst: 2026-08-11
project:
  repo: alsdmlals4-eng/urban-legend
  default_branch: main
  current_main_source: READ_GITHUB_MAIN_REF_ON_RESUME
  last_observed_main: cba130ee156c89710d3ddef33ed677bf99aa0716
base:
  repo: alsdmlals4-eng/Base
  default_branch: main
  current_main_source: READ_GITHUB_MAIN_REF_ON_RESUME
  last_observed_main: 315c66eea9614c284b9c11c4d522141065dfa4b0
  project_adopted_base: fa69a77a14f923a756064f6ae151d34cadb374f7
  project_adopted_base_auto_advanced: false
  proposal_id: BCP-2026-014-handoff-machine-consumer-compatibility-closeout
  proposal_status: IMPLEMENTED
  implementation_pr: 260
feature_work:
  state: RESUMED_BY_USER_2026_08_11
  product_mutation: GATED
```

`last_observed_main`은 resume 시점의 비교 앵커일 뿐 영구 current-main 선언이 아니다. 새 세션은 반드시 두 저장소의 `main` ref를 다시 읽는다.

프로젝트가 채택한 Base pin `fa69a77a...`는 Base 원격 main이 `315c66ee...`까지 전진했다는 이유만으로 자동 갱신하지 않는다.

## 2. Current User-Approved Decisions

현재 live 작업에 직접 관련된 Decision:

- `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
- `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`
- `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`
- `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY`
- `D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE`

2026-08-11 사용자 승인으로 Gameplay → Main Menu 범위는 **A**로 확정됐다.

```text
principal gameplay에서 일관된 메인 메뉴 진입
→ 현재 gameplay의 안전한 resume checkpoint 저장
→ canonical Main Menu 이동
→ 기존 Continue가 저장된 gameplay scene/checkpoint 재개
```

단, 현재 save schema가 보존하지 않는 순간 입력·타이머·프레임 상태까지 완전 복원한다고 해석하지 않는다.

Google Sheet `02_현재_확정결정` row 104와 GitHub Issue #181에 같은 Decision ID가 동기화되어 있다.

## 3. Open PR Router

Resume 시 open PR 목록을 다시 읽는다. 2026-08-11 마지막 관측 기준:

### PR #190 — Gameplay → Main Menu safe-return planning

```yaml
decision: D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE
head: f70fb8d56bce7cfaef6f92bd0cdfbf46b9cbf2ca
base: cba130ee156c89710d3ddef33ed677bf99aa0716
state: DRAFT
scope: DOCS_ONLY
changed_files: 5
product_runtime_changed: false
written_spec_status: REVIEW_GATE_OPEN
implementation: NOT_STARTED
```

포함 문서:

- Decision record
- external `SOURCE_CONTEXT_PACKET`
- Base L2 `GAME_FEATURE_DESIGN_SPEC`
- draft TDD implementation plan
- adversarial review

첫 exact head `c90b8fdc...`의 BCA workflow는 BCA contract tests 자체가 아니라 adversarial review 헤더 trailing whitespace 때문에 `git diff --check`에서 실패했다. 내용 의미를 바꾸지 않고 공백만 제거해 `f70fb8d...`로 교정했다.

`f70fb8d...` exact-head 마지막 관측:

- Documentation contracts: PASS — run `31435560337`
- Project Base Adapter: PASS — run `31435560256`
- Urban Legend BCA Adoption: PASS — run `31435560390`
- Core/docs/full Godot regression: PASS — run `31435560312`

Docs-only exact-head PASS는 runtime 구현 또는 Human QA PASS로 재사용하지 않는다. 다음 세션은 exact head workflow 상태를 다시 읽고 current truth로 교체한다.

### PR #189 — post-clear return blocker RED reproduction

```yaml
owner_decision: D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY
head: 5e1c30a4b98732541d8c25d4f9390272c950cfeb
state: DRAFT
scope: TEST_ONLY_RED_PLUS_PLAN
production_runtime_changed: false
red_reproduction: PASS_AS_EXPECTED_FAILURE
```

Godot 4.7.1 `Validate Canon v2 Runtime UX` run `31433463182`에서 import와 선행 tests는 통과한 뒤 새 real-pointer assertion만 의도대로 실패했다.

Exact failure:

```text
read-only result detail must allow actual mouse press/release to reach the underlying post-clear return action
```

원인 class는 실제 result-mode read-only detail panel이 underlying `현장 기록으로 복귀` click을 가로채는 것으로 자동 재현됐다.

제품 GREEN은 아직 없다. 현재 ChatGPT connector에는 HiGodot/Godot-MCP product-authoring surface가 없어 승인된 Godot 저작 권위를 우회하지 않는다.

### PR #186 — route restore endpoint connectivity

```yaml
decision: D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY
historical_head: 4113c2d711d96b87082645acd39166ba502a1c90
state: DRAFT
route_core_human_qa: PASS
post_clear_return_flow: FAIL
merge: HELD
```

노선 자체는 실제 start→safe 연결성과 화면 연결이 일치하도록 구현·핵심 Windows Human QA까지 진행됐다. 다만 성공 후 visible return control의 real pointer 진행이 막혀 병합하지 않는다.

PR #189 blocker GREEN → exact-head automated validation → Windows real-pointer Human retest → current main 기준 PR #186 revalidation 순서가 필요하다.

### PR #183 — Main Menu Ver 4.3 presentation

```yaml
decision: D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING
head: 42e4f378ef10aebfcd812f737bcdae33cfe8dd3f
state: DRAFT
automated: PASS
human_visual_1280_class: PASS
human_visual_1920_class: PASS
complete_input_gate: NOT_RUN
gamepad: NOT_RUN
android: NOT_RUN
merge: HELD
```

Gameplay safe-return 설계는 PR #183의 `main_menu.gd` presentation owner와 충돌을 줄이기 위해 기존 Continue 계약을 재사용하고 gameplay/GameState 쪽 변경을 우선한다.

### PR #165 / #149

오래된 Draft다. current main과 단순 ancestor 관계라고 가정하지 않는다. 실제 compare가 divergent일 수 있으므로 별도 supersession review 없이 임의 close/merge하지 않는다.

## 4. Gameplay → Main Menu Safe-Return Design

Feature ID: `UL-FEATURE-GAMEPLAY-MAIN-MENU-SAFE-RETURN-001`

Principal minimum scope:

1. Preparation
2. Dialogue
3. Investigation
4. Minigame
5. Recovery/Battle
6. Result

Secondary/cuttable:

7. Market
8. Daily Episode

Resume policy classes:

- `DETERMINISTIC_REBUILD`
- `SEMANTIC_CHECKPOINT`
- `RESTART_INCOMPLETE_ATTEMPT`
- `TURN_BOUNDARY_CHECKPOINT`

핵심 적대적 검토 결과:

- 기존 generic `메뉴` navigation은 destination Main Menu를 save target으로 써서 Continue 의미를 깨뜨릴 수 있다.
- Investigation의 기존 HQ 복귀는 `suspend_campaign_operation()`과 Preparation 저장이라는 다른 의미라 persistence 구현을 재사용하면 안 된다.
- incomplete minigame은 authored restart rule을 유지하고 frame-save를 허위 약속하지 않는다.
- Recovery/Battle은 current pattern ID와 stable turn state를 복원해 resume가 RNG reroll exploit이 되지 않게 해야 한다.
- Result/Daily/Market는 load/re-entry 시 reward/report/purchase/choice 중복을 characterization test로 먼저 공격해야 한다.
- Validation persistence isolation은 하드 경계다.
- 기존 `save_game()`의 application-level 성공을 crash-atomic durability로 과장하지 않는다.

PR #190이 이 Decision의 Decision record, SOURCE_CONTEXT_PACKET, Base L2 Game Feature Design Spec, draft TDD implementation plan, adversarial review를 소유한다. 이 다섯 파일은 PR #190이 병합되기 전에는 main 또는 PR #191 tree에 존재한다고 가정하지 않는다. Resume 시 PR #190의 changed-files/tree에서 직접 읽는다.

## 5. Display Settings

Decision: `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`

승인 범위:

- `1280×720`
- `1600×900`
- `1920×1080`
- windowed / fullscreen
- restart persistence
- DisplaySettings owner를 AccessibilitySettings와 분리

Planning은 준비되어 있으나 구현은 `NOT_STARTED`다. 현재 우선순위에서는 route blocker와 Gameplay→Main Menu written-Spec gate 뒤에 둔다. “feature work resumed”를 Display runtime implementation 자동 승인으로 해석하지 않는다.

## 6. Base Proposal / Source Context

`BCP-2026-014-handoff-machine-consumer-compatibility-closeout`의 Base current registry 상태는:

```yaml
status: IMPLEMENTED
implementation_pr: 260
```

과거 handoff의 `SUBMITTED / NOT_STARTED`는 current truth가 아니다. Google Sheet `98_Base_반영후보`도 2026-08-11 이 상태로 교정했다.

Base remote `315c66ee...`는 `SOURCE_CONTEXT_PACKET`, Existing-Solution-First, low-risk source auto-merge gate를 운영화했다. 이번 Gameplay save/resume 의미 변경은 source-only 저위험 자동 병합으로 취급하지 않는다.

## 7. Google Sheet Sync

2026-08-11 live Sheet에서 교정/추가된 핵심 surface:

- `00_프로젝트_허브`: feature resumed, Base remote/current project main, PR189, Main Menu 승인 상태
- `02_현재_확정결정` row 103: route 구현/Human core PASS/post-clear blocker 현실 반영
- `02_현재_확정결정` row 104: `D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE`
- `04_누락_충돌_감사`: live authority reconciliation / PR189 exact RED / Main Menu design adversarial audit
- `98_Base_반영후보` row 5: BCP-2026-014 `IMPLEMENTED / PR260`
- `99_변경이력`: 2026-08-11 reconciliation/PR189/Main Menu planning 기록

Resume 시 Sheet도 다시 읽어야 한다. 이 handoff 자체보다 live GitHub+Sheet가 우선한다.

## 8. Verification Boundary

```yaml
project_main_last_observed: cba130ee156c89710d3ddef33ed677bf99aa0716
base_main_last_observed: 315c66eea9614c284b9c11c4d522141065dfa4b0
route_pr186_route_core_human_qa: PASS
route_post_clear_human_qa: FAIL
route_pr189_exact_red: CONFIRMED
route_pr189_product_green: NOT_RUN
route_post_clear_human_retest: NOT_RUN
pr183_automated: PASS
pr183_complete_human_input_gate: NOT_RUN
pr183_gamepad: NOT_RUN
pr183_android: NOT_RUN
main_menu_safe_return_direction_A: APPROVED
main_menu_safe_return_l2_spec: WRITTEN_REVIEW_GATE
main_menu_safe_return_runtime: NOT_STARTED
main_menu_safe_return_human_qa: NOT_RUN
display_settings_runtime: NOT_STARTED
project_asset_approved_count: 0
```

`NOT_RUN`을 PASS로 승격하지 않는다. Docs-only CI나 test-only RED를 runtime/Human PASS로 재사용하지 않는다.

## 9. Authority / Build Gate

Persistent Godot product authoring authority remains:

```yaml
Godot Scene/Node/Resource/Project Settings/product GDScript: HiGodot sole authority
GUT: test authority / non-authoring
```

현재 ChatGPT connector에는 HiGodot/Godot-MCP product-authoring plugin이 노출되지 않았다. GitHub Contents API로 `.gd`를 기술적으로 쓸 수 있다는 사실은 권위 우회 근거가 아니다.

Gameplay safe-return은 사용자 방향 A가 승인됐지만, written Spec review/프로젝트 planning-completion gate가 아직 열려 있다. 기획 문서 작성 자체를 runtime implementation 승인으로 간주하지 않는다.

## 10. Resume Read Order

다음 세션은 다음을 live로 다시 읽는다.

```text
1. urban-legend current main ref / latest commit
2. open PRs와 exact-head status, 특히 #190 / #189 / #186 / #183
3. Base current main + BCP-2026-014 registry state
4. Google Sheet 00 / 02 rows103-104 / 04 / 98 / 99
5. docs/CURRENT_HANDOFF.md
6. PR189 result-mode real-pointer RED test + canon_v2_operation_overlay.gd
7. PR190 Decision / SOURCE_CONTEXT_PACKET / L2 Spec / TDD plan / adversarial review
8. scripts/core/game_state.gd + scripts/ui/main_menu.gd
9. principal gameplay scene scripts as implementation gate requires
```

## 11. Next Executable Steps

### Route blocker

1. PR #189 current exact-head/CI 재확인.
2. approved HiGodot product-authoring path가 실제 사용 가능한 환경에서만 minimal GREEN.
3. read-only detail subtree만 pointer-transparent하게 만들고 Manual/Confirmation/Backdrop interaction semantics 보존.
4. focused + maintained exact-head CI.
5. Windows real-pointer Human retest.
6. 그 뒤 PR #186를 current main에 맞춰 exact-head 재검증.

### Gameplay → Main Menu

1. PR #190 exact-head docs CI 완료 확인.
2. written Spec review/기획 완료 gate.
3. current main에서 HiGodot-authorized TDD 시작.
4. GameState optional JSON-safe resume checkpoint RED→GREEN.
5. principal six scenes를 scene policy별로 순차 구현·검증.
6. secondary Market/Daily는 필요 시 후속.
7. exact-head full regression + Windows Human QA.
8. 같은 Decision ID로 GitHub/Sheet status propagation.

### Aggregate canon freshness

`docs/CURRENT_CONFIRMED_DECISIONS.md` 등 오래된 aggregate 문서는 historical 내용이 많고 current state surface가 stale하다. 별도 owner-aware docs reconciliation로 정리하되, feature PR #190에 섞어 scope를 흐리지 않는다.

## 12. Stop / Safety Conditions

- HiGodot authoring surface 없이 product `.gd`/Scene/Resource mutation을 우회하지 않는다.
- PR #186 / #183를 기존 자동 evidence만으로 merge-ready 승격하지 않는다.
- PR #189의 intended RED를 failure-free PASS로 위장하지 않는다.
- PR #190 docs-only PASS를 제품 구현 검증으로 해석하지 않는다.
- save/resume가 중복 reward/RNG reroll/transaction replay를 일으킬 가능성이 있으면 해당 scene Menu exit를 임시 차단하는 편을 선택한다.
- current GitHub/Sheet와 이 handoff가 충돌하면 live authority를 먼저 교정한다.

## 13. Historical Compatibility Anchors

아래 값은 현재 상태 선언이 아니라 기존 machine consumers용 역사/호환 앵커다.

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

`Ver 4.2`는 현재 제품 버전 선언이 아니다. PR #183의 승인 목표는 Ver 4.3이며 아직 Draft/미병합이다.