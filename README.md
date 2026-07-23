# urban-legend

> 시작: `START_HERE.md` | 현재 상태 원본: `docs/CURRENT_STATUS.md` | 프로젝트 코어: `docs/PROJECT_CORE.md` | 운영 모델: `docs/OPERATING_MODEL.md` | 기획 인수인계: `docs/planning/README.md`

`괴이 기록국`은 Godot 4.7 stable과 GDScript로 제작하는 PC용 현대 오컬트 수사 어드벤처다. 플레이어는 고정 주인공 권나래로 관측 가능한 단서와 괴이 매뉴얼을 비교해 규칙 가설을 만들고, 그 이해로 회수 전투의 전조를 읽어 괴이를 처치하지 않고 포획 조건을 연다.

> 괴이는 완전히 죽지 않는다. 그렇기에 규칙을 기록하고, 다음에 살아남을 방법을 남긴다.

## 현재 기준

| 항목 | 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 스키마 | `mvp-039` (`mvp-038` 이관 지원) |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 구현 사건 | 저승역, 비 오는 골목의 빨간 우산, 폐주파수 방송국 |
| 주인공·요원 | 권나래 고정 주인공 / 초기 요원 5인 / 서포트 최대 2인 |
| 프로젝트 코어 | `CORE_RECORDED / CORE_STRESS_TESTED` |
| 구현 상태 | `POC_PENDING` |
| Production gate | `HOLD_UNTIL_PLAYER_EVIDENCE` |
| 현재 활성 트랙 | CORE-MVP-001 조사·가설·전조 포획 독립 PoC |

UX-PD-001 2B·2C와 MVP-044~046은 폐기하지 않는다. CORE-MVP-001 플레이 증거가 생긴 뒤 새 코어에 맞게 재매핑하며, 현재 활성 구현 순서로 사용하지 않는다. 구현 사실과 승인 계획의 구분은 [`docs/CURRENT_STATUS.md`](docs/CURRENT_STATUS.md)를 따른다.

