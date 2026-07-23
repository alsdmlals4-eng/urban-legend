# TEST_CHECKLIST

> 문서 위치: `TEST_CHECKLIST.md` | 상태: `docs/CURRENT_STATUS.md` | 코어: `docs/PROJECT_CORE.md` | CI 재개: `docs/CI_COST_OPTIMIZATION_AND_REENABLEMENT.md`

## 목적

현행 **MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / `mvp-039`**를 보호하면서 PR #57의 CORE-MVP-001 독립 PoC를 검증한다. 코드 작성, 자동 검증, 빌드 준비, 플레이 통과를 혼합하지 않는다.

## 현재 게이트

- 구현: `IMPLEMENTATION_IN_PROGRESS`
- 자동 검증: `ACTION_REQUIRED / AUTOMATED_VERIFICATION_PENDING`
- `CI_ENABLED != true` 동안 GitHub Actions job은 runner 할당 없이 `skipped`
- 자동 검증 전 `POC_BUILD_READY`, `READY_FOR_MERGE` 선언 금지
- 플레이 증거 없이 `POC_PASSED` 선언 금지
- 전체 원문 대화·신규 플레이어 행동·사전 지표는 사용자의 요청에 따라 `POC_BUILD_READY` 필수 차단 조건에서 제외

## Actions 재개 전 확인

- [ ] 사용자가 GitHub Actions 사용 가능 상태를 알림
- [ ] `CI_ENABLED=true` 설정 또는 비용 게이트 제거
- [ ] main/nightly full matrix workflow 추가
- [ ] 같은 ref의 이전 실행을 `concurrency`로 취소하도록 유지
- [ ] 문서 PR·코드 PR·main/nightly의 책임이 중복되지 않음

## 공통 자동 검증

### 문서 전용 PR

```text
Ubuntu
Python 3.12
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py
```

- [ ] Godot·Windows·전체 Python matrix를 실행하지 않음
- [ ] 실패할 때만 artifact 업로드
- [ ] artifact 7일 보존

### 코드·데이터·Scene PR

```text
Ubuntu 1개 job
python -m unittest tests/test_core_mvp_001_data_contract.py tests/test_core_mvp_001_static_contract.py
Godot 4.7.1 headless import
bash tests/run_core_mvp_001_tests.sh
bash tests/run_godot_regression.sh
```

- [ ] Python과 Godot가 한 Ubuntu job에서 순차 실행
- [ ] 집중 테스트 `4/4`
- [ ] 전체 Godot 회귀 `43/43`
- [ ] 실패할 때만 로그 artifact 업로드
- [ ] 실행하지 못한 항목을 통과로 보고하지 않음

### main·nightly

- [ ] Ubuntu·Windows × Python 3.11·3.12·3.13 matrix
- [ ] Godot 전체 회귀는 Ubuntu에서 1회만 실행
- [ ] `push: main`, 수동 실행, 03:20 KST nightly
- [ ] PR 검증과 중복 실행하지 않음

## 보호 경계

- [ ] `scripts/core/game_state.gd` 미변경
- [ ] 기존 `data/episodes/**` 미변경
- [ ] 기존 `scripts/scenes/investigation_scene.gd` 미변경
- [ ] 기존 `scripts/scenes/battle_scene.gd` 미변경
- [ ] `project.godot` 미변경
- [ ] `knowledge/base-pack/**` 미변경
- [ ] 저장 `mvp-039`와 `mvp-038` 이관 유지
- [ ] PoC가 기존 GameState·캠페인 저장을 읽거나 쓰지 않음
- [ ] 테스트가 기존 사용자 저장을 복구함

## CORE-MVP-001 데이터 계약

- [ ] `contract_version == core-mvp-001-v1`
- [ ] 조사 장면 3, 단서 6, 매뉴얼 3, 선택지 4, 가설 2, 패턴 3, 행동 8
- [ ] 모든 전용 ID가 `poc001_`로 시작하고 중복 없음
- [ ] 통합 명세의 장면·단서·매뉴얼·선택지·가설·패턴·행동 고정 ID와 정확히 일치
- [ ] `reaction_clue_id`, `resolves_question_id`, `refresh_hypothesis_id` 포함 모든 참조가 존재
- [ ] 회수 순서 5턴, 미관측 패턴이 3·5턴에 출현
- [ ] 포획 표식 3개, 최소 포획 5턴, 최대 회수 8턴
- [ ] 미관측 패턴 1개, 범용 완화 행동 1개 이상, 최초 피해 상한 18
- [ ] `enemy_hp` 계약 없음

## 조사·가설 카드

- [ ] 선택지 4개와 관련 기록 3개 표시
- [ ] 올바른 기록 연결로 정확히 두 선택지 배제
- [ ] 잘못된 연결은 체력·위험·단계 변화 없음
- [ ] 배제 이유가 화면에 남음
- [ ] 남은 두 가설을 플레이어가 직접 선택
- [ ] 지지·반박·미해결 근거를 직접 연결
- [ ] 무관하거나 확보하지 않은 근거는 제출 거부
- [ ] 잘못된 가설은 정답 대신 반응 단서·피해·위험 사례를 남김
- [ ] 실패 뒤 기존 가설 1개 + 변형 가설 1개 유지
- [ ] 같은 위험 사례 반복은 행 추가 대신 `attempts` 증가

## 이해도·미해결 질문

