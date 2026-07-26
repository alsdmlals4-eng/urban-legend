# ANNUAL-MVP-002 자동 검증 기록 — 2026-07-26

> 추적: Issue #88 / PR #89 / review Issue #90 / PR #91  
> 상태: `MERGED / AUTOMATED_QA_PASSED / REVIEW_HARDENING`  
> 제품 판정: `POC_PASSED NOT_DECLARED`

## 검증 대상

- `annual-mvp-002-v1` 확장 데이터
- 일정 미리보기·지난주 복사·템플릿 3개·전체 초기화·한 단계 undo
- 동료 3명 중 최대 2명 편성
- 고유 스킬 데이터 3개와 공용 지원 데이터 6개
- 고유 스킬 런타임: 오현·박도윤 2개 `ACTIVE`, 한세린 `교차 색인` 1개 `DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK`
- 공용 지원 런타임: 피해·위험 계열 2개 `ACTIVE`, 나머지 4개 `DISABLED_PENDING_CORE_HOOK`
- 적격 여부·확률·준비도·보장 발동 공개
- 장비 3개와 계열 호환 모듈 6개
- 연구 자원 4종과 연구 노드 8개
- `annual-mvp-001-save-v1` 선택 확장 블록과 구 저장 fallback
- 주간 인과 요약
- 기존 CORE-MVP-001 hook과 안전 fallback

## 문서 검증

- workflow: `Validate documentation contracts`
- run: #333
- 결과: PASS
- 확인 범위:
  - archive governance
  - Base·Skill·active reference
  - ANNUAL-MVP-001 문서 계약
  - 프로젝트 문서 동기화
  - 확장 기획 기준선
  - 유사 장르 벤치마크 계약

## 코드·데이터·회귀 검증

- workflow: `Validate ANNUAL-MVP-001`
- run: #167
- 결과: PASS
- 단계:
  1. Python ANNUAL-MVP-001·002 데이터 계약 PASS
  2. Godot 4.7.1 import PASS
  3. CORE-MVP-001 focused PASS
  4. ANNUAL-MVP-001 focused PASS
  5. ANNUAL-MVP-002 focused PASS
  6. 전체 Godot 회귀 PASS

ANNUAL-MVP-002 focused entrypoints:

- planner
- state·save·orphan
- support resolver
- incident adapter·fallback
- isolated Scene

## 시각·입력 검증

- workflow: `Capture ANNUAL-MVP-001 Visual QA`
- run: #55
- 결과: PASS
- artifact: `8625300008`

확인한 입력 경로:

1. 실제 화면 좌표로 7일 일정 편성
2. 마지막 변경 취소
3. 템플릿 1 저장
4. 전체 초기화
5. 템플릿 1 적용
6. 1주차 결과 확인
7. 주차 전환 뒤 같은 템플릿 재적용
8. 2주차 조기 출동
9. 실제 화면 좌표로 동료 2명 선택
10. 지원 확률·준비도 표시 확인
11. 사건 시작과 embedded CORE 선택지 클릭

기존 ANNUAL-MVP-001 키보드·Esc·그래픽 포인터 경로도 같은 run에서 PASS했다.

## 캡처 직접 검사

검사 해상도:

- 1280×720
- 1920×1080

화면 상태:

- 빈 일정 계획
- 7일 일정 결과 미리보기
- 주간 인과 요약
- 동료·장비·지원 준비

검사 결과:

- 한글 글리프 누락 없음
- 겹친 텍스트 없음
- 핵심 버튼·상태 정보 잘림 없음
- 주간 인과 요약 전체 가독성 확인
- 준비 화면의 동료 3명·장비·모듈·지원 상태 가독성 확인
- 720p 계획 화면의 긴 템플릿 영역은 ScrollContainer로 접근 가능

## 수정 과정에서 확인한 결함

### 문서 선행 참조

구현 계획이 아직 생성되지 않은 미래 QA 파일을 참조해 문서 거버넌스가 실패했다. 미래 증거 파일 참조를 제거하고 실제 검증 뒤 이 기록을 생성했다.

### Planner 템플릿 수명주기

주차 확정 후 planner 재구성 과정에서 템플릿이 초기화되는 결함이 포인터 QA에서 발견됐다. 주차 전환 시 현재 계획과 undo만 초기화하고 템플릿 3개는 유지하도록 수정했으며 focused·포인터 회귀를 추가했다.

### 포인터 스크롤

ScrollContainer 밖에 있는 버튼을 화면 좌표로 클릭하던 QA 결함을 수정했다. 클릭 전에 대상 컨트롤을 화면 안으로 이동시키고 실제 mouse motion·press·release를 전송한다.

### 한세린 `교차 색인` 런타임 경계

현재 CORE snapshot과 외부 지원 hook에는 관측 기록 충돌 강조를 안전하게 적용할 관측·가설 보드가 없다. 따라서 데이터는 보존하되 `DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK`으로 두고 resolver 입력, 판정, 성공 로그에서 제외한다. 준비 화면에는 비활성 사유를 표시하며, 향후 관측·가설·반박 보드 구현 시 별도 검토 후 활성화한다.

## 보호 범위 확인

변경하지 않은 항목:

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `project.godot`
- `knowledge/base-pack/**`
- 본편 save `mvp-039`, `mvp-038`
- ANNUAL save version `annual-mvp-001-save-v1`
- 기존 CORE 사건 원본·가설·패턴·필수 회수 조건

## 미실행 게이트

```text
human_usability_qa: NOT_RUN
new_player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
POC_PASSED: NOT_DECLARED
production_expansion: NOT_APPROVED
ANNUAL-MVP-003: NOT_APPROVED
```

자동 검증 통과는 동료 선택의 재미, 정보량, 장기 반복 피로, 신규 플레이어의 지원 확률 이해를 증명하지 않는다.
