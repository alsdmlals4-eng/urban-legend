# Package 1 기획 승인

> Decision ID: `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL`
> 승인 시각: 2026-08-02 10:59 KST
> 상태: `CURRENT_APPROVED_PLANNING_ONLY`
> Parent Decision: `D-2026-08-02-BASE-V94-CANON-RECONCILIATION`
> Proposal: `P-2026-08-02-VALIDATION-CHANGE-PROPOSAL`
> 제품 구현 권한: `NONE`
> 병합 권한: `NOT_REQUESTED`

## 1. 사용자 승인 원문

```text
Package 1 승인. 그리고 적대적 검토루프로 충돌,누락,보완할 쪽이 있는지 찾아봐.
우리는 기획 작성부터 진행할거야 상세 데이터 수치 부분은 네 권장안대로 진행할거고
중요기획,기획 충돌 부분은 내게 grillme로 질문해
```

## 2. 승인 해석

최신 사용자 지시에 따라 이번 `Package 1 승인`은 다음 범위의 **기획·명세 작성 승인**이다.

- Package 1 Session·Save isolation의 제품·기술 기획 작성
- 상태·저장·복귀·손상·호환성·롤백 계약 설계
- 실제 `main`과 승인 Target을 대조한 적대적 검토
- 검증된 오류·누락의 안전한 기획 보완
- 구현 전에 필요한 핵심 Decision만 Grill Me로 질문
- 상세 수치·기술 기본값은 GPT 권장안을 `RECOMMENDED_DEFAULT` 또는 `TEST_VALUE`로 기록

다음은 승인되지 않았다.

- GDScript·Scene·JSON·Schema·Workflow 구현
- Codex Build Goal 실행
- Package 2 이상 구현
- PR #125 병합
- Runtime·Human·POC 통과 선언

이 판정은 이전 문서의 `Package 1 implementation approval pending` 문구보다 최신 사용자 지시를 우선한다.

## 3. 기획 운영 계약

```text
현재 정본·실제 구현 복원
→ 보존 강점 고정
→ Package 1 기획 Coverage 감사
→ attack
→ validate-critique
→ AUTO_FIX_ELIGIBLE 안전 보완
→ USER_DECISION_REQUIRED만 Grill Me
→ 승인된 설계 작성
→ 사용자 Spec 검토
→ writing-plans
→ 별도 구현 승인
```

### 3.1 GPT가 권장안으로 확정할 항목

프로젝트 방향을 바꾸지 않는 다음 항목은 반복 질문하지 않는다.

- 저장 버전 문자열·필드명·상태 enum의 초기안
- 원자적 저장·임시 파일·백업·손상 격리의 안전 기본값
- snapshot whitelist의 기술적 구조
- 오류 코드·로그·테스트 fixture
- timeout·재시도·보관 개수 등 시험 수치
- 테스트 순서와 경계값

모든 초기 수치는 `RECOMMENDED_DEFAULT` 또는 `TEST_VALUE`로 표시하고 실행 증거 뒤 조정한다.

### 3.2 Grill Me가 필요한 항목

다음은 한 번에 하나씩 질문한다.

- Validation 기록과 본편 진행의 영속 관계
- 저장 UX가 플레이어에게 약속하는 의미
- 기존 승인 정본을 대체하는 범위
- 서로 다른 유효한 제품 경험안 사이의 선택
- 실패·복구·보상 의미를 바꾸는 선택

저장소·Sheet·실제 구현에서 확인 가능한 사실, 기술 세부, 시험 수치는 묻지 않는다.

## 4. Package 1 기획 범위

### 포함

- `ValidationSession` 책임과 비책임
- 별도 Validation save namespace
- Legacy file·memory no-effect 계약
- session lifecycle과 save lifecycle 분리
- stage·checkpoint·return/focus 저장 계약
- runtime snapshot whitelist와 제외 목록
- corrupt·recoverable·incompatible 판정
- save version·migration·orphan metadata 계약
- explicit activation과 fail-closed routing
- 테스트 oracle·rollback·관찰 가능한 수용 기준

### 제외

- 메인 메뉴 최종 레이아웃과 시각 디자인
- 축약 준비·Reasoning·결과 화면 상세 구현
- 저승역 콘텐츠 문구·가설·노선·회수 수치 변경
- Legacy campaign·economy·relationship 설계 변경
- 장기 제품 저장 슬롯 시스템

## 5. 보호 강점

- Legacy `mvp-039` 저장과 `mvp-038` 이관 지원
- CORE·MVP-043·ANNUAL 정상 경로와 49-entry regression
- 별도 Validation save와 무통보 삭제 금지
- `flow_stage → checkpoint → return_target → scene fallback` 복귀 우선순위
- 기존 dialogue/investigation/minigame/battle 전문 절차 재사용 방향
- 결과 원시 4축과 apply-once 원칙
- Validation에서 캠페인·경제·관계·시장·의뢰 무부작용

## 6. 완료 기준

Package 1 기획은 다음이 모두 닫혀야 완료다.

1. 중요 제품 Decision이 Grill Me로 확정됨
2. 상태·저장 소유권이 한 질문당 하나의 책임 원본을 가짐
3. Legacy 파일뿐 아니라 숨은 메모리 상태의 무변경 계약이 있음
4. 손상·중단·버전 불일치·삭제·재진입 실패 경로가 정의됨
5. 수용 기준·RED 테스트·롤백이 실제 최신 파일과 테스트명에 연결됨
6. GitHub 정본·PR #125·Google Sheet가 같은 Decision ID로 재조회됨
7. 구현 권한은 별도 승인 전까지 `NOT_AUTHORIZED`로 유지됨

## 7. 다음 Gate

```text
Package 1 기획 적대적 감사
→ 첫 Grill Me Decision
→ Package 1 Design Spec 작성·self-review
→ 사용자 Spec 승인
→ writing-plans 구현 계획
→ 별도 Package 1 구현 승인
```
