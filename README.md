# urban-legend

> 문서 위치: `README.md` | 현재 상태 원본: `docs/CURRENT_STATUS.md` | 기획 인수인계: `docs/planning/README.md` | 과거 소개·로드맵 백업: `docs/archive/backup/2026-07-16/PROJECT_STATUS_AND_ROADMAP_BACKUP.md`

`괴이 기록국`은 Godot 4.7 stable과 GDScript로 제작하는 PC용 현대 오컬트 수사 어드벤처다. 플레이어는 권나래를 주인공으로 운용하고 최대 두 명의 서포트와 함께 괴이의 규칙을 조사해 현재 출현을 안정화한 뒤, 다음 피해를 막을 괴이 매뉴얼을 남긴다.

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
| 현재 계획 | UX-PD-001 2B 조사 정보 위계 → 2C 결과 정보 위계 → MVP-044~046 |

MVP-044~046은 Codex 전달 패키지와 기획 문서가 작성된 **승인 계획**이며 GitHub `main` 구현 완료를 뜻하지 않는다. 현재 구현 사실과 계획의 구분은 [`docs/CURRENT_STATUS.md`](docs/CURRENT_STATUS.md)를 따른다.

## 새 담당자·새 AI 읽기 순서

```text
AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/planning/README.md
→ docs/planning/PROJECT_DIRECTION.md
→ 이번 작업의 분야별 기획서
→ 실제 대상 파일
```

### 기획 문서

- 프로젝트 방향: [`docs/planning/PROJECT_DIRECTION.md`](docs/planning/PROJECT_DIRECTION.md)
- 서사·대화·관계: [`docs/planning/NARRATIVE_CONTENT_PLAN.md`](docs/planning/NARRATIVE_CONTENT_PLAN.md)
- 아트·표정·컷인·연출: [`docs/planning/ART_PRESENTATION_PLAN.md`](docs/planning/ART_PRESENTATION_PLAN.md)
- 준비·조사·결과 정보 위계: [`docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md`](docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md)
- 통합 로드맵·인수인계: [`docs/planning/ROADMAP_AND_HANDOFF.md`](docs/planning/ROADMAP_AND_HANDOFF.md)
- 적용 사례 라이브러리: [`docs/planning/REFERENCE_CASES.md`](docs/planning/REFERENCE_CASES.md)

## 다른 핵심 문서

- 작업별 문서 선택: [`docs/DOCUMENTATION_MAP.md`](docs/DOCUMENTATION_MAP.md)
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

## 구현 핵심

- 최대 10일, 오전·오후 순차 반일 운영
- 권나래 주인공과 서포트 0~2명 저장 호환
- 첫 준비에서 사건·편성을 우선하고 장비·외부 접점·기록을 사용자 선택으로 펼치는 점진적 공개
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
assets/                 배경·요원·괴이·아카·캐릭터 아트
data/episodes/          구현 사건 JSON 3개
data/daily_episodes.json
scenes/                 메인·준비·대화·현장·회수·결과·DB·시장
scripts/core/           저장 파사드와 캠페인 상태
scripts/data/           에피소드·일상 데이터 로딩
scripts/scenes/         화면별 진행 연결
scripts/ui/             공용 UI·프레젠테이션·접근성
docs/planning/          프로젝트 방향·서사·아트·정보 위계·연출·로드맵·사례
docs/                   현행 설계·상태·검증·백업 라우터
tests/                  Godot·계약·회귀 테스트
tools/docs/             GDD DOCX 생성기
```

## 검증

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
git diff --check
& "C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" tools/docs/build_game_design_doc.py --build
& "C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" tools/docs/build_game_design_doc.py --check
```

상세 수동·기능 검증은 [`TEST_CHECKLIST.md`](TEST_CHECKLIST.md)를 따른다.

## 현재 남은 작업

1. UX-PD-001 2B에서 조사 화면의 선택 관련 정보 위계를 작은 단위로 검증한다.
2. 2C에서 결과 화면의 기록·다음 행동 우선순위를 검증한다.
3. 이후 선택한 Codex ZIP의 `IMP-00` 사전 감사를 현재 `main`에서 실행한다.
4. MVP-044~046 중 한 범위만 작은 end-to-end 단위로 구현한다.
5. 구현 완료 후 상태·로드맵·테스트·해당 기획서를 갱신한다.
6. 이후 Steam 데모 패키징과 180~220분 플레이타임 실측을 진행한다.
