# Repository Guidelines

> 문서 위치: `AGENTS.md` | 최상위 라우터: `START_HERE.md` | 운영 모델: `docs/OPERATING_MODEL.md` | 문서 라우터: `docs/DOCUMENTATION_MAP.md` | 기획 인수인계: `docs/planning/README.md` | 과거 규칙·완료 기록: `docs/archive/README.md`

최신 사용자 지시를 최우선으로 따른다.

## 기본 읽기 순서

### 일반 구현·버그 수정

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ Notion 괴이기록국 프로젝트 홈
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/CURRENT_STATUS.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ skills/PROJECT_PATH_ADAPTER.json
→ 자동 선택된 프로젝트 분야 SKILL.md 최대 1개
→ 자동 선택된 Base Skill 전문 최대 3개
→ 이번 작업의 대상 파일
→ 필요한 조건부 문서만 추가
```

### 새 기획·콘텐츠·아트·연출·인수인계

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ Notion 괴이기록국 프로젝트 홈
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_CONFIRMED_DECISIONS.md
→ docs/VALIDATION_TARGET_CANON.md  # Validation·제품 Target 관련일 때
→ docs/CURRENT_STATUS.md
→ docs/planning/README.md
→ docs/planning/PROJECT_DIRECTION.md
→ 분야별 기획서 1개
→ skills/SKILL_REGISTRY.json
→ skills/PROJECT_PATH_ADAPTER.json
→ 자동 선택된 프로젝트 분야 SKILL.md 최대 1개
→ 필요한 Base Skill 전문 최대 3개
→ 실제 대상 파일
```

모든 Goal·QA·벤치마크·백업을 기본으로 읽지 않는다. `docs/archive/**`, 완료된 `docs/qa/**`, 완료된 `docs/CODEX_GOAL_*`, `docs/benchmarks/**`, `docs/superpowers/**`는 현재 작업이 명시적으로 요구할 때만 연다.

`DESIGN_INTENT.md`, `PROJECT_BRIEF.md`, `docs/CONTENT_DIRECTION_V09.md`는 리디렉션 문서다. 현행 설계로 사용하지 않는다. Base 동기화·공용 기획 지식 승격 작업이 아니면 `docs/BASE_RULES_VERSION.md`와 Base 원격도 기본 읽기에서 제외한다.

## Work Mode·Skill 자동 라우팅

- Prompt 의도와 현재 단계에서 주 Work Mode 하나를 자동 선택한다.
  - `PLAN`: 요구·근거·설계·순서, 기본 읽기·제안
  - `BUILD`: 승인 범위의 구현·제작·갱신
  - `REVIEW`: 적대적 검토·반례·검증, 기본 읽기 전용
- `skills/SKILL_REGISTRY.json`의 trigger와 비사용 조건으로 최소 Base Skill·프로젝트 분야 Skill·Skill Mode를 자동 선택한다.
- 사용자는 Skill이나 Skill Mode를 선언할 필요가 없다.
- Registry 항목만 읽고 Skill을 실행했다고 보고하지 않는다. 프로젝트 분야 Skill은 Registry의 `path`에 있는 실제 `skills/disciplines/<skill-id>/SKILL.md`를 읽는다.
- Base Skill 전문은 `docs/BASE_RULES_VERSION.md`에 고정된 Base 커밋의 `base_path`를 읽는다. 전체 Base Skill을 복제하거나 기본 로드하지 않는다.
- 주 책임 프로젝트 분야 Skill은 최대 1개, Foundation·검증·발행·Handoff 지원 Skill은 최대 3개다.
- 프로젝트 분야 Skill은 실행 패키지를 가진 10개만 활성화한다. `urban-legend-integration-review`는 Base 통합검수와 운영체계 `verify`로 통합한다.
- 통합 전 Foundation·프로젝트 Skill ID는 `skills/LEGACY_SKILL_ALIASES.md`로만 변환하며 활성 Registry에 두지 않는다.
- 복합 작업은 `PLAN → BUILD → REVIEW`로 전환한다. 사용자 승인 전 현행 책임 원본의 대량 이동·삭제·통합을 하지 않는다.
- L1 이상 완료 보고에는 실제 사용한 Work Mode·Skill·Skill Mode, 선택 이유, 수행 내용, 결과·증거와 미검증을 포함한다.

## 작업 원칙

