# urban-legend

`urban-legend`는 Godot 4.7 stable + GDScript로 제작하는 현대 괴담 미스터리 비주얼노벨 프로젝트입니다.

초기 목표는 기존 HTML 기반 `도시괴담 기록국 데이터 편집기`와 작업 보고서의 구조를 Godot 프로젝트로 옮겨, 이후 조사/대화/전투/미니게임 씬이 함께 사용할 수 있는 데이터 기반 게임 골격을 만드는 것입니다.

## 버전 표기

메인 화면의 `Ver` 표기는 수정 작업이 반영될 때마다 0.1씩 올립니다.
현재 버전은 `Ver 1.4`이며, 이후에는 `Ver 1.5`, `Ver 1.6`처럼 갱신합니다.

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
    result_scene.tscn
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
      result_scene.gd
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
- `dialogue_nodes`: 대화 노드, 대사 라인, 선택지, 선택 결과
- `investigation_points`: 조사 포인트, 잠김 조건, 조사 결과, 단서/힌트/플래그 처리

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

## MVP-003 조사/대화 연결

조사씬과 대화씬이 MVP-002 데이터 구조를 실제 플레이 흐름과 연결합니다.

조사씬의 조사 포인트는 저승역 JSON의 단서 id와 연결되어 있습니다.

- `피해자의 휴대폰` -> `clue_last_message`
- `검은 승차권 조각` -> `clue_black_ticket`
- `플랫폼 스피커` -> `clue_repeating_announcement`
- `꺼진 종착지 표지판` -> `clue_missing_terminal_sign`
- `역무원실 근무 기록` -> `clue_staff_room_log`

조사 포인트를 클릭하면 `GameState.collect_clue(clue_id)`가 호출됩니다. 새 단서를 얻으면 단서 제목과 설명이 표시되고, 이미 수집한 단서를 다시 클릭하면 `이미 확인한 단서입니다` 문구가 표시됩니다. 조사씬에는 단서 수집률과 현재 해결 단계가 함께 표시됩니다.

대화씬의 `동료 힌트 확인` 버튼은 `GameState.get_hints()`에서 힌트를 가져와 표시합니다. 힌트는 대상 단서와 힌트 문구만 보여주며, 단서 수집률에는 반영되지 않습니다. 대화씬 안에서도 힌트 목록 영역과 단서 목록 영역을 분리했습니다.

## MVP-004 해결 페이즈 진입 선택

조사씬에서 현재 단서 수집률에 따라 해결 페이즈 진입 여부를 선택할 수 있습니다.

- 40% 미만: `해결 불가`, 해결 시도 버튼 비활성화
- 40~69%: `임시 해결 가능`, 해결 시도 가능
- 70~99%: `정식 해결 가능`, 해결 시도 가능
- 100%: `완전 해결 가능`, 해결 시도 가능

조사씬의 `해결 시도` 버튼을 누르면 확인 패널이 열립니다. 확인 패널에는 현재 단서 수집률, 현재 해결 등급, 위험 안내가 표시됩니다.

- `조사 계속`: 확인 패널을 닫고 조사씬에 남습니다.
- `해결 시도`: `GameState.start_resolution_phase()`를 호출해 현재 해결 등급을 저장한 뒤 `battle_scene.tscn`으로 이동합니다.

MVP-004에서 추가한 `GameState` 함수입니다.

- `can_enter_resolution_phase()`: 현재 단서 수집률로 해결 페이즈에 들어갈 수 있는지 확인합니다.
- `get_resolution_phase_warning()`: 현재 해결 등급에 맞는 위험 안내 문구를 반환합니다.
- `start_resolution_phase()`: 현재 해결 등급, 표시명, 단서 수집률을 저장합니다.
- `get_selected_resolution_grade()`: 저장된 해결 등급 key를 반환합니다.
- `get_selected_resolution_label()`: 저장된 해결 등급 표시명을 반환합니다.
- `get_selected_resolution_rate()`: 해결 시도 당시의 단서 수집률을 반환합니다.

