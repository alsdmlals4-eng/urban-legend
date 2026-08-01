# Base·프로젝트 GitHub·GDD Sheet 운영체계 적대적 감사 — 2026-08-01

> Review ID: `R-2026-08-01-BASE-PROJECT-SHEET-OPERATING-AUDIT`
> 상태: `REVIEW_COMPLETE / RECOMMENDATIONS_APPROVED / VISUAL_GATE_ACTIVE / NOT_BUILD_READY`
> 승인 연결: `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL`
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

다음을 하나의 영향 지도에서 대조했다.

1. Base 최신 운영체계·Skill 구조
2. urban-legend가 실제 채택한 Base 버전·Adapter·프로젝트 Skill
3. 프로젝트 상위 정본·계획·실제 제품·테스트 상태
4. Google GDD Sheet 27개 탭의 Decision·상태·다음 작업
5. Validation A~G 승인 패키지의 전파 누락
6. 다음 시각·검증·정본 이관 순서

`전부 확인`은 모든 파일을 무차별 적재하는 뜻이 아니다. Base와 프로젝트가 선언한 `START_HERE → Documentation Map → Registry → 책임 원본 → 실제 소비처 → 테스트` 경로로 전체 책임을 추적했다.

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
- 관련 적대적 검토·운영체계·문서 관리 Skill 전문

### 프로젝트

- `START_HERE.md`, `AGENTS.md`
- `docs/BASE_RULES_VERSION.md`
- `docs/CURRENT_STATUS.md`
- `docs/PROJECT_CORE.md`
- `docs/GAME_DESIGN_DOCUMENT.md`
- `docs/DOCUMENTATION_MAP.md`
- `docs/planning/README.md`
- `MVP_ROADMAP.md`
- `skills/SKILL_REGISTRY.json`
- `skills/PROJECT_BASE_ADAPTER.json`
- `skills/PROJECT_PATH_ADAPTER.json`
- 열린 PR #120·#122와 최근 병합 PR
- 승인 Decision·SCREEN/SIT Spec·저장 계획·적대적 검토
- 기존 전체 제품 감사에서 확인한 Scene·Script·JSON·테스트 경로

### Google Sheet

Spreadsheet ID:

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

### 릴리스 계층

```text
사람용 안정 기준: v9.0.0 RELEASED
현재 호환 운영선: v9.3.0 RELEASED
기계 잠금: base-v9.3.lock.json
활성 Skill 권위: skills/SKILL_REGISTRY.json
선택 라우팅: START_HERE + Documentation Map + Registry trigger
```

v9.3 잠금:

- candidate release commit: `30ca6c7b5f93521f0eb0eed42d01437cd43c50ae`
- evidence commit: `462a86db192d23d0f386281a1eb54b0a8cbad62e`
- 활성 Skill: 27개

### Skill 구조

```text
프로젝트 분야·로컬 Skill 우선
→ trigger로 주 책임 최대 1개
→ 필요한 Foundation·검증·발행 Skill만 제한 선택
→ Base 공용 Skill 본문 전체 복제 금지
→ exact pin 또는 승인된 compatible current 사용
```

이번 작업의 실제 라우팅:

| 책임 | 선택 |
|---|---|
| 주 Work Mode | REVIEW |
| 프로젝트 주 분야 | urban-legend-qa / repository-wide-audit |
| 적대적 공격 | running-adversarial-review-and-refinement |
| 운영체계 인벤토리 | managing-game-project-operating-system / audit |
| 승인·Sheet 동기화 | managing-design-documents / update·validate |

### 공통 작업 루프

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

현재 프로젝트는 `CANONICAL_UPDATE → PROPAGATION_AUDIT → VISUAL VALIDATION` 구간에 있다.

## 4. 프로젝트 Base 채택 상태

### 현재 선언

- 사람용 core pin: `c987647d01ad2baa028a16e03d85ddfc1572a727`
- 사람용 core 활성 Skill: 25개
- shared extension 별도 채택
- Vertical Slice Prompt: v8
- canonical Adapter: Base v9.1
- 생성 운영 뷰: 27개 Base route + 10개 프로젝트 분야 route

### Base 원격 최신과 차이

| 계층 | 프로젝트 | Base 최신 |
|---|---|---|
| 사람용 버전 | core c987… / 25개 | v9.3 / 27개 |
| Adapter | v9.1 | v9.3 compatible current |
| Vertical Slice | v8 | v9 계열 |
| migration | PR #120 Draft/HOLD | 이관 가능 |

### 승인된 처리

`D-2026-08-01-RECOMMENDED-BATCH-APPROVAL`에 따라 다음을 확정했다.

```text
현재 v9.1 Adapter: KEEP_CURRENT
PR #120: DRAFT_HOLD
새 Base migration PR: PROHIBITED_DUPLICATE_WORK
병합·cherry-pick: PROHIBITED_BEFORE_CANON_PASS
재평가 시점: PR #122 최종 기획·상위 정본 Canon Pass 완료 뒤
```

