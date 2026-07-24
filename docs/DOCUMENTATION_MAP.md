# Documentation Map

> 문서 위치: `docs/DOCUMENTATION_MAP.md` | 시작 지점: `../START_HERE.md` | 운영 모델: `OPERATING_MODEL.md` | 문서 보존 규칙: `DOCUMENT_LIFECYCLE.md` | 백업 찾기: `archive/README.md`

이 문서는 작업에 필요한 책임 원본과 Skill만 선택하는 라우터다. 모든 문서나 Skill을 매번 읽지 않는다. Base 버전은 `BASE_RULES_VERSION.md` 한 곳에서 관리한다.

## 기본 읽기 순서

### 일반 구현·버그 수정

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ OPERATING_MODEL.md
→ WORK_MODE_AND_SKILL_ROUTING.md
→ CURRENT_STATUS.md
→ PROJECT_CORE.md
→ DOCUMENTATION_MAP.md
→ SKILL_REGISTRY.json
→ 선택된 Skill·책임 원본
→ 대상 코드·데이터·문서
```

### 새 기획·콘텐츠·아트·연출·인수인계

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ CURRENT_STATUS.md
→ planning/README.md
→ planning/PROJECT_DIRECTION.md
→ 분야별 기획서 1개
→ SKILL_REGISTRY.json
→ 선택된 프로젝트 로컬/분야 Skill과 필요한 Base Skill
→ 대상 코드·데이터·에셋
```

추가 문서는 실제 작업 조건이 있을 때만 읽는다.

## 운영 책임 원본

| 책임 | 현행 원본 | 읽기 조건 |
|---|---|---|
| 강제 규칙·불변 용어 | `../AGENTS.md` | 항상 |
| 콜드 스타트 | `../START_HERE.md` | 새 채팅·새 작업자 |
| 현재 구현·승인 계획·미구현 구분 | `CURRENT_STATUS.md` | 항상 |
| 프로젝트 코어·변경 경계 | `PROJECT_CORE.md` | L1 이상·구조·기획·검수 |
| 운영 생명주기 | `OPERATING_MODEL.md` | L1 이상 |
| Work Mode·Skill 라우팅 | `WORK_MODE_AND_SKILL_ROUTING.md` | Skill 선택·보고 |
| Base 버전 | `BASE_RULES_VERSION.md` | Base 적용·동기화 |
| 프로젝트 Skill Registry | `../skills/SKILL_REGISTRY.json` | trigger 선택 |
| Base Skill 인덱스 | `../skills/BASE_SKILL_INDEX.json` | Base trigger 선택 |
| Base 기능 Coverage | `../skills/BASE_SKILL_COVERAGE.json` | 누락·통합 감사 |
| 분야 공통 계약 | `../skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md` | 분야 Skill 실행 |
| Base 경로 변환 | `../skills/PROJECT_PATH_ADAPTER.json` | Base 예시 경로 해석 |
| 검증 계약 | `../TEST_CHECKLIST.md` | 변경 시 |
| 문서 보존·백업 정책 | `DOCUMENT_LIFECYCLE.md` | 문서 이동·정리 |

같은 사실을 다른 문서에 장문으로 복사하지 않고 책임 원본을 링크한다.

## 프로젝트 기획 원본

| 주제 | 현행 원본 | 읽기 조건 |
|---|---|---|
| 기획 인수인계·분야별 라우팅 | `planning/README.md` | 기획·콘텐츠·아트·연출·새 담당자 인수 |
| 프로젝트 약속·핵심 방향 | `planning/PROJECT_DIRECTION.md` | 방향·범위·캐릭터·미감 판단 |
| 서사·대화·관계 | `planning/NARRATIVE_CONTENT_PLAN.md` | 사건 대사, 일상, 관계 이벤트 |
| 아트·표정·컷인·연출 | `planning/ART_PRESENTATION_PLAN.md` | 캐릭터 아트, 대화 UI, 연출 |
| 준비·조사·결과 정보 위계 | `planning/PROGRESSIVE_DISCLOSURE_PLAN.md` | UX-PD-001 후속 |
| 단계 의존성·인수인계 | `planning/ROADMAP_AND_HANDOFF.md` | MVP 시작·종료, 역할 교대 |
| 적용 사례 | `planning/REFERENCE_CASES.md` | 기존 근거 재사용, 적용·제외 판단 |
| 상세 게임 설계 | `GAME_DESIGN_DOCUMENT.md` | 프로젝트 전체 시스템·콘텐츠 상세 변경 |
| CORE-MVP-001 마일스톤 계약 | `superpowers/specs/2026-07-23-project-core-integrated-spec.md` | CORE-MVP-001 구현·검증 기간에만 읽음 |
| CORE-MVP-001 실행 계획 | `superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md` | CORE-MVP-001 TDD 구현·QA·게이트 |
| 프로젝트 용어·표현 원칙 | `PROJECT_CONTEXT.md` | 대사·세계관·캐릭터 작업 |
| 구현 순서 | `../MVP_ROADMAP.md` | 범위·우선순위 결정 |
| 검증 계약 | `../TEST_CHECKLIST.md` | 구현·문서 변경 |
| 실행·프로젝트 소개 | `../README.md` | 실행·외부 안내 |
| 현재 계정 인수 상태 | `CURRENT_HANDOFF.md` | 계정·채팅 교대 |

