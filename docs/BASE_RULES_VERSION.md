# Base Rules Version

> 문서 위치: `docs/BASE_RULES_VERSION.md` | 프로젝트 운영 모델: `docs/OPERATING_MODEL.md` | Skill Registry: `skills/SKILL_REGISTRY.json` | 경로 어댑터: `skills/PROJECT_PATH_ADAPTER.json` | 과거 동기화 기록: `docs/archive/backup/2026-07-16/COMPLETED_QA_RULES_HANDOFF_BACKUP.md`

이 문서는 Base 공용 규칙·Skill·기획 지식 동기화 작업에서만 읽는다. 일상적인 `urban-legend` 구현·기획 작업은 `START_HERE.md`, `AGENTS.md`, `docs/CURRENT_STATUS.md`, `docs/planning/`을 먼저 읽는다.

## 현재 동기화 기준

| 항목 | 값 |
|---|---|
| 공용 원본 | `alsdmlals4-eng/Base` |
| 기준 브랜치 | `main` |
| 기준 커밋 | `ee265576da7f67d3278f8099dd97d4e714ef0651` |
| 확인일 | 2026-07-21 |
| 대조 범위 | 최상위 운영 정본·Registry·Legacy Alias·13개 Active Skill 전문·필요 Schema/Template |
| Base 운영 버전 | Work Mode·자동 Skill 라우팅·13개 활성 Skill·구형 파일 정리·참조 무결성 감사 |
| 현재 상태 | 비파괴 동기화 PR 검토 중 / 프로젝트 책임 원본 경로 유지 / 원격 자동 병합 금지 |

## 동기화 방식

Base의 공용 원본은 원격 고정 커밋으로 참조한다. 전체 Base 파일·Skill을 프로젝트에 복제하지 않는다.

```text
Base START_HERE·AGENTS
→ Base OPERATING_MODEL
→ WORK_MODE_AND_SKILL_ROUTING
→ DOCUMENTATION_MAP
→ Base SKILL_REGISTRY·LEGACY_SKILL_ALIASES
→ Active Skill 13개 전문과 필요한 reference·schema·template
→ PROJECT_PATH_ADAPTER의 프로젝트 실제 경로
→ urban-legend의 현행 책임 원본·실제 파일
```

`urban-legend`는 기존 운영 프로젝트이므로 신규 설치형 구조를 강제하지 않는다.

- 기존 책임 원본: 현재 경로 유지
- 프로젝트 고유 규칙: `AGENTS.md` 우선
- Base 운영 계약: `docs/OPERATING_MODEL.md`에 프로젝트 적용
- Work Mode·Skill 라우팅: `docs/WORK_MODE_AND_SKILL_ROUTING.md`
- Base 13개 Skill과 프로젝트 11개 분야: `skills/SKILL_REGISTRY.json`
- Base 역할·예시 경로의 실제 프로젝트 binding: `skills/PROJECT_PATH_ADAPTER.json`
- 통합 전 ID: `skills/LEGACY_SKILL_ALIASES.md`
- Base 전문: 필요할 때 이 문서의 고정 커밋에서 읽음

Base Skill의 `[기획서]/...` 경로는 설치 예시이며 이 프로젝트의 정본 경로가 아니다. 경로 어댑터가 `START_HERE.md`, `docs/CURRENT_STATUS.md`, `docs/DOCUMENTATION_MAP.md`, 기존 Handoff·Roadmap·검증·GDD 경로로 변환한다.

## 이번 Base 반영

- `PLAN / BUILD / REVIEW` Work Mode
- Prompt 의도와 현재 단계 기반 자동 Skill·Skill Mode 선택
- L1 이상 Skill 실행 이유·수행·결과·미검증 보고
- 13개 최신 활성 Base Skill 전문의 trigger·mode·입력·실패 조건 대조
- 구형 Foundation Skill ID의 통합 별칭
- 기존 프로젝트 `audit / reconcile-legacy / migrate / verify`
- `CURRENT / UPDATE_IN_PLACE / MERGE_TO_CANONICAL / COMPATIBILITY_STUB / ARCHIVE_HISTORY / DELETE_APPROVED / KEEP_UNRESOLVED` 판정
- 정본·경로·ID·Schema·정책·생성기 변경의 reference-freshness 감사
- Base 예시 경로를 프로젝트 실제 경로로 고정하는 어댑터
- 자동 Registry·경로 binding·발행 호환·보존·회귀 검증과 GitHub Actions

