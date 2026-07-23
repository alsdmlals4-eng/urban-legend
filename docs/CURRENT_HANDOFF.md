# Current Codex Handoff

> 문서 위치: `docs/CURRENT_HANDOFF.md` | 상태 원본: `docs/CURRENT_STATUS.md` | 코어: `docs/PROJECT_CORE.md`

이 문서는 계정·채팅·담당자 교대 시 읽는 짧은 상태다. 실제 완료 여부는 현재 브랜치·대상 PR·`main`·테스트와 함께 확인한다.

```yaml
status: UNVERIFIED
implemented_baseline: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039
project_core: CORE_RECORDED
core_review: CORE_STRESS_TESTED
implementation_state: POC_PENDING
production_gate: HOLD_UNTIL_PLAYER_EVIDENCE
tracking_issue:
  number: 56
  scope: CORE-MVP-001 독립 PoC
pr_review:
  number: 55
  state: draft
  verdict: UNVERIFIED
  automated_validation: REQUIRED_PASS_ON_LATEST_HEAD
unverified:
  - 현재 대화 전체 원문
  - 로컬 clone/worktree와 Godot 4.7 실행
  - 기존 Godot 회귀 39개와 저장·Scene smoke
  - CORE-MVP-001 구현과 신규 플레이어 행동 증거
  - 사용자의 PDF 직접 시각 검수
current_protagonist: 권나래
active_track:
  - CORE-MVP-001 조사·가설 카드·전조 기반 포획 PoC
queued_tracks:
  - CORE-MVP-002 포획·연구·영구 지식
  - CORE-MVP-003 기간제 챕터·부상·세력 의뢰
  - CORE-MVP-004 히든 분기·가치관 엔딩
deferred_for_remap:
  - UX-PD-001 2B·2C
  - MVP-044
  - MVP-045
  - MVP-046
next_action:
  - Issue #56과 통합 명세·CORE-MVP-001 구현 계획을 읽는다
  - 독립 PoC 경로만 TDD로 구현한다
  - Godot 전체 회귀와 저장 비침범을 확인한다
  - 신규 플레이어 행동 증거 전 지원 시스템을 확장하지 않는다
```

## 필수 읽기

```text
AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md
→ docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md
→ MVP_ROADMAP.md
→ docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md
→ TEST_CHECKLIST.md
→ 실제 코드·데이터·테스트
```

완료 QA 보고서는 기본 필수 읽기가 아니다. 과거 감사 근거가 필요할 때 `docs/archive/README.md`와 `docs/qa/`에서 해당 날짜의 증거 하나만 선택한다.

## 현재 핵심 판단

- 현행 구현 완료선은 MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A다.
- 새 코어는 사용자 승인과 문서 스트레스 테스트를 마쳤지만 게임 구현과 플레이테스트는 미완료다.
- 최소 코어는 `단서 비교 → 가설 카드 → 위험 검증 → 이해도 → 전조 해석 → 포획 → 매뉴얼 기록`이다.
- 챕터, 부상, 연구, 의뢰, 히든 분기, 엔딩은 승인된 `CORE_SUPPORT`이며 PoC 전 불변으로 잠그지 않는다.
- 핵심 단서·가설·이해도 승격은 결정론적이고, 확률은 중간 이해도의 전조 정보 해석에만 사용한다.
- 회수 전투는 HP 0 처치가 아니라 패턴 대응으로 포획 창을 여는 구조다.
- CORE-MVP-001은 기존 `game_state.gd`, 세 사건 데이터, 조사·회수 장면과 `mvp-039`를 건드리지 않는 독립 PoC로 계획됐다.
- 최종 적대적 감사는 문서 차단 결함을 수정했으나 원문 전체 대화·Godot·PoC·플레이 증거가 없어 `UNVERIFIED`다.

## 보호할 기술 계약

- 권나래 고정 주인공, 서포트 최대 2인, 권나래 일정만 소비
- 저장 `mvp-039`, `mvp-038` 이관
- 기존 사건·선택·보고서·DB ID
- `scripts/core/game_state.gd`, `data/episodes/**`, `project.godot`, `knowledge/base-pack/**`
- CORE-MVP-001에서 `scripts/scenes/investigation_scene.gd`, `scripts/scenes/battle_scene.gd` 직접 수정 금지
- 기록관 아카는 확보 정보를 정리하지만 정답을 대신하지 않음
- UI·컷인·표정은 상태를 표현하지만 저장·진행을 소유하지 않음

## 구현 금지선

- CORE-MVP-001 전 시장·세력·연구 트리·복수 챕터·대규모 서사 확장
- 자동 최적 요원 선택과 필수 단서 독점
- 거짓 전조 예측
- 미관측 패턴의 즉사·강제 중상·소프트락·영구 분기 실패
- 유사 괴이 자동 분류에 따른 이해도 전이
- 히든 분기를 항상 우월한 정답으로 만드는 보상
- 자동 테스트만으로 `POC_PASSED` 선언
- `UNVERIFIED`를 구현 완료·MVP 완료·병합 승인으로 해석

## 완료 뒤 갱신

1. `docs/CURRENT_STATUS.md`
2. `docs/PROJECT_CORE.md` - 코어 변경이 있을 때만
3. `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md` - 계약이 바뀔 때만
4. `MVP_ROADMAP.md`
5. `TEST_CHECKLIST.md`
6. `docs/planning/ROADMAP_AND_HANDOFF.md`
7. `docs/planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md`
8. 이 handoff
