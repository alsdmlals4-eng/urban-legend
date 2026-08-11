# Hybrid Narrative · Deduction · Growth — Adversarial Review

> Decision: `D-2026-08-11-HYBRID-NARRATIVE-DEDUCTION-GROWTH-INTEGRATION`
> Review mode: `PLAN PRE-IMPLEMENTATION / attack → validate-critique → decision-report`
> Baseline project main: `aee356a140c32c820a1c8832965b62ac3a5a6d58`
> Base observed: `315c66eea9614c284b9c11c4d522141065dfa4b0`
> Product mutation: `NONE`
> Human usability: `NOT_RUN`
> Player experience: `NOT_RUN`

## 1. Failure assumption

이 설계가 실패했다고 가정한다.

가능한 최악의 결과는 다음과 같다.

- 추리·텍스트노벨·육성을 연결한다는 명목으로 세 시스템이 모두 더 복잡해진다.
- 관계와 정체성이 숨은 선악 점수로 읽혀 플레이어 자기표현을 오히려 줄인다.
- 분기와 콜백이 콘텐츠 조합을 폭발시켜 네 핵심 사건 제작을 지연시킨다.
- 육성 준비가 사실상 정답/필수 단서 구매가 되어 조사 코어를 약화한다.
- 인물 감정이 객관적 괴이 규칙을 바꾸는 것처럼 보여 추리 공정성이 무너진다.
- 자동 테스트와 문서 완성도를 사람 경험 증거로 오인한다.

## 2. Protected strengths

다음은 공격 후에도 보호해야 한다.

1. 사건 플레이가 메인 콘텐츠이며 일정·육성은 지원 계층이라는 current authority.
2. 괴이의 객관적 진실과 필수 핵심 키워드는 성장 빌드에 잠기지 않는다는 계약.
3. `조사 → 구출 → 회수 → 결과`의 인과.
4. Year-One의 `지식 / 관계·기관 / 현장` 결과 축과 `조사 성향 / 보호 원칙 / 기관 내 위치 / 남은 책임` 연말 언어.
5. 모든 과거 플래그를 모든 장면에 반영하지 않는 범위 상한.
6. Human/Player Experience를 자동 검증으로 대체하지 않는 Base evidence ceiling.

## 3. Findings

### AR-01 — `MUST_FIX` — Umbrella design을 하나의 거대 L2 기능으로 오인할 위험

공격:
다섯 보완 요소를 한 PR/한 구현 계획으로 넘기면 narrative, data, relationship, playtest, campaign callback의 blast radius가 너무 커진다.

검증:
실제 설계는 `UMBRELLA_DESIGN_PRE_L2`로 표시하고 PoC 후 살아남은 항목만 개별 L2로 승격하도록 분해했다.

Disposition: `MITIGATED_IN_DESIGN`.

보호 규칙:

```text
Umbrella Design
→ PoC
→ KEEP/CHANGE/REMOVE
→ surviving L2 only
```

### AR-02 — `MUST_FIX` — 선택지가 가짜 분기로 느껴질 위험

공격:
플롯이 다시 합쳐지는 선택이 많으면 플레이어는 선택이 장식이라고 인식할 수 있다.

검증:
영구 플롯 분기는 제작비를 폭발시키므로 전부 영구화하는 것도 실패다.

Disposition: `MITIGATED_IN_DESIGN`.

최소 계약:
- 모든 선택은 `INFORMATION / STANCE / RISK / RELATIONSHIP / ACTION` 역할 중 하나 이상을 가진다.
- 합류 선택은 `즉시 반응 / 기록 흔적 / 관계 memory / 후속 callback` 중 하나 이상을 남긴다.
- 아무것도 남지 않는 선택은 삭제·통합 후보.

### AR-03 — `MUST_FIX` — 숨은 도덕성 meter가 될 위험

공격:
`조사 성향 / 보호 원칙 / 기관 내 위치 / 남은 책임`을 내부 숫자로 합산하면 결국 선악·정답 플레이를 만들 수 있다.

검증:
기존 Year-One authority가 단일 선악 점수와 단일 최고 등급을 이미 금지한다.

Disposition: `MITIGATED_IN_DESIGN`.

최소 계약:
- 단일 morality score 금지.
- identity evidence는 구체 사건/장면 source를 가진다.
- 우선은 숫자보다 서술·반응·근거 로그로 검증.
- 정확한 Schema/aggregation은 PoC 이후 별도 L2 승인.

### AR-04 — `MUST_FIX` — 관계 노가다가 메인 사건을 가릴 위험

공격:
관계 강화를 위해 선물, 반복 대화, 매일 클릭 같은 별도 노동을 넣으면 메인 사건 권위를 위반한다.

검증:
현재 Main Content Authority는 관계를 지원/환류 계층으로 제한한다.

Disposition: `MITIGATED_IN_DESIGN`.