## MVP-005 전투 중 단서 자동 발동과 회수

전투씬은 괴이를 처치하는 화면이 아니라, 수집한 단서로 괴이의 핵을 안정화하고 회수하는 placeholder 전투입니다.

전투 시작 시 `GameState.get_collected_battle_effects()`가 현재 수집된 단서의 `battle_clue_effects`만 가져옵니다. 힌트는 단서가 아니므로 자동 발동 목록에 포함되지 않습니다. 미수집 단서도 자동 발동하지 않습니다.

전투 MVP 기준입니다.

- 괴이 안정도는 100에서 시작합니다.
- 기본 회수 가능 기준은 괴이 안정도 40 이하입니다.
- 수집 단서의 `effect_value` 합계가 클수록 회수 가능 기준이 완화됩니다.
- 현재 계산식은 `40 + floor(effect_value 합계 * 0.5)`이며, 최대 75까지 완화됩니다.
- 수집 단서 효과는 전투 시작 안정도도 조금 낮춥니다.
- `기록 스캔`, `임시 봉인지`, `지원 요청`은 괴이 안정도를 낮춥니다.
- `방어: 위험 억제`는 현장 위험/공포도를 낮추는 placeholder입니다.
- 회수 조건 충족 전에는 `괴이 핵 회수` 버튼이 비활성화됩니다.
- 회수 조건 충족 후 `괴이 핵 회수` 버튼이 활성화됩니다.
- 회수 성공 시 `GameState.save_recovery_result()`로 결과 상태를 저장합니다.

MVP-005에서 추가한 `GameState` 함수입니다.

- `get_collected_clues()`: 현재 수집된 단서 목록을 반환합니다.
- `get_collected_battle_effects()`: 현재 수집된 단서의 전투 자동 효과 목록을 반환합니다.
- `save_recovery_result(successful, result_status, anomaly_stability)`: 회수 성공 여부, 결과 상태, 회수 당시 안정도를 저장합니다.
- `is_recovery_successful()`: 회수 성공 여부를 반환합니다.
- `get_recovery_result_status()`: 저장된 회수 결과 상태를 반환합니다.
- `get_recovery_result_stability()`: 회수 당시 괴이 안정도를 반환합니다.

## MVP-006 결과/연구 보상과 저승역 통합 흐름

저승역 MVP는 메인 메뉴에서 `저승역 MVP 시작` 버튼으로 시작합니다.

전체 흐름입니다.

1. 메인 메뉴
2. 저승역 MVP 시작
3. 대화씬: 사건 브리핑
4. 조사씬: 단서 수집
5. 해결 페이즈 진입 선택
6. 전투씬: 수집 단서 자동 발동
7. 괴이 핵 회수 성공
8. 결과 / 연구 보상 화면
9. 메인 메뉴 복귀 또는 저승역 다시 시작

전투씬에서 `괴이 핵 회수`에 성공하면 `scenes/result_scene.tscn`으로 이동합니다. 결과 화면에는 에피소드명, 해결 등급, 피해자 구조 결과, 피해자 후일담, 괴이 핵 회수 상태, 연구 결과, 해금 능력명, 해금 능력 설명, 다음 사건 영향 placeholder가 표시됩니다.

MVP-006에서 추가한 `GameState` 함수입니다.

- `restart_afterlife_station_flow()`: 저승역 에피소드를 처음 상태로 다시 시작합니다.
- `get_current_episode_title()`: 현재 에피소드명을 반환합니다.
- `get_result_resolution_grade()`: 결과 화면에서 사용할 해결 등급 key를 반환합니다.
- `get_result_resolution_label()`: 결과 화면에서 사용할 해결 등급 표시명을 반환합니다.
- `get_current_recovery_result()`: 현재 해결 등급에 맞는 회수/구조 결과 데이터를 반환합니다.
- `get_current_victim_rescue_result()`: 현재 해결 등급에 맞는 피해자 구조 결과 문구를 반환합니다.
- `get_current_victim_after_story()`: 현재 해결 등급에 맞는 피해자 후일담을 반환합니다.
- `get_current_research_result()`: 현재 해결 등급에 맞는 연구 결과 문구를 반환합니다.
- `get_current_result_research_reward()`: 현재 해결 등급에 맞는 연구 보상 데이터를 반환합니다.

