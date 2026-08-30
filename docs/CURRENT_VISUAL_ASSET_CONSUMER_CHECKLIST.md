# 괴이기록국 · Current Visual Asset Consumer Checklist

> Role: `CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST`
> Updated: `2026-08-27`
> Decision: `D-2026-08-26-RUNTIME-CONSUMER-FIRST-VISUAL-ASSET-GATE`
> Scope: planning / visual asset requirement inventory
> Product asset approval: `6 CURRENT ROOT-MANIFEST ENTRIES (M01 Investigation/Recovery backgrounds, B/C, D; M04 Investigation background, B/C)`
> Runtime visual validation: `PARTIALLY_VERIFIED` — M04 Investigation Background + LocationPreview 1280×720/1920×1080 is verified by PR #273; the remaining approved M01/M04 consumers still require their own runtime gates.
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
→ bounded candidate generation (pre-approved workflow)
→ visual-lock / rights / consumer inspection
→ user LOCK | REVISE | REJECT
```

설명용 component sheet는 이미지 backlog가 아니다.

### Status language

- `REUSE_REVIEW`: 실제 consumer와 current file이 모두 존재한다. 교체 전에 현재 파일을 검토한다.
- `REPLACE_REQUIRED`: 실제 consumer와 current file은 존재하지만 승인 시각/정보 계약을 충족하지 못한다는 근거가 확보됐다.
- `CREATE_REQUIRED`: 실제 consumer는 있으나 viable current file이 없다.
- `UI_NOT_IMAGE`: Godot Control/Theme으로 구현되며 별도 이미지가 현재 필요하지 않다.
- `REFERENCE_ONLY`: 승인/검토용 화면 reference이며 현재 texture consumer 파일 자체가 아니다.
- `USER_AUTHORIZED_VISUAL_CANDIDATE`: `D-2026-08-28-VISUAL-CANDIDATE-GENERATION-LOCK-ONLY-APPROVAL`에 따른 생성 후보. 제품 승격이나 runtime 적용은 아니다.

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
| `IMG-M01-01` | Main Menu backdrop + Dialogue `ArtLayer/Background` + dialogue location preview | `assets/backgrounds/afterlife_entrance.png` | `CANDIDATE_RUNTIME_COMPARED / PROMOTION_RECOMMENDED / FINAL_USER_LOCK_REQUIRED` | `M01_ENTRANCE_BACKGROUND_ADAPT_01`은 일반 플랫폼 복도·중앙 빈 표지판/기둥이 entry threshold와 compact preview를 약화해 승격하지 않았다. `M01_ENTRANCE_BACKGROUND_ADAPT_02_20260828`은 descending stair/paired rail/clock landmark를 되돌렸고, 격리된 실제 menu/dialogue consumer 비교와 focused regression을 통과했다. 다만 명시적 최종 `LOCK` 전까지 현행 파일을 유지하며 Main Menu 전용 이미지는 만들지 않는다. 완료형 QA 영수증은 current checklist 밖에서 보존한다. |
| `IMG-M01-02` | Investigation `ArtLayer/Background` + `LocationPreview` | `assets/backgrounds/afterlife_platform.png` | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING` | `M01_INVESTIGATION_PLATFORM_ADAPT_02_20260827` exact bytes가 canonical PNG를 교체했다. Adapt 01은 작은 preview를 막는 중앙 기둥 때문에 승격하지 않았고, Adapt 02는 1280×720·1920×1080의 실제 두 consumer에서 import·resolution·readability를 확인했다. 별도 location-card 이미지는 만들지 않는다. |
| `IMG-M01-03` | Recovery `ArtLayer/Background` | `assets/backgrounds/afterlife_recovery.png` | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING` | `M01_RECOVERY_BACKGROUND_ADAPT_01`의 exact bytes가 canonical PNG를 교체했다. 1280×720·1920×1080 launch profile 실제 consumer에서 import·resolution·readability를 확인했으며, Human QA는 별도 Gate다. |
| `IMG-M01-04` | Recovery `AnomalyVisual` B/C | `assets/anomalies/cutouts/afterlife_b_cutout.png` with `assets/anomalies/afterlife_b.png` fallback | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING` | `M01_ANOMALY_BC_ADAPT_01`의 exact bytes가 canonical cutout을 교체했다. B/C는 1280×720·1920×1080 launch profile 실제 consumer에서 import·resolution·readability를 확인했으며, Human QA는 별도 Gate다. |
| `IMG-M01-05` | Recovery `AnomalyVisual` D | `assets/anomalies/cutouts/afterlife_d_cutout.png` with `assets/anomalies/afterlife_d.png` fallback | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING` | `M01_ANOMALY_D_RUNTIME_CORRECTION_CANDIDATE_20260827` exact bytes가 canonical cutout을 교체했다. 1280×720·1920×1080 실제 D consumer에서 identity escalation과 transparent cutout 가독성을 확인했으며, Human QA는 별도 Gate다. |
| `IMG-M01-06` | Investigation `ManualSurface: TextureRect` | `assets/ui/afterlife/manual_book_frame.png` | `REUSE_ACCEPTED / NO_NEW_IMAGE_REQUIRED / EXISTING_RUNTIME_EVIDENCE_REUSED / HUMAN_QA_PENDING` | Textless book-paper surface owns framing only; live Manual text and controls remain separately readable in the existing 1920×1080 Investigation runtime capture. Current SHA-256 `2e4dd2d2cc646f76060ba0baf1f11b3bdcfc7b2bb8cd6766e6f45627dba96c24`. No replacement or new image is required. |
| `IMG-M01-07` | route-restore minigame full-screen surface | `assets/ui/afterlife/generated/afterlife_metal_panel_v1.png` | `REUSE_ACCEPTED / NO_NEW_IMAGE_REQUIRED / EXISTING_RUNTIME_EVIDENCE_REUSED / HUMAN_QA_PENDING` | Full-rect texture remains a restrained frame behind route tiles and Korean labels in the existing 1920×1080 final-route runtime capture. Current SHA-256 `80efdc2544502c16432b998760e22aada5fe6aae06414db6273b9ee63685acce`. No replacement or new image is required. |

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
| `IMG-M04-01` | Dialogue background + main-menu current-case preview | `assets/backgrounds/red_alley_entrance.png` | `CANDIDATE_RUNTIME_COMPARED / PROMOTION_RECOMMENDED / FINAL_USER_LOCK_REQUIRED` | Current file is strongly photoreal and its convenience-store-like striped sign conflicts with the soft-anime-noir lock. `M04_ENTRANCE_BACKGROUND_ADAPT_01_20260827` removes the brand/text cues, preserves the red umbrella in the actual dialogue read, and passed isolated Dialogue + **non-compact** current-case-preview comparison plus focused regression. `CurrentCasePreview` is hidden below 1500×850; thus 1280×720 validates Dialogue only, while the requested 1920×1080 profile validates both consumers. Keep the canonical file until an explicit final `LOCK`; the completed QA receipt is intentionally kept outside this current checklist. |
| `IMG-M04-02` | Investigation `ArtLayer/Background` + shared `LocationPreview` | `assets/backgrounds/red_crossroads.png` | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING` | `M04_INVESTIGATION_BACKGROUND_ADAPT_01` exact bytes가 canonical PNG를 교체했다. PR #273이 기존 route에서 1280×720/1920×1080 Background·LocationPreview와 배경 관찰성을 검증했다. Human evidence는 별도 Gate다. |
| `IMG-M04-03` | Recovery `ArtLayer/Background` | `assets/backgrounds/red_recovery.png` | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING` | `M04_RECOVERY_BACKGROUND_ADAPT_02_20260828` exact bytes가 canonical PNG를 교체했다. 실제 Battle `Background`가 1280×720·1920×1080에서 경로·환경 크롭을 유지하는 자동 검증을 통과했다. separate B/C·D overlay, Scene mapping, live UI ownership은 유지하며 Human evidence와 release-rights review는 별도 Gate다. |
| `IMG-M04-04` | Recovery `AnomalyVisual` B/C | `assets/anomalies/cutouts/red_umbrella_b_cutout.png` with full fallback | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING` | `M04_ANOMALY_BC_ADAPT_01_20260827` exact bytes가 canonical cutout을 교체했다. 1280×720·1920×1080 actual M04 Recovery `AnomalyVisual`에서 import·resolution·readability를 확인했고, scene/catalog/fallback 경로는 변경하지 않았다. Human QA는 별도 Gate다. |
| `IMG-M04-05` | Recovery `AnomalyVisual` D | `assets/anomalies/cutouts/red_umbrella_d_cutout.png` with full fallback | `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING` | `M04_ANOMALY_D_ADAPT_01` exact RGBA bytes가 canonical cutout을 교체했다. D 단계는 기본적으로 `KEEP_ASPECT_CENTERED`로 투명 여백을 보존하되, 플레이어가 F2 runtime editor에서 저장한 crop preference는 존중한다. 실제 Battle `AnomalyVisual` 경로가 1280×720·1920×1080 자동 검증을 통과했고, Human QA·release-rights는 별도 Gate다. |

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