`GAME_DESIGN_DOCUMENT.md`는 프로젝트 전체 상세 게임 설계 정본이다. CORE-MVP-001 마일스톤 계약은 그 전역 책임을 대체하지 않고, 승인된 PoC의 고정 ID·상태·테스트 경계만 구체화한다. 두 문서가 충돌하면 `PROJECT_CORE.md → GAME_DESIGN_DOCUMENT.md → CURRENT_STATUS.md → CORE-MVP-001 마일스톤 계약` 순으로 권한을 판정하고 충돌을 즉시 보고한다.

## Skill 조건부 라우팅

| 작업 조건 | 프로젝트 Skill | 추가 책임 원본 |
|---|---|---|
| 새 괴이 사건·전조·가설·근거·대응·매뉴얼 작성/개정 | `urban-legend-investigation-case-authoring` | `CURRENT_STATUS.md`, `planning/PROJECT_DIRECTION.md`, `GAME_DESIGN_DOCUMENT.md`, `MINIGAME_SYSTEM_SPEC.md`, 실제 에피소드 데이터 |
| 대사·상황지시문·일상·후일담 | `urban-legend-narrative` | `planning/NARRATIVE_CONTENT_PLAN.md`, `DIALOGUE_AUTHORING_WORKFLOW.md`, `PROJECT_CONTEXT.md` |
| 조사·안정화·미니게임·캠페인·밸런스 | `urban-legend-game-design` | GDD, `MINIGAME_SYSTEM_SPEC.md` |
| UI·입력·접근성 | `urban-legend-ux-ui-accessibility` | `planning/PROGRESSIVE_DISCLOSURE_PLAN.md`, `GODOT_NATIVE_UI_ARCHITECTURE.md`, `CINEMATIC_FIELD_RECOVERY_UI.md` |
| Godot·저장·Scene·데이터 계약 | `urban-legend-engineering` | 실제 코드·테스트; 런타임 실패면 Base `diagnosing-game-engine-runtime-failures` |
| 에셋 import·Manifest | `urban-legend-technical-art-pipeline` | `IMAGE_ASSET_WORKFLOW.md` |
| 캐릭터 아트·표정·컷인 | `urban-legend-art` | `planning/ART_PRESENTATION_PLAN.md`, `IMAGE_ASSET_WORKFLOW.md` |
| 오디오 | `urban-legend-audio` | GDD, `planning/PROJECT_DIRECTION.md` |
| 테스트·release gate | `urban-legend-qa` | `../TEST_CHECKLIST.md`, `MVP_WORKFLOW_CHECKLIST.md` |
| Roadmap·Issue·PR·Handoff | `urban-legend-production-pm` | `../MVP_ROADMAP.md`, `planning/ROADMAP_AND_HANDOFF.md` |
| 연구·텔레메트리·플레이테스트 | `urban-legend-analytics-user-research` | `BENCHMARKING_REFERENCE_GUIDE.md`, `planning/REFERENCE_CASES.md` |

구조 최적화는 Base `pruning → simplifying/refactoring → adversarial review → validation` 순서를 따른다.

## 기타 조건부 문서

