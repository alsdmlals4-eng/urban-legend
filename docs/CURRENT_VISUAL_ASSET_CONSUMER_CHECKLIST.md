# 괴이기록국 · Current Visual Asset Consumer Checklist

> Role: `CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST`
> Updated: `2026-08-26`
> Decision: `D-2026-08-26-RUNTIME-CONSUMER-FIRST-VISUAL-ASSET-GATE`
> Scope: planning / visual asset requirement inventory
> Product asset approval: `3 CURRENT ROOT-MANIFEST ENTRIES (M01 Recovery background, B/C, D)`
> Runtime visual validation: `NOT_RUN`
> Human QA: `NOT_RUN`

## 1. Rule

이미지 backlog에는 실제 게임 consumer가 있는 항목만 남긴다.

```text
actual consumer
→ current file
→ reuse review
→ delete test
→ REUSE_REVIEW | REPLACE_REQUIRED | CREATE_REQUIRED
→ consumer-specific brief
→ explicit image approval
→ exactly one image
```

설명용 component sheet는 이미지 backlog가 아니다.

### Status language

- `REUSE_REVIEW`: 실제 consumer와 current file이 모두 존재한다. 교체 전에 현재 파일을 검토한다.
- `REPLACE_REQUIRED`: 실제 consumer와 current file은 존재하지만 승인 시각/정보 계약을 충족하지 못한다는 근거가 확보됐다.
- `CREATE_REQUIRED`: 실제 consumer는 있으나 viable current file이 없다.
- `UI_NOT_IMAGE`: Godot Control/Theme으로 구현되며 별도 이미지가 현재 필요하지 않다.
- `REFERENCE_ONLY`: 승인/검토용 화면 reference이며 현재 texture consumer 파일 자체가 아니다.

## 2. Runtime consumer facts

### Shared presentation

`scripts/ui/scene_presentation.gd`:

- `apply_background(scene, role)` → `ArtLayer/Background: TextureRect`에 episode/role별 texture를 적용한다.
- `apply_anomaly(texture_rect, risk)` → risk-stage anomaly cutout을 먼저 적용하고 없으면 full image를 fallback한다.
- agent strip은 `get_agent_expression()` texture를 사용한다.

`scripts/ui/ui_asset_catalog.gd`가 실제 tracked file path를 연결한다.

## 3. M01 · Afterlife Station

