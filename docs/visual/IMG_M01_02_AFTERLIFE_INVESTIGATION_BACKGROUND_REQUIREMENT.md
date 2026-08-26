# IMG-M01-02 · Afterlife Investigation Background · Consumer Requirement

Status: `REUSE_REVIEW / PIXEL_COMPARE_PENDING`
Decision: `D-2026-08-26-RUNTIME-CONSUMER-FIRST-VISUAL-ASSET-GATE`
Consumer:
- `scenes/investigation_scene.tscn -> ArtLayer/Background`
- `scenes/investigation_scene.tscn -> LocationPreview` via the same background texture
Current file: `assets/backgrounds/afterlife_platform.png`
Current file replacement: `NOT_DECIDED`
Image generation: `NOT_AUTHORIZED_BY_THIS_REQUIREMENT`

## 1. Player question

Investigation 진입 직후 이 자산은 다음 질문에 답해야 한다.

> “이곳은 어떤 장소이며, 평범한 심야 승강장 속에서 무엇이 규칙적으로 잘못되어 조사할 가치가 있는가?”

배경은 정답 가설이나 대응법을 알려주는 증거 보고서가 아니다.

## 2. Actual runtime role

`investigation_scene.gd`는 `ScenePresentation.apply_background(self, "investigation")`을 호출하고, M01의 investigation role은 `afterlife_platform`에 연결된다.

같은 texture가 두 consumer에서 재사용된다.

1. **Full `ArtLayer/Background`**
   - 화면 전체 environment identity.
   - 상단/중앙의 live Godot UI 아래에 깔린다.
2. **`LocationPreview`**
   - `PointMethodDock` 안의 약 172px 높이 preview.
   - full background texture를 그대로 받아 `STRETCH_KEEP_ASPECT_COVERED`로 표시한다.

따라서 이 자산은 큰 화면에서 분위기만 좋은 배경이 아니라, **작은 wide preview에서도 저승역임을 즉시 식별할 수 있는 composition**이어야 한다.

## 3. Composition alternatives

### A. Cinematic off-center focal

주요 landmark/이상을 화면 한쪽에 몰아 영화적 여백을 크게 만든다.

- 장점: 큰 화면에서는 분위기와 연출이 강하다.
- 문제: `LocationPreview` center crop과 Investigation UI overlay에서 focal이 잘리기 쉽다.
- 판정: `REJECTED_FOR_PRIMARY_CONSUMER`.

### B. Central station-identity anchor

승강장 중심축, 선로/기둥/전광판/역 표식 같은 **장소 identity landmark를 중앙~중앙 상단에 두고**, 주변에 조사 가능한 환경 요소를 분산한다.

- 장점: full background와 작은 preview 모두 장소를 유지한다.
- 장점: 특정 단서 하나를 정답처럼 과도하게 강조하지 않는다.
- 장점: live UI가 덮여도 중앙 spatial identity가 남는다.
- 판정: `SELECTED`.

### C. Evidence close-up collage

휴대폰, 승차권, 노선도, 전광판 등 증거를 큰 foreground cluster로 구성한다.

- 장점: 조사 요소가 즉시 보인다.
- 문제: 같은 background가 여러 조사 지점에 재사용되므로 특정 기록을 항상 획득한 것처럼 보이게 한다.
- 문제: Dossier/UI가 소유해야 할 provenance와 evidence state를 원화가 선점한다.
- 판정: `REJECTED`.

## 4. Current canon the background may support

M01 저승역은 **공간형 괴담**이며, 막차 이후 목적지 공백을 사람들이 서로 다르게 기억하는 승강장에서 공식 기록으로 안전 노선을 복원하는 첫 사건이다.

Canon v2의 Investigation/Manual은 다음 종류의 기록을 수집·대조한다.

- 방송 원본과 목적지 공백.
- 피해자 휴대폰의 개인 목적지 기록.
- 동시에 들은 사람들이 서로 다른 목적지를 기록한 비교 자료.
- 공식 운행 기록.
- 시간/배터리/연속 기록과 반복 후에도 남는 흔적.
- 공간 경계 시험과 anchor object.
- 공식 노선도·역 식별·승차권·승하차 기록.

이 중 대부분은 **live record/evidence data가 소유**한다. 배경은 이런 기록을 찾을 수 있는 물리적 맥락을 제공하되 결과를 미리 확정하지 않는다.

## 5. Required environment language

### Required

- 현대 한국 도시철도의 현실적인 심야 승강장.
- 막차 이후 사람의 기척이 거의 없는 정적.
- 플랫폼 깊이, 기둥, 선로, 안전선, 전광판/방송 설비/노선 안내 같은 실제 철도 문법.
- 정상 공간처럼 보이지만 원근·반복·거리감이 미세하게 어긋나는 **규칙적 이상**.
- `SOFT_ANIME_NOIR_LOCKED`: 읽기 쉬운 형태와 절제된 오컬트 누아르.
- 현재 승인 style reference의 손그림 기록물형 표면감과 괴이한 공기.
- 조사 화면답게 Recovery보다 낮은 위협 강도. “공격 직전”보다 “관측해야 하는 장소”가 먼저 읽혀야 한다.

### Good ambient investigation anchors

