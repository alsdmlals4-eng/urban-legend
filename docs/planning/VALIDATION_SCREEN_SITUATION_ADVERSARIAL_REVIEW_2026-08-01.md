# 괴이기록국 Validation SCREEN·SIT 적대적 검토 — 2026-08-01

> Review ID: `R-2026-08-01-VALIDATION-SCREEN-SIT-ADVERSARIAL`
> 상태: `PASS_FOR_USER_REVIEW / NOT_BUILD_READY`
> 검토 대상:
> - `SPEC-2026-08-01-VALIDATION-SCREEN-SIT`
> - `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS REV-2`
> - `D-2026-08-01-VALIDATION-RESULT-AXES`
> - `DRAFT-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION`
> 기준 main: `656846865eb88871d00842a0da527ce1b0722b77`
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> Runtime / Human QA: `NOT_RUN`

## 1. 공격 질문

다음 실패를 가정하고 초안을 검토했다.

1. 7개 기준 화면이 전문 화면 추가로 다시 비대해진다.
2. CURRENT와 APPROVED·DRAFT가 섞여 구현자가 잘못된 권위를 따른다.
3. 회수 행동 문구가 정답을 설명한다.
4. 가설·노선 실패가 소프트락을 만든다.
5. 저장 재진입으로 피해·보상·보고서가 중복 적용된다.
6. 숨긴 시스템이 백그라운드에서 난수·상태를 변경한다.
7. 결과 4축이 체크리스트형 숨은 총점으로 퇴행한다.
8. SCREEN-05~07이 Validation에 다시 전면 노출된다.
9. 사용자가 중요하지 않은 부분을 반복 선택하게 된다.
10. 기존 Legacy 테스트 통과를 새 기획 구현 완료로 오인한다.

## 2. 발견 및 보정

| Finding | 심각도 | 공격 결과 | 보정 계약 | 상태 |
|---|---:|---|---|---|
| F-SIT-001 | P1 | `flow_stage`가 일부 문장에서 승인 목표처럼 보임 | `flow_stage`는 저장 마이그레이션 `RECOMMENDED_DRAFT`; 사용자 승인 전 권위 없음 | RESOLVED_FOR_REVIEW |
| F-SIT-002 | P1 | 가설·시간순·노선·회수를 별도 기준 화면으로 세면 7종 계약 충돌 | 전문 절차는 SCREEN-02에서 호출되는 Specialist Flow; 기준 화면 수는 7개 유지 | RESOLVED_FOR_REVIEW |
| F-SIT-003 | P1 | 잘못된 가설 제출 뒤 진행 규칙 누락 | 1회 이상 관계 수정·재제출 가능; 최종 미검증·반박 상태로도 진행 가능하되 결과 등급 상한 적용 | RESOLVED_FOR_REVIEW |
| F-SIT-004 | P1 | 노선 복원 실패 후 회수 강행 가능 | 최소 안전 노선 확인 전 회수 진입 금지; 재시도 또는 `미해결` 결과로 종료 | RESOLVED_FOR_REVIEW |
| F-SIT-005 | P1 | 회수 오대응이 영구 소프트락 또는 무한 재시도로 갈 수 있음 | 패턴당 첫 오대응 후 복구 1회; 두 번째 실패는 위험 사례로 확정하고 다음 패턴 또는 결과로 진행 | RESOLVED_FOR_REVIEW |
| F-SIT-006 | P1 | Validation 종료용 8번째 화면 생성 위험 | SCREEN-04 내부에서 완료 처리하고 메인으로 복귀; 별도 완료 화면 없음 | RESOLVED_FOR_REVIEW |
| F-SIT-007 | P1 | 비노출 기능이 UI만 숨고 난수·로그를 계속 실행할 수 있음 | 비노출 기능은 판정·난수·로그·자원·관계·위험·저장 변경 전부 금지 | RESOLVED_FOR_REVIEW |
| F-SIT-008 | P1 | Scene 경로만 복원하면 전문 절차가 잘못된 노드로 돌아감 | Validation에서는 `flow_stage → checkpoint → return target → scene fallback` 순서 권장 | RESOLVED_FOR_REVIEW |
| F-SIT-009 | P1 | 원시 결과 없이 요약 등급만 저장할 위험 | 네 원시 축이 권위; 요약 등급 충돌 시 재계산 | RESOLVED_FOR_REVIEW |
| F-SIT-010 | P1 | 결과 후 연구·보급 화면을 강제해 Validation 범위가 팽창 | 연구 질문 1개·보급 후보 1개만 SCREEN-04에 표시; 전체 화면 강제 진입 없음 | RESOLVED_FOR_REVIEW |
| F-SIT-011 | P2 | 올바른 회수 행동 문구가 여전히 안전해 보일 수 있음 | 행동 라벨만 보는 집단과 기록을 읽는 집단의 정답률 분리 측정 | HUMAN_TEST_REQUIRED |
| F-SIT-012 | P2 | 네 결과 축이 첫 화면을 과밀하게 만들 수 있음 | 상태명+한 문장 이유만 우선; 상세는 접기 | VISUAL_TEST_REQUIRED |
| F-SIT-013 | P2 | 임시 안정화 상한이 성공 보상을 박탈하는 느낌을 줄 수 있음 | 현장 성공은 축에서 명확히 인정하고, 상한 이유를 `원인 미검증`으로 설명 | HUMAN_TEST_REQUIRED |
| F-SIT-014 | P2 | 다일 활동 중 강제 출동 규칙이 복잡해질 수 있음 | 날짜 경계 중단·완료 일수 보존·남은 날짜 재배치만 사용; 반일 분할 금지 | USER_REVIEW_REQUIRED |
| F-SIT-015 | P2 | Legacy와 Validation 이어하기가 메인에서 혼동될 수 있음 | 이어하기에 `기존 진행` 또는 `Validation 기록` 상태 표시 | VISUAL_TEST_REQUIRED |

