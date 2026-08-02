# Package 1 기획 적대적 감사

> Audit ID: `R-2026-08-02-PACKAGE-1-PLANNING-ADVERSARIAL`
> Decision: `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL`
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> 작업 브랜치: `agent/v9-4-canon-reconciliation`
> 상태: `AUDIT_COMPLETE / GRILL_ME_REQUIRED`
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
| `S-P1-002` | 별도 Validation 저장 | Change Proposal | 경로·버전·삭제·손상 격리 |
| `S-P1-003` | 기존 전문 절차 재사용 | dialogue/investigation/minigame/battle·현재 테스트 | 신규 Session의 도메인 state 중복 금지 |
| `S-P1-004` | flow 우선 복귀 | Target Canon | stage→checkpoint→return→fallback 순서 |
| `S-P1-005` | 숨은 기능 무부작용 | Validation Scope Filter | 파일·메모리 hidden-state diff test |
| `S-P1-006` | 결과 apply-once | Result Axes·Change Proposal | Scene 진입이 아닌 명시적 transaction |

## 3. 검증된 Finding Ledger

| ID | 유형 | Finding | 영향 | 판정 | 처리 |
|---|---|---|---|---|---|
| `F-P1-001` | `PLANNING_CONFLICT` | 기존 Gate의 “구현 승인” 표현과 최신 사용자의 “기획 작성부터” 지시가 충돌 | 구현 조기 착수 위험 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | 최신 지시를 우선해 `PLANNING_ONLY`로 정본화 |
| `F-P1-002` | `PLANNING_GAP` | Validation 완료 기록이 본편/Legacy와 어떤 영속 관계를 갖는지 미확정 | 저장 Schema·메뉴 UX·완료 의미가 달라짐 | `USER_DECISION_REQUIRED` | 첫 Grill Me |
| `F-P1-003` | `UNDERDESIGN` | Validation 저장 슬롯 개수가 명시되지 않음 | 메뉴·덮어쓰기·QA 범위 증가 | `SHOULD_FIX / RECOMMENDED_DEFAULT` | 버티컬 슬라이스 동안 단일 슬롯 1개 |
| `F-P1-004` | `UNDERDESIGN` | corrupt/recoverable/incompatible 상태명은 있으나 사용자 행동과 데이터 보존 정책이 없음 | 무통보 삭제·복구 실패 위험 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | 자동 삭제 금지, 원본 격리 보존, 명시적 초기화 |
| `F-P1-005` | `DATA_COMPATIBILITY_RISK` | 파일 bytes 불변만 검사하면 GameState의 숨은 campaign/economy/relationship 메모리 변경을 놓침 | 이후 Legacy 이어하기가 오염될 수 있음 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | Package 1 P0에 hidden-state memory diff 추가 |
| `F-P1-006` | `DATA_COMPATIBILITY_RISK` | Session 활성 판정이 암묵적이면 Legacy save routing이 오작동할 수 있음 | 잘못된 파일 저장 또는 양쪽 미저장 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | 명시적 activation token·version·episode 검증, 불일치 시 fail-closed |
| `F-P1-007` | `UNDERDESIGN` | runtime snapshot whitelist가 범주 수준이며 필드별 포함·제외·기본값이 없음 | 장기 상태 혼입·복원 불일치 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | Design Spec에 field-level matrix 작성 |
| `F-P1-008` | `UNDERDESIGN` | session reset, save delete, run abandon, completion의 의미가 분리되지 않음 | 버튼·API가 잘못된 상태를 삭제 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | lifecycle 명령을 별도 계약으로 분리 |
| `F-P1-009` | `DATA_COMPATIBILITY_RISK` | 저장 중단·부분 쓰기·교체 실패 시 마지막 정상 저장 보존 계약 부족 | save 손상·진행 유실 | `MUST_FIX / RECOMMENDED_DEFAULT` | temp write→검증→replace, 정상 백업 1세대 |
| `F-P1-010` | `UNDERDESIGN` | 버전 호환성 판정 matrix가 없음 | 구형·신형 save를 잘못 적용 | `MUST_FIX / AUTO_FIX_ELIGIBLE` | exact/migratable/newer-incompatible/corrupt 분리 |
| `F-P1-011` | `OVERDESIGN` | Package 1에서 메인 메뉴·전체 UI까지 함께 설계할 가능성 | 범위 팽창·검증 지연 | `SHOULD_FIX` | Package 1은 headless/session/save 계약까지, 표시 UX는 Package 2 |
| `F-P1-012` | `UNPROVEN_ASSUMPTION` | Autoload를 추가하면 기존 Scene 자동 save가 모두 안전해진다고 가정 | 직접 save 호출·초기화 경로 누락 | `MUST_FIX` | 호출자 inventory와 routing contract를 수용 기준에 포함 |

## 4. Validate Critique

### `F-P1-002` — 영속 관계

