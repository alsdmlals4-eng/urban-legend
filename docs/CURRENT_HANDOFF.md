# Current Codex Handoff

> 문서 위치: `docs/CURRENT_HANDOFF.md`  
> 상태 원본: `docs/CURRENT_STATUS.md`  
> 코어: `docs/PROJECT_CORE.md`  
> 구현 기준: `MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039`

이 문서는 새 담당자가 구현 완료와 검증 미완료를 혼합하지 않도록 하는 짧은 인수인계다.

```yaml
status: ANNUAL_MVP_001_BUILD_READY
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
  automated_verification: PASSED
  validation_run: 59
  focused_suite: 6/6
  full_regression: 49/49
  human_visual_qa: NOT_RUN
  player_validation: NOT_RUN
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

## 현재 구현 사실

- ANNUAL-MVP-001은 별도 `AnnualMvp001State`와 전용 저장을 사용한다.
- 3주 × 주당 3슬롯의 일정 선택이 역량·피로·기관 지원·오현 신뢰에 반영된다.
- 2주차 자율 출동, 3주차 추가 준비, 위험 +15 출동, 위험 +30 긴급 출동이 구현됐다.
- 출동 준비에서 오현, 공용 보조 스킬, 신호 완충 모듈을 구성한다.
- 오현의 고유·공용 보조 스킬은 조건 충족 시 자동 판정된다.
- 조건·확률·지원 준비도·남은 횟수를 표시한다.
- 동일 event key는 다시 판정하거나 다시 적용하지 않는다.
- 같은 seed와 입력 순서는 같은 지원 결과를 만든다.
- 기존 CORE-MVP-001을 override와 선택적 extension으로 embedded 실행한다.
- 동료 지원은 체력 회복과 위험 완화만 가능하다.
- 핵심 정답·가설·이해도·관측 패턴·포획 표식은 변경하지 않는다.
- 사건 결과는 잔향 자료·기관 지원·연구·공용 스킬·분기 결산으로 환류한다.
- 분기 결산은 최종 엔딩이 아니라 후속 분기·연도 확장의 중간 결과다.
- F1 개발 패널에서 CORE-MVP-001과 ANNUAL-MVP-001을 별도로 실행할 수 있다.

## 자동 검증

ANNUAL workflow run #59:

- Python 계약 PASS
- Godot 4.7.1 import PASS
- CORE-MVP-001 4/4 PASS
- ANNUAL-MVP-001 6/6 PASS
- 전체 Godot 회귀 49/49 PASS
- 1280×720·1920×1080 기계적 레이아웃 PASS
- 기존 save `mvp-039`와 `mvp-038` 이관 비침범 PASS

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

- 사람 눈 UI·텍스트 QA
- 실제 마우스·키보드·Esc·포커스 사용성
- 육성 선택이 사건 차이로 체감되는지에 대한 플레이 증거
- 동료 자동 지원이 공정하다는 플레이어 설명
- `POC_PASSED`
- `annual loop passed`
- ANNUAL-MVP-002 진입
- 제작 확대

## 다음 작업

1. PR #62 리뷰·병합 결정
2. 세 경로 사람 눈 QA: 조기 출동 / 지연 출동 / 긴급 출동
3. 신규 플레이어에게 육성→사건→연구 인과를 설명하게 함
4. 지원 조건·확률·준비도의 공정성 확인
5. 결과를 `KEEP / AMPLIFY / CHANGE / RETEST / HOLD`로 판정
