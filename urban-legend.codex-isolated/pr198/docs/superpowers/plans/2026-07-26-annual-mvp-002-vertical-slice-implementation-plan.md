# ANNUAL-MVP-002 수직절편 구현 계획

> 상태: `EXECUTED / MERGED / REVIEW_HARDENING`  
> 추적: Issue #88 / PR #89 / review Issue #90 / PR #91  
> 실행 방법: 각 작업은 실패 테스트 확인 → 최소 구현 → 기존 회귀 확인 순서로 수행한다.

## 목표

기존 ANNUAL-MVP-001의 4주×7일 경로를 유지하면서 다음 수직절편을 격리 구현한다.

- 동료 3명 중 최대 2명 편성
- 고유 스킬 3개와 공용 지원 6개
- 장비 3개와 호환 모듈 6개
- 연구 자원 4종과 연구 노드 8개
- 일정 결과 미리보기
- 지난주 복사, 템플릿 3개, 전체 초기화, 마지막 변경 실행 취소
- 지원 적격 여부·확률·준비도·보장 발동 공개
- 주간 선택과 결과를 연결하는 인과 요약

## 변경하지 않는 계약

- 권나래 고정 주인공
- 1개월 = 4주 × 주당 7일 = 28일
- 일정별 1~3일 소비와 주차 경계 초과 금지
- 미사용 일수 경고 후 자동 휴식
- 2주차 위험 0 / 3주차 위험 15 / 4주차 강제 위험 30
- `annual-mvp-001-save-v1`
- 본편 `mvp-039`과 `mvp-038` 이관
- CORE 핵심 단서·정답 가설·미관측 패턴·필수 회수 조건
- 확장 실패 시 기존 ANNUAL-MVP-001과 CORE 기본 동작

신규 수치는 `PROVISIONAL_BASELINE`이며 사람 검증 전 `POC_PASSED`와 제작 확대를 선언하지 않는다.

## 이번 범위에서 분리하는 항목

- 사건 징후 시계
- 관측·가설·반박 보드
- 연구·괴이 매뉴얼 전체 탐색 화면
- ANNUAL-MVP-003 분기 콘텐츠

이 항목들은 별도 Issue와 구현 계획으로 관리한다.

## 아키텍처

확장 코드는 기존 구현에 직접 혼합하지 않고 다음 경로에 둔다.

- `data/poc/annual_mvp_002/`
- `scripts/poc/annual_mvp_002/`
- `scenes/poc/annual_mvp_002/`

`AnnualMvp002State`는 `AnnualMvp001StateV2`를 상속한다. 기존 7일 계획, 출동 위험, 사건 진입과 저장 흐름은 부모 구현을 사용하고 동료·장비·연구·템플릿 상태만 선택 필드로 확장한다.

기존 themed Scene에는 상태와 adapter를 만드는 factory hook만 추가한다. ANNUAL-MVP-001은 기존 factory 기본값을 계속 사용하고 ANNUAL-MVP-002 Scene만 확장 State와 adapter를 주입한다.

## 작업 1 — 확장 데이터 계약

### 파일

- `data/poc/annual_mvp_002/companion_equipment_research.json`
- `scripts/poc/annual_mvp_002/annual_mvp_002_data.gd`
- `tests/test_annual_mvp_002_data_contract.py`

### 계약

- contract: `annual-mvp-002-v1`
- base contract: `annual-mvp-001-v3`
- 동료 3, 고유 스킬 3, 공용 지원 6
- 장비 3, 모듈 6
- 연구 자원 4, 연구 노드 8
- 모든 신규 ID는 `annual002_` namespace 사용
- 기존 `annual001_` ID와 충돌 금지
- 모듈은 한 장비 계열에만 속함
- 연구 선행 그래프 순환 금지
- 연구 비용 음수 금지
- 정답·신규 단서·미관측 패턴·필수 회수 조건 필드 금지

### 검증

1. 데이터 파일이 없는 상태에서 Python 계약 실패를 확인한다.
2. JSON과 GDScript validator를 작성한다.
3. 새 계약과 기존 ANNUAL 데이터 계약을 함께 통과시킨다.
4. Godot import에서 validator parser 오류가 없는지 확인한다.

## 작업 2 — 일정 미리보기와 반복 편성 도구

### 파일

- `scripts/poc/annual_mvp_002/annual_mvp_002_planner.gd`
- `tests/annual_mvp_002_planner_test.gd`

### 공개 함수

