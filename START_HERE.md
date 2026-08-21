# Urban Legend 시작 지점

새 채팅·새 GPT·새 Codex·새 작업자가 괴이기록국을 **현재 정본과 실제 main**에서 안전하게 시작하는 최상위 라우터다.

## 기본 읽기

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main ref + open PR/Issue 상태
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ Notion 괴이기록국 프로젝트 홈
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ docs/CURRENT_HANDOFF.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 실제 main 코드·데이터·Scene·테스트
→ 작업에 필요한 조건부 원본만 추가
```

구현 작업이면 current handoff가 가리키는 다음 세 문서를 추가한다.

- Reality Gate: `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`
- Design: `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- Plan: `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

Validation·저승역·장기 구현 Ledger·승인 역사처럼 작업 주제가 요구할 때만 다음을 추가한다.

- Validation: `docs/VALIDATION_TARGET_CANON.md`
- 저승역 상세 규칙: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
- 장기 구현·검증 이력/evidence ceiling: `docs/CURRENT_STATUS.md`
- 상세 승인·대체 역사: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- 과거 Validation 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`

`전부 확인`은 모든 과거 문서를 기본 로드한다는 뜻이 아니다. 현재 정본·실제 변경 경로·Registry로 범위를 좁힌 뒤 필요한 전문만 읽는다.

## 현재 권위 구분

```text
GitHub latest main ref
= 현재 정확한 commit과 실제 구현 기준

Notion 프로젝트 홈
= 사람이 보는 전체 그림·Flow·비교표·현재 승인 방향

docs/CURRENT_PLANNING_CANON.md + docs/current-planning-canon.json
= 월 1사건 제품 구조·M01/M04 역할·현재 Planning/Implementation Gate 정본

docs/CURRENT_DECISION_OVERLAY.md
= 다음 작업자가 바로 소비하는 current mutable decision·verified successor state

docs/CURRENT_HANDOFF.md
= 현재 implementation continuation owner

docs/CURRENT_STATUS.md
= 장기 구현·검증·ANNUAL/CORE 계보와 evidence ceiling을 보존하는 조건부 Ledger

docs/CURRENT_CONFIRMED_DECISIONS.md
= 승인·대체·병합·과거 CI의 상세 역사 원장

실제 main 코드·테스트
= 구현 사실

ASSET_MANIFEST.yml
= tracked 제품 자산 승인·의미·권리 권위

Google Sheet
= migration-only legacy inventory
```

같은 질문에 여러 문서가 다른 시대의 상태를 말하면 **최신 사용자 지시 → GitHub latest main → Notion current planning → CURRENT_PLANNING_CANON/current-planning-canon.json → CURRENT_DECISION_OVERLAY → CURRENT_HANDOFF → 분야별 current canon → 실제 code/test → 조건부 역사 ledger** 순서로 판정한다.

## 현재 제품·Gate Snapshot

