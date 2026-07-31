# 괴이기록국 기획 진행 상태 — 2026-08-01

> 상태: `PLANNING_IN_PROGRESS / AUDIT_DECISIONS_APPROVED`
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> Codex: `HOLD`
> Runtime / Human QA: `NOT_RUN`
> 이전 상태 문서: `docs/planning/PLANNING_PROGRESS_2026-07-31.md` — 역사 기록, 최신 상태로 사용하지 않음

## 승인 기준선

- Validation Cut 35~50분 우선
- 조사·일반 플레이는 텍스트 노벨 방식
- 비주얼은 다크 현대 오컬트·세미리얼 애니
- 메인 화면에는 캐릭터를 표시하지 않음
- 기준 화면 7종: 메인 / 텍스트 조사 / 준비 / 결과 / 일정 / 연구 / 기록국 보급실
- Validation 화면 흐름: 메인 → 콜드 오픈 → 브리핑 → 축약 준비 → 조사 → 가설 → 시간순 증거 → 노선 복원 → 회수 → 결과 → 사후 정산
- 일정은 하루 단위, 주요 활동 1개
- 2~3일 주요 활동은 같은 주의 연속 날짜 자동 점유
- 별도 일상 활동 카탈로그는 없음
- 저승역 시간순 증거: 23:57:42 개인 목적지 청취 < 23:59:08 검은 승차권 최초 접촉
- 주요 승인 변경은 GitHub·Sheet 동일 Decision ID로 동기화

## 2026-08-01 감사 후 승인 결정

### D-2026-08-01-SCHEDULE-REST-SEMANTICS

```text
기본 휴식
= 매일 자동 적용되는 소량 피로 회복

전일 회복·치료
= 하루 주요 활동을 소비하는 큰 회복
```

- 상태: `APPROVED_PLANNING_BASELINE`
- 기존 자동 휴식·직접 휴식·반일 대기/회복은 Legacy 구현 증거로 보존
- 구현 권한: `NONE`

### D-2026-08-01-PROVISIONING-AUTHORITY

```text
기록국 보급실
= 정규 준비·조달 권위

소문시장
= 선택적 외부 접점 콘텐츠
```

- SCREEN-07 세계관 명칭: `기록국 보급실`
- 화면 분류명: `보급·조달`
- 소문시장은 Validation에서 비노출
- Benchmark Gate: `PASSED`
- 구현 권한: `NONE`

### D-2026-08-01-VALIDATION-SCOPE-FILTER

Validation 전면 노출:

- 축약 준비 1회
- 텍스트 조사
- 사건 원인 가설
- 시간순 증거
- 안전 노선 복원
- 회수 2패턴
- 결과 4축·최소 환류

Validation 비노출:

- 랜덤 이벤트
- 세력 의뢰
- 소문시장
- 일상 에피소드
- 전체 4주 운영
- 복잡한 자동 행동·관계·시장 경제
- 회수 패턴 3·4

비노출 시스템은 판정·난수·로그·상태 변경을 실행하지 않는다.

### D-2026-08-01-LEGACY-PR-DISPOSITION

- PR #120: Draft 유지 / `HOLD`
- PR #54: 유효 개념 기록 후 종료
- PR #26: 유효 개념 기록 후 종료
- 오래된 브랜치를 현재 main에 그대로 병합하지 않음

## Canon Migration

### docs/planning/CANON_MIGRATION_BUNDLE_2026-08-01.md

상태: `CANON_ALIGNMENT_ACTIVE / PRODUCT_IMPLEMENTATION_BLOCKED`

기획 단계 권위 순서:

1. 2026-08-01 승인 Decision
2. 2026-07-31 승인 Decision 최신 개정
3. 본 진행 상태
4. 전체 적대적 감사
5. 동일 ID의 Google Sheet 행
6. 기존 상위 정본과 과거 PoC 문서

기존 상위 문서는 현재 구현 설명을 유지하되 새 승인 목표와 충돌하면 `CURRENT_IMPLEMENTATION_LEGACY`로 해석한다.

상위 정본의 실제 내용 교체는 SCREEN/SIT·저장·테스트 계약과 사용자 기획 최종 승인 뒤 단일 Canon Pass에서 진행한다.

## 감사 Finding 처리 상태

| Finding | 상태 |
|---|---|
| 정본 이중화 | Canon 권위 순서 설정 / 상위 내용 교체 대기 |
| 일정 3중 계약 | 목표 책임 확정 / 구현 이관 대기 |
| 기본 휴식·전일 회복 | `RESOLVED_IN_PLANNING` |
| 기록국 보급실·소문시장 | `RESOLVED_IN_PLANNING` |
| Validation 비핵심 기능 | `RESOLVED_IN_PLANNING` |
| 구형 PR 처리 | `APPROVED / EXECUTION_IN_PROGRESS` |
| 가설 보드·전문 화면 Gate | 미구현 |
| 회수 2패턴 중립 문구 | 최종 검수 필요 |
| 결과 4축·등급 상한 | 최종 검수 필요 |
| SCREEN/SIT 정본 | 미작성 |
| 저장·테스트 마이그레이션 | 미작성 |
| 사람 플레이 검증 | `NOT_RUN` |

## 다음 P0

```text
1. 구형 PR 주석·종료 처리
2. Google Sheet Decision·Legacy/Target 상태 정렬
3. SCREEN-01~07 CURRENT / INFERRED / PROPOSED 정본
4. SIT-001~008 시퀀스와 전체 전환도
5. 회수 2패턴 분류·중립 행동 최종 승인
6. 결과 4축·해결 등급 상한·연구 환류 승인
7. 저장·테스트 마이그레이션 계획
8. 플레이테스트 패키지 적대적 검토
9. 사용자 기획 최종 승인
10. 상위 정본 단일 Canon Pass
11. Codex Goal은 마지막
```

## 현재 Gate

```yaml
full_project_adversarial_audit: REVIEW_COMPLETE
user_audit_review: APPROVED_RECOMMENDED_PACKAGE
schedule_daily_input: APPROVED_PLANNING_BASELINE
schedule_rest_semantics: APPROVED_PLANNING_BASELINE
procurement_authority: APPROVED_PLANNING_BASELINE
screen_07_benchmark: PASSED
validation_scope_filter: APPROVED_PLANNING_BASELINE
legacy_pr_disposition: APPROVED_OPERATIONAL_DECISION
canon_authority_hierarchy: ACTIVE
upper_canon_content_rewrite: HOLD_UNTIL_FINAL_DESIGN_APPROVAL
validation_product_router: NOT_IMPLEMENTED
case_hypothesis_board: NOT_IMPLEMENTED
timeline_evidence: APPROVED_NOT_IMPLEMENTED
route_restore_required_gate: NOT_ENFORCED
recovery_patterns: DRAFT_REQUIRES_USER_REVIEW
result_four_axis_contract: DRAFT_REQUIRES_REVIEW
screen_01_to_07_spec: NOT_STARTED
sit_001_to_008_spec: NOT_STARTED
save_test_migration_plan: NOT_STARTED
human_validation: NOT_RUN
production_expansion: NOT_APPROVED
codex: HOLD
```
