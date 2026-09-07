# 괴이기록국 현재 확정 결정

> 2026-08-28 routing correction: 이 파일은 상세 승인·대체 **역사 원장**이다. 여기의 과거 Base SHA, 0건 asset count, 구현/QA 값은 current state를 소유하지 않는다. 최신 사용자 승인 → GitHub latest main → Notion current planning → `CURRENT_PLANNING_CANON.md` / `current-planning-canon.json` → `CURRENT_DECISION_OVERLAY.md`를 먼저 읽는다. 현재 개별 asset은 root `ASSET_MANIFEST.yml`, 현재 시각 방향은 `D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION`과 `docs/visual/VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md`가 소유한다.

> 2026-08-20 supersession: 현재 제품 구조는 `월 1사건 M01+ / Signature 4 + Standard 8 / M01 First Session / M04 release-near Vertical Slice`다. 아래 1년차·분기 구조는 승인·병합 history와 기술 회귀 근거로 보존하되 현재 cadence를 소유하지 않는다. 최신 계획은 `docs/CURRENT_PLANNING_CANON.md`를 우선한다.
> Workspace authority: Notion 사람용 정본 + Repository 구조화/구현 정본. Google Sheet는 migration-only다.

> 문서 역할: `CURRENT_CONFIRMED_DECISIONS`
> 상태: `PACKAGE_2_MERGED_ON_MAIN / YEAR_ONE_DESIGN_MERGED_ON_MAIN / GRILLME_BATCH_2_MERGED / GRILLME_BATCH_3_OPEN / AUTHORITY_CORRECTION_MERGED / ASSET_GATE_CANON_RECONCILED / UI_HIERARCHY_SPEC_PLAN_MERGED`
> 갱신일: 2026-08-08
> Base: `9.4.3`
> Base main: `fa69a77a14f923a756064f6ae151d34cadb374f7` — project-adopted baseline
> Current Base remote main observed during PR #176 merge gate: `a912cc001ff4d4e3415fb4b4931723c49eb08d9a` — not automatically adopted
> Godot authority correction: `UL-DEC-AUTHORITY-001` / PR #172 / main `305d9b5bbf21ea13ce23053e43afd98fabc21654`
> Asset approval authority: root `ASSET_MANIFEST.yml` / current `PROJECT_ASSET_APPROVED` count `0`
> UI hierarchy Decision: `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT` / PR #176 merged `4ccd37675576141126b7bf8c718fb30ec9020409` / spec approved / implementation plan merged / runtime not changed / router freshness PR #177 merged `6c4058854a977027721d7115ff453be4c80a10c5`
> Package 1 구현 merge: `80160218d05e79af5442bf27d8fdeb66bcf05723`
> 병합 운영 정본 merge: `e15b9d25127170a530f66d5c3462340b806ad51d`
> Package 2 planning merge: `b4d7bd0fb82968325bcf230f3e81b8d96e142402`
> Package 2 implementation merge: `f8751e7fa7890f402c7377ea6aee64f79ef59911`
> 1년차 캠페인 Design PR: #135
> 1년차 캠페인 Design merge: `7bddbce2ebd427154cdeb8e4bb9b7aec06e2ea5e`
> main→planning sync PR: #138 / merge `cc25991ba6b74b3c3f552c84e90d40987595fa82`
> Batch 2 조사 시스템 Design PR: #140
> Batch 2 verified head: `3a532a9127126757fc75bf533eef6a65bbc2fc36`
> Batch 2 merge: `3344ac4ca6ef4c755c269b863c1bdeb8cdb8d722`
> 1년차 Design: `docs/planning/2026-08-02-year-one-campaign-master-structure-design.md`
> Batch 2 Design: `docs/planning/2026-08-02-investigation-system-design.md`
> Batch 2 감사: `docs/audits/2026-08-03-grillme-batch-2-premerge-audit.md`
> 정본·Asset Gate 감사: `docs/audits/2026-08-08-canonical-asset-gate-reconciliation.md`
> 상세 Validation Target: `docs/VALIDATION_TARGET_CANON.md`
> 현재 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`
> Grill Me ledger: `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`

이 문서는 현재 유효한 사용자 승인 결정과 대체 관계를 소유한다. 실제 최신 main SHA는 GitHub `main` ref에서 읽고, 문서 안의 SHA와 run ID는 역할이 고정된 병합·검증 증거로 사용한다. 실행하지 않은 사람·시각·콘텐츠 검증은 승인으로 간주하지 않는다.

`Base main` 필드는 프로젝트가 현재 채택한 기준선을 의미한다. Base 원격 저장소의 최신 main이 더 전진했더라도 별도 채택·동기화 검증 없이 프로젝트 기준선을 자동 변경하지 않는다.

## 1. 권위 순서

```text
최신 사용자 승인
→ GitHub 최신 main ref
→ AGENTS.md 보호 규칙
→ skills/PROJECT_BASE_ADAPTER.json
→ docs/PROJECT_CORE.md
→ 이 문서
→ docs/VALIDATION_TARGET_CANON.md
→ 분야별 책임 원본과 승인 Decision
→ 실제 main 코드·데이터·Scene·테스트
→ 자동·사람 검증 증거
→ Google Sheet 동일 Decision ID
→ 과거 PR·대화·추정
```

source-only·superseded PR은 현재 권위가 아니다. Package 1·2, 1년차 캠페인 Design, Grill Me Batch 2 조사 시스템 Design은 main에 병합됐다. Design 병합은 Design Spec·개별 사건 Spec·구현·사람 검증·POC·Production 확대 권한을 열지 않는다.

제품 자산의 승인·의미·권리 권위는 프로젝트 루트 `ASSET_MANIFEST.yml`이다. 과거 `assets/ASSET_MANIFEST.json`은 `LEGACY_MIGRATION_PENDING_NON_AUTHORITY` 재고이며 그 안의 `stage: final` 또는 QA 문구만으로 `PROJECT_ASSET_APPROVED`를 부여하지 않는다.

## 2. 현재 상태

```yaml
base_version: 9.4.3
base_main: fa69a77a14f923a756064f6ae151d34cadb374f7
base_remote_main_observed_20260808_merge_gate: a912cc001ff4d4e3415fb4b4931723c49eb08d9a
base_remote_main_auto_adopted: false
platform: PC_16_9_MOUSE_KEYBOARD
mobile: DEFERRED_AFTER_PC_VALIDATION
package_1_implementation: MERGED
package_1_automated_ci: PASS
package_1_validation_focused: 4_OF_4_PASS
package_2_menu_hierarchy: MERGED_PARALLEL_INDEPENDENT_CARDS
package_2_design: MERGED
package_2_design_spec: MERGED
package_2_implementation_plan: MERGED_AND_EXECUTED
package_2_product_implementation: MERGED_ON_MAIN
package_2_automated_code_ci: PASS
package_2_validation_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
godot_persistent_authoring_authority: HIGODOT_SOLE_AUTHORITY
gut_test_authority: ADOPTED_ACTIVE_NON_AUTHORING
hera_addon_source: PRESERVED_INACTIVE
hera_adoption: DEFERRED_PENDING_EXACT_PAIR_LIVE_QA_SOURCE_DELTA_NONE_ROLLBACK
authority_decision: UL-DEC-AUTHORITY-001
authority_correction_pr: 172
authority_correction_main: 305d9b5bbf21ea13ce23053e43afd98fabc21654
authority_live_editor_run_31225687879: PASS
authority_full_matrix_run_31225687571: PASS
authority_core_docs_run_31225687675: PASS
asset_manifest_authority: ROOT_ASSET_MANIFEST_YML
project_asset_approved_count: 0
legacy_asset_manifest_json: LEGACY_MIGRATION_PENDING_NON_AUTHORITY
vault_local_state: VAULT_LOCAL_STATE_UNVERIFIED
asset_vault_runtime_contract: NOT_VERIFIED
image_product_promotion: BLOCKED_NO_PROJECT_ASSET_APPROVED
ui_hierarchy_decision: D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT
ui_hierarchy_design_direction: APPROVED
ui_hierarchy_written_spec: APPROVED
ui_hierarchy_implementation_plan: MERGED_ON_MAIN_PR_176
ui_hierarchy_planning_merge: 4ccd37675576141126b7bf8c718fb30ec9020409
ui_hierarchy_router_freshness_merge: 6c4058854a977027721d7115ff453be4c80a10c5
ui_hierarchy_runtime_implementation: NOT_STARTED
ui_hierarchy_new_runtime_render: NOT_RUN
ui_hierarchy_human_validation: NOT_RUN
year_one_design_sections_1_to_6: MERGED_ON_MAIN
year_one_design_pr: 135
year_one_design_merge: 7bddbce2ebd427154cdeb8e4bb9b7aec06e2ea5e
year_one_planning_priority: APPROVED
year_one_main_content_authority: INVESTIGATION_RESCUE_RECOVERY_BATTLE
year_one_core_case_spring: AFTERLIFE_STATION
year_one_core_case_summer: RED_UMBRELLA_ALLEY
year_one_core_case_autumn: DEAD_FREQUENCY_STATION
year_one_core_case_winter: UNRECORDED_WARD
year_one_feedback_axes: KNOWLEDGE_RELATION_INSTITUTION_FIELD
year_one_annual_review: COMPOSITE_AGENT_RECORD_NO_SINGLE_RANK
grillme_batch_1: COMPLETE_MERGED
grillme_batch_2: COMPLETE_MERGED
grillme_batch_2_design_sections_1_to_10: MERGED_ON_MAIN
grillme_batch_2_verified_head: 3a532a9127126757fc75bf533eef6a65bbc2fc36
grillme_batch_2_merge: 3344ac4ca6ef4c755c269b863c1bdeb8cdb8d722
grillme_batch_3_counter: 0_OF_10
design_spec: NOT_WRITTEN
year_one_design_spec: NOT_WRITTEN
investigation_design_spec: NOT_WRITTEN
year_one_implementation: NOT_AUTHORIZED
investigation_implementation: NOT_AUTHORIZED
human_qa: NOT_RUN
new_player_validation: NOT_RUN
screen_01_visual_1280x720: NOT_RUN
core_gameplay_screen_human_validation: NOT_RUN
year_one_minigame_human_validation: NOT_RUN
four_case_content_validation: NOT_RUN
case_play_differentiation_validation: NOT_RUN
result_feedback_validation: NOT_RUN
annual_review_comprehension: NOT_RUN
investigation_rank_validation: NOT_RUN
replay_rewind_validation: NOT_RUN
accessibility_equivalence_validation: NOT_RUN
mastery_reward_motivation_validation: NOT_RUN
android_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

