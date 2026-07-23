# Urban Legend 시작 지점

새 채팅·새 GPT·새 Codex·새 작업자가 urban-legend를 안전하게 시작하는 최상위 라우터다. Base 버전은 `docs/BASE_RULES_VERSION.md` 한 곳에서 확인한다.

## 기본 읽기

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 필요 시 skills/BASE_SKILL_INDEX.json
→ 선택된 프로젝트 분야/로컬/Base Skill 전문
→ 책임 원본·실제 코드·데이터·자산·테스트
```

`전부 확인`은 모든 파일과 Skill을 기본 로드한다는 뜻이 아니다. Documentation Map·Registry·Coverage로 누락을 확인한 뒤 현재 요청에 필요한 최소 책임 원본과 Skill만 읽는다.

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

## 프로젝트 보호 범위

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `project.godot`
- `knowledge/base-pack/**`
- 저장 Schema·기존 ID·캠페인·경제·엔딩 의미
- 승인 자산과 실제 QA 증거

## 핵심 위치

- 현재 구현·계획: `docs/CURRENT_STATUS.md`
- 프로젝트 코어: `docs/PROJECT_CORE.md`
- 문서 라우터: `docs/DOCUMENTATION_MAP.md`
- Base 버전: `docs/BASE_RULES_VERSION.md`
- 프로젝트 Registry: `skills/SKILL_REGISTRY.json`
- Base 라우팅: `skills/BASE_SKILL_INDEX.json`
- Base 기능 Coverage: `skills/BASE_SKILL_COVERAGE.json`
- 분야 공통 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`
- 괴이 사건 작성: `skills/urban-legend-investigation-case-authoring/SKILL.md`
- 검증 계약: `TEST_CHECKLIST.md`

백업·완료 QA·과거 Goal은 현재 작업의 직접 근거가 있을 때만 읽는다. 실행하지 않은 검사·권한·사람 확인은 `NOT_RUN` 또는 `UNVERIFIED`다.