```gdscript
configure(activities: Array[Dictionary], days_per_week: int = 7)
set_plan(activity_ids: Array[String])
append_activity(activity_id: String)
undo()
clear()
copy_last_week(last_week_result: Dictionary)
save_template(slot: int)
apply_template(slot: int)
preview()
restore(snapshot: Dictionary)
```

### 불변성

- 7일을 초과하는 변경은 상태를 바꾸지 않고 거부한다.
- 지난주 복사는 표시용 `activity_ids`가 아니라 정본 `planned_activity_ids`를 사용한다.
- 템플릿 슬롯은 정확히 3개다.
- 현재 데이터에서 사라진 활동이 포함된 복사·템플릿은 적용하지 않는다.
- undo는 직전 편성 변경 한 단계만 복구한다.
- preview는 사용 일수, 남은 일수, 피로, 역량, 기관 지원, 연구 진척, 신뢰 변화를 합산한다.

## 작업 3 — 확장 State와 저장

### 파일

- `scripts/poc/annual_mvp_002/annual_mvp_002_state.gd`
- `tests/annual_mvp_002_state_test.gd`

### 상태 블록

```text
annual_mvp_002
  enabled
  companion_states
  equipped_support_skills
  readiness_by_skill
  owned_equipment
  installed_modules
  research_resources
  research_projects
  completed_research
  last_loadout
  schedule_templates
  orphaned_ids
```

### 동료·장비 규칙

- 동료 0~2명 편성 가능
- 세 번째 동료 선택은 변경 없이 거부
- 같은 주 역할 중복 시 두 번째 동일 계열 효과 70%
- 공용 지원은 해당 동료의 허용 목록에 있어야 함
- 주 장비 1개
- 기본 모듈 슬롯 1개, 연구 후 2개
- 같은 모듈 중복 및 장비 계열 불일치 금지

### 연구 규칙

- 동시에 진행 가능한 연구 최대 2개
- 시작 시 자원을 예약
- 완료 시 예약 자원을 소비
- 취소 시 예약량의 75%를 내림 반환
- 선행 노드가 완료되지 않으면 시작 불가
- 사건 결과에 따라 관측 기록·잔향 자료·위험 사례·기관 협력 점수를 지급

### 저장 호환

- save version은 변경하지 않는다.
- 구 저장에 확장 블록이 없으면 기본값을 생성한다.
- 알 수 없는 ID는 `orphaned_ids`에 보존하고 효과 계산에서는 제외한다.
- 다음 저장에서도 알려진 ID와 orphaned ID를 모두 보존한다.

## 작업 4 — 지원 resolver

### 파일

- `scripts/poc/annual_mvp_002/annual_mvp_002_support_resolver.gd`
- `tests/annual_mvp_002_support_resolver_test.gd`

### 확률 계약

```text
최종 일반 확률
= 기본 확률
+ 관련 일정 준비 보정 10%p
+ 업무 신뢰 보정 0/5/10%p
```

- 업무 신뢰 40 이상: +5%p
- 업무 신뢰 70 이상: +10%p
- 일반 확률 상한 90%
- 준비도는 일반 확률에 직접 더하지 않음
- 적격 실패 시 준비도 +20
- 실패 학습 연구 완료 시 +25
- 준비도 100이면 다음 적격 상황 보장 발동
- 성공 후 준비도 0
- 고유 스킬은 명시 조건 충족 시 사건당 1회 확정 발동
- 동일 seed와 event key는 같은 결과를 반환
- 같은 event key 재호출은 중복 적용하지 않음

### 투명성 출력

각 지원 항목은 다음을 공개한다.

- 적격 여부
- 비적격 사유
- 현재 확률
- 현재 준비도
- 보장 발동까지 남은 준비도
- 효과 범주
- 남은 사용 횟수
- 신규 핵심 단서·정답 가설·미관측 패턴·필수 회수 조건을 제공하지 않는다는 제한

## 작업 5 — 사건 adapter와 fallback

### 파일

- `scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd`
- `tests/annual_mvp_002_incident_adapter_test.gd`

### 규칙

- CORE 스크립트와 사건 원본을 직접 수정하지 않는다.
- 기존 hook 범위에서 피해·위험·입력 허용 오차·표시 시간·회수 창·연구 보상만 조정한다.
- 두 동료의 고유·공용 지원을 resolver에 전달한다.
- 동일 역할 중복 효율 70%를 적용한다.
- 확장 데이터 또는 hook 실패 시 기본 사건 결과를 유지한다.
- 생성 override와 support log에는 정답 필드를 넣지 않는다.

