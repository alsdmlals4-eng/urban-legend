# Base 기준 기존 프로젝트 마이그레이션 검수

- 프로젝트: 괴이 기록국 (`urban-legend`)
- 저장소: `alsdmlals4-eng/urban-legend`
- 감사 기준 브랜치·커밋: `main` / `dd3c9a8776eb938eeeeb2f1319af6bfc4a135202`
- 현재 프로젝트 채택 Base: `e05e198d9c003623f1a117fa1d4505e97117990e` / v1.6.0 / 2026-07-16
- 비교한 Base: `alsdmlals4-eng/Base` `main` / `45df92c18c12e3b0d070bbc75498490b063e68a0` / 2026-07-19
- 작성일: 2026-07-19
- 현재 단계: `Audit only`
- 실제 변경 권한: 감사 보고서와 동기화 메타데이터 기록만

## 0. 작업 계약과 라우팅

```yaml
work_contract_type: approved_direct_request
work_level: L3
primary_discipline: 프로덕션·PM / 프로젝트 운영
affected_disciplines:
  - 기획 문서·인수인계
  - 개발·엔지니어링
  - QA
  - 아트·자산 관리
change_types:
  - 문서·경로 감사
  - 운영체계 마이그레이션 제안
goal: 현재 구현과 승인 자료를 보존하면서 최신 Base 운영체계의 적용 차이를 증거로 정리한다.
user_value: 새 AI가 현재 상태와 다음 작업을 더 빠르게 찾되 기존 기획·코드·자산·QA를 잃지 않는다.
scope:
  - 현재 책임 문서, 파생본, 자산 manifest, 테스트, GitHub 상태, 참조 구조 감사
  - 최신 Base와의 차이 및 단계별 적용안 작성
out_of_scope:
  - 기존 파일 이동·통합·삭제
  - Markdown 본책의 JSON 전환
  - DOCX·PDF 재발행
  - 코드·데이터·씬·저장 스키마 변경
  - GitHub Issue·PR 종료 또는 브랜치 보호 변경
protected_paths:
  - scripts/core/game_state.gd
  - data/episodes/*
  - project.godot
  - knowledge/base-pack/*
  - 사용자 미추적 QA 캡처
foundation_skills:
  - routing-project-work-by-discipline
  - transforming-requests-into-prompts
discipline_skills:
  - migrating-existing-game-project-structure
deferred_skills:
  - publishing-discipline-bibles
  - evolving-project-discipline-skills
  - verifying-game-project-operating-system
validation:
  - git 상태와 원격 기준선 대조
  - JSON 파싱
  - Markdown 로컬 링크 검사
  - 기존 PowerShell 문서 계약 테스트
  - GDD DOCX 최신성 검사
  - git diff --check
```

## 1. 현재 상태

