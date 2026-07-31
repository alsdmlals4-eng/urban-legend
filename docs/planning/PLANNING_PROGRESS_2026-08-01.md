# 괴이기록국 기획 진행 상태 — 2026-08-01

> 상태: `PLANNING_IN_PROGRESS / SCREEN_SIT_PACKAGE_READY_FOR_USER_REVIEW`
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> Codex: `HOLD`
> Runtime / Human QA: `NOT_RUN`
> 이전 상태 문서: `docs/planning/PLANNING_PROGRESS_2026-07-31.md` — 역사 기록, 최신 상태로 사용하지 않음

## 1. 승인 기준선

- Validation Cut 35~50분 우선
- 조사·일반 플레이는 텍스트 노벨 방식
- 비주얼은 다크 현대 오컬트·세미리얼 애니
- 메인 화면에는 캐릭터를 표시하지 않음
- 기준 화면 7종: 메인 / 텍스트 조사 / 준비 / 결과 / 일정 / 연구 / 기록국 보급실
- 일정은 하루 주요 활동 1개 + 자동 기본 휴식
- 2~3일 주요 활동은 같은 주 연속 날짜 점유
- 별도 일상 활동 카탈로그 없음
- 기록국 보급실은 정규 조달, 소문시장은 선택 외부 접점
- Validation 비핵심 기능은 비노출·무부작용
- 저승역 시간순 증거: `23:57:42 개인 목적지 청취 < 23:59:08 검은 승차권 최초 접촉`
- 주요 승인 변경은 GitHub·Sheet 동일 Decision ID로 동기화

## 2. 2026-08-01 승인 결정

### D-2026-08-01-SCHEDULE-REST-SEMANTICS

```text
기본 휴식
= 매일 자동 적용되는 소량 피로 회복

전일 회복·치료
= 하루 주요 활동을 소비하는 큰 회복
```

### D-2026-08-01-PROVISIONING-AUTHORITY

```text
기록국 보급실
= 정규 준비·조달 권위

소문시장
= 선택적 외부 접점 콘텐츠
```

### D-2026-08-01-VALIDATION-SCOPE-FILTER

전면 노출:

- 축약 준비
- 텍스트 조사
- 가설·시간순 증거
- 안전 노선 복원
- 회수 2패턴
- 결과 4축·최소 환류

비노출:

- 랜덤 이벤트
- 세력 의뢰
- 소문시장
- 일상 에피소드
- 전체 4주 운영
- 복잡한 자동 행동·관계·시장 경제
- 회수 패턴 3·4

### D-2026-08-01-LEGACY-PR-DISPOSITION

- PR #120: Draft / HOLD
- PR #54: 유효 개념 기록 후 미병합 종료
- PR #26: 유효 개념 기록 후 미병합 종료

## 3. Canon Migration

책임 원본:

- `docs/planning/CANON_MIGRATION_BUNDLE_2026-08-01.md`

상태:

```text
CURRENT_IMPLEMENTATION_LEGACY
APPROVED_TARGET_NOT_IMPLEMENTED
HISTORICAL_EVIDENCE
HOLD
```

상위 `PROJECT_CORE`·GDD·CURRENT_STATUS·DOCUMENTATION_MAP의 실제 내용 교체는 기획 최종 승인 뒤 단일 Canon Pass에서 진행한다.

## 4. 이번 작업 산출물

### SPEC-2026-08-01-VALIDATION-SCREEN-SIT

경로:

- `docs/superpowers/specs/2026-08-01-validation-screen-situation-design.md`

포함:

- SCREEN-01~07 책임
- CURRENT / APPROVED / DRAFT / EXCLUDED 구분
- 화면별 상태 변형
- SIT-001~008
- 전체 전환도
- Godot 구조 경계
- 저장 체크포인트
- 테스트 마이그레이션 초안

상태: `DRAFT_REQUIRES_USER_REVIEW`

### D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS REV-2

- 회수 패턴 2개만 Validation 노출
- 분류·기록·행동 분리
- 짧은 중립 행동 문구
- 패턴당 첫 오대응 후 복구 1회
- 행동 성공과 추론 검증 분리

상태: `DRAFT_REQUIRES_USER_REVIEW`

### D-2026-08-01-VALIDATION-RESULT-AXES

- 현장 안정화
- 피해자 구조
- 규칙 검증
- 괴이 핵·잔향 회수
- 미해결 / 임시 안정화 / 제한적 해결 / 완전 해결
- 규칙 미검증·반박 시 임시 안정화 상한
- 연구 질문 1개·보급 후보 1개

상태: `DRAFT_REQUIRES_USER_REVIEW`

### DRAFT-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION

- Legacy / Validation 모드 분리
- Validation은 `flow_stage`·checkpoint 우선 권장
- Scene 경로는 호환 fallback
- 기존 mvp-039 강제 변환 금지
- 전문 절차 return target
- 중복 효과 적용 금지
- Legacy 테스트와 Validation 테스트 병렬 유지

상태: `DRAFT_REQUIRES_USER_REVIEW`

### R-2026-08-01-VALIDATION-SCREEN-SIT-ADVERSARIAL

