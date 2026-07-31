# 괴이기록국 Validation 저장·테스트 마이그레이션 초안

> Draft ID: `DRAFT-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION`
> Review ID: `R-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION`
> 상태: `DRAFT_REQUIRES_USER_REVIEW`
> 기준 main 저장: `mvp-039`
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> Codex: `HOLD`
> Runtime / Human QA: `NOT_RUN`

## 1. 목적

기존 저장·회귀 테스트를 삭제하지 않고 다음 두 계약을 분리한다.

```text
LEGACY
= 현재 main의 기존 캠페인·Scene 경로·반일 준비·회수 4패턴

VALIDATION
= 승인 예정인 통합 흐름·전문 절차·회수 2패턴·결과 4축
```

이 문서는 Save Schema 구현안이 아니라 마이그레이션 시 반드시 보존해야 할 상태·복구·테스트 책임을 정의한다.

## 2. 현재 근거

현재 `GameState`는 다음을 저장·복구하는 기반을 가진다.

- `SAVE_VERSION = mvp-039`
- 현재 에피소드
- `current_scene_path`
- 현재 대화·현장 노드
- 선택 요원
- 플래그·힌트·미니게임 결과
- 조사·회수 상태
- 완료 보고서·괴이 매뉴얼
- 장비·시장·관계·캠페인 상태

현재 메인 이어하기는 `current_scene_path`를 읽고, 메인 경로면 대화 Scene으로 보정한다.

문제:

- 전문 절차가 늘면 Scene 경로만으로 의미 있는 진행 단계를 알기 어렵다.
- 모달·전환 중·미확정 선택 상태를 그대로 복원하면 중복 적용 위험이 있다.
- 기존 저장을 새 Validation 구조로 강제 변환하면 데이터 의미가 달라진다.

## 3. 권장 권위 순서

Validation 저장의 이어하기 권위는 다음 순서다.

1. `campaign_mode`
2. `flow_stage`
3. `checkpoint_id`
4. `current_screen_id`
5. `return_screen_id / return_node_id`
6. `current_scene_path` 호환 fallback

`current_scene_path`를 제거하지 않는다. Legacy 저장과 디버그·호환 경로에서 계속 사용한다.

## 4. 모드 분리

### legacy

- 기존 `mvp-039` 저장
- 기존 Scene 경로 기반 복귀
- 기존 반일 준비·시장·회수 4패턴·캠페인 상태 유지
- 신규 Validation 결과 계산에 자동 편입하지 않음

### validation

- 통합 흐름 전용 단계와 체크포인트 저장
- 숨긴 시스템 상태는 결과 계산에 사용하지 않음
- 회수 2패턴과 결과 4축 저장
- 전체 4주 운영·시장·일상·의뢰 상태 변경 금지

## 5. 권장 상위 상태

```yaml
save_version: future_version
campaign_mode: validation | legacy
flow_stage: main | cold_open | briefing | preparation | investigation | hypothesis | route_validation | recovery | result | validation_complete
checkpoint_id: string
current_screen_id: SCREEN-01 | SCREEN-02 | SCREEN-03 | SCREEN-04 | SCREEN-05 | SCREEN-06 | SCREEN-07
return_screen_id: optional
return_node_id: optional
current_scene_path: compatibility_fallback
validation_state:
  preparation_snapshot: {}
  investigation_progress: {}
  hypothesis_state: {}
  timeline_evidence_state: {}
  route_result: {}
  recovery_pattern_results: {}
  result_axes: {}
  post_result_candidates: {}
  applied_effect_ids: []
  orphaned_ids: []
```

필드명은 구현 계획에서 변경할 수 있지만 책임과 권위 순서는 유지한다.

## 6. 단계별 최소 복원 상태

### main

- 저장 존재 여부
- 모드·버전·호환 상태

### cold_open

- 콜드 오픈 시작·완료 여부
- 현재 텍스트 노드

### briefing

- 현재 브리핑 노드
- 등록된 조사 목표

### preparation

- 권나래 고정 상태
- 선택 동료
- 장비·지원
- 조사 우선순위
- 확정 여부

### investigation

- 현재 장소·텍스트 노드
- 확보한 필수·선택 기록
- 조사 선택 결과
- 이미 적용한 상태 변화 ID

### hypothesis

- 제거한 가설
- 증거의 지지·반박·미해결 연결
- 시간순 배열
- 제출 여부와 판정 상태

### route_validation

- 조작 중 상태 또는 마지막 안전 시점
- 확정 노선 결과
- 재시도 횟수
- 결과 적용 여부

### recovery

패턴별:

- 분류 선택
- 연결 기록
- 행동 선택
- 현장 결과
- 추론 검증
- 위험 사례
- 적용 완료 ID

### result

- 네 원시 결과 축
- 요약 등급
- 등급 이유 ID
- 매뉴얼 갱신
- 연구·보급 후보
- 보고서 저장 여부

### validation_complete

