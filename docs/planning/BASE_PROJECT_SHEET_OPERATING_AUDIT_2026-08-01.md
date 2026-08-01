# Base·프로젝트 GitHub·GDD Sheet 운영체계 적대적 감사 — 2026-08-01

> Review ID: `R-2026-08-01-BASE-PROJECT-SHEET-OPERATING-AUDIT`
> 상태: `REVIEW_COMPLETE / VISUAL_GATE_ACTIVE / NOT_BUILD_READY`
> Work Mode: `REVIEW`
> 주 책임: `urban-legend-qa / repository-wide-audit`
> 지원 책임:
> - `running-adversarial-review-and-refinement / repository-wide-audit`
> - `managing-game-project-operating-system / audit`
> - `managing-design-documents / update·validate`
> 기준 main: `656846865eb88871d00842a0da527ce1b0722b77`
> 계획 branch: `plan/urban-legend-planning-audit`
> 추적: Issue #121 / Draft PR #122
> 제품 구현 권한: `NONE`
> Runtime / Visual / Human QA: `NOT_RUN`
> Codex: `HOLD`

## 1. 감사 목적

다음을 하나의 영향 지도에서 대조한다.

1. Base 최신 운영체계와 Skill 구조
2. urban-legend가 실제로 채택한 Base 버전·Adapter·프로젝트 Skill
3. 프로젝트의 상위 정본·계획·실제 제품·테스트 상태
4. Google GDD Sheet 27개 탭의 현재 Decision·상태·다음 작업
5. 승인된 Validation A~G 패키지의 전파 누락
6. 다음 기획·시각·검증·정본 이관 순서

`전부 확인`은 모든 파일을 무차별적으로 컨텍스트에 적재하는 방식이 아니다. Base와 프로젝트의 `START_HERE → Documentation Map → Registry → 책임 원본 → 실제 소비처 → 테스트` 라우팅으로 전체 책임을 추적한다.

## 2. 확인 범위

### Base

- `START_HERE.md`
- `AGENTS.md`
- `docs/OPERATING_MODEL.md`
- `docs/DOCUMENTATION_MAP.md`
- `docs/WORK_MODE_AND_SKILL_ROUTING.md`
- `docs/CONFIRMED_DECISION_SYNC_POLICY.md`
- `docs/PLANNING_SEQUENCE_AND_EVIDENCE_POLICY.md`
- `docs/PROJECT_GDD_GOOGLE_SHEETS_POLICY.md`
- `docs/GPT_IMAGE_GENERATION_AND_REVIEW_POLICY.md`
- `docs/BASE_RULES_VERSION.md`
- `base-v9.3.lock.json`
- `skills/SKILL_REGISTRY.json`
- `docs/generated/BASE_ACTIVE_SKILLS.md`
- `skills/running-adversarial-review-and-refinement/SKILL.md`
- `skills/managing-game-project-operating-system/SKILL.md`
- `skills/managing-design-documents/SKILL.md`

### 프로젝트 GitHub

- `START_HERE.md`, `AGENTS.md`
- `docs/BASE_RULES_VERSION.md`
- `docs/CURRENT_STATUS.md`
- `docs/PROJECT_CORE.md`
- `docs/DOCUMENTATION_MAP.md`
- `docs/planning/README.md`
- `MVP_ROADMAP.md`
- `skills/SKILL_REGISTRY.json`
- `skills/PROJECT_BASE_ADAPTER.json`
- `skills/PROJECT_PATH_ADAPTER.json`
- 최근·열린 PR, Issue #121, Draft PR #122
- 승인 Decision·SCREEN/SIT Spec·적대적 검토·저장 계획
- 이전 전체 제품 감사에서 확인한 실제 Scene·Script·JSON·테스트 경로

### Google Sheet

Spreadsheet:
`14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck`

27개 탭 전체를 확인했다.