### 도구 권위·Asset Gate 현재 계약

- `UL-DEC-AUTHORITY-001`: HiGodot은 Scene·Node·Resource·Project Settings의 단일 persistent 저작 권위다.
- GUT 9.7.1은 테스트 검색·실행·assertion·double·JUnit의 비저작 권위로 `ADOPTED_ACTIVE`다.
- Hera addon 소스는 보존하지만 plugin/autoload 활성 권위는 제거된 상태다. exact CLI/addon pair·live-QA 소비 경로·source-delta `NONE`·rollback evidence를 갖춘 별도 Decision 전에는 active adoption으로 승격하지 않는다.
- PR #172 병합 후 main `305d9b5bbf21ea13ce23053e43afd98fabc21654`에서 Live Editor `31225687879`, Full Matrix `31225687571`, Core+Docs `31225687675`가 PASS했다.
- 루트 `ASSET_MANIFEST.yml`은 제품 자산 승인·의미·권리 원장이다. 현재 승인 자산 목록은 비어 있고 `PROJECT_ASSET_APPROVED`는 0건이다.
- `assets/ASSET_MANIFEST.json`은 역사 재고를 보존하는 `LEGACY_MIGRATION_PENDING_NON_AUTHORITY`이며 개별 재검수 전 제품 승격 근거가 아니다.
- 이 환경에서 Windows 로컬 `.asset-vault/` 상태와 vault 도구/계약은 검증하지 못했으므로 `VAULT_LOCAL_STATE_UNVERIFIED / NOT_VERIFIED`를 유지한다.
- 이미지 생성·삭제·tracked 제품 승격을 이 정본 정합화 작업에서 자동 수행하지 않는다.

