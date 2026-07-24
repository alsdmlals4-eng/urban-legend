# Current Codex Handoff

> 문서 위치: `docs/CURRENT_HANDOFF.md`  
> 상태 원본: `docs/CURRENT_STATUS.md`  
> 코어: `docs/PROJECT_CORE.md`  
> 구현 기준: `MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039`

이 문서는 계정·채팅·담당자 교대 시 읽는 짧은 운영 상태다. 실제 완료 여부는 현재 브랜치, PR, Actions 결과와 함께 확인한다.

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
  status: IN_PROGRESS
  runtime_changes: NONE
annual_mvp_001:
  status: PLAN_PENDING_APPROVAL
  implementation: NOT_IMPLEMENTED
active_track:
  - canonical document migration
  - ANNUAL-MVP-001 plan review
next_gate:
  - approve canonical migration diff
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
- F1 개발 패널에서 `CORE-MVP-001 조사→전조→포획 PoC`로 진입한다.
- 조사 4지선다에서 매뉴얼 근거로 2개를 배제한다.
- 남은 가설에 지지·반박·필수 미해결 질문을 연결한다.
- 현장 검증 실패는 반응 단서·피해·위험·누적 위험 사례를 남긴다.
- 회수는 고정 패턴·전조 해석·범용 대응·포획 표식으로 진행한다.
- 결과는 회수 품질·피해 관리·지식 품질로 분리한다.
- PoC는 기존 `GameState`, 기존 사건 데이터, 기존 조사·회수 장면, 저장 Schema를 사용하지 않는다.

## 승인됐지만 미구현인 사실

- 권나래의 1년 4분기 육성
- 주간 계획 + 중요 반일 선택
- 텍스트 노벨을 전체 서사·화면 문법으로 사용
- 핵심 사건별 조작형 규칙 검증 미니게임과 턴제 회수 전투
- 권나래 + 동료 최대 2명
- 권나래 직접 명령, 동료 고유·공용 스킬 자동 지원
- 괴이 연구·기본 장비·모듈
- 관계·기관·선택적 로맨스
- 실패 전진
- 최종 엔딩이 아닌 연도 결산과 다음 연도 계승

이 항목들은 `APPROVED_DESIGN_BASELINE`이며 구현 완료가 아니다.

## 최신 검증 증거

CORE-MVP-001 통합 전 검증:

- 문서 계약 PR #55 run #210: PASS
- Python 데이터·정적 계약 통합 head run #84: PASS
- Godot 4.7.1 import: PASS
- 집중 테스트 4/4: PASS
- 전체 Godot 회귀 43/43: PASS
- 1280×720·1920×1080 viewport·Footer·Esc·포커스·저장 비침범: PASS

현재 정본 전환은 문서 전용 작업이다. 런타임 검증을 새로 실행하거나 통과했다고 기록하지 않는다.

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

- 기존 save `mvp-039` 비침범
- 기존 `mvp-038` 이관 비침범
- 별도 `user://annual_mvp_001_poc.json`만 사용 예정
- 사건 중 저장 금지
- 난수 seed 또는 결과를 저장해 재불러오기 재추첨 금지
- 동료 지원은 정답·가설·이해도·포획 표식을 변경하지 않음
- 기존 CORE-MVP-001 기본 진입과 집중 4/4 회귀 보호

## 보호할 기술 계약

- 권나래 고정 주인공
- 저장 `mvp-039`, `mvp-038` 이관
- 기존 사건·선택·보고서·DB ID
- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- `project.godot`
- `knowledge/base-pack/**`
- 기존 `scripts/scenes/investigation_scene.gd`
- 기존 `scripts/scenes/battle_scene.gd`
- 기록관 아카는 정보를 정리하지만 정답을 대신하지 않음
- UI는 상태를 표현하며 진행을 대신 소유하지 않음

## 진행 금지선

- 플레이 증거 없이 `POC_PASSED` 선언
- 정본 전환 완료 전 ANNUAL-MVP-001 구현 시작
- ANNUAL-MVP-001 계획 승인 없이 코드·데이터·Scene 작성
- 시장·대형 경제·복수 연도·대규모 서사 확장
- 핵심 단서·정답의 확률화
- 거짓 전조 예측
- 동료가 숨은 정답·필수 단서·최적 행동 제공
- 미관측 패턴의 즉사·강제 중상·소프트락·영구 분기 실패
- 기존 저장·사건·조사·회수 경로 직접 개조

## 다음 작업

1. 정본 전환 PR의 문서 계약 통과
2. `canonical_migration: COMPLETE` 판정
3. ANNUAL-MVP-001 구현 계획 재검토·승인
4. 격리 수직절편 구현
5. 자동·사람 눈 QA
6. 육성→사건→연구 인과 플레이 검증
7. `KEEP / CHANGE / RETEST / HOLD` 판정

## 다음 상태 변경 시 갱신

1. `docs/CURRENT_STATUS.md`
2. `docs/CURRENT_HANDOFF.md`
3. `MVP_ROADMAP.md`
4. `TEST_CHECKLIST.md`
5. 관련 PR 본문