```text
00_프로젝트_허브
01_작업순서
02_현재_확정결정
03_근거_라이브러리
04_누락_충돌_감사
05_GDD_요약
10_제품방향
11_세계관
12_핵심루프
13_주요인물
14_조연_세력_관계
15_조작_게임규칙
20_코어경험_데모목표
30_데모범위_품질기준_제작기반
40_핵심시스템_메인콘텐츠
41_성장_경제
50_메인콘텐츠
51_미니게임
52_글쓰기_서사
60_UX_UI_접근성
70_아트_오디오_에셋
71_이미지기획_생성목록
72_이미지검수_승인로그
80_데모_버티컬슬라이스_플레이테스트
90_본제작_출시_사업
98_Base_반영후보
99_변경이력
```

## 3. Base 현행 구조 분석

### 3.1 현재 Base 릴리스 계층

Base는 다음 계층을 분리한다.

```text
사람용 안정 기준: v9.0.0 RELEASED
현재 호환 운영선: v9.3.0 RELEASED
기계 릴리스 잠금: base-v9.3.lock.json
활성 Skill 권위: skills/SKILL_REGISTRY.json
선택 라우팅: START_HERE + Documentation Map + Registry trigger
```

v9.3 기계 잠금:

- candidate release commit: `30ca6c7b5f93521f0eb0eed42d01437cd43c50ae`
- evidence commit: `462a86db192d23d0f386281a1eb54b0a8cbad62e`
- 활성 Skill: 27개

### 3.2 Skill 구조

Base Skill은 프로젝트에 전체 복제하지 않는다.

```text
Foundation·공용 Skill Registry
→ trigger로 주 책임 최대 1개 선택
→ 필요한 지원 Skill만 제한 선택
→ 프로젝트 분야 Skill·로컬 전문 Skill 우선
→ Base 공용 책임은 exact pin 또는 승인된 compatible current에서 읽기
```

이번 감사에 맞는 라우팅:

| 책임 | 선택 |
|---|---|
| 주 Work Mode | REVIEW |
| 프로젝트 주 분야 | urban-legend-qa / repository-wide-audit |
| 적대적 공격 | running-adversarial-review-and-refinement |
| 운영체계 인벤토리 | managing-game-project-operating-system / audit |
| 승인·Sheet 동기화 | managing-design-documents / update·validate |
| 기획 질문 | brainstorming·intake 원칙, 중요 결정만 한 번에 하나 |

### 3.3 Base 공통 작업 루프

```text
BASELINE_RECOVERY
→ DUPLICATE_OMISSION_CONFLICT_AUDIT
→ EVIDENCE_PACK
→ APPROVAL_BUNDLE
→ CANONICAL_UPDATE
→ PROPAGATION_AUDIT
→ VALIDATION
→ GATE_CLOSE
```

현재 urban-legend는 `APPROVAL_BUNDLE → CANONICAL_UPDATE`까지 완료했고, `PROPAGATION_AUDIT → VISUAL VALIDATION` 구간에 있다.

### 3.4 승인 동기화 원칙

승인 직후 같은 단위로 다음을 맞춘다.

```text
Decision ID
→ GitHub 상세 책임 원본
→ 승인 Decision 문서
→ 현재 상태·작업 순서
→ 프로젝트 Sheet 관련 탭
→ 02_현재_확정결정
→ 99_변경이력
→ Commit·행 재조회
```

이번 A~G 패키지는 이 계약에 따라 승인 정본과 Sheet 확정결정에 반영됐다.

### 3.5 이미지 운영 원칙

기획 시각화는 제품 에셋이 아니다.

```text
PLANNED
→ GENERATED_EXPLORATION
→ IN_REVIEW
→ REVISION_REQUIRED | REJECTED | APPROVED_CANDIDATE
```

현재 SCREEN/SIT 보드는 `READY_FOR_GENERATION`이며, 생성 뒤에도 `GENERATED_EXPLORATION / IN_REVIEW` 상태로 검수해야 한다.

## 4. 프로젝트의 실제 Base 채택 상태

### 4.1 현재 채택선

프로젝트의 사람용 Base 문서는 다음을 선언한다.

