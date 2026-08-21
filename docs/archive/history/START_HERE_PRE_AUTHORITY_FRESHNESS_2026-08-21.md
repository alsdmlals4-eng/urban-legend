# Urban Legend 시작 지점

새 채팅·새 GPT·새 Codex·새 작업자가 urban-legend를 안전하게 시작하는 최상위 라우터다.

## 기본 읽기

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main ref
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ Notion 괴이기록국 프로젝트 홈
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
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

현재 제품 구조는 월 1사건 M01+ cadence다. `1년 4분기` 또는 ANNUAL 트랙을 다음 기획 단계라고 안내하는 과거 문구보다 `CURRENT_PLANNING_CANON`을 우선한다. `ANNUAL-MVP-001/002`는 이미 병합된 runtime/history ID로만 보존한다.

## 현재 권위 구분

```text
GitHub latest main ref = 현재 정확한 commit
Notion 프로젝트 홈 = 사람이 보는 전체 그림·Flow·비교표·현재 승인 방향
docs/CURRENT_PLANNING_CANON.md = 최신 월간 기획과 Gate의 사람용 Repository 정본
docs/current-planning-canon.json = 월간 기획·M01/M04·workspace·Gate의 기계 정본
docs/CURRENT_CONFIRMED_DECISIONS.md = 프로젝트 전체 사용자 승인·대체 관계
docs/CURRENT_AFTERLIFE_STATION_CANON.md = 저승역 현재 제품 정본과 구형 자료 우선순위
docs/VALIDATION_TARGET_CANON.md = Validation 상세 Target
docs/CURRENT_HANDOFF_VALIDATION.md = Validation 일반 인수인계; 최신 승인과 active PR이 있으면 그 상태를 먼저 대조
실제 main 코드·테스트 = 구현 사실
docs/CURRENT_STATUS.md = 장기 프로젝트 구현·검증 이력
ASSET_MANIFEST.yml = tracked 제품 자산 승인·의미·권리 권위
Google Sheet = migration-only legacy inventory
```

Current 문서 안의 commit SHA는 역할이 고정된 병합 증거다. 문서 자신의 병합으로 main이 이동하므로 `현재 main`을 문서 속 상수로 고정하지 않는다. 정확한 현재 main SHA와 최신 CI 결과는 작업 시작 때 GitHub에서 다시 읽는다.

Base도 같은 원칙을 사용한다. 프로젝트가 채택한 Base baseline과 Base 원격 latest main을 구분하고, 원격이 전진했다는 이유만으로 채택 baseline을 자동 승격하지 않는다.

저승역 상세 규칙이 구형 Episode·PoC·CORE-VALIDATION 자료와 충돌하면 `docs/CURRENT_AFTERLIFE_STATION_CANON.md`와 `docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`를 우선한다.

