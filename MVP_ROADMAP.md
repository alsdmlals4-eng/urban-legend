# MVP_ROADMAP

> 상태 원본: `docs/CURRENT_STATUS.md`  
> 최소 코어: `docs/PROJECT_CORE.md`  
> 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`  
> 승인 설계: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`  
> 구현 계획: `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`

## 현재 기준

| 항목 | 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 Schema | `mvp-039` (`mvp-038` 이관 지원) |
| 사건 코어 | CORE-MVP-001 `POC_BUILD_READY` |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| 정본 전환 | `COMPLETE` |
| ANNUAL-MVP-001 | `BUILD_READY` — PR #62 / commit `88522ce08f261bce6d61a8043c64caa3b982bd47` |
| 렌더링·입력 QA | `PASSED` — PR #65 / commit `b4f2e224bf7a2a6ee511c83bbbd45cd9e0b8570a` |
| 최종 자동 검증 | `PASSED` — visual run #24, ANNUAL run #89, 문서 run #245 |
| 렌더링·텍스트 검토 | `PASSED` |
| 키보드·Esc 입력 | `PASSED` |
| 세 출동 경로 scripted QA | `PASSED` |
| 수동 마우스 QA | `NOT_RUN` |
| 신규 플레이어 검증 | `NOT_RUN` |
| POC_PASSED | `NOT_DECLARED` |
| 제작 확대 | `NOT_APPROVED` |
| 목표 트랙 | ANNUAL-MVP-001 → 002 → 003 → 004 |

## 공통 원칙

- 현행 MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A는 회귀 기준으로 보존한다.
- CORE-MVP-001의 조사→가설→검증→전조→회수→매뉴얼 인과를 사건 코어로 재사용한다.
- 연도제 트랙은 기존 `GameState`, 저장 `mvp-039`, 기존 사건을 직접 개조하지 않는 격리 PoC부터 검증한다.
- 성장 수치와 동료 지원은 핵심 정답·가설·이해도·포획 조건을 변경하지 않는다.
- 같은 저장 seed와 입력 순서에서 지원 판정을 재현한다.
- 회수 승리는 HP 0이 아니라 패턴 대응으로 포획 창을 여는 것이다.
- 연말 결과는 최종 엔딩이 아니라 연도 결산이다.
- 자동 회귀·렌더링 QA 통과만으로 `POC_PASSED`나 제작 확대를 선언하지 않는다.
- 충돌 시 사용자 승인 최신 설계 → 승인 구현 계획 → 활성 정본 → 기존 PoC·레거시 순서로 해석한다.

## 완료·보존

### CORE-MVP-001 — 사건 코어 독립 PoC

- 상태: `POC_BUILD_READY`
- main 통합: PR #55 / commit `8d0bf91a2e31538d3c0f142c800a84e8e3693889`
- focused suite: 4/4 PASS
- 전체 회귀: ANNUAL workflow 49/49에 포함
- embedded 렌더링: 1280×720·1920×1080에서 조사 패널 노출 확인
- 신규 플레이어 증거: `NOT_RUN`
- `POC_PASSED`: `NOT_DECLARED`

### ANNUAL-MVP-001 — 육성→사건→연구 수직절편

> 구현 상태: `BUILD_READY`  
> 구현 main 통합: PR #62 / commit `88522ce08f261bce6d61a8043c64caa3b982bd47`  
> 렌더링·입력 QA 통합: PR #65 / commit `b4f2e224bf7a2a6ee511c83bbbd45cd9e0b8570a`  
> 최종 검증: visual run #24, ANNUAL run #89, 문서 run #245 PASS

#### 구현 범위

- 3주 × 주당 3개 일정 슬롯
- 권나래 역량 4종, 피로, 기관 지원
- 오현 업무 신뢰
- 조기 출동, 3주차 위험 출동, 긴급 강제 출동
- 오현 고유 보조 스킬
- 기관 공용 보조 스킬
- 연구 공용 보조 스킬
- 발동 조건·확률·지원 준비도·남은 횟수 표시
- 기본 장비 1개와 모듈 1개
- 기존 CORE-MVP-001 embedded 실행
- 사건 결과·manual delta 반환
- 잔향 자료·기관 지원·사후 연구
- 분기 결산 모형
- PoC 전용 저장·복원
- F1 독립 개발 진입

#### 구현 자동 검증

- Python 계약: PASS
- Godot 4.7.1 import: PASS
- CORE-MVP-001 focused: 4/4 PASS
- ANNUAL-MVP-001 focused: 6/6 PASS
- 전체 Godot 회귀: 49/49 PASS
- 보호 경로·기존 저장 비침범: PASS

