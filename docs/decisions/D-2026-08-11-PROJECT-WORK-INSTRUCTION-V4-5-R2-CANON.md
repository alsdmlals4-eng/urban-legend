# D-2026-08-11-PROJECT-WORK-INSTRUCTION-V4-5-R2-CANON

## Decision

사용자는 2026-08-11 KST에 `작업지시문 v4.5 r2 로 깃허브 정본도 교체`를 명시적으로 승인했다.

현재 프로젝트 작업지시문 정본을 attached source `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`의 **v4.5 / revision 2026-08-11-r2**로 전환한다.

```yaml
decision_id: D-2026-08-11-PROJECT-WORK-INSTRUCTION-V4-5-R2-CANON
classification: APPROVED_GOVERNANCE_CANON
approved_choice: ADOPT_V4_5_R2_AS_CURRENT_PROJECT_WORK_INSTRUCTION
supersedes_current_work_instruction_revisions:
  - v4.4
  - earlier project work-instruction revisions
product_runtime_change: NONE
planning_complete_declaration: NOT_RECEIVED
product_build_authorization: NOT_GRANTED_BY_THIS_DECISION
```

## Exact source identity

```yaml
logical_source_bytes: 77734
logical_source_sha256: 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
logical_source_git_blob_sha1: de7c6f818a4c96d2a02edea5eaff33bb1c39e8da
canonical_entry: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION.md
canonical_parts: docs/canon/work-instruction/v4.5-r2/part-00.md..part-46.md
reconstruction: CONCAT_NUMERIC_ORDER_WITH_NO_INSERTED_SEPARATOR
```

현재 GitHub connector에서 단일 77,734-byte opaque payload 전송 중 byte drift가 실제 관찰되어, 손상된 blob을 정본으로 사용하지 않았다. 원문을 line-bounded UTF-8 part로 분할하고 **각 part의 Git blob SHA를 local attached source에서 직접 계산한 값과 대조**했다. 47개 exact part의 단순 연결은 원문과 동일한 byte length, SHA-256, full Git blob SHA-1을 재현한다.

이 packaging은 전송/저장 표현만 분할한 것이며 논리적 정본 내용은 attached v4.5-r2 원문이다.

## Authority boundary

v4.5-r2는 Thin Adapter다. source에 기록된 Base SHA `7ce3fb64...`는 historical observation이며 current authority가 아니다. 이 작업 시작 시 다시 읽은 live Base main은 `315c66eea9614c284b9c11c4d522141065dfa4b0`이었다.

source의 `planning_completion_trigger`는 `USER_EXPLICIT_PLANNING_COMPLETE_DECLARATION`이다. 사용자의 이번 `권장안대로 승인`은 Main Menu safe-return written Spec과 이 governance canon 전환의 승인으로 기록하지만, **정확한 `기획 완료` 선언으로 대체하지 않는다.** 따라서 PHASE C PowerShell/Codex/Godot persistent BUILD는 이 Decision만으로 시작하지 않는다.

## Preserved source-internal conflict

source Section 4는 다음 다른 프로젝트 경로를 포함한다.

`C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle`

현재 urban-legend 프로젝트 계약의 경로는 다음이다.

`C:/Users/user/Documents/GitHub/Ninza/urban-legend`

attached source를 요청 근거 그대로 보존해야 하므로 이 값을 몰래 수정하지 않는다.

```yaml
finding: SOURCE_INTERNAL_PROJECT_INPUT_CONFLICT
source_preserved_exactly: true
silent_correction: FORBIDDEN
follow_up: SEPARATE_EXPLICIT_SOURCE_REVISION_IF_USER_WANTS_CONTENT_CORRECTED
```

## Scope ceiling

이 Decision/PR은 문서 정본·governance 전환만 수행한다.

- runtime `.gd`: 변경 없음
- Scene/Resource/project.godot: 변경 없음
- gameplay data/assets: 변경 없음
- workflow/test behavior: 변경 없음
- Human/UI/Android evidence: 승격 없음

동일 Decision ID를 Google Sheet 현재 결정 원장과 변경 이력에 동기화한다.
