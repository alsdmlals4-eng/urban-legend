# D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION — Legacy 병렬 보존·Validation 복귀 권위

> 상태: `APPROVED_PLANNING_BASELINE`
> 승인일: `2026-08-01 09:15 KST`
> 승인 근거: 사용자 `A~G 권장안 승인`
> 추적: Issue #121 / Draft PR #122
> 상위 패키지: `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE`
> 지원 초안: `docs/planning/VALIDATION_SAVE_TEST_MIGRATION_DRAFT_2026-08-01.md`
> 구현 권한: `NONE`
> Save Schema 변경: `NOT_AUTHORIZED`
> Runtime / Automated Migration / Human QA: `NOT_RUN`
> Codex: `HOLD`

## 1. 결정 질문

현재 `mvp-039` 저장을 파괴하지 않으면서 Validation의 8개 상황·전문 절차·결과 4축을 정확히 복구하고 중복 피해·보상·보고서 적용을 막으려면 어떤 저장·테스트 권위를 사용할 것인가?

## 2. 승인 결론

- 기존 `mvp-039` 저장은 `LEGACY`로 보존한다.
- 기존 저장을 Validation 형식으로 강제 변환하지 않는다.
- Validation 저장은 장면 경로보다 플레이 단계와 체크포인트를 우선한다.
- 전문 절차는 복귀 화면·복귀 노드를 명시적으로 저장한다.
- 원시 결과 축과 안정 ID를 저장해 중복 적용을 차단한다.
- Legacy 회귀와 Validation 신규 회귀를 병렬 유지한다.

## 3. 캠페인 모드

최소 구분:

```text
campaign_mode = LEGACY_MVP039
campaign_mode = VALIDATION_001
```

`campaign_mode`가 없으면 Legacy로 해석한다. 기존 저장을 무통보 삭제하거나 자동으로 Validation으로 승격하지 않는다.

## 4. 이어하기 권위

Validation 이어하기는 다음 우선순위를 사용한다.

```text
campaign_mode
→ flow_stage
→ checkpoint_id
→ return_screen_id / return_node_id
→ current_scene_path fallback
```

### 역할

- `campaign_mode`: Legacy와 Validation 구분
- `flow_stage`: SIT-001~008 중 현재 진행 책임
- `checkpoint_id`: 단계 내부 안전 복구 지점
- `return_screen_id`: 전문 절차 종료 뒤 복귀할 기준 화면
- `return_node_id`: 텍스트 노벨 장면·노드 복귀 위치
- `current_scene_path`: Legacy·호환 fallback

Scene 경로만으로 전문 절차 내부 상태를 추측하지 않는다.

## 5. 승인 flow stage

```text
MAIN
COLD_OPEN
BRIEFING
LIMITED_PREPARATION
TEXT_INVESTIGATION
HYPOTHESIS
TIMELINE_EVIDENCE
ROUTE_RESTORE
RECOVERY_PATTERN_01
RECOVERY_PATTERN_02
RESULT_REPORT
VALIDATION_COMPLETE
```

`VALIDATION_COMPLETE`는 별도 화면이 아니라 SCREEN-04 완료 처리 상태다. 완료 확인 뒤 SCREEN-01 메인으로 복귀한다.

## 6. 체크포인트

안전 체크포인트를 다음 시점에 생성한다.

1. 새 Validation 시작 직후
2. 콜드 오픈 완료
3. 브리핑 완료
4. 축약 준비 확정
5. 핵심 조사 장면 완료
6. 가설 최종 제출
7. 시간순 증거 확정
8. 최소 안전 노선 확정
9. 회수 패턴 1 결과 확정
10. 회수 패턴 2 결과 확정
11. 결과 원시 축 생성
12. 보고서·환류 적용 완료

Hover, 임시 선택, 열려 있던 Drawer, 포커스 위치는 필수 저장 대상이 아니다.

## 7. 전문 절차 저장

공통 저장 대상:

```yaml
specialist_flow_id:
return_screen_id:
return_node_id:
checkpoint_id:
selection_state:
validation_state:
applied_effect_ids: []
```

### 가설

- 연결한 기록·단서
- 제출한 가설
- `VERIFIED / UNRESOLVED / CONTRADICTED`
- 수정·재제출 횟수

### 시간순 증거

- 배치된 사건 ID
- 확정 순서
- 충돌 상태
- 검증된 시간순 관계

### 노선 복원

- 배치한 노선 조각
- 최소 안전 노선 확인 여부
- 실패·재시도 횟수
- 철수 여부

