→ 계획/기획 데이터
→ 연결된 Google Sheet의 대응 tab/range
→ Decision ledger / change record
```

```yaml
decision_sync:
  decision_id:
  approved_choice:
  github_canon_locations: []
  planning_data_locations: []
  google_sheet_url:
  sheet_tab_or_range:
  commit_or_pr:
  sync_result:
  reread_result:
```

연결된 Sheet를 찾을 수 있고 권한이 있으면 GPT가 직접 찾아 반영한다.
사용자 행동만으로 가능한 경우에만 blocker로 남긴다.

### 11.3 최대 10건 승인 배치 종료 프로토콜

승인 10건은 **최대 배치 크기**다. 고위험 충돌·세션 종료 위험·정본 영향이 크면 그 전에 닫을 수 있다.

```text
approved Decision IDs inventory
→ canon + planning data + Sheet sync
→ reread
→ planning/document change diff
→ TDD/contract check where applicable
→ PR inventory
→ planning PR create/update
→ required checks
→ adversarial review loop
→ critique validation
→ approved minimal fix
→ recheck
→ current conversation auto-merge rule 적용 가능 여부 판정
→ merge when eligible
→ new main readback
→ remaining Draft/Open PR reread
```

이 배치 병합은 **기획 결과의 정본화**이며 PHASE C 구현을 시작시키지 않는다.

---

## 12. 승인·병합 권한

### 12.0 현재 대화의 병합 승인 계약

이 작업지시문을 작성한 **현재 대화에서 사용자가 이미 승인한 범위**는 권장안대로 자동 병합 승인된 것으로 취급한다.

```yaml
current_conversation_merge_approval:
  scope: ALREADY_USER_APPROVED_ITEMS_IN_THIS_CONVERSATION
  merge_reapproval: NOT_REQUIRED
  recommended_low_risk_pr_merge: AUTO_APPROVED_AFTER_ALL_GATES
  planning_conflict_auto_approval: FORBIDDEN
  scope_expansion_auto_approval: FORBIDDEN
```

이 권한은 다른 대화·미래 프로젝트에 영구 승계되지 않는다.
새 기획 충돌은 반드시 Grill Me로 승인받는다.

자동 병합에서 제외:

- proposal-only
- reference-only
- `DO_NOT_MERGE`
- 실험/PoC 보존 PR
- 필수 검증 미완료
- stale base / strict-up-to-date 미충족
- unresolved review thread
- 승인 범위 밖 diff
- P0/P1 적대적 finding 미해결
- 사용자 행동이 필요한 미검증 위험

### 12.1 같은 승인 범위

사용자의 명시 승인이 무엇을 가리키는지 명확하면:

```text
APPROVAL
→ BUILD
→ VERIFY
→ PR
→ exact current validation target
→ ci-gate
→ adversarial review
→ merge
→ readback
```

다시 묻지 않는다.

