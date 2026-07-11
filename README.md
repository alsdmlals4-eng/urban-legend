# urban-legend

`urban-legend`는 Godot 4.7 stable + GDScript로 제작하는 현대 괴담 미스터리 비주얼노벨 프로젝트입니다.

현재 목표는 괴담기록국 요원 팀을 편성해 대화, 텍스트 노벨형 조사, 현장 판정, 괴이 안정화/회수, 사건 보고서와 기록국 DB까지 이어지는 PC용 데이터 기반 수사 어드벤처를 완성하는 것입니다.

## 버전 표기

메인 화면의 `Ver` 표기는 수정 작업이 반영될 때마다 0.1씩 올립니다.
현재 버전은 `Ver 3.0`이며, MVP 번호를 소수점으로 반영합니다. 예를 들어 MVP-018은 `Ver 1.8`, MVP-022는 `Ver 2.2`, MVP-028은 `Ver 2.8`, MVP-030은 `Ver 3.0`입니다.

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
      episode_002_red_umbrella_alley.json
  scenes/
    main_menu.tscn
    database_view.tscn
    case_data_scene.tscn
    result_scene.tscn
    investigation_scene.tscn
    dialogue_scene.tscn
    battle_scene.tscn
    minigame_scene.tscn
    preparation_scene.tscn
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
      preparation_scene.gd
    ui/
      main_menu.gd
      database_view.gd
