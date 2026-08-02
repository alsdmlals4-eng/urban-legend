# 괴이기록국 Validation 현재 인수인계

> 상태: `CANON_RECONCILIATION_PENDING_MAIN`
> 갱신일: 2026-08-02
> Decision: `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> 제품 구현 권한: `NONE`

## 현재 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/planning/POST_V94_CANON_RECONCILIATION_AUDIT_2026-08-02.md
→ docs/superpowers/plans/2026-08-02-validation-read-only-technical-plan.md
→ 실제 main 코드·데이터·테스트
```

## 현재 상태

```yaml
base: 9.4.0
base_adoption_main: 7277b9cececa56532f7b0d11c1a02fd3d5642750
planning: APPROVED_FINAL_PLANNING_BASELINE
canon: RECONCILED_ON_BRANCH_PENDING_MAIN
implementation: CURRENT_IMPLEMENTATION_LEGACY
validation_build: NOT_AUTHORIZED
runtime: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
platform: PC_16_9_MOUSE_KEYBOARD
mobile: FUTURE_CONSIDERATION_NOT_IN_CURRENT_SCOPE
```

## 승인 Target

```text
무인 메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 가설·시간순 증거
→ 안전 노선 복원
→ 회수 2패턴
→ 결과 4축·최소 환류
→ 메인 복귀
```

상세는 `docs/VALIDATION_TARGET_CANON.md`가 소유한다.

## 현재 구현과의 차이

- `main_menu.gd`는 Legacy 저장 하나를 기준으로 새 캠페인·이어하기를 처리한다.
- `GameState`는 본편 `mvp-039` 저장과 사건·회수·보고서·ANNUAL 상태를 폭넓게 소유한다.
- `investigation_scene.gd`는 조사 지점·현장 대화·가설 진입·기록 Drawer를 이미 소유한다.
- `battle_scene.gd`는 가설·증거·응답 단계와 회수 안정도·두려움·임계값을 이미 소유한다.
- `result_scene.gd`는 진입 시 사건 보고서를 즉시 기록하고 반일 준비 화면으로 복귀하는 Legacy 버튼을 제공한다.
- 승인 Target의 별도 Validation 저장, flow stage, 결과 원시 4축, 메인 복귀는 아직 구현되지 않았다.

## 열린 위험

1. `GameState`에 신규 상태를 직접 추가하면 Legacy save payload와 reset 의미가 변할 수 있음
2. 결과 Scene 재진입 시 보고서·보상 중복 적용 가능성
3. 기존 battle 판단 상태와 신규 Validation state의 이중 소유권
4. 숨긴 Legacy 기능이 난수·로그·상태를 변경할 위험
5. 존재하지 않는 `scripts/core/game_bootstrap.gd`를 전제로 한 구형 계획
6. 사람 검증 없이 정보 위계·문구·보상감을 확정할 위험

## 다음 작업

`docs/superpowers/plans/2026-08-02-validation-read-only-technical-plan.md`를 실행해 다음만 산출한다.

- 실제 파일·함수·Scene·저장 경계 인벤토리
- 기존 구현 계획의 `KEEP / CHANGE / REMOVE / ADD` 표
- 최소 격리 아키텍처 2~3안과 권장안
- Save/Scene/Result idempotency 계약
- 변경 파일 목록과 회귀 테스트 목록
- `CHANGE_PROPOSAL`

이 단계에서는 파일을 수정하거나 Codex Build Goal을 만들지 않는다.

## GitHub 상태

- PR #120: Base v9.4 main으로 목적 대체
- PR #122: 승인 기획의 역사 증거, 그대로 병합 금지
- 새 브랜치: `agent/v9-4-canon-reconciliation`
- 새 Draft PR: 생성 후 이 문서와 Sheet에 기록
