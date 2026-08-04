# Urban Legend 시작 지점

새 채팅·새 GPT·새 Codex·새 작업자가 urban-legend를 안전하게 시작하는 최상위 라우터다.

## 기본 읽기

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main ref
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/CURRENT_AFTERLIFE_STATION_CANON.md  # 저승역 작업일 때
→ docs/CURRENT_HANDOFF_VALIDATION.md       # Validation 작업일 때
→ docs/VALIDATION_TARGET_CANON.md          # 제품 Target 관련일 때
→ docs/GRILLME_APPROVAL_MERGE_LEDGER.md
→ docs/CURRENT_STATUS.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 실제 main 코드·데이터·Scene·테스트
```

`전부 확인`은 모든 파일을 무조건 로드한다는 뜻이 아니다. 현재 정본·Registry·실제 변경 경로로 범위를 좁힌 뒤 필요한 전문만 읽는다.

## 현재 권위 구분

```text
GitHub latest main ref = 현재 정확한 commit
docs/CURRENT_CONFIRMED_DECISIONS.md = 프로젝트 전체 사용자 승인·대체 관계
docs/CURRENT_AFTERLIFE_STATION_CANON.md = 저승역 현재 제품 정본과 구형 자료 우선순위
docs/VALIDATION_TARGET_CANON.md = Validation 상세 Target
docs/CURRENT_HANDOFF_VALIDATION.md = 현재 작업 상태·다음 Gate
실제 main 코드·테스트 = 구현 사실
docs/CURRENT_STATUS.md = 장기 프로젝트 구현·검증 이력
Google Sheet = 동일 Decision ID의 계획·감사·변경 추적
```

Current 문서 안의 commit SHA는 역할이 고정된 병합 증거다. 문서 자신의 병합으로 main이 이동하므로 `현재 main`을 문서 속 상수로 고정하지 않는다.

저승역 상세 규칙이 구형 Episode·PoC·CORE-VALIDATION 자료와 충돌하면 `docs/CURRENT_AFTERLIFE_STATION_CANON.md`와 `docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`를 우선한다.

## Work Mode·Skill 라우팅

1. 요청을 `PLAN / BUILD / REVIEW`로 분류한다.
2. 프로젝트 분야 Skill 최대 1개를 고른다.
3. 필요한 프로젝트 로컬 전문 최대 1개를 고른다.
4. 필요한 Base 지원 Skill 최대 3개를 고른다.
5. 실제 Skill 전문을 읽고 수행한다.
6. 완료 시 선택 이유·변경·증거·미검증을 보고한다.

Registry 항목만 읽고 Skill을 실행했다고 보고하지 않는다.

## 현재 Validation 상태

```yaml
base: 9.4.0
branch: main
canon_merge_pr_125: 595d45454621900e858a903fef0598a03349b794
package_1_merge_pr_126: 80160218d05e79af5442bf27d8fdeb66bcf05723
governance_merge_pr_127: e15b9d25127170a530f66d5c3462340b806ad51d
package_1_automated_ci: PASS
validation_focused: 4_OF_4_PASS
full_godot_regression: 53_OF_53_PASS
package_2: PLANNING_NEXT
human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
poc_passed: NOT_DECLARED
mobile: DEFERRED_AFTER_PC_VALIDATION
```

## Package 1 구현 경계

구현됨:

- 별도 Validation save repository
- ValidationSession lifecycle
- completion apply-once
- hidden Legacy memory guard
- GameState field whitelist wrapper
- invalid active Session fail-closed save routing
- focused 4-entry·full 53-entry 테스트 배관

구현되지 않음:

- main-menu Validation entry/continue UX
- 전용 축약 준비·Reasoning·결과 Scene
- 전체 SCREEN-01→SIT-008 제품 흐름
- Human·신규 플레이어·1280×720 시각 검증

## Package 2 다음 Gate

```text
main-menu에서 Legacy/Validation 저장 구분
→ Validation 생성·재개 routing
→ 전용 준비·추론·결과 Scene 최소 범위
→ 저장 비파괴·부작용 차단 계약
→ 적대적 검토
→ 사용자 구현 승인
```

## Grill Me 승인·병합 규칙

운영 Decision:

- `docs/decisions/D-2026-08-02-GRILLME-10-MERGE-CADENCE.md`
- `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`

현재 미래 카운터: `0 / 10`

승인된 Grill Me Decision ID가 10개 누적되면 다음을 먼저 수행한다.

```text
최신 main 고정
→ GitHub 열린 PR·Issue·review threads·CI 확인
→ Google Sheet 동일 Decision ID·exact range 확인
→ 중복·대체·충돌·권한·범위 적대적 검토
→ Canon PR과 구현 PR 분리
→ 최신 HEAD 재검증
→ 병합 직전 GitHub·Sheet 재조회
→ expected head SHA 고정 병합
→ merge SHA·Sheet 위치·미검증 ledger 기록
```

source-only·superseded·blocked PR은 숫자를 맞추기 위해 병합하지 않는다.

## PR 상태

- PR #125: `MERGED` — Canon·승인·Design·Plan
- PR #126: `MERGED` — Package 1 구현
- PR #127: `MERGED` — Batch 0·Grill Me 병합 운영
- PR #142: `MERGED` — 조사 시스템 Batch 3
- PR #143: `BATCH 4 COMPLETE / PENDING FINAL AUDIT AND MERGE` — 저승역 완전 사건 설계
- PR #122: `CLOSED SOURCE / DO NOT MERGE AS-IS`
- PR #120: `CLOSED / SUPERSEDED`
- Issue #121: `CLOSED / COMPLETED`

PR #122의 유효 승인 내용은 current canon에 통합 승계했다.

## 보호 범위

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `project.godot`
- 저장 Schema·기존 ID·캠페인·경제·엔딩 의미
- 승인 자산과 실제 QA 증거

보호 의미 변경은 별도 승인·RED/GREEN·회귀·롤백 없이 수행하지 않는다.

## 핵심 위치

- 승인 결정: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- 저승역 현재 정본: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
- 저승역 Source Map: `docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`
- 저승역 적대적 감사: `docs/audits/2026-08-04-afterlife-station-batch-4-canonicalization-audit.md`
- 현재 Validation 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`
- Validation Target: `docs/VALIDATION_TARGET_CANON.md`
- Package 1 Design: `docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md`
- Package 1 Plan: `docs/superpowers/plans/2026-08-02-validation-session-save-isolation-implementation-plan.md`
- Package 1 evidence: `docs/implementation/2026-08-02-package-1-session-save-isolation-evidence.md`
- Retarget merge gate: `docs/implementation/2026-08-02-package-1-retarget-merge-gate.md`
- Grill Me cadence: `docs/decisions/D-2026-08-02-GRILLME-10-MERGE-CADENCE.md`
- Grill Me ledger: `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`
- 프로젝트 실제 상태: `docs/CURRENT_STATUS.md`
- 검증 계약: `TEST_CHECKLIST.md`
- Base 버전: `docs/BASE_RULES_VERSION.md`

실행하지 않은 검사·사람 확인·제품 완료는 `NOT_RUN`, `UNVERIFIED`, `NOT_DECLARED` 중 정확한 상태로 기록한다.
