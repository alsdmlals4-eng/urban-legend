# IMG-M04-02 · Red Crossroads Investigation Background · Promotion Requirement

Status: `USER_APPROVED_VISUAL_CANDIDATE / RUNTIME_CONSUMER_COMPARE_PENDING / PRODUCT_REFERENCE_ASSET_PENDING`
Decision: `D-2026-08-26-RUNTIME-CONSUMER-FIRST-VISUAL-ASSET-GATE`
Route: `M04_RED_UMBRELLA`
Consumer:
- `scenes/investigation_scene.tscn -> ArtLayer/Background`
- same texture reused by `LocationPreview`
Current tracked file: `assets/backgrounds/red_crossroads.png`
Approved challenger: `M04_INVESTIGATION_ANCHOR_01`
Approved challenger receipt: `docs/visual/M04_PRODUCT_REFERENCE_APPROVAL_BRIEF.md`
New image generation: `NOT_REQUIRED_BY_THIS_GATE`

## 1. Goal

사용자 승인된 `비 오는 골목의 빨간 우산 · Investigation Anchor`가 실제 게임 consumer `red_crossroads`에 들어갈 수 있는지 **승격/교체 관점에서 비교**한다.

이 Gate는 승인 후보가 있다는 이유로 current tracked PNG를 즉시 교체하지 않으며, current file이 있다는 이유로 승인 후보를 reference-only에 영구 고정하지도 않는다.

## 2. Actual runtime role

M04 episode data는:

```text
dialogue background      → red_alley_entrance
investigation background → red_crossroads
recovery background      → red_recovery
```

으로 분리한다.

`investigation_scene.gd`는 `ScenePresentation.apply_background(self, "investigation")`으로 `red_crossroads`를 full background에 넣고, 같은 texture를 `LocationPreview`에도 복사한다.

따라서 승인 M04 Anchor의 primary destination은 **실제 Investigation background consumer**다.

## 3. Current canon the candidate must preserve

사건명: **비 오는 골목의 빨간 우산**.

현재 사건 데이터:

- 유형: 반복 경로형 괴담.
- 장소: 폐쇄 상가 뒤편의 골목 사거리 계열.
- 현상: 빨간 우산과 **젖지 않은 발자국**이 귀가 경로를 되감는다.
- 규칙 단서: **세 번째 빗소리** 뒤에만 붉은 우산 손잡이가 관측된다.
- 피해자는 반복되는 귀가 경로에 갇혀 있다.

승인 후보의 의미도 이 계약을 기준으로 한다.

## 4. Promotion alternatives

### A. Keep current tracked `red_crossroads.png` without comparison

승인 후보는 사람용 reference로만 유지하고 runtime 파일을 바꾸지 않는다.

- 장점: 변경 위험이 없다.
- 문제: 사용자가 승인한 현재 시각 방향을 실제 consumer로 연결할 기회를 검증하지 않는다.
- 문제: current tracked file이 최신 visual direction보다 낫다는 증거가 없다.
- 판정: `REJECTED_AS_DEFAULT`.

### B. Replace current tracked file immediately with approved candidate

사용자 시각 승인을 product/runtime 승인으로 간주하고 바로 교체한다.

- 장점: 가장 빠르게 승인 방향을 게임 파일과 맞춘다.
- 문제: current file pixel compare, crop, rights/provenance promotion, runtime readability가 끝나지 않았다.
- 문제: `USER_APPROVED_VISUAL_CANDIDATE`를 `PROJECT_ASSET_APPROVED`로 과승격한다.
- 판정: `REJECTED`.

### C. Consumer promotion compare gate

승인 후보를 **preferred challenger**로 두고 current tracked `red_crossroads.png`와 같은 실제 consumer 조건에서 비교한다.

```text
current file + approved candidate
→ full Investigation background crop
→ LocationPreview crop
→ evidence readability / no-answer-spoil
→ rights/provenance / source suitability
→ REUSE_CURRENT | PROMOTE_CANDIDATE | ADAPT_CANDIDATE
```

- 장점: 사용자 승인 방향을 실제 게임에 연결하면서 asset evidence ceiling을 지킨다.
- 장점: 불필요한 재생성을 막는다.
- 판정: `SELECTED`.

## 5. Approved challenger receipt

`M04_INVESTIGATION_ANCHOR_01`:

- status: `USER_APPROVED_VISUAL_CANDIDATE`.
- approved: `2026-08-24`.
- source size: `1672x941`.
- recorded SHA-256: `4c67a65c9f7469bf39c231c81710fd71f0796501d13231c8fd7020bdad20462f`.
- Notion Visual surface native attachment/readback: recorded PASS.
- product asset promoted: false.
- runtime visual validation: `NOT_RUN`.

이 receipt는 후보 존재/사용자 시각 승인을 증명하지만 현재 runtime file과의 우열은 증명하지 않는다.

## 6. Consumer-specific visual requirement

### 3-second hierarchy

```text
1. 현실적인 한국의 젖은 골목 사거리
2. 빨간 우산의 규칙적으로 잘못된 존재
3. 젖은 노면과 어긋나는 발자국/물기 흔적
4. 반복되는 귀가 경로를 의심하게 하는 공간 방향감
5. 비·습기·잔향 atmosphere
```

캐릭터 poster가 이 hierarchy를 덮지 않는다.

### Environment

- 폐쇄 상가 뒤편의 현실적인 한국 골목 사거리.
- 셔터, 간판 형태, 전선, 배수구, 노면, 건물 깊이 등 생활감.
- 비가 막 멈췄거나 약해진 상태의 젖은 표면.
- 과도한 cyberpunk/neon보다 실제 도시 환경 우선.

