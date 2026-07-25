# 괴이 기록국 결정 로그

> 역할: 승인된 핵심 기획 결정과 후속 변경을 시간순으로 보존하는 append-only 기록이다.  
> 상세 설계는 각 spec·GDD가 소유하며, 이 문서는 결정·근거·대체 관계·검증 상태를 연결한다.

## D-2026-07-23-CORE-001 — 사건 코어 승인

- 상태: `APPROVED / CORE_STRESS_TESTED / POC_BUILD_READY`
- 결정: 조사 → 가설 → 위험 검증 → 전조 → 대응 → 안정화·잔향 회수 → 매뉴얼 인과를 제품 코어로 유지한다.
- 가드레일: 육성 수치·동료·장비·아카는 정답을 대신하지 않는다.
- 사람 플레이 증거: `NOT_RUN`
- `POC_PASSED`: `NOT_DECLARED`

## D-2026-07-25-ANNUAL-BASELINE — 연도제 육성·텍스트 노벨 통합

- 상태: `APPROVED_DESIGN_BASELINE`
- 결정: 권나래를 고정 주인공으로 두고 1년 4분기 육성, 관계·기관·연구·장비, 사건 코어, 연도 결산을 연결한다.
- 책임 원본: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`
- 구현 확대: 사람 검증 전 `NOT_APPROVED`

## D-2026-07-25-ANNUAL-FOUR-WEEK — 월간 4주 보정

- 상태: `IMPLEMENTED / HISTORICAL_REGRESSION_EVIDENCE`
- 결정: 한 달을 4주로 보정하고 2주차 위험 0, 3주차 위험 15, 4주차 강제 위험 30 경로를 확립했다.
- 구현: PR #70
- 대체 관계: 주당 3슬롯 시간 예산은 다음 7일 계약으로 대체됐지만 4주·위험 경로 증거는 유지한다.

## D-2026-07-25-ANNUAL-SEVEN-DAY — 7일 주간·가변 일정 계약

- 상태: `MERGED / AUTOMATED_QA_PASSED`
- 승인 계약:
  - 1개월 = 4주 × 주당 7일 = 총 28일
  - 일정별 1~3일 소비
  - 일정의 주차 경계 초과 금지
  - 남은 일수보다 긴 일정 선택 금지
  - 7일 미만 첫 확정은 경고와 편성 유지
  - 같은 편성 재확정은 남은 일수 자동 휴식
  - 직접 휴식은 1일·피로 -25·상태 회복 가능
  - 자동 휴식은 하루당 피로 5만 회복하고 관계 이벤트·특수 회복·추가 보상 없음
  - 출동 위험 2주차 0 / 3주차 15 / 4주차 강제 30
- 구현: Issue #75 / PR #76 / commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478`
- 검증: 문서 run #273, ANNUAL run #121, Visual run #51 PASS
- 상태 원본 동기화: PR #77 / commit `229c74a80b8aefd71d16befb95758f4dcc7f591f`
- 대체 관계: PR #70의 4주×3슬롯에서 `3슬롯/주`만 대체한다. 기존 3주·4주×3슬롯 자료는 역사적 회귀 증거로 보존한다.
- 사람 사용성 QA: `NOT_RUN`
- 신규 플레이어 검증: `NOT_RUN`
- `annual_loop_passed`: `NOT_DECLARED`
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`

## D-2026-07-26-DOC-GOVERNANCE — 기획 정보 무손실 갱신

- 상태: `ADOPTED`
- 결정: 모든 중요 기획·구현·검증 변경은 `docs/PROJECT_UPDATE_PROTOCOL.md`의 동기화 매트릭스를 따른다.
- 추적: Issue #78 / PR #80
- 요구사항: 원문 보존, 결정 로그 추가, 상태 어휘 동기화, 자동/사람 검증 분리, 병합 증거 기록.

## D-2026-07-26-ANNUAL-EXPANSION-SEQUENCE — 시스템 우선 확장 순서

- 상태: `APPROVED_SEQUENCE / PROVISIONAL_DATA_BASELINE`
- 사용자 승인: 2026-07-26
- 추적: Issue #84
- 승인 순서:
  1. ANNUAL-MVP-002 동료·장비·연구 조합
  2. 일정·상태·회복 확장
  3. ANNUAL-MVP-003 1분기 운영
  4. 사건 콘텐츠 제작 규격
  5. 관계·동료·선택적 로맨스 연간 구조
  6. 조작형 규칙 검증 미니게임 규격
  7. ANNUAL-MVP-004 1년 캠페인·결산·계승
- 세부 데이터 위임: 구현 준비를 위해 수치·ID·비용·확률·콘텐츠 수량을 임시 작성한다.
- 데이터 상태: 신규 세부값은 플레이 검증 전 `PROVISIONAL_BASELINE`이며 기존 승인 계약을 대체하지 않는다.
- 책임 원본:
  - `docs/superpowers/specs/2026-07-26-annual-expansion-master-design.md`
  - `docs/planning/ANNUAL_PROVISIONAL_DATA_BASELINE.md`
  - `docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md`
- 보호 계약: 권나래 고정, 4주×7일, 위험 0/15/30, CORE·저장·기존 ID 비침범.
- ANNUAL-MVP-002 구현: `NOT_STARTED`
- ANNUAL-MVP-003 이후 구현: `NOT_APPROVED`
- 사람 사용성·신규 플레이어 검증: `NOT_RUN`
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`