| 작업 조건 | 추가로 읽을 문서 |
|---|---|
| CORE-MVP-001 구현·검증 | 통합 명세, 상세 구현 계획, `planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md` |
| 관계 태그·선택 기억·연속 이벤트 | `planning/NARRATIVE_CONTENT_PLAN.md`, 실제 저장·이벤트 데이터 |
| 외부 GPT·DeepSeek·이미지 모델 위임 | `AI_DELEGATION_WORKFLOW.md` |
| 기존 사례 재사용 | `planning/REFERENCE_CASES.md` |
| 최신 외부 사례 비교가 필요한 새 판단 | `BENCHMARKING_REFERENCE_GUIDE.md`와 필요한 최신 1차 근거 |
| 저장·진행·일정·위험·경제 | 관련 코드, `MVP037_CAMPAIGN_CORE.md`, `MVP038_SEQUENTIAL_CAMPAIGN.md` |
| 실제 MVP 시작·종료 절차 | `planning/ROADMAP_AND_HANDOFF.md`, `MVP_WORKFLOW_CHECKLIST.md` |
| Base 공용 규칙·기획 지식 승격 | `AI_SHARED_WORK_RULES.md`, `BASE_RULES_VERSION.md`, Base `docs/knowledge/` |
| 계정 교대·저사용량 checkpoint | `CURRENT_HANDOFF.md`, `CODEX_ACCOUNT_HANDOFF.md` |
| 과거 결정·완료 근거 | `archive/README.md`에서 필요한 파일 하나만 선택 |

## 리디렉션 문서

다음 파일은 기존 링크를 보존하기 위한 위치 안내용이며 현행 설계 원본이 아니다.

- `../DESIGN_INTENT.md`
- `../PROJECT_BRIEF.md`
- `CONTENT_DIRECTION_V09.md`
- `BASE_RULES_VERSION.md` — Base 동기화 작업 외에는 읽지 않음

리디렉션 문서를 본 뒤 연결된 현행 원본 또는 백업 파일로 이동하며, 내용 동기화 작업을 만들지 않는다.

## 기본 읽기 제외

- `archive/**`
- 완료된 `qa/**`
- 완료된 `CODEX_GOAL_*`
- `benchmarks/**`
- `superpowers/**` — 단, 현재 활성 마일스톤 계약과 실행 계획은 위 조건부 라우팅으로 예외
- 과거 보고서·HTML·일회성 감사
- Base 전체 Skill 폴더

이 자료는 현재 작업의 직접 근거가 필요할 때만 연다. “혹시 필요할 수 있음”은 읽기 조건이 아니다.

## 활성 계획 라우팅

현재 유일한 활성 구현 트랙은 CORE-MVP-001이다.

```text
CURRENT_STATUS.md
→ PROJECT_CORE.md
→ planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md
→ superpowers/specs/2026-07-23-project-core-integrated-spec.md
→ ../MVP_ROADMAP.md
→ superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md
→ ../TEST_CHECKLIST.md
→ 실제 PoC 코드·데이터·장면·테스트
```

UX-PD-001 2B·2C와 MVP-044~046 전달 패키지는 CORE-MVP-001 플레이 증거 뒤 재매핑한다. 패키지 전체를 저장소 현행 문서로 복사하지 않으며, 구현 완료 후 확정된 결과만 상태·GDD·검증·분야별 기획서에 통합한다.

## Base 승격 라우팅

- Base로 보낼 것: 반복 가능한 기획 방법, 조사 방식, 아트·연출 판단 프레임, 품질 체크, 도구·스킬 선택 기준, 익명화된 사례 카드
- 프로젝트에 남길 것: 괴이 기록국의 세계관, 캐릭터명, 사건 규칙, 수치, 에셋 경로, 저장 구조, 실제 QA 결과

Base의 canonical 공용 지식 위치는 `docs/knowledge/`다. Base에 반영한 뒤 `BASE_RULES_VERSION.md`에 기준 커밋과 동기화 상태를 기록한다. 제안 PR과 Base 활성 구현 PR은 분리한다.

## 상시 동기화

- 플레이어 노출 설계가 바뀌면 `CURRENT_STATUS.md`, GDD, 로드맵, 테스트, 해당 기획 원본을 함께 심사한다.
- 코어 영향 시 `PROJECT_CORE.md`와 실제 구현을 함께 심사한다.
- 경로·ID·Schema·정본·생성기 변경 시 untouched 소비자를 감사한다.
- GDD 수정 후 DOCX를 재생성하고 `--check`를 실행한다.
- Skill 통합·간소화·추가 뒤 Registry·Coverage·Alias·Entry point·CI를 갱신한다.
- 큰 단계·MVP 종료 시 날짜·버전·다음 작업을 갱신한다.
- 완료 상세는 현행 문서에 누적하지 않고 `qa/` 또는 날짜별 백업으로 이동한다.
- 5개 MVP마다 구문서·중복·깨진 참조·기본 읽기 범위를 감사한다.
