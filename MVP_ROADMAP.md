# MVP_ROADMAP

> Current planning overlay: `docs/CURRENT_PLANNING_CANON.md` / `docs/current-planning-canon.json` / `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
> current product gate: `TEN_DAY_HALF_DAY_CADENCE_USER_APPROVED / IMPLEMENTATION_CONTRACT_PENDING / HUMAN_QA_NOT_RUN`

이 문서의 CORE/ANNUAL 단계는 병합된 기술·검증·회귀 계보를 보존한다. current product는 10일·오전/오후, 한 cycle 메인 사건 1개, Day 1~9 조기 / Day 10 정규이며 새 implementation contract 전 runtime change를 시작하지 않는다. 아래 ANNUAL-MVP-003 이후 순서는 current execution authority가 아니다.

> 상태 원본: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 최신 시간 설계: `docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md`  
> 확장 마스터 설계: `docs/superpowers/specs/2026-07-26-annual-expansion-master-design.md`  
> 임시 데이터 기준선: `docs/planning/ANNUAL_PROVISIONAL_DATA_BASELINE.md`  
> ANNUAL-MVP-002 상세 설계: `docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md`  
> ANNUAL-MVP-002 구현 계획: `docs/superpowers/plans/2026-07-26-annual-mvp-002-vertical-slice-implementation-plan.md`  
> 벤치마크 권장안: `docs/planning/ANNUAL_BENCHMARK_RECOMMENDATIONS.md`

## 역사적 구현 기준선

| 항목 | 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 Schema | `mvp-039` (`mvp-038` 이관 지원) |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| CORE-MVP-001 | `POC_BUILD_READY` |
| ANNUAL-MVP-001 원 구현 | `BUILD_READY` — PR #62 |
| 4주 보정 | `MERGED / AUTOMATED_QA_PASSED` — PR #70 |
| 7일 주간 계약 | `APPROVED / COMPLETE` — Issue #75 |
| 7일 주간 구현 | `MERGED / AUTOMATED_QA_PASSED` — PR #76 / commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478` |
| 확장 순서 | `APPROVED_SEQUENCE` — Issue #84 / PR #85 |
| 확장 세부 데이터 | `PROVISIONAL_BASELINE` |
| 유사 장르 벤치마크 | `BENCHMARK_RESEARCH_COMPLETE / RECOMMENDED_FOR_REVIEW` — Issue #86 / PR #87 |
| ANNUAL-MVP-002 설계 | `APPROVED_IMPLEMENTATION_BASELINE` |
| ANNUAL-MVP-002 구현 | `MERGED / AUTOMATED_QA_PASSED` — Issue #88 / PR #89 / commit `c790bf747c0fa4f4427d9e4b49b22adbfce92824` |
| ANNUAL-MVP-002 문서 검증 | run #333 PASS |
| ANNUAL-MVP-002 자동 검증 | run #167 PASS |
| ANNUAL-MVP-002 시각·포인터 QA | run #55 PASS / artifact `8625300008` |
| 사람 사용성 QA | `NOT_RUN` |
| 신규 플레이어 검증 | `NOT_RUN` |
| POC_PASSED | `NOT_DECLARED` |
| 제작 확대 | `NOT_APPROVED` |

## 공통 원칙

- CORE-MVP-001의 조사→가설→검증→전조→회수→매뉴얼 인과를 보존한다.
- ANNUAL 트랙은 기존 `GameState`, `mvp-039`, 기존 사건을 직접 개조하지 않는 격리 경로에서 검증한다.
- 성장과 동료 지원은 핵심 정답·가설·이해도·포획 조건을 변경하지 않는다.
- 자동 회귀 통과만으로 `POC_PASSED`나 제작 확대를 선언하지 않는다.
- 기획·구현·병합 상태 변경은 `docs/PROJECT_UPDATE_PROTOCOL.md`의 동기화 매트릭스를 따른다.
- 충돌 시 최신 사용자 승인 ANNUAL-MVP-002 범위 → 7일 설계 → 승인 확장 순서 → 활성 정본 → PR #70의 4주×3슬롯 → 기존 3주 구현 순서로 해석한다.
- `PROVISIONAL_BASELINE` 수치는 플레이 검증을 위한 시작값이며 기존 `FIXED_CONTRACT`를 대체하지 않는다.

