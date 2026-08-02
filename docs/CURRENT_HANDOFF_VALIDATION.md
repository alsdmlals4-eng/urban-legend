# 괴이기록국 현재 인수인계

> 상태: `PACKAGE_2_MERGED_ON_MAIN / YEAR_ONE_SECTION_4_APPROVED`
> 갱신일: 2026-08-02
> Package 2 Planning PR: #129
> Package 2 Implementation PR: #131
> Package 2 Planning merge: `b4d7bd0fb82968325bcf230f3e81b8d96e142402`
> Package 2 Implementation merge: `f8751e7fa7890f402c7377ea6aee64f79ef59911`
> Year-one campaign Draft PR: #135
> Grill Me future counter: `8 / 10`

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
→ 1년차 승인 Decision 7개
→ docs/VALIDATION_TARGET_CANON.md
→ 실제 main 코드·테스트
```

## 현재 제품 권위

```text
메인 콘텐츠
= 괴이 사건 진입
→ 텍스트 노벨 조사
→ 상황 설명과 조건 표시 선택지
→ 키워드 획득
→ 괴이 매뉴얼 후보 규칙 구성
→ 피해자 구출 미니게임
→ 턴제 회수 전투
→ 안정화·봉쇄·잔향 회수
→ 결과·기록·환류
```

일정·육성·동료·장비·연구·기관은 메인 콘텐츠를 준비하고 결과를 되돌리는 지원 계층이다. 일정 보내기 자체를 메인 콘텐츠로 설명하거나 일정으로 사건을 자동 해결해서는 안 된다.

책임 Decision:

- `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
- `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`

## 1년차 캠페인 현재 승인

```yaml
planning_priority: APPROVED
design_section_1: APPROVED
design_section_2: APPROVED
design_section_3: APPROVED
design_section_4: APPROVED
quarterly_core_cases: 4_TOTAL_ONE_PER_QUARTER
spring_core_case: AFTERLIFE_STATION
summer_core_case: RED_UMBRELLA_ALLEY
autumn_core_case: DEAD_FREQUENCY_STATION
winter_core_case: UNRECORDED_WARD
case_result: STABILIZED_AND_CURRENT_INCIDENT_CLOSED
connection: INDEPENDENT_CASES_STRONG_FEEDBACK_WEAK_META_MYSTERY
feedback_axes: KNOWLEDGE_RELATION_INSTITUTION_FIELD
failure_forward: REQUIRED
quarterly_minigames: DISTINCT_AND_SIMPLE_VICTIM_RESCUE
minigame_human_validation: NOT_RUN
four_case_content_validation: NOT_RUN
unrecorded_ward_playability: NOT_RUN
implementation: NOT_AUTHORIZED
production_expansion: NOT_APPROVED
poc_passed: NOT_DECLARED
```

### 분기 배치

| 분기 | 핵심 괴담 | 역할 | 피해자 구출 문법 |
|---|---|---|---|
| 봄 | 저승역 | 기준 사건 | 공식 기준 기반 순서·경로 복원 |
| 여름 | 비 오는 골목의 빨간 우산 | 선택 사건 | 반사 차단·우산 격리·호위 역할 배치 |
| 가을 | 폐주파수 방송국 | 충돌 사건 | 보호 범위·무음 구간·반환 대상 조절 |
| 겨울 | 기록되지 않은 병동 | 종합 사건 | 과거 기록 비교·모순 보존·복구 절차 선택 |

네 사건은 동일 흑막이나 동일 괴이의 분신이 아니다. 약한 공통 질문은 기억·감정뿐 아니라 인간의 기록과 대응 절차도 괴이의 경계와 행동에 영향을 주는가로 제한한다.

### 적대적 보호

- 저승역과 빨간 우산을 동일한 경로 퍼즐로 만들지 않는다.
- 폐주파수 방송국을 무음 맞추기만으로 끝내지 않고 즉시 차단과 피해자 목소리 반환의 책임 충돌을 포함한다.
- 기록되지 않은 병동을 서류 정리로 만들지 않고 피해자 현장 변화와 능동적인 회수 전투를 필수로 둔다.
- 겨울 성공으로 이전 피해·관계 갈등·기관 책임을 자동 삭제하지 않는다.

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
Design Section 5
— 네 사건 각각의 조사 키워드와 괴이 매뉴얼 문장 구조
— 피해자 구출 미니게임의 사건별 차별화
— 회수 전투의 관찰·대응·공격·봉쇄 차별화
— 실패가 전투와 다음 분기에 남기는 결과
```
