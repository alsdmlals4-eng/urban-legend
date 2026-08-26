# IMG-M01-04/05 · Afterlife Recovery Anomaly · State-Family Consumer Requirement

Status: `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_AND_HUMAN_QA_PENDING`
Decision: `D-2026-08-26-RUNTIME-CONSUMER-FIRST-VISUAL-ASSET-GATE`
Consumer: `scenes/battle_scene.tscn -> AnomalyVisual`
Runtime selector: `ScenePresentation.apply_anomaly(texture_rect, risk)`
Current files:
- B/C: `assets/anomalies/cutouts/afterlife_b_cutout.png` with `assets/anomalies/afterlife_b.png` fallback
- D: `assets/anomalies/cutouts/afterlife_d_cutout.png` with `assets/anomalies/afterlife_d.png` fallback
Replacement: `NOT_DECIDED`
Image generation: `NOT_AUTHORIZED_BY_THIS_REQUIREMENT`

## 1. Why this is one state family

현재 `UiAssetCatalog.get_risk_stage()`는:

```text
risk < 35  → B
35..69     → C
risk >= 70 → D
```

이지만 `get_anomaly_id()`는 D가 아니면 `afterlife_b`를 사용한다.

즉 현재 visual consumer는 사실상:

```text
B/C visual family → afterlife_b(_cutout)
D visual family   → afterlife_d(_cutout)
```

두 실제 파일이 **같은 저승역 괴이 정체성의 위험 단계 변화**를 보여줘야 한다.

## 2. Important runtime boundary

`AnomalyVisual`의 texture selection은 **현재 Recovery pattern ID가 아니라 risk stage**를 기준으로 한다.

따라서 이 이미지들은 다음 특정 전조의 정답을 직접 encode하면 안 된다.

- `[목적지 합창]`
- `[회귀 승강장]`
- `[무정차 환송]`

세 패턴의 현재 전조와 판단 질문은 live text/data가 소유한다.

만약 미래에 각 pattern별 시각 전조가 별도 이미지로 반드시 필요해지면 `pattern_id → texture consumer`라는 새로운 runtime mapping부터 정의해야 한다. 현재 B/D 파일에 그 의미를 억지로 넣지 않는다.

## 3. Shared identity

B/C와 D는 서로 다른 몬스터가 아니다.

둘 다 다음 identity를 공유한다.

- 저승역의 **잔향/현현**이며 단순 처치 대상 보스가 아니다.
- 인간 또는 통근자의 기억이 철도 공간과 뒤섞인 듯한 세로형 실루엣.
- 얼굴/표정의 일반적 감정 연기보다 **기억의 부재, 목적지 혼선, 비인간적 정지감**이 우선.
- 현실 도시철도 환경과 함께 보일 때 비정상성이 커지는 디자인.
- `SOFT_ANIME_NOIR_LOCKED`: 형상은 읽히되 과도한 gore/괴물 해부학보다 신비롭고 불길한 오컬트 현현.
- 최신 사용자 승인 Recovery reference에서 확인된 **희고 비어 있는 얼굴/가면 같은 focal, 길고 가는 수직 형상, 검은 잔향/선형 간섭**의 방향을 identity reference로 사용한다.

이 reference는 product asset 승인을 의미하지 않는다.

## 4. IMG-M01-04 · B/C state

### Player read

> “아직 회수할 수 있는 현상으로 보이지만, 정상 인간/승객과는 명백히 다르고 다음 전조를 읽어야 한다.”

### Required

- 동일 identity의 **부분 현현 / 중간 위험** 상태.
- 작은 `AnomalyVisual` panel에서도 실루엣과 얼굴 focal이 읽힘.
- 과도한 폭발/공격 pose보다 정지·왜곡·불연속감.
- 투명 배경 cutout 소비가 가능해야 함.
- 주변 환경을 통째로 포함한 scene art가 아니라 entity/cutout 역할이 명확해야 함.
- B와 C가 현재 같은 texture를 공유하므로 너무 낮은 위험 전용 표정도, D급 폭주 연출도 피한다.

### Must not