```

## MVP-001 핵심 4개 씬 (초기 이력)

- 조사씬: 캐릭터 본체 없이 장소의 조사 포인트를 클릭해 결과와 힌트 대사를 확인합니다.
- 대화씬: 배경, 스탠딩 placeholder, 이름창, 대사창, 다음 대사, 선택지 테스트를 제공합니다.
- 회수씬: 현재는 아군 요원, 해결 단서, 괴이 안정화 상태, 회수 행동을 분리한 팀 기반 회수 화면으로 발전했습니다. 내부 파일명 `battle_scene`은 저장/경로 호환을 위해 유지합니다.
- 현장 판정씬: 저승역은 줄어드는 원을 `Space/Enter`로 맞추고, 빨간 우산은 방향키로 12초 동안 빗방울을 피합니다. 성공/실패는 조사 상태와 회수 조건에 반영됩니다.

## MVP-002 사건 데이터 구조

저승역 테스트 데이터는 `data/episodes/episode_001_afterlife_station.json`에 있습니다.
메인 메뉴의 `MVP-002 데이터 확인` 버튼을 누르면 단서 수집률, 현재 해결 단계, 단서 목록, 힌트 목록, 현재 연구 보상을 화면에서 확인할 수 있습니다.

핵심 규칙은 다음과 같습니다.

- 힌트는 단서가 아니며, 단서 수집률에 반영하지 않습니다.
- 힌트는 아직 찾지 못한 단서로 향하는 방향 제시입니다.
- 단서만 단서 수집률에 반영합니다.
- 단서는 전투에서 자동 발동할 수 있는 괴이 약화 효과를 가집니다.
- 단서 수집률에 따라 해결 단계가 `해결 불가`, `임시 해결 가능`, `정식 해결 가능`, `완전 해결 가능`으로 나뉩니다.
- 괴이는 없애지 않고 회수하며, 회수 결과에 따라 피해자 구조 결과와 연구 보상이 달라집니다.

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
- `agents`: 임무 투입 가능한 요원 id, 이름, 성향, 역할, 설명, 조사 능력치, 회수 지원
- `player_investigation_stats`: 플레이어의 기본 조사 능력치
- `agent_reactions`: 선택된 요원만 대화씬에 표시하는 성향별 반응 지문
- `investigation_points`: 조사 포인트, 잠김 조건, 조사 결과, 조사 방법, 단서/힌트/플래그 처리
- `minigames`: 사건 진행에 연결되는 미니게임 설정, 성공/실패 결과, 복귀 경로

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

대화씬의 `기록국 힌트 확인` 버튼은 `GameState.get_hints()`에서 힌트를 가져와 표시합니다. 힌트는 대상 단서와 힌트 문구만 보여주며, 단서 수집률에는 반영되지 않습니다. 대화씬 안에서도 힌트 목록 영역과 단서 목록 영역을 분리했습니다.

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

전투씬은 괴이를 없애는 화면이 아니라, 수집한 단서로 괴이의 핵을 안정화하고 회수하는 placeholder 전투입니다.

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
  "current_minigame_id": "minigame_frequency_sync",
  "flags": ["choice_headed_staff_room", "unlocked_staff_room"],
  "minigame_results": {
    "minigame_frequency_sync": {
      "successful": true,
      "result_state": "success",
      "result_text": "반복 안내방송의 규칙을 파악했습니다."
    }
  },
  "method_results": {
    "point_staff_room_door": {
      "method_id": "method_staff_room_observation",
      "successful": true,
      "total": 10
    }
  },
  "agent_trust_changes": {
    "agent_kwon_narae": 2
  },
  "used_agent_supports": ["support_kwon_victim_guard"],
  "investigation_risk": 2,
  "case_understanding": 8,
  "victim_understanding": 10,
  "anomaly_stability": 98,
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
- 기록국 힌트 확인: `seen_hint_ids`에 힌트 id 저장
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
  "standing_id": "bureau_control",
  "lines": [
    {
      "speaker": "기록국 관제",
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

## MVP-009 미니게임 성공/실패 분기

MVP-009부터 미니게임은 별도 테스트 화면이 아니라 저승역 사건 진행 조건으로 사용합니다.

저승역 JSON의 `minigames` 구조입니다.

```json
{
  "id": "minigame_frequency_sync",
  "title": "폐주파수 동기화",
  "description": "반복 안내방송의 잡음 사이에 숨어 있는 피해자의 이름과 숫자 패턴을 맞춥니다.",
  "type": "timing_check",
  "target_count": 3,
  "success_flags": ["minigame_frequency_success", "heard_station_noise", "frequency_sync_completed"],
  "failure_flags": ["minigame_frequency_failed", "frequency_noise_alert", "battle_route_distorted"],
  "success_collect_clues": ["clue_repeating_announcement"],
  "success_show_hint_ids": ["hint_afterlife_station_003"],
  "failure_show_hint_ids": ["hint_afterlife_station_003"],
  "success_result_text": "반복 안내방송의 규칙을 파악했습니다.",
  "failure_result_text": "잡음이 커져 저승역의 경계가 강화되었습니다.",
  "return_scene_path": "res://scenes/investigation_scene.tscn"
}
```

미니게임 진입 경로입니다.

- 대화 선택지 `전광판 사진의 잡음 주파수를 분석한다`
- 조사 포인트 `기록국 단말기: 폐주파수 동기화`

성공/실패 결과입니다.

- 성공 플래그: `minigame_frequency_success`, `heard_station_noise`, `frequency_sync_completed`
- 실패 플래그: `minigame_frequency_failed`, `frequency_noise_alert`, `battle_route_distorted`
- 성공 시 처리: `clue_repeating_announcement` 획득, `hint_afterlife_station_003` 확인 기록
- 실패 시 처리: 위험/불리한 플래그 저장, `hint_afterlife_station_003` 확인 기록
- 결과 저장: `GameState.save_minigame_result(minigame_id, successful)`가 `minigame_results`와 플래그를 함께 저장합니다.

전투 반영입니다.

- `minigame_frequency_success`: 회수 가능 기준이 완화되고 괴이 안정도 시작값이 낮아집니다.
- `minigame_frequency_failed`: 회수 가능 기준이 강화되고 괴이 안정도 시작값이 높아집니다.
- 전투씬의 자동 발동 단서 영역과 시작 안내 문구에 미니게임 영향이 표시됩니다.

## MVP-010 3성향 요원 데이터와 편성

MVP-010은 저승역 흐름 앞단에 요원 선택의 재미를 추가합니다.

이번 범위는 요원 데이터, 요원 2~3명 편성, 선택 요원 저장/불러오기, 3성향 기반 대화 반응까지만 포함합니다. 조사 방법 `파괴 / 관찰 / 분석`, 미니게임 보조, 회수 페이즈 지원, 신뢰도 변화는 MVP-011에서 확장합니다.

### 요원 성향

성향은 3개만 사용합니다.

- `analytical` / 분석형: 규칙 해석, 미니게임 보조, 회수 페이즈 관찰
- `empathetic` / 공감형: 피해자 보호, 위험 완화, 회수 페이즈 방어
- `breakthrough` / 돌파형: 위험 감수, 파괴 우선, 회수 페이즈 공격

### 테스트 요원

- 강이준: `agent_kang_ijun`, 분석형, 디지털 포렌식 담당
- 권나래: `agent_kwon_narae`, 공감형, 기억 상담 담당
- 오현: `agent_oh_hyun`, 돌파형, 현장 정리반

### 데이터 구조

저승역 JSON의 `agents` 예시입니다.

```json
{
  "id": "agent_kang_ijun",
  "name": "강이준",
  "temperament": "analytical",
  "temperament_label": "분석형",
  "class": "현대 요원",
  "role": "디지털 포렌식 담당",
  "description": "삭제된 앱 로그, 통신 기록, CCTV 노이즈를 복원하는 분석 담당.",
  "mvp10_dialogue_focus": "노이즈, 로그, 전광판, 앱 기록의 반복 패턴을 말한다.",
  "mvp11_future_role": "미니게임 보조, 괴이 패턴 관찰, 고가치 힌트 발견"
}
```

저승역 JSON의 `agent_reactions`는 `agent_id`, `temperament`, `conditions`, `text`, `expression`을 사용합니다. 대화씬은 현재 선택된 요원의 반응만 표시하며, 선택되지 않은 요원의 지문은 표시하지 않습니다.

### 추가된 GameState 함수

- `get_agents()`: 요원 데이터 목록을 반환합니다.
- `get_agent_by_id(agent_id)`: 요원 id로 요원 데이터를 조회합니다.
- `select_agent(agent_id)`: 현재 편성에 요원을 추가합니다.
- `deselect_agent(agent_id)`: 현재 편성에서 요원을 제거합니다.
- `set_selected_agent_ids(agent_ids)`: 저장/불러오기 또는 새 게임 시작 시 선택 요원 목록을 교체합니다.
- `clear_selected_agents()`: 선택 요원을 초기화합니다.
- `is_agent_selected(agent_id)`: 특정 요원이 편성되었는지 확인합니다.
- `get_selected_agent_ids()`: 선택 요원 id 목록을 반환합니다.
- `get_selected_agents()`: 선택 요원 데이터 목록을 반환합니다.
- `can_start_mission_with_agents()`: 요원 2~3명 조건을 만족하는지 확인합니다.
- `get_agent_selection_status_text()`: 편성 상태 안내 문구를 반환합니다.
- `get_selected_agent_summary()`: 선택 요원 이름과 성향 요약을 반환합니다.
- `get_selected_agent_reactions()`: 선택 요원 중 조건을 만족한 대화 반응만 반환합니다.

저장 데이터에는 `selected_agent_ids`가 추가되었습니다.

```json
{
  "selected_agent_ids": [
    "agent_kang_ijun",
    "agent_kwon_narae"
  ]
}
```

### 사용 흐름

1. 메인 메뉴의 `임무 투입 요원 편성`에서 요원을 2~3명 선택합니다.
2. 2명 미만이면 `새 게임 / 저승역 시작` 버튼이 비활성화됩니다.
3. 3명을 선택하면 선택되지 않은 나머지 요원 버튼은 비활성화됩니다.
4. `새 게임 / 저승역 시작`을 누르면 선택 요원 id가 저장됩니다.
5. 대화씬의 `편성 요원 반응` 영역에서 선택된 요원만 성향별 지문을 표시합니다.
6. 저장 후 메인 메뉴의 `이어하기`를 누르면 선택 요원이 유지됩니다.
7. `저장 초기화` 또는 새 상태 초기화 시 선택 요원도 초기화됩니다.

## MVP-011 조사 방법, 성향별 지원, 신뢰도 반응

MVP-011은 조사 포인트 1개에 `파괴 / 관찰 / 분석` 접근 방식을 붙이고, 선택 요원 1명이 자동 도우미로 판정에 참여하게 만든 단계입니다.

현재 전체 흐름 적용 지점은 조사씬의 `역무원실 잠긴 문`입니다.

- 파괴 / `destruction`: 빠르게 진입하지만 위험도와 괴이 경계가 오를 수 있습니다. 돌파형 오현이 강합니다.
- 관찰 / `observation`: 피해자 흔적과 열쇠를 안정적으로 확인합니다. 공감형 권나래가 강합니다.
- 분석 / `analysis`: 잠금 패턴과 폐주파수 규칙을 해석합니다. 분석형 강이준이 강합니다.

판정 공식입니다.

```text
판정값 = 플레이어 능력치 + 자동 추천 도우미 요원 능력치 + 1d6
성공 조건 = 판정값 >= 난이도
```

`data/episodes/episode_001_afterlife_station.json`에 추가된 주요 구조입니다.

```json
{
  "player_investigation_stats": {
    "destruction": 2,
    "observation": 2,
    "analysis": 2
  },
  "agents": [
    {
      "id": "agent_kang_ijun",
      "investigation_stats": {
        "destruction": 1,
        "observation": 2,
        "analysis": 4
      },
      "recovery_support": {
        "label": "패턴 예측",
        "role": "관찰"
      }
    }
  ],
  "investigation_points": [
    {
      "id": "point_staff_room_door",
      "method_options": [
        {
          "id": "method_staff_room_analysis",
          "stat_key": "analysis",
          "difficulty": 8,
          "success_effects": {},
          "failure_effects": {},
          "trust_rules": []
        }
      ]
    }
  ]
}
```

MVP-011에서 추가된 `GameState` 상태입니다.

- `investigation_risk`: 조사 중 위험도
- `case_understanding`: 사건 이해도
- `victim_understanding`: 피해자 이해도
- `anomaly_stability`: 조사 결과가 회수 페이즈로 넘기는 괴이 안정도
- `method_results`: 조사 방법 판정 결과 기록
- `agent_trust_changes`: 선택 요원의 수사 파트너 신뢰도 변화
- `used_agent_supports`: 회수 페이즈에서 이미 사용한 요원 지원

MVP-011에서 추가된 주요 `GameState` 함수입니다.

- `get_player_investigation_stats()`: 플레이어 기본 조사 능력치를 반환합니다.
- `get_agent_investigation_stat(agent_id, stat_key)`: 요원별 조사 능력치를 반환합니다.
- `get_investigation_point_by_id(point_id)`: 조사 포인트 데이터를 조회합니다.
- `resolve_investigation_method(point_id, method)`: 조사 방법 판정, 결과 적용, 저장을 처리합니다.
- `get_method_results()`, `get_method_result(point_id)`: 조사 방법 결과를 조회합니다.
- `get_case_status_summary()`: 위험도, 이해도, 괴이 안정도를 반환합니다.
- `get_selected_recovery_supports()`: 선택된 요원만 회수 지원 목록으로 반환합니다.
- `mark_agent_support_used(support_id)`, `has_used_agent_support(support_id)`: 요원 지원 중복 발동을 막습니다.

회수 페이즈에는 선택한 요원만 성향별 지원 버튼으로 표시됩니다.

- 강이준 / 분석형: `패턴 예측`, 괴이 안정도 감소와 회수 기준 완화
- 권나래 / 공감형: `피해자 보호`, 현장 위험/공포도 감소와 회수 기준 완화
- 오현 / 돌파형: `강행 안정화`, 괴이 안정도 직접 감소

선택하지 않은 요원은 대화 반응, 조사 신뢰도 반응, 회수 지원에 등장하지 않습니다.

## MVP-012 텍스트 조사 루프, 괴이 스테이터스, 랜덤 이벤트

MVP-012는 조사 방법 판정 뒤에 사건 상태 변화와 랜덤 이벤트 체크를 연결한 1차 텍스트 조사 루프입니다.

기본 흐름입니다.

1. 대화 또는 조사씬에서 조사 항목을 선택합니다.
2. `역무원실 잠긴 문`에서 파괴 / 관찰 / 분석 중 하나를 선택합니다.
3. 플레이어 능력치 + 선택 요원 능력치 + 1d6으로 판정합니다.
4. 성공/실패 결과가 단서, 힌트, 플래그, 괴이 위험도, 괴이 이해도, 정신력, 괴이 안정도에 반영됩니다.
5. 조사 직후 위험도 기반 랜덤 이벤트를 체크합니다.
6. 단서가 충분하거나 괴이 위험도 100으로 강제 회수전이 발생하면 회수 페이즈로 이동할 수 있습니다.

저승역 JSON에 추가된 데이터입니다.

- `anomaly_status`: 괴이 위험도, 괴이 이해도, 괴이 안정도, 정신력, 예측 연속 성공, 강제 회수전 초기 상태
- `prediction_rules`: 괴이 이해도 기반 예측률과 연속 성공 감쇠 규칙
- `random_events`: `threat_event`, `opportunity_event`, `branch_event` 3종 랜덤 이벤트
- 조사 방법 `success_effects` / `failure_effects`: `anomaly_risk_delta`, `anomaly_understanding_delta`, `mental_stamina_delta`, `anomaly_stability_delta`
- 미니게임 `success_*_delta` / `failure_*_delta`: 폐주파수 동기화 성공/실패가 괴이 상태에 주는 영향

MVP-012에서 추가된 주요 `GameState` 함수입니다.

- `get_anomaly_status_summary()`: 괴이 위험도, 이해도, 안정도, 정신력, 예측률을 한 번에 반환합니다.
- `get_current_prediction_rate()`: 괴이 이해도와 연속 성공 감쇠를 반영한 현재 예측률을 반환합니다.
- `roll_anomaly_prediction()`: 회수 페이즈에서 다음 행동 예측을 굴리고 성공/실패를 저장합니다.
- `apply_prediction_result(successful)`: 예측 성공 연속 횟수를 갱신합니다.
- `reset_prediction_decay()`: 예측 감쇠를 초기화합니다.
- `check_random_event(trigger_tags)`: 조사 태그와 위험도를 기준으로 랜덤 이벤트를 판정합니다.
- `get_last_random_event_result()`: 마지막 랜덤 이벤트 결과를 반환합니다.
- `is_forced_recovery_phase()`: 괴이 위험도 100으로 강제 회수전 상태인지 확인합니다.

확인할 화면입니다.

- 조사씬 상단에 괴이 위험도 / 괴이 이해도 / 피해자 이해도 / 정신력 / 괴이 안정도 / 예측률이 표시됩니다.
- 조사 방법 실행 결과에 상태 변화와 랜덤 이벤트 결과가 표시됩니다.
- 미니게임 성공/실패 결과에 현재 괴이 상태가 표시됩니다.
- 회수 페이즈에 괴이 상태와 예측률이 표시되고 `다음 행동 예측` 버튼을 사용할 수 있습니다.
- 괴이 위험도가 100에 도달하면 조사씬의 해결 시도 버튼이 `강제 회수전 진입`으로 바뀝니다.

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
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/minigame_scene.tscn" --quit-after 1
```

