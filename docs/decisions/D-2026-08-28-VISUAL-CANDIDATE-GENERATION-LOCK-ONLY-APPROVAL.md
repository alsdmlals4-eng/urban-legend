# D-2026-08-28 · Visual Candidate Generation / Lock-Only Approval

> Status: `USER_APPROVED / PROJECT_WORKFLOW_POLICY`
> Decision ID: `D-2026-08-28-VISUAL-CANDIDATE-GENERATION-LOCK-ONLY-APPROVAL`
> Scope: future project visual candidate generation; no automatic asset promotion
> Owner: `CURRENT_VISUAL_WORK_ORDER.md`, `CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST.md`, `VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md`, Notion `03 · Visual Bible`

## Decision

확정된 consumer brief, visual lock, reuse/rights preflight가 있는 경우에는 후보 이미지 생성 전에 건별 사용자 승인을 다시 묻지 않는다. 후보를 생성·검수한 뒤 사용자에게 **확정(LOCK) / 수정(REVISE) / 거절(REJECT)**만 요청한다.

## Boundaries

- 후보는 `GENERATED_EXPLORATION` 또는 `USER_AUTHORIZED_VISUAL_CANDIDATE`일 뿐, PROJECT_ASSET_APPROVED, runtime asset, Godot 적용, Human QA PASS가 아니다.
- 실제 consumer가 없거나 rights/provenance가 불명확하면 생성하지 않는다.
- 기존 승인 asset은 후보 생성만으로 제거·교체하지 않는다.
- 최종 LOCK 뒤에도 manifest, provenance, target-resolution runtime capture, Human QA의 각 승격 gate를 별도로 통과해야 한다.

## Disposition

`ADOPT`: 반복적인 사전 승인 대기를 줄이되, visual direction / consumer / rights / user final lock의 안전 경계를 유지한다. 이 policy는 프로젝트 협업 방식에 묶여 있으므로 `NO_BASE_PROMOTION`이다.
