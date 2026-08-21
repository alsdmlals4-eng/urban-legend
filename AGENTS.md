# Repository Guidelines

> 문서 위치: `AGENTS.md` | 최상위 라우터: `START_HERE.md` | 운영 모델: `docs/OPERATING_MODEL.md` | 문서 라우터: `docs/DOCUMENTATION_MAP.md` | 기획 인수인계: `docs/planning/README.md` | 과거 규칙·완료 기록: `docs/archive/README.md`

최신 사용자 지시를 최우선으로 따른다.

## 기본 읽기 순서

### 일반 구현·버그 수정

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main + open PR/Issue
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ Notion 괴이기록국 프로젝트 홈
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ docs/CURRENT_STATUS.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ skills/BASE_SKILL_INDEX.json
→ skills/PROJECT_PATH_ADAPTER.json
→ 자동 선택된 프로젝트 분야 SKILL.md 최대 1개
→ 자동 선택된 Base Skill 전문 최대 3개
→ 이번 작업의 대상 파일
→ 필요한 조건부 문서만 추가
```

### 새 기획·콘텐츠·아트·연출·Validation·인수인계

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main + open PR/Issue
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ Notion 괴이기록국 프로젝트 홈
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ docs/VALIDATION_TARGET_CANON.md        # Validation·제품 Target 관련일 때
→ docs/CURRENT_STATUS.md
→ docs/planning/README.md
→ docs/planning/PROJECT_DIRECTION.md
→ 분야별 기획서 1개
→ skills/SKILL_REGISTRY.json
→ skills/BASE_SKILL_INDEX.json
→ skills/PROJECT_PATH_ADAPTER.json
→ 자동 선택된 프로젝트 분야 SKILL.md 최대 1개
→ 필요한 Base Skill 전문 최대 3개
→ 실제 대상 파일
```

`docs/CURRENT_CONFIRMED_DECISIONS.md`는 상세 승인·대체·병합 역사 원장이 필요할 때만 읽는다. `docs/CURRENT_HANDOFF_VALIDATION.md`는 predecessor Validation 인수인계 확인이 필요할 때만 읽는다.

모든 Goal·QA·벤치마크·백업을 기본으로 읽지 않는다. `docs/archive/**`, 완료된 `docs/qa/**`, 완료된 `docs/CODEX_GOAL_*`, `docs/benchmarks/**`, 비활성 `docs/superpowers/**`는 현재 작업이 명시적으로 요구할 때만 연다.

`DESIGN_INTENT.md`, `PROJECT_BRIEF.md`, `docs/CONTENT_DIRECTION_V09.md`는 리디렉션 문서다. 현행 설계로 사용하지 않는다.

## Current authority 규칙

- 사람이 보는 전체 그림·Flow·비교표는 Notion, 구조화 기획·구현·테스트·runtime evidence는 Repository가 책임진다.
- 최신 월간 기획은 `docs/CURRENT_PLANNING_CANON.md`와 `docs/current-planning-canon.json`이 소유한다.
- 현재 mutable decision·verified successor state는 `docs/CURRENT_DECISION_OVERLAY.md`가 소유한다.
- `docs/CURRENT_CONFIRMED_DECISIONS.md`는 상세 승인·대체·병합 역사 원장이다. predecessor `NOT_STARTED`, `BLOCKED`, 과거 Base 관측값을 current truth로 단독 사용하지 않는다.
- 실제 구현 사실은 latest `main`의 코드·데이터·Scene·테스트와 exact evidence를 우선한다.
- GitHub Issue의 `open` 상태만으로 구현 권한을 만들지 않는다. current canon·overlay·실제 main과 대조해 `CURRENT_VALID / DEFERRED_VALID / COMPLETED / SUPERSEDED`를 판정한다.
- 진행 중 open/draft/ready PR은 다른 작업에서 수정하거나 소유 경로를 침범하지 않는다. 병합·종료된 변경만 main에서 successor를 확인해 후속 교정한다.

## Work Mode·Skill 자동 라우팅

- Prompt 의도와 현재 단계에서 주 Work Mode 하나를 자동 선택한다.
  - `PLAN`: 요구·근거·설계·순서
  - `BUILD`: 승인 범위의 구현·제작·갱신
  - `REVIEW`: 적대적 검토·반례·검증