1. `IMG-M01-03` Afterlife Recovery background — `PROJECT_ASSET_APPROVED / RUNTIME_VERIFIED`; Human QA pending.
2. `IMG-M01-04` Afterlife anomaly B/C — `PROJECT_ASSET_APPROVED / RUNTIME_VERIFIED`; Human QA pending.
3. `IMG-M01-05` Afterlife anomaly D — `PROJECT_ASSET_APPROVED / RUNTIME_VERIFIED`; Human QA pending.
4. `IMG-M04-02` Investigation background — `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED`; Human QA pending.
5. `IMG-M01-02` Afterlife Investigation background — `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED`; Human QA pending.
6. `IMG-M01-01` Afterlife Entrance / Dialogue background.
7. M04 Recovery/anomaly consumers.
8. Character/support/contact assets only when a current playable-slice consumer shows a visual gap.

If current binary pixels cannot be inspected in the active session, status remains `REUSE_REVIEW`; do not promote to `REPLACE_REQUIRED` by inference.

## 9. Image-generation rule

Only after `REPLACE_REQUIRED` or `CREATE_REQUIRED` is supported and a real consumer brief, visual lock, and rights/reuse preflight are present:

```text
one consumer-specific text brief
→ bounded candidate generation without per-image pre-approval
→ inspect against visual lock / rights / actual consumer
→ ask user to LOCK, REVISE, or REJECT
```

No batch generation from checklist gaps, and no candidate is auto-promoted to a product/runtime asset.

## 10. Authority / evidence ceiling

Root `ASSET_MANIFEST.yml` is the current tracked product-asset authority and has seven current approved entries: M01 Investigation background, M01 Recovery background, B/C anomaly cutout, D anomaly cutout, the CASE-01 Lume manual guide portrait, the M04 Investigation background, and the M04 B/C anomaly cutout.

Legacy `assets/ASSET_MANIFEST.json`, tracked PNG presence, `.import` files, existing runtime wiring, and old QA labels do **not** independently grant `PROJECT_ASSET_APPROVED`.

This checklist does not claim:

- product asset approval;
- rights/provenance promotion;
- current binary pixel quality;
- 1280×720 / 1920×1080 runtime visual PASS;
- Human QA;
- POC_PASSED.
