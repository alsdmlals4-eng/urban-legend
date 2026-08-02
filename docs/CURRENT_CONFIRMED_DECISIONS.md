# 괴이기록국 현재 확정 결정

> 문서 역할: `CURRENT_CONFIRMED_DECISIONS`
> 상태: `CURRENT_PENDING_MAIN`
> 갱신일: 2026-08-02
> 추적: Issue #121 / Draft PR #122 / Base v9.4 PR #124
> 상세 Target 정본: `docs/VALIDATION_TARGET_CANON.md`
> 운영 재조정: `docs/decisions/D-2026-08-02-BASE-V94-CANON-RECONCILIATION.md`
> Google GDD Sheet: `02_현재_확정결정`, `99_변경이력`
> 제품 구현 권한: `NONE`

이 문서는 현재 유효한 사용자 승인 결정을 복원하는 단일 인덱스다. 구현 완료 여부는 `docs/CURRENT_STATUS.md`와 실제 `main` 코드·데이터·테스트가 소유한다.

## 1. 권위 순서

```text
최신 사용자 승인
→ AGENTS.md의 보호·엔진·데이터 규칙
→ 이 문서의 CURRENT Decision
→ docs/VALIDATION_TARGET_CANON.md
→ 등록된 분야 책임 원본
→ docs/CURRENT_STATUS.md의 실제 구현 상태
→ 실제 main 코드·데이터·Scene·테스트
→ 프로젝트 Base v9.4 Adapter
→ 과거 PR·대화·추정
```

실제 구현이 승인 Target과 다르면 `CURRENT_IMPLEMENTATION_LEGACY`와 `APPROVED_TARGET_NOT_IMPLEMENTED`로 분리한다. 어느 한쪽을 자동으로 덮어쓰지 않는다.

## 2. 현재 제품 Target