### Anomaly anchor

- 빨간 우산 또는 손잡이가 현실 장면 속에서 **규칙적으로 끼어든 이상**으로 보인다.
- 보스 포스터처럼 중앙에서 공격하지 않는다.
- 붉은색 하나만이 아니라 실루엣/반복 위치/명암으로도 anomaly가 읽힌다.

### Evidence anchor

- 젖은 노면과 어긋나는 **젖지 않은 발자국/물기 비껴감**.
- 색이 아니라 표면 질감·반사·경계 차이도 사용한다.
- 배경에서 보인다는 것은 “관측 가능”을 뜻하며, 자동으로 기록 획득/정답 확정을 뜻하지 않는다.

### Time/audio rule boundary

`세 번째 빗소리`는 정지 이미지 하나가 증명할 수 없다.

- 빗물 잔향, 반복되는 물방울, CCTV/센서 간섭 같은 보조 흔적은 가능.
- `3회째`, 정확한 타이밍, 정답 문구를 baked text로 노출하지 않는다.
- 실제 time/audio 판단은 runtime Audio/record/interaction이 완성한다.

## 7. Full background + LocationPreview geometry

### Full Investigation background

- `STRETCH_KEEP_ASPECT_COVERED`를 견딘다.
- live Investigation UI가 화면 대부분을 점유해도 중앙 환경 identity와 anomaly focal이 남는다.
- 하단/패널 뒤에만 핵심 evidence를 두지 않는다.

### LocationPreview

같은 texture가 작은 wide preview로 소비된다.

- 중앙 50~60%에서 골목 사거리 + 빨간 우산 identity가 살아야 한다.
- 젖지 않은 발자국은 preview에서 반드시 완전 판독될 필요는 없지만, full view에서는 조사 가능한 evidence로 읽혀야 한다.
- edge-only umbrella/focal은 crop 위험 때문에 피한다.

## 8. Layer / reuse boundary under consumer-first rule

기존 approval brief의 production decomposition 목표:

- `BG_ENVIRONMENT`
- `ANOMALY_UMBRELLA`
- `EVIDENCE_FOOTPRINTS`
- `ATMOSPHERE_RAIN`
- `INTERFERENCE_OPTIONAL`

은 **재사용/production-source 검토 언어**다.

현재 Investigation scene은 이 다섯 layer를 각각 직접 받는 별도 Texture consumer를 증명하지 않는다.

따라서:

- 5개 layer goal을 곧바로 **5장 신규 생성 quota**로 해석하지 않는다.
- 현재 single background consumer에는 flattened 16:9 candidate가 의미상 유효할 수 있다.
- layer가 실제 runtime animation/variant에 필요해지면 그때 consumer를 먼저 정의한다.
- candidate source가 selective layer/rebuild에 적합한지는 product-reference promotion 시 별도 검토한다.

## 9. Candidate comparison checklist

Current tracked file과 approved challenger를 같은 조건에서 본다.

### Visual direction

- `SOFT_ANIME_NOIR_LOCKED`와 맞는가.
- 환경 → 괴이 → 증거 순서가 읽히는가.
- 캐릭터가 장면을 지배하지 않는가.

### Canon safety

- 빨간 우산 / 젖지 않은 발자국 / 반복 경로 의미가 current case와 맞는가.
- 세 번째 빗소리 정답을 문자/확률/표식으로 폭로하지 않는가.
- M01 저승역 truth를 섞지 않는가.

### Runtime consumer

- 1280×720 full Investigation에서 focal이 남는가.
- 1920×1080에서 빈 공간/정보 위치가 깨지지 않는가.
- small LocationPreview crop에서 장소+umbrella identity가 유지되는가.
- live UI text/choices와 겹쳐 evidence가 사라지지 않는가.

### Production

- baked UI/텍스트 없음.
- rights/provenance receipt가 promotion에 충분한가.
- 필요한 source/layer/reuse 전략이 있는가.
- import/performance가 current target에 적합한가.

## 10. Outcomes

### `REUSE_CURRENT`

현재 tracked `red_crossroads.png`가 approved challenger보다 consumer 조건을 더 잘 만족하면 유지한다.

### `PROMOTE_CANDIDATE`

승인 challenger가 current file보다 명확히 낫고 rights/source/runtime readability Gate를 통과하면 실제 `red_crossroads` product-reference/promotion 경로를 연다.

### `ADAPT_CANDIDATE`

승인 challenger의 visual direction은 맞지만 crop/source/layer/readability 문제만 bounded 수정하면 해결될 때 사용한다.

이 경우에도 바로 새 이미지를 만들지 않는다. 먼저 **무엇을 수정해야 실제 consumer가 통과하는지**를 구체적으로 적고, 이미지 편집이 필요할 때만 one-image approval cycle을 연다.

## 11. Current evidence status

현재 session에서는 tracked `assets/backgrounds/red_crossroads.png` binary pixels를 직접 확인하지 못했다.

따라서:

- `REUSE_CURRENT` 미판정.
- `PROMOTE_CANDIDATE` 미판정.
- `ADAPT_CANDIDATE` 미판정.
- **새 image generation 불필요.**

현재 상태는 `RUNTIME_CONSUMER_COMPARE_PENDING`이다.

## 12. Evidence ceiling

이 Gate는 approved candidate와 actual runtime consumer를 연결한다.

다음을 아직 증명하지 않는다.

- current tracked PNG의 visual quality.
- approved candidate의 runtime PASS.
- `PROJECT_ASSET_APPROVED`.
- rights/provenance final promotion.
- 1280×720 / 1920×1080 runtime readability PASS.
- Human player-experience PASS.
- POC_PASSED.