- 특정 pattern의 올바른 대응 방향을 암시.
- `위로 이동`, 안내판, 방송 장치 등 world action을 entity 그림에 표시.
- boss HP/combat iconography를 bake.
- 별도 Background가 담당하는 승강장/열차 환경을 크게 포함.

## 5. IMG-M01-05 · D state

### Player read

> “같은 현현이 위험 단계가 올라가 공간과 사람을 더 강하게 침식하고 있다. 지금 판단 실패의 비용이 크다.”

### Required

- B/C와 **같은 identity**임을 얼굴 focal, 핵심 silhouette, shape language로 유지.
- 더 강한 왜곡, 더 긴/넓은 잔향, silhouette fragmentation, 주변으로 번지는 간섭으로 escalation.
- 위험은 적갈색/붉은 accent를 사용할 수 있으나 색 하나에만 의존하지 않음.
- B/C보다 shape break, edge interference, scale/gesture tension이 명확히 증가.
- 여전히 text/telegraph response가 정답을 판단하게 두고 entity가 해답을 공개하지 않음.

### Must not

- 완전히 다른 creature로 교체.
- 단순히 B/C 이미지를 붉게 tint한 것만으로 D 차이를 해결.
- 거대한 보스 공격 이펙트로 `AnomalyVisual` panel을 읽을 수 없게 만듦.
- 특정 Recovery pattern 하나를 D의 정본처럼 고정.

## 6. Consumer geometry

`AnomalyVisual`은 `CinematicStage/AnomalyPanel/Content` 안의 `TextureRect`이고 `STRETCH_KEEP_ASPECT_CENTERED`를 사용한다.

현재 `CinematicStage`와 `AnomalyPanel` 자체가 화면 중앙~우측의 큰 공간을 차지하지만, entity texture는 패널 내부에서 중앙 정렬된다.

따라서:

- 투명 cutout의 좌우/상하 여백을 과도하게 남기지 않는다.
- 세로형 silhouette가 panel에서 너무 작아지지 않게 한다.
- 얼굴/상체 focal이 HUD와 ActionDock 사이에서 읽혀야 한다.
- 중요한 손/얼굴/핵심 silhouette가 source edge에 붙어 crop 위험을 만들지 않는다.

Legacy manifest의 existing cutout intent는 portrait-oriented transparent source다. 실제 current pixel quality는 아직 확인하지 못했다.

## 7. State-family consistency gate

B/C와 D를 각각 생성해야 하는 상황이 오더라도 **동시에 두 장을 생성하지 않는다**.

순서:

```text
B/C consumer brief → explicit approval → exactly one B/C image → result approval
→ approved B/C identity를 D의 required reference로 고정
→ D consumer brief → explicit approval → exactly one D image → result approval
```

D가 B/C identity를 임의로 재해석하지 못하게 한다.

## 8. Reuse / replacement gate

### REUSE

현재 B/C·D cutout이:

- 최신 Recovery approved reference와 identity/treatment가 크게 충돌하지 않고,
- B/C ↔ D 동일 identity escalation이 읽히며,
- actual `AnomalyVisual` 크기에서 가독성이 있고,
- 별도 background/telegraph UI와 역할이 겹치지 않으면

유지한다.

### REPLACE_REQUIRED only if pixel review proves

- B와 D가 서로 다른 괴물처럼 보임.
- 구형 combat boss/처치 대상 의미가 강함.
- 최신 soft-anime-noir/hand-drawn occult reference와 현저한 drift.
- B/C가 너무 약하거나 D가 단순 tint 차이뿐이라 risk state가 읽히지 않음.
- 투명 cutout quality/edge가 runtime panel에서 깨짐.
- source에 baked UI/text/background가 있어 actual consumer와 충돌.

현재 session에서는 tracked PNG pixel을 직접 읽지 못하므로 `REPLACE_REQUIRED`로 승격하지 않는다.

## 9. Evidence ceiling

이 문서는:

- actual consumer와 state meaning을 고정하지만,
- current PNG pixel quality,
- product asset approval,
- rights/provenance,
- runtime visual PASS,
- Human comprehension,
- POC_PASSED

를 증명하지 않는다.
