# Base → Urban Legend 운영체계 Health Review

## 범위와 기준

- 기준 Base: `eb40b912e5f5a0e4d369105a4f0a770e0a6179a9`
- 검토 대상: Issue #37 보존 감사, #39 거버넌스·Foundation Skill, #40 발행·Health Review
- 비교 방식: 기존 `d2457e75a856260d309203e20262f2a2142d2dd6`은 현 Base 원격 이력의 직접 조상이 아니므로 의미 기반 비교만 수행했다.
- 보호 대상: `project.godot`, `scripts/core/game_state.gd`, `data/episodes/**`, 기존 Scene·승인 자산·실제 QA 증거

## 결과

| 항목 | 상태 | 증거 / 제한 |
|---|---|---|
| 보존 대조 | PASS | `tools/verify_migration_inventory.py` 결과 `preserved=581 missing=0` |
| 책임 문서·Registry | PASS | 12개 책임 원본, 11개 분야 Skill, 선택 Foundation Skill 8개를 Registry 및 검사기가 확인 |
| 거버넌스 | PASS | 문서·Skill 라우팅·발행·인터뷰 검사기를 통과. 게임 경로는 검사 입력이 아닌 보호 경로다. |
| 발행·해시 | PASS | 12개 책임 문서 PDF/Manifest 및 `PROJECT_SKILL_MAP`을 `e39dd7b` 기준으로 재생성했고 자동 PDF 렌더 검토를 통과했다. |
| 링크·콜드 스타트 | PASS | `START_HERE.md` → Active Context → Documentation Map → Registry/Skill Map/보존 감사 경로를 확인했다. |
| Godot editor import | PARTIAL | `--headless --path . --quit`은 exit 0. 종료 시 ObjectDB 2개 누수 경고가 있어 기존 경고로 기록하고 이번 PR에서 수정하지 않는다. |
| 기존 headless smoke | PASS | `minigame_rules_test.gd`: 10 assertions 통과. |
| runtime smoke | PASS | `minigame_scene_smoke_test.gd`의 저승역 `route_restore_game.gd`와 빨간 우산 `rain_dodge_game.gd` 경로가 모두 exit 0. |
| 기존 PowerShell 계약 테스트 | NOT_RUN | 이 로컬 환경에 `pwsh`가 없어 UTF-8 PowerShell 7 실행 증거를 만들지 못했다. CI Windows 환경에서 실행해야 한다. |
| 수동 플레이 QA | NOT_RUN | 실제 플레이 세션 증거가 없으며 문서 이주 PR에서 통과로 표기하지 않는다. |
| 게임 기능·기획 불일치 | NOT_RUN | 이번 범위는 코드/데이터 정렬이 아니다. 발견 시 `[미검증]` 및 별도 Issue로 분리한다. |

## 발행물

- 책임 원본: 각 분야의 `*_PUBLICATION_MANIFEST.json`이 PDF SHA-256, source SHA-256, 자동 렌더 결과를 보관한다.
- Skill Map: `00_프로젝트_허브/PROJECT_SKILL_MAP.pdf` 및 `SKILL_MAP_PUBLICATION_MANIFEST.json`.
- 사람 수동 시각 검토는 모든 발행 Manifest에서 `NOT_RUN`으로 유지한다. 자동 렌더 성공은 사람의 레이아웃 승인과 동일하지 않다.

## 보호 대조

`git diff`와 staged diff에서 다음 보호 경로의 변경은 없었다.

- `project.godot`
- `scripts/core/game_state.gd`
- `data/episodes/**`
- `scripts/**`, `scenes/**`, `assets/**`, `docs/qa/captures/**`

이 판정은 PR 1에서 동결한 작업 시작 기준선(`BASE_SYNC_AUDIT.md`) 대비다. `main` 대비 PR 전체 diff에는 작업 시작 전에 dirty 상태였던 승인 자산·QA 캡처가 보존 대상 그대로 포함될 수 있으며, 이 이주 작업이 새로 만들거나 수정한 게임 변경으로 해석하지 않는다.

## 후속 조치

1. Windows CI에서 `pwsh` 계약 테스트와 문서 거버넌스 워크플로를 확인한다.
2. 수동 플레이 QA는 별도 세션으로 실행하고 결과를 QA 책임 원본에 기록한다.
3. ObjectDB 종료 경고 또는 게임 기능 불일치는 이 문서에서 수정하지 않고 별도 Issue·Goal로 분리한다.