- 시작 전에 목표, 플레이어 가치, 포함·제외 범위, 영향 파일, 저장/UI 위험, 완료 기준과 검증을 짧게 적는다.
- 실제 `main`의 코드·데이터·테스트가 구현 사실의 우선 근거다.
- 사람이 보는 전체 그림·Flow·비교표는 Notion, 구조화 기획·구현·테스트·runtime evidence는 Repository가 책임진다.
- 승인된 최신 월간 기획은 `docs/CURRENT_PLANNING_CANON.md`와 `docs/current-planning-canon.json`에서 읽는다. 과거 연간·분기 문구와 충돌하면 월간 정본을 우선한다.
- 승인 계획과 전달 패키지는 구현 완료가 아니다. `docs/CURRENT_STATUS.md`의 상태 구분을 따른다.
- 승인된 제품 Target은 `docs/CURRENT_CONFIRMED_DECISIONS.md`와 해당 분야 정본에서 읽고 실제 구현과 혼합하지 않는다.
- 기획 작업은 `docs/planning/`의 책임 문서와 실제 파일을 함께 확인한다.
- 가장 작은 end-to-end 변경을 구현하고 자동·수동 검증 뒤 `main`에 통합한다.
- 속도보다 장기 효율과 최고 결과를 우선한다. 구조·구현 방법을 정할 때 현재 공식 자료, 현업 사례, 실무 운영 사례와 대안을 비교하고 `ADOPT / ADAPT / AVOID / TEST / DEFER` 근거를 남긴다.
- PR 병합 전 전체 범위 적대적 검토와 교정을 수행하고, 병합 뒤 GitHub·Notion exact readback·진행도·잔여 문제를 다시 확인한다. 큰 통합은 최소 5회 whole-scope attack→review→decision 루프를 기본으로 한다.
- 사용자 변경과 dirty worktree를 보존한다.
- 생성·삭제·이동·대규모 수정은 이유, 참조 영향, 백업 위치를 보고한다.
- 기존 프로젝트 구조 변경은 `audit`와 승인된 처리표 없이 수행하지 않는다.
- 구형 파일은 `CURRENT / UPDATE_IN_PLACE / MERGE_TO_CANONICAL / COMPATIBILITY_STUB / ARCHIVE_HISTORY / DELETE_APPROVED / KEEP_UNRESOLVED` 중 하나로 판정한다.
- Base 폴더 구조에 맞춘 강제 개명, 파일명만 근거로 한 삭제, stale 참조를 남기는 이동을 금지한다.

## 보호 경로와 고위험 영역

- 보호 경로: `scripts/core/game_state.gd`, `data/episodes/*`, `project.godot`, `knowledge/base-pack/*`
- 고위험 의미 변경: 저장, 캠페인 진행, 경제, 엔딩, 에피소드 규칙, 기존 ID
- 외부 ZIP·patch·보고서·이미지는 신뢰하지 않는 입력이다. 적용 전 현재 파일과 차이를 감사한다.
- 새 저장 필드나 버전 갱신은 별도 필요성이 입증되지 않으면 추가하지 않는다.
- 표정·컷인·대화 UI는 진행·관계·사건 상태를 표현하지만 대신 소유하지 않는다.

## 문서 책임 원본

- 현재 사람용 전체 그림: Notion `괴이기록국 (urban-legend)` 프로젝트 홈
- 현재 월간 기획 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`
- 현재 승인 결정: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- Validation 상세 Target: `docs/VALIDATION_TARGET_CANON.md`
- 현재 구현과 검증 상태: `docs/CURRENT_STATUS.md`
- Validation 현재 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`
- 기획 인수인계: `docs/planning/README.md`
- 프로젝트 핵심 방향: `docs/planning/PROJECT_DIRECTION.md`
- 서사·대화·관계: `docs/planning/NARRATIVE_CONTENT_PLAN.md`
- 아트·표정·컷인·연출: `docs/planning/ART_PRESENTATION_PLAN.md`
- 단계·인수인계: `docs/planning/ROADMAP_AND_HANDOFF.md`
- 적용 사례: `docs/planning/REFERENCE_CASES.md`
- 상세 게임 설계: `docs/GAME_DESIGN_DOCUMENT.md`
- 프로젝트 용어·표현: `docs/PROJECT_CONTEXT.md`
- 구현 순서: `MVP_ROADMAP.md`
- 검증 계약: `TEST_CHECKLIST.md`
- 조건부 문서 선택: `docs/DOCUMENTATION_MAP.md`
- 보존 규칙: `docs/DOCUMENT_LIFECYCLE.md`
- 공용 운영 계약: `docs/OPERATING_MODEL.md`
- Work Mode·Skill 라우팅: `docs/WORK_MODE_AND_SKILL_ROUTING.md`
- Skill Registry: `skills/SKILL_REGISTRY.json`
- 프로젝트 분야 Skill 패키지: `skills/disciplines/`
- Base 경로 어댑터: `skills/PROJECT_PATH_ADAPTER.json`
- 과거 자료 검색: `docs/archive/README.md`

