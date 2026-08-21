# 괴이기록국 Current Decision Overlay

> 문서 역할: `CURRENT_MUTABLE_DECISION_OVERLAY`
> 상태: `CURRENT / PLAN_LOCK`
> 갱신 기준: 2026-08-21 monthly canon integration 이후
> 상세 역사 결정 원장: `docs/CURRENT_CONFIRMED_DECISIONS.md`

이 파일은 **현재 작업자가 즉시 판단해야 하는 mutable decision과 verified successor state만** 소유한다. `CURRENT_CONFIRMED_DECISIONS.md`는 승인·대체 계보와 과거 검증 증거를 보존하는 상세 원장으로 유지한다. 두 문서가 현재 상태에서 충돌하면 최신 사용자 지시 → GitHub latest main → Notion 현재 기획 → `CURRENT_PLANNING_CANON.md` / `current-planning-canon.json` → 이 Overlay 순으로 해석한다.

## 1. 현재 제품 구조

```yaml
cadence: ONE_MAIN_CASE_PER_MONTH
initial_slate: M01_TO_M12
continuous_after_m12: true
signature_cases: [M01, M04, M07, M10]
first_session: M01_AFTERLIFE_STATION
release_near_vertical_slice: M04_RED_UMBRELLA
core_flow: INVESTIGATION_DEDUCTION_MANUAL_RESCUE_RECOVERY_COMPOSITE_RESULT
```

- M01 저승역은 첫 세션·온보딩·회귀 사건이다.
- M04 빨간 우산은 약 30~45분 release-near player-experience Vertical Slice다.
- 과거 1년 4분기·ANNUAL next-step 문구는 현재 제품 cadence를 소유하지 않는다.
- `ANNUAL-MVP-001/002`는 병합된 runtime/history ID와 기술 자산으로만 보존한다.

## 2. 현재 Gate

```yaml
non_visual_planning: CLOSURE_READY
visual_review: WAITING_USER_DRAFT
overall_plan: OPEN
plan_lock: ACTIVE
runtime_implementation: NOT_AUTHORIZED
canonical_root_runtime_receipt: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

사용자의 전체 기획 완료 선언 또는 명시적 보류 범위, 필요한 시각 시안 검토, fresh-main Reality Gate 전에는 code/data/Scene/save/제품 asset을 수정하지 않는다.

## 3. Verified successor state

### 조사·회수 UI hierarchy

- Decision: `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
- 구현: PR #180 병합 완료.
- 현재 main에는 저승역 요청형 매뉴얼, 의미 있는 focus 복귀, 조사 pointer-through 교정, 회수 대표 요원 contextual cut-in 등 successor 구현이 존재한다.
- 따라서 과거 문서의 `ui_hierarchy_runtime_implementation: NOT_STARTED` 또는 `BLOCKED_HIGODOT_UNAVAILABLE_IN_CHATGPT_SESSION`은 현재 상태가 아니라 predecessor history다.
- 실제 전체 Human/UI/device validation은 별도이며 `NOT_RUN`을 유지한다.

### 메인 메뉴 Ver 4.3 중앙화

- Issue #181은 현재도 유효한 미완료 설계다.
- 현재 main `scripts/ui/main_menu.gd`는 `GAME_VERSION := "Ver 4.2"`를 유지하므로 Ver 4.3 중앙화 완료를 주장하지 않는다.
- 현 단계에서는 `DEFERRED_VALID / PLAN_LOCK`이다. 전체 기획 완료와 runtime 구현 권한 뒤 별도 구현 계약으로 재개한다.

## 4. Workspace authority

- Notion: 사람이 보는 전체 그림, Flow, 비교표, 현재 승인 방향.
- Repository: 구조화 기획 계약, 구현, 테스트, runtime evidence.
- Google Sheet: migration-only legacy inventory. 새 기획·승인·감사 쓰기 금지.
- 의미 변경은 GitHub·Notion을 같은 범위에서 동기화하고 병합 뒤 양쪽을 readback한다.

## 5. Base authority

- 프로젝트가 채택한 Base 릴리스·payload·trusted evidence·registry hash는 `docs/BASE_RULES_VERSION.md`와 `skills/PROJECT_BASE_ADAPTER.json`만 소유한다.
- 다른 current entrypoint에 Base 버전 숫자나 채택 commit을 중복 고정하지 않는다.
- Base 원격 latest main이 전진해도 별도 채택 검증 없이 프로젝트 baseline을 자동 승격하지 않는다.

## 6. Runtime migration boundary

현재 저승역 legacy Episode/PoC/runtime 자료에는 최신 Canon v2와 다른 의미가 남아 있을 수 있다. 이는 `docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`가 선언한 계획된 migration debt다.

- 기존 Episode/save/report/ANNUAL ID를 자동 rename하지 않는다.
- 새 월간 조율은 top-level optional `monthly_state` additive block 방향만 승인됐다.
- 실제 save schema·Episode JSON·Scene 이관은 별도 Reality Gate와 승인 구현 계약 전에는 하지 않는다.

## 7. Issue authority

GitHub Issue의 `open` 상태만으로 현재 구현 권한을 부여하지 않는다.

```text
최신 사용자 지시
→ current canon / current overlay
→ 실제 main 구현·검증
→ Issue disposition
→ 과거 Issue 본문
```

2026-08-21 전수 감사의 disposition receipt는 `docs/audits/2026-08-21-open-issue-and-authority-freshness-correction.md`가 소유한다. 완료·대체된 Issue는 post-merge에 close하고, 실제 미완료이며 현재 결정과 충돌하지 않는 Issue만 `CURRENT_VALID` 또는 `DEFERRED_VALID`로 유지한다.

## 8. 현재 검증 진입점

현재 Validation 책임은 `docs/VALIDATION_TARGET_CANON.md`의 최신 Router를 따른다.

- M01: First Session / onboarding / regression comprehension.
- M04: release-near player-experience Vertical Slice.
- 과거 저승역 단일 35~50분 Validation target은 historical predecessor이며 현재 제품 Validation 권한이 아니다.

실행하지 않은 Runtime·Human·device 검증은 PASS로 승격하지 않는다.