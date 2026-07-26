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

## D-2026-07-26-ANNUAL-GENRE-BENCHMARK — 유사 장르 비교와 개선 후보

- 상태: `BENCHMARK_RESEARCH_COMPLETE / RECOMMENDED_FOR_REVIEW`
- 추적: Issue #86
- 비교 대상: Persona 5 Royal, I Was a Teenage Exocolonist, Long Live the Queen, Citizen Sleeper, WORLD OF HORROR, The Case of the Golden Idol, Return of the Obra Dinn, PARANORMASIGHT, Strange Horticulture.
- 결론: 현재 4주×7일·시스템 우선 구조는 유지한다.
- P0 검토 후보:
  - 일정 결과 미리보기
  - 사건 징후 시계
  - 관측·가설·반박 분리 보드
  - 주간 인과 요약
  - 지난주 복사·템플릿·실행 취소
  - 동료 지원 적격·확률·준비도 공개
  - 연구·괴이 매뉴얼 상호 링크
- 명시적 제외:
  - 핵심 단서 무작위 출현
  - 사건 실패 시 전체 초기화
  - 주사위 중심 행동 성패
  - 회차 기억 전용 필수 정답
  - 숨은 임계치 즉사
  - 동료의 자동 정답 제공
- 책임 원본:
  - `docs/research/2026-07-26-genre-benchmark.md`
  - `docs/planning/ANNUAL_BENCHMARK_RECOMMENDATIONS.md`
- 기존 승인 설계 변경: 없음
- 구현 승인: `NOT_GRANTED`
- 사람 사용성·신규 플레이어 검증: `NOT_RUN`
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`

## D-2026-07-26-ANNUAL-MVP-002-VERTICAL-SLICE — 동료·장비·연구 수직절편

- 상태: `ON_BRANCH / AUTOMATED_QA_PASSED`
- 사용자 승인: 2026-07-26, “좋아 진행해”
- 추적: Issue #88 / draft PR #89
- 대체 관계: `D-2026-07-26-ANNUAL-EXPANSION-SEQUENCE`의 `ANNUAL-MVP-002 구현: NOT_STARTED`를 구현 착수·자동 검증 완료 상태로 갱신한다. 이전 기록은 당시 사실로 보존한다.
- 구현 결정:
  - 확장 contract `annual-mvp-002-v1`, base contract `annual-mvp-001-v3`
  - 동료 오현·한세린·박도윤 3명 중 최대 2명 편성
  - 고유 스킬 3개, 공용 지원 6개
  - 장비 3개, 모듈 6개
  - 연구 자원 4종, 연구 노드 8개
  - 일정 결과 미리보기, 지난주 복사, 템플릿 3개, 전체 초기화, 한 단계 undo
  - 템플릿은 주차 전환 뒤에도 유지
  - 지원 적격·비적격 사유, 확률, 준비도, 보장 거리 공개
  - 주간 결과의 변화·원인·다음 주 영향 인과 요약
- 지원 공정성:
  - 일반 확률 = 기본 + 준비 일정 10%p + 업무 신뢰 0/5/10%p, 상한 90%
  - 준비도는 일반 확률에 직접 가산하지 않음
  - 적격 실패 +20, 실패 학습 연구 완료 시 +25
  - 준비도 100이면 다음 적격 발동 보장, 성공 후 0
  - 신규 핵심 단서·정답 가설·미관측 패턴·필수 회수 조건 제공 금지
- 저장·fallback:
  - save version `annual-mvp-001-save-v1` 유지
  - `state.annual_mvp_002` 선택 블록 추가
  - 구 저장은 기본 확장 상태로 복원
  - 알 수 없는 ID는 `orphaned_ids`에 보존하고 효과 계산에서 제외
  - 확장 데이터·adapter 실패 시 기존 ANNUAL-MVP-001과 CORE 기본 동작 유지
- 벤치마크 반영:
  - 포함: 일정 미리보기, 반복 편성, 지원 투명성, 주간 인과 요약
  - 후속 분리: 사건 징후 시계, 관측·가설·반박 보드, 전체 연구·매뉴얼 탐색
- 자동 검증:
  - 문서 run #333 PASS
  - ANNUAL run #167 PASS
  - Visual run #55 PASS
  - visual artifact `8625300008`, 1280×720·1920×1080 캡처 8장 직접 검사 PASS
- 책임 원본:
  - `docs/superpowers/plans/2026-07-26-annual-mvp-002-vertical-slice-implementation-plan.md`
  - ANNUAL-MVP-002 자동 QA 기록
  - `docs/CURRENT_STATUS.md`
  - `docs/CURRENT_HANDOFF.md`
- 사람 사용성 QA: `NOT_RUN`
- 신규 플레이어 검증: `NOT_RUN`
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`
- ANNUAL-MVP-003: `NOT_APPROVED`


## 2026-07-26 — ANNUAL-MVP-002 적대적 검수 C안

- 상태: `APPROVED_REVIEW_DECISION`
- 추적: Issue #90 / PR #91
- 지원 데이터 6개는 보존한다.
- 현재 CORE hook이 실제 적용 가능한 피해·위험 계열 2개만 `ACTIVE`로 둔다.
- 기록 가독성·실수 면제·표시 시간·회수 창 계열 4개는 `DISABLED_PENDING_CORE_HOOK`으로 두며 선택·발동·성공 로그를 금지한다.
- 준비 보정은 장착 자체가 아니라 직전 주간의 대응 활동 이력에서만 +10%p를 얻는다.
- 병합 후 정본 상태, 실제 main menu 경로, 준비도 영속화, save 복구 정화, 런타임 저장·연구 조작을 기술 보정한다.
- 사람 검증 전 `POC_PASSED`, `annual_loop_passed`, 제작 확대는 계속 미선언한다.

## 2026-07-26 — 한세린 `교차 색인` C안

- 상태: `APPROVED_REVIEW_DECISION / IMPLEMENTED_ON_PR_91`
- 사용자 승인: 2026-07-26, 권장안대로 진행
- 추적: Issue #90 / PR #91
- 결정: `교차 색인`의 ID·이름·조건·효과 데이터는 보존한다.
- 런타임 상태: `DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK`
- 현재 금지: resolver 입력, 선택, 발동 판정, CORE 적용, 성공 로그.
- UI: 준비 화면에 `관측·가설 보드 hook 필요`를 표시한다.
- 활성화 조건: 관측·가설·반박 보드가 기존 기록만 대상으로 충돌 강조를 안전하게 지원하고, 신규 핵심 단서·정답 가설·미관측 패턴을 만들지 않는 계약과 테스트가 승인될 것.
- 사람 사용성 QA·신규 플레이어 검증: `NOT_RUN`
- `POC_PASSED`, `annual_loop_passed`, 제작 확대: 계속 미선언.

