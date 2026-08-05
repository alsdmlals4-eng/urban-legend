# GrillMe Batch 3 승인 원장

> 상태: `OPEN / 7_OF_10 / EARLY_CANON_CHECKPOINT`
> 배치 병합: `BATCH_MERGE_NOT_STARTED`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 병합 권한: `MERGE_NOT_AUTHORIZED`
> 기반 Draft PR: PR #149
> 현재 Draft PR: #151

이 문서는 GrillMe Batch 3의 실제 사용자 승인만 카운트한다. 철회·오해·비승인 기록은 역사로 남기되 승인 수에 포함하지 않는다.

## 승인 현황

| 순번 | Decision ID | 주제 | 사용자 응답 | 상태 | 정본·시트 |
|---:|---|---|---|---|---|
| 1 | `DEC-20260805-115-CANON-V2-RULE-STRIP-CONTINUITY` | 조사·구출·회수 전 단계의 괴이 매뉴얼 표시 방식 | `권장안대로 진행` | `APPROVED` | GitHub·Google Sheet 동기화 완료 |
| 2 | `DEC-20260805-116-CANON-V2-RESCUE-RETRIEVAL-ROLE-BOUNDARY` | 피해자 구출과 회수 전투의 역할 경계 | `권장안대로 진행` | `APPROVED` | GitHub·Google Sheet 동기화 완료 |
| 3 | `DEC-20260805-117-CANON-V2-RESCUE-MINIGAME-AND-RETRIEVAL-RULE-COVERAGE` | 공통 구출 문법·사건별 변주·회수 규칙 범위 | `권장안대로 진행` | `APPROVED` | GitHub·Google Sheet 동기화 완료 |
| 철회 | `DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE` | 예시를 고정 4턴 규칙으로 잘못 승격 | 사용자 정정: `4턴 확정이 아님` | `RETRACTED / NON_COUNTING` | 활성 정본·Sheet 결정에서 제거 |
| 4 | `DEC-20260806-119-CANON-V2-RECOVERY-PATTERN-POOL-SELECTION-AND-JUDGMENT` | 괴이별 패턴 풀의 첫 노출·반복 선택·전조·판단 불변성 | `권장안대로 진행` | `APPROVED` | GitHub·Google Sheet 동기화 완료 |
| 5 | `DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET` | 회수 대표 결과 6종·승인 철수 경계·독립 결과 패킷 | `권장안대로 진행` | `APPROVED` | GitHub·Google Sheet 동기화 완료 |
| 6 | `DEC-20260806-121-CANON-V2-RESCUE-RESULT-HANDOFF-TO-RECOVERY-INITIAL-CONDITIONS-AND-ACTION-CONSTRAINTS` | 불변 구출 스냅샷·회수 초기 조건·보호 의무·행동 제약 | `권장안대로 진행` | `APPROVED` | GitHub·Google Sheet 동기화 완료 |
| 7 | `DEC-20260806-122-CANON-V2-PROTECTION-OBLIGATION-COST-PRIORITY-AND-RECOVERY-TERMINATION-ELIGIBILITY` | 보호 의무 행동 비용·표시 우선순위·회수 종결 자격 | `권장안대로 진행` | `APPROVED` | GitHub·Google Sheet 동기화 완료 |
| 8–10 | — | 후속 GrillMe | — | `NOT_ASKED` | 미반영 |

## 1번 승인 — 규칙 정보 연속성

- 조사·보고는 전체 괴이 매뉴얼 작업공간을 사용한다.
- 구출·회수는 같은 권위 상태에서 파생된 현행 규칙 스트립을 사용한다.
- 정답 자동 공개는 금지하며 전체 매뉴얼은 비용 없이 재열람한다.

## 2번 승인 — 같은 규칙, 다른 책임

- 구출은 피해자 분리·보호·생존·후유증을 담당한다.
- 회수는 현상 통제·안정화·봉쇄·잔향 회수·승인 철수를 담당한다.
- 구출 결과는 회수 초기 조건과 보호 의무에 영향을 주되 승패를 대신하지 않는다.

## 3번 승인 — 공통 구출 문법과 회수 범위

- 공통 4단계는 구출 미니게임에만 적용한다.
- 회수 행동 범위는 보호·관찰·대응·공격·장비·봉쇄·후퇴다.
- `core_recovered` 단일 결과는 구형 호환 상태이며 최종 제품 계약이 아니다.
- 정확한 회수 턴 수·패턴 개수·행동 비용은 승인되지 않았다.

## 철회 기록 — Decision 118

4턴은 예시일 뿐 전역 규칙이 아니다. 실제 회수는 **패턴별 전조·판단 단위**다.

```text
괴이가 가진 패턴 집합
→ 완성된 패턴 하나 선택
→ 단일 전조 공개
→ 가설·근거·대응
→ 즉시 정오 판정
→ 안정도 또는 피해
→ 기록
→ 다음 패턴 또는 종결
```

