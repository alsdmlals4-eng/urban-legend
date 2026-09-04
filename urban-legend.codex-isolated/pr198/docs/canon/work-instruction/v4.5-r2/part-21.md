→ planning / writing-plans
→ TDD
→ systematic debugging when failure appears
→ adversarial review
→ critique validation
→ code/document review
→ verification-before-completion
→ post-merge reconciliation
```

Superpowers 등 외부 프레임워크는 `EXTERNAL_PROCESS_OVERLAY`로 기록한다.
Skill을 단순히 읽은 것과 실제 적용한 것을 구분한다.

### 28.2 1인 개발용 GPT 역할 분리 검토 — v4.4 보호 계약

별도의 인간 독립 리뷰어가 없을 때도 구현자 설명을 그대로 성공 증거로 사용하지 않는다.

```text
GPT REVIEWER ROLE
+ USER PLANNING DECISION AUTHORITY
+ OBJECTIVE TEST / CI / GODOT / SHA EVIDENCE
```

새 검토 패킷을 구성한다.

```yaml
gpt_role_separated_review:
  requirements_or_plan:
  decision_ids: []
  approval_reference:
  base_sha:
  head_sha:
  changed_file_inventory: []
  protected_contracts: []
  tdd_evidence:
  test_commands_and_results:
  godot_runtime_evidence:
  windows_android_evidence:
  visual_asset_audio_acceptance:
  known_deferred_items: []
  implementer_claims: LABELED_NOT_INDEPENDENT_EVIDENCE
```

규칙:

- 같은 GPT가 구현과 리뷰를 모두 수행할 수 있으므로 완전한 독립 리뷰라고 과장하지 않는다.
