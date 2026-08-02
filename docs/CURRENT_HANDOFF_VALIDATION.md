# 괴이기록국 Validation 현재 인수인계

> 상태: `PACKAGE_1_MERGED / AUTOMATED_CI_VERIFIED / PACKAGE_2_PLANNING_NEXT`
> 갱신일: 2026-08-02
> 현재 main: `80160218d05e79af5442bf27d8fdeb66bcf05723`
> Canon merge: PR #125 / `595d45454621900e858a903fef0598a03349b794`
> Implementation merge: PR #126 / `80160218d05e79af5442bf27d8fdeb66bcf05723`
> Grill Me future counter: `0 / 10`

## 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/GRILLME_APPROVAL_MERGE_LEDGER.md
→ docs/decisions/D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY.md
→ docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md
→ docs/superpowers/plans/2026-08-02-validation-session-save-isolation-implementation-plan.md
→ docs/implementation/2026-08-02-package-1-session-save-isolation-evidence.md
→ docs/implementation/2026-08-02-package-1-retarget-merge-gate.md
→ 실제 main 코드·테스트
```

## 현재 상태

```yaml
base: 9.4.0
main: 80160218d05e79af5442bf27d8fdeb66bcf05723
canon: MERGED
package_1_planning: APPROVED_AND_MERGED
persistence_boundary: APPROVED_AND_IMPLEMENTED
package_1_design: APPROVED_AND_EXECUTED
package_1_implementation: MERGED
package_1_ci: PASS
validation_focused: 4_OF_4_PASS
full_godot_regression: 53_OF_53_PASS
package_2: NOT_PLANNED_YET
runtime_human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
platform: PC_16_9_MOUSE_KEYBOARD
mobile: DEFERRED_AFTER_PC_VALIDATION
```

## 승인 Target

```text
무인 메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 가설·시간순 증거
→ 안전 노선 복원
→ 회수 2패턴
→ 결과 4축·최소 환류
→ 메인 복귀
```

상세는 `docs/VALIDATION_TARGET_CANON.md`가 소유한다.

## Package 1에서 구현된 것

### ValidationSaveRepository

- `user://urban_legend_validation_save.json` 독립 namespace
- Legacy 경로 접근 차단
- temp write → readback → replace
- 정상 backup 1세대
- corrupt·schema·older/newer·interrupted·recoverable 판정
- 명시적 quarantine

### ValidationSession

- create·activate·save·load·suspend·resume·complete·abandon·delete lifecycle
- token·episode·lifecycle fail-closed
- completion apply-once ID
- hidden Legacy memory guard

### GameState adapter

- 기존 `scripts/core/game_state.gd` 본체를 직접 수정하지 않음
- `validation_game_state.gd` 상속 wrapper
- inactive 시 기존 save 유지
- active valid 시 Validation save routing
- active invalid 시 Validation·Legacy 양쪽 저장 차단
- field-level runtime whitelist와 restore prevalidation

### Autoload·검증

```text
UrbanLegendState
→ ValidationSession
→ GameState(validation_game_state.gd)
→ MCP helper
```

- Documentation contracts PASS
- BCA Adoption PASS
- Godot 4.7.1 import PASS
- Validation focused 4/4 PASS
- CORE·ANNUAL focused PASS
- full Godot regression 53/53 PASS

## 아직 구현되지 않은 것

- main-menu의 Legacy/Validation 시작·이어하기 구분
- Validation 전용 축약 준비 Scene
- Validation 전용 Reasoning Scene
- Validation 전용 결과 Scene
- 전체 SCREEN-01→SIT-008→메인 복귀 routing
- 신규 플레이어 검증
- 1280×720 시각·입력 검증
- 모바일

이 항목들은 Package 1 완료 주장에 포함하지 않는다.

## GitHub 상태

```yaml
pr_125: MERGED
pr_126: MERGED
pr_122: SOURCE_DO_NOT_MERGE_AS_IS
pr_120: CLOSED_SUPERSEDED
```

PR #122의 현재 유효한 승인 내용은 `CURRENT_CONFIRMED_DECISIONS`와 `VALIDATION_TARGET_CANON`으로 승계했다. source PR 자체는 stale·중복 권위를 되살리므로 병합하지 않는다.

## Grill Me 운영

- 역사 승인분: `HISTORICAL_BATCH_0` 완료
- 미래 카운터: `0 / 10`
- 승인된 Grill Me Decision ID마다 +1
- 10개 도달 시 GitHub·Sheet·PR·CI 최종 적대적 검토 후 병합
- source-only·superseded·blocked PR은 제외
- Canon과 구현은 별도 PR·별도 승인·별도 검증

책임 원본:

- `docs/decisions/D-2026-08-02-GRILLME-10-MERGE-CADENCE.md`
- `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`

## 다음 Gate

```text
Package 2 범위 기획
→ main-menu entry·continue UX
→ ValidationSession 생성/재개 routing
→ Legacy 저장 비파괴 계약 유지
→ 전용 준비·추론·결과 Scene의 최소 범위 확정
→ 적대적 검토
→ 사용자 구현 승인
```

## 미검증 경계

```yaml
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
