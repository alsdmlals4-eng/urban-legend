# IMG-M01-01 · Afterlife Entrance / Dialogue Background · Consumer Requirement

Status: `REUSE_REVIEW / SHARED_CONSUMER_ROLE_REVIEW / AUTO_AUTHORIZED_CANDIDATE_COMPARE_REQUIRED`
Decision: `D-2026-08-26-RUNTIME-CONSUMER-FIRST-VISUAL-ASSET-GATE`
Current file: `assets/backgrounds/afterlife_entrance.png`
Current replacement: `M01_ENTRANCE_BACKGROUND_ADAPT_01 / PRODUCT_ASSET_PROMOTION_PENDING`
Image generation: `USER_AUTONOMOUSLY_AUTHORIZED_FOR_THIS_RUNTIME_CONSUMER`

## 1. Actual consumers

현재 한 texture가 여러 곳에서 실제 소비된다.

### Primary M01 consumer

- `scenes/dialogue_scene.tscn -> ArtLayer/Background`
- M01 Afterlife briefing의 `LocationPanel` preview는 위 Background texture를 그대로 재사용한다.
- Dialogue UI에서 location meta는 `저승역 · 플랫폼 진입부`로 설명한다.

### Secondary product consumers

- `scripts/ui/main_menu.gd`의 full-screen backdrop은 현재 `afterlife_entrance`를 직접 불러온다.
- Main Menu right intelligence rail의 `CurrentCasePreview`도 M01일 때 episode `dialogue_background_id = afterlife_entrance`를 소비한다.

따라서 이 파일은 M01 오프닝 장소를 소유하지만, 동시에 Main Menu의 어두운 atmospheric backdrop으로도 견뎌야 한다.

## 2. Authority boundary for Main Menu

승인된 `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`은 Main Menu의 제품 identity를 **관제실형 3-rail Godot UI hierarchy**가 소유하도록 한다.

그 Decision은 명시적으로 **새 product image가 필요하지 않다**고 정한다.

따라서 `afterlife_entrance.png`가 Main Menu에 재사용된다는 이유만으로 별도 Main Menu illustration을 신규 생성하지 않는다.

이 자산의 primary design success는 **M01 오프닝/Dialogue 장소**에서 판단하고, Main Menu에서는 dark overlay 아래 secondary atmosphere compatibility를 확인한다.

## 3. Player question

M01 오프닝에서 플레이어는 이미지로 다음을 이해해야 한다.

> “기록국이 연결한 첫 현장은 막차 이후의 비정상적인 지하철 승강장 진입부이며, 아직 정체를 확정할 수 없지만 안쪽을 조사해야 한다.”

여기서는 Recovery의 괴이 현현이나 사건의 정답 규칙을 아직 보여주지 않는다.

## 4. Composition alternatives

### A. Dramatic anomaly entrance

진입부 중앙에 거대한 괴이/문/포털을 두어 사건 hook을 즉시 강하게 만든다.

- 장점: 공포 hook이 빠르다.
- 문제: 첫 조사 전에 괴이 정체를 과도하게 확정한다.
- 문제: Main Menu backdrop으로 재사용할 때 M01 보스 화면처럼 보인다.
- 판정: `REJECTED`.

### B. Generic bureau control room

관제실/서류실을 배경으로 하여 Main Menu 정체성을 우선한다.

- 장점: Main Menu에는 자연스럽다.
- 문제: Dialogue의 실제 location consumer `저승역 · 플랫폼 진입부`와 충돌한다.
- 문제: Main Menu 정본 자체가 새 image를 요구하지 않는다.
- 판정: `REJECTED_FOR_THIS_ASSET`.

### C. Subdued midnight station threshold

현대 한국 지하철의 심야 **승강장 진입부/threshold**를 실제 장소처럼 보여주고, 깊은 안쪽에 미세한 반복·공백·잘못된 거리감을 암시한다.

- Dialogue/location preview에서 실제 사건 장소로 읽힌다.
- Main Menu에서는 82% 수준 dark overlay 뒤에 남는 큰 구조·명암이 atmospheric background 역할을 한다.
- 사건 정답이나 괴이 형상을 미리 확정하지 않는다.
- 판정: `SELECTED`.

## 5. Required visual content

### Required

- 현대 한국 도시철도 승강장으로 내려가는 진입부 또는 승강장 문턱.
- 막차 이후 이용객이 거의 없는 심야 분위기.
- 계단/통로/기둥/개찰 또는 플랫폼 접근 구조 중 실제 장소를 설명하는 건축 요소.
- 안쪽으로 이어지는 승강장 깊이와 비정상적 정적.
- 정상적인 교통 시설이지만 일부 거리·반복·정보 공백이 미세하게 이상한 느낌.
- `SOFT_ANIME_NOIR_LOCKED`의 읽기 쉬운 형태와 절제된 오컬트 누아르.
- 최신 시각 reference의 손그림 기록물형 표면감.

### May imply

- 멀리 있는 전광판/안내 설비 중 일부 정보가 비어 보이는 형태.
- 같은 기둥이나 출입구가 깊이 속에서 이상하게 반복되는 듯한 실루엣.
- 기록국이 연결을 시작했다는 느낌의 약한 기기 광원/현장 흔적.

