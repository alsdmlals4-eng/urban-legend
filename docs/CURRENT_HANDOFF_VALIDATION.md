# 괴이기록국 현재 인수인계

> 상태: `PACKAGE_2_MERGED_AND_VERIFIED / YEAR_ONE_DESIGN_MERGED_ON_MAIN / GRILLME_BATCH_2_OPEN`
> 갱신일: 2026-08-02
> Base: `9.4.3`
> Package 2 Planning PR: #129
> Package 2 Implementation PR: #131
> Package 2 Planning merge: `b4d7bd0fb82968325bcf230f3e81b8d96e142402`
> Package 2 Implementation merge: `f8751e7fa7890f402c7377ea6aee64f79ef59911`
> Year-one campaign Design PR: #135
> Year-one campaign Design merge: `7bddbce2ebd427154cdeb8e4bb9b7aec06e2ea5e`
> Year-one verified head: `a009732ab6162bdfc018da792e7e0414c342e7f5`
> main→planning sync PR: #138 / merge `cc25991ba6b74b3c3f552c84e90d40987595fa82`
> Grill Me Batch 1: `COMPLETE / 10_OF_10 / MERGED`
> Grill Me Batch 2: `0 / 10`

실제 최신 main SHA는 GitHub `main` ref에서 읽는다. Package 2 planning·implementation과 1년차 캠페인 Design은 main에 병합됐다. 문서 병합은 구현·사람 검증·POC·Production 확대 권한을 열지 않는다.

## 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ GitHub latest main ref
→ skills/PROJECT_BASE_ADAPTER.json
→ docs/PROJECT_CORE.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/GRILLME_APPROVAL_MERGE_LEDGER.md
→ docs/planning/2026-08-02-year-one-campaign-master-structure-design.md
→ 1년차 승인 Decision 9개
→ docs/audits/2026-08-02-grillme-batch-1-premerge-audit.md
→ Package 2 Design·Plan·Evidence
→ 실제 main 코드·테스트
```

## 현재 상태

```yaml
base: 9.4.3
package_1: MERGED_AND_AUTOMATED_CI_VERIFIED
package_2_planning_audit: COMPLETE
package_2_menu_hierarchy: MERGED_PARALLEL_INDEPENDENT_CARDS
package_2_design: MERGED
package_2_spec: MERGED
package_2_implementation_plan: MERGED_AND_EXECUTED
package_2_product_implementation: MERGED_ON_MAIN
package_2_planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
package_2_implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
package_2_final_exact_head: PASS
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
year_one_design_sections_1_to_6: MERGED_ON_MAIN
year_one_design_pr: 135
year_one_design_merge: 7bddbce2ebd427154cdeb8e4bb9b7aec06e2ea5e
year_one_verified_head: a009732ab6162bdfc018da792e7e0414c342e7f5
year_one_main_sync: MERGED_PR_138
year_one_design_spec: NOT_WRITTEN
year_one_implementation: NOT_AUTHORIZED
grillme_batch_1: COMPLETE_MERGED
grillme_batch_2: 0_OF_10
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
core_gameplay_screen_human_validation: NOT_RUN
four_case_content_validation: NOT_RUN
result_feedback_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
platform: PC_16_9_MOUSE_KEYBOARD
mobile: DEFERRED_AFTER_PC_VALIDATION
```

# Part A — Package 2 구현 인수인계

## 구현된 SCREEN-01 구조

```text
기존 진행 카드
- 새 캠페인
- 이어하기
- Legacy 저장 상태

