# 괴이기록국 · Final Planning → Implementation Reality Gate

> 기준: `main@7f9e714e5aac65a826b4fd66d5219df8ed2dfb3e`
> 사용자 제품 Gate: `기획완료` · 2026-08-22 KST
> 판정: `HANDOFF_READY_WITH_KNOWN_REALIGNMENT`
> runtime_implementation: NOT_AUTHORIZED
> Human QA: `NOT_RUN`
> POC: `NOT_DECLARED`

이 감사는 사용자의 최종 `기획 완료` 선언을 구현 승인으로 오인하지 않고, 최신 main의 실제 코드·데이터·테스트가 최종 기획 정본과 어느 정도 일치하는지 확인한다. 결과는 **기획을 다시 여는 것**이 아니라 **구현자가 무엇을 재사용하고 무엇을 먼저 정합화해야 하는지**를 고정하는 implementation handoff다.

## 1. 최종 Planning Gate

```yaml
PLANNING_COMPLETE: true
USER_FINAL_PLANNING_DECLARATION_APPROVED: true
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
implementation_reality_gate: HANDOFF_READY_WITH_KNOWN_REALIGNMENT
implementation_contract: READY
runtime_implementation: NOT_AUTHORIZED
product_reference_asset: PENDING
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

`RELEASED_TO_IMPLEMENTATION_GATE`는 기획 단계의 변경 금지 잠금을 해제한다는 뜻이다. 실제 `data/`, `scripts/`, `scenes/`, save, product asset을 수정할 권한은 별도 구현 실행 승인/환경에서만 열린다.

## 2. Fresh-main actual implementation readback

### 2.1 EXISTING_CANON_V2_RUNTIME_REUSE

현재 main에는 저승역 Canon v2의 구현이 이미 상당 부분 존재한다.

- `data/episodes/episode_001_afterlife_station_canon_v2.json`
- `data/episodes/episode_001_afterlife_station_canon_v2_runtime_projection.json`
- `data/migrations/afterlife_station_canon_v2_id_migration.json`
- `scripts/data/afterlife_canon_v2_loader.gd`
- `scripts/core/afterlife_main_save_migrator.gd`
- `scripts/core/afterlife_migrating_game_state.gd`
- `scripts/core/afterlife_migrating_validation_session.gd`
- migration fixtures/focused tests/workflows

`project.godot`의 실제 autoload도 `GameState=afterlife_migrating_game_state.gd`, `ValidationSession=afterlife_migrating_validation_session.gd`를 사용한다.

판정: **`EXISTING_CANON_V2_RUNTIME_REUSE`**. 과거 implementation plan을 처음부터 재실행하거나 Canon v2 migration을 새로 만드는 것은 중복·회귀 위험이 크므로 금지한다.

### 2.2 Save / ID successor

현재 구현은 다음 안전 계약을 이미 가진다.

- stable Episode ID `episode_001_afterlife_station` 유지
- stable victim ID `victim_afterlife_station_001` 유지
- `mvp-038/039 → mvp-040` 저승역 전용 migration
- `validation-save-v1 → validation-save-v2`
- SPLIT evidence는 `migrated_unverified`
- 진행 중 legacy rescue/recovery는 `LEGACY_CASE_RESTART_REQUIRED`
- 완료 결과는 `legacy_resolution_snapshot`으로 보존
- `effect_id`, migration history, checksum, backup/rollback

따라서 ID/save migration matrix는 새로 작성할 필요가 없다. 기존 `docs/planning/2026-08-05-afterlife-station-id-migration-matrix.md`를 **재사용 + 최신 정본 의미만 보정**한다.

중요: base `scripts/core/game_state.gd`의 `SAVE_VERSION := "mvp-039"`를 프로젝트 전체에서 무조건 올리지 않는다. 현재 `mvp-040`은 active migrating GameState가 저승역 Canon v2에 조건부로 적용하는 호환 경로이며, 다른 사건 저장 호환성을 증명하지 않고 전역 버전을 바꾸면 안 된다.

## 3. Current canon ↔ runtime conflicts

### 3.1 LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED

현재 기획 정본의 사건 결과 권위는 `COMPOSITE_RESULT`다.

- 피해자 상태
- 확인 규칙 / 증거 무결성
- 회수·안정화 상태
- 위험 사례 / 보호 책임
- 잔향
- 미해결 / 후속 실행

반면 현재 `episode_001_afterlife_station_canon_v2.json`의 `result_contract`에는 `owns_first_s_rank`, `s_rank`가 현행 product authority처럼 남아 있다.

판정: **`LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED`**.

교정 원칙:
- 과거 grade 값과 첫 S-rank 기록은 save/history/mastery compatibility로 보존 가능하다.
- S/A/B나 S-rank가 current 사건 결과를 대표하거나 복합 축을 덮어쓰면 안 된다.
- 현재 runtime에 이미 존재하는 independent result/evaluation axes를 successor로 사용한다.

### 3.2 COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT

현재 main에는 이미 다음 successor가 존재한다.

- `RecoveryOutcomePolicy.build_independent_result_packet()`
- `CanonV2ResultAxesBridge`
- control axis
- protection responsibility axis
- evidence integrity axis
- follow-up execution axis
- mastery axis

판정: **`COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT`**.

따라서 새 결과 시스템을 병렬로 만들지 않는다. 기존 independent axes를 현재 `COMPOSITE_RESULT`의 runtime owner로 승격·정합화한다.

### 3.3 MONTHLY_STATE_NOT_IMPLEMENTED

현재 Planning Canon은 top-level optional `monthly_state`를 승인했지만 fresh-main 검색에서 runtime implementation은 확인되지 않았다.

판정: **`MONTHLY_STATE_NOT_IMPLEMENTED`**.

추가 계약:
- additive optional block
- old save에 block이 없으면 정상 default
- 기존 Episode/report/ANNUAL ID rename 금지
- legacy report만 보고 month completion을 추론하지 않음
- case truth/정답을 저장하지 않고 월간 orchestration만 소유
- M01 조기 해결 뒤 같은 달 두 번째 main case를 만들지 않음

## 4. M01 First Session implementation readiness

현재 정본 역할: `M01_FIRST_SESSION`.

재사용 가능:
- Canon v2 loader/migration/runtime state
- investigation/recovery UI hierarchy successor
- rescue→recovery handoff policies
- independent result axes
- existing weekly/ANNUAL scheduling implementation assets

추가 구현에서 보호할 것:
- Opening Record → 기록국 첫 업무 → 제한된 첫 일정 → M01 출동 → 조사 → 추리 → 구출 → 회수 → 복합 결과
- `SERIAL_EXAM_FATIGUE_GUARD`: 단계마다 새 정답 체계를 추가하지 않고 동일 규칙을 `관측 → 해석 → 적용 → 실행`으로 재사용
- 첫 실패에서 전체 사건 즉시 리셋보다 학습 가능한 기록/원인 피드백 우선

## 5. M04 release-near boundary

현재 정본 역할: `M04_RELEASE_NEAR_VERTICAL_SLICE`.

공용 시스템/화면 grammar와 test baseline 준비는 implementation plan에 포함할 수 있다. 하지만 concrete M04 이미지·레이어·권리·최종 가독성은 여전히 **`PRODUCT_REFERENCE_ASSET_PENDING`**이다.

따라서:
- code/data/state 기반 준비: 가능
- 최종에 가까운 visual/audio/VFX production 및 player-experience Human PASS: asset Gate 뒤
- 자동 테스트만으로 M04 release-near PASS 선언: 금지

## 6. Issue successor freshness — #181

유일한 open Issue **#181**은 실제 main의 `Ver 4.2` hardcode가 남아 있어 미완료가 맞다. 이미 별도 design/spec/implementation plan도 존재한다.

기획 완료 전 상태 `DEFERRED_VALID / PLAN_LOCK`은 이제 predecessor다.

fresh-main 판정:

**`#181 = CURRENT_VALID / IMPLEMENTATION_GATE`**

