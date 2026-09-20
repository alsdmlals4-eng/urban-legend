# 괴이기록국: 작업 시작점

읽기 순서는 `AGENTS.md`의 **Current-authority read order** 한 곳만 따른다. 여기서는 필요한 책임 원본을 고른다.

| 알고 싶은 것 | 책임 원본 |
|---|---|
| 최신 승인·대체된 결정 | `docs/CURRENT_DECISION_OVERLAY.md` |
| 현재 작업·다음 행동·차단 사항 | `docs/CURRENT_HANDOFF.md`의 현재 블록 |
| 제품 약속·사건 구조·현재 기획 | `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json` |
| 사람용 전체 그림 | `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`; PDF는 파생 검토본 |
| 보호할 코어와 기존 의미 | `docs/PROJECT_CORE.md` + 최신 Decision의 대체 관계 |
| Base 채택·업데이트 경계 | `docs/BASE_RULES_VERSION.md`, `skills/PROJECT_BASE_ADAPTER.json` |
| 작업 진행·검토·보고 | `docs/OPERATING_MODEL.md` |
| 필요한 분야 Skill 선택 | `docs/WORK_MODE_AND_SKILL_ROUTING.md`, `skills/SKILL_REGISTRY.json` |
| 분야 문서·검증 위치 | `docs/DOCUMENTATION_MAP.md`, `TEST_CHECKLIST.md` |
| 재미 가설·UI/효과·검증 연결 | `docs/UX_UI_SYSTEM.md#experience-verification` |
| M01/M04 검증 대상 구분 | `docs/VALIDATION_TARGET_CANON.md` |

## 작업 종류별 최소 진입

- **상태 질문·검토만:** Decision/Handoff와 질문에 필요한 실제 파일·Git 증거를 읽고 답한다. 파일 수정·새 승인·전체 엔진 실행을 만들지 않는다.
- **승인된 작업 재개:** 기존 계약·남은 작업·변경된 source를 복원한다. 같은 계획을 새 파일로 다시 만들거나 승인받지 않는다.
- **새 변경:** 현재 owner/consumer를 확인해 변경·보호 범위와 검증 방법을 먼저 설명한다.
- **기획·표현·규칙 변경:** 필요한 현재 기획과 분야 정본을 추가한다. 벤치마크나 예시 PDF를 게임 요구사항으로 복사하지 않는다.

## 현재와 이력을 구분한다

최신 main의 실제 파일과 현재 작업 브랜치의 변경을 따로 확인한다. 병합되지 않은 구현을 main 완료로 보고하지 않는다. 과거 PR #180·#224·#322·#356과 2026-08-22 계획은 predecessor history이며, 현재 완료 여부·실행 권한은 Decision/Handoff와 새 검증으로 판정한다.

`docs/CURRENT_STATUS.md`, `docs/CURRENT_CONFIRMED_DECISIONS.md`, `docs/CURRENT_HANDOFF_VALIDATION.md`, 과거 계획은 역사·저장 migration·회귀 근거가 필요할 때만 읽는다. 현재 일정·등장인물·Gate 값은 이 시작 문서에 복제하지 않는다.