### 조사·회수 UI hierarchy 현재 계약

- `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`는 `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`의 UX 가변 범위를 구체화하며 기존 사건 의미를 대체하지 않는다.
- 조사: field/environment first → 짧은 상황 서술 → 첫 조사 행동 → 획득 context/가설 진행 → 요청 시 괴이 매뉴얼/기록 상세 순서를 기본으로 한다.
- 저승역의 상시 대형 `ManualPanel` 점유는 승인 target이 아니며 기존 drawer 계열 progressive disclosure로 전환한다.
- Canon v2 investigation presentation은 compact/contextual이어야 하며 recovery-only obligation/termination/follow-up 전문은 조사 화면에서 상시 펼치지 않는다.
- 회수: 괴이 현상/전조가 persistent 전장 주체이고 아군은 `TeamStrip` 및 필요 시 contextual cut-in으로 표현한다. `RepresentativeVisual` stable identity는 호환을 위해 보존할 수 있으나 상시 전신 배치는 승인 target이 아니다.
- 1280×720에서는 보조 정보부터 collapse하며 첫 활성 행동·잠금 이유·복귀 경로를 유지한다.
- 실제 1280×720/1920×1080·keyboard/gamepad·접근성·actual save 검증은 구현 이후 Human QA 전까지 `NOT_RUN`이다.
- 상세 Spec: `docs/superpowers/specs/2026-08-08-investigation-recovery-ui-hierarchy-design.md`
- 구현 계획: `docs/superpowers/plans/2026-08-08-investigation-recovery-ui-hierarchy-implementation-plan.md`
- planning PR #176은 docs/canon 범위로 main에 병합됐고, runtime implementation은 별도 HiGodot implementation PR로 분리한다.

## 3. 현재 제품 코어 권위

괴이기록국의 메인 콘텐츠는 괴이 사건에 진입해 조사·피해자 구출·회수 전투를 수행하는 경험이다.

```text
괴이 사건 진입
→ 텍스트 노벨 조사
→ 상황 설명과 조건 표시 선택지
→ 키워드 획득
→ 괴이 매뉴얼 후보 규칙 구성
→ 피해자 구출 미니게임
→ 턴제 회수 전투
→ 안정화·봉쇄·잔향 회수
→ 공식 규칙·위험 사례·결과 환류
```

- 조사: 상황 설명·조건 선택지·키워드·괴이 매뉴얼 문장 구성
- 피해자 구출: 조사 규칙을 적용해 피해자를 괴이 현상에서 분리
- 회수 전투: 보호·관찰·대응·공격·장비·봉쇄·후퇴
- 일정·육성·동료·장비·연구·기관: 준비·지원·환류 계층
- 능력·태그·판정: 객관적 진실을 바꾸지 않고 비용·위험·우회 경로를 조정
- 공격: 필요한 전술 행동이지만 공격 반복만으로 기본 승리 불가

