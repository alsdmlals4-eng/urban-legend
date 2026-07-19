# Urban Legend 11개 분야 이주 감사

## 전수 기준

- 원격 기준: `dd3c9a8776eb938eeeeb2f1319af6bfc4a135202`
- `MIGRATION_INVENTORY_BEFORE.json`: tracked 511개, 원래 dirty worktree 이주 대상 70개, 합계 581개
- dirty 대상: QA PNG 47개, 로그 22개, 기존 Base 감사 보고서 1개
- 보호 해시 대조 대상: `project.godot`, `scripts/core/game_state.gd`, `data/episodes/**`, 저장·캠페인·에피소드 데이터

## 확정 처리 원칙

| 원본 집합 | 목표 판정 | 이주 조건 |
|---|---|---|
| GDD·planning·CURRENT_STATUS·Handoff·Roadmap·UI·QA 문서 | [본책 이주] 또는 [등록 부록] | 11개 본책의 유일한 책임 원본·등록 부록으로 연결 |
| `docs/qa/captures/**` PNG | [증거] | 경로 유지, 추적, SHA-256과 QA/Asset Registry 등록 |
| dirty 로그 22개 | [제거] | `.gitignore`에 기록, Git에 추적하지 않음 |
| DOCX·과거 감사·완료 Goal·과거 보고서·archive | [백업] 또는 [보류] | 고유 내용 대조 후 물리 이동, 기본 읽기 제외 |
| 코드·Scene·Resource·저장·데이터·테스트 | [증거] | 본 이주에서 수정하지 않고 전후 해시 대조 |

이 감사는 이주 전 기록이다. 실제 파일 이동·링크 갱신·PDF/Manifest 생성·Godot 검증이 끝나기 전에는 Ready PR을 만들지 않는다.
