# Grill Me 승인·병합 Ledger

> 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 미래 카운터: `7 / 10`
> 마지막 조정: `CORE_GAMEPLAY_SCREEN_PRESENTATION_BASELINE`
> 갱신일: 2026-08-02

## 카운터 규칙

- 승인된 새 제품 선택 Decision ID 한 개당 1을 더한다.
- 질문·기각·보류·중복·대체 Decision은 더하지 않는다.
- 이미 카운트된 질문의 Design·Spec·구현·병합 후속 Gate는 새 질문이 아니므로 추가하지 않는다.
- 10개에 도달하면 새 질문 진행보다 먼저 merge batch gate를 실행한다.
- batch가 완전히 처리되면 다음 카운터를 0에서 시작한다.
- 병합 불가 Decision은 승인 이력을 삭제하지 않고 `BLOCKED`로 기록한다.
- 사용자가 별도 병합을 명시적으로 승인한 경우 해당 범위만 10개 이전에 병합할 수 있으며 카운터는 리셋하지 않는다.

## HISTORICAL_BATCH_0

과거 질문 횟수를 추정하지 않고 당시 유효 승인 Decision 전체를 정본으로 조정한 역사 batch다.

```yaml
canon_pr: 125
canon_merge: 595d45454621900e858a903fef0598a03349b794
implementation_pr: 126
implementation_merge: 80160218d05e79af5442bf27d8fdeb66bcf05723
source_pr_122: CLOSED_DO_NOT_MERGE_AS_IS
package_1_focused: 4_OF_4_PASS
full_godot_regression: 53_OF_53_PASS
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## GRILLME_BATCH_1 — 누적 중

```yaml
counter: 7 / 10
automatic_batch_triggered: false
package_2_separate_merge_authorized: true
package_2_planning_pr: 129
package_2_implementation_pr: 131
package_2_planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
package_2_implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
year_one_planning_pr: 135
year_one_planning_pr_state: DRAFT_IN_PROGRESS
year_one_implementation: NOT_AUTHORIZED
next_counter: 7 / 10
```

### 승인 Decision

1. `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
   - 승인: Legacy·Validation 독립 병렬 카드
   - 상태: `MERGED_AND_IMPLEMENTED`
   - 책임 원본: `docs/decisions/D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY.md`
   - 추적: PR #129·#131, Google Sheet 동일 Decision ID

2. `D-2026-08-02-YEAR-ONE-CAMPAIGN-MASTER-STRUCTURE-FIRST`
   - 승인: 개별 사건·세부 시스템보다 1년차 4분기 마스터 구조를 먼저 설계
   - 상태: `APPROVED_PLANNING_PRIORITY`
   - 책임 원본: Decision·PR #135·Sheet

3. `D-2026-08-02-YEAR-ONE-CAMPAIGN-PURPOSE-AND-QUARTERLY-CASE`
   - 승인: 봄·여름·가을·겨울 성장 축과 분기당 핵심 괴담 1개
   - 정본 용어: 제거=`안정화 상태 + 현재 사건 종결`
   - 상태: `APPROVED_DESIGN_SECTION_1`

4. `D-2026-08-02-YEAR-ONE-QUARTERLY-CASE-ROLE-AND-FEEDBACK`
   - 승인: 독립 사건 4개 + 강한 결과 환류 + 약한 공통 미스터리
   - 환류: 지식·관계/기관·현장 3축, 실패 전진
   - 상태: `APPROVED_DESIGN_SECTION_2`

5. `D-2026-08-02-YEAR-ONE-QUARTERLY-SIMPLE-MINIGAME-VARIATION`
   - 승인: 분기마다 서로 다른 초간단 피해자 구출 미니게임
   - 제한: 설명 30초·입력 1~2개·기본 1~3분·즉시 실패 이유·접근성 대체
   - 상태: `APPROVED_DESIGN_SECTION_3 / HUMAN_VALIDATION_NOT_RUN`

6. `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
   - 승인: 메인 콘텐츠는 괴이 사건의 조사·피해자 구출·회수 전투
   - 일정·육성·동료·장비·연구·기관은 지원·준비·환류 계층
   - 상태: `CURRENT_APPROVED_PRODUCT_AUTHORITY`

7. `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`
   - 승인: 조사=`상황 설명→조건 표시 선택지`, 플레이어 노출 패널=`괴이 매뉴얼`
   - 승인: 구출 미니게임은 피해자 구출, 회수 전투는 괴이 단독 중심 전장
   - 승인: 아군은 하단 HUD, 스킬 사용 시에만 짧은 하단 컷인
   - 상태: `APPROVED_PROVISIONAL_UX_BASELINE / HUMAN_VALIDATION_NOT_RUN`

### Package 2 후속 Gate — 카운트 제외

- `D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL`
- `D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL`
- `D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL`
- 사용자 `병합 승인`

동일 질문의 후속 Gate이므로 별도 카운트하지 않았다.

### Package 2 병합·검증 이력

```yaml
main_before_package_2: 13cf7f1814cd7435c77e99d97ea8b7b7658464e1
main_to_planning_sync_pr: 132
main_to_planning_sync_merge: 181dd690761af7caae3f162235485001b3aefa72
planning_pr: 129
planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
main_to_implementation_sync_pr: 133
main_to_implementation_sync_merge: c7cbec06efa2b3487b2d8fe9e9cab3dd3177f9b6
implementation_pr: 131
implementation_verified_head: fdd55e367e21d9bc1c031ff2f0c4438289040665
implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
documentation_run_30742092953: PASS
bca_run_30742092954: PASS
core_run_30742092974: PASS
annual_run_30742092951: PASS
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
review_threads: 0
submitted_reviews: 0
```

## 현재 미검증 경계

```yaml
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
core_gameplay_screen_human_validation: NOT_RUN
investigation_choice_readability: NOT_RUN
manual_state_comprehension: NOT_RUN
battle_enemy_focus_readability: NOT_RUN
skill_cut_in_interruption: NOT_RUN
year_one_minigame_first_30_seconds: NOT_RUN
year_one_minigame_accessibility: NOT_RUN
year_one_campaign_poc: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 다음 Gate

```text
현재 counter 7/10
→ 기존 세 괴담과 신규 네 번째 후보를 동일 핵심 구조로 적대적 검토
→ Design Section 4: 네 핵심 괴담 선정과 분기 배치
→ 10/10 도달 시 적대적 batch audit와 별도 merge 승인
```

## Future Batch Template

```markdown
## GRILLME_BATCH_<N>

- counter range: 1..10
- Decision IDs:
- canon PR/head:
- implementation PR/head:
- pre-merge main:
- GitHub audit:
- Sheet ranges:
- CI:
- merge SHA(s):
- blocked/excluded:
- unverified:
- next counter: 0 / 10
```
