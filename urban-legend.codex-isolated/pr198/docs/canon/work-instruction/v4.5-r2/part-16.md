| 이미지·애니메이션 | size·style·readability·frame·import acceptance |
| 문서·기획 | 누락·충돌을 재현하는 audit/checklist/contract |
| CI·배포 | failing validation job 또는 재현 절차 |
| PR hygiene | stale/duplicate/mergeability/required-check expected failure |

```text
요구/Decision
→ RED
→ failure reason verification
→ minimal GREEN
→ related regression
→ adversarial case
→ exact validation target
```

자동 테스트가 불가능한 작업도 **관찰 가능한 실패 조건과 수용 기준을 먼저** 작성한다.

### 25.3 TDD 증거 기록

```yaml
tdd_unit:
  id:
  requirement_or_decision_id:
  red_test_or_acceptance:
  red_result:
  failure_reason_verified:
  minimal_change:
  green_result:
  regression_suite:
  adversarial_case:
  evidence_location:
  commit_sha:
```

테스트를 나중에 추가하고 TDD를 했다고 주장하지 않는다.

### 25.4 최소 변경·Godot 안전

- 목표에 필요한 파일만 수정한다.
- save schema·public interface·Resource path를 무단 변경하지 않는다.
- Scene/Resource 텍스트 대량 치환을 기본값으로 두지 않는다.
- NodePath, UID, signal, owner, ext/sub resource를 검증한다.
