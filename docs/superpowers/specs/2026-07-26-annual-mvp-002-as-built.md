# ANNUAL-MVP-002 As-Built Specification

> 날짜: 2026-07-26  
> 추적: Issue #88 / PR #89 / review Issue #90 / PR #91  
> 상태: `MERGED / AUTOMATED_QA_PASSED / REVIEW_HARDENING`  
> 선행 설계: `2026-07-26-annual-mvp-002-companion-equipment-research-design.md`

## 1. 문서 역할

이 문서는 구현 전 상세 설계의 원문을 삭제하거나 소급 수정하지 않고, 실제 수직절편에 반영된 범위와 구현 과정에서 변경된 아키텍처를 기록한다.

다음 항목을 대체한다.

- 선행 설계 §15의 `NOT_WRITTEN / NOT_STARTED` 상태
- 초기 구현 계획의 기존 themed Scene factory hook 방식

선행 설계의 데이터·지원·장비·연구·save·사람 검증 계약은 계속 유효하다.

## 2. 실제 구현 상태

```text
annual_mvp_002_design: APPROVED_IMPLEMENTATION_BASELINE
annual_mvp_002_data: PROVISIONAL_BASELINE
a nnual_mvp_002_plan: WRITTEN_AND_EXECUTED
annual_mvp_002_implementation: MERGED
a nnual_mvp_002_automated_qa: PASSED
annual_mvp_002_merge: c790bf747c0fa4f4427d9e4b49b22adbfce92824
human_validation: NOT_RUN
new_player_validation: NOT_RUN
POC_PASSED: NOT_DECLARED
production_expansion: NOT_APPROVED
```

공백이 포함된 `a nnual` 표기는 상태 키가 아니다. 실제 상태 키는 다음과 같다.

```text
annual_mvp_002_plan: WRITTEN_AND_EXECUTED
annual_mvp_002_automated_qa: PASSED
```

## 3. 아키텍처 변경

### 초기 계획

기존 ANNUAL-MVP-001 themed Scene에 상태·adapter factory hook을 추가하고 확장 Scene이 이를 상속하는 방식을 검토했다.

### 실제 구현

기존 ANNUAL-MVP-001 Scene을 변경하지 않고 독립 격리 Scene을 추가했다.

```text
data/poc/annual_mvp_002/
scripts/poc/annual_mvp_002/
scenes/poc/annual_mvp_002/
```

구성:

- `AnnualMvp002Data`
- `AnnualMvp002Planner`
- `AnnualMvp002State`
- `AnnualMvp002SupportResolver`
- `AnnualMvp002IncidentAdapter`
- `AnnualMvp002Scene`

이 방식의 이유:

- 기존 7일 ANNUAL-MVP-001 Scene 회귀 위험 감소
- 확장 초기화 실패와 기본 fallback 분리
- 새로운 편성 UI의 정보량을 기존 PoC 화면과 분리
- 향후 삭제·비활성화가 쉬운 독립 실험 경계

## 4. 데이터 subset

전체 `PROVISIONAL_BASELINE` 중 실제 수직절편은 다음만 사용한다.

| 데이터 | 수량 |
|---|---:|
| 동료 | 3 |
| 최대 편성 | 2 |
| 고유 스킬 | 3 |
| 공용 지원 | 6 |
| 주 장비 | 3 |
| 모듈 | 6 |
| 연구 자원 | 4 |
| 연구 노드 | 8 |
| 동시 연구 | 2 |
| 일정 템플릿 | 3 |

contract:

```text
annual-mvp-002-v1
base: annual-mvp-001-v3
```

## 5. Planner as-built

지원 기능:

- 7일 초과 변경 불변성
- 일정 결과 미리보기
- 지난주 정본 `planned_activity_ids` 복사
- 템플릿 3개
- 주차 전환 뒤 템플릿 유지
- 전체 초기화
- 마지막 변경 한 단계 undo
- save·restore

템플릿 수명주기 결함이 실제 포인터 QA에서 발견됐으며, planner 재구성은 현재 계획과 undo만 초기화하고 템플릿은 보존하도록 수정됐다.

