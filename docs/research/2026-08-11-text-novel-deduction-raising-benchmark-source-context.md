# 2026-08-11 Text Novel · Deduction · Raising Benchmark Source Context

> Decision: `D-2026-08-11-HYBRID-NARRATIVE-DEDUCTION-GROWTH-INTEGRATION`
> 상태: `SOURCE_CONTEXT_PACKET / DESIGN_EVIDENCE`
> 기준 시각: 2026-08-11 KST
> project main at research start: `aee356a140c32c820a1c8832965b62ac3a5a6d58`
> Base main at research start: `315c66eea9614c284b9c11c4d522141065dfa4b0`
> Human/Player Experience evidence for this new design: `NOT_RUN`

## 1. Decision to make

```yaml
decision_to_make: >-
  괴이기록국의 텍스트노벨·추리·육성 혼합에서 현재 가장 약한 층이 무엇인지,
  그리고 이미 강한 코어를 훼손하지 않고 무엇을 보완해야 하는지 결정한다.
current_hypothesis: >-
  추리 시스템 자체보다 사건의 사실이 인물의 의미와 장기 요원 정체성·관계로 환류되는 층이 약하다.
what_would_change_the_decision:
  - current canon에 이미 충분한 장면/관계/정체성 환류 계약과 실행 가능 콘텐츠가 존재하는 증거
  - benchmark에서 큰 스탯/활동 확장이 하이브리드 코어에 필수라는 강한 근거
  - 플레이어 테스트에서 현재 관계·장기 서사 부족이 실제 문제가 아니라는 반증
excluded_questions:
  - 새 전투 규칙 설계
  - 새 Main Menu 구현
  - 실제 런타임 Schema/Save migration
  - 최종 아트/보이스 제작
```

## 2. Project evidence — live Sheet / GitHub

### 2.1 강한 현재 영역 — 추리 코어

현재 project canon은 다음을 이미 강하게 소유한다.

- 사건의 메인 콘텐츠는 `텍스트 노벨 조사 → 키워드/괴이 매뉴얼 → 피해자 구출 → 회수 전투 → 결과/기록`이다.
- 필수 진실은 특정 능력/태그/확률 판정에 잠기지 않는다.
- 가설 후보·확인·반증·위험·미해결을 분리한다.
- 실패 전진, 부분 진실 공개, 재조사, 최초 정본/숙련 재현 분리까지 폭넓은 추리 보호 규칙이 존재한다.

주요 current source:

- `docs/decisions/D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY.md`
- `docs/decisions/D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING.md`
- Google Sheet `12_핵심루프`, `40_핵심시스템_메인콘텐츠`, `50_메인콘텐츠`

판정: `KEEP / PLAYER-TEST MORE`, 새 추리 시스템 대규모 추가는 우선순위 아님.

### 2.2 약한 현재 영역 — 텍스트노벨의 장기 인물극

live Sheet `52_글쓰기_서사` 기준:

- 저승역 대표 사건은 `CURRENT`.
- 일상·기관 운영은 `PARTIAL`.
- 후속 괴이 사건은 `PLANNED`.
- 관계·선택적 로맨스는 `PROVISIONAL_BASELINE`.
- 연도 결산은 승인됐지만 `WRITING_RULES_NOT_SPECIFIED`.

현재 메인 콘텐츠 Decision의 텍스트 조사 계약은 정보·조건·키워드에는 명확하지만, 모든 주요 장면이 **극적 질문 / 인물의 욕망·두려움 / 플레이어 자기표현 / 후속 관계 콜백**을 가져야 한다는 공통 장면 작성 계약은 없다.

판정: `ADAPT / P0-P1 GAP`.

### 2.3 약한 현재 영역 — 육성의 정체성 체감

live Sheet `41_성장_경제` 기준:

- 시간·위험·장비 등은 존재한다.
- `연구·관계·준비도`는 `PARTIAL`.
- 일정·육성의 장기 목적은 단기 사건 대비와 장기 성장으로 정의돼 있다.

