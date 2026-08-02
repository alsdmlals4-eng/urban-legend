# 괴이기록국 현재 인수인계

> 상태: `PACKAGE_2_MERGED_ON_MAIN / YEAR_ONE_CAMPAIGN_DESIGN_IN_PROGRESS`
> 갱신일: 2026-08-02
> Package 2 Planning PR: #129
> Package 2 Implementation PR: #131
> Package 2 Planning merge: `b4d7bd0fb82968325bcf230f3e81b8d96e142402`
> Package 2 Implementation merge: `f8751e7fa7890f402c7377ea6aee64f79ef59911`
> Year-one campaign Draft PR: #135
> Grill Me future counter: `6 / 10`

실제 최신 main SHA는 GitHub `main` ref에서 읽는다. Package 2 planning과 implementation은 main에 병합됐다. 현재 본격 게임 기획은 Draft PR #135에서 진행 중이며, 구현·Production 확대 권한은 열리지 않았다.

## 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ GitHub latest main ref
→ docs/PROJECT_CORE.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/GRILLME_APPROVAL_MERGE_LEDGER.md
→ docs/planning/2026-08-02-year-one-campaign-master-structure-design.md
→ 1년차 승인 Decision 5개
→ docs/VALIDATION_TARGET_CANON.md
→ 실제 main 코드·테스트
```

## 현재 제품 권위

```text
메인 콘텐츠
= 괴이 사건 진입
→ 조사
→ 기록 비교·가설
→ 위험 검증
→ 회수
→ 안정화·사건 종결
→ 결과·기록·환류
```

일정·육성·동료·장비·연구·기관은 메인 콘텐츠를 준비하고 결과를 되돌리는 지원 계층이다. 일정 보내기 자체를 메인 콘텐츠로 설명하거나 일정으로 사건을 자동 해결해서는 안 된다.

책임 Decision:

- `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`

## 1년차 캠페인 현재 승인

```yaml
planning_priority: APPROVED
design_section_1: APPROVED
design_section_2: APPROVED
design_section_3: APPROVED
design_section_4: IN_REVIEW
quarterly_core_cases: 4_TOTAL_ONE_PER_QUARTER
case_result: STABILIZED_AND_CURRENT_INCIDENT_CLOSED
connection: INDEPENDENT_CASES_STRONG_FEEDBACK_WEAK_META_MYSTERY
feedback_axes: KNOWLEDGE_RELATION_INSTITUTION_FIELD
failure_forward: REQUIRED
quarterly_minigames: DISTINCT_AND_SIMPLE
minigame_human_validation: NOT_RUN
implementation: NOT_AUTHORIZED
production_expansion: NOT_APPROVED
poc_passed: NOT_DECLARED
```

### 분기 역할

```text
봄 — 기준 사건
여름 — 선택 사건
가을 — 충돌 사건
겨울 — 종합 사건
```

### 분기별 미니게임 방향

```text
봄: 순서·경로 복원
여름: 대상·역할 배치
가을: 보호·공개 범위 조절
겨울: 과거 기록 비교·적용
```

제작 목표는 설명 30초·입력 1~2개·기본 1~3분·즉시 실패 이유·빠른 복구·접근성 대체 입력이다. 사람 검증 전에는 달성으로 선언하지 않는다.

## Package 2 구현 상태

```yaml
package_1: MERGED_AND_AUTOMATED_CI_VERIFIED
package_2_product_implementation: MERGED_ON_MAIN
package_2_planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
package_2_implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
```

## 다음 Gate

```text
Design Section 4
— 봄 저승역 채택 여부
— 여름·가을·겨울 핵심 괴담 컨셉 방향
— 각 미니게임이 조사·회수 중 어디에 배치되는지
```
