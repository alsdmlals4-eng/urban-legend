# 괴이기록국 Validation Canon Pass 결과 — 2026-08-01

> Canon Pass ID: `CANON-PASS-2026-08-01-VALIDATION`
> Decision: `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL`
> 상태: `CANON_UPDATED / VERIFICATION_PENDING`
> 기준 main: `656846865eb88871d00842a0da527ce1b0722b77`
> 제품 구현 권한: `NONE`

## 1. 목표

승인된 Validation 기획을 대화·Draft 문서·Sheet 행에 분산된 상태에서 현재 작업자가 한 단계 안에 찾을 수 있는 단일 권위 구조로 승격한다.

## 2. 설치한 현재 권위

### 사람용

- `docs/CURRENT_CONFIRMED_DECISIONS.md`
- `docs/VALIDATION_TARGET_CANON.md`
- `docs/DOCUMENTATION_MAP_CURRENT.md`
- `docs/CURRENT_HANDOFF_VALIDATION_2026-08-01.md`
- `docs/planning/VALIDATION_IMPLEMENTATION_ROADMAP_2026-08-01.md`

### 기계 판독

- `docs/CANON_AUTHORITY_ADAPTER.json`

### 라우터 갱신

- `START_HERE.md`
- `docs/planning/README.md`
- `docs/BASE_RULES_VERSION.md`

## 3. 권위 순서

```text
최신 사용자 승인
→ CURRENT_CONFIRMED_DECISIONS
→ VALIDATION_TARGET_CANON
→ Decision 상세 문서
→ PROJECT_CORE의 충돌하지 않는 장기 정체성
→ GDD의 충돌하지 않는 장기 상세
→ CURRENT_STATUS의 실제 구현 상태
→ 실제 main 파일·테스트
→ Legacy·역사 자료
```

## 4. 보존한 Legacy

다음은 삭제·본문 축약·강제 이관하지 않았다.

- `docs/PROJECT_CORE.md`
- `docs/GAME_DESIGN_DOCUMENT.md`
- `docs/CURRENT_STATUS.md`
- `MVP_ROADMAP.md`
- `TEST_CHECKLIST.md`
- 기존 `docs/DOCUMENTATION_MAP.md`
- 기존 `docs/CURRENT_HANDOFF.md`
- CORE·ANNUAL 설계·계획·QA
- 기존 Scene·Script·JSON·Save·테스트

분류:

- 장기 정체성의 충돌하지 않는 내용: `CURRENT_LONG_TERM`
- 현재 제품 구현·회귀: `CURRENT_IMPLEMENTATION_LEGACY`
- 과거 계획·QA: `HISTORICAL_EVIDENCE`

## 5. 기존 Documentation Map 처리

`docs/DOCUMENTATION_MAP.md`를 현재 권위로 덮어쓰려 했으나 GitHub Contents API가 재조회한 동일 Blob SHA를 두 차례 409로 거부했다.

안전 처리:

- 강제 덮어쓰기·삭제하지 않음
- `docs/DOCUMENTATION_MAP_CURRENT.md`를 현재 권위로 신규 설치
- `START_HERE.md`가 Current Map을 우선 읽도록 갱신
- 기존 Map은 연도제·CORE·Legacy 호환 라우터로 보존

판정:

`COMPATIBILITY_PRESERVED / CURRENT_AUTHORITY_RESTORED`

## 6. Base 권위 정렬

이전 충돌:

- 사람용 `BASE_RULES_VERSION`: c987… / 25개 / v8 중심
- canonical Adapter: Base v9.1 / 27 Base routes / 10 project routes
- Base 원격: v9.3

현재:

- 프로젝트 운영 Adapter 권위: Base v9.1
- c987…·v8: Legacy BCA compatibility input
- Base v9.3 PR #120: Draft/HOLD
- Canon Pass 검증 뒤 PR #120 재평가
- stale generated Sheet field는 future generator 재생성 대상

## 7. Target/Implementation 분리

### Target

- `APPROVED_FINAL_PLANNING_BASELINE`
- 상세: `VALIDATION_TARGET_CANON.md`

### 구현

- `CURRENT_IMPLEMENTATION_LEGACY`
- 상세: `CURRENT_STATUS.md`·실제 main 파일·테스트

승인 Target은 구현 완료가 아니며 Legacy 구현은 폐기 대상이 아니다.

## 8. 연결된 검증

- 시각: `R-2026-08-01-UL-IMG-007-VISUAL-REVIEW`
- 플레이테스트: `PT-2026-08-01-VALIDATION-SCREEN-SIT`
- 최종 적대적 검토: `R-2026-08-01-VALIDATION-PLANNING-FINAL-ADVERSARIAL`
- Base·Sheet 운영 검증: `R-2026-08-01-BASE-PROJECT-SHEET-OPERATING-VERIFY`

## 9. 변경 경계

변경:

- 문서 권위·라우팅·상태·Handoff·Roadmap

변경하지 않음:

- GDScript
- Scene
- JSON·Resource
- assets·addons
- project.godot
- Save Schema·ID
- 기존 테스트 의미
- Base generated Adapter

## 10. 다음 검증

- 새 파일 존재·참조 확인
- Current Decisions→Target Canon→Map→Handoff 한 단계 발견성
- JSON parse
- Documentation Contracts
- BCA Adoption
- main 대비 제품 보호 경로 diff 0
- PR review threads 0
- Google Sheet Decision·경로·Commit 재조회

## 11. 검증 뒤 상태

검증이 통과하면:

```text
CANON_PASS_COMPLETE
→ writing-plans
→ Codex 읽기 전용 기술 Plan
```

검증 전에는 `CANON_PASS_COMPLETE`를 선언하지 않는다.
