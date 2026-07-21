# Current Project Status

> 문서 위치: `docs/CURRENT_STATUS.md` | 최상위 라우터: `START_HERE.md` | 기획 인수인계: `docs/planning/README.md` | 과거 상태·중복 설명: `docs/archive/backup/2026-07-16/`

이 문서는 **현재 구현 사실과 승인됐지만 아직 구현되지 않은 다음 계획을 구분하는 단일 상태 원본**이다. 새 작업자는 모든 과거 Goal·QA·제안서를 읽지 않고 이 문서와 `docs/planning/README.md`에서 필요한 갈래를 선택한다.

## 현재 구현 기준

| 항목 | 현재 값 |
|---|---|
| 구현 기준선 | `main`의 MVP-043 |
| 화면 버전 | Ver 4.1 |
| 저장 스키마 | `mvp-039` (`mvp-038` 이관 지원) |
| 엔진 | Godot 4.7 stable / GDScript |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 구현 사건 | 저승역, 비 오는 골목의 빨간 우산, 폐주파수 방송국 |
| 주인공 | 권나래 고정 |
| 초기 요원 | 권나래·윤서하·오현·강이준·한유리 |
| 외부 접점 | 박도윤·이세린·레이먼드 케인·카밀라 바르가스 |

## 구현 완료 핵심

- 최대 10일, 오전·오후 순차 반일 캠페인
- 권나래 주인공과 서포트 최대 2인 편성·저장 이관
- 조사 중 HQ 중단·재개
- 세 사건의 조사·판단·안정화·잔향 회수·보고서·DB
- 저승역 장소/판단/페이지형 괴이 매뉴얼 3열 UI
- 위험 사례를 삭제하지 않고 배제 근거와 함께 남기는 선택 구조
- 3×3 학습과 4×4 최종 노선 검증
- 자동 전조형 회수와 가로 대응 카드
- HQ 일정 비소모 일상 에피소드 3장
- 소문시장·마도회·퇴마사 계보, 3칸 세력 의뢰 게시판
- 초기 5인과 외부 4인 캐릭터 아트 28종
- 플레이어 노출 안내자 명칭 `기록관 아카`; 내부 `로그` ID는 호환용 유지

## Base 운영체계 동기화 — 게임 구현과 별도

| 항목 | 상태 | 설명 |
|---|---|---|
| Base 기준 | 검토 중 | `alsdmlals4-eng/Base@ee265576da7f67d3278f8099dd97d4e714ef0651` |
| 비파괴 동기화 | Draft PR | 기존 `docs/`, GDD, Roadmap, Test, 게임 파일 경로를 유지하고 운영 모델·Registry·검증만 추가 |
| PR #41~#43 | 병합 차단 권고 | 승인 없는 대규모 이동, 루트 규칙 축약, 구형 Foundation Skill 활성화가 최신 Base와 이주 계약에 충돌 |
| 게임 코드·데이터·Scene·자산 | 변경 없음 | Base 동기화 범위에서 제외 |
| Godot·수동 플레이 QA | `NOT_RUN` | 플레이어 화면과 런타임 파일을 변경하지 않음 |

Base 동기화 PR이 존재한다는 사실은 게임 기능 구현 완료나 프로젝트 구조 이주 완료를 뜻하지 않는다. 병합 전 `tests/test_base_operating_sync.py`와 PR changed-file 감사를 통과해야 한다. 상세 감사: `docs/qa/BASE_SYNC_AUDIT_2026-07-21.md`.

## 승인된 다음 계획 — 아직 GitHub main 구현 완료 아님

| 계획 | 상태 | 핵심 범위 | 구현 선행 관계 |
|---|---|---|---|
| MVP-044 | Codex 전달 패키지·기획서 작성 완료 | 괴이 1~3편 상황지시문·아카 대사, AFTER/DAILY/FACTION 서사 확장 | 현재 사건·일상 ID와 저장 감사 |
| MVP-045 | Codex 전달 패키지·기획서 작성 완료 | 관계 태그, 선택 기억, 연속 캐릭터 이벤트 | MVP-044 서사 ID·완료 상태 안정화 |
| MVP-046 | Codex 전달 패키지·연출 기획서 작성 완료 | 공용 대화 UI, 의미 기반 표정, 컷인, 이벤트 연출, 접근성 폴백 | MVP-044 대사와 MVP-045 관계 반응의 의미 키 확인 |

