# Hybrid Narrative · Deduction · Growth Integration Design

> Decision: `D-2026-08-11-HYBRID-NARRATIVE-DEDUCTION-GROWTH-INTEGRATION`
> 상태: `PROPOSED / USER_APPROVED_DIRECTION / WRITTEN_SPEC_AWAITING_REVIEW`
> 설계 레벨: `UMBRELLA DESIGN` — 개별 L2 생산 Spec 아님
> project baseline: `aee356a140c32c820a1c8832965b62ac3a5a6d58`
> Base observed: `315c66eea9614c284b9c11c4d522141065dfa4b0`
> 제품 구현: `NOT_AUTHORIZED`
> Human usability: `NOT_RUN`
> Player experience: `NOT_RUN`

## 0. Identity & authority

```yaml
feature_id: UL-HYBRID-NARRATIVE-DEDUCTION-GROWTH-001
feature_name: 괴이기록국 사실-의미-정체성 통합
work_level: UMBRELLA_DESIGN_PRE_L2
status: PROPOSED
canonical_path: docs/superpowers/specs/2026-08-11-hybrid-narrative-deduction-growth-design.md
related_decision_ids:
  - D-2026-08-11-HYBRID-NARRATIVE-DEDUCTION-GROWTH-INTEGRATION
  - D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY
  - D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING
  - D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT
source_context: docs/research/2026-08-11-text-novel-deduction-raising-benchmark-source-context.md
```

### Authority boundary

이 문서는 다음 질문을 책임진다.

- 텍스트노벨·추리·육성이 어떤 인과로 하나의 게임이 되는가?
- 현재 코어를 보존하면서 어떤 부족한 층을 보완하는가?
- 어떤 하위 패키지를 PoC한 뒤 L2 Feature Spec으로 승격할 것인가?
- 어떤 범위는 의도적으로 HOLD/AVOID하는가?

이 문서는 다음을 소유하지 않는다.

- 괴이의 객관적 사건 진실
- 개별 사건의 실제 정답·단서 데이터
- 실제 runtime Schema·Save migration
- UI 픽셀 레이아웃·최종 아트·오디오
- 실제 Task/PR progress와 executed verification
- 제품 GDScript/Scene/Resource 구현

## 1. Player problem

현재 기획은 플레이어에게 `사실을 조사하고 규칙을 적용하는 경험`은 강하게 약속하지만, 다음 세 질문에 대한 장기 체감 계약이 상대적으로 약하다.

1. **내가 알아낸 사실이 이 사람에게 왜 중요한가?**
2. **내가 어떻게 대했는지가 동료와 기관에 어떻게 남는가?**
3. **여러 사건을 지나면서 권나래는 어떤 요원이 되어 가는가?**

현재 위험은 장르가 다음처럼 분리되어 보이는 것이다.

```text
추리 = 사건 정답
텍스트노벨 = 정보를 읽는 화면
육성 = 사건 전 숫자 준비
```

원하는 변화는 다음이다.

```text
추리로 사실을 만든다
→ 장면이 그 사실의 인간적 의미를 만든다
→ 사건 선택과 책임이 관계·기관·정체성에 남는다
→ 그 누적이 다음 사건의 실제 조건과 후속 장면으로 돌아온다
```

## 2. Experience intent & core alignment

### Core experience sentence

> 플레이어는 괴이의 규칙을 스스로 추리해 사람을 구하고 현상을 회수하며, 그 과정에서 선택한 조사 방식과 보호 원칙 때문에 동료·기관·후속 사건이 자신을 다르게 대하는 **한 명의 기록국 요원**이 된다.

### Three-layer contract

```text
FACT
- 관측·기록·가설·검증
- 객관적 진실과 공정성

MEANING
- 피해자·동료·기관의 욕망·두려움·갈등
- 같은 사실을 둘러싼 태도와 책임 선택

IDENTITY
- 조사 성향
- 보호 원칙
- 기관 내 위치
- 남은 책임
```

### Existing core preservation

| owner | 유지할 권위 | 이번 Spec의 역할 |
|---|---|---|
| Main Content Authority | 조사→구출→회수→기록이 메인 | 인물·성장 환류를 앞뒤에 연결 |
| Investigation Truth Gate | 필수 진실 비잠금 | identity/relationship이 truth를 잠그지 못하게 보호 |
| Year-One Result Contract | 지식/관계·기관/현장 + 연말 4관점 | 이 결과를 실제 장면·반응으로 보이게 함 |
| Accessibility/Mastery contracts | 접근성은 핵심 판단과 동등 | 장면/관계 피드백도 감각 채널 하나에만 의존하지 않음 |

