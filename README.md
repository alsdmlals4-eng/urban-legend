# urban-legend

`urban-legend`는 Godot 4.7 stable + GDScript로 제작하는 현대 괴담 미스터리 비주얼노벨 프로젝트입니다.

초기 목표는 기존 HTML 기반 `도시괴담 기록국 데이터 편집기`와 작업 보고서의 구조를 Godot 프로젝트로 옮겨, 이후 조사/대화/전투/미니게임 씬이 함께 사용할 수 있는 데이터 기반 게임 골격을 만드는 것입니다.

## 기준 파일

- `C:\Users\user\Downloads\도시괴이담\urban-legend-database.html`
- `C:\Users\user\Downloads\도시괴이담\agent-workflow-report-v28.md`

## 프로젝트 열기

1. Godot 4.7 stable을 실행합니다.
2. `Import`를 누릅니다.
3. `C:\Users\user\Documents\GitHub\urban-legend\project.godot`을 선택합니다.
4. 실행 버튼을 누르면 `scenes/main_menu.tscn`에서 시작합니다.

## 현재 구조

```text
urban-legend/
  project.godot
  data/
    episodes/
      episode_001_afterlife_station.json
  scenes/
    main_menu.tscn
    database_view.tscn
    case_data_scene.tscn
    investigation_scene.tscn
    dialogue_scene.tscn
    battle_scene.tscn
    minigame_scene.tscn
  scripts/
    core/
      urban_legend_state.gd
      game_state.gd
    data/
      episode_loader.gd
      case_data.gd
    scenes/
      investigation_scene.gd
      dialogue_scene.gd
      battle_scene.gd
      minigame_scene.gd
    ui/
      main_menu.gd
      database_view.gd
```

## MVP-001 핵심 4개 씬

- 조사씬: 캐릭터 본체 없이 장소의 조사 포인트를 클릭해 결과와 힌트 대사를 확인합니다.
- 대화씬: 배경, 스탠딩 placeholder, 이름창, 대사창, 다음 대사, 선택지 테스트를 제공합니다.
- 전투씬: 플레이어 1명 vs 괴담 현상 1개 구조의 placeholder이며, 체력바, 행동 버튼, 지원군 UI를 제공합니다.
- 미니게임씬: 폐주파수 파형 맞추기 placeholder로 성공/실패 상호작용을 테스트합니다.

## MVP-002 사건 데이터 구조

저승역 테스트 데이터는 `data/episodes/episode_001_afterlife_station.json`에 있습니다.
메인 메뉴의 `MVP-002 데이터 확인` 버튼을 누르면 단서 수집률, 현재 해결 단계, 단서 목록, 힌트 목록, 현재 연구 보상을 화면에서 확인할 수 있습니다.

핵심 규칙은 다음과 같습니다.

- 힌트는 단서가 아니며, 단서 수집률에 반영하지 않습니다.
- 힌트는 아직 찾지 못한 단서로 향하는 방향 제시입니다.
- 단서만 단서 수집률에 반영합니다.
- 단서는 전투에서 자동 발동할 수 있는 괴이 약화 효과를 가집니다.
- 단서 수집률에 따라 해결 단계가 `해결 불가`, `임시 해결 가능`, `정식 해결 가능`, `완전 해결 가능`으로 나뉩니다.
- 괴이는 처치하지 않고 회수하며, 회수 결과에 따라 피해자 구조 결과와 연구 보상이 달라집니다.

### 데이터 항목

- `episode`: 에피소드 id, 제목, 괴담 유형, 요약, 괴이의 핵
- `victims`: 피해자 id, 이름, 상태, 마지막 목격 위치, 감정 상태, 구조 결과, 이후 이야기
- `hints`: 힌트 id, 대상 단서 id, 출처 타입, 출처 id, 문구, 조건 플래그
- `clues`: 단서 id, 제목, 설명, 위치 id, 관련 피해자/괴담 id, 전투 효과 id, 해결 가중치, 필수 여부, 수집 여부
- `resolution`: 전체 단서 수, 수집 단서 수, 수집률, 해결 단계, 임시/정식/완전 해결 기준
- `battle_clue_effects`: 단서별 전투 자동 효과 id, 효과 타입, 효과 값, 설명
- `research_rewards`: 해결 등급별 연구 보상 id, 능력명, 설명, 다음 에피소드 영향
- `recovery_results`: 해결 등급별 피해자 구조와 괴이 핵 회수 결과

### 저승역 기준

- 에피소드명: 저승역
- 피해자: 막차 이후 사라진 인물
- 괴담 유형: 공간형 괴담
- 괴이의 핵: 존재하지 않는 종착지가 찍힌 검은 승차권
- 단서 총수: 5개
- 해결 기준: 0~39% 해결 불가, 40~69% 임시 해결 가능, 70~99% 정식 해결 가능, 100% 완전 해결 가능

## 주요 스크립트

- `scripts/core/game_state.gd`: 현재 에피소드 로딩, 단서 수집 상태, 수집률, 해결 등급 조회를 담당하는 AutoLoad입니다.
- `scripts/data/episode_loader.gd`: JSON 에피소드 파일을 읽어 `Dictionary`로 변환합니다.
- `scripts/data/case_data.gd`: 힌트/단서 분리, 단서 수집률 계산, 해결 등급 판정, 전투 효과와 연구 보상 조회를 담당합니다.
- `scripts/scenes/case_data_scene.gd`: MVP-002 데이터를 화면에서 확인하고 테스트용 단서 수집을 실행합니다.

## 테스트 방법

Godot 실행 확인.

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
```

씬 단독 실행 확인.

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/main_menu.tscn" --quit-after 1
```

## 체크리스트

- [ ] Godot 4.7 stable에서 프로젝트가 열린다.
- [ ] `main_menu.tscn`에서 데이터베이스, 조사, 대화, 전투, 미니게임 씬으로 이동할 수 있다.
- [ ] `MVP-002 데이터 확인` 화면에서 단서 수집률과 해결 단계가 보인다.
- [ ] `테스트: 다음 단서 수집` 버튼을 누르면 수집률이 20%씩 증가한다.
- [ ] `수집 초기화` 버튼을 누르면 단서 수집률이 0%로 돌아간다.
- [ ] 조사씬에서 조사 포인트 3개를 클릭할 수 있다.
- [ ] 대화씬에서 대사 진행과 선택지 테스트가 가능하다.
- [ ] 전투씬에서 행동 버튼 3개와 지원 스킬 버튼이 작동한다.
- [ ] 미니게임씬에서 성공/실패 상호작용이 가능하다.
- [ ] 저승역 JSON 데이터가 존재한다.
- [ ] 피해자, 힌트, 단서, 해결 단계, 전투 단서 효과, 연구 보상 데이터가 분리되어 있다.
- [ ] 힌트는 단서 수집률에 반영되지 않는다.
- [ ] `GameState.get_clue_collection_rate()`로 단서 수집률을 계산할 수 있다.
- [ ] `GameState.get_resolution_grade()`와 `GameState.get_resolution_label()`로 해결 등급을 확인할 수 있다.
- [ ] Godot Output / Debugger에 에러가 없다.

## 다음 작업 후보

1. 조사씬의 조사 포인트를 저승역 JSON 단서 id와 연결합니다.
2. 대화 선택지 결과가 `GameState.collect_clue()`를 호출하도록 테스트 연결합니다.
3. 전투씬에서 수집된 단서의 `battle_clue_effects`를 자동 표시합니다.
4. 해결 페이즈 진입 버튼과 결과 UI를 별도 placeholder로 추가합니다.