current `D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT`는 매우 유용한 장기 언어를 이미 승인했다.

```text
조사 성향
+ 보호 원칙
+ 기관 내 위치
+ 남은 책임
```

하지만 같은 Decision이 명시적으로 아직 승인하지 않은 것으로 `분기별 활성 결과의 최종 목록과 장면`, `연말 문구 생성 규칙·칭호·UI`를 남긴다.

판정: 새 스탯 추가보다 existing identity language를 장면에 환류하는 `ADAPT / TEST`가 우선.

### 2.4 약한 현재 영역 — 핵심 관계망

live Sheet `13_주요인물` 기준:

- 권나래: `CURRENT`.
- 오현: `CURRENT`.
- 한세린: `PARTIAL_DISABLED`.
- 기타 요원/세력: `PROVISIONAL_BASELINE`.

관계가 장기 결과 축에 존재하지만, 핵심 동료별로 `사건 판단 → 관계 변화 → 후속 장면/지원 방식 → 연말 기록`을 반복 가능하게 제작하는 공통 계약은 아직 얇다.

판정: `ADAPT / TEST`, 처음부터 많은 캐릭터로 확장하지 않는다.

## 3. GitHub ↔ Sheet conflict found

### C-01 — stale/nonexistent responsibility path

Sheet `50_메인콘텐츠`에는 `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION`의 책임 원본 경로를 `docs/decisions/D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION.md`로 기록하고 있으나, 2026-08-11 current GitHub `main`의 `docs/decisions/`에서 해당 파일은 존재하지 않았다.

현재 GitHub main에서 실제 텍스트 노벨 조사 권위는 최소 다음 current Decision에 포함돼 있다.

