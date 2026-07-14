# MVP-043 저승역 3×3 노선 복원 PoC 검증 기록

> 상태: **Godot 4.7 자동·수동 검증 통과 / 후속 통합 미승인**
>
> 기준일: 2026-07-15
>
> 기준선: `main`의 최신 확장 커밋 `c17d58cdc2560195a8d27b8543ecfa606d8424d7`(초기 제안서 `5a1b575c30895b0d4411c9feafc07c40fd88f99b` 포함), Issue #36, `docs/CODEX_GOAL_MVP_043.md`

## 이번 검증 범위

- 현재 `minigame_frequency_sync`의 런타임 컨트롤이 `route_restore_game.gd`로 교체되는지 확인했다.
- 3×3 PoC의 입력, 경로 판정, 등급, 초기화, 저장 경계와 다른 사건 회귀만 검증했다.
- 현재 3×3은 최종 미니게임이 아니라 4×4 앞의 내부 조작 학습 후보로 취급한다.
- 보호 JSON, `scripts/core/game_state.gd`, 저장 스키마, 4×4 보드와 최종 콘텐츠는 수정하지 않았다.
- 테스트는 모두 별도의 임시 `APPDATA`에서 순차 실행했다. 실제 `user://urban_legend_save.json`은 읽거나 수정하지 않았다.

## 변경한 검증 계약

- `tests/minigame_scene_smoke_test.gd`
  - 저승역은 `route_restore_game.gd`, 빨간 우산은 계속 `rain_dodge_game.gd`가 생성되어야 한다.
- `tests/minigame_controls_test.gd`
  - 초기 가짜 목적지 확정은 위험 사례를 1회 기록하되 보드와 0회 상태를 유지한다.
  - 끊긴 경로는 위험 사례 수를 늘리지 않고 계속 조작할 수 있다.
  - 실제 회전 조합 4회·6회·8회는 각각 `optimal`·`precision`·`standard`로 완료된다.
  - 초기화는 보드·횟수·선택 위치만 되돌리고 이미 관측한 위험 사례는 유지한다.
  - 마우스 클릭과 방향키·Enter·C·R이 동일한 조작 함수로 이어진다.
- `tests/minigame_pipeline_test.gd`
  - 저승역 결과 상세의 `game_type`은 `route_restore`다.
  - 진입 체크포인트에는 보드, 조작 횟수, 위험 사례 관측값이 저장되지 않는다.
  - 체크포인트 재로드 뒤 새 컨트롤은 초기 보드·0회·위험 미관측 상태로 생성된다.
  - 완료 결과 재진입 시 결과 효과와 저장 상세가 다시 적용되지 않고 플레이 컨트롤도 재생성되지 않는다.

## 자동 검증 결과

Godot `4.7.stable.official.5b4e0cb0f`에서 다음을 각각 새로운 임시 `APPDATA`로 실행했다.

| 검증 | 결과 | 확인 내용 |
| --- | --- | --- |
| Headless 프로젝트 로드 | 통과 | 스크립트 파싱과 프로젝트 초기화 오류 없음 |
| `tests/minigame_controls_test.gd` | 통과 | 3×3 계약, 기존 rhythm, 빨간 우산 입력 회귀 |
| `tests/minigame_pipeline_test.gd` | 통과 | 저장 상세, 미완료 상태 비저장, 재진입 중복 방지, 보고서 포함 |
| 저승역 `minigame_scene` smoke | 통과 | `route_restore_game.gd` 생성 |
| 빨간 우산 `minigame_scene` smoke | 통과 | `rain_dodge_game.gd` 유지 |
| `git diff --check` | 통과 | 공백 오류 없음 |

기존 저승역 smoke 실패는 `rhythm_timing_game.gd`를 기대하던 노후화된 테스트 때문이었다. 테스트 기대값을 현재 런타임 연결로 갱신한 뒤에는 실행 차단, 입력, 저장 중복 또는 다른 사건 회귀가 재현되지 않아 런타임 구현 파일은 수정하지 않았다.

## 1280×720 수동 검증 결과

`tests/manual_minigame_launcher.gd`를 격리된 저장 경로에서 실제 창으로 세 번 실행했다.

- 초기 상태에서 `경로 확인`을 눌러 가짜 목적지 위험 문구가 표시되고 보드와 `조작 0회`가 유지되는 것을 확인했다.
- 마우스 타일 클릭으로 4회 경로를 만들고 `최적 복원` 완료를 확인했다.
- 방향키·Enter·C로 6회 경로를 만들고 `정밀 복원` 완료를 확인했다.
- 방향키·Enter·C로 8회 경로를 만들고 `일반 복원` 완료를 확인했다.
- 1280×720에서 규칙, 보드, 현장 기록, 초기화·확정 버튼과 완료 후 복귀 버튼이 화면 안에 표시됐다.
- 미니게임 진행 중 저장 버튼은 없고, 저장 불가 및 종료·불러오기 시 처음부터 재시작한다는 안내가 표시됐다.

