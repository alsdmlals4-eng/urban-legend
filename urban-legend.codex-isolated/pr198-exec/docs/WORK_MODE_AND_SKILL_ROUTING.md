# Work Mode·Skill 라우팅

> Base 버전: `docs/BASE_RULES_VERSION.md` | 프로젝트 Registry: `skills/SKILL_REGISTRY.json` | Base 인덱스: `skills/BASE_SKILL_INDEX.json`

## 선택 순서

```text
Prompt
→ PLAN / BUILD / REVIEW
→ 프로젝트 분야 trigger: 주 Skill 0~1개
→ 프로젝트 로컬 trigger: 전문 Skill 0~1개
→ Base trigger·do-not-use: 지원 Skill 0~3개
→ 선택된 전문·필요 reference
→ 실행·검증·보고
```

`load_by_default=false`는 trigger가 없을 때 읽지 않는다는 뜻이다. 지원 목록 전체를 연쇄 호출하지 않는다. Registry 행만 읽고 Skill을 실행했다고 보고하지 않는다.

## 프로젝트 Skill 층

- **분야 Skill 10개:** 서사, 게임디자인, UX·UI, 엔지니어링, 테크아트, 아트, 오디오, QA, 프로덕션, 분석·유저리서치의 주 책임을 맡는다.
- **프로젝트 로컬 Skill:** 분야보다 좁은 반복 작업 계약을 맡는다. 현재 활성 로컬 Skill은 `skills/urban-legend-investigation-case-authoring/SKILL.md` 하나다.
- 사건 작성 작업은 로컬 Skill을 주 전문으로 선택하고, 실제 변경 성격에 따라 게임디자인·서사·QA 분야 Skill 중 주 책임 최대 하나만 함께 선택한다.
- 프로젝트 로컬 Skill이 존재해도 Base의 검증·적대적 검토·정본 최신성 책임을 대체하지 않는다.

## 주요 라우팅

| 요청 | Skill |
|---|---|
| 새 괴이 사건, 전조·가설·근거·대응·매뉴얼 후보·위험 사례 | `urban-legend-investigation-case-authoring` |
| 새 L1 이상·복합 범위 | `managing-project-intake-and-work-contract` |
| 기존 운영 구조·구형 파일 | `managing-game-project-operating-system` |
| 프로젝트 코어 읽기 전용 판정 | `identifying-project-core` |
| 코어 제안·사용자 승인 확정 | `establishing-project-core` |
| 컨셉·벤치마크·PoC | `analyzing-and-refining-game-concepts` |
| 적대적 공격·개선 루프 | `running-adversarial-review-and-refinement` |
| 죽은·중복·stale 자료 | `pruning-stale-and-nonfunctional-material` |
| 비대한 Skill·라우터 압축 | `simplifying-skill-bodies` |
| 기능 보존 구조 변경 | `refactoring-with-contract-preservation` |
| Skill 생성·통합·Health Review | `evolving-project-discipline-skills` |
| 실제 diff·런타임·회귀 | `reviewing-and-validating-project-changes` |
| 경로·ID·Schema·생성기 전파 | `auditing-canonical-reference-freshness` |
| Git local/remote drift | `synchronizing-local-and-github-state` |
| 긴 작업 checkpoint | `maintaining-long-running-task-continuity` |
| GUR 11영역 누락 감사 | `governing-game-user-research-coverage` |
| Godot 런타임 오류 | `diagnosing-game-engine-runtime-failures` |

## 구조 개선 결정

```text
행동을 바꾸지 않는 중복/죽은 경로? → pruning
조건부 상세 때문에 본문이 비대한가? → simplifying
사용 중 구조의 중복·복잡성을 줄이는가? → refactoring
Skill 책임 경계를 바꾸는가? → evolving
결과를 실패했다고 가정해 공격하는가? → adversarial review
실제 변경이 맞는가? → validation
```

같은 책임을 여러 Skill에서 중복 판정하지 않는다.

## 실행 보고

```yaml
work_mode:
primary_project_skill:
project_local_skill:
base_support_skills:
skill_modes:
selection_reason:
work_performed:
preserved_core_and_contracts:
evidence:
unverified:
status: PASS | PARTIAL | FAIL | UNVERIFIED
```
