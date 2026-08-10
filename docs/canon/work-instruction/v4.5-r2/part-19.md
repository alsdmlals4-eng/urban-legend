→ close PowerShell block when applicable
→ next block starts with fresh repo/process/session read
```

다음 실행은 **처음부터 다시 시작한다고 생각하고** 다음을 재검증한다.

```yaml
fresh_execution_identity:
  current_main_sha:
  branch:
  working_tree:
  codex_version_and_args:
  godot_version:
  godot_process:
  gut_discovery:
  hera_transport:
  exact_target:
```

stale PID/session/editor state를 현재 성공 증거로 사용하지 않는다.

### 26.5 Codex 인계

Codex는 기본 의무 단계가 아니다.

```text
USER_REQUESTED_CODEX_HANDOFF
AND package DoR closed
→ handoff
```

인계 패키지:

```yaml
codex_package:
  repository:
  base_sha:
  target_branch:
  goal:
  approved_scope:
  approval_reference:
  protected_paths:
  current_actual_state:
  affected_files:
  acceptance_criteria:
  tests:
  godot_authoring_boundary:
  rollback:
  required_post_build_review:
```

Codex도 실제 repo/project/Godot 상태를 다시 읽는다.
GPT의 예상 상태를 사실로 가정하지 않는다.

---

## 27. 다층 검증

### 27.1 Contract

- 승인 목표
- 범위
- 보호 대상
- 실제 diff
- 책임 원본

### 27.2 Reference freshness

- 정본 변경
- active consumers
- untouched consumers
- Registry
