# Grill Me 승인·병합 Ledger

> 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 Batch: `GRILLME_BATCH_3`
> 현재 카운터: `0 / 10`
> 마지막 조정: `GRILLME_BATCH_2_MERGED_AND_CLOSED`
> 갱신일: 2026-08-03

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

과거 질문 횟수를 추정하지 않고 당시 유효한 승인 Decision 전체를 정본으로 조정한 역사 batch다.

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

## GRILLME_BATCH_1 — COMPLETE / MERGED

```yaml
counter: 10 / 10
automatic_batch_triggered: true
batch_audit: COMPLETE
separate_merge_authorized: true
package_2_separate_merge_authorized: true
package_2_planning_pr: 129
package_2_implementation_pr: 131
package_2_planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
package_2_implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
year_one_planning_pr: 135
year_one_verified_head: a009732ab6162bdfc018da792e7e0414c342e7f5
year_one_design_merge: 7bddbce2ebd427154cdeb8e4bb9b7aec06e2ea5e
year_one_main_sync_pr: 138
year_one_main_sync_merge: cc25991ba6b74b3c3f552c84e90d40987595fa82
year_one_implementation: NOT_AUTHORIZED
next_batch: GRILLME_BATCH_2
next_counter: 0 / 10
```

### 승인 Decision

1. `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
   - 승인: Legacy·Validation 독립 병렬 카드
   - 상태: `MERGED_AND_IMPLEMENTED`
   - 책임 원본: `docs/decisions/D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY.md`
   - 추적: PR #129·#131, Google Sheet 동일 Decision ID

2. `D-2026-08-02-YEAR-ONE-CAMPAIGN-MASTER-STRUCTURE-FIRST`
   - 승인: 개별 사건·세부 시스템보다 1년차 4분기 마스터 구조를 먼저 설계
   - 상태: `MERGED_APPROVED_PLANNING_PRIORITY`

3. `D-2026-08-02-YEAR-ONE-CAMPAIGN-PURPOSE-AND-QUARTERLY-CASE`
   - 승인: 봄·여름·가을·겨울 성장 축과 분기당 핵심 괴담 1개
   - 정본 용어: 제거=`안정화 상태 + 현재 사건 종결`
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_1`

4. `D-2026-08-02-YEAR-ONE-QUARTERLY-CASE-ROLE-AND-FEEDBACK`
   - 승인: 독립 사건 4개 + 강한 결과 환류 + 약한 공통 미스터리
   - 환류: 지식·관계/기관·현장 3축, 실패 전진
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_2`

5. `D-2026-08-02-YEAR-ONE-QUARTERLY-SIMPLE-MINIGAME-VARIATION`
   - 승인: 분기마다 서로 다른 초간단 피해자 구출 미니게임
   - 제한: 설명 30초·입력 1~2개·기본 1~3분·즉시 실패 이유·접근성 대체
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_3 / HUMAN_VALIDATION_NOT_RUN`

6. `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
   - 승인: 메인 콘텐츠는 `텍스트 노벨 조사 → 피해자 구출 → 턴제 회수 전투`
   - 일정·육성·동료·장비·연구·기관은 지원·준비·환류 계층
   - 상태: `MERGED_CURRENT_APPROVED_PRODUCT_AUTHORITY`

7. `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`
   - 승인: 조사=`상황 설명→조건 표시 선택지`, 플레이어 노출 패널=`괴이 매뉴얼`
   - 승인: 구출 미니게임은 피해자 구출, 회수 전투는 괴이 단독 중심 전장
   - 승인: 아군은 하단 HUD, 스킬 사용 시에만 짧은 하단 컷인
   - 상태: `MERGED_APPROVED_PROVISIONAL_UX_BASELINE / HUMAN_VALIDATION_NOT_RUN`

8. `D-2026-08-02-YEAR-ONE-FOUR-CORE-CASES-AND-QUARTER-PLACEMENT`
   - 승인: 봄 저승역·여름 비 오는 골목의 빨간 우산·가을 폐주파수 방송국·겨울 기록되지 않은 병동
   - 승인: 독립 규칙과 안정화 결말, 동일 흑막 금지
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_4 / CONTENT_AND_HUMAN_VALIDATION_NOT_RUN`

