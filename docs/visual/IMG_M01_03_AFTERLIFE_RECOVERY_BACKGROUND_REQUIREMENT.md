# IMG-M01-03 · Afterlife Recovery Background · Consumer Requirement

Status: `REUSE_REVIEW / PIXEL_COMPARE_PENDING`
Decision: `D-2026-08-26-RUNTIME-CONSUMER-FIRST-VISUAL-ASSET-GATE`
Consumer: `scenes/battle_scene.tscn -> ArtLayer/Background`
Current file: `assets/backgrounds/afterlife_recovery.png`
Current file replacement: `NOT_DECIDED`
Image generation: `NOT_AUTHORIZED_BY_THIS_REQUIREMENT`

## 1. Player question

Recovery 화면에 진입한 플레이어가 배경만으로 다음을 즉시 이해해야 한다.

> “여기는 방금 조사·구출을 진행한 저승역의 같은 사건 공간이고, 이제 현장 전체가 불안정한 회수/안정화 단계에 들어갔다.”

배경은 정답 행동이나 괴이의 정확한 패턴을 알려주는 UI가 아니다.

## 2. Actual runtime role

`battle_scene.gd`는 `ScenePresentation.apply_background(self, "recovery")`를 호출하고, `UiAssetCatalog`는 M01 Recovery role을 `afterlife_recovery`에 연결한다.

Scene overlay 구조:

- full-screen `ArtLayer/Background` — 이 requirement의 consumer.
- 별도 `AnomalyVisual: TextureRect` — 괴이 현현 visual owner.
- 별도 `RepresentativeVisual: TextureRect` — 짧은 요원 Cut-in owner.
- 상단 `RecoveryHud` — live text/status.
- 하단 `ActionDock` — telegraph/판단/행동 UI.

따라서 Recovery background는 **전체 화면 목업을 baked image로 만들면 안 된다**.

## 3. Required visual content

### Keep

- 심야 한국 도시철도/승강장의 현실적인 기반.
- 저승역의 비정상적 공간감: 반복되는 승강장, 잘못 이어지는 깊이, 현실 교통 정보와 어긋나는 미세한 구조.
- 손그림 기록물 질감과 `SOFT_ANIME_NOIR_LOCKED`의 절제된 오컬트 누아르.
- Recovery 단계답게 Investigation보다 더 불안정한 조명/잔향/공간 긴장.
- foreground/midground/background 깊이로 현장성을 유지.

### May imply, but must not solve

- `[목적지 합창]`: 안내 방송의 공백/정적이 있다는 분위기적 흔적.
- `[회귀 승강장]`: 반복되어도 남는 지속 흔적이 있을 법한 공간적 anchor.
- `[무정차 환송]`: 현실 노선과 어긋난 투영 경로가 열릴 수 있다는 공간적 불안정.

이 세 패턴의 **정답 대응·정확 좌표·타이밍**은 배경이 알려주지 않는다.

## 4. Must exclude

- UI frame, button, HUD text, `공격/보호/보조`, Context Action text.
- 한글/영문 설명 문구를 원화에 bake.
- 정답 방향 화살표, 추천 행동, 성공 확률.
- 큰 캐릭터/요원.
- 별도 `AnomalyVisual`과 중복되는 대형 괴이 캐릭터/현현체 중심 구도.
- 단일 S/A/B 결과 표현.
- M04 빨간 우산 motif.
- 구형 검은 승차권 파괴 해법을 current truth처럼 표시.

## 5. Composition / safe zones

Runtime overlay를 고려한다.

- 상단 약 8%: status HUD가 올라오므로 세밀한 단서나 얼굴을 두지 않는다.
- 중앙 상단~중앙: 현장 공간과 깊이를 읽는 주 영역.
- 중앙 우측: 별도 `AnomalyVisual` panel이 강하게 소비하므로 배경의 가장 복잡한 focal point를 두지 않는다.
- 좌측 중앙: `RepresentativeVisual` Cut-in이 순간적으로 나타날 수 있으므로 고유 핵심 단서를 두지 않는다.
- 하단 약 38%: ActionDock이 덮으므로 핵심 evidence/landmark를 두지 않는다.

배경의 핵심 spatial identity는 **UI에 가리지 않는 중앙~상단 중좌측/중앙 깊이**에서 읽혀야 한다.

## 6. Layer responsibility

이 파일의 primary role은 `ENVIRONMENT_RECOVERY_BACKGROUND`다.

괴이 entity, character cut-in, live telegraph text, action UI는 별도 owner가 있으므로 이 파일에 통합하지 않는다.

필요한 대기/잔향 효과가 정적인 environment identity에 속하면 포함할 수 있으나, runtime에서 변화해야 하는 telegraph/VFX는 별도 consumer가 생길 때 분리한다.

## 7. Resolution / crop requirement

- master composition: `16:9`.
- `TextureRect.STRETCH_KEEP_ASPECT_COVERED` crop에서 핵심 공간 identity가 보존돼야 한다.
- 1280×720과 1920×1080에서 중앙 핵심 landmark가 UI safe zone 밖으로 밀리지 않아야 한다.
- 현재 tracked file의 실제 pixel quality/readability는 `PIXEL_COMPARE_PENDING`이다.

## 8. Reuse decision gate

### REUSE

현재 `afterlife_recovery.png`가 위 requirement와 최신 Recovery 승인 reference의 환경·분위기·정보 hierarchy를 충분히 만족하면 유지한다.

### ADAPT / REPLACE

다음 중 하나가 실제 pixel review로 확인될 때만 교체/수정을 연다.

- 구형 처치전투/보스 arena 의미가 화면을 지배함.
- 별도 `AnomalyVisual`과 대형 괴이를 중복해 focal collision이 발생함.
- 최신 손그림 기록물 + 오컬트 + 소프트 애니 누아르 direction과 현저히 충돌함.
- 하단/우측 UI overlay 때문에 핵심 공간 정보가 대부분 가려짐.
- baked text/UI가 production localization을 방해함.
- 1280×720 crop에서 현장 identity를 판독하기 어려움.

현재 session에서는 PNG pixel bytes를 직접 읽지 못했으므로 **`REPLACE_REQUIRED`로 승격하지 않는다**.

## 9. If replacement becomes required

그때만 다음 절차를 연다.

```text
consumer requirement readback
→ one text image brief
→ explicit user generation approval
→ exactly one background image
→ result approval
→ production source / rights / runtime readability validation
```
