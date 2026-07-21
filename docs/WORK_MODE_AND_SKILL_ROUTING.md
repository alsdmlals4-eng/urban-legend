# Work Mode·Skill·Skill Mode 라우팅

> Base 기준: `alsdmlals4-eng/Base@ee265576da7f67d3278f8099dd97d4e714ef0651`  
> Registry: `skills/SKILL_REGISTRY.json` | 프로젝트 Skill: `skills/disciplines/` | 경로 어댑터: `skills/PROJECT_PATH_ADAPTER.json`

## 1. 용어

| 구분 | 의미 |
|---|---|
| Work Mode | 현재 단계의 작업 자세·쓰기 권한·증거 기준 |
| Skill | 특정 책임을 반복 수행하는 실제 `SKILL.md` 작업 계약 |
| Skill Mode | Skill 내부에서 현재 필요한 세부 절차 |
| Prompt | 사용자의 현재 목표·제약·산출물 |

| Work Mode | 목적 | 기본 권한 |
|---|---|---|
| `PLAN` | 의도·요구·근거·설계·순서 확정 | 읽기·조사·제안, 승인 전 구조 변경 보류 |
| `BUILD` | 승인 범위의 코드·데이터·문서·자산 구현 | 범위 내 쓰기, 단계별 검증·롤백 |
| `REVIEW` | 적대적 검토·반례·검증·판정 | 기본 읽기 전용, finding과 증거 우선 |

복합 작업은 `PLAN → BUILD → REVIEW`로 전환할 수 있다. `REVIEW`에서 수정 범위가 이미 승인돼 있으면 `BUILD`로 최소 수정한 뒤 다시 `REVIEW`한다.

## 2. 자동 선택과 실제 실행 순서

```text
사용자 Prompt
→ 의도·현재 단계·위험 파악
→ 주 Work Mode 하나 선택
→ Registry trigger·do_not_use_when 대조
→ 주 책임 프로젝트 분야 Skill 최대 1개 선택
→ Foundation·전문 지원 Skill 최대 3개 선택
→ Registry가 가리키는 실제 SKILL.md 전문 읽기
→ 각 Skill의 Skill Mode 선택
→ 책임 원본·실제 파일 확인
→ 실행·검증
→ 사용 이유·수행 내용·결과·증거·미검증 보고
```

- 사용자는 Skill 또는 Skill Mode를 선언할 필요가 없다.
- Registry 행만 읽고 Skill을 사용했다고 보고하지 않는다.
- 프로젝트 분야 Skill은 `project_disciplines[].path`의 실제 `SKILL.md`를 읽는다.
- Base Skill은 고정 커밋의 `base_skills[].base_path` 전문을 읽는다.
- 주 책임 프로젝트 분야 Skill은 최대 하나다.
- Foundation·검증·발행·Handoff Skill은 현재 단계에 필요한 것만 추가하며 최대 3개다.
- 같은 책임을 여러 Skill에서 중복 판정하지 않는다.
- `load_by_default=false`는 trigger가 없을 때 읽지 않는다는 뜻이다.
- 전체 `skills/` 폴더를 기본 컨텍스트로 읽지 않는다.

## 3. 활성 구조

### Base Skill

- 활성 13개
- Registry trigger·비사용 조건·review trigger는 Base Registry blob `2291bce0d139905f8b8b6721ffbc9859774dcb06`과 일치한다.
- 전문은 Base 고정 커밋에서 필요할 때만 읽는다.

### 프로젝트 분야 Skill

| Skill | 주요 mode |
|---|---|
| `urban-legend-narrative` | `route`, `author`, `continuity-review` |
| `urban-legend-game-design` | `system-design`, `rule-change`, `balance-review` |
| `urban-legend-ux-ui-accessibility` | `architecture`, `accessibility`, `interaction-review` |
| `urban-legend-engineering` | `implement`, `data-boundary`, `compatibility-review` |
| `urban-legend-technical-art-pipeline` | `import`, `manifest`, `pipeline-review` |
| `urban-legend-art` | `direction`, `asset-spec`, `continuity-review` |
| `urban-legend-audio` | `direction`, `event-spec`, `mix-review` |
| `urban-legend-qa` | `plan`, `execute`, `defect-triage`, `release-gate` |
| `urban-legend-production-pm` | `scope`, `sequence`, `status-review`, `production-handoff` |
| `urban-legend-analytics-user-research` | `research`, `telemetry`, `playtest-analysis`, `synthesis` |

