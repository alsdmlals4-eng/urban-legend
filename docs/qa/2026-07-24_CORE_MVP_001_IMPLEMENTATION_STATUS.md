# CORE-MVP-001 구현 상태

`IMPLEMENTATION_IN_PROGRESS / ACTION_REQUIRED / AUTOMATED_VERIFICATION_PENDING`

독립 PoC 데이터·상태 머신·로그·단계형 장면·F1 개발 진입과 계약 테스트를 작성했다. 고정 ID·참조·질문 해소·매뉴얼 단계·UI drift를 수정했다. 기존 GameState·사건·조사/회수 Scene·project.godot·저장 Schema는 변경하지 않았다.

최신 Python·Godot·UI 검증은 GitHub Actions 비용 게이트로 보류한다. 재개 순서는 `CI_ENABLED=true` → full matrix 추가 → Python 계약 → Godot import → 집중 4/4 → 전체 43/43 → UI·보호 경로 → `POC_BUILD_READY` 판정이다.

`POC_BUILD_READY`, `POC_PASSED`, `READY_FOR_MERGE`는 아직 선언하지 않는다.
