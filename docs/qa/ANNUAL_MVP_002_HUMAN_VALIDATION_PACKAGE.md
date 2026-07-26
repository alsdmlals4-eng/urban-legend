# ANNUAL-MVP-002 사람 플레이 검증 패키지

- 상태: `READY_TO_RUN`
- 작업 Issue: #92
- 설계 정본: `docs/superpowers/specs/2026-07-27-annual-mvp-002-human-validation-design.md`
- 대상 빌드: 기준 커밋과 빌드 ID를 세션 시작 전에 기록
- 결과 상태 기본값: `UNVERIFIED`

## 1. 세션 헤더

아래 블록을 세션마다 복사한다.

```yaml
session_id:
session_type: REPEATED_USABILITY | NEW_PLAYER
participant_code:
prior_exposure: NONE | TRAILER_ONLY | PRIOR_BUILD | PROJECT_MEMBER
facilitator:
date:
start_time:
end_time:
commit_sha:
build_id:
godot_version: 4.7.1
resolution:
input: KEYBOARD_MOUSE
recording: NOT_RUN | SCREEN_ONLY | SCREEN_AND_AUDIO
save_slot_or_path:
valid_session: YES | NO
invalid_reason:
```

실명·연락처 등 검증에 불필요한 개인정보는 기록하지 않는다.

## 2. 진행자 사전 점검

- [ ] 커밋 SHA와 빌드 ID가 Issue #92 기준과 일치한다.
- [ ] 1280×720 또는 1920×1080에서 실행된다.
- [ ] 키보드·마우스 입력이 동작한다.
- [ ] 메인 메뉴 F1 경로에서 ANNUAL-MVP-002 진입이 가능하다.
- [ ] 새 세션용 저장 상태가 준비되어 있다.
- [ ] 이전 참가자의 저장이 남아 있지 않다.
- [ ] 화면 녹화 여부를 참가자에게 알리고 동의를 받았다.
- [ ] 진행자는 정답·메뉴 위치·효율 조합을 설명하지 않는다.

## 3. 진행자 소개문

다음 문장을 그대로 읽는다.

> 이 테스트는 당신을 평가하는 것이 아니라 게임 화면과 규칙을 평가합니다. 막히거나 헷갈리면 그대로 말해 주세요. 가능한 한 소리 내어 생각하면서 플레이해 주세요. 저는 바로 정답을 알려주지 않고, 오래 진행하지 못할 때만 현재 하려는 일을 질문하겠습니다.

신규 플레이어에게는 4주 구조, 자동 휴식, 동료 효과, 지원 확률, 연구 규칙을 미리 설명하지 않는다.

## 4. 사전 질문

1. 일정·육성·경영 게임을 얼마나 자주 플레이하는가?
2. 추리·공포 게임을 얼마나 자주 플레이하는가?
3. 이 프로젝트나 이전 빌드를 본 적이 있는가?

답변은 세션 맥락으로만 사용하며 성공·실패 판정에 직접 합산하지 않는다.

## 5. 진행자 개입 단계

| 단계 | 조건 | 허용 발화 |
|---|---|---|
| I0 | 정상 진행 | 개입하지 않음 |
| I1 | 45초 동안 같은 영역을 탐색 | “현재 무엇을 하려는지 말해 주세요.” |
| I2 | 90초 동안 진행 없음 | “화면에서 다음 행동에 도움이 될 정보를 찾아보세요.” |
| I3 | 진행 불가가 확실함 | 필요한 조작 위치만 지시, 규칙 이유는 설명하지 않음 |
| I4 | 저장 손실·크래시·소프트락 위험 | 세션 중단 후 기술 Finding 기록 |

모든 I1 이상 개입은 시간, 화면, 참가자 발화, 개입 단계와 결과를 기록한다.

## 6. 과제 스크립트

### 과제 1 — 첫 주 계획

진행자 발화:

> 첫 주에 할 일을 정하고 다음 주로 넘어가 보세요.

관찰:

- 7일 예산을 발견하는가?
- 활동별 소요일을 읽는가?
- 남은 일수보다 긴 활동의 비활성 이유를 이해하는가?
- 자동 휴식 경고를 어떻게 해석하는가?
- 경고 후 재선택과 재확정 중 무엇을 하는가?

완료 조건:

- 유효 계획을 확정하고 주간 결과로 이동한다.

### 과제 2 — 반복 편성 도구

진행자 발화:

> 비슷한 계획을 다시 만들되, 이번에는 더 빠르게 해보세요. 이후 계획을 한 번 되돌리고, 다른 방식으로 다시 구성해 보세요.

관찰:

- 지난주 복사 발견 여부
- 템플릿 발견 여부
- 실행 취소 발견 여부
- 전체 초기화 발견 여부
- 세 번째 반복에서 자발적으로 선택한 도구
- 도구 사용 전후 혼란과 소요 시간

### 과제 3 — 동료·지원·장비

진행자 발화:

> 다음 출동을 대비해 동료와 장비를 정하세요. 선택한 이유도 말해 주세요.

관찰:

- 동료 최대 2명 제한을 이해하는가?
- 각 동료의 차이를 말할 수 있는가?
- 오현의 `충격 완화`와 `위험 억제`를 구분하는가?
- 비활성 지원의 사유를 읽는가?
- 장비와 모듈 호환을 이해하는가?
- 특정 조합을 이유 없이 정답처럼 고르는가?

사후 확인:

- “이 조합이 사건의 정답이나 단서를 알려주나요?”
- “이 조합이 실패했을 때 무엇이 달라지나요?”

### 과제 4 — 저장·복귀

진행자 발화:

> 지금 상태를 저장하고 나갔다가 다시 돌아와 이전 계획을 이어가세요.

관찰:

- 저장 기능 발견 여부
- 불러오기 성공 여부
- 동료·지원·장비·모듈·연구·준비도 상태 일치
- 복귀 후 다음 행동을 찾는 시간
- 참가자가 기억한 상태와 실제 상태의 불일치

저장 불일치, 데이터 손실, 진행 불가는 즉시 `HOLD` 후보로 기록한다.

### 과제 5 — 연구

진행자 발화:

> 얻은 자원으로 연구를 시작하고, 진행 상태를 확인하세요. 하나는 취소하거나 완료한 뒤 다음 계획에 어떤 영향을 줄지 말해 주세요.

관찰:

- 연구 자원과 비용 이해
- 동시 연구 제한 이해
- 취소 시 반환 의미 이해
- 연구 결과를 다음 주 계획과 연결하는가?
- 연구가 단순 수집 목록으로만 인식되는가?

### 과제 6 — 2·3·4주 출동

진행자 발화:

> 한 달을 끝까지 진행하세요. 출동 여부와 준비 선택의 이유를 매주 말해 주세요.

관찰:

- 2주차 조기 출동 위험을 인식하는가?
- 3주차 자율 출동의 장단점을 설명하는가?
- 4주차 강제 출동을 예상하는가?
- 위험 0/15/30의 변화가 계획을 바꾸는가?
- 주간 인과 요약에서 무엇이 변했고 왜 변했는지 읽는가?

### 과제 7 — 정답 비대체 설명

진행자 발화:

> “동료와 장비는 사건에서 ________을 해준다”를 완성해 주세요.

판정:

- 정답·단서·가설 자동 제공 의미: `MISCONCEPTION`
- 피해·위험·회복·실수 여유 보조 의미: `UNDERSTOOD`
- 불명확하거나 설명 불가: `PARTIAL`

## 7. 행동 관찰 기록지

| 시간 | 화면·상태 | 플레이어 행동 | 플레이어 발화 | 기대 규칙 | 관찰 결과 | 개입 | Finding 후보 |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

### 핵심 결과 요약

```yaml
first_valid_plan_seconds:
invalid_plan_attempts:
auto_rest_interpretation: UNDERSTOOD | PARTIAL | MISUNDERSTOOD
repeat_tool_first_discovered:
repeat_tool_used_voluntarily:
companion_role_explanation: ACCURATE | PARTIAL | INCORRECT
support_eligibility: ACCURATE | PARTIAL | INCORRECT
support_probability: ACCURATE | PARTIAL | INCORRECT
support_readiness: ACCURATE | PARTIAL | INCORRECT
guaranteed_trigger: ACCURATE | PARTIAL | INCORRECT
equipment_module_compatibility: ACCURATE | PARTIAL | INCORRECT
research_causal_chain: ACCURATE | PARTIAL | INCORRECT
save_restore: MATCH | PARTIAL_CONFUSION | MISMATCH
answer_substitution: UNDERSTOOD | PARTIAL | MISCONCEPTION
week_2_result:
week_3_result:
week_4_result:
month_completed: YES | NO
stop_point:
facilitator_interventions:
crash_or_softlock: NONE | CRASH | SOFTLOCK | DATA_LOSS
```

## 8. 사후 설문