- core pin: `c987647d01ad2baa028a16e03d85ddfc1572a727`
- core 활성 Skill: 25개
- shared extension 별도 채택
- Vertical Slice Prompt: v8

반면 현재 Adapter·생성 운영 뷰는 Base v9.1을 선언하며 27개 Base route와 10개 프로젝트 분야 route를 유지한다.

### 4.2 최신 Base와의 차이

| 계층 | 프로젝트 선언 | Base 원격 최신 |
|---|---|---|
| 사람용 버전 문서 | core pin c987… / 25개 | v9.3 released / 27개 |
| canonical adapter | Base v9.1 | Base v9.3 compatible current |
| Vertical Slice Prompt | v8 | v9 계열 존재 |
| migration work | PR #120 Draft/HOLD | v9.3 릴리스 가능 |

### 4.3 판정

`CANON_CONFLICT`를 즉시 자동 수정하지 않는다.

이유:

- PR #120이 이미 같은 Base v9.3 이관 Goal을 소유한다.
- `D-2026-08-01-LEGACY-PR-DISPOSITION`이 PR #120을 기획 최종 승인 전 HOLD로 지정했다.
- 현재 PR #122는 제품 기획 정렬을 소유하며 Base Adapter·생성 뷰를 변경하지 않는다.
- 두 PR을 동시에 진행하면 protected baseline·generated view·Sheet 상태가 다시 분기될 수 있다.

판정:

```text
현재 v9.1 project adapter: KEEP_CURRENT
Base v9.3 PR #120: HOLD_EXISTING_WORK
새 Base 이관 PR 생성: PROHIBITED_DUPLICATE_WORK
재평가 시점: PR #122 최종 기획·Canon Pass 완료 후
```

사용자 결정이 필요한 질문은 하나다.

> 최종 기획 승인 뒤 PR #120을 최신 main에 맞춰 재작성·재검증하여 Base v9.3을 채택할 것인가?

권장안은 **기획 PR #122와 Canon Pass를 먼저 완료한 뒤 PR #120을 재평가**하는 것이다.

## 5. 프로젝트 진행도 복원

### 5.1 현재 구현

`CURRENT_IMPLEMENTATION_LEGACY`:

- CORE-MVP-001 저승역 사건 기반
- ANNUAL-MVP-001/002 4주×7일 PoC
- 동료·장비·연구·지원·저장 복귀
- 반일 준비·기존 조사·회수 4패턴·단일 결과 등급
- 기존 mvp-039 저장과 Scene 경로 이어하기
- 일부 자동·시각 QA 증거

사람 장시간 사용성·신규 플레이어 검증은 `NOT_RUN`이다.

### 5.2 승인된 목표

`APPROVED_TARGET_NOT_IMPLEMENTED`:

```text
무인 메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 사건 가설
→ 시간순 증거
→ 안전 노선 복원
→ 회수 2패턴
→ 결과 4축·최소 환류
→ 메인 복귀
```

기준 화면:

- SCREEN-01~07

전문 절차:

- 사건 가설
- 시간순 증거
- 안전 노선 복원
- 회수 2패턴

### 5.3 현재 Gate

```text
A~G 기획 승인: COMPLETE
GitHub Decision 동기화: COMPLETE
Sheet 확정결정 동기화: COMPLETE
SCREEN/SIT 정적 적대적 검토: PASS_FOR_USER_REVIEW
비주얼 보드: IN_PROGRESS
이미지 중간점검: NOT_RUN
최종 플레이테스트 패키지: PENDING
상위 정본 Canon Pass: BLOCKED_BY_VISUAL_AND_FINAL_APPROVAL
Codex Goal: HOLD
제품 구현: NOT_AUTHORIZED
```

## 6. 적대적 Finding Ledger

### F-OPS-001 — Base 버전 권위 다층화

