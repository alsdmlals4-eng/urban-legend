# Urban Legend

Urban Legend는 도시 전설을 조사·판단·회복하는 Godot 프로젝트다. 현재 운영 원본은 Base `d2457e75a856260d309203e20262f2a2142d2dd6` 기준의 11개 독립 본책이다.

새 작업자는 다음 순서로 시작한다.

1. [`START_HERE`](<[기획서]/00_프로젝트_허브/START_HERE.md>)
2. [`ACTIVE_CONTEXT`](<[기획서]/00_프로젝트_허브/ACTIVE_CONTEXT.md>)
3. [`DOCUMENTATION_MAP`](<[기획서]/00_프로젝트_허브/DOCUMENTATION_MAP.md>)
4. 영향 분야의 01~11 본책 및 1:1 스킬
5. 실제 코드·Scene·데이터·테스트

## 운영 계약

- 서술형 책임 원본: 프로젝트 허브와 11개 분야 Markdown 본책
- 구조·상태·경로·해시: JSON Registry/Manifest 또는 실제 파일
- 발행: 각 본책은 최신 PDF와 Publication Manifest를 가진다.
- 보존: 모든 이주 대상은 [`MIGRATION_PRESERVATION_LEDGER`](<[기획서]/00_프로젝트_허브/MIGRATION_PRESERVATION_LEDGER.md>)의 `[본책 이주] / [등록 부록] / [증거] / [보류] / [백업] / [제거]` 중 하나다.

## 보호 범위

이 구조 이주 PR은 `project.godot`, `scripts/core/game_state.gd`, `data/episodes/**`, 저장 형식, Scene·게임 규칙을 바꾸지 않는다. QA PNG 증거는 `docs/qa/captures`의 기존 경로에 유지한다. `.log` 22개는 증거가 아니라 재생성 가능한 실행 로그이므로 `.gitignore`로 제외한다.

## 검증 순서

문서 이주 검증은 보존 대조 → Registry/링크/PDF·Manifest → Godot editor import → 기존 headless → runtime smoke 순서다. 수동 플레이 QA가 실행되지 않았으면 반드시 `[미검증]`으로 남긴다.