- factual basis: Target Canon은 별도 Validation 저장과 결과 기록을 요구하지만 본편 save로의 이동·공유·가져오기 여부를 정의하지 않는다.
- counterevidence: Change Proposal은 Legacy write 금지와 후보 기록만 저장하는 안전 방향을 제시한다.
- impact: main menu 구조, 저장 파일 책임, completion 의미, 향후 migration 비용에 직접 영향.
- verdict: `USER_DECISION_REQUIRED`.

### `F-P1-005` — 메모리 오염

- factual basis: `GameState`는 캠페인·경제·관계 상태를 메모리에 소유하며 기존 Scene이 직접 함수를 호출한다.
- counterevidence: 별도 파일 경로는 파일 덮어쓰기를 막지만 런타임 mutation까지 자동으로 막지 않는다.
- impact: Validation 종료 뒤 Legacy 이어하기의 숨은 상태 drift.
- verdict: `MUST_FIX`.

### `F-P1-009` — 정상 백업 1세대

- factual basis: 단일 파일을 직접 교체하면 중단 시 마지막 정상 상태를 잃을 수 있다.
- counterevidence: 버티컬 슬라이스의 단일 슬롯에서 다세대 기록은 과도하다.
- impact: 최소 복구 가능성 확보.
- verdict: `SHOULD_FIX / RECOMMENDED_DEFAULT`, 1세대만 유지.

## 5. 자동 반영할 권장 기본값

다음은 프로젝트 방향을 바꾸지 않으므로 Grill Me 없이 Design Spec에 반영한다.

```yaml
validation_slot_count: 1
classification: RECOMMENDED_DEFAULT
adjustment_condition: 실제 신규 플레이어 테스트에서 다중 슬롯 필요성이 확인될 때

save_version: validation-save-v1
classification: RECOMMENDED_DEFAULT

normal_backup_generations: 1
classification: TEST_VALUE

corrupt_save_policy: PRESERVE_AND_QUARANTINE_NO_AUTO_DELETE
classification: RECOMMENDED_DEFAULT

incompatible_newer_save_policy: INSPECT_ONLY_NO_DOWNGRADE
classification: RECOMMENDED_DEFAULT

activation_policy: EXPLICIT_FAIL_CLOSED
classification: RECOMMENDED_DEFAULT

hidden_state_contract: FILE_AND_MEMORY_NO_EFFECT
classification: RECOMMENDED_DEFAULT
```

### lifecycle 명령 분리

- `start_new_validation`: 새 runtime 시작, 기존 Validation save가 있으면 명시적 교체 승인 필요
- `save_validation`: Validation namespace만 저장
- `load_validation`: Validation save만 복원
- `abandon_runtime`: 현재 메모리 Session 종료, 저장 파일 유지
- `delete_validation_save`: Validation save와 해당 임시/백업만 삭제
- `complete_validation`: 결과 transaction 후 완료 checkpoint 저장
- `reset_legacy`: 기존 Legacy 전용 명령, Validation에서 호출 금지

## 6. 첫 Grill Me 필요 Decision

### Decision 후보

`D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`

### 질문 필요성

Validation 결과를 본편과 완전히 분리할지, 완료 뒤 명시적으로 가져올 수 있게 할지는 기술 세부가 아니다. 플레이어에게 “이 기록이 실제 진행인가, 독립 검증 기록인가”를 약속하는 제품 결정이며 Package 1 저장 경계를 바꾼다.

### 선택지

- A — 완전 독립 Validation 기록
- B — 완료 후 명시적 1회 가져오기
- C — 공용 프로필에 일부 기록만 공유

권장안은 A다. 이유는 현재 버티컬 슬라이스의 검증 목적, Legacy 보존, 숨은 경제·캠페인 무부작용과 가장 잘 맞고 되돌리기 쉽기 때문이다.

## 7. Rejected Critique

- Validation save를 여러 슬롯으로 확장해야 한다: 현재 한 사건 버티컬 슬라이스에는 근거 없는 범위 확장이라 `REJECTED_CRITIQUE`.
- 모든 기존 Scene을 신규 전용 Scene으로 교체해야 한다: 검증된 전문 절차를 버리고 중복 구현하므로 `REJECTED_CRITIQUE`.
- Legacy save를 즉시 신규 Schema로 통합해야 한다: 현재 보호 계약과 정면 충돌하므로 `REJECTED_CRITIQUE`.
- 구현 전에 모든 수치와 파일 API를 사용자에게 물어야 한다: 기술 기본값은 권장안으로 처리한다는 최신 지시와 충돌하므로 `REJECTED_CRITIQUE`.

## 8. 다음 Gate

```text
첫 Grill Me 답변
→ persistence boundary Decision 즉시 동기화
→ Package 1 Design Spec 작성
→ field-level snapshot·lifecycle·error·test matrix
→ Spec self-review
→ 사용자 Spec 승인
→ writing-plans
→ 별도 구현 승인
```
