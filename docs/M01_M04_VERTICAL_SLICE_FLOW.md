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

- M04의 4주차는 정규 출동일이다. 2주차와 3주차는 더 이른 피해자 보호를 위한 조기 출동 창이다.
- 귀가 기억 노출은 2/3/4주차에 `+0/+15/+30`이며, 조기 출동을 사용하지 않았을 때의 누적 노출이다. 4주차를 지연·강제 벌점으로 표현하지 않는다.
- 권나래의 기존 한 번짜리 능동형 `귀가 기억 고정`은 기본 공포 `-16`·임계치 `+2`를 유지한다. 직접 사용 시 2/3/4주차 준비 tier는 안정화 `+0/+4/+8`을 추가한다.
- `victim_route_memory_exposure`와 지원 실제 사용은 Composite Result에서 추리·구출·회수와 분리해 설명한다. M01 온보딩에는 이 복잡도를 추가하지 않는다.

### M04 순차 후일담 결과 계약

- M04의 결과는 한 화면의 카드·점수·목록이 아니라 `피해자 → 잔향 → 귀가 기억 → 기록국`의 짧은 logical page sequence로 읽는다.
- 한 페이지에는 한 가지 인과와 1~3문장의 후일담만 둔다. 귀가 기억 페이지는 출동 timing·노출·실제 권나래 지원 사용을 같은 준비 인과로만 다룬다.
- 페이지 이동은 명시적 다음 입력을 사용한다. 진행 위치는 알려도 결과 비교표나 점수판을 만들지 않는다.
- 이는 M04의 presentation contract이며 M01·기존 결과 data·등급·보상·Scene 구조를 아직 변경하지 않는다.

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