전체 플레이 테스트 순서입니다.

1. 메인 메뉴에서 `새 게임 / 저승역 시작`을 누릅니다.
2. 2명 미만 선택 상태에서는 시작 버튼이 비활성화되는지 확인합니다.
3. 요원 2~3명을 선택한 뒤 `새 게임 / 저승역 시작`을 누릅니다.
4. 대화씬에서 JSON 대사 노드의 대사가 표시되는지 확인합니다.
5. 대화씬의 `편성 요원 반응` 영역에 선택한 요원만 표시되는지 확인합니다.
6. `전광판을 촬영한다` 선택지로 `clue_missing_terminal_sign` 단서와 `choice_photographed_sign` 플래그를 얻습니다.
7. 다음 대화 노드에서 조건부 선택지 `촬영 기록으로 역무원실 접근을 요청한다`가 활성화되는지 확인합니다.
8. 조건부 선택지를 눌러 `unlocked_staff_room` 플래그를 얻고 조사씬으로 이동합니다.
9. 조사씬에서 JSON 조사 포인트 5개가 표시되는지 확인합니다.
10. 새 게임 직후 대화 선택 없이 조사씬에 들어가면 `역무원실 근무 기록`이 `[잠김]`으로 표시되는지 확인합니다.
11. 조건 충족 후 `역무원실 근무 기록`을 눌러 `clue_staff_room_log` 단서와 힌트 기록이 처리되는지 확인합니다.
12. `플랫폼 스피커`를 확인한 뒤 `기록국 단말기: 폐주파수 동기화` 조사 포인트로 미니게임씬에 진입합니다.
13. 줄어드는 원이 판정 원과 겹칠 때 `Space` 또는 `Enter`를 눌러 5박자 중 3회 이상 성공합니다.
14. 새 게임 또는 저장 초기화 후 3회 이상 박자를 놓쳐도 실패 결과 뒤 조사를 계속할 수 있는지 확인합니다.
15. 성공 시 `반복 안내방송 녹음` 단서가 수집되는지 확인합니다.
16. 실패 시 전투씬 시작 안내에서 폐주파수 실패 경고가 보이는지 확인합니다.
17. 조사씬의 `역무원실 잠긴 문`을 눌러 파괴/관찰/분석 방법 버튼이 표시되는지 확인합니다.
18. 방법을 실행하면 플레이어 능력치, 자동 추천 도우미 요원, 주사위, 최종 판정값, 난이도, 성공/실패, 신뢰도 반응이 표시되는지 확인합니다.
19. 선택하지 않은 요원이 조사 반응이나 신뢰도 변화에 등장하지 않는지 확인합니다.
20. 단서 2개 이상 수집 후 `해결 시도` 버튼이 활성화되는지 확인합니다.
21. 회수 페이즈에서 선택 요원만 성향별 지원 버튼으로 표시되는지 확인합니다.
22. 요원 지원을 사용하면 괴이 안정도, 회수 기준 또는 현장 위험/공포도가 변하고 같은 지원이 다시 눌리지 않는지 확인합니다.
23. 전투/회수/결과 화면까지 기존 흐름이 이어지는지 확인합니다.
24. 메인 메뉴로 돌아가 `이어하기`가 미니게임 결과, 선택 요원, 조사 방법 결과, 마지막 저장 씬을 복원하는지 확인합니다.

