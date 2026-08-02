# 괴이기록국 현재 확정 결정

> 문서 역할: `CURRENT_CONFIRMED_DECISIONS`
> 상태: `CURRENT_ON_MAIN`
> 갱신일: 2026-08-02
> 현재 main: `80160218d05e79af5442bf27d8fdeb66bcf05723`
> 상세 Target: `docs/VALIDATION_TARGET_CANON.md`
> 현재 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`
> Grill Me ledger: `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`
> Google Sheet: `02_현재_확정결정`, `04_누락_충돌_감사`, `99_변경이력`

이 문서는 현재 유효한 사용자 승인 결정과 대체 관계를 소유한다. 실제 구현 사실은 main 코드·테스트와 Package 1 구현 증거가 우선하며, 실행하지 않은 사람·시각 검증은 승인으로 간주하지 않는다.

## 1. 권위 순서

```text
최신 사용자 승인
→ AGENTS.md 보호 규칙
→ 이 문서
→ docs/VALIDATION_TARGET_CANON.md
→ 분야별 책임 원본
→ 실제 main 코드·데이터·Scene·테스트
→ 자동 검증 증거
→ Google Sheet 동일 Decision ID
→ 과거 PR·대화·추정
```

source-only·superseded PR은 현재 권위가 아니다.

## 2. 현재 제품·구현 상태

```yaml
base_version: 9.4.0
main: 80160218d05e79af5442bf27d8fdeb66bcf05723
platform: PC_16_9_MOUSE_KEYBOARD
mobile: DEFERRED_AFTER_PC_VALIDATION
validation_target: APPROVED_FINAL_PLANNING_BASELINE
package_1_design: APPROVED
package_1_implementation: MERGED
package_1_automated_ci: PASS
validation_focused: 4_OF_4_PASS
full_godot_regression: 53_OF_53_PASS
human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
future_grillme_counter: 0_OF_10
```

Package 1은 Session·Save isolation 기반만 구현했다. main-menu 진입, 전용 준비·추론·결과 Scene과 전체 플레이 흐름은 후속 Package다.

## 3. 승인 Validation 흐름

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

상세 규칙은 `docs/VALIDATION_TARGET_CANON.md`가 소유한다.

## 4. 현재 Decision 목록

| Decision ID | 현재 상태 | 핵심 | 현재 책임 원본 |
|---|---|---|---|
| `D-2026-07-31-CANON-SHEET-SYNC` | CURRENT_APPROVED_GOVERNANCE | 주요 승인을 GitHub·Sheet에 같은 ID로 동기화 | 이 문서·Sheet |
| `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION` | APPROVED_PLANNING_BASELINE | 일반 조사·플레이는 텍스트 노벨 화면 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-VISUAL-ART-DIRECTION` | APPROVED_PLANNING_BASELINE | 다크 현대 오컬트·세미리얼 애니·기관 UI | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY` | SUPERSEDED_IN_PART | 화면 책임 분리; 결과 복귀는 최종 Target이 대체 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS` | APPROVED_LONG_TERM_TARGET | 일정·연구·보급 화면 유지 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION` | APPROVED_LONG_TERM_TARGET | 하루 주요 활동 1개·자동 기본 휴식 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE` | APPROVED_PLANNING_BASELINE | 23:57:42 개인 청취가 23:59:08 승차권 접촉보다 먼저 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS` | APPROVED_PLANNING_BASELINE | 회수 2패턴·분류/기록/중립 행동 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-SCHEDULE-REST-SEMANTICS` | APPROVED_TARGET_NOT_IMPLEMENTED | 기본 휴식·전일 회복 의미 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-PROVISIONING-AUTHORITY` | APPROVED_TARGET_NOT_IMPLEMENTED | 기록국 보급실·선택 외부 접점 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-SCOPE-FILTER` | APPROVED_TARGET_NOT_IMPLEMENTED | 핵심만 노출하고 숨긴 기능은 무부작용 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE` | APPROVED_PLANNING_BASELINE | SCREEN-01~07·SIT-001~008·실패 복구 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-RESULT-AXES` | APPROVED_PLANNING_BASELINE | 결과 원시 4축·규칙 미검증 상한 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION` | PARTLY_IMPLEMENTED_PACKAGE_1 | Legacy 병렬 저장·복귀·중복 방지 계약 | Canon + Package 1 evidence |
| `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL` | CURRENT_APPROVED_GOVERNANCE | 안전 권장안 일괄 승인 범위 | 역사 reconciliation |
| `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL` | APPROVED_FINAL_PLANNING_BASELINE | 전체 Validation 기획 최종 승인 | `VALIDATION_TARGET_CANON.md` |
| `D-2026-08-01-LEGACY-PR-DISPOSITION` | SUPERSEDED_IN_PART | 구형 PR 직접 병합 금지 원칙 유지 | Base v9.4 reconciliation |
| `D-2026-08-02-BASE-V94-CANON-RECONCILIATION` | MERGED_CURRENT_GOVERNANCE | Base v9.4·PR #122 source 격리·정본 복구 | Decision 문서·PR #125 |
| `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL` | MERGED_APPROVED_PLANNING | 기획·명세·적대적 검토 우선 | Decision 문서·PR #125 |
| `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY` | MERGED_AND_IMPLEMENTED | Validation 기록은 본편·Legacy와 완전 독립 | Decision 문서·PR #126 |
| `D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL` | MERGED_AND_EXECUTED | Session·Save isolation Design 승인 | Spec·Plan·PR #125 |
| `D-2026-08-02-PACKAGE-1-IMPLEMENTATION-APPROVAL` | MERGED_AND_AUTOMATED_CI_VERIFIED | Package 1 구현·테스트 승인 | PR #126·implementation evidence |
| `D-2026-08-02-PACKAGE-1-SEPARATE-MERGE-AUTHORIZATION` | EXECUTED | #125 병합→#126 retarget·재검증→별도 병합 | Merge gate·Sheet |
| `D-2026-08-02-GRILLME-10-MERGE-CADENCE` | CURRENT_APPROVED_GOVERNANCE | 미래 Grill Me 승인 10개마다 적대적 병합 batch | Decision 문서·ledger |

## 5. 영속·저장 경계

```text
Validation 진행·완료 기록 = user://urban_legend_validation_save.json
Legacy 본편 기록 = user://urban_legend_save.json
공용 프로필 = 생성하지 않음
본편 자동 공유·즉시 보상 = 금지
본편 가져오기 = 별도 Decision 전까지 보류
```

Package 1 main 구현:

- 별도 Validation repository
- atomic temp/readback/replace와 backup
- corrupt/version/interrupted 판정
- 명시적 quarantine
- ValidationSession lifecycle
- completion apply-once
- hidden Legacy memory guard
- GameState field whitelist wrapper
- invalid active Session의 양쪽 저장 fail-closed

## 6. GitHub 병합·PR 상태

```yaml
pr_125: MERGED
pr_125_merge: 595d45454621900e858a903fef0598a03349b794
pr_126: MERGED
pr_126_merge: 80160218d05e79af5442bf27d8fdeb66bcf05723
pr_122: SOURCE_DO_NOT_MERGE_AS_IS
pr_120: CLOSED_SUPERSEDED
```

PR #122의 유효 승인 내용은 이 문서와 `VALIDATION_TARGET_CANON.md`로 통합 승계했다. PR #122 자체를 병합하지 않는 것이 승인 누락이 아니라 중복·stale 권위 방지다.

## 7. Grill Me 병합 운영

- 과거 승인분: `HISTORICAL_BATCH_0`으로 조정 완료
- 미래 카운터: `0 / 10`
- 카운트: 승인된 Grill Me Decision ID만
- 10개 도달: GitHub·Sheet·PR·CI 적대적 검토 후 병합
- source-only·superseded·blocked PR: 숫자를 맞추기 위해 병합 금지
- Canon PR과 구현 PR: 분리
- 최신 HEAD CI만 유효

책임 원본:

- `docs/decisions/D-2026-08-02-GRILLME-10-MERGE-CADENCE.md`
- `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`
- `docs/planning/HISTORICAL_GRILLME_APPROVAL_RECONCILIATION_2026-08-02.md`

## 8. 검증 증거와 한계

자동 검증:

- Documentation contracts: PASS
- BCA Adoption: PASS
- Godot 4.7.1 import: PASS
- Validation focused: 4/4 PASS
- CORE focused: PASS
- ANNUAL-001/002 focused: PASS
- full Godot regression: 53/53 PASS

미검증:

```yaml
local_runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
full_validation_product_flow: NOT_IMPLEMENTED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 9. 다음 Gate

```text
Package 2 기획
→ main-menu에서 Legacy/Validation 저장을 명시적으로 구분
→ Validation 진입 routing
→ 전용 축약 준비·추론·결과 Scene 범위 확정
→ 별도 구현 승인
```
