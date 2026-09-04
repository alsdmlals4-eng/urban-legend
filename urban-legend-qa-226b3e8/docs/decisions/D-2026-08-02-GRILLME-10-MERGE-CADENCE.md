# D-2026-08-02-GRILLME-10-MERGE-CADENCE

## 상태

`CURRENT_APPROVED_GOVERNANCE`

## 사용자 승인

사용자는 다음 운영 방식을 승인했다.

```text
지금까지 승인된 Grill Me 결정을 정본에 병합한다.
앞으로 승인된 Grill Me Decision ID가 10개 누적될 때마다
GitHub·Google Sheet를 다시 상세 검토하고
적대적 검토와 PR Check를 통과한 승인 항목을 병합까지 완료한다.
```

## 카운트 단위

카운트는 질문 횟수나 선택지 수가 아니라 **승인되어 Decision ID를 받은 Grill Me 결정**을 기준으로 한다.

다음은 카운트하지 않는다.

- 답변 전 질문
- 기각·보류·재질문된 선택지
- 자동 권장 기본값과 단순 기술값
- 중복 Decision
- 이미 다른 Decision이 대체한 항목
- source-only·superseded·blocked PR

## 역사 기준선

2026-08-02의 과거 승인분은 `HISTORICAL_BATCH_0`으로 한 번에 조정한다.

- PR #125에서 승인 Canon·Package 1 기획·Grill Me 영속 결정·Design·Implementation Approval을 main에 병합했다.
- PR #126에서 별도 승인된 Package 1 구현을 main에 병합했다.
- PR #122는 승인 출처를 보존하는 source-only PR이며 그대로 병합하지 않는다.
- PR #122의 현재 유효한 승인 내용은 `docs/CURRENT_CONFIRMED_DECISIONS.md`와 `docs/VALIDATION_TARGET_CANON.md`가 승계한다.
- 역사 질문 횟수는 신뢰할 수 있게 재구성할 수 없으므로 과거분을 임의 숫자로 환산하지 않는다.
- `HISTORICAL_BATCH_0` 완료 뒤 미래 카운터는 `0 / 10`에서 시작한다.

## 10개 도달 시 필수 절차

1. 최신 `main` exact SHA를 고정한다.
2. GitHub 열린 PR·Issue·브랜치 목적을 전부 확인한다.
3. 각 승인 Decision ID가 GitHub 책임 원본과 Google Sheet에 같은 ID로 존재하는지 확인한다.
4. 중복·대체·충돌·범위 팽창·권한 부재·미검증 항목을 적대적으로 분류한다.
5. PR changed files, unresolved review threads, requested changes, mergeability, CI/checks를 확인한다.
6. 저장·Schema·제품 의미·보호 경로 변경은 별도 구현 승인과 회귀 증거를 요구한다.
7. Canon PR과 구현 PR을 분리한다.
8. source-only·superseded·blocked PR은 숫자를 맞추기 위해 병합하지 않는다.
9. 필요한 CI를 최신 HEAD에서 다시 실행한다. 과거 HEAD의 성공을 새 HEAD의 성공으로 재사용하지 않는다.
10. 병합 직전 GitHub·Sheet exact range를 다시 읽는다.
11. expected head SHA를 고정해 병합한다.
12. 병합 후 main merge SHA·Decision ID 목록·Sheet 위치·미검증 항목을 ledger에 기록한다.

## 병합 조건

다음을 모두 만족할 때만 병합한다.

```yaml
approval_decision_ids_resolved: true
canon_conflicts: 0
scope_violations: 0
unresolved_review_threads: 0
requested_changes: 0
mergeable: true
required_ci: success
sheet_sync: exact_re_read
protected_meaning_change: separately_approved
```

## 실패 시

한 항목이라도 충족하지 못하면 해당 batch의 병합을 중단한다. 안전한 항목만 별도 PR로 분리할 수 있으나, 실패·차단 항목을 자동으로 제외하고 성공으로 보고하지 않는다.

## 책임 원본

- 카운터·batch 기록: `docs/GRILLME_APPROVAL_MERGE_LEDGER.md`
- 현재 승인 결정: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- Validation 상세 정본: `docs/VALIDATION_TARGET_CANON.md`
- Google Sheet: `02_현재_확정결정`, `04_누락_충돌_감사`, `99_변경이력`
