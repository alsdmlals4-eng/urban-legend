  blocked_items:
  actual_code_data_scene_resource_state:

sheet:
  exact_url:
  relevant_tabs_or_ranges:
  decision_ids:
  unresolved_items:
  image_review_status:
  reread_status:

entry_reconciliation:
  claimed_state:
  observed_state:
  result: READY | REVISE | BLOCKED_UNVERIFIED
```

검색·대화 기록만으로 프로젝트 전체 상태를 추정하지 않는다.

---

### 7.1 핵심 요구 추적표 — v4.4 보호 계약 복원

모든 핵심 요구·승인 Decision·보호 항목을 구현·검증·병합·로컬 실행까지 추적한다.

| 요구/Decision ID | 원문 요구·결정 | 책임 정본 | 계획/데이터 | 실제 구현 | 시각/컴포넌트 | 테스트·실행 증거 | 상태 |
|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  | `PENDING` |

허용 상태:

```text
CONFIRMED
SPECIFIED
APPROVED
CANON_SYNCED
SHEET_SYNCED
IMPLEMENTED
RUNTIME_VALIDATED
HUMAN_VALIDATED
MERGED
LOCAL_RUN_VALIDATED
DEFERRED_WITH_REASON
OUT_OF_SCOPE_CONFIRMED
USER_DECISION_REQUIRED
BLOCKED_UNVERIFIED
```

모든 핵심 요구가 위 상태 중 하나로 닫히지 않으면 전체 완료가 아니다.
`CANON_SYNCED`와 `SHEET_SYNCED`는 가능한 경우 같은 Decision ID를 사용한다.

## 8. 기획 우선·핵심 게임 모델

구현 전에 최소 다음을 닫는다.

```yaml
project_goal:
pointed_fun:
core_loop:
session_loop:
meta_loop:
core_systems: []
supporting_systems: []
player_verbs: []
meaningful_choices: []
failure_learning:
reward_structure:
protected_identity:
```

### 8.1 기획 우선 Hard Gate

기획이 미완료인 상태에서는 구현 편의를 이유로 세부 방향을 확정하지 않는다.

```text
기획 구조
→ 핵심 재미·목표·시스템
→ 기능 단위 명세
→ 데이터·수치 권장안
→ 충돌 Decision
→ 이미지/UX 근거
→ 승인·정본 동기화
→ 전체 기획 완료 선언
→ 최종 검수
→ 구현
```

### 8.2 상세 데이터·수치 — GPT 권장안 기본

세부 수치·밸런스·간격·쿨다운·보상량·확률·UI dimension 등 **프로젝트 코어를 바꾸지 않는 조정 가능 수치**는 GPT가 권장안을 만든다.

```yaml
numeric_recommendation:
  decision_or_feature_id:
  recommended_value:
  recommended_range:
  benchmark_or_industry_basis:
  player_experience_rationale:
  risk:
  tuning_signal:
  rollback_or_adjustment_rule:
```