책임 Decision:

- `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY`
- `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE`
- `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`

### Batch 2 조사·랭크·재도전 계약

- 일반 클리어에 필요한 필수 진실에는 비판정 또는 확정 우회 경로가 있다.
- 능력·태그·판정은 비용·추가 근거·위험·구출 및 전투 정보 우위와 최고 랭크 가능성을 바꾼다.
- 최고 랭크 준비 조건은 출동 전에 공개하지만 정확한 사용 지점·해법·정답은 숨긴다.
- 사건 결과는 조사 정확도·피해자 보호·현장 통제·기록 완성도 네 축과 관문형 종합 랭크로 평가한다.
- 정상 종결 랭크는 `C 조건부 대응 / B 적정 대응 / A 우수 대응 / S 정밀 대응`이며 정상 종결 실패·기관 강제 봉쇄에는 종합 랭크를 부여하지 않는다.
- 일반 재도전 `기록 재현`은 숙련 기록만 갱신하고 캠페인 정본을 바꾸지 않는다.
- 실제 서사 변경은 첫 1년차 완료 뒤 해금되는 캠페인 되감기로만 허용하며 출동 준비 확정 직전 정본 앵커에서 사건 전체를 다시 진행한다.
- 접근성 등가 기능은 랭크와 업적에 중립이며 판단 자동 해결은 해당 숙련 관문만 등가 과제로 대체한다.
- S 랭크·업적 보상은 캠페인 필수 전력·필수 서사와 분리하며 기록 재현 전용 변칙은 캠페인에 반입하지 않는다.
- 캠페인 종속 후일담은 활성 캠페인 정본만 참조하고 기록 재현의 대안 결과는 비정본으로 표시한다.

Batch 2 책임 Decision:

1. `D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING`
2. `D-2026-08-02-INVESTIGATION-RANK-CONDITION-DISCLOSURE`
3. `D-2026-08-03-INCIDENT-MULTIAXIS-GATED-RANKING`
4. `D-2026-08-03-INCIDENT-RANK-STAGES-AND-LABELS`
5. `D-2026-08-03-INCIDENT-REPLAY-CANON-AND-MASTERY-RECORDS`
6. `D-2026-08-03-INCIDENT-CHECKPOINT-RETRY-AND-CANON-CONFIRMATION`
7. `D-2026-08-03-CAMPAIGN-REWIND-UNLOCK-AND-BRANCH-SLOTS`
8. `D-2026-08-03-CAMPAIGN-REWIND-CANON-ANCHOR-SCOPE`
9. `D-2026-08-03-ACCESSIBILITY-EQUIVALENCE-AND-MASTERY-GATES`
10. `D-2026-08-03-MASTERY-REWARD-SCOPE-AND-CAMPAIGN-NEUTRALITY`

## 4. 1년차 캠페인 승인 구조

### 캠페인 목적과 성장 축

> 권나래가 한 해 동안 무엇을 이해하고, 누구의 책임을 선택하며, 어떤 방식으로 괴이를 기록하는 요원이 되었는가?

```text
봄 — 배우고 소속된다
→ 여름 — 전문화하고 약속한다
→ 가을 — 가치 충돌의 대가를 치른다
→ 겨울 — 축적한 판단으로 책임을 완수한다
```

### 구조

- 분기마다 핵심 괴담 1개, 1년 총 4개
- 각 사건은 독립된 규칙과 안정화·현재 사건 종결을 가짐
- 독립 사건 4개 + 강한 결과 환류 + 약한 공통 미스터리
- 다음 분기는 이전 결과 최소 2축 사용, 겨울은 3축 모두 사용
- 실패는 위험 사례·후유증·기관 압박·관계 변화·재출현 조건으로 전진
- 동일 흑막·동일 괴이 분신·겨울 성공으로 과거 피해 삭제 금지

### 분기 배치와 플레이 문법

| 분기 | 핵심 괴담 | 역할 | 대표 위협 문법 | 피해자 구출 문법 |
|---|---|---|---|---|
| 봄 | 저승역 | 기준 사건 | 순서와 이동 시점 | 공식 기준 기반 순서·경로 복원 |
| 여름 | 비 오는 골목의 빨간 우산 | 선택 사건 | 대상과 역할의 전이 | 반사 차단·우산 격리·호위 역할 배치 |
| 가을 | 폐주파수 방송국 | 충돌 사건 | 응답과 송수신 구간 | 보호 범위·무음 구간·반환 대상 조절 |
| 겨울 | 기록되지 않은 병동 | 종합 사건 | 기록 권위와 존재 대체 | 기록 비교·모순 보존·복구 순서 |

### 공통 조사·구출·전투 계약