## 3. 보정된 Specialist Flow 계약

기준 화면은 7개를 유지한다.

```text
SCREEN-02 텍스트 노벨 조사
  ├─ FLOW-HYPOTHESIS 사건 가설
  ├─ FLOW-TIMELINE 시간순 증거
  ├─ FLOW-ROUTE 안전 노선 복원
  └─ FLOW-RECOVERY 회수 2패턴
```

전문 절차는 독립 Scene으로 구현될 수 있지만 제품 정보구조상 별도 기준 화면으로 세지 않는다.

각 절차는 `return_screen_id`와 `return_node_id`를 명시한다.

## 4. 보정된 실패·복구 흐름

### 가설·시간순 증거

```text
제출
→ 관계 충돌 피드백
→ 수정·재제출 가능
→ 최종 제출
→ VERIFIED / UNRESOLVED / CONTRADICTED 저장
```

정답을 강제 공개하지 않는다. 플레이어는 미해결 상태로도 다음 안전 규칙 검증을 진행할 수 있지만 완전 해결은 불가능하다.

### 노선 복원

```text
복원 실패
→ 근거 위치·조작 오류 피드백
→ 재시도
또는
→ 현장 철수·미해결 결과
```

최소 안전 노선 없이 회수에 진입하지 않는다.

### 회수 패턴

```text
첫 오대응
→ 피해·위험 사례
→ 복구 1회

두 번째 실패
→ 위험 사례 확정
→ 다음 패턴 또는 결과
```

영구 이탈·강제 즉사·전체 사건 초기화는 사용하지 않는다.

## 5. 권장 기본 편성

Validation의 추천 편성은 기존 저승역 핵심 팀을 재사용한다.

- 고정 주인공: 권나래
- 추천 동료: 오현, 강이준

플레이어는 동료를 조정할 수 있지만 추천 편성을 그대로 사용해도 핵심 기록·가설·회수에 접근할 수 있어야 한다.

편성은 피해 완화·기록 비교 편의·재시도를 보조하며 정답을 제공하지 않는다.

## 6. SCREEN-02 최소 HUD 권장안

상단 고정 정보는 네 개만 둔다.

1. 사건명
2. 현재 장소
3. 기록
4. 설정

팀 상태는 작은 버튼 또는 필요 시 Popover로 연다.

상시 제외:

- 단서 수집률
- 회수 가능 퍼센트
- 자동 예측률
- 정답 후보 제거 표시
- 전체 장비·관계·시장 자원

## 7. 결과 등급 공격 결과

### 유지

