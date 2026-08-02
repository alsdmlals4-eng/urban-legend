# Package 1 기획 적대적 감사

> Audit ID: `R-2026-08-02-PACKAGE-1-PLANNING-ADVERSARIAL`
> Decision: `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL`
> Persistence Decision: `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> 작업 브랜치: `agent/v9-4-canon-reconciliation`
> 상태: `AUDIT_COMPLETE / USER_DECISION_RESOLVED / DESIGN_REVIEW_READY`
> 구현: `NOT_AUTHORIZED`

## 1. 감사 목적

Package 1 Session·Save isolation을 구현하기 전에 다음을 확인한다.

- 승인된 Validation 경험과 저장 계약이 충돌하지 않는가
- Legacy 저장 파일만이 아니라 런타임 상태까지 오염되지 않는가
- 별도 저장의 손상·중단·버전 불일치·삭제 의미가 닫혀 있는가
- 신규 Session이 기존 GameState 도메인 상태를 중복 소유하지 않는가
- 사용자가 결정해야 할 제품 의미와 GPT가 정할 기술 기본값이 분리됐는가

## 2. 보존 강점

| Strength ID | 보호 강점 | 근거 | 회귀 방지 |
|---|---|---|---|
| `S-P1-001` | Legacy `mvp-039`과 이관 지원 유지 | CURRENT Decision·Target Canon | Legacy save/load/clear 의미 불변 |
| `S-P1-002` | 별도 Validation 저장 | Change Proposal·Persistence Decision | 경로·버전·삭제·손상 격리 |
| `S-P1-003` | 기존 전문 절차 재사용 | dialogue/investigation/minigame/battle·현재 테스트 | 신규 Session의 도메인 state 중복 금지 |
| `S-P1-004` | flow 우선 복귀 | Target Canon | stage→checkpoint→return→fallback 순서 |
| `S-P1-005` | 숨은 기능 무부작용 | Validation Scope Filter | 파일·메모리 hidden-state diff test |
| `S-P1-006` | 결과 apply-once | Result Axes·Change Proposal | Scene 진입이 아닌 명시적 transaction |

## 3. 검증된 Finding Ledger

| ID | 유형 | Finding | 영향 | 판정 | 처리 |
|---|---|---|---|---|---|
| `F-P1-001` | `PLANNING_CONFLICT` | 기존 Gate의 “구현 승인” 표현과 최신 사용자의 “기획 작성부터” 지시가 충돌 | 구현 조기 착수 위험 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | `PLANNING_ONLY`로 정본화 완료 |
| `F-P1-002` | `PLANNING_GAP` | Validation 완료 기록과 본편/Legacy의 영속 관계 미확정 | 저장 Schema·메뉴 UX·완료 의미가 달라짐 | `USER_DECISION_REQUIRED → RESOLVED` | 권장안 A 승인: 완전 독립 기록 |
| `F-P1-003` | `UNDERDESIGN` | Validation 저장 슬롯 개수 미명시 | 메뉴·덮어쓰기·QA 범위 증가 | `SHOULD_FIX / RECOMMENDED_DEFAULT` | 단일 슬롯 1개 |
| `F-P1-004` | `UNDERDESIGN` | corrupt/recoverable/incompatible 상태의 행동·보존 정책 부족 | 무통보 삭제·복구 실패 위험 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | 자동 삭제 금지·격리 보존·명시적 초기화 |
| `F-P1-005` | `DATA_COMPATIBILITY_RISK` | 파일 bytes만 검사하면 숨은 메모리 오염을 놓침 | 이후 Legacy 이어하기 drift | `MUST_FIX / AUTO_FIX_ELIGIBLE` | hidden-state memory diff P0 추가 |
| `F-P1-006` | `DATA_COMPATIBILITY_RISK` | Session 활성 판정이 암묵적이면 저장 라우팅 오작동 | 잘못된 파일 저장 또는 양쪽 미저장 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | explicit token·version·episode, fail-closed |
| `F-P1-007` | `UNDERDESIGN` | runtime snapshot whitelist가 범주 수준 | 장기 상태 혼입·복원 불일치 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | Design Spec에 field-level 포함·제외 작성 |
| `F-P1-008` | `UNDERDESIGN` | reset·delete·abandon·completion 의미 혼합 | API가 잘못된 상태 삭제 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | lifecycle 명령 분리 |
| `F-P1-009` | `DATA_COMPATIBILITY_RISK` | 저장 중단·부분 쓰기·교체 실패 계약 부족 | save 손상·진행 유실 | `MUST_FIX / RECOMMENDED_DEFAULT` | temp→검증→replace·정상 backup 1세대 |
| `F-P1-010` | `UNDERDESIGN` | 버전 호환성 판정 Matrix 없음 | 구형·신형 save 잘못 적용 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | exact/migratable/incompatible/corrupt 분리 |
| `F-P1-011` | `OVERDESIGN` | Package 1에서 메뉴·전체 UI까지 설계할 가능성 | 범위 팽창·검증 지연 | `SHOULD_FIX` | Package 1은 Session·Save, 표시 UX는 Package 2 |
| `F-P1-012` | `UNPROVEN_ASSUMPTION` | Autoload만으로 기존 자동 save가 안전하다고 가정 | 직접 save 호출·초기화 경로 누락 | `MUST_FIX` | 호출자 inventory와 routing 수용 기준 |

## 4. 핵심 비판 재검증

### `F-P1-002` — 영속 관계

- factual basis: Target Canon은 별도 저장을 요구했지만 본편 이동·공유 여부를 정의하지 않았다.
- impact: 저장 파일 책임, 완료 의미, 향후 migration 비용에 직접 영향.
- user decision: `권장안대로 진행`.
- resolution: `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`에서 완전 독립 기록 확정.
- verdict: `RESOLVED / APPROVED`.

### `F-P1-005` — 메모리 오염

- factual basis: `GameState`는 캠페인·경제·관계 상태를 메모리에 소유하며 기존 Scene이 직접 함수를 호출한다.
- counterevidence: 별도 파일 경로는 파일 덮어쓰기를 막지만 런타임 mutation까지 자동으로 막지 않는다.
- verdict: `MUST_FIX`, Design P0에 file+memory no-effect 반영.

### `F-P1-009` — 정상 백업 1세대

- factual basis: 단일 파일 직접 교체는 중단 시 마지막 정상 상태를 잃을 수 있다.
- counterevidence: 한 사건 단일 슬롯에서 다세대 기록은 과도하다.
- verdict: `SHOULD_FIX / TEST_VALUE`, 1세대만 유지.

## 5. 승인된 영속 경계

```text
Validation save = 독립 기록
Legacy save = 기존 본편 기록
공유 profile = 생성하지 않음
자동 import = 금지
명시적 import = 별도 Decision 전까지 DEFERRED
```

Validation 완료 기록·보고서·매뉴얼 후보·결과 축은 Validation 저장에만 남는다. Legacy 캠페인·경제·관계·보고서·보상·해금은 변경하지 않는다.

## 6. 권장 기본값

```yaml
validation_slot_count: 1
save_version: validation-save-v1
normal_backup_generations: 1
corrupt_save_policy: PRESERVE_AND_QUARANTINE_NO_AUTO_DELETE
incompatible_newer_save_policy: INSPECT_ONLY_NO_DOWNGRADE
activation_policy: EXPLICIT_FAIL_CLOSED
hidden_state_contract: FILE_AND_MEMORY_NO_EFFECT
```

각 값은 `RECOMMENDED_DEFAULT` 또는 `TEST_VALUE`이며 실제 자동·런타임·플레이테스트 증거로 조정한다.

## 7. Design 반영 결과

Design Spec:

- `docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md`

반영된 항목:

- Session 상태와 책임 경계
- Save Repository 파일·원자적 교체 계약
- GameState field-level whitelist adapter
- active/inactive save routing
- 저장 문서 구조
- 버전·손상·복구 Matrix
- create/activate/save/load/abandon/delete/complete/deactivate lifecycle
- 오류 코드와 idempotency
- P0 file+memory no-effect 테스트
- 예상 파일·금지 파일·롤백

## 8. Rejected Critique

- 다중 슬롯 즉시 확장: 한 사건 Validation에는 근거 없는 범위 확장.
- 모든 기존 Scene 신규 구현: 검증된 전문 절차를 버리는 중복 작업.
- Legacy save 즉시 통합 Schema 전환: 보호 계약과 충돌.
- 모든 기술 기본값 사용자 질문: 최신 지시와 충돌.
- 독립 저장이므로 메모리 diff는 불필요: 파일과 runtime 권위가 달라 잘못된 비판.

## 9. 자기검수

```yaml
placeholder_scan: PASS
internal_consistency: PASS
scope_single_package: PASS
ambiguity_scan: PASS
persistence_decision_reflected: PASS
file_and_memory_no_effect: PASS
product_diff: 0
runtime: NOT_RUN
human_qa: NOT_RUN
```

## 10. 다음 Gate

```text
사용자 Design Spec 승인
→ writing-plans
→ 구현 계획 검수
→ 별도 Package 1 구현 승인
```
