# Codex Goal - MVP-021

## 기준

- Issue: #28 `[MVP-021] 메인 UI·사건 준비 UI 리디자인 1차`
- 기준 문서: `MVP_ROADMAP.md`, `docs/MVP_STATUS_AUDIT.md`, `TEST_CHECKLIST.md`
- 플랫폼 목표: PC 기준 Steam 출시

## 작업 전 확인

먼저 GitHub Base 원본 규칙을 확인한다.

- `alsdmlals4-eng/Base/docs/MVP_WORKFLOW_CHECKLIST.md`
- `alsdmlals4-eng/Base/docs/AI_WORKFLOW_RULES.md`
- `alsdmlals4-eng/Base/docs/BENCHMARKING_REFERENCE_GUIDE.md`

그다음 `docs/DOCUMENTATION_MAP.md`의 읽기 순서를 따른 뒤, Issue #28과 아래 파일을 확인한다.

- `scripts/ui/main_menu.gd`
- `scripts/scenes/preparation_scene.gd`
- 관련 `.tscn` 파일
- `README.md`
- `TEST_CHECKLIST.md`

## 벤치마킹 반영 기준

Issue #28과 `MVP_ROADMAP.md`의 벤치마킹 결론을 확인하고, Goal에는 실행에 필요한 만큼만 반영한다.

- Unity Asset Store: UI 키트/템플릿/상점형 정보 구조에서 버튼 그룹, 카드 구성, 기능 소개 방식을 참고한다.
- Tales of Tuscany Demo: Steam 위시리스트 유도, 데모 소개, 빠른 기능 소개, 개성 있는 상호작용 소개 방식을 참고한다.

## 작업

Issue #28을 기준으로 메인 메뉴와 사건 준비 화면의 정보 위계를 PC/Steam 기준으로 정리한다.

1. `main_menu.gd`에서 주요 행동, 저장/요원 상태, 개발용 테스트 버튼을 분리한다.
2. `preparation_scene.gd`에서 현재 사건, 사건 선택, 요원, 장비, 기록물, 로그, 조사 시작을 카드/섹션 단위로 읽히게 정리한다.
3. 기존 새 게임, 이어하기, DB 진입, 저장 초기화, 사건 선택, 장비 장착, 조사 시작 흐름을 보존한다.
4. PC 16:9 기준으로 정보 위계, 버튼 순서, 마우스 클릭 흐름을 점검한다.
5. `TEST_CHECKLIST.md` 또는 `README.md`에 MVP-021 확인 항목을 반영한다.

## 제한

- 새 괴담 에피소드, 조사 화면 UI, DB/보고서 UI, 저장 구조를 이번 작업에 포함하지 않는다.
- 대형 아트, 애니메이션, 복잡한 테마 시스템은 추가하지 않는다.
- 모바일 세로 최적화를 이번 기준으로 삼지 않는다.
- Issue와 규칙 문서에 있는 내용을 Goal에 장문 반복하지 않는다.

## 완료 기준

- 주요 플레이 버튼과 개발/테스트 버튼이 구분된다.
- 준비 화면의 정보가 카드/섹션 단위로 구분된다.
- 시작 가능/불가능 이유가 읽힌다.
- PC 16:9 기준의 버튼 순서와 정보 위계가 확인된다.
- 기존 흐름이 깨지지 않는다.
- Godot headless 또는 수동 확인 결과를 보고한다.

## 보고 형식

```md
## 변경 파일
-

## 벤치마킹 반영
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
