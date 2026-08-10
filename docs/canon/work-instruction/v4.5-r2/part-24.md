v4.5 작성 시 Base에서 확인된 상태:

```yaml
base_repository_governance:
  protected_ruleset:
    name: solo-main-safety
    required_check: ci-gate
    protected_merge_method: squash
  repository_level_observed:
    squash: enabled
    merge_commit: enabled
    rebase: enabled
  desired_defense_in_depth:
    squash: enabled
    merge_commit: disabled
    rebase: disabled
  tracking_issue: "https://github.com/alsdmlals4-eng/Base/issues/277"
  live_setting_write_status: BLOCKED_UNVERIFIED
```

Issue #277이 해결되기 전에는 repository-level merge/rebase가 꺼졌다고 주장하지 않는다.

이 차이는 Base의 protected Ruleset이 현재 squash를 강제한다는 사실과 별개다.

---

## 31. exact validation target / strict up-to-date

병합 전:

```text
current PR head
current base main
merge-base
test merge / merge queue if applicable
required ci validation target
```

를 다시 읽는다.

**중요**

검증 중 `main`이 전진하면:

```text
OLD GREEN != CURRENT GREEN
```

strict up-to-date 정책을 우회하지 않는다.

```text
new main read
→ conflict/consumer comparison
→ rebase/reconstruct
→ adversarial diff
→ new exact validation
→ ci-gate
→ merge
```

---