- 심각도: P1 운영
- 유형: `CANON_CONFLICT / USER_DECISION_REQUIRED`
- 증거: `BASE_RULES_VERSION`, `PROJECT_BASE_ADAPTER`, `PROJECT_PATH_ADAPTER`, PR #120, Base v9.3 lock
- 위험: 25/27 Skill 수, v8/v9 Prompt, protected baseline이 서로 다른 세대를 가리킴
- 처리: 현행 v9.1 유지, PR #120 HOLD, 최종 기획 뒤 단일 재평가
- 상태: `CONTAINED_NOT_RESOLVED`

### F-OPS-002 — 상위 정본이 Legacy 시간·전투 계약을 CURRENT처럼 표시

- 심각도: P1 기획 권위
- 유형: `CANON_CONFLICT`
- 경로:
  - `docs/CURRENT_STATUS.md`
  - `docs/PROJECT_CORE.md`
  - `docs/GAME_DESIGN_DOCUMENT.md`
  - `MVP_ROADMAP.md`
- 충돌:
  - 주간 일괄 편성·중요 반일
  - 회수 4패턴·기존 전투
  - 반일 준비 복귀
  - 새 승인 일일 일정·회수 2패턴·결과 4축
- 처리: `CANON-MIGRATION-2026-08-01`에 따라 최종 기획 승인 뒤 단일 Canon Pass
- 상태: `KNOWN_CANON_DEBT / DEFERRED_BY_APPROVED_GATE`

### F-OPS-003 — Documentation Map·planning README·Roadmap의 활성 트랙 불일치

- 심각도: P1 콜드 스타트
- 유형: `STALE_REFERENCE`
- 관찰:
  - Documentation Map은 ANNUAL-MVP-001 PLAN_PENDING_APPROVAL 문구를 유지
  - planning README는 CORE-MVP-001을 유일 활성 구현 트랙으로 설명
  - Roadmap은 이미 병합된 PR #89를 병합 대기로 표시하는 구간이 존재
  - 최신 승인 Validation 기획 경로가 최상위 기본 읽기에 연결되지 않음
- 처리: 최종 Canon Pass에서 등록된 활성 문서 전부 같은 상태로 갱신
- 임시 복구: 본 감사와 PR #122 설명에서 최신 Gate를 제공
- 상태: `DEFERRED_MUST_FIX_BEFORE_MERGE_READY`

### F-OPS-004 — 이전 화면 권위의 사후 정산 경로가 최신 종료 계약과 충돌

- 심각도: P1
- 유형: `MISSING_SUPERSESSION`
- 이전: 결과 → preparation_scene 사후 정산
- 최신: SCREEN-04 완료 → 메인 복귀
- 처리: `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY`를 `SUPERSEDED_IN_PART`로 갱신
- 상태: `FIXED_ON_BRANCH`

### F-OPS-005 — Sheet 작업순서·콘텐츠의 회수 상태가 승인 전으로 남음

- 심각도: P1 동기화
- 유형: `SHEET_OUTDATED`
- 경로:
  - `01_작업순서` 회수 행
  - `50_메인콘텐츠` 회수 행
  - 일부 플레이테스트 문구
- 처리: 같은 Decision ID로 승인 상태 갱신
- 상태: `FIX_IN_CURRENT_SYNC_PASS`

### F-OPS-006 — Sheet 허브·GDD 요약·제품 Gate가 ANNUAL-MVP-002에 고정

- 심각도: P1 사용자 작업면
- 유형: `SHEET_OUTDATED`
- 위험: 사용자가 현재 다음 작업을 가설 보드 사람 검증 또는 ANNUAL 제품 검증으로 오해
- 현재 실제 Gate: SCREEN/SIT 비주얼 중간점검
- 처리: 승인 패키지 ID로 Hub·GDD 요약·제품 방향·Demo 목표·Milestone에 현재 Target 행 추가
- 상태: `FIX_IN_CURRENT_SYNC_PASS`

### F-OPS-007 — Sheet의 Legacy 행과 Target 행이 상태 표기 없이 병존

- 심각도: P1
- 유형: `CANON_CONFLICT`
- 예:
  - 12_핵심루프의 연간 준비
  - 15_조작의 주간 일정
  - 20_데모목표의 4주 완료
  - 30_Demo 범위의 ANNUAL Slice
