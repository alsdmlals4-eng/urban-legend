### 36.1 프로젝트 출처형 BCP 규칙

수정제안서를 작성할 때 **Base 활성 규칙을 proposal 단계에서 직접 건드리지 않는다.**

권장 구조:

```text
[수정제안서]/
└─ BCP - [프로젝트명] - [개선주제]/
   ├─ PROPOSAL.md
   └─ evidence/
      ├─ PROJECT_VALIDATION.md
      ├─ BEFORE_AFTER.md
      ├─ COUNTEREXAMPLES.md
      └─ TRACEABILITY.md
```

```yaml
bcp_project_source:
  source_project:
  source_decision_ids: []
  source_commits_or_prs: []
  problem_observed:
  validated_improvement:
  evidence:
  reusable_boundary:
  project_specific_values_removed:
  existing_base_owner:
  conflict_analysis:
  proposed_absorption:
  rollback:
```

### 36.2 “Registry 등록”의 충돌 방지 해석

`Base 활성 규칙은 건드리지 않는다`와 `Registry 등록 → PR → 검증 → 병합`을 동시에 만족시키기 위해 다음을 구분한다.

```text
PROPOSAL PHASE
→ BCP proposal/index/registry 성격의 등록
→ [수정제안서] 범위
→ active Skill/Rule Registry 변경 금지

APPROVED IMPLEMENTATION PHASE
→ 별도 승인 reference
→ 필요한 경우 active skills/SKILL_REGISTRY.json 또는 owner 변경
→ 별도 implementation PR
