# M04 현재 Godot 구현 계획 — 2026-08-30

> 상태: `IMPLEMENTED_FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN`
>
> 기준: latest `origin/main` `2be624893dd114247266ff8aa3af8f8a091c29a8`
>
> 사용자 승인 근거: 최신 지시의 “권장안대로 진행”, “Godot에 기획안들 전부 구현될 때까지” 및 현재 범위의 필요한 승인 일괄 허용.
>
> 구현 기준 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`, `docs/CURRENT_DECISION_OVERLAY.md`, `docs/CURRENT_HANDOFF.md`, `docs/CURRENT_VISUAL_WORK_ORDER.md`, root `ASSET_MANIFEST.yml`.

## 1. 플레이어가 받는 변화

M04 빨간 우산을 선택해 출동하면, 준비 화면에서 지금의 날짜와 반일 슬롯이 **조기 해결**인지 **정규 해결**인지 먼저 읽는다.

- Day 1~9에는 “더 이른 피해자 보호”라는 조기 해결 의미를 표시한다.
- Day 10에는 “남은 반일을 준비에 사용한 정규 해결”이라는 의미를 표시한다. 지연·강제 출동·숨은 벌점으로 표현하지 않는다.
- 한 10일 cycle에서 실제로 출동을 시작한 메인 사건만 그 cycle의 메인 사건이 된다. 조기 해결 뒤 다른 메인 사건을 같은 cycle에 추가로 시작할 수 없다.
- M04의 종료는 점수판이 아니라 `피해자 → 잔향 → 귀가 기억 → 기록국` 네 페이지를 다음 입력으로 넘긴다.
- 귀가 기억 페이지는 실제 출동 Day/반일과 실제 `귀가 기억 고정` 지원 사용만 기록한다. 새 숫자 보너스·정답·진실은 추가하지 않는다.

M04 회수 화면은 이미 존재하는 Godot UI를 유지한다. 새 정적 UI 이미지 대신, 기존 `Background`와 `AnomalyVisual` 소비처에 맞춰 준비된 회수 배경과 D 단계 단일 우산 투명 후보를 검증 뒤 적용한다.

## 2. 포함·제외

### 포함

1. `CampaignState`의 cycle 단위 메인 사건 lock과 Day 1~9/Day 10 출동 context.
2. 기존 저장 구조 안의 additive campaign metadata 및 구 저장 기본값 복원.
3. Preparation의 현재 cycle·출동 의미·선택 불가 이유 표시.
4. M04 한정 순차 결과 페이지와 mouse/keyboard 다음 입력.
5. M04 Recovery 배경과 D 단계 transparent cutout의 기존 경로 승격, manifest·provenance·focused regression 갱신.
6. focused Godot/Python regression 및 가능한 실제 1280×720·1920×1080 runtime capture.

### 제외

- Day별 수치 보너스·노출·안정화 수치, 기존 `0/15/30` 또는 `0/+4/+8`의 환산.
- M04 이외 사건의 결과 UX 변경, M01 first-session 의미 변경.
- 새 사건·새 clue·새 정답/가설·새 피해자·새 경제/성장 규칙.
- M04 entrance candidate와 M01 entrance candidate의 승격. 둘은 별도 실제 소비처 비교가 필요하다.
- Human/new-player/accessibility QA PASS, release-rights legal clearance, production expansion 선언.

## 3. 대안 비교 및 채택

| 방향 | 판정 | 이유 |
| --- | --- | --- |
| 기존 10일·반일 state에 최소 metadata, 선택 lock, M04 logical-page 결과를 더한다 | `ADOPT` | 이미 존재하는 campaign/save/UI를 재사용하며 승인된 cadence와 M04 결과 인과를 실제 플레이에 연결한다. 새 수치를 만들지 않는다. |
| 과거 2/3/4주·0/15/30 값을 Day 1~10으로 환산해 즉시 balance까지 구현한다 | `REJECT` | 명시적으로 `SUPERSEDED / UNDEFINED`인 수치를 되살리며 정규 해결을 벌점처럼 만들 위험이 있다. |
| 시각 후보·mockup을 하나의 fullscreen bitmap UI로 바꾸고 결과를 카드 대시보드로 합친다 | `REJECT` | 현재 Godot Control 소비처와 Dossier presentation language를 훼손하고, 승인된 순차 후일담과 충돌한다. |
| M04를 미루고 M05~M12를 먼저 임의 제작한다 | `DEFER` | M04는 release-near slice이고 M05+는 현재 실제 사건 데이터/승인 consumer가 준비되지 않았다. |

## 4. 구현 단위

### A. Campaign metadata와 one-main-case enforcement

파일 후보:

- `scripts/core/campaign_state.gd`
- `scripts/core/game_state.gd`
- `tests/test_mvp037_campaign_state.gd`
- 새 focused campaign cadence test

계약:

- `cycle_main_case_id`는 실제 `begin_operation()` 시에만 고정한다. preparation에서 선택만 하고 시작하지 못한 경우에는 lock을 만들지 않는다.
- 같은 cycle에서 lock된 사건과 다른 episode는 `set_planned_case()`와 `begin_operation()`에서 거부한다.
- Day 1~9는 `EARLY`, Day 10은 `REGULAR` dispatch context를 active operation에 기록한다.
- resolution 뒤 context는 해당 case state와 completed report에서 읽을 수 있도록 보존한다.
- 새 metadata가 없는 기존 저장은, 진행 중 operation이 있으면 저장된 사건·날짜·슬롯으로 lock/context를 재구성하고, operation이 없으면 빈 lock/context로 기본 복원한다. save version/root key를 올리지 않는다.
- risk, clue, recovery threshold, support 기본 효과, truth는 바꾸지 않는다.

### B. Preparation docket

파일 후보:

- `scripts/scenes/preparation_scene.gd`
- preparation scene focused test

계약:

- 현재 `운영 n일차 오전/오후` 라벨에 cycle 상태와 M04 dispatch 의미를 추가한다.
- 현재 날짜 기준으로 조기/정규 의미를 표시하되 수치·추천·정답 라벨은 표시하지 않는다.
- lock된 다른 사건 버튼은 disabled 상태와 이유를 가지며, 이미 해결된 cycle에는 새 메인 사건 선택을 열지 않는다.
- 현장 시작 뒤에는 active operation의 동일 dispatch context가 유지된다.

### C. M04 sequential narrative result

파일 후보:

- `scripts/scenes/result_scene.gd`
- `scripts/core/game_state.gd`
- M04 result focused scene test

계약:

- M04와 유효 campaign resolution context가 함께 있을 때만 네 logical page를 렌더한다.
- Page 1은 기존 victim rescue result/after-story, Page 2는 existing recovery result, Page 3은 recorded dispatch context 및 실제 `support_kwon_return_route` 사용, Page 4는 existing record/research/next action을 사용한다.
- 다음/이전이 아닌 명시적 “다음 기록” 입력으로 한 페이지씩 진행한다. 위치 표시는 `1 / 4` 형태만 허용한다.
- M01과 legacy/direct non-campaign result는 기존 `COMPOSITE_RESULT` surface를 보존한다.
- Page 3은 `EARLY`/`REGULAR`의 의미만 문장으로 설명하며 새 balance나 outcome-grade를 만들지 않는다.

### D. M04 Recovery product assets

파일 후보:

- `assets/backgrounds/red_recovery.png`
- `assets/anomalies/cutouts/red_umbrella_d_cutout.png`
- `ASSET_MANIFEST.yml`
- `docs/approvals/PROJECT_PROTECTED_CHANGE_APPROVAL_M04_CURRENT_IMPLEMENTATION_20260830.json`
- focused asset promotion regression

계약:

- source candidate bytes are copied without post-processing from `M04_RECOVERY_BACKGROUND_ADAPT_02_20260828.png` and `M04_ANOMALY_D_ADAPT_01.png`.
- recovery background remains background-only: no baked text/UI/umbrella/figure, leaving the upper-middle anomaly zone and lower ActionDock zone.
- D cutout remains a genuine RGBA texture with alpha-zero transparent margin, a single D-risk umbrella identity, no scenery/UI/extra figure.
- existing `ScenePresentation.apply_background()` and `apply_anomaly()` routes, scene nodes, full fallback, and B/C assets are preserved.
- manifest records exact source/canonical SHA, actual consumers, source provenance, current user promotion authorization, machine/runtime evidence boundary, and Human QA pending state.

## 5. Test-first sequence

1. Add failing tests for the cycle lock, timing context classification, save default/round trip, preparation copy/disabled state, and M04 page order/context.
2. Add failing asset tests that require exact candidate bytes at both canonical asset paths, D RGBA transparency, and unchanged existing consumer routes.
3. Implement the smallest state/UI code to pass those tests.
4. Run focused Godot scripts and Python contract tests, then the relevant full Godot regression route.
5. Start from actual Scene consumers to inspect 1280×720 and 1920×1080. Record runtime evidence only if a real Urban Legend runtime is available; do not attach to another project’s live editor.
6. Run five whole-scope adversarial loops: campaign semantics, save compatibility, result causality, UI/input/readability, and asset/provenance/rollback.

## 6. Acceptance and rollback

Acceptance requires:

- only one operation case can be started per 10-day cycle;
- Day 1~9 and Day 10 produce the correct non-numeric context;
- no M01 first-session behavior change;
- M04 results retain four causal pages, no aggregated score dashboard;
- candidate byte, alpha, consumer, manifest, and provenance checks pass;
- automated checks distinguish machine pass from runtime/Human QA.

Rollback is bounded: revert the implementation commit(s), restoring the two canonical M04 asset bytes and removing the additive campaign/result fields. Existing data has default fallbacks, so no destructive migration is required.

## 7. 실행 및 검증 증거 — 2026-08-30

### 구현 결과

- `CampaignState`는 처음 실제 출동한 case만 `cycle_main_case_id`로 고정하고, 같은 10일 cycle의 두 번째 메인 사건 시작을 거부한다. 출동 context에는 Day 1~9 `EARLY`, Day 10 `REGULAR`과 실제 반일 슬롯을 기록·저장한다.
- Preparation은 현재 cycle 메인 사건, 다음 cycle 대기 상태, 현재 출동의 조기/정규 의미를 숫자 보정 없이 표시한다.
- M04 결과는 Godot `Control` 기반으로 `피해자 → 잔향 → 귀가 기억 → 기록국` 네 페이지를 한 입력씩 표시한다. 첫 화면에는 기존 결과 계약을 보존하는 `ReasoningSummary`를 함께 둔다.
- `red_recovery.png`와 `red_umbrella_d_cutout.png`는 승인 후보의 정확한 bytes로 canonical consumer에 승격했다. D 단계는 초기 회수 화면에서 cutout 전체가 보이는 centered crop을 사용하고, 기존 B/C cover crop은 유지한다.

### 다섯 회 전체 범위 반대 검토

| 회차 | 공격한 위험 | 검증과 결과 |
| --- | --- | --- |
| 1 | 한 cycle에 여러 메인 사건을 다시 시작하거나 Day 10을 벌점으로 만드는 문제 | `m04_current_campaign_cadence_test`, two/three-case campaign QA 통과. Day 10은 정규 대응 context만 남고 수치 보정은 없다. |
| 2 | 구 저장에 새 metadata가 없어 load가 깨지는 문제 | campaign/save 경로와 80개 Godot 엔트리포인트 회귀 통과. 기존 저장은 빈 lock/context 기본값으로 복원된다. |
| 3 | M04 결과가 점수판이 되거나 기존 추리 근거 surface를 잃는 문제 | `m04_sequential_result_vignette_test`와 `test_mvp039_manual_ux_validation` 통과. 네 페이지·단일 다음 입력·`ReasoningSummary`를 유지한다. |
| 4 | D cutout이 런타임 편집 기본 crop에 의해 잘리거나 B/C가 변하는 문제 | `m04_recovery_promoted_asset_runtime_test`가 1280×720 및 1920×1080에서 D centered crop을 확인했고, B/C 기본 cover 경로는 보존했다. |
| 5 | 정본·자산 provenance·기존 자동 검사와 충돌하는 문제 | runner가 열거한 Godot 80개 엔트리포인트와 Python 계약 검사 472개를 순차 통과했다. candidate SHA, alpha, consumer, manifest 검사는 focused asset promotion test로 확인했다. |

### 증거 상한과 보류 항목

- 이 문서는 `FOCUSED_MACHINE_VERIFIED`까지의 기록이다. headless 자동 검사는 human/new-player/accessibility QA, 실제 사용자 조작감, 출시 PASS가 아니다.
- M04 entrance 및 M01 entrance candidate, M05~M12 신규 사건, Day별 수치 balance는 현재 범위 밖이며 승격·제작하지 않았다.
- 런타임 검증 중 Windows Godot가 실제 `user://` 저장 위치를 사용할 수 있어, 각 stateful test 뒤 작업 시작 시점 저장 backup을 정확한 SHA-256로 복구·대조했다. 최종 원본 저장 SHA-256은 `21EF268BC46D348B94BC34408DBB62936C1151AF78FBF14CFC7CE7403563C849`다.
