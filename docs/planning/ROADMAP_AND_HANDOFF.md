# 괴이 기록국 통합 로드맵·인수인계 기획서

> 문서 위치: `docs/planning/ROADMAP_AND_HANDOFF.md`  
> 상태: `../CURRENT_STATUS.md`  
> 실행 순서: `../../MVP_ROADMAP.md`  
> 상세 설계: `../GAME_DESIGN_DOCUMENT.md`

## 목적

승인된 연도제 육성·텍스트 노벨 설계를 작은 수직절편부터 검증하고, 사건 코어·육성·동료·장비·관계·연도 결산을 단계적으로 확대하도록 의존성과 통과 조건을 고정한다.

## 기준선

| 항목 | 기준 |
|---|---|
| 현행 구현 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / `mvp-039` |
| 사건 코어 | CORE-MVP-001 `POC_BUILD_READY` |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| 4주 보정 | PR #70 `HISTORICAL_REGRESSION_EVIDENCE` |
| 7일 주간 계약 | `APPROVED` — Issue #75 |
| 7일 주간 구현 | `ON_BRANCH / CI_PENDING` |
| POC_PASSED | `NOT_DECLARED` |
| 제작 확대 | `NOT_APPROVED` |

## 상위 방향

> 권나래 연도제 육성 시뮬레이션 + 텍스트 노벨 + 규칙 추리 + 조작형 미니게임 + 턴제 회수 전투

```text
육성·준비
→ 사건 조사·규칙 검증·회수
→ 위험 사례·잔향·괴이 매뉴얼
→ 연구·장비·동료 협업
→ 분기 정산·연도 결산
→ 다음 연도 계승
```

## 단계 의존성

### 0. 정본 전환 — 완료

- `PROJECT_CORE`를 육성+사건 이중 코어로 전환
- GDD·상태·인수인계·로드맵 정렬
- PR #61·#73에서 정본과 생성기 동기화

### 1. ANNUAL-MVP-001 — 현재 작업

목표:

> 육성·준비 선택과 일정 비용이 사건의 정보·위험·피해 관리에 차이를 만들고, 사건 결과가 연구·스킬·분기 결산으로 되돌아오는지 검증한다.

활성 범위:

- 1개월 = 4주 × 주당 7일 = 28일
- 일정별 1~3일 소비
- 일정의 주차 경계 초과 금지
- 7일 미만 첫 확정은 자동 휴식 경고와 편성 유지
- 같은 편성 재확정은 남은 일수 자동 휴식
- 직접 휴식은 자동 휴식보다 강함
- 권나래 역량 4종·피로 1개
- 동료 1명·업무 신뢰
- 고유 스킬 1개·공용 스킬 2종 후보
- 기본 장비 1개·모듈 1개
- 2주차 위험 0·3주차 위험 15·4주차 강제 위험 30
- 기존 CORE-MVP-001 embedded 실행
- 사건 결과·잔향 자료·연구·분기 결산
- 전용 저장 `annual-mvp-001-save-v1`

보호:

- 기존 `GameState` 비침범
- save `mvp-039`와 `mvp-038` 이관 비침범
- 기존 사건·조사·회수 장면 비침범
- CORE-MVP-001 회귀 보호
- 기존 활동·동료·스킬·장비·연구 ID 유지

역사적 기준:

- PR #62의 3주×3슬롯 구현
- PR #70의 4주×3슬롯 보정
- PR #65·#67의 렌더링·입력 QA

위 항목은 `HISTORICAL_REGRESSION_EVIDENCE`이며 최신 시간 계약이 아니다.

### 2. ANNUAL-MVP-002 — 동료·장비·연구 조합

진입 조건:

- Issue #75 구현·자동 검증·사람 사용성 QA 완료
- 육성→사건→연구 인과가 신규 플레이어 증거로 확인
- 별도 사용자 승인

범위:

- 동료 2명 동시 편성
- 고유 스킬 차별화
- 기관·연구 공용 보조 스킬
- 협업 성장과 공용 슬롯 추가
- 확률·지원 준비도·보장 발동 UI
- 장비 계열과 공용·전용 모듈 비교

### 3. ANNUAL-MVP-003 — 1분기

진입 조건:

동료 자동 지원과 장비·연구 조합이 정답을 대체하지 않고 전략적 차이를 만든다.