## 후속 통합 영향 파일

아래는 승인 후의 영향 범위이며 이번 변경에는 포함하지 않았다.

| 목표 | 우선 영향 파일 | 필요한 변경과 경계 |
| --- | --- | --- |
| 내부 3×3 학습 → 4×4 최종 검증 | `scripts/minigames/route_restore_game.gd` | 보드 크기·타일·목적지·단계 상태를 보드 정의 딕셔너리로 일반화한다. 3×3 종료는 내부 전환만 하고 `completed`를 발생시키지 않는다. |
| 호스트 완료 1회 보장 | `scripts/scenes/minigame_scene.gd` | 4×4 최종 종료 때만 기존 `_on_game_completed()`로 진입해 저장과 효과를 한 번 적용한다. |
| 위험도·괴이 고착 결정 | `scripts/core/game_state.gd` 읽기 경계, `scripts/minigames/route_restore_game.gd` | 기존 `get_anomaly_risk()`와 `get_anomaly_stability()` 값을 진입 시 한 번 읽어 고정 보드 정의를 결정한다. 현재 저장 스키마는 바꾸지 않는다. |
| 마지막 단서 저장 | `scripts/scenes/minigame_scene.gd`, `scripts/minigames/minigame_result_formatter.gd` | 기존 `minigame_results` 상세에 `final_clue_title`, `final_clue_text`, 등급, 위험 사례를 추가하는 안을 우선한다. 별도 저장 루트나 로더를 만들지 않는다. |
| 결과·보고서·DB 제목 동기화 | `scripts/scenes/result_scene.gd`, `scripts/ui/database_view.gd`, `scripts/scenes/battle_scene.gd` | 보호 JSON의 기존 제목 대신 저장 상세의 `display_title`을 우선 표시하고 마지막 단서 상세를 읽는다. |
| 성공 후 회수 직행 | `scripts/scenes/minigame_scene.gd`, `data/episodes/episode_001_afterlife_station.json`, `scripts/scenes/battle_scene.gd` | 승인 단계에서 `success_next_scene_path`를 `res://scenes/battle_scene.tscn`으로 동기화하고 결과 문구와 회수 효과를 함께 맞춘다. |
| 보호 콘텐츠 동기화 | `data/episodes/episode_001_afterlife_station.json`, 관련 GDD·DOCX·로드맵 | 런타임 검증과 콘텐츠 승인 뒤 기존 `minigame_frequency_sync` 항목에 최종 규칙을 편입한다. 새 미니게임 ID나 저장 스키마는 만들지 않는다. |

## 저장·진행 위험

- 내부 3×3 종료 시 `completed`를 발생시키면 4×4 전에 결과와 효과가 저장된다.
- 위험도·괴이 고착을 단계 전환이나 재진입 때 다시 계산하면 보드 조건이 재추첨된 것처럼 달라질 수 있다. 고정 보드라면 새 보드 ID나 시드를 저장할 필요가 없다.
- `result_scene.gd`, `database_view.gd`, `battle_scene.gd`는 현재 원본 JSON 제목 `폐주파수 동기화`를 사용하므로 `display_title`을 읽기 전까지 보고서 제목이 런타임 제목과 다르다.
- 성공 직행 경로만 먼저 바꾸면 마지막 단서 상세와 회수 효과가 준비되기 전에 회수 화면으로 이동할 수 있다. 보호 JSON, 결과 문구, 회수 소비 코드를 한 승인 단위로 동기화해야 한다.
- 3×3·4×4 진행 상태를 `minigame_results`에 중간 저장하면 강제 종료 시 미완료 결과가 완료 기록으로 오인될 수 있다. 저장은 4×4 최종 완료 뒤 한 번만 수행해야 한다.

## 미검증·제외 항목

- 4×4 최종 보드와 3×3에서 4×4로 넘어가는 실제 단계 전환
- 위험도·괴이 고착에 따른 실제 보드 변화와 정밀 해결 보상
- 3인 고정 편성 강제, 목적지 공백 중심 단서 재작성, 마지막 단서 데이터
- 완료 후 회수 페이즈 직행과 결과·보고서·DB의 최종 콘텐츠 동기화
- GDD·DOCX·README·로드맵 통합

이번 검증에서 실행 차단 오류·입력 오류·저장 중복·빨간 우산 회귀는 발견되지 않았다. **Base 승격 후보 없음.** 프로젝트 전용 검증 및 저장 경계로 유지한다.
