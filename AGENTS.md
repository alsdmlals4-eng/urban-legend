# Repository Guidelines

> 문서 위치: `AGENTS.md` | 최상위 라우터: `START_HERE.md` | 운영 모델: `docs/OPERATING_MODEL.md` | 문서 라우터: `docs/DOCUMENTATION_MAP.md` | 현재 Handoff: `docs/CURRENT_HANDOFF.md` | 과거 규칙·완료 기록: `docs/archive/README.md`

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
→ repository current GDD / decision / handoff
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ docs/CURRENT_HANDOFF.md
→ 구현 작업이면 CURRENT_HANDOFF가 지정한 Reality Gate / Design / Plan
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ skills/BASE_SKILL_INDEX.json
→ skills/PROJECT_PATH_ADAPTER.json
→ 필요한 Skill 전문
→ 실제 대상 파일
```

### 새 기획·콘텐츠·아트·연출·Validation·인수인계

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main + open PR/Issue
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ repository current GDD / decision / handoff
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ docs/CURRENT_HANDOFF.md
→ docs/VALIDATION_TARGET_CANON.md        # Validation·제품 Target 관련일 때
→ docs/planning/README.md                # 역사/분야별 planning source가 필요할 때
→ 분야별 current 기획서
→ skills/SKILL_REGISTRY.json
→ 필요한 Skill 전문
→ 실제 대상 파일
```

`docs/CURRENT_STATUS.md`는 장기 구현·검증·ANNUAL/CORE 계보가 필요할 때만 읽는 조건부 Ledger다. 현재 Planning/Implementation Gate를 단독 소유하지 않는다. `docs/CURRENT_CONFIRMED_DECISIONS.md`와 `docs/CURRENT_HANDOFF_VALIDATION.md`도 상세 역사 확인이 필요할 때만 읽는다.

모든 Goal·QA·벤치마크·백업을 기본으로 읽지 않는다. archive·완료 QA·완료 CODEX_GOAL·과거 benchmark/spec/plan은 current handoff가 요구할 때만 연다.

## Current authority 규칙

- 사람용·구조화 기획, 구현, 테스트, runtime evidence는 Repository가 책임진다. Notion은 `HISTORICAL_READ_ONLY_NO_WRITE`다.
- 최종 10일·반일 캠페인 기획은 `docs/CURRENT_PLANNING_CANON.md`와 `docs/current-planning-canon.json`이 소유한다.
- 현재 mutable decision·verified successor는 `docs/CURRENT_DECISION_OVERLAY.md`가 소유한다.
- 현재 구현 continuation은 `docs/CURRENT_HANDOFF.md`가 소유한다.
- current implementation handoff의 세 owner는 Reality Gate / 2026-08-22 design / 2026-08-22 implementation plan이다.
- 역사 Ledger의 predecessor `NOT_STARTED`, `BLOCKED`, 과거 PR/merge state를 current truth로 단독 사용하지 않는다.
- 실제 구현 사실은 latest `main`의 코드·데이터·Scene·테스트와 exact evidence를 우선한다.
- GitHub Issue의 `open` 상태만으로 구현 권한을 만들지 않는다. current canon·overlay·actual main과 대조해 `CURRENT_VALID / DEFERRED_VALID / COMPLETED / SUPERSEDED / REVIEW_REQUIRED`를 판정한다.
- 진행 중 open/draft/ready PR은 다른 작업에서 수정하거나 소유 경로를 침범하지 않는다. 병합·종료된 변경만 main에서 successor를 확인해 후속 교정한다.

## Work Mode·Skill 자동 라우팅