```yaml
product_cadence: ONE_MAIN_CASE_PER_MONTH
initial_slate: M01_TO_M12
continuous_after_m12: true
first_session: M01_AFTERLIFE_STATION
release_near_vertical_slice: M04_RED_UMBRELLA
PLANNING_COMPLETE: true
USER_FINAL_PLANNING_DECLARATION_APPROVED: true
non_visual_planning: COMPLETE
visual_planning: COMPLETE
product_reference_asset: PENDING
overall_plan: COMPLETE
user_final_planning_declaration: APPROVED
visual_treatment: SOFT_ANIME_NOIR_LOCKED
presentation_language: DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM
planning_lock: RELEASED_TO_IMPLEMENTATION_GATE
implementation_reality_gate: HANDOFF_READY_WITH_KNOWN_REALIGNMENT
implementation_contract: READY
runtime_implementation: NOT_AUTHORIZED
canonical_root_runtime_receipt: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

- M01 저승역은 첫 세션·온보딩·회귀 사건이다.
- M04 빨간 우산은 약 30~45분 release-near player-experience Vertical Slice다.
- 사용자 최종 `기획완료` 선언은 반영 완료다.
- 기획 잠금은 implementation gate로 release됐지만 runtime mutation은 자동 승인되지 않았다.
- concrete product-reference asset은 별도 `PENDING`이다.
- `ANNUAL-MVP-001/002`는 current cadence가 아니라 병합된 runtime/history ID다.

## Verified successor와 미완료를 구분한다

### Canon v2 runtime / save migration

현재 main에는 Canon v2 loader, ID registry, save migrator, transaction, active migrating GameState/ValidationSession이 이미 존재한다.

판정:

```text
EXISTING_CANON_V2_RUNTIME_REUSE
```

2026-08-05 migration plan을 처음부터 다시 구현하지 않는다. 과거 `MERGE_NOT_AUTHORIZED` 같은 문구는 그 당시 branch/PR 역사이며, current main의 실제 파일과 autoload가 successor evidence다.

### Composite result

현재 main에는 `RecoveryOutcomePolicy`와 `CanonV2ResultAxesBridge`를 통한 독립 result axes successor가 존재한다.

```text
COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT
```

다만 Canon v2 sidecar에는 legacy `owns_first_s_rank`/`s_rank` current-like authority가 남아 있어:

```text
LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED
```

이다. 새 결과 시스템을 만들지 말고 existing independent axes를 current `COMPOSITE_RESULT` owner로 정합화한다.

### monthly_state

Planning Canon은 top-level optional `monthly_state`를 확정했지만 current runtime 구현은 확인되지 않았다.

```text
MONTHLY_STATE_NOT_IMPLEMENTED
```

additive optional orchestration으로 구현하고 기존 ID rename/legacy report 기반 month-complete 추론/case truth 저장을 금지한다.

### 조사·회수 UI hierarchy

Decision `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`의 runtime 구현은 PR #180을 통해 main에 병합됐다.

현재 main에는 저승역 요청형 manual/progressive disclosure, 조사 focus/pointer-through 보정, contextual cut-in 등이 존재한다. 따라서 과거의 `ui_hierarchy_runtime_implementation: NOT_STARTED` 또는 `BLOCKED_HIGODOT_UNAVAILABLE_IN_CHATGPT_SESSION`은 **predecessor history**다.

다만 current canonical-root runtime receipt와 Human/UI/device validation은 계속 `NOT_RUN`이다.

### Visual/UI planning closure

- M01 packet chain은 Investigation → Deduction → Rescue → Recovery → Composite Result까지 닫혀 있다.
- `SERIAL_EXAM_FATIGUE_GUARD`로 각 Phase가 새 정답 시험이 아니라 같은 규칙의 관측→해석→적용→실행이 되도록 한다.
- 과거 단일 S/A/B 결과 등급은 current `COMPOSITE_RESULT`를 덮어쓰지 않는다.
- concrete image/product reference는 `PRODUCT_REFERENCE_ASSET_PENDING`이다.

### 메인 메뉴 Ver 4.3 중앙화

Issue #181은 실제 main `scripts/ui/main_menu.gd`가 아직 `Ver 4.2` 기준이므로 미완료가 맞다.

최종 기획 완료로 이전 `DEFERRED_VALID / PLAN_LOCK` 보류 상태는 successor에 의해 대체된다.

현재 판정:

```text
CURRENT_VALID / IMPLEMENTATION_GATE
```

기존 2026-08-09 design/implementation plan을 재사용하며 새 main-menu 계획을 중복 생성하지 않는다. 실제 mutation은 runtime implementation 실행 단계에서 한다.

## Validation Router

현재 Validation 책임은 `docs/VALIDATION_TARGET_CANON.md`가 소유한다.

```text
M01_FIRST_SESSION
→ 첫 세션·온보딩·핵심 인과 이해·회귀 검증

