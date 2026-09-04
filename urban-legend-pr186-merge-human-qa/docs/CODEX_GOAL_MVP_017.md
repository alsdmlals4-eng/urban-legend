# Codex Goal - MVP-017

## Issue

- GitHub Issue: #17
- Title: `[MVP-017] 사건 보고서·요원 신뢰도 결산·전체 흐름 점검 1차 구현`

## 작업 목표

MVP-017은 기존 MVP-001~016에서 쌓인 대화, 조사, 미니게임, 회수, 연구 보상, 요원 신뢰도 흐름을 결과 화면의 `사건 보고서`로 정리하는 작업이다.

플레이어가 결과 화면에서 다음을 이해할 수 있어야 한다.

```text
내가 어떤 선택을 했고, 어떤 단서를 얻었고, 어떤 요원과 신뢰가 쌓였으며, 그 결과 기록국 보고서에 무엇이 남았는가?
```

## 작업 전 확인 파일

반드시 아래 순서로 확인한다.

1. `AGENTS.md`
2. `docs/BASE_RULES_VERSION.md`
3. `docs/DOCUMENTATION_MAP.md`
4. `docs/AI_SHARED_WORK_RULES.md`
5. `docs/AI_WORKFLOW_RULES.md`
6. `docs/MVP_WORKFLOW_CHECKLIST.md`
7. `docs/BENCHMARKING_REFERENCE_GUIDE.md`
8. `docs/CODEX_SHARED_WORK_RULES.md`
9. Issue #17
10. `README.md`
11. `PROJECT_BRIEF.md`
12. `DESIGN_INTENT.md`
13. `MVP_ROADMAP.md`
14. `TEST_CHECKLIST.md`
15. `docs/MVP_STATUS_AUDIT.md`
16. 실제 수정 대상 파일

## 실제 구현 범위

### 1. GameState 사건 보고서 집계 함수 추가

`GameState`에 다음 역할의 함수를 추가한다.

권장 함수명:

```gdscript
get_case_report_summary() -> Dictionary
```

권장 반환값:

```text
{
  episode_title,
  resolution_label,
  clue_collection_rate,
  collected_clues,
  seen_hint_count,
  minigame_results,
  recovery_result,
  unlocked_records,
  unlocked_equipment,
  selected_agents,
  agent_trust,
  triggered_agent_events,
  next_case_notes
}
```

기존 함수와 상태를 재사용한다.

- `get_current_episode_title()`
- `get_resolution_label()`
- `get_clue_collection_rate()`
- `get_collected_clue_ids()` 또는 단서 목록 관련 함수
- `get_minigame_results()`
- `get_current_recovery_result()` 또는 회수 결과 관련 함수
- `get_unlocked_records()`
- `get_unlocked_equipment()`
- `get_selected_agents()`
- `get_agent_trust_values()`
- `get_triggered_agent_event_ids()`
- `get_agent_trust_support_texts()`

새 저장 구조를 무리하게 만들지 말고, 기존 저장 데이터에서 보고서에 필요한 값을 모아 보여준다.

### 2. 결과 화면에 사건 보고서 표시

`result_scene.gd`에 사건 보고서 영역을 추가한다.

표시 항목:

- 에피소드명
- 해결 등급
- 단서 수집률
- 수집 단서 목록
- 확인한 힌트 수
- 미니게임 성공/실패 결과
- 회수 결과
- 연구 보상/해금 기록물/해금 장비
- 선택 요원 목록
- 요원별 수사 파트너 신뢰도
- 발생한 요원 이벤트 또는 보조 안내
- 다음 사건 연결 참고 문구

표시 방식은 우선 텍스트 블록 또는 PanelContainer로 충분하다.

### 3. README 갱신

README에 MVP-017 섹션을 추가한다.

포함:

- 사건 보고서 목적
- 표시 항목
- 기존 MVP-016 요원 신뢰도와의 연결
- 저장/불러오기 주의
- Godot 확인 항목

### 4. 버전/저장 버전 검토

다음 값이 현재 의도와 맞는지 확인한다.

- `scripts/ui/main_menu.gd`의 `GAME_VERSION`
- `scripts/core/game_state.gd`의 `SAVE_VERSION`

주의:

- `SAVE_VERSION`은 저장 호환성 때문에 일부러 낮게 유지했을 수 있다.
- 의도 확인 없이 저장 데이터를 깨는 방식으로 변경하지 않는다.
- 변경하지 않는 경우 보고서에 이유를 적는다.

## 제외 범위

이번 Goal에서 하지 않는다.

- HTML 대시보드 수정
- 새 장기 요원 루트
- 요원별 전용 엔딩
- 새 미니게임
- 새 전투/회수 시스템
- 재판식 추리/논증 시스템
- 대규모 리팩터링
- 기존 저장 데이터 파괴

## 완료 기준

- `get_case_report_summary()` 또는 같은 역할의 사건 보고서 집계 함수가 있다.
- 결과 화면에서 사건 보고서 항목이 표시된다.
- 기존 해결 등급, 피해자 결과, 연구 보상 표시가 깨지지 않는다.
- 요원 신뢰도와 발생한 요원 이벤트가 보고서에 연결된다.
- 저장 후 이어하기에서도 보고서에 필요한 상태가 유지된다.
- 두 번째 사건 준비 흐름이 기존처럼 유지된다.
- README에 MVP-017 설명과 확인 항목이 추가된다.
- `GAME_VERSION` / `SAVE_VERSION` 변경 여부와 이유를 보고한다.

## 검증 방법

가능하면 다음을 실행한다.

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/result_scene.tscn" --quit-after 1
```

Godot 실행이 불가능하면 이유를 보고하고, 최소한 수정한 GDScript/JSON의 구문과 참조 흐름을 직접 확인한다.

## Serena 사용 규칙

이번 작업은 `GameState`, 결과 화면, 저장 데이터, 요원 신뢰도 상태가 연결되므로 Serena 사용 대상이다.

Serena가 가능하면 확인한다.

- `GameState`
- `ResultScene`
- `CaseData`
- `get_agent_trust_values`
- `get_triggered_agent_event_ids`
- `get_unlocked_records`
- `get_unlocked_equipment`
- 결과 화면 생성/갱신 함수

Serena를 사용할 수 없으면 `docs/CODEX_SHARED_WORK_RULES.md`의 대체 확인 절차를 따른다.

## 보고 형식

```md
## Serena 사용 여부

- 사용 가능 여부:
- 실제 사용 여부:
- 확인한 심볼/파일:
- Serena 미사용 시 대체 확인 방법:

## 변경 파일

-

## 변경 이유

-

## 구현 내용

-

## 검증 내용

-

## Godot 확인 순서

1.
2.
3.

## 남은 위험

-

## 다음 MVP에 넘길 항목

-
```