- 조사: `상황 설명 → 조건 표시 선택지 → 결과 문장 → 키워드`
- 괴이 매뉴얼: 발생 조건·피해 연결·금지 행동·구출 절차·전투 대응
- 키워드 상태: 후보·확인·위험 사례·미해결
- 구출 미니게임: 설명 30초·입력 1~2종·기본 1~3분 목표, 사람 검증 전 달성 선언 금지
- 전투 승리: 피해자 보호 + 규칙 관찰 + 고유 대응 + 현현체 약화 + 봉쇄 조건

### 결과 환류와 연도 결산

각 사건은 `정밀 안정화·안정화·불완전 안정화·기관 강제 봉쇄` 중 하나의 종결 상태와 결과 패킷을 남긴다.

결과 축:

1. 지식 — 공식 규칙·위험 사례·미해결 질문·연구·재출현 대응
2. 관계·기관 — 동료·피해자·기관·외부 세력·책임 주체
3. 현장 — 피해자 상태·잔향·놓친 피해 경로·재출현·오염

모든 세부 결과는 보존하되 다음 분기에 직접 작동하는 주 결과는 축마다 최대 1개로 제한한다. 과거 성공은 현재 괴담 정답을 공개하지 않고, 과거 실패는 필수 진행을 잠그지 않는다.

연말은 단일 점수나 S~D 등급이 아니라 다음 복합 기록으로 표현한다.

```text
조사 성향
+ 피해자 보호 원칙
+ 기관 내 위치
+ 남은 책임
```

2년차 초반 직접 활성화는 지식 1개·관계/기관 1개·현장 1개·요원 성향 기록으로 제한하되 나머지 사건 기록과 책임은 삭제하지 않는다.

## 5. 핵심 게임 화면 표현 기준선

상태: `APPROVED_PROVISIONAL_UX_BASELINE / UI_HIERARCHY_REFINEMENT_APPROVED`

- 조사 화면: 상황 설명 → 조건이 표시된 선택지, 플레이어 노출 명칭 `괴이 매뉴얼`
- 피해자 구출 화면: 구출 대상·조건·금지 행동·안전 행동 표시
- 회수 전투 화면: 괴이 중심 전장, 아군 하단 HUD, 스킬 사용 시 짧은 컷인
- 패널·크기·컷인 시간·단축키·애니메이션은 후속 UX와 사람 검증에서 수정 가능
- `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`는 이 가변 범위를 구체화해 조사에서 현장/행동 우선, 회수에서 괴이 중심 persistent stage를 승인 target으로 고정한다.
- 승인된 presentation target은 구현 완료가 아니며 현재 main runtime은 별도 implementation PR 전까지 그대로다.

## 6. 승인 Validation 흐름

```text
SCREEN-01 무인 메인
→ SIT-001 저승역 콜드 오픈
→ SIT-002 기록국 브리핑
→ SCREEN-03 / SIT-003 축약 준비
→ SCREEN-02 / SIT-004 텍스트 노벨 조사
→ SCREEN-02 전문 절차 / SIT-005 사건 가설·시간순 증거
→ SCREEN-02 전문 절차 / SIT-006 안전 노선 복원
→ SCREEN-02 전문 절차 / SIT-007 회수 2패턴
→ SCREEN-04 / SIT-008 결과 4축·최소 환류
→ SCREEN-01 메인 복귀
```

Package 2는 SCREEN-01에서 SIT-001·SIT-002·SIT-004의 현재 구현 Scene만 allowlist로 연다. SIT-003·SIT-005~008은 전용 Scene 구현 전 `NOT_AVAILABLE`로 fail-closed한다. 1년차 Design과 Batch 2 Design 병합은 기존 Validation 구현을 자동 변경하지 않는다.

## 7. 현재 Decision 목록

