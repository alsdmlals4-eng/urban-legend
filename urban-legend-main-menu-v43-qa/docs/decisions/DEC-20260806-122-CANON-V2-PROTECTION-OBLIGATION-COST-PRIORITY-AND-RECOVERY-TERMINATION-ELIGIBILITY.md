# DEC-20260806-122-CANON-V2-PROTECTION-OBLIGATION-COST-PRIORITY-AND-RECOVERY-TERMINATION-ELIGIBILITY

> 상태: `APPROVED_DESIGN_CONTRACT`
> 사용자 승인: 2026-08-06 07:53 KST — `권장안대로 진행`
> GrillMe: Batch 3 `7_OF_10`
> 적용 범위: 보호 의무의 행동 비용, 표시 우선순위, 회수 종결 자격, 사전 결과 표시, 저장·호환 원칙
> 선행 Decision: `DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET`, `DEC-20260806-121-CANON-V2-RESCUE-RESULT-HANDOFF-TO-RECOVERY-INITIAL-CONDITIONS-AND-ACTION-CONSTRAINTS`
> 철회 이력: `DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE`는 `RETRACTED / NON_COUNTING`
> Draft PR: #151
> 기반 PR: PR #149
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 배치 병합: `BATCH_MERGE_NOT_STARTED`
> 병합: `MERGE_NOT_AUTHORIZED`

## 1. 결정

보호 의무는 구출 결과를 회수 플레이에 연결하지만, 하나의 페널티 점수나 자동 승패 판정으로 축소하지 않는다. 다음 세 영향 채널은 **서로 분리**한다.

1. 행동 비용: 특정 보호 책임과 직접 충돌하거나 이를 이행하는 행동의 선택 비용
2. 표시 우선순위: 플레이어가 먼저 확인해야 할 책임과 위험의 정렬·경고 순서
3. 종결 자격: 특정 회수 종결 후보, 특히 `approved_withdrawal`이 책임 조건을 충족하는지의 판정

세 채널을 `단일 의무 점수`로 합치거나 그 점수로 회수의 `자동 승패`를 결정하지 않는다.

권장 흐름은 다음과 같다.

```text
active_protection_obligations
→ 관련 행동의 비용 조정 계산
→ 의무 표시 우선순위 계산
→ 행동/종결 확정 전 결과 미리보기
→ 플레이어 선택
→ 비용·이행·위반을 한 번만 적용
→ 현상 통제 결과와 보호 결과를 독립 기록
```

## 2. 행동 비용 계약

보호 의무가 행동 비용에 영향을 줄 때는 다음 최소 필드를 가진다.

```text
cost_adjustment_id
obligation_id
affected_action
cost_channel
base cost
additional cost
source_reason
preview_text
applied_once
```

- `cost_adjustment_id`: 저장·재개와 중복 적용 방지를 위한 안정 ID
- `obligation_id`: 비용을 발생시킨 보호 의무
- `affected_action`: 비용이 실제로 영향을 주는 행동 또는 행동 범주
- `cost_channel`: 시간, 행동 기회, 장비·지원 자원, 노출 위험 등 이미 승인된 자원 채널
- `base cost`: 의무와 무관한 원래 비용
- `additional cost`: 보호 책임 때문에 추가되는 표시 가능한 비용 또는 위험
- `source_reason`: 구출 스냅샷이나 회수 중 새 사건을 가리키는 인과 근거
- `preview_text`: 확정 전에 보여 줄 설명
- `applied_once`: 동일 조정의 중복 적용 방지 상태

### 비용 상한 원칙

- 비용은 보호 의무와 인과가 있는 **관련 행동에만** 적용한다.
- 한 의무를 이유로 모든 행동에 비용을 붙이는 `전역 비용 인상 금지`를 적용한다.
- 여러 의무가 같은 행동에 영향을 줘도 출처와 조정 내역을 각각 표시하고, 중복 원인은 하나로 정규화한다.
- 추가 비용은 사건이 제공하는 현재 자원과 대체 경로를 고려해야 하며 **모든 의미 있는 행동을 불가능하게 만들지 않는다**.
- 비용 때문에 선택할 수 없는 행동이 생기면 보호 행동, 도구·지원, 책임 이관, 후속 책임이 명시된 연기, 승인 철수 판단 중 사건에 맞는 대안을 적어도 하나 표시한다.
- 정확한 수치 상한과 비용량은 구현 승인 뒤 사건별 밸런싱에서 정한다.
- 새로운 전역 `책임 포인트` 화폐를 만들지 않는다.

다음 정보 행동은 책임 판단을 위한 기본 권리이므로 비용을 부과하지 않는다.

- `관찰·괴이 매뉴얼·결과 미리보기는 비용을 부과하지 않는다`
- 행동 확정 전 취소와 포커스 이동
- 책임 근거·위험 대상·대안 열람

