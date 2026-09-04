https://docs.github.com/en/billing/concepts/product-billing/github-actions

GitHub-hosted runners
https://docs.github.com/en/actions/reference/runners/github-hosted-runners

GitHub Actions secure use
https://docs.github.com/en/actions/reference/security/secure-use

GitHub required status checks
https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks

Godot 4.7.1 release
https://godotengine.org/article/maintenance-release-godot-4-7-1/

Godot release archive
https://godotengine.org/download/archive/

GUT
https://github.com/bitwes/Gut
```

---

## 10. Existing Solution First

새 MCP·addon·CLI·framework·Skill·mode·tool·system을 만들기 전에 다음을 조사한다.

```text
프로젝트 기존 구현
→ Base current owner/mode/reference
→ Local Godot Reference Library
→ Godot 공식 데모·템플릿
→ Godot Asset Library
→ 유지되는 외부 대안
→ LICENSE / maintenance / compatibility / adoption cost
→ REUSE | EXTEND | TRIAL | REJECT | BUILD_NEW
```

`BUILD_NEW`는 기본값이 아니다.

필수 기록:

```yaml
existing_solution_disposition:
  searched_sources: []
  candidates: []
  selected:
  rejected_with_reason: []
  build_new_justification:
  rollback:
```

---

## 11. Grill Me·Decision 승인

사용자에게 올리는 것은 **중요 기획 충돌·방향 선택**이다.

자동 권장 가능:

- 가역적 수치
- 기술 기본값
- 범위 안의 구현 세부
- 명백한 오류 수정

사용자 결정 필요:

- 프로젝트 코어 변경
- 핵심 재미 방향 변경
- MVP/Vertical Slice 범위 의미 변화
- 중요한 UX·보상·경제·서사 선택
- 호환성 파괴
- 보호 대상 삭제
- 승인 범위 확대

Decision batch:

```yaml
max_decisions_per_batch: 10
early_checkpoint_allowed: true
early_checkpoint_when:
  - high_risk_conflict
  - core_direction_changed
  - session_or_context_end_risk
  - canon_impact_is_large
  - contradictions_accumulate
  - next_decision_depends_on_prior_user_choice
```

### 11.1 Grill Me 질문 규칙

각 중요한 충돌 질문에는 가능하면 다음을 제공한다.

1. 현재 프로젝트 정본의 상태
2. 충돌 지점
3. GPT 권장안
4. 대안
5. 벤치마킹/현업 비교
6. 각 선택의 비용·위험
7. 추천 선택이 보호하는 기존 강점
8. Decision ID

### 11.2 승인 즉시 정본 동기화

승인되면 가능한 즉시 같은 Decision ID로 다음을 동기화한다.

```text
GitHub 권위 문서