## 완료·보존 자산

### CORE-MVP-001

- 사건 코어 독립 PoC `POC_BUILD_READY`
- main 통합 PR #55
- 기존 독립 실행·F1 진입 유지
- 신규 플레이어 증거 `NOT_RUN`

### ANNUAL-MVP-001 역사적 기준

- PR #62 원 수직절편
- PR #65 렌더링·한글·키보드 보정
- PR #67 포인터·모듈 toggle 수정
- PR #70 4주×3슬롯 보정
- PR #73 PROJECT_CORE·GDD 정밀 동기화
- visual run #28/#34, ANNUAL run #94/#101/#103, 문서 run #253/#255는 `HISTORICAL_REGRESSION_EVIDENCE`

## 통합 완료 — 7일 주간·가변 일정 일수

```text
1개월 = 4주 × 주당 7일 = 28일
→ 일정마다 1~3일 소비
→ 주차 경계 초과 금지
→ 첫 미달 확정: 자동 휴식 경고와 편성 유지
→ 같은 편성 재확정: 남은 일수 자동 휴식
→ 직접 휴식은 자동 휴식보다 강함
→ 2주차 위험 0 / 3주차 위험 15 / 4주차 강제 위험 30
→ 사건 → 연구 → 결산
```

### 구현 범위

- JSON `annual-mvp-001-v3`
- 활동별 `day_cost`
- `days_per_week=7`, 월 28일
- `AnnualMvp001StateV2`의 일수 합계·경고·자동 휴식 처리
- 직접 휴식 1일·피로 -25·상태 회복 가능
- 자동 휴식 하루당 피로 5, 관계·특수 회복·추가 보상 없음
- 주간 결과의 `planned_days`, `used_days`, `auto_rest_days`, `activity_results`
- UI의 활동 비용과 사용/남은 일수
- 남은 일수보다 긴 일정 비활성화
- save `annual-mvp-001-save-v1` 유지
- 기존 ID·CORE·렌더링·포인터 계약 보존

### 통합 게이트

- [x] 사용자 승인 설계 기록
- [x] Issue #75 생성
- [x] 데이터·StateV2·Scene·테스트 변경
- [x] PROJECT_CORE·GDD·상태·인수인계·로드맵 정렬
- [x] Python 계약 — run #121 PASS
- [x] Godot 4.7.1 import — run #121 PASS
- [x] CORE focused — run #121 PASS
- [x] ANNUAL focused — run #121 PASS
- [x] 전체 Godot 회귀 — run #121 PASS
- [x] 7일 편성·자동 휴식 경고 렌더링 — run #51 PASS
- [x] 키보드·그래픽 포인터 경로 — run #51 PASS
- [x] PR #76 changed-file·review thread 감사 — thread 0
- [x] PR #76 squash merge — commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478`
- [x] PR #77 상태 원본 병합 — commit `229c74a80b8aefd71d16befb95758f4dcc7f591f`
- [x] Issue #75 completed

## 확장 기획 기준선 — 승인

승인된 순서:

```text
ANNUAL-MVP-002 동료·장비·연구 조합
→ 일정·상태·회복 확장
→ ANNUAL-MVP-003 1분기 운영
→ 사건 콘텐츠 제작 규격
→ 관계·동료·선택적 로맨스 연간 구조
→ 조작형 규칙 검증 미니게임 규격
→ ANNUAL-MVP-004 1년 캠페인·결산·계승
```

책임 원본:

