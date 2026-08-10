# Route Restore Endpoint Connectivity Design

Decision: `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY`

## Goal

저승역 노선 복원에서 플레이어가 화면으로 본 철로 연결과 실제 성공 판정이 항상 일치하게 한다.

## Current defect

현재 final 4×4 board는:

- start `(0,3)`
- safe `(3,0)`
- false `(3,3)`

인데 `safe` 연결은 모든 보드에서 `[SOUTH]`로 고정돼 있다. final safe는 `(2,0)`에서 서쪽→동쪽으로 진입해야 하므로 endpoint 방향과 보드 구조가 맞지 않는다.

또한 `_confirm_route()`가 `_is_solution()`의 하드코딩 state/orientation 조합도 성공으로 인정하므로 실제 reachability와 별개로 통과할 수 있다.

## Architecture

### Endpoint orientation

endpoint tile dictionary가 `connections` 또는 명시적 orientation을 소유한다.

- tutorial safe: SOUTH
- final safe: WEST
- false endpoint도 각 보드의 실제 진입 방향을 명시
- start endpoint도 board definition에서 출구를 명시

`_connections_for()`는 endpoint 종류에 대해 보드에 저장된 방향을 읽는다.

### Single success authority

`_confirm_route()` 성공 조건은 reachability 결과만 사용한다.

성공:

- safe reachable = true
- false reachable = false

실패:

- false reachable = true → 위험 사례
- 둘 다 false → 끊긴 구간

`_is_solution()`은 제품 성공 판정에서 제거한다. 필요한 경우 테스트 fixture의 예상 조작 상태 검증에만 남긴다.

### Visual feedback

- 출발점에서 실제로 연결된 rail은 기존 gold 유지.
- 연결되지 않은 endpoint/rail end는 작은 끝점 마커 또는 단절 표시를 추가한다.
- 색상 외 형태 차이로 연결/단절을 구별한다.
- 정답을 미리 노출하는 자동 경로 하이라이트는 추가하지 않는다.

## Data flow

board build → endpoint directions stored in tile dictionaries → `_connections_for()` → `_get_reachability()` / `_reachable_indices()` → draw + confirm 판정.

시각 표시와 성공 판정이 같은 `_connections_for()` 결과를 소비하므로 두 표현이 다시 분리되지 않게 한다.

## Testing

RED부터 다음을 검증한다.

1. final safe endpoint가 WEST 연결을 가진다.
2. tutorial safe endpoint는 기존 SOUTH 연결을 유지한다.
3. 하드코딩 orientation 조합이어도 실제 endpoint가 끊겨 있으면 성공하지 않는다.
4. 실제 start→safe 연결이 완성되면 성공한다.
5. false endpoint에 연결되면 성공하지 않고 danger path가 실행된다.
6. `_reachable_indices()`와 `_get_reachability()`가 동일 연결 규칙을 소비한다.
7. endpoint 단절 표시가 색상 외 cue를 가진다.

## Regression boundaries

- 3×3 tutorial → 4×4 final 전환 유지
- route lock/wobble 유지
- move count, grade threshold 유지
- 결과 payload와 clue 의미 유지
- 신규 이미지 에셋 없음
