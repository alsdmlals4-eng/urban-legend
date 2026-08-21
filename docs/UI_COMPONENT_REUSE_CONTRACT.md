# 괴이기록국 · UI Component Reuse Contract

> Status: PLANNING_COMPLETE / INTEGRATED_CANON / IMPLEMENTATION_NOT_AUTHORIZED
> Source PR: #214
> Parent canon: `docs/CURRENT_PLANNING_CANON.md`

## Purpose

M01~M12 사건에서 재사용할 화면 언어를 정의한다.

## Investigation Components

- Scene Background Frame
- Observation Text Panel
- Choice Card
- Record Acquisition Card
- Keyword Tag
- Support Indicator

Principle:
현장·증거·선택이 캐릭터보다 우선한다.

Required behavior:
- 필수 핵심 기록은 단일 확률 성공에 잠기지 않는다.
- Choice Card는 조건·비용·잠금 이유를 선택 전에 표시한다.
- 획득한 record/keyword는 provenance를 보존한다.

## Deduction Components

- Manual Index (5 slots)
- Keyword Provenance Card
- Hypothesis Panel
- Support / Refute / Unresolved State
- Inference Sentence Area
- Return To Field Action

## Rescue Components

- Rule Summary Panel
- Victim State Panel
- Route / Action Board
- Risk Indicator

## Recovery Components

- Anomaly Field Frame
- Telegraph Indicator
- Protection Target Panel
- Action Set:
  - 보호
  - 관찰
  - 대응
  - 공격
  - 장비
  - 봉쇄
  - 후퇴
- Skill Cut-in Frame

## Pixel Observation Language

Pixel/dot is supporting language only.

Use:
- logs
- sensors
- CCTV
- map markers
- anomaly interference
- record effects

Do not replace main character art or full investigation presentation with pixel style by default.

## Guardrails

- Planning is complete, but `runtime_implementation: NOT_AUTHORIZED` remains the mutation boundary.
- No product asset promotion while `PRODUCT_REFERENCE_ASSET_PENDING`.
- 공용 Component는 질문·반증·피해자 갈등·봉쇄 조건을 사건 간 동일하게 만들지 않는다.
- Concrete image candidates require separate reference/rights/readability approval.
- No Human QA claims before actual sessions.
