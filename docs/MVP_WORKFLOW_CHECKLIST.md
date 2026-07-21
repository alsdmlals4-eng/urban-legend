# MVP Workflow Checklist

> 문서 위치: `docs/MVP_WORKFLOW_CHECKLIST.md` | 운영 모델: `docs/OPERATING_MODEL.md` | 현재 상태: `docs/CURRENT_STATUS.md` | 과거 작업 절차: `git show 130466e66d3115876a85ba06f47b7661fae3f304:docs/MVP_WORKFLOW_CHECKLIST.md`

이 문서는 실제 MVP를 시작·구현·종료할 때만 읽는다. 문서·오탈자·단순 데이터 수정은 `AGENTS.md`와 `TEST_CHECKLIST.md`의 빠른 경로를 사용한다.

## 1. 시작 순서

```text
1. 최신 사용자 지시 확인
2. START_HERE.md·AGENTS.md·CURRENT_STATUS.md 확인
3. Prompt 의도와 현재 단계에서 Work Mode 선택
4. SKILL_REGISTRY trigger로 주 프로젝트 Skill 최대 1개·지원 Base Skill 최대 3개 선택
5. Registry가 가리키는 실제 SKILL.md 전문 확인
6. 대상 ZIP/Issue/Goal의 범위 확인
7. IMP-00 사전 감사
8. 작은 end-to-end 구현 단위 확정
9. 구현 → 자동 검증 → 수동 화면 검증
10. 상태·로드맵·테스트 갱신
11. Skill 실행 결과 보고·main 통합
```

모든 과거 Goal·QA·벤치마크와 전체 Base·프로젝트 Skill을 읽지 않는다. 현재 변경과 직접 연결된 파일만 `docs/DOCUMENTATION_MAP.md`와 `skills/SKILL_REGISTRY.json`에서 선택한다.

## 2. Work Mode·Skill 계약

- [ ] 현재 주 Work Mode가 `PLAN / BUILD / REVIEW` 중 하나로 명확하다.
- [ ] Registry trigger와 비사용 조건으로 필요한 최소 Skill만 선택했다.
- [ ] 주 책임 프로젝트 분야 Skill은 하나 이하이다.
- [ ] Foundation·검증·발행·Handoff 지원 Skill은 세 개 이하이다.
- [ ] 사용자에게 Skill·Skill Mode 선택을 전가하지 않았다.
- [ ] 프로젝트 Skill은 Registry의 `path`가 가리키는 실제 `SKILL.md`를 읽었다.
- [ ] Base Skill 전문은 `docs/BASE_RULES_VERSION.md`의 고정 커밋에서 필요한 것만 읽었다.
- [ ] Registry 항목만 읽고 Skill을 실행했다고 보고하지 않는다.
- [ ] L1 이상이면 완료 보고에 선택 이유·수행·결과·증거·미검증을 남길 계획이 있다.

## 3. Definition of Ready

- [ ] 목표와 해결할 플레이어 문제가 한 문장으로 설명된다.
- [ ] 구현 사실과 승인 계획이 구분돼 있다.
- [ ] 포함 범위와 제외 범위가 작게 잘렸다.
- [ ] 영향 코드·Scene·JSON·에셋·문서가 적혀 있다.
- [ ] 저장·진행·경제·엔딩·기존 ID 위험이 적혀 있다.
- [ ] 완료 기준마다 자동 또는 수동 검증이 연결된다.
- [ ] 대상 ZIP의 `00_README`와 `IMP-00` 요구사항을 확인했다.
- [ ] 필요한 외부 근거 조사 여부를 결정했다.
- [ ] 경로·ID·Schema·정본 변경이 있다면 reference-freshness 소비자 목록을 만들었다.
- [ ] Skill·Registry 변경이면 실제 패키지·trigger·Alias·진입점·CI 영향 범위를 적었다.

준비 기준을 만족하지 못하면 구현을 시작하지 않고 범위를 보완한다.

## 4. 구현 전 보고

```md
Work Mode / Skill / Skill Mode:

선택 이유:

목표:

수정 대상:
-

변경 순서:
1.
2.

보존 계약:
-

제외 범위:
-

검증:
-
```

## 5. 구현 원칙

- 작은 end-to-end 변경 하나를 먼저 완성한다.
- `scripts/core/game_state.gd`, `data/episodes/*`, `project.godot`, `knowledge/base-pack/*`은 보호 경로로 취급한다.
- 외부 ZIP·patch·문서의 파일명과 현재 저장소 경로가 다르면 자동 적용하지 않는다.
- 기존 ID·저장 스키마·진행 상태를 재사용하고 새 상태 소유자를 만들지 않는다.
- 플레이어 노출 문구는 `괴이 기록국`, `안정화 상태`, `위험 사례`, `잔향`, `괴이 매뉴얼`, `기록관 아카`를 사용한다.
- 구현되지 않은 계획을 README·GDD에서 구현 완료로 표시하지 않는다.
- 기존 프로젝트 문서·Skill 구조는 `audit`와 승인된 처리표 없이 대량 이동·삭제·통합하지 않는다.
- 새 Skill 추가 전 기존 Base·프로젝트 Skill Mode로 흡수 가능한지 먼저 판정한다.
- 독립 Skill은 고유 입력·산출물·Quality Bar·검증·승인 경계가 있어야 한다.
- 구형 파일은 `CURRENT / UPDATE_IN_PLACE / MERGE_TO_CANONICAL / COMPATIBILITY_STUB / ARCHIVE_HISTORY / DELETE_APPROVED / KEEP_UNRESOLVED`로 판정한다.

## 6. 조건부 추가 문서·Skill

