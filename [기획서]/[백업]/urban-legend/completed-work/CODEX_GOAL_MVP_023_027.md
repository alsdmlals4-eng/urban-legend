# Codex Goal - MVP-023~027

## 기준

- Issue: #30 `[MVP-023~027] 보고서·DB·요원·장비·회수·저장 통합 정리`
- 기준 문서: `MVP_ROADMAP.md`, `docs/MVP_STATUS_AUDIT.md`, `TEST_CHECKLIST.md`
- 플랫폼 목표: PC 기준 Steam 출시

## 작업 전 확인

먼저 GitHub Base 원본 규칙을 확인한다.

- `alsdmlals4-eng/Base/docs/MVP_WORKFLOW_CHECKLIST.md`
- `alsdmlals4-eng/Base/docs/AI_WORKFLOW_RULES.md`
- `alsdmlals4-eng/Base/docs/BENCHMARKING_REFERENCE_GUIDE.md`

그다음 `docs/DOCUMENTATION_MAP.md`의 읽기 순서를 따른 뒤, Issue #30과 아래 파일을 확인한다.

- `scripts/ui/database_view.gd`
- `scripts/scenes/result_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `scripts/scenes/preparation_scene.gd`
- `scripts/core/game_state.gd`
- 관련 `.tscn` 파일
- `README.md`
- `TEST_CHECKLIST.md`

## 벤치마킹 반영 기준

Issue #30, `MVP_ROADMAP.md`, `docs/MVP_STATUS_AUDIT.md`의 벤치마킹 결론을 확인하고 Goal에는 실행에 필요한 만큼만 반영한다.

- Unity Asset Store: 기능별 패키징, 카드형 정보 구조, 상점형 요약 방식을 참고한다.
- Tales of Tuscany Demo: 데모 첫인상, 기능 목록, 강한 상호작용 소개 방식을 참고한다.

## 작업

Issue #30을 기준으로 MVP-023~027을 통합 정리한다.

1. `database_view.gd`와 `result_scene.gd`에서 사건 보고서/DB 상세를 섹션 단위로 정리한다.
2. 저승역과 빨간 우산 완료 보고서가 명확히 구분되게 한다.
3. 요원 신뢰도/요원 이벤트는 수사 파트너 신뢰와 사건 기여 관점으로 표시한다.
4. 장비/기록물은 획득처, 활용처, 다음 조사 연결성을 읽히게 한다.
5. `battle_scene.gd`는 전투보다 괴이 안정화/회수 페이즈로 읽히게 섹션과 문구를 정리한다.
6. `game_state.gd` 저장/불러오기 흐름에서 완료 보고서, 요원 신뢰도, 장비/기록물, 회수 결과, 현재 씬 경로 유지 여부를 점검한다.
7. 기존 저승역/빨간 우산 전체 흐름을 보존한다.
8. `TEST_CHECKLIST.md` 또는 `README.md`에 통합 확인 항목을 반영한다.

## 제한

- 세 번째 괴담, 새 미니게임, 새 장기 요원 루트, 대형 UI 프레임워크, 대규모 저장 마이그레이션을 추가하지 않는다.
- 복잡한 검색/필터/정렬 시스템은 이번 범위에 넣지 않는다.
- 모바일 세로 최적화를 이번 기준으로 삼지 않는다.
- Issue와 규칙 문서에 있는 내용을 Goal에 장문 반복하지 않는다.

## 완료 기준

- 사건 보고서와 기록국 DB 상세가 섹션 단위로 읽힌다.
- 요원/장비/기록물/회수/저장 상태가 다음 행동과 연결되어 보인다.
- 회수 페이즈가 전투보다 안정화/회수 UI로 읽힌다.
- 저장/이어하기 후 완료 보고서, 요원 신뢰도, 장비/기록물, 회수 결과가 유지된다.
- PC 16:9 기준의 정보 위계가 확인된다.
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

## 유지한 흐름
-

## 저장/이어하기 확인
-

## 검증 내용
-

## 남은 위험
-
```
