# 괴이기록국 기획 진행 상태 — 2026-08-01

> 상태: `PLANNING_IN_PROGRESS / A_G_APPROVED / VISUALIZATION_IN_PROGRESS`
> 추적: Issue #121 / Draft PR #122
> 기준 main: `656846865eb88871d00842a0da527ce1b0722b77`
> 구현 권한: `NONE`
> Codex: `HOLD`
> Runtime / Visual / Human QA: `NOT_RUN`
> 이전 상태: `docs/planning/PLANNING_PROGRESS_2026-07-31.md` — 역사 기록

## 1. 현재 승인 기준선

### 제품 흐름

```text
SCREEN-01 무인 메인
→ SIT-001 저승역 콜드 오픈
→ SIT-002 기록국 브리핑
→ SIT-003 축약 준비
→ SIT-004 텍스트 노벨 조사
→ SIT-005 사건 가설
→ SIT-006 시간순 증거·안전 노선 복원
→ SIT-007 회수 2패턴
→ SIT-008 결과 4축·최소 환류
→ SCREEN-01 메인 복귀
```

### 화면·상황

- 기준 화면: SCREEN-01~07
- 전문 절차: 사건 가설 / 시간순 증거 / 안전 노선 복원 / 회수 2패턴
- 전문 절차는 SCREEN-02 아래의 제품 흐름으로 계산한다.
- 일반 조사·일반 플레이는 텍스트 노벨 방식이다.
- 메인 화면에는 캐릭터를 표시하지 않는다.
- 일정은 하루 주요 활동 1개와 자동 기본 휴식을 사용한다.
- 2~3일 활동은 같은 주 연속 날짜를 점유한다.
- 다일 활동 중 강제 출동은 날짜 경계에서 중단하고 완료 일수와 남은 일수를 보존한다.
- SCREEN-07은 기록국 보급실이 정식 권위를 소유한다.
- Validation 비핵심 기능은 비노출이며 판정·난수·로그·자원·저장을 변경하지 않는다.

### 사건·회수·결과

- 시간순 증거: `23:57:42 개인 목적지 청취 < 23:59:08 검은 승차권 최초 접촉`
- 회수: 전조 → 분류 → 기록 → 중립 행동 → 현장 결과 → 추론 검증
- 회수 패턴당 첫 오대응 뒤 복구 1회
- 결과 원시 축:
  1. 현장 안정화
  2. 피해자 구조
  3. 규칙 검증
  4. 괴이 핵·잔향 회수
- 요약 단계: 미해결 / 임시 안정화 / 제한적 해결 / 완전 해결
- 규칙 미검증 또는 반박 상태에서는 `임시 안정화`를 넘지 못한다.

### 저장·복귀

- 기존 `mvp-039`는 Legacy 저장으로 보존한다.
- Validation은 `flow_stage → checkpoint → return target → scene fallback` 우선순위를 사용한다.
- 잘못된 가설은 수정·재제출할 수 있다.
- 노선 실패는 재시도 또는 미해결 철수로 진행한다.
- 중복 피해·보상·보고서 적용을 금지한다.
- 원시 결과 축이 요약 등급보다 권위가 높다.

## 2. 승인 Decision

| Decision ID | 상태 | 책임 |
|---|---|---|
| `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION` | APPROVED_PLANNING_BASELINE | 일반 조사 표현 |
| `D-2026-07-31-VISUAL-ART-DIRECTION` | APPROVED_PLANNING_BASELINE | 다크 현대 오컬트·세미리얼 애니 |
| `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY` | APPROVED / SUPERSEDED_IN_PART | 시작·준비·가설/회수 책임 |
| `D-2026-08-01-SCHEDULE-REST-SEMANTICS` | APPROVED_TARGET_NOT_IMPLEMENTED | 기본 휴식·전일 회복 |
| `D-2026-08-01-PROVISIONING-AUTHORITY` | APPROVED_TARGET_NOT_IMPLEMENTED | 기록국 보급실·소문시장 분리 |
| `D-2026-08-01-VALIDATION-SCOPE-FILTER` | APPROVED_TARGET_NOT_IMPLEMENTED | 핵심 노출·비핵심 무부작용 |
| `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE` | APPROVED_PLANNING_BASELINE | A~G 화면·상황 계약 |
| `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS` | APPROVED_PLANNING_BASELINE | 회수 2패턴·복구 |
| `D-2026-08-01-VALIDATION-RESULT-AXES` | APPROVED_PLANNING_BASELINE | 결과 4축·상한·환류 |
| `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION` | APPROVED_PLANNING_BASELINE | Legacy 병렬 저장·테스트 |
| `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL` | CURRENT_APPROVED_GOVERNANCE | 현재 작업 권장안 일괄 승인 |

## 3. Base·프로젝트·Sheet 감사·검증

책임 원본:

- `docs/planning/BASE_PROJECT_SHEET_OPERATING_AUDIT_2026-08-01.md`
- `docs/planning/BASE_PROJECT_SHEET_OPERATING_VERIFY_2026-08-01.md`

확인 범위:

