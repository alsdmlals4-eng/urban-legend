# CORE-MVP-001 구현 상태 보고서

- 작성일: 2026-07-24
- 대상: Issue #56 / Draft PR #57
- 브랜치: `agent/core-mvp-001-poc-20260724`
- 기반: `agent/project-core-mvp-rebase-20260723`
- 판정: `ACTION_REQUIRED / AUTOMATED_VERIFICATION_PENDING`
- 구현 상태: `IMPLEMENTATION_IN_PROGRESS`
- 병합 상태: Draft 유지

## 1. 판정 경계

사용자는 다음 증거를 진행 차단 조건에서 제외했다.

- 현재 대화 전체 원문 메시지
- 신규 플레이어 행동 증거
- 사전 선언 지표

따라서 최신 자동 계약, Godot import, 집중 테스트, 전체 회귀, 수동 UI·보호 경계 검증이 통과하면 `POC_BUILD_READY`까지 판정할 수 있다.

다음은 여전히 선언하지 않는다.

- `POC_BUILD_READY`: 최신 실행 증거 없음
- `POC_PASSED`: 플레이 증거 없음
- `READY_FOR_MERGE`: 최신 회귀와 수동 QA 없음

## 2. 작성된 구현

### 데이터

- `data/poc/core_mvp_001/afterlife_station_poc.json`
- 조사 장면 3개
- 단서 6개: 지지 3, 반박 2, 미해결 1
- 관련 매뉴얼 3개
- 선택지 4개와 배제 규칙 2개
- 가설 2개와 현장 검증 2개
- 회수 패턴 3개, 행동 8개, 고정 5턴
- 포획 결과 3개

### 런타임

- `CoreMvp001CaseData`
  - JSON 로드
  - 고정 ID·수량·중복·참조 검증
  - `reaction_clue_id`, `resolves_question_id`, `refresh_hypothesis_id` 검증
  - 미관측 패턴과 포획 규칙 검증
- `CoreMvp001State`
  - 매뉴얼-선택지 연결과 두 선택지 배제
  - 가설·지지·반박·미해결 근거 작성
  - 무관 근거 거부
  - 현장 검증 성공·실패·부분 갱신·긴급 회수
  - 이해도와 핵심 질문 해소 기록
  - 전조 해석과 미관측 패턴 페어플레이
  - 포획 표식·정상/비용/긴급 포획
  - 결과 3축과 매뉴얼 delta
  - `RESULT_COMPARE → MANUAL_PROMOTION → COMPLETE`
- `CoreMvp001PlaytestLog`
  - 연속 sequence
  - payload deep copy
  - JSONL 내보내기
  - 중복 `poc_started` 방지
- `CoreMvp001Scene`
  - 조사·가설·현장 검증·회수·결과 단일 패널
  - 단계별 ScrollContainer
  - 고정 Footer
  - 읽기 전용 이전 단계 검토
  - 포커스 복구
  - 명시적 회수 턴 진행
  - 결과·매뉴얼 두 단계 확인

### 진입

- `scripts/ui/main_menu.gd`
- F1 개발 패널 버튼: `CORE-MVP-001 조사→전조→포획 PoC`

## 3. 고정 ID 정렬

통합 명세와 구현 사이에 있던 drift를 수정했다.

### 매뉴얼

- `poc001_manual_early_movement_reset`
- `poc001_manual_personal_destination`
- `poc001_manual_ticket_contact_danger`

### 회수 행동

- `poc001_action_observe`
- `poc001_action_guard`
- `poc001_action_cover`
- `poc001_action_protect_trace`
- `poc001_action_hold_position`
- `poc001_action_fix_boundary`
- `poc001_action_isolate_ticket`
- `poc001_action_capture`

폐기 ID는 Python 정적 계약에서 금지한다.

## 4. TDD 증거

| 단계 | 증거 | 결과 |
|---|---|---|
| 데이터 Red | Validate CORE-MVP-001 run #1 | fixture 부재로 예상 실패 |
| 데이터 Green | fixture 추가 뒤 Python 계약 | PASS |
| Godot Red | run #8 | 로더 스크립트 부재로 예상 실패 |
| 집중 테스트 | run #16 | 로더 PASS, 로그 PASS, 상태 테스트 타입 경고 실패 |
| 타입 수정 | recovery sequence index 명시적 `int` | 코드 반영 |
| 이후 강화 | 고정 ID·참조·질문 해소·단계 UI·매뉴얼 상태 | 테스트 우선 반영 / 실행 보류 |

Actions 비용 게이트 이후의 커밋은 자동 실행되지 않았다.

## 5. 정적 적대적 검토 finding

### F-001 고정 ID drift