- 복합 작업은 `PLAN → BUILD → REVIEW`로 전환한다.
- `skills/SKILL_REGISTRY.json`의 trigger와 비사용 조건으로 최소 Skill만 고른다.
- 프로젝트 분야 Skill은 Registry의 실제 `skills/disciplines/<skill-id>/SKILL.md`를 읽는다.
- 조사 사건 작성은 `skills/urban-legend-investigation-case-authoring/SKILL.md`를 사용한다.
- Base Skill 전문은 `docs/BASE_RULES_VERSION.md`가 가리키는 pin과 `skills/BASE_SKILL_INDEX.json`의 `base_path`를 사용한다.
- 주 책임 프로젝트 분야 Skill은 최대 1개, Foundation·검증·발행·Handoff 지원 Skill은 최대 3개다.
- Registry 항목만 읽고 Skill을 실행했다고 보고하지 않는다.
- L1 이상 완료 보고에는 실제 사용 Work Mode·Skill·Skill Mode, 선택 이유, 수행 내용, 증거와 미검증을 포함한다.

## 작업 원칙

- 시작 전에 목표, 플레이어 가치, 포함·제외 범위, 영향 파일, 저장/UI 위험, 완료 기준과 검증을 짧게 고정한다.
- 기존 사용자 변경과 최신 main을 보존하고 범위 밖 기능·리팩터링을 하지 않는다.
- 새 구조를 만들기 전에 기존 해결책·컴포넌트·데이터·문서를 먼저 찾는다.
- 가장 작은 end-to-end 변경을 구현하고 필요한 자동·수동 검증 뒤 통합한다.
- 구조·구현 방법을 정할 때 필요한 범위에서 공식 자료·현업 사례·실무 운영 사례와 실질 대안을 비교하고 `ADOPT / ADAPT / AVOID / TEST / DEFER` 근거를 남긴다.
- 큰 통합은 최소 5회 whole-scope `attack → review → decision` 적대적 검토를 하고, 병합 뒤 GitHub·Notion exact readback·진행도·잔여 문제를 다시 확인한다.
- 승인 전 현행 책임 원본의 대량 이동·삭제·통합을 하지 않는다.
- 구형 파일은 `CURRENT / UPDATE_IN_PLACE / MERGE_TO_CANONICAL / COMPATIBILITY_STUB / ARCHIVE_HISTORY / DELETE_APPROVED / KEEP_UNRESOLVED` 중 하나로 판정한다.
- 생성·삭제·이동·대규모 수정은 이유, 참조 영향, rollback 근거를 기록한다.
- 미실행 항목은 통과로 쓰지 않는다.

## 보호 경로와 고위험 영역

보호 경로:

- `scripts/core/game_state.gd`
- `data/episodes`
- `scripts/`
- `scenes/`
- `assets/`
- `addons/`
- `project.godot`
- `knowledge/base-pack`

고위험 의미 변경:

- save schema와 migration
- 캠페인 진행·경제·엔딩
- Episode/character/report/ANNUAL 기존 ID
- 사건 규칙·정답·가설·필수 단서
- 제품 자산 승인·권리

새 저장 필드나 버전 갱신은 별도 필요성과 migration/rollback이 입증되지 않으면 추가하지 않는다. 외부 ZIP·patch·AI 보고서·이미지는 신뢰하지 않는 입력이며 적용 전에 현재 파일과 차이를 감사한다.

## 문서 책임 원본