Validation 기록 카드
- 새 기록 시작
- 이어하기
- 완료 기록 보기
- 오류·호환 상태
```

Validation badge는 `본편과 별도 기록`을 명시한다. 한쪽 저장 오류는 다른 카드 행동을 차단하지 않는다.

## 구현 컴포넌트

1. `ValidationPersistenceSummary`
   - repository code와 lifecycle을 UI 행동으로 변환
   - payload 전체를 UI에 노출하지 않음

2. `ValidationPersistenceInspector`
   - menu render용 read-only repository 조회
   - Package 1 `ValidationSession` autoload 경계 유지

3. `ValidationRouteMapper`
   - SIT-001·002 → dialogue
   - SIT-004 → investigation
   - SIT-003·005~008 → `NOT_AVAILABLE`
   - unknown → `UNKNOWN_FLOW_STAGE`

4. `initialize_validation_runtime()`
   - Validation runtime whitelist만 초기화
   - campaign·관계·보상·경제·Legacy file 무변경

5. `ValidationEntryCoordinator`
   - create·activate·guard·initialize·save·route
   - record identity 재확인 후 교체
   - active·suspended 이어하기
   - completed read-only summary
   - single-flight
   - 실패 시 runtime rollback·Session abandon

6. SCREEN-01 UI
   - Legacy·Validation 독립 카드
   - status·replace·completed dialog
   - 파괴적 교체 기본 포커스 취소
   - keyboard focus neighbor

## Package 2 최종 exact-head 자동 검증

PR #131 최종 HEAD `fdd55e367e21d9bc1c031ff2f0c4438289040665`에서 다음을 확인한 뒤 expected-head SHA로 병합했다.

```yaml
documentation_run_30742092953: PASS
bca_run_30742092954: PASS
core_run_30742092974: PASS
annual_run_30742092951: PASS
godot_import: PASS
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
core_focused: PASS
annual_001_focused: PASS
annual_002_focused: PASS
full_godot_regression: 58_OF_58_PASS
review_threads: 0
submitted_reviews: 0
changed_files: 21_SCOPED
```

TDD RED·GREEN·적대적 보정 상세:

`docs/implementation/2026-08-02-package-2-main-menu-entry-routing-evidence.md`

## 필수 보호 계약 판정

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

Package 2 책임 문서:

- `docs/decisions/D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY.md`
- `docs/decisions/D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL.md`
- `docs/decisions/D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL.md`
- `docs/decisions/D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL.md`
- `docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md`
- `docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`
- `docs/implementation/2026-08-02-package-2-main-menu-entry-routing-evidence.md`

# Part B — 1년차 캠페인 Design 인수인계

## 현재 제품 권위

```text
괴이 사건 진입
→ 텍스트 노벨 조사
→ 상황 설명과 조건 표시 선택지
→ 키워드 획득·괴이 매뉴얼 구성
→ 피해자 구출 미니게임
→ 턴제 회수 전투
→ 안정화·봉쇄·잔향 회수
→ 결과·기록·다음 분기 환류
```

일정·육성·동료·장비·연구·기관은 준비·지원·환류 계층이다. 일정으로 사건을 자동 해결하거나 조사·구출·회수 전투의 정답을 대신해서는 안 된다.

## 승인된 분기 구조

| 분기 | 핵심 괴담 | 역할 | 대표 위협 문법 | 피해자 구출 문법 |
|---|---|---|---|---|
| 봄 | 저승역 | 기준 사건 | 순서와 이동 시점 | 순서·경로 복원 |
| 여름 | 비 오는 골목의 빨간 우산 | 선택 사건 | 대상과 역할의 전이 | 대상·역할 배치 |
| 가을 | 폐주파수 방송국 | 충돌 사건 | 응답과 송수신 구간 | 보호 범위·반환 대상 조절 |
| 겨울 | 기록되지 않은 병동 | 종합 사건 | 기록 권위와 존재 대체 | 기록 비교·모순 보존·복구 순서 |

- 각 사건은 독립된 규칙과 안정화 결말을 가진다.
- 동일 흑막·동일 괴이 분신으로 통합하지 않는다.
- 다음 분기는 이전 결과 최소 2축, 겨울은 지식·관계/기관·현장 3축 모두 사용한다.
- 과거 성공은 현재 괴담 정답을 공개하지 않고, 실패는 필수 진행을 잠그지 않는다.

## 결과 환류·연도 결산

사건 종결 상태:

- 정밀 안정화
- 안정화
- 불완전 안정화
- 기관 강제 봉쇄

결과 패킷:

- 지식
- 관계·기관
- 현장

연말은 단일 점수·S등급이 아니라 다음 복합 요원 기록으로 표현한다.

```text
조사 성향
+ 피해자 보호 원칙
+ 기관 내 위치
+ 남은 책임
```

2년차 초반 직접 활성화는 지식 1개·관계/기관 1개·현장 1개·요원 성향 기록으로 제한하되, 나머지 사건 보고서·괴이 매뉴얼·피해·책임은 삭제하지 않는다.

## 1년차 책임 Decision

1. `D-2026-08-02-YEAR-ONE-CAMPAIGN-MASTER-STRUCTURE-FIRST`
2. `D-2026-08-02-YEAR-ONE-CAMPAIGN-PURPOSE-AND-QUARTERLY-CASE`
3. `D-2026-08-02-YEAR-ONE-QUARTERLY-CASE-ROLE-AND-FEEDBACK`
4. `D-2026-08-02-YEAR-ONE-QUARTERLY-SIMPLE-MINIGAME-VARIATION`
5. `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
6. `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`
7. `D-2026-08-02-YEAR-ONE-FOUR-CORE-CASES-AND-QUARTER-PLACEMENT`
8. `D-2026-08-02-YEAR-ONE-CASE-PLAY-DIFFERENTIATION-CONTRACT`
9. `D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT`