## 3. Scope / Non-goals

### In scope

1. `Investigation Thought-Path Playtest Contract`
2. `Text Novel Scene Contract`
3. `Investigator Identity Feedback`
4. `Core Relationship Network`
5. `Year-One Narrative Spine`

### Out of scope

- 새로운 범용 스탯/화폐/활동 슬롯 추가
- 대규모 직업 시스템
- 관계 캐릭터 대량 추가
- 로맨스 전체 설계
- 새 랭크/되감기/숙련 메타 시스템
- 새 조사 퍼즐 입력 방식
- 보이스 연기 의무화
- 실제 데이터 Schema 확정
- 제품 구현

### Minimum viable behavior

최소 PoC는 **저승역 1장**과 **사건 후 짧은 핵심 동료 장면 1개**만으로도 다음 연결이 느껴지는지 검증한다.

```text
기록을 비교해 가설을 만든다
→ 피해자/동료의 인간적 이해가 바뀐다
→ 하나의 태도·책임 선택을 한다
→ 그 선택에 즉시 반응이 있다
→ 사건 후 동료 장면에서 같은 선택의 의미가 다시 나타난다
→ 플레이어가 자신의 권나래를 한 문장으로 설명할 수 있다
```

이 PoC에서 작동하지 않으면 Year-One 전체 확장으로 가지 않는다.

## 4. Component A — Investigation Thought-Path Playtest Contract

### Purpose

사건의 논리 구조가 문서상 맞는지를 넘어, 처음 보는 플레이어가 실제로 의도한 사고 과정을 거치는지 관찰한다.

### Authoring fields

```yaml
thought_path_id:
chapter_or_scene:
target_inference:
required_evidence:
alternate_valid_evidence_paths: []
plausible_wrong_hypotheses: []
expected_revision_triggers: []
stuck_signatures: []
aha_point:
spoiler_budget:
hint_ceiling:
```

### Player-test observation fields

```yaml
tester_prior_exposure:
first_hypothesis_time:
evidence_used_in_order: []
wrong_hypotheses_observed: []
revision_trigger_observed:
stuck_state_observed:
player_explanation_of_answer:
confidence_before_reveal:
observer_notes:
```

### Rules

- 제작자가 정답을 설명하지 않는다.
- `생각을 말해보라`는 요청이 플레이 자체를 과도하게 바꾸면 행동 관찰과 사후 인터뷰를 분리한다.
- 정답 제출 여부만 성공 지표로 쓰지 않는다.
- 틀린 가설이 생겼다는 사실 자체를 실패로 취급하지 않는다. **공정한 반증과 수정 기회가 있는지** 본다.
- 자동 테스트는 단서 reachability/contract를 검증할 수 있지만 실제 Aha를 증명하지 못한다.

### PoC start

저승역 1장 `개인 목적지 투영 교차검증`을 대표 Thought Path로 사용한다. 신규 정답을 만들지 않고 current canon의 기록 비교 경로를 관찰한다.

## 5. Component B — Text Novel Scene Contract

### Purpose

텍스트노벨을 `정보를 배달하는 화면`에서 **사실·인물·태도·후속 결과를 동시에 움직이는 장면**으로 만든다.

### Scene contract

```yaml
scene_id:
scene_role: INVESTIGATION | INTERSTITIAL | RELATIONSHIP | INSTITUTION | AFTERMATH
pov:
participants: []
dramatic_question:
known_fact_before:
new_fact_or_recontextualization:
character_wants:
character_fears_or_stakes:
choice_roles: []
convergence_rule:
immediate_reaction:
persistent_callback_candidates: []
identity_relevance:
relationship_relevance:
next_question_created:
spoiler_budget:
skip_replay_behavior:
accessibility_channels:
```

### Choice role taxonomy

선택은 최소 하나의 명확한 역할을 가진다.

- `INFORMATION` — 무엇을 더 알고 싶은가
- `STANCE` — 권나래가 무엇을 중요하게 여기는가
- `RISK` — 어떤 비용·위험을 감수하는가
- `RELATIONSHIP` — 누구의 관점·전문성·책임을 신뢰하는가
- `ACTION` — 현장에서 무엇을 실제로 하는가

한 선택이 여러 역할을 가질 수 있지만, **역할 없는 장식 선택**은 만들지 않는다.

### Convergent choice rule

