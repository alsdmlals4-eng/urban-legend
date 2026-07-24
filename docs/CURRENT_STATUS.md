# Current Project Status

> 문서 위치: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`  
> 승인 설계: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`  
> ANNUAL-MVP-001 계획: `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`

이 문서는 현재 `main` 기준 구현 사실, 자동 검증, 플레이 검증, 승인된 미구현 설계를 분리한다. CORE-MVP-001의 `POC_BUILD_READY`는 사건 코어 구현과 자동 회귀 준비를 뜻하며, 연도제 육성 시스템 구현이나 플레이 통과를 뜻하지 않는다.

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
| 정본 전환 | `COMPLETE` |
| 정본 문서 검증 | `PASSED` — PR #61 run #227 |
| 연도제 구현 | `NOT_IMPLEMENTED` |
| ANNUAL-MVP-001 | `PLAN_PENDING_APPROVAL` |
| POC_PASSED | `NOT_DECLARED` |
| 제작 확대 | `NOT_APPROVED` |

## 병합·승인 이력

- PR #57은 PR #55의 head 브랜치에 병합됐다.
- PR #55가 `main`에 squash merge되며 CORE-MVP-001 구현과 사건 코어 문서가 통합됐다.
- Issue #56은 완료 상태다.
- PR #58은 연도제 육성·텍스트 노벨 통합 설계를 추가했다.
- PR #59는 사용자 승인을 `APPROVED_DESIGN_BASELINE / NOT_IMPLEMENTED`로 기록했다.
- PR #60은 정본 전환 계획과 ANNUAL-MVP-001 구현 계획을 추가했다.
- PR #61은 승인 설계를 프로젝트 코어·GDD·상태·로드맵·검증 정본으로 전환한다.

## 상태 분리

| 구분 | 상태 | 의미 |
|---|---|---|
| 최소 제품 코어 | `CORE_RECORDED` | 권나래·규칙 추리·미니게임·회수·매뉴얼 보호 계약 |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` | 육성·텍스트 노벨·사건 이중 코어 승인 |
| 사건 코어 구현 | `POC_BUILD_READY` | 코드·계약·회귀·기계적 UI 검증 통과 |
| 정본 전환 | `COMPLETE` | 활성 문서가 승인 설계와 같은 권한·상태 사용 |
| 정본 자동 검증 | `PASSED` | 문서 경로·상태·기존 운영 계약 통과 |
| 연도제 상위 루프 | `NOT_IMPLEMENTED` | 런타임 없음 |
| 사건 코어 플레이 검증 | `NOT_RUN` | 신규 플레이어 행동 증거 없음 |
| POC_PASSED | `NOT_DECLARED` | 플레이 증거 없이 선언 금지 |
| 제작 확대 | `NOT_APPROVED` | ANNUAL-MVP-001 검증 뒤 판정 |

## CORE-MVP-001 보존 자산

- 전용 데이터: `data/poc/core_mvp_001/afterlife_station_poc.json`
- 조사 장면 3개, 단서 6개, 매뉴얼 3개
- 선택지 4개, 가설 2개, 현장 검증 2개
- 회수 패턴 3개, 고정 5턴, 행동 8개
- 정상·비용·긴급 포획 결과
- `CoreMvp001CaseData`, `CoreMvp001State`, `CoreMvp001PlaytestLog`, `CoreMvp001Scene`
- F1 개발 패널 진입

보호 계약:

1. 관측 가능한 근거로 정확히 두 선택지를 배제한다.
2. 가설에 지지·반박·필수 미해결 질문을 연결한다.
3. 실패는 반응 단서·피해·위험 사례를 남긴다.
4. 조사 결과는 회수 전조 정보 우위로 변환된다.
5. 미관측 패턴은 범용 대응과 회복 가능한 손실을 보장한다.
6. 승리는 적 HP 0이 아니라 포획 창 개방이다.
7. 결과는 회수 품질·피해 관리·지식 품질로 분리한다.
8. 기존 본편 저장을 읽거나 쓰지 않는다.

## 검증 증거

### CORE-MVP-001 통합 전

| 검증 | 상태 |
|---|---|
| 문서 계약 PR #55 run #210 | PASS |
| Python 데이터·정적 계약 통합 head run #84 | PASS |
| Godot 4.7.1 import | PASS |
| 집중 CORE-MVP-001 | 4/4 PASS |
| 전체 Godot 회귀 | 43/43 PASS |
| 1280×720·1920×1080·Esc·포커스·저장 비침범 | PASS |
| 플레이 증거 | NOT_RUN |

### 연도제 정본 전환

| 검증 | 상태 |
|---|---|
| 새 정본 계약 Red | PR #61 run #214 failure 확인 |
| 운영 호환 계약 원인 분석 | 기존 CORE_RECORDED·HOLD 표기 요구 확인 |
| 문서 계약 Green | PR #61 run #227 PASS |
| 런타임 검증 | NOT_RUN — 런타임 변경 없음 |

## 승인된 연도제 구조

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
- 권나래만 직접 명령, 동료는 고유·공용 스킬 자동 지원
- 기관 교육·괴이 연구로 공용 보조 스킬 획득
- 실패 전진
- 최종 엔딩이 아닌 연도 결산

## ANNUAL-MVP-001 계획

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

상태는 `PLAN_PENDING_APPROVAL / NOT_IMPLEMENTED`다.

## 보호 경계

- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- 기존 조사·회수 장면
- `project.godot`
- `knowledge/base-pack/**`
- 저장 `mvp-039`와 `mvp-038` 이관

정본 전환은 위 런타임·데이터 경로를 변경하지 않는다.

## 다음 우선순위

| 순서 | 단계 | 상태 |
|---:|---|---|
| 1 | 정본 전환 PR #61 검토·병합 | 대기 |
| 2 | ANNUAL-MVP-001 구현 계획 재검토·승인 | 대기 |
| 3 | 격리 수직절편 구현 | 미착수 |
| 4 | 자동·사람 눈 QA | 미착수 |
| 5 | 육성→사건→연구 인과 플레이 검증 | 미실행 |
| 6 | KEEP / CHANGE / RETEST / HOLD | 대기 |

## 최종 상태

```text
canonical_migration: COMPLETE
automated_document_validation: PASSED
annual_mvp_001: PLAN_PENDING_APPROVAL
runtime_changes: NONE
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

## 책임 문서

- 최소 코어: `docs/PROJECT_CORE.md`
- 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`
- 짧은 인수인계: `docs/CURRENT_HANDOFF.md`
- 구현 순서: `MVP_ROADMAP.md`
- 검증: `TEST_CHECKLIST.md`
- 승인 설계: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`
- 승인 기록: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design-approval.md`
- ANNUAL-MVP-001 계획: `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`
