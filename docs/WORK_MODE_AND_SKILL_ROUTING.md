# Work Mode·Skill 라우팅

## 한 번 선택하고 필요한 부분만 읽는다

시작 순서는 `AGENTS.md`를 따른다. `PLAN / BUILD / REVIEW` 중 현재 단계와 `skills/SKILL_REGISTRY.json`의 trigger/비사용 조건으로 주 분야 0~1개, 로컬 전문 0~1개, 지원 0~3개를 기본 선택한다. 지원 목록 전체를 연쇄 호출하지 않는다. 구현·검증·인계로 단계가 바뀌면 필요한 지원만 교체한다.

분야 Skill은 `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`와 선택한 본문을 읽는다. Read first는 공통 시작 순서 뒤의 **분야별 추가 자료**이지 별도 current-authority 순서가 아니다. Registry나 인덱스만 읽고 본문을 실행했다고 보고하지 않는다.

## Base 전문 해석

1. `docs/BASE_RULES_VERSION.md` → `skills/PROJECT_BASE_ADAPTER.json`의 `shared_overrides`를 먼저 확인한다.
2. 승인된 selective policy reference에 해당하면 기록된 exact commit의 해당 절만 읽는다. 원격 최신을 자동 채택하지 않는다.
3. 그 밖의 Base Skill은 `skills/BASE_SKILL_INDEX.json`의 released package를 유지한다. 공용 전문을 프로젝트에 복제하지 않는다.
4. `skills/PROJECT_PATH_ADAPTER.json` 등 생성된 호환 뷰의 과거 active_context는 현재 읽기 권한이 아니다. 현재 owner는 정본 adapter의 `current_authority`를 사용한다.
5. adapter/생성물·hash 불일치는 숨기지 말고 해당 공유 경로 실행 전에 검사·교정한다. 릴리스 pin을 검사 편의로 바꾸지 않는다.

`skills/BASE_SKILL_COVERAGE.json`은 책임 coverage 확인용이며 모든 Skill의 실행 목록이 아니다.

## 요청별 선택

| 현재 작업 | 주 책임/조건부 지원 |
|---|---|
| 새 변경·중대한 범위 모호성 | `managing-project-intake-and-work-contract`; 기존 승인 continuation은 계약 재사용 |
| 읽기 전용 상태 | 현재 Decision/Handoff와 실제 증거; 불일치 판단이 필요할 때 production-pm |
| 괴이 사건·전조·가설·근거·대응·매뉴얼 작성 | `skills/urban-legend-investigation-case-authoring/SKILL.md` + 필요한 분야 |
| 승인된 게임 구현 | engineering; 저장·엔진·UI 검증은 실제 영향에 따라 |
| UI·연출·효과 상태 | ux-ui-accessibility + 필요한 `auditing-and-refining-ui-art` reference |
| 경험 가설·반증·재미 검증 계획 | game-design / analytics-user-research / qa 중 현재 책임; `docs/UX_UI_SYSTEM.md#experience-verification` |
| 운영구조·read order·legacy 연결 | `managing-game-project-operating-system` audit/reconcile/verify |
| Skill·라우터 중복 | `simplifying-skill-bodies`; 고유 기능과 fixture 보존 |
| 실제 diff·회귀 / 공격 검토 | `reviewing-and-validating-project-changes` / `running-adversarial-review-and-refinement` |
| 참조·ID 전파 | `auditing-canonical-reference-freshness` |
| Git 동기화·인계 | `synchronizing-local-and-github-state` / `maintaining-project-context-and-handoff` |

## 적용 경계

- 같은 승인의 계획·조사·검토는 `docs/OPERATING_MODEL.md`의 공유 예산을 따른다. 플러그인 단계마다 별도 spec/plan/승인 루프를 다시 만들지 않는다.
- 외부 위임은 필수 단계가 아니다. 실제 capability·승인·추가 비용 0·보호 경계가 확인된 필요 작업에만 사용한다.
- 설치 스킬은 도구 사용법을 제공할 뿐 새 권한이나 다른 프로젝트 read order를 만들지 않는다. 충돌은 프로젝트 owner에서 해소하고 설치 파일을 임의 편집하지 않는다.
- 운영문서 변경은 엔진·자산 제작·플랫폼 심사 스킬을 호출하는 조건이 아니다.
- 새 스킬은 독립 trigger·입출력·검증 경계가 있을 때만 검토한다. 현재 분야 스킬·조건부 reference를 우선한다.
- 실제 사용한 mode·선택 이유·결과·미검증만 기존 기록에 남긴다. 모든 빈 보고 필드를 채우는 작업은 하지 않는다.
