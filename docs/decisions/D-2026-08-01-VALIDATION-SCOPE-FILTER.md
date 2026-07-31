# D-2026-08-01-VALIDATION-SCOPE-FILTER — Validation 비핵심 기능 비노출

> 상태: `APPROVED_PLANNING_BASELINE`
> 승인일: 2026-08-01
> 사용자 승인: “권장안대로 진행”
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> Runtime / Human QA: `NOT_RUN`

## 1. 결정

Validation Cut은 35~50분 안에 사건 코어와 최소 환류를 검증한다.

기존 기능을 삭제하지 않되, 핵심 경험을 방해하는 비핵심 시스템은 Validation 제품 경로에서 숨기거나 비활성화한다.

## 2. Validation 전면 노출

```text
무인 메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비 1회
→ 텍스트 노벨 조사
→ 사건 원인 가설 보드
→ 시간순 증거 비교
→ 안전 노선 복원
→ 회수 2패턴
→ 결과 4축·보고서
→ 사후 정산·다음 준비 영향
```

### 축약 준비에서 허용

- 권나래 고정
- 동료 최대 2명 선택 또는 추천 편성 확인
- 장비·지원의 제한된 선택 1회
- 조사 우선순위 확인
- 현재 사건 위험과 준비 영향의 짧은 미리보기

## 3. Validation에서 비노출

- 랜덤 이벤트
- 세력 의뢰 게시판
- 소문시장
- 반복 구매·판매
- 일상 에피소드 목록
- 전체 4주 운영 화면
- 복잡한 관계 단계·확률·준비도 상세
- 다수 자동 행동 로그
- 런타임 UI 편집 기능
- 회수 패턴 3·4
- 전체 연구 트리와 전체 조달 카탈로그

비노출은 삭제를 의미하지 않는다.

## 4. 비활성 시스템의 상태 규칙

Validation에서 숨긴 시스템은 다음을 지킨다.

- 자동 판정을 실행하지 않는다.
- 난수를 소비하지 않는다.
- 성공·실패 로그를 만들지 않는다.
- 자원·관계·위험·저장 상태를 변경하지 않는다.
- 필수 기록·가설·회수 조건을 소유하지 않는다.
- 저장 데이터에 기존 값이 있어도 Validation 결과 계산에는 사용하지 않는다.

기존 저장과 데이터는 호환을 위해 보존할 수 있다.

## 5. 동료·장비 경계

동료와 장비는 Validation에서 존재하되 정답을 대신하지 않는다.

허용:

- 피해 완화
- 기록 위치 안내
- 이미 확보한 기록의 비교 편의
- 입력 허용 오차 보정
- 다음 기회 생성

금지:

- 가설 후보 자동 제거
- 정답 분류·행동 추천
- 신규 핵심 단서 생성
- 미니게임 자동 완료
- 원인 미검증 상태를 완전 해결로 승격

## 6. 연구·조달의 Validation 표현

Validation 종료 뒤 전체 SCREEN-06·07을 강제하지 않는다.

결과 화면과 사후 정산에서 다음 최소 환류만 보여준다.

- 새 연구 질문 1개
- 연구 후보 1개
- 보급·모듈 후보 1개
- 다음 사건에서 달라질 수 있는 준비 효과 1개

전체 연구·조달 화면 검증은 Showcase 또는 후속 전용 Cut으로 분리한다.

## 7. 범위 복원 조건

숨긴 기능은 다음 조건을 충족한 뒤 단계적으로 복원한다.

1. Validation 사람 검증 완료
2. 핵심 흐름의 역할 이해·추리 공정성·결과 환류가 기준 충족
3. 추가 기능이 핵심 지표를 훼손하지 않는다는 별도 가설
4. 필요 시 Benchmark Gate
5. Showcase 범위 사용자 승인

## 8. Benchmark Gate

```yaml
validation_scope_filter: REUSED
basis:
  - Validation Cut approval
  - full project adversarial audit
  - progressive disclosure contracts
  - existing annual benchmark
implementation_authority: NONE
human_validation: NOT_RUN
```

## 9. 대체 관계

이 결정은 기존 기능의 삭제 결정이 아니다.

- 현재 본편 기능: `CURRENT_IMPLEMENTATION_LEGACY / PRESERVED`
- Validation 노출 범위: `APPROVED_TARGET`
- Showcase 복원 범위: `HOLD_UNTIL_VALIDATION`