| Decision ID | 현재 상태 | 핵심 |
|---|---|---|
| `D-2026-07-31-CANON-SHEET-SYNC` | CURRENT_APPROVED_GOVERNANCE | 주요 승인을 GitHub·Sheet에 같은 ID로 동기화 |
| `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION` | APPROVED_PLANNING_BASELINE | 일반 조사·플레이는 텍스트 노벨 화면 |
| `D-2026-07-31-VISUAL-ART-DIRECTION` | APPROVED_PLANNING_BASELINE | 다크 현대 오컬트·세미리얼 애니·기관 UI |
| `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY` | SUPERSEDED_IN_PART | 화면 책임 분리 |
| `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS` | APPROVED_LONG_TERM_TARGET | 일정·연구·보급 지원 화면 유지 |
| `D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION` | APPROVED_SUPPORT_LAYER_TARGET | 하루 주요 활동 1개·자동 기본 휴식 |
| `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE` | APPROVED_PLANNING_BASELINE | 저승역 시간순 증거 |
| `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS` | APPROVED_PLANNING_BASELINE | 저승역 회수 2패턴 |
| `D-2026-08-01-SCHEDULE-REST-SEMANTICS` | APPROVED_SUPPORT_LAYER_NOT_IMPLEMENTED | 기본 휴식 의미 |
| `D-2026-08-01-PROVISIONING-AUTHORITY` | APPROVED_SUPPORT_LAYER_NOT_IMPLEMENTED | 기록국 보급실 |
| `D-2026-08-01-VALIDATION-SCOPE-FILTER` | APPROVED_TARGET_NOT_IMPLEMENTED | 핵심만 노출 |
| `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE` | APPROVED_PLANNING_BASELINE | SCREEN-01~07·SIT-001~008 |
| `D-2026-08-01-VALIDATION-RESULT-AXES` | APPROVED_PLANNING_BASELINE | 결과 원시 4축 |
| `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION` | IMPLEMENTED_PACKAGE_1_AND_2_BOUNDARY | Legacy 병렬 저장·복귀·중복 방지 |
| `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL` | CURRENT_APPROVED_GOVERNANCE | 안전 권장안 일괄 승인 |
| `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL` | APPROVED_FINAL_PLANNING_BASELINE | Validation 기획 최종 승인 |
| `D-2026-08-01-LEGACY-PR-DISPOSITION` | SUPERSEDED_IN_PART | 구형 PR 직접 병합 금지 |
| `D-2026-08-02-BASE-V94-CANON-RECONCILIATION` | MERGED_CURRENT_GOVERNANCE | Base v9.4 계열·source PR 격리·정본 복구 |
| `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL` | MERGED_APPROVED_PLANNING | 기획·명세·검토 우선 |
| `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY` | MERGED_AND_IMPLEMENTED | Validation 기록 완전 독립 |
| `D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL` | MERGED_AND_EXECUTED | Session·Save isolation Design |
| `D-2026-08-02-PACKAGE-1-IMPLEMENTATION-APPROVAL` | MERGED_AND_CI_VERIFIED | Package 1 구현·테스트 |
| `D-2026-08-02-PACKAGE-1-SEPARATE-MERGE-AUTHORIZATION` | EXECUTED | 정본→재정렬→구현 별도 병합 |
| `D-2026-08-02-GRILLME-10-MERGE-CADENCE` | CURRENT_APPROVED_GOVERNANCE | 승인 10개마다 적대적 병합 batch |
| `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY` | MERGED_AND_IMPLEMENTED | Legacy·Validation 독립 병렬 카드 |
| `D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL` | MERGED_AND_EXECUTED | 상태·초기화·이어하기·라우팅 Design |
| `D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL` | MERGED_AND_EXECUTED | Design Spec 승인·계획 작성 |
| `D-2026-08-02-PACKAGE-2-IMPLEMENTATION-APPROVAL` | MERGED_AND_CI_VERIFIED | Package 2 구현·TDD·자동 검증·병합 |
| `D-2026-08-02-YEAR-ONE-CAMPAIGN-MASTER-STRUCTURE-FIRST` | MERGED_APPROVED_PLANNING_PRIORITY | 개별 콘텐츠보다 4분기 마스터 구조 우선 |
| `D-2026-08-02-YEAR-ONE-CAMPAIGN-PURPOSE-AND-QUARTERLY-CASE` | MERGED_APPROVED_DESIGN_SECTION_1 | 성장 축·분기당 핵심 괴담 1개 |
| `D-2026-08-02-YEAR-ONE-QUARTERLY-CASE-ROLE-AND-FEEDBACK` | MERGED_APPROVED_DESIGN_SECTION_2 | 독립 4사건·3축 환류·실패 전진 |
| `D-2026-08-02-YEAR-ONE-QUARTERLY-SIMPLE-MINIGAME-VARIATION` | MERGED_APPROVED_DESIGN_SECTION_3 | 분기별 초간단 피해자 구출 미니게임 |
| `D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY` | MERGED_CURRENT_PRODUCT_AUTHORITY | 메인 콘텐츠=조사·피해자 구출·회수 전투 |
| `D-2026-08-02-CORE-GAMEPLAY-SCREEN-PRESENTATION-BASELINE` | MERGED_APPROVED_PROVISIONAL_UX_BASELINE | 선택지 조사·괴이 매뉴얼·괴이 중심 전투 |
| `D-2026-08-02-YEAR-ONE-FOUR-CORE-CASES-AND-QUARTER-PLACEMENT` | MERGED_APPROVED_DESIGN_SECTION_4 | 봄 저승역·여름 빨간 우산·가을 폐주파수·겨울 기록되지 않은 병동 |
| `D-2026-08-02-YEAR-ONE-CASE-PLAY-DIFFERENTIATION-CONTRACT` | MERGED_APPROVED_DESIGN_SECTION_5 | 순서·전이·응답·기록 권위 위협 문법 |
| `D-2026-08-02-YEAR-ONE-RESULT-FEEDBACK-AND-ANNUAL-REVIEW-CONTRACT` | MERGED_APPROVED_DESIGN_SECTION_6 | 3축 결과 패킷·기관 강제 봉쇄·복합 연도 기록·2년차 계승 |
| `D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING` | MERGED_APPROVED_DESIGN_SECTION_1 | 필수 진실 비판정/확정 우회·능력/태그는 비용과 숙련 변화 |
| `D-2026-08-02-INVESTIGATION-RANK-CONDITION-DISCLOSURE` | MERGED_APPROVED_DESIGN_SECTION_2 | 준비 조건 공개·정답과 사용 지점 비공개·첫 클리어 후 상세 피드백 |
| `D-2026-08-03-INCIDENT-MULTIAXIS-GATED-RANKING` | MERGED_APPROVED_DESIGN_SECTION_3 | 네 평가축·관문형 종합 랭크·치명적 실패 상쇄 금지 |
| `D-2026-08-03-INCIDENT-RANK-STAGES-AND-LABELS` | MERGED_APPROVED_DESIGN_SECTION_4 | C/B/A/S와 조건부/적정/우수/정밀 대응 명칭 |
| `D-2026-08-03-INCIDENT-REPLAY-CANON-AND-MASTERY-RECORDS` | MERGED_APPROVED_DESIGN_SECTION_5 | 기록 재현 숙련 기록과 캠페인 정본 분리 |
| `D-2026-08-03-INCIDENT-CHECKPOINT-RETRY-AND-CANON-CONFIRMATION` | MERGED_APPROVED_DESIGN_SECTION_6 | 구간 체크포인트·제한 재개·결과 보고서 정본 확정 |
| `D-2026-08-03-CAMPAIGN-REWIND-UNLOCK-AND-BRANCH-SLOTS` | MERGED_APPROVED_DESIGN_SECTION_7 | 첫 1년차 완료 후 무료 되감기·3개 분기 슬롯·최초 완료 보호 |
| `D-2026-08-03-CAMPAIGN-REWIND-CANON-ANCHOR-SCOPE` | MERGED_APPROVED_DESIGN_SECTION_8 | 출동 준비 직전 정본 앵커·사건 전체 재진행·소급 반입 금지 |
| `D-2026-08-03-ACCESSIBILITY-EQUIVALENCE-AND-MASTERY-GATES` | MERGED_APPROVED_DESIGN_SECTION_9 | 판단 보존 접근성 중립·자동 해결 관문 등가 대체 |
| `D-2026-08-03-MASTERY-REWARD-SCOPE-AND-CAMPAIGN-NEUTRALITY` | MERGED_APPROVED_DESIGN_SECTION_10 | 캠페인 전력 중립 숙련 보상·비정본 기록 재현 변칙 |
| `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT` | SPEC_APPROVED / IMPLEMENTATION_PLAN_MERGED_ON_MAIN / RUNTIME_NOT_CHANGED | 조사 field/action 우선·manual progressive disclosure·Canon v2 mode-specific·회수 anomaly-centered/contextual ally cut-in |
| `UL-DEC-AUTHORITY-001` | APPROVED_DECISION_REAFFIRMED / MERGED_ON_MAIN / HERA_SOURCE_INACTIVE_ADOPTION_DEFERRED | HiGodot sole persistent authoring · GUT 9.7.1 non-authoring test authority · Hera active adoption deferred |