## 새 담당자·새 AI 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 선택된 Skill·책임 원본
→ 실제 대상 파일
```

CORE-MVP-001 작업에서는 다음을 추가로 읽는다.

```text
docs/planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md
→ docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md
→ MVP_ROADMAP.md
→ docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md
→ TEST_CHECKLIST.md
```

Base 공용 Skill은 `skills/BASE_SKILL_INDEX.json`에서 선택해 고정된 전문만 읽는다. 프로젝트 분야 Skill 10개와 괴이 사건 작성 로컬 Skill은 `skills/SKILL_REGISTRY.json`이 라우팅한다.

### 기획 문서

- 프로젝트 방향: [`docs/planning/PROJECT_DIRECTION.md`](docs/planning/PROJECT_DIRECTION.md)
- 서사·대화·관계: [`docs/planning/NARRATIVE_CONTENT_PLAN.md`](docs/planning/NARRATIVE_CONTENT_PLAN.md)
- 아트·표정·컷인·연출: [`docs/planning/ART_PRESENTATION_PLAN.md`](docs/planning/ART_PRESENTATION_PLAN.md)
- 준비 화면 점진 공개와 후속 재매핑: [`docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md`](docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md)
- 통합 로드맵·인수인계: [`docs/planning/ROADMAP_AND_HANDOFF.md`](docs/planning/ROADMAP_AND_HANDOFF.md)
- 적용 사례 라이브러리: [`docs/planning/REFERENCE_CASES.md`](docs/planning/REFERENCE_CASES.md)

## 다른 핵심 문서

- 작업별 문서·Skill 선택: [`docs/DOCUMENTATION_MAP.md`](docs/DOCUMENTATION_MAP.md)
- 상세 게임 설계: [`docs/GAME_DESIGN_DOCUMENT.md`](docs/GAME_DESIGN_DOCUMENT.md)
- 검증 계약: [`TEST_CHECKLIST.md`](TEST_CHECKLIST.md)
- 문서 보존 규칙: [`docs/DOCUMENT_LIFECYCLE.md`](docs/DOCUMENT_LIFECYCLE.md)

모든 과거 Goal·QA·제안서를 기본으로 읽지 않는다. 필요한 근거만 [`docs/archive/README.md`](docs/archive/README.md)에서 선택한다.

## 프로젝트 열기

1. Godot 4.7 stable을 실행한다.
2. `Import`를 누른다.
3. 이 저장소의 `project.godot`을 선택한다.
4. 실행하면 `scenes/main_menu.tscn`에서 시작한다.

## 현재 구현 플레이 흐름

```text
신규 캠페인 → 저승역 온보딩 또는 현재 반일 계획
→ 사건·편성 우선 확인 → (선택) 보조 준비 도구 펼치기
→ (선택) HQ 일정 비소모 일상 에피소드
→ 조사·휴식·세력 의뢰 배치
→ 사건 조사 → 규칙 판단 → 안정화·잔향 회수
→ 반일 결과 → 사건 보고서·DB·연구·시장 → 다음 반일
```

이 흐름은 현행 구현 기준선이다. 확정 코어의 `조사 가설 → 전조 정보 → 패턴 대응 → 포획 창` 직접 인과는 CORE-MVP-001 독립 PoC에서 검증한다.

## 구현 핵심

- 최대 10일, 오전·오후 순차 반일 운영
- 권나래 주인공과 서포트 0~2명 저장 호환
- 첫 준비에서 사건·편성을 우선하고 장비·외부 접점·기록을 사용자 선택으로 펼치는 UX-PD-001 2A
- 조사 중 HQ 중단·재개
- 세 사건의 조사·판단·회수·보고서·DB
- 위험 사례를 다음 판단 근거로 남기는 페어플레이 추리
- 저승역 3×3 학습·4×4 최종 검증과 페이지형 괴이 매뉴얼
- 저승역 안정화의 가설·근거·대응 단계형 선택
- 공식 매뉴얼 규칙·검증 대기 후보·위험 사례의 저장·결과·DB 연결
- 기록관 아카 관제 안내
- 초기 5인과 외부 접점 4인의 캐릭터 아트
- 소문시장·마도회·퇴마사 계보 및 3칸 세력 의뢰 게시판

## 주요 구조

```text
assets/                   배경·요원·괴이·아카·캐릭터 아트
data/episodes/            구현 사건 JSON 3개
data/daily_episodes.json  HQ 일정 비소모 일상 에피소드 데이터
scenes/                   메인·준비·대화·현장·회수·결과·DB·시장
scripts/core/             저장 파사드와 캠페인 상태
scripts/data/             에피소드·일상 데이터 로딩
scripts/scenes/           화면별 진행 연결
scripts/ui/               공용 UI·프레젠테이션·접근성
docs/planning/            프로젝트 방향·서사·아트·정보 위계·로드맵·사례
docs/                     현행 설계·상태·운영·검증·백업 라우터
skills/                   Base 인덱스·Coverage·프로젝트 분야/로컬 Skill
tests/                    Godot·계약·회귀 테스트
tools/docs/               GDD DOCX 생성기
```

## 검증

```powershell
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
git diff --check
& "C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" tools/docs/build_game_design_doc.py --build
& "C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" tools/docs/build_game_design_doc.py --check
```

DOCX는 Markdown 정본에서 필요 시 재생성하는 비추적 파생본이다. 상세 수동·기능 검증은 [`TEST_CHECKLIST.md`](TEST_CHECKLIST.md)를 따른다.

## 현재 남은 작업

1. CORE-MVP-001의 독립 PoC 사건 데이터·상태 머신·단일 장면을 TDD로 구현한다.
2. 자동 계약과 기존 39개 Godot 회귀 진입점을 통과시킨다.
3. 1280×720·1920×1080, 마우스·키보드·Esc·접근성 수동 QA를 수행한다.
4. 신규 플레이어 5~8명으로 사전 선언 지표를 측정한다.
5. 지표 결과를 `KEEP / AMPLIFY / CHANGE / RETEST / HOLD`로 판정한다.
6. 통과한 뒤에만 UX-PD-001 2B·2C와 MVP-044~046을 재매핑한다.
