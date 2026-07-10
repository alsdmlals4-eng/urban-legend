# Codex Goal - MVP-020

## Issue

- 실제 GitHub Issue: #27
- MVP 번호: MVP-020
- 제목: `[MVP-020] 5개 단위 회고·규칙 다이어트·시스템/UI 전환 기준 정리`

> 주의: GitHub Issue #20은 과거 오생성/중복 종료 이슈다. MVP-020 기준 이슈로 사용하지 않는다.

## 목표

MVP-020은 MVP-015~019까지 쌓인 기능과 문서를 점검하고, 이후 작업 방향을 `괴담 에피소드 추가`가 아니라 `시스템/UI 디벨롭` 중심으로 전환하는 회고·정리 작업이다.

핵심 판단:

```text
괴담 에피소드는 2편까지를 기준 샘플로 두고, 이후 MVP는 시스템·UI·안정화·데모 완성도를 높인다.
```

## 작업 전 확인

작업 시작 전에 실제 파일을 확인한다.

- `AGENTS.md`
- `docs/BASE_RULES_VERSION.md`
- `docs/DOCUMENTATION_MAP.md`
- `docs/AI_SHARED_WORK_RULES.md`
- `docs/AI_WORKFLOW_RULES.md`
- `docs/MVP_WORKFLOW_CHECKLIST.md`
- `docs/CODEX_SHARED_WORK_RULES.md`
- Issue #27
- `README.md`
- `MVP_ROADMAP.md`
- `TEST_CHECKLIST.md`
- `docs/MVP_STATUS_AUDIT.md`
- `PROJECT_BRIEF.md`
- `DESIGN_INTENT.md`
- `data/episodes/`
- `scripts/core/game_state.gd`
- 주요 씬/데이터 파일

## 구현 성격

이번 MVP는 코드 기능 추가보다 문서·규칙·로드맵 정리 중심이다.

단, 실제 파일 구조와 구현 상태를 확인하지 않고 문서만 추정으로 고치지 않는다.

## 작업 범위

### 1. MVP-015~019 회고 정리

다음을 문서에 반영한다.

- MVP-015: 두 번째 사건 준비 연결
- MVP-016: 요원 신뢰도와 이벤트
- MVP-017: 사건 보고서와 신뢰도 결산
- MVP-018: 완료 사건 보고서 DB 재확인
- MVP-019: 두 번째 사건 본격 조사 루프

각 항목은 다음 기준으로 정리한다.

- 유지할 구조
- 줄일 구조
- 위험한 중복
- 다음 MVP로 넘길 항목

### 2. 규칙 다이어트

중복되거나 과도한 설명을 줄인다.

정리 대상:

- 반복되는 작업 순서 설명
- HTML 대시보드 규칙의 GitHub 소스/로컬 파일 혼재
- MVP마다 반복되는 장문 원칙
- `battle_scene` 전투 오해 방지 문구의 불필요한 반복
- Codex Goal에 들어갈 필요 없는 긴 기획 전문

유지할 핵심 규칙:

- Godot 4.7 + GDScript
- Codex는 구현, ChatGPT는 기획/Issue/로컬 HTML/Goal/검수
- HTML 대시보드는 로컬 파일 방식
- `battle_scene` = 괴이 안정화/회수 페이즈
- 괴담은 죽이는 대상이 아니라 규칙을 밝혀 봉인/회수하는 대상
- 요원 신뢰도는 수사 파트너 신뢰
- 기존 사용자 변경사항을 되돌리지 않음

### 3. MVP-021~030 로드맵 재배열

새 괴담 에피소드 추가보다 시스템/UI 중심으로 재배열한다.

권장 방향:

- MVP-021: 메인 UI / 사건 준비 UI 리디자인 1차
- MVP-022: 조사 화면 UI / 단서·힌트 추적 개선
- MVP-023: 사건 보고서 / 기록국 DB UI 고도화
- MVP-024: 요원 시스템 디벨롭
- MVP-025: 장비 / 기록물 시스템 디벨롭
- MVP-026: 괴이 안정화 / 회수 페이즈 UI 개선
- MVP-027: 저장 / 불러오기 / 진행 상태 안정화
- MVP-028: 모바일 세로 화면 / 접근성 / 텍스트 가독성 정리
- MVP-029: 2개 사건 통합 데모 QA
- MVP-030: 데모 후보 빌드 / 소개 자료 정리

### 4. 문서 갱신

필수 갱신:

- `MVP_ROADMAP.md`
- `TEST_CHECKLIST.md`
- `docs/MVP_STATUS_AUDIT.md`
- `docs/DOCUMENTATION_MAP.md`

필요 시 최소 갱신:

- `README.md`

## 제외 범위

이번 MVP에서는 하지 않는다.

- 세 번째 괴담 에피소드 추가
- 새 미니게임 추가
- 새 전투/회수 시스템 추가
- 장기 요원 개인 루트
- 실제 코드 리팩터링
- 저장 구조 변경
- 대형 UI 구현
- GitHub HTML 소스 관리 전환

## 완료 기준

- MVP-015~019 회고가 문서화된다.
- 유지할 구조와 줄일 구조가 분리된다.
- 핵심 규칙과 중복 규칙이 구분된다.
- MVP-021~030 로드맵이 시스템/UI 중심으로 재배열된다.
- HTML 대시보드는 로컬 파일 방식이라는 기준이 유지된다.
- 다음 MVP-021의 작업 방향이 명확해진다.
- 코드 변경이 없거나 최소화되며, 변경이 있다면 이유가 명확하다.

## 작업 후 보고 형식

```md
## 변경 파일

-

## 변경 이유

-

## 정리한 내용

-

## 줄인 규칙

-

## 유지한 규칙

-

## 다음 MVP 제안

-

## 남은 위험

-
```