- [ ] `unknown → clue → likely → understood` 단계만 사용
- [ ] 가설 제출과 이해도 승격은 결정론적
- [ ] 필수 지지·반박이 갖춰져야 `likely`
- [ ] 결정적 현장 검증이 핵심 `resolves_question_id`를 기록
- [ ] 필수 미해결 질문이 해소돼야 `understood`
- [ ] 매뉴얼 delta에서 해소된 질문은 unresolved 목록에서 제거
- [ ] resolved 질문은 별도 목록으로 보존
- [ ] 전조 확률은 이미 관측한 패턴의 정보 공개만 결정
- [ ] 전조 실패는 `놈은 무언가 하려 한다.`
- [ ] 거짓 행동명·대상·범위·조건 제공 금지

## 회수 전투

- [ ] 실제 패턴을 해석 전에 고정
- [ ] `understood`에서 관측 패턴 확정 해석
- [ ] 미관측 핵심 패턴 첫 발동은 행동명·대상·범위·조건 비공개
- [ ] 첫 발동에 방어·엄폐·흔적 보호 중 하나 이상 유효
- [ ] 최초 관측 피해 상한 18, 체력 최저 1
- [ ] 첫 발동 뒤 패턴이 관측 목록에 등록
- [ ] 두 번째 발동에서 이해도 해석 적용
- [ ] 패턴 대응으로 포획 표식을 중복 없이 축적
- [ ] 정상 포획 창은 표식 3개와 5턴 이상에서 개방
- [ ] 위험 100·체력 임계·최대 턴에서 긴급 포획 가능
- [ ] 승리 조건에 적 HP 0 없음

## 결과·괴이 매뉴얼

- [ ] 회수 품질·피해 관리·지식 품질을 별도 필드로 반환
- [ ] 정상·비용·긴급 포획 결과를 구분
- [ ] 검증 요건 미달 시 매뉴얼 `candidate`
- [ ] 올바른 가설·필수 근거·질문 해소·현장 검증·포획 완료 시 `verified`
- [ ] 위험 사례와 관측 패턴을 결과 뒤에도 보존
- [ ] 상태 전이가 `RESULT_COMPARE → MANUAL_PROMOTION → COMPLETE`
- [ ] 첫 확인은 매뉴얼 반영 검토, 두 번째 확인은 기록 확정

## 플레이테스트 로그

- [ ] `poc_started`는 세션당 1회
- [ ] 필수 이벤트 이름이 통합 명세와 일치
- [ ] sequence가 1부터 연속 증가
- [ ] payload deep copy
- [ ] JSONL 한 줄에 한 객체
- [ ] 기존 save path 참조 없음
- [ ] 로그 내보내기 실패·성공 문구 표시

## 단계별 UI·접근성

- [ ] `PhaseHost` 아래 현재 단계 패널만 표시
- [ ] Investigation·Hypothesis·FieldTest·Recovery·Result 패널 존재
- [ ] 각 패널 내부에 별도 `ScrollContainer`
- [ ] Footer가 단계 스크롤과 분리돼 고정
- [ ] 이전 단계 검토는 읽기 전용
- [ ] 뒤로보기 뒤 선택한 근거·가설 유지
- [ ] Esc와 BackButton 동작 일치
- [ ] 단계 전환·뒤로보기 뒤 첫 유효 버튼에 포커스
- [ ] 전조·성공·위험을 텍스트로 전달
- [ ] 시간 제한 없음
- [ ] 1280×720과 1920×1080에서 버튼·한국어 텍스트 잘림 없음
- [ ] 기존 화면 흔들림·섬광·왜곡 설정을 훼손하지 않음
- [ ] F1 개발 패널에 전용 PoC 진입 버튼 존재

## 현행 회귀 계약

- [ ] 기존 39개 회귀가 모두 통과
- [ ] 신규 4개 집중 테스트 추가 뒤 전체 runner가 43개를 보고
- [ ] 세 사건 진입·보고서·DB 유지
- [ ] 권나래·서포트·일정·HQ·의뢰·미니게임 회귀 없음
- [ ] 기존 후보·공식 규칙·위험 사례 보존
- [ ] 아카·요원·장비·자동행동이 핵심 정답 대체 금지

## 선택적 플레이 연구

다음은 `POC_BUILD_READY` 필수 조건이 아니며, 사용자가 별도로 플레이 검증을 요청했을 때만 사용한다.

- [ ] 규칙·대응 이유 설명
- [ ] 근거 기반 배제
- [ ] 조사-회수 인과 체감
- [ ] 난수 불공정 인식
- [ ] 매뉴얼 저작감
- [ ] 미관측 패턴 무대응 인식

플레이 증거가 없으면 `POC_PASSED` 대신 `POC_BUILD_READY`까지만 판정한다.

## 문서·참조 최신성

- [ ] README·CURRENT_STATUS·CURRENT_HANDOFF·PROJECT_CORE·GDD·MVP_ROADMAP·TEST_CHECKLIST 정합
- [ ] 구현 PR #57과 Issue #56 상태가 문서와 일치
- [ ] CI 비용 문서가 `CI_ENABLED`, concurrency, 재개 순서를 소유
- [ ] 구현되지 않거나 실행되지 않은 검증을 완료로 기록하지 않음
- [ ] 새 책임 문서 링크와 경로 유효

## 완료 보고

- 판정: ACCEPT / ACCEPT_WITH_FOLLOWUP / REVISE / REJECT / ACTION_REQUIRED / UNVERIFIED / BLOCKED
- 변경 파일과 이유
- Red·Green·Refactor 증거
- 자동·수동 검증 결과
- 미검증·남은 위험·롤백
- 다음 단계 진입 또는 HOLD 근거
