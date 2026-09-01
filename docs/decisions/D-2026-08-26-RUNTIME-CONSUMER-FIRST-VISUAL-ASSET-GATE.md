# D-2026-08-26-RUNTIME-CONSUMER-FIRST-VISUAL-ASSET-GATE

Status: `APPROVED_BY_USER`
Date: `2026-08-26`
Scope: visual planning / image generation / asset requirement gate
Runtime implementation: `NOT_CHANGED_BY_THIS_DECISION`
Product asset promotion: `NOT_GRANTED`
Human QA: `NOT_RUN`

## Decision

괴이기록국의 신규 이미지 제작은 **설명용 시트가 아니라 실제 게임 소비처가 있는 이미지**를 기준으로 한다.

이미지 후보는 생성 전에 반드시 다음을 연결한다.

```text
actual Scene / Control / Texture consumer
→ current file or reusable project asset
→ Delete Test
→ REUSE_REVIEW | REPLACE_REQUIRED | CREATE_REQUIRED
→ text brief
→ explicit image-generation approval
→ exactly one image
→ result approval
→ promotion/runtime validation as separate gates
```

`PanelContainer`, `Label`, `Button`, `GridContainer`, Theme/StyleBox 등 Godot UI로 구현되는 정보 구조를 설명하기 위한 PNG 시트는 기본적으로 만들지 않는다.

## Selected approach

### A. Explanation-sheet first

Telegraph Badge, Context Action List, Category Bar, Composite Result card를 각각 설명용 이미지 시트로 만든다.

- 장점: 디자인 설명은 쉽다.
- 단점: 실제 runtime consumer와 분리되어 있고 Godot UI/Theme과 중복되며, 설명 이미지가 잘못된 asset backlog로 승격될 위험이 크다.
- 판정: `REJECTED`.

### B. Hybrid explanation + runtime assets

설명용 시트와 실제 소비 이미지를 병행 제작한다.

- 장점: 문서 전달력과 production 참고를 동시에 얻을 수 있다.
- 단점: 동일 의미를 두 번 제작하고 승인 상태가 갈라지며 solo-project 비용과 drift가 커진다.
- 판정: `DEFERRED / ONLY_IF_EXPLANATORY_NEED_IS_SEPARATELY_PROVEN`.

### C. Runtime-consumer first

실제 `TextureRect`/background/anomaly/portrait/cut-in/VFX consumer가 있는 파일만 이미지 backlog에 남기고 UI 구조는 Godot Control/Theme으로 다룬다.

- 장점: 실제 플레이 화면과 직접 연결되고, 재사용 우선·Delete Test·product asset gate를 유지하며 불필요한 이미지 생성을 줄인다.
- 판정: `SELECTED`.

## Fresh runtime evidence

### Recovery

`scenes/battle_scene.tscn`의 실제 이미지 소비 슬롯:

- `ArtLayer/Background`
- `CinematicStage/RepresentativeVisual`
- `CinematicStage/AnomalyPanel/Content/AnomalyVisual`

반면 전조와 행동 구조는 현재 `Label`, `GridContainer`, `PanelContainer`, `Button` 계열이다.

`ScenePresentation.apply_background()`은 `UiAssetCatalog.get_background_id()`와 실제 Texture 파일을 연결한다.
`ScenePresentation.apply_anomaly()`은 위험 단계에 따라 anomaly cutout/full texture를 연결한다.

### Result

현재 `scenes/result_scene.tscn`은 루트 Control만 선언하고 `scripts/scenes/result_scene.gd`가 `ColorRect`, `PanelContainer`, `Label`, `Button`으로 결과 화면을 구성한다.

따라서 지금까지 승인한 Composite Result mockup은 **UI/visual direction reference**이며 현재 제품 PNG consumer 자체가 아니다.

### Preparation / contacts / guide

실제 소비 중인 이미지 예:

