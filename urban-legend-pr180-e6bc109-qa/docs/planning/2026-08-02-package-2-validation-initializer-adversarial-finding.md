# Package 2 Validation 초기화 경로 적대적 Finding

> Finding ID: `P2-011-VALIDATION-INITIALIZER-LEGACY-RESET`
> 상태: `MUST_FIX / DESIGN_INPUT`
> 연관 Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
> 구현 권한: `NOT_AUTHORIZED`

## 발견

현재 메인 메뉴의 새 캠페인 경로는 다음을 호출한다.

```text
GameState.clear_save_file()
→ GameState.restart_afterlife_station_flow(...)
```

`restart_afterlife_station_flow()`는 내부에서 `reset_run_state()`를 호출한다. `reset_run_state()`는 Validation whitelist 런타임 필드뿐 아니라 다음 숨은 Legacy 상태도 초기화한다.

- campaign state
- agent trust와 event 기록
- unlocked records/equipment/research
- completed reports/manual records
- daily episode records
- echo fragments와 rewards
- faction relations/requests
- market purchases
- consumable inventory/loadout/effects

따라서 Validation 시작에서 이 함수를 그대로 재사용하면 Package 1의 `FILE_AND_MEMORY_NO_EFFECT` 계약을 위반한다.

## 판정

```yaml
reuse_restart_afterlife_station_flow_for_validation: FORBIDDEN
reuse_reset_run_state_for_validation: FORBIDDEN
```

## Design 보정

`validation_game_state.gd` 또는 별도 좁은 adapter에 Validation 전용 초기화 API를 둔다.

권장 책임:

```text
initialize_validation_runtime(episode_id, agent_ids)
```

허용 변경은 Package 1 whitelist에 포함된 런타임 필드뿐이다.

- episode/path
- scene/dialogue/field/minigame 위치
- selected agents
- flags/clues/hints
- method/minigame 결과
- resolution/recovery
- agent case state/victim state

금지:

- campaign/economy/relationship/faction/market/reward/report/manual/profile 상태 변경
- Legacy save 파일 삭제·저장
- 기존 Legacy 진행을 초기값으로 덮어쓰기

## 시작 순서 권장

```text
read-only persistence status 확인
→ 기존 Validation 기록 교체가 필요하면 명시적 확인·삭제
→ ValidationSession.create()
→ ValidationSession.activate(token)
→ hidden Legacy guard capture
→ initialize_validation_runtime()  # whitelist only
→ ValidationSession.save(GameState)
→ flow-stage allowlist mapper
→ 허용 Scene 이동
```

초기화·저장·라우팅 중 하나라도 실패하면 메인 메뉴에 남고 Legacy 저장을 건드리지 않는다.

## 검증 요구

- 초기화 전후 hidden Legacy snapshot semantic equality
- Legacy save bytes equality
- Validation runtime whitelist의 기대 초기값
- 실패 단계별 메인 잔류와 single-flight 해제
- 기존 Legacy 새 캠페인 경로의 회귀 보존

## 현재 상태

```yaml
planning_finding: COMPLETE
implementation: NOT_AUTHORIZED
runtime: NOT_RUN
human_qa: NOT_RUN
```
