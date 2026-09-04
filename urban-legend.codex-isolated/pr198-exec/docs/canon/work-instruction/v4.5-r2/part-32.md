  verification_after_action:
```

원칙:

1. GPT가 현재 권한·도구로 안전하게 해결 가능하면 직접 해결한다.
2. 사용자만 할 수 있는 설치·로그인·권한·로컬 UI 조작이면 dependent stage를 `BLOCKED_USER_ACTION`으로 둔다.
3. 사용자 요청은 가능하면 현재 응답의 **마지막 `User Action Required`**에 모은다.
4. 보안·데이터 손실·과금·법률 위험 때문에 즉시 확인이 필요한 경우만 즉시 중단·질문한다.
5. 예: GitHub CLI가 없으면 왜 필요한지, 설치 시 장점, 공식 설치 방법, `gh --version` / `gh auth status` 확인법을 제공한다.
6. 설치가 “있으면 좋은 것”인지 “없으면 진행 불가”인지 구분한다.

## 38. 증거 Manifest

```yaml
evidence_manifest:
  base:
    current_main_sha:
    registry_read:
    selected_skills: []
    executed_skill_modes: []
    external_process_overlay:

  project:
    repository:
    base_sha:
    head_sha:
    approval_reference:
    decisions: []
    protected_items: []

  planning:
    core_game_model:
    requirement_traceability:
    benchmark_sources: []
    professional_comparisons: []
    existing_solution_disposition:
    grill_me_decisions: []
    grill_me_batch_checkpoint:
