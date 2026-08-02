# Urban Legend 시작 지점

새 채팅·새 GPT·새 Codex·새 작업자가 urban-legend를 안전하게 시작하는 최상위 라우터다. Base 버전은 `docs/BASE_RULES_VERSION.md` 한 곳에서 확인한다.

## 기본 읽기

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md  # Validation·제품 Target 관련일 때
→ docs/decisions/D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL.md  # Package 1 작업일 때
→ docs/decisions/D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY.md  # Package 1 저장 작업일 때
→ docs/planning/2026-08-02-package-1-planning-adversarial-audit.md  # Package 1 작업일 때
→ docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md  # Package 1 설계
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 필요 시 skills/BASE_SKILL_INDEX.json
→ 선택된 프로젝트 분야/로컬/Base Skill 전문
→ 책임 원본·실제 코드·데이터·자산·테스트
```

`전부 확인`은 모든 파일과 Skill을 기본 로드한다는 뜻이 아니다. Documentation Map·Registry·Coverage로 누락을 확인한 뒤 현재 요청에 필요한 최소 책임 원본과 Skill만 읽는다.

승인 Target과 실제 구현은 분리한다.

```text
docs/CURRENT_CONFIRMED_DECISIONS.md = 현재 승인 결정 인덱스
docs/VALIDATION_TARGET_CANON.md = 승인된 Validation 상세 Target
docs/CURRENT_STATUS.md = 실제 구현·검증 상태
실제 main 코드·데이터·테스트 = 구현 사실
```

## 자동 라우팅

1. Prompt 의도·현재 단계·위험에서 `PLAN / BUILD / REVIEW` 하나를 선택한다.
2. 프로젝트 trigger로 주 분야 Skill을 최대 하나 고른다.
3. 좁은 반복 작업 trigger가 맞으면 프로젝트 로컬 전문 Skill을 최대 하나 고른다.
4. Base trigger가 맞는 지원 Skill만 최대 3개 고른다.
5. 프로젝트 분야 Skill은 `PROJECT_DISCIPLINE_CONTRACT.md`와 해당 본문을 읽는다.
6. 프로젝트 로컬 Skill은 Registry의 실제 `path` 전문을 읽는다.
7. Base Skill은 `BASE_SKILL_INDEX.json`에서 선택하고 고정 커밋의 해당 `SKILL.md`·명시 reference만 읽는다.
8. 실행 뒤 이유·수행·증거·미검증을 보고한다.

Registry 행만 읽고 Skill을 실행했다고 보고하지 않는다.

## 구조 개선·검토 루프

```text
코어·기능 baseline
→ 가지치기 후보 분류
→ 조건부 상세 reference 이동
→ 행동 보존 리팩토링
→ attack
→ validate-critique
→ MUST_FIX·승인 SHOULD_FIX 최소 수정
→ regression-recheck
→ PR changed-file·CI 판정
```

삭제·대량 이동·코어 변경·Schema 변경은 승인과 롤백 없이 수행하지 않는다.

## 현재 Validation Gate

```text
Base v9.4 Canon·Sheet 재조정 = COMPLETE_ON_PR_125
최신 main 읽기 전용 기술 검수 = COMPLETE
CHANGE_PROPOSAL = READY
Package 1 기획·명세 작성 = APPROVED
Package 1 적대적 감사 = COMPLETE
D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY = APPROVED
Package 1 Design Spec = REVIEW_READY
→ 사용자 Spec 승인
→ writing-plans
→ 별도 Package 1 구현 승인
```

현재 제품 코드·Scene·JSON·Save Schema·에셋 변경과 Codex Build는 승인되지 않았다.

Package 1 운영 규칙:

- Validation 완료 기록은 본편·Legacy와 완전히 독립한다.
- 상세 수치·기술 기본값은 `RECOMMENDED_DEFAULT` 또는 `TEST_VALUE`로 권장안을 사용한다.
- 프로젝트 방향·저장 UX·완료 의미·정본 충돌만 Grill Me로 한 번에 하나씩 질문한다.
- Legacy 파일과 숨은 campaign/economy/relationship 메모리를 모두 무변경으로 보호한다.
- Design Spec 승인 전 구현 계획과 코드를 시작하지 않는다.

## 프로젝트 보호 범위

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `project.godot`
- `knowledge/base-pack/**`
- 저장 Schema·기존 ID·캠페인·경제·엔딩 의미
- 승인 자산과 실제 QA 증거

## 핵심 위치

- 현재 승인 결정: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- Validation 상세 Target: `docs/VALIDATION_TARGET_CANON.md`
- Package 1 기획 승인: `docs/decisions/D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL.md`
- Validation 영속 경계: `docs/decisions/D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY.md`
- Package 1 Design: `docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md`
- Package 1 적대적 감사: `docs/planning/2026-08-02-package-1-planning-adversarial-audit.md`
- Validation 현재 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`
- 실제 구현·검증 상태: `docs/CURRENT_STATUS.md`
- 프로젝트 코어: `docs/PROJECT_CORE.md`
- 문서 라우터: `docs/DOCUMENTATION_MAP.md`
- Base 버전: `docs/BASE_RULES_VERSION.md`
- 프로젝트 Registry: `skills/SKILL_REGISTRY.json`
- Base 라우팅: `skills/BASE_SKILL_INDEX.json`
- Base 기능 Coverage: `skills/BASE_SKILL_COVERAGE.json`
- 분야 공통 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`
- 괴이 사건 작성: `skills/urban-legend-investigation-case-authoring/SKILL.md`
- 검증 계약: `TEST_CHECKLIST.md`
- 최신 정본 감사: `docs/planning/POST_V94_CANON_RECONCILIATION_AUDIT_2026-08-02.md`
- 읽기 전용 기술 Plan: `docs/superpowers/plans/2026-08-02-validation-read-only-technical-plan.md`
- 현재 기술 제안: `docs/superpowers/plans/2026-08-02-validation-change-proposal.md`

## 현재 권장 기술 방향

```text
별도 ValidationSession Autoload
+ 별도 Validation save
+ 기존 dialogue/investigation/minigame/battle 전문 절차 재사용
+ 전용 축약 준비·Reasoning·결과 Scene
+ pure 4-axis result calculator
+ apply-once effect ledger
```

Package 1 저장 경계:

```text
Validation save = 독립 기록
Legacy save = 기존 본편 기록
공용 프로필 = 생성하지 않음
본편 가져오기 = 별도 Decision 전까지 보류
```

구형 계획의 범용 Text Novel Shell, Legacy preparation/result 단순 모드 분기, 전 도메인 상태를 소유하는 ValidationFlowState는 그대로 구현하지 않는다.

## Base·PR 현재값

- Base: `9.4.0`
- 프로젝트 채택 main: `7277b9cececa56532f7b0d11c1a02fd3d5642750`
- PR #120(Base v9.3): `CLOSED_UNMERGED / SUPERSEDED_BY_BASE_V9_4_MAIN`
- PR #122: 승인 기획의 역사 source branch이며 그대로 병합하지 않는다.
- Draft PR #125: 최신 main 기반 Canon·Audit·Package 1 Design surface

백업·완료 QA·과거 Goal은 현재 작업의 직접 근거가 있을 때만 읽는다. 실행하지 않은 검사·권한·사람 확인은 `NOT_RUN` 또는 `UNVERIFIED`다.