## MVP-007 플래그/조건/저장 상태 관리

MVP-007은 저승역 진행 중 생기는 선택, 조사, 힌트 확인, 해결 시도, 회수 결과를 `GameState`의 상태와 `user://` 저장 파일로 관리합니다.

저장 파일 경로입니다.

```text
user://urban_legend_save.json
```

저장 데이터 구조입니다.

```json
{
  "save_version": "mvp-007",
  "last_updated_at": "시스템 시간 문자열",
  "episode_id": "episode_001_afterlife_station",
  "episode_path": "res://data/episodes/episode_001_afterlife_station.json",
  "current_scene_path": "res://scenes/investigation_scene.tscn",
  "flags": ["choice_headed_staff_room", "unlocked_staff_room"],
  "collected_clue_ids": ["clue_last_message", "clue_black_ticket"],
  "seen_hint_ids": ["hint_afterlife_station_001"],
  "selected_resolution_grade": "temporary",
  "selected_resolution_label": "임시 해결 가능",
  "selected_resolution_rate": 40.0,
  "capture_success": true,
  "capture_result_state": "core_recovered",
  "capture_result_stability": 24
}
```

추가한 주요 `GameState` 함수입니다.

- `add_flag(flag_id)`, `remove_flag(flag_id)`, `has_flag(flag_id)`: 플래그 추가/제거/확인
- `has_all_flags(flag_ids)`, `has_any_flag(flag_ids)`, `get_flags()`, `clear_flags()`: 복수 플래그 판정과 조회
- `check_conditions(conditions)`: `required_flags`, `blocked_flags`, `required_clues`, `min_clue_collection_rate`, `required_resolution_grade`, `capture_success` 조건 판정
- `mark_hint_seen(hint_id)`, `has_seen_hint(hint_id)`, `get_seen_hint_ids()`: 힌트 확인 상태 관리
- `get_collected_clue_ids()`, `has_collected_clue(clue_id)`: 저장과 조건 판정에 쓰는 단서 id 조회
- `save_game()`, `load_game()`, `has_save_file()`, `clear_save_file()`, `reset_run_state()`: 저장/불러오기/초기화
- `set_current_scene_path(scene_path)`, `get_current_scene_path()`, `get_save_file_path()`: 이어하기 위치와 저장 경로 조회

조건 데이터 예시입니다.

```gdscript
{
	"required_flags": ["unlocked_staff_room"],
	"blocked_flags": ["capture_success"],
	"required_clues": ["clue_black_ticket"],
	"min_clue_collection_rate": 40.0,
	"required_resolution_grade": "temporary",
	"capture_success": false
}
```

현재 적용된 플래그/조건 예시입니다.

- 대화씬 선택지 `전광판을 촬영한다`: `choice_photographed_sign` 플래그 추가
- 대화씬 선택지 `역무원실로 향한다`: `choice_headed_staff_room`, `unlocked_staff_room` 플래그 추가
- 조사 포인트 클릭: `inspected_phone`, `visited_ticket_gate`, `heard_station_noise` 같은 조사 플래그 추가
- 역무원실 근무 기록 조사: `unlocked_staff_room` 플래그가 있어야 확인 가능
- 동료 힌트 확인: `seen_hint_ids`에 힌트 id 저장
- 미니게임 성공/실패: `minigame_frequency_success`, `minigame_frequency_failed` 플래그 저장
- 회수 성공: `capture_success`, `capture_result_core_recovered` 플래그 저장

자동 저장 지점입니다.