| ID | Actual consumer | Current file | Current status | Delete test / note |
|---|---|---|---|---|
| `IMG-M01-01` | Main Menu backdrop + Dialogue `ArtLayer/Background` + dialogue location preview | `assets/backgrounds/afterlife_entrance.png` | `REUSE_REVIEW` | 없으면 Main Menu identity/background와 오프닝 현장 preview가 사라진다. 같은 파일을 여러 surface가 재사용한다. |
| `IMG-M01-02` | Investigation `ArtLayer/Background` + `LocationPreview` | `assets/backgrounds/afterlife_platform.png` | `REUSE_REVIEW` | 없으면 조사 장소/관측 공간이 사라진다. 별도 location-card 이미지를 만들지 않는다. |
| `IMG-M01-03` | Recovery `ArtLayer/Background` | `assets/backgrounds/afterlife_recovery.png` | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_AND_HUMAN_QA_PENDING` | `M01_RECOVERY_BACKGROUND_ADAPT_01`의 exact bytes가 canonical PNG를 교체했다. Scene/catalog 연결은 기존 route를 재사용하며, import·runtime/Human evidence는 별도 Gate다. |
| `IMG-M01-04` | Recovery `AnomalyVisual` B/C | `assets/anomalies/cutouts/afterlife_b_cutout.png` with `assets/anomalies/afterlife_b.png` fallback | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_AND_HUMAN_QA_PENDING` | `M01_ANOMALY_BC_ADAPT_01`의 exact bytes가 canonical cutout을 교체했다. Scene/catalog/fallback은 변경하지 않으며, import·runtime/Human evidence는 별도 Gate다. |
| `IMG-M01-05` | Recovery `AnomalyVisual` D | `assets/anomalies/cutouts/afterlife_d_cutout.png` with `assets/anomalies/afterlife_d.png` fallback | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VALIDATED_1280 / HUMAN_QA_PENDING` | `M01_ANOMALY_D_ADAPT_01`은 canonical cutout으로 승격됐고 1280×720 live check가 통과했다. 1920×1080 capture와 Human QA는 별도 Gate다. |
| `IMG-M01-06` | Investigation `ManualSurface: TextureRect` | `assets/ui/afterlife/manual_book_frame.png` | `REUSE_REVIEW` | 실제 live Godot text 뒤의 textless surface. |
| `IMG-M01-07` | route-restore minigame full-screen surface | `assets/ui/afterlife/generated/afterlife_metal_panel_v1.png` | `REUSE_REVIEW` | 저승역 최종 노선 복원 runtime surface. |

### M01 Anomaly pixel-review decision · 2026-08-26

- **Reuse current transparent cutouts:** alpha·파일 경로는 맞지만, B/C의 긴 코트 인물과 D의 등진 일반 인물은 `익명 역무원형` 현현과 stage 상승을 전달하지 못한다.
- **Reuse landscape fallbacks:** B fallback은 역 내부 인물 장면, D fallback은 군중 장면이라 `AnomalyVisual`의 단일 현현 owner에 맞지 않고 transparent presentation도 잃는다.
- **Selected — replace with separate transparent candidates:** B/C와 D를 서로 다른 위험 단계의 독립 현현으로 생성·승인한다. 이는 현재 Scene/consumer path를 바꾸지 않는 최소 시각 교정이다.

### M01 UI that is not an image backlog

- Recovery `TelegraphLabel` → `UI_NOT_IMAGE`.
- Recovery `ResponseGrid` / contextual action list → `UI_NOT_IMAGE`.
- 공격 / 보호 / 보조 category UI → `UI_NOT_IMAGE` unless a later implementation explicitly creates an icon texture consumer.
- Composite Result cards/causal strips/tags → current `result_scene.gd` is Control/Theme-built; `UI_NOT_IMAGE`.

## 4. M04 · Red Umbrella

| ID | Actual consumer | Current file | Current status | Delete test / note |
|---|---|---|---|---|
| `IMG-M04-01` | Dialogue background + current-case preview | `assets/backgrounds/red_alley_entrance.png` | `REUSE_REVIEW` | 오프닝/preview surface. |
| `IMG-M04-02` | Investigation `ArtLayer/Background` | `assets/backgrounds/red_crossroads.png` | `REUSE_REVIEW / APPROVED_CANDIDATE_COMPARE_REQUIRED` | 사용자 승인 M04 Investigation Anchor가 이 consumer의 strongest visual candidate다. 기존 tracked file과 promotion/replacement를 비교한다. |
| `IMG-M04-03` | Recovery `ArtLayer/Background` | `assets/backgrounds/red_recovery.png` | `REUSE_REVIEW` | M04 Recovery background. |
| `IMG-M04-04` | Recovery `AnomalyVisual` B/C | `assets/anomalies/cutouts/red_umbrella_b_cutout.png` with full fallback | `REUSE_REVIEW` | actual anomaly consumer. |
| `IMG-M04-05` | Recovery `AnomalyVisual` D | `assets/anomalies/cutouts/red_umbrella_d_cutout.png` with full fallback | `REUSE_REVIEW` | actual high-risk anomaly consumer. |

### M04 layer caution

승인 M04 Investigation Anchor의 `BG_ENVIRONMENT / ANOMALY_UMBRELLA / EVIDENCE_FOOTPRINTS / ATMOSPHERE_RAIN / INTERFERENCE_OPTIONAL`은 production 분리 검토 목표다.

그러나 현재 Investigation scene에 이 5장을 각각 직접 받는 별도 TextureRect consumer가 있다는 증거는 없다.

따라서 layer goal만으로 5장의 신규 이미지 생성을 자동 승인하지 않는다.

## 5. Character / support / contact consumers

### Preparation

- `ProtagonistArt: TextureRect` → `agent_kwon_narae/full_body.png`.
- external contact card portrait → 각 contact `portrait.png`.

### Recovery

- `TeamStatusChip` texture → current expression/cutout source.
- `RepresentativeVisual` short cut-in → current expression texture.
- agent support trigger → 해당 agent `recovery_support.png`가 존재하면 약 0.9초 Cut-in으로 소비된다.

### Current production collection

`UiAssetCatalog`는 MVP043 5명에 대해:

- `full_body`
- `portrait`
- `investigation_support`
- `recovery_support`

를 실제 paths로 등록한다.

외부 접점 4명은:

- `portrait`
- `hq_contact`

paths를 가진다.

### Known wiring caveat

legacy `get_agent_expression()` / `AGENT_ASSETS` / `AGENT_CUTOUT_ASSETS`는 현재 강이준·권나래·오현 3명 중심이다.

윤서하·한유리 production files 존재 자체를 이유로 새 expression sheet를 생성하지 않는다. 필요하면 이는 먼저 runtime wiring/consumer 문제로 분류한다.

## 6. Log guide consumer

`LogGuide`의 실제 portrait consumer는:

- `assets/log/log_normal.png`
- `assets/log/log_focus.png`
- `assets/log/log_warning.png`

이다.

상태색은 별도 ColorRect로 중복 cue를 제공한다.

Current status: `REUSE_REVIEW`.

## 7. Result screen boundary

`scenes/result_scene.tscn`은 root Control만 선언하고 `scripts/scenes/result_scene.gd`가 runtime UI를 구성한다.

현재 결과 화면은 ColorRect/PanelContainer/Label/Button 기반이다.

따라서 다음은 `REFERENCE_ONLY`:

- Composite Result 1단계 정보 위계 mockup — user approved reference.
- Composite Result 2단계 결과 인과 mockup — user approved reference.
- Composite Result 3단계 기록 귀결 mockup — generated, `IN_REVIEW`; approval not inferred.

현재 이 mockup들을 그대로 PNG product asset으로 import하는 계획은 없다.

## 8. Current generation queue

### Confirmed CREATE_REQUIRED

`NONE_PROVEN_YET`.

현재 실제 소비처에는 대부분 tracked file이 존재한다.

### REUSE/REPLACE review order

1. `IMG-M01-03` Afterlife Recovery background — `PROJECT_ASSET_APPROVED`; import/1280×720/1920×1080 runtime and Human QA evidence pending.
2. `IMG-M01-04` Afterlife anomaly B/C — `PROJECT_ASSET_APPROVED`; import/1280×720/1920×1080 runtime and Human QA evidence pending.
3. `IMG-M01-05` Afterlife anomaly D — `PROJECT_ASSET_APPROVED`; 1280×720 runtime evidence recorded, 1920×1080 and Human QA pending.
4. `IMG-M04-02` approved M04 Investigation Anchor vs current `red_crossroads` consumer.
5. `IMG-M01-02` Afterlife Investigation background.
6. `IMG-M01-01` Afterlife Entrance / Dialogue background.
7. M04 Recovery/anomaly consumers.
8. Character/support/contact assets only when a current playable-slice consumer shows a visual gap.

If current binary pixels cannot be inspected in the active session, status remains `REUSE_REVIEW`; do not promote to `REPLACE_REQUIRED` by inference.

## 9. Image-generation rule

Only after `REPLACE_REQUIRED` or `CREATE_REQUIRED` is supported:

```text
one consumer-specific text brief
→ explicit user approval to generate
→ exactly one image
→ stop for result approval
```

No batch generation from checklist gaps.

## 10. Authority / evidence ceiling

Root `ASSET_MANIFEST.yml` is the current tracked product-asset authority and has three current approved M01 entries: Recovery background, B/C anomaly cutout, and D anomaly cutout.

Legacy `assets/ASSET_MANIFEST.json`, tracked PNG presence, `.import` files, existing runtime wiring, and old QA labels do **not** independently grant `PROJECT_ASSET_APPROVED`.

This checklist does not claim:

- product asset approval;
- rights/provenance promotion;
- current binary pixel quality;
- 1280×720 / 1920×1080 runtime visual PASS;
- Human QA;
- POC_PASSED.
