# 괴이기록국 현재 확정 결정

> 문서 역할: `CURRENT_CONFIRMED_DECISIONS`
> 상태: `CURRENT`
> 갱신일: 2026-08-01
> 추적: Issue #121 / Draft PR #122
> 상세 Target 정본: `docs/VALIDATION_TARGET_CANON.md`
> Google GDD Sheet: `02_현재_확정결정`, `99_변경이력`
> 제품 구현 권한: `NONE`

이 문서는 현재 유효한 사용자 승인 결정을 복원하는 단일 인덱스다. 시스템 상세는 연결된 책임 원본이 소유한다.

## 1. 권위 순서

```text
최신 사용자 승인
→ 이 문서의 CURRENT Decision
→ docs/VALIDATION_TARGET_CANON.md
→ 각 Decision 상세 문서
→ 프로젝트 코어·GDD의 충돌하지 않는 장기 제품 계약
→ CURRENT_STATUS의 실제 구현 상태
→ 실제 main 코드·데이터·Scene·테스트
→ 과거 설계·PR·대화·추정
```

실제 구현이 이 문서와 다르면 승인 Target을 구현 완료로 간주하지 않는다. `CURRENT_IMPLEMENTATION_LEGACY`와 `APPROVED_TARGET_NOT_IMPLEMENTED`로 분리한다.

## 2. 현재 제품 Target

Decision:

- `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL`

상태:

- `APPROVED_FINAL_PLANNING_BASELINE`
- Canon Pass: `AUTHORIZED`
- 제품 구현: `NOT_AUTHORIZED`
- Runtime / Human QA: `NOT_RUN`

대표 흐름:

```text
무인 메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 사건 가설·시간순 증거
→ 안전 노선 복원
→ 회수 2패턴
→ 결과 4축·최소 환류
→ 메인 복귀
```

## 3. CURRENT Decision 목록

| Decision ID | 상태 | 핵심 | 상세 책임 원본 |
|---|---|---|---|
| `D-2026-07-31-CANON-SHEET-SYNC` | CURRENT_APPROVED_GOVERNANCE | 승인 즉시 GitHub·Sheet 동일 ID 동기화 | `docs/decisions/D-2026-07-31-CANON-SHEET-SYNC.md` |
| `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION` | APPROVED_PLANNING_BASELINE | 일반 조사·일반 플레이는 텍스트 노벨 화면 | `docs/decisions/D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION.md` |
| `D-2026-07-31-VISUAL-ART-DIRECTION` | APPROVED_PLANNING_BASELINE | 다크 현대 오컬트·세미리얼 애니·기관 UI | `docs/visual/VISUAL_ART_DIRECTION.md` |
| `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY` | APPROVED / SUPERSEDED_IN_PART | 시작·축약 준비·가설/회수 책임 분리 | `docs/decisions/D-2026-07-31-VALIDATION-SCREEN-AUTHORITY.md` |
| `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS` | APPROVED_PLANNING_BASELINE | 일정·연구·보급을 기준 화면으로 유지 | `docs/decisions/D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS.md` |
| `D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION` | APPROVED_PLANNING_BASELINE | 하루 주요 활동 1개·자동 기본 휴식·다일 연속 점유 | `docs/decisions/D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION.md` |
| `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE` | APPROVED_PLANNING_BASELINE | 23:57:42 개인 청취가 23:59:08 승차권 접촉보다 먼저 | `docs/decisions/D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE.md` |
| `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS` | APPROVED_PLANNING_BASELINE | 회수 2패턴·분류/기록/중립 행동·복구 1회 | `docs/decisions/D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS.md` |
| `D-2026-08-01-SCHEDULE-REST-SEMANTICS` | APPROVED_TARGET_NOT_IMPLEMENTED | 기본 휴식 자동 소량 회복·전일 회복 주요 활동 | `docs/decisions/D-2026-08-01-SCHEDULE-REST-SEMANTICS.md` |
| `D-2026-08-01-PROVISIONING-AUTHORITY` | APPROVED_TARGET_NOT_IMPLEMENTED | 기록국 보급실 정식 조달·소문시장 외부 접점 | `docs/decisions/D-2026-08-01-PROVISIONING-AUTHORITY.md` |
| `D-2026-08-01-VALIDATION-SCOPE-FILTER` | APPROVED_TARGET_NOT_IMPLEMENTED | 핵심만 노출·숨긴 기능 무부작용 | `docs/decisions/D-2026-08-01-VALIDATION-SCOPE-FILTER.md` |
| `D-2026-08-01-LEGACY-PR-DISPOSITION` | APPROVED_OPERATIONAL_DECISION | PR #120 HOLD·구형 PR 미병합 종료 | `docs/decisions/D-2026-08-01-LEGACY-PR-DISPOSITION.md` |
| `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE` | APPROVED_PLANNING_BASELINE | SCREEN-01~07·SIT-001~008·A~G | `docs/decisions/D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE.md` |
| `D-2026-08-01-VALIDATION-RESULT-AXES` | APPROVED_PLANNING_BASELINE | 결과 원시 4축·4단계 요약·상한 | `docs/decisions/D-2026-08-01-VALIDATION-RESULT-AXES.md` |
| `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION` | APPROVED_PLANNING_BASELINE | Legacy 병렬 저장·flow stage·중복 방지 | `docs/decisions/D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION.md` |
| `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL` | CURRENT_APPROVED_GOVERNANCE | 현재 기획 작업 권장안 일괄 승인 | `docs/decisions/D-2026-08-01-RECOMMENDED-BATCH-APPROVAL.md` |
| `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL` | APPROVED_FINAL_PLANNING_BASELINE | 전체 Validation 기획 최종 승인·Canon Pass 허용 | `docs/decisions/D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL.md` |