M04_RELEASE_NEAR_VERTICAL_SLICE
→ 실제 사용 후보 UI/UX·아트·연출·Audio/VFX·핵심 시스템·콘텐츠를 연결한 30~45분 제품 경험 검증
```

과거 2026-08-02 저승역 단일 35~50분 Validation target은 predecessor history다. Human QA가 새 Router로 이동했다는 것은 Human PASS를 뜻하지 않는다.

## GitHub Issue·PR 규칙

GitHub의 `open` 상태만으로 구현 권한을 만들지 않는다.

```text
current canon / current overlay
→ 실제 main 구현·검증
→ Issue disposition
→ 과거 Issue 본문
```

- 작업 시작 때 open PR과 open Issue를 다시 조회한다.
- 진행 중 PR은 읽기 전용으로 존중한다.
- 병합·종료된 작업은 main에서 successor가 실제 존재하는지 확인한다.
- 완료·대체 Issue를 open 상태로 방치하지 않는다.
- 현재 유효하고 implementation gate로 이동한 Issue는 `CURRENT_VALID`로 유지한다.
- 병합 뒤 open Issue + merge-linked auto-close Issue를 모두 successor freshness로 재검사한다.

## Base 권위

프로젝트가 실제 채택한 Base 릴리스와 pin은:
- `docs/BASE_RULES_VERSION.md`
- `skills/PROJECT_BASE_ADAPTER.json`

이 소유한다. Base remote latest를 자동 채택하지 않는다.

## Work Mode·Skill 라우팅

1. 요청을 `PLAN / BUILD / REVIEW`로 분류한다.
2. `skills/SKILL_REGISTRY.json`에서 프로젝트 분야 Skill 최대 1개를 고른다.
3. 필요한 Base 지원 Skill 최대 3개만 고른다.
4. 실제 Skill 전문을 읽고 수행한다.
5. L1 이상 완료 보고에 선택 이유·변경·증거·미검증을 기록한다.

## 프로젝트 불변 조건

- 공식 기관명은 **괴이 기록국**이다.
- 사건 완료는 안정화 상태, 실패 기록은 위험 사례, 회수 대상은 잔향이다.
- 최종 기록 보상은 괴이 매뉴얼 작성·갱신이다.
- 플레이어 노출 안내자는 기록관 아카다.
- 괴이는 처치 대상이 아니라 규칙을 조사하고 현재 출현을 안정화·회수할 현상이다.
- 관측되지 않은 패턴·정답을 요원·성장·장비·자동행동이 대신 제공하지 않는다.
- M01과 M04의 역할을 서로 대체하지 않는다.
- 기존 Episode/save/report/ANNUAL ID를 current naming에 맞추기 위해 자동 rename하지 않는다.

## 보호 범위

현재 handoff 문서 단계에서는 수정하지 않는다.

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `scripts/`, `scenes/`, `assets/`, `addons/`
- `project.godot`
- save schema·기존 ID·캠페인·경제·엔딩 의미
- Human/runtime evidence

실제 실행은 별도 runtime implementation authorization 뒤 current implementation plan의 RED부터 시작한다.

## 현재 다음 Gate

```text
GitHub latest main + open PR/Issue + Notion readback
→ current Reality Gate / implementation design / plan 확인
→ runtime implementation 명시 실행 권한
→ Task 1: COMPOSITE_RESULT semantic realignment
→ Task 2: legacy grade/save compatibility
→ Task 3: additive monthly_state
→ Task 4: M01_FIRST_SESSION orchestration + SERIAL_EXAM_FATIGUE_GUARD
→ Task 5: #181 기존 plan으로 main menu / Ver 4.3
→ Task 6: M04 shared-system 준비
→ concrete product-reference asset 승인 시 release-near visual/audio/VFX 진행
→ exact-head 자동 회귀 + actual runtime evidence
→ M01/M04 Human QA
→ 병합 뒤 GitHub·Notion readback + Issue successor freshness + 적대적 검토
```

HiGodot 저작 권위가 필요한 제품 Scene·Node·Resource·Project Settings mutation은 해당 권위가 실제 가능한 구현 환경에서만 수행한다.