- 문제: 매뉴얼·행동 ID가 통합 명세와 달랐다.
- 조치: JSON·Python·Godot 테스트·참조를 정본 ID로 통일했다.
- 검증: 최신 실행 `ACTION_REQUIRED`.

### F-002 런타임 참조 검증 누락

- 문제: `reaction_clue_id`, `resolves_question_id`, `refresh_hypothesis_id`를 GDScript 검증기가 확인하지 않았다.
- 조치: 런타임 validator와 실패 테스트를 추가했다.
- 검증: 최신 실행 `ACTION_REQUIRED`.

### F-003 결과 상태 축약

- 문제: 결과 비교에서 바로 COMPLETE로 이동해 `MANUAL_PROMOTION` 상태가 생략됐다.
- 조치: 첫 확인은 반영 검토, 두 번째 확인은 기록 확정으로 분리했다.
- 검증: 최신 실행 `ACTION_REQUIRED`.

### F-004 미해결 질문의 해소 증거 누락

- 문제: 올바른 현장 검증 뒤에도 질문이 매뉴얼 delta의 unresolved 목록에 남았다.
- 조치: `resolved_question_ids`를 상태에 기록하고 `understood`·`verified` 승격 조건에 포함했다.
- 검증: 최신 실행 `ACTION_REQUIRED`.

### F-005 장면 단계 누출

- 문제: 초기 장면은 모든 단계 콘텐츠를 한 스크롤에 구성했고 뒤로가기가 실제 검토를 제공하지 않았다.
- 조치: PhaseHost와 5개 단계 패널, 단계별 스크롤, 읽기 전용 검토, 포커스 복구를 추가했다.
- 검증: 최신 실행 `ACTION_REQUIRED`.

### F-006 렌더 중 상태 자동 진행

- 문제: 회수 렌더가 턴 시작과 전조 읽기를 암묵적으로 실행할 위험이 있었다.
- 조치: 확인 입력으로만 `begin_recovery_turn`과 `read_current_omen`을 호출한다.
- 검증: 정적 확인, 최신 Godot 실행 `ACTION_REQUIRED`.

### F-007 중복 세션 시작 로그

- 문제: logger 시작과 상태 시작 이벤트가 `poc_started`를 두 번 기록할 수 있었다.
- 조치: 동일 세션의 두 번째 시작 이벤트를 거부하고 테스트를 추가했다.
- 검증: 최신 실행 `ACTION_REQUIRED`.

## 6. 테스트 구성

### Python

- `tests/test_core_mvp_001_data_contract.py`
- `tests/test_core_mvp_001_static_contract.py`

### 집중 Godot 4개

- `core_mvp_001_case_data_test`
- `core_mvp_001_state_test`
- `core_mvp_001_playtest_log_test`
- `core_mvp_001_scene_test`

### 전체 회귀

- 기존 39개 + 신규 4개 = 43개 entrypoint

## 7. 보호 경계

PR #57 diff에는 다음 경로가 없다.

- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- 기존 조사·회수 Scene
- `project.godot`
- `knowledge/base-pack/**`
- 저장 Schema 변경

변경된 기존 런타임 파일은 `scripts/ui/main_menu.gd`의 F1 개발 버튼 추가뿐이다.

## 8. CI 비용 최적화

- 문서 workflow: Ubuntu + Python 3.12 + 문서 validator
- 코드 workflow: Ubuntu 1개 job에서 Python → Godot import → 집중 4개 → 전체 43개
- 같은 workflow/ref의 이전 실행 자동 취소
- 실패 artifact만 7일 보존
- `CI_ENABLED != true`이면 job 즉시 skipped
- main/nightly full matrix는 `ACTION_REQUIRED`

## 9. Actions 재개 뒤 필수 검증

1. `CI_ENABLED=true` 설정 또는 비용 게이트 제거
2. main/nightly full matrix workflow 추가
3. 문서 validator
4. Python 데이터·정적 계약
5. Godot 4.7.1 import
6. 집중 테스트 `4/4`
7. 전체 Godot 회귀 `43/43`
8. 1280×720·1920×1080 UI 확인
9. 키보드·마우스·Esc·포커스 확인
10. 기존 저장 비침범 확인
11. 보호 경로 diff 확인
12. PR review thread·mergeability 확인

## 10. 현재 결론

코어 슬라이스의 데이터·상태·로그·장면·개발 진입 코드와 테스트는 작성됐다. 정본 drift와 정적 계약 결함도 수정했다. 그러나 최신 커밋에 대한 Python·Godot 실행 증거가 없으므로 최종 상태는 다음과 같다.

> `IMPLEMENTATION_IN_PROGRESS / ACTION_REQUIRED / AUTOMATED_VERIFICATION_PENDING`

Actions 사용 가능 통보 전에는 추가 runner 검증을 실행하지 않는다.