- close하지 않는다.
- 새 메인 메뉴 계획을 중복 생성하지 않는다.
- 기존 `2026-08-09-main-menu-control-room-versioning-*` spec/plan을 재사용한다.
- 실제 runtime mutation은 이 handoff PR이 아니라 구현 실행 단계에서 한다.

## 7. 최소 3개 실행 대안 비교

### A. Canon v2 migration을 처음부터 재구현

- 장점: 최신 정본만 보고 깨끗하게 재설계 가능.
- 단점: main에 이미 있는 transaction/save/loader/runtime policy와 중복되고, 검증된 rollback·compatibility를 다시 위험에 노출.
- 판정: 기각.

### B. 현재 runtime을 그대로 두고 monthly_state만 추가

- 장점: 변경량 최소.
- 단점: current sidecar의 S-rank authority가 최신 `COMPOSITE_RESULT`와 충돌한 채 남아 current/runtime 불일치 지속.
- 판정: 기각.

### C. 기존 Canon v2 runtime 재사용 + 정본 충돌만 보정 + monthly_state 추가

- 장점: 검증된 구현·rollback·ID 호환을 보존하면서 최신 제품 정본에 맞게 최소 수정.
- 단점: 역사 S-rank/grade와 current composite result의 compatibility boundary를 세밀하게 테스트해야 함.
- 판정: **권장 / 채택**.

## 8. Implementation Reality Gate 결론

```yaml
planning: COMPLETE
existing_canon_v2_runtime: REUSE
save_id_migration_matrix: REUSE_WITH_CURRENT_SEMANTIC_REALIGNMENT
composite_result_runtime: SUCCESSOR_PRESENT
legacy_s_rank_contract: REALIGNMENT_REQUIRED
monthly_state: NOT_IMPLEMENTED
m01_first_session: HANDOFF_READY
m04_release_near: SYSTEM_PREP_READY_ASSET_GATE_PENDING
issue_181: CURRENT_VALID_IMPLEMENTATION_GATE
runtime_implementation: NOT_AUTHORIZED
human_qa: NOT_RUN
```

최종 판정: **`HANDOFF_READY_WITH_KNOWN_REALIGNMENT`**.

다음 current owner는:
- 설계: `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- 실행계획: `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

이다.
