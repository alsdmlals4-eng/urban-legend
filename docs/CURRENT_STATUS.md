# Current Project Status

> 문서 위치: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`  
> 승인 설계: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`  
> 현재 구현 계획: `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`

이 문서는 현재 `main`의 구현 사실, 자동 검증, 플레이 검증, 승인된 미구현 설계를 분리한다. CORE-MVP-001의 `POC_BUILD_READY`는 사건 코어 구현과 자동 회귀가 준비됐다는 뜻이며, 연도제 육성 시스템 구현이나 플레이 통과를 뜻하지 않는다.

## 현재 기준

| 항목 | 현재 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 Schema | `mvp-039` (`mvp-038` 이관 지원) |
| 엔진 | Godot 4.7.1 / GDScript |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 주인공 | 권나래 고정 |
| 사건 코어 | CORE-MVP-001 `POC_BUILD_READY` |
| 사건 코어 main 통합 | PR #55 / commit `8d0bf91a2e31538d3c0f142c800a84e8e3693889` |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| 설계 PR | #58, #59 merged |
| 계획 PR | #60 merged |
| 연도제 구현 | `NOT_IMPLEMENTED` |
| POC_PASSED | `NOT_DECLARED` |
| 현재 작업 | 정본 전환과 ANNUAL-MVP-001 계획 |
| 제작 확대 | `NOT_APPROVED` |

## 병합 이력 정정

- PR #57은 PR #55의 head 브랜치에 병합됐다.
- PR #55가 `main`에 squash merge되며 CORE-MVP-001 구현과 코어 문서가 통합됐다.
- Issue #56은 완료 상태다.
- CORE-MVP-001은 `main`에서 F1 개발 패널로 실행 가능하다.
- 플레이 증거가 없으므로 `POC_PASSED`는 선언하지 않는다.
- PR #58은 연도제 육성·텍스트 노벨 통합 설계를 추가했다.
- PR #59는 해당 설계의 사용자 승인을 `APPROVED_DESIGN_BASELINE / NOT_IMPLEMENTED`로 기록했다.
- PR #60은 정본 전환 계획과 ANNUAL-MVP-001 구현 계획을 추가했다.

## 프로젝트 코어와 설계 상태

