# 현재 인계 — 2026-09-20 운영규칙 경량화·재미 검증

현재 승인 작업은 `D-2026-09-20-LEAN-OPERATING-AND-EXPERIENCE-METHOD`다. 읽기 순서는 `AGENTS.md`, Base 선택 적용과 재조회 조건은 `docs/BASE_RULES_VERSION.md`에서 시작한다. 아래 과거 제품 snapshot을 현재 실행 권한으로 재사용하지 않는다.

- 범위: 시작 문서·분야 Skill·어댑터·관련 검사; 게임 코드/씬/데이터/자산/설치·전역 설정 변경 없음.
- 실행 순서: 원본/스킬 연결 교정 → 생성물 및 계약 검증 → 전체 검토 2회와 독립 검토 → current-task PR의 필수 검사 → 허용될 때 정상 병합 → 최신 main readback.
- 기존 작업 보존: `codex/daily-case-structure-design-20260910` (`bc8320e4783a015403edc8cde3dc1075e5eecbca`)은 시작 시 main보다 44커밋 앞서 있었다. 변경·미추적 파일을 그대로 두었다. 이 SHA는 이번 조사 snapshot이며 다음 대화에서 다시 fetch/비교한다.
- 최초 main baseline `c82291101bf0a2bb4d821a12bca9f14070ee2886`은 Python 503개 중 502 PASS / 기존 headless helper 1 FAIL이었다. 이후 사용자가 **PR #362 교정·검증·정상 병합 → PR #363 재결합·검증·정상 병합**을 명시 승인했다. 다른 기존 PR은 계속 읽기 전용이다.
- 새 재미 검증 방법의 실제 프로젝트 HUMAN은 `NOT_RUN`. 이미 승인된 제품 구현 continuation을 사람 검증 대기로 다시 잠그지 않는다.
- 구현 결과: Base #883/#885 선택 적용, 분야 Skill 10개·기존 UX/검증 책임 연결. 최초 508 PASS / 1 FAIL 기록은 아래 교정으로 대체하며 실패 이력은 보존한다. 기존 read-order·generated adapter·exact CI validator PASS와 전체 검토 1 자체 교정 + 검토 2 독립 검토를 재사용한다.
- 환경 한계: 별도 Skill quick_validate는 PyYAML 부재로 실행 실패; 설치 변경 없이 프로젝트 자체 Skill 무결성 검사로 확인했다. 실제 게임 실행·Human 재미·최종 아트·출시는 이번 운영 작업의 검증 범위가 아니다.
- 완료 경계: `POST_COMPLETION_ADVERSARIAL_REVIEW_REQUIRED`의 전체 2회 검토 기록은 `skills/SKILL_LEARNING_LOG.md`; 병합 재결합은 해당 변경분만 확인하고 예산을 초기화하지 않는다. `REMAINING_WORK_COMPLETION_GATE`와 `CLEAN_REVIEW_EXIT`의 병합 결과는 [PR #363](https://github.com/alsdmlals4-eng/urban-legend/pull/363)의 최종 exact HEAD 검사·review·merge 상태 및 병합 후 readback 댓글에서 재조회한다. 이 문서의 병합 전 snapshot을 계속 OPEN 또는 이미 MERGED라고 추정하지 않는다.
- PR: [urban-legend #363](https://github.com/alsdmlals4-eng/urban-legend/pull/363), `codex/base-lean-20260920`. 구현 commit `887167495de8d4658a42cb7b0e109eb314f75be3`를 push하고 원격 exact HEAD를 확인했다. 최초 원격 adapter·문서·Base 채택 검사들은 통과했으나 [core/docs 검사](https://github.com/alsdmlals4-eng/urban-legend/actions/runs/35478252938)는 기존 headless 문제로 실패했다.
- 위 최초 원격 unittest는 496개 중 495 PASS / 동일 1 FAIL이었다. 로컬 pytest 509개와 수집 범위가 다르므로 개수를 합치지 않는다.
- #362 완료: 검토 HEAD `cb41a35fa69dee12312bd365775ac791204fe377`, 독립 검토 blocking/minor 0, 원격 10 workflow·17 checks PASS, 미해결 thread 0을 확인하고 정상 merge `78c10b86c4ac445a43bfb166088d01df02ed5530`. 병합된 파일은 검토 HEAD와 같고 main Python 503 PASS 및 승인 계약/생성물 PASS를 재확인했다. 강제 push·main 직접 push·관리자 우회 없음.
- #363 후속: 위 main을 merge하여 helper 회귀를 해소하고 adapter 보호 기준·파생본을 재결합한다. 승인된 helper 외 보호 경로는 변경하지 않으며 이 PR의 최신 main 대비 제품 diff는 0이어야 한다. Windows 긴 경로·생성물 충돌은 전역 설정 변경 없이 이번 작업의 경로 옵션·기존 생성기로 처리한다.
- 재결합 검증: pytest 509 PASS / unittest 496 PASS, Windows read-order PASS, 운영 계약·생성물 PASS, diff check PASS. 위 main 대비 게임 코드·씬·데이터·자산·addon 변경 0. 원격 검사·재결합 독립 검토·최종 병합은 완료 후 PR 증거로 확인한다.
- #362 병합 후 원격 main 검증도 완료: [full matrix](https://github.com/alsdmlals4-eng/urban-legend/actions/runs/35505500983), [core/Godot](https://github.com/alsdmlals4-eng/urban-legend/actions/runs/35505500969), [live-editor pilot](https://github.com/alsdmlals4-eng/urban-legend/actions/runs/35505501526) PASS. 이는 새 사람 플레이·재미·최종 아트 검증이 아니다.
- 병합 뒤 다음 작업: 원래 브랜치 44개 커밋·19개 tracked import 수정·81개 untracked 상태를 재확인하고 최신 main 및 다른 열린 PR과 중첩을 분류한다. 게임 구현은 별도 승인된 W01~W12 계약의 실제 successor를 따라 M04 정상 입력(CCTV 성공 포함) → 시계/저장 경계 → UI·컷인·일상·사건 확장 → 재미/접근성·문서/전달 순으로 이어간다. 구형 일정제·아카를 복원하거나 #359/#360/#361 등을 무단 병합하지 않는다.

## 보존된 제품 병합 계보 (아래는 당시 snapshot)

# 괴이기록국 Current Handoff

## 2026-09-20 — 명시 승인된 PR #362 교정

- 사용자가 PR #362의 필요한 교정·검증·정상 병합, 이어 PR #363 최신 main 재결합을 승인했다. 다른 열린 PR 및 원래 게임 작업 브랜치는 읽기 전용으로 보존한다.
- 비교 근거: 기존 editor의 headless opt-in, 기존 wrapper 회귀 검사, PR base `c82291101bf0a2bb4d821a12bca9f14070ee2886`, CI의 trusted-baseline 선택식을 실제 대조했다 (`REUSED_EVIDENCE / ADAPT`). 승인 경로 확대나 이미 main에 들어간 PNG 되돌리기는 기각했다.
- 실패 재현: 이전 adapter baseline `a62b534`는 이미 main에서 바뀐 PNG를 이번 변경으로 오인했다. 승인 manifest와 adapter를 실제 PR base에 맞추고 기존 생성기로 파생본을 재생성했다. 보호 경로 목록·정책 hash·release lock·helper implementation 원본은 유지했다.
- 검증: 교정 전 승인 계약 검사 FAIL → 교정 후 PASS. Python 503 PASS. 생성 router만 LF 고정하여 Windows/CI raw-byte 비교를 보존한다. 독립 검토와 원격 exact HEAD·main 병합 확인은 아직 남아 있다.
- 증거 상한: 기획·게임 데이터·승인 자산·저장·설치 플러그인·전역 설정 변경 없음. HUMAN 재미/최종 아트/출시 검증은 NOT_RUN. 롤백은 이 PR의 변경만 Git에서 되돌리며 원래 작업 폴더를 덮어쓰지 않는다.

## 보존된 제품 상태 (당시 snapshot)

> 상태: `PLANNING_COMPLETE / USER_APPROVED_VISUAL_DIRECTION_LOCK / RUNTIME_RECONCILIATION_MERGED / HUMAN_QA_PENDING`
> latest-main reconciliation: PR #322 merge `9fa32d32e8a5a2ad7d34a388695986b4ab81c6a7` (runtime implementation: `8d303f0f9414950273be934fd28c8fb1b3a21e18` · PR #224)
> M04 current-main continuation: PR #356 merge `a62b5341f3c4742192f7bfc0d11e1fb4897c1308` — recovery clocks/menu and main-menu identity surface are `M04_RECOVERY_AND_MENU_MAIN_MERGED`; Human QA remains `NOT_RUN`.
> 사람용 정본: repository `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`와 user PDF GDD
> 구조화 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`
> Notion 이전 영수증: `docs/migrations/NOTION_CURRENT_WORK_MIGRATION_2026-08-28.md` (Notion은 `HISTORICAL_READ_ONLY_NO_WRITE`)

이 문서는 다음 GPT/Codex가 구현 전 handoff나 과거 annual next-step을 현재 권한으로 오인하지 않도록 하는 continuation router다. 실제 구현 사실은 latest `main`의 code/data/Scene/test를 우선한다.

```yaml
status: RUNTIME_RECONCILIATION_MERGED
planning: COMPLETE
user_final_planning_declaration: APPROVED
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
runtime_implementation: MERGED_MAIN
runtime_merge_commit: 8d303f0f9414950273be934fd28c8fb1b3a21e18
product_reference_asset: PENDING
visual_direction_lock: USER_APPROVED
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
ten_day_half_day_cadence: USER_APPROVED / IMPLEMENTED_NON_NUMERIC_CONTEXT / FOCUSED_MACHINE_VERIFIED
one_main_case_runtime_enforcement: IMPLEMENTED / FOCUSED_MACHINE_VERIFIED
keyword_composition: IMPLEMENTED_M01_M04 / DRAFT_ONLY / FOCUSED_MACHINE_VERIFIED / OTHER_CASES_PENDING
player_authored_manual_keyword_verification: USER_APPROVED / IMPLEMENTED_M01_M04 / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN
m04_bounded_preparation_capacity: USER_APPROVED / IMPLEMENTED_M04_ONLY / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN
m04_recovery_and_menu_surface: IMPLEMENTED_MAIN / FOCUSED_MACHINE_RUNTIME_CAPTURED / HUMAN_QA_NOT_RUN
primary_playable_core: INVESTIGATION_DEDUCTION_AND_RECOVERY
calendar_role: SUPPORTING_CAMPAIGN_CONTEXT_NOT_PRIMARY_FUN
```

`PLAN_LOCK`은 predecessor 기획 잠금 식별자이며 현재 값은 `RELEASED_TO_IMPLEMENTATION_GATE`다. 이를 runtime 미승인 상태로 되돌려 해석하지 않는다.

현재 시각 방향은 `D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION`의 **현실적 한국 도시 누아르 환경 + 애니풍 인물·괴이 + 손그림 기록물 UI**다. 이 방향은 `docs/visual/VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md`가 소유하며, 첨부 Core Scene Board는 기획 검증용 `GENERATED_EXPLORATION`일 뿐 runtime asset/Scene/UI/Human QA가 아니다.

현재 accepted frontier는 `D-2026-08-29-PLAYER-AUTHORED-MANUAL-KEYWORD-VERIFICATION`, `D-2026-08-29-CORE-LOOP-PRIORITY`, `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE`, `D-2026-08-28-M04-SEQUENTIAL-NARRATIVE-RESULT-VIGNETTES`, `D-2026-08-30-M04-BOUNDED-PREPARATION-CAPACITY`, `D-2026-08-28-VISUAL-CANDIDATE-GENERATION-LOCK-ONLY-APPROVAL`다. **1차 플레이 경험은 조사·추리와 회수**이며, M01과 M04는 원본 출처가 남은 정상 키워드를 만들고 플레이어가 빈칸 추리문을 직접 채운다. 매뉴얼은 정답·변조·호환 점수를 알려 주지 않으며, 구출 미니게임과 `전조 → 가설 → 근거 → 대응` 회수 결과에서만 후보 규칙을 검증한다. M04는 세 기존 clue ID와 두 기존 rule page를 사건 데이터 하나에서 소비하며, 기록관 아카는 텍스트 안내만 제공한다. 10일·반일 일정은 준비·후일담·관계의 리듬을 주는 보조 캠페인 시스템이다. 현재 `CampaignState`는 첫 operation을 cycle main case로 고정하고 다른 사건의 same-cycle 계획/시작을 거부하며, 실제 완료한 대기·회복 반일을 `현장 준비 1/1` dispatch record로 보존해 M04의 기존 권나래 귀가 지원 가용 여부와 귀가 기억 후일담으로 연결한다. 이 게이트는 stats/정답/추가 지원/자동 발동을 만들지 않는다. 예전 M04 주차 수치와 tier bonus는 `SUPERSEDED`; day-based 새 숫자는 여전히 `UNDEFINED`다. M05+ keyword/manual 확장, M01/M04 entrance candidate의 최종 user `LOCK`, Human/new-player/accessibility/release QA는 여전히 별도 Gate다.

## 1. 재개 순서

```text
최신 사용자 지시
→ GitHub latest main + open PR/Issue + exact-head CI
→ repository current GDD / decision / handoff
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ 실제 current code/data/Scene/test
→ 필요 시 2026-08-22 design/implementation plan과 역사 Ledger
```

## 2. 현재 구현된 제품 계약

- primary playable core: `INVESTIGATION → DEDUCTION / MANUAL → RECOVERY`; the calendar is supporting campaign context, not primary fun.
- approved cadence: `ONE_MAIN_CASE_PER_TEN_DAY_CYCLE / TWO_HALF_DAY_SLOTS_PER_DAY`; runtime implements the first-operation cycle lock, persisted non-numeric dispatch context, and Preparation docket; M04 alone also records one completed rest as a visible `0/1` or `1/1` gate for the existing Kwon support; numeric balance remains undefined.
- result authority: `COMPOSITE_RESULT`.
- legacy S/A/B/S grade는 history/mastery compatibility이며 current incident result를 덮어쓰지 않는다.
- additive optional `monthly_state`는 historical generic orchestration이며 case truth를 저장하지 않는다. 새 10일 timing consumer를 아직 소유하지 않는다.
- M01 저승역은 `M01_FIRST_SESSION` 10단계 causal orchestration과 `SERIAL_EXAM_FATIGUE_GUARD`를 사용한다.
- M01은 기존 Canon v2 loader/save migration/result runtime을 재사용한다.
- 메인 메뉴 제품 버전은 `scripts/core/product_version.gd`의 `Ver 4.3`이 중앙 owner다.
- 메인 메뉴는 관제실형 3-rail 구조를 사용하고 Legacy / Validation save·route 분리를 유지한다.
- M04 빨간 우산은 shared Investigation/Manual/Rescue/Recovery/Composite Result validation baseline까지 구현됐다.
- PR #356은 M04의 안정도 8칸·위험도 6칸 회수 시계, 우측 하단 `괴이 매뉴얼 열기`, 안정도 조건의 자동 회수 전환, legacy `대표 교체`·`회수 실행` 제거와 메인 메뉴의 archive/워드마크/분리 action plate를 current main에 통합했다.
- current keyword/manual state is split by coverage: CASE-01 and M04 page-local keyword composition are `IMPLEMENTED / MACHINE_VERIFIED`, while M05+ rollout and any mutated-candidate field-verification extension remain outside this slice.
- clarified manual contract: the player must fill readable blank sentences from investigation memory and provenance; the UI cannot reveal semantic correctness. Rescue/minigame and recovery are the field verification, not an automatic answer checker. CASE-01 and M04 candidate arrays/input consumers are implemented, CASE-01 complete-manual auto-reveal is disabled, and every player draft remains separate from Canon migration slots.

## 3. PR #224 postmerge Reality Gate

완료:
- `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED` → `REALIGNED_TO_LEGACY_MASTERY_COMPATIBILITY`.
- `MONTHLY_STATE_NOT_IMPLEMENTED` → `IMPLEMENTED_ADDITIVE_OPTIONAL`.
- M01 First Session orchestration → `IMPLEMENTED`.
- #181 main menu / Ver 4.3 → `IMPLEMENTED`; Issue #181 closed after merged-main readback.
- M04 shared-system validation baseline → `IMPLEMENTED`.

보존:
- 기존 Episode/victim/report/ANNUAL IDs rename 금지.
- legacy report만으로 month completion 추론 금지.
- 필수 진실을 성장·동료·장비·자동행동이 제공하지 않음.
- Human PASS를 자동화로 생성하지 않음.

## 4. 자동 검증 증거

PR #224 exact head에서 다음 계열이 GREEN이었다.
- core and documentation baseline
- full matrix
- Afterlife Station Canon v2 migration
- Canon v2 Runtime UX
- ANNUAL-MVP-001 / CORE-MVP-001
- Windows platform preflight
- documentation contracts
- visual capture automation

`Project Base Adapter`의 fail-closed 신호는 PR #226에서 공식 Base generator로 reconciliation했다. protected baseline은 `6b4a9e8080898536139c8e825179b389f8bf9d64`으로 갱신됐고, adapter/generated views 검증과 core full Godot regression이 GREEN인 exact head를 `9073b4730993149f89970a13fbe32d49f8f473e7`로 병합했다.

PR #356 integration exact head에서는 recovery clock 17건, direct-lead 12건, overlay 8건, dual-clock scene 12건의 focused Godot checks가 GREEN이었고, `docs/qa/captures/m04-current-main-integration/`에 메인·회수·매뉴얼-open capture가 남아 있다. 이 증거는 machine/runtime capture이며 Human/new-player/accessibility/device/release PASS가 아니다.

## 5. Product reference / Human gate

### 2026-08-28 visual-status clarification

`PRODUCT_REFERENCE_ASSET_PENDING`은 모든 자산이 미승격이라는 뜻이 아니다. 개별 제품 승인·runtime 상태는 `ASSET_MANIFEST.yml`과 `CURRENT_VISUAL_WORK_ORDER.md`가 소유한다. 현재 root manifest의 9개 entry 중 M01 Investigation/Recovery background, M01 B/C·D cutout, CASE-01 루메 매뉴얼 보조 초상, M04 Investigation/Recovery background, M04 B/C·D cutout은 각각의 승인·구현·runtime evidence를 가진다. 반면 M01 Entrance, M04 Entrance와 Human/new-player/accessibility/release QA는 별도 Gate에 남는다.


`PRODUCT_REFERENCE_ASSET_PENDING` 유지:
- concrete M01/M04 이미지·레이어
- rights/source approval
- 최종 1280×720 / 1920×1080 가독성
- release-near M04 visual/audio/VFX polish

Exception recorded: M01 D-risk `afterlife_d_cutout.png` is `PROJECT_ASSET_APPROVED / IMPLEMENTED / 1280_RUNTIME_VERIFIED` under Issue #246. Its 1920×1080 capture and Human QA remain pending; this exception does not promote other M01/M04 assets.

Human QA는 계속 `NOT_RUN`:
- M01 첫 세션 이해도
- serial-exam fatigue 체감
- M04 재미/첫인상/차별화
- 접근성·실제 입력 체감

## 6. Base governance reconciliation 완료

- PR #226에서 project-pinned Base generator를 사용해 adapter + generated views를 갱신했다.
- protected baseline: `6b4a9e8080898536139c8e825179b389f8bf9d64`.
- reconciliation merge: `9073b4730993149f89970a13fbe32d49f8f473e7`.
- 제품 `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot` 재변경 없이 Project Base Adapter 및 Base 9.4.x 검증을 GREEN으로 닫았다.
- 남은 제품 Gate는 실제 Human QA와 product-reference asset 승인/후속 release-near 구현이다.

## 7. 이전 구현 계약의 역할

다음 문서는 완료된 구현의 설계·계획 provenance로 보존한다.
- `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`
- `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

이 문서들을 다시 Task 1부터 실행하지 않는다. 새 작업은 latest main의 실제 상태에서 successor를 판정한다.

## 8. 완료 판정 경계

현재 **runtime reconciliation implementation은 main 병합 완료**다. 그러나 프로젝트 전체 제품 완료를 의미하지 않는다.

```yaml
runtime_reconciliation: COMPLETE_MERGED
human_qa: NOT_RUN
product_reference_asset: PENDING
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
```
