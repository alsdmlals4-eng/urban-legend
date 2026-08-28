# Project Context

> 문서 위치: `docs/PROJECT_CONTEXT.md`  
> 현재 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`
> 프로젝트 코어: `docs/PROJECT_CORE.md`

## 한 줄 정의

`괴이 기록국`은 권나래의 **10일·오전/오후 일정**을 준비하고, 관측 가능한 단서로 괴이 규칙을 추리해 피해자를 구출하고 잔향을 안정화·회수하며, 성공·실패·미확정을 다음 판단의 매뉴얼과 기록으로 남기는 PC용 현대 한국 오컬트 조사 RPG다.

## 현재 구현 기준

- main menu product version `Ver 4.3`
- current runtime: `CampaignState.MAX_DAYS = 10`, `TIME_SLOTS = [morning, afternoon]`
- current product cadence: Day 1~9 조기 해결 / Day 10 정규 해결, 한 cycle 메인 사건 1개
- Godot 4.7.1 / GDScript / PC·Steam 16:9 / 마우스·키보드
- M01 First Session와 M04 shared-system baseline은 merged main에 존재한다.
- Day 10 정규 판정, timing save/result consumer, visible docket, new numeric balance는 `NOT_IMPLEMENTED`.
- Human / Player Experience evidence 없음 / `POC_PASSED NOT_DECLARED`.

## 장르와 화면 문법

> **10일·반일 준비 + 텍스트 조사·규칙 추리 + 피해자 구출 + 전조 기반 잔향 회수**

텍스트 노벨은 기관 업무·관계·사건 조사·전조·결과·기록을 연결하는 기본 표현 문법이다. 조작형 미니게임과 회수 전투를 제거하지 않는다. 연도제·분기 정산 문구는 historical runtime history이며 current cadence를 소유하지 않는다.

## 주인공

권나래는 과거·기본 성격·말투·핵심 욕구가 고정된 주인공이다. 플레이어는 개연성 있는 선택을 반복해 어떤 요원으로 성장하는지를 결정한다.

가능한 성장 방향:

- 절차와 규칙을 중시하는 기관형 요원
- 민간인 보호를 우선하는 현장형 요원
- 괴이의 사정과 공존 가능성을 탐색하는 협상형 요원
- 감춰진 진실을 공개하려는 독립적 조사자

## 공식 기관과 역할

- 공식 기관명: **괴이 기록국**
- 안내자: **기록관 아카**
- 플레이어는 일상에서 권나래의 일정과 준비를 편성한다.
- 사건에서는 권나래의 대화·조사·검증·회수 판단을 직접 선택한다.
- 출동은 권나래 + 동료 최대 2명이다.
- 회수 전투에서 직접 명령하는 인물은 권나래 한 명이다.
- 동료는 고유 스킬과 장착한 공용 보조 스킬을 조건부 자동 발동한다.

## 핵심 세계관 용어

| 용어 | 의미 |
|---|---|
| 괴이 | 인간의 기억·감정·도시 환경에서 규칙을 갖고 발현하는 현상·존재 |
| 안정화 상태 | 현재 출현을 통제해 추가 피해를 막은 상태 |
| 잔향 | 안정화·포획 뒤 회수하는 연구 대상 |
| 위험 사례 | 잘못된 판단과 실패에서 얻은 다음 생존 근거 |
| 괴이 매뉴얼 | 공식 규칙·관측 패턴·위험 사례·연구 대응의 영구 기록 |
| 현장 이해도 | 현재 장소·환경·변형에 대한 출현별 이해 단계 |
| 연도 결산 | `ANNUAL-MVP-*` history에서만 보존하는 historical runtime 용어; current campaign cadence의 owner가 아님 |

## 제품 핵심 루프

```text
10일·반일 일정·육성
→ 관계·기관·연구·장비 준비
→ 사건 징후·출동 시점 판단
→ 텍스트 노벨형 조사
→ 규칙 가설 카드
→ 조작형 위험 검증
→ 전조 기반 턴제 회수
→ 안정화·잔향 회수
→ 괴이 매뉴얼·연구·동료 협업
→ 후일담·연구·관계·다음 cycle 준비
```

## 조사와 회수의 불변 계약

- 핵심 단서는 관측 가능해야 한다.
- 4개 선택지 중 2개를 근거로 배제한다.
- 가설에는 지지·반박·미해결 질문을 연결한다.
- 성장 수치·동료·장비·아카가 정답을 대신하지 않는다.
- 현장 이해도는 공격력보다 전조 정보 우위로 변환된다.
- 거짓 전조를 제공하지 않는다.
- 미관측 핵심 패턴 첫 발동은 범용 대응과 회복 가능한 손실을 보장한다.
- 괴이는 HP 0으로 처치하지 않고 안정화·포획·잔향 회수로 종료한다.
- 성공과 실패를 모두 괴이 매뉴얼에 기록한다.

## 육성·관계·연구의 경계

- 기초 역량: 관찰, 분석, 현장 대응, 대인 대응
- 가치 성향: 괴이 구제, 민간인 보호, 기관 명령 준수, 진실 공개
- 상시 관리 수치: 피로 1개
- 상태 태그: 경상, 중상, 불안, 집착, 과신 등
- 핵심 자원: 일정 일수, 기관 지원도, 잔향 자료
- 장비: 소수 기본 장비 + 연구 모듈
- 관계: 업무 신뢰 + 개인적 유대 + 일부 선택적 로맨스
- 직접 육성 대상은 권나래 한 명
- 개인 돈·생활비·반복 상점 거래는 핵심 시스템에서 제외

## 문체·서사 기준

- 현대 한국 도시 공간과 기관 업무의 구체성을 유지한다.
- 괴이의 규칙은 장르 상식이 아니라 사건 안의 관측 근거로 설명한다.
- 권나래의 대사는 고정된 기본 성격을 유지하면서 누적 성향에 따라 논리와 태도가 변한다.
- 동료 관계는 반복 선물보다 공동 업무·위기·책임·가치 충돌로 진행한다.
- 실패를 무효 처리하지 않고 인물·기관·괴이 기록에 남긴다.
- 연말은 모든 비밀을 끝내는 최종 엔딩이 아니라 다음 연도로 이어지는 결산이다.

## 현재 제작 경계

과거 `ANNUAL-MVP-*` 시간 예산 구현은 historical regression evidence다. current product timing은 `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE`가 소유하며, 다음 구현 계약에서 Day 1~9 조기 / Day 10 정규의 이해도와 체감을 검증한다.

- 한 cycle = 10일 × 하루 2 반일 슬롯
- Day 1~9 해결은 조기, Day 10 해결은 정규이며 두 선택 모두 정상 경로
- 조기 해결 뒤에는 두 번째 메인 사건을 생성하지 않고 남은 반일을 후일담·치료·연구·관계·다음 준비에 쓴다
- 구체 numeric balance와 timing save/result consumer는 implementation contract 전 `UNDEFINED / NOT_IMPLEMENTED`
- 권나래 역량·피로
- 동료 1명과 자동 보조
- 기본 장비·모듈
- 기존 CORE-MVP-001 사건 연결
- 사건 결과 → 연구·분기 결산
- 본편 `GameState`와 저장 `mvp-039` 비침범

PR #62의 3주 구조, PR #70의 4주×3슬롯 구조, PR #76의 7일 주간 구조는 `HISTORICAL_REGRESSION_EVIDENCE`로 보존한다. 새 calendar behavior의 runtime/Human verification은 아직 `NOT_RUN`이다.

## 책임 원본

- 최소 코어: `docs/PROJECT_CORE.md`
- 상세 시스템: `docs/GAME_DESIGN_DOCUMENT.md`
- current contract: `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
- 구현 순서: `MVP_ROADMAP.md`
- 검증: `TEST_CHECKLIST.md`
- historical scheduling design: `docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md`
- 업데이트 프로토콜: `docs/PROJECT_UPDATE_PROTOCOL.md`
- 결정 로그: `docs/DECISION_LOG.md`
