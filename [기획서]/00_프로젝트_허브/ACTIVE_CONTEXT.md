# Urban Legend Active Context

## 현재 단계

11개 독립 본책의 전수 보존 감사가 완료됐으며, 다음 단계는 Base `eb40b912e5f5a0e4d369105a4f0a770e0a6179a9` 기반 거버넌스·필요 Foundation Skill 동기화다. 이주 기준은 `dd3c9a8776eb938eeeeb2f1319af6bfc4a135202`이다.

## 확인된 사실

- 전수 입력은 tracked 511개와 원래 dirty worktree의 대상 70개, 합계 581개다.
- 기존 `docs/`의 활성 기획·QA·조사 원문은 의미 기준으로 01~11의 `등록_부록`으로 이동했고, 과거 문서는 `[백업]`, 재개 조건이 있는 제안은 `[보류]`다.
- dirty QA PNG 47개는 `docs/qa/captures` 경로에 SHA-256 일치 상태로 보존한다. 로그 22개는 `.gitignore`로 제외한다.
- `project.godot`, `scripts/core/game_state.gd`, `data/episodes/**`은 구조 이주 범위 밖 보호 파일이다.

## 다음 작업

1. 보존 대조 `581/581, missing=0`과 보호 기준선을 유지한다.
2. Issue #39에서 필요한 Foundation Skill·Registry·Governance Checker를 Urban 경로에 분화한다.
3. Issue #40에서 PDF/Manifest·Skill Map·Health Review와 Godot smoke 증거를 갱신한다.
4. PR #26은 별도 workflow 계약 대조 전까지 닫지 않는다.

## 읽지 않을 범위

`[기획서]/[백업]`, `[기획서]/[보류]` 및 과거 Issue/Goal/Plan은 기본 읽기 대상이 아니다. 고유 정보 대조나 사용자의 재개 요청이 있을 때만 참고한다.