- `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
- `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`

Disposition:

```text
SHEET_RESPONSIBILITY_PATH_DRIFT
/ DO_NOT_INVENT_MISSING_FILE
/ USE_LIVE_GITHUB_CURRENT_AUTHORITY
/ TRACK_FOR_SEPARATE_SHEET_RECONCILIATION
```

이 연구 문서에서 누락 파일 내용을 일반 지식으로 보충하지 않는다.

### C-02 — stale current Gate in product-direction Sheet

Sheet `10_제품방향`의 `현재 Gate`가 과거 `Validation Canon Pass / writing-plans / Codex Plan` 흐름을 현재 상태로 표시한다. 그러나 current project work-instruction은 v4.5-r2이며 정확한 `기획 완료` 선언 전 persistent BUILD를 금지한다.

Disposition:

```text
SHEET_CURRENT_GATE_STALE
/ V4_5_R2_GOVERNANCE_WINS
/ TRACK_SEPARATE_RECONCILIATION
```

## 4. External benchmark evidence

외부 사례는 기능 복사 근거가 아니라 **비교 원리와 실패 조건**만 추출한다.

### B-01 — The Case of the Golden Idol

Source:
- Game Developer, 2022-11-01, `Pursuing the "Aha!" moment with deductive reasoning game The Case of the Golden Idol`
- https://www.gamedeveloper.com/design/case-of-the-golden-idol

Observed professional evidence:
- 제작자가 답을 이미 알기 때문에 자기 미스터리를 스스로 품질 판정하기 어렵고 외부 테스트에 크게 의존했다.
- 각 사건은 개별 미스터리·퍼즐뿐 아니라 전체 서사를 전진시켜야 했다.
- 플레이어를 과도하게 안내하지 않으면서도 추론이 성립하는지 반복 테스트했다.

Project judgment:

```text
ADOPT principle: external blind thought-path testing
ADAPT: use our keyword/manual structure as the observable reasoning surface
AVOID: copy Golden Idol's answer-entry UI
```

### B-02 — PARANORMASIGHT: The Seven Mysteries of Honjo

Sources:
- Square Enix official product page
  - https://paranormasight.square-enix-games.com/en-us/
- Square Enix official launch/features article
  - https://www.square-enix-games.com/en_GB/home/paranormasight-seven-mysteries-honjo-now-available
- Game Informer interview with director Takanari Ishiyama, 2026
  - https://gameinformer.com/2026/04/27/paranormasight-interview
- Crunchyroll director interview, 2026
  - https://www.crunchyroll.com/zh-tw/news/interviews/2026/4/28/paranormasight-director-interview
- Steam product/review signal
  - https://store.steampowered.com/app/2106840/

Observed professional/product evidence:
- 공식 소개는 여러 인물의 욕망과 동기가 서로 얽히는 초자연 미스터리를 전면에 둔다.
- 감독은 첫 작품에서 예산이 매우 제한돼 팀이 이미 경험과 노하우를 가진 어드벤처 형식을 택했다고 설명한다.
- 2026 인터뷰에서 초자연 현상도 규칙과 조건이 명확하면 논리 미스터리와 puzzle-solving이 가능하다고 설명한다.
- 후속작에서는 특정 캐릭터/배경을 그대로 반복하는 것보다 시리즈 원리를 유지한 채 새 캐스트·새 설정을 택했다.
- 보이스가 텍스트의 끝까지 세밀한 수정 가능성을 희생할 정도의 가치가 확실하지 않다면 현재 텍스트 중심 제작 방식을 유지하겠다고 설명했다.

Player response signal:
- 2026-08-11 확인 시 Steam 영어 리뷰는 약 95% 긍정 수준이었다. 이는 품질 원인의 인과 증거가 아니라 **현재도 강한 긍정 반응이 유지되는 제품 신호**로만 사용한다.

Project judgment:

```text
ADOPT: supernatural rules must stay explicit/logically investigable
ADAPT: character desires/motives should carry mystery information and consequences
ADOPT: production focus over unbounded presentation scope
AVOID: treat voice acting as required VN completeness
```

### B-03 — I Was a Teenage Exocolonist

Sources:
- developer official site
  - https://www.exocolonist.com/
- Sarah Northway developer deep dive / Northway Games
  - https://northwaygames.com/the-narrative-octopus-of-i-was-a-teenage-exocolonist/
- Game Developer deep dive
  - https://www.gamedeveloper.com/programming/deep-dive-the-narrative-octopus-of-i-was-a-teenage-exocolonist
- Steam product/review signal
  - https://store.steampowered.com/app/1148760/

Observed developer/product evidence:
- 공식 제품 약속은 10년에 걸친 선택과 숙련 스킬이 삶과 공동체 결과를 바꾼다는 것이다.
- 개발자는 단일 거대한 branching tree보다 core narrative와 여러 겹치는 plotline/event가 서로 영향을 주는 `Narrative Octopus` 구조를 설명한다.
- stats raising과 관계·직업·사건이 별도 장르가 아니라 같은 장기 narrative state를 만든다.

Player response signal:
- 2026-08-11 확인 시 Steam 영어 리뷰는 약 96% 긍정 수준이었다. 원인 단정에는 사용하지 않는다.

Project judgment:

```text
ADAPT: growth should alter perspective, relationship and future situation
ADOPT: bounded interconnected callbacks rather than one giant story tree
AVOID: copy its 15 skills / 25 jobs / 1000 events scale
```

### B-04 — As Dusk Falls / GDC 2023

Source:
- GDC Vault, `A Narrative Multiverse: The Branching Structure of 'As Dusk Falls'`
- https://www.gdcvault.com/play/1028903/A-Narrative-Multiverse-The-Branching

Observed professional evidence:
- 복잡한 전체 branching structure를 설계하더라도 실제 글쓰기에서는 개별 경로를 **characters, emotions, themes**로 성립시키는 두 관점이 모두 필요하다고 설명한다.

Project judgment:

```text
ADOPT: every experienced scene path must work emotionally on its own
AVOID: branch count itself as quality target
```

### B-05 — Alan Wake 2 / GDC 2024

Source:
- GDC Vault, `Making Linear Story Playable: The Narrative Design of 'Alan Wake 2'`
- https://gdcvault.com/play/1034328/Making-Linear-Story-Playable-The

Observed professional evidence:
- 고정된 protagonist/linear story에서도 player expression을 제공할 수 있고, 복잡한 exposition 자체를 narrative gameplay mechanic으로 만들 수 있음을 다룬다.

Project judgment:

```text
ADAPT: 권나래를 고정 protagonist로 유지하면서 태도·조사 방식·책임 선택의 expression 강화
AVOID: protagonist를 blank avatar로 재설계
```

### B-06 — Low-budget branching / GDC 2024 coverage

Source:
- Game Developer, `How to build branching narrative without breaking the bank`
- https://www.gamedeveloper.com/design/how-to-build-branching-narrative-when-you-don-t-have-a-big-budget-

Observed professional evidence:
- branching은 쉽게 scope를 폭발시킨다.
- 동일한 플롯 결과로 합쳐지는 선택도 character definition/self-expression을 제공할 수 있다.

Project judgment:

```text
ADOPT: choice-role classification and authored callbacks
ADAPT: convergent choices are allowed when meaning persists
AVOID: branch-only-for-branching
```

### B-07 — Long Live The Queen

Source:
- Steam official product page
- https://store.steampowered.com/app/251990/

Product/player signal:
- visual novel + political/raising simulation의 명시적 결합.
- 플레이어는 성장 전략을 다시 바꾸며 반복하는 구조로 소개된다.
- 2026-08-11 영어 리뷰는 약 94% 긍정 수준이었다.

Project judgment:

```text
ADAPT: preparation/raising should change later options and risk
AVOID: mandatory-stat-check death maze as our core truth structure
```

### B-08 — Volcano Princess

Source:
- Steam official product page
- https://store.steampowered.com/app/1669980/Volcano_Princess/

Product/player signal:
- activity, training, relationships and future outcome를 연결하는 life/raising simulation.
- multiple endings, 많은 관계/활동/achievement를 가진 폭넓은 콘텐츠 구조다.
- 2026-08-11 영어 리뷰는 약 95% 긍정 수준이었다.

Project judgment:

```text
ADAPT: daily/raising choices should create recognizable future identity
AVOID: copy activity/endings/content volume into current production scope
```

## 5. Cross-benchmark synthesis

### Principle 1 — deduction needs observed player reasoning, not author confidence

```text
CASE AUTHOR INTENT
≠ ACTUAL PLAYER THOUGHT PATH
```

괴이기록국은 논리 구조가 이미 풍부하므로 다음 병목은 추가 rule count보다 실제 블라인드 플레이에서 **근거 발견 → 가설 생성 → 반증/수정 → 실행 → Aha**가 일어나는지 확인하는 것이다.

Decision: `ADOPT`.

### Principle 2 — narrative choice does not require permanent plot divergence

중요한 것은 선택지가 몇 갈래로 영구 분기되는지가 아니라:

- 선택 전에 판단 근거가 있는가
- 플레이어가 자신의 권나래를 표현할 수 있는가
- 즉시 반응이 있는가
- 이후 장면에서 선택의 의미가 다시 드러나는가

Decision: `ADAPT`.

### Principle 3 — raising must change lived experience, not only numbers

현재 project의 시간·위험·연구·관계·준비도 자원은 충분한 출발점이다. 부족한 것은 새 수치보다 그 결과가 **다른 조사 방식·관계 반응·기관 위치·책임**으로 체감되는 장면이다.

Decision: `ADAPT / TEST`.

### Principle 4 — character drama must not overwrite objective mystery truth

PARANORMASIGHT와 project current authority 모두 초자연 규칙을 명확히 유지할 수 있음을 지지한다. 캐릭터의 감정은 사실을 바꾸는 장치가 아니라 **어떤 사실을 왜 중요하게 여기고 어떻게 행동하는지**를 만든다.

Decision: `KEEP truth authority / ADD meaning layer`.

### Principle 5 — content density before meta-system expansion

현재 project는 replay/canon/mastery/rewind 규칙이 이미 풍부한 반면 후속 관계·연간 장면 콘텐츠는 상대적으로 얇다.

Decision:

```text
HOLD new replay/rank/meta rules
→ build/validate narrative callbacks first
```

## 6. Gap matrix

| gap_id | 영역 | 현재 상태 | benchmark/pro evidence | 판정 | 보완 후보 |
|---|---|---|---|---|---|
| G01 | 추리 검증 | logic contract 강함, Human thought-path evidence 부족 | Golden Idol | ADOPT | Thought-Path Playtest Contract |
| G02 | 텍스트노벨 장면 | 정보/조건 선택 강함, 장면 감정·자기표현 공통 규격 약함 | As Dusk Falls, Alan Wake 2, low-budget branching | ADAPT | Text Novel Scene Contract |
| G03 | 장기 성장 | 자원 존재, identity 체감 장면 부족 | Exocolonist, Long Live The Queen | ADAPT/TEST | Investigator Identity Feedback |
| G04 | 관계 | 관계 축 존재, 핵심 동료 반복 제작 계약 약함 | Exocolonist, PARANORMASIGHT | ADAPT/TEST | Core Relationship Network |
| G05 | 연간 서사 | 결과 packet 강함, 실제 scene/copy rules 미지정 | Exocolonist, GDC branching | ADAPT | Year-One Narrative Spine |
| G06 | 메타 규칙 | 이미 세밀함 | production-scope evidence | HOLD | 새 replay/rank rule 금지 |
| G07 | 활동/스탯 수 | 현재 support 자원 충분 | raising benchmarks show content cost | AVOID | 대규모 확장 금지 |

## 7. Planned PoC / player evidence questions

첫 PoC는 저승역 current canon을 사용하며 신규 제품 BUILD를 의미하지 않는다. written Spec 승인 뒤 별도 계획에서 다음을 검증한다.

### Thought-path

- 처음 보는 플레이어가 어떤 기록을 근거로 어떤 가설을 언제 만든다?
- 제작자가 예상한 오답과 실제 오답이 같은가?
- 막혔을 때 정보가 부족한가, 정보는 있는데 관계를 못 보는가, UI를 못 찾는가?
- 정답을 알았을 때 `왜 맞는지` 설명할 수 있는가?

### Scene meaning

- 장면 뒤 플레이어가 피해자/동료가 무엇을 원했는지 기억하는가?
- 선택이 단순 정보 버튼이 아니라 권나래의 태도로 인식되는가?
- 같은 플롯 지점에 합쳐져도 선택에 대한 반응/콜백을 기억하는가?

### Identity / relationship

- 플레이어가 자신의 권나래를 한두 문장으로 설명할 수 있는가?
- 시스템이 붙인 표현과 플레이어 자기인식이 충돌하지 않는가?
- 동료 반응이 선택의 도덕 채점이 아니라 관점 차이로 읽히는가?

## 8. Evidence limitations

- 외부 리뷰 평점은 설계 원인의 인과 증거가 아니다.
- 개발자 발표도 괴이기록국에 그대로 적용할 수 있는 보편 법칙이 아니다.
- 본 문서의 `ADOPT/ADAPT`는 PoC/플레이테스트 전 production-ready 판정이 아니다.
- 신규 장면·identity·relationship의 Human usability 및 Player Experience는 전부 `NOT_RUN`이다.
- 수치·표본·성공 임계값은 실행 전 연구 계약에서 사전 선언해야 하며 결과를 본 뒤 맞추지 않는다.
