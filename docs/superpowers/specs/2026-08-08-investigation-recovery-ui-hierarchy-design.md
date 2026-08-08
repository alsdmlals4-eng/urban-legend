# Investigation / Recovery UI Hierarchy Design

> 상태: `SPEC_APPROVED / IMPLEMENTATION_PLAN_READY / IMPLEMENTATION_NOT_STARTED`
> 날짜: 2026-08-08
> 명세서 승인: 2026-08-08 20:31 KST
> Decision: `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
> 기준 main: `09c187bf7bd4eb69fa19558d069d46f411d93951`
> Project-adopted Base baseline: `fa69a77a14f923a756064f6ae151d34cadb374f7`
> Current Base remote main observed at approval: `eee98a930219065e30b4d7d14d99d5ac7db44c60`
> Work Mode: `PLAN → REVIEW`
> 구현 권위: `HiGodot only for persistent Godot mutation`
> 구현 계획: `docs/superpowers/plans/2026-08-08-investigation-recovery-ui-hierarchy-implementation-plan.md`

이 문서는 사용자 승인된 조사·회수 UI hierarchy의 written design spec이다. 상세 설계 내용은 같은 Decision의 승인 문서 `docs/decisions/D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT.md`와 구현 계획에서 보존한다.

## 승인된 계약

- 조사 화면은 environment-first로 재구성하고 사건/위치, 현장, 획득 context, 가설 진행, 조사 행동 순으로 읽히게 한다.
- 저승역의 상시 대형 `ManualPanel` 점유를 제거하고 기존 `AnomalyManualDrawer` 계열의 progressive disclosure로 옮긴다.
- 첫 활성 조사 행동의 pointer/keyboard 발견성과 drawer 종료 뒤 의미 있는 focus 복귀를 명시적 계약으로 둔다.
- Canon v2 데이터/API는 유지하되 investigation presentation은 compact/contextual로 제한한다. protection obligation, termination preview, follow-up 상세는 조사 화면에서 상시 펼치지 않는다.
- 회수 화면은 anomaly-centered stage를 유지하고 `RepresentativeVisual`은 stable node를 보존하되 persistent 전장 주체가 아니라 contextual cut-in으로 재해석한다.
- 1280×720에서는 장식·보조 context부터 collapse하며 핵심 행동과 잠금 이유를 숨기지 않는다.
- 1920×1080에서는 case/context/action hierarchy를 동시에 읽을 수 있게 한다.
- 색상 단일 상태 전달을 금지하고 텍스트·형태·아이콘을 함께 사용한다.
- UI는 action/visibility intent만 반환하며 clue truth, hypothesis correctness, obligation status, recovery outcome, reward, save state를 소유하지 않는다.
- `scripts/core/game_state.gd`, `data/episodes/**`, save schema, `project.godot`, 제품 asset bytes와 root `ASSET_MANIFEST.yml`은 이 UI 구현 범위 밖이다.
- 사용자 제공/로컬 `.asset-vault` 레퍼런스는 `REFERENCE_ONLY`; `PROJECT_ASSET_APPROVED` 전 제품 승격 금지다.

## 구현 slice

1. Interaction blocker correction — persistent manual/overlay pointer/focus 문제를 TDD로 먼저 닫는다.
2. Investigation hierarchy — field → context → action presentation 재구성.
3. Canon v2 mode-specific presentation — investigation compact, recovery/result 상세 유지.
4. Recovery hierarchy — anomaly-centered stage + bottom ally/action + contextual detail/cut-in.
5. Exact-head regression — focused SceneTree tests + adopted GUT + full Godot regression.
6. Actual Windows Human/UI QA — `START_HUMAN_QA.cmd`, 18개 판정, 720p/1080p, keyboard/gamepad/accessibility, actual-save restart.

## 미검증 경계

```yaml
implementation: NOT_STARTED
new_runtime_render_1280x720: NOT_RUN
new_runtime_render_1920x1080: NOT_RUN
keyboard_human_validation: NOT_RUN
gamepad_human_validation: NOT_RUN
accessibility_human_validation: NOT_RUN
actual_save_human_validation: NOT_RUN
android_validation: NOT_RUN
project_asset_approved_count: 0
vault_local_state: VAULT_LOCAL_STATE_UNVERIFIED
```

## 실행 Gate

```text
spec approved
→ implementation plan review / exact-head docs CI
→ planning/canon merge gate
→ latest main + Base + Sheet fresh-read
→ separate HiGodot implementation PR
→ TDD RED/GREEN
→ GUT + full regression + exact-head CI
→ actual Windows Human/UI QA
```

HiGodot 권위가 없는 환경에서는 Scene·Node·Resource·Project Settings의 persistent mutation을 시작하지 않는다.