## 4. 대체·보존 관계

### 결과 복귀

이전:

```text
결과 → preparation_scene 사후 정산
```

현재 Validation:

```text
SCREEN-04 결과·보고서·최소 환류 → SCREEN-01 메인
```

전체 제품에서는 추후 SCREEN-05 다음 날짜로 연결한다.

### 회수

이전 저승역 구현의 `가설→근거→대응` 4패턴은 `CURRENT_IMPLEMENTATION_LEGACY`다.

현재 Validation:

```text
전조→분류→기록→중립 행동→현장 결과→추론 검증
```

패턴 2개만 노출한다.

### 시간

- ANNUAL-MVP-001/002의 주간 일괄 편성: `CURRENT_IMPLEMENTATION_LEGACY`
- preparation_scene의 오전·오후 반일: `CURRENT_IMPLEMENTATION_LEGACY`
- 현재 제품 Target: 하루 주요 활동 1개 + 자동 기본 휴식

### 저장

- 본편 `mvp-039`: 유지
- ANNUAL PoC 저장: 유지
- Validation 저장: 미구현 Target
- 강제 변환·무통보 삭제: 금지

## 5. 시각·테스트 상태

- `UL-IMG-007`: `APPROVED_PLANNING_VISUALIZATION / NOT_PRODUCT_ASSET`
- 시각 검수: `R-2026-08-01-UL-IMG-007-VISUAL-REVIEW`
- 플레이테스트 설계: `PT-2026-08-01-VALIDATION-SCREEN-SIT`
- Runtime: `NOT_RUN`
- 신규 플레이어: `NOT_RUN`
- 1280×720 제품 화면: `NOT_RUN`
- 최종 캐릭터·배경·UI 에셋: `NOT_STARTED`

## 6. Base 채택

- 현재 프로젝트 Adapter: Base v9.1
- Base v9.3 PR #120: `DRAFT_HOLD`
- Canon Pass 전 병합·cherry-pick·새 migration PR 생성 금지
- Canon Pass 완료 뒤 최신 main 기준으로 재평가

## 7. 다음 작업

```text
Canon Pass
→ reference·상태·Sheet 검증
→ writing-plans
→ Codex 읽기 전용 기술 Plan
→ 변경 제안 검수
→ 구현 패키지 승인
→ 마지막에 Codex Build Goal
```

## 8. 동기화 상태

- GitHub branch: `BRANCH_SYNCED_PENDING_MAIN`
- Google Sheet: 관련 Decision·작업순서·감사·콘텐츠·UX·이미지·테스트·변경이력 동기화
- main: `PENDING`
- 제품 파일: 변경 없음
