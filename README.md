# urban-legend

`괴이 기록국`은 Godot 4.7 stable과 GDScript로 제작하는 PC용 현대 오컬트 수사 어드벤처다. 플레이어는 주인공 요원 한 명과 최대 두 명의 서포트를 편성하고, 인간의 마음에서 되살아나는 괴이의 규칙을 조사해 현재 출현을 안정화한 뒤 다음 피해를 막을 괴이 매뉴얼을 남긴다.

> 괴이는 완전히 죽지 않는다. 그렇기에 규칙을 기록하고, 다음에 살아남을 방법을 남긴다.

## 현재 기준

| 항목 | 값 |
|---|---|
| 현재 MVP | MVP-043 |
| 화면 버전 | Ver 4.1 |
| 저장 스키마 | mvp-039 (`mvp-038` 이관 지원) |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 구현 사건 | 저승역, 비 오는 골목의 빨간 우산, 폐주파수 방송국 |
| 승인 설계 | 콘텐츠 방향 v0.9 — 공식 용어·첫 10분·저승역 튜토리얼 |
| 다음 작업 | 저승역 첫 10분 수동 플레이타임·가독성 검수와 다른 사건 공용 UI 회귀 확인 |

현재 구현에는 최대 10일 캠페인, 오전·오후 순차 반일 운영, 조사 중 HQ 중단·재개, 요원 5능력, 괴이 안정화·회수, 사건 보고서·DB, 소문시장·마도회·퇴마사 계보와 3칸 의뢰 게시판이 포함된다.

MVP-042에서 HQ 일상 에피소드 3장을 추가했다. 관련 사건이 `lead`·미해결일 때만 열리고, 선택 후 결과·요원 반응·DB 기록만 남긴 채 같은 준비 화면으로 돌아온다. 반일 일정·현장 조사·위험도·요원 편성·세력 의뢰·필수 단서와 회수 패턴은 바꾸지 않는다. 게임 버전은 `Ver 4.1`, 저장 스키마는 `mvp-039`이며 `mvp-038` 저장은 빈 일상 상태로 이관한다. 상세는 [`MVP042_DAILY_EPISODE_VALIDATION.md`](docs/qa/MVP042_DAILY_EPISODE_VALIDATION.md)를 따른다.

## 승인된 다음 콘텐츠 방향

[`docs/CONTENT_DIRECTION_V09.md`](docs/CONTENT_DIRECTION_V09.md)는 사용자와 확정한 다음 설계다. 아직 구현 완료를 뜻하지 않는다.

핵심 변경 방향:

- 공식 기관명: **괴이 기록국**
- 사건 완료 표기: **안정화 상태**
- 실패 기록: **위험 사례**
- 회수 대상: **잔향**
- 최종 기록 보상: **괴이 매뉴얼 작성·갱신**
- 신규 캠페인 첫 경험: 짧은 세계관 소개 뒤 저승역 튜토리얼 진입
- 저승역 핵심 규칙: 안내방송의 목적지 공백을 듣는 사람의 귀환 욕망이 채우며, 안내 종료 전 이동하면 공간이 초기화됨

Codex는 콘텐츠·세계관·온보딩·용어 작업을 시작할 때 `AGENTS.md` 다음으로 이 문서를 읽고, 현재 GDD와 실제 데이터의 차이를 먼저 보고한다.

## 기획서

- 승인된 콘텐츠 방향: [`docs/CONTENT_DIRECTION_V09.md`](docs/CONTENT_DIRECTION_V09.md)
- 현재 구현 기준 편집 원본: [`docs/GAME_DESIGN_DOCUMENT.md`](docs/GAME_DESIGN_DOCUMENT.md)
- 장식된 배포본: [`docs/URBAN_LEGEND_GAME_DESIGN.docx`](docs/URBAN_LEGEND_GAME_DESIGN.docx)
- 현재 로드맵: [`MVP_ROADMAP.md`](MVP_ROADMAP.md)
- 현재 검증 순서: [`TEST_CHECKLIST.md`](TEST_CHECKLIST.md)

GDD를 갱신하면 DOCX도 재생성하고 완료 보고에서 두 파일을 사용자에게 모두 보여준다.

## 프로젝트 열기

1. Godot 4.7 stable을 실행한다.
2. `Import`를 누른다.
3. 이 저장소의 `project.godot`을 선택한다.
4. 실행하면 `scenes/main_menu.tscn`에서 시작한다.

## 현재 구현 플레이 흐름

```text
신규 캠페인 → 현재 반일 계획 → (선택) HQ 일상 에피소드 확인
→ 조사·휴식·세력 의뢰 배치
→ 사건 조사 → 현장 판정 → 괴이 안정화·회수
→ 반일 결과 확인 → 다음 반일/다음 날 → 보고서·DB·연구·시장
```

## 승인된 목표 온보딩 흐름

```text
신규 캠페인 → 괴이와 괴이 기록국 소개 → 저승역 고정 투입
→ 조사·단서 연결·위험 사례·안정화·잔향 회수
→ 괴이 매뉴얼 초안 완성 → HQ 복귀 → 첫 자유 반일 계획
```

MVP-043은 이 흐름의 저승역 vertical slice를 구현했다. 조사 화면은 장소/판단/페이지형 매뉴얼 3열이며, 3×3 학습은 결과를 저장하지 않고 4×4 최종 검증만 한 번 저장한다.

편성은 기존 `selected_agent_ids`의 첫 유효 요원을 주인공, 뒤의 최대 두 명을 서포트로 해석한다. 반일 일정은 주인공에게만 배정·소비하고, 이전 저장 배열과 저장 스키마는 유지한다.

## 주요 구조

```text
assets/                 배경·요원·괴이·로그 이미지
data/episodes/          구현 사건 JSON 3개
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

- 승인된 v0.9 콘텐츠 방향과 현재 저승역 데이터 차이 검수
- 오프닝·첫 10분·저승역 튜토리얼 최소 PoC 설계와 구현 범위 확정
- GDD·DOCX·로드맵·테스트 문서에 공식 용어와 승인 설계 통합
- 연구·장비·세력 콘텐츠 확장 여부 재심사
- 로그·요원 문구 외부 GPT 패스 검토
- Steam 데모 패키징과 180~220분 플레이타임 실측

과거 README 전체 구현 일지는 `docs/archive/history/README_MVP001_038_PRE_GDD.md`에 보관한다.
