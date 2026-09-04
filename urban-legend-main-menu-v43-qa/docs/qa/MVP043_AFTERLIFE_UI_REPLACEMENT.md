# MVP-043 저승역 전용 UI 전면 교체 검증

## 적용 기준

- 승인 기준: 사용자 제공 1·2·3번 참고 화면의 검정·금속·금색·보라 계층, compact 3열 조사, 열린 책 매뉴얼, 3열 4×4 검증 화면
- 폐기 기준: 기존 둥근 청록 공용 카드, 전신 요원 3인 스트립, 대형 하단 VN 패널, 큰 빈 조사 영역
- 구현 경계: 저승역 전용 표시 계층만 변경. `GameState`, 보호 사건 JSON, 저장 스키마, 단서 ID, 미니게임 완료 신호는 변경하지 않음
- 후속 분리: v0.6의 권나래 고정 주인공·초기 5인 변경은 이번 UI 릴리스에 포함하지 않음

## 실제 적용

- Noto Serif KR 제목 / Noto Sans KR 본문과 SIL OFL 라이선스를 프로젝트에 포함했다.
- 저승역 도입은 `현장 이미지 / 긴급 보고 / 잠긴 이상 정보` 3열 briefing으로 교체했다.
- 조사 화면은 `조사 지점 20% / 현장 기록 43% / 열린 책 매뉴얼 37%`로 교체했다.
- 주요 판단 후보 5개, 실패사례 기반 비활성화 근거, 위험 사례 배너와 같은 목록 복귀를 실제 게임 씬에서 확인했다.
- 4×4는 `비교 근거 28% / 텍스처 보드 44% / 현장 반응 28%`로 교체했다.
- 생성형 자산의 텍스트는 사용하지 않았고 모든 한국어 문구는 Godot 실시간 텍스트로 유지했다.
- 기존 책 원본은 밝기 변조 없이 사용하고, 신규 금속 패널과 노선 타일 표면은 별도 파일로 추가했다.

## 실제 렌더 캡처

Windows 렌더러로 1280×720과 1920×1080을 각각 캡처했다. 각 캡처는 격리된 임시 `APPDATA`에서 생성했다.

- `docs/qa/captures/mvp043/ui_replacement/briefing_1280x720.png`
- `docs/qa/captures/mvp043/ui_replacement/investigation_initial_1280x720.png`
- `docs/qa/captures/mvp043/ui_replacement/investigation_cases_1280x720.png`
- `docs/qa/captures/mvp043/ui_replacement/investigation_risk_1280x720.png`
- `docs/qa/captures/mvp043/ui_replacement/route_final_1280x720.png`
- 위 5개 상태의 `1920x1080` 대응 캡처

## 자동 검증

- Godot 4.7 headless 프로젝트 로드: 통과
- `mvp043_opening_flow_test.gd`: 통과
- `mvp043_investigation_ui_test.gd`: 1280×720, 1920×1080, 1918×943 통과
- `mvp043_reasoning_ui_test.gd`: 후보 5개, 위험 복귀, 사례 제외 근거, 최소 후보 2개 통과
- `minigame_controls_test.gd`: 3×3·4×4 입력/등급/위험 사례 계약 통과
- `minigame_scene_smoke_test.gd`: 저승역 route restore와 빨간 우산 분기 통과
- `minigame_pipeline_test.gd`: 결과 저장·재진입 중복 방지 통과
- `git diff --check`: 통과

Godot 종료 시 기존 테스트에서도 관찰되는 RID/ObjectDB 누수 경고가 출력되지만 테스트 종료 코드는 정상이다. 화면 교착, 파서 오류, 결과 중복은 관찰되지 않았다.

## 자산 출처와 QA

신규 생성형 자산의 원본 프롬프트·용도·크기·QA는 `assets/ASSET_MANIFEST.json`에 기록했다. 생성 원본은 Codex 생성물 보관 경로에 유지했고 게임에는 승인 용도의 복사본만 포함했다.

Base 승격 후보 없음. 저승역 사건 전용 시각 체계와 검증 자료로 유지한다.