프로젝트 trigger는 분야 간 완전 중복이 없도록 구체화했다. 대표 routing example은 Registry에 있으며 CI가 주 Skill 중복과 지원 Skill 상한을 검사한다.

### 통합된 Skill

`urban-legend-integration-review`는 독립된 입력·산출물·검증이 없어 활성 Skill에서 제거했다.

```text
urban-legend-integration-review
→ reviewing-and-validating-project-changes:
   contract-check / static-validation / regression / evidence-report
→ managing-game-project-operating-system: verify
```

기존 ID는 `skills/LEGACY_SKILL_ALIASES.md`로 호환한다.

## 4. 주요 라우팅

| 요청 | Work Mode·Skill Mode |
|---|---|
| 새 L1 이상 요청·복합 범위 | `PLAN` + `managing-project-intake-and-work-contract: route/contract`, 필요 시 `decompose-and-sequence` |
| 기존 프로젝트 구조 감사 | `PLAN/REVIEW` + `managing-game-project-operating-system: audit` |
| 구형·중복·stale 파일 | `audit → reconcile-legacy`, 승인 뒤 `BUILD`, 이후 `verify` |
| Skill 누락·중복·통합 | `evolving-project-discipline-skills: inventory/consolidation/health-review` |
| 기획 책임 원본 작성·수정 | 프로젝트 분야 Skill + `managing-design-documents: author/update/restructure` |
| 발행본 갱신 | 발행 정책 확인 뒤 `managing-design-documents: publish/validate` |
| 핵심 컨셉·벤치마크·플레이테스트 전략 | `analyzing-and-refining-game-concepts`의 필요한 mode |
| 구현·문서·데이터 변경 검증 | 프로젝트 `urban-legend-qa` 또는 Base `reviewing-and-validating-project-changes`의 필요한 mode |
| 최종 통합검수 | `reviewing-and-validating-project-changes` + `managing-game-project-operating-system: verify` |
| 경로·ID·Schema·정본 변경 | `auditing-canonical-reference-freshness` |
| UI 실제 결과 감사 | `auditing-and-refining-ui-art`, 승인된 수정 뒤 전후 렌더 재검수 |
| 프로젝트 교훈의 Base 승격 | `managing-base-change-proposals`, 제안과 Base 구현 PR 분리 |

## 5. 기존 파일 처리 권한

구형 파일은 먼저 다음 상태로 판정한다.

```text
CURRENT
UPDATE_IN_PLACE
MERGE_TO_CANONICAL
COMPATIBILITY_STUB
ARCHIVE_HISTORY
DELETE_APPROVED
KEEP_UNRESOLVED
```

승인된 처리표가 없으면 `PLAN/REVIEW`에서 판정과 제안까지만 수행한다. 현행 원본 이동·삭제, Base식 강제 개명, 보호 경로 수정은 자동 승인되지 않는다.

## 6. Skill 구조 검증

```text
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py
```

검사 범위:

- Base trigger 원본 일치
- 프로젝트 Registry와 실제 Skill 패키지 1:1
- front matter name·description
- 책임 원본과 로컬 참조 존재
- 프로젝트 trigger 중복 없음
- 대표 routing example 결과
- 통합 Skill alias 완전성
- 선택적 로드 상한

## 7. 실행 보고

L1 이상 최종 보고 최소 형식:

```yaml
work_mode:
skill_id:
skill_mode:
selection: automatic | user-directed
reason:
work_performed:
result:
evidence:
status: PASS | PARTIAL | FAIL | UNVERIFIED
```

Skill 파일을 읽은 것과 실제 절차를 실행한 것을 구분한다. 중요 후보를 쓰지 않았으면 trigger 불일치, 현재 단계 아님, 입력·도구 없음 중 실제 이유를 기록한다.
