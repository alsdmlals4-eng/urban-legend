# Agentic GitHub Workflow

이 문서는 `urban-legend`에서 GPT, Codex, GitHub를 Antigravity식 작업 환경처럼 사용하기 위한 프로젝트 전용 운영 규칙이다.

Antigravity와 동일한 IDE 통합 환경을 전제로 하지 않는다. 이 저장소에서는 GitHub를 중앙 지휘면으로 두고, Issue, Codex Goal, Pull Request, Review 문서를 각각 작업 산출물로 사용한다.

## 1. 목적

- GPT는 기획, 범위 정리, Issue, Codex Goal, 검수 기준을 작성한다.
- Codex는 Issue와 Goal을 기준으로 실제 Godot/GDScript/JSON/TSCN 변경을 수행한다.
- GitHub는 작업 지시, 변경 이력, 검증 기록, 승인 흐름을 보관한다.
- 사용자는 방향 결정, Godot 실행 확인, 최종 승인에 집중한다.

## 2. Antigravity식 대응표

| Antigravity 개념 | 이 저장소의 대체 구조 | 사용 규칙 |
|---|---|---|
| Manager Surface | GitHub Issues / Pull Requests / Projects | 여러 작업의 상태와 우선순위를 Issue와 PR로 본다. |
| Agent | Codex | 구현 담당으로 제한한다. 기획 확장이나 임의 리팩터링은 금지한다. |
| Implementation Plan Artifact | GitHub Issue / `docs/CODEX_GOALS/` | 작업 목표, 범위, 제외 범위, 완료 기준을 기록한다. |
| Task List Artifact | Issue 체크리스트 | 구현 전 준비 상태와 완료 기준을 체크한다. |
| Walkthrough Artifact | PR 설명 / `docs/REVIEWS/` | 변경 이유, 플레이어 영향, 검증, 남은 위험을 남긴다. |
| Diff Artifact | Pull Request diff | 실제 파일 변경은 PR diff로 검토한다. |
| Skills | `AGENTS.md`, `docs/BASE_RULES_VERSION.md`, 로컬 Base 사본, `docs/CODEX_SHARED_WORK_RULES.md` | 작업자가 먼저 읽는 규칙 묶음으로 사용한다. |
| Browser/Terminal 검증 | Godot headless 실행, changed scene 실행, 수동 확인 순서 | 검증하지 못한 항목은 완료로 보고하지 않는다. |
| Scheduling | GitHub Issue/Projects 또는 별도 자동화 | 반복 작업은 Issue/체크리스트로 관리한다. |

## 3. 표준 작업 흐름

```text
1. 사용자 요청 수신
2. GPT가 목표, 배경, 플레이어 경험, 범위, 제외 범위, 완료 기준으로 변환
3. 필요한 경우 GitHub Issue 작성 또는 갱신
4. Codex Goal 작성
5. Codex가 구현 브랜치에서 작업
6. Codex가 PR 작성
7. GPT/사용자가 PR 설명, diff, 검증 결과를 리뷰
8. Godot에서 핵심 흐름 확인
9. 승인 후 병합
10. 로드맵, 체크리스트, 상태 감사 문서에 남은 위험 반영
```

## 4. 파일 배치 규칙

| 위치 | 역할 |
|---|---|
| `AGENTS.md` | 모든 작업자의 최상위 프로젝트 규칙 |
| `docs/DOCUMENTATION_MAP.md` | 읽기 순서와 문서 책임 구분 |
| `docs/CODEX_SHARED_WORK_RULES.md` | Codex 구현 규칙과 보고 형식 |
| `docs/CODEX_GOALS/` | 신규 Codex Goal 보관 위치 |
| `docs/REVIEWS/` | PR 또는 MVP 검수 기록 보관 위치 |
| `.github/ISSUE_TEMPLATE/codex_goal.yml` | Codex 작업용 Issue 입력 양식 |
| `.github/ISSUE_TEMPLATE/planning_task.yml` | 기획/시스템 설계용 Issue 입력 양식 |
| `.github/ISSUE_TEMPLATE/bug_report.yml` | 오류 재현/검증용 Issue 입력 양식 |
| `.github/pull_request_template.md` | PR 산출물 제출 양식 |

기존 `docs/CODEX_GOAL_MVP_017.md`, `docs/CODEX_GOAL_MVP_018.md`처럼 루트 `docs/`에 있던 Goal 문서는 과거 기록으로 유지한다. 신규 Goal은 `docs/CODEX_GOALS/`에 만든다.

## 5. Issue 작성 기준

Issue는 Codex가 바로 구현할 수 있는 기준서가 되어야 한다.

필수 항목:

- 해결할 플레이어 문제
- 목표 플레이어 경험
- 이전 MVP에서 받는 상태
- 다음 MVP로 넘길 상태
- 구현 범위
- 제외 범위
- 데이터 / 저장 / 씬 영향
- 완료 기준
- 검증 방법
- 남은 위험

준비되지 않은 Issue는 Codex Goal로 넘기지 않는다.

## 6. Codex Goal 작성 기준

Codex Goal은 Issue 전체를 반복하지 않는다. Codex가 실행할 최소 지시서로 작성한다.

포함:

- Issue 번호
- 작업 목표
- 작업 전 확인 파일
- 구현 범위
- 제외 범위
- 완료 기준
- 검증 방법
- 보고 형식

제외:

- 긴 벤치마킹 전문
- HTML 대시보드 수정 지시
- 장기 기획 설명
- 요청 밖 대규모 구조 변경

## 7. PR 산출물 기준

PR은 단순 diff가 아니라 검토 가능한 작업 산출물이다.

PR 설명에는 반드시 다음을 남긴다.

- 변경 이유
- 플레이어가 체감하는 변화
- 수정 파일
- 구현 범위와 제외 범위
- 자동/정적 검증 결과
- Godot 확인 순서
- 검증하지 못한 항목
- 남은 위험
- 다음 MVP로 넘길 항목

스크린샷, 로그, 실행 결과가 있으면 PR 설명 또는 코멘트에 첨부한다.

## 8. Codex 자율성 제한

Codex는 아래 작업을 임의로 하지 않는다.

- 전체 아키텍처 재설계
- 씬 트리 대규모 재구성
- 리소스 경로 대량 변경
- 저장 시스템 전체 교체
- 기획 의도 없는 UX 변경
- 정상 동작하던 이전 MVP 흐름 제거
- 사용자 변경사항 되돌리기

필요하면 Issue에 위험으로 남기고 별도 MVP로 분리한다.

## 9. 기록국 프로젝트 고정 해석

이 프로젝트의 중심 경험은 `괴담을 죽이는 전투`가 아니라 `규칙을 밝혀 안정화하고 회수하는 조사`다.

따라서 Codex Goal, Issue, PR 설명은 다음 표현을 우선한다.

- 조사
- 기록
- 단서
- 규칙 확인
- 안정화
- 봉인
- 회수
- 위험도
- 괴이 안정도

새로운 HP, damage, kill, death 중심 시스템은 명시 요청이 없으면 추가하지 않는다.

## 10. Base 승격 판단

공용으로 승격할 수 있는 내용:

- Issue / Goal / PR 템플릿 구조
- 역할 분리 원칙
- Artifact 기반 검수 방식
- 구현 AI 자율성 제한 원칙

프로젝트 전용으로 남길 내용:

- 도시괴담 기록국 세계관 표현
- Godot 4.7 stable 기준 실행 명령
- `battle_scene`을 회수/안정화 페이즈로 해석하는 규칙
- 현재 MVP 번호와 로드맵
