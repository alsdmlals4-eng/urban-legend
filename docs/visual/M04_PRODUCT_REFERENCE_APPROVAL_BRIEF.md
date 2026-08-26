# 괴이기록국 M04 Product Reference Approval Brief

> Route: `M04_RED_UMBRELLA`
> Incident: `비 오는 골목의 빨간 우산`
> Target: `Investigation Anchor`
> Art treatment: `SOFT_ANIME_NOIR_LOCKED`
> Presentation invariant: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`
> Asset state: `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_AND_HUMAN_QA_PENDING`
> Generation contract: `GENERATE_EXACTLY_ONE / COMPLETE`
> RESULT_APPROVAL: `USER_APPROVED`
> Candidate status: `USER_APPROVED_VISUAL_CANDIDATE`

## 1. 현재 역할

이 문서는 M04 release-near Vertical Slice의 첫 product-reference 후보에 대한 **텍스트 Brief + 생성/사용자 승인 receipt**다.

Brief 승인 뒤 후보는 정확히 1장 생성됐고, 사용자가 2026-08-24 결과를 승인했다. 이 승인은 사람용 시각 후보 승인이지 product asset 승격, rights 승인, runtime visual PASS 또는 Human QA PASS가 아니다. 현재 `PRODUCT_REFERENCE_ASSET_PENDING`은 유지한다.

### Approved candidate receipt

```yaml
candidate_id: M04_INVESTIGATION_ANCHOR_01
status: USER_APPROVED_VISUAL_CANDIDATE
approved_on: 2026-08-24
sha256: 4c67a65c9f7469bf39c231c81710fd71f0796501d13231c8fd7020bdad20462f
pixel_size: 1672x941
bytes: 2291020
notion_surface: 04 · Visual · UX · Assets
notion_native_attachment_readback: PASS
product_asset_promoted: false
runtime_visual_validation: NOT_RUN
```

## 2. 왜 첫 후보를 Investigation Anchor로 잡는가

M04의 판매 포인트는 캐릭터 일러스트 자체보다 **평범한 한국 도시 공간에서 모순되는 관측 단서를 발견하고, 괴이의 규칙 문제로 읽기 시작하는 순간**이다.

따라서 첫 product-reference 후보는 다음을 한 화면에서 검증한다.

- 환경·괴이·증거 우선.
- 장면만 봐도 “무엇인가 규칙적으로 잘못됐다”는 첫인상.
- 단서가 장식이 아니라 조사할 이유가 있는 관측 정보로 보이는가.
- 캐릭터가 화면을 지배하지 않고 현장과 괴이가 주체인가.
- 이후 Deduction/Rescue/Recovery로 확장 가능한 공용 화면 문법인가.

## 3. 고정 Canon

현재 사건 데이터에서 가져오는 의미를 바꾸지 않는다.

- 사건명: **비 오는 골목의 빨간 우산**.
- 유형: 반복 경로형 괴담.
- 장소: 폐쇄 상가 뒤편의 골목 사거리 계열 현대 한국 도시 공간.
- 핵심 현상: 빨간 우산과 **젖지 않은 발자국**이 귀가 경로를 되감는 이상.
- 규칙 단서: **세 번째 빗소리** 뒤에만 붉은 우산 손잡이가 관측된다.
- 피해자는 반복되는 귀가 경로에 갇혀 있다.
- 빨간색 자체가 정답 표식이거나 유일한 정보 채널이 되어서는 안 된다.

한 장의 정지 이미지가 시간·소리 규칙을 문자 그대로 증명할 수는 없다. 따라서 `세 번째 빗소리`는 이미지가 정답을 알려주는 장치가 아니라 **조사해야 할 시간성 이상을 암시하는 관측 흔적** 수준으로만 표현한다. 실제 규칙 판단은 게임의 기록·Audio·상호작용에서 완성한다.

## 4. 화면 구성

### 배경

- 현실적인 한국의 낡은 상가 뒤 골목 사거리.
- 비는 막 멈췄거나 매우 약해진 상태로, 노면·간판·배수구·벽면에는 습기가 남아 있다.
- 지나친 사이버펑크 네온, 미래형 투명 HUD, 장식적 광원 남용 금지.
- 생활감 있는 전선, 간판, 셔터, 골목 표식으로 현실성을 먼저 확보한다.

### 괴이

- 사거리의 시선 유도점에 **붉은 우산 또는 붉은 우산 손잡이의 비정상적 존재감**.
- 인간형 존재를 크게 전시하는 공포 포스터 구도보다, “현실 장면에 규칙적으로 끼어든 이상”으로 보이게 한다.
- 우산의 실루엣·형태·위치 반복성이 읽혀야 하며 색상 하나에만 의존하지 않는다.

### 증거

- 젖은 노면과 대비되는 **젖지 않은 발자국** 또는 비정상적으로 물기가 비껴간 발자국 경로.
- 발자국의 형태·표면 질감·반사 차이로도 식별 가능해야 한다.
- 골목의 방향감이 미세하게 되감기는 느낌을 주되, 불가능한 원근 왜곡으로 정답을 직접 폭로하지 않는다.
- 세 번째 빗소리의 시간성은 물방울 잔향, 배수 흔적, CCTV/센서 관측 흔적 같은 보조 레이어로 암시할 수 있으나 “3회째가 정답”이라는 UI 텍스트를 이미지 안에 박지 않는다.

### 캐릭터

- L0 일반 조사 원칙: 큰 전신/반신 캐릭터 상시 노출 금지.
- 첫 후보에서는 캐릭터를 생략하거나 아주 작은 현장 인물/실루엣 수준으로 제한한다.
- 사건 장소·이상 현상·증거의 우선순위를 침범하지 않는다.

## 5. 스타일

`SOFT_ANIME_NOIR_LOCKED`:

- 소프트 애니메이션 계열의 정돈된 형태와 읽기 쉬운 실루엣.
- 현대 한국 도시의 현실감을 유지한 절제된 오컬트 누아르.
- 검정으로 뭉개는 공포보다 관측 가능한 표면·단서가 읽히는 명암.
- 과도한 고채도 네온·글로우 대신 젖은 표면, 흐린 하늘, 약한 인공광의 대비.
- 아름다운 콘셉트 아트보다 **게임 조사 화면으로 쓸 수 있는 정보 가독성**을 우선한다.

`DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`:

- Dossier는 UI·정보 위계·현장 기록의 presentation language다.
- 이미지 자체를 문서 스캔, 픽셀아트, HUD 콜라주로 바꾸지 않는다.
- 사건 파일 프레임·선택지·기록 배지는 runtime UI 레이어가 담당하며 배경 원화에 굽지 않는다.

## 6. 레이어·재사용 구조

승인 후보의 후속 product-reference 검토에서는 다음 분리를 확인한다.

1. `BG_ENVIRONMENT` — 골목 사거리/상가/노면.
2. `ANOMALY_UMBRELLA` — 빨간 우산/손잡이 현상.
3. `EVIDENCE_FOOTPRINTS` — 젖지 않은 발자국.
4. `ATMOSPHERE_RAIN` — 잔비·물방울·안개·습기.
5. `INTERFERENCE_OPTIONAL` — CCTV/센서/기록 간섭 보조 표현.

UI 텍스트, 선택지, Manual panel, 정답 강조는 이미지에 bake하지 않는다. 현재 승인 PNG가 실제 production layer source로 분리 가능하다는 증거는 아직 없으므로 `NOT_RUN`으로 둔다.

## 7. 가독성 기준

최종 product-reference 승격 전 별도 확인:

- 16:9 master composition.
- 1280×720에서 우산/발자국/조사 가능한 환경 실루엣이 뭉개지지 않는다.
- 1920×1080에서 빈 공간이 과도하게 늘어나거나 중요 단서가 모서리로 밀리지 않는다.
- 우산의 붉은색을 제거하거나 색각 차이가 있어도 형태·배치·명암으로 이상 존재를 식별할 수 있다.
- 발자국도 색상만이 아니라 질감·반사·경계로 식별한다.
- 향후 하단 선택지와 짧은 서술이 올라갈 안전 영역을 남긴다.

현재 후보가 1672x941로 생성됐다는 사실은 위 1280×720 / 1920×1080 runtime 가독성 검증을 대신하지 않는다.

## 8. 금지사항

- 빨간 우산이 단순 보스 몬스터처럼 화면 중앙에서 포효하는 구성.
- 피해자 또는 캐릭터가 화면 대부분을 차지하는 캐릭터 포스터 구성.
- 정답 가설, 대응법, 세 번째 빗소리의 해답을 UI/문구로 직접 노출.
- 과도한 네온·홀로그램·glass HUD.
- 붉은색만으로 상태를 구분.
- 저승역의 M01 truth ID나 검은 승차권을 M04 현재 진실처럼 재사용.
- 승인 후보를 검증 없이 제품 reference/최종 asset으로 승격.

## 9. 권리·정본 Gate

- 생성 provenance는 ChatGPT image generation → 사용자 결과 승인 → Notion native attachment/readback 순서로 기록한다.
- 외부 reference를 직접 포함하거나 복제한 project asset이라고 주장하지 않는다.
- 사건 의미가 현재 `episode_002_red_umbrella_alley`와 충돌하지 않는지 계속 검수한다.
- 승인된 visual direction과 다른 매체로 임의 전환하지 않는다.
- Human QA나 runtime 가독성 PASS를 이미지 승인으로 대체하지 않는다.

## 10. 다음 단계

```text
텍스트 Brief 승인 — COMPLETE
→ 이미지 후보 정확히 1개 생성 — COMPLETE
→ 사용자 결과 승인 — COMPLETE
→ Notion 사람용 Visual surface 업로드/readback — COMPLETE
→ product-reference promotion — COMPLETE (2026-08-27, existing canonical path only)
→ layer/reuse provenance recorded + 1280×720/1920×1080 실제 검증 pending
→ M04 release-near visual/audio/VFX 구현
→ Human player-experience QA
```

후속 승격은 별도 adaptation receipt `M04_INVESTIGATION_BACKGROUND_ADAPT_01`로 완료됐으며, 원 후보 `M04_INVESTIGATION_ANCHOR_01` 자체는 사람용 reference로 보존한다. `runtime_visual_validation: NOT_RUN`과 Human QA pending은 유지한다.
