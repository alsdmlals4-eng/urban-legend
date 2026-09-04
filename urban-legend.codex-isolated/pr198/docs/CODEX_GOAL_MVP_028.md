# Codex Goal - MVP-028

## 기준

- Issue: #31 `[MVP-028] PC/Steam UX·텍스트 노벨형 조사·팀 기반 회수 UI 정리`
- 기준 문서: `MVP_ROADMAP.md`, `docs/MVP_STATUS_AUDIT.md`, `TEST_CHECKLIST.md`
- 플랫폼 목표: PC 기준 Steam 출시

## 작업 전 확인

먼저 GitHub Base 원본 규칙을 확인한다.

- `alsdmlals4-eng/Base/docs/MVP_WORKFLOW_CHECKLIST.md`
- `alsdmlals4-eng/Base/docs/AI_WORKFLOW_RULES.md`
- `alsdmlals4-eng/Base/docs/BENCHMARKING_REFERENCE_GUIDE.md`

그다음 `docs/DOCUMENTATION_MAP.md`의 읽기 순서를 따른 뒤, Issue #31과 아래 파일을 확인한다.

- `scripts/scenes/dialogue_scene.gd`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `scripts/scenes/preparation_scene.gd`
- `scripts/core/game_state.gd`
- 관련 `.tscn` 파일
- `README.md`
- `TEST_CHECKLIST.md`

## 벤치마킹 반영 기준

Issue #31, `MVP_ROADMAP.md`, `docs/MVP_STATUS_AUDIT.md`의 벤치마킹 결론을 확인하고 Goal에는 실행에 필요한 만큼만 반영한다.

- 대화 화면: 인물/현장 몰입, 하단 대사창, 주변부 보조 UI 구조를 참고한다.
- 조사 화면: 텍스트 노벨형 상황 설명, 선택지, 결과 텍스트, 단서/상태 변화 흐름을 참고한다.
- 회수 화면: 전투 UI의 동료 지원 감각을 재해석해 좌상단은 아군 요원, 우상단은 해결 단서/회수 근거로 둔다.

## 작업

Issue #31을 기준으로 PC/Steam 기준 UX 패스를 진행한다.

1. 대화/조사/회수 화면의 PC 16:9 정보 위계를 점검하고 필요한 최소 UI 문구/배치 정리를 수행한다.
2. 조사 페이즈가 텍스트 노벨형 선택 진행으로 읽히게 한다.
3. 별도 주인공 없이 요원 팀이 함께 움직인다는 표현을 대화/조사/회수 UI에 반영한다.
4. 회수 페이즈 좌상단은 아군 요원 패널, 우상단은 해결 단서/회수 근거 패널로 읽히게 정리한다.
5. 대표 요원 교체 개념을 UI/문서/최소 구현 중 하나 이상에 반영한다.
6. 기존 저승역/빨간 우산 전체 흐름을 보존한다.
7. `TEST_CHECKLIST.md` 또는 `README.md`에 MVP-028 확인 항목을 반영한다.

## 제한

- 새 괴담, 새 미니게임, 신규 캐릭터 대량 추가, 대형 아트/애니메이션, 복잡한 파티 전투 시스템을 추가하지 않는다.
- 모바일 세로 최적화와 Steam 상점 페이지 실제 제작은 이번 범위에 넣지 않는다.
- 전체 UI 프레임워크를 교체하지 않는다.
- Issue와 규칙 문서에 있는 내용을 Goal에 장문 반복하지 않는다.

## 완료 기준

- 조사 화면이 텍스트 노벨형 선택 진행으로 읽힌다.
- 대화/조사/회수 화면의 정보 위계가 PC 16:9 기준으로 구분된다.
- 별도 주인공 없이 요원 팀이 함께 움직인다는 표현이 반영된다.
- 회수 화면 좌상단은 아군 요원, 우상단은 해결 단서/회수 근거로 읽힌다.
- 대표 요원 교체 개념이 반영된다.
- 기존 저승역/빨간 우산 흐름이 깨지지 않는다.
- Godot headless 또는 수동 확인 결과를 보고한다.

## 보고 형식

```md
## 변경 파일
-

## 벤치마킹 반영
-

## 구현 내용
-

## 팀 기반 표현
-

## 대표 요원/단서 UI
-

## 유지한 흐름
-

## 검증 내용
-

## 남은 위험
-
```
