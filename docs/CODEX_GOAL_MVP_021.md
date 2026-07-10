# Codex Goal - MVP-021

## 기준

- Issue: #28 `[MVP-021] 메인 UI·사건 준비 UI 리디자인 1차`
- 기준 문서: `MVP_ROADMAP.md`, `docs/MVP_STATUS_AUDIT.md`, `TEST_CHECKLIST.md`

## 작업 전 확인

먼저 GitHub Base 원본 규칙을 확인한다.

- `alsdmlals4-eng/Base/docs/MVP_WORKFLOW_CHECKLIST.md`
- `alsdmlals4-eng/Base/docs/AI_WORKFLOW_RULES.md`

그다음 `docs/DOCUMENTATION_MAP.md`의 읽기 순서를 따른 뒤, Issue #28과 아래 파일을 확인한다.

- `scripts/ui/main_menu.gd`
- `scripts/scenes/preparation_scene.gd`
- 관련 `.tscn` 파일
- `README.md`
- `TEST_CHECKLIST.md`

## 작업

Issue #28을 기준으로 메인 메뉴와 사건 준비 화면의 정보 위계를 정리한다.

1. `main_menu.gd`에서 주요 행동, 저장/요원 상태, 개발용 테스트 버튼을 분리한다.
2. `preparation_scene.gd`에서 현재 사건, 사건 선택, 요원, 장비, 기록물, 로그, 조사 시작을 카드/섹션 단위로 읽히게 정리한다.
3. 기존 새 게임, 이어하기, DB 진입, 저장 초기화, 사건 선택, 장비 장착, 조사 시작 흐름을 보존한다.
4. 모바일 세로 화면 기준으로 스크롤 순서와 버튼 간격을 점검한다.
5. `TEST_CHECKLIST.md` 또는 `README.md`에 MVP-021 확인 항목을 반영한다.

## 제한

- 새 괴담 에피소드, 조사 화면 UI, DB/보고서 UI, 저장 구조를 이번 작업에 포함하지 않는다.
- 대형 아트, 애니메이션, 복잡한 테마 시스템은 추가하지 않는다.
- Issue와 규칙 문서에 있는 내용을 Goal에 장문 반복하지 않는다.

## 완료 기준

- 주요 플레이 버튼과 개발/테스트 버튼이 구분된다.
- 준비 화면의 정보가 카드/섹션 단위로 구분된다.
- 시작 가능/불가능 이유가 읽힌다.
- 기존 흐름이 깨지지 않는다.
- Godot headless 또는 수동 확인 결과를 보고한다.

## 보고 형식

```md
## 변경 파일
-

## 구현 내용
-

## 유지한 흐름
-

## 검증 내용
-

## 남은 위험
-
```