- 대사·일상·후일담: `urban-legend-narrative`, `DIALOGUE_AUTHORING_WORKFLOW.md`
- 게임 규칙·미니게임: `urban-legend-game-design`, `MINIGAME_SYSTEM_SPEC.md`
- UI·Theme·컴포넌트: `urban-legend-ux-ui-accessibility`, `GODOT_NATIVE_UI_ARCHITECTURE.md`
- 조사·회수 화면: `urban-legend-ux-ui-accessibility`, `CINEMATIC_FIELD_RECOVERY_UI.md`
- Godot·저장·Scene 구현: `urban-legend-engineering`
- 이미지·Manifest: `urban-legend-technical-art-pipeline`, `IMAGE_ASSET_WORKFLOW.md`
- 아트·표정·컷인: `urban-legend-art`, `ART_PRESENTATION_PLAN.md`
- BGM·SFX·음성: `urban-legend-audio`
- QA·결함·release gate: `urban-legend-qa`
- MVP·Issue·PR·우선순위: `urban-legend-production-pm`
- 조사·벤치마크·텔레메트리: `urban-legend-analytics-user-research`, 필요 시 Base `analyzing-and-refining-game-concepts`
- 외부 모델 위임: `AI_DELEGATION_WORKFLOW.md`, 필요 시 Base `orchestrating-deepseek-worktrees`
- Base 동기화·구형 파일: `BASE_RULES_VERSION.md`, `qa/BASE_SYNC_AUDIT_2026-07-21.md`
- Skill 누락·중복·통합: Base `evolving-project-discipline-skills`

작업 조건이 없으면 추가 문서·Skill을 읽지 않는다.

## 7. 자동 검증

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
git diff --check
& "C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" tools/docs/build_game_design_doc.py --check
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py
```

- [ ] 변경한 JSON·스크립트·Scene의 계약 테스트가 통과한다.
- [ ] 사용자 저장을 덮어쓰지 않는 격리 테스트를 사용한다.
- [ ] 저장 왕복으로 재추첨·중복 보상·이벤트 재발동이 생기지 않는다.
- [ ] Registry의 Base commit·blob, Base 13개 trigger, 프로젝트 실행 Skill 10개, Legacy Alias, 프로젝트 책임 경로가 일치한다.
- [ ] 프로젝트 Registry와 실제 `SKILL.md`가 1:1이다.
- [ ] 프로젝트 trigger 완전 중복과 대표 routing 실패가 없다.
- [ ] 미실행 항목을 통과로 쓰지 않는다.

## 8. PR changed-file 감사

- [ ] 승인 범위 밖 파일이 없다.
- [ ] 보호 경로 변경은 명시적 기능 요청과 회귀 증거가 있다.
- [ ] 삭제·rename·대량 이동은 승인된 처리표와 복구 경로가 있다.
- [ ] 경로·ID·Schema·정본 변경의 untouched 소비자를 확인했다.
- [ ] Skill 통합 시 고유 절차·Alias·Registry·진입점·테스트가 함께 갱신됐다.
- [ ] stacked PR이면 base PR의 차단 finding을 상속하지 않는다.
- [ ] PR 설명의 검증 결과가 실제 Actions·테스트 상태와 일치한다.
- [ ] 사람 시각 QA, Godot 런타임, 브랜치 보호 등 확인하지 못한 항목을 `NOT_RUN` 또는 `UNVERIFIED`로 적었다.

## 9. 수동 검증

- [ ] 변경된 실제 플레이 경로를 시작부터 결과까지 확인한다.
- [ ] 1280×720과 1920×1080에서 핵심 선택과 문장이 잘리지 않는다.
- [ ] 마우스·키보드·Esc·포커스가 겹치지 않는다.
- [ ] 선택하지 않은 요원·미확보 정보·숨은 수치가 노출되지 않는다.
- [ ] 실패가 진행 차단만 만들지 않고 다음 판단 근거를 남긴다.
- [ ] 연출·컷인·표정·아카 안내가 상태와 선택을 대신하지 않는다.

플레이어 화면·입력·런타임 파일을 변경하지 않은 문서·거버넌스·Skill PR은 수동 플레이 검증을 자동 PASS로 바꾸지 않고 `NOT_RUN — runtime scope unchanged`로 기록한다.

## 10. Definition of Done

- [ ] 완료 기준을 실제 파일과 실행 결과로 확인했다.
- [ ] 기존 세 사건과 저장 호환성을 보존했다.
- [ ] 변경 범위 밖 리팩터링과 새 상태 필드를 추가하지 않았다.
- [ ] 자동·수동 검증 결과와 미검증 항목을 구분했다.
- [ ] Skill 사용을 보고했다면 실제 `SKILL.md`와 해당 mode를 수행했다.
- [ ] `docs/CURRENT_STATUS.md`, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`의 갱신 필요를 심사했다.
- [ ] 완료 상세를 현행 문서에 중복하지 않고 `docs/qa/` 또는 날짜별 백업에 기록했다.
- [ ] `main`과 `origin/main`의 통합 상태를 확인했다.
- [ ] 실제 사용한 Work Mode·Skill·Skill Mode와 얻은 결과를 보고했다.

## 11. 완료 보고

- Work Mode·Skill·Skill Mode와 선택 이유
- 변경 파일과 이유
- 플레이어가 확인할 변화
- 구현 내용
- 자동·수동 검증
- 미검증·위험
- 저장·UI·데이터 호환
- 현행 문서 갱신과 백업 위치
- 다음 구현 진입점

외부 도구·모델을 사용했다면 실제 사용 여부와 적용하지 않은 산출물을 사실대로 적는다.
