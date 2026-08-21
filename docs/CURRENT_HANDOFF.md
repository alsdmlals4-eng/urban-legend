# 괴이기록국 Current Handoff

> 상태: `MONTHLY_CANON_SYNCED / NON_VISUAL_PLANNING_CLOSURE_READY / OVERALL_PLAN_OPEN / PLAN_LOCK`
> 정확한 main·PR·CI: 재개 시 GitHub에서 다시 조회
> 사람용 정본: Notion 괴이기록국 프로젝트 홈
> 구조화 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`

이 문서는 다음 채팅·작업자가 과거 PID, 로컬 worktree, 오래된 PR 번호, 연간/분기 next step을 현재 권한으로 오인하지 않도록 하는 continuation router다. 과거 CASE-01/PR #198 로컬 실행기 handoff는 Git history의 PR #199/#200 계보로 보존하며 현재 작업 전선이 아니다.

```yaml
status: MONTHLY_CANON_SYNCED_PLAN_LOCK
branch: READ_GITHUB_DEFAULT_BRANCH
completed_work_commit: READ_GITHUB_LATEST_MAIN
tests: READ_LATEST_EXACT_HEAD_CI
next_action: REVIEW_USER_VISUAL_DRAFT_AND_WAIT_FOR_PLANNING_COMPLETE_DECLARATION
main_integrated: VERIFY_ON_RESUME
origin_pushed: VERIFY_ON_RESUME
```

## 1. 재개 순서

```text
최신 사용자 지시
→ GitHub latest main + open PR + exact-head CI
→ Notion 프로젝트 홈 + 08 Core + 09 Vertical Slice + 10 Content Budget + 11 First Session
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_STATUS.md
→ 사건별 current canon
→ 실제 code/data/Scene/test
```

Notion `Repo Main SHA`는 마지막 동기화 receipt이며 현재 GitHub ref를 대신하지 않는다. GitHub와 Notion을 병합 뒤 각각 readback하고 `Repo Main SHA`, `Sync State`, 관련 현재 페이지를 갱신한다.

## 2. 현재 제품 계약

```yaml
cadence: ONE_MAIN_CASE_PER_MONTH
initial_slate: M01_TO_M12
continuous_after_m12: true
signature_cases: M01_M04_M07_M10
first_session: M01_AFTERLIFE_STATION
release_near_vertical_slice: M04_RED_UMBRELLA
core_flow: INVESTIGATION_DEDUCTION_MANUAL_RESCUE_RECOVERY_COMPOSITE_RESULT
non_visual_planning: CLOSURE_READY
visual_review: WAITING_USER_DRAFT
overall_plan: OPEN
plan_lock: ACTIVE
runtime_implementation: NOT_AUTHORIZED
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

`ANNUAL-MVP-001/002`는 주간 일정·육성 기술 구현과 회귀 계보를 가리키는 runtime/history ID다. 이를 삭제·rename하지 않지만, 다음 제품 기획 트랙이나 1년 4분기 콘텐츠 정본으로 사용하지 않는다.

## 3. M01 / M04 역할

- M01 저승역: First Session, 온보딩, regression anchor.
- M01 추리: 공식 원본 목적지설·단일 가짜 목적지설·개인 기억 투영설·검은 승차권 원인설 4후보를 근거로 줄인다.
- 저승역 구출: 안내 종료 전 개인 목적지 경계 통과 금지 → 현실 교통 기록과 공식 승차권 → 지정 역 동반 하차. 검은 승차권 접촉·파괴는 정답이 아니다.
- M04 빨간 우산: 약 30~45분 release-near player-experience Vertical Slice. 실제 사용 후보 UI/UX·시각·Audio/VFX·피드백·핵심 시스템·콘텐츠를 연결한 뒤 Human QA한다.

## 4. 열린 PR 통합 계보

PR #211, #213, #214, #215, #216, #217, #218의 고유 문서는 현재 월간 기획 통합 범위에 흡수한다. 통합 main에서 다음 파일의 동등 이상 내용을 확인한 뒤 원 PR을 `SUPERSEDED_BY_INTEGRATED_CANON`으로 닫는다.

- `docs/CURRENT_DEDUCTION_RECOVERY_WORK_ORDER.md`
- `docs/M01_M04_VERTICAL_SLICE_FLOW.md`
- `docs/UI_COMPONENT_REUSE_CONTRACT.md`
- `docs/VISUAL_ANCHOR_SPEC.md`
- `docs/M01_INVESTIGATION_SCENE_PACKET.md`
- `docs/M01_DEDUCTION_SCENE_PACKET.md`
- `docs/M01_RESCUE_SCENE_PACKET.md`

## 5. Workspace authority

- Notion: 사람이 보는 전체 그림, Flow, 비교표, 현재 승인 방향.
- Repository: 구조화된 기획 계약, implementation, test, runtime evidence.
- Google Sheet: migration-only legacy inventory. 새 작업·승인·감사 쓰기 금지.
- 의미를 바꾸는 작업은 Notion과 Repository를 같은 범위에서 동기화하고 병합 뒤 readback한다.

## 6. 구현 전 Gate

1. 사용자 보유 시각 시안 검토.
2. 사용자 전체 `기획 완료` 선언 또는 명시적 보류 범위.
3. fresh main에서 character/case ID, top-level `monthly_state`, save/migration Reality Gate.
4. 필요한 production asset 승인.
5. Codex/HiGodot 단일 구현 계약.
6. TDD RED→GREEN, 전체 회귀, exact-head CI.
7. M01/M02/M04 사전등록 Human QA.

현재는 1~5가 충족되지 않았으므로 code/data/Scene/save/제품 asset을 수정하지 않는다.

## 7. 보호 범위

- `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot`
- 기존 `mvp-039`, episode/character/report ID, Validation save, campaign/economy state
- root `ASSET_MANIFEST.yml` 승인·의미·권리
- 실제 Human/Visual/Device QA evidence

이번 planning sync는 위 보호 경로를 변경하지 않는다. 새 월간 state는 top-level `monthly_state` additive optional block 방향만 승인됐으며 실제 schema 변경 권한은 없다.

## 8. 완료·병합 기준

```text
focused contracts
→ full Python discovery
→ available local runtime/static checks
→ 5 whole-scope adversarial loops
→ exact-head CI
→ merge with expected head SHA
→ GitHub main readback
→ original PR disposition readback
→ Notion destination/property readback
→ remaining risk and progress report
```

실행하지 않은 검사는 `NOT_RUN`, 확인할 수 없는 상태는 `UNVERIFIED`, 플레이 증거 없는 제품 판단은 `NOT_DECLARED`로 남긴다.
