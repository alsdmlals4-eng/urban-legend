# CORE-MVP-001 구현 상태

`POC_BUILD_READY`

독립 PoC 데이터·상태 머신·로그·단계형 장면·F1 개발 진입과 계약 테스트를 작성했다. 고정 ID·참조·질문 해소·매뉴얼 단계·UI drift를 수정했다. 기존 GameState·사건·조사/회수 Scene·`project.godot`·저장 Schema는 변경하지 않았다.

## 검증 증거

- 문서 계약 run #195: PASS
- Python 데이터·정적 계약 run #69: PASS
- Godot 4.7.1 `--import` run #69: PASS
- 집중 테스트 run #69: 4/4 PASS
- 전체 Godot 회귀 run #69: 43/43 PASS
- 1280×720·1920×1080 viewport 경계: PASS
- Esc·포커스·읽기 전용 이전 단계·저장 비침범: PASS
- 보호 경로 diff: PASS
- PR #57 미해결 review thread 0, mergeable true

## 수정된 CI 결함

첫 재활성화 run #66은 `--quit-after 1`이 자산 import 완료 전에 종료해 기존 노선 미니게임 preload가 실패했다. workflow를 Godot의 완료 대기 명령 `--import`로 교체했고 run #68과 #69에서 전체 회귀가 통과했다.

## 판정 경계

`POC_BUILD_READY`는 구현·계약·회귀·기계적 UI 검증 통과를 의미한다. 플레이 증거가 없으므로 `POC_PASSED`는 선언하지 않는다. CORE-MVP-002와 제작 확대는 별도 사용자 승인이 필요하다.
