# Current Project Status

> 문서 위치: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`  
> 연도제 원설계: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`  
> 최신 시간 계약: `docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md`  
> 최신 구현 계획: `docs/superpowers/plans/2026-07-25-annual-mvp-001-four-week-month-implementation-plan.md`

이 문서는 구현, 자동 검증, 렌더링·입력 QA, 신규 플레이어 검증을 분리한다. `BUILD_READY`, 렌더링·포인터 이벤트 통과, 4주 계약 자동 검증은 `POC_PASSED`, 연간 루프 통과, 제작 확대 승인을 뜻하지 않는다.

## 현재 기준

| 항목 | 현재 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 Schema | `mvp-039` (`mvp-038` 이관 지원) |
| ANNUAL PoC 저장 | `annual-mvp-001-save-v1` 유지 |
| 엔진 | Godot 4.7.1 / GDScript |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 주인공 | 권나래 고정 |
| 사건 코어 | CORE-MVP-001 `POC_BUILD_READY` |
| 사건 코어 main 통합 | PR #55 / commit `8d0bf91a2e31538d3c0f142c800a84e8e3693889` |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| 정본 전환 | `COMPLETE` — PR #61 |
| ANNUAL-MVP-001 원 구현 | `BUILD_READY` — PR #62 / commit `88522ce08f261bce6d61a8043c64caa3b982bd47` |
| 렌더링·입력 QA 통합 | `RENDERED_QA_PASSED` — PR #65 / commit `b4f2e224bf7a2a6ee511c83bbbd45cd9e0b8570a` |
| 그래픽 포인터 QA·모듈 토글 수정 | `PASSED` — PR #67 / commit `0f24efa204a04cca62a58e55628e6b831b9bef2d` |
| 4주 월간 계약 | `APPROVED` — Issue #69 |
| 4주 월간 구현 | `MERGED / AUTOMATED_QA_PASSED` — PR #70 / commit `20a0d052e4d48863481af7c3acc53805105d6a01` |
| PROJECT_CORE·GDD 정밀 동기화 | `COMPLETE` — Issue #72 / PR #73 / commit `932bc39300bb6ba7f3169b98c25d910f0e01413a` |
| GDD 버전 | v3.1 — 활성 4주 계약 반영 |
| GDD DOCX 생성물 | build·source hash·11페이지 렌더 QA `PASSED`; 저장소 정책상 바이너리 비추적 |
| 문서 계약 | `PASSED` — run #255 |
| ANNUAL 자동 검증 | `PASSED` — run #103 |
| 4주 시각·입력 QA | `PASSED` — run #34 |
| 사람 손 장시간 사용성 QA | `NOT_RUN` |
| 신규 플레이어 검증 | `NOT_RUN` |
| POC_PASSED | `NOT_DECLARED` |
| annual loop passed | `NOT_DECLARED` |
| 제작 확대 | `NOT_APPROVED` |

## ANNUAL-MVP-001 활성 시간 계약

```text
1개월 = 4주 × 주당 3개 일정 슬롯 = 최대 12슬롯
→ 1주차: 활동 3개, 출동 결정 없음
→ 2주차: 활동 3개, 자율 출동 위험 0 또는 지연
→ 3주차: 활동 3개, 자율 출동 위험 15 또는 지연
→ 4주차: 활동 3개와 주간 결과 확인 후 긴급 강제 출동 위험 30
→ 출동 준비 → 기존 CORE-MVP-001 embedded 실행
→ 사건 결과·괴이 매뉴얼 delta·잔향 자료
→ 사후 연구·공용 스킬 해금
→ 최종 엔딩이 아닌 월말/분기 결산 모형
```

### 구현된 시스템

- JSON 계약 `annual-mvp-001-v2`
- `max_weeks=4`, `slots_per_week=3`, `deadline_week=4`
- 기존 3주 상태를 보존하고 활성 Scene이 `AnnualMvp001StateV2`를 사용
- 2주차 조기 출동 위험 0
- 3주차 자율 출동 위험 15
- 3주차 지연 후 4주차 계획 3슬롯 제공
- 4주차 결과 확인 뒤 `annual_forced_deployment`, 위험 30
- 강제 경로 결산 `weeks_used=4`
- 기존 `annual-mvp-001-save-v1` payload 유지
- 기존 2·3주차 저장 복원과 이미 강제 출동 상태인 저장의 진행 보존
- 기존 활동·동료·스킬·장비·연구 ID 유지
- 결정론적 동료 지원 resolver 유지
- CORE-MVP-001 선택적 확장점 유지
  - 외부 지원은 체력 회복·위험 완화만 허용
  - 이해도·가설·관측 패턴·포획 표식 변경 금지
