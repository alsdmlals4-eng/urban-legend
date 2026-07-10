# TEST_CHECKLIST

## 목적

이 문서는 `도시괴담 기록국` Godot 프로젝트의 MVP별 수동 확인 순서를 분리해 기록한다.

검증 기준은 기능 이름이 아니라 다음 형식을 우선한다.

```text
조건 → 행동 → 관찰 결과
```

## 플랫폼 기준

현재 1차 출시 목표는 **PC 기준 Steam 출시**다.

UI/UX 확인은 기본적으로 다음을 우선한다.

- PC 16:9 화면
- 마우스/키보드 입력
- Steam 데모로 처음 접하는 플레이어의 이해도
- 창 모드와 전체화면에서 모두 읽히는 정보 위계

## 공통 실행 확인

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
```

Godot가 PATH에 있으면 다음으로도 확인할 수 있다.

```powershell
godot --headless --path . --quit
```

## 씬 단독 실행 확인

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/main_menu.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/preparation_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/dialogue_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/investigation_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/minigame_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/battle_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/result_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/database_view.tscn" --quit-after 1
```

## 전체 플레이 확인: 저승역

1. 메인 메뉴를 연다.
2. 저장 파일이 없을 때 `이어하기`가 비활성화되는지 확인한다.
3. 요원 2명 미만일 때 `새 게임 / 저승역 시작`이 비활성화되는지 확인한다.
4. 요원 2~3명을 선택한다.
5. `새 게임 / 저승역 시작`으로 준비 화면에 진입한다.
6. 장비 선택/해제 상태가 표시되는지 확인한다.
7. 저승역을 시작한다.
8. 대화씬에서 JSON 대사가 표시되는지 확인한다.
9. 선택 요원 반응 영역에 선택한 요원만 표시되는지 확인한다.
10. 조사/단서/미니게임/회수/결과/보고서/DB 흐름이 유지되는지 확인한다.

## 전체 플레이 확인: 두 번째 사건 빨간 우산

1. 저승역을 정식 해결 이상으로 완료해 기록물 또는 `equip_frequency_filter`를 확보한다.
2. 준비 화면의 `시작할 사건`에서 `비 오는 골목의 빨간 우산`을 선택한다.
3. 시작 대화와 선택한 요원만의 성향 반응이 표시되는지 확인한다.
4. 빨간 우산, 반복 표지판, 물웅덩이 조사 포인트가 표시되고, 각 포인트에서 파괴/관찰/분석 방법이 구분되는지 확인한다.
5. 세 조사 포인트에서 단서 3개를 수집하고 수집률이 갱신되는지 확인한다.
6. 조건부 조사/판정이 잠김과 해금을 구분하는지 확인한다.
7. 미니게임 또는 간단한 판정 결과가 위험도, 이해도, 정신력, 회수 기준에 반영되는지 확인한다.
8. 회수 후 결과 화면에 두 번째 사건 보고서가 표시되는지 확인한다.
9. 기록국 DB의 `완료 사건 기록`에서 저승역과 빨간 우산 보고서가 별도 항목으로 남는지 확인한다.

## MVP-020~027 요약 확인 항목

1. `MVP_ROADMAP.md`의 전환 판단이 보존되는지 확인한다.
2. MVP-021~030 로드맵이 새 괴담 에피소드 추가가 아니라 시스템/UI/안정화/데모 중심인지 확인한다.
3. 메인/준비 UI, 조사 화면, 보고서/DB/요원/장비/회수/저장 흐름이 기존 사건 흐름을 깨지 않는지 확인한다.
4. HTML 대시보드 기준이 GitHub 소스가 아니라 로컬 파일 `urban-legend-database-dashboard.html` 방식인지 확인한다.

## MVP-028 PC/Steam UX·텍스트 노벨형 조사·팀 기반 회수 UI 확인 항목

1. PC 16:9 창 모드에서 대화 화면의 인물/현장/대사창/보조 버튼 정보 위계가 읽히는지 확인한다.
2. 대화 화면에서 별도 주인공이 말하는 느낌보다 요원 팀이 사건에 투입된 느낌이 유지되는지 확인한다.
3. 조사 화면이 대시보드 버튼 나열보다 `상황 텍스트 → 선택지 → 결과 텍스트 → 단서/상태 변화` 흐름으로 읽히는지 확인한다.
4. 조사 선택지가 단순 다음 넘김이 아니라 관찰, 질문, 분석, 강행, 요원 판단, 단서 대조 같은 수사 방식으로 보이는지 확인한다.
5. 조사 결과 후 단서/힌트/위험도/이해도 변화와 요원 반응이 이어지는지 확인한다.
6. 회수 화면 좌상단에 아군 요원/대표 요원/지원 상태가 읽히는지 확인한다.
7. 회수 화면 우상단에 해결 단서/회수 근거/부족 조건이 읽히는지 확인한다.
8. 대표 요원 교체 개념이 UI, 문서, 최소 구현 중 하나 이상에 반영되는지 확인한다.
9. 회수 화면 하단 행동 선택이 안정화 시도, 패턴 분석, 보호 조치, 대표 요원 교체, 강제 회수 같은 선택으로 읽히는지 확인한다.
10. 저승역과 빨간 우산 전체 흐름이 깨지지 않는지 확인한다.

## 현재 남은 검증 위험

- 이 문서는 수동 확인 순서다. 실제 Godot 실행 결과는 사용자가 로컬에서 확인해야 한다.
- MVP-028은 UX 기준 변경이 크므로, 실제 구현은 최소 변경으로 시작하고 큰 구조 변경은 별도 MVP로 분리해야 한다.
- 대표 요원 교체는 파티 전투 시스템으로 확장될 위험이 있으므로 `현장 지휘/회수 담당 전환` 수준으로 제한해야 한다.