- `docs/superpowers/specs/2026-07-26-annual-expansion-master-design.md`
- `docs/planning/ANNUAL_PROVISIONAL_DATA_BASELINE.md`
- `docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md`
- `docs/planning/ANNUAL_BENCHMARK_RECOMMENDATIONS.md`

세부 데이터 작성 완료 범위:

- 동료 5명 기준선과 고유 스킬 5개
- 공용 보조 스킬 8개, 준비도·보장 발동 규칙
- 장비 6개, 모듈 12개
- 연구 분야 4개, 노드 24개
- 상태 8종과 회복 규칙
- 봄 분기 핵심 1·중형 2·소형 4 사건 기준선
- 기관 요청 6개
- 사건 제작 데이터 규격
- 관계 5단계와 가치 태그 4종
- 미니게임 3종 난이도 기준
- 연도 결산·다음 연도 계승 payload

모든 신규 세부값은 `PROVISIONAL_BASELINE`이다. 구현 결합 전에 ID 충돌 감사와 사람 플레이 수치 검증을 거친다.

## ANNUAL-MVP-002 수직절편 — 병합·자동 검증 완료 (runtime history)

### 구현 subset

전체 임시 기준선 중 첫 수직절편은 다음으로 제한했다.

- 동료 3명: 오현, 한세린, 박도윤
- 최대 동시 편성 2명
- 고유 스킬 3개
- 공용 지원 6개
- 장비 3개, 모듈 6개
- 연구 자원 4종, 연구 노드 8개
- 동시 연구 최대 2개
- save 선택 확장 블록 `state.annual_mvp_002`

### 벤치마크 P0 반영

- 일정 결과 미리보기
- 지난주 복사
- 템플릿 3개
- 전체 초기화
- 마지막 변경 한 단계 취소
- 템플릿의 주차 간 유지
- 동료 지원 적격·비적격 사유, 확률, 준비도, 보장 거리 공개
- 주간 결과의 변화·원인·다음 주 영향 요약

### 공정성·fallback

- 일반 지원 확률은 기본 + 준비 일정 10%p + 업무 신뢰 0/5/10%p, 상한 90%다.
- 준비도는 일반 확률에 직접 더하지 않는다.
- 적격 실패 +20, 실패 학습 연구 완료 시 +25다.
- 준비도 100이면 다음 적격 발동을 보장하고 성공 뒤 0으로 초기화한다.
- 동료·장비·연구는 신규 핵심 단서, 정답 가설, 미관측 패턴, 필수 회수 조건을 제공하지 않는다.
- 확장 데이터·adapter 실패 시 기존 ANNUAL-MVP-001과 CORE 기본 동작을 사용한다.
- save version `annual-mvp-001-save-v1`을 유지한다.
- 구 저장은 기본 확장 상태로 복원하고 알 수 없는 ID는 `orphaned_ids`에 보존하되 효과 계산에서 제외한다.

### 자동 게이트

- [x] Issue #88 생성
- [x] draft PR #89 생성
- [x] 구현 계획 작성
- [x] 데이터 계약 RED→GREEN
- [x] planner RED→GREEN
- [x] State·save·orphan RED→GREEN
- [x] 지원 resolver RED→GREEN
- [x] 사건 adapter·fallback RED→GREEN
- [x] 독립 격리 Scene RED→GREEN
- [x] Python 계약 — run #167 PASS
- [x] Godot 4.7.1 import — run #167 PASS
- [x] CORE focused — run #167 PASS
- [x] ANNUAL-MVP-001 focused — run #167 PASS
- [x] ANNUAL-MVP-002 focused — run #167 PASS
- [x] 전체 Godot 회귀 — run #167 PASS
- [x] 기존 ANNUAL-MVP-001 키보드·포인터 — run #55 PASS
- [x] ANNUAL-MVP-002 실제 포인터 — run #55 PASS
- [x] 1280×720·1920×1080 화면 캡처 — run #55 PASS
- [x] 캡처 8장 직접 검사 — artifact `8625300008`
- [x] 문서 계약 — run #333 PASS
- [x] PR #89 changed-file·review thread 최종 감사
- [x] PR #89 squash merge와 Issue #88 완료 — commit `c790bf747c0fa4f4427d9e4b49b22adbfce92824`