`접근성 대체 입력과 시간 압박 완화는 비용이 아니다`. 접근성 설정을 이유로 추가 행동 비용, 위험, 보상·랭크 감소를 만들지 않는다.

## 3. 표시 우선순위 계약

`priority_class`는 보호 책임을 알아보기 쉽게 정렬하는 정보 계층이다.

| priority_class | 의미 |
|---|---|
| `critical` | 다음 관련 행동이나 종결 전에 확인하지 않으면 비가역 인명·노출·안전 경로 손실 가능성이 큼 |
| `urgent` | 악화 중이지만 보호·지원·대체 경로로 회복 가능한 책임 |
| `watch` | 즉시 강제하지 않지만 감시·기록·후속 조치가 필요한 책임 |

각 의무는 `priority_reason`을 표시한다. 우선순위는 다음을 하지 않는다.

- 행동을 `자동 실행하지 않는다`.
- 플레이어에게 `강제 대상 선택`을 하지 않는다.
- 대응 정답이나 `숨은 성공률 보정`을 만들지 않는다.
- 높은 우선순위를 이유로 관찰·매뉴얼·대안 확인을 막지 않는다.

`동일 우선순위`의 의무는 `created_order`를 먼저 사용하고, 그래도 같으면 `obligation_id` 사전순을 사용해 재현 가능한 `결정적 순서`로 표시한다. 무작위 정렬과 불러오기 후 순서 변경을 금지한다.

## 4. 실패 전진과 선택 보존

보호 의무는 책임을 만들지만 회수를 죽음의 나선으로 만들지 않는다.

- 어떤 유효 상태에서도 사건 규칙 안의 `최소 하나의 의미 있는 회수 행동` 또는 책임 있는 종결 판단 경로를 유지한다.
- 위험 상태에는 `보호 행동`, `도구·지원`, `책임 이관`, `후속 책임이 명시된 연기`, `승인 철수 판단` 중 하나 이상의 명시적 대안을 제공한다.
- `모든 의무를 먼저 처리해야만 회수를 진행`할 수 있는 전역 선행 조건을 만들지 않는다.
- 비가역 손실은 되돌리지 않지만 기록 보존, 오염 차단, 안전 경로 확보, 후속 책임 수행 같은 남은 선택을 제공한다.
- 의무 위반은 숨은 수치 묶음이 아니라 어떤 대상과 책임이 어떻게 악화됐는지 기록한다.

## 5. 현상 통제 결과와 보호 축의 독립

Decision 120의 대표 회수 결과는 현상 통제 축을 나타낸다.

- `residue_recovered`
- `containment_complete`
- `stabilization_complete`
- `emergency_containment`
- `approved_withdrawal`
- `control_failure`

`미완료 보호 의무만으로 대표 회수 결과를 자동 강등하지 않는다`. `residue_recovered`, `containment_complete`, `stabilization_complete`, `emergency_containment`는 보호 의무의 완료·위반·미완료 상태와 함께 존재할 수 있다.

결과 패킷은 다음을 분리한다.

- `현상 통제 축`: 괴이와 확산 경로를 어디까지 통제했는가
- `보호 축`: 사람·기록·현장·안전 경로에 대한 책임을 어떻게 이행했는가

두 축은 `서로 덮어쓰지 않는다`. 완전 회수는 보호 위반을 숨기지 않고, 보호 의무 완료는 현상 통제 실패를 성공으로 바꾸지 않는다.

## 6. 보호 의무 상태

종결 판단 시 보호 의무는 다음 대표 상태를 사용한다.

- `completed`: 의무의 완료 조건 충족
- `transferred`: 자격과 수단을 가진 `accountable_owner`에게 책임을 인계
- `deferred_with_owner`: 즉시 완료하지 못했지만 `accountable_owner`와 `follow_up_condition`을 확정해 책임 있게 연기
- `breached`: 플레이어 행동이나 방치로 위반 결과가 발생
- `unresolved`: 완료·인계·책임 있는 연기 없이 남아 있음

`transferred`와 `deferred_with_owner`는 단순 문구가 아니라 인계 대상, 수락 근거, 후속 조건과 결과 패킷 기록을 요구한다. 출처나 책임 주체가 없는 형식적 인계는 `unresolved`로 취급한다.

## 7. 승인 철수 자격

`approved_withdrawal`은 Decision 120의 안전 철수 경로, 철수 근거, 보호 대상·중요 기록 확인, 붕괴 전 의도적 종료, 후속 책임 조건을 계속 사용한다.

추가로 보호 의무를 다음처럼 평가한다.

- `completed`, 유효한 `transferred`, 유효한 `deferred_with_owner`는 승인 철수 자격을 유지할 수 있다.
- `breached`는 발생 사실과 후속 책임을 숨기지 않지만, 그 자체만으로 항상 승인 철수를 금지하지는 않는다. 안전 철수와 책임 인계가 가능한지 함께 판단한다.
- `중대 보호 의무가 책임 있게 인계되지 않은 상태`의 `unresolved` 의무가 남으면 `승인 철수 자격 없음`이다.
- 보호 대상·중요 기록이 확인되지 않았는데 책임 주체와 추적 계획도 없으면 승인 철수가 아니다.