- 완료 보고서 ID
- 결과 확인 완료
- 메인 복귀 가능 상태

## 7. 안전 체크포인트

다음 시점에만 안정 체크포인트를 생성한다.

1. 새 Validation 상태 생성 직후
2. 콜드 오픈 종료
3. 브리핑 종료
4. 준비 확정
5. 필수 조사 기록 획득
6. 가설 제출 직전
7. 가설 제출 결과 확정
8. 노선 결과 확정
9. 각 회수 패턴 결과 확정
10. 결과 4축 생성
11. 사건 보고서 저장
12. Validation 완료 처리

전환 Fade 중간이나 버튼 입력 직후 결과 미확정 상태는 안전 체크포인트가 아니다.

## 8. 임시 UI 상태

기본적으로 저장하지 않는다.

- Hover
- Tooltip
- 포커스 링 위치
- 버튼 눌림 애니메이션
- 접히는 패널의 일시적 열림 상태
- 미확정 드래그 위치
- 화면 흔들림·섬광 진행률
- 전환 Fade 진행률

예외:

- 접근성 설정
- 사용자가 명시적으로 고정한 패널 설정

예외 여부는 기존 설정 저장 계약을 재사용한다.

## 9. 전문 절차 복귀

가설·시간순 증거·노선 복원·회수는 7개 기준 화면을 늘리는 새 메인 화면이 아니라 SCREEN-02에서 호출되는 전문 절차다.

복귀 시 반드시 저장한다.

```yaml
return_screen_id: SCREEN-02
return_node_id: specialist_exit_target
```

- 가설 종료 → 조사 결과 노드 또는 노선 복원 안내 노드
- 노선 종료 → 회수 진입 전 텍스트 노드
- 회수 종료 → SCREEN-04 결과 생성

Scene이 존재하더라도 Scene 자체가 복귀 위치를 추측하지 않는다.

## 10. 중복 적용 방지

모든 영속 효과는 안정된 ID를 가진다.

예:

- `briefing_goal_registered`
- `clue_timeline_phone_awarded`
- `route_result_applied`
- `recovery_pattern_1_damage_applied`
- `recovery_pattern_1_reward_applied`
- `result_report_recorded`
- `research_candidate_added`
- `provisioning_candidate_added`

복구 시 ID가 이미 존재하면 같은 효과를 다시 적용하지 않는다.

특히 다음은 중복 금지다.

- 피해
- 피로·정신력 변화
- 신뢰도 변화
- 잔향·보상
- 장비·연구 후보
- 보고서·매뉴얼 기록
- 회수 완료 상태

## 11. 난수 책임

Validation에서 비노출한 기능은 난수를 소비하지 않는다.

전문 절차가 난수를 사용하는 경우:

- 결과 확정 전 생성한 seed 또는 결과를 저장
- 재진입 때 재추첨 금지
- 동료 지원·위험 사례·보상 결과도 동일

첫 Validation의 핵심 추리 정답과 회수 행동 판정은 난수로 바꾸지 않는다.

## 12. Legacy 저장 호환

### 자동 판별

`campaign_mode`가 없고 저장 버전이 `mvp-039` 또는 기존 호환 버전이면 `legacy`로 판정한다.

### 복구

- 기존 `current_scene_path` 복귀 유지
- 기존 캠페인·시장·회수·보고서 상태 유지
- 새 Validation 단계로 자동 변환하지 않음
- 새 결과 4축을 기존 단일 등급에서 임의 추정하지 않음

### 사용자 표시

메인 이어하기에 `기존 진행` 표기를 표시할 수 있다.

기존 저장을 계속 진행하거나 새 Validation 기록을 시작하는 선택을 제공한다.

## 13. Validation 저장 호환

### 알 수 없는 ID

- 삭제하지 않고 `orphaned_ids`에 보존
- 표시 가능한 경우 `사용할 수 없는 과거 항목`으로 안내
- 효과 계산·Gate 판정에서 제외

### 부분 손상

복구 우선순위:

1. 원본 저장을 보존
2. 마지막 유효 체크포인트 탐색
3. 임시 UI 상태 폐기
4. 결과 중복 적용 방지
5. 복구 불가 사유 표시

자동 삭제·무통보 초기화 금지.

## 14. 원시 결과와 요약 등급 정합성

저장된 결과 축과 요약 등급이 충돌하면:

- 원시 결과 축을 권위로 사용
- 요약 등급을 재계산
- 보정 사실을 진단 로그에 기록
- 보상은 `applied_effect_ids`를 기준으로 중복 지급하지 않음

## 15. 테스트 계층

### A. Legacy 회귀

기존 테스트를 보존한다.

- 기존 main menu→dialogue 진입
- 기존 preparation 반일 일정
- 기존 조사·미니게임·회수
- 기존 회수 4패턴
- 기존 result→preparation
- 기존 market
- 기존 campaign·ANNUAL PoC
- 기존 `mvp-039` 저장 복귀

