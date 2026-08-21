# 2026-08-21 Current Authority Correction — 5 Whole-Scope Adversarial Loops

> 대상 PR: #220
> 기준 main: `faaf7731dd9013eba1aa0944d24fc17dba3a6ae3`
> 범위: current authority routing, Validation routing, Issue lifecycle, predecessor preservation, regression contract
> 제품 runtime 변경: 없음

이 문서는 하나의 변경 범위를 다섯 관점으로 나눈 것이 아니라, **동일한 전체 변경을 매 회 다시 `attack → review → decision`한 기록**이다.

## Loop 1 — Authority propagation attack

### Attack

사람용 `START_HERE`·`AGENTS`만 새 Overlay를 가리키고 machine canon이나 다른 active router가 계속 predecessor source를 사용하면, 이번 교정 자체가 새 이중 정본을 만든다.

### Review

- `START_HERE.md`, `AGENTS.md`, `docs/DOCUMENTATION_MAP.md`에 Overlay route를 추가했다.
- 첫 구현안에서 `docs/current-planning-canon.json`의 `active_entrypoints`에는 Overlay/Validation Router가 빠져 있었다.
- 이 상태는 `MISSING_PROPAGATION`에 해당한다.

### Decision

- `docs/current-planning-canon.json`에도 `docs/CURRENT_DECISION_OVERLAY.md`, `docs/VALIDATION_TARGET_CANON.md`를 active entrypoint로 등록했다.
- 회귀 테스트가 사람용 3개 entrypoint와 machine `active_entrypoints`를 함께 검사하도록 강화했다.
- **Finding: FIXED.**

## Loop 2 — Verified successor / evidence ceiling attack

### Attack

과거 `NOT_STARTED`를 고치다가 PR #180의 제한된 Windows pointer evidence를 전체 UI Human PASS로 과장하거나, current runtime 전체를 검증했다고 오인할 수 있다.

### Review

- 실제 main 조사·회수 코드는 PR #180 successor behavior를 포함한다.
- PR #180은 조사 pointer progression의 실제 Windows Human 증거를 남겼지만, 전체 current product Human/UI/device 검증을 완료한 것은 아니다.
- 현재 monthly canonical-root live receipt와 전체 Human QA는 여전히 `NOT_RUN`이다.

### Decision

- Overlay는 UI hierarchy의 **구현 successor만** `병합 완료`로 기록한다.
- 전체 Human/UI/device, current canonical-root runtime receipt는 `NOT_RUN`으로 유지한다.
- M01/M04 Validation Router도 자동·과거 runtime 증거가 현재 Human QA를 대신하지 못하도록 fail-closed한다.
- **Finding: PASS after boundary clarification.**

## Loop 3 — Open Issue lifecycle attack

### Attack

35개 Issue를 오래됐다는 이유로 닫으면 아직 필요한 Human 검증·UI 설계까지 유실될 수 있다. 반대로 모두 열어 두면 다음 AI가 predecessor 작업을 현재 권한으로 재실행한다.

### Review

baseline open Issue exact set을 전수 대조했다.

- 과거 MVP/ANNUAL/CORE Validation Issue는 current monthly canon·후속 runtime·새 Validation Router가 책임을 대체한다.
- #112/#115/#119은 current Base v9.4.3 Adapter가 successor다.
- #179은 PR #180이 successor다.
- #203은 current headless-safe wrapper가 존재하고 #196은 종료됐다.
- #212는 #211 내용이 PR #219에 통합됐다.
- #181만 실제 main의 `Ver 4.2` 상태 때문에 아직 완료되지 않았다.

### Decision

- 완료를 직접 확인한 #112/#115/#119/#179/#203/#212만 `CLOSE_COMPLETED`.
- 나머지 predecessor milestone은 개별 체크리스트를 허위 재인증하지 않고 `CLOSE_NOT_PLANNED_SUPERSEDED`.
- #181은 `KEEP_OPEN_DEFERRED_VALID / PLAN_LOCK`.
- #92/#105를 닫아도 Human QA status는 `NOT_RUN`을 유지한다.
- **Finding: PASS with one deliberately retained Issue.**

