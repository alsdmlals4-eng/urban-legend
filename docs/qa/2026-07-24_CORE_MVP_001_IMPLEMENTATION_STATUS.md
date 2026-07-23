# CORE-MVP-001 구현 상태 보고서

- 작성일: 2026-07-24
- 대상: Issue #56 / Draft PR #57
- 브랜치: `agent/core-mvp-001-poc-20260724`
- 기반: `agent/project-core-mvp-rebase-20260723`
- 판정: `ACTION_REQUIRED / AUTOMATED_VERIFICATION_PENDING`
- 구현 상태: `IMPLEMENTATION_IN_PROGRESS`
- 병합 상태: Draft 유지

## 1. 판정 경계

사용자는 현재 대화 전체 원문 메시지, 신규 플레이어 행동 증거, 사전 선언 지표를 진행 차단 조건에서 제외했다. 최신 자동 계약, Godot import, 집중 테스트, 전체 회귀, 수동 UI·보호 경계 검증이 통과하면 `POC_BUILD_READY`까지 판정할 수 있다.

다음은 여전히 선언하지 않는다.

- `POC_BUILD_READY`: 최신 실행 증거 없음
- `POC_PASSED`: 플레이 증거 없음
- `READY_FOR_MERGE`: 최신 회귀와 수동 QA 없음

## 2. 작성된 구현

- 전용 JSON: 조사 장면 3, 단서 6, 매뉴얼 3, 선택지 4, 가설 2, 패턴 3, 행동 8, 고정 5턴, 결과 3
- 런타임 검증기: 고정 ID·수량·중복·참조·미관측 패턴·포획 규칙 검사
- 상태 머신: 배제, 가설 카드, 현장 검증, 이해도, 질문 해소, 전조, 회수 대응, 포획, 결과 3축, 매뉴얼 delta
- 로그: 연속 sequence, deep copy, JSONL, 중복 세션 시작 방지
- UI: 단계별 단일 패널, 단계별 ScrollContainer, 고정 Footer, 읽기 전용 이전 단계, 포커스 복구
- F1 개발 패널 진입: `CORE-MVP-001 조사→전조→포획 PoC`

## 3. 수정된 정적 finding

1. 고정 ID drift를 통합 명세와 정렬
2. 런타임 참조 검증에 `reaction_clue_id`, `resolves_question_id`, `refresh_hypothesis_id` 추가
3. `RESULT_COMPARE → MANUAL_PROMOTION → COMPLETE` 상태 분리
4. `resolved_question_ids`를 이해도·매뉴얼 승격 조건에 반영
5. PhaseHost와 5개 단계 패널·스크롤·읽기 전용 검토 추가
6. 렌더 중 회수 상태 자동 진행 제거
7. 중복 `poc_started` 거부
8. 폐기 ID 정적 검사의 테스트 자기 오탐 제거
9. Godot UI API는 공식 문서로 정적 확인했으나 import·실행 검증을 대체하지 않음

## 4. TDD 증거

| 단계 | 증거 | 결과 |
|---|---|---|
| 데이터 Red | run #1 | fixture 부재로 예상 실패 |
| 데이터 Green | fixture 추가 | Python 계약 PASS |
| Godot Red | run #8 | 로더 부재로 예상 실패 |
| 집중 run #16 | 로더·로그 PASS, 상태 타입 경고 실패 | 원인 확인 |
| 타입 수정 | recovery sequence index 명시적 `int` | 코드 반영 |
| 이후 강화 | ID·참조·질문·UI·매뉴얼·정적 오탐 | 테스트 우선 반영, 실행 대기 |

## 5. 테스트 구성

- Python: 데이터 계약, 정적 통합 계약
- 집중 Godot: 로더, 상태, 로그, 장면 4개
- 전체 회귀: 기존 39개 + 신규 4개 = 43개

## 6. 보호 경계

PR #57 diff에는 다음 경로가 없다.

- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- 기존 조사·회수 Scene
- `project.godot`
- `knowledge/base-pack/**`
- 저장 Schema 변경

기존 런타임 변경은 `scripts/ui/main_menu.gd`의 F1 개발 버튼 추가로 제한한다.

## 7. CI 비용 구조

- `CI_ENABLED != true`이면 PR job은 runner 할당 없이 skipped
- 문서 PR: Ubuntu + Python 3.12 + 문서 validator
- 코드 PR: Ubuntu 1개 job에서 Python → Godot import → 집중 4개 → 전체 43개
- 동일 workflow/ref 실행은 새 커밋에서 자동 취소
- 실패 artifact만 7일 보존
- main/nightly full matrix는 `ACTION_REQUIRED`

## 8. Actions 재개 뒤 필수 검증

1. `CI_ENABLED=true` 설정 또는 비용 게이트 제거
2. main/nightly full matrix workflow 추가
3. 문서 validator
4. Python 데이터·정적 계약
5. Godot 4.7.1 import
6. 집중 테스트 `4/4`
7. 전체 Godot 회귀 `43/43`
8. 1280×720·1920×1080 UI·키보드·Esc·포커스 확인
9. 기존 저장 비침범과 보호 경로 diff 확인
10. PR review thread·mergeability 확인

## 9. 결론

코어 슬라이스의 데이터·상태·로그·장면·개발 진입 코드와 테스트는 작성됐다. 최신 커밋의 Python·Godot 실행 증거는 없으므로 현재 판정은 다음과 같다.

> `IMPLEMENTATION_IN_PROGRESS / ACTION_REQUIRED / AUTOMATED_VERIFICATION_PENDING`