- 현재 사람용 전체 그림: Notion `괴이기록국 (urban-legend)` 프로젝트 홈
- 현재 월간 기획 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`
- 현재 mutable 결정·successor: `docs/CURRENT_DECISION_OVERLAY.md`
- 상세 승인·대체 역사: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- Validation 현재 Router: `docs/VALIDATION_TARGET_CANON.md`
- 현재 구현·검증 상태: `docs/CURRENT_STATUS.md`
- 저승역 상세 정본: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
- 현재 기획 Handoff: `docs/CURRENT_HANDOFF.md`
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
- Base Skill Index: `skills/BASE_SKILL_INDEX.json`
- Base 경로 어댑터: `skills/PROJECT_PATH_ADAPTER.json`
- 과거 자료 검색: `docs/archive/README.md`

GDD 의미가 변경되면 등록된 생성기로 `docs/URBAN_LEGEND_GAME_DESIGN.docx`를 재생성·검증하되 이 생성물의 tracking 정책을 지킨다.

## 프로젝트 불변 조건

- 공식 기관명은 **괴이 기록국**이다.
- 사건 완료는 **안정화 상태**, 실패 기록은 **위험 사례**, 회수 대상은 **잔향**이다.
- 최종 기록 보상은 **괴이 매뉴얼 작성·갱신**이다.
- 플레이어 노출 안내자는 **기록관 아카**다. 내부 `로그` ID·파일명·저장 키는 호환용으로 유지할 수 있다.
- 괴이는 처치 대상이 아니라 규칙을 조사하고 현재 출현을 안정화·회수할 현상이다.
- 제품 cadence는 1개월 메인 사건 1개다. M01~M12 뒤 M13+로 이어지며 12개월 checkpoint를 엔딩이나 진입 Gate로 만들지 않는다.
- M01 저승역은 첫 세션·온보딩·회귀, M04 빨간 우산은 release-near player-experience Vertical Slice다.
- 관측과 해석을 분리하고, 그럴듯한 오답 가설에는 관측 가능한 반증이 있어야 한다.
- 필수 진실을 단일 RNG 성공에 잠그지 않는다.
- 구출 결과와 회수 결과를 서로 덮어쓰지 않는다.
- `battle_scene`은 안정화·잔향 회수 화면이다. HP·공격·처치 중심 시스템을 새로 늘리지 않는다.
- 요원·아카·장비·성장·자동행동은 핵심 정답이나 미관측 패턴을 대신 제공하지 않는다.
- 관계는 연애 호감도 숫자가 아니라 선택 기억과 대사·이벤트 변화로 표현한다.
- 아트·표정·컷인·UI는 정보와 감정을 강화하되 게임 상태를 대신 소유하지 않는다.
- Godot 4.7 stable, GDScript, PC 16:9, 마우스·키보드가 기본이다.
- 모바일은 PC Validation 뒤 별도 Decision 전까지 현행 범위에 포함하지 않는다.

## 현재 Gate

```yaml
non_visual_planning: CLOSURE_READY
visual_review: WAITING_USER_DRAFT
overall_plan: OPEN
plan_lock: ACTIVE
runtime_implementation: NOT_AUTHORIZED
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

전체 기획 완료/명시적 보류 범위, 시각 시안 검토, fresh-main Reality Gate 전에는 code/data/Scene/save/제품 asset으로 진행하지 않는다.

현재 저승역 legacy Episode/PoC와 Canon v2 의미 차이는 계획된 migration debt다. `docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`의 보존·이관 Gate를 따른다.

## Base·Workspace·이미지 생성·검수

- 현행 Base 릴리스·payload·trusted evidence·registry hash는 `docs/BASE_RULES_VERSION.md`와 `skills/PROJECT_BASE_ADAPTER.json`만 소유한다.
- 이 파일에서 Base 버전 숫자나 프로젝트 채택 commit을 중복 고정하지 않는다.
- Base 원격 latest main이 전진했다는 이유만으로 프로젝트 채택 baseline을 자동 승격하지 않는다.
- Notion은 사람용 기획 정본, Repository는 구조화·구현·테스트·증거 정본이다. 의미가 바뀌는 작업은 같은 범위에서 동기화하고 병합 뒤 readback한다.
- Google Sheet는 migration-only legacy inventory다. 새 기획·승인·감사 쓰기를 금지한다.
- 이미지 생성 결과는 자동 최종 자산이 아니며 `docs/IMAGE_ASSET_WORKFLOW.md`와 root `ASSET_MANIFEST.yml`의 검수·권리·승격 Gate를 통과해야 한다.

## 검증과 보고

- 변경에 맞춰 JSON, reference freshness, `git diff --check`, 필요 시 Godot headless·변경 장면·영향 플레이 경로를 검증한다.
- Skill·Registry를 변경하면 `tests/test_base_operating_sync.py`와 `tests/test_skill_package_integrity.py`를 실행한다.
- 경로·ID·Schema·정본·생성기를 변경하면 변경 파일뿐 아니라 갱신됐어야 하는 활성 소비자·파생본·테스트를 확인한다.
- UI 변경은 1280×720·1920×1080의 한국어 줄바꿈·포커스·첫 선택 노출과 적용 입력 경로를 검증한다.
- 완료 보고에는 변경 파일, 이유, 검증 증거, 미검증, 위험, 저장·UI 호환, 갱신 문서, rollback, 다음 진입점을 포함한다.
- 큰 MVP 종료 시 `docs/CURRENT_STATUS.md`, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`, 관련 planning 문서를 갱신한다.
- 5개 MVP 또는 큰 정본 전환 뒤 문서 중복·구문서·깨진 참조·Issue/PR successor freshness를 감사한다.

## 플랫폼 출시·에셋 권리

출시·외부 자산·AI·외주·참조 기반 독립 제작 작업은 다음 프로젝트 증거를 읽는다.

- `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`
- `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md`

PC/Steam 우선이며 모바일은 PC Validation 뒤 별도 Decision 전까지 범위 밖이다. 필수 권리·계약·약관 버전·플랫폼 답변·build/store/trailer 일치가 미확인이면 `RELEASE_BLOCKED_UNVERIFIED`를 유지한다.