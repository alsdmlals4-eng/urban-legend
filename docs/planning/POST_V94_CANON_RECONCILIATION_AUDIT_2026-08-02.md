# Base v9.4 이후 괴이기록국 정본·Sheet 적대적 감사

> Audit ID: `R-2026-08-02-POST-V94-CANON-RECONCILIATION`
> Decision: `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> Work Mode: `PLAN → REVIEW → BUILD(docs only) → REVIEW`
> 제품 변경: `NONE`
> Runtime / Human: `NOT_RUN`

## 1. 감사 범위

- Base 저장소의 현재 진입 규칙, 28개 활성 Skill 운영 구조, 결정 동기화 정책
- 프로젝트 `main`의 Base v9.4 채택 상태와 시작 라우터
- `CURRENT_STATUS`, `PROJECT_CORE`, 문서 지도, Base Adapter
- 열린 Issue #121, Draft PR #120·#122, 최근 병합 PR #124
- Google GDD Sheet 27개 탭의 구조와 핵심 운영 탭
- Validation 승인 Target과 현재 구현 Legacy의 분리 상태
- 기존 Validation 구현 계획의 최신 파일·함수 전제

전체 tracked-file tree를 로컬 clone으로 대조하지 못했으므로 저장소 전체 파일 인벤토리는 `BLOCKED_UNVERIFIED`다. Connector로 확인한 권위 문서·열린 작업·핵심 런타임 경로에 대한 감사이며, 이를 전체 저장소 무결성 PASS로 확대하지 않는다.

## 2. 현행 구조 이해

### Base

- Base v9.4는 28개 활성 공용 Skill을 Registry에서 선택한다.
- 프로젝트에서는 공용 Base route 28개와 프로젝트 분야 route 10개를 `skills/PROJECT_BASE_ADAPTER.json`으로 결합한다.
- 기본 운영은 하나의 주 Work Mode와 최소 Skill 조합을 사용한다.
- 승인 결정은 `CURRENT_CONFIRMED_DECISIONS.md`, 상세 책임 원본, GitHub, Google Sheet에 동일 Decision ID로 기록한다.
- 실제 구현과 승인 Target이 다르면 자동 덮어쓰지 않고 `CANON_CONFLICT`로 분리한다.

이번 작업의 선택:

- 주 책임: `managing-game-project-operating-system / audit`
- 지원: `running-adversarial-review-and-refinement / repository-wide-audit`
- 지원: `auditing-canonical-reference-freshness`
- 지원: `managing-project-intake-and-work-contract`
- Superpowers: brainstorming, verification-before-completion

### 프로젝트

- 실제 구현 원본: `docs/CURRENT_STATUS.md` + 실제 `main` 코드·데이터·테스트
- 장기 제품 코어: `docs/PROJECT_CORE.md`, `docs/GAME_DESIGN_DOCUMENT.md`
- 현재 Base: v9.4.0, PR #124, main `7277b9ce...`
- 현재 구현: CORE-MVP-001과 ANNUAL-MVP-001/002 Legacy/PoC가 존재
- 승인 Target: 35~50분 저승역 Validation Cut
- 사람 사용성·신규 플레이어 검증: `NOT_RUN`
- 제작 확대: `NOT_APPROVED`

## 3. 공격 관점

다음 질문으로 상태를 공격했다.

1. 승인 정본을 새 작업자가 `main`만 읽고 복원할 수 있는가?
2. Sheet가 실제 Base 버전과 현재 Gate를 표시하는가?
3. 열린 PR이 동일 Goal을 중복하거나 구형 기준선을 현행처럼 보이게 하는가?
4. 승인 Target이 현재 구현 완료로 오인될 수 있는가?
5. 구현 계획의 파일·함수·저장 전제가 최신 `main`과 일치하는가?
6. PC Validation에 모바일 범위가 암묵적으로 섞이는가?
7. 자동·시각 증거가 사람 검증을 대신한다고 표기되는가?

## 4. Finding

### F-001 — 승인 정본이 `main`에 없음

- 심각도: `P0 / MUST_FIX`
- 증거: `docs/CURRENT_CONFIRMED_DECISIONS.md`, `docs/VALIDATION_TARGET_CANON.md`가 PR #122에만 존재
- 영향: 새 작업자가 `main`에서 최종 승인 Target을 복원하지 못함
- 처리: 최신 main 기반 브랜치에 두 정본을 재설치

### F-002 — Base 상태 드리프트

- 심각도: `P0 / MUST_FIX`
- GitHub main: Base v9.4
- PR #122·Sheet: Base v9.1 current / v9.3 PR #120 HOLD
- 영향: 잘못된 Adapter·Skill·계획 기준선 선택
- 처리: `D-2026-08-02`로 v9.4 현재값과 PR #120 superseded를 동기화

### F-003 — PR #122를 그대로 병합할 수 없음

- 심각도: `P0 / MUST_FIX`
- 상태: Draft, `mergeable=false`, 100 commits, 59 docs files
- 본문 HEAD와 실제 GitHub HEAD 불일치
- 영향: 구형 Base 문서가 최신 main을 되돌리거나 대규모 충돌을 유발
- 처리: source branch로 격리하고 승인 Canon만 최신 main에 재작성

### F-004 — PR #120 목적 상실

- 심각도: `P1 / MUST_FIX`
- 기존 목적: Base v9.3 이관 준비
- 새 사실: Base v9.4가 main에 병합됨
- 처리: `SUPERSEDED_BY_BASE_V9_4_MAIN`, 미병합 종료

### F-005 — AGENTS의 활성 BCA v8 문구

- 심각도: `P1 / MUST_FIX`
- 영향: `c987...`와 Prompt v8을 현행 Base 기준으로 오해
- 처리: v9.4를 활성 기준으로 명시하고 v8을 Legacy compatibility로 격하

### F-006 — 구현 계획의 존재하지 않는 파일

- 심각도: `P1 / MUST_FIX`
- `scripts/core/game_bootstrap.gd`: 최신 main에 없음
- 실제 시작·이어하기: `scripts/ui/main_menu.gd`가 `GameState.restart_afterlife_station_flow`, `save_game`, `load_game`, `current_scene_path`를 직접 사용
- 처리: bootstrap 전제를 제거한 읽기 전용 기술 계획 작성

### F-007 — 결과 진입 부작용 중복 위험

- 심각도: `P1 / MUST_FIX_BEFORE_BUILD`
- `result_scene.gd::_ready()`가 진입 즉시 `GameState.record_current_case_report()` 호출
- 저장 복귀·Scene 재진입·Validation 결과 기록을 추가하면 보고서·보상 중복 가능
- 처리: idempotency key와 applied effect ledger를 먼저 설계·검증

### F-008 — 회수 상태 소유권 중복

- 심각도: `P1 / MUST_FIX_BEFORE_BUILD`
- 기존 `battle_scene.gd`는 GuidedDecisionStep, 선택 가설, 증거, 응답, 안정도·두려움·임계값을 소유
- 신규 ValidationFlowState가 동일 상태를 다시 소유하면 정본 이중화
- 처리: Flow state는 전환·checkpoint·idempotency만 소유하고 도메인 판단 상태는 별도 specialist state 또는 기존 CaseData 계약과 단일화

### F-009 — Sheet의 CURRENT 표 불변성 부족

- 심각도: `P1 / MUST_FIX`
- 동일 `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS`가 초안·REV-2 형태로 CURRENT 표에 중복
- `VALIDATION-SCREEN-AUTHORITY`의 사후 정산 복귀가 최종 Target에서 일부 대체됐지만 Sheet 분류는 완전 CURRENT처럼 보임
- 처리: 02 탭에는 현재 행 하나만 유지하고 이전 Revision은 99 변경이력으로 이동; 대체 상태 명시

### F-010 — 검증 증거 상한

- 심각도: `P1 / OPEN_GATE`
- 자동·정적 시각 검증은 존재하지만 신규 플레이어·사람 장시간 사용성은 미실행
- 처리: `NOT_RUN` 유지, Build Ready·POC Passed·제작 확대 선언 금지

### F-011 — 모바일 범위 혼입 위험

- 심각도: `P2 / DEFER`
- 사용자 방향: PC 우선, 이후 모바일 고려
- 처리: 현재 Validation에는 모바일를 포함하지 않고 PC 통과 뒤 입력·레이아웃·성능·배포를 별도 Decision으로 설계

## 5. 작업 진행도 판정

| 영역 | 상태 | 다음 Gate |
|---|---|---|
| 프로젝트 코어 | `RECORDED / IMPLEMENTED_BASELINE_EXISTS` | 사람 이해 검증 |
| CORE-MVP-001 | `POC_BUILD_READY / HUMAN_NOT_RUN` | 신규 플레이어 검증 |
| ANNUAL-MVP-001/002 | `IMPLEMENTED_AUTOMATED_VISUAL_QA / HUMAN_NOT_RUN` | 사람 사용성·신규 플레이어 검증 |
| Validation 기획 | `APPROVED_FINAL_PLANNING_BASELINE` | 최신 main 정본 복구 |
| Validation 정본 | `BRANCH_ONLY_DRIFT` → 이번 작업에서 복구 | PR 검증·main 반영 |
| Validation 기술 계획 | `STALE_ASSUMPTIONS_FOUND` | 읽기 전용 최신화 |
| Validation 구현 | `NOT_AUTHORIZED / NOT_STARTED` | CHANGE_PROPOSAL·패키지 승인 |
| 모바일 | `FUTURE_CONSIDERATION` | PC Validation 뒤 별도 기획 |
| 제작 확대 | `NOT_APPROVED` | Human Gate 이후 |

## 6. 적용한 최소 개선

- Base v9.4 정본 재조정 Decision 추가
- 현재 확정 결정 인덱스 복구
- Validation Target Canon 복구
- 최신 main용 Validation Handoff 추가
- 존재하지 않는 파일·중복 부작용·상태 소유권을 다루는 읽기 전용 기술 계획 추가
- 시작 라우터와 AGENTS의 현행 Base·정본 경로 갱신
- Google Sheet 핵심 운영 탭을 동일 Decision ID로 갱신

## 7. 미실행·차단

- 로컬 clone 기반 전체 tracked-file inventory: `BLOCKED_UNVERIFIED`
- Python/Godot test execution: `NOT_RUN` — docs-only connector 변경, 로컬 실행 환경 없음
- Godot runtime·입력·해상도 QA: `NOT_RUN`
- 사람 플레이·신규 플레이어 검증: `NOT_RUN`
- 모바일 검증: `NOT_IN_SCOPE`
- PR merge: `NOT_AUTHORIZED`

## 8. 최종 판정

```text
CANON_CONFLICT_CONFIRMED
→ MINIMAL_RECONCILIATION_APPLIED_ON_LATEST_MAIN_BRANCH
→ PRODUCT_PATHS_UNTOUCHED
→ READ_ONLY_TECHNICAL_PLAN_REQUIRED
→ NOT_BUILD_READY
```
