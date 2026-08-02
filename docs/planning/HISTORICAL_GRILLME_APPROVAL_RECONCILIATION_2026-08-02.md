# Historical Grill Me 승인 정본 조정 — 2026-08-02

## 목적

과거 source PR의 승인 내용을 그대로 병합하지 않고, 현재 유효한 결정만 최신 Base·main 기준 정본에 승계했는지 확인한다.

## 출처

- PR #122: 과거 기획·감사·Decision provenance
- PR #125: 최신 Base v9.4 기준 current canon·Package 1 승인 정본
- PR #126: 별도 승인된 Package 1 구현
- Google Sheet: `02_현재_확정결정`, `04_누락_충돌_감사`, `99_변경이력`

## 판정

### 병합 완료

- PR #125 → main `595d45454621900e858a903fef0598a03349b794`
- PR #126 → main `80160218d05e79af5442bf27d8fdeb66bcf05723`

### source PR 처리

PR #122는 다음 이유로 직접 병합하지 않는다.

- Base v9.1 시점부터 누적된 100커밋 source branch
- 최신 main·Base v9.4와 상태 문구 충돌
- 현재 정본과 중복되는 current 문서 다수
- 초안·감사·대체 Decision이 함께 섞임
- GitHub가 nonmergeable로 판정
- PR 제목과 댓글이 `SOURCE / DO NOT MERGE AS-IS`로 명시

직접 병합은 승인 내용을 더 잘 보존하는 것이 아니라 stale 상태와 중복 권위를 되살린다.

## 승인 승계 방식

현재 유효한 과거 승인 내용은 다음 두 current 문서로 승계한다.

- `docs/CURRENT_CONFIRMED_DECISIONS.md`: Decision ID·상태·대체 관계 인덱스
- `docs/VALIDATION_TARGET_CANON.md`: 화면·상황·시간순 증거·회수·결과·저장 상세 정본

직접 책임 문서가 최신 main에 없는 과거 Decision도 위 current canon에 ID와 핵심 결론이 존재하면 `CONSOLIDATED_IN_CURRENT_CANON`으로 판정한다. source PR의 초안 파일을 별도 current 권위로 복원하지 않는다.

## 적대적 검토

| 위험 | 판정 | 처리 |
|---|---|---|
| 승인 내용 누락 | current decision index와 target canon으로 대조 | Batch 0 목록 고정 |
| 중복 권위 | PR #122 current 문서 직접 병합 시 발생 | source-only 유지 |
| stale 상태 복원 | 구현 전·병합 전 문구 다수 | post-merge current 문서 재작성 |
| 승인 질문 수 추정 오류 | 대화·source만으로 정확한 복원 불가 | 과거분 Batch 0, 미래 0/10 |
| 숫자 맞추기 병합 | source/superseded PR 오병합 위험 | 명시적 금지 |
| 구현과 기획 혼합 | 검증 책임 불명확 | Canon PR·Implementation PR 분리 유지 |

## 결론

```yaml
historical_approved_canon: MERGED_AND_CONSOLIDATED
package_1_implementation: MERGED
source_pr_122: EXCLUDED_DO_NOT_MERGE_AS_IS
historical_grillme_numeric_count: UNRELIABLE_NOT_INFERRED
future_counter: 0_OF_10
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
```