### 회수

- 현재 패턴 ID
- 분류
- 연결 기록
- 행동
- 현장 성공
- 추론 검증
- 복구 사용 여부
- 위험 사례

## 8. 중복 적용 방지

다음은 안정 ID를 사용한다.

- 피해·피로 변화
- 관계 변화
- 잔향·재화·보상
- 연구 질문 후보
- 보급 후보
- 회수 패턴 완료
- 피해자 상태 변화
- 사건 보고서
- 괴이 매뉴얼 규칙·위험 사례

규칙:

```text
이미 applied_effect_ids에 존재
→ 효과 재적용 금지
→ 화면 표시만 복원
```

패턴·지원 결과를 재추첨하지 않는다.

## 9. 결과 저장

원시 축을 권위로 저장한다.

```yaml
result_axes:
  field_stabilization:
  victim_rescue:
  rule_verification:
  core_recovery:
summary_grade:
summary_grade_reason_ids: []
```

원시 축과 요약 등급이 충돌하면 원시 축으로 등급을 재계산한다. 요약 등급만 저장한 뒤 원시 축을 역산하지 않는다.

## 10. 손상·호환 처리

### 복구 가능

- 임시 UI 상태 누락
- 마지막 Scene 경로 불일치
- Drawer·Popover 상태 누락
- 요약 등급 재계산 가능

처리:

- 마지막 안전 체크포인트로 복귀
- 손실된 임시 UI만 초기화
- 복구 이유를 사용자에게 표시

### 호환 불가

- 필수 원시 축 손실
- 체크포인트와 적용 효과 ID의 중대한 충돌
- 사건 ID·핵심 노드 ID 미존재

처리:

- 저장 자동 삭제 금지
- 백업 유지
- 오류 설명
- Legacy 복귀 또는 새 Validation 시작 선택

## 11. Legacy 보호

Legacy `mvp-039`에서 유지:

- 기존 Scene 경로 중심 이어하기
- 기존 반일 준비
- 회수 4패턴
- 기존 단일 결과 등급
- 기존 보고서·해금·시장·일상·세력 상태

Validation 구현 때문에 Legacy 테스트 기대값을 임의로 변경하지 않는다.

## 12. 테스트 계층

### 정적 계약

- 승인 Decision·Spec·Sheet ID 일치
- 7개 기준 화면·4개 전문 절차·8개 SIT 일치
- 비노출 기능 무부작용 계약 존재
- 제품 보호 경로 미변경 확인

### 자동 저장 회귀

각 체크포인트에서:

```text
상태 생성
→ 저장
→ 프로세스 재시작
→ 불러오기
→ stage/checkpoint/return target 비교
→ 적용 효과 중복 여부 비교
```

### Legacy 회귀

- `mvp-039` 저장 이어하기
- 기존 보고서·해금·편성 보존
- 회수 4패턴 Legacy 경로 보존
- 저장 자동 변환·삭제 없음

### Validation 회귀

- SIT-001~008 복귀
- 가설 재제출 상태
- 노선 재시도·철수
- 회수 패턴당 복구 1회
- 결과 4축·등급 재계산
- 완료 후 메인 복귀

### Runtime·사람 검증

아직 실행하지 않는다. 구현 계획과 제품 변경 승인 이후 수행한다.

## 13. STOP 조건

다음 중 하나면 구현을 중단하고 계약을 재검토한다.

- Legacy 저장 무통보 삭제
- 저장 로드만으로 피해·보상 재적용
- 최소 안전 노선 없이 회수 진입
- 전문 절차가 다른 텍스트 노드로 복귀
- 원시 축 손실
- 비노출 기능의 난수·로그·자원 변경
- Validation 완료 후 별도 8번째 화면 생성

## 14. 승인 상태

```yaml
decision_id: D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION
approval_state: APPROVED_PLANNING_BASELINE
approved_at: 2026-08-01T09:15:00+09:00
legacy_save: PRESERVE
forced_conversion: PROHIBITED
validation_resume_authority: FLOW_STAGE_FIRST
save_schema_change: NOT_AUTHORIZED
implementation_authority: NONE
runtime: NOT_RUN
automated_migration_test: NOT_RUN
human_validation: NOT_RUN
codex: HOLD
```

## 15. 다음 Gate

```text
비주얼 보드 제작
→ 플레이테스트 패키지
→ 사용자 기획 최종 승인
→ 상위 정본 단일 Canon Pass
→ writing-plans
→ 저장 Schema 변경안 별도 검수
→ 마지막에 Codex Goal
```