이 요소는 **첫 질문을 만든다**. 답을 주지 않는다.

## 6. Must exclude

- 큰 괴이/역무원 현현체를 정면에 전시.
- Recovery danger-state B/D visual과 역할 중복.
- 큰 캐릭터 전신/반신.
- 피해자 얼굴을 사건 poster처럼 노출.
- 공식 귀환 노선, 정답 목적지, 정확한 승차권/하차역, 대응법.
- 구형 검은 승차권 파괴 해법을 핵심 visual hook으로 사용.
- UI button, Main Menu rail, 긴 텍스트, briefing copy를 원화에 bake.
- 미래형 cyberpunk 관제실/홀로그램 배경으로 장소를 대체.
- 특정 save/Validation 상태를 원화에 고정.

## 7. Shared-consumer geometry

### Dialogue full background

`DialogueScene/ArtLayer/Background`는 full-screen `STRETCH_KEEP_ASPECT_COVERED`로 소비된다.

Dialogue의 live briefing UI가 위에 올라오므로:

- 배경 핵심 identity는 중앙~중앙 상단의 큰 architectural shape로 읽힌다.
- live text와 경쟁하는 작은 signage를 핵심 clue로 쓰지 않는다.
- UI 뒤에 가려져도 “지하철 진입부/threshold”가 남아야 한다.

### Dialogue LocationPanel preview

Preview는 좌측 column에서 작은 wide image로 보인다.

- 중앙 50~60%에 입구/계단/플랫폼 접근의 강한 landmark를 둔다.
- edge focal과 tiny signage 의존을 피한다.
- preview만 봐도 `저승역 · 플랫폼 진입부`라는 장소 설명과 충돌하지 않아야 한다.

### Main Menu backdrop

`main_menu.gd`는 이 texture 위에 `Color(0.025, 0.035, 0.05, 0.82)`의 강한 dark overlay를 둔다.

따라서 Main Menu compatibility는:

- 밝은 대형 얼굴/문구가 overlay 뒤에서 시선을 빼앗지 않음.
- 큰 value/line 구조는 남아 institutional/noir atmosphere를 보조함.
- 제품 identity와 primary action은 UI rails가 소유하게 둠.

### Main Menu CurrentCasePreview

M01일 때 같은 `afterlife_entrance`가 약 150px 높이 preview로 다시 소비된다.

- 작은 crop에서 장소 identity가 유지돼야 한다.
- Dialogue preview와 동일한 central landmark가 재사용 가능해야 한다.

## 8. Information hierarchy

3초 우선순위:

```text
1. 심야 한국 지하철 진입부
2. 안쪽으로 이어지는 비정상적 정적/거리감
3. 조사할 가치가 있는 교통 설비/환경 anchor
4. 기록국·오컬트 누아르 atmosphere
```

다음은 live UI/record가 소유한다.

- 사건 개요 문장.
- 피해자 상태.
- 목적지 불일치의 정확한 기록.
- 후보 키워드/가설.
- 현재 save/Validation 상태.
- 제품 버전/메뉴 action.

## 9. Reuse / replacement gate

### REUSE

현재 `afterlife_entrance.png`가 다음을 만족하면 유지한다.

- Dialogue full background와 작은 location preview에서 실제 플랫폼 진입부로 읽힌다.
- Main Menu dark overlay 뒤에서 과도한 M01-specific focal이 제품 UI를 압도하지 않는다.
- 큰 괴이/정답 clue를 미리 노출하지 않는다.
- latest soft-anime-noir + hand-drawn occult direction과 큰 drift가 없다.
- baked UI/text가 없다.

### REPLACE_REQUIRED only if actual pixel review proves

- 장소가 지하철/플랫폼 진입부로 읽히지 않는다.
- 작은 preview에서 focal이 사라진다.
- 구형 combat/boss/검은 승차권 해법이 지배한다.
- Main Menu에서 밝은 캐릭터/괴이가 UI hierarchy를 압도한다.
- 최신 승인 art direction과 현저히 충돌한다.
- baked text/UI가 current consumer와 충돌한다.

현재 session에서는 tracked PNG pixel을 직접 확인하지 못했으므로 `REPLACE_REQUIRED`로 승격하지 않는다.

## 10. If replacement becomes required

```text
this shared-consumer requirement readback
→ one entrance-background-only text brief
→ explicit user generation approval
→ exactly one 16:9 environment image
→ result approval
→ Dialogue full/preview + Main Menu backdrop/current-case preview runtime validation
→ promotion/rights review
```

Main Menu 전용 이미지는 이 replacement flow에서 자동 추가하지 않는다.

## 11. Evidence ceiling

이 requirement는 소비처 역할과 composition contract를 정의한다.

다음을 증명하지 않는다.

- current PNG pixel quality.
- replacement necessity.
- `PROJECT_ASSET_APPROVED`.
- rights/provenance promotion.
- 1280×720 / 1920×1080 runtime visual PASS.
- Human QA.
- POC_PASSED.