이 결정은 Base v9.3을 기각한 것이 아니라 **제품 기획 정본을 먼저 고정한 뒤 단일 이관**하도록 순서를 확정한 것이다.

## 5. 프로젝트 진행도 복원

### 현재 구현

`CURRENT_IMPLEMENTATION_LEGACY`:

- CORE-MVP-001 저승역 사건
- ANNUAL-MVP-001/002 4주×7일 PoC
- 동료·장비·연구·지원·저장 복귀
- 기존 반일 준비·조사·회수 4패턴·단일 결과 등급
- 본편 `mvp-039`와 별도 ANNUAL 저장
- 일부 자동·시각 QA 증거

사람 장시간 사용성·신규 플레이어 검증은 `NOT_RUN`이다.

### 승인 Target

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

- 기준 화면: SCREEN-01~07
- 전문 절차: 사건 가설 / 시간순 증거 / 안전 노선 복원 / 회수 2패턴
- Legacy 저장 강제 변환 금지
- 제품 구현 권한 없음

## 6. Finding Ledger

### F-OPS-001 — Base 버전 권위 다층화

- 심각도: P1 운영
- 유형: `CANON_CONFLICT`
- 위험: 25/27 Skill, v8/v9 Prompt, protected baseline이 서로 다른 세대를 가리킴
- 권장 처리: v9.1 유지, PR #120 HOLD, Canon Pass 뒤 단일 재평가
- 승인 상태: `RESOLVED_SEQUENCE_APPROVED`

### F-OPS-002 — 상위 정본의 Legacy 시간·회수 계약

- 심각도: P1 기획 권위
- 유형: `KNOWN_CANON_DEBT`
- 경로:
  - `docs/CURRENT_STATUS.md`
  - `docs/PROJECT_CORE.md`
  - `docs/GAME_DESIGN_DOCUMENT.md`
  - `MVP_ROADMAP.md`
- 처리: 비주얼·플레이테스트·최종 승인 뒤 단일 Canon Pass
- 상태: `DEFERRED_BY_APPROVED_GATE`

### F-OPS-003 — 콜드 스타트 문서의 활성 트랙 불일치

- 심각도: P1
- 유형: `STALE_REFERENCE`
- 관찰:
  - Documentation Map의 과거 PLAN_PENDING 문구
  - planning README의 과거 단일 활성 트랙
  - Roadmap의 병합 대기·완료 상태 혼재
  - 최신 Validation 흐름이 기본 읽기에 미연결
- 처리: Canon Pass에서 같은 상태로 일괄 정렬
- 상태: `MUST_FIX_BEFORE_MERGE_READY`

### F-OPS-004 — 결과 뒤 사후 정산 경로 충돌

- 심각도: P1
- 유형: `MISSING_SUPERSESSION`
- 이전: 결과 → preparation_scene 사후 정산
- 최신: SCREEN-04 완료 → 메인 복귀
- 처리: `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY`를 `SUPERSEDED_IN_PART`로 갱신
- 상태: `FIXED_ON_BRANCH`

### F-OPS-005 — Sheet 회수 상태가 승인 전으로 잔존

- 심각도: P1
- 유형: `SHEET_OUTDATED`
- 처리:
  - `01_작업순서`
  - `50_메인콘텐츠`
  - `80_플레이테스트`
- 상태: `FIXED_PENDING_READBACK`

### F-OPS-006 — Sheet 현재 Gate가 ANNUAL 사람 검증에 고정

- 심각도: P1
- 유형: `SHEET_OUTDATED`
- 처리:
  - `00_프로젝트_허브`
  - `05_GDD_요약`
  - `10_제품방향`
  - `20_코어경험_데모목표`
  - `30_데모범위`
  - `90_본제작_출시_사업`
- 상태: `FIXED_PENDING_READBACK`

### F-OPS-007 — Legacy와 Target의 상태 혼합

- 심각도: P1
- 유형: `CANON_CONFLICT`
- 처리:
  - 기존 행 삭제 금지
  - 기존 구현은 `CURRENT_IMPLEMENTATION_LEGACY`
  - 새 기획은 `APPROVED_TARGET_NOT_IMPLEMENTED`
- 상태: `PARTIAL_FIXED / CANON_PASS_REQUIRED`

### F-OPS-008 — PR #122 설명의 승인 전 상태

- 심각도: P1
- 유형: `GITHUB_OUTDATED`
- 처리: 최신 승인·HEAD·Sheet 범위·Visual Gate로 교체
- 상태: `IN_PROGRESS`

### F-OPS-009 — UL-IMG-007 검수 소비처 누락

- 심각도: P2
- 유형: `MISSING_CONSUMER`
- 처리: `72_이미지검수_승인로그`에 생성 전 행 등록
- 상태: `FIXED_PENDING_READBACK`

### F-OPS-010 — 결과 4축 화면 과밀

- 심각도: P2 UX
- 위험: 4축 + 등급 + 근거 + 환류를 한 화면에 펼치면 문서 대시보드화
- 최소안:
  - 첫 화면은 축 상태명 + 한 문장 이유
  - 상세 근거·보고서·해금은 접기
