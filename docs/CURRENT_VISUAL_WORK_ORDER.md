# 괴이기록국 · Current Visual Work Order

> Role: `CURRENT_VISUAL_WORK_ORDER`
> Updated: `2026-08-26`
> Status: `PLANNING_COMPLETE / RUNTIME_IMPLEMENTED / USER_APPROVED_VISUAL_CANDIDATES / RUNTIME_CONSUMER_FIRST_ASSET_GATE / PRODUCT_REFERENCE_ASSET_PENDING / HUMAN_QA_NOT_RUN`
> Art treatment: `SOFT_ANIME_NOIR_LOCKED`
> Presentation invariant: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`
> Decisions: `D-2026-08-20-INVESTIGATION-SCENE-KEYWORD-DEDUCTION-LIMITED-CHARACTER-EXPOSURE`, `D-2026-08-25-RECOVERY-CONTEXT-ACTION-HIERARCHY`, `D-2026-08-26-RUNTIME-CONSUMER-FIRST-VISUAL-ASSET-GATE`
> Consumer checklist: `docs/CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST.md`

이 문서는 현재 시각/화면 계약을 소유한다. 공유 runtime 구현은 PR #224를 통해 main에 반영됐고, M04 Investigation Anchor 1안은 사용자 결과 승인을 받았다. Recovery successor 전체 시안도 현재 대화에서 사용자 승인을 받았고, Composite Result 1·2단계 mockup은 사용자 승인 reference다. 다만 이 화면 mockup들은 자동으로 제품 PNG asset이 되지 않는다.

2026-08-26 사용자 결정에 따라 신규 이미지 제작은 **실제 게임 runtime consumer가 있는 asset**을 기준으로 한다. `PanelContainer`, `Label`, `Button`, `GridContainer`, Theme/StyleBox 등 Godot UI 구조를 설명하기 위한 component sheet는 이미지 backlog에서 제외한다. 실제 생성/교체 판단은 `CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST.md`가 소비처·기존 파일·Delete Test를 연결해 소유한다.

현재 mutation 경계는 **runtime-consumed visual asset review, product-reference asset 승격, runtime 가독성 검증, release-near polish, Human evidence**다.

## 1. Current approved direction

- 메인 아트 treatment: **소프트 애니 누아르**, `SOFT_ANIME_NOIR_LOCKED`.
- 현재 사용자 스타일 reference: 기록물형 손그림 배경/프레임 + 신비롭고 불길한 괴이 + 캐릭터는 한 단계 더 애니메풍.
- `Korean Urban Occult Dossier Hybrid` = UI·정보 위계·현장/기록 composition 언어 (`DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`).
- 조사 = 장면 이미지 + 서술 + 2~4 선택지.
- 조사 결과 = 관측 사실 / 기록 / 키워드 / 위험 사례 / 관계·태도 기억 / 비용.
- 추리 = 별도 괴이 매뉴얼에서 provenance와 후보 키워드를 읽고 **번호가 붙은 추리문 슬롯을 완성**해 Manual 규칙을 만든다.
- 일반 조사에서 큰 캐릭터 전신/반신 상시 노출 금지.
- 회수 = 괴이/전조 중심, 캐릭터는 작은 상태 표현 + 의미 있는 스킬 순간 Cut-in.
- 픽셀/도트 = CCTV·센서·로그·지도·괴이 간섭의 보조 관측 언어.
- **이미지 제작은 actual runtime consumer first**. 설명용 시트는 별도 explanatory need가 입증되지 않으면 만들지 않는다.

## 2. Character exposure policy

```text
L0 일반 조사          = 환경·사건·증거 중심, 큰 캐릭터 없음
L1 짧은 지원/대사     = 이름 + 문장 또는 작은 Portrait
L2 중요 서사           = 제한적인 반신/장면 일러스트
L3 회수 스킬           = 짧은 Cut-in
L4 도감/편성/프로필    = 전신/상세 일러스트
```

캐릭터 사용 빈도를 줄여 중요한 순간의 품질·보상감을 높인다.

## 3. Current screen order

### A. Investigation Anchor

1. 사건 장소/이상 현상 이미지
2. 3~7문장 관측 서술
3. 2~4개 조사/대화/행동 선택
4. 필요 시 작은 기록/지원 표시

금지: 상시 대형 Manual/Hypothesis panel, 캐릭터가 현장을 가리는 구성, 핵심 키워드의 probability-only 획득.

### B. Deduction / Manual Anchor

- 좌측: Manual INDEX / 관측 provenance
- 중앙: 추리문 / 번호 슬롯
- 우측: 후보 키워드
- 하단/별도 층: 근거·출처·지지/반박/미해결 참고
- 항상 `현장으로 돌아가기`

정답 후보를 시각 위계로 미리 알려주지 않는다. 조사에서 확보한 후보 키워드로 추리문 슬롯을 채우는 것이 primary action이다.

### C. Rescue Anchor

- 규칙 요약 + 피해자 상태 동시 확인.
- 행동/역할은 현재 근거와 연결.
- 새 정답 퍼즐보다 추리에서 만든 규칙의 실제 적용.
- 실패 이유는 추론 부족과 입력/적용 오류를 분리.

### D. Recovery Anchor

Visual/interaction priority:
1. 괴이/현현체
2. 다음 전조
3. 보호 대상
4. 참조 규칙/예상 영향
5. **전조 대응 행동 — `CONTEXTUAL_TELEGRAPH_RESPONSE`**
6. 상시 기본 행동 **공격 / 보호 / 보조**
7. 동료/자원 상태

상시 1차 메뉴는 **공격 / 보호 / 보조** 세 카테고리뿐이며, 누르면 관련 세부 행동 목록이 2단 메뉴로 열린다.

괴이 전조가 발생하면 별도의 전조 대응 목록에 `위로 이동`, `좌로 이동`, `안내판 조작`, `방송 장치 조작`, `문 닫기`처럼 현재 현장에서 수행 가능한 world action을 제시한다. 올바른 전조 대응은 앞선 조사·기록·추리문·괴이 매뉴얼의 키워드/규칙을 기억하거나 재확인해 판단한다. UI는 정답을 색·확률·추천 표식으로 선공개하지 않는다.

오대응은 비용/위험과 함께 **실패 관측 기록**을 남겨 이후 판단 근거가 된다.

기존의 다중 평면 1차 command set은 폐기된 predecessor다. 세부 역사 목록은 Decision 문서에서만 보존한다.

M01 상세 runtime predecessor는 `docs/M01_RECOVERY_SCENE_PACKET.md`에 남아 있을 수 있으므로 재개 시 이 successor decision과 reconcile한다. Cut-in은 전조·보호 대상·상황 행동을 가리지 않는다.

현재 `TelegraphLabel`, contextual action list, 기본 행동 category는 Godot UI 구조로 다루며, 별도 설명용 PNG 제작 대상이 아니다. 실제 이미지 target은 `Background`, `AnomalyVisual`, `RepresentativeVisual`처럼 명확한 Texture consumer를 먼저 본다.

### E. Composite Result

단일 S/A/B 하나로 압축하지 않는다.
- 피해자 상태
- 확인 규칙/증거
- 위험 사례/보호 책임
- 안정화/잔향
- 미해결 질문
- 후속 관계·연구·정보 공유

현재 `result_scene.gd`는 Control/Theme 기반 runtime UI를 구성한다. 따라서 승인된 Composite Result mockup은 **UI/visual direction reference**이며, 현재 별도 product PNG consumer를 증명하지 않는다.

## 4. Product-reference asset boundary

현재 M04 Investigation Anchor 1안은 `USER_APPROVED_VISUAL_CANDIDATE`다.

- receipt owner: `docs/visual/M04_PRODUCT_REFERENCE_APPROVAL_BRIEF.md`.
- candidate SHA-256: `4c67a65c9f7469bf39c231c81710fd71f0796501d13231c8fd7020bdad20462f`.
- source size: `1672x941`, `2291020` bytes.
- 사람용 Notion `04 · Visual · UX · Assets`에 native attachment로 업로드/readback 완료.
- 이 승인은 시각 후보 승인이지 `PRODUCT_REFERENCE_ASSET_APPROVED`가 아니다.
- 실제 product-reference 승격 전 layer/reuse, rights/provenance, 1280×720/1920×1080 runtime readability, runtime consumption을 검증한다.
- Human QA와 product-reference asset Gate는 서로 독립이다.

2026-08-26 M04 Investigation background adaptation은 별도 `USER_APPROVED_VISUAL_CANDIDATE`로 확정됐다.

- candidate ID: `M04_INVESTIGATION_BACKGROUND_ADAPT_01`.
- durable review source: `docs/visual/candidates/M04_INVESTIGATION_BACKGROUND_ADAPT_01.png`.
- receipt: `1672x941`, `2,662,606` bytes, SHA-256 `874d3c531a45c9ddf670e9a8ff70a37443762dc24af640edac2ff45fea762f9d`.
- actual consumer intent: `investigation_scene.tscn -> ArtLayer/Background` plus shared `LocationPreview`.
- this is an approved visual adaptation candidate after current `red_crossroads.png` pixel comparison. It is **not** `PROJECT_ASSET_APPROVED`, a replacement of the tracked PNG, a Godot connection, runtime readability PASS, or Human QA PASS.
- detailed approval/provenance record: Notion `M04_INVESTIGATION_BACKGROUND_ADAPT_01` Asset Library entry.

Recovery visual history:

- predecessor WIP: `REFERENCE_MOCKUP / REVISION_REQUIRED / NOT_PRODUCT_ASSET`.
- predecessor SHA-256: `606cb6998d4d1d08b44f96fe508b777e631786f05fdbd9a8c0d2b307dbe0e4d2`.
- successor hierarchy 전체 시안: current conversation에서 `USER_APPROVED_VISUAL_CANDIDATE`.
- successor 승인은 화면 의미/시각 후보 승인이지 current `afterlife_recovery.png`, anomaly cutout, product asset promotion, runtime readability PASS를 자동 승인하지 않는다.
- 2026-08-26 원본 보관: `docs/visual/candidates/approved-references/m01_recovery_context_action_approved_candidate.png`; 1672×941, `2,464,731` bytes, SHA-256 `cf476ea56e89aa0e87e41eabae2c29f3bf85a95740b443ca8a573f7095ed6116`. 전체 UI mockup은 Recovery의 시각 후보/reference이며 배경 texture 또는 live UI 교체본이 아니다.

Composite Result visual references:

- 1단계 정보 위계: `USER_APPROVED_REFERENCE`.
- 2단계 결과 인과: `USER_APPROVED_REFERENCE`.
- 3단계 기록 귀결: `GENERATED / IN_REVIEW`; 사용자 승인으로 추론하지 않는다.
- 현재 runtime result scene은 Control/Theme 기반이므로 이 mockup들은 설명/방향 reference이며 product PNG asset 승격 대상이 아니다.

## 5. Runtime-consumer-first asset gate

Decision: `D-2026-08-26-RUNTIME-CONSUMER-FIRST-VISUAL-ASSET-GATE`.

이미지 후보는 다음 순서만 허용한다.

```text
actual Scene / Texture consumer
→ current file / project reuse
→ Delete Test
→ REUSE_REVIEW | REPLACE_REQUIRED | CREATE_REQUIRED
→ consumer-specific text brief
→ explicit generation approval
→ exactly one image
→ result approval
→ promotion/runtime validation
```

### Image backlog에서 제거

실제 texture consumer가 별도로 입증되지 않는 한 다음은 이미지 생성 대상이 아니다.

- Recovery Telegraph Badge state sheet.
- Recovery Context Action List sheet.
- 공격 / 보호 / 보조 Category Bar sheet.
- Composite Result Axis Card sheet.
- Composite Result causal strip sheet.
- Composite Result record-consequence tag sheet.
- generic public UI component explanation sheet.

위 항목은 필요하면 Godot UI/UX 설계 task로 남는다.

### Current actual consumer checklist

`docs/CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST.md`가 실제 consumer와 tracked file을 연결한다.

현재 확인 결과:

- `CREATE_REQUIRED`: `NONE_PROVEN_YET`.
- 대부분 runtime consumer에는 tracked file이 이미 존재하므로 먼저 `REUSE_REVIEW`한다.
- tracked file 존재는 current root `ASSET_MANIFEST.yml` product approval을 의미하지 않는다.

## 6. Current work sequence

```text
1. 사용자 최종 기획완료 — COMPLETE
2. runtime reconciliation / COMPOSITE_RESULT / monthly_state / M01 First Session — COMPLETE_MERGED (#224)
3. main menu Ver 4.3 / M04 shared-system baseline — COMPLETE_MERGED (#224)
4. current authority + Base protected baseline reconciliation — COMPLETE (#225~#227)
5. M01 First Session Human QA packet — READY_TO_RUN / HUMAN_QA_NOT_RUN
6. M04 product-reference text Brief 승인 — COMPLETE
7. M04 Investigation Anchor 후보 1개 생성/사용자 승인/Notion upload — COMPLETE
8. CASE-01 통합 UI style reference — USER_APPROVED_STYLE_REFERENCE
9. Recovery predecessor WIP — COMPLETE_AS_REFERENCE / SUPERSEDED_FOR_HIERARCHY
10. Recovery successor hierarchy + revised full mockup — USER_APPROVED_VISUAL_CANDIDATE
11. Composite Result mockup 1단계/2단계 — USER_APPROVED_REFERENCE; 3단계 — IN_REVIEW
12. runtime-consumer-first image gate — APPROVED
13. actual visual consumer inventory — COMPLETE_FOR_CURRENT_CORE_SURFACES
14. `IMG-M01-03 afterlife_recovery.png` pixel compare + one background-only candidate result approval — COMPLETE_AS_VISUAL_CANDIDATE; no product asset promotion
15. M01 anomaly B/C and D pixel compare — COMPLETE; both `REPLACE_REQUIRED`; B/C text brief approval 대기, D는 B/C 결과 승인 뒤 별도 brief
16. M04 approved Investigation Anchor vs actual `red_crossroads` consumer comparison — `ADAPT_CANDIDATE` selected
17. `M04_INVESTIGATION_BACKGROUND_ADAPT_01` one-image adaptation + user result approval — COMPLETE_AS_VISUAL_CANDIDATE
18. M04 product-reference promotion + rights/provenance + 1280×720/1920×1080 runtime 검증
19. M04 release-near visual/audio/VFX implementation — separate later authorization
20. M04 actual runtime/input + Human player-experience QA — separate later gate
```

## 7. Approval boundary

### Complete
- 조사/추리 화면 분리
- 장면형 조사 문법
- 후보 키워드 → 추리문 슬롯 primary action
- 환경·증거 우선 화면
- 캐릭터 노출 레벨
- 회수 skill Cut-in policy
- Recovery 기본 category vs contextual telegraph-response 의미 분리
- Recovery successor full-mockup user visual approval
- pixel/dot 보조 관측 언어
- 소프트 애니 누아르 treatment
- 최신 손그림+괴이감+애니메 캐릭터 style reference
- Dossier UI presentation language
- M01/M04 화면 책임 분리
- 공용 runtime/state/result implementation
- M04 Investigation Anchor 1안 사용자 결과 승인
- M04 Investigation background adaptation 01 사용자 결과 승인
- 사람용 Notion Visual/Home 이미지 upload/readback
- Composite Result information-hierarchy / causal visual references 1·2단계 사용자 승인
- runtime-consumer-first visual asset production gate
- current core-surface visual consumer inventory

### Pending / not run
- Composite Result 3단계 result approval
- remaining runtime PNG pixel-quality comparisons against latest approved visual references
- M01-03 product-reference asset promotion + rights/provenance + runtime readability / Human QA
- M01 B/C background-independent transparent anomaly candidate: text brief approval → exactly one candidate → result approval
- M01 D background-independent transparent anomaly candidate: B/C result approval 뒤 text brief approval → exactly one candidate → result approval
- M01 actual Human QA / new-player validation
- M04 product-reference asset 승격
- layer/reuse production source 검증
- rights/provenance promotion 검토
- 1280×720/1920×1080 최종 runtime 시각 PASS
- M04 release-near visual/audio/VFX Human QA
- Android
- POC_PASSED
- Production expansion

자동 검증 성공, tracked asset 존재, mockup 승인, 또는 사용자 시각 후보 승인은 Human/runtime/product-asset PASS를 의미하지 않는다.

## 8. Asset authority warning

Root `ASSET_MANIFEST.yml`가 current tracked product-asset authority이며 현재 `assets: []`다.

`assets/ASSET_MANIFEST.json`은 `LEGACY_MIGRATION_PENDING_NON_AUTHORITY`다. 과거 `stage=final`, QA 문구, tracked PNG, `.import`, runtime wiring은 existence/provenance/history evidence일 수 있지만 `PROJECT_ASSET_APPROVED`를 부여하지 않는다.

## 9. Sync rule

향후 시각/UX 의미 변경은 Notion과 Repository를 같은 작업 범위에서 갱신하고 readback한다. 승인된 Decision은 동일 Decision ID로 양쪽에 기록한다. 구현·asset·Human evidence Gate는 서로 분리한다. 진행 중 unrelated PR은 read-only로 유지한다.

사용자 승인 시각 원본은 `docs/visual/candidates/`의 receipt 포함 PNG와 Notion native attachment를 함께 남긴다. 자세한 보관 계약과 2026-08-26 원본 목록은 `docs/IMAGE_ASSET_WORKFLOW.md` 및 `docs/visual/candidates/APPROVED_VISUAL_REFERENCES_2026-08-26.md`를 따른다.
