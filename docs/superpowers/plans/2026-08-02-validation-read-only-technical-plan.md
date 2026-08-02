# Validation 최신 main 읽기 전용 기술 계획

> 상태: `READY_FOR_READ_ONLY_EXECUTION`
> Decision: `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> 제품 변경 권한: `NONE`
> 산출물: `CHANGE_PROPOSAL`만 허용

## 목표

승인된 Validation Target을 최신 `main`의 실제 파일·함수·저장·Scene 계약과 대조해, 기존 구현 계획의 잘못된 전제를 제거하고 최소 격리 구현안을 제안한다.

이 계획은 GDScript·Scene·JSON·Save Schema·에셋을 수정하지 않는다.

## 이미 확인된 정정

1. `scripts/core/game_bootstrap.gd`는 최신 `main`에 존재하지 않는다.
2. 시작·이어하기는 `scripts/ui/main_menu.gd`가 직접 소유한다.
3. Legacy 저장 경로와 버전은 `GameState.SAVE_FILE_PATH = user://urban_legend_save.json`, `SAVE_VERSION = mvp-039`다.
4. `result_scene.gd::_ready()`는 진입 즉시 `GameState.record_current_case_report()`를 호출한다.
5. `battle_scene.gd`는 가설·증거·응답 단계와 회수 수치 상태를 이미 소유한다.
6. `investigation_scene.gd`는 기록 Drawer, 텍스트 조사, 가설/회수 진입 책임의 상당 부분을 이미 소유한다.

구형 계획의 `ValidationFlowState`가 이 도메인 상태를 전부 다시 소유하는 안은 그대로 채택하지 않는다.

## 읽기 순서

### A. 시작·저장·복귀

- `project.godot`
- `scripts/ui/main_menu.gd`
- `scripts/core/game_state.gd`
- `scripts/scenes/result_scene.gd`
- `tests/afterlife_main_menu_flow_test.gd`
- 저장·이어하기 관련 테스트 전체

확인:

- Autoload와 Scene 시작점
- `save_game`, `load_game`, `clear_save_file`, `has_save_file`
- 저장 payload 생성·복원·마이그레이션 함수
- `current_scene_path` fallback
- report/reward/manual 기록 시점
- Scene 재진입의 idempotency

### B. 조사·전문 절차