## 6. State·save as-built

`AnnualMvp002State`는 `AnnualMvp001StateV2`를 상속한다.

save version:

```text
annual-mvp-001-save-v1
```

추가 선택 필드:

```text
state.annual_mvp_002
```

호환:

- 구 저장: 기본 확장 상태 생성
- 알 수 없는 ID: `orphaned_ids`에 보존
- orphaned ID: 효과 계산 제외
- 알려진 ID와 orphaned ID: 다음 저장에서도 보존
- 확장 데이터 실패: base State 유지, 확장만 비활성화

## 7. 지원 resolver as-built

공용 지원 일반 확률:

```text
base_chance
+ preparation_bonus 10%p
+ work_trust_bonus 0/5/10%p
```

- 상한 90%
- 준비도는 일반 확률에 직접 가산하지 않음
- 적격 실패 +20
- 실패 학습 연구 완료 시 +25
- 준비도 100이면 다음 적격 발동 보장
- 성공 후 준비도 0
- 동일 seed·event key 재현
- 같은 event key 중복 적용 금지
- 고유 스킬은 조건 충족 시 사건당 1회 확정 발동

공개 정보:

- 적격 여부
- 비적격 사유
- 확률
- 준비도
- 보장 거리
- 효과 범주
- 정답 비대체 경계

## 8. CORE adapter as-built

기존 CORE 사건 데이터와 State를 직접 수정하지 않는다.

허용 범위:

- 피해 완화
- 위험 완화
- 관측·입력 표시 시간
- 허용 오차
- 회수 창
- 연구 보상

금지 범위:

- 신규 핵심 단서
- 정답 가설
- 미관측 패턴
- 필수 회수 조건

동일 현장 역할이 중복되면 두 번째 동료의 같은 계열 숫자 효과를 70%로 적용한다.

확장 snapshot·데이터·resolver가 없거나 실패하면 기존 ANNUAL-MVP-001 adapter와 CORE 기본 동작을 사용한다.

## 9. UI as-built

계획 화면:

- 활동별 소요일
- 사용·남은 일수
- 피로·역량·기관 예상 영향
- 지난주 복사
- undo
- 전체 초기화
- 템플릿 1~3 저장·적용

주간 결과:

```text
무엇이 변했는가
왜 변했는가
다음 주 영향
```

준비 화면:

- 동료 카드 3개
- 최대 2명 제한
- 장비·모듈 계열 검증
- 지원 적격·확률·준비도·보장 거리
- 동료·장비가 정답을 대신하지 않는다는 안내

## 10. 구현하지 않은 벤치마크 후보

별도 후속 범위:

- 사건 징후 시계
- 관측·가설·반박 보드
- 연구·괴이 매뉴얼 전체 탐색 UI
- ANNUAL-MVP-003 분기 콘텐츠

## 11. 검증 증거

- 문서 run #333 PASS
- ANNUAL run #167 PASS
  - Python 데이터 계약
  - Godot 4.7.1 import
  - CORE-MVP-001 focused
  - ANNUAL-MVP-001 focused
  - ANNUAL-MVP-002 focused
  - 전체 Godot 회귀
- Visual run #55 PASS
  - 기존 ANNUAL-MVP-001 키보드·포인터
  - ANNUAL-MVP-002 실제 좌표 포인터
  - 1280×720·1920×1080 캡처
- visual artifact `8625300008`
- 캡처 8장 직접 검사 PASS

## 12. 제품 판정 경계

자동 검증으로 확인하지 못한 항목:

- 동료별 장점의 체감
- 지원 정보량의 이해도
- 준비도·보장 발동의 공정성 인식
- 장기 반복 편성 피로
- 장비·동료의 정답 제공 오인 여부
- 사건 결과→연구 환류의 만족도

따라서 현재 상태는 다음을 유지한다.

```text
human_usability_qa: NOT_RUN
new_player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
POC_PASSED: NOT_DECLARED
production_expansion: NOT_APPROVED
ANNUAL-MVP-003: NOT_APPROVED
```
