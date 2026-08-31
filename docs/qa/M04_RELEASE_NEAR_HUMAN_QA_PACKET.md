# 괴이기록국 M04 Release-near Human QA Packet

> Route: M04_RELEASE_NEAR_VERTICAL_SLICE
> Evidence mode: BEHAVIOR_FIRST_SELF_REPORT_SECOND
> Current status: M04_HUMAN_QA_PACKET_READY / HUMAN_QA_NOT_RUN
> Automation boundary: NO_AUTOMATIC_PASS
> Scope: M04 빨간 우산의 조사·플레이어 작성 매뉴얼·피해자 보호·회수 시계·Composite Result
> Excludes: product-reference asset 승격, release visual/audio/VFX PASS, 접근성·출시 PASS

## 1. 목적

이 패킷은 약 30~45분의 M04 release-near 경험에서 자동 테스트가 확인할 수 없는 것을 실제 사람 플레이로 관찰한다. 확인할 핵심은 다음과 같다.

- 플레이어가 괴이 기록국의 역할을 화력 처치가 아니라 **조사한 규칙에 맞춰 피해자를 보호하고 잔향을 안정화·회수하는 일**로 이해하는가.
- 획득한 기록의 출처와 맥락을 바탕으로 빈칸 매뉴얼에 후보 키워드를 직접 배치하는가.
- 루메의 절차 보조를 답안·추천·정오 판정으로 오해하지 않는가. **루메는 정답, 변조, 후보 적합성, 미관측 정보를 말하지 않는다.**
- 구출에서 사람을 보호하는 판단과 회수에서 현상을 안정화하는 판단을 하나의 결과로 뭉개지 않고 읽는가.
- 회수 화면의 안정도 8칸과 위험도 6칸 시계가 실제 압박·해소의 선택 근거가 되는가. 시계는 단순 시간 제한이나 전투 체력바가 아니다.

## 2. 증거 경계

- 문서, 스크린샷, Godot 자동 테스트, GPU 캡처는 Human 항목을 PASS로 채우지 않는다. NO_AUTOMATIC_PASS를 유지한다.
- 패킷을 만들었을 뿐 실제 세션은 아직 실행하지 않았으므로 현재 결론은 HUMAN_QA_NOT_RUN이다.
- 관찰한 행동과 세션 뒤 참가자의 자기보고를 섞지 않는다. 관찰 기록이 먼저이고, 자기보고는 보조 근거다.
- 세션 기록에는 repository commit SHA, 실행 환경, 화면 해상도, 입력 방식, 시작 save 조건, prior knowledge, 진행한 M04 route를 함께 남긴다.
- 실제 사용자 저장 내용, 개인정보, 절대 경로, 계정 정보는 공유 증거에 기록하지 않는다.
- 한 참가자의 세션은 문제 발견 또는 가설 지지 자료일 뿐, 제품 전체 Human QA PASS가 아니다.

## 3. 실행 전

1. 테스트할 build와 repository commit SHA를 적는다. 서로 다른 commit의 관찰을 같은 결과표에 합치지 않는다.
2. 저장 상태를 NEW / RESET_TEST_SAVE / EXISTING_SAVE 중 하나로 기록한다. 이미 M04 정답이나 사건 구조를 아는 참가자는 prior_knowledge: KNOWN으로 분리한다.
3. 사용한 화면 해상도, 창/전체화면, 입력 수단(마우스·키보드 또는 게임패드), OS와 오디오 사용 여부를 적는다.
4. 진행자는 M04의 해답·올바른 키워드·변조 후보·가장 빠른 선택·시계 변동 조건을 설명하지 않는다.
5. 진행자는 참가자에게 “생각나는 근거나 헷갈리는 점은 말로 표현해도 좋다”고만 안내한다. 침묵을 실패로 취급해 유도 질문을 늘리지 않는다.
6. 실행 중 소프트락·저장 손실·입력 불능·읽을 수 없는 레이아웃이 보이면 곧바로 BLOCKED를 기록하고, release-near PASS를 선언하지 않는다.

## 4. 실제 플레이 경로

~~~text
main menu → M04 dispatch → investigation → player-authored manual → rescue → recovery clocks → composite result
~~~

### 4.1 M04 출동과 조사

- 참가자가 사건의 즉시 목표와 피해자 보호 목표를 어떻게 읽는지 기록한다.
- 어떤 현장 정보와 기록을 먼저 확인하는지, 다시 확인하는 기록이 있는지, 관측 사실과 추측을 분리하는지 적는다.
- 진행자는 “그게 정답인가요?”처럼 맞음/틀림을 암시하는 질문을 하지 않는다.

### 4.2 플레이어 작성 괴이 매뉴얼

- 참가자가 후보 키워드의 출처·맥락을 비교하는지, 아니면 무작위로 빈칸을 채우는지 기록한다.
- 후보 배치가 막힐 때 기록으로 돌아가는지, 매뉴얼이 무엇을 위한 작업대라고 이해하는지 적는다.
- 루메의 문구가 절차 보조인지 정답 추천인지 참가자가 어떻게 해석하는지 관찰한다.
- 진행자는 정확한 빈칸, 정답 키워드, 변조 사실, 후보 호환성, 추천 슬롯을 말하거나 표시하지 않는다.

### 4.3 피해자 보호·구출

- 조사/매뉴얼에서 확인한 정보를 피해자 보호 판단에 다시 쓰는지 관찰한다.
- 구출 결과를 잔향 회수 성공과 같은 하나의 점수로 읽는지, 또는 별도의 보호 결과로 읽는지 적는다.
- 실패·부분 성공·되돌아감이 생기면 참가자가 무엇이 남았다고 이해하는지 기록한다.

### 4.4 회수 시계