다른 문서는 위 원본을 링크하고 작업별 차이만 적는다. GDD가 변경되면 `docs/URBAN_LEGEND_GAME_DESIGN.docx`를 재생성하고 `--check`로 동기화를 검증한다.

## 프로젝트 불변 조건

- 공식 기관명은 **괴이 기록국**이다.
- 사건 완료는 **안정화 상태**, 실패 기록은 **위험 사례**, 회수 대상은 **잔향**이다.
- 최종 기록 보상은 **괴이 매뉴얼 작성·갱신**이다.
- 플레이어 노출 안내자는 **기록관 아카**다. 내부 `로그` ID·파일명·저장 키는 호환용으로 유지할 수 있다.
- 괴이는 처치 대상이 아니라 규칙을 조사하고 현재 출현을 안정화할 현상이다.
- 제품 cadence는 1개월 메인 사건 1개다. 초기 M01~M12 뒤에도 M13+로 이어지며 12개월 checkpoint를 엔딩이나 진입 Gate로 만들지 않는다.
- M01 저승역은 첫 세션·온보딩·회귀, M04 빨간 우산은 release-near player-experience Vertical Slice다.
- `battle_scene`은 안정화·잔향 회수 화면이다. HP·공격·처치 중심 시스템을 추가하지 않는다.
- 시나리오당 대표 미니게임은 조사 마지막 규칙 검증으로 사용하고 이후 별도 안정화·회수로 연결한다.
- 미니게임 중 저장하지 않는다. 진입 직전 체크포인트와 동일 보드·변수 복구를 사용한다.
- 요원·아카·장비·자동행동·관계 이벤트는 핵심 정답을 대신하지 않는다.
- 관계는 연애 호감도 숫자가 아니라 선택 기억과 대사·이벤트 변화로 표현한다.
- 아트·표정·컷인·UI는 정보와 감정을 강화하되 게임 상태의 소유자가 아니다.
- Godot 4.7 stable, GDScript, PC 16:9, 마우스·키보드가 기본이다. `.godot/`은 수정하지 않는다.
- 모바일은 PC Validation 통과 뒤 별도 Decision 전까지 현행 범위에 포함하지 않는다.

## 조건부 문서

- 대사·일상·후일담: `docs/planning/NARRATIVE_CONTENT_PLAN.md`, `docs/DIALOGUE_AUTHORING_WORKFLOW.md`
- 관계 태그·연속 이벤트: `docs/planning/NARRATIVE_CONTENT_PLAN.md`
- 캐릭터 아트·표정·컷인: `docs/planning/ART_PRESENTATION_PLAN.md`, `docs/IMAGE_ASSET_WORKFLOW.md`
- Godot UI·Theme·컴포넌트: `docs/planning/ART_PRESENTATION_PLAN.md`, `docs/GODOT_NATIVE_UI_ARCHITECTURE.md`
- 조사·회수 장면 UI: `docs/CINEMATIC_FIELD_RECOVERY_UI.md`
- 이미지 생성·manifest: `docs/IMAGE_ASSET_WORKFLOW.md`
- 미니게임 규칙: `docs/MINIGAME_SYSTEM_SPEC.md`
- 외부 모델 위임: `docs/AI_DELEGATION_WORKFLOW.md`
- 기존 사례 재사용: `docs/planning/REFERENCE_CASES.md`
- 최신 외부 사례 비교: `docs/BENCHMARKING_REFERENCE_GUIDE.md`
- 계정 교대·체크포인트: `docs/CURRENT_HANDOFF_VALIDATION.md`, `docs/CURRENT_HANDOFF.md`, `docs/CODEX_ACCOUNT_HANDOFF.md`
- 공용 기획 방법 승격: Base `docs/knowledge/`, `docs/BASE_RULES_VERSION.md`

