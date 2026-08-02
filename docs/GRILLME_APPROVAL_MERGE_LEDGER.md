# Grill Me 승인·병합 Ledger

> 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 Batch 1 카운터: `10 / 10`
> 마지막 조정: `YEAR_ONE_RESULT_FEEDBACK_AND_ANNUAL_REVIEW_CONTRACT`
> Batch 상태: `PREMERGE_AUDIT_IN_PROGRESS`
> 갱신일: 2026-08-02

## 카운터 규칙

- 승인된 새 제품 선택 Decision ID 한 개당 1을 더한다.
- 질문·기각·보류·중복·대체 Decision은 더하지 않는다.
- 이미 카운트된 질문의 Design·Spec·구현·병합 후속 Gate는 새 질문이 아니므로 추가하지 않는다.
- 10개에 도달하면 새 질문 진행보다 먼저 merge batch gate를 실행한다.
- batch가 완전히 처리되면 다음 카운터를 0에서 시작한다.
- 병합 불가 Decision은 승인 이력을 삭제하지 않고 `BLOCKED`로 기록한다.
- 사용자가 별도 병합을 명시적으로 승인한 경우 해당 범위만 10개 이전에 병합할 수 있으며 카운터는 리셋하지 않는다.
- audit 통과는 병합 승인이 아니다. 사용자 별도 병합 승인이 필요하다.

## HISTORICAL_BATCH_0

과거 질문 횟수를 추정하지 않고, 현재 유효한 승인 Decision 전체를 정본으로 조정한 역사 batch다.

### Canon 병합

```text
PR: #125
head: b3d38576b37c60fd36c1b7bdc9018803b917c000
merge: 595d45454621900e858a903fef0598a03349b794
result: MERGED
```

승계한 주요 승인:

- `D-2026-07-31-CANON-SHEET-SYNC`
- `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION`
- `D-2026-07-31-VISUAL-ART-DIRECTION`
- `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY`
- `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS`
- `D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION`
- `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE`
- `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS`
- `D-2026-08-01-SCHEDULE-REST-SEMANTICS`
- `D-2026-08-01-PROVISIONING-AUTHORITY`
- `D-2026-08-01-VALIDATION-SCOPE-FILTER`
- `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE`
- `D-2026-08-01-VALIDATION-RESULT-AXES`
- `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION`
- `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL`
- `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL`
- `D-2026-08-01-LEGACY-PR-DISPOSITION`
- `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
- `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL`
- `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`
- `D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL`
- `D-2026-08-02-PACKAGE-1-IMPLEMENTATION-APPROVAL`

이 목록은 질문 횟수 카운터가 아니라 현재 승인 정본의 역사 reconciliation 목록이다.

### 구현 병합

```text
PR: #126
retargeted head: dd5832857a19854827944f521a2a3684c1380d78
merge: 80160218d05e79af5442bf27d8fdeb66bcf05723
result: MERGED
```

검증:

- Documentation contracts: success
- BCA Adoption: success
- CORE workflow: success
- ANNUAL workflow: success
- Validation focused: 4/4
- full Godot regression: 53/53

### 제외

```text
PR #122 = SOURCE / DO NOT MERGE AS-IS
```

PR #122는 provenance를 보존하는 source branch이며 현재 정본이 아니다. 유효 승인 내용은 PR #125로 승계했고 PR 자체는 병합 대상에서 제외했다.

### 증거 한계

```yaml
human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## GRILLME_BATCH_1 — 10/10 감사 중

