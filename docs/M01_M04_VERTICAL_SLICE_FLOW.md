# 괴이기록국 · M01-M04 Vertical Slice Flow

Status: `PLANNING_COMPLETE / IMPLEMENTATION_HANDOFF_READY / IMPLEMENTATION_NOT_AUTHORIZED`

Source PR: #213
Parent canon: `docs/CURRENT_PLANNING_CANON.md`
Implementation design: `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`

## Core flow

Investigation
→ Deduction / Anomaly Manual
→ Victim Rescue
→ Recovery
→ Composite Result

## M01 · First Session responsibility

M01 is the first complete learning case and regression anchor. Opening Record, 제한된 첫 주간 일정, 첫 조사·추리·구출·회수를 한 번의 인과 체험으로 가르친다. 플레이어는 괴이가 단순 처치가 아니라 규칙 이해를 통해 안정화·회수된다는 점을 배운다.

M01 packet chain:

```text
M01_INVESTIGATION_SCENE_PACKET
→ M01_DEDUCTION_SCENE_PACKET
→ M01_RESCUE_SCENE_PACKET
→ M01_RECOVERY_SCENE_PACKET
→ COMPOSITE_RESULT
```

`SERIAL_EXAM_FATIGUE_GUARD`:
- Phase가 바뀔 때마다 별도 정답 체계를 추가하지 않는다.
- 조사에서 얻은 같은 규칙을 추리→구출→회수에서 다른 행동 형태로 재사용한다.
- 추리는 근거 부족 시 현장 복귀가 가능하다.
- 구출은 추리 결과의 적용이며 독립 정답 퀴즈가 아니다.
- 회수는 telegraph-first 실행 긴장으로 전환한다.

## Recovery validation

- Telegraphs and anomaly rules are the primary information.
- Protection target state is more important than enemy HP.
- Character visuals are limited except for important support Cut-ins.
- M01 `목적지 합창 / 회귀 승강장 / 무정차 환송`은 서로 다른 기록 판독을 요구하되 첫 세션에서 연속 독립 시험처럼 제시하지 않는다.

## M04 · Player-experience responsibility

M04 Red Umbrella is the 30~45 minute release-near player-experience Vertical Slice. It reuses the same screen grammar with different:

- anomaly rule
- keyword structure
- rescue logic
- recovery telegraph
- relationship/value conflict
- visual hook

M04는 실제 사용 후보 UI/UX·시각·Audio/VFX·피드백·핵심 시스템·콘텐츠를 연결한 뒤 재미·첫인상·가독성·추리 인과를 Human QA한다. M01은 온보딩/회귀, M04는 제품 경험 검증이므로 서로를 대체하지 않는다.

### M04 출동 타이밍 계약

- M04는 즉시 출동 또는 **한 번만** 준비 후 지연 출동의 두 선택을 보인다.
- 지연은 사전 공개된 준비 이득 1개와 피해자 위험 `+15`의 교환이며, 이득은 정답/히든 진실/자동 규칙을 제공하지 않는다.
- 4주차 `+30` 강제 출동은 별도 escalation boundary로 가시화한다.
- Composite Result가 timing causality를 추리·구출·회수와 분리해 설명한다. M01 온보딩에는 이 복잡도를 추가하지 않는다.

## Visual / asset boundary

- `SOFT_ANIME_NOIR_LOCKED`: main character/key narrative treatment.
- `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`: field terminal/case file/manual UI composition.
- `PRODUCT_REFERENCE_ASSET_PENDING`: concrete images/layers are not yet promoted to product reference.
- Planning completion does not claim runtime visual PASS or Human QA.

## Current implementation boundary

Fresh-main Reality Gate:
- existing Canon v2 runtime/save migration = `REUSE_EXISTING_CANON_V2_RUNTIME`.
- result successor = `COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT`.
- stale sidecar grade semantics = `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED`.
- monthly orchestration = `MONTHLY_STATE_NOT_IMPLEMENTED`.

Current plan: `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`.

## Guardrails

- Planning is complete.
- `runtime_implementation: NOT_AUTHORIZED` until explicit execution authorization.
- No asset promotion while `PRODUCT_REFERENCE_ASSET_PENDING`.
- No Human QA claims before actual sessions.
- No single S/A/B grade may overwrite current composite result.