플롯이 다시 같은 지점에 합쳐져도 선택은 다음 중 하나 이상을 남겨야 한다.

- 직후 대사/표정/서술 반응
- 기록 로그의 태도/책임 흔적
- 관계 milestone 후보
- 이후 대화의 재언급
- 기관·피해자 후속 장면의 framing

아무것도 남지 않으면 해당 선택은 삭제·통합 후보다.

### Narrative protection

- 인물 감정은 괴이의 객관적 진실을 바꾸지 않는다.
- 플레이어 자기표현을 위해 고정 주인공 권나래의 핵심 가치와 직업 책임을 무효화하지 않는다.
- ‘친절/악함’ 한 축으로 선택을 환산하지 않는다.
- 모든 장면을 영구 분기로 만들지 않는다.

## 6. Component C — Investigator Identity Feedback

### Purpose

기존 일정/사건 선택이 단순 수치 변화에 그치지 않고, 플레이어가 **자신의 권나래가 어떤 방식의 요원인지** 인식하게 한다.

### Existing identity vocabulary

새 도덕성 meter 대신 이미 승인된 연말 언어를 재사용한다.

```text
조사 성향
보호 원칙
기관 내 위치
남은 책임
```

### Identity evidence model

각 identity 변화 후보는 **저작된 사건/장면 근거**를 가져야 한다.

```yaml
identity_evidence_id:
source_scene_or_outcome:
observed_player_choice:
axis:
meaning:
strength_or_salience: HYPOTHESIS
visible_callback_candidates: []
```

이 Spec은 숫자 합산 공식을 승인하지 않는다. PoC 단계에서는 플레이어에게 보이는 **서술·장면 반응과 근거 기록**이 먼저다.

### Allowed downstream effects

- 동료/기관의 대사와 기대
- 비필수 조사 질문/맥락
- 지원 방식 또는 책임 비용
- 후속 장면 순서/프레이밍
- 연말 요원 기록의 근거

### Forbidden downstream effects

- 핵심 진실 접근 차단
- 일반 클리어 차단
- ‘올바른’ identity의 필수 보상 독점
- 접근성 사용에 따른 identity 낙인
- 숨은 선악 점수로 모든 반응 통합

## 7. Component D — Core Relationship Network

### Purpose

관계를 별도 데이트/선물 노동이 아니라 **사건을 함께 처리한 방식의 기억**으로 만든다.

### Initial scope

처음에는 핵심 동료 2~3명만 대상으로 한다. current 상태상 우선 후보는 오현·한세린이며, 추가 인물은 별도 검증 후 확장한다.

### Relationship memory unit

```yaml
relationship_memory_id:
character_id:
source_incident_or_scene:
shared_problem:
player_choice_or_result:
character_interpretation:
open_tension_or_trust:
callback_scene_candidate:
support_consequence_candidate:
```

### Rules

- 단일 0~100 호감도를 성공 조건으로 만들지 않는다.
- 관계 변화는 실제 공유 사건이나 후속 책임에서 나온다.
- 동료가 플레이어의 도덕성을 채점하는 기계처럼 보이지 않게 각자의 가치와 전문성에 따라 반응한다.
- 관계가 나빠져도 필수 진실/필수 캠페인 진행은 유지한다.
- 좋은 관계는 정답 제공이 아니라 관점·지원·복구·비용의 차이를 만든다.
- 선택적 로맨스는 core relationship layer 위의 별도 콘텐츠이며 현재 필수 범위가 아니다.

## 8. Component E — Year-One Narrative Spine

### Purpose

네 핵심 사건을 단절된 에피소드가 아니라 **권나래·동료·기관·피해자의 1년**으로 기억하게 한다.

### Existing result contract reuse

현재 `D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT`를 그대로 사용한다.

```text
지식
관계·기관
현장
```

다음 핵심 사건은 기존 계약대로 최소 2축을 사용하고, 겨울은 3축 모두를 사용한다. 이 Spec은 그 수를 늘리지 않는다.

### Narrative spine flow

```text
봄 핵심 사건
→ 사건 직후 사람/책임 장면
→ 준비·연구·관계 환류
→ 여름 핵심 사건에서 대표 결과 사용
→ 사건 직후 사람/책임 장면
→ 가을
→ 사건 직후 사람/책임 장면
→ 겨울에서 3축 종합
→ 연말 요원 기록
```

### Callback budget principle

모든 과거 플래그를 모든 장면에서 읽지 않는다.

Callback source priority:

