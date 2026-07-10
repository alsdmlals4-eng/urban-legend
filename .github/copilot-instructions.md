# Repository Instructions

이 저장소는 Godot 4.7 stable과 GDScript로 만든 `도시괴담 기록국` 조사/회수 게임이다. 괴담을 처치하는 RPG가 아니라 규칙을 밝혀 봉인·회수하는 데이터 기반 게임이다.

## 먼저 읽을 파일

1. `AGENTS.md`
2. `docs/BASE_RULES_VERSION.md`
3. `docs/DOCUMENTATION_MAP.md`
4. `docs/AI_SHARED_WORK_RULES.md`
5. `docs/AI_WORKFLOW_RULES.md`
6. `docs/MVP_WORKFLOW_CHECKLIST.md`
7. `docs/BENCHMARKING_REFERENCE_GUIDE.md`
8. `docs/CODEX_SHARED_WORK_RULES.md`
9. 현재 GitHub Issue와 `README.md`
10. Godot 구현 작업이면 수정 직전에 `docs/CODEX_SHARED_WORK_RULES.md`를 다시 확인하고, 현재 작업 규칙과 충돌이 있으면 문서를 임의로 바꾸지 말고 보고한다.

Base 원격 링크를 일반 작업의 규칙 출처로 직접 사용하지 않는다. `docs/BASE_RULES_VERSION.md`에 기록된 기준에 따라 이 저장소의 공용 로컬 사본을 먼저 읽는다. 실제 파일 구조와 현재 변경사항을 확인한 뒤 작업한다. 범위 밖 리팩터링과 기존 사용자 변경사항 되돌리기는 금지한다.

## 구조

- `data/episodes/`: JSON 사건 데이터
- `scripts/core/game_state.gd`: Autoload 상태, 씬 간 진행, 저장/불러오기
- `scripts/data/`: JSON 접근과 데이터 변환
- `scripts/scenes/`, `scripts/ui/`: 동적 Godot UI와 씬 흐름
- `scenes/`: 최소 루트 씬과 스크립트 연결

새 GDScript 파일의 첫 줄에는 한국어 역할 주석을 넣는다. battle은 전통 RPG 전투가 아니라 괴이 안정화/회수 페이즈다.

## 검증

변경 후 가능한 범위에서 다음을 실행한다.

```powershell
godot --headless --path . --quit
godot --headless --path . --scene "res://scenes/<changed_scene>.tscn" --quit-after 1
```

Godot가 PATH에 없으면 프로젝트의 Windows Godot 4.7 console 실행 파일을 사용한다. JSON 변경은 UTF-8 파싱과 실제 Godot 로드를 함께 확인한다. 결과 보고에는 변경 이유, 검증 내용, Godot 수동 확인 순서, 남은 위험을 포함한다.