## 체크리스트

- [ ] Godot 4.7 stable에서 프로젝트가 열린다.
- [ ] 메인 메뉴의 버전 표기가 현재 기준 `Ver 3.0`으로 표시된다.
- [ ] 저승역 JSON에 `agents` 데이터가 존재한다.
- [ ] 요원 성향은 `analytical`, `empathetic`, `breakthrough` 3개만 사용한다.
- [ ] 메인 메뉴에서 요원 2~3명을 선택할 수 있다.
- [ ] 2명 미만이면 `새 게임 / 저승역 시작`이 비활성화된다.
- [ ] 3명 선택 후에는 추가 요원 선택이 제한된다.
- [ ] 선택 요원 id가 저장 데이터의 `selected_agent_ids`에 저장된다.
- [ ] 저장/불러오기 후 선택 요원이 유지된다.
- [ ] 저장 초기화 또는 상태 초기화 시 선택 요원이 초기화된다.
- [ ] 대화씬에서 현재 선택 요원 목록이 표시된다.
- [ ] 대화씬에서 선택된 요원만 성향별 반응 지문을 표시한다.
- [ ] 선택되지 않은 요원 반응은 대화씬에 표시되지 않는다.
- [ ] 조사씬의 `역무원실 잠긴 문`에서 파괴/관찰/분석 조사 방법을 선택할 수 있다.
- [ ] 조사 방법 판정이 플레이어 능력치 + 자동 추천 도우미 요원 능력치 + 1d6으로 계산된다.
- [ ] 조사 방법 성공/실패가 플래그, 단서, 힌트, 위험도, 이해도에 반영된다.
- [ ] 조사 방법 결과가 `method_results`에 저장된다.
- [ ] 선택 요원만 수사 파트너 신뢰도 변화 대상이 된다.
- [ ] 회수 페이즈에서 선택 요원만 성향별 지원 버튼으로 표시된다.
- [ ] 요원 회수 지원은 중복 적용되지 않는다.
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
- [ ] 저승역 JSON에 `minigames`가 정의되어 있다.
- [ ] 미니게임씬이 JSON 미니게임 제목과 설명을 표시한다.
- [ ] 미니게임 성공 결과가 플래그와 `minigame_results`에 저장된다.
- [ ] 미니게임 실패 결과가 플래그와 `minigame_results`에 저장된다.
- [ ] 미니게임 성공 시 `clue_repeating_announcement` 또는 관련 힌트가 처리된다.
- [ ] 미니게임 실패 시 위험/불리한 플래그가 처리된다.
- [ ] 대화 또는 조사에서 미니게임씬으로 이동할 수 있다.
- [ ] 미니게임 종료 후 조사씬으로 복귀할 수 있다.
- [ ] 미니게임 성공/실패 결과가 전투씬 안내 또는 난이도에 반영된다.
- [ ] 저장/불러오기 후 미니게임 결과가 유지된다.
- [ ] `MVP-002 데이터 확인` 화면에서 단서 수집률과 해결 단계가 보인다.
- [ ] `테스트: 다음 단서 수집` 버튼을 누르면 수집률이 20%씩 증가한다.
- [ ] `수집 초기화` 버튼을 누르면 단서 수집률이 0%로 돌아간다.
- [ ] 조사씬에서 조사 포인트 5개를 클릭해 저승역 단서를 수집할 수 있다.
- [ ] 조사씬에서 단서 획득 후 단서 수집률과 현재 해결 단계가 갱신된다.
- [ ] 이미 수집한 단서를 다시 클릭하면 중복 획득 대신 `이미 확인한 단서입니다`가 표시된다.
- [ ] 대화씬에서 대사 진행과 선택지 테스트가 가능하다.
- [ ] 대화씬의 `기록국 힌트 확인` 버튼으로 힌트를 확인할 수 있다.
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
- [ ] 저승역 JSON에 `anomaly_status`, `prediction_rules`, `random_events`가 정의되어 있다.
- [ ] 조사씬에 괴이 위험도, 괴이 이해도, 정신력, 괴이 안정도, 예측률이 표시된다.
- [ ] `역무원실 잠긴 문` 조사 방법 실행 후 상태 변화와 랜덤 이벤트 결과가 표시된다.
- [ ] 랜덤 이벤트는 위협, 기회, 분기 유형 데이터를 가진다.
- [ ] 미니게임 성공/실패가 괴이 위험도, 괴이 이해도, 정신력, 괴이 안정도에 반영된다.
- [ ] 회수 페이즈에 `다음 행동 예측` 버튼과 현재 예측률이 표시된다.
- [ ] 예측 성공 시 연속 성공 감쇠로 다음 예측률이 낮아지고, 실패 시 감쇠가 초기화된다.
- [ ] 괴이 위험도 100 도달 시 강제 회수전 진입이 가능하다.
- [ ] Godot Output / Debugger에 에러가 없다.