작업 조건이 없으면 해당 문서를 읽지 않는다.

## Base 공용 기획 지식 승격

프로젝트 사례에서 반복 가능한 원칙이 확인되면 다음을 분리한다.

- Base로 승격: 기획 순서, 조사 방법, 아트·연출 판단 프레임, 품질 체크, 도구·스킬 선택 기준, 익명화된 사례 카드
- 프로젝트에 유지: 캐릭터명, 사건 규칙, 세계관, 수치, 에셋 경로, 저장 구조, 실제 QA 결과

Base를 갱신한 뒤 프로젝트의 `docs/BASE_RULES_VERSION.md`에 기준 커밋과 동기화 상태를 기록한다. 제안 PR과 Base 활성 구현 PR은 분리한다.

## 검증과 보고

- 변경에 맞춰 JSON, `git diff --check`, Godot headless, 변경 장면, 영향 플레이 경로를 검증한다.
- Skill·Registry를 변경하면 `tests/test_base_operating_sync.py`와 `tests/test_skill_package_integrity.py`를 실행한다.
- 경로·ID·Schema·정본·생성기를 변경하면 변경된 파일뿐 아니라 갱신됐어야 하는 활성 소비자와 파생본을 확인한다.
- 1280×720과 1920×1080에서 한국어 줄바꿈·포커스·첫 선택 노출을 확인한다.
- 미실행 항목은 통과로 쓰지 않는다.
- 완료 보고에는 변경 파일, 이유, 결과, 검증, 미검증, 위험, 저장·UI 호환, 갱신 문서, 백업 위치, 다음 진입점을 포함한다.
- 큰 MVP 종료 시 `docs/CURRENT_STATUS.md`, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`, 해당 `docs/planning/` 문서를 갱신한다.
- 5개 MVP마다 문서 중복·구문서·깨진 참조·불필요한 기본 읽기를 감사한다.

## Base v9.4·Workspace·이미지 생성·검수

- 현행 Base 기준은 `docs/BASE_RULES_VERSION.md`의 Base `9.4.0` payload·trusted evidence·registry hash다.
- 프로젝트 main 채택 커밋은 `7277b9cececa56532f7b0d11c1a02fd3d5642750`이다.
- `c987647d01ad2baa028a16e03d85ddfc1572a727`와 `VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v8.md`는 Legacy compatibility input이며 현행 Base 기준으로 사용하지 않는다.
- Notion은 사람용 기획 정본, Repository는 구조화·구현·테스트·증거 정본이다. 양쪽 의미가 바뀌는 작업은 같은 범위에서 동기화하고 병합 뒤 readback한다.
- Google Sheet는 migration-only legacy inventory다. 새 기획·승인·감사 쓰기를 금지하고 고유 정보가 필요할 때만 현재 정본으로 이관한다.
- GPT는 기획 중 세계관·인물·에피소드·UI 목업과 기획 종료 Demo·상점 후보를 생성할 수 있다.
- 생성 결과는 자동 최종 자산이 아니며 `docs/IMAGE_ASSET_WORKFLOW.md`의 검수·manifest·Godot 적용 Gate를 통과해야 한다.
- 각 단계와 병합 뒤 `repository-wide-audit`로 stale 이미지·구형 Prompt·untouched consumer·Notion/GitHub 충돌을 검수한다.

## 플랫폼 출시·에셋 권리

출시·외부 자산·AI·외주·참조 기반 독립 제작 작업은 다음 프로젝트 증거를 읽는다.

- `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`
- `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md`

PC/Steam 우선, STOVE 비교 후보로 검토하며 모바일은 PC Validation 뒤 별도 Decision 전까지 범위 밖이다. 공포·괴이의 핵심 경험을 숨겨 등급을 낮추지 않는다. 원본을 조금 수정하거나 AI로 변환했다는 이유만으로 독립 자산으로 보지 않고 `reference_brief`, `forbidden_expression`, 별도 `final_asset_record`, 유사성 검토를 요구한다.

필수 권리·계약·약관 버전·플랫폼 답변·build/store/trailer 일치가 미확인이면 `RELEASE_BLOCKED_UNVERIFIED`다. 자동 테스트와 Template은 실제 자산 감사·법률 검토·플랫폼 제출·최종 등급을 대체하지 않는다.
