# Base Rules Version

> 문서 위치: `docs/BASE_RULES_VERSION.md` | Base 공용 지식: `alsdmlals4-eng/Base/docs/knowledge/` | 과거 동기화 기록: `docs/archive/backup/2026-07-16/COMPLETED_QA_RULES_HANDOFF_BACKUP.md`

이 문서는 **Base 공용 규칙·기획 지식 동기화 작업에서만** 읽는다. 일상적인 urban-legend 구현·기획 작업은 프로젝트의 `AGENTS.md`, `docs/CURRENT_STATUS.md`, `docs/planning/`을 먼저 읽는다.

## 현재 동기화 기준

| 항목 | 값 |
|---|---|
| 공용 원본 | `alsdmlals4-eng/Base` |
| 기준 브랜치 | `main` |
| 기준 커밋 | `e05e198d9c003623f1a117fa1d4505e97117990e` |
| 확인일 | 2026-07-16 |
| Base 지식 버전 | v1.6.0 — 기획·서사·캐릭터 아트·대화 연출·조사·인수인계 확장 |
| 현재 상태 | 프로젝트 전용 기획과 Base 공용 방법 분리 / 원격 자동 병합 금지 |

## 이번 Base 반영

Base의 canonical 공용 기획 지식 위치는 `docs/knowledge/`다.

- `methods/PLANNING_SYSTEM_METHOD.md`
- `methods/NARRATIVE_AND_RELATIONSHIP_METHOD.md`
- `methods/CHARACTER_AND_NARRATIVE_ART_METHOD.md`
- `methods/DIALOGUE_AND_EVENT_PRESENTATION_METHOD.md`
- `skills/PLANNING_RESEARCH_HANDOFF_SKILL_MATRIX.md`
- urban-legend에서 일반화한 프로젝트 사례 7건
- 미스터리 근거 재열람·캐릭터 반응·학습 가능한 실패 벤치마킹 사례 2건
- 프로젝트 방향·서사·아트·연출·handoff 템플릿

urban-legend의 캐릭터명, 괴이 규칙, 수치, 파일 경로, 저장 구조, 실제 QA 결과는 프로젝트 저장소에 유지한다.

## 프로젝트에서 우선할 문서

- 현재 구현·승인 계획: `docs/CURRENT_STATUS.md`
- 기획 인수인계: `docs/planning/README.md`
- 프로젝트 방향: `docs/planning/PROJECT_DIRECTION.md`
- 서사·관계: `docs/planning/NARRATIVE_CONTENT_PLAN.md`
- 아트·연출: `docs/planning/ART_PRESENTATION_PLAN.md`
- 로드맵·인수인계: `docs/planning/ROADMAP_AND_HANDOFF.md`
- 프로젝트 적용 사례: `docs/planning/REFERENCE_CASES.md`

Base 공용 문서는 새 방법·사례가 필요한 작업에서만 조건부로 확인한다.

## 현재 로컬 공용 사본

- `docs/AI_SHARED_WORK_RULES.md`
- `docs/AI_WORKFLOW_RULES.md`
- `docs/AI_SKILL_ADOPTION_GUIDE.md`
- `docs/MVP_WORKFLOW_CHECKLIST.md`
- `docs/BENCHMARKING_REFERENCE_GUIDE.md`
- `docs/DOCUMENTATION_MAP.md`

Base의 새 `docs/knowledge/` 문서는 현재 프로젝트에 전문을 복사하지 않고 기준 커밋과 경로를 참조한다. 프로젝트 특화 적용 결과는 `docs/planning/`에 유지한다.

## 사용 규칙

- Base 원격은 사용자가 공용 규칙·기획 지식 확인, 동기화, 승격을 요청했을 때만 연다.
- 프로젝트 고유 용어, 세계관, 저장 경로, Godot 명령, 사건 수치, 캐릭터 아트 스타일은 Base 공용 원칙으로 쓰지 않는다.
- 동기화는 원격 내용을 무조건 덮어쓰는 절차가 아니다. 공용 방법과 프로젝트 확장을 비교해 필요한 항목만 반영한다.
- 프로젝트 해결안은 먼저 프로젝트에서 검증하고, 공용성 확인 뒤 Base `cases/`에 승격한다.
- 한 프로젝트의 미검증 계획을 즉시 공용 method·skill로 승격하지 않는다.
- Base 기준이 프로젝트 최신 사용자 승인과 충돌하면 프로젝트 규칙이 우선한다.

## 과거 기록

2026-07-10~14의 Base 변경 이력, MVP-032~038 승격 후보, 자원 인식형 AI 운영, 외부 스킬 채택 기록은 백업 파일에서 찾는다. 정리 전 전체 원문은 다음 명령으로 확인할 수 있다.

```bash
git show 130466e66d3115876a85ba06f47b7661fae3f304:docs/BASE_RULES_VERSION.md
```