9. `D-2026-08-02-YEAR-ONE-CASE-PLAY-DIFFERENTIATION-CONTRACT`
   - 승인: 저승역=순서, 빨간 우산=전이, 폐주파수 방송국=응답, 기록되지 않은 병동=기록 권위
   - 승인: 객관적 진실 고정·구출 결과 전투 반영·공격 반복 승리 금지
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_5 / PLAYABILITY_VALIDATION_NOT_RUN`

10. `D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT`
   - 승인: 종결 상태 + 지식·관계/기관·현장 결과 패킷
   - 승인: 다음 분기 최소 2축·겨울 3축·축별 주 결과 최대 1개 활성
   - 승인: 기관 강제 봉쇄는 실패 전진이지만 완전 해결이 아님
   - 승인: 연말은 단일 점수가 아닌 조사 성향·보호 원칙·기관 위치·남은 책임의 복합 기록
   - 승인: 2년차 대표 결과 제한 계승과 전체 기록 보존
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_6 / VALIDATION_NOT_RUN`

### Package 2 후속 Gate — 카운트 제외

- `D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL`
- `D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL`
- `D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL`
- 사용자 Package 2 `병합 승인`

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

### Batch 1 적대적 병합 감사

책임 원본:

- `docs/audits/2026-08-02-grillme-batch-1-premerge-audit.md`

초기 판정: `CHANGES_REQUIRED`

보완한 항목:

- planning branch의 main 2커밋 지연
- Base 9.4.1과 최신 9.4.3 불일치
- current docs의 과거 승인·Package 2 보호 근거 손실 위험
- 구형 미니게임·회수 역할 표현
- Section 6·10/10 GitHub·Sheet 동기화 누락

최종 판정: `READY_FOR_SEPARATE_MERGE_APPROVAL`

### Batch 1 최종 exact-head 검증·병합

```yaml
verified_head: a009732ab6162bdfc018da792e7e0414c342e7f5
documentation_contracts_run_30750849552: PASS
bca_adoption_run_30750849578: PASS
core_mvp_run_30750849570: PASS
annual_mvp_run_30750849589: PASS
changed_files: 14_DOCS_ONLY
review_threads: 0
submitted_reviews: 0
conversation_comments: 0
user_merge_authorization: GRANTED
merge: 7bddbce2ebd427154cdeb8e4bb9b7aec06e2ea5e
result: MERGED
```

## GRILLME_BATCH_2 — COMPLETE / MERGED

```yaml
counter: 10 / 10
automatic_batch_triggered: true
batch_audit: PASS_AFTER_CORRECTIONS
separate_merge_authorized: true
planning_pr: 140
verified_head: 3a532a9127126757fc75bf533eef6a65bbc2fc36
merge: 3344ac4ca6ef4c755c269b863c1bdeb8cdb8d722
changed_files: 14_DOCS_ONLY
main_behind_at_merge: 0
review_threads: 0
submitted_reviews: 0
conversation_comments: 0
documentation_run_30774862515: PASS
bca_run_30774862512: PASS
core_workflow: NOT_TRIGGERED_BY_PATH_FILTER
annual_workflow: NOT_TRIGGERED_BY_PATH_FILTER
implementation_authority: NOT_INFERRED
human_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
next_batch: GRILLME_BATCH_3
next_counter: 0 / 10
```

### 승인 Decision

1. `D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING`
   - 승인: 일반 클리어의 필수 진실은 비판정 또는 확정 우회 경로로 획득
   - 승인: 능력·태그·판정은 비용·근거·위험·구출·전투 정보 우위와 S 랭크 가능성을 변경
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_1 / IMPLEMENTATION_NOT_AUTHORIZED`

2. `D-2026-08-02-INVESTIGATION-RANK-CONDITION-DISCLOSURE`
   - 승인: 요구 능력·태그와 수치는 출동 전 공개
   - 승인: 정확한 사용 지점·정답·최적 순서는 비공개, 첫 클리어 뒤 상세 피드백 공개
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_2 / IMPLEMENTATION_NOT_AUTHORIZED`

3. `D-2026-08-03-INCIDENT-MULTIAXIS-GATED-RANKING`
   - 승인: 조사 정확도·피해자 보호·현장 통제·기록 완성도 네 축
   - 승인: 단순 합산이 아닌 관문형 종합 랭크, 치명적 실패 상쇄 금지
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_3 / IMPLEMENTATION_NOT_AUTHORIZED`

4. `D-2026-08-03-INCIDENT-RANK-STAGES-AND-LABELS`
   - 승인: `C 조건부 대응 / B 적정 대응 / A 우수 대응 / S 정밀 대응`
   - 승인: 축별 `미달 / 충족 / 우수 / 정밀`, 정상 종결 실패에는 종합 랭크 없음
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_4 / HUMAN_VALIDATION_NOT_RUN`

5. `D-2026-08-03-INCIDENT-REPLAY-CANON-AND-MASTERY-RECORDS`
   - 승인: 일반 재도전은 숙련 기록만 갱신하는 기록 재현
   - 승인: 실제 서사 변경은 이후 진행 폐기형 캠페인 되감기만 허용
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_5 / IMPLEMENTATION_NOT_AUTHORIZED`

6. `D-2026-08-03-INCIDENT-CHECKPOINT-RETRY-AND-CANON-CONFIRMATION`
   - 승인: 조사 소단락·구출 시작·전투 시작 체크포인트
   - 승인: 결과 보고서에서 정본 확정, 확정 전 사건당 1회 출동 재개
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_6 / IMPLEMENTATION_NOT_AUTHORIZED`