최소 계약:
- relationship memory는 shared incident / responsibility / trust conflict에서 생성.
- generic 0~100 affection 성공 조건 금지.
- 첫 범위 2~3명.
- optional romance는 별도 콘텐츠 승인 전 core success condition 아님.

### AR-05 — `MUST_FIX` — 육성이 추리 정답을 대신할 위험

공격:
육성 가치가 약하다는 이유로 좋은 스탯을 가진 플레이어에게 필수 진실/정답을 주면 성장 체감은 커지지만 추리 코어가 죽는다.

검증:
`D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING`이 명시적으로 금지한다.

Disposition: `MITIGATED_BY_EXISTING_AUTHORITY + REASSERTED`.

허용:
- 정보량
- 비용/위험
- 복구 여유
- 추가 맥락
- 지원 방식
- 숙련 목표

금지:
- 필수 진실 독점
- 일반 클리어 독점
- 핵심 엔딩 독점

### AR-06 — `MUST_FIX` — 인물 감정이 괴이 진실을 덮어쓸 위험

공격:
텍스트노벨 강화를 위해 피해자의 기억이나 동료 감정을 사실 판정과 섞으면 논리 미스터리가 흔들린다.

검증:
현재 프로젝트는 객관적 진실 고정과 개인 기억/기록의 차이를 이미 코어로 사용한다.

Disposition: `MITIGATED_IN_DESIGN`.

원칙:

```text
FACT AUTHORITY = episode/investigation canon
MEANING LAYER = character interpretation/stakes
```

캐릭터는 사실을 바꾸지 않고 **그 사실을 왜 중요하게 여기며 어떤 책임을 택하는지**를 바꾼다.

### AR-07 — `SHOULD_FIX` — 콜백 조합 폭발

공격:
네 사건 × 여러 결과 × 여러 동료 × 기관 × 피해자를 전부 후속 장면에 반영하면 콘텐츠/QA가 지수적으로 증가한다.

검증:
기존 Year-One authority가 다음 분기에서 축마다 주 결과 최대 1개를 직접 활성화하는 상한을 이미 가진다.

Disposition: `MITIGATED_IN_DESIGN`.

Callback source priority:
1. 현재 사건이 활성화한 대표 결과
2. 장면 참여자의 relationship memory
3. unresolved responsibility
4. 나머지는 기록 보관소

### AR-08 — `SHOULD_FIX` — 플레이어가 identity label에 동의하지 않을 위험

공격:
시스템이 플레이어에게 “당신은 이런 사람”이라고 확정하면 자기표현이 아니라 판정처럼 느껴질 수 있다.

검증:
연말 요원 기록은 행동을 설명하되 도덕적 정답을 선언하지 않는다는 기존 계약이 있다.

Disposition: `TEST_REQUIRED`.

PoC 질문:
- 플레이어가 스스로 설명한 권나래와 시스템 반응이 크게 충돌하는가?
- 반응을 ‘판정’이 아니라 ‘타인의 관점’으로 읽는가?

실패 시 label 시스템을 키우지 말고 evidence/callback 중심으로 축소한다.

### AR-09 — `SHOULD_FIX` — Thought-aloud 자체가 추리를 왜곡할 위험

공격:
플레이 중 계속 생각을 말하게 하면 평소보다 근거를 더 명시적으로 검토해 난이도/이해도를 왜곡할 수 있다.

검증:
Thought Path 설계는 행동 관찰과 사후 인터뷰를 분리할 수 있도록 이미 명시한다.

Disposition: `MITIGATED / RESEARCH_METHOD_DETAIL_DEFERRED`.

실제 연구 계획에서 concurrent think-aloud와 retrospective probing의 사용 조건을 사전 정의한다.

### AR-10 — `SHOULD_FIX` — 벤치마크 리뷰 점수를 인과 근거로 오용할 위험

공격:
상용작의 높은 Steam 평가를 특정 메커닉의 성공 증거로 오해할 수 있다.

검증:
Source Context는 평점을 player-response signal로만 쓰고 원인 증거로 사용하지 않는다고 명시한다.

Disposition: `MITIGATED`.

### AR-11 — `DEFER` — 신규 identity/relationship runtime Schema

공격:
Semantic design만으로는 Save/Load, dedupe, migration, callback lookup 비용을 판단할 수 없다.

검증:
현재 단계에서 Schema를 미리 확정하면 PoC 전 과설계가 된다.

Disposition: `DEFER UNTIL POC SURVIVES`.

PoC 후 L2에서 runtime/persistent authority, stable IDs, dedupe, compatibility를 설계한다.

### AR-12 — `DEFER` — 관계 캐릭터 확대

공격:
오현/한세린 외 여러 인물을 동시에 깊게 만들면 장면·아트·QA가 폭발한다.

Disposition: `DEFER`.

