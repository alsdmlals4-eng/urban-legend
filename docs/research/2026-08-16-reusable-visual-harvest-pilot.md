# Reusable Visual Harvest Pilot — urban-legend

## Status

```yaml
work_mode: REVIEW_TO_PLAN
pilot_status: EVIDENCE_CLASSIFICATION_COMPLETE
canonical_status: PILOT_NOT_CANON
product_asset_mutation: NONE
figma_mutation: NOT_RUN
asset_vault_write: NOT_RUN
layer_decomposition: NOT_RUN
project_asset_approved_change: NONE
project_main_baseline: 83208874e2ddcfe310874e2da23c1c4bb2d2683c
project_adopted_base_version: 9.4.3
project_adopted_base_main: fa69a77a14f923a756064f6ae151d34cadb374f7
base_harvest_reference_commit: e018adb678443f85596582773740cdaa276b4a5e
base_harvest_project_adoption: NOT_CLAIMED
```

이 문서는 Base의 `Reusable Visual Asset Harvest` 설계를 `urban-legend`의 실제 완료된 `main` 자료에 시험 적용한 **프로젝트 전용 Pilot evidence**다. 프로젝트의 Base pin, 제품 자산 승인, Figma 구조, Godot Scene/Resource를 변경하지 않는다.

Base 신규 계약을 프로젝트가 이미 채택했다고 가정하지 않는다. 프로젝트 현행 권위는 Base 9.4.3, 루트 `ASSET_MANIFEST.yml`, `docs/IMAGE_ASSET_WORKFLOW.md`, `docs/planning/ART_PRESENTATION_PLAN.md`, 실제 `main` 코드·Scene·테스트다.

## 1. Pilot 질문

다음 세 종류에서 `primary use -> harvest review -> selective reuse`가 실제로 의미 있는 차이를 만드는지 확인한다.

1. 실제 Godot 인게임/운영 화면 1개
2. 반복 소비되는 배경 이미지 1개
3. 반복 소비되는 UX 시각 자산 1개

검증 질문:

```text
실제 사용되었다고 해서 자동으로 재사용 자산으로 올려도 되는가?
→ 반복 사용 근거가 있는가?
→ 픽셀 자체를 재사용할 가치와 구조/Visual DNA만 재사용할 가치를 구분할 수 있는가?
→ 프로젝트 자산 승인과 Harvest 분류를 분리할 수 있는가?
→ 레이어 분해가 정말 필요한가, 아니면 기존 구조 재사용이 더 싼가?
```

## 2. Authority guard

현재 프로젝트 정본은 다음을 명시한다.

```yaml
asset_manifest_authority: ROOT_ASSET_MANIFEST_YML
project_asset_approved_count: 0
legacy_asset_manifest_json: LEGACY_MIGRATION_PENDING_NON_AUTHORITY
vault_local_state: VAULT_LOCAL_STATE_UNVERIFIED
image_product_promotion: BLOCKED_NO_PROJECT_ASSET_APPROVED
```

따라서 이 Pilot의 `REUSE_*`, `STRUCTURE_PATTERN`, `STYLE_DNA` 판정은 **재사용 후보 분류**일 뿐 `PROJECT_ASSET_APPROVED`, tracked 제품 자산 승인, Figma Final, Godot runtime proof를 부여하지 않는다.

`assets/ASSET_MANIFEST.json`의 과거 `final`/QA 표기도 제품 승인 근거로 사용하지 않는다.

## 3. Pilot A — 실제 런타임 화면

### Source evidence

```yaml
source_type: GODOT_RUNTIME_CAPTURE
workflow: Capture ANNUAL-MVP-001 Visual QA
workflow_run: 31314464604
workflow_conclusion: SUCCESS
artifact_id: 9038332622
artifact_name: annual-mvp-001-002-visual-qa
artifact_digest: sha256:2aa74f70085adce2dca69096e0ef8a8329d9bcdf037150a7e0db75845799165f
capture: annual-qa-artifacts/annual-mvp-002/annual-mvp-002-preparation_1920x1080.png
capture_sha256: ab46d14cdc27dec840cc2c911620878c3739f7fcabaef7254360421ecdeee6ef
phase: PREPARATION
resolution: 1920x1080
```

