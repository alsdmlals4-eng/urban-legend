# Urban Legend 전수 이주 보존표

## 기준과 판정

- 기준 커밋: `dd3c9a8776eb938eeeeb2f1319af6bfc4a135202`
- Base 기준: `d2457e75a856260d309203e20262f2a2142d2dd6`
- 전수 입력: `docs/MIGRATION_INVENTORY_BEFORE.json` (511 tracked + 70 dirty/untracked = 581)
- 전수 결과: `docs/MIGRATION_INVENTORY_AFTER.json`
- 판정 없는 파일은 허용하지 않는다. 이 문서와 두 JSON은 함께 읽는다.

| 판정 | 수 | 실제 위치 또는 근거 |
|---|---:|---|
| `[본책 이주]` | 문서 책임별 | `[기획서]/01`~`11` 본책과 `등록_부록`에 의미 기준으로 재배치 |
| `[등록 부록]` | 문서 책임별 | 기존 GDD·계획·QA·UI·조사 자료. 원문 SHA-256은 전수 결과로 대조 |
| `[증거]` | 557 보존 항목 포함 | 코드·Scene·데이터·자산·테스트와 `docs/qa/captures` PNG. 경로가 실행 계약이면 유지 |
| `[백업]` | 과거 Goal·감사·archive·이전 진입 문서 | `[기획서]/[백업]/urban-legend/`; 기본 읽기에서 제외 |
| `[보류]` | 재개 조건이 있는 기존 제안 | `[기획서]/[보류]/urban-legend/`; 승인 전 구현 금지 |
| `[제거]` | 23 | QA 실행 로그 22개와 Superpowers 런타임 `server.pid` 1개. 고유 기획·증거는 없으며 Git 이력/실행으로 재생성 가능 |

## 예외와 보호 범위

| 항목 | 판정 | 보존 또는 갱신 조건 |
|---|---|---|
| `docs/qa/captures` PNG 47개 | `[증거]` | 기존 경로를 유지하고 추적한다. 원래 dirty worktree의 SHA-256과 일치해야 한다. |
| 기존 원격 QA 캡처와 `.import` | `[증거]` | Godot import churn을 피하기 위해 기존 실행 경로를 유지한다. |
| QA `.log` 22개 | `[제거]` | `.gitignore`의 `docs/qa/captures/**/*.log`로 재추적을 막는다. PNG 증거와 혼동하지 않는다. |
| `.gitignore` | `[증거]` → 계약 갱신 | 로그 제외 규칙만 추가했다. 보존 대조에서는 `UPDATED_BY_CONTRACT`가 정상이다. |
| `project.godot`, `scripts/core/game_state.gd`, `data/episodes/**` | `[증거]` | 이 PR은 문서 구조만 바꾼다. 전후 SHA-256이 같아야 한다. |
| `BASE_MIGRATION_AUDIT_2026-07-19.md` | `[백업]` | dirty 원본을 그대로 `[백업]/urban-legend/audits/`에 보관하고, 현행 결론은 본책과 이 보존표에서 교정한다. |
| `GAME_DESIGN_DOCUMENT.md`, `TEXT_NOVEL_BENCHMARK_2026-07-14.md` | `[등록 부록]` + `[백업]` | 활성 부록은 새 경로 링크만 갱신했다. 이주 전 원문 SHA-256은 `[백업]/urban-legend/original-appendices/`에 그대로 보존한다. |

## 완료 판정

`tools/verify_migration_inventory.py --before docs/MIGRATION_INVENTORY_BEFORE.json --after docs/MIGRATION_INVENTORY_AFTER.json`은 `missing=0`이어야 한다. `REMOVED_BY_CONTRACT`와 `UPDATED_BY_CONTRACT`는 위 표의 한정된 항목만 허용한다. 모든 활성 본책·Registry·PDF·Manifest·스킬·링크 검증이 끝나기 전에는 이주 PR을 Ready로 표기하지 않는다.
