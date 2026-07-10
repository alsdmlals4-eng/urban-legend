# Codex Goal - MVP-018

## Issue

- 현재 Issue: #18
- 제목: `[MVP-018] 사건 보고서 기반 기록국 DB 탭 강화`

## 목표

MVP-018은 MVP-017에서 구현된 `사건 보고서`를 결과 화면에서 한 번 보고 끝나는 정보가 아니라, 기록국 DB에서 다시 확인할 수 있는 `완료 사건 기록`으로 연결하는 작업이다.

핵심 경험은 다음이다.

```text
내가 해결한 사건이 기록국 DB에 남고, 이후 사건 준비와 기록물 확인에서 다시 참고된다.
```

## 확인할 파일

작업 시작 전에 최신 파일을 직접 확인한다.

- `AGENTS.md`
- `docs/BASE_RULES_VERSION.md`
- `docs/DOCUMENTATION_MAP.md`
- `docs/AI_SHARED_WORK_RULES.md`
- `docs/AI_WORKFLOW_RULES.md`
- `docs/MVP_WORKFLOW_CHECKLIST.md`
- `docs/CODEX_SHARED_WORK_RULES.md`
- 현재 Issue #18 본문
- `README.md`
- `MVP_ROADMAP.md`
- `TEST_CHECKLIST.md`
- `docs/MVP_STATUS_AUDIT.md`
- `data/episodes/episode_001_afterlife_station.json`
- `scripts/core/game_state.gd`
- `scripts/data/case_data.gd`
- `scripts/data/episode_loader.gd`
- `scripts/scenes/result_scene.gd`
- `scripts/ui/database_view.gd` 또는 기록 표시 UI
- `scripts/ui/main_menu.gd`
- 관련 씬 파일

추정하지 말고 실제 파일 구조를 확인한 뒤 수정한다.

## 구현 범위

### 1. 완료 사건 보고서 저장

MVP-017의 사건 보고서 요약을 완료 사건 기록으로 저장한다.

권장 상태명:

```text
completed_case_reports
```

권장 구조:

```text
{
  episode_id,
  episode_title,
  completed_at_label,
  resolution_label,
  clue_collection_rate,
  collected_clues,
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

주의:

- MVP-017의 `get_case_report_summary()` 또는 같은 역할의 함수를 재사용한다.
- 같은 보고서를 중복 저장하지 않도록 episode_id 기준 최신 1개 유지 또는 안전한 중복 방지 방식을 선택한다.
- 기존 저장 파일을 불러올 때 기본값이 안전하게 들어가야 한다.

### 2. 기록국 DB / 기록 표시 UI에 완료 사건 보고서 표시

기존 `database_view.gd` 또는 기록물 표시 UI에 완료 사건 보고서 영역을 추가한다.

표시 항목:

- 완료 사건 목록
- 선택한 사건의 보고서 요약
- 수집 단서 목록
- 미니게임 결과
- 회수 결과
- 연구 보상 / 해금 기록물 / 해금 장비
- 선택 요원 / 요원 신뢰도 / 요원 이벤트
- 다음 사건 참고 문구

목록 선택 + 상세 표시 수준이면 충분하다.

### 3. 기록물/장비 연결 문구

보고서 상세에 해금 기록물/장비가 있으면 연결 문구를 표시한다.

예시:

```text
이 사건에서 확보한 기록물은 다음 사건 준비 화면에서 참고할 수 있다.
해금 장비는 준비 화면에서 장착할 수 있다.
```

### 4. README 갱신

README에 MVP-018 섹션을 추가한다.

포함:

- 완료 사건 보고서 저장 목적
- 기록국 DB 재확인 흐름
- 저장/불러오기 주의
- Godot 확인 항목

## 제외 범위

이번 작업에서 하지 않는다.

- HTML 대시보드 수정
- 완성형 DB 검색/필터 시스템
- 보고서 편집/삭제/정렬/태그 관리
- 새 사건 본편 구현
- 새 미니게임
- 새 전투/회수 규칙
- 장기 요원 개인 루트
- 대규모 리팩터링
- 기존 저장 데이터 파괴

## 완료 기준

- 완료 사건 보고서가 저장 데이터에 포함된다.
- 기존 저장 파일을 불러올 때 완료 사건 보고서 기본값이 안전하게 처리된다.
- 기록국 DB 또는 기존 기록 표시 UI에서 완료 사건 보고서 목록을 볼 수 있다.
- 완료 사건 보고서를 선택하면 상세 요약이 표시된다.
- 보고서 상세에 단서, 미니게임 결과, 회수 결과, 연구 보상, 요원 신뢰도 결산이 표시된다.
- 해금 기록물/장비와 보고서의 연결 문구가 보인다.
- 기존 결과 화면과 두 번째 사건 준비 흐름이 깨지지 않는다.
- README에 MVP-018 설명과 Godot 확인 항목이 추가된다.

## Serena 사용 규칙

이번 작업은 `GameState`, 저장/불러오기, 결과 화면, 기록국 DB UI가 연결되므로 Serena 사용 대상이다.

Serena가 가능하면 다음을 확인한다.

- `GameState`
- `ResultScene`
- `DatabaseView` 또는 기록 표시 UI
- `CaseData`
- `get_case_report_summary`
- 저장/불러오기 함수
- 기록물/장비 해금 조회 함수

Serena가 불가능하면 `docs/CODEX_SHARED_WORK_RULES.md`의 대체 확인 절차를 따른다.

## 작업 후 보고 형식

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
