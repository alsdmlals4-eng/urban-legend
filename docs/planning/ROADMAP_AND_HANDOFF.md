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
| 연도제 구현 | `NOT_IMPLEMENTED` |
| POC_PASSED | `NOT_DECLARED` |
| 현재 트랙 | 정본 전환 → ANNUAL-MVP-001 계획 승인 |
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

### 0. 정본 전환

목표:

- `PROJECT_CORE`를 육성+사건 이중 코어로 전환
- GDD v3.0 정렬
- 상태·인수인계·로드맵의 오래된 PR 대기 문구 제거
- 문서 지도·테스트 계약 정렬

통과 조건:

- 문서 계약 `PASSED`
- 변경 파일이 Markdown과 문서 계약 테스트로 제한
- 런타임·데이터·Scene·저장 변경 없음

### 1. ANNUAL-MVP-001 — 3주 수직절편

목표:

> 육성·준비 선택이 사건의 정보·위험·피해 관리에 차이를 만들고, 사건 결과가 연구·스킬·분기 결산으로 되돌아오는지 검증한다.

범위:

- 3주 × 주당 3슬롯
- 권나래 역량 4종·피로 1개
- 동료 1명·업무 신뢰
- 고유 스킬 1개·공용 스킬 2종 후보
- 기본 장비 1개·모듈 1개
- 2주차 자율 출동·3주차 강제 출동
- 기존 CORE-MVP-001 embedded 실행
- 사건 결과·잔향 자료·연구·분기 결산
- 전용 저장

보호:

- 기존 `GameState` 비침범
- 기존 save `mvp-039`와 `mvp-038` 이관 비침범
- 기존 사건·조사·회수 장면 비침범
- CORE-MVP-001 집중 4/4와 전체 43/43 회귀 보호

### 2. ANNUAL-MVP-002 — 동료·장비·연구 조합

진입 조건:

ANNUAL-MVP-001에서 육성→사건→연구 인과가 플레이 증거로 확인된다.

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
| ANNUAL-MVP-001 | 데이터·상태·저장·adapter·회귀 | 일정·준비·결산 가독성 | 육성→사건→연구 인과 |
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
- [ ] 활성 계획 확인
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
- [ ] 문서·코드 workflow 결과 확인
- [ ] 변경 파일이 계획 범위와 일치
- [ ] CURRENT_STATUS·CURRENT_HANDOFF·MVP_ROADMAP·TEST_CHECKLIST 정합

## 현재 인수 상태

```yaml
canonical_migration:
  status: IN_PROGRESS
  runtime_changes: NONE
annual_design:
  status: APPROVED_DESIGN_BASELINE
annual_mvp_001:
  status: PLAN_PENDING_APPROVAL
  implementation: NOT_IMPLEMENTED
core_mvp_001:
  implementation: POC_BUILD_READY
  automated_verification: PASSED
  poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 다음 담당자 행동

1. 정본 전환 PR의 문서 계약을 통과시킨다.
2. 정본 전환 diff가 코드·데이터·Scene을 포함하지 않는지 확인한다.
3. 정본 전환을 병합한다.
4. ANNUAL-MVP-001 구현 계획의 수치·경계·인터페이스를 재검토한다.
5. 사용자 승인 뒤에만 격리 구현을 시작한다.

## 보류 항목

- UX-PD-001 2B·2C는 연도제 준비 화면에 맞춰 재설계
- MVP-044~046은 새 ANNUAL-MVP 트랙으로 재매핑
- 대형 경제·시장·세력 직접 경영
- 복수 연도 전체 콘텐츠
- 동료 상세 스탯·개인 일정
- 사건 중 저장
- 구현 전 대량 사건·관계 콘텐츠 제작