사건과 괴이가 저작한 패턴 수에 따라 회수 길이가 달라진다. 고정 4턴·전조 세 개 누적·4턴 전용 대응은 활성 권위가 아니다.

## 4번 승인 — 괴이별 패턴 풀의 선택·판단

```text
괴이별 패턴 풀
→ 유효 후보 계산
→ 완성된 패턴 하나 선택
→ 단일 전조 공개
→ 가설·근거·대응
→ 즉시 정오 판정
→ 안정도 또는 피해
→ 선택 이유와 결과 인과 기록
→ 다음 패턴 또는 회수 종결
```

- 미관측 패턴을 저작 순서로 우선한다.
- 모든 패턴을 확인한 뒤에는 유효 후보를 다시 계산한다.
- 후보가 둘 이상이면 직전 패턴을 제외해 즉시 반복을 피한다.
- 남은 후보는 사건별 가중치로 선택하며 가중치 미지정은 동일 기본값이다.
- 유효 후보가 하나뿐이면 반복을 허용하고 이유를 기록한다.
- 첫 노출 완전 무작위와 전체 확인 뒤 순수 고정 순환을 모두 금지한다.
- 전조 공개 전에 `pattern_id`와 `correct_response_id`를 확정하고 판정 종료까지 바꾸지 않는다.
- 같은 패턴 재등장 시 같은 규칙과 정답을 유지하며, 다른 정답은 별도 variant pattern ID로 저작한다.
- 고정 전역 턴 수·`cycle_turn`·`ordered_telegraphs`를 요구하지 않는다.

## 5번 승인 — 회수 결과 상태와 독립 결과 패킷

대표 회수 결과:

| 결과 | 클래스 | 의미 |
|---|---|---|
| `residue_recovered` / 잔향 회수 완료 | `FULL_SUCCESS` | 현상·확산 경로 통제와 잔향 확보 |
| `containment_complete` / 봉쇄 완료 | `CONTROL_SUCCESS` | 지속 봉쇄, 잔향 미회수 가능 |
| `stabilization_complete` / 안정화 완료 | `PROVISIONAL_SUCCESS` | 현재 발현 정지, 재발 가능성과 후속 의무 |
| `emergency_containment` / 긴급 봉쇄 | `PARTIAL_SUCCESS` | 참사 방지, 임시 봉쇄와 높은 잔여 위험 |
| `approved_withdrawal` / 승인 철수 | `STRATEGIC_EXIT` | 책임 조건을 갖춘 전략적 종료 |
| `control_failure` / 통제 실패 | `FAILURE` | 통제·안전 종결·승인 철수 불성립 |

- 긴급 봉쇄는 부분 성공이다.
- 승인 철수는 실패가 아니며 안전 철수 경로·철수 근거·보호 대상/중요 기록 상태·통제 붕괴 전 종료·후속 책임이 필요하다.
- 승인 조건 없는 강제 퇴각은 통제 실패다.
- 피해자 결과와 회수 결과는 서로 덮어쓰지 않는다.
- 대표 결과 외에 보호 의무·요원/장비·현장/노출·증거/기록·후속 의무·인과 이력을 독립 저장한다.
- `core_recovered`는 `LEGACY_SINGLE_OUTCOME`, `recovery_successful`과 `capture_success`는 `LEGACY_COMPAT_ONLY`다.
- 결과 화면은 피해자 결과와 회수 결과를 동등한 헤드라인으로 표시하고 단일 임무 성공/실패 배너를 사용하지 않는다.

상세 Decision·설계·감사·구현 계획:

- `docs/decisions/DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET.md`
- `docs/planning/2026-08-06-canon-v2-recovery-outcome-states-and-independent-result-packet-design.md`
- `docs/audits/2026-08-06-recovery-outcome-states-and-result-packet-adversarial-review.md`
- `docs/superpowers/plans/2026-08-06-recovery-outcome-states-and-result-packet.md`

## 6번 승인 — 구출 결과의 회수 인계와 보호 의무

```text
구출 종료
→ rescue_outcome_snapshot 확정
→ recovery_handoff_state 도출
→ active_protection_obligations 생성
→ 회수 행동 전 책임 결과 공개
→ protection_history에 이행·위반·악화 기록
→ 구출 당시 사실과 회수 중 변화를 나란히 보고
```