- 새 게임 시작 후
- 단서 획득 후
- 힌트 확인 후
- 해결 페이즈 진입 후
- 씬 이동 버튼을 통한 진행 위치 변경 후
- 미니게임 성공/실패 후
- 괴이 핵 회수 성공 후
- 결과 화면 진입 후

메인 메뉴에서는 `새 게임 / 저승역 시작`, `이어하기`, `저장 초기화`를 제공합니다. 저장 파일이 없으면 `이어하기` 버튼은 비활성화됩니다.

## MVP-008 데이터 기반 대화/조사 분기

MVP-008부터 저승역 대화와 조사 포인트는 `data/episodes/episode_001_afterlife_station.json`의 데이터에서 읽습니다.

### 대화 데이터

`dialogue_nodes`는 다음 구조를 사용합니다.

```json
{
  "id": "dialogue_intro",
  "background_id": "station_platform_midnight",
  "standing_id": "agent_yeon_harin",
  "lines": [
    {
      "speaker": "연하린",
      "text": "이 역은 지도에도, 기록국 데이터에도 남아 있지 않아요.",
      "expression": "calm"
    }
  ],
  "choices": [
    {
      "id": "choice_photo_terminal_sign",
      "text": "전광판을 촬영한다",
      "conditions": {},
      "result_text": "전광판 사진에 지도에 없는 종착지가 희미하게 남았습니다.",
      "add_flags": ["choice_photographed_sign"],
      "collect_clues": ["clue_missing_terminal_sign"],
      "show_hint_ids": ["hint_afterlife_station_004"],
      "next_node_id": "dialogue_after_photo"
    }
  ]
}
```

대화씬은 `GameState.get_current_dialogue_node()`로 현재 노드를 읽고, 선택지는 JSON의 `choices`에서 생성합니다. 조건은 `GameState.check_conditions()`로 판정하며, 조건이 맞지 않는 선택지는 비활성화됩니다.

선택 결과는 `GameState.apply_story_effects()`가 처리합니다.

- `add_flags`: 플래그 추가
- `remove_flags`: 플래그 제거
- `collect_clues`: 단서 획득
- `show_hint_ids`: 힌트 확인 기록
- `next_node_id`: 다음 대화 노드
- `next_scene_path`: 다음 씬 이동

현재 조건부 선택지 예시는 `촬영 기록을 근거로 역무원실 접근을 요청한다`입니다. `choice_photographed_sign` 플래그가 있을 때 선택할 수 있습니다.

### 조사 데이터

`investigation_points`는 다음 구조를 사용합니다.

```json
{
  "id": "point_staff_room_log",
  "label": "역무원실 근무 기록",
  "clue_id": "clue_staff_room_log",
  "conditions": {
    "required_flags": ["unlocked_staff_room"]
  },
  "locked_text": "아직 확인할 근거가 부족합니다.",
  "result_text": "역무원실 기록에서 막차 이후에도 반복된 출근 도장을 발견했습니다.",
  "add_flags": ["inspected_staff_room_log"],
  "show_hint_ids": ["hint_afterlife_station_005"]
}
```

조사씬은 `GameState.get_investigation_points()`로 조사 포인트를 읽습니다. 조건이 맞지 않는 포인트는 `[잠김]`으로 표시되며, 클릭하면 `locked_text`를 보여줍니다. 조건이 맞으면 `GameState.apply_story_effects()`로 플래그, 단서, 힌트 기록을 처리합니다.

기존 단서 수집률, 해결 등급, 해결 시도 버튼은 그대로 유지됩니다. 저장/불러오기는 `flags`, `collected_clue_ids`, `seen_hint_ids`, `current_dialogue_node_id`, `current_scene_path`를 통해 데이터 기반 진행 상태를 복원합니다.

## 테스트 방법

Godot 실행 확인.

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
```

씬 단독 실행 확인.

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/main_menu.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/investigation_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/dialogue_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/battle_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/result_scene.tscn" --quit-after 1
```

전체 플레이 테스트 순서입니다.

