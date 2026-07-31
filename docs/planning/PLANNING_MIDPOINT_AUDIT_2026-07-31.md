# 괴이기록국 기획 중간점검 — 2026-07-31

> Review ID: `R-2026-07-31-PLANNING-MIDPOINT-AUDIT`
> 상태: `REVIEW_COMPLETE / USER_DECISION_REQUIRED`
> 기준 main: `656846865eb88871d00842a0da527ce1b0722b77`
> 대상 브랜치: `plan/urban-legend-planning-audit`
> 추적: Issue #121 / Draft PR #122
> Benchmark Gate: `NOT_APPLICABLE_FOR_AUDIT`
> 구현 권한: `NONE`
> Codex: `HOLD`
> Runtime / Human QA: `NOT_RUN`

## 1. 점검 목적

현재까지 승인·작성된 Validation Cut 기획이 다음 단계인 상황별 인게임 화면 명세로 넘어갈 준비가 되었는지 확인한다.

점검 범위:

- 프로젝트 기획 정본과 현재 Planning PR
- Google GDD Sheet의 제품 방향·핵심 루프·데모·UX·아트·플레이테스트
- 실제 main의 Scene·Script·데이터 소비 구조
- 사용자 제공 `상황별 인게임 화면 구현 명세` 기준
- GitHub Issue·PR 운영 상태

이번 점검은 새 시스템을 승인하지 않는다. 확인된 충돌과 다음 Review Gate만 기록한다.

## 2. 총평

### 유지해야 할 강점

- 제품 카피와 핵심 판타지가 명확하다.
- 조사·기록·가설·현장 적용·결과 기록의 공정성 가드레일이 일관된다.
- Validation Cut 35~50분 우선 전략과 Showcase 보류가 적절하다.
- Benchmark-first와 승인 결정 즉시 GitHub·Sheet 동기화 원칙이 작동하고 있다.
- 저승역 시간순 증거는 승인 기준선으로 승격됐다.
- 회수 패턴은 정답 누설 문제를 인식하고 행동 성공과 추론 검증을 분리하는 방향으로 개선 중이다.
- 실제 main에는 메인, 준비, 조사, 회수, 결과, DB, 연간 PoC Scene과 저장 구조가 존재한다.

### 중간점검 판정

```yaml
product_direction: PASS
core_case_logic: PASS_WITH_REMAINING_REVIEW
validation_cut_scope: PASS
canon_sheet_sync: PASS
screen_situation_canon: MISSING
integrated_product_flow: CONFLICT
recovery_ux_authority: CONFLICT
resource_management_authority: CONFLICT
visual_language_contract: PARTIAL
screen_state_variants: MISSING
screen_level_godot_spec: PARTIAL
runtime_validation: NOT_RUN
human_validation: NOT_RUN
codex_readiness: BLOCKED
```

현재 기획은 개별 시스템 설계의 밀도는 높지만, 플레이어가 실제로 거치는 기준 화면과 상황을 하나의 제품 흐름으로 묶는 정본이 부족하다. 따라서 해결 등급 세부값으로 바로 넘어가기 전에 `화면·상황 권위 정리`를 P0로 삽입한다.

## 3. 필수 기준 화면 4종 현재 판정

### SCREEN-01 메인 화면

확인된 실제 파일:

- `scenes/main_menu.tscn`
- `scripts/ui/main_menu.gd`

현재 기능:

- 새 캠페인 시작
- 이어하기
- 기록국 DB
- 저장 상태
- 연출 강도 접근성
- F1 개발·PoC 진입 패널

핵심 충돌:

- 새 캠페인은 `restart_afterlife_station_flow()` 뒤 대화 Scene으로 직접 진입한다.
- ANNUAL-MVP-001/002는 개발 패널에서만 직접 접근한다.
- 승인된 Validation Cut의 `콜드 오픈 → 브리핑 → 제한 준비 → 저승역` 흐름과 실제 시작 경로가 연결되지 않았다.

판정: `IMPLEMENTED / PRODUCT_FLOW_CONFLICT`

### SCREEN-02 핵심 플레이 화면

괴이기록국에서 전통적 전투 화면의 대응 화면은 다음이다.

- 현장 조사: `investigation_scene`
- 안정화·잔향 회수: `battle_scene`
- 가설 보드·기록 서랍·회수 판단

확인된 실제 파일:

- `scenes/investigation_scene.tscn`
- `scenes/battle_scene.tscn`
- `scripts/scenes/battle_scene.gd`
- `docs/CINEMATIC_FIELD_RECOVERY_UI.md`

