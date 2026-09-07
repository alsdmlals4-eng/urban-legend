# D-2026-08-29 · Core Loop Priority

> Status: `USER_APPROVED / PLANNING_CANON / NO_RUNTIME_MUTATION`
> Decision ID: `D-2026-08-29-CORE-LOOP-PRIORITY`
> Scope: player-experience hierarchy and successor implementation order
> Owner: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`, `docs/CURRENT_DECISION_OVERLAY.md`, `docs/CURRENT_HANDOFF.md`, `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
> Does not supersede: `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE`; it reclassifies the calendar as supporting context rather than primary fun.

## Decision

괴이 기록국의 **1차 플레이 경험**은 다음이다.

```text
조사: 무엇을 실제로 관찰했는가
→ 추리/매뉴얼: 어떤 규칙이 그 근거와 모순을 설명하는가
→ 회수: 지금의 전조에 어떤 가설·증거·대응을 연결하는가
```

플레이어는 관측 가능한 정보를 가설로 엮고, `telegraph → hypothesis → evidence → response` 회수에서 그 판단을 검증한다. 이것이 Vertical Slice가 반드시 검증해야 할 핵심 재미다.

10일·오전/오후 일정은 **보조 캠페인 시스템**이다. 준비, 후일담, 연구, 관계, 다음 사건으로 넘어가는 리듬을 제공하되 단서·진실·정답·회수 대응을 제공하거나 대체하지 않는다. 일정 선택이 존재해도 조사·추리와 회수의 판단이 읽히지 않으면 핵심 경험은 통과하지 않는다.

키워드/매뉴얼은 추리의 근거를 표현하는 도구이고, 피해자 구출과 Composite Result는 판단의 인간적 결과를 분리해 보존하는 인과 bridge다. 이 결정은 이들의 기존 의미를 축소하지 않는다.

## Evidence and benchmark check

- current project evidence: M01/M04 shared grammar already connects investigation evidence, hypotheses, rescue, and recovery; the 10-day calendar is structurally present but its player-facing timing contract is not implemented.
- external reference: the official *Return of the Obra Dinn* page describes an exploration-and-logical-deduction mystery, while the publisher description of *The Case of the Golden Idol* centers examining clues and building a theory. Both support keeping evidence interpretation as the primary action, not copying their presentation, content, or structure.

| direction | disposition | reason |
| --- | --- | --- |
| evidence-led investigation/deduction and telegraph-led recovery as the primary core | `ADOPT` | matches user direction and the implemented M01/M04 causal grammar |
| calendar as preparation/aftermath context | `ADAPT` | retains the approved 10-day rule without allowing timing to overshadow deduction or recovery |
| calendar as the primary gameplay loop or an answer source | `REJECT` | conflicts with the player promise and would turn a support structure into false proof of fun |

Sources: <https://obradinn.com/>, <https://www.nintendo.com/us/store/products/the-case-of-the-golden-idol-complete-edition-70010000086587-switch/>.

## Implementation and validation boundary

1. The next unified implementation contract must state the investigation → deduction/manual → recovery evidence chain first.
2. Keyword composition must be validated as a deduction consumer; it remains `APPROVED_DESIGN / NOT_IMPLEMENTED` today.
3. Calendar save/UI/balance work must preserve the core loop and must not create hidden truth, a correct-response recommender, or a second primary loop.
4. Human/new-player validation must ask whether a player can explain the evidence, rule, telegraph, and response before asking whether the schedule is understandable.

No runtime code, Scene, Resource, save schema, balance number, asset, or Human/player pass is authorized by this decision.
