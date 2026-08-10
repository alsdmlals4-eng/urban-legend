외부 근거는 프로젝트 정본을 대체하지 않는다.
반대로 프로젝트 문서가 실제 코드·데이터와 충돌하면 충돌을 숨기지 않는다.

---

## 3. EXTERNAL_PROCESS_OVERLAY — Superpowers 등 외부 프로세스 합성

Base current `docs/CAPABILITY_COMPOSITION_MAP.md`의 계약을 따른다.

```yaml
external_process_overlay:
  authority: EXECUTION_PROCESS_ONLY
  overlay_name_or_source:
  applied_process_skills_or_gates: []
  approval_state: NEW_APPROVAL | REUSED_APPROVAL | NOT_REQUIRED | BLOCKED
  approval_reference:
  conflict_state: NONE | OVERLAY_CONFLICT | BLOCKED_UNVERIFIED
  extra_evidence: []
```

예:

- Superpowers brainstorming
- writing-plans
- test-driven-development
- systematic-debugging
- requesting-code-review
- verification-before-completion
- 기타 system/developer가 요구하는 실행 프로세스

규칙:

1. 외부 프로세스는 **현재 실행 방법**을 강화할 수 있다.
2. 프로젝트 정본·`CURRENT_CONFIRMED_DECISIONS`를 소유하거나 덮어쓰지 않는다.
3. Base의 안전·증거·보호 Gate를 약화하지 않는다.
4. 정확히 같은 승인 범위는 `REUSED_APPROVAL`로 처리한다.
5. 기술 재검증 때문에 같은 기획 승인을 다시 요구하지 않는다.
6. 범위·코어·보호 행동·사용자 결정이 실제로 바뀌면 새 승인 Gate를 연다.
7. 외부 Skill을 읽은 것과 실제 실행한 것을 구분한다.
8. 충돌은 `OVERLAY_CONFLICT`로 기록하고 안전하게 해소할 수 없으면 `BLOCKED_UNVERIFIED`.
9. 외부 프로세스를 썼다는 이유만으로 Base Skill을 새로 만들지 않는다.

실행 보고에는 최소 다음을 남긴다.

```yaml
external_process_execution:
  overlay_name_or_source:
  read_skills: []
  actually_executed_skills_or_gates: []
  approval_reference:
  approval_reused:
  extra_evidence: []
  unresolved_overlay_conflict:
```

---

## 4. 프로젝트 입력 계약

아래 값은 v4.4의 프로젝트 고유 입력을 보존한다.
작업 시작 시 실제 환경과 대조하며, 빈 값은 자동으로 채워졌다고 추정하지 않는다.

```yaml
mode: AUTO | AUDIT_ONLY | PLAN_AND_IMPLEMENT | REVIEW_ONLY | MERGE_AND_DELIVER

base_repository: "https://github.com/alsdmlals4-eng/Base"
base_branch: "main"
base_snapshot_observed_when_v4_5_written: "7ce3fb64fa6303c5da6c7fc27c979f7233b761ac"
base_snapshot_policy: ALWAYS_REFETCH_CURRENT_MAIN_BEFORE_WORK
