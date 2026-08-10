# Urban Legend 시작 지점

새 채팅·새 GPT·새 Codex·새 작업자가 urban-legend를 안전하게 시작하는 최상위 라우터다.

## 기본 읽기

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main ref + open PRs
→ Google Sheet current Decision/audit rows
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/CURRENT_AFTERLIFE_STATION_CANON.md  # 저승역 작업일 때
→ docs/CURRENT_HANDOFF_VALIDATION.md       # Validation 일반 인수인계가 필요할 때
→ docs/VALIDATION_TARGET_CANON.md          # 제품 Target 관련일 때
→ docs/GRILLME_APPROVAL_MERGE_LEDGER.md
→ docs/CURRENT_STATUS.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 실제 main 코드·데이터·Scene·테스트
```

`전부 확인`은 모든 파일을 무조건 로드한다는 뜻이 아니다. 현재 정본·Registry·실제 변경 경로로 범위를 좁힌 뒤 필요한 전문만 읽는다.

현재 작업은 하나의 과거 next step으로 고정하지 않는다. 최신 사용자 승인, GitHub current main/open PR, Google Sheet 동일 Decision ID, `docs/CURRENT_CONFIRMED_DECISIONS.md`, 실제 코드·테스트를 서로 대조한 뒤 해당 주제의 Decision/Spec/Plan을 고른다.

2026-08-11 freshness 감사에서 `docs/CURRENT_CONFIRMED_DECISIONS.md`의 일부 구현 상태와 최신 Decision 전파가 live GitHub/Sheet보다 뒤처진 것이 확인됐다. 해당 문서를 버리거나 역사 전체를 덮어쓰지 말고, 충돌 시 실제 main/open PR/Sheet를 증거로 `CONFLICTING_SOURCE` 또는 `MISSING_PROPAGATION`을 명시해 교정한다.

## 현재 권위 구분

```text
GitHub latest main ref = 현재 정확한 commit
GitHub open/merged PR evidence = 구현·검증 단계와 exact-head 증거
docs/CURRENT_CONFIRMED_DECISIONS.md = 프로젝트 전체 사용자 승인·대체 관계; 최근 전파 누락은 live GitHub/Sheet와 대조
docs/CURRENT_AFTERLIFE_STATION_CANON.md = 저승역 현재 제품 정본과 구형 자료 우선순위
docs/VALIDATION_TARGET_CANON.md = Validation 상세 Target
docs/CURRENT_HANDOFF_VALIDATION.md = Validation 일반 인수인계; 최신 승인과 active PR이 있으면 그 상태를 먼저 대조
실제 main 코드·테스트 = 구현 사실
docs/CURRENT_STATUS.md = 장기 프로젝트 구현·검증 이력; 역사 구간을 current summary로 오독하지 않음
ASSET_MANIFEST.yml = tracked 제품 자산 승인·의미·권리 권위
Google Sheet = 동일 Decision ID의 계획·감사·변경 추적
```

Current 문서 안의 commit SHA는 역할이 고정된 병합 증거다. 문서 자신의 병합으로 main이 이동하므로 `현재 main`을 문서 속 상수로 고정하지 않는다. 정확한 현재 main SHA와 최신 CI 결과는 작업 시작 때 GitHub에서 다시 읽는다.

Base도 같은 원칙을 사용한다. 프로젝트가 채택한 Base baseline과 Base 원격 latest main을 구분하고, 원격이 전진했다는 이유만으로 채택 baseline을 자동 승격하지 않는다.

저승역 상세 규칙이 구형 Episode·PoC·CORE-VALIDATION 자료와 충돌하면 `docs/CURRENT_AFTERLIFE_STATION_CANON.md`와 `docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`를 우선한다.

제품 자산은 루트 `ASSET_MANIFEST.yml`과 Google Sheet 승인 상태가 함께 충족돼야 승격할 수 있다. 과거 `assets/ASSET_MANIFEST.json`의 `stage: final` 또는 QA 문구만으로 `PROJECT_ASSET_APPROVED`를 추론하지 않는다.

## Work Mode·Skill 라우팅

1. 요청을 `PLAN / BUILD / REVIEW`로 분류한다.
2. 프로젝트 분야 Skill 최대 1개를 고른다.
3. 필요한 프로젝트 로컬 전문 최대 1개를 고른다.
4. 필요한 Base 지원 Skill 최대 3개를 고른다.
5. 실제 Skill 전문을 읽고 수행한다.
6. 완료 시 선택 이유·변경·증거·미검증을 보고한다.

Registry 항목만 읽고 Skill을 실행했다고 보고하지 않는다.

## 현재 Validation·운영 상태

이 블록은 **단계와 권위만** 요약한다. 테스트 개수·latest main SHA·latest run ID는 빠르게 낡으므로 GitHub와 책임 원본에서 다시 읽는다.

```yaml
base: 9.4.3
base_remote_main: READ_GITHUB_BASE_LATEST_MAIN
project_adopted_base_baseline: READ_CURRENT_CONFIRMED_DECISIONS_AND_BASE_RULES_VERSION
project_branch: main
project_main: READ_GITHUB_PROJECT_LATEST_MAIN
package_1: MERGED_AND_AUTOMATED_CI_VERIFIED
package_2: MERGED_ON_MAIN_AND_AUTOMATED_CI_VERIFIED
canon_v2_runtime_ux: MERGED_ON_MAIN_AND_AUTOMATED_CI_VERIFIED
one_click_windows_human_qa_package: MERGED_ON_MAIN
automated_windows_human_qa_preflight: PASS_PR_174
ui_hierarchy_decision: D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT
ui_hierarchy_written_spec: APPROVED
ui_hierarchy_implementation_plan: MERGED_ON_MAIN_PR_176
ui_hierarchy_runtime_implementation: MERGED_ON_MAIN_PR_180
ui_hierarchy_investigation_pointer_progression_human_qa: PASS_EXACT_HEAD_PR_180
ui_hierarchy_broader_complete_input_gate: NOT_RUN
ui_hierarchy_android_validation: NOT_RUN
route_endpoint_decision: D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY
route_endpoint_runtime: DRAFT_PR_186
route_endpoint_core_human_qa: PASS
route_post_clear_return: FAIL_INPUT_BLOCKED
route_post_clear_blocker_red: CONFIRMED_DRAFT_PR_189
main_menu_v43: DRAFT_PR_183
main_menu_v43_complete_input_gate: NOT_RUN
main_menu_v43_gamepad: NOT_RUN
main_menu_v43_android: NOT_RUN
gameplay_main_menu_safe_return_decision: D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE
gameplay_main_menu_safe_return_direction: APPROVED_A
gameplay_main_menu_safe_return_planning: DRAFT_PR_190_DOCS_EXACT_HEAD_GREEN
gameplay_main_menu_safe_return_runtime: NOT_STARTED
display_resolution_window_mode_decision: D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE
display_resolution_window_mode_runtime: NOT_STARTED
current_handoff_freshness: DRAFT_PR_191_EXACT_HEAD_GREEN
current_canon_freshness_audit: DRAFT_PR_192
full_godot_regression: READ_LATEST_CI_EVIDENCE
godot_persistent_authoring_authority: HIGODOT_SOLE_AUTHORITY
gut_test_authority: ADOPTED_ACTIVE_NON_AUTHORING
hera_addon_source: PRESERVED_INACTIVE
hera_adoption: DEFERRED_PENDING_EXACT_PAIR_LIVE_QA_SOURCE_DELTA_NONE_ROLLBACK
asset_manifest_authority: ROOT_ASSET_MANIFEST_YML
project_asset_approved_count: 0
image_product_promotion: BLOCKED_NO_PROJECT_ASSET_APPROVED
vault_local_state: VAULT_LOCAL_STATE_UNVERIFIED
full_windows_human_qa_gate: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_complete_validation: NOT_RUN
visual_1920x1080_complete_validation: NOT_RUN
keyboard_complete_human_validation: NOT_RUN
gamepad_human_validation: NOT_RUN
ui_accessibility_complete_human_validation: NOT_RUN
android_validation: NOT_RUN
poc_passed: NOT_DECLARED
mobile: DEFERRED_AFTER_PC_VALIDATION
```

`automated_windows_human_qa_preflight: PASS_PR_174`는 GitHub-hosted Windows runner에서 원클릭 QA 도구·PowerShell 7/5.1·Godot 4.7.1 격리 import·안전 실패 경로를 검증했다는 뜻이다. 실제 사용자 저장·화면·조작의 전체 Human QA 항목을 PASS했다는 뜻이 아니다.

PR #180의 Human 증거는 **조사 real-pointer progression이 실제 Windows 1280×720에서 route-restore 미니게임까지 진행됐다는 좁은 PASS**다. 이 증거를 게임패드·Android·전체 UI/접근성·출시 QA PASS로 확대하지 않는다.

PR #186의 route core Human PASS와 post-clear return FAIL도 분리한다. route 자체 성공 판정이 검증됐더라도 성공 후 복귀 입력 blocker가 남아 있으므로 merge-ready로 승격하지 않는다.

## 현재 구현 경계

현재 main에 구현·병합된 Validation/UI 계층:

- 별도 Validation save repository와 `ValidationSession` lifecycle
- completion apply-once와 hidden Legacy memory guard
- GameState field whitelist wrapper와 invalid active Session fail-closed save routing
- Legacy/Validation 독립 메인 메뉴 카드와 생성·재개·완료 기록 흐름
- Validation runtime whitelist 초기화·route allowlist·single-flight·rollback/abandon 보호
- Canon v2 저승역 runtime/UX 정책·저장·adapter·공용 overlay·행동 확인·종결 미리보기·독립 결과 축
- `START_HUMAN_QA.cmd` 기반 원클릭 Windows Human QA 패키지
- 자동 Windows preflight와 표준 GitHub Actions 회귀
- PR #180 조사 environment-first hierarchy, requested manual drawer/progressive disclosure, first-action pointer/keyboard discoverability, compact/contextual investigation overlay, anomaly-centered recovery stage/contextual ally cut-in, 1280 secondary-first collapse

현재 승인·진행 중이지만 **main 통합 또는 제품 완료로 승격하면 안 되는** target:

- PR #186 route endpoint connectivity: Draft 구현 + route core Human PASS, post-clear input blocker 때문에 병합 보류
- PR #189 post-clear return pointer blocker: exact test-only RED 확인, product GREEN은 HiGodot 권위 환경에서만 수행
- PR #183 Main Menu Ver 4.3 presentation: Draft, 자동/일부 시각 evidence와 complete input/gamepad/Android gate를 분리
- `D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE`: 방향 A 승인, PR #190 written L2 Spec/plan review gate, runtime `NOT_STARTED`
- `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`: 승인/planning 완료 범위, runtime `NOT_STARTED`

자동 검증이 있어도 다음은 구현 완료나 사람 승인으로 자동 승격하지 않는다.

- 전체 Windows 사용자 저장 기반 Human QA gate
- 1280×720 / 1920×1080 전체 시각 밀도·폰트·겹침 판정
- 키보드·게임패드 전체 포커스 체감
- 색상 외 상태 단서·접근성 전체 사람 검증
- 신규 플레이어 이해도 검증
- Android device/export 검증
- 제품 이미지 승격

## 현재 다음 Gate

하나의 과거 UI 계획을 다시 구현하지 말고 live frontier를 다음 순서로 판정한다.

```text
GitHub latest main + open PRs + Base latest + project adopted Base baseline + Sheet + Current canon 재조회
→ PR #189 exact RED/current head 재확인
→ HiGodot product-authoring 권위가 실제 가능한 환경에서만 post-clear minimal GREEN
→ focused + maintained exact-head CI + Windows real-pointer Human retest
→ 그 뒤 PR #186를 current main 기준으로 재검증
→ PR #190 written Spec/기획 완료 gate 판정 후에만 gameplay→Main Menu runtime TDD 진입
→ PR #183는 complete input/gamepad/Android 미검증을 보존한 채 별도 owner로 검토
→ Display runtime은 승인된 planning 범위지만 앞선 blocker/gate와 분리해 착수 여부 판정
→ 결과를 PASS / FAIL / BLOCKED / NOT_RUN으로 그대로 기록
→ 별도 Android/제품/출시 판단
```

HiGodot 권위가 없는 환경에서는 Scene·Node·Resource·Project Settings·product GDScript의 persistent mutation을 시작하지 않는다. GitHub Contents API로 기술적으로 쓸 수 있다는 사실은 권위 우회 근거가 아니다.

이미지·자산 작업은 별도 게이트다.

```text
71_이미지기획_생성목록
→ 72_이미지검수_승인로그
→ PROJECT_ASSET_APPROVED
→ root ASSET_MANIFEST.yml
→ tracked 제품 자산 승격
```

현재 `PROJECT_ASSET_APPROVED`가 0건이므로 이미지 제품 승격은 BLOCKED다. 자동 생성·삭제·교체로 이 게이트를 우회하지 않는다.

## Grill Me 승인·병합 규칙

운영 Decision:

- `docs/decisions/D-2026-08-02-GRILLME-10-MERGE-CADENCE.md`
- `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`

현재 미래 카운터: `0 / 10`

승인된 Grill Me Decision ID가 10개 누적되면 다음을 먼저 수행한다.

```text
최신 main 고정
→ GitHub 열린 PR·Issue·review threads·CI 확인
→ Google Sheet 동일 Decision ID·exact range 확인
→ 중복·대체·충돌·권한·범위 적대적 검토
→ Canon PR과 구현 PR 분리
→ 최신 HEAD 재검증
→ 병합 직전 GitHub·Sheet 재조회
→ expected head SHA 고정 병합
→ merge SHA·Sheet 위치·미검증 ledger 기록
```

source-only·superseded·blocked PR은 숫자를 맞추기 위해 병합하지 않는다.

동일 Decision의 spec/plan/implementation 후속은 새 Grill Me 질문으로 중복 계산하지 않는다.

## 현재 PR 상태 라우팅

최근 운영상 중요한 상태만 적는다. 정확한 open/closed/mergeable 상태는 매 작업 시작 때 GitHub에서 다시 읽는다.

- PR #180: `MERGED` — 조사·회수 UI hierarchy runtime 구현; exact-head Windows 조사 real-pointer progression PASS, Android/전체 release QA는 별도
- PR #183: `OPEN DRAFT` — Main Menu Ver 4.3 presentation; complete input/gamepad/Android gate 미실행
- PR #186: `OPEN DRAFT` — route endpoint connectivity 구현; route core Human PASS, post-clear return input FAIL로 merge held
- PR #189: `OPEN DRAFT / TEST-ONLY RED` — post-clear return blocker 실제 pointer RED 재현; product GREEN 미실행
- PR #190: `OPEN DRAFT / DOCS-ONLY` — Gameplay→Main Menu safe-return 방향 A의 Decision/L2 Spec/plan/adversarial package; exact-head docs/core regression GREEN, runtime 미시작
- PR #191: `OPEN DRAFT / HANDOFF-ONLY` — `CURRENT_HANDOFF.md` live reconciliation; exact-head docs/ANNUAL/core GREEN, product runtime 변경 없음
- PR #192: `OPEN DRAFT / AUDIT-ONLY` — current canon/reference freshness impact map; 기존 canonical 파일은 아직 미수정
- PR #149: `OPEN DRAFT / DIVERGED` — 로컬 Human QA runner 계열; 현재 main과 고유 차이가 있어 별도 감사 전 직접 병합 금지
- PR #165: `OPEN DRAFT / DIVERGED` — 과거 GUT/addon 정합화 감사; 후속 main 변경과 대조한 별도 재감사 전 직접 병합 금지

정확한 현재 open/closed/head/CI는 위 목록보다 GitHub live 상태가 우선한다. 과거 PR 번호나 본문이 current canon과 충돌하면 GitHub latest main, 실제 코드·테스트, Sheet의 최신 동기화 기록을 먼저 확인하고 current canon propagation gap을 보고한다.

## 보호 범위

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `project.godot`
- 저장 Schema·기존 ID·캠페인·경제·엔딩 의미
- `ASSET_MANIFEST.yml`과 승인 자산
- 실제 Human/Visual/Device QA 증거

보호 의미 변경은 별도 승인·RED/GREEN·회귀·롤백 없이 수행하지 않는다.

Godot Scene·Node·Resource·Project Settings·product GDScript의 persistent 저작은 HiGodot 단일 권위다. GUT은 비저작 테스트 권위다. Hera addon source는 보존할 수 있으나 exact CLI/addon pair·live-QA 소비·source-delta `NONE`·rollback evidence와 별도 승인 없이는 active plugin/autoload로 승격하지 않는다.

## 핵심 위치

- 승인 결정: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- 현재 live handoff: `docs/CURRENT_HANDOFF.md`
- UI hierarchy Decision: `docs/decisions/D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT.md`
- UI hierarchy Spec: `docs/superpowers/specs/2026-08-08-investigation-recovery-ui-hierarchy-design.md`
- UI hierarchy Plan: `docs/superpowers/plans/2026-08-08-investigation-recovery-ui-hierarchy-implementation-plan.md`
- 조사·회수 분야 정본: `docs/CINEMATIC_FIELD_RECOVERY_UI.md`
- 저승역 현재 정본: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
- 저승역 Source Map: `docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`
- 저승역 적대적 감사: `docs/audits/2026-08-04-afterlife-station-batch-4-canonicalization-audit.md`
- 저승역 병합 증거: `docs/implementation/2026-08-04-afterlife-station-batch-4-merge-evidence.md`
- 현재 Validation 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`
- Validation Target: `docs/VALIDATION_TARGET_CANON.md`
- Package 1 Design: `docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md`
- Package 1 Plan: `docs/superpowers/plans/2026-08-02-validation-session-save-isolation-implementation-plan.md`
- Package 1 evidence: `docs/implementation/2026-08-02-package-1-session-save-isolation-evidence.md`
- Package 2 Design: `docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md`
- Package 2 Plan: `docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`
- Package 2 evidence: `docs/implementation/2026-08-02-package-2-main-menu-entry-routing-evidence.md`
- 원클릭 Windows Human QA 실행기: `START_HUMAN_QA.cmd`
- 제품 자산 권위: `ASSET_MANIFEST.yml`
- Godot 도구 권위 원장: `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`
- Grill Me cadence: `docs/decisions/D-2026-08-02-GRILLME-10-MERGE-CADENCE.md`
- Grill Me ledger: `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`
- 프로젝트 실제 상태: `docs/CURRENT_STATUS.md`
- 검증 계약: `TEST_CHECKLIST.md`
- Base 버전: `docs/BASE_RULES_VERSION.md`

실행하지 않은 검사·사람 확인·제품 완료는 `NOT_RUN`, `UNVERIFIED`, `NOT_DECLARED` 중 정확한 상태로 기록한다.