# Documentation Map

> 문서 위치: `docs/DOCUMENTATION_MAP.md` | 문서 보존 규칙: `docs/DOCUMENT_LIFECYCLE.md` | 백업 찾기: `docs/archive/README.md`

이 문서는 작업에 필요한 문서만 선택하는 라우터다. 모든 문서를 매번 읽지 않는다.

## 기본 읽기 순서

```text
최신 사용자 지시
→ AGENTS.md
→ CURRENT_STATUS.md
→ DOCUMENTATION_MAP.md
→ 대상 코드·데이터·문서
```

추가 문서는 실제 작업 조건이 있을 때만 읽는다.

## 현행 책임 원본

| 주제 | 현행 원본 | 기본 읽기 여부 |
|---|---|---|
| 현재 구현·승인 계획·미구현 구분 | `CURRENT_STATUS.md` | 항상 |
| 상세 게임 설계 | `GAME_DESIGN_DOCUMENT.md` | 설계·콘텐츠 변경 시 |
| 프로젝트 용어·표현 원칙 | `PROJECT_CONTEXT.md` | 대사·세계관·캐릭터 작업 시 |
| 구현 순서 | `../MVP_ROADMAP.md` | 범위·우선순위 결정 시 |
| 검증 계약 | `../TEST_CHECKLIST.md` | 구현·문서 변경 시 |
| 실행·프로젝트 소개 | `../README.md` | 실행·외부 안내 시 |
| 현재 계정 인수 상태 | `CURRENT_HANDOFF.md` | 계정·채팅 교대 시 |
| 문서 보존·백업 정책 | `DOCUMENT_LIFECYCLE.md` | 문서 이동·정리 시 |

같은 사실을 다른 문서에 복사하지 않고 책임 원본을 링크한다.

## 조건부 라우팅

| 작업 조건 | 추가로 읽을 문서 |
|---|---|
| 대사·상황지시문·일상·후일담 | `DIALOGUE_AUTHORING_WORKFLOW.md`, `PROJECT_CONTEXT.md` |
| Godot UI·Theme·컴포넌트 | `GODOT_NATIVE_UI_ARCHITECTURE.md` |
| 조사·회수 장면 UI | `CINEMATIC_FIELD_RECOVERY_UI.md` |
| 이미지 생성·파생 PNG·manifest | `IMAGE_ASSET_WORKFLOW.md` |
| 미니게임 규칙·조작·복구 | `MINIGAME_SYSTEM_SPEC.md` |
| 외부 GPT·DeepSeek·이미지 모델 위임 | `AI_DELEGATION_WORKFLOW.md` |
| 외부 사례 비교가 필요한 새 판단 | `BENCHMARKING_REFERENCE_GUIDE.md`와 필요한 최신 근거 |
| 저장·진행·일정·위험·경제 | 관련 코드, `MVP037_CAMPAIGN_CORE.md`, `MVP038_SEQUENTIAL_CAMPAIGN.md` |
| 실제 MVP 시작·종료 절차 | `MVP_WORKFLOW_CHECKLIST.md` |
| Base 공용 규칙 동기화 | `AI_SHARED_WORK_RULES.md`, `BASE_RULES_VERSION.md` |
| 계정 교대·저사용량 checkpoint | `CURRENT_HANDOFF.md`, `CODEX_ACCOUNT_HANDOFF.md` |
| 과거 결정·완료 근거 | `archive/README.md`에서 필요한 파일 하나만 선택 |

## 리디렉션 문서

다음 파일은 기존 링크를 보존하기 위한 위치 안내용이며 현행 설계 원본이 아니다.

- `../DESIGN_INTENT.md`
- `../PROJECT_BRIEF.md`
- `CONTENT_DIRECTION_V09.md`
- `BASE_RULES_VERSION.md` — Base 동기화 작업 외에는 읽지 않음

리디렉션 문서를 본 뒤 연결된 현행 원본 또는 백업 파일로 이동하며, 내용 동기화 작업을 만들지 않는다.

## 기본 읽기 제외

- `archive/**`
- 완료된 `qa/**`
- 완료된 `CODEX_GOAL_*`
- `benchmarks/**`
- `superpowers/**`
- 과거 보고서·HTML·일회성 감사

이 자료는 현재 작업의 직접 근거가 필요할 때만 연다. “혹시 필요할 수 있음”은 읽기 조건이 아니다.

## 활성 계획 라우팅

MVP-044~046 전달 패키지는 GitHub `main` 구현 완료 문서가 아니다. ZIP을 받은 작업에서만 다음 순서로 읽는다.

```text
ZIP/00_README_코덱스_전달사항.md
→ ZIP의 구현 지시서
→ 필요한 제안서·레지스트리
→ 현재 저장소의 CURRENT_STATUS.md와 대상 파일
```

패키지 전체를 저장소 현행 문서로 복사하지 않는다. 구현 완료 후 확정된 결과만 상태·GDD·검증 문서에 통합한다.

## 상시 동기화

- 플레이어 노출 설계가 바뀌면 `CURRENT_STATUS.md`, GDD, 로드맵, 테스트 기준을 함께 심사한다.
- GDD 수정 후 DOCX를 재생성하고 `--check`를 실행한다.
- 큰 단계·MVP 종료 시 날짜·버전·다음 작업을 갱신한다.
- 완료 상세는 현행 문서에 누적하지 않고 `qa/` 또는 날짜별 백업으로 이동한다.
- 5개 MVP마다 구문서·중복·깨진 참조·기본 읽기 범위를 감사한다.