Artifact manifest에는 같은 PREPARATION 화면의 `1280x720`/`1920x1080` 캡처와 선택된 동료·장비·지원 상태가 함께 기록되어 있다.

### Observed screen structure

실제 캡처에서 확인한 구성:

- 상단: 수직절편/현재 단계·주차·핵심 상태 요약
- 중단: 동료 3명 카드와 선택/비선택 toggle 상태
- 중단 이후: 동료별 공용 지원 select row
- 하단: 주 장비·모듈 선택과 조건/확률/준비도 상세 설명
- 화면 전체: 고대비 어두운 배경, 얇은 경계, 선택 상태에 제한적인 금색 강조

### Harvest decision

```yaml
primary_use_automated_capture: PASS
primary_use_human_visual_quality: NOT_RUN
reuse_classification:
  - STRUCTURE_PATTERN_CANDIDATE
style_dna_promotion: DEFER
pixel_asset_reuse: REJECT_NOT_APPLICABLE
layer_decomposition: NOT_NEEDED
```

채택 후보:

- `선택 가능한 동료 카드 -> 선택/비선택 상태 -> 세부 지원 설정`의 정보 구조
- `상위 선택 -> 하위 세부 설정 -> 조건/확률 설명` progressive disclosure 원리
- 1280×720/1920×1080 쌍을 같은 구조 검증에 사용하는 QA 방식

채택하지 않는 것:

- 현재 PoC 캡처 자체의 화면 스타일을 프로젝트 Visual DNA로 승격
- 런타임 스크린샷에서 버튼/카드를 잘라 raster 자산으로 재사용
- 자동 레이어 분해

이 화면은 자동 runtime evidence로서 **구조 학습 자료**에는 충분하지만 Human visual QA가 없으므로 시각 정본이나 최종 UX 표현으로 승격하기에는 근거가 부족하다. 이것이 `primary use evidence != reusable visual approval`의 첫 실증이다.

## 4. Pilot B — 배경 자산

### Source evidence

```yaml
source_path: assets/backgrounds/afterlife_entrance.png
source_role: BACKGROUND
tracked_file_exists: YES
runtime_catalog_binding: YES
project_asset_approved: NO
pixel_review_this_pilot: NOT_RUN
```

`UiAssetCatalog`는 이 파일을 `afterlife_entrance`로 등록하며 다음 두 별도 사건의 `dialogue` 배경에 동일 ID를 사용한다.

```text
episode_001_afterlife_station.dialogue -> afterlife_entrance
episode_003_dead_frequency_station.dialogue -> afterlife_entrance
```

즉, **둘 이상의 실제 소비 경로라는 반복 가치 근거**가 이미 존재한다.

### Harvest decision

```yaml
primary_use_binding: CONFIRMED
primary_use_human_visual_quality: NOT_RUN
reuse_classification:
  - REUSE_AS_IS_CANDIDATE
  - STYLE_DNA_CANDIDATE
second_use_evidence: CODE_BINDING_CONFIRMED
asset_authority_gate: BLOCKED_PROJECT_ASSET_APPROVED_0
layer_decomposition: DEFER_NO_NEED_PROVEN
```

이 자산은 "잘라낼 수 있어서"가 아니라 **이미 두 사건에서 같은 역할로 소비되고 있어서** 재사용 후보가 된다.

다만 다음은 아직 주장하지 않는다.

- 이미지 픽셀 품질이 현재 Art Direction을 만족한다.
- 두 사건에서 동일 배경 재사용이 최종 아트 방향으로 적절하다.
- tracked 파일이라는 이유만으로 현재 제품 승인 자산이다.
- parallax/depth layer 분해가 필요하다.

