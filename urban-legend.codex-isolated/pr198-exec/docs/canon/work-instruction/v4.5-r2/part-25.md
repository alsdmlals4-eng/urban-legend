## 32. Open/Draft PR 전체 감사와 변경 단위

### 32.1 작업 시작·배치 종료·병합 후 Open/Draft PR 전체 확인

현재 프로젝트의 **모든 Open/Draft PR**을 조회한다.
same-goal PR만 보는 것으로 끝내지 않는다.

각 PR에 대해:

```yaml
pr_audit:
  number:
  title:
  draft_or_open:
  purpose:
  changed_scope:
  base_sha:
  head_sha:
  current_main_compatibility:
  duplicate_or_overlap:
  proposal_only:
  reference_only:
  do_not_merge:
  ci_status:
  required_check:
  unresolved_threads:
  adversarial_findings:
  user_approval_scope:
  risk:
  disposition:
```

Disposition:

```text
MERGE_ELIGIBLE
SYNC_WITH_MAIN_THEN_REVERIFY
KEEP_OPEN_WITH_REASON
PROPOSAL_ONLY_DO_NOT_MERGE
REFERENCE_ONLY_DO_NOT_MERGE
BLOCKED_VALIDATION
SUPERSEDED_CLOSE
STALE_CLOSE
USER_DECISION_REQUIRED
```

### 32.2 자동 병합 가능 PR

다음을 모두 만족하면 최신 main과 동기화하고 검증한 뒤 병합한다.

- 이미 사용자 승인 범위
- 저위험
- 목적·변경 범위가 명확
- current main 충돌 없음
- 중복 PR 아님
- 모든 필수 검증 PASS
- exact current validation target PASS
- 적대적 검토 P0/P1 없음
- unresolved thread 없음
- proposal-only/reference-only/DO_NOT_MERGE 아님

