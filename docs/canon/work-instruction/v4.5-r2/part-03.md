16. HiGodot/GUT/Hera 역할 경계에 따라 구현·테스트·QA
17. PR·exact validation target·ci-gate·적대적 검토
18. 승인 범위 안이면 자동 병합
19. merged-main readback
20. 사용자 로컬 Fetch/Pull 및 Godot Project Play
```

**중요:** PHASE A/B가 끝나기 전에는 PowerShell/Codex/Godot persistent implementation을 시작하지 않는다.
기획 중 10건 승인 배치 병합은 기획 정본·Decision·문서 변경을 닫는 것이며, Godot BUILD 시작 승인이 아니다.

---

## 1. 최초 진입 순서

작업 시작 시 다음 순서로 읽는다.

```text
Base current main SHA
→ recursive tracked-file inventory 또는 동등한 전체 범위 증거
→ START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ docs/generated/BASE_ACTIVE_SKILLS.md
→ 현재 요청에 필요한 책임 원본·Skill·mode·reference·Template·Test
→ 동일 Goal의 열린·최근 병합 PR
→ 대상 프로젝트 AGENTS/START_HERE/Active Context/Decision/Sheet/정본
→ 실제 코드·데이터·Scene·Resource·자산·테스트
```

`Base를 전부 살펴본다`는 의미:

```text
전체 저장소 범위와 권한 지도를 먼저 복원
+
현재 작업과 관계 있는 owner·consumer·test·recent PR을 깊게 읽음
```

다음을 의미하지 않는다.

```text
모든 Skill 본문을 무조건 컨텍스트에 로드
모든 과거 문서를 current authority로 취급
README 몇 개만 읽고 전체 검토 완료 주장
```

활성 Skill 수는 Registry 관찰값일 뿐 설계 목표가 아니다.
Skill 수를 유지하려고 필요한 독립 Skill을 금지하거나, 숫자를 늘리기 위해 중복 Skill을 만들지 않는다.

---

## 2. 권위 순서

현재 실행의 사실·결정 권위는 다음 순서로 해석한다.

1. 사용자의 최신 명시 지시와 승인된 결정
2. 현재 환경의 system/developer/security 실행 제약
3. 프로젝트 `AGENTS.md`, 보안·엔진·데이터 계약
4. 프로젝트 Active Context와 승인된 실행 계약
5. `CURRENT_CONFIRMED_DECISIONS` 및 등록된 분야 정본
6. 실제 코드·데이터·Scene·Resource·자산·테스트
7. 프로젝트에 채택된 Base Adapter/lock/snapshot
8. Base remote current `main`
9. 외부 공식·전문가·현업·플레이어 근거
10. 과거 draft·과거 prompt·검색 캐시·추정