핵심 충돌:

- 기존 회수 UI 정본은 `가설 선택 → 근거 선택 → 대응 선택`을 사용한다.
- 신규 회수 검수안은 `패턴 분류 → 근거 연결 → 중립 행동`을 사용하며 사건 전체 가설을 반복하지 않는다.
- 두 계약의 관계가 `대체`, `상황별 병행`, `접근성 대안` 중 무엇인지 아직 정해지지 않았다.
- 실제 저승역 recovery pattern 데이터는 설명형 정답 버튼을 사용하고 있어 신규 중립 문구와 다르다.

판정: `IMPLEMENTED / UX_AUTHORITY_CONFLICT`

### SCREEN-03 인벤토리·보유 자원 관리 화면

괴이기록국에서 전통적 인벤토리의 대응 화면은 사건 준비·연간 운영 화면이다.

현재 제품 준비 화면:

- `scenes/preparation_scene.tscn`
- `scripts/scenes/preparation_scene.gd`
- 반일 일정
- 사건·편성·장비·외부 접점·기록 5개 탭
- 요원 2~3명 편성

ANNUAL-MVP-002 PoC:

- `scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn`
- `scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd`
- 4주×7일
- 동료 최대 2명
- 장비·모듈·연구·지원·템플릿·실행 취소

핵심 충돌:

- 제품 준비 화면은 반일 기반이며 ANNUAL-MVP-002와 시간 구조·편성 규칙·정보 구조가 다르다.
- 어느 화면이 최종 제품의 권위 화면인지 정해지지 않았다.
- ANNUAL 기능을 기존 준비 화면에 흡수할지, PoC 화면을 제품화할지, Validation 전용 축약 화면을 둘지 결정이 필요하다.

판정: `TWO_IMPLEMENTED_SURFACES / PRODUCT_AUTHORITY_CONFLICT`

### SCREEN-04 결과 화면

확인된 실제 파일:

- `scenes/result_scene.tscn`
- `scripts/scenes/result_scene.gd`

현재 표시:

- 안정화·회수 등급
- 피해자 구조·후일담
- 안전 노선 검증 기록
- 공식 규칙·검증 대기 후보·위험 사례
- 연구·기록물·장비 해금
- 사건 보고서·저장 상태

핵심 충돌:

- 결과 화면의 후속 버튼은 `메인 메뉴`, `저승역 다시 시작`, `현재 반일 결과 확인`이다.
- `현재 반일 결과 확인`은 기존 준비 화면과 campaign slot에 연결된다.
- 승인된 4주×7일 연간 운영의 주간·월간 인과 요약과 결과 환류가 제품 결과 화면에 직접 연결되지 않았다.
- 신규 네 축 결과 계약과 현재 `resolution_label`의 대체·확장 관계가 아직 미결정이다.

판정: `IMPLEMENTED / RETURN_FLOW_AND_RESULT_CONTRACT_CONFLICT`

## 4. 대표 상황 명세 준비도

사용자 제공 기준은 메뉴 이름이 아니라 특정한 플레이 맥락을 상황으로 정의한다. 현재 기획에서 우선 등록해야 할 P0 상황은 다음이다.

| 상황 ID | 상황명 | 현재 근거 | 판정 |
|---|---|---|---|
| SIT-001 | 새 캠페인 시작과 첫 역할 인지 | main menu·Validation Cut | 흐름 충돌 |
| SIT-002 | 저승역 콜드 오픈에서 첫 이상 징후 관측 | 통합 경험 v3 | 상세 화면 미작성 |
| SIT-003 | 기록국 브리핑에서 사건 목표 확인 | 통합 경험 v3 | 상세 화면 미작성 |
| SIT-004 | 제한된 준비 선택 | 준비 화면·ANNUAL PoC | 권위 화면 충돌 |
| SIT-005 | 현장 조사 지점과 위험 경로 선택 | CORE·investigation | 부분 구현, 명세 분산 |
| SIT-006 | 후보 4개를 2개로 제거 | 가설 보드 v2 | 설계 있음, 화면 명세 미완 |
| SIT-007 | 시간순 증거로 최초 원인과 매개 역할 구분 | 승인 Decision | 기획 승인, 구현 없음 |
| SIT-008 | 안전 노선 복원 | minigame·JSON | 데이터 중복·정본 충돌 |
| SIT-009 | 회수 전조 분류와 현장 행동 | recovery draft | 사용자 검수 전 |
| SIT-010 | 현장 성공과 추론 검증 결과 확인 | result/reward draft | 결과 계약 미확정 |
| SIT-011 | 연구·장비·다음 일정으로 환류 | ANNUAL·결과 화면 | 통합 연결 미완 |
| SIT-012 | 저장 후 이어하기 | GameState·각 Scene | 자동 검증 있음, 통합 흐름 검증 없음 |

