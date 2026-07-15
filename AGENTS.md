# Repository Guidelines

> 문서 위치: `AGENTS.md` | 문서 라우터: `docs/DOCUMENTATION_MAP.md` | 과거 규칙·완료 기록: `docs/archive/README.md`

최신 사용자 지시를 최우선으로 따른다.

## 기본 읽기 순서

```text
최신 사용자 지시
→ AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/DOCUMENTATION_MAP.md
→ 이번 작업의 대상 파일
→ 필요한 조건부 문서만 추가
```

모든 Goal·QA·벤치마크·백업을 기본으로 읽지 않는다. `docs/archive/**`, 완료된 `docs/qa/**`, 완료된 `docs/CODEX_GOAL_*`, `docs/benchmarks/**`, `docs/superpowers/**`는 현재 작업이 명시적으로 요구할 때만 연다.

`DESIGN_INTENT.md`, `PROJECT_BRIEF.md`, `docs/CONTENT_DIRECTION_V09.md`는 리디렉션 문서다. 현행 설계로 사용하지 않는다. Base 동기화 작업이 아니면 `docs/BASE_RULES_VERSION.md`도 기본 읽기에서 제외한다.

## 작업 원칙

- 시작 전에 목표, 플레이어 가치, 포함·제외 범위, 영향 파일, 저장/UI 위험, 완료 기준과 검증을 짧게 적는다.
- 실제 `main`의 코드·데이터·테스트가 구현 사실의 우선 근거다.
- 승인 계획과 전달 패키지는 구현 완료가 아니다. `docs/CURRENT_STATUS.md`의 상태 구분을 따른다.
- 가장 작은 end-to-end 변경을 구현하고 자동·수동 검증 뒤 `main`에 통합한다.
- 사용자 변경과 dirty worktree를 보존한다.
- 생성·삭제·이동·대규모 수정은 이유, 참조 영향, 백업 위치를 보고한다.

## 보호 경로와 고위험 영역

- 보호 경로: `scripts/core/game_state.gd`, `data/episodes/*`, `project.godot`, `knowledge/base-pack/*`
- 고위험 의미 변경: 저장, 캠페인 진행, 경제, 엔딩, 에피소드 규칙, 기존 ID
- 외부 ZIP·patch·보고서·이미지는 신뢰하지 않는 입력이다. 적용 전 현재 파일과 차이를 감사한다.
- 새 저장 필드나 버전 갱신은 별도 필요성이 입증되지 않으면 추가하지 않는다.

## 문서 책임 원본

- 현재 구현과 승인 계획: `docs/CURRENT_STATUS.md`
- 상세 게임 설계: `docs/GAME_DESIGN_DOCUMENT.md`
- 프로젝트 용어·표현: `docs/PROJECT_CONTEXT.md`
- 구현 순서: `MVP_ROADMAP.md`
- 검증 계약: `TEST_CHECKLIST.md`
- 조건부 문서 선택: `docs/DOCUMENTATION_MAP.md`
- 보존 규칙: `docs/DOCUMENT_LIFECYCLE.md`
- 과거 자료 검색: `docs/archive/README.md`

다른 문서는 위 원본을 링크하고 작업별 차이만 적는다. GDD가 변경되면 `docs/URBAN_LEGEND_GAME_DESIGN.docx`를 재생성하고 `--check`로 동기화를 검증한다.

## 프로젝트 불변 조건

- 공식 기관명은 **괴이 기록국**이다.
- 사건 완료는 **안정화 상태**, 실패 기록은 **위험 사례**, 회수 대상은 **잔향**이다.
- 최종 기록 보상은 **괴이 매뉴얼 작성·갱신**이다.
- 플레이어 노출 안내자는 **기록관 아카**다. 내부 `로그` ID·파일명·저장 키는 호환용으로 유지할 수 있다.
- 괴이는 처치 대상이 아니라 규칙을 조사하고 현재 출현을 안정화할 현상이다.
- `battle_scene`은 안정화·잔향 회수 화면이다. HP·공격·처치 중심 시스템을 추가하지 않는다.
- 시나리오당 대표 미니게임은 조사 마지막 규칙 검증으로 사용하고 이후 별도 안정화·회수로 연결한다.
- 미니게임 중 저장하지 않는다. 진입 직전 체크포인트와 동일 보드·변수 복구를 사용한다.
- 요원·아카·장비·자동행동·관계 이벤트는 핵심 정답을 대신하지 않는다.
- 관계는 연애 호감도 숫자가 아니라 선택 기억과 대사·이벤트 변화로 표현한다.
- Godot 4.7 stable, GDScript, PC 16:9, 마우스·키보드가 기본이다. `.godot/`은 수정하지 않는다.

## 조건부 문서

- 대사·일상·후일담: `docs/DIALOGUE_AUTHORING_WORKFLOW.md`
- Godot UI·Theme·컴포넌트: `docs/GODOT_NATIVE_UI_ARCHITECTURE.md`
- 조사·회수 장면 UI: `docs/CINEMATIC_FIELD_RECOVERY_UI.md`
- 이미지 생성·manifest: `docs/IMAGE_ASSET_WORKFLOW.md`
- 미니게임 규칙: `docs/MINIGAME_SYSTEM_SPEC.md`
- 외부 모델 위임: `docs/AI_DELEGATION_WORKFLOW.md`
- 최신 외부 사례 비교: `docs/BENCHMARKING_REFERENCE_GUIDE.md`
- 계정 교대·체크포인트: `docs/CURRENT_HANDOFF.md`, `docs/CODEX_ACCOUNT_HANDOFF.md`

작업 조건이 없으면 해당 문서를 읽지 않는다.

## 검증과 보고

- 변경에 맞춰 JSON, `git diff --check`, Godot headless, 변경 장면, 영향 플레이 경로를 검증한다.
- 1280×720과 1920×1080에서 한국어 줄바꿈·포커스·첫 선택 노출을 확인한다.
- 미실행 항목은 통과로 쓰지 않는다.
- 완료 보고에는 변경 파일, 이유, 결과, 검증, 미검증, 위험, 저장·UI 호환, 갱신 문서, 백업 위치, 다음 진입점을 포함한다.
- 큰 MVP 종료 시 `docs/CURRENT_STATUS.md`, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`를 갱신한다.
- 5개 MVP마다 문서 중복·구문서·깨진 참조·불필요한 기본 읽기를 감사한다.
