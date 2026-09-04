# D-2026-08-02-BASE-V94-CANON-RECONCILIATION — Base v9.4 기준 기획 정본 복구

> 상태: `APPROVED_OPERATIONAL_RECONCILIATION`
> 승인 근거: 현재 사용자 지시 + `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL`
> 추적: Issue #121 / Draft PR #122 / PR #124
> 기준 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
> 제품 구현 권한: `NONE`
> 제품 경로 변경: `NONE`
> Google Sheet Decision ID: `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`

## 1. 확인된 새 사실

1. 프로젝트 `main`은 PR #124로 Base v9.4를 채택했다.
2. Draft PR #122와 연결된 Google Sheet는 Base v9.1을 현재값, Base v9.3 PR #120을 HOLD 대상으로 계속 표시한다.
3. PR #122는 Base v9.1 시점의 `main`에서 100개 커밋을 누적했고 현재 `mergeable=false`다. PR 본문에 적힌 HEAD와 실제 GitHub HEAD도 다르다.
4. `docs/CURRENT_CONFIRMED_DECISIONS.md`와 `docs/VALIDATION_TARGET_CANON.md`는 승인됐지만 `main`이 아니라 PR #122 브랜치에만 존재한다.
5. PR #120의 Base v9.3 이관 목적은 Base v9.4가 `main`에 직접 채택되면서 현행 작업으로서 대체됐다.
6. `AGENTS.md` 하단의 BCA v8 기준 문구는 Base v9.4 정본과 충돌한다.
7. 기존 구현 계획은 존재하지 않는 `scripts/core/game_bootstrap.gd`를 baseline으로 포함하며, 최신 `main`의 시작·이어하기는 `scripts/ui/main_menu.gd`와 `GameState`가 직접 소유한다.

## 2. 결정

### 2.1 Base 권위

```text
현재 Base = v9.4.0
payload = a728712cb776ec98f4875914a580fcf7d0156593
trusted evidence = ef1fba11167e4da0b298123b0c85ebd268191a42
project main adoption = 7277b9cececa56532f7b0d11c1a02fd3d5642750
```

Base v9.1·v9.3은 현행 채택선이 아니다. `c987647d...`와 BCA v8 자료는 호환·역사 근거로만 유지한다.

### 2.2 PR #122 처리

PR #122를 현재 `main`에 그대로 병합하거나 cherry-pick하지 않는다.

- 승인된 제품 Target과 Decision은 최신 `main` 기반의 새 정본 브랜치로 승계한다.
- 과거 감사·초안·시각 검토·중간 커밋은 PR #122를 역사 증거로 보존한다.
- 새 정본이 검증되기 전 PR #122를 구현 근거나 최신 Base 상태로 인용하지 않는다.
- 새 정본 PR이 생성되면 PR #122는 `SUPERSEDED_SOURCE_BRANCH`로 표시한다.

### 2.3 PR #120 처리

PR #120은 `SUPERSEDED_BY_BASE_V9_4_MAIN`으로 종료한다.

- 병합·cherry-pick 금지
- 유효한 Vertical Slice 개념은 최신 `main`의 새 기술 계획에서 필요성부터 재검증
- Base v9.3용 Adapter·pin·생성물은 현행 입력으로 사용하지 않음

### 2.4 정본 복구 범위

최신 `main` 기준으로 다음을 설치·갱신한다.

- `docs/CURRENT_CONFIRMED_DECISIONS.md`
- `docs/VALIDATION_TARGET_CANON.md`
- `docs/CURRENT_HANDOFF_VALIDATION.md`
- `docs/planning/POST_V94_CANON_RECONCILIATION_AUDIT_2026-08-02.md`
- `docs/superpowers/plans/2026-08-02-validation-read-only-technical-plan.md`
- `START_HERE.md`
- `AGENTS.md`

`CURRENT_STATUS.md`는 실제 구현 상태 원본으로 유지한다. 승인 Target과 현재 구현을 합치지 않는다.

### 2.5 다음 Gate

```text
Base v9.4 정본·Sheet 재조정
→ 최신 main actual-file/signature/save-policy 읽기 전용 기술 검수
→ CHANGE_PROPOSAL
→ 구현 패키지 재승인
→ 별도 사용자 승인 뒤에만 Codex Build
```

제품 코드·Scene·JSON·Save Schema·에셋은 이 Decision으로 변경할 수 없다.

### 2.6 플랫폼 경계

- 현재 제품·검증 기준: `PC / Steam / 16:9 / mouse+keyboard`
- 모바일: `FUTURE_CONSIDERATION_NOT_IN_CURRENT_VALIDATION_SCOPE`
- 모바일 입력·레이아웃·성능·출시 범위는 PC Validation 통과 뒤 별도 Decision으로 다룬다.

## 3. 적대적 검토 판정

| Finding | 판정 | 처리 |
|---|---|---|
| 승인 정본이 오래된 Draft 브랜치에만 존재 | `MUST_FIX` | 최신 main 기반 정본 복구 |
| Sheet의 Base v9.1·v9.3 상태 | `MUST_FIX` | v9.4·PR #120 superseded로 갱신 |
| PR #122 비병합 가능·본문 HEAD 불일치 | `MUST_FIX` | 현행 병합 대상에서 제외 |
| AGENTS BCA v8 활성 기준 | `MUST_FIX` | Legacy 호환 근거로 격하 |
| 구현 계획의 존재하지 않는 bootstrap 경로 | `MUST_FIX` | 읽기 전용 기술 계획에서 제거 |
| 사람 사용성·신규 플레이어 검증 미실행 | `DEFER_GATE` | Build 승인 전 필수 Gate 유지 |
| 모바일 고려 | `DEFER` | PC Validation 뒤 별도 기획 |
| 전체 tracked-file 인벤토리 | `BLOCKED_UNVERIFIED` | Connector 검색 범위 밖; 로컬 clone/전체 tree 검증 필요 |

## 4. 보호 범위

다음을 변경하지 않는다.

- `data/**`
- `scripts/**`
- `scenes/**`
- `assets/**`
- `addons/**`
- `project.godot`
- 본편 save `mvp-039`·`mvp-038`
- ANNUAL PoC save `annual-mvp-001-save-v1`
- 기존 사건 ID·단서·플래그·대사·결과·테스트

## 5. 동기화 계약

동일 Decision ID로 다음을 갱신한다.

- GitHub: 이 Decision, 현재 결정 인덱스, Validation Target, 감사, Handoff, 기술 계획, 시작 라우터
- Sheet: `00_프로젝트_허브`, `01_작업순서`, `02_현재_확정결정`, `04_누락_충돌_감사`, `99_변경이력`
- PR/Issue: 새 Draft PR, Issue #121, PR #120, PR #122

최종 Commit SHA와 Sheet 범위는 새 Draft PR과 Issue #121 승인 결과 댓글에 기록한다.