판정:

- P1 전환·권위 충돌: 검토 단계에서 보정
- P2 문구·과밀·보상 감정 위험: 사람·비주얼 검증 필요
- 제품 구현: `BLOCKED`
- 사용자 검수: `READY`

## 5. 적대적 검토 보정 계약

### 기준 화면과 전문 절차

기준 화면은 7개를 유지한다.

```text
SCREEN-02 텍스트 노벨 조사
  ├─ 사건 가설
  ├─ 시간순 증거
  ├─ 안전 노선 복원
  └─ 회수 2패턴
```

전문 절차는 구현상 독립 Scene일 수 있지만 별도 기준 화면으로 세지 않는다.

### 실패·복구

- 잘못된 가설: 수정·재제출 가능
- 최종 미검증·반박 상태: 진행 가능, 결과 등급 상한
- 노선 실패: 재시도 또는 미해결 철수
- 최소 안전 노선 없이 회수 진입 금지
- 회수 첫 오대응: 복구 1회
- 두 번째 실패: 위험 사례 확정 후 다음 패턴 또는 결과

### Validation 종료

- 별도 8번째 완료 화면 없음
- SCREEN-04에서 완료 처리
- 사건 보고서 저장 후 메인 복귀
- 전체 제품에서는 향후 SCREEN-05 다음 날짜로 연결

## 6. 권장 사용자 검수 패키지 A~G

### A. 화면·전문 절차

- 기준 화면 7개 유지
- 가설·시간순·노선·회수는 SCREEN-02 전문 절차

### B. 텍스트 노벨 최소 HUD

- 사건명 / 장소 / 기록 / 설정
- 팀 상태는 Popover
- 수집률·예측률·회수 퍼센트 상시 제외

### C. 추천 편성

- 권나래 고정
- 오현·강이준 추천

### D. 실패·복구

- 가설 수정·재제출
- 노선 재시도 또는 미해결 철수
- 회수 패턴당 복구 1회

### E. 결과

- 네 원시 축
- 4단계 요약 등급
- 규칙 미검증·반박 시 임시 안정화 상한
- 제한적 해결은 잔향 회수 실패 허용

### F. 저장

- Validation은 `flow_stage` 우선
- mvp-039는 Legacy 유지
- 전문 절차 return target 저장
- 원시 결과 축이 요약 등급보다 우선

### G. 종료·일정 충돌

- Validation은 SCREEN-04에서 완료 후 메인 복귀
- 다일 활동 중 강제 출동은 날짜 경계 중단
- 완료 일수 보존·남은 일수 재배치
- 반일 분할 금지

## 7. 감사 Finding 상태

| Finding | 상태 |
|---|---|
| 정본 이중화 | Canon 권위 순서 설정 / 상위 내용 교체 대기 |
| 일정 3중 계약 | 목표 책임 확정 / 구현 이관 대기 |
| 기본 휴식·전일 회복 | RESOLVED_IN_PLANNING |
| 기록국 보급실·소문시장 | RESOLVED_IN_PLANNING |
| Validation 비핵심 기능 | RESOLVED_IN_PLANNING |
| 구형 PR 처리 | RESOLVED_OPERATIONALLY |
| SCREEN-01~07 정본 | DRAFT_READY_FOR_USER_REVIEW |
| SIT-001~008 | DRAFT_READY_FOR_USER_REVIEW |
| 회수 2패턴 문구 | REV-2_READY_FOR_USER_REVIEW |
| 결과 4축·등급 상한 | DRAFT_READY_FOR_USER_REVIEW |
| 저장·테스트 마이그레이션 | DRAFT_READY_FOR_USER_REVIEW |
| 비주얼 화면 보드 | BLOCKED_BY_USER_REVIEW |
| 사람 플레이 검증 | NOT_RUN |

## 8. 현재 Gate

```yaml
screen_01_to_07_spec: DRAFT_REQUIRES_USER_REVIEW
sit_001_to_008_spec: DRAFT_REQUIRES_USER_REVIEW
specialist_flow_count: FOUR_UNDER_SCREEN_02
recovery_patterns: REV_2_DRAFT_REQUIRES_USER_REVIEW
result_four_axis_contract: DRAFT_REQUIRES_USER_REVIEW
save_test_migration: DRAFT_REQUIRES_USER_REVIEW
adversarial_review: PASS_FOR_USER_REVIEW
visual_boards: HOLD_UNTIL_USER_REVIEW
upper_canon_content_rewrite: HOLD_UNTIL_FINAL_DESIGN_APPROVAL
runtime: NOT_RUN
human_validation: NOT_RUN
production_expansion: NOT_APPROVED
codex: HOLD
```

## 9. 다음 Gate

```text
사용자 A~G 검수
→ 승인 Decision·Sheet 확정결정 동기화
→ SCREEN-01~07 비주얼 보드 A/B
→ SIT 상황 보드 C1~C4
→ 이미지 중간점검
→ 플레이테스트 패키지 최종 적대적 검토
→ 사용자 기획 최종 승인
→ 상위 정본 단일 Canon Pass
→ writing-plans
→ 마지막에 Codex Goal
```
