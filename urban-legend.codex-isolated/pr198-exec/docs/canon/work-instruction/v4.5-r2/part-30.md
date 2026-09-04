→ TDD/freshness/adversarial/ci-gate
→ merge
```

즉 proposal-only PR에서 active `skills/SKILL_REGISTRY.json`을 미리 바꾸지 않는다.
현재 Base의 BCP 프로토콜이 별도 proposal registry/index를 제공하면 그것을 사용한다.
그런 surface가 없으면 proposal 안에 registration metadata를 남기고 active Registry는 구현 PR까지 기다린다.

proposal 등록과 active Base 구현을 같은 단계로 합치지 않는다.

프로젝트 고유 값·경로·아트를 Base에 승격하지 않는다.

---

## 37. Skill 변화·부분 흡수

### 37.1 전체 Skill을 가져오지 않아도 부분 흡수

외부/프로젝트 Skill을 검토할 때 “전체 채택 또는 전체 거부” 이분법을 금지한다.

흡수 후보:

- 특정 mode
- review lens
- checklist
- test pattern
- failure classification
- prompt 구조
- reference 문서
- evidence schema
- debugging step
- tool integration pattern

```yaml
skill_absorption:
  source_skill_or_framework:
  feature_or_function:
  source_license_or_usage_boundary:
  classification:
  reusable_part:
  rejected_part:
  target_existing_base_skill_or_doc:
  why_partial_absorption_is_better:
  regression_needed:
```

