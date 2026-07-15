# Repository Guidelines

> 문서 위치: `AGENTS.md` | 문서 라우터: `docs/DOCUMENTATION_MAP.md` | 인수 상태: `docs/CURRENT_HANDOFF.md` | 과거 기록: `docs/archive/README.md`

최신 사용자 지시가 최우선이다. 실제 `main`의 코드·데이터·테스트를 구현 사실로 삼고, 승인 계획·ZIP·목업은 구현 완료로 취급하지 않는다.

## 읽기와 범위

일반 구현은 `AGENTS.md → docs/CURRENT_STATUS.md → docs/DOCUMENTATION_MAP.md → 대상 파일` 순서로 읽는다. 콘텐츠·아트·연출·인수 작업은 여기에 `docs/planning/README.md`, `PROJECT_DIRECTION.md`, 해당 분야 기획서를 추가한다. `archive/**`, 완료 QA·Goal·벤치마크는 현재 작업이 명시적으로 요구할 때만 연다.

작업 시작 시 플레이어 가치, 포함·제외 범위, 영향 파일, 저장·UI 위험, 검증을 짧게 적는다. 가장 작은 end-to-end 단위를 구현하고 사용자 변경과 dirty worktree를 보존한다. 생성·삭제·이동·대규모 수정은 이유와 참조 영향, 백업 위치를 보고한다.

## 보호 계약

- 보호 경로: `scripts/core/game_state.gd`, `data/episodes/*`, `project.godot`, `knowledge/base-pack/*`.
- 고위험 영역: 저장, 캠페인 진행, 경제, 엔딩, 사건 규칙, 기존 ID. 새 저장 필드·버전은 필요성과 이관 테스트가 있을 때만 추가한다.
- 공식 용어: **괴이 기록국**, **안정화 상태**, **위험 사례**, **잔향**, **괴이 매뉴얼**, **기록관 아카**. 내부 `로그` 호환 ID는 유지할 수 있다.
- 괴이는 처치하지 않는다. 조사·안정화·잔향 회수가 핵심이며 `battle_scene`은 전투가 아닌 안정화 화면이다.
- 요원·장비·자동행동·관계 이벤트는 핵심 정답을 대신하지 않는다. 관계는 숫자형 연애 호감도가 아니다.
- 미니게임 중 저장하지 않으며, 아트·표정·컷인·UI는 상태를 표현할 뿐 소유하지 않는다.

## 책임 문서와 검증

현재 상태는 `docs/CURRENT_STATUS.md`, 방향은 `docs/planning/`, 상세 설계는 `docs/GAME_DESIGN_DOCUMENT.md`, 검증은 `TEST_CHECKLIST.md`를 따른다. 조건부 문서는 `docs/DOCUMENTATION_MAP.md`가 정한다. 문서 이동은 `docs/DOCUMENT_LIFECYCLE.md`에 따라 `docs/archive/backup/YYYY-MM-DD/`에 원래 경로·사유·대체 문서를 기록한다.

변경마다 JSON 파싱, `git diff --check`, Godot headless, 변경 화면과 영향 경로를 검증한다. 1280×720과 1920×1080에서 한국어 줄바꿈·포커스·첫 선택 노출을 확인한다. GDD 변경 시 DOCX를 재생성하고 `--check`를 실행한다. 완료 보고에는 변경·검증·미검증·위험·호환·백업·다음 진입점과 Base 승격 후보 여부를 남긴다.
