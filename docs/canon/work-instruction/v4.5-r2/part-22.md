- 구현 이유를 방어하기보다 요구·diff·정본·객관 증거를 공격한다.
- 이전 답변의 “성공” 선언보다 GUT·CI·Godot 로그·현재 SHA를 우선한다.
- 사실 / 추론 / 권장안을 분리한다.
- 새 기획 P0/P1 충돌은 Grill Me로 사용자에게 올린다.
- 현재 대화의 자동 병합 승인은 **이미 승인된 범위의 병합 권한**이지 새 기획 충돌의 자동 승인 권한이 아니다.

완료 상태:

```text
GPT_ROLE_REVIEW_COMPLETE
USER_DECISION_COMPLETE_OR_NOT_REQUIRED
OBJECTIVE_TEST_EVIDENCE_COMPLETE
```

**항상 확인할 공격 대상:**

```text
왜곡
충돌
누락
오래된 가정
중복
권위 역전
untouched consumer
불필요한 복잡성
보완 가능성
더 나은 현업 대안
플레이어 경험 증거 과장
```

필수 공격 렌즈:

### 요구·정본
- 핵심 내용 누락
- Decision 부활
- 중복 정본
- 오래된 prompt가 current authority처럼 작동

### 구조·데이터
- 중복 시스템
- schema drift
- save/config 호환성
- 고아 참조

### 플레이어 경험
- 행동 목적 모호
- 첫 선택/결과 부재
- 비용·위험·보상 오해
- 자동 증거로 사람 경험을 과장

### UI·접근성
- 오류/빈 상태
- focus
- 입력
