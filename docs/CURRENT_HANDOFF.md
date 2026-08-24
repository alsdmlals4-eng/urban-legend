# 괴이기록국 Current Handoff

> 상태: `PLANNING_COMPLETE / RUNTIME_RECONCILIATION_MERGED / HUMAN_QA_PENDING`
> 기준 main: `9073b4730993149f89970a13fbe32d49f8f473e7` · PR #226 (runtime implementation: `8d303f0f9414950273be934fd28c8fb1b3a21e18` · PR #224)
> 사람용 정본: Notion 괴이기록국 프로젝트 홈
> 구조화 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`

이 문서는 다음 GPT/Codex가 구현 전 handoff나 과거 annual next-step을 현재 권한으로 오인하지 않도록 하는 continuation router다. 실제 구현 사실은 latest `main`의 code/data/Scene/test를 우선한다.

```yaml
status: RUNTIME_RECONCILIATION_MERGED
planning: COMPLETE
user_final_planning_declaration: APPROVED
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
runtime_implementation: MERGED_MAIN
runtime_merge_commit: 8d303f0f9414950273be934fd28c8fb1b3a21e18
product_reference_asset: PENDING
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
```

`PLAN_LOCK`은 predecessor 기획 잠금 식별자이며 현재 값은 `RELEASED_TO_IMPLEMENTATION_GATE`다. 이를 runtime 미승인 상태로 되돌려 해석하지 않는다.

## 1. 재개 순서

```text
최신 사용자 지시
→ GitHub latest main + open PR/Issue + exact-head CI
→ Notion Project Home
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ 실제 current code/data/Scene/test
→ 필요 시 2026-08-22 design/implementation plan과 역사 Ledger
```

## 2. 현재 구현된 제품 계약

- cadence: `ONE_MAIN_CASE_PER_MONTH`.
- result authority: `COMPOSITE_RESULT`.
- legacy S/A/B/S grade는 history/mastery compatibility이며 current incident result를 덮어쓰지 않는다.
- additive optional `monthly_state`가 월간 orchestration을 소유하며 case truth를 저장하지 않는다.
- M01 저승역은 `M01_FIRST_SESSION` 10단계 causal orchestration과 `SERIAL_EXAM_FATIGUE_GUARD`를 사용한다.
- M01은 기존 Canon v2 loader/save migration/result runtime을 재사용한다.
- 메인 메뉴 제품 버전은 `scripts/core/product_version.gd`의 `Ver 4.3`이 중앙 owner다.
- 메인 메뉴는 관제실형 3-rail 구조를 사용하고 Legacy / Validation save·route 분리를 유지한다.
- M04 빨간 우산은 shared Investigation/Manual/Rescue/Recovery/Composite Result validation baseline까지 구현됐다.

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

`PRODUCT_REFERENCE_ASSET_PENDING` 유지:
- concrete M01/M04 이미지·레이어
- rights/source approval
- 최종 1280×720 / 1920×1080 가독성
- release-near M04 visual/audio/VFX polish

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
