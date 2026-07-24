# Current Codex Handoff

> 문서 위치: `docs/CURRENT_HANDOFF.md`  
> 상태 원본: `docs/CURRENT_STATUS.md`  
> 코어: `docs/PROJECT_CORE.md`  
> 구현 기준: `MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039`

이 문서는 계정·채팅·담당자 교대 시 읽는 짧은 상태다. 실제 완료 여부는 현재 브랜치·PR·Actions 결과와 함께 확인한다.

```yaml
status: ANNUAL_DESIGN_BASELINE_APPROVED
implemented_baseline: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039
core_mvp_001:
  implementation: POC_BUILD_READY
  automated_verification: PASSED
  player_validation: NOT_RUN
  POC_PASSED: NOT_DECLARED
  main_merge:
    pr: 55
    commit: 8d0bf91a2e31538d3c0f142c800a84e8e3693889
annual_design:
  status: APPROVED_DESIGN_BASELINE
  implementation: NOT_IMPLEMENTED
  design_pr: 58
  approval_pr: 59
  plans_pr: 60
canonical_migration:
  status: COMPLETE
  automated_document_validation: PASSED
  validation_run: 227
  runtime_changes: NONE
annual_mvp_001:
  status: PLAN_PENDING_APPROVAL
  implementation: NOT_IMPLEMENTED
active_track:
  - review and merge canonical migration PR 61
  - review ANNUAL-MVP-001 implementation plan
next_gate:
  - merge canonical migration
  - approve isolated vertical slice implementation plan
production_expansion: NOT_APPROVED
```

## 필수 읽기

```text
AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/GAME_DESIGN_DOCUMENT.md
→ docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md
→ docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design-approval.md
→ docs/superpowers/plans/2026-07-25-annual-design-canonical-migration-plan.md
→ docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md
→ 기존 CORE-MVP-001 코드·데이터·테스트
```

## 현재 구현 사실

- CORE-MVP-001은 PR #57에서 구현되고 PR #55를 통해 `main`에 통합됐다.
- Issue #56은 완료됐다.
- F1 개발 패널에서 CORE-MVP-001 PoC를 실행할 수 있다.
- 조사 배제→가설 카드→현장 검증→전조→회수→포획→매뉴얼 기록이 구현됐다.
- CORE-MVP-001은 기존 `GameState`, 기존 사건, 저장 Schema를 사용하지 않는다.
- 집중 테스트 4/4와 전체 Godot 회귀 43/43이 통합 전 통과했다.
- 플레이 증거가 없어 `POC_PASSED`는 선언하지 않는다.

## 승인됐지만 미구현인 사실

- 권나래 1년 4분기 육성
- 주간 계획 + 중요 반일 선택
- 텍스트 노벨 전체 표현 문법
- 핵심 사건별 조작형 미니게임과 회수 전투
- 권나래 + 동료 최대 2명
- 권나래 직접 명령, 동료 고유·공용 스킬 자동 지원
- 괴이 연구·기본 장비·모듈
- 관계·기관·선택적 로맨스
- 실패 전진
- 연도 결산과 다음 연도 계승

이 항목은 `APPROVED_DESIGN_BASELINE / NOT_IMPLEMENTED`다.

## 정본 전환 결과

- `PROJECT_CORE`가 육성+사건 이중 코어를 소유한다.
- GDD v3.0이 일정·성장·사건·동료·연구·관계·연도 결산을 소유한다.
- CURRENT_STATUS·CURRENT_HANDOFF의 오래된 병합 대기 상태를 제거했다.
- MVP_ROADMAP을 ANNUAL-MVP-001~004로 재기준화했다.
- README·PROJECT_CONTEXT·기획 방향·문서 지도를 정렬했다.
- TEST_CHECKLIST에 기존 사건 코어 회귀와 ANNUAL-MVP-001 사전 계약을 분리했다.
- 문서 계약 Red run #214를 확인한 뒤 운영 호환 표기를 복원했다.
- Green run #227이 통과했다.
- 코드·데이터·Scene·저장 Schema 변경은 없다.

## ANNUAL-MVP-001 계획 요약

```text
3주 × 주당 3슬롯
→ 권나래 역량·피로·동료 신뢰
→ 2주차 자율 출동 / 3주차 강제 출동
→ 동료·공용 스킬·장비 모듈 준비
→ 기존 CORE-MVP-001 embedded 실행
→ 사건 결과·잔향 자료
→ 연구 해금
→ 분기 결산 모형
```

- 기존 save `mvp-039`와 `mvp-038` 이관 비침범
- 별도 PoC 저장만 사용 예정
- 사건 중 저장 금지
- 같은 seed와 입력 순서로 난수 판정 재현
- 동료 지원은 정답·가설·이해도·포획 표식을 변경하지 않음
- 기존 CORE-MVP-001 기본 진입과 4/4 회귀 보호

## 보호할 기술 계약

- 권나래 고정 주인공
- 저장 `mvp-039`, `mvp-038` 이관
- 기존 사건·보고서·DB ID
- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- `project.godot`
- `knowledge/base-pack/**`
- 기존 조사·회수 장면
- 기록관 아카와 동료는 정답을 대신하지 않음

## 진행 금지선

- 플레이 증거 없이 `POC_PASSED` 선언
- PR #61 병합 전 정본 전환 완료를 `main` 사실로 오인
- ANNUAL-MVP-001 계획 승인 없이 구현 시작
- 대형 경제·복수 연도·대규모 콘텐츠 확장
- 핵심 정답·가설 정합성 난수화
- 동료의 숨은 정답·필수 단서 제공
- 기존 저장·사건·조사·회수 경로 직접 개조

## 다음 작업

1. PR #61 검토·병합
2. ANNUAL-MVP-001 구현 계획 재검토·승인
3. 격리 수직절편 구현
4. 자동·사람 눈 QA
5. 육성→사건→연구 인과 플레이 검증
6. `KEEP / CHANGE / RETEST / HOLD` 판정