제품 자산은 루트 `ASSET_MANIFEST.yml`의 승인·의미·권리 계약을 충족해야 승격할 수 있다. Notion의 시각 방향 승인은 제품 asset 승격이 아니며, 과거 Sheet나 `assets/ASSET_MANIFEST.json`의 상태 문구만으로 `PROJECT_ASSET_APPROVED`를 추론하지 않는다.

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
project_adopted_base_baseline: READ_CURRENT_CONFIRMED_DECISIONS
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
ui_hierarchy_runtime_implementation: NOT_STARTED
ui_hierarchy_new_runtime_render: NOT_RUN
monthly_planning: NON_VISUAL_CLOSURE_READY
monthly_cadence: ONE_MAIN_CASE_PER_MONTH
first_session: M01_AFTERLIFE_STATION
release_near_vertical_slice: M04_RED_UMBRELLA
planning_lock: ACTIVE
overall_plan: OPEN
full_godot_regression: READ_LATEST_CI_EVIDENCE
godot_persistent_authoring_authority: HIGODOT_SOLE_AUTHORITY
gut_test_authority: ADOPTED_ACTIVE_NON_AUTHORING
hera_addon_source: PRESERVED_INACTIVE
hera_adoption: DEFERRED_PENDING_EXACT_PAIR_LIVE_QA_SOURCE_DELTA_NONE_ROLLBACK
asset_manifest_authority: ROOT_ASSET_MANIFEST_YML
project_asset_approved_count: 0
image_product_promotion: BLOCKED_NO_PROJECT_ASSET_APPROVED
vault_local_state: VAULT_LOCAL_STATE_UNVERIFIED
human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
visual_1920x1080_validation: NOT_RUN
keyboard_human_validation: NOT_RUN
gamepad_human_validation: NOT_RUN
ui_accessibility_human_validation: NOT_RUN
android_validation: NOT_RUN
poc_passed: NOT_DECLARED
mobile: DEFERRED_AFTER_PC_VALIDATION
```

`automated_windows_human_qa_preflight: PASS_PR_174`는 GitHub-hosted Windows runner에서 원클릭 QA 도구·PowerShell 7/5.1·Godot 4.7.1 격리 import·안전 실패 경로를 검증했다는 뜻이다. 실제 사용자 저장·화면·조작의 18개 Human QA 항목을 PASS했다는 뜻이 아니다.

`ui_hierarchy_written_spec: APPROVED`도 같은 원칙이다. 승인된 목표/계획이 존재한다는 뜻이며 현재 main의 조사·회수 runtime이 이미 새 layout으로 구현됐다는 뜻이 아니다.

## 현재 구현 경계

현재 main에 구현·병합된 Validation 계층:

- 별도 Validation save repository와 `ValidationSession` lifecycle
- completion apply-once와 hidden Legacy memory guard
- GameState field whitelist wrapper와 invalid active Session fail-closed save routing
- Legacy/Validation 독립 메인 메뉴 카드와 생성·재개·완료 기록 흐름
- Validation runtime whitelist 초기화·route allowlist·single-flight·rollback/abandon 보호
- Canon v2 저승역 runtime/UX 정책·저장·adapter·공용 overlay·행동 확인·종결 미리보기·독립 결과 축
- `START_HUMAN_QA.cmd` 기반 원클릭 Windows Human QA 패키지
- 자동 Windows preflight와 표준 GitHub Actions 회귀

현재 승인됐지만 아직 main runtime에 구현되지 않은 target:

- 조사 environment-first hierarchy
- 저승역 persistent `ManualPanel` → requested drawer/progressive disclosure
- first-action pointer/keyboard discoverability contract
- Canon v2 investigation compact/contextual presentation
- 회수 anomaly-centered persistent stage + contextual ally cut-in
- 1280×720 secondary-first collapse

자동 검증이 있어도 다음은 구현 완료나 사람 승인으로 자동 승격하지 않는다.

- 실제 Windows 사용자 저장 기반 Human QA
- 1280×720 / 1920×1080 실제 시각 밀도·폰트·겹침 판정
- 키보드·게임패드 실제 포커스 체감
- 색상 외 상태 단서·접근성 사람 검증
- 신규 플레이어 이해도 검증
- Android device/export 검증
- 제품 이미지 승격

## 현재 다음 Gate

현재는 월간 non-visual planning이 closure-ready지만 전체 기획과 구현 Gate는 열리지 않았다.

```text
GitHub latest main + Notion current planning + project adopted Base baseline 재조회
→ 사용자 보유 시각 시안 review
→ 전체 기획 완료/보류 범위 명시
→ fresh main에서 character/case ID·monthly_state·save/migration Reality Gate
→ Codex/HiGodot 단일 구현 계약
→ release-near M04 Vertical Slice TDD 구현
→ 자동 회귀 + actual runtime evidence
→ M01/M02/M04 사전등록 Human QA
→ 결과를 PASS / FAIL / BLOCKED / NOT_RUN으로 그대로 기록
→ 병합 뒤 GitHub·Notion readback + 적대적 검토·교정 확인
```

HiGodot 권위가 없는 환경에서는 Scene·Node·Resource·Project Settings의 persistent mutation을 시작하지 않는다.

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
→ Notion 동일 Decision·관련 현재 페이지 확인
→ 중복·대체·충돌·권한·범위 적대적 검토
→ Canon PR과 구현 PR 분리
→ 최신 HEAD 재검증
→ 병합 직전 GitHub·Notion 재조회
→ expected head SHA 고정 병합
→ merge SHA·Notion 위치·미검증 ledger 기록
```

source-only·superseded·blocked PR은 숫자를 맞추기 위해 병합하지 않는다.

동일 Decision의 spec/plan/implementation 후속은 새 Grill Me 질문으로 중복 계산하지 않는다.

## 현재 PR 통합 계보

PR #211, #213~#218의 고유 문서는 `CURRENT_PLANNING_CANON` 통합 범위에 포함한다. 통합본은 월간 정본·저승역 Canon v2·workspace domain split·회귀 검사를 함께 적용한다. 통합 PR 병합 뒤 파일 존재와 동등 이상 내용을 확인한 다음 원 PR을 `SUPERSEDED_BY_INTEGRATED_CANON`으로 닫는다.

정확한 현재 open/closed/mergeable/check 상태는 매 작업 시작과 병합 직전에 GitHub에서 다시 읽는다. 과거 PR 번호나 본문이 current canon과 충돌하면 GitHub latest main, Notion 현재 프로젝트 기획, `docs/CURRENT_PLANNING_CANON.md`, 실제 코드·테스트를 우선한다.

## 보호 범위

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `project.godot`
- 저장 Schema·기존 ID·캠페인·경제·엔딩 의미
- `ASSET_MANIFEST.yml`과 승인 자산
- 실제 Human/Visual/Device QA 증거

보호 의미 변경은 별도 승인·RED/GREEN·회귀·롤백 없이 수행하지 않는다.

Godot Scene·Node·Resource·Project Settings의 persistent 저작은 HiGodot 단일 권위다. GUT은 비저작 테스트 권위다. Hera addon source는 보존할 수 있으나 exact CLI/addon pair·live-QA 소비·source-delta `NONE`·rollback evidence와 별도 승인 없이는 active plugin/autoload로 승격하지 않는다.

## 핵심 위치

- 승인 결정: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- 현재 월간 기획: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`
- 사람용 프로젝트 홈: `https://app.notion.com/p/3c01b237eb1c811c9d5ec512acad4f92`
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