- Decision: `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL`
- 상태: `APPROVED_FINAL_PLANNING_BASELINE`
- Canon 복구: `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
- 제품 구현: `NOT_AUTHORIZED`
- Runtime / Human QA: `NOT_RUN`
- 플랫폼: `PC / Steam / 16:9 / mouse+keyboard`
- 모바일: `FUTURE_CONSIDERATION_NOT_IN_CURRENT_VALIDATION_SCOPE`

대표 흐름:

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

## 3. CURRENT Decision 목록

| Decision ID | 상태 | 핵심 | 상세 책임 원본 |
|---|---|---|---|
| `D-2026-07-31-CANON-SHEET-SYNC` | CURRENT_APPROVED_GOVERNANCE | 승인된 주요 결정을 GitHub·Sheet에 같은 ID로 동기화 | 이 문서 §8, Base 동기화 정책 |
| `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION` | APPROVED_PLANNING_BASELINE | 일반 조사·일반 플레이는 텍스트 노벨 화면 | `VALIDATION_TARGET_CANON.md` §4·§5 |
| `D-2026-07-31-VISUAL-ART-DIRECTION` | APPROVED_PLANNING_BASELINE | 다크 현대 오컬트·세미리얼 애니·기관 UI | `VALIDATION_TARGET_CANON.md` §9 |
| `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY` | SUPERSEDED_IN_PART | 시작·준비·조사·전문 절차 책임 분리; 사후 정산 복귀는 최종 Target이 대체 | `VALIDATION_TARGET_CANON.md` §3·§5 |
| `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS` | APPROVED_PLANNING_BASELINE | 일정·연구·보급을 장기 제품 기준 화면으로 유지 | `VALIDATION_TARGET_CANON.md` §5 SCREEN-05~07 |
| `D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION` | APPROVED_PLANNING_BASELINE | 하루 주요 활동 1개·자동 기본 휴식·다일 연속 점유 | `VALIDATION_TARGET_CANON.md` §5 SCREEN-05 |
| `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE` | APPROVED_PLANNING_BASELINE | 23:57:42 개인 청취가 23:59:08 승차권 접촉보다 먼저 | `VALIDATION_TARGET_CANON.md` §6 SIT-005 |
| `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS` | APPROVED_PLANNING_BASELINE | 회수 2패턴·분류/기록/중립 행동·패턴당 복구 1회 | `VALIDATION_TARGET_CANON.md` §6 SIT-007 |
| `D-2026-08-01-SCHEDULE-REST-SEMANTICS` | APPROVED_TARGET_NOT_IMPLEMENTED | 기본 휴식 자동 소량 회복·전일 회복은 주요 활동 | `VALIDATION_TARGET_CANON.md` §5 SCREEN-05 |
| `D-2026-08-01-PROVISIONING-AUTHORITY` | APPROVED_TARGET_NOT_IMPLEMENTED | 기록국 보급실 정식 조달·소문시장 선택 외부 접점 | `VALIDATION_TARGET_CANON.md` §5 SCREEN-07 |
| `D-2026-08-01-VALIDATION-SCOPE-FILTER` | APPROVED_TARGET_NOT_IMPLEMENTED | 핵심만 노출하고 숨긴 기능은 무부작용 | `VALIDATION_TARGET_CANON.md` §8 |
| `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE` | APPROVED_PLANNING_BASELINE | SCREEN-01~07·SIT-001~008·실패 복구 | `VALIDATION_TARGET_CANON.md` §3~§7 |
| `D-2026-08-01-VALIDATION-RESULT-AXES` | APPROVED_PLANNING_BASELINE | 결과 원시 4축·4단계 요약·규칙 미검증 상한 | `VALIDATION_TARGET_CANON.md` §5 SCREEN-04 |
| `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION` | APPROVED_PLANNING_BASELINE | Legacy 병렬 저장·flow stage 우선 복귀·중복 방지 | `VALIDATION_TARGET_CANON.md` §7·§10 |
| `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL` | CURRENT_APPROVED_GOVERNANCE | Issue #121/PR #122 범위의 기획·감사·정본 동기화 권장안 일괄 승인 | Issue #121 승인 댓글 |
| `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL` | APPROVED_FINAL_PLANNING_BASELINE | 전체 Validation 기획 최종 승인 | `VALIDATION_TARGET_CANON.md` 전체 |
| `D-2026-08-01-LEGACY-PR-DISPOSITION` | SUPERSEDED_IN_PART | 구형 PR 미병합 원칙 유지; PR #120 HOLD는 v9.4 채택으로 대체 | 아래 Decision |
| `D-2026-08-02-BASE-V94-CANON-RECONCILIATION` | CURRENT_APPROVED_GOVERNANCE | Base v9.4 현행화·PR #120 종료·PR #122 소스 격리·최신 main 정본 복구 | `docs/decisions/D-2026-08-02-BASE-V94-CANON-RECONCILIATION.md` |

## 4. 대체·보존 관계

### 결과 복귀

- Legacy: `결과 → preparation_scene 반일 정산`
- Validation Target: `SCREEN-04 결과·보고서·최소 환류 → SCREEN-01 메인`
- 장기 제품: 추후 SCREEN-05 다음 날짜 연결을 별도 구현한다.

### 회수

- Legacy: `가설→근거→대응` 4패턴
- Validation Target: `전조→분류→기록→중립 행동→현장 결과→추론 검증`, 2패턴 노출

### 일정

- ANNUAL-MVP-001/002 주간 일괄 편성: `CURRENT_IMPLEMENTATION_LEGACY`
- preparation_scene 오전·오후 반일: `CURRENT_IMPLEMENTATION_LEGACY`
- 제품 Target: 하루 주요 활동 1개 + 자동 기본 휴식

### 저장

- 본편 `mvp-039`: 유지
- `mvp-038` 이관 지원: 유지
- ANNUAL PoC 저장: 유지
- Validation 저장: `APPROVED_TARGET_NOT_IMPLEMENTED`
- 강제 변환·무통보 삭제: 금지

### GitHub 작업

- PR #120: `SUPERSEDED_BY_BASE_V9_4_MAIN`
- PR #122: `SUPERSEDED_SOURCE_BRANCH / DO_NOT_MERGE_AS_IS`
- 최신 정본 브랜치: Base v9.4 `main`에서 새로 생성

## 5. 시각·테스트 상태

- `UL-IMG-007`: `APPROVED_PLANNING_VISUALIZATION / NOT_PRODUCT_ASSET`
- 플레이테스트 설계: `PT-2026-08-01-VALIDATION-SCREEN-SIT`
- 정적 시각 기획 검수: `COMPLETE`
- Godot Runtime: `NOT_RUN`
- 신규 플레이어 검증: `NOT_RUN`
- 사람 장시간 사용성: `NOT_RUN`
- 1280×720 제품 화면: `NOT_RUN`
- 최종 캐릭터·배경·UI 에셋: `NOT_STARTED`
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`

## 6. Base 채택

```yaml
base_version: 9.4.0
project_main_adoption: 7277b9cececa56532f7b0d11c1a02fd3d5642750
payload: a728712cb776ec98f4875914a580fcf7d0156593
trusted_evidence: ef1fba11167e4da0b298123b0c85ebd268191a42
registry_sha256: 693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59
```

`c987647d...`와 BCA v8는 Legacy compatibility input이다. 현행 작업 기준으로 사용하지 않는다.

## 7. 다음 작업

```text
D-2026-08-02 정본·Sheet 재조회
→ 최신 main actual-file/signature/save-policy 읽기 전용 기술 Plan
→ CHANGE_PROPOSAL 적대적 검토
→ 구현 패키지 재승인
→ 별도 승인 뒤 Codex Build Goal
→ 자동·시각·사람 검증
```

우선 검수할 기술 위험:

1. 존재하지 않는 `scripts/core/game_bootstrap.gd` 전제 제거
2. `main_menu.gd`의 Legacy/Validation 저장·이어하기 분리
3. `result_scene.gd` 진입 시 보고서 기록의 중복 적용 방지
4. `GameState`의 거대 저장 소유권을 침범하지 않는 격리 경계
5. investigation/battle의 기존 가설·근거·회수 상태와 신규 flow state의 중복 권위 방지

## 8. 동기화 상태

- GitHub `main`: `PENDING_PR_MERGE`
- 최신 정본 브랜치: `BRANCH_SYNC_IN_PROGRESS`
- Google Sheet: `D-2026-08-02`로 갱신 후 재조회
- 제품 파일: 변경 없음
- Runtime / Human: `NOT_RUN`
