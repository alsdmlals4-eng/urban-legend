# 괴이기록국 Current Decision Overlay

> 문서 역할: `CURRENT_MUTABLE_DECISION_OVERLAY`
> 상태: `CURRENT / PLANNING_COMPLETE / USER_APPROVED_VISUAL_DIRECTION_LOCK / RUNTIME_RECONCILIATION_MERGED`
> 갱신 기준: PR #322 merge commit `9fa32d32e8a5a2ad7d34a388695986b4ab81c6a7` + merged-main canon readback (runtime merge `8d303f0f9414950273be934fd28c8fb1b3a21e18`)
> 상세 역사 결정 원장: `docs/CURRENT_CONFIRMED_DECISIONS.md`

이 파일은 현재 작업자가 즉시 판단해야 하는 mutable decision과 verified successor state만 소유한다. 역사 원장이 current state와 충돌하면 최신 사용자 지시 → GitHub latest main → Notion current planning → `CURRENT_PLANNING_CANON.md` / `current-planning-canon.json` → 이 Overlay 순으로 해석한다.

## 1. 현재 제품 구조

```yaml
cadence: ONE_MAIN_CASE_PER_MONTH
initial_slate: M01_TO_M12
continuous_after_m12: true
signature_cases: [M01, M04, M07, M10]
first_session: M01_AFTERLIFE_STATION
release_near_vertical_slice: M04_RED_UMBRELLA
core_flow: INVESTIGATION_DEDUCTION_MANUAL_RESCUE_RECOVERY_COMPOSITE_RESULT
visual_treatment: SOFT_ANIME_NOIR_LOCKED
presentation_language: DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM
visual_direction_lock: USER_APPROVED
visual_direction_decision: D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION
m04_time_tradeoff: USER_APPROVED
m04_time_tradeoff_decision: D-2026-08-28-M04-ONE-DELAY-PREPARATION-VICTIM-RISK-TRADEOFF
m04_route_memory_anchor_preparation_benefit: USER_APPROVED
m04_route_memory_anchor_decision: D-2026-08-28-M04-ROUTE-MEMORY-ANCHOR-PREPARATION-BENEFIT
```

## 2. 현재 Gate

```yaml
PLANNING_COMPLETE: true
USER_FINAL_PLANNING_DECLARATION_APPROVED: true
non_visual_planning: COMPLETE
visual_planning: COMPLETE
visual_direction_lock: USER_APPROVED
product_reference_asset: PENDING
overall_plan: COMPLETE
runtime_implementation: MERGED_MAIN
runtime_merge_commit: 8d303f0f9414950273be934fd28c8fb1b3a21e18
canonical_root_runtime_receipt: AUTOMATED_EXACT_HEAD_GREEN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
```

## 3. Verified successor state

### Canon v2 / Composite Result

판정:
- `EXISTING_CANON_V2_RUNTIME_REUSE` 유지.
- `COMPOSITE_RESULT`가 current result authority.
- legacy S/A/B/S grade는 history/mastery compatibility로만 보존.
- PR #224에서 stale current-like S-rank ownership을 realign 완료.

### monthly_state

판정: `IMPLEMENTED_ADDITIVE_OPTIONAL`.

- top-level optional orchestration state.
- legacy report에서 month completion을 추론하지 않는다.
- case truth를 저장하지 않는다.
- 같은 달 해결 뒤 두 번째 main case를 막는다.

### M01 First Session

판정: `IMPLEMENTED / AUTOMATED_REGRESSION_GREEN`.

- 10단계 causal orchestration을 사용한다.
- 조사에서 얻은 기록/규칙을 추리→구출→회수에 재사용한다.
- `correct_response_id` 같은 별도 hidden truth ownership을 orchestrator에 만들지 않는다.
- Human comprehension / serial-exam fatigue 체감은 `NOT_RUN`.

### 메인 메뉴 Ver 4.3 — #181

판정: `IMPLEMENTED / ISSUE_181_CLOSED`.

- `scripts/core/product_version.gd`가 제품 버전 중앙 owner.
- direct `Ver 4.2` ownership 제거.
- 관제실형 3-rail UI 구현.
- Legacy / Validation route 및 save isolation 유지.
- keyboard focus 계약 유지.
- Human/UI usability는 `NOT_RUN`.

### M04 release-near preparation

판정: `SHARED_SYSTEM_BASELINE_IMPLEMENTED / FINAL_VISUAL_GATE_PENDING`.

- M04-specific record/investigation/minigame/recovery IDs를 shared grammar에 연결.
- Composite Result axes 공유.
- M01 truth ID를 M04 current truth로 재사용하지 않는다.
- `PRODUCT_REFERENCE_ASSET_PENDING`, `final_visuals_authorized=false` 유지.

### M04 one-delay preparation ↔ victim-risk trade-off — 2026-08-28

판정: `USER_APPROVED / PLANNING_CANON / IMPLEMENTATION_NOT_AUTHORIZED`.

- 즉시 출동은 위험 `+0`과 준비 이득 없음, 한 번만 지연 출동은 사전 공개된 준비 이득 1개와 피해자 위험 `+15`의 교환이다.
- 4주차 강제 출동 `+30`은 별도·가시적 escalation boundary다.
- 준비 이득은 `D-2026-08-28-M04-ROUTE-MEMORY-ANCHOR-PREPARATION-BENEFIT`의 귀가 기억 고정 강화다. 지연 시 권나래의 기존 능동형 회수 지원은 공포 `-16 → -24`가 되며, 임계치 `+2`·안정화 변화 `0`·타 요원 지원은 바꾸지 않는다.
- Composite Result는 timing causality를 추리·구출·회수 결과와 분리해 설명한다. M01에는 이 선택을 추가하지 않는다.