P0 상세 명세는 `SIT-001~SIT-011` 중 Validation Cut에 포함되는 상황을 6~9개로 압축한 뒤 작성해야 한다.

## 5. P1 Finding Ledger

### F-MID-001 — 통합 시작 경로 부재

- 심각도: P1
- 현상: 제품 메인 시작은 저승역으로 직접 진입하고 연간 운영은 개발 PoC로 분리됨.
- 영향: 준비 선택이 사건과 결과를 바꾼다는 제품 약속을 첫 세션에서 증명할 수 없음.
- 요구 결정: Validation Cut의 정확한 Scene 전환 순서.

### F-MID-002 — 준비 화면 권위 이중화

- 심각도: P1
- 현상: 기존 반일 준비 화면과 ANNUAL 4주×7일 PoC가 병존.
- 영향: 화면·데이터·편성 규칙·저장 책임이 분리되고 구현 계획이 흔들림.
- 요구 결정: 제품 준비 화면의 책임 원본.

### F-MID-003 — 회수 UX 계약 충돌

- 심각도: P1
- 현상: 기존 `가설→근거→대응`과 신규 `분류→근거→중립 행동`이 병존.
- 영향: Schema, UI 상태 머신, 결과 기록 구조를 확정할 수 없음.
- 요구 결정: 대체 관계와 적용 조건.

### F-MID-004 — 결과 화면의 연간 환류 미연결

- 심각도: P1
- 현상: 결과 화면은 기존 반일 campaign slot로 복귀.
- 영향: 4주×7일 준비→사건→연구→다음 주 인과가 제품 화면에서 끊김.
- 요구 결정: 결과 이후의 단일 복귀 지점과 유지 데이터.

### F-MID-005 — 화면·상황 정본 부재

- 심각도: P1
- 현상: 시스템·데이터·개별 UI 문서는 있으나 SCREEN/SIT ID 기반 통합 명세 없음.
- 영향: 현재안·개선안·상태 변형·Scene/Node/Signal·테스트의 추적 불가.
- 요구 작업: 필수 화면 4종과 P0 상황 구현 명세 작성.

### F-MID-006 — 시각 언어와 오디오 규격 불완전

- 심각도: P2
- 현상: 기관·기록·괴이 흔적 방향은 있으나 화면 간 팔레트·폰트 계층·아이콘·패널·전환·오디오 문법이 하나의 계약으로 정리되지 않음.
- 영향: 화면별 구현이 기능적으로는 맞아도 한 제품처럼 보이지 않을 위험.
- 요구 작업: 기준 화면 4종의 공통 시각·오디오 계약.

### F-MID-007 — 상태 변형 명세 부족

- 심각도: P2
- 현상: 일부 Script가 저장 없음·잠김·비활성·오류를 처리하지만 정본 명세가 없음.
- 영향: 빈 상태·이어하기·조건 부족·전환 중·튜토리얼 중 화면 누락 위험.
- 요구 작업: 화면별 상태 변형표.

### F-MID-008 — 기획 PR 과밀과 별도 미병합 PR

- 심각도: P2
- 현상: PR #122는 다수의 기획 문서를 누적하고 있으며 #26·#54·#120도 열려 있음.
- 영향: 어떤 문서가 실제 main 권위인지 혼동하고 검토 범위가 커짐.
- 요구 작업: 기획 승인 전에는 병합하지 않되, 최종 정리 시 superseded 문서 축소와 미병합 PR 처리 방침 필요.

## 6. 첨부 작업지시문 대비 충족도