- 프로젝트 구조: Godot 4.7 프로젝트와 `docs/` 중심의 현행 문서 체계가 같은 저장소에 있다.
- 현행 책임 문서: `AGENTS.md`, `docs/CURRENT_STATUS.md`, `docs/DOCUMENTATION_MAP.md`, `docs/planning/*`, `docs/GAME_DESIGN_DOCUMENT.md`, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`가 역할을 명시한다.
- 분야별 스킬: 저장소 내부 `SKILL_REGISTRY.json`과 프로젝트 스킬은 없다. 사용자 환경의 `urban-legend-game-workflow` 스킬은 저장소 밖에 있어 새 작업자가 저장소만으로 재현할 수 없다.
- 현재 개발 단계·다음 게이트: `main`은 MVP-043 구현 기준선이며 MVP-044 → MVP-045 → MVP-046이 승인 계획이다.
- 실제 실행·검증 상태: 기존 GDD Markdown과 DOCX의 해시는 일치한다. JSON은 파싱된다. 문서 계약 테스트 4개 중 1개만 통과해 문서 정리 이후 테스트 계약이 뒤처졌다.
- Base 차이: 프로젝트는 Base v1.6.0에 고정돼 있고, 최신 Base는 v2.2.0 구조화 기획서·스킬 Registry·발행 Manifest·운영체계 검증까지 확장됐다.

### 유지할 강점

1. `CURRENT_STATUS.md`가 구현 완료와 승인 계획을 분리한다.
2. `DOCUMENTATION_MAP.md`가 조건부 읽기와 과거 자료 기본 제외를 정의한다.
3. `docs/planning/`의 다섯 문서가 프로젝트 방향, 서사, 아트·연출, 로드맵, 사례 책임을 분리한다.
4. GDD Markdown → DOCX 생성과 SHA-256 최신성 검사가 실제로 작동한다.
5. 프로젝트 고유 용어, 보호 경로, 저장 호환, 상태 비소유 UI 원칙이 명시돼 있다.
6. 리디렉션 문서가 과거 링크를 깨뜨리지 않고 현행 원본으로 안내한다.

## 2. 보존 대상

- 승인된 결정: 괴이 기록국, 안정화 상태, 위험 사례, 잔향, 괴이 매뉴얼, 기록관 아카, 권나래 고정 주인공, 서포트 최대 2인.
- 프로젝트 고유 세계관·수치·용어: 세 사건 규칙, 최대 10일·순차 반일, 저장 `mvp-039`과 `mvp-038` 이관, 현재 ID와 데이터 계약.
- 현재 구현 상태와 실제 경로: `scripts/`, `scenes/`, `data/`, `tests/`, `project.godot`.
- 승인 이미지·UI·다이어그램·프롬프트: 추적된 PNG 120개, `assets/ASSET_MANIFEST.json`, `assets/characters/mvp043/ASSET_MANIFEST.json`, GDD가 포함하는 이미지.
- 테스트·실패 사례: `tests/`, `docs/qa/`, `docs/archive/`, 이번 감사에서 확인한 문서 계약 테스트 실패.
- Roadmap·Issue·Goal·Plan 기록: `MVP_ROADMAP.md`, `docs/CODEX_GOAL_*`, `docs/superpowers/`, GitHub Issue와 PR.
- Active Context·Handoff 미완료 작업: `CURRENT_STATUS.md`, `CURRENT_HANDOFF.md`, `planning/ROADMAP_AND_HANDOFF.md`의 MVP-044~046.
- 보류·확인 필요·미검증: GDD와 기획 문서의 상태 표기, 미실행 수동 QA, 장기 연구·장비·세력·Steam 데모 항목.
- 외부 참조·출처·감사 기록: 루트 리디렉션, `docs/archive/**`, 기존 GitHub Issue·PR 링크.
- 사용자 작업: `docs/qa/captures/` 아래 미추적 파일 69개. Git 이력으로 복구할 수 없으므로 처리 승인 전 절대 삭제·이동하지 않는다.

## 3. 전체 인벤토리

감사 시점 Git 추적 파일은 511개다. 주요 확장자는 Markdown 90, JSON 9, DOCX 1, PDF 0, HTML 6, PNG 120, GDScript 78, Scene 23개다.

| ID | 현재 경로 | 유형 | 현재 역할 | 상태 | 제안 | 위험·검증 |
|---|---|---|---|---|---|---|
| INV-01 | `AGENTS.md` | 문서 | 프로젝트 최상위 실행·보호 계약 | 현행 | 유지, 향후 `START_HERE`와 연결 | 과도한 Base 문구 복사 금지 |
| INV-02 | `README.md` | 문서 | 외부 소개·실행·현재 기준 | 현행 | 유지 | 상태 원본과 중복 최소화 |
| INV-03 | `docs/CURRENT_STATUS.md` | 문서 | 구현·승인 계획 단일 상태 원본 | 현행 | 유지 | Active Context와 전문 중복 금지 |
| INV-04 | `docs/CURRENT_HANDOFF.md` | 문서 | 계정·채팅 인수 상태 | 현행 | 유지·계약 재검토 | 기존 테스트 기대 필드와 불일치 |
| INV-05 | `docs/DOCUMENTATION_MAP.md` | 문서 | 조건부 문서 라우터 | 현행 | 유지·새 Registry 연결 | 현재 링크 검사는 통과 |
| INV-06 | `docs/planning/PROJECT_DIRECTION.md` | 문서 | 프로젝트 약속·핵심 경험 | 현행 본책 | JSON 승계 후보, 전환 전 유지 | 고유 인물·미감·금지 방향 보존 |
| INV-07 | `docs/planning/NARRATIVE_CONTENT_PLAN.md` | 문서 | 서사·대사·관계 | 현행 본책 | JSON 승계 후보, 전환 전 유지 | 상태·대사 데이터 경계 보존 |
| INV-08 | `docs/planning/ART_PRESENTATION_PLAN.md` | 문서 | 아트·표정·컷인·UI·접근성 | 현행 본책 | JSON 승계 후보, 전환 전 유지 | 승인 자산·폴백 계약 보존 |
| INV-09 | `docs/planning/ROADMAP_AND_HANDOFF.md` | 문서 | 단계·진입·완료·인수인계 | 현행 | 운영 Markdown 유지 우선 | GDD·로드맵과 장문 중복 점검 |
| INV-10 | `docs/planning/REFERENCE_CASES.md` | 문서 | 프로젝트 적용 사례 | 현행 보조 | 유지 | Base 공용 사례와 프로젝트 고유 사실 분리 |
| INV-11 | `docs/GAME_DESIGN_DOCUMENT.md` | 문서 | 상세 게임 설계 편집 원본 | 현행 본책 | 구조화 JSON 승계의 핵심 후보 | 21개 장과 상태·표·이미지 무손실 대조 필요 |
| INV-12 | `docs/URBAN_LEGEND_GAME_DESIGN.docx` | DOCX | GDD 사람용 파생본 | 현행 파생본 | 새 발행 체계 검증 전 유지 | 현재 SHA·구조 검사 통과, PDF·Manifest 없음 |
| INV-13 | `MVP_ROADMAP.md` | 문서 | 구현 순서 | 현행 | 운영 Markdown 유지 | GitHub Issue 상태와 불일치 |
| INV-14 | `TEST_CHECKLIST.md` | 문서 | 검증 계약 | 현행 | 유지·Development Gates와 연결 | 실제 계약 테스트 3개 실패 |
| INV-15 | `assets/ASSET_MANIFEST.json` | JSON | 선택 자산·프롬프트·QA | 현행 보조 | Visual Source와 연결 | 전역 캐노니컬 ID·해시·승인 상태 구조 부족 |
| INV-16 | `assets/characters/mvp043/ASSET_MANIFEST.json` | JSON | 캐릭터 28종 컬렉션 | 현행 보조 | 기존 manifest를 승계·확장 | 중첩 manifest 책임 경계 명시 필요 |
| INV-17 | `docs/qa/**` | 문서·이미지 | 완료·수동 QA 증거 | 보조·백업 | 기본 읽기 제외 유지 | 추적·미추적 증거 혼재 |
| INV-18 | `docs/archive/**` | 문서·HTML | 과거 원문·감사·백업 | 백업 | 유지 | 고유 승인 근거 삭제 금지 |
| INV-19 | `docs/CODEX_GOAL_*`, `docs/superpowers/**` | 문서 | 완료 Goal·과거 Plan | 보조·백업 | 기본 읽기 제외 유지 | 현행 계획으로 오인하지 않게 상태 필요 |
| INV-20 | `DESIGN_INTENT.md`, `PROJECT_BRIEF.md`, `docs/CONTENT_DIRECTION_V09.md` | 문서 | 과거 링크 호환 리디렉션 | 보조 | 유지 | 외부 참조 조사 전 삭제 금지 |
| INV-21 | `docs/MVP_STATUS_AUDIT.md`, `docs/PROJECT_COMPACT_AUDIT.md`, `docs/UI_UX_REDESIGN_R1_REPORT.md`, `docs/urban_legend_flow_dashboard.html` | 문서·HTML | 과거 경로 호환 리디렉션 | 보조 | 유지 | 삭제보다 짧은 리디렉션이 안전 |
| INV-22 | `.github/ISSUE_TEMPLATE`, PR 템플릿 | 템플릿 | GitHub 작업 계약 | 현행 보조 | Base 최신 계약과 선택 비교 | Actions·governance checker 없음 |
| INV-23 | `tests/*.ps1` | 테스트 | 문서·워크플로 계약 | 현행 테스트 | 현행 문서와 재정렬 | 과거 문구를 강제해 3개 실패 |
| INV-24 | 사용자 미추적 `docs/qa/captures/**` 69개 | 이미지·로그 | 로컬 QA 증거 | 확인 필요 | 보존 처리표 승인 전 유지 | Git 이력 복구 불가 |

## 4. 현행 책임 원본 지도

| 질문·주제 | 현행 책임 원본 | 보조·근거 자료 | 실제 파일·테스트 | 상태 | 갱신 트리거 |
|---|---|---|---|---|---|
| 프로젝트 방향 | `planning/PROJECT_DIRECTION.md` | `PROJECT_CONTEXT.md`, GDD | 실제 사건·UI·자산 | 현행 | 핵심 경험·용어·미감 변경 |
| 현재 구현 상태 | `CURRENT_STATUS.md` | README, Handoff | `main`, 코드·데이터·테스트 | 현행 | MVP 통합·검증 상태 변경 |
| 개발 단계·게이트 | `MVP_ROADMAP.md`, `planning/ROADMAP_AND_HANDOFF.md` | `MVP_WORKFLOW_CHECKLIST.md` | Issue·Goal·테스트 | 부분 | Base식 명시적 Development Gates 없음 |
| 상세 게임 설계 | `GAME_DESIGN_DOCUMENT.md` | 기획 문서 5개 | 코드·데이터·씬 | 현행 | 시스템·콘텐츠 설계 변경 |
| 서사·관계 | `planning/NARRATIVE_CONTENT_PLAN.md` | `DIALOGUE_AUTHORING_WORKFLOW.md` | 사건·일상·세력 JSON | 현행 | 대사·관계·선택 기억 변경 |
| 아트·UI·연출 | `planning/ART_PRESENTATION_PLAN.md` | 이미지·UI 워크플로 | assets·scene·UI script | 현행 | 자산·화면 위계·연출 변경 |
| 분야별 스킬 | 저장소 내부 원본 없음 | 사용자 환경 스킬 | 없음 | 누락 | 프로젝트 스킬 설치 승인 |
| 승인 이미지 | 두 Asset Manifest | GDD 이미지·QA 캡처 | PNG와 Godot import | 부분 | 자산 승인·교체·실제 화면 QA |
| 최신 사람용 본책 | `URBAN_LEGEND_GAME_DESIGN.docx` | GDD Markdown | `build_game_design_doc.py --check` | DOCX만 현행 | GDD 변경 |
| 완료 검증 | `TEST_CHECKLIST.md` | `docs/qa/**` | GDScript·PowerShell 테스트 | 부분 | 구현·문서 계약 변경 |

## 5. 핵심 누락·충돌

### P0 — 먼저 보존·판정

1. 미추적 QA 파일 69개가 있다. 선택 증거를 Git에 포함할지, 외부 백업으로 둘지, 생성 로그를 제외할지 사용자 판단이 필요하다.
2. GitHub에는 완료선보다 오래된 MVP Issue 25개가 열린 상태다. Issue #1~31 다수가 현재 `main`의 MVP-043보다 과거이며 상태 원본과 충돌한다.
3. PR #26 `docs: add agentic GitHub workflow templates`는 열려 있고 `mergeable: false`다. 최신 Base v2.x 및 2026-07-16 문서 정리와 내용이 겹칠 수 있어 단순 병합하면 안 된다.
4. 기존 PowerShell 계약 테스트 4개 중 3개가 실패한다. 실패는 현재 기능 결함보다 문서 정리 뒤 테스트 문구가 갱신되지 않은 정황이 강하지만, 승인 없이 테스트를 약화하지 않는다.

### P1 — Governance foundation 누락

- 루트 `START_HERE.md` 없음.
- `ACTIVE_CONTEXT.md`, `DEVELOPMENT_GATES.md`, `DOCUMENT_UPDATE_MATRIX.md` 없음.
- `DESIGN_DOCUMENT_REGISTRY.json`과 구조화 기획서 JSON 없음.
- 프로젝트 `SKILL_REGISTRY.json`, 분야 스킬, Learning Log, 사람용 Skill Map 없음.
- 문서·스킬·발행 Governance checker와 GitHub Actions 없음.
- GDD PDF, 자동 다이어그램, Publication Manifest, 전 페이지 렌더 검수 없음.
- 전체 자산의 캐노니컬 ID와 승인·구현·시각 검증 상태를 한 곳에서 찾는 Visual Source가 없음.

### P2 — 구조 최적화 후보

- `CURRENT_STATUS`, `CURRENT_HANDOFF`, `ROADMAP_AND_HANDOFF`, `MVP_ROADMAP`의 역할은 명확하지만 일부 현재 기준과 다음 작업 문장이 반복된다.
- GDD와 분야별 Markdown 본책은 Base v2.2.0의 JSON 책임 원본 계약과 다르다. 그러나 현재 구조가 실제로 작동하므로 즉시 변환보다 무손실 승계가 우선이다.
- 90개 Markdown 중 완료 Goal·QA·과거 Plan이 많다. 현재 Documentation Map이 기본 읽기에서 제외하므로 파일 수 자체는 실패가 아니다.

## 6. 구조 변경 제안

다음은 제안이며 이번 감사에서 생성·이동하지 않는다.

| 단계 | 현재 경로 | 제안 경로·처리 | 이유 | 보존 내용 | 위험 | 승인 필요 |
|---|---|---|---|---|---|---|
| B1 | 루트에 시작 문서 없음 | `START_HERE.md` 추가 | 새 AI 단일 진입점 | 기존 읽기 순서 링크만 사용 | 또 다른 장문 원본이 될 위험 | 예 |
| B2 | 현재 docs 라우터 | `[기획서]/00_프로젝트_허브/START_HERE.md`를 브리지로 추가 | Base 도구와 프로젝트 구조 연결 | 기존 경로를 이동하지 않음 | 이중 진입점 혼동 | 예 |
| B3 | 현재 상태·handoff | 짧은 `ACTIVE_CONTEXT.md` 추가 | 현재 단계·다음 행동·위험만 압축 | 전문은 기존 원본 링크 | 상태 중복 | 예 |
| B4 | 로드맵·체크리스트 | `DEVELOPMENT_GATES.md` 추가 | Definition of Ready부터 Integration까지 판정 | 기존 MVP 진입·완료 기준 연결 | 형식만 늘어날 위험 | 예 |
| B5 | 문서 갱신 규칙 분산 | `DOCUMENT_UPDATE_MATRIX.md` 추가 | 변경 유형별 갱신 대상을 기계 판독 | 현행 규칙 링크 | 과도한 강제 갱신 | 예 |
| B6 | 저장소 스킬 없음 | 최소 프로젝트 `SKILL_REGISTRY.json`과 Learning Log | 새 AI가 프로젝트 전용 스킬을 찾음 | 현재 urban-legend workflow를 기준으로 검토 | 사용자 환경 스킬과 중복 | 예 |
| B7 | GitHub 자동 검사 없음 | 문서·링크·스킬 checker를 비차단 CI로 먼저 추가 | 실제 실패를 수집한 뒤 강제 | 기존 테스트 유지 | 초기 오탐 | 예 |
| C1 | GDD Markdown 본책 | 통합 기획서 JSON으로 무손실 승계 | 구조화 책임·추적성 | 21개 장, 표, 상태, 이미지, 미확정 | 정보 축약·상태 손실 | 예 |
| C2 | 분야별 planning Markdown | 프로젝트 방향·서사·아트·프로덕션 JSON으로 단계 승계 | 분야 책임과 발행 연결 | 고유 판단·금지·예외·ID 경계 | 강제 11문서 분할 금지 | 예 |
| C3 | DOCX만 존재 | JSON → DOCX·PDF·다이어그램·Manifest 발행 | 사람 열람·최신성 검증 | 기존 DOCX를 비교 기준으로 유지 | 폰트·한글 줄바꿈·렌더 차이 | 예 |
| D1 | 리디렉션·과거 원본 | 참조·고유 정보·복구 대조 후에만 제거 후보 판정 | cleanup | 외부 링크·승인 근거 | 링크 파손·정보 손실 | 별도 삭제 승인 |

### 권장 목표 기획서 묶음

정확한 파일명과 분할은 승인 전 `Undecided`다. 다만 현재 책임을 그대로 보존하는 최소 묶음은 다음과 같다.

| 목표 본책 | 우선 승계 원본 | 책임 범위 |
|---|---|---|
| 프로젝트 통합 기획서 | `PROJECT_DIRECTION.md`, GDD 공통 장 | 프로젝트 약속·책임 범위·현재 방향 |
| 게임 디자인 기획서 | `GAME_DESIGN_DOCUMENT.md` | 핵심 루프·사건·캠페인·저장·밸런스 |
| 서사·관계 기획서 | `NARRATIVE_CONTENT_PLAN.md` | 대사·관계·일상·후일담·세력 서사 |
| 아트·UX·연출 기획서 | `ART_PRESENTATION_PLAN.md` | 아트·UI·표정·컷인·접근성·음향 표현 |
| 프로덕션·QA 기획서 또는 운영 문서 | `ROADMAP_AND_HANDOFF.md`, `TEST_CHECKLIST.md` | 단계·진입·완료·검증·인수인계 |

작은 프로젝트이므로 11개 분야를 각각 별도 파일로 강제하지 않고 `responsibility_coverage`에서 누락 없이 매핑하는 안이 적합하다.

## 7. 문서·스킬 통합 제안

| 책임 주제 | 현행 후보 | 충돌·중복 | 처리 | 새 책임 원본 | 검증 |
|---|---|---|---|---|---|
| 현재 상태 | CURRENT_STATUS, CURRENT_HANDOFF, Roadmap | 현재 기준 일부 반복 | 상태·handoff·단계 역할 유지 | 기존 경로 + 짧은 Active Context | 콜드 스타트 질문 |
| 상세 설계 | GDD, 분야 기획서 | 방향·로드맵 일부 중복 | 요소별 JSON 승계 후 대조 | Design Document Registry | 섹션·표·상태·이미지 대조 |
| 프로젝트 스킬 | 사용자 환경 skill, 문서 규칙 | 저장소에서 재현 불가 | 프로젝트 전용 최소 스킬로 분화 | Skill Registry | trigger·비사용 조건·Learning Log |
| 자산 책임 | 두 manifest, GDD 이미지, QA 캡처 | 전역 캐노니컬 상태 없음 | manifest를 폐기하지 말고 Visual Source에서 연결 | Visual Source + Asset Manifest | 파일·크기·alpha·승인·실제 화면 |
| 검증 | TEST_CHECKLIST, tests, qa | 문서 계약 테스트가 현행 문구와 어긋남 | 실패 원인별 계약 재승인 | Development Gates + tests | 기존 보호 의미 유지 여부 |

## 8. 삭제·제거 후보

이번 단계에서 실제 삭제 후보로 확정한 파일은 없다.

| 파일·범위 | 현재 판단 | 참조 여부 | 복구 방법 | 삭제 조건 | 승인 필요 |
|---|---|---|---|---|---|
| 리디렉션 문서 7종 | 유지 | 과거 Goal·외부 링크 가능 | Git 이력·archive | 외부·내부 참조 0과 사용자 승인 | 예 |
| 완료 `CODEX_GOAL_*` | 기본 읽기 제외 유지 | 과거 구현 근거 | Git 이력 | 고유 결정과 Issue 연결 승계 | 예 |
| 완료 `qa/**` | 근거 자료 유지 | CURRENT_STATUS·Roadmap 참조 | Git 이력 | 증거 인덱스·보존 정책 승인 | 예 |
| `archive/**` | 백업 유지 | 리디렉션·감사 근거 | 현재 파일 자체 | 별도 감사·법적/승인 근거 확인 | 예 |
| 기존 GDD Markdown·DOCX | 현행 유지 | 다수 문서·도구가 참조 | Git 이력 | JSON·DOCX·PDF·Manifest 무손실 대조 통과 | 예 |

## 9. 백업·보류 분류

### `[백업]`

| 자료 | 보존 이유 | 기본 읽기 제외 | 검토 조건 |
|---|---|---|---|
| `docs/archive/**` | 과거 승인·감사·전체 원문 | 예 | 마이그레이션 고유 정보 대조 |
| 완료 `docs/qa/**` | 실제 검증·실패 증거 | 예 | 관련 시스템 변경·release gate |
| 완료 Goal·Plan | 범위·의사결정·실행 이력 | 예 | 해당 기능 회귀·Issue 정리 |

### `[보류]`

| 항목 | 보류 이유 | 재개 조건 | 관련 원본 | 현재 범위 제외 |
|---|---|---|---|---|
| JSON 본책 전환 | 무손실 처리표와 사용자 승인 필요 | Phase B 구조 승인·보존 대조 계획 확정 | GDD·planning 문서 | 예 |
| PDF·Skill Map 발행 | JSON·Registry가 선행 | 생성 환경·폰트·렌더 경로 확인 | Base v2.2 도구 | 예 |
| Required Check 강제 | 비차단 CI 실제 성공 이력 필요 | 오탐 정리·사용자 승인 | GitHub Actions | 예 |
| 오래된 Issue·PR 정리 | 외부 상태 변경이며 근거 댓글 필요 | 종료 처리표 승인 | GitHub | 예 |
| 미추적 QA 캡처 처리 | 사용자 파일이며 보존 정책 미결정 | 보존·선별·제외 승인 | `docs/qa/captures/**` | 예 |

## 10. PDF·발행 검수

| 분야 | 기존 책임 원본 | DOCX | PDF | 자동 다이어그램 | 승인 이미지 | 실제 캡처 | Manifest | 상태·조치 |
|---|---|---|---|---|---|---|---|---|
| 통합 GDD | GDD Markdown | 있음·CURRENT | 없음 | 없음 | GDD에 5개 이미지 포함 | 별도 QA에 존재 | 없음 | 기존 파이프라인은 정상, Base v2.2 발행은 미설치 |
| 프로젝트 방향 | Markdown | 없음 | 없음 | 없음 | 링크 기반 | 일부 존재 | 없음 | JSON 전환 승인 후 발행 |
| 서사·관계 | Markdown | 없음 | 없음 | 없음 | 직접 책임 아님 | 일부 존재 | 없음 | JSON 전환 승인 후 발행 |
| 아트·UX·연출 | Markdown | 없음 | 없음 | 없음 | manifest 존재 | QA 캡처 존재 | 없음 | Visual Source 연결 필요 |
| 프로덕션·QA | Markdown | 없음 | 없음 | 없음 | 해당 없음 | QA 캡처 존재 | 없음 | 운영 문서 유지 여부 결정 |

## 11. GitHub 운영 상태

- 열린 Issue: 25개. 대부분 MVP-002~028 범위이며 현재 구현 완료선 MVP-043과 상태가 어긋난다.
- 열린 PR: #26 1개. `docs/agentic-github-workflow` → `main`, `mergeable: false`.
- 현재 저장소 `.github/`에는 Issue 템플릿과 PR 템플릿이 있으나 workflow와 governance checker는 없다.
- 이번 감사에서는 Issue·PR 댓글, 종료, 라벨, 브랜치 변경을 수행하지 않았다.
- `gh` CLI는 설치돼 있지 않지만 설치된 GitHub 커넥터로 읽기 감사를 완료했다. 로컬 `gh` 설치는 현재 단계의 필수 조건이 아니다.

## 12. 변경 전후 보존 대조

이번 단계는 Audit only라 기존 파일·내용·경로를 이동하지 않았다.

| 기존 내용 | 기존 위치 | 변경 후 위치 | 보존 여부 | 참조 갱신 | 검증 결과 |
|---|---|---|---|---|---|
| 프로젝트 방향·불변 조건 | planning·GDD·AGENTS | 동일 | 보존 | 없음 | 변경 없음 |
| 현재 구현·다음 계획 | CURRENT_STATUS·Roadmap | 동일 | 보존 | 없음 | `main`과 대조 |
| GDD와 DOCX | docs | 동일 | 보존 | 없음 | SHA·구조 검사 통과 |
| 승인·생성 자산 | assets | 동일 | 보존 | 없음 | manifest와 경로 조사 |
| QA·archive·Goal | docs | 동일 | 보존 | 없음 | 추적·미추적 구분 |
| 사용자 미추적 캡처 | docs/qa/captures | 동일 | 보존 | 없음 | 69개 존재 확인 |

## 13. 콜드 스타트 검증

| 질문 | 결과 | 근거·실패 |
|---|---|---|
| 프로젝트 목적과 핵심 경험 | 통과 | README, PROJECT_DIRECTION |
| 현재 구현·검증 상태 | 통과 | CURRENT_STATUS, TEST_CHECKLIST |
| 다음 우선 작업과 선행 조건 | 통과 | CURRENT_STATUS, Roadmap, Handoff |
| 금지·보호 범위 | 통과 | AGENTS, PROJECT_CONTEXT |
| 분야별 책임 문서 | 통과 | Documentation Map, planning README |
| 분야별 프로젝트 스킬 | 실패 | 저장소 Skill Registry·프로젝트 스킬 없음 |
| 구현 전후 개발 게이트 | 부분 통과 | MVP 진입·완료 기준은 있으나 통합 Development Gates 없음 |
| 보류·확인 필요·미검증 위치 | 부분 통과 | 여러 문서에 상태는 있으나 전역 Registry 없음 |
| 승인 이미지와 최신 PDF | 실패 | manifest·DOCX는 있으나 PDF·Visual Source·Publication Manifest 없음 |
| Base 공용 기준과 프로젝트 확장 | 부분 통과 | v1.6.0 경계는 명확하나 최신 v2.2.0 미반영 |

## 14. 검증 결과

### 통과

- `urban-legend/main`과 `origin/main`: 동일 (`0 0`).
- 전체 추적 JSON 9개: 파싱 통과.
- Markdown 로컬 링크 검사: 누락 0건.
- GDD DOCX 최신성: `CURRENT`, source hash `d2ddeb1a...`, 224 paragraphs / 34 tables / 5 images.
- `tests/test_dialogue_workflow_contract.ps1`: 통과.

### 실패·불일치

- `tests/test_account_handoff_contract.ps1`: `AGENTS.md`에 5%/2% 임계값과 과거 handoff 필드를 강제한다. 현재 임계값은 `CODEX_ACCOUNT_HANDOFF.md`에 있으므로 테스트 책임을 재설계할 필요가 있다.
- `tests/test_multimodel_workflow_contract.ps1`: `BASE_RULES_VERSION.md`의 과거 특정 문구를 강제한다. 기능 계약과 문구 일치 검사를 분리해야 한다.
- `tests/test_workflow_context.ps1`: AGENTS 450단어 제한과 영문 `Conditional routing` 문구를 강제한다. 현재 문서는 한국어 `조건부 라우팅`을 사용한다.

실패 테스트를 통과시키기 위해 현행 문서에 오래된 문구를 되넣지 않는다. 다음 단계에서 어떤 의미 계약을 유지할지 승인한 뒤 테스트와 문서를 함께 갱신한다.

### 미실행

- Godot headless와 수동 플레이: 문서 감사만 수행해 런타임 파일을 변경하지 않았으므로 미실행.
- DOCX/PDF 전 페이지 시각 검수: GDD를 재발행하지 않았고 PDF가 없어 미실행.
- GitHub Actions·Required Check: workflow가 없어 미실행.

## 15. 실제 변경 권장 순서

1. **보존 결정:** 미추적 QA 69개와 열린 Issue 25개·PR #26의 처리표를 승인한다.
2. **Governance foundation:** 기존 경로를 유지한 채 START_HERE, Active Context, Development Gates, Update Matrix, 최소 Skill Registry를 브리지로 설치한다.
3. **테스트 계약 복구:** 실패한 문서 계약 테스트 3개의 보호 의미를 현행 문서 책임과 재정렬한다.
4. **비차단 CI:** 링크·Registry·문서 계약 검사를 먼저 관찰 모드로 실행한다.
5. **JSON 파일 1개 PoC:** GDD 전체 변환 전에 프로젝트 통합 기획서의 일부를 무손실로 승계하고 변경 전후 표를 검증한다.
6. **사람용 발행 PoC:** 선택한 JSON 1개에서 DOCX·PDF·다이어그램·Manifest를 생성하고 한글·이미지·전 페이지 렌더를 사람이 확인한다.
7. **분야별 단계 승계:** 서사 → 아트·UX → 게임 디자인 순으로 승인된 처리표만 이관한다.
8. **Cleanup·Enforcement:** 모든 고유 정보·참조·출력이 검증된 뒤에만 리디렉션·기존 본책을 제거 후보로 올리고 Required Check를 심사한다.

## 16. 사용자 승인 필요 항목

1. 다음 작업을 `Governance foundation`으로 진행할지, 현재 구조를 유지하고 Base v1.6.0에 계속 고정할지.
2. 미추적 QA 캡처 69개를 선별해 Git에 보존할지, 별도 백업할지, 로그만 제외할지.
3. 완료된 과거 Issue 25개의 일괄 정리 원칙과 PR #26을 닫을지 재설계할지.
4. Base v2.2.0 JSON·DOCX·PDF 구조를 전면 목표로 승인할지, GDD 1개 PoC만 승인할지.
5. 프로젝트 스킬을 저장소에 포함해 새 AI가 재현 가능하게 만들지.

## 17. 완료 판정

- [x] 실제 파일·원격 기준선·GitHub 상태를 조사했다.
- [x] 승인 결정·이미지·사용자 미추적 파일을 보존 대상으로 분리했다.
- [x] 대규모 삭제·이동·통합을 하지 않았다.
- [x] Base 공용 구조와 프로젝트 고유 구조의 경계를 명시했다.
- [x] 실행한 검증과 미실행 검증을 분리했다.
- [ ] Governance foundation 승인.
- [ ] JSON 본책 마이그레이션 승인.
- [ ] 변경 전후 고유 정보 보존 대조.
- [ ] DOCX·PDF·다이어그램·Manifest 발행 검증.
- [ ] 프로젝트 Skill Registry·Learning Log·Skill Map 검증.
- [ ] GitHub 이슈·PR·Required Check 정리.

이번 결과는 **마이그레이션 완료가 아니라 Audit only 완료**다.
