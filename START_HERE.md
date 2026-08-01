# Urban Legend 시작 지점

새 채팅·새 GPT·새 Codex·새 작업자가 urban-legend를 안전하게 시작하는 최상위 라우터다.

Base 버전은 `docs/BASE_RULES_VERSION.md`, 현재 승인 결정은 `docs/CURRENT_CONFIRMED_DECISIONS.md`, 승인된 Validation 상세 Target은 `docs/VALIDATION_TARGET_CANON.md`가 소유한다.

## 현재 한 줄 상태

```text
Validation 기획 최종 승인
→ Canon Pass 진행
→ 제품 구현·Runtime·사람 검증·Codex Build는 HOLD
```

## 기본 읽기

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 필요 시 skills/BASE_SKILL_INDEX.json
→ 선택된 프로젝트 분야/로컬/Base Skill 전문
→ 책임 원본·실제 코드·데이터·자산·테스트
```

`전부 확인`은 모든 파일과 Skill을 기본 로드한다는 뜻이 아니다. Documentation Map·Registry·Coverage로 누락을 확인하고 현재 요청의 책임 원본·소비처·실제 파일을 추적한다.

## 권위 분리

### 승인 Target

- `docs/CURRENT_CONFIRMED_DECISIONS.md`
- `docs/VALIDATION_TARGET_CANON.md`
- `docs/decisions/**`

상태:

- `APPROVED_FINAL_PLANNING_BASELINE`
- `APPROVED_TARGET_NOT_IMPLEMENTED`

### 현재 구현

- `docs/CURRENT_STATUS.md`
- 실제 main 코드·데이터·Scene·테스트

상태:

- `CURRENT_IMPLEMENTATION_LEGACY`
- 실제 구현·회귀 증거

승인 Target을 구현 완료로 보고하지 않는다. 현재 구현이 Target과 다르면 양쪽을 섞지 않고 차이와 마이그레이션 책임을 기록한다.

## 현재 Validation 흐름

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

제품 코드·Scene·JSON·Save Schema·에셋 구현은 아직 승인되지 않았다.

## 자동 라우팅

1. Prompt 의도·현재 단계·위험에서 `PLAN / BUILD / REVIEW` 하나를 선택한다.
2. 프로젝트 trigger로 주 분야 Skill을 최대 하나 고른다.
3. 좁은 반복 작업 trigger가 맞으면 프로젝트 로컬 전문 Skill을 최대 하나 고른다.
4. Base trigger가 맞는 지원 Skill만 최대 3개 고른다.
5. 프로젝트 분야 Skill은 `PROJECT_DISCIPLINE_CONTRACT.md`와 해당 본문을 읽는다.
6. Base Skill은 현재 프로젝트 Base pin과 Adapter 경계를 따른다.
7. 실행 뒤 이유·수행·증거·미검증을 보고한다.

Registry 행만 읽고 Skill을 실행했다고 보고하지 않는다.

## 현재 작업 순서

```text
Canon reference·상태·Sheet 검증
→ writing-plans
→ Codex 읽기 전용 기술 Plan
→ CHANGE_PROPOSAL 검수
→ 구현 패키지 승인
→ 마지막에 Codex Build Goal
```

Base v9.3 PR #120은 Canon Pass 전 `DRAFT_HOLD`다. 새 migration PR을 만들거나 구형 branch를 병합·cherry-pick하지 않는다.

## 구조 개선·검토 루프

```text
코어·기능 baseline
→ 현재 승인 Decision 복원
→ Target/Legacy 분리
→ 가지치기·참조 후보 분류
→ attack
→ validate-critique
→ MUST_FIX·승인 SHOULD_FIX 최소 수정
→ regression-recheck
→ GitHub·Sheet 동기화
```

삭제·대량 이동·코어 변경·Schema 변경은 승인과 롤백 없이 수행하지 않는다.

## 프로젝트 보호 범위

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `project.godot`
- `knowledge/base-pack/**`
- `scripts/**`, `scenes/**`, `assets/**`, `addons/**`
- 저장 Schema·기존 ID·캠페인·경제·엔딩 의미
- 승인 자산과 실제 QA 증거

## 핵심 위치

- 현재 승인 결정: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- 승인 Validation Target: `docs/VALIDATION_TARGET_CANON.md`
- 현재 구현·검증 상태: `docs/CURRENT_STATUS.md`
- 프로젝트 코어·장기 정체성: `docs/PROJECT_CORE.md`
- 문서 라우터: `docs/DOCUMENTATION_MAP.md`
- Base 버전: `docs/BASE_RULES_VERSION.md`
- 프로젝트 Registry: `skills/SKILL_REGISTRY.json`
- Base 라우팅: `skills/BASE_SKILL_INDEX.json`
- Base 기능 Coverage: `skills/BASE_SKILL_COVERAGE.json`
- 분야 공통 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`
- 괴이 사건 작성: `skills/urban-legend-investigation-case-authoring/SKILL.md`
- Validation 시각 검수: `docs/visual/UL_IMG_007_VISUAL_REVIEW_2026-08-01.md`
- Validation 플레이테스트: `docs/validation/VALIDATION_SCREEN_SIT_PLAYTEST_PACKAGE_2026-08-01.md`
- 검증 계약: `TEST_CHECKLIST.md`

## 기본 읽기 제외

다음은 현재 요청에 직접 필요한 경우만 연다.

- `docs/archive/**`
- 완료된 `docs/qa/**`
- 완료된 `docs/CODEX_GOAL_*`
- 과거 `docs/benchmarks/**`
- 비활성 `docs/superpowers/**`
- 과거 보고서·일회성 감사
- Base 전체 Skill 본문

현재 승인 Target에 직접 연결된 Decision·Spec·Review·Playtest 문서는 예외다.

## 검증 상태 표현

- 실행한 검사만 `PASS`
- 실행하지 않은 Runtime·기기·사람 검증은 `NOT_RUN`
- 계획 승인은 구현 완료가 아님
- 정적 이미지 승인은 제품 에셋 승인이 아님
- 자동 회귀 통과는 `POC_PASSED`나 제작 확대 승인이 아님