| 요구 영역 | 현재 상태 | 판정 |
|---|---|---|
| 프로젝트 핵심 경험 | 정본·Sheet에 존재 | 충족 |
| 핵심 플레이 루프 | Sheet·통합 경험 문서에 존재 | 부분 충족 — 화면 전환 미연결 |
| 대표 상황 목록 | 본 중간점검에서 1차 도출 | 부분 충족 |
| 상황 우선순위 | 일부 P0/P1 | 부분 충족 |
| 필수 기준 화면 4종 | 실제 파일 확인 | 부분 충족 — 통합 명세 없음 |
| 현재·개선 와이어프레임 | 없음 | 미충족 |
| 화면 상태 변형 | 분산 구현 | 미충족 |
| P0 상세 A~T 명세 | 없음 | 미충족 |
| 전체 상황 전환도 | 통합 경험 텍스트만 존재 | 미충족 |
| 시스템 의존 관계 | 여러 문서에 분산 | 부분 충족 |
| 공통·전용 UI 구분 | 네이티브 UI 원칙 일부 존재 | 부분 충족 |
| 재사용 Scene 구분 | 일부 컴포넌트 존재 | 부분 충족 |
| Vertical Slice 구현 순서 | Validation Cut 순서 존재 | 부분 충족 |
| 테스트 전략 | 자동·플레이테스트 초안 존재 | 부분 충족 |
| Base 승격 후보 | 일부 문서 존재 | 부분 충족 |
| 프로젝트 전용 유지 | 코어·보호 경로 존재 | 충족 |

## 7. 다음 기획 순서 권고

기존의 `원인 미검증 상태 해결 등급 상한` 검수 전에 다음 화면·상황 Gate를 삽입한다.

```text
R-2026-07-31-PLANNING-MIDPOINT-AUDIT
→ 필수 기준 화면 4종 목적형 Benchmark Gate
→ 현재 Scene·Script·데이터 인벤토리
→ 제품 권위 화면 결정
→ SCREEN-01~04 현재안·개선안·상태 변형
→ Validation P0 SIT 6~9개 선정
→ 상황별 상세 명세와 전체 전환도
→ 회수 패턴 승인 검수 재개
→ 해결 등급·환류
→ 플레이테스트 적대적 검토
```

새 화면·UX 설계가 포함되므로 다음 단계의 Benchmark Gate는 `PASSED` 또는 `REUSED`가 필요하다.

## 8. 사용자 결정이 필요한 세 가지

### 결정 A — Validation Cut 시작 구조

권장:

```text
메인 화면
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비 1회
→ 현장 조사
```

현재 실제 `메인 → 저승역 대화` 직접 진입은 Validation 전용 시퀀스로 재정의하거나 대체해야 한다.

### 결정 B — 준비 화면 제품 권위

권장:

- `preparation_scene`를 제품 표면으로 유지
- ANNUAL-MVP-002의 4주×7일·동료·장비·연구 기능을 즉시 전부 합치지 않음
- Validation Cut에서는 `축약 준비 상태`를 같은 화면 구조 안의 제한 모드로 설계
- Showcase 이후 정식 연간 운영 통합을 별도 승인

이 안은 현재 main 흐름을 보존하면서 PoC 전체를 조급하게 제품화하는 위험을 줄인다.

### 결정 C — 회수 판단 권위

권장:

- 사건 가설 보드: 사건 전체 원인 가설을 담당
- 회수 화면: `패턴 분류 → 관련 기록 → 중립 행동`만 담당
- 기존 `가설→근거→대응` 회수 계약은 저승역 Validation에서 superseded 처리하고, 가설 보드가 없는 구형 사건의 compatibility flow로만 유지

이렇게 해야 동일 추론을 반복하지 않고 신규 회수 초안의 목적과 일치한다.

## 9. 현재 Gate

```yaml
midpoint_review: COMPLETE
new_approvals_from_review: NONE
screen_benchmark: REQUIRED_NEXT
screen_situation_canon: BLOCKED_UNTIL_BENCHMARK
recovery_pattern_approval: HOLD_FOR_SCREEN_AUTHORITY
result_cap_review: HOLD
sheet_sync: BRANCH_SYNCED_PENDING_MAIN
product_files_changed: false
codex: HOLD
```

## 10. GitHub·Sheet 동기화 증거

```yaml
review_id: R-2026-07-31-PLANNING-MIDPOINT-AUDIT
github:
  branch: plan/urban-legend-planning-audit
  pull_request: 122
  path: docs/planning/PLANNING_MIDPOINT_AUDIT_2026-07-31.md
  pre_sheet_commit: 592d577b98e965beaf7c92475cf015b76f6a5517
sheet:
  spreadsheet_id: 14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck
  ranges:
    - 01_작업순서!A9:J9
    - 04_누락_충돌_감사!A10:H10
    - 60_UX_UI_접근성!A6:J6
    - 99_변경이력!A9:H9
  status: BRANCH_SYNCED_PENDING_MAIN
approval:
  new_approved_decisions: NONE
  user_decisions_required:
    - Validation Cut 시작 구조
    - 준비 화면 제품 권위
    - 회수 판단 권위
verification:
  product_files_changed: false
  runtime: NOT_RUN
  human_qa: NOT_RUN
  main_merge: PENDING
```
