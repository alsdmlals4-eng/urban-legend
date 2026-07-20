# 책형 이상 매뉴얼 레이아웃 QA — 2026-07-20

관련 Issue: #44

## 결과

| 항목 | 상태 | 근거 |
| --- | --- | --- |
| 책형 매뉴얼 공통 컴포넌트 | PASS | `tests/manual_book_layout_test.gd` |
| 대화: 좌측 현장/중앙 지문·선택/우측 책 | PASS | `tests/dialogue_manual_book_layout_test.gd`, `dialogue.png` |
| 미니게임: 노선 복원·빗속 회피 구조 | PASS | `tests/minigame_scene_smoke_test.gd` 두 경로, `minigame.png` |
| 회수: 중앙 전조·세 대응 카드/우측 책 | PASS | `tests/mvp043_recovery_loop_test.gd`, `recovery.png` |
| 저장·판정·에피소드 데이터 회귀 | PASS | 보호 경로 무변경 대조 및 기존 관련 smoke |
| 실제 수동 플레이 | NOT_RUN | 자동 캡처와 headless 테스트만 수행. 사용자의 Godot 플레이 확인이 필요함. |

## 캡처

- [대화](../../../docs/qa/captures/manual-book-layout/dialogue.png)
- [미니게임](../../../docs/qa/captures/manual-book-layout/minigame.png)
- [회수 페이즈](../../../docs/qa/captures/manual-book-layout/recovery.png)

## 수동 확인 절차

1. 1280×720에서 우측 책이 항상 보이고 중앙 조작 영역을 가리지 않는지 확인한다.
2. 노선 복원에서 타일 클릭, 방향키/Enter, `C`, `R` 입력이 기존과 동일하게 동작하는지 확인한다.
3. 회수 페이즈에서 전조를 읽고 세 대응 카드, 대표 교체, 회수 실행을 순서대로 확인한다.
4. 책 내부를 스크롤한 뒤에도 중앙 선택지와 포커스 이동이 가능한지 확인한다.
