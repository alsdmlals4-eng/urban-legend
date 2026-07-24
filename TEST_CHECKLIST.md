# TEST_CHECKLIST

> 문서 위치: `TEST_CHECKLIST.md` | 상태: `docs/CURRENT_STATUS.md` | 코어: `docs/PROJECT_CORE.md` | CI 운영: `docs/CI_COST_OPTIMIZATION_AND_REENABLEMENT.md`

## 목적

현행 **MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / `mvp-039`**를 보호하면서 PR #57의 CORE-MVP-001 독립 PoC를 검증한다. 코드 작성, 자동 검증, `POC_BUILD_READY`, 플레이 통과를 혼합하지 않는다.

## 현재 게이트

- 구현: `POC_BUILD_READY`
- 자동 검증: `PASSED`
- 문서 계약: run #195 PASS
- CORE-MVP-001 코드 계약: run #69 PASS
- 플레이 증거: 없음
- `POC_PASSED`: 미선언
- 제작 확대: 미승인
- 전체 원문 대화·신규 플레이어 행동·사전 지표는 사용자의 결정에 따라 `POC_BUILD_READY` 필수 차단 조건에서 제외

## CI 재활성화

- [x] 사용자가 GitHub Actions 사용 가능 상태를 알림
- [x] PR workflow의 비용 게이트 제거
- [x] main/nightly full matrix workflow 추가
- [x] 같은 ref의 이전 실행을 `concurrency`로 취소
- [x] 문서 PR·코드 PR·main/nightly 책임 분리
- [x] Godot import는 완료를 기다리는 `--import` 사용

## 공통 자동 검증

### 문서 전용 PR

```text
Ubuntu
Python 3.12
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py
```

- [x] run #195 PASS
- [x] Godot·Windows·전체 Python matrix 미실행
- [x] 실패할 때만 artifact 업로드
- [x] artifact 7일 보존

### 코드·데이터·Scene PR

```text
Ubuntu 1개 job
python -m unittest tests/test_core_mvp_001_data_contract.py tests/test_core_mvp_001_static_contract.py
godot --headless --path . --import
bash tests/run_core_mvp_001_tests.sh
bash tests/run_godot_regression.sh
```

- [x] Python과 Godot를 한 Ubuntu job에서 순차 실행
- [x] Python 데이터·정적 계약 PASS
- [x] Godot 4.7.1 import PASS
- [x] 집중 테스트 `4/4` PASS
- [x] 전체 Godot 회귀 `43/43` PASS
- [x] 실패할 때만 로그 artifact 업로드
- [x] 실행하지 못한 항목을 통과로 보고하지 않음

### main·nightly

- [x] Ubuntu·Windows × Python 3.11·3.12·3.13 matrix 정의
- [x] Godot 전체 회귀는 Ubuntu에서 1회만 실행
- [x] `push: main`, 수동 실행, 03:20 KST nightly 정의
- [x] PR workflow와 trigger 책임 분리
- [ ] main 병합 뒤 최초 full matrix 실제 실행 확인

## 보호 경계

- [x] `scripts/core/game_state.gd` 미변경
- [x] 기존 `data/episodes/**` 미변경
- [x] 기존 `scripts/scenes/investigation_scene.gd` 미변경
- [x] 기존 `scripts/scenes/battle_scene.gd` 미변경
- [x] `project.godot` 미변경
- [x] `knowledge/base-pack/**` 미변경
- [x] 저장 `mvp-039`와 `mvp-038` 이관 유지
- [x] PoC가 기존 GameState·캠페인 저장을 읽거나 쓰지 않음
- [x] 테스트가 기존 사용자 저장을 복구함

## CORE-MVP-001 데이터 계약

- [x] `contract_version == core-mvp-001-v1`
- [x] 조사 장면 3, 단서 6, 매뉴얼 3, 선택지 4, 가설 2, 패턴 3, 행동 8
- [x] 모든 전용 ID가 `poc001_`로 시작하고 중복 없음
- [x] 통합 명세의 고정 ID와 정확히 일치
- [x] `reaction_clue_id`, `resolves_question_id`, `refresh_hypothesis_id` 포함 모든 참조 존재
- [x] 회수 순서 5턴, 미관측 패턴이 3·5턴에 출현
- [x] 포획 표식 3개, 최소 포획 5턴, 최대 회수 8턴
- [x] 미관측 패턴 1개, 범용 완화 행동, 최초 피해 상한 18
- [x] `enemy_hp` 계약 없음

## 조사·가설 카드

- [x] 선택지 4개와 관련 기록 3개 표시
- [x] 올바른 기록 연결로 정확히 두 선택지 배제
- [x] 잘못된 연결은 체력·위험·단계 변화 없음
- [x] 배제 이유 표시
- [x] 남은 두 가설을 플레이어가 직접 선택
- [x] 지지·반박·미해결 근거 직접 연결
- [x] 무관하거나 확보하지 않은 근거 제출 거부
- [x] 잘못된 가설은 반응 단서·피해·위험 사례를 남김
- [x] 실패 뒤 기존 가설 1개 + 변형 가설 1개 유지
- [x] 같은 위험 사례 반복은 `attempts` 증가

