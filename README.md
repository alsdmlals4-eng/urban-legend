# urban-legend

`괴담기록국`은 Godot 4.7 stable과 GDScript로 제작하는 PC용 현대 오컬트 수사 어드벤처다. 플레이어는 고정 주인공 한 명이 아니라 요원 팀을 운용하고, 도시괴담의 규칙을 조사해 괴이를 안정화·회수한다.

> 괴담은 죽이는 게 아니라, 규칙을 밝혀 봉인하는 것이다.

## 현재 기준

| 항목 | 값 |
|---|---|
| 현재 MVP | MVP-038 |
| 화면 버전 | Ver 3.8 |
| 저장 스키마 | mvp-038 |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 구현 사건 | 저승역, 비 오는 골목의 빨간 우산 |
| 계획 사건 | 폐주파수 방송국 |

현재 구현에는 최대 10일 캠페인, 오전·오후 순차 반일 운영, 조사 중 HQ 중단·재개, 요원 5능력, 괴이 안정화·회수, 사건 보고서·DB, 소문시장·마도회·퇴마사 계보와 3칸 의뢰 게시판이 포함된다.

MVP-039의 두 사건 성공·오대응 경로 UX 검증은 완료했다. 현재 다음 작업은 **두 구현 사건 전체 캠페인 수동 QA**다. 신규 캠페인부터 오전·오후 순차 진행, HQ 중단·재개, 사건 보고서·DB와 저장 왕복을 실제 흐름으로 확인한다. 상세 근거는 [`docs/qa/MVP039_MANUAL_UX_VALIDATION.md`](docs/qa/MVP039_MANUAL_UX_VALIDATION.md)를 따른다.

## 기획서

- 편집 기준 원본: [`docs/GAME_DESIGN_DOCUMENT.md`](docs/GAME_DESIGN_DOCUMENT.md)
- 장식된 배포본: [`docs/URBAN_LEGEND_GAME_DESIGN.docx`](docs/URBAN_LEGEND_GAME_DESIGN.docx)
- 현재 로드맵: [`MVP_ROADMAP.md`](MVP_ROADMAP.md)
- 현재 검증 순서: [`TEST_CHECKLIST.md`](TEST_CHECKLIST.md)

기획서를 갱신하면 DOCX도 재생성하고 완료 보고에서 두 파일을 사용자에게 모두 보여준다.

## 프로젝트 열기

1. Godot 4.7 stable을 실행한다.
2. `Import`를 누른다.
3. 이 저장소의 `project.godot`을 선택한다.
4. 실행하면 `scenes/main_menu.tscn`에서 시작한다.

## 현재 플레이 흐름

```text
신규 캠페인 → 현재 반일 계획 → 조사·휴식·세력 의뢰 배치
→ 사건 조사 → 현장 판정 → 괴이 안정화·회수
→ 반일 결과 확인 → 다음 반일/다음 날 → 보고서·DB·연구·시장
```

## 주요 구조

```text
assets/                 배경·요원·괴이·로그 이미지
data/episodes/          구현 사건 JSON 2개
data/faction_requests.json
scenes/                 메인·준비·현장·판정·회수·결과·DB·시장
scripts/core/           저장 파사드와 캠페인 상태
scripts/data/           에피소드 로딩과 사건 계산
scripts/scenes/         화면별 진행 연결
scripts/ui/             공용 UI·로그·레이아웃·접근성
docs/                   현행 설계·규칙·보관 자료
tests/                  Godot·PowerShell 계약 테스트
tools/docs/             기획서 DOCX 생성기
```

## 검증

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
& "C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" tools/docs/build_game_design_doc.py --check
```

상세 플레이 검수는 `TEST_CHECKLIST.md`를 따른다.

## 현재 남은 작업

- 두 구현 사건의 신규 캠페인 전체 수동 QA
- 폐주파수 방송국 vertical slice
- 선택형 일상 에피소드 최소 세트
- 연구·장비·세력 콘텐츠 확장과 밸런스
- 로그·요원 문구 외부 GPT 패스 검토
- Steam 데모 패키징과 180~220분 플레이타임 실측

과거 README 전체 구현 일지는 `docs/archive/history/README_MVP001_038_PRE_GDD.md`에 보관한다.