7. `D-2026-08-03-CAMPAIGN-REWIND-UNLOCK-AND-BRANCH-SLOTS`
   - 승인: 첫 1년차 완료 뒤 무료·무제한 해금
   - 승인: 최대 3개 분기 슬롯, 최초 완료 캠페인 자동 보호, 분기별 정본 분리·숙련 공유
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_7 / IMPLEMENTATION_NOT_AUTHORIZED`

8. `D-2026-08-03-CAMPAIGN-REWIND-CANON-ANCHOR-SCOPE`
   - 승인: 지속 결과 사건마다 출동 준비 확정 직전 정본 앵커
   - 승인: 당시 보유 범위에서 준비 재구성, 이후 성장 소급 반입 금지, 사건 전체 재진행
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_8 / IMPLEMENTATION_NOT_AUTHORIZED`

9. `D-2026-08-03-ACCESSIBILITY-EQUIVALENCE-AND-MASTERY-GATES`
   - 승인: 판단 보존 접근성 기능은 모든 랭크·업적에 중립
   - 승인: 판단 자동 해결은 해당 숙련 관문만 등가 과제로 대체, 대체 불가 감각·운동 과제는 S 필수 조건 제외
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_9 / HUMAN_ACCESSIBILITY_VALIDATION_NOT_RUN`

10. `D-2026-08-03-MASTERY-REWARD-SCOPE-AND-CAMPAIGN-NEUTRALITY`
   - 승인: 숙련 보상은 캠페인 필수 전력·필수 서사와 분리
   - 승인: 인장·칭호·코스메틱·전시품·문서 테마·비필수 부록 중심, 게임플레이 확장은 기록 재현 전용 변칙으로 제한
   - 승인: 캠페인 종속 후일담은 활성 정본만 참조하고 기록 재현 대안은 비정본 표시
   - 상태: `MERGED_APPROVED_DESIGN_SECTION_10 / REWARD_MOTIVATION_NOT_VALIDATED`

### 적대적 병합 감사

책임 원본:

- `docs/audits/2026-08-03-grillme-batch-2-premerge-audit.md`

발견·보완:

- `PROJECT_CORE.md`의 구형 이중 코어·조작형 위험 검증·공격 누락 표현
- 숙련 부록과 캠페인 정본 후일담 혼합 위험
- 첫 교정에서 훼손된 PROJECT_CORE 고정 상태 문자열과 CORE-MVP-001 설계·구현계획 참조
- Markdown 후행 공백과 `git diff --check` 실패
- CORE·ANNUAL workflow 미실행을 PASS로 오표기할 위험

최종 판정:

```yaml
content_audit: PASS_AFTER_CORRECTIONS
scope_audit: PASS_DOCS_ONLY
canon_conflict: RESOLVED
sheet_decision_ids: 10_OF_10_MATCHED
implementation_boundary: PRESERVED
user_merge_authorization: GRANTED
result: MERGED
```

### 책임 원본

- `docs/GRILLME_BATCH_2_LEDGER.md`
- `docs/planning/2026-08-02-investigation-system-design.md`
- Batch 2 Decision 10개
- `docs/audits/2026-08-03-grillme-batch-2-premerge-audit.md`
- Google Sheet 동일 Decision ID 10개

## GRILLME_BATCH_3 — OPEN

```yaml
counter: 0 / 10
status: OPEN
approved_decisions: []
automatic_batch_triggered: false
implementation_authority: NOT_INFERRED
```

다음 중요 제품 결정부터 새 Decision ID와 함께 `1/10`으로 기록한다. Batch 2의 Design Spec·구현·병합 후속은 새로운 제품 질문이 아닌 한 Batch 3 카운터에 포함하지 않는다.

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
investigation_rank_playability: NOT_RUN
replay_rewind_comprehension: NOT_RUN
accessibility_equivalence_human_validation: NOT_RUN
mastery_reward_motivation: NOT_RUN
year_one_campaign_poc: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 다음 Gate

```text
GRILLME_BATCH_3 counter 0/10
→ 다음 중요 제품 결정을 새 Decision ID로 기록
→ Batch 2 Design Spec·사건별 랭크 관문·저장 스키마·접근성 등가 과제는 별도 승인 Gate 유지
→ 개별 사건 Spec·구현 계획·코드는 별도 승인 Gate 유지
→ 사람 검증·POC·Production 확대는 미승인 상태 유지
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