### M04 route-memory anchor preparation benefit — 2026-08-28

판정: `USER_APPROVED / PLANNING_CANON / IMPLEMENTATION_NOT_AUTHORIZED`.

- M04 한 번 지연 출동에만 적용한다. 출동 확정 전 이득·대상·공포 `-24`·위험 `+15`를 함께 보인다.
- 회수에서 플레이어가 기존 `support_kwon_return_route`를 직접 한 번 선택할 때만 강화한다. 자동 발동·추가 사용·무료 재시도는 없다.
- 이득은 단서·힌트·가설·매뉴얼 정답·구출 절차·회수 전조를 변경하지 않는다. `+15`와 실제 사용 여부·보호 효과는 Composite Result의 별도 timing axis에 남긴다.

### M04 bounded forced-dispatch reachability — 2026-08-28

판정: `USER_APPROVED / PLANNING_CANON / IMPLEMENTATION_NOT_AUTHORIZED`.

- M04에만 2주차 즉시 출동(`+0`) 또는 한 번 준비를 보이고, 준비 뒤 3주차에는 지연 출동(`+15`, 귀가 기억 고정 강화) 또는 보상 없는 출동 보류를 보인다.
- 3주차 출동 보류는 두 번째 준비·추가 이득이 아니며 즉시 4주차 `+30` 강제 출동으로 transition한다. 강제 출동에는 준비 modifier가 없다.
- 현재 `monthly_state_policy`의 2/3/4주차 risk grammar를 재사용하되 M01, 다른 사건, 범용 calendar UI와 post-week-4 transition으로 확장하지 않는다.
- 위험 `+15`/`+30`의 concrete runtime consumer는 아직 `UNSPECIFIED_PENDING_UNIFIED_IMPLEMENTATION_CONTRACT`다. 이 결정은 code/data/Scene/UI/asset mutation이나 balance/runtime/Human QA PASS를 승인하지 않는다.

### Visual direction lock — 2026-08-28

판정: `USER_APPROVED / PLANNING_ONLY`.

- 현실적 한국 도시 누아르 환경 + 애니풍 인물·괴이 + 손그림 기록물 UI의 혼합 문법을 현행 `SOFT_ANIME_NOIR_LOCKED`의 구체화로 채택했다.
- `docs/visual/VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md`의 Keep/Avoid/Do Not Drift가 후속 시각 자료에 적용된다.
- `PROJECT_CORE_SCENE_VISUAL_BOARD`는 AI 이해/기획 검토용 생성 보드다. 자체로 product asset, Godot UI/Scene 구현, target-resolution PASS, Human/Player Experience PASS를 만들지 않는다.

## 4. 자동 검증

PR #224 exact head에서 core/docs, full matrix, Canon v2 migration/runtime UX, ANNUAL/CORE, Windows platform preflight, documentation 및 visual capture 계열이 GREEN이었다.

`Project Base Adapter`의 protected-path fail-closed 신호는 PR #226에서 project-pinned Base generator로 reconciliation 완료했다. protected baseline `6b4a9e8080898536139c8e825179b389f8bf9d64`, reconciliation merge `9073b4730993149f89970a13fbe32d49f8f473e7` 기준으로 adapter 및 Base 9.4.x 검증이 GREEN이다.

## 5. Workspace authority

- Notion: 사람이 보는 전체 그림, Flow, 비교표, 현재 승인 방향과 구현 상태 요약.
- Repository: 구조화 기획 계약, 구현, 테스트, runtime evidence.
- Google Sheet: migration-only legacy inventory.

Notion Home 및 `05 · Production · Validation`에 PR #224 구현 상태와 evidence ceiling을 동기화했다.

## 6. Base authority / governance reconciliation

프로젝트가 채택한 Base 릴리스·payload·trusted evidence·registry hash는 `docs/BASE_RULES_VERSION.md`와 `skills/PROJECT_BASE_ADAPTER.json`이 소유한다.

PR #226에서 공식 Base generator로 snapshot / compatibility views / dashboard를 함께 갱신했고, protected baseline `6b4a9e8080898536139c8e825179b389f8bf9d64`을 merged main에 고정했다. 이 runtime reconciliation 관련 Base governance 후속은 `COMPLETE`다.

## 7. 구현 provenance

완료된 구현의 설계·계획 근거로 다음을 보존한다.
- `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`
- `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

이들은 현재 next-step owner가 아니라 구현 provenance다.

## 8. Issue authority

Issue #181은 merged-main readback 뒤 `completed`로 닫혔다. 새 Issue/PR의 open 상태만으로 구현 권한이나 current truth를 만들지 않는다.

## 9. 다음 검증 진입점

- M01: 실제 First Session comprehension / input / fatigue Human QA.
- M04: product-reference asset 승인 후 release-near player-experience Human QA.
- Base adapter: PR #226 merged-main readback 완료; runtime reconciliation 관련 추가 technical gate 없음.

실행하지 않은 Human·device·visual 검증은 PASS로 승격하지 않는다.