- 권나래 `full_body` → Preparation protagonist art.
- 외부 접점 4명 `portrait` → Preparation contact cards.
- 요원 `recovery_support` → Recovery support cut-in.
- 기록관 아카 절차 통신 → text-first `LogGuide`; portrait asset 없음.

## Current consumer inventory

### M01

- `assets/backgrounds/afterlife_entrance.png` → Main Menu backdrop + dialogue background/preview.
- `assets/backgrounds/afterlife_platform.png` → Investigation background + location preview.
- `assets/backgrounds/afterlife_recovery.png` → Recovery background.
- `assets/anomalies/cutouts/afterlife_b_cutout.png` → Recovery anomaly B/C visual, with full-image fallback.
- `assets/anomalies/cutouts/afterlife_d_cutout.png` → Recovery anomaly D visual, with full-image fallback.
- `assets/ui/afterlife/manual_book_frame.png` → Investigation ManualSurface.
- `assets/ui/afterlife/generated/afterlife_metal_panel_v1.png` → route-restore minigame background surface.

### M04

- `assets/backgrounds/red_alley_entrance.png` → dialogue/current-case preview.
- `assets/backgrounds/red_crossroads.png` → investigation background.
- `assets/backgrounds/red_recovery.png` → recovery background.
- `assets/anomalies/cutouts/red_umbrella_b_cutout.png` → recovery anomaly B/C visual.
- `assets/anomalies/cutouts/red_umbrella_d_cutout.png` → recovery anomaly D visual.

### Character/support

`UiAssetCatalog` already maps the five MVP043 agents to `full_body`, `portrait`, `investigation_support`, `recovery_support` production files, and four external contacts to `portrait`/`hq_contact` files.

## Asset authority warning

Root `ASSET_MANIFEST.yml` currently records `PROJECT_ASSET_APPROVED` assets as **0**.

Tracked runtime files and legacy `assets/ASSET_MANIFEST.json` history therefore prove existence/runtime path, not current product-asset approval.

Do not infer `PROJECT_ASSET_APPROVED`, rights approval, runtime visual PASS, or Human QA from file presence.

## Immediate work order

1. Stop generating UI explanation/component sheets.
2. Treat approved Recovery and Composite Result mockups as reference/decision evidence only unless an actual runtime texture consumer is separately defined.
3. Review current runtime-consumed assets in this order:
   - M01 Recovery background.
   - M01 Recovery anomaly B/C and D visuals.
   - M01 Investigation/dialogue backgrounds.
   - M04 approved Investigation Anchor against the real `red_crossroads` consumer.
   - character/support assets only where an actual consumer lacks a suitable current file.
4. For every candidate, classify:
   - `REUSE_REVIEW`: current file exists; inspect before replacing.
   - `REPLACE_REQUIRED`: current file exists but fails approved visual/information contract.
   - `CREATE_REQUIRED`: actual consumer exists and no viable file exists.
5. If current binary cannot be visually inspected in the active session, do **not** guess that replacement is required. Continue with inventory/brief planning that does not depend on that pixel comparison.

## Generation boundary

For a `REPLACE_REQUIRED` or `CREATE_REQUIRED` image:

1. write one consumer-specific text brief;
2. obtain explicit user image-generation approval;
3. generate exactly one image;
4. stop for result approval;
5. only then consider source/layer/provenance/promotion/runtime validation.

## Superseded image backlog items

The following are removed from the **image-generation** backlog unless a separate actual texture consumer is later proven:

- Recovery Telegraph Badge state sheet.
- Recovery Context Action List sheet.
- Attack / Protect / Support Category Bar sheet.
- Composite Result Axis Card sheet.
- Composite Result causal strip sheet.
- Composite Result record-consequence tag sheet.
- generic public UI component explanation sheets.

They may still exist as Godot UI/UX design tasks.

## Evidence ceiling

This decision proves a planning/production gate only.

It does not prove:

- any existing PNG matches the latest approved style;
- any tracked file is current product-approved;
- any image has passed 1280×720 / 1920×1080 runtime readability;
- rights/provenance promotion;
- Human QA;
- POC_PASSED.
