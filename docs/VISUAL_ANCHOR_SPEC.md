# 괴이기록국 · Visual Anchor Specification

Status: `PLANNING_COMPLETE / RUNTIME_IMPLEMENTED / RECOVERY_WIP_REVISION_REQUIRED / PRODUCT_REFERENCE_ASSET_PENDING / HUMAN_QA_NOT_RUN`
Art treatment: `SOFT_ANIME_NOIR_LOCKED`
Presentation invariant: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`

Source PR: #215 + successor decision `D-2026-08-25-RECOVERY-CONTEXT-ACTION-HIERARCHY`
Parent canon: `docs/CURRENT_PLANNING_CANON.md`
Closure contract: `docs/planning/2026-08-21-visual-ui-planning-closure.md`

## Purpose

현재 visual planning criteria와 product-reference 승격 경계를 정의한다. 공유 runtime은 이미 구현됐지만, generated/reviewed reference를 자동으로 product reference로 간주하지 않는다. Product-reference image selection, layer/reuse audit, rights review, 실제 해상도 가독성 및 Human QA는 별도 Gate다.

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
- `보호 / 관찰 / 대응 / 공격 / 장비 / 봉쇄 / 후퇴`를 모두 같은 상시 1차 메뉴에 나열하는 구조는 사용하지 않는다.

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
