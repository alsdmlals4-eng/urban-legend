# ANNUAL 벤치마크 개선 후보

> 추적: Issue #86  
> 근거: `docs/research/2026-07-26-genre-benchmark.md`  
> 상태: `RECOMMENDED_FOR_REVIEW`  
> 기존 승인 설계 변경: 없음  
> 구현 승인: 없음

## 1. 판정 요약

현재 `4주 × 7일` 구조와 시스템 우선 확장 순서는 유지한다.

벤치마크 결과, 구조를 바꾸기보다 다음 결손을 보강하는 편이 우선이다.

1. 일정 선택 전 결과 비교 정보
2. 사건 마감과 지연 결과의 가시성
3. 관측과 추론을 분리하는 작업 공간
4. 주간 선택→결과 인과 설명
5. 장기 캠페인의 반복 입력 축소
6. 동료 지원 확률·준비도의 투명성
7. 연구와 괴이 매뉴얼의 실제 문제 해결 연결

## 2. P0 — ANNUAL-MVP-002 구현 계획에 함께 검토

| ID | 후보 | 상태 | 구현 범위 |
|---|---|---|---|
| BENCH-P0-001 | 일정 결과 미리보기 | `RECOMMENDED_FOR_REVIEW` | 소요일, 효과 범주, 피로, 관계·연구 영향, 남은 일수 |
| BENCH-P0-002 | 사건 징후 시계 | `RECOMMENDED_FOR_REVIEW` | 잠복/가시화/확산/긴급, 다음 위험 시점, 지연 손실 범주 |
| BENCH-P0-003 | 관측·가설·반박 보드 | `RECOMMENDED_FOR_REVIEW` | 관측, 가설, 지지, 반박, 미해결, 검증, 공식 규칙 |
| BENCH-P0-004 | 주간 인과 요약 | `RECOMMENDED_FOR_REVIEW` | 변화, 원인 일정, 사건 의미, 다음 주 해금·잠금 |
| BENCH-P0-005 | 반복 편성 도구 | `RECOMMENDED_FOR_REVIEW` | 지난주 복사, 템플릿 3개, 초기화, 실행 취소, 충돌 강조 |
| BENCH-P0-006 | 동료 지원 투명성 | `RECOMMENDED_FOR_REVIEW` | 적격 여부, 확률, 준비도, 보장 발동, 비적격 이유 |
| BENCH-P0-007 | 연구·매뉴얼 상호 링크 | `RECOMMENDED_FOR_REVIEW` | 사건 기록↔연구 노드↔장비·스킬 이동 |

### P0 보호 조건

- 핵심 단서와 정답은 공개하지 않는다.
- 동료는 신규 핵심 단서·정답 가설·미관측 패턴을 제공하지 않는다.
- 진행 시계는 정보 표현이며 기존 위험 0/15/30을 대체하지 않는다.
- 템플릿은 현재 주의 유효성 검사를 다시 수행한다.
- 주간 요약은 실제 발생 원인만 표시하고 숨은 미래 분기를 노출하지 않는다.

## 3. P1 — ANNUAL-MVP-003 1분기 검증 후보

| ID | 후보 | 상태 |
|---|---|---|
| BENCH-P1-001 | 활성 진행 시계 최대 3개 | `CONDITIONAL` |
| BENCH-P1-002 | 사건 완료 후 경로도 | `CONDITIONAL` |
| BENCH-P1-003 | 사건 규모별 가설 보드 복잡도 | `CONDITIONAL` |
| BENCH-P1-004 | 분기 일정 환경 변화 1개 | `CONDITIONAL` |
| BENCH-P1-005 | 기관 요청·관계 마감 충돌 | `CONDITIONAL` |
| BENCH-P1-006 | 실패 시 위험 사례 자동 생성 | `CONDITIONAL` |

## 4. P2 — 연간 구조 이후 후보

- 공식 규칙·위험 사례·동료 기억의 다음 연도 계승
- 다중 관점 사건
- 자유 입력식 최종 추론
- 분기 경로도 비교
- 장기 관계·사건 진행 시계

상태는 모두 `DEFERRED`다.

## 5. 명시적 제외

| ID | 제외 요소 | 이유 |
|---|---|---|
| BENCH-X-001 | 핵심 단서 무작위 출현 | 추리 공정성 훼손 |
| BENCH-X-002 | 사건 실패 시 전체 초기화 | 장기 육성 기록 훼손 |
| BENCH-X-003 | 행동 성패의 주사위 중심화 | 계획보다 운이 중심이 됨 |
| BENCH-X-004 | 반복 선물·방문 중심 관계 | 장기 조작 피로 증가 |
| BENCH-X-005 | 회차 기억만으로 필수 정답 해금 | 최초 플레이 공정성 훼손 |
| BENCH-X-006 | 숨은 임계치 즉사 | 원인 학습과 실패 전진 부족 |
| BENCH-X-007 | 동료의 자동 정답 제공 | 권나래의 추론 주체성 훼손 |

## 6. 구현 계획 반영 방식

ANNUAL-MVP-002 구현 계획 작성 시 P0을 한 번에 모두 구현하지 않는다.

권장 분할:

1. 편성 정보·반복 UX: P0-001, P0-005
2. 동료 지원 정보: P0-006
3. 주간 결과 설명: P0-004
4. 사건 정보 구조: P0-002, P0-003
5. 연구·매뉴얼 연결: P0-007

각 묶음은 독립 테스트와 화면 QA를 가져야 한다.

## 7. 사람 검증 기준

- 일정 선택 전 비용·효과 범주 설명 성공률
- 사건 지연 결과 예측 성공률
- 관측과 추측 구분 성공률
- 가설 충돌 수정 성공률
- 동료 지원 공정성 평가
- 편성 완료 시간과 되돌리기 사용 횟수
- 주간 인과 설명 성공률
- 매뉴얼 실제 참조 횟수

## 8. 현재 판정

```text
benchmark_research: COMPLETE
current_structure: KEEP
p0_recommendations: READY_FOR_USER_REVIEW
p1_recommendations: CONDITIONAL
p2_recommendations: DEFERRED
excluded_patterns: RECORDED
implementation_approval: NOT_GRANTED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
