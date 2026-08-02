# Grill Me 승인·병합 Ledger

> 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 미래 카운터: `1 / 10`
> 마지막 조정: `HISTORICAL_BATCH_0`
> 갱신일: 2026-08-02

## 카운터 규칙

- 승인된 Grill Me Decision ID 한 개당 1을 더한다.
- 질문·기각·보류·중복·대체 Decision은 더하지 않는다.
- 이미 카운트된 Grill Me 질문의 Design·Spec·구현 후속 Gate는 새 질문이 아니므로 추가하지 않는다.
- 10개에 도달하면 새 질문 진행보다 먼저 merge batch gate를 실행한다.
- batch가 완전히 처리되면 다음 카운터를 0에서 시작한다.
- 병합 불가 Decision은 승인 이력을 삭제하지 않고 `BLOCKED`로 기록한다.

## HISTORICAL_BATCH_0

과거 질문 횟수를 추정하지 않고, 현재 유효한 승인 Decision 전체를 정본으로 조정한 역사 batch다.

### Canon 병합

```text
PR: #125
head: b3d38576b37c60fd36c1b7bdc9018803b917c000
merge: 595d45454621900e858a903fef0598a03349b794
result: MERGED
```

승계한 주요 승인:

- `D-2026-07-31-CANON-SHEET-SYNC`
- `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION`
- `D-2026-07-31-VISUAL-ART-DIRECTION`
- `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY`
- `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS`
- `D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION`
- `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE`
- `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS`
- `D-2026-08-01-SCHEDULE-REST-SEMANTICS`
- `D-2026-08-01-PROVISIONING-AUTHORITY`
- `D-2026-08-01-VALIDATION-SCOPE-FILTER`
- `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE`
- `D-2026-08-01-VALIDATION-RESULT-AXES`
- `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION`
- `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL`
- `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL`
- `D-2026-08-01-LEGACY-PR-DISPOSITION`
- `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
- `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL`
- `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`
- `D-2026-08-02-PACKAGE-1-DESIGN-SPEC-APPROVAL`
- `D-2026-08-02-PACKAGE-1-IMPLEMENTATION-APPROVAL`

이 목록은 질문 횟수 카운터가 아니라 현재 승인 정본의 역사 reconciliation 목록이다.

### 구현 병합

```text
PR: #126
retargeted head: dd5832857a19854827944f521a2a3684c1380d78
merge: 80160218d05e79af5442bf27d8fdeb66bcf05723
result: MERGED
```

검증:

- Documentation contracts: success
- BCA Adoption: success
- CORE workflow: success
- ANNUAL workflow: success
- Validation focused: 4/4
- full Godot regression: 53/53

### 제외

```text
PR #122 = SOURCE / DO NOT MERGE AS-IS
```

PR #122는 provenance를 보존하는 source branch이며 현재 정본이 아니다. 유효 승인 내용은 PR #125로 승계했고 PR 자체는 병합 대상에서 제외했다.

### 증거 한계

```yaml
human_qa: NOT_RUN
new_player_validation: NOT_RUN
visual_1280x720_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## GRILLME_BATCH_1 — 누적 중

```yaml
counter: 1 / 10
merge_triggered: false
canon_pr: 129
implementation_pr: none
```

승인 Decision:

1. `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
   - 승인: Legacy·Validation 독립 병렬 카드
   - 상태: `APPROVED_PENDING_BATCH_MERGE`
   - 책임 원본: `docs/decisions/D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY.md`
   - 추적: Draft PR #129, Google Sheet 동일 Decision ID

같은 질문의 후속 Gate:

- `D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL` — 상세 Design 승인
- `D-2026-08-02-PACKAGE-2-DESIGN-SPEC-APPROVAL` — Spec 승인·implementation plan 작성 허가
- 구현 계획: `docs/superpowers/plans/2026-08-02-package-2-main-menu-entry-routing-implementation-plan.md`
- 상태: `PLAN_WRITTEN_SELF_REVIEWED / PRODUCT_IMPLEMENTATION_NOT_AUTHORIZED`

이 후속 Gate들은 별도 Grill Me 질문이 아니므로 카운터는 `1 / 10`을 유지한다.

다음 batch 병합 Gate는 10번째 승인 Decision이 기록될 때 실행한다. 그 전에도 사용자가 별도 병합을 명시적으로 승인하면 해당 범위만 병합할 수 있다.

## Future Batch Template

```markdown
## GRILLME_BATCH_<N>

- counter range: 1..10
- Decision IDs:
- canon PR/head:
- implementation PR/head:
- pre-merge main:
- GitHub audit:
- Sheet ranges:
- CI:
- merge SHA(s):
- blocked/excluded:
- unverified:
- next counter: 0 / 10
```
