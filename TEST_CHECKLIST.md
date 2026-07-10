# TEST_CHECKLIST

## 목적

이 문서는 `도시괴담 기록국` Godot 프로젝트의 MVP별 수동 확인 순서를 분리해 기록한다.

검증 기준은 기능 이름이 아니라 다음 형식을 우선한다.

```text
조건 → 행동 → 관찰 결과
```

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

1. `MVP_ROADMAP.md`의 현재 기준선이 MVP-020 또는 이후 기준선에서 이 전환 판단을 보존하는지 확인한다.
2. MVP-015~019 회고가 유지할 구조/줄일 구조/위험으로 구분되어 있는지 확인한다.
3. MVP-021~030 로드맵이 새 괴담 에피소드 추가가 아니라 시스템/UI/안정화/데모 중심인지 확인한다.
4. HTML 대시보드 기준이 GitHub 소스가 아니라 로컬 파일 `urban-legend-database-dashboard.html` 방식인지 확인한다.

## MVP-021 메인 UI / 사건 준비 UI 확인 항목

1. 메인 메뉴에서 제목, 버전, 핵심 설명이 주요 버튼과 구분되는지 확인한다.
2. `새 수사 시작`, `이어하기`, `기록국 DB`가 주요 행동으로 묶여 보이는지 확인한다.
3. 저장 초기화와 테스트 씬 버튼이 개발/보조 영역으로 분리되는지 확인한다.
4. 저장 파일 상태와 요원 편성 상태가 한눈에 읽히는지 확인한다.
5. 요원 2명 미만일 때 시작 불가 이유가 명확히 표시되는지 확인한다.
6. 요원 2~3명을 선택하면 시작 가능 상태가 명확히 표시되는지 확인한다.
7. 준비 화면에서 현재 사건, 사건 선택, 요원 요약, 장비, 기록물, 로그, 조사 시작 영역이 구분되는지 확인한다.
8. 장비 장착/해제와 사건 선택이 기존처럼 동작하는지 확인한다.
9. 조사 시작 가능/불가능 이유가 준비 화면에서 보이는지 확인한다.
10. 모바일 세로 화면 기준으로 스크롤 순서와 버튼 간격이 자연스러운지 확인한다.
11. 기존 저승역/빨간 우산 시작, 이어하기, DB 진입, 저장 초기화 흐름이 유지되는지 확인한다.

## 현재 남은 검증 위험

- 이 문서는 수동 확인 순서다. 실제 Godot 실행 결과는 사용자가 로컬에서 확인해야 한다.
- MVP-021은 UI 정보 구조 개선이므로, 기능 성공 여부와 별개로 실제 화면 가독성 확인이 필요하다.
- 모바일 세로 화면의 체감 스크롤 길이와 버튼 간격은 로컬 실행 화면에서 최종 판단한다.
