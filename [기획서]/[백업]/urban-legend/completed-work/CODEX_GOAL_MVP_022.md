# Codex Goal - MVP-022

## 기준

- Issue: #29 `[MVP-022] 조사 화면 UI·단서/힌트 추적 개선 1차`
- 기준 문서: `MVP_ROADMAP.md`, `docs/MVP_STATUS_AUDIT.md`, `TEST_CHECKLIST.md`
- 플랫폼 목표: PC 기준 Steam 출시

## 작업 전 확인

먼저 GitHub Base 원본 규칙을 확인한다.

- `alsdmlals4-eng/Base/docs/MVP_WORKFLOW_CHECKLIST.md`
- `alsdmlals4-eng/Base/docs/AI_WORKFLOW_RULES.md`
- `alsdmlals4-eng/Base/docs/BENCHMARKING_REFERENCE_GUIDE.md`

그다음 `docs/DOCUMENTATION_MAP.md`의 읽기 순서를 따른 뒤, Issue #29와 아래 파일을 확인한다.

- `scripts/scenes/investigation_scene.gd`
- `scenes/investigation_scene.tscn`
- `scripts/core/game_state.gd`
- `README.md`
- `TEST_CHECKLIST.md`

## 벤치마킹 반영 기준

Issue #29, `MVP_ROADMAP.md`, `docs/MVP_STATUS_AUDIT.md`의 벤치마킹 결론을 확인하고 Goal에는 실행에 필요한 만큼만 반영한다.

- Unity Asset Store: GUI/Tools/Templates처럼 기능을 명확히 분류하는 정보 구조를 참고한다.
- Tales of Tuscany Demo: 짧은 기능 소개와 즉시 이해되는 상호작용 안내 방식을 참고한다.

## 작업

Issue #29를 기준으로 조사 화면의 정보 위계를 PC/Steam 기준으로 정리한다.

1. `investigation_scene.gd`에서 사건 상태, 조사 포인트, 결과 로그, 단서, 힌트, 회수/안정화 안내를 섹션 단위로 구분한다.
2. 단서와 힌트 표시를 분리하고, 수집/미수집/이번 조사로 얻은 정보가 읽히게 한다.
3. 조사 방법 결과를 `방법 → 성공/실패 → 새 정보 → 상태 변화 → 요원 반응 → 다음 행동` 순서로 요약한다.
4. `해결 시도` 버튼과 안내 문구는 가능한 범위에서 회수/안정화 표현을 강화한다.
5. 기존 조사 포인트 클릭, 조건 잠김, 단서 수집, 힌트 표시, 요원 신뢰도/이벤트, 회수 진입 흐름을 보존한다.
6. `TEST_CHECKLIST.md` 또는 `README.md`에 MVP-022 확인 항목을 반영한다.

## 제한

- 메인 메뉴/사건 준비 UI, 보고서/DB UI, 회수 페이즈 UI를 이번 작업에 포함하지 않는다.
- 새 괴담, 새 미니게임, 저장 구조 변경, 대형 아트, 복잡한 플로우차트 시스템을 추가하지 않는다.
- 모바일 세로 최적화를 이번 기준으로 삼지 않는다.
- Issue와 규칙 문서에 있는 내용을 Goal에 장문 반복하지 않는다.

## 완료 기준

- 조사 화면에서 상태, 조사 포인트, 결과, 단서, 힌트가 구분된다.
- 단서/힌트 추적이 기존보다 읽기 쉽다.
- 조사 방법 결과가 요약 순서로 읽힌다.
- PC 16:9 기준의 정보 위계가 확인된다.
- 기존 저승역/빨간 우산 조사 흐름이 깨지지 않는다.
- Godot headless 또는 수동 확인 결과를 보고한다.

## 보고 형식

```md
## 변경 파일
-

## 벤치마킹 반영
-

## 구현 내용
-

## 유지한 흐름
-

## 검증 내용
-

## 남은 위험
-
```
