# D-2026-08-11-HYBRID-NARRATIVE-DEDUCTION-GROWTH-INTEGRATION

> 상태: `USER_APPROVED_DIRECTION / WRITTEN_SPEC_APPROVED / PLANNING_COMPLETE_DECLARATION_RECEIVED / PHASE_B_FINAL_REVIEW_COMPLETE / PACKAGE_1_DOR_LOCKED`
> 승인 시각: 2026-08-11 KST
> 사용자 승인: `권장안 승인 / 연속작업 진행해 / 승인,진행해 / 기획 완료`
> 적용 범위: 텍스트노벨·추리·육성 장르 통합 보완 방향
> 제품 구현: `PACKAGE_1_AUTHORIZED_AFTER_PHASE_B / NOT_STARTED / HIGODOT_REQUIRED`
> `기획 완료`: `RECEIVED_2026-08-11_KST`
> Human/Player Experience 검증: `NOT_RUN`

## 1. 승인된 방향

괴이기록국은 세 장르를 병렬 기능 목록으로 늘리지 않고 다음 인과 사슬로 통합한다.

```text
추리 = 무엇이 사실인가
→ 텍스트노벨 = 그 사실이 누구에게 어떤 의미인가
→ 육성 = 그 선택들이 결국 권나래를 어떤 요원으로 만드는가
```

축약 원칙:

```text
FACT → MEANING → IDENTITY
```

현재 강한 `괴이 사건 진입 → 텍스트 노벨 조사 → 키워드/괴이 매뉴얼 → 피해자 구출 → 회수 전투 → 결과/기록` 코어는 유지한다. 보완의 주 대상은 새 추리 퍼즐이나 새 스탯이 아니라 **사건 판단이 인물·관계·장기 성장·후속 장면으로 돌아오는 연결층**이다.

## 2. 기존 권위 보존

이 Decision은 다음 current authority를 대체하지 않고 확장한다.

