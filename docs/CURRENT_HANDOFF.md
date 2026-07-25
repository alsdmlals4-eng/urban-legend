# Current Codex Handoff

> 문서 위치: `docs/CURRENT_HANDOFF.md`  
> 상태 원본: `docs/CURRENT_STATUS.md`  
> 코어: `docs/PROJECT_CORE.md`  
> 구현 기준: `MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039`

이 문서는 구현·렌더링·입력 이벤트 검증 완료와 사람 사용성·신규 플레이어 검증 미완료를 혼합하지 않도록 하는 짧은 인수인계다.

```yaml
status: ANNUAL_MVP_001_POINTER_QA_PASSED
implemented_baseline: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039
core_mvp_001:
  implementation: POC_BUILD_READY
  automated_verification: PASSED
  focused_suite: 4/4
  player_validation: NOT_RUN
  POC_PASSED: NOT_DECLARED
  main_merge:
    pr: 55
    commit: 8d0bf91a2e31538d3c0f142c800a84e8e3693889
annual_design:
  status: APPROVED_DESIGN_BASELINE
  design_pr: 58
  approval_pr: 59
  plans_pr: 60
canonical_migration:
  status: COMPLETE
  merge_pr: 61
  automated_document_validation: PASSED
annual_mvp_001:
  implementation: BUILD_READY
  implementation_pr: 62
  implementation_commit: 88522ce08f261bce6d61a8043c64caa3b982bd47
  rendered_qa:
    status: PASSED
    merge_pr: 65
    main_commit: b4f2e224bf7a2a6ee511c83bbbd45cd9e0b8570a
    representative_artifact_id: 8617041311
    visual_direction: KEEP_AMPLIFY
  graphical_pointer_qa:
    status: PASSED
    merge_pr: 67
    main_commit: 0f24efa204a04cca62a58e55628e6b831b9bef2d
    visual_run: 28
    annual_validation_run: 94
    keyboard_input: PASSED
    pointer_event_flow: PASSED
    module_toggle_runtime_bug: FIXED
  focused_suite: 6/6
  full_regression: 49/49
  human_usability_qa: NOT_RUN
  new_player_validation: NOT_RUN
  annual_loop_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 필수 읽기

```text
AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/GAME_DESIGN_DOCUMENT.md
→ docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md
→ docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md
→ ANNUAL-MVP-001 코드·데이터·Scene·테스트
→ 기존 CORE-MVP-001 코드·데이터·테스트
```

## 충돌 해석

구현·문서·레거시가 다를 때는 다음 순서를 사용한다.

1. 사용자 승인 최신 연도제 설계
2. 승인된 ANNUAL-MVP 구현 계획
3. `CURRENT_STATUS`·`PROJECT_CORE`·GDD 활성 정본
4. 기존 PoC·레거시 구현

최신 기획이 우선이지만 보호 경로, 기존 저장 비침범, CORE 하위 호환은 깨지 않는다.

## 현재 구현 사실

- ANNUAL-MVP-001은 PR #62에서 `main`에 squash merge됐다.
- 렌더링·현지화·키보드 수정은 PR #65에서 `main`에 squash merge됐다.
- 그래픽 포인터 회귀와 모듈 체크박스 수정은 PR #67에서 `main`에 squash merge됐다.
- 3주 × 주당 3슬롯의 일정 선택이 역량·피로·기관 지원·오현 신뢰에 반영된다.
- 2주차 자율 출동, 3주차 위험 +15 출동, 위험 +30 긴급 출동이 구현됐다.
- 동료 지원은 체력 회복과 위험 완화만 가능하며 정답·가설·이해도·포획 표식을 변경하지 않는다.
- 사건 결과는 잔향 자료·기관 지원·연구·공용 스킬·분기 결산으로 환류한다.
- 분기 결산은 최종 엔딩이 아니라 후속 분기·연도 확장의 중간 결과다.

## 렌더링·입력 검증

검증된 항목:

- 공용 현대 오컬트 Theme과 한글 시스템 글꼴 후보
- embedded CORE 조사 패널 확장과 단계·이해도 현지화
- 초기 키보드 포커스, `ui_accept`, Esc
- 조기·지연·긴급 출동 세 경로
- 실제 버튼 좌표 기반 주간 활동 선택과 확인
- PoC 저장·불러오기
- 출동 결정, 연구, 공용 스킬, 모듈 선택
- embedded 사건 시작과 사건 중 저장 비활성
- embedded 매뉴얼·조사 선택지 좌클릭

포인터 QA에서 `모듈: 신호 완충` 체크박스가 untyped 배열을 `Array[String]`에 대입하던 런타임 오류를 발견했고 typed append 방식으로 수정했다.

최종 검증:

- Visual workflow run #28 PASS
- ANNUAL workflow run #94 PASS
- CORE-MVP-001 focused 4/4 PASS
- ANNUAL-MVP-001 focused 6/6 PASS
- 전체 Godot 회귀 49/49 PASS

시각 판정은 `KEEP / AMPLIFY`다. 기본 가독성과 경로 차이는 유지하고, 넓은 여백과 개발용 HUD는 최종 텍스트 노벨 화면에서 강화한다.

## 보호할 계약

- 권나래 고정 주인공
- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `project.godot`
- `knowledge/base-pack/**`
- 기존 저장 `mvp-039`, `mvp-038` 이관
- 기존 CORE-MVP-001 기본 F1 진입과 4/4 회귀
- 괴이 기록국·기록관 아카·동료가 정답을 대신하지 않는 규칙

## 아직 완료로 선언하지 않는 것

- 사람 손으로 장시간 수행하는 마우스·키보드 사용성 평가
- 신규 플레이어가 육성 선택과 사건 차이를 설명하는 증거
- 동료 자동 지원이 공정하다는 플레이어 설명
- 주간 일정 반복 피로도 판정
- `POC_PASSED`
- `annual loop passed`
- ANNUAL-MVP-002 진입
- 제작 확대

## 다음 작업

1. 사람 손 장시간 사용성 평가
2. 신규 플레이어 세 경로 플레이
3. 육성→사건→연구 인과와 지원 공정성 설명 수집
4. 전체 루프를 `KEEP / AMPLIFY / CHANGE / RETEST / HOLD`로 판정
5. 별도 사용자 승인 전 ANNUAL-MVP-002를 시작하지 않음