## 8. Package 2 구현 보호 계약

- 메뉴 조회는 독립 read-only inspector 사용
- Validation 시작에서 Legacy 저장 삭제 금지
- `reset_run_state()`·`restart_afterlife_station_flow()` 재사용 금지
- active·suspended·completed 행동 분리
- 기존 Validation 교체는 record identity 재검증 후 명시적 확인
- corrupt·incompatible·recoverable·interrupted 자동 변경 금지
- flow-stage allowlist·unknown/not-available fail-closed
- whitelist-only runtime initializer
- single-flight mutation lock
- route·저장 실패 시 runtime rollback·Session abandon
- Legacy file bytes·hidden memory equality 검증
- completed viewer는 GameState load 없는 read-only summary

책임 문서:

- `docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md`
- `docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`
- `docs/implementation/2026-08-02-package-2-main-menu-entry-routing-evidence.md`

## 9. GitHub·검증 상태

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
pr_140: MERGED_GRILLME_BATCH_2_DESIGN
pr_172: MERGED_AUTHORITY_CORRECTION
pr_176: MERGED_UI_HIERARCHY_SPEC_PLAN
pr_177: MERGED_UI_HIERARCHY_ROUTER_FRESHNESS
pr_122: CLOSED_SOURCE_DO_NOT_MERGE_AS_IS
issue_121: CLOSED_COMPLETED
package_2_planning_merge: b4d7bd0fb82968325bcf230f3e81b8d96e142402
package_2_implementation_merge: f8751e7fa7890f402c7377ea6aee64f79ef59911
main_to_year_one_planning_sync_merge: cc25991ba6b74b3c3f552c84e90d40987595fa82
year_one_design_verified_head: a009732ab6162bdfc018da792e7e0414c342e7f5
year_one_design_merge: 7bddbce2ebd427154cdeb8e4bb9b7aec06e2ea5e
year_one_documentation_run_30750849552: PASS
year_one_bca_run_30750849578: PASS
year_one_core_run_30750849570: PASS
year_one_annual_run_30750849589: PASS
batch_2_verified_head: 3a532a9127126757fc75bf533eef6a65bbc2fc36
batch_2_merge: 3344ac4ca6ef4c755c269b863c1bdeb8cdb8d722
batch_2_documentation_run_30774862515: PASS
batch_2_bca_run_30774862512: PASS
batch_2_core_workflow: NOT_TRIGGERED_BY_PATH_FILTER
batch_2_annual_workflow: NOT_TRIGGERED_BY_PATH_FILTER
package_1_focused: 4_OF_4_PASS
package_2_focused: 5_OF_5_PASS
full_godot_regression: 58_OF_58_PASS
authority_correction_main: 305d9b5bbf21ea13ce23053e43afd98fabc21654
authority_live_editor_run_31225687879: PASS
authority_full_matrix_run_31225687571: PASS
authority_core_docs_run_31225687675: PASS
ui_hierarchy_planning_merge: 4ccd37675576141126b7bf8c718fb30ec9020409
ui_hierarchy_router_freshness_merge: 6c4058854a977027721d7115ff453be4c80a10c5
ui_hierarchy_runtime_implementation: NOT_STARTED
ui_hierarchy_human_validation: NOT_RUN
year_one_human_validation: NOT_RUN
batch_2_human_validation: NOT_RUN
merge_authorization: EXECUTED
```

## 10. Grill Me 운영

```yaml
batch_1: COMPLETE_MERGED
batch_1_counter: 10_OF_10
batch_1_design_pr: 135
batch_1_verified_head: a009732ab6162bdfc018da792e7e0414c342e7f5
batch_1_merge: 7bddbce2ebd427154cdeb8e4bb9b7aec06e2ea5e
batch_2: COMPLETE_MERGED
batch_2_counter: 10_OF_10
batch_2_design_pr: 140
batch_2_verified_head: 3a532a9127126757fc75bf533eef6a65bbc2fc36
batch_2_merge: 3344ac4ca6ef4c755c269b863c1bdeb8cdb8d722
batch_2_audit: PASS_AFTER_CORRECTIONS
batch_3_counter: 0_OF_10
```

Batch 1과 Batch 2의 승인 Decision은 `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`에 보존한다. 동일 질문의 Design·Spec·구현·병합 후속 Gate는 새 질문이 아니면 새 Batch에 추가하지 않는다.

## 11. 미검증 경계

```yaml
local_runtime: NOT_RUN
local_windows_checkout: BLOCKED_UNVERIFIED
vault_local_state: VAULT_LOCAL_STATE_UNVERIFIED
asset_vault_runtime_contract: NOT_VERIFIED
legacy_asset_inventory_reverification: MIGRATION_PENDING
project_asset_approved_count: 0
image_product_promotion: BLOCKED
image_runtime_validation: NOT_RUN
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
ui_hierarchy_runtime_1280x720: NOT_RUN
ui_hierarchy_runtime_1920x1080: NOT_RUN
ui_hierarchy_keyboard: NOT_RUN
ui_hierarchy_gamepad: NOT_RUN
ui_hierarchy_accessibility_human: NOT_RUN
ui_hierarchy_actual_save_restart: NOT_RUN
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
android_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 12. 다음 Gate