### 별도 후속 범위

- 사건 징후 시계
- 관측·가설·반박 보드
- 연구·괴이 매뉴얼 전체 탐색 UI
- 전체 기준선의 동료 5명·장비 6개·모듈 12개·연구 24개 확대

## 다음 플레이 게이트

- 2주차 조기 출동: 위험 0
- 3주차 자율 출동: 위험 15
- 4주차 긴급 강제 출동: 위험 30
- 7일 안에서 일정 비용 조합이 의미 있는 고민을 만드는가
- 남은 일수 자동 휴식 경고가 이해되고 실수를 방지하는가
- 직접 휴식과 자동 휴식의 차이를 이해하는가
- 육성 선택이 사건 정보·위험·피해 관리로 연결되는가
- 사건 결과가 연구·스킬·결산으로 환류하는가
- 동료별 장점을 설명할 수 있는가
- 지원 적격·확률·준비도·보장 발동을 설명할 수 있는가
- 장비·동료가 사건 정답을 제공한다고 오인하지 않는가
- 일정 미리보기·템플릿·undo가 반복 조작 피로를 줄이는가

판정은 `KEEP / AMPLIFY / CHANGE / RETEST / HOLD`를 사용한다.

## 후속 트랙

### 일정·상태·회복 확장

ANNUAL-MVP-002의 지원·장비·연구 데이터가 안정된 뒤 피로 외 상태, 치료, 상담, 반일 중요 이벤트를 추가한다.

### ANNUAL-MVP-003

1분기 전체 일정·핵심/중형/소형 사건·관계 이벤트·기관 요청·실패 전진. 구현은 별도 사용자 승인 전 시작하지 않는다.

### 사건 콘텐츠 제작 규격

사건 규모별 장면·단서·가설·전조·결말 최소 수량과 공통 데이터 schema를 구현 가능한 형태로 확정한다.

### 관계·동료·선택적 로맨스

업무 신뢰·개인적 유대·가치 충돌·비연애 완결을 연간 구조로 확장한다.

### 조작형 규칙 검증 미니게임

경로 봉쇄, 신호 동기화, 대상 식별 3종을 조사 규칙과 같은 인지 문법으로 구현한다.

### ANNUAL-MVP-004

1년 4분기, 분기별 핵심 사건, 연간 관계·기관 진행, 연도 결산과 다음 연도 계승. 구현은 별도 사용자 승인 전 시작하지 않는다.

## 보호 계약

- 권나래 고정 주인공
- 괴이는 처치하지 않고 안정화·잔향 회수
- 플레이어는 권나래만 직접 명령
- 동료는 정답·필수 단서를 독점하지 않음
- 저장 `mvp-039`, `mvp-038`, `annual-mvp-001-save-v1` 유지
- `scripts/core/game_state.gd`, `data/episodes/**`, `project.godot`, `knowledge/base-pack/**` 보호

## 현재 상태

```text
annual_mvp_001_seven_day_contract: APPROVED
annual_mvp_001_seven_day_implementation: MERGED
annual_mvp_001_automated_verification: PASSED
annual_expansion_sequence: APPROVED
annual_expansion_provisional_data: AUTHORED
annual_mvp_002_design: APPROVED_IMPLEMENTATION_BASELINE
annual_mvp_002_implementation: MERGED
annual_mvp_002_automated_verification: PASSED
annual_mvp_002_merge: COMPLETE
annual_mvp_003_implementation: NOT_APPROVED
annual_mvp_004_implementation: NOT_APPROVED
human_usability_qa: NOT_RUN
player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
