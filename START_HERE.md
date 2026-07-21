# Urban Legend 시작 지점

이 문서는 새 채팅, 새 GPT, 새 Codex 또는 새 작업자가 `urban-legend`를 안전하게 시작하는 최상위 라우터다.

## 기준

- 프로젝트: `alsdmlals4-eng/urban-legend`
- 공용 원본: `alsdmlals4-eng/Base`
- Base 기준 커밋: `ee265576da7f67d3278f8099dd97d4e714ef0651`
- 프로젝트 구현 기준: `main`의 실제 코드·데이터·테스트와 `docs/CURRENT_STATUS.md`

Base의 공용 방법은 프로젝트 고유 세계관·수치·저장 구조·파일 경로보다 우선하지 않는다. 기존 책임 원본을 강제 이동하거나 모든 Base 파일·Skill을 복사하지 않는다.

## 기본 읽기 순서

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/CURRENT_STATUS.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ skills/PROJECT_PATH_ADAPTER.json
→ 현재 책임 원본·Issue·Plan
→ 실제 코드·데이터·자산·테스트
```

`전부 확인`은 저장소와 Base의 모든 파일을 무작정 읽는다는 뜻이 아니다. Documentation Map과 Registry로 현재 요청에 필요한 최소 책임 원본·Skill·Skill Mode를 선택한다. Base Skill 문서에 `[기획서]/...` 같은 예시 경로가 있으면 `skills/PROJECT_PATH_ADAPTER.json`의 실제 프로젝트 경로를 우선한다.

## 자동 작업 흐름

```text
Prompt 의도·현재 단계·위험 파악
→ PLAN / BUILD / REVIEW Work Mode 자동 선택
→ Registry trigger 기반 최소 Skill·Skill Mode 자동 선택
→ 범위·보호 대상·완료 기준·검증 확정
→ 승인 범위 실행
→ 정본·참조·정적·런타임·회귀 검증
→ 사용 이유·수행 내용·결과·미검증 보고
```

- `PLAN`: 조사·요구·근거·설계·순서. 승인 전 구조 변경을 하지 않는다.
- `BUILD`: 승인된 범위만 구현·갱신한다.
- `REVIEW`: 적대적 검토·반례·검증을 우선하며 기본은 읽기 전용이다.

## 프로젝트 보호 범위

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `project.godot`
- `knowledge/base-pack/**`
- 저장 스키마, 캠페인 진행, 경제, 엔딩, 기존 ID
- 승인된 자산과 실제 QA 결과

위 항목은 관련 기능 요청과 회귀 계약 없이 변경하지 않는다.

## 문서 위치

- 현재 구현·승인 계획: `docs/CURRENT_STATUS.md`
- 문서 라우터: `docs/DOCUMENTATION_MAP.md`
- Base 경로 어댑터: `skills/PROJECT_PATH_ADAPTER.json`
- 기획 인수인계: `docs/planning/README.md`
- 프로젝트 핵심 방향: `docs/planning/PROJECT_DIRECTION.md`
- 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`
- 구현 순서: `MVP_ROADMAP.md`
- 검증 계약: `TEST_CHECKLIST.md`
- Base 기준: `docs/BASE_RULES_VERSION.md`

백업·완료 QA·과거 Goal은 현재 작업이 직접 요구할 때만 연다. 실행하지 않은 검사와 권한은 통과로 보고하지 않는다.
