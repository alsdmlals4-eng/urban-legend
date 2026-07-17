# MVP-044~046 Repository Audit

## Follow-up correction (2026-07-17)

- The current branch was rechecked from `a56ceeb` with an isolated save directory. All 42 automated Godot contracts, project loading, and the target scene smoke checks completed with exit code 0.
- Fixed a real relationship-record save loss: an unresolved relationship scene now keeps its existing saved payload and returns to the relationship route after reload. Completion still clears the active payload and cannot create a duplicate record.
- Restored the missing player-visible relationship tags from final memory outcomes. They are display-only, use no score or gameplay modifier, and are shown alongside compact per-chain progress in the records DB.
- Fixed the direct daily-episode scene smoke path so it defers its fallback scene change instead of changing parents while Godot is attaching the scene.
- The remaining `ObjectDB` shutdown warning occurs only when directly opening an empty daily-episode scene in headless mode; no gameplay test fails, but interactive 1280×720 and 1920×1080 capture remains pending.

## Current implementation update (2026-07-16)

- Current working baseline is `codex/mvp044-046-integration` at `4e6b5c4`, which is also pushed as `origin/codex/mvp044-046-integration`. `origin/main` remains intentionally behind pending final regression.
- `data/narrative_events.json` parses with the bundled Python and Node runtimes: all 25 optional entries (7 AFTER / 9 DAILY / 9 FACTION) now expose the three approved choices and retain their existing event IDs and unlock conditions. This is source-contract verification, not a claim that every entry has completed an interactive real-scene playthrough.
- User-owned Godot import metadata and `tests/ui_visual_capture.gd` are dirty local capture artifacts. They are preserved by the workflow allowlist and excluded from integration commits.
- Save version is now `mvp-047`. Existing `mvp-045` and `mvp-046` saves load missing research and contract fields with safe defaults; completed case, daily, relationship, campaign and equipment records remain untouched.
- MVP-044 source restoration and its 25-entry unlock→choice→completed-record automated flow are verified. MVP-045 now verifies the actual ordered unlock and completion path for all 12 chains / 30 scenes, and the relationship scene supplies participant, location, and context text to the playable screen. MVP-046 now routes dialogue expression IDs through the registry and shows transient relationship cut-ins without owning progress or save state.
- MVP-047 is partially implemented: the HQ research half-day yields a fixed 1–3 point result shown before execution; 3/3/5-point projects unlock existing equipment or consumable crafting for 35/25 fragments; and the researched Raymond Kane contract charges 35 fragments only when its one-event deployment begins. Save/reload cannot reroll research or recharge the contract.
- Visual capture and full interactive Day 8/10 verification remain pending and are not represented as complete. The headless relationship capture attempt did not return after scene rendering, so no capture result is claimed; user-owned capture files were not changed.

> 문서 위치: `docs/audits/MVP044_046_REPOSITORY_AUDIT.md` | 실행 계획: `docs/planning/MVP044_046_EXECUTION_PLAN.md` | [백업]: `docs/archive/backup/YYYY-MM-DD/`
>
> 외부 참조 위치: `C:\Users\user\Downloads\보낼거\MVP-044-046_Codex_PlanMode_Handoff_Package_v1.0.zip` | 원본 ZIP은 이동·삭제하지 않음

## 기준선

| 항목 | 확인 결과 |
|---|---|
| 기준 브랜치 | `codex/mvp044-046-integration` |
| 기준 SHA | `bfc1146` (MVP-044 approved-source restoration complete; full interactive regression remains pending) |
| 원격 기준 | `origin/codex/mvp044-046-integration`도 같은 SHA; `origin/main`은 `dd3c9a8` |
| 저장 | `mvp-039`, `mvp-038` 이관 지원 |
| 구현 기준선 | MVP-043 / Ver 4.1 |
| 현재 작업 상태 | MVP-044~046 진행 중 |

## 현재 구현과 미구현

### 구현 확인

- 저승역·빨간 우산·폐주파수의 조사, 미니게임, 안정화, 결과, 보고서, DB 연결
- 권나래 고정 주인공, 서포트 최대 2명, 초기 요원 5명
- 저승역 3×3 학습과 4×4 최종 검증, 위험 사례와 저장 경계
- 선택형 일상 3편, 반복 세력 의뢰 9건, 캐릭터 production 자산 28종

### 미구현

- MVP-044의 AFTER 7편·DAILY 9편·FACTION 9편과 세 사건 승인 대사 연결
- MVP-045의 선택 기억, 관계 태그, 12체인·30장면, 관계 저장 이관
- MVP-046의 공용 대화 스테이지, 의미 표정, 컷인 6종, 접근성 연출 설정

## 상태 소유권과 보호 범위

| 소유자 | 책임 |
|---|---|
| `GameState` | 저장, 캠페인, 완료 기록, 관계 기억, 이관 |
| 데이터 카탈로그 | 사건·서사 문장, 선택지, 해금 조건, 기록 요약 |
| 씬·UI | 표시와 입력, 상태 변경 요청 |
| 결과·DB | 완료 스냅샷 열람 |
| presentation | 현재 줄에서 재구성하는 일시 연출 상태 |

보호 경로는 `scripts/core/game_state.gd`, `data/episodes/*`, `project.godot`, `knowledge/base-pack/*`다. 기존 episode/clue/minigame/report ID, `selected_agent_ids`, `used_agent_supports`, `agent_trust`, 현재 일상 완료 기록은 유지한다.

## 위임 실행기 복구

저장소에는 `scripts/game-workflow.ps1`와 동반 모듈이 없었지만, 검증된 원본은 다음 위치에 존재했다.

| 대상 | 원본 SHA-256 |
|---|---|
| `scripts/game-workflow.ps1` | `19B2636D7E064311F3AD98FBF19F4555B62C55738B6EF4ABBC048FD0DB622B8C` |
| `scripts/GameWorkflow.psm1` | `B2289D4188FA226F5599DA5E9FCC58C11AF5D20D6E1A784EFBFC55ABCCCA09FC` |
| `scripts/run-opencode-worker.ps1` | `F2A453E62B37D365576D304BC88C260D84397EC47DECEF22233CCC0469AA2A6F` |

원본 위치: `C:\Users\user\.codex\skills\deepseek-game-workflow\scripts\`. 이 프로젝트 사본은 계정·프로필 전환 뒤에도 같은 계약으로 실행할 수 있게 유지한다.

## 감사 시점 검증

- Godot 4.7 headless 프로젝트 로드: 통과
- MVP-043 주인공·서포트: 통과
- MVP-042 일상: 28/28 통과
- MVP-038 캠페인: 52/52 통과 (`.tscn` 실행)
- 일상 UI: 통과
- GDD `--check`, `git diff --check`: 통과
- 기존 워크플로 문서 계약: 실행기 부재·노후 기대값으로 실패했고, 이 작업의 첫 단계에서 수정함

## 사용 규칙

DeepSeek는 실행기 검증 후 R0 읽기 감사와 비보호 단위에만 사용한다. 보호 경로, 저장 이관, 최종 통합·검증·커밋은 Codex가 담당한다. Base 승격 후보는 없다.
