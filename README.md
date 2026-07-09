# urban-legend

`urban-legend`는 비주얼노벨 / 호러 미스터리 게임을 Godot 4.7 stable + GDScript로 제작하기 위한 프로젝트입니다.

초기 목표는 기존 HTML 기반 `도시괴담 기록국 데이터 편집기`와 작업 보고서의 구조를 Godot 프로젝트로 옮기는 것입니다. 단순 웹 UI 복사가 아니라, Godot에서 실제 비주얼노벨 제작 데이터와 플레이 흐름으로 확장할 수 있는 기반을 만드는 것이 목표입니다.

## 기준 파일

- `C:\Users\user\Downloads\도시괴이담\urban-legend-database.html`
- `C:\Users\user\Downloads\도시괴이담\agent-workflow-report-v28.md`

## 프로젝트 열기

1. Godot 4.7 stable을 실행합니다.
2. `Import`를 누릅니다.
3. 이 폴더의 `project.godot`을 선택합니다.
4. 실행 버튼을 눌러 `scenes/main_menu.tscn`을 시작합니다.

권장 작업 폴더.

```text
C:\Users\user\Documents\GitHub\urban-legend
```

## 현재 구조

```text
urban-legend/
  project.godot
  scenes/
    main_menu.tscn
    database_view.tscn
    investigation_scene.tscn
    dialogue_scene.tscn
    battle_scene.tscn
    minigame_scene.tscn
  scripts/
    core/
      urban_legend_state.gd
    ui/
      main_menu.gd
      database_view.gd
    scenes/
      investigation_scene.gd
      dialogue_scene.gd
      battle_scene.gd
      minigame_scene.gd
```

## 재현할 핵심 요소

HTML 원본에서 Godot로 옮길 핵심 구조입니다.

- 기록국 데이터베이스 느낌의 메인 UI
- 주요 세력, 요원, 장비, 기술 카드
- 호러 에피소드와 일상 에피소드
- 주요 타임라인
- 분기 선택지
- 대화문
- 미니게임 연결
- BGM / SFX 큐
- 제작 점검과 품질 검토
- Godot 이관용 데이터 구조

## MVP-000 현재 상태

현재 커밋은 Godot 프로젝트 골격입니다.

- `main_menu.tscn`에서 프로젝트 소개와 데이터베이스 진입 버튼을 표시합니다.
- `database_view.tscn`에서 섹션 목록과 샘플 항목 상세를 볼 수 있습니다.
- `UrbanLegendState` AutoLoad가 HTML 원본에서 확인한 주요 탭과 샘플 데이터를 보관합니다.

## MVP-001 핵심 4개 씬

### 조사씬

파일.

- `scenes/investigation_scene.tscn`
- `scripts/scenes/investigation_scene.gd`

역할.

- 괴담 현장을 조사하는 1인칭 UI 골격입니다.
- 플레이어 캐릭터 본체는 화면에 표시하지 않습니다.
- 배경 placeholder, 조사 포인트 3개, 작은 초상화 영역, 힌트 대사 영역, 조사 결과 텍스트를 제공합니다.

테스트 방법.

- 메인 메뉴에서 `조사씬 열기`를 누릅니다.
- `낡은 승차권`, `꺼진 전광판`, `검은 우산` 버튼을 눌러 조사 결과와 힌트 대사가 바뀌는지 확인합니다.

### 대화씬

파일.

- `scenes/dialogue_scene.tscn`
- `scripts/scenes/dialogue_scene.gd`

역할.

- 비주얼노벨 기본 대화 UI 골격입니다.
- 배경 placeholder, 캐릭터 스탠딩 placeholder, 이름창, 대사창, 다음 대사 버튼, 테스트 선택지를 제공합니다.

테스트 방법.

- 메인 메뉴에서 `대화씬 열기`를 누릅니다.
- `다음 대사`를 여러 번 눌러 대사가 진행되는지 확인합니다.
- 선택지가 나타나면 하나를 눌러 결과 대사가 표시되는지 확인합니다.

### 전투씬

파일.

- `scenes/battle_scene.tscn`
- `scripts/scenes/battle_scene.gd`

역할.

- 신입 요원 1명과 괴담 현상 1개의 조우 해결 UI 골격입니다.
- 플레이어 체력바, 괴담 위험도 바, 행동 버튼 3개, 지원군 UI, 지원 스킬 버튼, 전투 종료 결과 텍스트를 제공합니다.
- 복잡한 전투 밸런스나 AI는 구현하지 않았습니다.

테스트 방법.

- 메인 메뉴에서 `전투씬 열기`를 누릅니다.
- `기록 스캔`, `임시 봉인지`, `거리 유지`, `연하린 지원 스킬` 버튼을 눌러 체력바와 결과 문구가 바뀌는지 확인합니다.

### 미니게임씬

파일.

- `scenes/minigame_scene.tscn`
- `scripts/scenes/minigame_scene.gd`

역할.

- 폐주파수 파형 맞추기 placeholder 미니게임입니다.
- 간단한 상호작용 버튼, 진행 바, 성공/실패 결과 텍스트를 제공합니다.

테스트 방법.

- 메인 메뉴에서 `미니게임씬 열기`를 누릅니다.
- `파형 맞추기`를 세 번 눌러 성공 문구가 나오는지 확인합니다.
- `잘못된 주파수 선택`을 눌러 실패 문구와 진행 초기화를 확인합니다.

## 테스트 체크리스트

- [ ] Godot 4.7 stable에서 프로젝트가 열린다.
- [ ] 실행 시 `main_menu.tscn`이 시작된다.
- [ ] `기록국 데이터베이스 열기` 버튼으로 `database_view.tscn`에 진입한다.
- [ ] 데이터베이스 화면에서 섹션 버튼이 보인다.
- [ ] `프로젝트 개요`, `주요 세력`, `호러 에피소드`, `요원`, `제작 점검` 섹션을 눌렀을 때 상세 내용이 바뀐다.
- [ ] PC 마우스 클릭과 모바일 터치 기준으로 버튼을 누를 수 있다.
- [ ] `investigation_scene.tscn`에서 조사 포인트 3개를 클릭할 수 있다.
- [ ] `dialogue_scene.tscn`에서 다음 대사 진행과 선택지 테스트가 가능하다.
- [ ] `battle_scene.tscn`에서 행동 버튼 3개와 지원 스킬 버튼이 작동한다.
- [ ] `battle_scene.tscn`에서 지원군 UI가 표시된다.
- [ ] `minigame_scene.tscn`에서 성공/실패 상호작용이 가능하다.

## 다음 작업 후보

1. HTML 원본의 데이터를 JSON 또는 Godot Resource로 추출한다.
2. 에피소드 타임라인 화면을 별도 씬으로 만든다.
3. 분기 선택지와 대화문 미리보기 UI를 구현한다.
4. 요원 ID 카드형 화면을 Godot UI로 재현한다.
5. 제작 점검 항목을 자동 체크하는 검증 스크립트를 추가한다.
