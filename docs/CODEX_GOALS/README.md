# Codex Goals

이 폴더는 신규 Codex Goal을 보관하는 위치다.

기존 `docs/CODEX_GOAL_MVP_017.md`, `docs/CODEX_GOAL_MVP_018.md`는 과거 기록으로 유지한다. 신규 MVP 또는 구현 작업은 이 폴더에 아래 이름으로 작성한다.

```text
MVP_019_goal.md
MVP_020_goal.md
bug_YYYYMMDD_short-title.md
refactor_YYYYMMDD_short-title.md
```

## 표준 구조

```md
# Codex Goal: MVP-000 - 작업명

## 연결 Issue

- Issue: #000

## 작업 목표

-

## 작업 전 확인 파일

- `AGENTS.md`
- `docs/BASE_RULES_VERSION.md`
- `docs/DOCUMENTATION_MAP.md`
- `docs/CODEX_SHARED_WORK_RULES.md`
- `docs/MVP_WORKFLOW_CHECKLIST.md`
- 현재 Issue 본문
- 실제 수정 대상 파일

## 구현 범위

-

## 제외 범위

-

## 완료 기준

- [ ]

## 검증 방법

- [ ]

## 작업 후 보고 형식

- 변경 파일
- 변경 이유
- 구현 내용
- 검증 내용
- Godot 확인 순서
- 남은 위험
- Serena 사용 여부
- 다음 MVP에 넘길 항목
```

## 작성 원칙

- Issue 전체를 길게 반복하지 않는다.
- Codex가 실제로 수정할 범위만 적는다.
- HTML 대시보드 작업은 명시 요청이 없으면 제외한다.
- 벤치마킹 전문은 넣지 않고 필요한 경우 문서 참조 한 줄만 둔다.
- 완료 기준은 실제 파일, 실행 결과, 화면 확인으로 판단 가능한 형태로 쓴다.