- PoC 전용 저장 `user://annual_mvp_001_poc.json`
  - 기존 `GameState`, `mvp-039`, `mvp-038` 이관 비침범
  - 사건 진행 중 저장 금지
  - 저장 seed 기반 동료 판정 재현

### 정본 문서·생성물 동기화

- `PROJECT_CORE.md`의 오래된 `NOT_IMPLEMENTED` 표기를 실제 4주 병합 상태로 교정
- `GAME_DESIGN_DOCUMENT.md`를 v3.1로 갱신하고 4주 시간 계약과 역사적 QA 경계를 반영
- 결정적 DOCX 생성기를 포맷 v4로 갱신
- Markdown 번호 목록이 DOCX 전체에서 잘못 연속되는 결함을 수정
- DOCX source hash `b0d35778686f6321f1d2b78efe7bd43267cde5b3e0dedb7b35e7aa46ca67e5ca` 검증
- DOCX 11페이지를 PDF·PNG로 렌더링해 글리프·표·번호·머리말·꼬리말·클리핑을 전수 확인
- `docs/URBAN_LEGEND_GAME_DESIGN.docx`는 결정적 생성물이므로 `.gitignore`와 활성 문서 계약에 따라 Git에 추적하지 않음

## 기존 3주 QA 증거 — HISTORICAL

PR #65·#67에서 수행한 다음 증거는 렌더링·현지화·키보드·포인터·embedded CORE 호환의 회귀 기준으로 유지한다. 다만 당시 긴급 출동은 3주차 강제로 기록됐으므로 현재 4주 시간 계약의 플레이 증거가 아니다.

- 1280×720·1920×1080 렌더링
- 공용 현대 오컬트 Theme과 어두운 배경
- 한글 시스템 글꼴 후보
- embedded CORE 조사 패널 확장
- 내부 ID 현지화
- 초기 키보드 포커스, `ui_accept`, Esc
- 실제 좌표 기반 마우스 이동·좌클릭
- PoC 저장·불러오기
- 출동 전 연구·공용 스킬·모듈 선택
- embedded 사건 시작·저장 비활성
- embedded 매뉴얼·조사 선택지 입력
- 모듈 toggle typed-array 런타임 오류 수정

과거 자동 증거:

- Visual workflow run #28: PASS
- ANNUAL workflow run #94: PASS
- CORE focused 4/4
- ANNUAL focused 6/6
- 전체 Godot 회귀 49/49
- 대표 visual artifact id `8617041311`

4주 계약은 PR #70과 문서 정밀 동기화 PR #73에서 다시 검증됐다.

- 문서 계약 run #255: PASS
- ANNUAL run #103: Python 계약, Godot 4.7.1 import, CORE focused, ANNUAL focused, 전체 Godot 회귀 PASS
- Visual run #34: 키보드·Esc, 실제 그래픽 포인터, 4주차 결과·긴급 강제 출동 캡처 PASS

## 충돌 해석 우선순위

구현·문서·기존 코드가 충돌할 때는 다음 순서로 해석한다.

1. 사용자가 승인한 최신 4주 월간 설계
2. `docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md`
3. 승인된 4주 구현 계획과 Codex Goal
4. `CURRENT_STATUS`·`PROJECT_CORE`·GDD 활성 정본
5. 기존 3주 PoC와 과거 QA 기록

최신 기획을 우선하되 보호 경로, 저장 비침범, 기존 CORE 하위 호환 계약은 유지한다.

## 보호 경계

변경하지 않는다.

- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `project.godot`
- `knowledge/base-pack/**`
- 저장 `mvp-039`와 `mvp-038` 이관
- 기존 CORE 사건·ID

## 아직 구현하지 않은 범위

- 본편 1년 4분기 전체
- 실제 월별 사건 배치·요일·공휴일
- 동료 2명 동시 편성
- 관계·로맨스 연간 진행
- 중형·소형 일반 사건
- 신규 대표 조작형 규칙 검증 미니게임
- 본편 `GameState` 통합과 기존 save migration
- 연도 결산 계승 payload의 실제 다음 연도 소비
- ANNUAL-MVP-002~004

## 다음 게이트

1. 사람 손을 사용한 장시간 마우스·키보드 사용성 평가
2. 신규 플레이어의 2주차 조기·3주차 자율·4주차 강제 출동 플레이
3. 육성→사건→연구 인과와 동료 자동 지원 공정성 설명 수집
4. 전체 루프를 `KEEP / AMPLIFY / CHANGE / RETEST / HOLD`로 판정
5. 별도 사용자 승인 전 ANNUAL-MVP-002와 제작 확대 시작 금지
