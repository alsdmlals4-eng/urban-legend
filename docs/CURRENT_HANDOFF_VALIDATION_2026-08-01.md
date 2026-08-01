# 괴이기록국 Validation 현재 인수인계 — 2026-08-01

> 상태: `CANON_PASS_IN_PROGRESS / WRITING_PLANS_NEXT`
> 기준 main: `656846865eb88871d00842a0da527ce1b0722b77`
> 작업 branch: `plan/urban-legend-planning-audit`
> 추적: Issue #121 / Draft PR #122
> 제품 구현: `NOT_AUTHORIZED`
> Codex Build: `HOLD`

## 1. 반드시 먼저 읽기

```text
START_HERE.md
→ AGENTS.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/DOCUMENTATION_MAP_CURRENT.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ 실제 main 코드·데이터·Scene·테스트
```

## 2. 현재 완료

- Base·프로젝트 GitHub·Google Sheet 27탭 감사
- Validation 화면 권위 확정
- SCREEN-01~07·SIT-001~008 상세 설계
- 저승역 시간순 증거 확정
- 회수 2패턴 REV-2 확정
- 결과 원시 4축 확정
- Legacy/Validation 저장·테스트 계약 확정
- 보드 A·B·C1~C4 생성·시각 검수
- 플레이테스트 패키지 작성
- 최종 적대적 검토
- 기획 최종 승인
- 현재 승인 Decision 원장·Validation 상세 Canon 설치
- Current Documentation Map 설치
- Base v9.1 유지·v9.3 PR #120 HOLD 정렬

## 3. 현재 Target

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

상세: `docs/VALIDATION_TARGET_CANON.md`

## 4. 실제 구현 상태

`CURRENT_IMPLEMENTATION_LEGACY`:

- CORE-MVP-001 저승역 구현
- ANNUAL-MVP-001/002 PoC
- 기존 preparation/investigation/battle/result/market 흐름
- 본편 `mvp-039`·ANNUAL 저장
- 기존 focused·full regression·visual QA

제품 Target으로 오인하거나 삭제하지 않는다.

## 5. 현재 열린 위험

### P1 — 구현 Gate

- 숨긴 기능 무부작용
- 저장 단계 복귀·효과 중복 0
- 최소 안전 노선 Gate
- 1280×720 핵심 입력 접근

### P2 — 테스트 Gate

- Legacy/Validation 이어하기 구분
- 기록 HUD 발견성
- 회수 행동 정답 모양
- 원인/매개 역할 설명
- 결과 4축 회상
- 다일 활동 중단 이해
- 최종 제품 아트

측정: `docs/validation/VALIDATION_SCREEN_SIT_PLAYTEST_PACKAGE_2026-08-01.md`

## 6. 다음 작업

```text
1. Canon Pass 최종 검증
2. writing-plans
3. Codex 읽기 전용 기술 Plan
4. CHANGE_PROPOSAL 검수
5. 구현 패키지 승인
6. 마지막에 Codex Build Goal
```

## 7. Codex 읽기 전용 Plan 요구

Codex는 최신 main에서 다음을 실제 파일로 확인한다.

- 메인 메뉴·새 게임·이어하기 라우터
- `GameState`·Save Schema·restore 경계
- preparation·investigation·hypothesis·route/minigame·battle/recovery·result Scene
- 저승역 JSON·ID·상태 소유자
- 기존 ANNUAL PoC와 본편 저장 분리
- focused·full regression·visual test 경로
- 숨긴 기능의 현재 판정·난수·로그 부작용

Codex Plan 금지:

- 파일 수정
- Commit·Push·PR·Issue 변경
- 기존 저장·ID 변경
- 승인 Target 변경

출력:

- actual-file inventory
- Target/Legacy gap
- technical risk
- package boundary
- TDD test matrix
- CHANGE_PROPOSAL

## 8. Base 상태

- 현재 Adapter: Base v9.1
- Base v9.3 PR #120: `DRAFT_HOLD`
- Canon Pass 검증 뒤 재평가
- 새 migration PR 생성 금지
- generated adapter 수동 편집 금지

## 9. Sheet 상태

Google Sheet ID:

`14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck`

주요 현재 탭:

- `00_프로젝트_허브`
- `01_작업순서`
- `02_현재_확정결정`
- `04_누락_충돌_감사`
- `05_GDD_요약`
- `12_핵심루프`
- `40_핵심시스템_메인콘텐츠`
- `50_메인콘텐츠`
- `60_UX_UI_접근성`
- `71_이미지기획_생성목록`
- `72_이미지검수_승인로그`
- `80_데모_버티컬슬라이스_플레이테스트`
- `99_변경이력`

승인 변경은 동일 Decision ID로 GitHub·Sheet를 함께 갱신한다.

## 10. 검증 경계

현재 통과 주장 가능:

- 문서·BCA CI
- 제품 보호 경로 diff 0
- 승인 Decision·Sheet 동기화
- 정적 시각 검수

현재 통과 주장 금지:

- Godot Runtime
- Save migration
- 1280×720 제품 화면
- 신규 플레이어
- 장시간 사용성
- `POC_PASSED`
- 제작 확대

## 11. 완료 보고 형식

- Work Mode·Skill·Skill Mode
- 변경 파일과 이유
- Decision ID·Sheet 범위·Commit
- Target/Legacy 영향
- 자동·Runtime·사람 검증 분리
- 미검증·위험
- 다음 Gate