그러나 `후퇴 선택 자체를 숨기거나 잠그지 않는다`. 플레이어는 후퇴를 선택할 수 있고, 종결 확정 전에 왜 `approved_withdrawal`이 불가능하며 현재 선택이 강제 퇴각 또는 `control_failure`로 판정되는지 확인한다.

## 8. 종결 자격 미리보기 계약

종결 후보를 선택하면 다음 구조를 `종결 확정 전에` 표시한다.

```text
termination_candidate
eligible
blocking_reasons
non_blocking_consequences
accountable_transfer
```

- `termination_candidate`: 평가 중인 대표 회수 결과
- `eligible`: 현재 상태에서 해당 결과가 성립하는지
- `blocking_reasons`: 성립을 직접 막는 규칙·안전·책임 조건
- `non_blocking_consequences`: 결과를 막지는 않지만 보호 축과 후속 책임에 남는 손실·위반·미완료 의무
- `accountable_transfer`: 유효한 책임 이관과 후속 조건

UI와 로그는 `상위 결과가 성립하지 않는 이유`, `미완료 의무와 후속 책임`, 선택 가능한 대안을 함께 보여 준다. 결과 미리보기는 정답을 대신하지 않고, 이미 관측된 상태와 승인된 종결 조건만 설명한다.

## 9. 패턴 진실·정보 접근·접근성 중립

비용·우선순위·종결 자격은 다음을 `변경하지 않는다`.

- `pattern_id`
- `correct_response_id`
- `전조의 객관적 의미`
- 같은 패턴의 규칙과 정답
- 사건의 유효 후보 계산

`관찰`과 `괴이 매뉴얼`은 무료로 다시 확인할 수 있다. `접근성` 대체 입력, 스크린리더, 시간 압박 완화, 입력 반복 완화에는 `랭크·보상·종결 자격 불이익 금지`를 적용한다.

## 10. 저장·재개·호환

- 같은 `cost_adjustment_id를 중복 적용하지 않는다`.
- 비용 적용, 의무 상태 전이, 종결 평가 기록은 한 트랜잭션으로 `원자적` 저장한다.
- 실패 시 부분 적용을 남기지 않고 `rollback`한다.
- 저장·불러오기는 `idempotent`해야 하며, 로드할 때 이미 적용된 추가 비용이나 위반을 다시 적용하지 않는다.
- 우선순위는 저장된 `created_order`와 `obligation_id`로 같은 순서를 복원한다.
- Decision 121의 `LEGACY_NUMERIC_HANDOFF` 원본과 출처를 보존한다.
- `기존 시작 안정도 보정을 보호 의무 비용으로 소급 해석하지 않는다`.
- legacy bool이나 시작 안정도 값만으로 `critical` 의무, 승인 철수 차단 이유, 책임 인계를 발명하지 않는다.

## 11. 현행 구현 판정

현행 runtime은 `NOT_IMPLEMENTED / MIGRATION_REQUIRED`다.

- `GameState`는 미니게임 결과 bool과 피해자 상태를 저장하지만 의무별 비용 조정·우선순위·종결 평가를 구조화하지 않는다.
- `battle_scene.gd`의 시작 안정도 보정은 `LEGACY_NUMERIC_HANDOFF`이며, 의무별 인과·미리보기·한 번 적용 계약이 아니다.
- `recovery_successful`, `capture_success`, `core_recovered` 계열 값은 보호 의무 상태와 승인 철수 자격을 구분하지 못한다.
- 현재 실행 가능성은 Decision 122 구현 완료를 의미하지 않는다.

## 12. 승인하지 않은 것

- `scripts/core/protection_obligation_policy.gd` 생성
- `scripts/core/rescue_recovery_handoff_policy.gd`, `scripts/core/recovery_outcome_policy.gd` 구현 또는 변경
- `scripts/core/game_state.gd`, `scripts/scenes/battle_scene.gd`, `scripts/scenes/result_scene.gd` 변경
- 저장 Schema·Episode JSON·Canon v2 sidecar 변경
- 정확한 행동 비용·시간·자원·위험 수치
- 사건별 `critical` 판정과 책임 이관 대상 저작
- 최종 UI 배치·이미지·애니메이션·HX·오디오
- Human QA 통과 선언
- PR #149 또는 PR #151 병합
- Codex 구현 착수

## 13. 다음 게이트

1. GrillMe Batch 3의 다음 기획 충돌을 한 항목씩 승인한다.
2. 구현은 별도 사용자 승인 후 TDD 계획을 실행한다.
3. 구현 전 사건별 비용 조정·우선순위·종결 미리보기 예시를 데이터 계약에 맞춰 작성한다.
4. Human QA와 UI·접근성 검증은 runtime 구현 뒤 별도 수행한다.
