# D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY

## Decision

저승역 노선 복원 미니게임의 성공 판정은 실제 출발점→타일 연결→도착점 연결성 하나를 권위로 사용한다.

최종 4×4 보드의 도착 타일은 좌측에서 진입하므로 WEST 연결을 가져야 한다. 튜토리얼 3×3 보드의 도착 타일은 기존 SOUTH 연결을 유지한다.

## Correctness contract

- `start`, `safe`, `false` endpoint도 보드별 실제 진입/출구 방향을 명시한다.
- 클리어 성공은 `_get_reachability()`가 안전 도착점을 실제 연결로 방문하고 잘못된 목적지에 도달하지 않을 때만 가능하다.
- `_is_solution()`의 회전 상태 하드코딩만으로 성공할 수 없어야 한다.
- 보드가 시각적으로 끊겨 있으면 성공 판정도 끊겨 있어야 한다.
- 연결된 레일과 끊긴 끝점은 색상 외 형태/표시로도 구분 가능해야 한다.

## Scope

포함:

- endpoint 방향 모델
- 실제 연결성 기반 성공 판정
- 최종 4×4 도착 연결 수정
- 튜토리얼/최종 보드 회귀 테스트
- 끊긴 끝점 피드백 강화

제외:

- 미니게임 전체 규칙 재설계
- 보드 크기 변경
- 난이도/조작 횟수 기준 변경
- 아트 에셋 생성 또는 교체

## Evidence

- 2026-08-10 Windows Human QA에서 사용자가 최종 노선 보드의 도착 지점에 연결이 자연스럽지 않다고 보고했다.
- 현재 코드에서 final safe 위치는 `(3,0)`이지만 safe endpoint 연결은 항상 `SOUTH`로 고정돼 있다.
- 현재 `_is_solution()`은 특정 state/orientation 조합을 직접 비교해 실제 endpoint 연결성과 별도로 성공 조건을 만족시킬 수 있다.

## Implementation gate

Persistent `.gd` 저작은 프로젝트 계약에 따라 HiGodot을 사용한다. 구현은 실패 재현 테스트를 먼저 추가한 뒤 최소 수정으로 진행한다.