- 상태: `OPEN_FOR_VISUAL_REVIEW`

### F-OPS-011 — 회수 행동의 정답 모양

- 심각도: P2 공정성
- 위험: 기록을 읽지 않아도 가장 안전해 보이는 행동 선택
- 검증: 라벨만 본 선택률과 기록 확인 뒤 선택률 분리
- 상태: `OPEN_FOR_VISUAL_AND_HUMAN_REVIEW`

### F-OPS-012 — Legacy/Validation 이어하기 구분

- 심각도: P2 UX
- 최소안: `기존 진행` / `Validation 기록` 상태를 텍스트로 구분
- 상태: `OPEN_FOR_VISUAL_REVIEW`

### F-OPS-013 — 다일 활동 강제 출동 이해 비용

- 심각도: P2 일정 UX
- 최소안: `중단됨 · 2/3 완료 · 복귀 후 1일 재배치`
- 상태: `OPEN_FOR_VISUAL_REVIEW`

### F-OPS-014 — 일상 활동 재팽창

- 심각도: P2 범위
- 보호:
  - 하루 주요 활동 1개
  - 기본 휴식 자동
  - 식사·취미·산책 등 일상 카탈로그 금지
- 상태: `PROTECTED_BY_DECISION`

### F-OPS-015 — 숨긴 기능의 백그라운드 부작용

- 심각도: P1 구현 계약
- 보호: 비노출 기능은 판정·난수·로그·자원·저장을 변경하지 않는다.
- 상태: `APPROVED_NOT_IMPLEMENTED`

## 7. 즉시 보정과 보류 경계

### 즉시 보정

- 승인 Decision·Sheet 확정결정 동기화
- 화면 권위 대체 관계
- Sheet 회수·현재 Gate·Demo Target
- PR #122 설명·HEAD·다음 Gate
- UL-IMG-007 생성 전 검수 행
- 본 Review와 승인 위임의 변경이력

### Canon Pass까지 보류

- `PROJECT_CORE.md`
- `GAME_DESIGN_DOCUMENT.md`
- `CURRENT_STATUS.md`
- `DOCUMENTATION_MAP.md`
- `planning/README.md`
- `MVP_ROADMAP.md`
- `TEST_CHECKLIST.md`
- `CURRENT_HANDOFF.md`

보류는 누락이 아니라 승인된 순서다.

```text
비주얼 보드
→ 이미지 중간점검
→ 플레이테스트 패키지
→ 사용자 기획 최종 승인 상태 기록
→ 단일 Canon Pass
```

## 8. 남은 기획·검증

### P0 — 현재

1. SCREEN 보드 A
2. SCREEN 보드 B
3. SIT 보드 C1~C4
4. 이미지 적대적 중간점검

### P0 — 이미지 뒤

5. Validation 플레이테스트 패키지 통합
6. 회수 문구 공정성 과제
7. 결과 4축 이해·보상감 과제
8. 이어하기·실패 복구·다일 중단 과제
9. 최종 기획 적대적 검토

### P0 — 최종 기획 승인 뒤

10. 상위 정본 단일 Canon Pass
11. Legacy/Target 테스트 책임표
12. Save Schema 변경 제안서
13. Base v9.3 PR #120 재평가
14. writing-plans
15. Codex Goal

## 9. 변경 판정

- 기존 ANNUAL·CORE·사람 검증 문서 삭제: `NO`
- 기존 PoC 테스트 삭제: `NO`
- 구형 저장 강제 변환: `NO`
- PR #120 병합·cherry-pick: `NO / HOLD`
- 새 Base migration PR 생성: `NO / DUPLICATE_WORK`
- Draft PR #122 재사용: `YES`
- 승인 Decision 문서: `YES / UPDATED`
- Visual board 생성: `YES / CURRENT_GATE`

## 10. 검증 상태

| 영역 | 판정 |
|---|---|
| Base 구조 이해 | PASS |
| Base 최신/프로젝트 채택선 분리 | PASS |
| Base v9.3 순서 결정 | APPROVED |
| 프로젝트 진행도 복원 | PASS |
| Sheet 27개 탭 감사 | PASS |
| A~G GitHub 승인 정본 | PASS |
| Sheet 상태 보정 | APPLIED_PENDING_READBACK |
| stale 상위 정본 | KNOWN_CANON_DEBT |
| 비주얼 보드 | IN_PROGRESS |
| Runtime | NOT_RUN |
| Human validation | NOT_RUN |
| Build readiness | BLOCKED |

## 11. 다음 Gate

```text
Sheet·GitHub 재조회
→ PR #122 설명·Issue #121 승인 기록
→ SCREEN/SIT 보드 A·B·C1~C4 생성
→ 이미지 적대적 중간점검
→ UL-IMG-007 검수 로그
→ 플레이테스트 패키지
→ 최종 기획 적대적 검토
→ 사용자 기획 최종 승인 상태 기록
→ 상위 정본 Canon Pass
→ Base v9.3 PR #120 재평가
→ writing-plans
→ 마지막에 Codex Goal
```