- Base START_HERE·AGENTS·운영 모델·Documentation Map·Registry·27개 활성 Skill
- 프로젝트 START_HERE·AGENTS·CURRENT_STATUS·PROJECT_CORE·GDD·Roadmap·Skill Adapter
- Google GDD Sheet 27개 탭 전체
- 열린 PR #120·#122와 최근 병합 PR
- 승인 Decision·실제 Scene/Script/JSON/테스트의 기존 감사 증거

판정:

- 프로젝트 현행 Base v9.1 Adapter 유지
- Base v9.3 PR #120은 Draft/HOLD
- PR #122 Canon Pass 전 병합·cherry-pick·새 migration PR 생성 금지
- Canon Pass 뒤 최신 main을 기준으로 PR #120 재평가
- CURRENT 구현과 APPROVED Target은 병렬 표기
- 상위 정본의 Legacy 계약은 최종 기획 승인 뒤 단일 Canon Pass에서 교체

검증 기준 HEAD `f7337149a6e9b4b80dd99c982a504e908e5acca5`:

- 제품 보호 경로 diff: 0
- 변경 파일: docs 전용
- Documentation Contracts run #496: PASS
- BCA Adoption run #102: PASS
- PR #122 review threads: 0
- Sheet 재조회: PASS_AFTER_ONE_CORRECTION

## 4. 현재 진행도

| 단계 | 상태 |
|---|---|
| A~G 사용자 승인 | COMPLETE |
| 승인 Decision GitHub 정본 | COMPLETE |
| Google Sheet 확정결정·관련 탭 | COMPLETE_AND_READ_BACK |
| Base·프로젝트·Sheet 적대적 감사 | COMPLETE |
| 운영 동기화 검증 기록 | COMPLETE |
| SCREEN/SIT 비주얼 브리프 | APPROVED |
| SCREEN 보드 A | IN_PROGRESS |
| SCREEN 보드 B | IN_PROGRESS |
| SIT 보드 C1~C4 | IN_PROGRESS |
| 이미지 적대적 중간점검 | NOT_RUN |
| 플레이테스트 패키지 | PENDING_VISUAL_REVIEW |
| 사용자 기획 최종 승인 상태 기록 | PENDING |
| 상위 정본 Canon Pass | BLOCKED_BY_VISUAL_AND_FINAL_APPROVAL |
| writing-plans | HOLD |
| Codex Goal | HOLD |
| 제품 구현 | NOT_AUTHORIZED |

## 5. Visual Gate

Image ID:

- `UL-IMG-007`

산출물:

- 보드 A: SCREEN-01~04
- 보드 B: SCREEN-05~07
- 보드 C1: SIT-001~002
- 보드 C2: SIT-003~004
- 보드 C3: SIT-005~006
- 보드 C4: SIT-007~008

규칙:

- 화면·상황별 별도 16:9 보드
- 직전 과밀 통합 보드 재사용 금지
- `CURRENT_IMPLEMENTATION_LEGACY`와 `APPROVED_TARGET_NOT_IMPLEMENTED` 혼합 금지
- 각 요소에 CURRENT / INFERRED / PROPOSED / PLACEHOLDER 태그
- 다크 현대 오컬트·세미리얼 애니·기록국 문서형 UI
- 제품 에셋·특정 IP·사용자 레퍼런스 이미지 복제 금지

## 6. 이미지에서 재검토할 P2 위험

1. 결과 4축·등급·환류를 한 번에 펼친 과밀
2. 회수 행동 문구가 기록을 읽지 않아도 정답처럼 보이는 문제
3. Legacy 이어하기와 Validation 이어하기의 구분
4. 다일 활동 중단이 삭제·실패처럼 보이는 문제
5. 전문 절차 4개가 별도 게임 4개처럼 분절되는 문제
6. 팀 상태 Popover와 최소 HUD의 발견성

## 7. Canon Migration 경계

상위 정본 실제 내용 교체는 아직 수행하지 않는다.

대상:

- `docs/PROJECT_CORE.md`
- `docs/GAME_DESIGN_DOCUMENT.md`
- `docs/CURRENT_STATUS.md`
- `docs/DOCUMENTATION_MAP.md`
- `docs/planning/README.md`
- `MVP_ROADMAP.md`
- `TEST_CHECKLIST.md`
- `docs/CURRENT_HANDOFF.md`

순서:

```text
비주얼 보드
→ 이미지 중간점검
→ 플레이테스트 패키지
→ 사용자 기획 최종 승인 상태 기록
→ 단일 Canon Pass
```

기존 ANNUAL·CORE 구현·테스트·저장은 삭제하지 않고 `CURRENT_IMPLEMENTATION_LEGACY` 또는 `HISTORICAL_EVIDENCE`로 보존한다.

## 8. 다음 Gate

```text
SCREEN 보드 A·B 생성
→ SIT 보드 C1~C4 생성
→ 이미지 적대적 중간점검
→ UL-IMG-007 검수 로그
→ Validation 플레이테스트 패키지
→ 최종 기획 적대적 검토
→ 사용자 기획 최종 승인 상태 기록
→ 상위 정본 Canon Pass
→ Base v9.3 PR #120 재평가
→ writing-plans
→ 마지막에 Codex Goal
```