1. 현재 사건이 직접 활성화한 대표 결과
2. 현재 장면 참여자의 relationship memory
3. 아직 해결되지 않은 `남은 책임`
4. 현재 장면의 극적 질문과 무관한 과거 데이터는 기록 보관소에 남김

### Required narrative payoff classes

- `INCIDENT_CALLBACK` — 과거 사실/위험/구출 결과의 재언급
- `RELATIONSHIP_CALLBACK` — 함께 일한 방식의 재언급
- `INSTITUTION_CALLBACK` — 기록국 평가·명령·불신·지원 변화
- `VICTIM/RESPONSIBILITY_CALLBACK` — 후유증·미완료 보호·후속 책임
- `IDENTITY_MIRROR` — 다른 인물이 권나래의 반복된 방식을 비추는 장면

한 장면에 모든 클래스를 넣지 않는다.

## 9. Cross-component data flow

이 단계에서는 runtime Schema를 확정하지 않고 semantic flow만 고정한다.

```text
Investigation evidence
→ hypothesis/manual state
→ incident outcome packet
→ authored scene choice/reaction
→ identity evidence + relationship memory candidates
→ bounded quarter callback selection
→ next incident condition / aftermath scene
→ year-end identity record
```

### Single-authority rules

- 사건 진실: 기존 episode/investigation canon
- 사건 결과: 기존 result packet authority
- 관계·기관 장기 결과: 기존 Year-One result axis
- identity vocabulary: 기존 year-end four-view contract
- 이 Spec: 위 source를 **어떻게 장면에서 연결하는지**만 책임

같은 사실을 별도 narrative DB에 복제해 새 authority를 만들지 않는다.

## 10. First-session / first-ten-minutes contract

현재 저승역 first-ten-minutes canon을 보존하며 다음 추가 검증만 한다.

```text
대표 문제
→ 서로 충돌하는 기록/개인 목적지
대표 행동
→ 기록 비교·후보 가설
첫 의미 있는 선택
→ 어떤 근거/질문/태도로 다음 조사에 접근할지
첫 observable result
→ 새 정보 또는 가설 수정 + 인물 반응
next question
→ 왜 같은 순간 사람마다 다른 목적지를 들었는가?
```

첫 10분에 identity 시스템을 설명하는 별도 튜토리얼을 추가하지 않는다. 플레이어가 장면과 반응을 통해 자기 방식이 기록될 수 있음을 먼저 느끼는지 본다.

## 11. Planned PoC

### PoC-1 — Thought Path

대상: 저승역 1장.

검증 질문:
- 핵심 가설을 어떤 근거 순서로 만드는가?
- 실제 오답 가설은 무엇인가?
- 반증 근거를 만났을 때 수정하는가?
- 답을 낸 뒤 이유를 설명할 수 있는가?

### PoC-2 — Scene Contract

대상: 저승역 주요 조사 장면 1개.

검증 질문:
- 정보 기능과 인물의 욕망/두려움이 동시에 읽히는가?
- 선택이 단순 `다음 정보 보기`가 아니라 태도/관점으로 느껴지는가?
- 즉시 반응을 플레이어가 인식하는가?

### PoC-3 — Fact → Meaning → Identity callback

대상: 사건 후 핵심 동료 짧은 장면 1개.

검증 질문:
- 플레이어가 이전 선택과 현재 동료 반응의 인과를 이해하는가?
- 동료가 도덕 점수를 매긴다고 느끼지 않는가?
- 플레이어가 자신의 권나래를 한 문장으로 설명할 수 있는가?

### Recruitment / evidence

초기 파일럿은 **fresh/unexposed player**를 우선한다. Golden Idol의 반복 외부 테스트 사례를 참고하되 특정 표본 수를 보편 법칙으로 고정하지 않는다. 첫 연구 계획에서는 `약 5회 관찰 세션`을 `RECOMMENDED_STARTING_SAMPLE`로 검토하고, 성공/실패 기준과 확대 조건을 실행 전에 사전 등록한다.

실행 전까지:

```text
HUMAN_USABILITY_EVIDENCE = NOT_RUN
PLAYER_EXPERIENCE_EVIDENCE = NOT_RUN
```

## 12. Success / failure of the umbrella design

### Keep / promote

PoC에서 다음이 동시에 관찰되면 해당 하위 패키지를 L2 후보로 승격한다.