- 처리: 기존 행을 삭제하지 않고 `CURRENT_IMPLEMENTATION_LEGACY`, 신규 행을 `APPROVED_TARGET_NOT_IMPLEMENTED`로 구분
- 상태: `PARTIAL / CURRENT_SYNC_PASS_REQUIRED`

### F-OPS-008 — PR #122 설명이 A~G 승인 전 상태를 유지

- 심각도: P1 추적
- 유형: `GITHUB_OUTDATED`
- 관찰: 본문에 `DRAFT_REQUIRES_USER_REVIEW`, old head, 02 미등록이라고 표기
- 처리: 승인 Decision·현재 head·Sheet 범위·다음 Visual Gate로 갱신
- 상태: `FIX_IN_CURRENT_SYNC_PASS`

### F-OPS-009 — 이미지 계획은 승인됐으나 검수 로그 행 부재

- 심각도: P2
- 유형: `MISSING_CONSUMER`
- 경로: `72_이미지검수_승인로그`
- 처리: UL-IMG-007의 생성 전 상태와 생성 후 검수 결과를 기록
- 상태: `VISUAL_GATE_ACTIVE`

### F-OPS-010 — 결과 4축 첫 화면 과밀 위험

- 심각도: P2 UX
- 유형: `VISUAL_TEST_REQUIRED`
- 공격:
  - 4축 + 등급 + 이유 + 환류를 한 화면에 모두 펼치면 보고서형 과밀 발생
- 최소 보정:
  - 첫 화면은 축 상태명 + 한 문장 이유
  - 상세 근거·보고서·해금은 접기
- 상태: `OPEN_FOR_VISUAL_REVIEW`

### F-OPS-011 — 회수 중립 행동의 정답 모양 위험

- 심각도: P2 공정성
- 유형: `HUMAN_TEST_REQUIRED`
- 공격:
  - 스피커 전원 차단, 투명 보관함이 기록을 읽지 않아도 가장 안전해 보일 수 있음
- 검증:
  - 행동 라벨만 본 선택률과 기록을 읽은 선택률 분리
- 상태: `OPEN_FOR_VISUAL_AND_HUMAN_REVIEW`

### F-OPS-012 — Legacy와 Validation 이어하기 구분 부족

- 심각도: P2 UX
- 유형: `VISUAL_TEST_REQUIRED`
- 최소 보정:
  - 이어하기 행에 `기존 진행` / `Validation 기록` 상태 표시
- 상태: `OPEN_FOR_VISUAL_REVIEW`

### F-OPS-013 — 다일 활동 강제 출동 규칙의 이해 비용

- 심각도: P2 일정 UX
- 유형: `VISUAL_TEST_REQUIRED`
- 승인 규칙:
  - 다음 날짜 경계 중단
  - 완료 일수 보존
  - 남은 일수 재배치
- 위험: 일정 블록이 삭제·실패한 것으로 보일 수 있음
- 최소 보정: `중단됨 · 2/3 완료 · 복귀 후 1일 재배치` 표시
- 상태: `OPEN_FOR_VISUAL_REVIEW`

### F-OPS-014 — 중요하지 않은 일상 활동 재팽창 위험

- 심각도: P2 범위
- 유형: `REGRESSION_RISK`
- 보호:
  - 주요 활동 1개
  - 기본 휴식 자동
  - 세부 식사·취미·산책·기록 습관 카탈로그 금지
- 상태: `PROTECTED_BY_DECISION`

### F-OPS-015 — 비핵심 기능이 화면만 숨고 상태를 변경할 위험

- 심각도: P1 구현 계약
- 유형: `IMPLEMENTATION_CONFLICT_RISK`
- 보호:
  - 랜덤·의뢰·시장·일상·전체 운영·패턴 3/4는 판정·난수·로그·자원·저장 변경 금지
- 상태: `APPROVED_NOT_IMPLEMENTED`

## 7. 즉시 보정과 보류 경계

### 즉시 보정