각 문항은 1점 `전혀 아니다`부터 5점 `매우 그렇다`까지 답하고 이유를 적는다.

1. 첫 주에 무엇을 해야 하는지 알았다.
2. 7일 예산과 활동 소요일을 이해했다.
3. 직접 휴식과 자동 휴식의 차이를 이해했다.
4. 동료마다 선택 이유가 달랐다.
5. 장비와 모듈의 결과를 예상할 수 있었다.
6. 지원이 언제 가능한지 알 수 있었다.
7. 지원 확률이 실패해도 다음 시도를 준비할 방법이 보였다.
8. 연구가 다음 주 계획에 의미가 있었다.
9. 2주차부터 4주차까지 압박이 커지는 것을 느꼈다.
10. 주간 결과가 왜 발생했는지 이해했다.
11. 다른 조합으로 다시 플레이하고 싶다.

자유 답변:

- 가장 기억나는 선택은 무엇인가?
- 가장 이해하기 어려운 화면이나 규칙은 무엇인가?
- 실패하거나 손해를 봤을 때 이유를 알 수 있었는가?
- 동료·장비·연구 중 하나만 남긴다면 무엇을 남기겠는가? 이유는 무엇인가?
- 동료와 장비가 사건의 정답을 알려준다고 느꼈는가?
- 다음 플레이에서 무엇을 다르게 하고 싶은가?

## 9. 세션 Finding 형식

```yaml
finding_id:
session_ids:
review_lens:
finding_route: TECHNICAL_REVIEW_PROPOSAL | USER_DECISION_REQUIRED | BLOCKED_UNVERIFIED | NO_CHANGE
severity: CRITICAL | HIGH | MEDIUM | LOW
decision: MUST_FIX | SHOULD_FIX | DEFER | REJECT | UNVERIFIED
problem:
failure_scenario:
observed_behavior:
player_self_report:
evidence:
player_impact:
production_impact:
save_schema_impact:
recommended_minimum_change:
validation_method:
regression_risk:
result:
```

행동과 자기보고가 충돌하면 둘을 합치지 않는다. 행동 증거를 우선 기록하고 자기보고는 별도 해석한다.

## 10. 게이트 판정표

### 증거 충분성

- [ ] 반복 사용성 유효 세션 2회 이상
- [ ] 신규 플레이어 유효 세션 3회 이상
- [ ] 모든 세션에 커밋·빌드·환경 기록
- [ ] 4주 흐름 관찰
- [ ] 저장·복귀 관찰
- [ ] 연구 시작·취소 또는 완료 관찰
- [ ] 행동 관찰과 자기보고 분리

하나라도 충족하지 못하면 `REPEAT_VALIDATION` 또는 `BLOCKED_UNVERIFIED`다.

### P0 차단

- [ ] 저장 손실 없음
- [ ] 진행 불가·소프트락 없음
- [ ] CORE 정답 자동 제공 없음
- [ ] 보호 계약 위반 없음

하나라도 실패하면 `HOLD`다.

### 핵심 경험

- [ ] 신규 플레이어 다수가 첫 주를 진행자 규칙 설명 없이 확정
- [ ] 신규 플레이어 다수가 7일·자동 휴식 규칙을 설명
- [ ] 신규 플레이어 다수가 동료 역할 차이를 설명
- [ ] 신규 플레이어 다수가 지원 적격·확률·준비도·보장 발동의 핵심을 설명
- [ ] 신규 플레이어 다수가 보조 시스템의 정답 비대체를 이해
- [ ] 신규 플레이어 다수가 4주 흐름을 완주
- [ ] 연구가 실제 다음 선택을 한 번 이상 변경

다수 실패 시 `REWORK`, 일부 불명확 시 `APPROVED_WITH_CONDITIONS`가 아니라 우선 `RETEST`한다.

## 11. 최종 결과 요약

```yaml
validation_build:
valid_usability_sessions:
valid_new_player_sessions:
critical_findings:
high_findings:
medium_findings:
low_findings:
core_hypothesis_results:
  HV-01:
  HV-02:
  HV-03:
  HV-04:
  HV-05:
  HV-06:
  HV-07:
  HV-08:
gate_decision: APPROVED | APPROVED_WITH_CONDITIONS | REWORK | REPEAT_VALIDATION | HOLD | STOP | UNVERIFIED
poc_passed: NOT_DECLARED
annual_loop_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
next_action:
```

`poc_passed`, `annual_loop_passed`, `production_expansion`은 사용자 게이트 승인 전 변경하지 않는다.