전달 패키지와 기획서가 존재한다는 사실은 구현 완료를 뜻하지 않는다. Codex는 대상 ZIP의 `00_README_코덱스_전달사항.md`와 `IMP-00` 사전 감사부터 진행한다.

## 기획 인수인계 문서

| 문서 | 확인할 내용 |
|---|---|
| `docs/planning/README.md` | 읽기 순서, 문서 책임, 분야별 라우팅 |
| `docs/planning/PROJECT_DIRECTION.md` | 프로젝트 약속, 핵심 경험, 캐릭터·세계관·시각 불변 조건 |
| `docs/planning/NARRATIVE_CONTENT_PLAN.md` | 사건 대사, 일상·후일담·세력, 관계 태그와 데이터 경계 |
| `docs/planning/ART_PRESENTATION_PLAN.md` | 아트 방향, 표정 의미 키, 컷인, 대화 UI, 접근성 |
| `docs/planning/ROADMAP_AND_HANDOFF.md` | MVP-044~046 진입·완료 기준과 인수인계 절차 |
| `docs/planning/REFERENCE_CASES.md` | 적용한 벤치마킹·내부 사례의 관찰·적용·제외·검증 |

## 현재 권장 구현 순서

1. 대상 Codex ZIP 하나만 선택한다.
2. `IMP-00`에서 현재 `main`, 보호 경로, 저장 호환, 기존 ID를 감사한다.
3. 분야별 기획서에서 플레이어 가치·금지 방향·수용 기준을 확인한다.
4. 구현되지 않은 계획을 `구현 확인`으로 문서에 쓰지 않는다.
5. 작은 end-to-end 단위로 구현·테스트·수동 QA한다.
6. 완료 후 이 문서, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`, 분야별 기획서를 갱신한다.

기본 의존 순서는 MVP-044 → MVP-045 → MVP-046이다. 단, MVP-046의 상태 비소유 공용 대화 스테이지는 기존 대사·관계 데이터를 바꾸지 않는 범위에서 선행할 수 있다.

## 프로젝트 불변 조건

- 공식 기관명은 **괴이 기록국**이다.
- 사건 완료 표기는 **안정화 상태**, 실패 기록은 **위험 사례**, 회수 대상은 **잔향**이다.
- 최종 기록 보상은 **괴이 매뉴얼 작성·갱신**이다.
- 괴이는 처치 대상이 아니라 규칙을 조사하고 현재 출현을 안정화할 현상이다.
- 대사는 일상에서 풍부하게, 조사에서는 짧고 기능적으로 사용한다.
- 요원·아카·장비·자동행동은 미확보 단서·정답·숨은 수치를 대신 제공하지 않는다.
- 관계는 연애 호감도 숫자가 아니라 신뢰·경계·부채·경쟁·공감·보호·균열 같은 선택 기억으로 표현한다.
- 아트·표정·컷인·UI는 상태를 표현하지만 저장·진행 결과를 대신 결정하지 않는다.
- 저장·진행·경제·엔딩 의미 변경은 고위험이며 별도 승인과 회귀 검증이 필요하다.

## 문서 선택

- 운영 시작점: `START_HERE.md`
- 운영 모델: `docs/OPERATING_MODEL.md`
- Work Mode·Skill 라우팅: `docs/WORK_MODE_AND_SKILL_ROUTING.md`
- Skill Registry: `skills/SKILL_REGISTRY.json`
- 기획 인수인계: `docs/planning/README.md`
- 상세 게임 설계: `docs/GAME_DESIGN_DOCUMENT.md`
- 프로젝트 용어·표현 원칙: `docs/PROJECT_CONTEXT.md`
- 현재 구현 순서: `MVP_ROADMAP.md`
- 검증 계약: `TEST_CHECKLIST.md`
- 문서 라우터: `docs/DOCUMENTATION_MAP.md`
- 문서 보존 규칙: `docs/DOCUMENT_LIFECYCLE.md`
- 과거 근거: `docs/archive/README.md`
