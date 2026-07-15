# Base Rules Version

> 문서 위치: `docs/BASE_RULES_VERSION.md` | 과거 동기화·승격 후보: `docs/archive/backup/2026-07-16/COMPLETED_QA_RULES_HANDOFF_BACKUP.md`

이 문서는 **Base 공용 규칙 동기화 작업에서만** 읽는다. 일상적인 urban-legend 구현·기획 작업의 기본 읽기 대상이 아니다.

## 현재 동기화 기준

| 항목 | 값 |
|---|---|
| 공용 원본 | `alsdmlals4-eng/Base` |
| 기준 브랜치 | `main` |
| 마지막 확인 기준 커밋 | `f8cf0a1` |
| 마지막 확인일 | 2026-07-14 |
| 현재 상태 | 프로젝트 로컬 확장 유지 / Base 원격 자동 덮어쓰기 금지 |

## 사용 규칙

- Base 원격은 사용자가 공용 규칙 확인·동기화·승격을 요청했을 때만 연다.
- 프로젝트 고유 용어, 저장 경로, Godot 명령, 사건 수치, 캐릭터·이미지 스타일은 Base로 승격하지 않는다.
- 동기화는 원격 내용을 무조건 덮어쓰는 절차가 아니다. 공용 변경과 프로젝트 확장을 비교해 필요한 항목만 반영한다.
- 새 공용 후보는 현재 작업 완료 보고에 간단히 적고, 검증 전 Base 원격을 수정하지 않는다.

## 현재 로컬 사본

- `docs/AI_SHARED_WORK_RULES.md`
- `docs/AI_WORKFLOW_RULES.md`
- `docs/AI_SKILL_ADOPTION_GUIDE.md`
- `docs/MVP_WORKFLOW_CHECKLIST.md`
- `docs/BENCHMARKING_REFERENCE_GUIDE.md`
- `docs/DOCUMENTATION_MAP.md`

## 과거 기록

2026-07-10~14의 Base 변경 이력, MVP-032~038 승격 후보, 자원 인식형 AI 운영, 외부 스킬 채택 기록은 백업 파일에서 찾는다. 정리 전 전체 원문은 다음 명령으로 확인할 수 있다.

```bash
git show 130466e66d3115876a85ba06f47b7661fae3f304:docs/BASE_RULES_VERSION.md
```
