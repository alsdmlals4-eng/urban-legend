기존 Base owner에 자연스럽게 흡수되면 새 Skill을 만들지 않는다.

### 37.2 기능 단위 분해·상태 분류

Skill·기능·규칙·문서·workflow를 다음처럼 **기능 단위**로 쪼갠다.

```text
ALREADY_INTEGRATED
CURRENTLY_VALID
CONFLICTING_OR_OUTDATED
PARTIALLY_REUSABLE
MISSING_AND_NEEDED
DEFERRED_WITH_REASON
```

| 기능 단위 | 현재 Base/프로젝트 위치 | 상태 | 충돌/구형 이유 | 흡수/유지/제거 권장 | 증거 |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

### 37.3 새 Skill 후보

```text
existing Skill mode/ref로 해결 가능
→ 통합/부분 흡수

독립 reusable input/output/authority/validation boundary 존재
→ 새 Skill 후보
```

Skill 숫자 목표는 없다.

---

### 37.4 최적 작업에 필요한 요소가 없을 때

최적 작업에 필요한 핵심 요소가 없으면 **해당 의존 단계는 중단**한다.
그러나 독립적으로 진행 가능한 조사·기획·검토까지 불필요하게 멈추지 않는다.

```yaml
missing_requirement:
  item:
  why_needed:
  benefit_if_available:
  can_gpt_resolve_directly:
  safe_auto_install_or_config_possible:
  dependent_stage_blocked:
  independent_work_can_continue:
  user_action_required:
  exact_steps:
