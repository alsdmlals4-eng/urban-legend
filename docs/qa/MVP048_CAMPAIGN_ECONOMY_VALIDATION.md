# MVP-048 캠페인·경제 검증

## 구현 범위

- 네 번째 사건 `episode_004_unconfirmed_arrival`을 Day 8부터 별도 조사 후보로 노출한다.
- 기존 잔향 파편·연구 포인트·세력 관계·외부 계약 저장을 재사용한다.
- 카밀라, 박도윤, 이세린 계약을 기존 레이먼드 계약과 같은 예약/배치 경계에 연결한다.
- 일상·관계 장면은 상태를 변경하지 않는 `NarrativeStageShell` 프레임을 사용한다.

## 자동 검증

- `tests/mvp048_campaign_contract_test.gd`: 네 번째 사건 로드, Day 8 해금, 카밀라 예약·결제·1회 완화·저장 왕복.
- `tests/mvp047_raymond_contract_test.gd`: 기존 레이먼드 계약 회귀.
- `tests/mvp047_research_projects_test.gd`: 기존 연구·제작 회귀.
- `tests/mvp046_presentation_test.gd`: 표정·컷인·접근성 표현 회귀.
- `tests/minigame_controls_test.gd`: 저승역 3×3/4×4 조작 계약 회귀.

## 수동 확인 보류

- 1280×720·1920×1080에서 네 번째 사건의 실제 조사/회수/결과 화면 캡처.
- 외부 계약 네 종류의 준비 화면 문구와 박도윤 안내, 이세린 결과 보정의 실제 플레이 확인.
- Day 10 종료 보고서에서 네 번째 사건 미해결/해결 표시 확인.

## 저장 경계

- 기존 저장에 네 번째 사건 상태가 없으면 캠페인 기본값을 유지한다.
- 활성 계약은 기존 `active_mercenary_contract`에만 기록한다. 새 최상위 저장 필드는 만들지 않는다.
- 연구 보정은 이세린 계약이 활성이고 정식 해결 이상일 때 한 번만 적용된다.