처음 2~3명에서 callback value가 관찰된 뒤 확장한다.

### AR-13 — `DEFER` — 로맨스 상세 설계

공격:
선택적 로맨스를 핵심 관계 시스템과 동시에 설계하면 장르 약속과 제작량이 크게 바뀐다.

Disposition: `DEFER / OPTIONAL_PROVISIONAL`.

### AR-14 — `REJECTED_CRITIQUE` — 추리 코어를 Golden Idol 방식 UI로 교체해야 한다

검증:
외부 사례에서 필요한 것은 blind reasoning test 원리이지 answer-entry UI가 아니다. 현재 괴이 매뉴얼/키워드/현장 적용은 프로젝트 고유 코어다.

Disposition: `REJECTED_CRITIQUE`.

### AR-15 — `REJECTED_CRITIQUE` — 육성 장르를 강화하려면 활동·스탯 수를 크게 늘려야 한다

검증:
현재 프로젝트에는 시간·위험·연구·관계·준비도·장비 등 충분한 support state가 이미 있다. 병목은 수치 수가 아니라 이 결과가 인물·정체성·후속 사건에 체감되는 연결이다.

Disposition: `REJECTED_CRITIQUE`.

### AR-16 — `BLOCKED_UNVERIFIED` — 실제 재미·감정·관계 몰입

현재 문서·외부 benchmark·자동 검증만으로는 신규 설계가 실제로 재미있고 감정적으로 작동하는지 판정할 수 없다.

Disposition:

```text
HUMAN_USABILITY_EVIDENCE = NOT_RUN
PLAYER_EXPERIENCE_EVIDENCE = NOT_RUN
```

PoC 플레이 관찰 전에는 승격 금지.

## 4. GitHub / Google Sheet conflict findings

### SYNC-01 — `SHOULD_FIX / SEPARATE_RECONCILIATION`

Sheet `50_메인콘텐츠`가 `docs/decisions/D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION.md`를 책임 원본으로 가리키지만 current GitHub main에 해당 파일이 없다.

현재 GitHub에서 확인 가능한 관련 current authority:
- `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
- `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`

누락 파일의 내용을 추정·재생성하지 않는다.

Disposition: `SHEET_RESPONSIBILITY_PATH_DRIFT / separate owner-aware reconciliation`.

### SYNC-02 — `SHOULD_FIX / SEPARATE_RECONCILIATION`

Sheet `10_제품방향`의 `현재 Gate`는 과거 Validation/Codex 흐름을 current로 표시한다. 현재 GitHub work-instruction canon은 v4.5-r2이며 정확한 `기획 완료` 선언 전 persistent product BUILD가 금지된다.

Disposition: `SHEET_CURRENT_GATE_STALE / v4.5-r2 governance wins / separate reconciliation`.

## 5. Open PR interaction attack

현재 열린 기존 PR #193/#192/#191/#190/#189/#186/#183/#165/#149는 이 설계의 구현 소유자가 아니다.

- 이 설계는 별도 planning branch에서만 작업한다.
- 기존 PR의 old base/head GREEN을 새 main `aee356a1…`의 근거로 재사용하지 않는다.
- 특히 #183 Main Menu, #186/#189 route blocker, #190 safe return과 파일/권위 소유를 섞지 않는다.
- 이 설계 PR은 제품 runtime 변경을 포함하지 않는다.

## 6. Regression recheck of design logic

공격 후 다음 정상 경로는 유지된다.

```text
사건 코어
→ 추리로 FACT 형성
→ Scene Contract로 MEANING 형성
→ authored identity/relationship evidence 후보
→ bounded callback
→ 다음 사건 조건 / aftermath
→ 연말 요원 기록
```

확인된 보호:
- truth authority 단일성 유지
- growth non-gating 유지
- main-content priority 유지
- Year-One result-axis budget 유지
- relationship grind 금지
- fake branch 방지
- Human evidence claim ceiling 유지
- umbrella → PoC → surviving L2 분해 유지

## 7. Final adversarial decision

```text
P0 MUST_FIX findings: MITIGATED IN CURRENT DESIGN
P1 SHOULD_FIX findings: MITIGATED OR TEST/DEFER BOUNDED
USER_DECISION_REQUIRED: NONE — approved direction unchanged
RUNTIME/SCHEMA: DEFERRED
HUMAN_USABILITY_EVIDENCE: NOT_RUN
PLAYER_EXPERIENCE_EVIDENCE: NOT_RUN
PRODUCT_BUILD: NOT_AUTHORIZED
WRITTEN_SPEC_REVIEW: REQUIRED
```

최종 판정:

`DESIGN_SURVIVES_ADVERSARIAL_REVIEW / WRITTEN_SPEC_REVIEW_REQUIRED / POC_BEFORE_L2_PROMOTION / NO_PRODUCT_BUILD`
