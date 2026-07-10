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

## MVP-020 회고/규칙 다이어트 확인 항목

1. `MVP_ROADMAP.md`의 전환 판단이 보존되는지 확인한다.
2. MVP-021~030 로드맵이 새 괴담 에피소드 추가가 아니라 시스템/UI/안정화/데모 중심인지 확인한다.
3. HTML 대시보드 기준이 GitHub 소스가 아니라 로컬 파일 `urban-legend-database-dashboard.html` 방식인지 확인한다.

## MVP-021 메인 UI / 사건 준비 UI 확인 항목

1. 메인 메뉴에서 제목, 버전, 핵심 설명이 주요 버튼과 구분되는지 확인한다.
2. `새 수사 시작`, `이어하기`, `기록국 DB`가 주요 행동으로 묶여 보이는지 확인한다.
3. 저장 초기화와 테스트 씬 버튼이 개발/보조 영역으로 분리되는지 확인한다.
4. 준비 화면에서 현재 사건, 사건 선택, 요원 요약, 장비, 기록물, 로그, 조사 시작 영역이 구분되는지 확인한다.
5. PC 16:9 화면에서 버튼 순서, 마우스 클릭 흐름, 정보 위계가 자연스러운지 확인한다.

## MVP-022 조사 화면 UI / 단서·힌트 추적 확인 항목

1. 조사 화면에서 사건 상태, 조사 포인트, 결과 로그, 단서, 힌트, 회수/안정화 안내 영역이 구분되는지 확인한다.
2. 조사 포인트 목록이 클릭 가능한 상태와 잠김 상태를 명확히 구분하는지 확인한다.
3. 단서 목록에서 수집/미수집 상태가 구분되고 수집 단서 수/전체 단서 수가 보이는지 확인한다.
4. 힌트 목록이 단서 목록과 분리되어 표시되는지 확인한다.
5. 조사 방법 선택 결과가 `방법 → 성공/실패 → 새 정보 → 상태 변화 → 요원 반응 → 다음 행동` 순서로 읽히는지 확인한다.
6. 기존 회수/해결 페이즈 진입 흐름이 유지되는지 확인한다.

## MVP-023~027 통합 확인 항목

1. 저승역을 완료한 뒤 결과 화면에서 사건 보고서, 요원 신뢰도, 장비/기록물, 회수 결과가 섹션 단위로 읽히는지 확인한다.
2. 기록국 DB의 `완료 사건 기록`에서 저승역 보고서를 열고 단서, 힌트 수, 미니게임, 회수 결과, 요원, 장비/기록물, 다음 사건 참고가 구분되는지 확인한다.
3. 빨간 우산 사건을 완료한 뒤 DB에서 두 사건 보고서가 별도 항목으로 구분되는지 확인한다.
4. 요원 신뢰도와 요원 이벤트가 연애 호감도가 아니라 수사 파트너 신뢰/사건 기여로 표시되는지 확인한다.
5. 장비/기록물이 획득처와 활용처, 다음 조사 연결성을 설명하는지 확인한다.
6. 회수 페이즈가 전투 승리 화면보다 `회수 근거 → 안정화 상태 → 안정화 행동 → 요원 지원 → 회수 실행` 절차로 읽히는지 확인한다.
7. 결과 화면과 기록국 DB의 저장 상태 요약을 확인한 뒤, 저장 후 게임을 재시작하고 이어하기를 눌렀을 때 완료 보고서, 요원 신뢰도, 장비/기록물, 회수 결과, 현재 씬 경로가 유지되는지 확인한다.
8. 저장 초기화 후 새 게임 흐름이 정상적으로 다시 시작되는지 확인한다.
9. PC 16:9 창 모드/전체화면에서 결과/DB/회수 화면 정보 위계가 읽기 쉬운지 확인한다.
10. 저승역과 빨간 우산 전체 흐름이 깨지지 않는지 확인한다.

## 현재 남은 검증 위험

- 이 문서는 수동 확인 순서다. 실제 Godot 실행 결과는 사용자가 로컬에서 확인해야 한다.
- MVP-023~027은 여러 시스템을 한 번에 다루므로, 기능 추가보다 기존 흐름 보존 검증이 중요하다.
- 저장/이어하기는 로컬 `user://urban_legend_save.json` 상태에 영향을 받으므로 초기화/재시작 확인을 별도로 수행해야 한다.
