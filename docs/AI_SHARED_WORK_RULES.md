# AI Shared Work Rules — Compatibility Stub

> 수명주기: `COMPATIBILITY_STUB`  
> 최신 운영 원본: `docs/OPERATING_MODEL.md`  
> Work Mode·Skill 라우팅: `docs/WORK_MODE_AND_SKILL_ROUTING.md`  
> Base 기준: `docs/BASE_RULES_VERSION.md`

이 경로는 과거 링크를 깨지 않기 위해 유지한다. 이전 Base 공용 규칙의 로컬 전문을 현행 작업 계약으로 사용하지 않는다.

새 작업은 다음 순서로 이동한다.

```text
START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/CURRENT_STATUS.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 실제 대상 파일
```

프로젝트 고유 불변 조건·보호 경로·저장 계약은 `AGENTS.md`가 책임진다. Base 전문이 필요하면 `docs/BASE_RULES_VERSION.md`에 고정된 Base 커밋에서 현재 요청에 필요한 파일만 읽는다.