#### 렌더링·입력 QA 결과

- 1280×720·1920×1080 실제 PNG 검토: PASS
- 한국어 글리프·줄바꿈·정보 밀도: PASS
- 공용 오컬트 Theme·어두운 배경: PASS
- embedded CORE 조사 패널 확장: PASS
- 단계·활동·역량·회수·지식 품질 현지화: PASS
- 초기 키보드 포커스: PASS
- `ui_accept` 활동 선택: PASS
- Esc 선택 취소: PASS
- 조기·지연·긴급 출동 세 경로 결산 도달: PASS
- 대표 visual artifact id `8617041311`
- 시각 방향 판정: `KEEP / AMPLIFY`

## 현재 게이트

### 렌더링·입력 QA 잔여

- 실제 포인터를 사용한 수동 마우스 조작
- 실제 클릭으로 저장·불러오기·출동·연구·결산 동작 확인

이 두 항목 전까지 전체 `QA_READY`는 선언하지 않는다.

### 신규 플레이어 판정

- 육성·준비 선택이 사건 정보·위험·피해 관리에 연결됨을 설명
- 사건 결과가 연구·스킬·결산으로 환류함을 설명
- 동료 지원 조건·확률·준비도가 공정하다고 인식
- 분기 결산을 최종 엔딩이 아닌 중간 결과로 인식
- 주간 일정 반복 피로도 보고

판정은 `KEEP / AMPLIFY / CHANGE / RETEST / HOLD` 중 하나로 기록한다.

## 후속 트랙 — 현재 시작 금지

### ANNUAL-MVP-002 — 동료·장비·연구 조합 확장

진입 조건:

- ANNUAL-MVP-001 수동 마우스 QA 완료
- 육성→사건→연구 순환의 신규 플레이어 증거
- 자동 지원 공정성의 플레이 설명
- 별도 사용자 승인

후보 범위:

- 동료 2명 동시 편성
- 동료별 고유 스킬 차별화
- 협업 성장 뒤 두 번째 공용 슬롯
- 기관·연구 공용 스킬 조합
- 장비 계열과 공용·전용 모듈 확장

### ANNUAL-MVP-003 — 1분기 전체

진입 조건: ANNUAL-MVP-002 조합이 정답을 대체하지 않고 전략 차이를 만든다.

후보 범위:

- 핵심 사건 징후와 마감
- 중형·소형 사건
- 관계 이벤트와 기관 요청
- 피로·상태 태그
- 실패 전진과 분기 정산

### ANNUAL-MVP-004 — 1년 4분기

진입 조건: 1분기 일정 압박과 사건 밀도가 플레이 증거로 검증된다.

후보 범위:

- 봄·여름·가을·겨울 4분기
- 분기별 핵심 사건 1개
- 핵심 사건별 대표 조작형 규칙 검증 미니게임
- 관계·기관·선택적 로맨스 연간 진행
- 현재 진로·신념·관계·세계 상태의 연도 결산
- 다음 연도 계승 payload

## 이전 트랙 매핑

- CORE-MVP-002의 부상·포획·연구는 ANNUAL-MVP-001~002로 분산한다.
- CORE-MVP-003의 기간제 챕터·의뢰는 ANNUAL-MVP-003으로 이동한다.
- CORE-MVP-004의 가치관 결말은 ANNUAL-MVP-004의 연도 결산·계승으로 재해석한다.
- 과거 ID는 승인 이력이며 신규 구현 진입점으로 사용하지 않는다.

## 보호 계약

- 권나래 고정 주인공
- 출동은 권나래 + 동료 최대 2명
- 플레이어는 권나래만 직접 명령
- 동료는 정답·필수 단서·최적 행동을 독점하지 않음
- 괴이는 처치하지 않고 안정화·포획·잔향 회수로 종료
- 연말은 최종 엔딩이 아니라 연도 결산
- 저장 `mvp-039`, `mvp-038` 이관 유지
- `scripts/core/game_state.gd`, 기존 `data/episodes/**`, `project.godot`, `knowledge/base-pack/**` 보호

## 현재 상태

```text
canonical_migration: COMPLETE
annual_mvp_001: BUILD_READY
automated_verification: PASSED
rendered_visual_review: PASSED
keyboard_input_qa: PASSED
three_route_scripted_qa: PASSED
manual_mouse_qa: NOT_RUN
player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
visual_direction: KEEP / AMPLIFY
```
