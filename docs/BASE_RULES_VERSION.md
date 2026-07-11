# Base Rules Version

## 동기화 기준

- 공용 원본: [`alsdmlals4-eng/Base`](https://github.com/alsdmlals4-eng/Base)
- 기준 브랜치: `main`
- 기준 커밋: [`6de304ee4cba14faf5a85d166f8ae1f1456ee768`](https://github.com/alsdmlals4-eng/Base/commit/6de304ee4cba14faf5a85d166f8ae1f1456ee768)
- 동기화 확인 날짜: `2026-07-11`

## 사용 규칙

일상적인 urban-legend 작업에서는 Base 원격 링크 대신 이 저장소의 공용 로컬 사본을 먼저 읽는다. Base 원격은 공용 규칙 동기화, 기준 차이 확인, 또는 공용 규칙 개선 작업에서만 확인한다.

단, 사용자 최신 지시로 Base 원본 확인이 요구되었거나 공용 규칙을 갱신하는 작업에서는 GitHub Base 원본을 먼저 확인한다.

## 로컬 사본 상태

| 로컬 파일 | Base와의 관계 | 비고 |
|---|---|---|
| `docs/AI_SHARED_WORK_RULES.md` | Base 기반 로컬 사본 | 공용 작업 원칙을 유지한다. |
| `docs/AI_WORKFLOW_RULES.md` | Base 기반 + 프로젝트 확장 | 도시괴담 기록국의 ChatGPT, Goal, 벤치마킹 작업 규칙을 포함한다. |
| `docs/AI_SKILL_ADOPTION_GUIDE.md` | Base 기반 + 프로젝트 확장 | 외부 스킬 비교와 Godot용 최소 라우팅·context compact 기준을 포함한다. |
| `docs/MVP_WORKFLOW_CHECKLIST.md` | Base 기반 + 프로젝트 확장 | 현재 프로젝트의 역할과 MVP 실행 흐름을 포함한다. |
| `docs/BENCHMARKING_REFERENCE_GUIDE.md` | Base 기반 + 프로젝트 확장 | 공용 기록 방식에 도시괴담 기록국 사례 목록과 고정 참고 링크를 더한다. |
| `docs/DOCUMENTATION_MAP.md` | Base 기반 + 프로젝트 적용 | 이 저장소의 실제 문서와 부재 문서를 구분한다. |

동기화는 Base 내용을 무조건 덮어쓰는 절차가 아니다. 먼저 Base의 공용 변경과 이 프로젝트의 확장 내용을 비교하고, 필요한 변경만 반영한 뒤 이 파일의 기준 커밋과 날짜를 갱신한다.

## 2026-07-11 스킬 채택·context compact 동기화

Base 변경:

- 외부 스킬은 프로젝트 규칙보다 낮은 선택형 보조 수단으로 정의했다.
- 스킬 설치 전 script, hook, MCP, 외부 API, cookie, secret, 쓰기 권한을 확인하게 했다.
- 최소 구현 사다리, 최소 스킬 라우팅, active context capsule, phase-boundary compact를 추가했다.
- Base 커밋: `6de304ee4cba14faf5a85d166f8ae1f1456ee768`.

도시괴담 기록국 전용 적용:

- Godot 4.7, PC/Steam, 저장 호환성, 변경 scene 검증을 작업 프롬프트에 유지한다.
- UI 스킬은 웹 미학을 복사하지 않고 화면 역할과 정보 밀도 원칙만 사용한다.
- MVP-028부터 요청하지 않은 HTML 대시보드를 작업 순서와 보고에서 제거했다.
- Superpowers/Harness/Serena 설치 설명은 새 가이드를 가리키는 최소 규칙으로 줄였다.

## 2026-07-10 Base 공용 규칙 갱신 기록

이번 업데이트는 Base 원본의 공용 규칙을 직접 갱신했다.

Base 변경 목적:

- GPT가 매 작업에서 벤치마킹을 수행하게 한다.
- 벤치마킹에서 게임성, 디자인, UX, 아이디어, 시장성, 구현 방식 중 필요한 항목을 확인하게 한다.
- 벤치마킹 결과를 장문 복사가 아니라 개선점/수정점으로 압축하게 한다.
- Issue/문서에는 필요한 맥락만 반영하고, Codex Goal에는 실행에 필요한 지시만 남기게 한다.
- 프로젝트별 고정 참고 링크를 매 작업에서 확인하게 한다.

도시괴담 기록국 로컬 반영:

- 1차 출시 목표를 PC 기준 Steam 출시로 명시했다.
- 모바일 세로 화면 기준은 기본 목표에서 제외하고, 별도 요청 시에만 포함한다.
- Unity Asset Store와 Tales of Tuscany Demo를 고정 벤치마킹 링크로 등록했다.

## 2026-07-10 로컬 확장 기록

이번 업데이트는 Base 원본을 갱신한 것이 아니라 `urban-legend` 프로젝트의 로컬 작업 규칙을 보강한 것이다.

변경 목적:

- Harness 플러그인 설치 또는 다운로드 실패 시에도 GPT + Codex + GitHub 문서 기반 흐름으로 작업을 계속할 수 있게 한다.
- `AGENTS.md`에 GPT, Codex, GitHub의 역할 분리를 명확히 추가한다.
- `docs/CODEX_SHARED_WORK_RULES.md`에 Harness 실패 시 Plan → Work → Review → Ship 대체 규칙을 추가한다.
- `docs/DOCUMENTATION_MAP.md`에 플러그인 실패 대응 규칙의 위치와 읽기 순서를 반영한다.

Base 승격 후보:

- GPT와 Codex의 역할 분리
- 플러그인 실패 시 문서 기반 대체 워크플로우
- Codex Goal 작성 형식
- 파일 변경 보고 형식
- Plan → Work → Review → Ship 단계화
- Base 승격 후보와 프로젝트 전용 규칙 후보를 최종 보고에 분리하는 방식
- GPT 작업 전 벤치마킹 필수 수행
- 벤치마킹 결과를 개선점/수정점으로 압축해 반영하는 방식

프로젝트 전용으로 유지할 내용:

- `urban-legend` 저장소의 실제 문서 경로
- 도시괴담 기록국 세계관과 회수/봉인 용어
- Godot 4.7 stable + GDScript 기준
- 현재 MVP/Issue 문맥
- `battle_scene`을 괴이 안정화/회수 페이즈로 보는 규칙
- PC 기준 Steam 출시 목표
- Unity Asset Store / Tales of Tuscany Demo 고정 참고 링크
