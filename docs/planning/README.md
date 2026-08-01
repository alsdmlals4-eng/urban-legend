# 괴이 기록국 기획 인수인계 인덱스

> 시작: `../../START_HERE.md`
> 현재 승인 결정: `../CURRENT_CONFIRMED_DECISIONS.md`
> 현재 Validation Target: `../VALIDATION_TARGET_CANON.md`
> 현재 구현 상태: `../CURRENT_STATUS.md`
> 장기 코어: `../PROJECT_CORE.md`

이 폴더는 현재 승인 Target, 실제 구현 Legacy, 장기 제품 방향, 검증 Gate를 구분하는 기획 진입점이다.

## 1. 현재 상태

```text
Validation 기획: APPROVED_FINAL_PLANNING_BASELINE
Canon Pass: IN_PROGRESS
제품 구현: NOT_AUTHORIZED
Runtime / Human QA: NOT_RUN
Codex Build: HOLD
```

현재 활성 트랙은 CORE-MVP 또는 ANNUAL 구현이 아니라 **승인 Validation Target의 Canon 정렬과 구현 계획 준비**다.

## 2. 권장 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/DOCUMENTATION_MAP_CURRENT.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ 이 README
→ 현재 작업의 Decision·Spec·Review·Playtest
→ 실제 코드·데이터·Scene·테스트
```

## 3. 현재 책임 원본

| 문서 | 책임 |
|---|---|
| `../CURRENT_CONFIRMED_DECISIONS.md` | 현재 유효한 승인 Decision 복원 |
| `../VALIDATION_TARGET_CANON.md` | Validation 제품 경험·화면·사건·결과·저장·검증 상세 정본 |
| `../DOCUMENTATION_MAP_CURRENT.md` | 현재 문서·Skill 라우팅 |
| `../CURRENT_STATUS.md` | 실제 구현·검증·Legacy 상태 |
| `../PROJECT_CORE.md` | 충돌하지 않는 장기 제품 정체성 |
| `../GAME_DESIGN_DOCUMENT.md` | 충돌하지 않는 장기 상세·현재 구현 Legacy |
| `VALIDATION_PLANNING_FINAL_ADVERSARIAL_REVIEW_2026-08-01.md` | 기획 최종 적대적 검토 |
| `../visual/UL_IMG_007_VISUAL_REVIEW_2026-08-01.md` | 화면·상황 시각 검수 |
| `../validation/VALIDATION_SCREEN_SIT_PLAYTEST_PACKAGE_2026-08-01.md` | 신규 플레이어·저장·접근성 검증 계약 |
| `CANON_MIGRATION_BUNDLE_2026-08-01.md` | Target/Legacy 이관 경계 |
| `ROADMAP_AND_HANDOFF.md` | 장기 단계·교대 원칙 |
| `REFERENCE_CASES.md` | 벤치마크 채택·변형·제외 원리 |

## 4. 현재 Validation 흐름

```text
무인 메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 사건 가설·시간순 증거
→ 안전 노선 복원
→ 회수 2패턴
→ 결과 4축·최소 환류
→ 메인 복귀
```

상세는 `../VALIDATION_TARGET_CANON.md`가 소유한다.

## 5. 기획 판단 우선순위

1. 플레이어가 관측 가능한 기록으로 규칙을 설명하는가
2. 원인과 현장 매개 역할을 구분하는가
3. 가설과 지지·반박·미해결 근거를 직접 연결하는가
4. 조사 지식이 노선·회수 판단으로 변환되는가
5. 행동 성공과 규칙 검증이 결과에서 분리되는가
6. 실패가 소프트락·전체 초기화가 아니라 복구와 위험 사례로 이어지는가
7. 동료·장비·연구·보급이 정답을 대신하지 않는가
8. 숨긴 기능이 백그라운드 상태를 변경하지 않는가
9. Legacy 저장·ID·구현·테스트를 보존하는가
10. 실행하지 않은 Runtime·사람 검증을 통과로 쓰지 않는가

## 6. 현재 시각·테스트

### UL-IMG-007

- 보드 A: SCREEN-01~04
- 보드 B: SCREEN-05~07
- 보드 C1~C4: SIT-001~008
- 상태: `APPROVED_PLANNING_VISUALIZATION / NOT_PRODUCT_ASSET`

열린 P2:

- Legacy/Validation 이어하기 구분
- 기록 HUD 발견성
- 회수 행동 정답 모양
- 원인/매개 설명 난이도
- 결과 4축 회상
- 다일 활동 중단 이해
- 1280×720 한국어 가독성
- 최종 아트

### Playtest Package

- `PT-2026-08-01-VALIDATION-SCREEN-SIT`
- 상태: `APPROVED_TEST_DESIGN / EXECUTION_NOT_RUN`
- 행동 지표·중단 기준·저장 중복·숨긴 기능 무부작용을 포함한다.

## 7. Legacy 보존

다음은 삭제 대상이 아니라 `CURRENT_IMPLEMENTATION_LEGACY`다.

- CORE-MVP-001 실제 구현
- ANNUAL-MVP-001/002 PoC
- preparation_scene 반일 구조
- 기존 회수 4패턴
- 단일 결과 등급·반일 복귀
- market_scene 소문시장
- 본편 `mvp-039`·ANNUAL 저장
- 기존 focused·full regression·visual QA

용도:

- 구현 baseline
- 회귀·롤백
- 저장 호환
- Target과 현재 차이 분석

## 8. 과거 연구·사람 검증 자료

다음은 근거·Artifact이며 현재 Target 정본을 대체하지 않는다.

- `../research/2026-07-29-fair-play-hypothesis-board-evidence-pack.md`
- `../superpowers/plans/2026-07-29-hypothesis-board-human-validation-artifact.md`
- `../research/2026-07-29-hypothesis-board-synthetic-session-execution.md`
- `../research/2026-07-29-hypothesis-board-synthetic-validation-closure.md`
- 기존 CORE·ANNUAL 사람 검증 패키지

상태:

- 합성 검토: T6_AI_INFERENCE
- 실제 사람 검증: NOT_RUN
- 독립 구현 권한: NONE

## 9. 작업별 라우팅

| 작업 | 먼저 읽을 문서 | 검증 핵심 |
|---|---|---|
| Validation 구현 계획 | Current Decisions, Target Canon, 실제 Scene/Script/Test | Target/Legacy 분리·저장·복귀·패키지 순서 |
| 저승역 사건 문구 | Target Canon, 시간순 증거, 회수 Decision | 원인/매개·정답 누설·관측 근거 |
| UI 정보 위계 | Target Canon, UL-IMG-007 Review | 최소 HUD·텍스트 노벨·결과 4축 |
| 저장·복귀 | Save/Test Decision, Playtest T10, 실제 GameState | Legacy 보존·중복0·return target |
| 일정·연구·보급 | Target Canon SCREEN-05~07 | 하루 주요1·정답 비대체·Validation 비노출 |
| 사람 플레이테스트 | Playtest Package | 행동 지표·개입 분리·P2 판정 |
| 아트 브리프 | Visual Art Direction, UL-IMG-007 Review | Placeholder와 제품 에셋 분리 |
| 벤치마킹 | REFERENCE_CASES·최신 1차 출처 | ADOPT/ADAPT/TEST/AVOID |

## 10. 다음 Gate

```text
Canon reference·상태·Sheet 검증
→ writing-plans
→ Codex 읽기 전용 기술 Plan
→ CHANGE_PROPOSAL 검수
→ 구현 패키지 승인
→ 마지막에 Codex Build Goal
```

Base v9.3 PR #120은 Canon Pass 검증 전 `DRAFT_HOLD`다.

## 11. 업데이트 규칙

- 승인 변경은 같은 Decision ID로 Current Decisions·Target/분야 정본·GitHub·Sheet에 즉시 동기화한다.
- 구현 완료와 승인 기획을 혼합하지 않는다.
- Evidence Pack·시각 보드·Playtest 설계는 제품 구현·사람 검증을 대신하지 않는다.
- 기존 구현·저장·테스트·역사 자료를 승인 없이 삭제·축약하지 않는다.
- 플레이 증거 없이 `POC_PASSED`, `PRODUCTION_READY`, 제작 확대를 선언하지 않는다.