- 플레이어가 추리 근거를 설명할 수 있다.
- 장면의 인물 의도/갈등을 기억한다.
- 선택에 즉시·후속 반응이 있다고 인식한다.
- 자신의 권나래를 시스템이 강요한 정답이 아니라 **자기 선택의 결과**로 설명한다.
- 관계/identity 피드백이 핵심 진실을 잠그지 않는다.

### Change / retest

- 플레이어가 선택을 전부 정보 버튼으로 인식
- 관계 반응을 숨은 선악 점수로 해석
- 추리보다 대화 정답 찾기에 집중
- 과거 콜백이 너무 많아 현재 사건을 방해
- 육성 준비가 필수 진실 접근을 사실상 독점

### Stop / remove

- 장면 콜백 비용 대비 플레이어가 원인 관계를 인식하지 못함
- identity label이 플레이어 자기인식과 반복적으로 충돌
- 관계 시스템이 선물/반복 노동 없이는 재미를 만들지 못함
- narrative layer가 추리 공정성을 지속적으로 손상

## 13. Risks & mitigations

| risk | 영향 | mitigation |
|---|---|---|
| Scope explosion | 장면/분기 제작량 폭발 | 대표 결과·relationship memory만 callback source로 사용 |
| Fake branching | 선택 불신 | choice role + immediate reaction + persistent callback 중 하나 이상 필수 |
| Hidden morality meter | RP 반감 | 4축 identity evidence, 단일 선악 합산 금지 |
| Relationship grind | 메인 사건 희석 | 사건/책임 기반 관계, 선물 루프 비필수 |
| Character drama overwrites truth | 추리 공정성 붕괴 | FACT authority와 MEANING layer 분리 |
| Growth solves mystery | 코어 선택 붕괴 | 필수 진실 비잠금 Decision 유지 |
| Callback exposition dump | 텍스트 과밀 | 현재 극적 질문과 관련 없는 결과는 보관소로 |
| Meta-system distraction | 제작 우선순위 역전 | 새 replay/rank/meta 규칙 HOLD |
| False human claim | 검증 신뢰 붕괴 | 실행 전까지 Human/Player evidence NOT_RUN |

## 14. Production decomposition after written approval

이 상위 Spec 자체를 하나의 거대 구현 계획으로 변환하지 않는다.

written Spec review 이후 순서는 다음이다.

```text
Package 1: Thought-Path + Scene Contract PoC plan
→ PoC / Human evidence
→ KEEP/CHANGE/REMOVE

Package 2: Investigator Identity L2 Spec candidate
→ only if Package 1 survives

Package 3: Core Relationship Network L2 Spec candidate
→ only if callback value is observed

Package 4: Year-One Narrative Spine content spec
→ compose surviving identity/relationship contracts
```

각 Package는 별도 owner/acceptance/rollback을 가져야 한다.

## 15. Spec self-review

### Placeholder scan

- `TBD/TODO` 없음.
- 미확정 수치와 runtime Schema는 확정 값처럼 쓰지 않고 `HYPOTHESIS / RECOMMENDED_STARTING_SAMPLE / 후속 L2`로 제한했다.

### Internal consistency

- 메인 콘텐츠 사건 권위를 유지한다.
- 필수 진실 비잠금 원칙을 유지한다.
- Year-One 3축 및 연말 4관점과 충돌하지 않는다.
- 새 관계/identity authority를 중복 생성하지 않는다.

### Scope check

- 다섯 요소를 하나의 runtime feature로 구현하지 않는다.
- 상위 design은 `Fact → Meaning → Identity` 인터페이스와 PoC 순서만 고정한다.
- 하위 L2는 PoC에서 살아남은 항목만 승격한다.

### Ambiguity check

- `관계 강화`를 generic affection meter로 해석하지 못하도록 사건 기반 memory로 명시했다.
- `육성 강화`를 새 스탯 추가로 해석하지 못하도록 existing identity vocabulary 재사용을 명시했다.
- `텍스트노벨 강화`를 무제한 branching으로 해석하지 못하도록 convergent choice rule을 명시했다.
- `추리 강화`를 새 puzzle count 증가로 해석하지 못하도록 Thought-Path evidence를 우선했다.

## 16. Current gate

```text
USER_APPROVED_DIRECTION
→ WRITTEN_SPEC_CREATED
→ SELF_REVIEW_COMPLETE
→ USER_WRITTEN_SPEC_REVIEW_REQUIRED
→ only then: PoC planning / individual L2 promotion work
```

정확한 `기획 완료` 선언은 여전히 별도이며, 그 전에는 persistent product BUILD에 진입하지 않는다.
