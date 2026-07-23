# Current Codex Handoff

> 문서 위치: `docs/CURRENT_HANDOFF.md` | 상태 원본: `docs/CURRENT_STATUS.md` | 코어: `docs/PROJECT_CORE.md`

이 문서는 계정·채팅·담당자 교대 시 읽는 짧은 상태다. 실제 완료 여부는 현재 브랜치·대상 PR·테스트 결과와 함께 확인한다.

```yaml
status: ACTION_REQUIRED
implemented_baseline: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039
project_core: CORE_RECORDED
core_review: CORE_STRESS_TESTED
implementation_state: IMPLEMENTATION_IN_PROGRESS
automated_verification: PENDING_ACTIONS_REENABLEMENT
poc_build_ready: NOT_DECLARED
poc_passed: NOT_DECLARED
tracking_issue:
  number: 56
  scope: CORE-MVP-001 독립 PoC
implementation_pr:
  number: 57
  state: draft
  branch: agent/core-mvp-001-poc-20260724
ci_gate:
  variable: CI_ENABLED
  active_when: "true"
  current_behavior: jobs skipped without runner allocation
remaining_required:
  - Python 데이터·정적 계약
  - Godot 4.7.1 import
  - 집중 테스트 4/4
  - 전체 Godot 회귀 43/43
  - 1280x720·1920x1080 UI·접근성 확인
  - 보호 경로 diff 재확인
current_protagonist: 권나래
active_track:
  - CORE-MVP-001 자동 검증과 정적 마감
queued_tracks:
  - CORE-MVP-002 포획·연구·영구 지식
  - CORE-MVP-003 기간제 챕터·부상·세력 의뢰
  - CORE-MVP-004 히든 분기·가치관 엔딩
deferred_for_remap:
  - UX-PD-001 2B·2C
  - MVP-044
  - MVP-045
  - MVP-046
next_action_when_actions_available:
  - CI_ENABLED=true 설정 또는 비용 게이트 제거
  - main/nightly full matrix workflow 추가
  - PR #57 Python·Godot 검증 실행
  - 최초 실패부터 수정
  - POC_BUILD_READY 판정
```

## 필수 읽기

```text
AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md
→ docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md
→ docs/CI_COST_OPTIMIZATION_AND_REENABLEMENT.md
→ Issue #56
→ Draft PR #57
→ 실제 PoC 코드·데이터·테스트
```

## 현재 구현 사실

- 독립 PoC 데이터·로더·상태 머신·JSONL 로그·단일 장면이 PR #57에 작성돼 있다.
- F1 개발 패널에서 `CORE-MVP-001 조사→전조→포획 PoC`로 진입한다.
- 조사 4지선다에서 매뉴얼 근거로 2개를 배제한다.
- 남은 가설에 지지·반박·미해결 근거를 연결하고 무관 근거는 거부한다.
- 현장 검증 실패는 반응 단서·피해·위험·누적 위험 사례를 남긴다.
- 현장 검증 성공은 핵심 질문을 해소하고 이해도를 `understood`로 승격한다.
- 회수는 고정 패턴·전조 해석·범용 대응·포획 표식으로 진행한다.
- 미관측 패턴 첫 발동은 정보 비공개, 범용 대응, 피해 상한 18 계약을 사용한다.
- 결과는 회수 품질·피해 관리·지식 품질을 분리한다.
- 결과 비교 뒤 매뉴얼 반영 검토와 기록 확정을 별도 상태로 처리한다.
- PoC는 기존 `GameState`, 기존 사건 데이터, 기존 조사·회수 장면, 저장 Schema를 사용하지 않는다.

## 검증 증거 경계

확인된 과거 증거:

- 데이터 fixture 부재 Red
- Python 데이터 계약 Green
- Godot 로더 부재 Red
- 집중 run #16에서 로더·로그 PASS
- 상태 테스트의 명시적 정수 타입 문제 확인 및 수정

최신 코드에 대해 실행되지 않은 항목:

- 강화된 고정 ID·참조 계약
- 미해결 질문 해소·매뉴얼 승격 계약
- 단계별 UI·읽기 전용 뒤로보기
- 최신 집중 테스트와 전체 회귀

사용자가 전체 원문 대화, 신규 플레이어 행동 증거, 사전 지표를 진행 차단 조건에서 제외했다. 이 항목들을 다시 필수 게이트로 추가하지 않는다. 다만 플레이 증거 없이 `POC_PASSED`는 선언하지 않는다.

## 보호할 기술 계약

- 권나래 고정 주인공
- 저장 `mvp-039`, `mvp-038` 이관
- 기존 사건·선택·보고서·DB ID
- `scripts/core/game_state.gd`, 기존 `data/episodes/**`, `project.godot`, `knowledge/base-pack/**`
- 기존 `scripts/scenes/investigation_scene.gd`, `scripts/scenes/battle_scene.gd`
- 기록관 아카는 정보를 정리하지만 정답을 대신하지 않음
- UI는 상태를 표현하며 기존 캠페인 진행을 소유하지 않음

## 구현 금지선

- Actions 검증 전 `POC_BUILD_READY`, `READY_FOR_MERGE` 선언
- 플레이 증거 없이 `POC_PASSED` 선언
- CORE-MVP-001 검증 전 CORE-MVP-002·지원 시스템 확장
- 시장·세력·연구 트리·복수 챕터·대규모 서사 확장
- 핵심 단서·정답의 확률화
- 거짓 전조 예측
- 미관측 패턴의 즉사·강제 중상·소프트락·영구 분기 실패
- 기존 저장·사건·조사·회수 경로 직접 개조

## 검증 뒤 갱신

1. `docs/CURRENT_STATUS.md`
2. `docs/CURRENT_HANDOFF.md`
3. `MVP_ROADMAP.md`
4. `TEST_CHECKLIST.md`
5. Issue #56
6. PR #57
7. `docs/CI_COST_OPTIMIZATION_AND_REENABLEMENT.md` - 재활성화 상태가 바뀔 때
