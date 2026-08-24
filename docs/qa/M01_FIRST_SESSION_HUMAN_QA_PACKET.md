# 괴이기록국 M01 First Session Human QA Packet

> Route: `M01_FIRST_SESSION`
> Evidence mode: `BEHAVIOR_FIRST_SELF_REPORT_SECOND`
> Current status: `HUMAN_QA_NOT_RUN`
> Automation boundary: `NO_AUTOMATIC_PASS`
> Runtime prerequisite: merged current runtime from PR #224
> System preflight reuse: `START_HUMAN_QA.cmd`

## 목적

이 패킷은 자동 테스트가 증명할 수 없는 첫 세션 경험을 실제 사람 플레이로 확인한다. 핵심 질문은 플레이어가 **조사 → 추리 → 구출 → 회수**를 서로 떨어진 시험으로 보지 않고, 관측 가능한 기록에서 규칙을 찾고 같은 지식을 피해자 구출과 괴이 안정화에 다시 쓰는 하나의 인과 흐름으로 이해하는가이다.

`SERIAL_EXAM_FATIGUE_GUARD`는 구현 계약이 존재한다는 사실만으로 PASS하지 않는다. 실제 플레이 중 재학습·무작위 추측·정체가 반복되는지, 이미 배운 규칙을 자연스럽게 재사용하는지를 사람 관찰로 확인한다.

## 증거 경계

- 자동화가 Human 항목을 PASS로 채우지 않는다: `NO_AUTOMATIC_PASS`.
- 아직 실제 세션을 실행하지 않았으므로 현재 판정은 `HUMAN_QA_NOT_RUN`이다.
- 기존 `START_HUMAN_QA.cmd`와 18항목 one-click checklist는 저장 이관, 런타임 UX, 해상도, 입력, 접근성, persistence를 확인하는 **시스템 Human QA**로 그대로 재사용한다.
- 본 패킷은 그 위에 M01 첫 세션의 역할 이해, 추리 인과, 지식 재사용, 피로, 복합 결과 이해만 추가한다.
- 둘 중 하나의 PASS가 다른 하나를 자동 PASS시키지 않는다.
- 실제 세션 증거에는 `repository commit SHA`, 실행 환경, 해상도, 입력 방식, 시작 save 조건, 세션 역할을 함께 기록한다.
- 실제 사용자 저장 내용, 개인정보, 절대 경로는 공유 증거에 기록하지 않는다.

## 실행 전

1. 테스트할 빌드의 `repository commit SHA`를 고정한다.
2. Windows에서 저장/입력/레이아웃까지 함께 볼 경우 `START_HUMAN_QA.cmd`를 먼저 사용한다.
3. M01을 처음 보거나 정답을 모르는 플레이어를 우선한다. 이미 내용을 아는 사람은 `prior_knowledge: KNOWN`으로 분리한다.
4. 진행자가 정답이나 규칙을 설명하지 않는다.
5. 플레이어에게 체크리스트의 PASS 조건이나 정본 해답을 보여주지 않는다.
6. `tools/qa/m01_first_session_human_qa_checklist.json`의 모든 항목은 `NOT_RUN`에서 시작한다.

## 진행 방식

### 1. 행동 관찰

진행 중에는 질문보다 행동을 먼저 기록한다.

- 무엇을 먼저 조사하는가.
- 어떤 기록을 다시 여는가.
- 관측 사실과 추측을 섞는가.
- 가설을 유지·배제할 때 실제 기록을 근거로 쓰는가.
- 구출에서 조사/추리 결과를 다시 쓰는가.
- 회수 전조에서 앞서 배운 규칙을 떠올리는가.
- Phase가 바뀔 때 새 규칙을 다시 배우느라 멈추는가.
- 실패/부분 성공 뒤 무엇이 남았다고 이해하는가.
- Composite Result를 하나의 승패가 아니라 독립 결과 축으로 읽는가.

행동 로그에는 관찰 사실을 먼저 적고 해석은 별도 finding으로 분리한다.

### 2. 세션 후 자기보고

플레이 종료 뒤에만 자기보고를 받는다. `BEHAVIOR_FIRST_SELF_REPORT_SECOND`를 유지한다.

- 기록국 요원의 역할은 무엇이라고 느꼈는가.
- 확실히 관측한 사실과 아직 추측인 내용은 무엇이었는가.
- 어떤 가설을 왜 유지하거나 버렸는가.
- 구출에서 앞선 조사 정보가 어떻게 쓰였는가.
- 회수에서 다시 사용한 규칙이 있었는가.
- 단계들이 한 문제를 깊게 푸는 흐름이었는가, 서로 다른 시험의 연속이었는가.
- 실패/부분 성공에서 무엇이 남는다고 이해했는가.
- 사건 결과에서 서로 따로 봐야 한다고 느낀 축은 무엇인가.

### 3. 판정

각 항목은 `PASS / FAIL / BLOCKED / NOT_RUN` 중 하나만 사용한다.

- `PASS`: 행동 증거와 필요한 자기보고가 기준을 지지한다.
- `FAIL`: 실제 행동 또는 자기보고에서 재현 가능한 이해/인과/피로 문제가 확인된다.
- `BLOCKED`: 빌드·입력·저장·진행불가 때문에 해당 경험을 평가할 수 없다.
- `NOT_RUN`: 해당 항목을 실제로 관찰하지 않았다. 예: 세션에서 실패가 한 번도 발생하지 않아 failure-forward를 평가하지 못한 경우.

한 번의 좋은 자기보고만으로 앞선 행동 실패를 지우지 않는다. 반대로 진행자의 설명 뒤 나온 정답 설명은 독립 Human evidence로 사용하지 않는다.

## M01 전용 8항목

정본은 `tools/qa/m01_first_session_human_qa_checklist.json`이 소유한다.

1. 기록국 역할 정체성.
2. 관측과 가설/반박/미해결 구분.
3. 가설 유지·배제 근거 설명.
4. 조사/추리 → 피해자 구출 인과 재사용.
5. 조사/추리 → 회수 전조/대응 인과 재사용.
6. `SERIAL_EXAM_FATIGUE_GUARD` 실제 체감.
7. 실패 전진(fail-forward) 이해.
8. Composite Result 독립 축 이해.

## 완료 조건

M01 Human QA를 완료로 승격하려면 최소한 다음이 필요하다.

- 고정된 build/repository SHA.
- 세션 환경·해상도·입력·시작 조건.
- 8항목 각각의 상태와 재현 가능한 관찰 근거.
- FAIL/BLOCKED가 있으면 수정 대상과 재검증 범위.
- 시스템 Human QA를 함께 수행했다면 18항목 결과와 별도 기록.

실제 세션이 없으면 문서와 자동 테스트가 아무리 완전해도 `HUMAN_QA_NOT_RUN`을 유지한다.