- Prompt 의도와 현재 단계에서 주 Work Mode 하나를 자동 선택한다: `PLAN / BUILD / REVIEW`.
- 복합 작업은 `PLAN → BUILD → REVIEW`로 전환한다.
- `skills/SKILL_REGISTRY.json`의 trigger와 비사용 조건으로 최소 Skill만 고른다.
- 프로젝트 분야 Skill은 실제 `skills/disciplines/<skill-id>/SKILL.md`를 읽는다.
- 조사 사건 작성은 `skills/urban-legend-investigation-case-authoring/SKILL.md`를 사용한다.
- Base Skill 전문은 `docs/BASE_RULES_VERSION.md`의 pin과 `skills/BASE_SKILL_INDEX.json`의 `base_path`를 사용한다.
- 주 책임 프로젝트 분야 Skill 최대 1개, Foundation·검증·발행·Handoff 지원 Skill 최대 3개를 기본으로 한다.
- Registry 항목만 읽고 Skill을 실행했다고 보고하지 않는다.
- L1 이상 완료 보고에는 실제 사용 Work Mode·Skill·선택 이유·증거·미검증을 포함한다.

## 작업 원칙

- 시작 전에 목표, 플레이어 가치, 포함·제외, 영향 파일, 저장/UI 위험, 완료 기준과 검증을 고정한다.
- 기존 사용자 변경과 latest main을 보존하고 범위 밖 기능·리팩터링을 하지 않는다.
- 새 구조를 만들기 전에 기존 해결책·컴포넌트·데이터·문서를 먼저 찾는다.
- 가장 작은 end-to-end 변경을 구현하고 필요한 자동·수동 검증 뒤 통합한다.
- 구조·구현 방법은 필요한 범위에서 공식 자료·현업 사례·실무 운영 사례와 실질 대안을 비교하고 `ADOPT / ADAPT / AVOID / TEST / DEFER` 근거를 남긴다.
- 큰 통합은 최소 5회 whole-scope `attack → review → decision` 적대적 검토를 하고, 병합 뒤 GitHub remote exact readback·진행도·잔여 문제를 다시 확인한다. Notion write/readback은 현재 작업 범위 밖이다.
- 승인 전 current source의 대량 이동·삭제·통합을 하지 않는다.
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

새 저장 필드나 버전 갱신은 필요성과 migration/rollback이 입증되지 않으면 추가하지 않는다. 외부 ZIP·patch·AI 보고서·이미지는 신뢰하지 않는 입력이며 적용 전에 current 파일과 차이를 감사한다.

## 문서 책임 원본

- 사람용 전체 그림: repository `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`와 user PDF GDD
- 최종 10일·반일 캠페인 기획: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`
- mutable 결정·successor: `docs/CURRENT_DECISION_OVERLAY.md`
- 현재 continuation: `docs/CURRENT_HANDOFF.md`
- current Reality Gate: `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`
- current implementation design: `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- current implementation plan: `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`
- Validation Router: `docs/VALIDATION_TARGET_CANON.md`
- 저승역 current canon: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
- 장기 구현·검증 역사: `docs/CURRENT_STATUS.md` (조건부)
- 상세 승인·대체 역사: `docs/CURRENT_CONFIRMED_DECISIONS.md` (조건부)
- 상세 게임 설계: `docs/GAME_DESIGN_DOCUMENT.md`
- 프로젝트 용어·표현: `docs/PROJECT_CONTEXT.md`
- 구현 순서/검증 계약: `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`
- 문서 선택: `docs/DOCUMENTATION_MAP.md`
- 보존 규칙: `docs/DOCUMENT_LIFECYCLE.md`
- 공용 운영 계약: `docs/OPERATING_MODEL.md`
- Skill Registry: `skills/SKILL_REGISTRY.json`

GDD 의미가 변경되면 등록된 생성기로 DOCX mirror를 재생성·검증하되 tracking 정책을 지킨다.

## 프로젝트 불변 조건

