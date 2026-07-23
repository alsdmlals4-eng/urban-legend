# Legacy Skill Aliases

2026-07-21 Base Skill 통합 이전의 ID와 프로젝트 통합 전 ID를 최신 Skill·Skill Mode로 연결한다. 이 파일은 과거 Issue·PR·문서 검색과 호환 라우팅용이며 활성 Skill Registry가 아니다.

| 이전 Skill ID | 새 Skill ID | Skill Mode |
|---|---|---|
| `routing-project-work-by-discipline` | `managing-project-intake-and-work-contract` | `route` |
| `conducting-deep-requirement-interviews` | `managing-project-intake-and-work-contract` | `clarify` |
| `transforming-requests-into-prompts` | `managing-project-intake-and-work-contract` | `contract` |
| `installing-game-project-operating-system` | `managing-game-project-operating-system` | `install` |
| `migrating-existing-game-project-structure` | `managing-game-project-operating-system` | `audit` / `migrate` |
| `verifying-game-project-operating-system` | `managing-game-project-operating-system` | `verify` |
| `writing-game-design-documents` | `managing-design-documents` | `author` / `update` / `restructure` |
| `publishing-discipline-bibles` | `managing-design-documents` | `publish` / `validate` |
| `promoting-project-knowledge` | `managing-base-change-proposals` | `extract` / `submit` |
| `reviewing-and-implementing-base-change-proposals` | `managing-base-change-proposals` | `review` / `implement` / `verify` |
| `reviewing-external-ai-drafts` | `reviewing-and-validating-project-changes` | `external-source-review` / `static-validation` / `regression` / `evidence-report` |
| `urban-legend-integration-review` | `reviewing-and-validating-project-changes` + `managing-game-project-operating-system` | `contract-check` / `static-validation` / `regression` / `evidence-report` + `verify` |

## 프로젝트 이주 규칙

- 새 문서·Registry·작업 계약에는 새 Skill ID만 사용한다.
- 과거 Issue·PR·Git 이력의 이전 ID는 기록 보존을 위해 수정하지 않아도 된다.
- 실행 경로에서 이전 ID를 발견하면 이 표로 변환하고 결과에는 새 Skill ID와 Skill Mode를 기록한다.
- 이전 Skill 파일을 활성 Registry에 등록하지 않는다.
- 프로젝트 고유 분야 Skill은 실행 패키지를 가진 10개만 활성화한다.
- `urban-legend-integration-review`는 고유 입력·산출물·검증이 없어 Base 통합검수와 운영체계 `verify`로 흡수한다.
