# 괴이기록국 Validation 구현 준비 Roadmap — 2026-08-01

> 상태: `PLANNING_READY / WRITING_PLANS_NEXT / BUILD_NOT_AUTHORIZED`
> 기준 Decision: `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL`
> 제품 Target: `docs/VALIDATION_TARGET_CANON.md`
> 실제 파일 판정: `CODEX_READ_ONLY_PLAN_REQUIRED`

## 1. 목표

현재 Legacy 구현을 삭제하지 않고 승인 Validation Target을 가장 작은 end-to-end 패키지로 순차 이관한다.

## 2. 선행 Gate

- [x] 기획 최종 승인
- [x] Current Decisions 설치
- [x] Validation Target Canon 설치
- [x] 화면·상황 시각 검수
- [x] 플레이테스트 설계
- [ ] Canon reference·상태·Sheet 최종 검증
- [ ] writing-plans
- [ ] Codex 읽기 전용 기술 Plan
- [ ] 기술 CHANGE_PROPOSAL 검수
- [ ] 구현 패키지 승인

## 3. 기술 Plan에서 확인할 실제 책임

- 메인 메뉴·새 기록·이어하기 라우터
- 본편 `GameState`와 Save version·restore
- 현재 사건 flow·checkpoint·Scene path 소유자
- preparation·investigation·가설·노선/미니게임·회수·result Scene
- 저승역 JSON·상태·ID
- ANNUAL PoC 저장과 본편 저장 분리
- 기존 focused·full regression·visual capture
- 비노출 기능의 판정·난수·로그·상태 부작용

정확한 파일 경로는 최신 main을 읽은 Codex Plan이 확정한다. 기획 단계에서 추정 경로를 구현 계약으로 만들지 않는다.

## 4. 권장 패키지 순서

### PACKAGE-01 — Flow·Resume Foundation

플레이어 결과:

- 새 Validation 기록 시작
- `flow_stage` 기반 이어하기
- Legacy 저장 구분·보존
- 정확한 checkpoint·return target 복귀

포함:

- Validation session marker
- 안정 ID
- save/restore 우선순위
- duplicate effect guard
- Legacy fallback

제외:

- 화면 전면 개편
- 사건 규칙 변경
- Base 이관

필수 테스트:

- 단계별 save→restart
- Legacy `mvp-039`
- 잘못된 node 0
- 중복 피해·보상·보고서 0

### PACKAGE-02 — SCREEN-01·02 Shell

플레이어 결과:

- 무인 메인
- 텍스트 노벨 조사 공통 Shell
- 최소 HUD·기록 Drawer
- 전문 절차 진입·복귀

포함:

- Main save card distinction
- location background
- narration/dialogue/choice/result
- record badge·drawer
- keyboard/pointer focus

제외:

- 가설·노선·회수 내부 규칙
- 최종 캐릭터·배경 아트

필수 테스트:

- first run·Legacy·Validation save states
- 2~4 choices
- locked reason
- record drawer 30초 발견 경로
- 1280/1920

### PACKAGE-03 — SCREEN-03 축약 준비

플레이어 결과:

- 권나래 고정
- 동료 최대 2명
- 장비 1·지원 1·우선순위 1
- 추천 편성 복원·출동

필수 보호:

- 정답 가설·행동·미관측 패턴 미노출
- 숨긴 기능 무부작용
- 전체 ANNUAL·시장·일상 비노출

### PACKAGE-04 — Hypothesis·Timeline·Route

플레이어 결과:

- 4→2 가설 제거
- 시간순 증거 연결
- 원인/매개 역할 구분
- 안전 노선 제출·실패 복구

필수 보호:

- 사건 JSON 원문 보존
- 오답 정답 자동 공개 금지
- 최소 안전 노선 Gate
- 재시도·미해결 철수

### PACKAGE-05 — Recovery 2 Patterns

플레이어 결과:

- 전조 분류
- 관련 기록 연결
- 중립 행동
- 현장 결과·추론 검증 분리
- 패턴당 복구 1회

필수 보호:

- 첫 선택 능력치·확률·동료 예측 비노출
- 두 번째 실패도 소프트락 없음
- 패턴 3·4 비노출·무부작용

### PACKAGE-06 — Result 4 Axes·Feedback

플레이어 결과:

- 원시 4축
- 요약 등급·상한
- 보고서·매뉴얼
- 연구 질문 1·보급 후보 1·다음 영향
- 메인 복귀

필수 보호:

- 단일 총점 권위 금지
- 원시 축 저장
- 미검증 원인 완전 해결 금지
- 후보의 정답화 금지

### PACKAGE-07 — Regression·Accessibility·Playtest Build

포함:

- 전체 Validation flow
- Legacy regression
- save restart matrix
- hidden feature no-side-effect
- keyboard/pointer
- 1280/1920 capture
- playtest instrumentation

출력:

- 실행 가능한 신규 플레이어 build
- `PT-2026-08-01-VALIDATION-SCREEN-SIT` 실행 자료

## 5. 후속 제품 화면

SCREEN-05 일정, SCREEN-06 연구, SCREEN-07 기록국 보급실은 승인 제품 Target이지만 첫 Validation 구현 패키지의 전체 화면 범위에서 제외한다.

Validation에서는 다음만 사용한다.

- 결과의 다음 날짜 영향
- 연구 질문 1개
- 보급 후보 1개

전체 제품 화면 구현은 Validation flow·사람 검증 뒤 별도 패키지로 진행한다.

## 6. 패키지 공통 Gate

각 패키지:

```text
Codex Plan actual-file inventory
→ RED test
→ 최소 구현
→ focused GREEN
→ 영향 회귀
→ 1280/1920 또는 저장 증거
→ GPT 적대적 검수
→ 다음 패키지
```

금지:

- 여러 패키지 동시 병합
- Save·화면·사건 규칙을 한 PR에서 전면 교체
- Legacy 코드·테스트 선삭제
- 실행하지 않은 검증 PASS

## 7. 최종 Validation Gate

- P0/P1 0
- 단계별 save/restore PASS
- Legacy regression PASS
- hidden feature side effect 0
- keyboard/pointer PASS
- 1280/1920 PASS
- 신규 플레이어 6명 실행
- 행동 지표 판정
- 사용자 체감 검수

이후에만:

- `POC_PASSED` 검토
- Showcase Cut
- SCREEN-05~07 전체 제품화
- Base v9.3 이관 병합 검토

## 8. 현재 다음 행동

```text
writing-plans로 PACKAGE-01~07의 정확한 파일·테스트·롤백 계획 작성
→ Codex 읽기 전용 Plan으로 실제 main 검수
```

Codex Build Goal은 마지막 단계다.