- `rescue_outcome_snapshot`은 구출 종료 당시 사실이며 불변이다.
- `recovery_handoff_state`는 회수 시작용 의미 상태를 한 번만 도출한다.
- `active_protection_obligations`는 출처·대상·긴급도·영향 행동·이행 조건·위반 결과를 가진다.
- `protection_history`는 의무의 생성·이행·부분 이행·위반·악화·완료 인과를 보존한다.
- 생존·안정, 생존·위중, 피해자 상실, 생존 불명·실종을 구분한다.
- 완전 분리, 부분 분리, 분리 실패, 비가역 연결을 구분한다.
- 구출 결과가 회수 대표 결과를 자동 결정하지 않으며 구출 실패가 회수 실패를 자동으로 만들지 않는다.
- 기본적으로 행동을 잠그지 않고 선택 전에 충돌 의무·예상 결과·위험 대상·대안을 표시한다.
- hard lock은 물리적으로 실행 불가능하거나 확인된 괴이 규칙을 직접 위반하는 경우만 허용한다.
- 인계는 `pattern_id`, `correct_response_id`, 전조의 객관적 의미를 변경하지 않는다.
- 같은 구출 퍼즐을 회수에서 반복하지 않으며 전역 고정 턴 수를 추가하지 않는다.
- 현행 수치 보정은 `LEGACY_NUMERIC_HANDOFF`이며 숨은 보정·단일 등급 일괄 보정·죽음의 나선을 금지한다.
- 저장·이관은 원자적·rollback-safe·idempotent해야 하며 legacy bool에서 완전 구출을 추정하지 않는다.
- 모순·필수 필드 누락·출처 불명은 `handoff_validation_failed`로 중단·기록한다.

상세 Decision·설계·감사·구현 계획:

- `docs/decisions/DEC-20260806-121-CANON-V2-RESCUE-RESULT-HANDOFF-TO-RECOVERY-INITIAL-CONDITIONS-AND-ACTION-CONSTRAINTS.md`
- `docs/planning/2026-08-06-canon-v2-rescue-result-handoff-to-recovery-initial-conditions-and-action-constraints-design.md`
- `docs/audits/2026-08-06-rescue-result-handoff-to-recovery-adversarial-review.md`
- `docs/superpowers/plans/2026-08-06-rescue-result-handoff-to-recovery.md`

## 7번 승인 — 보호 의무의 비용·우선순위·종결 자격

```text
active_protection_obligations
→ 관련 행동 비용 계산
→ critical / urgent / watch 표시 정렬
→ 행동·종결 확정 전 결과 미리보기
→ 플레이어 선택
→ 비용·이행·위반을 한 번만 적용
→ 현상 통제 축과 보호 축을 독립 보고
```

- 행동 비용, 표시 우선순위, 종결 자격은 서로 분리한다.
- 비용은 `obligation_id`, `affected_action`, `source_reason`이 있는 관련 행동에만 적용한다.
- `base cost`와 `additional cost`를 확정 전에 표시한다.
- 전역 비용 인상, 새로운 책임 화폐, 모든 의미 있는 행동의 봉쇄를 금지한다.
- 관찰·괴이 매뉴얼·결과 미리보기와 접근성 대체 입력에는 비용을 부과하지 않는다.
- `priority_class`는 `critical`, `urgent`, `watch`이며 정보 정렬이지 자동 행동이나 강제 대상 선택이 아니다.
- 동일 우선순위는 `created_order`, 그다음 `obligation_id`로 결정적 정렬한다.
- 미완료 보호 의무만으로 `residue_recovered`, `containment_complete`, `stabilization_complete`, `emergency_containment`를 자동 강등하지 않는다.
- `completed`, 유효한 `transferred`, 유효한 `deferred_with_owner`는 승인 철수 책임 조건을 충족할 수 있다.
- 중대 `unresolved` 의무가 책임 있게 인계되지 않으면 `approved_withdrawal` 자격이 없지만 후퇴 선택은 잠그지 않는다.
- 종결 미리보기는 `termination_candidate`, `eligible`, `blocking_reasons`, `non_blocking_consequences`, `accountable_transfer`를 표시한다.
- 같은 `cost_adjustment_id`는 한 번만 적용하며 저장·재개는 원자적·rollback-safe·idempotent하다.
- `LEGACY_NUMERIC_HANDOFF`를 새 보호 의무 비용으로 소급 해석하지 않는다.
- `pattern_id`, `correct_response_id`, 전조의 객관적 의미와 접근성 성과는 바꾸지 않는다.

상세 Decision·설계·감사·구현 계획:

- `docs/decisions/DEC-20260806-122-CANON-V2-PROTECTION-OBLIGATION-COST-PRIORITY-AND-RECOVERY-TERMINATION-ELIGIBILITY.md`
- `docs/planning/2026-08-06-canon-v2-protection-obligation-cost-priority-and-recovery-termination-eligibility-design.md`
- `docs/audits/2026-08-06-protection-obligation-cost-priority-and-termination-eligibility-adversarial-review.md`
- `docs/superpowers/plans/2026-08-06-protection-obligation-cost-priority-and-termination-eligibility.md`

## 배치 운영 경계

- 현재 카운터: `7_OF_10`.
- Decision 118은 계속 `RETRACTED / NON_COUNTING`이다.
- 현재 PR은 조기 기획 체크포인트일 뿐 배치 병합 완료가 아니다.
- PR #149의 실제 저장·UI·접근성 QA 상태는 변경하지 않는다.
- PR #151의 제품 구현과 병합은 승인하지 않는다.

## 다음 질문 후보

다음 GrillMe 8/10은 보호 의무의 완료·책임 이관·연기·위반을 후속 조사·재진입·보상·평가에 연결하는 범위와 한계를 다룬다.