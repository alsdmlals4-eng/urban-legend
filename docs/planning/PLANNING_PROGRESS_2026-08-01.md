# 괴이기록국 기획 진행 상태 — 2026-08-01

> 상태: `PLANNING_IN_PROGRESS / FULL_AUDIT_COMPLETE`
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
- 기준 화면 7종: 메인 / 텍스트 조사 / 준비 / 결과 / 일정 / 연구 / 보급 조달
- Validation 화면 흐름: 메인 → 콜드 오픈 → 브리핑 → 축약 준비 → 조사 → 가설 → 시간순 증거 → 노선 복원 → 회수 → 결과 → 사후 정산
- 일정은 하루 단위, 주요 활동 1개
- 2~3일 주요 활동은 같은 주의 연속 날짜 자동 점유
- 별도 일상 활동 카탈로그는 없으며 남는 일상 시간은 기본 휴식으로 단순 처리
- 저승역 시간순 증거: 23:57:42 개인 목적지 청취 < 23:59:08 검은 승차권 최초 접촉
- 주요 승인 변경은 GitHub·Sheet 동일 Decision ID로 동기화

## 감사 완료

### R-2026-08-01-FULL-PROJECT-ADVERSARIAL-AUDIT

상태: `REVIEW_COMPLETE / USER_DECISION_REQUIRED`

책임 원본:

- `docs/planning/FULL_PROJECT_ADVERSARIAL_AUDIT_2026-08-01.md`

핵심 결론:

1. 승인 결정과 상위 GitHub 정본이 분리됨
2. 주간 PoC·반일 본편·일일 승인안의 일정 계약이 3중화됨
3. 기본 휴식과 전일 회복의 의미 분리 필요
4. 새 캠페인·가설 보드·미니게임·회수·결과 환류가 승인 흐름으로 미연결
5. 현재 회수 4패턴과 설명형 행동이 승인된 2패턴·중립 행동과 충돌
6. 시간순 증거가 실제 사건 JSON에 없음
7. 결과 4축·연구·내부 보급 조달 화면이 제품 정본으로 미완
8. 기존 테스트가 주간·반일·4패턴 레거시 계약을 보호함
9. SCREEN/SIT 정본과 수정 비주얼 보드가 없음
10. 사람 플레이 검증은 여전히 NOT_RUN

## 다음 P0

```text
1. 감사 결과 사용자 검수
2. 기본 휴식 vs 전일 회복 의미 확정
3. 소문시장과 기록국 보급실 책임 분리 확정
4. Validation 비핵심 기능 숨김 범위 확정
5. Canon Migration Bundle 작성
6. SCREEN-01~07 / SIT-001~008 정본
7. 회수 2패턴·결과 4축·환류 최종 승인
8. 저장·테스트 마이그레이션 계획
9. 사용자 최종 승인
10. Codex Goal은 마지막
```

## 현재 Gate

```yaml
full_project_adversarial_audit: REVIEW_COMPLETE
user_audit_review: REQUIRED
canon_authority_alignment: BLOCKED
schedule_daily_input: APPROVED_PLANNING_BASELINE
schedule_rest_semantics: USER_DECISION_REQUIRED
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