- `scripts/scenes/dialogue_scene.gd`
- `scripts/scenes/preparation_scene.gd`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/minigame_scene.gd`
- `scripts/minigames/route_restore_game.gd`
- `scripts/scenes/battle_scene.gd`
- 관련 `.tscn`
- 관련 smoke/pipeline tests

확인:

- 현재 SCREEN/SIT에 재사용 가능한 책임
- 조사 노드·선택·기록·가설·시간순·노선·회수 상태의 실제 소유자
- 전문 절차 진입·복귀 지점
- 소프트락·재시도·철수 경로
- 숨긴 기능의 난수·로그·상태 부작용

### C. 데이터·정본

- `scripts/data/episode_loader.gd`
- `scripts/data/case_data.gd`
- `data/episodes/episode_001_afterlife_station.json`
- 저승역 관련 UI catalog·manual catalog
- 사건 데이터 검증 테스트

확인:

- 기존 ID·필드·조건·결과
- 시간순 증거와 회수 패턴을 표현할 수 있는 현재 Schema
- 런타임 override와 JSON의 중복 권위
- 신규 필드가 필요한지, 기존 필드 조합으로 가능한지

### D. ANNUAL·Legacy 회귀

- ANNUAL-MVP-001/002 state·save·router·tests
- `docs/CURRENT_STATUS.md`
- `docs/CURRENT_HANDOFF.md`
- `TEST_CHECKLIST.md`
- `.github/workflows/validate-core-mvp-001.yml`
- `.github/workflows/validate-annual-mvp-001.yml`

확인:

- Validation 경로가 ANNUAL state를 초기화·진행·보상하지 않는가
- 본편 `mvp-039`와 ANNUAL save가 보존되는가
- 기존 CORE/ANNUAL 테스트가 회귀 기준으로 충분한가

## 필수 인벤토리 표

각 상태에 대해 다음 표를 작성한다.

| 상태/효과 | 현재 소유자 | 저장 위치 | 적용 시점 | 재적용 위험 | Validation 권장 소유자 |
|---|---|---|---|---|---|
| 현재 Scene |  |  |  |  |  |
| SIT/전문 절차 단계 |  |  |  |  |  |
| 준비 Snapshot |  |  |  |  |  |
| 가설·증거 관계 |  |  |  |  |  |
| 노선 결과 |  |  |  |  |  |
| 회수 분류·행동 |  |  |  |  |  |
| 피해·위험 사례 |  |  |  |  |  |
| 결과 원시 4축 |  |  |  |  |  |
| 보고서·매뉴얼 |  |  |  |  |  |
| 연구·보급 후보 |  |  |  |  |  |

## 기존 구현 계획 대조

`docs/superpowers/plans/2026-08-01-validation-screen-sit-implementation-plan.md`의 각 Package/Task를 다음으로 분류한다.

```text
KEEP
CHANGE_SIGNATURE
CHANGE_OWNER
SPLIT
MERGE_WITH_EXISTING
REMOVE_STALE
ADD_MISSING
BLOCKED_UNVERIFIED
```

최소 필수 정정:

- bootstrap 관련 단계 제거
- `GameState` 변경을 첫 Task로 두지 않음
- 별도 저장소 도입 전에 save payload·migration·main menu UX 계약 확정
- result report/reward의 idempotency test 선행
- battle 도메인 상태와 flow navigation 상태 분리
- 숨긴 Legacy 기능 무부작용 test 추가
- 기존 `mvp-039`, `mvp-038`, ANNUAL save fixture 회귀 추가

## 아키텍처 대안

최소 3안을 비교한다.

### A안 — GameState 내 Validation 하위 Dictionary

- 장점: 기존 Autoload·Scene 접근 재사용
- 위험: Legacy save/reset/상태 소유권 오염
- 기본 판정: `HOLD` unless 매우 작은 adapter로 제한 가능

### B안 — 별도 ValidationSession Autoload + 별도 저장소

- 장점: 저장·flow·idempotency 격리
- 위험: Autoload·Scene 전환·테스트 범위 증가
- 기본 판정: 유력 후보

### C안 — Scene-local specialist state + 얇은 ValidationRouter

- 장점: 기존 조사·회수 도메인 소유권 재사용
- 위험: 복귀·저장 Snapshot이 여러 Scene에 분산
- 기본 판정: B안과 혼합 검토

권장안은 `B의 저장/flow 격리 + C의 기존 도메인 상태 재사용`을 우선 검토한다. 단, 실제 함수·테스트 확인 전 확정하지 않는다.

## Idempotency 계약

다음 효과는 안정 ID를 가져야 한다.

- 피해 적용
- 위험 사례 기록
- 보고서 생성
- 매뉴얼 갱신
- 결과 축 확정
- 보상 지급
- 연구 후보 생성
- 보급 후보 생성

필수 함수 계약 예시:

```text
apply_once(effect_id, payload) -> APPLIED | ALREADY_APPLIED | REJECTED
```

로드·Scene 재진입·뒤로가기·재시도에서 같은 `effect_id`가 두 번 적용되지 않아야 한다.

## 테스트 제안

### RED 우선

1. Legacy save가 있는 상태에서 Validation 새 기록 생성 시 Legacy 파일 불변
2. Validation 저장 손상 시 Legacy 저장 불변
3. 결과 Scene 두 번 진입 시 보고서·보상·매뉴얼 1회
4. 전문 절차 저장 후 복귀 시 `return_target` 정확
5. 회수 첫 오대응 1회 복구, 두 번째 실패 결과 진행
6. 숨긴 랜덤·의뢰·시장·일상 기능의 상태 diff 0
7. Validation 종료 후 SCREEN-01 메인 복귀
8. 본편/ANNUAL/Validation 이어하기 항목 구분
9. 1280×720 키보드 포커스·Esc·Drawer 복귀
10. 기존 CORE/ANNUAL 전체 회귀

## CHANGE_PROPOSAL 형식

```markdown
# Validation CHANGE_PROPOSAL

## 확인한 main HEAD
## 실제 파일·함수·저장 인벤토리
## 구형 계획 KEEP/CHANGE/REMOVE 표
## 권장 아키텍처와 기각 대안
## 변경 파일 목록
## Save·Scene·ID·Schema 영향
## RED/GREEN 테스트 순서
## 롤백 경계
## 미검증·사람 Gate
## 구현 승인 요청 사항
```

## 종료 조건

다음을 모두 만족해야 읽기 전용 계획 완료로 판정한다.

- baseline 경로 존재 여부 전수 확인
- 핵심 함수 signature 확인
- 상태·효과 소유권 표 작성
- save migration과 idempotency 계약 작성
- 기존 계획 분류 완료
- 최소 구현안과 롤백 작성
- 제품 파일 diff 0
- `CHANGE_PROPOSAL`만 생성

그 뒤에도 Codex Build는 자동 승인되지 않는다.