```yaml
counter: 10 / 10
automatic_batch_triggered: true
batch_audit: IN_PROGRESS
separate_merge_authorized: false
package_2_separate_merge_authorized: true
package_2_planning_pr: 129
package_2_implementation_pr: 131
package_2_planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
package_2_implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
year_one_planning_pr: 135
year_one_planning_pr_state: DRAFT_UNMERGED
year_one_main_sync_pr: 138
year_one_main_sync_merge: cc25991ba6b74b3c3f552c84e90d40987595fa82
year_one_implementation: NOT_AUTHORIZED
next_counter: PENDING_BATCH_COMPLETION
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
   - 승인: 메인 콘텐츠는 `텍스트 노벨 조사 → 피해자 구출 → 턴제 회수 전투`
   - 일정·육성·동료·장비·연구·기관은 지원·준비·환류 계층
   - 상태: `CURRENT_APPROVED_PRODUCT_AUTHORITY`

7. `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`
   - 승인: 조사=`상황 설명→조건 표시 선택지`, 플레이어 노출 패널=`괴이 매뉴얼`
   - 승인: 구출 미니게임은 피해자 구출, 회수 전투는 괴이 단독 중심 전장
   - 승인: 아군은 하단 HUD, 스킬 사용 시에만 짧은 하단 컷인
   - 상태: `APPROVED_PROVISIONAL_UX_BASELINE / HUMAN_VALIDATION_NOT_RUN`

8. `D-2026-08-02-YEAR-ONE-FOUR-CORE-CASES-AND-QUARTER-PLACEMENT`
   - 승인: 봄 저승역·여름 비 오는 골목의 빨간 우산·가을 폐주파수 방송국·겨울 기록되지 않은 병동
   - 승인: 독립 규칙과 안정화 결말, 동일 흑막 금지
   - 상태: `APPROVED_DESIGN_SECTION_4 / CONTENT_AND_HUMAN_VALIDATION_NOT_RUN`

9. `D-2026-08-02-YEAR-ONE-CASE-PLAY-DIFFERENTIATION-CONTRACT`
   - 승인: 저승역=순서, 빨간 우산=전이, 폐주파수=응답, 기록되지 않은 병동=기록 권위
   - 승인: 객관적 진실 고정·구출 결과 전투 반영·공격 반복 승리 금지
   - 상태: `APPROVED_DESIGN_SECTION_5 / PLAYABILITY_VALIDATION_NOT_RUN`

10. `D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT`
   - 승인: 종결 상태 + 지식·관계/기관·현장 결과 패킷
   - 승인: 다음 분기 최소 2축·겨울 3축·축별 주 결과 최대 1개 활성
   - 승인: 기관 강제 봉쇄는 실패 전진이지만 완전 해결이 아님
   - 승인: 연말은 단일 점수가 아닌 조사 성향·보호 원칙·기관 위치·남은 책임의 복합 기록
   - 승인: 2년차 대표 결과 제한 계승과 전체 기록 보존
   - 상태: `APPROVED_DESIGN_SECTION_6 / VALIDATION_NOT_RUN`

### Package 2 후속 Gate — 카운트 제외

- `D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL`
- `D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL`
- `D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL`
- 사용자 `병합 승인`

동일 질문의 후속 Gate이므로 별도 카운트하지 않았다.

### Package 2 병합 이력

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
```

### Package 2 최종 exact-head 자동 검증

```yaml
documentation_run_30742092953: PASS
bca_run_30742092954: PASS
core_run_30742092974: PASS
annual_run_30742092951: PASS
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
review_threads: 0
submitted_reviews: 0
changed_files: 21_SCOPED
```

### Batch 1 사전 병합 감사

책임 원본:

- `docs/audits/2026-08-02-grillme-batch-1-premerge-audit.md`

초기 감사에서 다음 보완을 확인했다.

- planning branch가 main보다 2커밋 뒤처짐
- Base 9.4.1 표기가 최신 9.4.3과 불일치
- 현재 결정·인수인계·Ledger 패치가 과거 승인과 Package 2 보호 근거를 삭제
- Section 3·메인 콘텐츠 Decision이 피해자 구출·회수 전투 구체화 이전 표현을 유지
- Section 6·10/10 GitHub·Sheet 동기화 미완료

진행한 보완:

- PR #138로 main→planning 동기화
- Section 3·메인 콘텐츠 Decision 교정
- current docs를 최신 main 기반으로 재구성해 역사와 보호 계약 보존
- Section 6 Decision·Design 반영

남은 Gate:

- Google Sheet Section 6·10/10 동기화
- PR 본문과 최신 HEAD 갱신
- 최신 HEAD CI·diff·review·base/head 재감사
- 최종 판정 기록

## 현재 미검증 경계

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
year_one_campaign_poc: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 다음 Gate

```text
최신 HEAD CI·diff·review·Sheet 재감사
→ READY_FOR_SEPARATE_MERGE_APPROVAL / CHANGES_REQUIRED / BLOCKED
→ 사용자 별도 병합 승인
→ PR #135 main 병합
→ post-merge current docs·Sheet 동기화
→ GRILLME_BATCH_2 counter 0/10 시작
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