아래 요소는 **정답을 직접 쓰지 않는 범위**에서 환경 anchor가 될 수 있다.

- 일부 정보가 빠져 있거나 이상하게 비어 보이는 전광판 영역.
- 같은 구조가 멀리서 다시 반복되는 것처럼 보이는 기둥/표지/승강장 깊이.
- 시간이 맞지 않는 듯한 시계나 전자 장치의 미세한 불일치감.
- 방송 스피커/역무 설비/노선 안내판처럼 이후 기록 provenance와 연결 가능한 장소 요소.
- 조사 포인트로 선택해도 자연스러운 벤치, 승강장 끝, 안내 설비, 노선도 위치.

이 anchor는 플레이어에게 “여기를 조사해보자”는 이유를 주되, **어떤 규칙이 참인지**를 알려주지 않는다.

## 6. Must exclude

- 큰 캐릭터 전신/반신 또는 피해자 포스터 구도.
- Recovery용 대형 괴이 현현체.
- 특정 가설이 정답임을 보여주는 화살표, 확률, 체크 표시.
- 읽기 가능한 긴 설명문, 조사 선택지, Manual 문장, UI text를 원화에 bake.
- 공식 귀환 노선/정확 하차역/정확한 정답 승차권을 한눈에 알 수 있는 결정적 정보.
- 구형 검은 승차권 파괴 해법을 핵심 해결책처럼 강조.
- 미래형 cyberpunk HUD/홀로그램/과도한 네온.
- 화면 중앙에 증거품 여러 개를 콜라주해 이미 수집된 기록처럼 보이게 하는 구성.

Diegetic station signage가 필요해도 **정답 문구를 읽을 수 있게 굽지 않는다**. 핵심 텍스트/식별 정보는 live UI/record가 소유한다.

## 7. Dual-consumer geometry

### Full background

Investigation `SafeFrame/Workspace`가 화면 대부분을 차지하고 배경 위에 live panels가 올라온다.

따라서:

- 배경의 공간 identity는 UI 바깥 얇은 여백에만 의존하지 않는다.
- 핵심 landmark는 중앙~중앙 상단에서 구조적으로 읽히게 한다.
- 세밀한 clue는 full-screen background의 유일한 전달 채널로 사용하지 않는다.

### LocationPreview

`LocationPreview`는 약 172px 높이의 wide crop이다.

따라서:

- 중앙 50~60% 안에 장소를 식별하는 강한 silhouette/landmark가 있어야 한다.
- tiny preview에서 사라질 작은 텍스트/소품을 핵심 identity로 삼지 않는다.
- 역/승강장인지, 그리고 무언가 비정상적으로 반복된다는 인상을 value/shape/line으로 읽게 한다.
- edge-only focal을 피한다.

## 8. Information hierarchy

배경 자체의 3초 우선순위:

```text
1. 현대 한국 심야 승강장
2. 비정상적 반복/공백/거리감
3. 조사 가능한 설비·환경 anchor
4. 분위기적 잔향/오컬트 질감
```

다음은 live UI가 소유하므로 배경 우선순위에서 제외한다.

- 현재 단서 수.
- 후보 키워드.
- 가설 지지/반박.
- 매뉴얼 슬롯.
- 조사 행동 버튼.
- 피해자 상태 수치.

## 9. Reuse / replacement gate

### REUSE

현재 `afterlife_platform.png`가 다음을 만족하면 유지한다.

- full background와 172px LocationPreview 모두에서 저승역 장소 identity가 읽힌다.
- 최신 손그림 기록물 + soft-anime-noir direction과 큰 drift가 없다.
- 특정 과거 정답/해법을 baked-in하지 않는다.
- investigation보다 Recovery처럼 과도한 전투/괴이 위협 연출이 앞서지 않는다.
- live UI overlay 후에도 central spatial identity가 남는다.

### REPLACE_REQUIRED only if actual pixel review proves

- 작은 LocationPreview에서 무엇을 보는지 식별하기 어렵다.
- 구형 combat/괴물 중심 화면처럼 보인다.
- 핵심 landmark가 edge에 있어 crop된다.
- 읽기 어려운 AI-generated signage가 핵심 단서처럼 보인다.
- 최신 approved visual direction과 현저한 style drift가 있다.
- baked UI/text 또는 구형 정답 의미가 current canon과 충돌한다.

현재 session에서는 tracked PNG의 실제 pixel을 확인하지 못했으므로 `REPLACE_REQUIRED`로 승격하지 않는다.

## 10. If replacement becomes required

그때만 다음 절차를 연다.

```text
this consumer requirement readback
→ one background-only text brief
→ explicit user generation approval
→ exactly one 16:9 Investigation background
→ result approval
→ current file replacement/promotion review
→ 1280×720 + 1920×1080 full-view and LocationPreview runtime validation
```

## 11. Evidence ceiling

이 requirement는 actual consumer와 composition/readability 계약을 정의한다.

다음을 증명하지 않는다.

- current `afterlife_platform.png` pixel quality.
- replacement need.
- `PROJECT_ASSET_APPROVED`.
- rights/provenance promotion.
- runtime visual PASS.
- Human comprehension.
- POC_PASSED.