## 1년차 exact-head 검증·병합

```yaml
planning_pr: 135
verified_head: a009732ab6162bdfc018da792e7e0414c342e7f5
merge: 7bddbce2ebd427154cdeb8e4bb9b7aec06e2ea5e
documentation_contracts_run_30750849552: PASS
bca_adoption_run_30750849578: PASS
core_mvp_run_30750849570: PASS
annual_mvp_run_30750849589: PASS
changed_files: 14_DOCS_ONLY
review_threads: 0
submitted_reviews: 0
conversation_comments: 0
```

## GitHub 상태

```yaml
pr_125: MERGED
pr_126: MERGED
pr_127: MERGED
pr_129: MERGED
pr_131: MERGED
pr_132: MERGED_MAIN_TO_PLANNING_SYNC
pr_133: MERGED_MAIN_TO_IMPLEMENTATION_SYNC
pr_138: MERGED_MAIN_TO_YEAR_ONE_PLANNING_SYNC
pr_135: MERGED_YEAR_ONE_DESIGN
pr_122: CLOSED_SOURCE_DO_NOT_MERGE_AS_IS
issue_121: CLOSED_COMPLETED
main_to_year_one_planning_sync_merge: cc25991ba6b74b3c3f552c84e90d40987595fa82
year_one_design_merge: 7bddbce2ebd427154cdeb8e4bb9b7aec06e2ea5e
```

## Grill Me 운영

- Batch 1: `COMPLETE / 10_OF_10 / MERGED`
- Batch 2: `0 / 10`
- 동일 질문의 Design·Spec·구현·병합 후속 Gate는 새 질문이 아니면 Batch 2에 추가하지 않는다.

## 다음 Gate

```text
GRILLME_BATCH_2 counter 0/10
→ 다음 중요 제품 결정을 새 Decision ID로 기록
→ Design Spec·개별 사건 Spec은 별도 사용자 승인 뒤 작성
→ 구현 계획·코드·사람 검증·POC·Production 확대는 각각 별도 Gate
```

## 미검증 경계

```yaml
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
screen_01_mouse_manual: NOT_RUN
screen_01_keyboard_manual: NOT_RUN
core_gameplay_screen_human_validation: NOT_RUN
investigation_choice_readability: NOT_RUN
manual_state_comprehension: NOT_RUN
battle_enemy_focus_readability: NOT_RUN
skill_cut_in_interruption: NOT_RUN
year_one_minigame_first_30_seconds: NOT_RUN
year_one_minigame_accessibility: NOT_RUN
four_case_content_validation: NOT_RUN
case_play_differentiation_validation: NOT_RUN
result_feedback_playability: NOT_RUN
annual_review_comprehension: NOT_RUN
unrecorded_ward_playability: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