## 작업 6 — Scene과 벤치마크 P0 UI

### 파일

- `scripts/poc/annual_mvp_001/annual_mvp_001_themed_scene.gd`
- `scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd`
- `scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn`
- `tests/annual_mvp_002_scene_test.gd`
- `scripts/ui/main_menu.gd`

### 일정 화면

- 활동 버튼에 소요일 표시
- 선택 전후의 총 사용 일수와 남은 일수 표시
- 피로·역량·기관·연구·신뢰 예상 변화 표시
- 지난주 복사
- 마지막 변경 실행 취소
- 전체 초기화
- 템플릿 1~3 저장·적용
- 기존 자동 휴식 2단계 경고 유지

### 편성 화면

- 동료 카드 3개
- 최대 2명 선택
- 고유 스킬 조건
- 장착 공용 지원의 적격·확률·준비도·보장 거리
- 주 장비와 호환 모듈
- 같은 역할 중복 경고
- 동료 미편성·빈 모듈 슬롯은 경고 후 진행 가능
- 계열 불일치는 선택 불가

### 주간 인과 요약

다음 세 부분을 표시한다.

```text
무엇이 변했는가
왜 변했는가
다음 주와 사건 준비에 어떤 의미가 있는가
```

직접 휴식과 자동 휴식의 차이를 명시하고, 각 수치 변화는 원인 활동과 소요일에 연결한다.

## 작업 7 — focused·시각·입력 검증

### 파일

- `tests/run_annual_mvp_002_tests.sh`
- `tests/annual_mvp_002_visual_capture.gd`
- `tests/annual_mvp_002_pointer_qa.gd`
- `.github/workflows/validate-annual-mvp-001.yml`
- `.github/workflows/capture-annual-mvp-001-visuals.yml`

### 자동 검증 순서

1. Python 데이터·문서 계약
2. Godot 4.7.1 import
3. CORE focused
4. ANNUAL-MVP-001 focused
5. ANNUAL-MVP-002 focused
6. 전체 Godot 회귀
7. 720p·1080p 캡처
8. 키보드·Esc 경로
9. 실제 그래픽 좌표 포인터 경로

포인터 경로는 7일 편성, undo, 템플릿 저장·적용, W2 출동, 동료 2명 편성, 장비·모듈 선택, 지원 정보 확인, 사건 시작까지 수행한다.

워크플로 권한은 `contents: read`를 유지한다.

## 작업 8 — 정본 동기화와 병합

### 갱신 원본

- ANNUAL-MVP-002 상세 설계
- `MVP_ROADMAP.md`
- `docs/CURRENT_STATUS.md`
- `docs/CURRENT_HANDOFF.md`
- `TEST_CHECKLIST.md`
- `docs/DECISION_LOG.md`

### 기록 항목

- Issue #88와 PR #89
- 실제 변경 범위와 제외 범위
- 데이터 contract와 save 호환
- 문서·ANNUAL·시각 검증 run
- changed-file 감사와 review thread 수
- 병합 커밋
- 사람 사용성·신규 플레이어 검증 미실행 상태

브랜치 상태는 검증 중임을 명확히 기록하고, 병합 후에만 `MERGED / AUTOMATED_QA_PASSED`로 바꾼다.

## 완료 조건

### 자동 완료

- 확장 데이터 계약 PASS
- Godot import PASS
- CORE·ANNUAL-MVP-001·ANNUAL-MVP-002 focused PASS
- 전체 Godot 회귀 PASS
- 720p·1080p와 입력 QA PASS
- 보호 경로 변경 없음
- review thread 0
- 정본·상태·결정 로그 동기화

### 제품 판정

자동 완료와 별개로 다음은 실제 사람이 수행해야 한다.

- 동료별 장점을 설명할 수 있는지
- 지원 확률과 준비도·보장 발동을 이해하는지
- 장비가 사건 정답을 제공한다고 오인하지 않는지
- 연구 보상이 사건 결과와 연결된다고 느끼는지
- 편성 화면의 정보량과 반복 조작 피로가 허용 가능한지

사람 검증 전 상태:

```text
human_usability_qa: NOT_RUN
new_player_validation: NOT_RUN
POC_PASSED: NOT_DECLARED
production_expansion: NOT_APPROVED
ANNUAL-MVP-003: NOT_APPROVED
```