## 다음 작업 후보

1. 결과 화면을 엽서/보고서형 UI로 다듬습니다.
2. 연구 보상을 다음 사건의 실제 보정 효과와 연결합니다.
3. 대화 노드와 조사 포인트를 별도 에피소드 데이터 파일로 분리할지 검토합니다.
4. 대화/조사 데이터 검증용 에디터 또는 간단한 체크 도구를 만듭니다.


## MVP-013 장비·기록물·연구 보상 1차 구현

MVP-013은 MVP-012의 조사/회수 흐름 뒤에 기록물, 연구 보상, 장비 해금을 연결합니다. 회수 성공 후 해결 등급이 정식 해결 이상이면 `record_black_ticket_core`, `record_repeating_announcement`, `reward_frequency_analysis`, `equip_frequency_filter`가 해금됩니다. 완전 해결이면 추가 기록물 `record_missing_terminal_sign`도 해금됩니다.

추가된 GameState 저장값은 `unlocked_records`, `unlocked_equipment`, `unlocked_research_rewards`, `equipped_items`, `used_equipment_effects`입니다. 저장/불러오기 후에도 해금 상태와 장비 효과 사용 이력이 유지됩니다.

결과 화면은 획득 기록물, 연구 보상, 장비 해금, 다음 조사 보정을 표시합니다. 기록국 DB의 `MVP-013 보상` 화면에서는 해금 기록물, 연구 보상, 해금 장비와 짧은 설명을 확인할 수 있습니다.

`equip_frequency_filter`는 전투력 장비가 아니라 기록국식 조사 보조 도구입니다. 장착 상태에서는 저승역 리듬 판정 범위가 넓어지고, 빨간 우산에서는 최초 충돌 1회를 방어합니다. `used_equipment_effects`는 같은 사건 판정의 보정이 중복 적용되지 않게 합니다.

작업 보고 시 Serena 사용 가능 여부, 실제 사용 여부, 확인한 심볼/파일, Serena 미사용 시 대체 확인 방법을 구분해 보고합니다.

Godot에서 확인할 항목:

1. 정식 해결 이상 회수 후 결과 화면에 기록물/연구 보상/장비 해금이 표시되는지 확인합니다.
2. 메인 메뉴에서 기록국 DB로 이동해 `MVP-013 보상` 화면에 해금 항목과 설명이 표시되는지 확인합니다.
3. 저장 후 이어하기를 했을 때 해금 상태가 유지되는지 확인합니다.
4. 폐주파수 필터 해금 후 주파수 계열 미니게임에 들어가면 힌트가 1회만 표시되는지 확인합니다.
5. 기존 단서 수집, 미니게임 성공/실패, 회수 결과, MVP-012 상태 표시가 깨지지 않는지 확인합니다.

## MVP-014 사건 준비 화면·장비 장착·마스코트 로그 1차 구현

MVP-014는 MVP-013에서 해금한 기록물, 연구 보상, 장비를 다음 조사 시작 전에 확인하고 선택하는 1차 준비 화면입니다. 핵심 문장은 “괴담은 죽이는 게 아니라, 규칙을 밝혀 봉인하는 것이다.”입니다.

새 준비 화면 `res://scenes/preparation_scene.tscn`은 현재 사건, 선택된 요원 목록, 해금된 장비 목록, 장착 장비, 참고 가능한 기록물, 적용될 조사 보정, 로그 안내 패널을 표시합니다. 메인 메뉴, 결과 화면, 기록국 DB에서 사건 준비 화면으로 이동할 수 있습니다.

장비 장착은 MVP 기준 `tool` 슬롯 1개처럼 동작합니다. `equip_frequency_filter`는 해금된 경우에만 장착할 수 있고, 장착/해제 상태는 기존 저장값 `equipped_items`에 저장됩니다. 저장/불러오기 후에도 장착 상태가 유지되며, 장착 상태일 때만 `get_next_investigation_modifier_text()`와 미니게임의 1회 힌트 보정이 활성화됩니다. 해금되어 있지만 장착하지 않은 경우에는 보정 없음 안내가 표시됩니다.

준비 화면의 참고 기록물은 `record_black_ticket_core`, `record_repeating_announcement`를 포함한 해금 기록물과 각 기록물의 다음 조사 영향 설명을 표시합니다. 기록국 DB의 `MVP-013 보상` 화면에도 현재 장착 장비와 다음 조사 보정 문구를 함께 확인할 수 있습니다.

마스코트 `로그`는 기관에서 지급한 괴담 기록 단말기 속 안내 AI입니다. MVP-014에서는 완성형 캐릭터 시스템이 아니라 준비 화면의 안내 패널로 구현하며, 장비 장착 안내, 기록물 참고 안내, 조사 시작 전 위험 또는 보정 안내를 짧게 표시합니다. 겉모습 설정은 작은 픽셀 유령 또는 말하는 부적 스티커이며, 반전 가능성은 과거에 회수된 괴담의 일부로 남겨둡니다.

HTML 대시보드는 MVP 로드맵, MVP-014 준비 화면 흐름, 로그 캐릭터 카드, 핵심 문장을 기본 데이터와 `data-testid` 기반 테스트 지점에 반영합니다. Playwright는 설치하거나 실행하지 않습니다.

작업 보고 시 Serena 사용 가능 여부, 실제 사용 여부, 확인한 심볼/파일, Serena 미사용 시 대체 확인 방법을 구분해 보고합니다.

Godot에서 확인할 항목:

1. 회수 성공 후 결과 화면에서 `사건 준비로` 버튼으로 준비 화면에 이동되는지 확인합니다.
2. 준비 화면에 현재 사건, 선택된 요원, 해금 장비, 장착 장비, 기록물, 로그 안내가 표시되는지 확인합니다.
3. `equip_frequency_filter`를 장착/해제하고 저장 후 이어하기로 장착 상태가 유지되는지 확인합니다.
4. 장착 상태로 조사/주파수 미니게임에 들어가면 힌트 1회 보정이 표시되고, 해제 상태에서는 보정 없음 안내가 표시되는지 확인합니다.
5. 기록국 DB에서 해금 항목과 현재 장착 장비, 다음 조사 보정 문구를 확인합니다.

## MVP-015 두 번째 사건 골격·준비 보상 연동 1차 구현

MVP-015는 저승역 보상으로 준비한 요원, 기록물, 장비를 두 번째 사건에 연결하는 최소 골격입니다. 두 번째 사건 데이터는 `episode_002_red_umbrella_alley`, 제목은 `비 오는 골목의 빨간 우산`입니다. 준비 화면에서 사건을 선택하면 현재 편성 요원과 해금·장착 상태를 유지한 채 해당 에피소드의 조사로 이동합니다.

두 번째 사건에는 시작 대화, `빗물 배수구의 되감긴 소리`와 `담벼락의 우산 표식` 조사 포인트, `세 박자 빗소리 간격`과 `빨간 우산 경로 표식` 단서가 포함됩니다. `rain_noise`, `route_loop`, `umbrella_mark`, `frequency_related` 태그로 이후 확장할 조사 보정 위치를 명시했습니다. 회수 결과는 이번 단계에서 placeholder로 남겨 둡니다.

`equip_frequency_filter`를 장착한 경우에만 `frequency_related` 조사 포인트에서 로그가 주파수 잡음 힌트 1회 가능 상태를 안내합니다. 장착하지 않으면 이 장비 보정 문구는 표시되지 않습니다. `record_repeating_announcement` 또는 `record_black_ticket_core`가 해금되어 있으면 같은 조사 포인트에서 저승역 반복 패턴과의 참고 안내를 표시합니다. 장비의 실제 미니게임 중복 사용 방지는 기존 `used_equipment_effects` 구조를 그대로 사용합니다.

로그는 두 번째 사건 준비 및 시작 시 사건 브리핑, 장착 장비 보정, 해금 기록물 참고, 경로 반복 위험 경고를 안내합니다. 핵심 원칙은 그대로 유지합니다. “괴담은 죽이는 게 아니라, 규칙을 밝혀 봉인하는 것이다.”

Godot에서 확인할 항목:

1. 준비 화면의 `시작할 사건`에서 `비 오는 골목의 빨간 우산`을 선택하고 조사 시작이 되는지 확인합니다.
2. 두 번째 사건의 시작 대화와 두 조사 포인트, 두 단서가 표시되는지 확인합니다.
3. `equip_frequency_filter` 장착 상태에서 `빗물 배수구의 되감긴 소리`를 조사하면 로그의 주파수 힌트 가능 안내가 표시되는지 확인합니다.
4. 같은 장비를 해제한 상태에서는 해당 장비 보정 문구가 표시되지 않는지 확인합니다.
5. 저승역 기록물을 해금한 상태에서는 조사 결과에 반복 안내방송 또는 검은 승차권 규칙 참고 문구가 표시되는지 확인합니다.
6. 저승역을 새로 시작해도 기존 대화·조사·회수 흐름이 유지되는지 확인합니다.

## MVP-016 요원 신뢰도·요원 이벤트 1차 구현

MVP-016의 요원 신뢰도는 연애 호감도가 아니라 수사 파트너로서의 신뢰입니다. `agent_trust`는 강이준(분석형), 권나래(공감형), 오현(돌파형)별로 `-3 ~ +3` 범위에서 관리하며, 선택된 요원만 변화합니다. 저장 데이터에는 `agent_trust`와 1회 이벤트 이력 `triggered_agent_event_ids`가 함께 기록됩니다. 이전 저장의 `agent_trust_changes`도 불러올 때 호환합니다.

조사 방법이 성향과 맞으면 신뢰도가 오릅니다. `analysis`는 분석형, `observation`은 공감형, `destruction`은 돌파형 요원과 연결됩니다. 기존 조사 방법의 성향별 반응 문구는 조사 결과 패널에 표시되며, 선택하지 않은 요원은 반응이나 신뢰도 변화 대상이 아닙니다.

신뢰도 +2 이상에서는 강이준의 패턴 메모, 권나래의 피해자 흔적, 오현의 돌파 경고 중 조건을 만족한 짧은 요원 이벤트가 한 번만 표시됩니다. 이벤트는 정답을 대신 제공하지 않고 다음 조사 또는 회수 판단에서 참고할 수 있는 보조 안내만 추가합니다.

Godot에서 확인할 항목:

1. 요원 2~3명을 편성하고 저승역의 `역무원실 잠긴 문`에서 조사 방법을 선택합니다.
2. 분석/관찰/파괴 방식에 맞는 선택 요원만 신뢰도 반응과 누적값이 표시되는지 확인합니다.
3. 돌파형 오현을 편성한 뒤 파괴 판정 성공 시 신뢰도 +2와 `오현의 돌파 경고` 이벤트가 표시되는지 확인합니다.
4. 같은 조사 방법을 다시 실행해도 같은 이벤트가 반복 표시되지 않는지 확인합니다.
5. 이벤트 후 조사 상태 패널에 수사 파트너 보조 안내가 유지되는지 확인합니다.
6. 저장 후 이어하기로 신뢰도와 이벤트 표시 이력이 유지되는지 확인합니다.

## MVP-017 사건 보고서·요원 신뢰도 결산 1차 구현

결과 화면은 기존 피해자 구조 결과와 연구 보상을 유지하면서, `GameState.get_case_report_summary()`가 집계한 사건 보고서를 함께 표시합니다. 보고서는 현재 사건의 단서 수집률과 실제 수집 단서, 확인한 힌트 수, 미니게임 결과, 괴이 핵 회수 결과, 이번 결과로 해금된 기록물·연구 보상·장비를 구분합니다.

선택한 요원만 보고서의 수사 파트너 신뢰도와 요원 이벤트 대상으로 표시됩니다. 신뢰도는 연애 호감도가 아니라 수사 파트너로서의 신뢰이며, 저장 데이터에 이미 있던 `agent_trust`, `triggered_agent_event_ids`, 단서·힌트·미니게임·회수·해금 상태를 다시 집계하므로 MVP-017을 위해 새 저장 필드는 추가하지 않았습니다.

MVP-017에서는 저장 구조를 바꾸지 않아 당시 `SAVE_VERSION`을 유지했습니다. 이후 MVP-018에서 완료 사건 기록을 저장하도록 확장하면서 `mvp-018`로 갱신했습니다.

Godot에서 확인할 항목:

1. 저승역을 회수 성공까지 진행한 뒤 결과 화면에 기존 피해자 결과와 연구 보상이 유지되는지 확인합니다.
2. 사건 보고서에서 실제 수집한 단서, 힌트 수, 미니게임 결과, 회수 결과가 표시되는지 확인합니다.
3. 편성한 요원만 신뢰도, 요원 이벤트, 보조 안내에 나타나는지 확인합니다.
4. 결과 화면에서 메인 메뉴 또는 사건 준비 화면으로 이동한 뒤 `이어하기`를 선택해 보고서에 필요한 상태가 유지되는지 확인합니다.

## MVP-018 사건 보고서 기반 기록국 DB 탭 강화

괴이 핵 회수에 성공하고 결과 화면에 들어가면 `GameState.record_current_case_report()`가 MVP-017 사건 보고서를 완료 사건 기록으로 저장합니다. 같은 사건은 중복으로 늘리지 않고 최신 기록 1개로 갱신합니다. 이 기록은 저장 파일의 `completed_case_reports`에 포함되며, 기존 저장 파일에 이 값이 없어도 빈 목록으로 안전하게 불러옵니다.

기록국 데이터베이스의 `완료 사건 기록`을 열면 사건 목록이 보입니다. 사건을 선택하면 실제 수집 단서, 미니게임 결과, 회수 결과, 연구 보상, 해금 기록물·장비, 선택 요원의 수사 파트너 신뢰도와 요원 이벤트를 다시 확인할 수 있습니다. 기록물과 장비가 있다면 준비 화면에서 다시 참고하거나 장착할 수 있다는 연결 안내도 표시됩니다.

이번에는 저장 데이터에 완료 사건 기록이 추가되므로 `SAVE_VERSION`을 `mvp-018`로 올렸습니다. 불러올 때 새 항목이 없는 이전 저장은 빈 목록으로 처리하므로 기존 저장이 깨지지 않습니다.

