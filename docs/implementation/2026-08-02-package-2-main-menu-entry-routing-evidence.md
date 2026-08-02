# Package 2 메인 메뉴 진입·이어하기·라우팅 구현 증거

> 상태: `IMPLEMENTATION_MERGED / FINAL_EXACT_HEAD_PASS / POST_MERGE_SYNC`
> 구현 Decision: `D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL`
> Planning PR: #129
> Implementation PR: #131
> Planning merge: `b4d7bd0fb82968325bcf230f3e81b8d96e142402`
> Implementation verified HEAD: `fdd55e367e21d9bc1c031ff2f0c4438289040665`
> Implementation merge: `f8751e7fa7890f402c7377ea6aee64f79ef59911`
> 병합 권한: `EXECUTED`

## 1. 구현 범위

- Legacy·Validation 독립 SCREEN-01 카드
- Validation persistence read-only inspector·summary
- active·suspended·completed 상태별 행동
- blocked persistence 상태의 무변경 상세 표시
- flow-stage allowlist route mapper
- whitelist-only Validation runtime initializer
- 새 시작·명시적 교체·이어하기·완료 기록 coordinator
- single-flight command lock
- 실패 시 runtime rollback·Session abandon
- Legacy save bytes·hidden memory 무부작용 검증
- 상태·교체·완료 read-only dialog와 키보드 focus
- Package 2 focused 5/5와 full regression 58/58

범위 밖:

- SIT-003·SIT-005~008 전용 Scene 상세 구현
- 완료 결과 4축 상세 viewer
- Validation 저장 migration·자동 backup 승격
- Legacy schema 변경
- 모바일 UI
- 전체 게임 기획

## 2. 주요 파일

### Production

- `scripts/core/validation_persistence_summary.gd`
- `scripts/core/validation_persistence_inspector.gd`
- `scripts/core/validation_route_mapper.gd`
- `scripts/core/validation_game_state.gd`
- `scripts/ui/validation_entry_coordinator.gd`
- `scripts/ui/main_menu.gd`

### Tests·CI

- `tests/validation/validation_persistence_summary_test.gd`
- `tests/validation/validation_route_mapper_test.gd`
- `tests/validation/validation_runtime_initializer_test.gd`
- `tests/validation/validation_entry_coordinator_test.gd`
- `tests/validation/validation_main_menu_contract_test.gd`
- `tests/run_validation_package_2_tests.sh`
- `tests/run_godot_regression.sh`
- `tests/test_annual_mvp_001_static_contract.py`
- `.github/workflows/validate-core-mvp-001.yml`
- `.github/workflows/validate-annual-mvp-001.yml`
- `.github/workflows/validate-bca-visual-sheet-adoption.yml`

## 3. TDD RED → GREEN 증거

| Task | RED | 예상 실패 | GREEN·보정 |
|---|---|---|---|
| 1 read-only summary | `1a6cf9dc9c8bc51cef387488d98b0536df0d36d7` | `validation_persistence_summary.gd` 없음 | `544bf580dd9727b542bc27d494b89a124b6062d0`; Package 1 4/4·summary·CORE·53/53 PASS |
| 2 route mapper | `e3395cb765cfae8b343b0a9d214a8caff9411977` | `validation_route_mapper.gd` 없음 | `31e56ab7f0a1b80242aad6263e74993d6602141c`; Package 2 2/2 PASS |
| 3 whitelist initializer | `63bf6d283f13f16be108133552ce1564b48088bd` | `initialize_validation_runtime()` 없음 | `52f78b821282bd395e00542b0e48b7c1ca5a0b71`; Package 2 3/3 PASS |
| 4·5 coordinator | `bc1b769f9df6473348b4b2bdb9cab0f7574aab67` | coordinator 없음 | compile/type 보정과 runner 강화 후 `c91690f41561e24f405c5944808b4eac83fd7534`에서 실제 coordinator PASS |
| 6 SCREEN-01 | `c91690f41561e24f405c5944808b4eac83fd7534` | 독립 카드·dialog·test facade 없음 | `45e022d6ab1bcbc32e698093de961917e2821894`; Package 1 4/4·Package 2 5/5·CORE·53/53 PASS |
| 7 full registration | `e78d6e6f0d0d92f4ae99446729a13d9e9bf03edd` | 신규 5개가 regression runner에 없음 | `e24aac73a81bfb1725c60dd640a26fa91527647a`; CORE·ANNUAL 양쪽 58/58 PASS |

## 4. 적대적 보정

### A. Package 1 autoload 계약 회귀

첫 Task 1 구현은 `ValidationSession` autoload를 subclass facade로 교체했다. Package 1 isolation test가 이를 즉시 실패 처리했다.

보정:

- 기존 `ValidationSession="*res://scripts/core/validation_session.gd"` 유지
- read-only 조회를 독립 `ValidationPersistenceInspector`로 분리
- Package 1 Session lifecycle 본체 무변경

### B. Godot script error의 exit code 0

초기 coordinator 테스트에서 GDScript compile error가 발생했지만 Godot가 종료코드 0을 반환해 runner가 PASS로 오인할 수 있었다.

보정:

- Package 2 focused runner가 `SCRIPT ERROR`, `Failed to load script`, `Parse Error`, `Compile Error`를 탐지하면 실패
- full regression runner에도 같은 탐지 적용
- coordinator의 동적 반환값에 명시적 `Dictionary` 타입 적용
- 이후 실제 coordinator 실행 결과로 재검증

### C. Legacy 초기화 함수 재사용 위험

`restart_afterlife_station_flow()`·`reset_run_state()`는 campaign·관계·보상·경제 상태를 초기화한다.

보정:

- Validation 경로에서 두 함수 호출 없음
- `initialize_validation_runtime()`은 Package 1 runtime whitelist 필드만 초기화
- hidden Legacy snapshot과 Legacy file bytes를 전후 비교

### D. 저장된 scene_path 직접 이동 위험

보정:

- payload `scene_path`를 라우팅 권위로 사용하지 않음
- SIT-001·002 → dialogue, SIT-004 → investigation
- SIT-003·005~008 → `NOT_AVAILABLE`
- unknown → `UNKNOWN_FLOW_STAGE`
- 실패 시 SCREEN-01 잔류·runtime rollback·Session abandon

### E. stacked PR BCA 조건

BCA workflow는 처음에 `main` base PR만 허용해 stacked PR #131에서 실행되지 않았다.

보정:

- stacked 검증 동안 planning base를 임시 허용
- diff 기준을 실제 `github.base_ref`로 변경
- PR #129 병합 후 PR #131을 main으로 retarget
- 임시 planning-base 허용을 제거
- 최종 HEAD에서 BCA를 다시 실행

## 5. 병합 순서와 main 동기화

```yaml
base_v9_4_1_main: 13cf7f1814cd7435c77e99d97ea8b7b7658464e1
main_to_planning_sync_pr: 132
main_to_planning_sync_merge: 181dd690761af7caae3f162235485001b3aefa72
planning_pr: 129
planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
main_to_implementation_sync_pr: 133
main_to_implementation_sync_merge: c7cbec06efa2b3487b2d8fe9e9cab3dd3177f9b6
implementation_pr: 131
implementation_verified_head: fdd55e367e21d9bc1c031ff2f0c4438289040665
implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
```

PR #129은 최신 main을 병합한 후 Documentation·BCA를 새로 통과하고 병합했다. PR #131은 main으로 retarget하고 최신 main을 동기화한 뒤 임시 stacked BCA 조건을 제거했다.

## 6. 최종 exact-head 자동 검증

PR #131 HEAD `fdd55e367e21d9bc1c031ff2f0c4438289040665`에서 다음 검증을 완료한 뒤 expected-head SHA로 병합했다.

### Documentation run `30742092953`

- archive governance: PASS
- Base·core·routing·active references·planning synchronization contracts: PASS

### BCA run `30742092954`

- BCA adoption unit tests: PASS
- `git diff --check origin/main...HEAD`: PASS

### CORE run `30742092974`

- Python contracts: PASS
- Godot 4.7.1 import: PASS
- Package 1 focused: 4/4 PASS
- Package 2 focused: 5/5 PASS
- CORE focused: PASS
- full Godot regression: 58/58 PASS

### ANNUAL run `30742092951`

- annual·active-document Python contracts: PASS
- Godot 4.7.1 import: PASS
- Package 1 focused: 4/4 PASS
- Package 2 focused: 5/5 PASS
- CORE focused: PASS
- ANNUAL-MVP-001 focused: PASS
- ANNUAL-MVP-002 focused: PASS
- full Godot regression: 58/58 PASS

### 병합 직전 감사

```yaml
changed_files: 21_SCOPED
review_threads: 0
submitted_reviews: 0
main_moved_after_planning_merge: false
sheet_same_decision_id: PASS
merge_method: merge
expected_head_sha: fdd55e367e21d9bc1c031ff2f0c4438289040665
```

## 7. 안전 계약 판정

```yaml
read_only_menu_inspection: PASS
blocked_storage_no_mutation: PASS
legacy_file_bytes_no_effect: PASS
legacy_hidden_memory_no_effect: PASS
whitelist_initializer: PASS
flow_stage_allowlist: PASS
unknown_route_fail_closed: PASS
route_failure_runtime_rollback: PASS
session_abandon_on_failure: PASS
single_flight: PASS
completed_view_read_only: PASS
legacy_validation_independent_cards: PASS
keyboard_focus_structure: PASS
```

## 8. 미검증 경계

```yaml
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
screen_01_mouse_manual: NOT_RUN
screen_01_keyboard_manual: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

구조 테스트와 자동 Scene 실행은 사람의 첫 시도 이해도·문구 판독·실제 시각 밀도를 증명하지 않는다.

## 9. 최종 판정

```yaml
package_2_planning: MERGED
package_2_implementation: MERGED
package_2_automated_verification: PASS
package_2_human_validation: NOT_RUN
package_2_status: COMPLETE_WITH_EXPLICIT_UNVERIFIED_BOUNDARIES
```

Package 2는 main에 반영됐다. 다음 작업은 post-merge current docs·Google Sheet 동기화 완료 후 본격 게임 기획 전환이다.
