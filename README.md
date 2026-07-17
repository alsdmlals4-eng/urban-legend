# urban-legend

> 문서 위치: `README.md` | 현재 상태 원본: `docs/CURRENT_STATUS.md` | 활성 기획서 진입점: `docs/DOCUMENTATION_MAP.md` | 과거 소개·로드맵 백업: `docs/archive/backup/2026-07-16/PROJECT_STATUS_AND_ROADMAP_BACKUP.md`

`괴이 기록국`은 Godot 4.7 stable과 GDScript로 제작하는 PC용 현대 오컬트 수사 어드벤처다. 플레이어는 권나래를 주인공으로 운용하고 최대 두 명의 서포트와 함께 괴이의 규칙을 조사해 현재 출현을 안정화한 뒤, 다음 피해를 막을 괴이 매뉴얼을 남긴다.

> 괴이는 완전히 죽지 않는다. 그렇기에 규칙을 기록하고, 다음에 살아남을 방법을 남긴다.

## 현재 기준

| 항목 | 값 |
|---|---|
| 진행 브랜치 기준선 | `codex/mvp048-campaign-novel` / `4cf39a2` (`main` 승격 전) |
| 화면 버전 | Ver 4.1 |
| 저장 스키마 | 기존 호환 유지 / 진행 브랜치 MVP-048 확장 이관 존재 |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 구현 사건 | 저승역, 비 오는 골목의 빨간 우산, 폐주파수 방송국 / 진행 브랜치: 새벽 2시 17분의 도착 알림 |
| 주인공·요원 | 권나래 고정 주인공 / 초기 요원 5인 / 서포트 최대 2인 |
| 현재 우선순위 | MVP-048 사건·외부 계약 완주 검증 → 해상도·입력 캡처 → 전체 회귀 후 `main` 승격 검토 |

MVP-044~048의 일부 구현은 진행 브랜치에 존재하지만, GitHub `main` 승격과 수동 회귀 완료를 뜻하지 않는다. 현재 구현 사실과 계획의 구분은 [`docs/CURRENT_STATUS.md`](docs/CURRENT_STATUS.md)를 따른다.

## 새 담당자·새 AI 읽기 순서

```text
AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/DOCUMENTATION_MAP.md
→ 이번 작업의 활성 기획서 1~2개
→ 실제 대상 파일
```

### 활성 기획서 — 처음에는 이 다섯 개만 읽는다

- 게임 기획: [`[기획서]/01_게임기획서.md`]([기획서]/01_게임기획서.md)
- 프로그래밍·로드맵/MVP: [`[기획서]/02_프로그래밍기획서_로드맵_MVP.md`]([기획서]/02_프로그래밍기획서_로드맵_MVP.md)
- 아트·최신 이미지: [`[기획서]/03_아트기획서.md`]([기획서]/03_아트기획서.md) → [`이미지 인덱스`]([기획서]/이미지_인덱스.md)
- 사운드: [`[기획서]/04_사운드기획서.md`]([기획서]/04_사운드기획서.md)
- QA: [`[기획서]/05_QA기획서.md`]([기획서]/05_QA기획서.md)

세력·공식 용어·초기 요원·외부 계약의 상세 기준은 게임 기획서의 부록 [`세계관 및 설정`]([기획서]/세계관_및_설정.md)에서 확인한다.

## 다른 핵심 문서

- 작업별 문서 선택: [`docs/DOCUMENTATION_MAP.md`](docs/DOCUMENTATION_MAP.md)
- 상세 게임 설계·승인 계획·테스트는 각 활성 기획서의 **부록·근거** 링크에서 필요한 것만 연다.
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
→ (선택) HQ 일정 비소모 일상 에피소드
→ 조사·휴식·세력 의뢰 배치
→ 사건 조사 → 규칙 판단 → 안정화·잔향 회수
→ 반일 결과 → 사건 보고서·DB·연구·시장 → 다음 반일
```

## 구현 핵심

- 최대 10일, 오전·오후 순차 반일 운영
- 권나래 주인공과 서포트 0~2명 저장 호환
- 조사 중 HQ 중단·재개
- 세 사건의 조사·판단·회수·보고서·DB, 진행 브랜치의 네 번째 사건 데이터·계약 기반
- 위험 사례를 다음 판단 근거로 남기는 페어플레이 추리
- 저승역 3×3 학습·4×4 최종 검증과 페이지형 괴이 매뉴얼
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
docs/planning/          프로젝트 방향·서사·아트·연출·로드맵·사례
docs/                   현행 설계·상태·검증·백업 라우터
tests/                  Godot·계약·회귀 테스트
tools/docs/             GDD DOCX 생성기
```

## 검증

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
git diff --check
& "C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" tools/docs/build_game_design_doc.py --check
```

상세 수동·기능 검증은 [`TEST_CHECKLIST.md`](TEST_CHECKLIST.md)를 따른다.

## 현재 남은 작업

1. 네 번째 사건·계약의 실제 완주와 저장/DB 회귀를 검증한다.
2. 다섯 활성 기획서와 실제 대상 파일의 차이를 확인한다.
3. 해상도·입력·텍스트 노벨/저승역 전용 UI의 실제 캡처를 갱신한다.
4. 전체 회귀와 문서 동기화 후에만 통합 브랜치의 `main` 승격을 검토한다.