배경 layer 분해는 카메라 pan/parallax, 전경 occluder 재배치, 동일 장소의 시간대 variant 등 실제 두 번째 요구가 생길 때만 연다.

## 5. Pilot C — UX 시각 자산

### Source evidence

```yaml
source_path: assets/ui/afterlife/generated/afterlife_metal_panel_v1.png
source_role: UX_SURFACE_TEXTURE
tracked_file_exists: YES
project_asset_approved: NO
pixel_review_this_pilot: NOT_RUN
```

실제 `main`에서 두 종류의 소비가 확인된다.

1. `scenes/investigation_scene.tscn`
   - `Texture2D` external resource로 등록
2. `scripts/scenes/minigame_scene.gd`
   - 저승역 route-restore UI의 full-screen `TextureRect` surface로 load

즉 동일 raster surface가 조사 UI와 현장 검증 미니게임 UI에서 이미 재사용된다.

### Harvest decision

```yaml
primary_use_binding: CONFIRMED_TWO_CONSUMERS
primary_use_human_visual_quality: NOT_RUN
reuse_classification:
  - REUSE_AS_IS_CANDIDATE
  - STYLE_DNA_CANDIDATE
variant_seed: DEFER
semantic_rebuild: NOT_REQUIRED_BY_CURRENT_EVIDENCE
asset_authority_gate: BLOCKED_PROJECT_ASSET_APPROVED_0
layer_decomposition: NOT_NEEDED
```

이 결과는 UX라고 해서 항상 raster를 버리고 component로 다시 만들어야 하는 것도 아님을 보여준다. **순수 surface texture**는 여러 구조적 UI가 그 위에 독립적으로 배치될 수 있으므로 raster 자체 재사용이 합리적일 수 있다.

반대로 버튼·label·상태 UI를 이 이미지에서 crop해 장기 컴포넌트로 만드는 것은 금지한다. 인터랙션/현지화/상태는 현행 Godot Theme·Control 구조가 소유한다.

## 6. Comparative finding

| Pilot | 반복 가치 근거 | 현재 권장 분류 | 레이어 분해 | 제품 승인 |
| --- | --- | --- | --- | --- |
| runtime PREPARATION screen | 실제 1280/1920 runtime capture | `STRUCTURE_PATTERN_CANDIDATE` | 불필요 | 해당 없음 |
| `afterlife_entrance.png` | 두 사건 dialogue 역할 | `REUSE_AS_IS_CANDIDATE + STYLE_DNA_CANDIDATE` | 필요 증거 없음 | BLOCKED |
| `afterlife_metal_panel_v1.png` | 조사 Scene + 미니게임 UI | `REUSE_AS_IS_CANDIDATE + STYLE_DNA_CANDIDATE` | 불필요 | BLOCKED |

핵심 결론:

```text
실사용됨 != 재사용 시각 정본
반복 소비됨 = Harvest 후보 근거
Harvest 후보 != PROJECT_ASSET_APPROVED
구조 재사용 가능 = raster layer 분해 필요 없음
레이어 분해는 재사용 목적이 구조/기존 bytes로 해결되지 않을 때만 사용
```

## 7. Adversarial review

### Attack 1 — 오래된 tracked asset을 재사용 성공 사례로 과장할 위험

판정: `MUST_GUARD`.

- 현재 루트 Manifest 승인 0건을 유지한다.
- legacy inventory의 `final`/QA 문구를 제품 승인으로 사용하지 않는다.
- 현재 Pilot은 code consumption만 확인하고 Human visual quality는 `NOT_RUN`으로 둔다.

### Attack 2 — PoC runtime 화면을 스타일 정본으로 축적할 위험

판정: `MUST_GUARD`.

- runtime screen은 `STRUCTURE_PATTERN_CANDIDATE`까지만 허용한다.
- Visual DNA 승격은 별도 Human/Art review 뒤에만 가능하다.