1. 메인 메뉴에서 `새 게임 / 저승역 시작`을 누릅니다.
2. 대화씬에서 JSON 대사 노드의 대사가 표시되는지 확인합니다.
3. `전광판을 촬영한다` 선택지로 `clue_missing_terminal_sign` 단서와 `choice_photographed_sign` 플래그를 얻습니다.
4. 다음 대화 노드에서 조건부 선택지 `촬영 기록으로 역무원실 접근을 요청한다`가 활성화되는지 확인합니다.
5. 조건부 선택지를 눌러 `unlocked_staff_room` 플래그를 얻고 조사씬으로 이동합니다.
6. 조사씬에서 JSON 조사 포인트 5개가 표시되는지 확인합니다.
7. 새 게임 직후 대화 선택 없이 조사씬에 들어가면 `역무원실 근무 기록`이 `[잠김]`으로 표시되는지 확인합니다.
8. 조건 충족 후 `역무원실 근무 기록`을 눌러 `clue_staff_room_log` 단서와 힌트 기록이 처리되는지 확인합니다.
9. 단서 2개 이상 수집 후 `해결 시도` 버튼이 활성화되는지 확인합니다.
10. 전투/회수/결과 화면까지 기존 흐름이 이어지는지 확인합니다.
11. 메인 메뉴로 돌아가 `이어하기`가 마지막 저장 씬과 데이터 기반 상태를 복원하는지 확인합니다.

## 체크리스트

