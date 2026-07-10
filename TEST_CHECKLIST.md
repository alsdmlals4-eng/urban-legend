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
10. `전광판을 촬영한다` 선택지로 단서와 플래그가 추가되는지 확인한다.
11. 조건부 선택지가 플래그 충족 후 활성화되는지 확인한다.
12. 조사씬에 조사 포인트가 표시되는지 확인한다.
13. 조건이 없는 조사 포인트는 바로 조사 가능해야 한다.
14. 조건이 부족한 조사 포인트는 `[잠김]`으로 표시되어야 한다.
15. `역무원실 잠긴 문`에서 파괴/관찰/분석 방법 버튼이 표시되는지 확인한다.
16. 방법 실행 후 판정값, 주사위, 성공/실패, 상태 변화가 표시되는지 확인한다.
17. 선택 요원만 신뢰도 반응에 등장하는지 확인한다.
18. 신뢰도 +2 이상에서 요원 이벤트가 1회만 표시되는지 확인한다.
19. 미니게임 진입 후 성공/실패 결과가 저장되는지 확인한다.
20. 단서 2개 이상 수집 후 해결 시도 버튼이 활성화되는지 확인한다.
21. 회수 페이즈에서 요원 지원이 선택 요원만 표시되는지 확인한다.
22. 괴이 핵 회수 성공 시 결과 화면으로 이동하는지 확인한다.
23. 결과 화면에서 피해자 결과와 연구 보상이 표시되는지 확인한다.
24. 저장 후 메인 메뉴로 돌아가 `이어하기`로 진행 상태가 복원되는지 확인한다.

## 전체 플레이 확인: 두 번째 사건 준비

1. 저승역에서 연구 보상/기록물/장비가 해금된 상태를 만든다.
2. 준비 화면의 `시작할 사건`에서 `비 오는 골목의 빨간 우산`을 선택한다.
3. 두 번째 사건의 시작 대화가 표시되는지 확인한다.
4. 두 번째 사건 조사 포인트 2개가 표시되는지 확인한다.
5. `equip_frequency_filter` 장착 시 주파수 관련 보정 안내가 표시되는지 확인한다.
6. 장비를 해제하면 해당 안내가 사라지는지 확인한다.
7. 저승역 기록물이 해금된 상태에서 반복 패턴 참고 안내가 표시되는지 확인한다.

## MVP-017 확인 항목

Codex 구현 후 확인한다.

1. 저승역을 시작해 대화, 조사 방법, 미니게임, 회수까지 진행한다.
2. 결과 화면에 기존 해결 등급, 피해자 결과, 연구 보상이 유지되는지 확인한다.
3. 사건 보고서 영역이 표시되는지 확인한다.
4. 사건 보고서에 에피소드명, 단서 수집률, 수집 단서 목록이 표시되는지 확인한다.
5. 사건 보고서에 미니게임 성공/실패 결과가 표시되는지 확인한다.
6. 사건 보고서에 선택 요원과 요원별 신뢰도가 표시되는지 확인한다.
7. 발생한 요원 이벤트가 사건 보고서에 표시되는지 확인한다.
8. 저장 후 이어하기로 돌아와도 사건 보고서에 필요한 상태가 유지되는지 확인한다.
9. 두 번째 사건 준비 흐름이 기존처럼 유지되는지 확인한다.

## 현재 남은 검증 위험

- 이 문서는 수동 확인 순서다. 실제 Godot 실행 결과는 사용자가 로컬에서 확인해야 한다.
- `SAVE_VERSION`이 `mvp-014`로 남아 있는 것은 저장 호환성 의도일 수 있으므로, Codex가 구현 전 실제 저장 구조를 확인해야 한다.
- `AGENTS.md`의 현재 MVP 기준선은 아직 MVP-009로 남아 있어, 후속 문서 정합성 작업에서 갱신해야 한다.