## 기획 문서 발행 호환

Base의 Design Document Registry v3 템플릿은 `milestone_sync`와 `always_sync`에 PDF와 Publication Manifest를 요구한다. 현재 프로젝트는 다음 검증된 계약을 사용한다.

```text
docs/GAME_DESIGN_DOCUMENT.md
→ tools/docs/build_game_design_doc.py
→ docs/URBAN_LEGEND_GAME_DESIGN.docx
→ --check
```

따라서 이번 동기화에서는 `docs/DOCUMENTATION_MAP.md`를 문서 Registry 상당 책임 원본으로 유지한다. PDF·Manifest 기반 v3 Registry로의 이주는 `DEFERRED_REQUIRES_SEPARATE_APPROVAL`이며, 이를 현행 완료로 가장하지 않는다.

## 프로젝트에 유지하는 것

- 캐릭터명, 괴이 규칙, 세계관, 수치
- 저장 구조와 기존 ID
- Godot 경로·Scene·데이터 계약
- 승인 이미지와 실제 QA 결과
- 현재 프로젝트 기획 책임 원본

프로젝트에서 우선할 문서:

- 현재 구현·승인 계획: `docs/CURRENT_STATUS.md`
- 기획 인수인계: `docs/planning/README.md`
- 프로젝트 방향: `docs/planning/PROJECT_DIRECTION.md`
- 서사·관계: `docs/planning/NARRATIVE_CONTENT_PLAN.md`
- 아트·연출: `docs/planning/ART_PRESENTATION_PLAN.md`
- 로드맵·인수인계: `docs/planning/ROADMAP_AND_HANDOFF.md`
- 적용 사례: `docs/planning/REFERENCE_CASES.md`

## 로컬 공용 사본 수명주기

| 파일 | 판정 | 현재 역할 |
|---|---|---|
| `docs/AI_SHARED_WORK_RULES.md` | `COMPATIBILITY_STUB` + 원문 보존 | 최신 운영 모델로 연결하고 고유 절차 유지 |
| `docs/AI_WORKFLOW_RULES.md` | `COMPATIBILITY_STUB` + 프로젝트 확장 보존 | 최신 라우팅과 프로젝트 외부 위임·Goal 절차 연결 |
| `docs/AI_SKILL_ADOPTION_GUIDE.md` | `CURRENT` | 프로젝트가 검토한 외부 Skill 사례와 채택 판단 유지 |
| `docs/MVP_WORKFLOW_CHECKLIST.md` | `UPDATE_IN_PLACE` | 프로젝트 MVP 절차와 최신 실행 보고 결합 |
| `docs/BENCHMARKING_REFERENCE_GUIDE.md` | `CURRENT` | 프로젝트 외부 근거 수집 규칙 유지 |

## 사용 규칙

- Base 원격은 공용 규칙·Skill·기획 지식 확인, 동기화, 승격 요청에서만 연다.
- 동기화는 원격 내용을 무조건 덮어쓰거나 프로젝트 경로를 Base 구조로 강제하는 절차가 아니다.
- Base 기준이 최신 사용자 승인, 프로젝트 불변 조건, 실제 구현과 충돌하면 프로젝트 규칙과 실제 파일이 우선한다.
- Base 문서의 예시 경로는 `skills/PROJECT_PATH_ADAPTER.json`에서 실제 경로로 변환한다.
- 프로젝트 해결안은 먼저 프로젝트에서 검증하고 공용성 확인 뒤 Base 변경 제안으로 분리한다.
- 제안 PR과 Base 활성 구현 PR을 합치지 않는다.
- Base 기준을 바꾸면 이 문서, 운영 모델, Registry, 경로 어댑터, 테스트의 커밋 값을 함께 갱신한다.

## PR 감사 기록

2026-07-20의 Base 이주 PR #41~#43은 승인 계약과 달리 현행 문서 대규모 이동, 루트 규칙 축약, 구형 Foundation Skill 활성화를 포함해 병합 차단으로 판정했다. 상세 근거와 대체 처리표는 `docs/qa/BASE_SYNC_AUDIT_2026-07-21.md`에 기록한다.

## 과거 기록

2026-07-10~16의 Base 변경 이력, MVP-032~038 승격 후보, 자원 인식형 AI 운영, 외부 Skill 채택 기록은 백업 파일과 Git 이력에서 찾는다.