## 이해도·미해결 질문

- [x] `unknown → clue → likely → understood` 단계만 사용
- [x] 가설 제출과 이해도 승격은 결정론적
- [x] 필수 지지·반박이 갖춰져야 `likely`
- [x] 결정적 현장 검증이 핵심 `resolves_question_id` 기록
- [x] 필수 질문이 해소돼야 `understood`
- [x] 해소된 질문은 unresolved 목록에서 제거
- [x] resolved 질문은 별도 목록으로 보존
- [x] 전조 확률은 관측한 패턴의 정보 공개만 결정
- [x] 전조 실패는 `놈은 무언가 하려 한다.`
- [x] 거짓 행동명·대상·범위·조건 제공 금지

## 회수 전투

- [x] 실제 패턴을 해석 전에 고정
- [x] `understood`에서 관측 패턴 확정 해석
- [x] 미관측 패턴 첫 발동 정보 비공개
- [x] 첫 발동에 범용 대응 유효
- [x] 최초 관측 피해 상한 18, 체력 최저 1
- [x] 첫 발동 뒤 패턴 관측 목록 등록
- [x] 두 번째 발동에서 이해도 해석 적용
- [x] 포획 표식을 중복 없이 축적
- [x] 정상 포획 창은 표식 3개와 5턴 이상에서 개방
- [x] 위험·체력·최대 턴 임계에서 긴급 포획 가능
- [x] 승리 조건에 적 HP 0 없음

## 결과·괴이 매뉴얼

- [x] 회수 품질·피해 관리·지식 품질 분리
- [x] 정상·비용·긴급 포획 결과 구분
- [x] 검증 요건 미달 시 매뉴얼 `candidate`
- [x] 올바른 가설·근거·질문 해소·현장 검증·포획 완료 시 `verified`
- [x] 위험 사례와 관측 패턴 보존
- [x] `RESULT_COMPARE → MANUAL_PROMOTION → COMPLETE`
- [x] 반영 검토와 기록 확정 분리

## 플레이테스트 로그

- [x] `poc_started` 세션당 1회
- [x] 필수 이벤트 이름 정렬
- [x] sequence 연속 증가
- [x] payload deep copy
- [x] JSONL 한 줄 한 객체
- [x] 기존 save path 참조 없음
- [x] 로그 내보내기 성공·실패 문구

## 단계별 UI·접근성

- [x] `PhaseHost` 아래 현재 단계 패널만 표시
- [x] Investigation·Hypothesis·FieldTest·Recovery·Result 패널 존재
- [x] 각 패널 내부 별도 `ScrollContainer`
- [x] Footer와 단계 스크롤 분리
- [x] 이전 단계 검토 읽기 전용
- [x] 뒤로보기 뒤 선택한 근거·가설 유지
- [x] Esc가 상태를 되감지 않고 이전 단계 검토 실행
- [x] 단계 전환·뒤로보기 뒤 버튼 포커스 복구
- [x] 전조·성공·위험을 텍스트로 전달
- [x] 시간 제한 없음
- [x] 1280×720·1920×1080에서 핵심 패널·Footer·버튼 viewport 내 유지
- [x] 기존 접근성 설정 비침범
- [x] F1 개발 패널 전용 PoC 진입 버튼
- [ ] 한국어 장문 줄바꿈·시각적 밀도에 대한 사람 눈 QA

## 현행 회귀 계약

- [x] 기존 39개 회귀 통과
- [x] 신규 4개 포함 전체 runner 43개 통과
- [x] 세 사건 진입·보고서·DB 회귀 없음
- [x] 권나래·서포트·일정·HQ·의뢰·미니게임 회귀 없음
- [x] 기존 후보·공식 규칙·위험 사례 보존
- [x] 아카·요원·장비·자동행동이 핵심 정답을 대체하지 않음

## 선택적 플레이 연구

다음은 `POC_BUILD_READY` 필수 조건이 아니며, 별도 플레이 검증 승인 뒤 사용한다.

- [ ] 규칙·대응 이유 설명
- [ ] 근거 기반 배제
- [ ] 조사-회수 인과 체감
- [ ] 난수 불공정 인식
- [ ] 매뉴얼 저작감
- [ ] 미관측 패턴 무대응 인식

플레이 증거가 없으므로 현재 판정은 `POC_BUILD_READY`이며 `POC_PASSED`가 아니다.

## 문서·참조 최신성

- [x] CURRENT_STATUS·CURRENT_HANDOFF·MVP_ROADMAP·TEST_CHECKLIST 정합
- [x] 구현 PR #57과 Issue #56 상태 갱신 대상 확인
- [x] CI 운영 문서가 재활성화·concurrency·full matrix를 소유
- [x] 실행되지 않은 검증을 완료로 기록하지 않음
- [x] 새 책임 문서 링크와 경로 유효

## 완료 보고

- 판정: `POC_BUILD_READY`
- 자동 검증: run #195, run #69 PASS
- 플레이 검증: 미실행
- 잔여 위험: 사람 눈 UI 밀도 검토, 플레이 이해도 검증
- 다음 단계: PR #57 리뷰·병합 결정 또는 수정