```text
D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT
→ written spec APPROVED
→ implementation plan MERGED_ON_MAIN via PR #176
→ active router freshness MERGED via PR #177
→ fresh latest main + Base + Sheet preflight
→ separate HiGodot implementation PR
→ TDD RED/GREEN
→ adopted GUT + maintained full Godot regression + exact-head CI
→ actual Windows START_HUMAN_QA.cmd
→ 1280×720 / 1920×1080 / keyboard / gamepad / accessibility / actual save Human 판단

정본·Asset Gate 정합화
→ UL-DEC-AUTHORITY-001은 같은 Decision ID로 GitHub·Sheet 동기화 유지
→ root ASSET_MANIFEST.yml에는 PROJECT_ASSET_APPROVED 자산만 기록
→ 현재 승인 자산 0건이므로 이미지 제품 승격은 BLOCKED
→ Legacy assets/ASSET_MANIFEST.json 항목은 개별 권리·참조·런타임·Sheet 승인 재검수 전 MIGRATION_PENDING
→ 로컬 .asset-vault 상태는 실제 Windows 접근 전 VAULT_LOCAL_STATE_UNVERIFIED
→ Human/UI/Android 검증은 실제 실행 전 NOT_RUN

GRILLME_BATCH_3 counter 0/10
→ 동일 Decision의 spec/plan/implementation 후속은 새 Grill Me 질문으로 중복 계산하지 않음
→ 다음 별도 중요 제품 결정은 새 Grill Me Decision으로 기록
→ Batch 2 Design Spec·사건별 랭크 관문·저장 스키마·접근성 등가 과제는 별도 사용자 승인 필요
→ 개별 사건 Spec 작성은 별도 사용자 승인 필요
→ 구현·사람 검증·POC·Production 확대는 각각 별도 Gate 유지
```
