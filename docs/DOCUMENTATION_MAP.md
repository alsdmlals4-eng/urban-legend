# Documentation Map

작업에 필요한 책임 원본과 Skill만 선택하는 라우터다. Base 버전은 `BASE_RULES_VERSION.md` 한 곳에서 관리한다.

## 기본 경로

```text
START_HERE.md
→ AGENTS.md
→ OPERATING_MODEL.md
→ WORK_MODE_AND_SKILL_ROUTING.md
→ CURRENT_STATUS.md
→ PROJECT_CORE.md
→ SKILL_REGISTRY.json
→ 선택된 Skill·책임 원본·실제 파일
```

## 운영 원본

| 책임 | 원본 | 조건 |
|---|---|---|
| 강제 규칙·불변 용어 | `../AGENTS.md` | 항상 |
| 현재 구현·승인 계획 | `CURRENT_STATUS.md` | 항상 |
| 프로젝트 코어·변경 경계 | `PROJECT_CORE.md` | L1 이상·구조·기획·검수 |
| 운영 생명주기 | `OPERATING_MODEL.md` | L1 이상 |
| Work Mode·라우팅 | `WORK_MODE_AND_SKILL_ROUTING.md` | Skill 선택·보고 |
| Base 버전 | `BASE_RULES_VERSION.md` | Base 적용·동기화 |
| 프로젝트 Skill | `../skills/SKILL_REGISTRY.json` | trigger 선택 |
| Base Skill | `../skills/BASE_SKILL_INDEX.json` | Base trigger 선택 |
| 공용 기능 Coverage | `../skills/BASE_SKILL_COVERAGE.json` | 누락·통합 감사 |
| 분야 공통 계약 | `../skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md` | 프로젝트 Skill 실행 |
| Base 경로 변환 | `../skills/PROJECT_PATH_ADAPTER.json` | Base 예시 경로 해석 |
| 검증 | `../TEST_CHECKLIST.md` | 변경 시 |

## 프로젝트 기획 원본

| 책임 | 원본 |
|---|---|
| 방향·약속 | `planning/PROJECT_DIRECTION.md` |
| 서사·대화·관계 | `planning/NARRATIVE_CONTENT_PLAN.md` |
| 아트·표정·컷인 | `planning/ART_PRESENTATION_PLAN.md` |
| 로드맵·Handoff | `planning/ROADMAP_AND_HANDOFF.md` |
| 적용 사례 | `planning/REFERENCE_CASES.md` |
| 상세 게임 설계 | `GAME_DESIGN_DOCUMENT.md` |
| 용어·표현 | `PROJECT_CONTEXT.md` |
| 구현 순서 | `../MVP_ROADMAP.md` |

## 조건부 라우팅

- 대사·관계: `urban-legend-narrative`.
- 조사·안정화·미니게임·밸런스: `urban-legend-game-design`.
- UI·입력·접근성: `urban-legend-ux-ui-accessibility`.
- Godot·저장·Scene: `urban-legend-engineering`; 런타임 실패면 `diagnosing-game-engine-runtime-failures`.
- 에셋 import·Manifest: `urban-legend-technical-art-pipeline`.
- 아트: `urban-legend-art`; 생성 프롬프트는 Base 아트 Skill.
- 오디오: `urban-legend-audio`.
- 테스트·release gate: `urban-legend-qa`.
- Roadmap·Issue·PR·Handoff: `urban-legend-production-pm`.
- 연구·텔레메트리: `urban-legend-analytics-user-research`; 11영역 Coverage는 Base GUR Skill.
- 구조 최적화: pruning→simplifying/refactoring→adversarial→validation 순서.

## 기본 읽기 제외

`archive/**`, 완료 `qa/**`, 완료 Goal, 과거 보고서·HTML, Base 전체 Skill 폴더는 직접 근거가 있을 때만 읽는다. 호환 문서는 연결된 현행 원본으로 이동하며 내용을 다시 복제하지 않는다.

## 상시 동기화

- 코어 영향 시 `PROJECT_CORE.md`와 실제 구현을 함께 심사한다.
- 경로·ID·Schema·정본·생성기 변경 시 untouched 소비자를 감사한다.
- GDD 변경 시 DOCX를 재생성하고 `--check`한다.
- Skill 통합·간소화 뒤 Registry·Coverage·Alias·Entry point·CI를 갱신한다.