### Attack 3 — "레이어화" 기능을 보여주기 위해 불필요한 decomposition을 강제할 위험

판정: `REJECT`.

이번 세 입력 중 자동 분해가 필수인 항목은 없다. 첫 Pilot에서 decomposition을 실행하지 않는 것이 오히려 Base 설계의 YAGNI/Harvest Gate가 작동한다는 증거다.

### Attack 4 — Base 최신 main을 프로젝트 채택으로 오인할 위험

판정: `MUST_GUARD`.

- Base `e018adb...`는 이 Pilot의 비교 기준일 뿐이다.
- 프로젝트 Base pin은 9.4.3/`fa69a77...`로 유지한다.
- 별도 adoption/sync 검증 없이 `docs/BASE_RULES_VERSION.md`를 갱신하지 않는다.

### Attack 5 — 진행 중 PR과 충돌할 위험

판정: `MUST_GUARD`.

- Pilot은 `urban-legend/main@83208874...`의 완료된 상태만 읽는다.
- 열린 Draft PR의 branch/changed files를 수정하지 않는다.
- Pilot PR은 이 새 evidence 문서만 소유한다.

## 8. Next executable gate

### Gate A — Project adoption / local Vault readiness

현재 차단:

```yaml
project_harvest_contract_adoption: NOT_DONE
project_asset_vault_config: NOT_TRACKED
vault_local_state: VAULT_LOCAL_STATE_UNVERIFIED
base_record_harvest_on_user_pc: NOT_RUN
```

다음 변경은 별도 검토 단위로 진행한다.

1. 프로젝트가 Base Harvest 계약을 어떤 범위로 채택할지 결정한다.
2. 필요 시 프로젝트 전용 `PROJECT_ASSET_VAULT.json`을 Base v2 기본값과 현재 `.gitignore`에 맞춰 추가한다.
3. 사용자 PC에서 `init`을 실행해 `.asset-vault/`와 `assets/_vault_local/`을 실제 생성·확인한다.
4. 제품 자산을 건드리지 않는 test fixture/복사본으로 `record-harvest`를 한 번 실행한다.
5. 생성된 `.asset-vault/harvest.json`이 local-only이고 `promote`/Figma/Godot 제품 경로를 건드리지 않았는지 확인한다.

### Gate B — First actual decomposition experiment

Gate A가 통과한 뒤에도 바로 모델을 설치하지 않는다.

다음 중 하나가 실제로 발생할 때만 이미지 1장으로 시작한다.

- 배경 parallax/depth 분리가 필요하다.
- 하나의 장면 합성에서 독립 prop/foreground를 다른 장면에 재사용해야 한다.
- 독립 캐릭터/오브젝트가 가림 영역까지 필요하다.

그때 `SOURCE_LAYER -> MASK_CUTOUT -> MANUAL_OR_SEMANTIC_REBUILD -> DERIVED_GENERATIVE_RECOVERY` 순서로 가장 낮은 위험 방식부터 시험한다.

## 9. Pilot completion evidence

```yaml
base_postmerge_ci: VERIFIED_SEPARATELY_ON_BASE_MAIN
project_main_read: YES
project_canon_read: YES
actual_runtime_capture_bytes_inspected: YES
runtime_capture_hash_recorded: YES
background_multi_consumer_binding: VERIFIED
ux_surface_multi_consumer_binding: VERIFIED
human_visual_quality: NOT_RUN
tracked_asset_product_approval: NO
figma_reusable_reference_write: NOT_RUN
asset_vault_write: NOT_RUN
layer_decomposition: NOT_RUN_BY_DESIGN
same_goal_open_pr_before_pilot: NONE
```

## 10. Rollback

이 Pilot의 repository 변경은 이 문서 한 파일뿐이다. 되돌릴 때 이 문서/PR만 폐기한다. 제품 자산, Scene, Resource, Base pin, Figma, Sheet, `.asset-vault`, 사용자 로컬 파일은 변경하지 않는다.