| 구분 | 상태 | 의미 |
|---|---|---|
| 최소 제품 코어 | `CORE_RECORDED` | 권나래·규칙 추리·미니게임·회수·매뉴얼 보호 계약 |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` | 육성·텍스트 노벨·사건 이중 코어 승인 |
| 사건 코어 구현 | `POC_BUILD_READY` | 코드·계약·회귀·기계적 UI 검증 통과 |
| 연도제 상위 루프 | `NOT_IMPLEMENTED` | 문서만 승인됐으며 런타임 없음 |
| 자동 문서 검증 | 전환 PR에서 실행 | 정본 간 상태·경로·어휘 검사 |
| 사건 코어 플레이 검증 | `NOT_RUN` | 신규 플레이어 행동 증거 없음 |
| POC_PASSED | `NOT_DECLARED` | 플레이 증거 없이 선언 금지 |
| 제작 확대 | `NOT_APPROVED` | ANNUAL-MVP-001 검증 뒤 판정 |

## CORE-MVP-001 현재 구현

### 독립 데이터

- `data/poc/core_mvp_001/afterlife_station_poc.json`
- 조사 장면 3개, 단서 6개, 관련 매뉴얼 3개
- 선택지 4개, 가설 2개, 현장 검증 2개
- 회수 패턴 3개, 고정 5턴 순서, 행동 8개
- 정상·비용·긴급 포획 결과 3개

### 독립 런타임

- `CoreMvp001CaseData`: JSON 로드와 참조 무결성 검증
- `CoreMvp001State`: 배제, 가설, 검증, 이해도, 전조, 대응, 포획, 매뉴얼 delta
- `CoreMvp001PlaytestLog`: JSONL 플레이 이벤트 기록
- `CoreMvp001Scene`: 조사→가설→검증→회수→결과의 단일 패널 UI

### 보호된 사건 코어 계약

1. 관측 가능한 매뉴얼 근거로 정확히 두 선택지를 배제한다.
2. 남은 가설에 지지·반박·필수 미해결 질문을 연결한다.
3. 무관 근거 연결은 비용 없이 거부한다.
4. 실패는 정답 대신 반응 단서·피해·위험 사례를 남긴다.
5. 조사 결과는 회수 전투의 전조 정보 우위로 변환된다.
6. 미관측 패턴 첫 발동은 정보 비공개·범용 대응·비가역 손실 금지를 따른다.
7. 승리는 적 HP 0이 아니라 포획 표식과 포획 창으로 결정한다.
8. 결과는 회수 품질·피해 관리·지식 품질로 분리한다.
9. 매뉴얼 반영 검토와 기록 확정을 별도 단계로 수행한다.
10. 기존 본편 저장을 읽거나 쓰지 않는다.

## 최신 검증 증거

CORE-MVP-001 병합 전 검증:

| 검증 | 증거 | 상태 |
|---|---|---|
| 문서 계약 | PR #55 run #210 | PASS |
| Python 데이터·정적 계약 | 통합 head run #84 | PASS |
| Godot 4.7.1 import | 통합 head run #84 | PASS |
| 집중 CORE-MVP-001 | 4/4 | PASS |
| 전체 Godot 회귀 | 43/43 | PASS |
| 기계적 UI | 1280×720·1920×1080, Esc, 포커스, 읽기 전용 | PASS |
| 저장 비침범 | save path 비생성·복구 | PASS |
| 플레이 증거 | 없음 | NOT_RUN |

현재 정본 전환은 문서 전용 작업이다. 런타임 파일이 변경되지 않으므로 Godot 검증을 새 통과로 보고하지 않는다.

## 승인된 연도제 제품 방향

```text
주간 일정·육성
→ 관계·기관·연구·장비 준비
→ 사건 징후와 출동 판단
→ 텍스트 노벨형 조사
→ 조작형 규칙 검증 미니게임
→ 턴제 회수 전투
→ 위험 사례·잔향·괴이 매뉴얼
→ 연구·스킬·분기 정산
→ 연도 결산·다음 연도 계승
```

- 1년 4분기
- 주간 계획 + 중요 반일 선택
- 기초 역량 4종, 가치 성향, 전문성
- 피로 1개 + 상태 태그
- 기본 장비 + 연구 모듈
- 권나래 + 동료 최대 2명
- 권나래만 직접 조작, 동료는 고유·공용 스킬 자동 지원
- 기관 교육·괴이 연구로 공용 보조 스킬 획득
- 실패 전진
- 최종 엔딩이 아닌 연도 결산

## ANNUAL-MVP-001 계획 상태

`ANNUAL-MVP-001`은 아직 구현되지 않았다. 승인된 계획은 다음 독립 순환을 검증한다.

```text
3주 × 주당 3개 일정 슬롯
→ 권나래 역량·피로·동료 신뢰 변화
→ 2주차 자율 출동 또는 3주차 강제 출동
→ 동료·공용 스킬·장비 모듈 준비
→ 기존 CORE-MVP-001 사건 실행
→ 사건 결과 반환
→ 잔향 자료·연구 해금
→ 분기 결산 모형
```

보호 경계:

- 기존 `scripts/core/game_state.gd` 미변경
- 기존 `data/episodes/**` 미변경
- 기존 조사·회수 장면 미변경
- `project.godot` 미변경
- `knowledge/base-pack/**` 미변경
- 저장 `mvp-039`와 `mvp-038` 이관 비침범

## 다음 우선순위

| 순서 | 단계 | 상태 | 목적 |
|---:|---|---|---|
| 1 | 연도제 정본 전환 | 진행 | 상위 문서 권한과 상태 정렬 |
| 2 | ANNUAL-MVP-001 계획 승인 | 대기 | 구현 수치·경계·테스트 최종 승인 |
| 3 | 격리 수직절편 구현 | 미착수 | 육성→사건→연구 순환 구현 |
| 4 | 자동·사람 눈 QA | 미착수 | 계약·회귀·텍스트·UI 검증 |
| 5 | 육성→사건→연구 인과 플레이 검증 | 미실행 | 플레이어 체감 증거 수집 |
| 6 | KEEP / CHANGE / RETEST / HOLD | 대기 | 제작 확대 여부 판정 |

## 상태 판정 계약

```text
canonical_migration: IN_PROGRESS
annual_mvp_001: PLAN_PENDING_APPROVAL
automated_document_validation: PENDING
runtime_changes: NONE
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 책임 문서

- 최소 코어: `docs/PROJECT_CORE.md`
- 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`
- 현재 상태: 이 문서
- 짧은 인수인계: `docs/CURRENT_HANDOFF.md`
- 구현 순서: `MVP_ROADMAP.md`
- 검증: `TEST_CHECKLIST.md`
- 승인 설계: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`
- 승인 기록: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design-approval.md`
- 정본 전환 계획: `docs/superpowers/plans/2026-07-25-annual-design-canonical-migration-plan.md`
- ANNUAL-MVP-001 계획: `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`