- [ ] Godot 4.7 stable에서 프로젝트가 열린다.
- [ ] `main_menu.tscn`에서 데이터베이스, 조사, 대화, 전투, 미니게임 씬으로 이동할 수 있다.
- [ ] 메인 메뉴에서 `새 게임 / 저승역 시작`으로 대화씬에 진입할 수 있다.
- [ ] 메인 메뉴에서 저장 파일이 없으면 `이어하기`가 비활성화된다.
- [ ] 저장 파일이 있으면 `이어하기`로 마지막 저장 씬에 진입할 수 있다.
- [ ] `저장 초기화`를 누르면 저장 파일이 삭제되고 `이어하기`가 비활성화된다.
- [ ] `GameState.add_flag()`, `remove_flag()`, `has_flag()`로 플래그를 관리할 수 있다.
- [ ] `GameState.check_conditions()`가 플래그, 단서, 단서 수집률, 해결 등급, 회수 성공 조건을 판정한다.
- [ ] 대화 선택 결과로 플래그가 추가된다.
- [ ] 힌트 확인 시 `seen_hint_ids`에 힌트 id가 저장된다.
- [ ] 조사 포인트 확인 시 관련 플래그가 추가된다.
- [ ] 역무원실 근무 기록은 `unlocked_staff_room` 조건이 없으면 막힌다.
- [ ] 단서 수집 상태가 저장/불러오기된다.
- [ ] 해결 등급과 회수 성공 상태가 저장/불러오기된다.
- [ ] 회수 성공 시 `capture_success` 플래그가 추가된다.
- [ ] 저승역 JSON에 `dialogue_nodes`가 정의되어 있다.
- [ ] 저승역 JSON에 `investigation_points`가 정의되어 있다.
- [ ] 대화씬이 JSON 대화 노드를 읽어 대사를 표시한다.
- [ ] 대화 선택지가 JSON 데이터에서 생성된다.
- [ ] 조건부 선택지가 조건에 따라 비활성화/활성화된다.
- [ ] 선택 결과로 플래그, 단서, 힌트 기록, 다음 노드/씬 이동이 처리된다.
- [ ] 조사씬이 JSON 조사 포인트를 읽어 표시한다.
- [ ] 조건부 조사 포인트가 `[잠김]`으로 표시되고 `locked_text`를 보여준다.
- [ ] 조사 결과로 플래그, 단서, 힌트 기록이 처리된다.
- [ ] 저장/불러오기 후 현재 대화 노드와 데이터 기반 진행 상태가 유지된다.
- [ ] `MVP-002 데이터 확인` 화면에서 단서 수집률과 해결 단계가 보인다.
- [ ] `테스트: 다음 단서 수집` 버튼을 누르면 수집률이 20%씩 증가한다.
- [ ] `수집 초기화` 버튼을 누르면 단서 수집률이 0%로 돌아간다.
- [ ] 조사씬에서 조사 포인트 5개를 클릭해 저승역 단서를 수집할 수 있다.
- [ ] 조사씬에서 단서 획득 후 단서 수집률과 현재 해결 단계가 갱신된다.
- [ ] 이미 수집한 단서를 다시 클릭하면 중복 획득 대신 `이미 확인한 단서입니다`가 표시된다.
- [ ] 대화씬에서 대사 진행과 선택지 테스트가 가능하다.
- [ ] 대화씬의 `동료 힌트 확인` 버튼으로 힌트를 확인할 수 있다.
- [ ] 힌트를 확인해도 단서 수집률이 변하지 않는다.
- [ ] 힌트 목록과 단서 목록이 같은 영역에 섞이지 않는다.
- [ ] 조사씬에서 단서 수집률 40% 미만일 때 해결 시도 버튼이 비활성화된다.
- [ ] 조사씬에서 단서 2개 이상을 수집하면 해결 시도 버튼이 활성화된다.
- [ ] 해결 시도 버튼을 누르면 현재 해결 등급과 위험 안내가 표시된다.
- [ ] `조사 계속`을 누르면 조사씬에 남는다.
- [ ] `해결 시도`를 누르면 현재 해결 등급이 저장되고 전투씬으로 이동한다.
- [ ] 전투씬 시작 시 수집한 단서가 자동 발동한다.
- [ ] 전투씬에 자동 발동된 단서 목록과 효과 설명이 표시된다.
- [ ] 힌트와 미수집 단서는 전투 자동 발동에 포함되지 않는다.
- [ ] 전투씬에서 현재 해결 등급이 표시된다.
- [ ] 괴이 안정도와 회수 가능 조건이 표시된다.
- [ ] 기본 행동 버튼이 괴이 안정도 또는 위험/공포도에 영향을 준다.
- [ ] 회수 조건 충족 전에는 `괴이 핵 회수` 버튼이 비활성화된다.
- [ ] 회수 조건 충족 후에는 `괴이 핵 회수` 버튼이 활성화된다.
- [ ] 회수 성공 시 결과 상태가 `GameState`에 저장되고 결과 화면으로 이동한다.
- [ ] 결과 화면에 에피소드명, 해결 등급, 피해자 구조 결과가 표시된다.
- [ ] 해결 등급에 따라 피해자 후일담과 연구 보상이 달라진다.
- [ ] 결과 화면에서 메인 메뉴로 돌아갈 수 있다.
- [ ] 결과 화면에서 저승역을 다시 시작할 수 있다.
- [ ] 대화 → 조사 → 해결 페이즈 → 전투/회수 → 결과 화면까지 이어진다.
- [ ] 미니게임씬에서 성공/실패 상호작용이 가능하다.
- [ ] 저승역 JSON 데이터가 존재한다.
- [ ] 피해자, 힌트, 단서, 해결 단계, 전투 단서 효과, 연구 보상 데이터가 분리되어 있다.
- [ ] 힌트는 단서 수집률에 반영되지 않는다.
- [ ] `GameState.get_clue_collection_rate()`로 단서 수집률을 계산할 수 있다.
- [ ] `GameState.get_resolution_grade()`와 `GameState.get_resolution_label()`로 해결 등급을 확인할 수 있다.
- [ ] Godot Output / Debugger에 에러가 없다.

## 다음 작업 후보

1. 결과 화면을 엽서/보고서형 UI로 다듬습니다.
2. 연구 보상을 다음 사건의 실제 보정 효과와 연결합니다.
3. 대화 노드와 조사 포인트를 별도 에피소드 데이터 파일로 분리할지 검토합니다.
4. 대화/조사 데이터 검증용 에디터 또는 간단한 체크 도구를 만듭니다.
