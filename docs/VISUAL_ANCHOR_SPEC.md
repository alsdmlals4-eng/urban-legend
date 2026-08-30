# 괴이기록국 · Visual Anchor Specification

Status: `PLANNING_COMPLETE / RUNTIME_IMPLEMENTED / RECOVERY_WIP_REVISION_REQUIRED / PRODUCT_REFERENCE_ASSET_PENDING / HUMAN_QA_NOT_RUN`
Art treatment: `SOFT_ANIME_NOIR_LOCKED`
Presentation invariant: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`

Current visual-direction lock: `D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION` — realistic Korean urban-noir environment + soft-anime player/anomaly identity + hand-drawn institutional dossier UI. The full lock packet is `docs/visual/VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md`; its project-understanding board is planning-only and not a product asset.

Source PR: #215 + successor decision `D-2026-08-25-RECOVERY-CONTEXT-ACTION-HIERARCHY`
Parent canon: `docs/CURRENT_PLANNING_CANON.md`
Closure contract: `docs/planning/2026-08-21-visual-ui-planning-closure.md`

## Purpose

현재 visual planning criteria와 product-reference 승격 경계를 정의한다. 공유 runtime은 이미 구현됐지만, generated/reviewed reference를 자동으로 product reference로 간주하지 않는다. Product-reference image selection, layer/reuse audit, rights review, 실제 해상도 가독성 및 Human QA는 별도 Gate다.



## 0. 2026-08-28 current-status reconciliation

이 문서의 2026-08-25 승격 대기 문구는 당시의 anchor/candidate 경계 기록이다. **현재 개별 제품 asset 상태는 반드시** `ASSET_MANIFEST.yml` → `CURRENT_VISUAL_WORK_ORDER.md` → `CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST.md` 순으로 읽는다.

- root manifest에는 6개 `PROJECT_ASSET_APPROVED` entry가 있다: M01 Investigation/Recovery background, M01 B/C·D cutout, M04 Investigation background, M04 B/C cutout.
- 이 개별 자산은 해당 consumer의 구현·runtime 검증 상태와 구분해 기록되며, 아직 승격되지 않은 M01 Entrance, M04 Entrance/Recovery, M04 D 후보나 Human/new-player QA를 자동으로 통과시키지 않는다.
- 특히 `M04_INVESTIGATION_ANCHOR_01` reference candidate는 `USER_APPROVED_VISUAL_CANDIDATE / PRODUCT_REFERENCE_ASSET_PENDING`을 유지한다. 이것은 실제 `red_crossroads.png` adaptation의 별도 `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED` 상태와 다른 대상이다.

## Anchor order

1. Investigation Scene Anchor
2. Deduction Manual Anchor
3. Rescue Anchor
4. Recovery Phase Anchor
5. Composite Result Anchor

## Investigation Anchor

Priority:
- environment
- anomaly
- evidence
- narration
- choices

Avoid:
- large permanent character illustration
- HUD overload
- revealing the deduction answer

Presentation:
- scene image
- short observation text
- 2~4 choices
- small record/support indicators

## Deduction Manual Anchor

Priority:
- dossier/document feeling
- evidence provenance
- acquired candidate keywords
- numbered inference-sentence construction

Required:
- manual index
- keyword sources
- inference-sentence slots
- support/refute/unresolved evidence context when needed
- return to field

Primary action: 조사에서 확보한 후보 키워드를 사용해 번호가 붙은 추리문 슬롯을 완성한다. 정답 후보를 시각 위계로 미리 알려주지 않는다.

### 3열 매뉴얼 작업대 적용 기준

Status: `USER_APPROVED / BLUEPRINT_UI_REFERENCE / NOT_RUNTIME_IMPLEMENTED`

빈칸 추리는 현장 우측의 짧은 읽기 서랍을 늘리는 방식이 아니라, 현장 위에 여는
전체 화면 기록철 작업대에서 수행한다. 이 오버레이는 다음 순서를 고정한다.

```text
왼쪽: 매뉴얼 INDEX와 단계 상태
가운데: 번호 빈칸이 있는 추리문 + 관측·반증·미해결 맥락
오른쪽: 후보 키워드 + 원본 출처 + 획득 맥락 + 획득 순서
하단: 후보 규칙 상태 + 기록관 아카의 비정답형 안내 + 현장 복귀
```

- 후보 키워드의 강조는 현재 선택·포커스·배치 상태만 나타낼 수 있으며, 의미상 정답,
  변조 후보, 호환 점수, 권장 선택을 표시해서는 안 된다.
- 슬롯 상태는 `비어 있음 / 후보 배치 / 구조 오류`까지만 즉시 표시한다. `확인된 규칙`
  또는 `위험 사례`는 구출·회수의 실제 결과 뒤에만 기록한다.
- 기록관 아카의 문구는 원문·출처·관측 순서를 다시 보게 하는 안내여야 하며, 특정
  후보를 정답처럼 지목하거나 현장 대응을 자동 선택하지 않는다.
- 매뉴얼을 닫아도 현장에는 후보 규칙의 요약만 남긴다. 전체 출처와 반증 비교는
  작업대 안에서 수행해 회수 HUD의 가독성을 보호한다.

## Rescue Anchor

Priority:
- protection target
- safe route / protection obligation
- rule summary
- application of already-deduced knowledge

새로운 독립 정답 퍼즐보다 앞선 추리문에서 만든 규칙을 피해자 구출에 적용하는 화면이다.

## Recovery Anchor

Priority:
1. anomaly phenomenon
2. telegraph/foreshadowing
3. protection target
4. referenced rule
5. contextual telegraph-response actions
6. stable command categories

Stable top-level commands:
- **공격 / 보호 / 보조**
- 카테고리 선택 뒤 관련 세부 행동을 2단 목록으로 연다.

`CONTEXTUAL_TELEGRAPH_RESPONSE`:
- 전조가 발생하면 현재 장소/현상에서 가능한 구체적인 **전조 대응** 행동을 별도 층으로 제시한다.
- 예: `위로 이동`, `좌로 이동`, `안내판 조작`, `방송 장치 조작`, `문 닫기`.
- 정답은 앞선 조사·기록·추리문·괴이 매뉴얼의 키워드/규칙을 기억하거나 재확인해 판단한다.
- 정답을 색·확률·추천·강제 동료 대사로 선공개하지 않는다.
- 오대응은 비용/위험뿐 아니라 실패 관측 기록을 남겨 이후 판단 근거로 재사용한다.

Deprecated predecessor:
- 과거의 다중 평면 1차 command set은 사용하지 않는다. 세부 역사 목록은 Decision 문서에서만 보존한다.

Character usage:
- small status presence normally
- short skill Cut-in only for meaningful support
- Cut-in must not cover telegraph, protection target, contextual response or sealing condition

## Composite Result Anchor

단일 등급보다 피해자 상태, 확인 규칙/증거, 위험 사례, 안정화/잔향, 미해결 질문, 후속 관계·연구를 분리해 보여준다.

## Art direction

Main treatment — `SOFT_ANIME_NOIR_LOCKED`:
- soft anime noir for character and key narrative illustration
- hand-drawn archival framing/background language in the latest approved style reference
- characters one notch more anime-like than the environment/UI
- mysterious and ominous anomaly presentation
- restrained urban occult
- grounded Korean modern environment
- readable clue surfaces over ornamental neon

`DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`:
- Korean Urban Occult Dossier Hybrid describes UI metaphor, information hierarchy and field-record composition
- it does not reopen the main art treatment as pixel / painterly / another competing medium
- field terminal, case file, anomaly manual and validation marks share one institutional component language

## 2026-08-30 Human Blueprint Visual Continuity Supplement

Status: `USER_APPROVED / BLUEPRINT_REFERENCE_ONLY / NOT_PRODUCT_REFERENCE_ASSET / NOT_RUNTIME_IMPLEMENTED`

The user approved the six-image human-blueprint reference pack at
`docs/visual/blueprint-reference-pack/2026-08-30/`. It is a visual continuity
anchor for future art planning and human documentation. It does **not** replace
an existing runtime asset, alter a scene, or waive the product-reference,
rights/provenance, resolution, or Human QA gates below.

### Field-operation composition rule

- A core-loop scene must show the actual incident location first. Archive
  offices are appropriate for Main, records, and preparation surfaces, but not
  as a substitute backdrop for Investigation, Rescue, or Recovery.
- The player-facing action chain must remain readable without a UI overlay:
  `observe / read the manual -> issue or choose a procedure -> protect a
  victim -> constrain and stabilize the phenomenon -> record the composite
  outcome`.
- Recovery is not a disposal or boss-kill tableau. When an anomalous presence
  is shown, its spread is constrained while a protection target remains
  legible.

### Character, colour, and material rule

- Preserve `SOFT_ANIME_NOIR_LOCKED`: characters remain one notch more
  anime-like than the grounded Korean urban environment, with coherent
  silhouette, ink-line detail, and practical role-specific fieldwear.
- Use charcoal / cold blue-green for place, restrained black-gold for Bureau
  records and manuals, violet for analytical containment, amber for protection
  equipment, and limited crimson for active anomaly danger. Colour may support
  a role but cannot be the only cue.
- Field personnel must read through their action and equipment: manual-led
  command, containment analysis, or civilian protection. Do not reduce them to
  static team-poster poses, wizard costumes, ungrounded religious display, or
  glass-heavy sci-fi HUDs.
- Dossier language belongs to physical records, manual pages, case tags, and
  information hierarchy. It must not be baked into a scene as unreadable UI or
  used to conceal relevant evidence.

### Downstream application boundary

When a new or revised in-game image is proposed, compare it against this
supplement and the existing screen anchors before generation or implementation.
Then keep the actual consumer, layer/reuse plan, `1280x720` / `1920x1080`
readability evidence, provenance review, and Human QA as separate gates. No
current approved runtime asset is retroactively invalidated or replaced by the
blueprint pack.

Pixel/dot:
- supporting observation language only
- logs, sensors, CCTV, markers, interference effects

No:
- full pixel conversion of characters
- pixel-only main investigation surface
- glass-heavy sci-fi HUD that obscures field evidence
- answer-salience styling that turns deduction/recovery into UI guessing

## Asset boundary

`PRODUCT_REFERENCE_ASSET_PENDING` means:
- no generated or user-owned draft is promoted merely because planning/runtime implementation is complete
- final image/reference approval checks P0 screen criteria, 1280×720 and 1920×1080 readability, layer/reuse structure, rights/provenance and semantic correctness
- product-reference approval does not imply runtime or Human QA PASS
- current M04 Investigation Anchor is a user-approved visual candidate, not yet promoted product reference

Recovery WIP:
- `REFERENCE_MOCKUP / REVISION_REQUIRED / NOT_PRODUCT_ASSET`
- SHA-256 `606cb6998d4d1d08b44f96fe508b777e631786f05fdbd9a8c0d2b307dbe0e4d2`
- `1672x941`, `2399097` bytes
- Notion native upload/readback complete
- next visual: successor Recovery hierarchy applied to exactly one revised whole-screen candidate

## Current gates

1. Final planning declaration — `APPROVED`.
2. Shared runtime/state/result implementation — `COMPLETE_MERGED` via PR #224.
3. Base protected-baseline governance reconciliation — historical completion via PR #226/#227; fresh Base rules must still be read on reactivation.
4. M01 actual First Session Human QA — `NOT_RUN`; `docs/qa/M01_FIRST_SESSION_HUMAN_QA_PACKET.md` 사용.
5. M04 Investigation visual candidate — user-approved candidate; product promotion still pending.
6. Recovery contextual-action hierarchy — user-approved meaning contract.
7. Recovery revised whole-screen image — next, exactly one candidate before component extraction.
8. Candidate approval 뒤 layer/reuse + rights/provenance + 1280×720/1920×1080 checks.
9. Release-near visual/audio/VFX implementation.
10. Actual runtime/input + Human player-experience QA.

## Evidence boundary

- Planning/runtime completion is not product asset approval.
- Product promotion requires project asset authority and rights/meaning review.
- M01 actual Human comprehension/fatigue QA remains `HUMAN_QA_NOT_RUN` until a person runs the session.
- Runtime visual, final 1280×720/1920×1080 readability, animation, Audio/VFX, and M04 Human QA remain `NOT_RUN` until actually executed.
- 자동 CI, reference upload, WIP 이미지 생성 또는 사용자 interaction 의미 승인을 product-reference/runtime/Human PASS로 승격하지 않는다.