Godot에서 확인할 항목:

1. 저승역 회수 성공 후 결과 화면으로 이동합니다.
2. 메인 메뉴의 `기록국 데이터베이스 열기`에서 `완료 사건 기록`을 엽니다.
3. 저승역 보고서를 선택해 단서, 미니게임, 회수, 요원 신뢰도, 보상 정보가 표시되는지 확인합니다.
4. 메인 메뉴로 돌아가 `이어하기`를 선택한 뒤에도 같은 보고서가 남아 있는지 확인합니다.

## MVP-019 두 번째 사건 본격 조사 루프 1차 구현

`비 오는 골목의 빨간 우산`은 더 이상 준비 전용 데이터가 아닙니다. 사건 준비에서 선택하면 대화, 조사, 조사 방법 판정, `빗소리 동기화`, 괴이 안정화/회수, 결과 화면, 사건 보고서, 기록국 DB까지 한 번에 진행할 수 있습니다.

조사 포인트는 `비에 젖지 않는 빨간 우산`, `반복되는 골목 표지판`, `물웅덩이에 비친 다른 골목`, `CCTV가 끊긴 사거리` 네 곳입니다. 앞의 세 포인트는 파괴/관찰/분석 방법마다 다른 상태 변화와 문구를 가지며, 세 단서 중 두 개를 모으면 CCTV의 `빗소리 동기화`를 열 수 있습니다. 동기화 성공/실패는 괴이 위험도, 이해도, 정신력과 회수 기준에 반영됩니다.

저승역에서 해금한 반복 안내방송 기록과 `폐주파수 필터`는 정답을 대신 알려주지 않습니다. 대신 준비 화면과 주파수 관련 조사 포인트에서 반복 간격을 읽을 수 있다는 참고 안내와 미니게임 힌트로만 작동합니다.

회수 보상은 이제 에피소드 JSON의 해결 결과에 함께 기록합니다. 따라서 저승역과 빨간 우산 사건은 같은 공통 흐름을 쓰되, 각 사건의 기록물·연구 보상·완료 보고서는 별도로 저장됩니다. 이번 작업은 새 저장 필드를 추가하지 않아 `SAVE_VERSION`은 `mvp-018`을 유지합니다. 기존 저장도 그대로 불러올 수 있습니다.

Godot에서 확인할 항목:

1. 저승역을 정식 해결 이상으로 끝내 기록물 또는 `폐주파수 필터`를 확보합니다.
2. 사건 준비에서 `비 오는 골목의 빨간 우산`을 선택하고, 시작 대화와 선택한 요원 반응을 확인합니다.
3. 빨간 우산, 반복 표지판, 물웅덩이에서 파괴/관찰/분석 중 하나씩 실행해 단서 3개를 수집합니다.
4. 단서 2개 뒤 `CCTV가 끊긴 사거리: 빗소리 동기화`를 열고 성공 또는 실패 결과가 조사 상태에 반영되는지 확인합니다.
5. 해결 시도로 회수 페이즈에 진입해 제목, 자동 단서 효과, 동기화 영향이 빨간 우산 사건 기준으로 보이는지 확인합니다.
6. 회수 후 결과 화면과 기록국 DB의 `완료 사건 기록`에서 저승역과 빨간 우산 보고서가 각각 보이는지 확인합니다.

## MVP-020 두 사건 기준 회고와 UI 전환

MVP-020은 새 기능을 추가하지 않고, 저승역과 `비 오는 골목의 빨간 우산` 두 사건을 데모 기준 샘플로 고정했습니다. 이후에는 세 번째 사건을 추가하지 않고 메인/준비 UI, 조사 추적, 사건 보고서와 기록국 DB, 요원·장비 활용, 회수 UI, 저장 안정성, 모바일 가독성을 차례로 다듬습니다.

현재 공통 흐름은 `준비 → 편성 → 대화 → 조사 → 이벤트/미니게임 → 괴이 안정화·회수 → 사건 보고서 → 기록국 DB`입니다. `battle_scene`은 전통 전투가 아니라 이 흐름의 안정화·회수 단계이며, 요원 신뢰도는 수사 파트너로서의 신뢰입니다.

## MVP-029~030 Steam 데모 후보

- 포함 범위: 저승역, 비 오는 골목의 빨간 우산, 요원 편성, 사건 준비, 대화, 조사, 사건별 현장 판정, 안정화/회수, 보고서, 기록국 DB, 저장/이어하기
- 예상 플레이 시간: 첫 플레이 기준 약 30~50분
- 핵심 시스템: 요원 팀 반응, 수사 방식 선택, 단서/힌트 추적, 짧은 사건 판정, 단서 기반 회수
- 기본 조작: 마우스로 조사 포인트·선택지·행동 버튼 선택, 스크롤로 기록 확인
- 저장 지원: 현재 장면, 편성 요원, 단서, 현장 판정 결과, 회수 결과, 보고서, 장비/기록물, 요원 신뢰도 유지
- 알려진 문제: 대형 일러스트와 애니메이션은 데모 후보 범위에 없으며, UI는 코드 생성 방식이라 해상도별 수동 스크린샷 검수가 더 필요함
- 다음 업데이트: 두 사건 전체 플레이 수동 QA, 스크린샷 후보 확정, 패드 조작 검토
- 스크린샷 후보: 대화 하단 대사창, 조사 상황/선택/결과, 사건별 현장 판정, 회수 요원/근거/행동, 두 사건 완료 DB

한 줄 소개: 괴담기록국 요원 팀을 지휘해 도시괴담의 규칙을 조사하고, 단서를 근거로 괴이를 회수하는 텍스트 노벨형 수사 어드벤처.

짧은 소개: 서로 다른 성향의 요원을 편성하고 도시의 반복 규칙을 조사하세요. 선택과 짧은 현장 판정으로 단서를 확보한 뒤, 기록된 근거를 조합해 괴이를 안정화하고 회수합니다.
