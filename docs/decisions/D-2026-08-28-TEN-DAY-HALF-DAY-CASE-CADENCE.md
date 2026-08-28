# D-2026-08-28 · Ten-Day Half-Day Case Cadence

> Status: `USER_APPROVED / PLANNING_CANON / IMPLEMENTATION_CONTRACT_PENDING`
> Decision ID: `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE`
> Scope: global campaign cadence; M04 timing presentation successor
> Owner: `CURRENT_PLANNING_CANON.md`, `current-planning-canon.json`, `CURRENT_DECISION_OVERLAY.md`, `CURRENT_HANDOFF.md`, `M01_M04_VERTICAL_SLICE_FLOW.md`, `PROJECT_AI_PRODUCTION_SPEC.md`, Notion `괴이기록국 · Home`, `01 · Direction · Planning`, `02 · Flow · Playable Slice`
> Supersedes: `D-2026-08-28-M04-EARLY-DISPATCH-REGULAR-WEEK4-CADENCE` timing values and its 2/3/4-week framing

## Decision

한 campaign cycle은 **10일**이고, 하루는 **오전 / 오후** 두 반일 슬롯이다. 플레이어는 cycle마다 메인 사건 **1개**를 해결한다.

```text
Day 1 - Day 9  → 조기 해결 가능
Day 10         → 정규 해결
```

Day 10은 늦은 길, 강제 출동, 벌점의 다른 이름이 아니다. 조기 해결은 피해자를 더 이른 시점에 보호하는 선택이고, 정규 해결은 남은 반일 슬롯을 준비·조사·회복·관계에 쓰는 정상 선택이다. 조기 해결 뒤에는 같은 cycle의 두 번째 메인 사건을 만들지 않는다.

## Current evidence and boundary

- `scripts/core/campaign_state.gd`는 이미 `MAX_DAYS = 10`, `TIME_SLOTS = ["morning", "afternoon"]` 구조를 가진다.
- 그러나 현재 `preparation_scene.gd`에는 조기/정규 의미를 보여 주는 docket이 없고, `campaign_state.gd`에는 Day 10 정규 해결 판정이나 M04 timing result record가 없다.
- `monthly_state_policy.gd`의 week index / `dispatch_risk 0/15/30`은 새 결정의 consumer가 아니다.
- 따라서 이 결정은 **제품 의미는 CONFIRMED**, runtime / save / UI / numeric balance / Human QA는 **NOT_IMPLEMENTED 또는 NOT_RUN**이다.

## Superseded values and non-invention rule

전 predecessor의 `WEEK_2_EARLY`, `WEEK_3_EARLY`, `WEEK_4_REGULAR`, 노출 `0/15/30`, 지원 안정화 `0/+4/+8`은 모두 `SUPERSEDED`다. 사용자가 새 수치를 승인하지 않았으므로 Day 1~10에 임의 매핑하지 않는다. 기존 권나래 지원의 실제 runtime 기본 효과는 보존 검토 대상일 뿐, 새 timing bonus로 해석하지 않는다.

## Player contract

- 선택 전에는 현재 Day, 남은 반일 수, 조기/정규 라벨, 각 선택이 보호 시점과 준비 기회에 주는 차이를 읽을 수 있어야 한다.
- 조기/정규는 정답 선택이 아니다. 각각의 이득과 손해가 결과 이야기에서 이해 가능해야 한다.
- M04는 `피해자 → 잔향 → 귀가 기억 → 기록국` 순차 후일담에서 timing을 설명한다. 이 문서는 그 페이지를 runtime Scene으로 확정하지 않는다.
- timing은 단서·진실·구출/회수 등급을 자동으로 바꾸지 않는다.

## Three considered directions

| option | disposition | player value | production / risk |
| --- | --- | --- | --- |
| 10일·반일, Day 1~9 조기 / Day 10 정규 | `ADOPT` | 짧고 읽기 쉬운 준비 기회와 보호 시점의 고민을 만든다 | 현재 `CampaignState`의 10일·반일 구조를 재사용하지만 visible contract/save/result consumer가 필요하다 |
| 기존 4주 3-window를 날짜 이름만 바꿔 유지 | `REJECT` | 기존 수치의 친숙함만 남는다 | 의미가 불명확하고 Day 10 정규 규칙을 왜곡한다 |
| Day 10을 강제 출동·실패 방지 gate로 사용 | `REJECT` | 긴장은 빠르다 | 정규 해결을 벌점으로 바꾸며 사용자 결정과 충돌한다 |

## Implementation contract inputs

후속 단일 구현 계약은 다음을 명시해야 한다.

1. 10일·반일 전용 state와 legacy `monthly_state`의 호환 경계.
2. Day 1~9 / Day 10을 보여 주는 Preparation docket과 confirmation copy.
3. M04 timing record의 save round-trip, Result vignette payload, skip/continue input.
4. **별도 balance Decision:** 조기/정규가 실제로 무엇을 바꾸는지, 수치·상한·rollback을 승인한다. 현재 값은 `UNDEFINED`다.
5. M01 회귀, 1280×720·1920×1080 한국어 가독성, mouse/keyboard, automated + Human/new-player QA.

## Incident / Solution / Lesson

- **Incident:** current canonical documents used weekly timing values while runtime already used a 10-day, two-slot calendar; the mismatch could lead to a fabricated balance migration.
- **Solution:** record the user-approved calendar as the only timing authority and preserve old numbers as historical, not converted data.
- **Lesson:** calendar labels, visible player choice, save fields, and result consumers must be reconciled before a timing value is called a gameplay consequence. This lesson is campaign-specific; `NO_BASE_PROMOTION`.