- 공식 기관명은 **괴이 기록국**이다.
- 사건 완료는 **안정화 상태**, 실패 기록은 **위험 사례**, 회수 대상은 **잔향**이다.
- 최종 기록 보상은 **괴이 매뉴얼 작성·갱신**이다.
- 플레이어 노출 안내자는 **기록관 아카**다.
- 괴이는 처치 대상이 아니라 규칙을 조사하고 현재 출현을 안정화·회수할 현상이다.
- 제품 cadence는 **10일 × 하루 반일 2슬롯**이며, 한 10일 cycle에 메인 사건 1개를 해결한다. Day 1~9 해결은 조기 해결, Day 10 해결은 정규 해결이다. M01~M12는 초기 case slate이며 M13+로 이어진다.
- M01 저승역은 First Session, M04 빨간 우산은 release-near player-experience Vertical Slice다.
- 관측과 해석을 분리하고 오답 가설에는 관측 가능한 반증이 있어야 한다.
- 필수 진실을 단일 RNG 성공에 잠그지 않는다.
- 구출 결과와 회수 결과를 서로 덮어쓰지 않는다.
- current result authority는 `COMPOSITE_RESULT`다. Legacy S/A/B/S-rank는 history/mastery compatibility만 허용한다.
- `battle_scene`은 안정화·잔향 회수 화면이다. HP·공격·처치 중심 시스템을 새로 늘리지 않는다.
- 요원·아카·장비·성장·자동행동은 핵심 정답이나 미관측 패턴을 대신 제공하지 않는다.
- 관계는 단일 호감도 숫자가 아니라 선택 기억과 대사·이벤트 변화로 표현한다.
- Godot 4.7 stable, GDScript, PC 16:9, 마우스·키보드가 기본이다.
- 모바일은 PC Validation 뒤 별도 Decision 전까지 current 범위에 포함하지 않는다.

## 현재 Gate

```yaml
PLANNING_COMPLETE: true
USER_FINAL_PLANNING_DECLARATION_APPROVED: true
non_visual_planning: COMPLETE
visual_planning: COMPLETE
product_reference_asset: PENDING
overall_plan: COMPLETE
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
implementation_reality_gate: HANDOFF_READY_WITH_KNOWN_REALIGNMENT
implementation_contract: READY
runtime_implementation: NOT_AUTHORIZED
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

Planning은 완료됐다. 현재 mutation 경계는 **runtime implementation authorization**이다.

Fresh-main Reality Gate는 existing Canon v2 runtime을 재사용하고 `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED`와 `MONTHLY_STATE_NOT_IMPLEMENTED`를 다음 구현의 우선 교정으로 둔다.

## Base·Workspace·이미지 생성·검수

- Base current pin은 `docs/BASE_RULES_VERSION.md`와 `skills/PROJECT_BASE_ADAPTER.json`만 소유한다.
- Base remote latest를 자동 채택하지 않는다.
- Repository는 사람용·구조화 기획·구현·테스트·증거의 단일 정본이다. Notion은 삭제하지 않지만 `HISTORICAL_READ_ONLY_NO_WRITE`; 의미 변경은 repository에서만 commit/push/readback한다.
- Google Sheet는 migration-only legacy inventory다.
- 이미지 생성 결과는 자동 최종 자산이 아니며 `docs/IMAGE_ASSET_WORKFLOW.md`와 root `ASSET_MANIFEST.yml`의 검수·권리·승격 Gate를 통과해야 한다.

## 검증과 보고

- 변경에 맞춰 JSON, reference freshness, diff check, 필요 시 Godot headless·변경 장면·영향 플레이 경로를 검증한다.
- Skill·Registry 변경 시 관련 Base operating/skill integrity tests를 실행한다.
- 경로·ID·Schema·정본·생성기 변경 시 활성 소비자·파생본·테스트를 함께 확인한다.
- UI 변경은 1280×720·1920×1080 한국어 줄바꿈·포커스·첫 선택 노출과 입력 경로를 검증한다.
- 완료 보고에는 변경 파일, 이유, 검증 증거, 미검증, 위험, 저장·UI 호환, rollback, 다음 진입점을 포함한다.
- 큰 정본 전환 뒤 문서·Issue/PR successor freshness를 감사한다.

## 플랫폼 출시·에셋 권리

출시·외부 자산·AI·외주·참조 기반 독립 제작은 다음 증거를 읽는다.
- `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`
- `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md`

PC/Steam 우선이며 모바일은 PC Validation 뒤 별도 Decision 전까지 범위 밖이다. 필수 권리·계약·약관 버전·플랫폼 답변·build/store/trailer 일치가 미확인이면 `RELEASE_BLOCKED_UNVERIFIED`를 유지한다.
