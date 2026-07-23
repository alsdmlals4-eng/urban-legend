# MVP_ROADMAP

> 문서 위치: `MVP_ROADMAP.md` | 상태 원본: `docs/CURRENT_STATUS.md` | 통합 명세: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md` | CORE-MVP-001 구현 계획: `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md`

## 현재 기준

| 항목 | 값 |
|---|---|
| 기존 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 스키마 | `mvp-039` (`mvp-038` 이관 지원) |
| 승인 코어 | `CORE_RECORDED` - 2026-07-23 |
| 검토 상태 | `CORE_STRESS_TESTED` |
| CORE-MVP-001 구현 | `IMPLEMENTATION_IN_PROGRESS` |
| 자동 검증 | `ACTION_REQUIRED / AUTOMATED_VERIFICATION_PENDING` |
| POC_BUILD_READY | 선언 금지 — 최신 Python·Godot·보호 경로 검증 대기 |
| 목표 구현 트랙 | CORE-MVP-001 → 002 → 003 → 004 |
| 실행 추적 | Issue #56 / Draft PR #57 |
| 설계 정본 | Draft PR #55 기반 |
| 주인공 | 권나래 고정, 단일 일정 주체 |

## 재기준화 원칙

- 현행 구현선은 회귀 기준으로 보존한다.
- 새 코어는 기존 세 사건을 전면 개조하지 않고 독립 저승역 PoC로 구현한다.
- 핵심 단서·가설·이해도 승격은 확률이 아니라 공정한 근거 계약으로 결정한다.
- 확률은 중간 이해도에서 이미 관측한 전투 패턴의 행동명을 읽는 정보 해석에만 사용한다.
- 회수 전투의 승리는 HP 0이 아니라 패턴 대응으로 `포획 창`을 여는 것이다.
- CORE-MVP-001 자동 검증 전 캠페인·경제·엔딩·대규모 서사를 확대하지 않는다.
- 기존 UX-PD-001 2B·2C와 MVP-044~046은 삭제하지 않고 PoC 뒤 재매핑한다.
- 사용자가 면제한 전체 원문 대화·신규 플레이어 행동·사전 지표는 `POC_BUILD_READY` 차단 조건으로 사용하지 않는다.
- 플레이 증거 없이 `POC_PASSED`는 선언하지 않는다.

## 기존 구현 완료선

- 권나래 고정 주인공, 초기 요원 5인, 서포트 최대 2인
- 세 사건의 조사·판단·안정화·잔향 회수·보고서·DB
- 저승역 가설·근거·대응 판단과 매뉴얼 후보·공식 규칙·위험 사례
- 자동 전조형 현행 회수 흐름
- HQ 일상, 세력 의뢰 게시판, 기존 미니게임
- UX-PD-001 2A 준비 화면 점진 공개

## CORE-MVP-001 - 조사·이해도·전조 포획 PoC

> 실행 추적: Issue #56 | 구현 PR: Draft PR #57 | 설계 기반: Draft PR #55

### 목표

> 플레이어가 조사에서 직접 만든 규칙 가설이 회수 전투의 전조 정보가 되고, 준비한 대응으로 포획 창을 여는 순간을 독립 실행 가능한 슬라이스로 구현한다.

### 현재 작성된 범위

- 전용 JSON 사건 데이터와 런타임 검증기
- 조사 장면 3개, 단서 6개, 관련 매뉴얼 3개
- 4지선다와 직접 배제 2개
- 가설 2개, 지지·반박·미해결 근거 연결
- 무관 근거 거부와 비용 없는 잘못된 연결
- 현장 검증 성공·실패·반응 단서·피해·위험 사례
- 이해도 `unknown → clue → likely → understood`
- 미해결 질문 해소 기록
- 회수 패턴 3개, 고정 5턴, 행동 8개
- 미관측 패턴 첫 발동의 정보 비공개·범용 대응·피해 상한 18
- 포획 표식 3개와 정상·비용·긴급 포획
- 회수 품질·피해 관리·지식 품질 3축 결과
- 매뉴얼 반영 검토와 기록 확정의 별도 상태
- JSONL 로그와 F1 개발 패널 진입
- 단계별 단일 패널·스크롤·읽기 전용 뒤로보기·포커스 복구

### 구현 경계

- 전용 경로: `data/poc/core_mvp_001/**`, `scripts/poc/core_mvp_001/**`, `scenes/poc/core_mvp_001/**`
- 진입: `scripts/ui/main_menu.gd`의 F1 개발 패널 버튼
- 기존 `scripts/core/game_state.gd`, `data/episodes/**`, 기존 조사·회수 장면, `project.godot`은 수정하지 않는다.
- 저장 `mvp-039`와 기존 사용자 저장은 읽거나 변경하지 않는다.

### 최신 필수 계약

- 전용 ID는 통합 명세의 고정 `poc001_` ID와 정확히 일치한다.
- 단서와 가설 정합성은 결정론적이다.
- 현장 검증 실패는 정답 대신 반응 단서·피해·위험 사례를 남긴다.
- 핵심 미해결 질문이 해소돼야 `understood`와 검증된 매뉴얼로 승격한다.
- 전조 해석 실패는 정보 없음이며 거짓 예측을 하지 않는다.
- `understood` 단계는 관측한 패턴을 확정 해석한다.
- 미관측 패턴 첫 발동은 범용 대응으로 완화 가능하고 비가역 손실을 만들지 않는다.
- 전투 승리는 포획 조건 달성으로 처리한다.
- 정상 경로는 최소 5턴이다.
- 결과 비교 → 매뉴얼 반영 검토 → 기록 확정을 분리한다.

### TDD 상태

| 순서 | 계약 | 상태 |
|---:|---|---|
| 1 | 데이터 fixture 부재 Red | 확인 |
| 2 | Python 데이터 계약 Green | 과거 PASS |
| 3 | Godot 로더 부재 Red | 확인 |
| 4 | 로더·로그 집중 테스트 | run #16 PASS |
| 5 | 상태 타입 경고 수정 | 코드 반영 |
| 6 | 고정 ID·참조·질문 해소·단계형 UI 계약 | 코드·테스트 반영 / 실행 대기 |
| 7 | 최신 Python 계약 | `ACTION_REQUIRED` |
| 8 | 집중 Godot 테스트 4개 | `ACTION_REQUIRED` |
| 9 | 전체 Godot 회귀 43개 | `ACTION_REQUIRED` |
| 10 | UI·접근성·저장 비침범 수동 QA | `ACTION_REQUIRED` |

### Actions 재개 뒤 `POC_BUILD_READY` 게이트

1. `CI_ENABLED=true` 설정 또는 비용 게이트 제거
2. main/nightly full matrix workflow 추가
3. 문서 validator 통과
4. Python 데이터·정적 계약 통과
5. Godot 4.7.1 import 통과
6. 집중 테스트 `4/4`
7. 전체 Godot 회귀 `43/43`
8. 1280×720·1920×1080 수동 UI·접근성 확인
9. 보호 경로 diff 확인
10. PR #57 review thread와 mergeability 확인

모두 통과하면 `POC_BUILD_READY`를 판정할 수 있다. 신규 플레이어 행동·사전 지표는 이 게이트에 포함하지 않는다.

### 연구 지표 - 선택적 후속 증거

다음 지표는 `POC_PASSED` 또는 제작 확대 판단에 유용하지만 사용자의 요청에 따라 현재 구현·빌드 준비의 필수 차단 조건은 아니다.

- 규칙과 대응 이유 설명
- 근거 기반 배제
- 조사-회수 인과 체감
- 난수 불공정 인식
- 매뉴얼 저작감
- 미관측 패턴 무대응 인식

### 상태 전이

```text
IMPLEMENTATION_IN_PROGRESS
→ ACTION_REQUIRED
→ AUTOMATED_VERIFICATION_PENDING
→ POC_BUILD_READY
→ 선택적 플레이 검증
   ├─ POC_PASSED
   ├─ RETEST_REQUIRED
   └─ HOLD
```

## CI 비용 구조

- 문서 PR: Ubuntu·Python 3.12·문서 validator만 실행
- 코드 PR: Ubuntu job 1개에서 Python → Godot import → 집중 테스트 → 전체 회귀
- main/nightly: Ubuntu·Windows Python matrix, Godot 전체 회귀는 Ubuntu 1회
- 모든 workflow는 ref별 `concurrency`와 `cancel-in-progress: true`
- 실패 artifact만 7일 보존
- `CI_ENABLED != true` 동안 job은 runner 할당 없이 `skipped`
- 상세: `docs/CI_COST_OPTIMIZATION_AND_REENABLEMENT.md`

## CORE-MVP-002 - 포획·연구·괴이별 영구 지식

### 진입 조건

CORE-MVP-001이 최소 `POC_BUILD_READY`를 획득하고, 영구 지식 저장 변경에 대한 별도 승인을 받는다.

### 최소 범위

- 포획 상태와 일상 연구 1종
- 영구 괴이 매뉴얼 지식과 현재 출현별 현장 이해도 분리
- 전용 대응 1개
- 재출현 1회
- 조사에서 조건을 만들고 회수에서 실행하는 히든 대안 1개

### 제외

- 유사 괴이 자동 분류·지식 전이
- 대형 연구 트리
- 항상 우월한 히든 보상

## CORE-MVP-003 - 기간제 챕터·부상·의뢰

### 진입 조건

CORE-MVP-002에서 영구 지식 저장·재사용을 검증한다.

### 최소 범위

- 기간제 챕터 1개와 핵심 사건 마감
- 권나래 강행/회복 선택, 약한 자동 회복
- 지원 요원 경상/중상 비대칭
- 연계 의뢰 1개 + 독립 의뢰 1개
- 기존 미니게임은 `전조 관측 → 규칙 적용 → 즉시 결과` 공통 문법을 충족할 때만 재사용
- 기본 보상 신뢰도 + 소량 잔향 파편 또는 연구도, 우수 등급 선택 보너스

## CORE-MVP-004 - 히든 분기·가치관 엔딩

### 진입 조건

CORE-MVP-003에서 일정 압박이 조사 코어를 가리지 않고 의뢰가 필수 파밍이 아님을 확인한다.

### 최소 범위

- 조사 히든 조건 1개
- 회수 전용 실행 1개
- 일반 회수와 다른 대안 결과 1개
- 추가 장면·기록·후일담
- 괴이 구제·민간인 보호·기관 준수·진실 공개 중 2개 축 최소 검증

## 보류·재매핑

### DEFER

- MVP-044~046의 대량 서사·관계·연출 구현
- 시장·세력·연구 트리 확대
- 복수 챕터와 대규모 엔딩 조합
- 추가 괴이 수량 확정

### PoC 뒤 재사용 후보

- UX-PD-001 2B·2C: 가설 카드와 회수 전조 정보 위계에 맞춰 재설계
- MVP-044: 한 사건 AFTER 1, DAILY 1, FACTION 1만 최소 연결
- MVP-045: 서포트 관찰 질문·위험 해석·결과 반응을 선택 기억으로 연결
- MVP-046: 전조·근거·대응 의도·직전 결과 우선 UI와 절제된 연출

## 보호 계약

- 권나래 고정 주인공과 단일 일정 주체
- 서포트는 정답·필수 단서를 독점하지 않음
- 실패는 위험 사례와 다음 판단 근거를 남김
- 괴이는 처치하지 않고 포획·안정화·잔향 회수로 종료
- 저장 `mvp-039`, 기존 ID와 보호 경로 유지
- UI·아트·연출은 상태를 표현하지만 대신 소유하지 않음
- 구현·검증되지 않은 상태를 완료 기능으로 기록하지 않음