상태 라벨: `LEGACY_REGRESSION`

Legacy 테스트 통과는 Validation 목표 구현 완료를 의미하지 않는다.

### B. Validation 정적 계약

- SCREEN-01~04 Validation 순서
- SCREEN-05~07 비강제 노출
- SIT-001~008 연결
- 회수 2패턴만 활성
- 숨긴 기능 무부작용
- 결과 4축 필드
- flow stage와 checkpoint 계약

### C. Validation 상태 단위 테스트

- 새 상태 생성
- 준비 Snapshot
- 조사 기록 중복 획득 금지
- 가설 관계 저장·복구
- 시간순 증거 판정
- 노선 결과 재적용 금지
- 회수 패턴별 중복 피해·보상 금지
- 결과 등급 상한
- 연구·보급 후보 중복 등록 금지

### D. Scene 통합 테스트

- 메인→콜드 오픈
- 콜드 오픈→브리핑
- 브리핑→축약 준비
- 준비→조사
- 조사→전문 절차→정확한 복귀 노드
- 회수→결과
- 결과→메인
- 단계별 저장·이어하기

### E. 시각·접근성 테스트

- 1280×720
- 1920×1080
- 키보드 포커스 순서
- 색 외 상태 표시
- 긴 한국어 줄바꿈
- 선택지·결과 카드 잘림
- 모션·섬광 강도 설정

### F. 사람 Validation

- 첫 10분 역할 이해
- 전문 화면 전환 혼동
- 행동 성공·추론 검증 구분
- 네 결과 축 이해
- 다음 행동·환류 이해

## 16. 필수 신규 회귀 시나리오

| Test ID | 시나리오 | 기대 결과 |
|---|---|---|
| VAL-SAVE-001 | 콜드 오픈 종료 후 재시작 | 브리핑 시작 체크포인트 복귀 |
| VAL-SAVE-002 | 준비 확정 후 재시작 | 동일 편성·지원·우선순위 복원 |
| VAL-SAVE-003 | 가설 제출 직전 재시작 | 관계 편집 상태 복원, 제출 결과 미적용 |
| VAL-SAVE-004 | 가설 제출 직후 재시작 | 판정 재실행·보상 중복 없음 |
| VAL-SAVE-005 | 노선 결과 확정 후 재시작 | 같은 결과 복원, 재추첨 없음 |
| VAL-SAVE-006 | 회수 패턴 1 완료 후 재시작 | 패턴 1 재실행 금지, 패턴 2 진입 |
| VAL-SAVE-007 | 행동 성공·추론 반박 | 결과 축과 임시 안정화 상한 유지 |
| VAL-SAVE-008 | 결과 생성 후 재시작 | 네 축·등급·후보 중복 없이 복원 |
| VAL-SAVE-009 | mvp-039 저장 이어하기 | Legacy 경로 유지, 강제 변환 없음 |
| VAL-SAVE-010 | 알 수 없는 후보 ID 포함 | orphaned 보존, 판정 제외, 오류 설명 |

## 17. 중단 기준

다음 중 하나면 구현·병합을 중단한다.

- 숨긴 기능이 난수·로그·자원을 변경함
- 수집률만으로 회수 진입 가능
- 규칙 미검증 상태에서 완전 해결 부여
- 복귀가 다른 텍스트 노드·전문 절차로 이동
- 저장 재진입 때 패턴·보상·피해 재적용
- Legacy 저장이 무통보 삭제·변환됨
- 원시 결과 축 없이 요약 등급만 저장
- 1280×720에서 핵심 선택·결과가 잘림

## 18. 권장 구현 순서 — 승인 후에만 사용

```text
신규 계약 테스트 작성
→ Validation 상태 구조
→ Resume Router
→ 단계별 체크포인트
→ SCREEN/SIT 전환 연결
→ 회수 2패턴·결과 4축
→ Legacy 호환
→ 시각·접근성
→ 사람 Validation
```

이 순서는 구현 계획이 아니라 의존 관계 기준이다. 실제 파일·함수·TDD 작업은 사용자 최종 승인 뒤 `writing-plans`에서 작성한다.

## 19. 사용자 검수 대상

1. `flow_stage`를 Scene 경로보다 우선하는 권위
2. 기존 저장은 강제 변환하지 않고 Legacy로 유지
3. Validation 결과 뒤 메인으로 복귀
4. 전문 절차의 `return_screen_id / return_node_id`
5. 단계별 안전 체크포인트
6. 알 수 없는 ID를 orphaned로 보존
7. 원시 결과 축을 요약 등급보다 우선
8. Legacy 테스트와 Validation 테스트 병렬 유지

## 20. 승인 Gate

```text
사용자 저장·테스트 계약 승인
→ SCREEN·SIT·회수·결과와 같은 상태로 승격
→ 비주얼 보드 중간점검
→ 플레이테스트 패키지 적대적 검토
→ 기획 최종 승인
```

현재 상태는 `NOT_BUILD_READY`다.