## Loop 4 — Preservation / rollback attack

### Attack

`CURRENT` 파일을 짧게 만들면서 과거 Validation 계약·당시 상태·복구 근거를 삭제하면 정리 자체가 정보 손실이다.

### Review

- `CURRENT_CONFIRMED_DECISIONS.md` 상세 승인·대체·CI history를 삭제하지 않았다.
- predecessor START_HERE와 Validation Target은 수정 전 exact Git blob을 `docs/archive/history/`에 별도 보존했다.
- 모든 Issue 원문·댓글·PR/commit history는 GitHub에 남는다.
- 제품 코드·data·Scene·save·asset은 diff 0이다.
- rollback 기준 main은 `faaf7731dd9013eba1aa0944d24fc17dba3a6ae3`이다.

### Decision

- current routing만 단순화하고 history 원문은 보존한다.
- archive가 current cold-start authority로 역유입되지 않도록 `START_HERE`/`DOCUMENTATION_MAP`에서 history-only로 명시한다.
- archive governance validator의 결과를 final gate에 포함한다.
- **Finding: PASS pending exact-head CI.**

## Loop 5 — Correction-self regression attack

### Attack

새 `CURRENT_DECISION_OVERLAY`가 월간 Planning Canon의 내용을 복제하면서 앞으로 다시 두 개의 current authority가 될 수 있다. 또한 “Issue를 정리했다”는 이유로 PLAN_LOCK을 풀거나 runtime migration까지 진행할 위험이 있다.

### Review

- Authority precedence는 `CURRENT_PLANNING_CANON/current-planning-canon.json`을 Overlay보다 위에 둔다.
- Overlay는 next-action·verified successor·Issue disposition 같은 mutable state를 압축하는 역할로 제한한다.
- planning cadence·M01/M04 역할·save migration 의미를 바꾸지 않는다.
- `monthly_state`는 additive optional 방향만 유지하며 실제 schema 변경은 하지 않았다.
- Runtime implementation은 `NOT_AUTHORIZED`, Human은 `NOT_RUN`, POC는 `NOT_DECLARED`다.

### Decision

- Overlay를 planning source가 아닌 **current mutable decision/successor consumer**로 유지한다.
- Planning meaning 변경 시 Notion + `CURRENT_PLANNING_CANON`을 먼저 갱신하고 Overlay는 파생 current state로 뒤따르게 한다.
- Issue cleanup은 구현 Gate를 열지 않는다.
- **Finding: PASS.**

## 5-loop verdict

```yaml
P0: 0
P1_open: 0
P2_open: 0
fixed_during_review:
  - machine active_entrypoints propagation gap
  - localized successor-state regression assertion
protected_product_path_changes: 0
runtime_validation: NOT_RUN_NOT_APPLICABLE_TO_DOC_ONLY_CORRECTION
human_validation: NOT_RUN
merge_gate: EXACT_HEAD_CI_REQUIRED
postmerge_gate: GITHUB_MAIN_ISSUE_NOTION_READBACK_REQUIRED
```

## Post-merge 재검사 항목

1. main이 PR #220 merge SHA를 가리키는지 확인.
2. current entrypoint 4종 + machine active_entrypoints readback.
3. baseline 35 Issue disposition 실행 후 open Issue 재검색.
4. #181만 `DEFERRED_VALID / PLAN_LOCK`으로 남는지 확인.
5. Notion `Repo Main SHA`, `Sync State`, Notes와 current Gate를 merge SHA 기준으로 갱신 후 readback.
6. `PLAN_LOCK / Human NOT_RUN / POC NOT_DECLARED`가 그대로인지 확인.