- 미해결
- 임시 안정화
- 제한적 해결
- 완전 해결

### 핵심 상한

- 규칙 `UNRESOLVED` 또는 `CONTRADICTED` → 최대 `임시 안정화`
- 현장 안정화 `FAILED` → `미해결`
- 제한적 해결은 잔향 회수 실패를 허용
- 완전 해결은 네 축 최고 상태 요구

이 규칙은 숨은 점수보다 설명 가능성이 높고, 현장 행동 성공과 인과 검증을 분리한다.

## 8. 일정 충돌 공격 결과

권장 규칙:

- 실행 전 미래 일정은 수정 가능
- 완료한 날짜는 고정
- 다일 활동 진행 중 강제 출동은 다음 날짜 경계에서 일시 중단
- 완료 일수 보존
- 출동 후 남은 일수 재배치
- 하루를 오전·오후로 다시 분할하지 않음

이는 기존 반일 준비 계약을 되살리지 않으면서 강제 출동과 다일 활동을 연결하는 최소 규칙이다.

## 9. 과설계 제거

다음은 이번 기획에서 결정하지 않는다.

- 세부 피로 회복 수치
- 장비 가격표
- 연구 자원 수치
- 모든 연구 노드 목록
- 모든 보급 품목 목록
- 일상 활동 종류
- 전체 관계 이벤트 규칙
- 화면별 최종 픽셀 좌표
- 최종 애니메이션 길이

이 항목들은 현재 Validation 판단과 전환을 검증하는 데 필요하지 않다.

## 10. 구현 보호

현재 단계에서 변경하지 않는다.

- `scripts/**`
- `scenes/**`
- `data/**`
- `assets/**`
- `project.godot`
- Save Schema
- 기존 ID
- Base Adapter·Skill·Router
- Codex Goal

## 11. 검토 판정

| 영역 | 판정 |
|---|---|
| 기준 화면 7종 책임 | PASS_FOR_USER_REVIEW |
| 텍스트 노벨 일반 플레이 | PASS_FOR_USER_REVIEW |
| SIT-001~008 전환 | PASS_WITH_NORMATIVE_CORRECTIONS |
| 회수 2패턴 문구 | PASS_FOR_USER_REVIEW / HUMAN_RISK_OPEN |
| 결과 4축·등급 상한 | PASS_FOR_USER_REVIEW |
| 저장·복귀 권위 | PASS_FOR_USER_REVIEW |
| Legacy 병렬 보존 | PASS |
| Validation 범위 보호 | PASS |
| 비주얼 판독성 | NOT_RUN |
| Godot Runtime | NOT_RUN |
| 사람 플레이 | NOT_RUN |
| Build Readiness | BLOCKED |

## 12. 사용자 승인 패키지 권장안

다음 일곱 항목을 한 패키지로 검수하는 것이 적절하다.

### A. 화면·전문 절차

- 기준 화면은 7개 유지
- 가설·시간순·노선·회수는 SCREEN-02 전문 절차

### B. 텍스트 노벨 최소 HUD

- 사건명 / 장소 / 기록 / 설정
- 팀 상태는 Popover

### C. 추천 편성

- 권나래 고정
- 오현·강이준 추천

### D. 실패·복구

- 가설 수정·재제출
- 노선 재시도 또는 미해결 철수
- 회수 패턴당 복구 1회

### E. 결과

- 네 원시 축
- 4단계 요약 등급
- 규칙 미검증·반박 시 임시 안정화 상한

### F. 저장

- Validation은 `flow_stage` 우선
- 기존 mvp-039는 Legacy 유지
- 전문 절차 return target 저장

### G. 종료·장기 일정

- Validation은 SCREEN-04에서 완료 후 메인 복귀
- 다일 활동 강제 출동 시 날짜 경계 중단·진행 보존

## 13. 다음 Gate

```text
사용자 A~G 검수
→ 승인 Decision·Sheet 동기화
→ SCREEN-01~07 비주얼 보드 A/B
→ SIT 상황 보드 C1~C4
→ 이미지 중간점검
→ 플레이테스트 패키지 최종 적대적 검토
→ 사용자 기획 최종 승인
```

현재는 `PASS_FOR_USER_REVIEW`이며 `NOT_BUILD_READY`다.