범위:

- 핵심 사건 징후와 마감
- 자율 출동·지연 위험·긴급 출동
- 중형 사건 1개·소형 사건 1개
- 관계 이벤트·기관 요청
- 피로·상태·회복
- 실패 전진
- 분기 정산

### 4. ANNUAL-MVP-004 — 1년 4분기

진입 조건:

1분기 구조에서 일정 압박이 조사 코어를 가리지 않고 일반 사건이 필수 파밍이 아님을 확인한다.

범위:

- 4분기
- 분기별 핵심 사건 1개
- 대표 규칙 검증 미니게임과 회수 전투
- 관계·기관·선택적 로맨스
- 연도 결산
- 다음 연도 계승 payload

## 단계별 증거

| 단계 | 자동 증거 | 사람 눈 QA | 플레이 증거 |
|---|---|---|---|
| 정본 전환 | 문서 계약·경로·상태 어휘 | 문서 충돌 검토 | 불필요 |
| ANNUAL-MVP-001 | 데이터·상태·저장·adapter·회귀 | 일정 비용·경고·준비·결산 가독성 | 육성→사건→연구 인과 |
| ANNUAL-MVP-002 | 지원 확률·보장·재현성 | 스킬 정보 위계 | 동료 조합의 전략성·공정성 |
| ANNUAL-MVP-003 | 마감·상태·실패 전진 | 분기 템포 | 일정 압박·사건 선택 비용 |
| ANNUAL-MVP-004 | 계승·결산·분기 연결 | 연간 가독성·서사 | 한 해의 완결감과 다음 해 기대 |

자동 검증만으로 `POC_PASSED`를 선언하지 않는다.

## 인수인계 체크리스트

### 작업 시작 전

- [ ] `../CURRENT_STATUS.md` 확인
- [ ] `../PROJECT_CORE.md` 확인
- [ ] `../GAME_DESIGN_DOCUMENT.md` 확인
- [ ] `../../MVP_ROADMAP.md` 확인
- [ ] 최신 7일 설계·계획 확인
- [ ] 보호 경로 확인
- [ ] Work Mode·Skill 선언

### PR 작성 전

- [ ] 구현 사실과 승인 설계 구분
- [ ] 자동 검증과 플레이 검증 구분
- [ ] 기존 save·ID·Scene 영향 기록
- [ ] Red→Green 증거 기록
- [ ] 미실행 검증을 통과로 보고하지 않음
- [ ] 다음 게이트 명시

### 병합 전

- [ ] 미해결 review thread 0
- [ ] 예상 head SHA 고정
- [ ] 문서·ANNUAL·Visual workflow 결과 확인
- [ ] 변경 파일이 계획 범위와 일치
- [ ] CURRENT_STATUS·CURRENT_HANDOFF·MVP_ROADMAP·TEST_CHECKLIST 정합

## 현재 인수 상태

```yaml
canonical_migration:
  status: COMPLETE
annual_design:
  status: APPROVED_DESIGN_BASELINE
annual_mvp_001:
  contract: SEVEN_DAY_SCHEDULING_APPROVED
  issue: 75
  implementation: ON_BRANCH
  automated_verification: PENDING
  human_usability_qa: NOT_RUN
  player_validation: NOT_RUN
core_mvp_001:
  implementation: POC_BUILD_READY
  poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 다음 담당자 행동

1. Issue #75 브랜치의 데이터·상태·Scene·테스트 계약을 실행한다.
2. GDD DOCX build와 source hash를 검증한다.
3. 7일 편성·자동 휴식 경고를 720p·1080p와 그래픽 포인터로 검증한다.
4. PR changed-file·review thread·CI를 확인하고 squash merge한다.
5. main 상태 문서에 최종 PR·commit·run을 기록한다.
6. 사람 플레이 전에는 `POC_PASSED`를 선언하지 않는다.

## 보류 항목

- UX-PD-001 2B·2C의 연도제 준비 화면 재설계
- MVP-044~046의 ANNUAL-MVP 트랙 재매핑
- 대형 경제·시장·세력 직접 경영
- 복수 연도 전체 콘텐츠
- 동료 상세 스탯·개인 일정
- 사건 중 저장
- 구현 전 대량 사건·관계 콘텐츠 제작