- 승인 Decision·Sheet 확정결정 동기화
- 이전 Decision 대체 관계
- Sheet 회수 상태
- Sheet Hub·현재 Gate·Demo Target
- PR #122 설명·head·다음 Gate
- 이미지 검수 로그 준비 행
- 본 감사 Review ID와 변경이력

### 최종 Canon Pass까지 보류

- `PROJECT_CORE.md` 전체 개정
- `CURRENT_STATUS.md` 활성 계약 교체
- GDD 본문 전체 정렬
- Documentation Map 기본 라우팅 교체
- planning README·Roadmap·Handoff 최종 정렬
- 테스트의 Legacy/Target 책임 재분류

보류 이유는 누락이 아니라 승인된 순서다.

```text
비주얼 보드
→ 이미지 중간점검
→ 플레이테스트 패키지
→ 사용자 기획 최종 승인
→ 단일 Canon Pass
```

## 8. 남은 기획

### P0 — 지금

1. SCREEN 보드 A
2. SCREEN 보드 B
3. SIT 보드 C1~C4
4. 이미지 적대적 중간점검

### P0 — 이미지 승인 뒤

5. Validation 플레이테스트 패키지 통합
6. 회수 문구 공정성 과제
7. 결과 4축 이해·보상감 과제
8. 이어하기·실패 복구·다일 중단 과제
9. 최종 기획 적대적 검토

### P0 — 사용자 최종 승인 뒤

10. 상위 정본 단일 Canon Pass
11. Legacy/Target 테스트 책임표
12. Save Schema 변경 제안서
13. writing-plans
14. Codex Goal

### 별도 사용자 결정

15. Base v9.3 PR #120 재개·폐기·재작성 시점

권장: 10번 Canon Pass까지 끝낸 뒤 재평가한다.

## 9. 삭제·통합·신규 생성 판정

- 기존 ANNUAL·CORE·사람 검증 문서 삭제: `NO`
- 기존 PoC 테스트 삭제: `NO`
- 구형 저장 강제 변환: `NO`
- PR #120 병합·cherry-pick: `NO / HOLD`
- 새 Base migration PR 생성: `NO / DUPLICATE_WORK`
- 계획 PR #122 재사용: `YES`
- 승인 Decision 문서 추가: `YES / COMPLETED`
- Visual board 생성: `YES / CURRENT_GATE`

## 10. 검증 계획

### 현재 작업

- GitHub Decision·Sheet 행 재조회
- PR #122 current head·Draft·mergeable 확인
- main 대비 changed files가 문서 범위인지 확인
- Documentation contracts
- BCA Adoption
- 이미지 생성 후 시각 적대적 검토

### 구현 이후

- Godot import
- focused Validation flow tests
- Legacy mvp-039 회귀
- Save checkpoint restart matrix
- 1280×720·1920×1080 keyboard/pointer
- 사람 플레이

현재 구현 검증은 `NOT_RUN`이다.

## 11. 감사 판정

| 영역 | 판정 |
|---|---|
| Base 구조 이해 | PASS |
| Base 최신/프로젝트 채택선 분리 | PASS_WITH_USER_DECISION_DEFERRED |
| 프로젝트 책임·진행도 복원 | PASS |
| Sheet 27개 탭 감사 | PASS |
| 승인 A~G GitHub·Sheet 반영 | PASS_PENDING_FINAL_READBACK |
| stale 상위 정본 | KNOWN_CANON_DEBT |
| 즉시 추적 보정 | IN_PROGRESS |
| Visual board | IN_PROGRESS |
| Runtime | NOT_RUN |
| Human validation | NOT_RUN |
| Build readiness | BLOCKED |

## 12. 다음 Gate

```text
즉시 보정·재조회
→ SCREEN/SIT 보드 A·B·C1~C4 생성
→ 이미지 적대적 중간점검
→ Visual Decision·Sheet 72 로그
→ 플레이테스트 패키지
→ 사용자 기획 최종 승인
→ 상위 정본 단일 Canon Pass
→ Base v9.3 PR #120 재평가
→ writing-plans
→ 마지막에 Codex Goal
```