- 안정도 시계는 8칸, 위험도 시계는 6칸이다. 참가자가 두 시계의 상태를 보고 대응 순서나 위험 감수를 바꾸는지 관찰한다.
- 시간 경과·부적절한 대응·위험한 선택이 위험도에 주는 압박과, 매뉴얼의 근거에 맞는 대응이 안정도와 위험도에 주는 해소를 각각 기록한다.
- 우측 하단의 괴이 매뉴얼 열기 동작을 실제로 발견·사용하는지 확인한다. 이 버튼이 기본 화면을 가리는 상단 탭으로 오해되지 않는지도 관찰한다.
- 화면의 대응은 공격/처치가 아니라 관찰·규칙 대응·보호·안정화·봉쇄·후퇴의 선택으로 읽혀야 한다. 대표 교체나 별도 회수 실행 버튼이 필요하다고 참가자가 느끼는지 관찰한다.

### 4.5 Composite Result

- 참가자가 피해자, 잔향, 귀가 기억, 기록국의 결과 페이지를 어떤 인과로 연결하는지 기록한다.
- 결과가 하나의 승패가 아니라 보호와 회수의 독립 결과라는 점을 읽는지 확인한다.
- 가장 기억에 남은 장면·판단·다음 사건 기대가 무엇인지, 그리고 그것이 핵심 판매 포인트로 느껴졌는지 자기보고로만 별도 기록한다.

## 5. 관찰 기록 양식

세션 시작 전 아래 양식을 복사해 채운다. 관찰에는 실제 화면·입력·행동만 쓰고, 해석과 참가자 발화는 반드시 분리한다.

~~~text
session_id:
date:
repository commit SHA:
build/runtime:
route: M04_RELEASE_NEAR_VERTICAL_SLICE
save_start: NEW | RESET_TEST_SAVE | EXISTING_SAVE
prior_knowledge: NONE | PARTIAL | KNOWN
display: resolution / window mode / UI scale
input: mouse-keyboard | gamepad
audio: on | off | unavailable
facilitator:
participant_pseudonym:

observed_behavior:
  - time / surface / actual action / actual visible outcome
  - time / surface / actual action / actual visible outcome

facilitator_intervention:
  - none, or exact neutral wording used and why

participant_quote_after_play:
  - direct quote, recorded after the relevant play segment

finding_interpretation:
  - hypothesis only; cite the observed rows it relies on

item_status:
  bureau_role: PASS | FAIL | BLOCKED | NOT_RUN
  record_to_manual_reasoning: PASS | FAIL | BLOCKED | NOT_RUN
  lume_non_answer_boundary: PASS | FAIL | BLOCKED | NOT_RUN
  rescue_protection_reasoning: PASS | FAIL | BLOCKED | NOT_RUN
  recovery_dual_clock_readability: PASS | FAIL | BLOCKED | NOT_RUN
  manual_to_recovery_reuse: PASS | FAIL | BLOCKED | NOT_RUN
  composite_result_separation: PASS | FAIL | BLOCKED | NOT_RUN
  memorable_value_or_selling_point: PASS | FAIL | BLOCKED | NOT_RUN

blocker_or_regression:
follow_up_scope:
~~~

## 6. 항목 판정

각 항목은 PASS / FAIL / BLOCKED / NOT_RUN 중 하나만 사용한다.

- PASS: 관찰한 행동이 목표 경험을 보이고, 필요할 때만 사후 자기보고가 이를 보강한다.
- FAIL: 관찰 또는 자발적 자기보고에서 재현 가능한 이해·가독성·인과 문제를 확인했다.
- BLOCKED: 빌드·입력·저장·레이아웃·진행 불능 때문에 항목을 평가할 수 없었다.
- NOT_RUN: 해당 경험을 실제로 관찰하지 않았다. 예를 들어 매뉴얼을 열지 않았다면 manual_to_recovery_reuse를 PASS나 FAIL로 추정하지 않는다.

한 번의 좋은 설명이 앞선 관찰상 혼란을 지우지 않는다. 반대로 진행자가 답을 설명한 뒤 나온 설명도 독립 Human evidence가 아니다.

## 7. 세션 뒤 질문

질문은 실제 플레이가 끝난 뒤에만 한다. 필요하면 다음 순서로 묻되, 답을 고쳐 주거나 정답 여부를 알려주지 않는다.

1. 이 사건에서 기록국 요원의 역할은 무엇이라고 느꼈는가?
2. 확실히 관측한 사실과 아직 추측인 내용은 무엇이었는가?
3. 매뉴얼의 빈칸을 어떤 근거로 채웠거나 보류했는가?
4. 피해자 보호 판단에 어떤 앞선 기록이나 가설을 다시 사용했는가?
5. 안정도와 위험도 시계는 각각 무엇을 나타낸다고 이해했는가? 두 시계 때문에 행동 순서가 바뀐 적이 있는가?
6. 루메의 보조는 어떤 역할로 느껴졌는가?
7. 결과에서 따로 봐야 한다고 느낀 결과 축은 무엇이었는가?
8. 가장 기억에 남은 장면·판단·다음 사건에서 보고 싶은 것은 무엇인가?

## 8. 완료·후속 경계

M04 Human QA가 실제 실행됐다고 기록하려면, 적어도 고정된 build/SHA·환경·입력·시작 save 조건·관찰 로그·각 항목 상태·발견된 문제의 재현 조건이 있어야 한다.

FAIL이나 BLOCKED가 있으면 수정 대상과 재검증 범위를 먼저 정한다. 세션이 끝나도 product_reference_asset: PENDING, release visual/audio/VFX, 접근성, 출시 권리 검토는 이 패킷으로 완료되지 않는다. 필요한 실제 사람 검증이 아직 없다면 언제나 HUMAN_QA_NOT_RUN을 유지한다.