- `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
  - 사건 플레이가 메인 콘텐츠다.
  - 일정·육성·동료·관계·장비·연구는 지원·준비·환류 계층이다.
- `D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING`
  - 필수 진실과 일반 클리어는 특정 능력·태그·확률 판정에 잠기지 않는다.
  - 육성은 비용·위험·정보량·안전·숙련 목표를 바꾸되 객관적 진실을 바꾸지 않는다.
- `D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT`
  - 사건 결과는 `지식 / 관계·기관 / 현장` 세 축으로 보존한다.
  - 연말 요원 기록은 `조사 성향 + 보호 원칙 + 기관 내 위치 + 남은 책임`으로 설명한다.
  - 단일 선악 점수나 모든 플래그의 무제한 장면 반영을 금지한다.

## 3. 승인된 보완 패키지

### A. Investigation Thought-Path Playtest Contract — `ADOPT`

사건 장별로 정답만 검수하지 않고, 처음 보는 플레이어가 실제로 어떤 생각 순서로 추론하는지 검증한다.

최소 설계 항목:

- 목표 추론
- 필수 근거
- 대체 가능한 유효 근거 경로
- 그럴듯한 오답 가설
- 예상 막힘 신호
- `Aha`가 발생해야 하는 지점
- 스포일러/힌트 상한
- 실제 관찰과 예상 Thought Path의 차이

자동 테스트나 제작자 자가 플레이는 Human/Player Experience 증거를 대체하지 않는다.

### B. Text Novel Scene Contract — `ADAPT`

기존 `상황 설명 → 조건 선택지 → 결과 문장 → 키워드` 구조에 장면의 인간적 의미를 추가한다.

각 주요 장면은 최소 다음 질문에 답해야 한다.

- 이번 장면의 극적 질문은 무엇인가?
- 참여 인물은 무엇을 원하고 무엇을 두려워하는가?
- 플레이어가 무엇을 새로 알거나 재해석하는가?
- 선택은 `정보 / 태도·자기표현 / 위험 / 관계 / 행동` 중 어떤 역할을 하는가?
- 분기가 다시 합쳐져도 무엇이 기억되고 후속에 되돌아오는가?
- 선택 직후 무엇이 변했는지 플레이어가 어떻게 아는가?

모든 선택을 거대한 영구 분기로 만들지 않는다. 줄거리가 합쳐지는 선택도 권나래의 태도·관계·책임을 정의하고 후속 콜백이 있으면 유효하다.

### C. Investigator Identity Feedback — `ADAPT / TEST`

새 도덕성 점수나 직업 트리를 추가하지 않는다. 이미 승인된 연말 네 관점인 다음 축을 사건·장면의 장기 피드백 언어로 사용한다.

```text
조사 성향
보호 원칙
기관 내 위치
남은 책임
```

이 정체성은 다음을 바꿀 수 있다.

- 장면의 반응과 서술 프레이밍
- 비필수 대화·관점·추가 맥락
- 동료/기관의 지원 방식과 비용
- 이후 책임 선택과 후일담

이 정체성은 다음을 바꾸지 않는다.

- 괴이의 객관적 진실
- 필수 핵심 키워드 접근
- 일반 클리어 가능 여부
- 핵심 엔딩·필수 동료·접근성 자격

정확한 상태 표현과 데이터 Schema는 PoC 결과가 살아남은 뒤 별도 L2 Spec에서만 승인한다.

### D. Core Relationship Network — `ADAPT / TEST`

관계는 선물 반복·호감도 노동으로 키우지 않는다. 미래 범위는 핵심 동료 2~3명에 집중하며, **사건에서 실제로 내린 판단과 함께 일한 방식**이 관계 장면과 지원 방식에 되돌아오게 한다.

관계 변화는 최소 다음 근거 중 하나를 가져야 한다.

- 같이 겪은 사건 판단
- 피해자 보호/기관 명령의 충돌
- 동료의 전문성을 신뢰하거나 무시한 선택
- 실패·손실·미완료 책임의 후속 처리

선택적 로맨스는 관계 시스템의 필수 성공 조건이 아니며 별도 콘텐츠 승인 전까지 `OPTIONAL / PROVISIONAL`을 유지한다.

**Package 1 현재 동료는 오현 1명으로 고정한다.** Fresh Sheet에서 한세린은 `PARTIAL_DISABLED`이므로 현재 PoC에서 제외한다. 이는 향후 전체 관계망에서 한세린을 영구 제거한다는 뜻이 아니다.

### E. Year-One Narrative Spine — `ADAPT`

기존 네 핵심 사건과 분기 결과 환류 사이에 사람이 기억할 **후속 장면과 관계·기관 콜백**을 배치한다.

기존 결과 패킷 상한을 재사용한다.

```text
사건 종결
→ 지식 / 관계·기관 / 현장 결과
→ 제한된 대표 결과 활성화
→ 인물·기관·피해자 후속 장면
→ 다음 핵심 사건의 실제 조건
→ 연말 요원 기록
```

모든 플래그를 모든 장면에서 확인하지 않는다. 기존 Decision이 정한 축별 대표 결과와 장면별 저작 콜백만 사용해 조합 폭발을 막는다.

## 4. HOLD / AVOID

이번 방향 승인과 함께 다음은 우선순위를 낮춘다.

- `HOLD`: 새 캠페인 되감기·새 랭크·새 숙련 메타 규칙 추가
- `HOLD`: 대규모 관계 캐릭터 확대
- `AVOID`: 새로운 범용 화폐·다수 스탯·활동 슬롯을 육성 존재감만을 위해 추가
- `AVOID`: 특정 성장 빌드가 조사 정답이나 필수 진실을 독점
- `AVOID`: 선택 결과가 아무 피드백·콜백 없이 즉시 다시 합쳐지는 가짜 분기
- `AVOID`: 관계를 선물/반복 클릭 노동으로 대체
- `AVOID`: 자동 테스트를 플레이어 재미·감정 검증으로 승격

## 5. Production 분해와 현재 Package 1 잠금

이 Decision은 하나의 거대 구현 Feature를 승인하지 않는다. 다음 순서를 따른다.

```text
상위 통합 Design
→ written Spec 승인
→ 저승역 대표 PoC / Human Playtest 계획
→ 정확한 `기획 완료`
→ Phase B final planning review
→ Package 1 DoR lock
→ HiGodot-authorized TDD BUILD
→ 실제 Human Playtest
→ 살아남은 항목만 L2 후보 승격
```

사용자의 정확한 `기획 완료` 선언은 2026-08-11 KST에 수신되었고 Phase B 최종 검수를 완료했다.

Package 1은 다음으로만 잠근다.

1. 저승역 1장 Thought Path 관찰 계약
2. `point_staff_room_door` 대표 조사 선택의 Scene Contract 검증
3. 사건 후 핵심 동료 **오현**의 기존 `agent_event_oh_breakthrough_warning_01` 콜백으로 `사실 → 의미 → 정체성/관계` 연결 검증

현재 main에서 이미 재사용 가능한 것:

- Canon v2 `record_afterlife_*` 증거·매뉴얼 구조
- 기존 `GameState` 조사 method 결과 저장
- 기존 `triggered_agent_event_ids` 1회 이벤트 저장
- 기존 결과/사건 보고서의 agent event/support 표시
- 기존 Canon v2 protection follow-up/evaluation packet

따라서 Package 1은 새 관계 DB·정체성 Schema·save version·Scene·Resource를 만들지 않는다.

Phase B에서 확인된 최소 runtime gap:

- 기존 오현 이벤트 문구는 `길을 열었으면 바로 빠져나갈 경로도 확보`라는 사건 인과를 이미 표현한다.
- 그러나 현재 오현 temperament는 `balanced`이고 대표 staff-room method의 trust rules는 `breakthrough / empathetic / analytical`만 가지므로, 이 대표 사건 선택만으로 기존 trust ≥2 이벤트가 자연스럽게 도달하지 않는다.
- `resolve_investigation_method`는 새 `method_result`를 저장하기 전에 agent event를 평가하므로, 아직 저장되지 않은 `method_results`를 읽는 방식도 사용하지 않는다.
- 해결은 같은 stable event ID/문구를 보존하고 `point_staff_room_door + destruction + successful` 사건 context를 명시적으로 전달하는 최소 trigger 확장이다.
- 다른 기존 agent event는 기존 trust-threshold 동작을 유지한다.
- 이 사건-memory trigger 자체는 오현 trust 수치를 올리지 않는다.

구현 계획 정본:

`docs/superpowers/plans/2026-08-11-afterlife-station-fact-meaning-identity-poc-implementation-plan.md`

Phase B 최종 검수:

`docs/planning/HYBRID_NARRATIVE_DEDUCTION_GROWTH_PHASE_B_FINAL_REVIEW_2026-08-11.md`

## 6. Evidence ceiling

현재 확보된 것은 다음이다.

- 프로젝트 current canon/Sheet의 구조적 갭
- 상용작·개발자 발표·현업 인터뷰 기반 benchmark/professional evidence
- Steam 사용자 평가의 방향성 signal
- current main의 Canon v2/runtime/event/report 실제 구현 구조
- Package 1의 TDD·Human Playtest 사전등록 계획

현재 확보되지 않은 것은 다음이다.

- 괴이기록국 신규 설계의 Human usability 결과
- 괴이기록국 신규 설계의 Player Experience 결과
- 신규 장면의 재미·감정·관계 몰입 증거
- Package 1 실제 실행 결과

따라서 현 상태는:

```text
WRITTEN_SPEC_APPROVED
PLANNING_COMPLETE_DECLARATION_RECEIVED
PHASE_B_FINAL_REVIEW_COMPLETE
PACKAGE_1_DOR_LOCKED
PHASE_C_READY
PRODUCT_RUNTIME_BUILD_NOT_STARTED
HUMAN_USABILITY_EVIDENCE=NOT_RUN
PLAYER_EXPERIENCE_EVIDENCE=NOT_RUN
```

## 7. Current conflict / validation notes

- 한세린: current Sheet `PARTIAL_DISABLED` → Package 1 제외, 오현만 사용.
- Sheet `10_제품방향` current Gate: v4.5-r2 이전 상태를 가리키므로 post-merge 동기화 대상.
- Sheet `50_메인콘텐츠` missing responsibility path: inference로 복원하지 않고 owner-aware reconciliation debt 유지.
- `docs/CURRENT_AFTERLIFE_STATION_CANON.md`의 오래된 `IMPLEMENTATION_NOT_AUTHORIZED` 문구는 이후 Canon v2 actual main 구현/Decision보다 역사적으로 오래된 상태이므로 현재 구현 사실로 사용하지 않는다.
- 저승역 1장 `목적지는 방송되지 않는다` page title 및 answer-adjacent intro 표현은 Thought Path priming 위험이다. initial Package 1에서 자동 변경하지 않고 Human protocol로 측정한다.

## 8. 다음 Gate

Phase B는 닫혔다.

```text
PHASE_B_FINAL_REVIEW_COMPLETE
→ PACKAGE_1_DOR_LOCKED
→ PHASE_C_READY
→ authorized HiGodot persistent-authoring surface에서 RED → minimal implementation → GREEN
→ focused Canon v2 suite + maintained full regression + exact-head CI
→ 실제 fresh/unexposed Human sessions
→ Thought Path / Scene Contract / Oh callback 각각 KEEP / CHANGE / RETEST / REMOVE
→ KEEP만 별도 L2 후보 승격
```

현재 이 planning PR 자체는 제품 runtime을 변경하지 않는다. 현재 ChatGPT connector surface에는 persistent Godot product-authoring을 수행할 HiGodot 실행 도구가 없으므로 PowerShell/Codex/HiGodot 실행을 가장하거나 제품 BUILD 완료로 보고하지 않는다.
