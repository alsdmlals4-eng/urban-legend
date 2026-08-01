# D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL — Validation 기획 최종 승인

> 상태: `APPROVED_FINAL_PLANNING_BASELINE`
> 승인일: 2026-08-01
> 사용자 승인 근거: `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL`
> 검토 근거: `R-2026-08-01-VALIDATION-PLANNING-FINAL-ADVERSARIAL`
> 추적: Issue #121 / Draft PR #122
> Canon Pass: `AUTHORIZED`
> 제품 구현 권한: `NONE`
> Runtime / Human QA: `NOT_RUN`
> Codex Build: `HOLD`

## 1. 최종 결정

괴이기록국 Validation Cut의 화면·상황·사건 추리·회수·결과·저장·테스트 기획을 최종 기준선으로 승인한다.

```text
SCREEN-01 무인 메인
→ SIT-001 저승역 콜드 오픈
→ SIT-002 기록국 브리핑
→ SIT-003 축약 준비
→ SIT-004 텍스트 노벨 조사
→ SIT-005 사건 가설·시간순 증거
→ SIT-006 안전 노선 복원
→ SIT-007 회수 2패턴
→ SIT-008 결과 4축·최소 환류
→ SCREEN-01 메인 복귀
```

## 2. 승인 구성

### 화면

- 기준 화면 7개
- 전문 절차 4개는 SCREEN-02 아래 흐름
- 일반 플레이는 텍스트 노벨 방식
- 메인은 무인 공간 중심
- 준비는 축약 모드
- 결과는 원시 4축 우선
- 일정·연구·보급은 제품 기준 화면이지만 Validation에서는 전체 화면 비노출

### 사건 추리

- 가설 4개 중 관측 근거로 2개 제거
- `23:57:42 개인 목적지 청취 < 23:59:08 검은 승차권 최초 접촉`
- 공백 투사설 지지
- 승차권 최초 원인 주장 반박
- 승차권 현장 매개 역할 미해결
- 원인과 매개 역할 분리

### 회수

```text
전조
→ 분류
→ 관련 기록
→ 중립 행동
→ 현장 결과
→ 추론 검증
```

- 회수 패턴 2개
- 패턴당 첫 오대응 뒤 복구 1회
- 두 번째 실패도 위험 사례 후 결과 진행
- 능력치·확률·동료 정답 예측 비노출

### 결과

원시 축:

1. 현장 안정화
2. 피해자 구조
3. 규칙 검증
4. 괴이 핵·잔향 회수

요약:

- 미해결
- 임시 안정화
- 제한적 해결
- 완전 해결

규칙 미검증·반박이면 `임시 안정화` 상한이다.

### 저장·복귀

- Legacy `mvp-039` 보존
- Validation `flow_stage → checkpoint → return target → scene fallback`
- 안정 ID 사용
- 로드 시 피해·보상·보고서·결과 축 중복 금지
- Legacy와 Validation 병렬 회귀

### 일정

- 하루 주요 활동 1개
- 기본 휴식 자동 소량 회복
- 전일 회복·치료는 주요 활동
- 2~3일 활동은 같은 주 연속 날짜 점유
- 강제 출동은 날짜 경계에서 중단
- 완료 일수 보존, 남은 일수 재배치
- 같은 날 반일 분할 없음

## 3. 시각 승인 경계

- `UL-IMG-007` 6개 보드: `APPROVED_PLANNING_VISUALIZATION`
- 제품 자산: `NOT_APPROVED`
- Wireframe Placeholder를 최종 캐릭터·배경·UI 에셋으로 사용 금지
- 오생성 감사 대시보드 2개: `REJECTED_WRONG_ARTIFACT_TYPE`
- 1280×720·실제 Runtime·최종 아트: `NOT_RUN`

## 4. 열린 P2

다음은 기획 승인 차단 사유가 아니라 플레이테스트·Runtime Gate다.

- Legacy/Validation 이어하기 구분
- 기록 HUD 발견성
- 회수 행동의 정답 모양
- 원인/매개 역할 설명 난이도
- 결과 4축 회상·등급 상한 이해
- 다일 활동 중단 이해
- 1280×720 한국어 가독성
- 최종 캐릭터·배경·UI 에셋

모든 항목은 `PT-2026-08-01-VALIDATION-SCREEN-SIT`에 과제·지표·중단 기준이 있다.

## 5. 승인된 정본 이관

Canon Pass에서 다음을 수행한다.

- 최신 승인 Decision 복원 원본 설치
- Validation Target 상세 정본 설치
- START_HERE·Documentation Map·기획 인덱스의 권위 순서 갱신
- CURRENT 구현과 승인 Target 분리
- Legacy 구현·테스트·저장 증거 보존
- 구형 결과 복귀·회수 4패턴·반일 준비를 Target 권위에서 격리
- Google Sheet Decision·상태·경로·Commit 재동기화

## 6. 승인되지 않은 것

- GDScript·Scene·JSON·Resource·에셋 구현
- Save Schema 실제 변경
- 기존 구현·테스트·저장 삭제
- PR #120 병합·cherry-pick
- Base v9.3 즉시 이관
- Runtime·사람 플레이 통과 선언
- `POC_PASSED`
- 제작 확대
- Codex Build

## 7. 구현 전 다음 순서

```text
상위 정본 Canon Pass
→ reference·상태·Sheet 재검증
→ writing-plans
→ Codex 읽기 전용 기술 Plan
→ CHANGE_PROPOSAL 검수
→ 구현 패키지 승인
→ 마지막에 Codex Build Goal
```

## 8. 연결 문서

- `docs/decisions/D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE.md`
- `docs/decisions/D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS.md`
- `docs/decisions/D-2026-08-01-VALIDATION-RESULT-AXES.md`
- `docs/decisions/D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION.md`
- `docs/visual/UL_IMG_007_VISUAL_REVIEW_2026-08-01.md`
- `docs/validation/VALIDATION_SCREEN_SIT_PLAYTEST_PACKAGE_2026-08-01.md`
- `docs/planning/VALIDATION_PLANNING_FINAL_ADVERSARIAL_REVIEW_2026-08-01.md`
- `docs/planning/CANON_MIGRATION_BUNDLE_2026-08-01.md`

## 9. 최종 상태

```yaml
planning: APPROVED_FINAL_PLANNING_BASELINE
canon_pass: AUTHORIZED
visual_planning: APPROVED_WITH_OPEN_P2
playtest_design: APPROVED
product_implementation: NOT_AUTHORIZED
runtime: NOT_RUN
human_validation: NOT_RUN
codex_build: HOLD
```
