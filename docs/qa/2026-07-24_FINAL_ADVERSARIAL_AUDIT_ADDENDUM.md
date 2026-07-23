# 부록 A. Publication-head 추가 회귀와 마감

최초 QA 원본·Manifest 발행 뒤 활성 `CURRENT_HANDOFF.md`가 과거 `ACCEPT_WITH_FOLLOWUP`을 유지하는 사실을 발견했다. 이를 최종 5차 회귀의 추가 finding으로 처리했다.

```yaml
finding_id: F-013
review_round: 5
problem: CURRENT_HANDOFF가 최종 UNVERIFIED 판정과 충돌하고 완료 QA를 필수 읽기로 연결
violated_requirement_or_core: Active Context·Handoff 최신성, 완료 QA 기본 읽기 제외
why_it_matters: 다음 담당자가 PR을 승인 가능한 상태로 오인하고 완료 QA를 현행 정본처럼 사용
failure_scenario: CORE-MVP-001 미구현 상태에서 ACCEPT_WITH_FOLLOWUP을 근거로 병합·후속 확장
severity: HIGH
confidence: 1.0
suggested_direction: Handoff를 UNVERIFIED로 정렬하고 QA 직접 링크를 조건부 탐색으로 변경
판정: MUST_FIX → FIXED
```

## Red → Green 증거

- workflow trigger에 `CURRENT_HANDOFF`, `MVP_ROADMAP`, `TEST_CHECKLIST`, 주요 planning handoff 문서를 추가했다. 커밋 `912c139f`.
- `CURRENT_HANDOFF`를 `UNVERIFIED`로 바꾸고 Issue #56·미검증 항목을 기록했다. 최초 커밋 `54c91144`.
- Required Check run #141은 Handoff의 완료 QA 직접 링크를 stale active reference로 검출해 실패했다.
- 완료 QA를 필수 읽기와 완료 뒤 갱신 목록에서 제거하고 날짜별 증거를 조건부 탐색하도록 수정했다. 커밋 `f9a33f95`.
- fix head의 Required Check run #142는 성공했다.

## 최종 커밋 보완

| 커밋 | 목적 |
|---|---|
| `912c139f` | Handoff·MVP·검증·planning route를 Required Check trigger에 포함 |
| `54c91144` | Handoff를 UNVERIFIED로 정렬하고 Issue·미검증 기록 |
| `f9a33f95` | 완료 QA의 활성 Handoff 직접 링크 제거 |

이 부록을 포함한 QA 원본·Manifest 재발행 커밋은 자기 자신을 커밋 목록에 고정하지 않는다. 최종 remote head와 Required Check run은 PR #55가 소유한다.
