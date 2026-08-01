# D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE — Validation 화면·상황 A~G 승인

> 상태: `APPROVED_PLANNING_BASELINE`
> 승인일: `2026-08-01 09:15 KST`
> 승인 근거: 사용자 `A~G 권장안 승인`
> 추적: Issue #121 / Draft PR #122
> 기준 main: `656846865eb88871d00842a0da527ce1b0722b77`
> 연결 Spec: `SPEC-2026-08-01-VALIDATION-SCREEN-SIT`
> 적대적 검토: `R-2026-08-01-VALIDATION-SCREEN-SIT-ADVERSARIAL`
> Benchmark Gate: `REUSED / SCREEN-07 PASSED`
> 구현 권한: `NONE`
> Runtime / Visual / Human QA: `NOT_RUN`
> Codex: `HOLD`

## 1. 결정 질문

저승역 Validation Cut을 구현하기 전에 기준 화면 수, 텍스트 노벨 정보 위계, 추천 편성, 실패 복구, 결과, 저장 복귀, 종료·일정 충돌을 어떤 단일 권위로 고정할 것인가?

## 2. 승인 결론

다음 A~G 패키지를 제품 기획 기준선으로 승인한다.

### A. 기준 화면과 전문 절차

기준 화면은 7개다.

1. `SCREEN-01` 메인
2. `SCREEN-02` 텍스트 노벨 조사·일반 플레이
3. `SCREEN-03` 출동 직전 축약 준비
4. `SCREEN-04` 결과 4축·보고서·최소 환류
5. `SCREEN-05` 하루 단위 일정
6. `SCREEN-06` 연구
7. `SCREEN-07` 기록국 보급실

다음은 SCREEN-02 아래에서 호출되는 전문 절차다.

- `FLOW-HYPOTHESIS` 사건 가설
- `FLOW-TIMELINE` 시간순 증거
- `FLOW-ROUTE` 안전 노선 복원
- `FLOW-RECOVERY` 회수 2패턴

전문 절차는 구현상 독립 Scene일 수 있지만 제품 정보구조의 기준 화면 수에는 포함하지 않는다.

### B. 텍스트 노벨 최소 HUD

상단 고정 정보는 다음 네 개만 사용한다.

```text
사건명 | 현재 장소 | 기록 | 설정
```

팀 상태는 필요할 때 여는 Popover로 둔다.

상시 제외:

- 단서 수집률
- 회수 가능 퍼센트
- 자동 예측률
- 정답 후보 제거 표시
- 전체 장비·관계·시장 자원

일반 플레이 기본 흐름:

```text
배경·상황 제시
→ 서술·대사
→ 관찰·대화·행동 선택
→ 결과 문장
→ 기록·상태 변화
```

### C. Validation 추천 편성

- 고정 주인공: `권나래`
- 추천 동료: `오현`, `강이준`

추천 편성을 그대로 사용해도 핵심 기록·가설·회수에 접근할 수 있어야 한다.

동료·장비 허용 역할:

- 피해 완화
- 이미 획득한 기록 비교
- 입력 허용 오차
- 재대응 기회

금지:

- 핵심 단서 생성
- 가설 자동 제거
- 정답 행동 추천
- 잘못된 행동의 성공 처리

### D. 실패·복구

#### 가설

```text
제출
→ 충돌 근거 확인
→ 수정·재제출
→ VERIFIED / UNRESOLVED / CONTRADICTED 저장
```

미해결·반박 상태로도 진행할 수 있지만 결과 등급 상한을 적용한다.

#### 노선 복원

```text
실패
→ 근거 위치·조작 오류 피드백
→ 재시도
또는
→ 현장 철수·미해결 결과
```

최소 안전 노선 없이 회수에 진입할 수 없다.

#### 회수

```text
첫 오대응
→ 피해·위험 사례
→ 복구 1회

두 번째 실패
→ 위험 사례 확정
→ 다음 패턴 또는 결과
```

영구 이탈·즉사·전체 사건 초기화·소프트락은 사용하지 않는다.

### E. 결과

원시 결과 축은 네 개다.

1. 현장 안정화
2. 피해자 구조
3. 규칙 검증
4. 괴이 핵·잔향 회수

요약 등급은 네 단계다.

1. 미해결
2. 임시 안정화
3. 제한적 해결
4. 완전 해결

상한:

- 규칙 `UNRESOLVED` 또는 `CONTRADICTED` → 최대 `임시 안정화`
- 현장 안정화 `FAILED` → `미해결`
- 제한적 해결은 잔향 회수 실패를 허용
- 완전 해결은 네 축 최고 상태와 회수 2패턴의 행동·추론 검증 필요

원시 축이 계산 권위이며 요약 등급은 표시값이다.

Validation 최소 환류:

- 연구 질문: `개인화된 신호와 공식 식별 신호를 어떻게 분리할 것인가`
- 보급 후보: `폐주파수 필터`

전체 연구·보급 화면은 종료 직후 강제 진입하지 않는다.

### F. 저장·복귀

기존 `mvp-039` 저장은 Legacy로 보존하며 강제 변환하지 않는다.

Validation 이어하기 권장 우선순위:

```text
campaign_mode
→ flow_stage
→ checkpoint_id
→ return_screen_id / return_node_id
→ current_scene_path fallback
```

중복 적용을 차단할 안정 ID 대상:

- 피해·피로
- 관계 변화
- 잔향·보상
- 연구·보급 후보
- 회수 패턴 완료
- 사건 보고서·괴이 매뉴얼

원시 결과 축과 요약 등급이 충돌하면 원시 축을 기준으로 등급을 재계산한다.

### G. 종료와 장기 일정 충돌

Validation은 별도 8번째 완료 화면을 만들지 않는다.

```text
SCREEN-04 결과 확인
→ 보고서 저장
→ 최소 환류 확인
→ 완료 처리
→ SCREEN-01 메인 복귀
```

다일 활동 중 강제 출동:

- 다음 날짜 경계에서 일시 중단
- 완료 일수 보존
- 출동 후 남은 일수 재배치
- 보상 소급 삭제 금지
- 오전·오후 반일 분할 금지

## 3. Validation 전체 흐름

```text
SCREEN-01 메인
→ SIT-001 저승역 콜드 오픈
→ SIT-002 기록국 브리핑
→ SIT-003 축약 준비
→ SIT-004 텍스트 노벨 조사
→ SIT-005 사건 가설
→ SIT-006 시간순 증거·안전 노선 복원
→ SIT-007 회수 2패턴
→ SIT-008 결과 4축·보고서·최소 환류
→ SCREEN-01 메인 복귀
```

## 4. CURRENT와 TARGET 경계

`CURRENT_IMPLEMENTATION_LEGACY`:

- 새 캠페인의 대화 Scene 직접 진입
- 반일 일정·준비
- 조사 HUD 과밀
- 회수 4패턴·설명형 행동 버튼
- 단일 결과 등급·반일 준비 복귀
- Scene 경로 중심 이어하기

`APPROVED_TARGET_NOT_IMPLEMENTED`:

- A~G 승인안 전체
- 전문 절차 return target
- Validation 회수 2패턴
- 결과 4축
- flow stage 기반 복귀
- 완료 후 메인 복귀

기존 기능을 승인 목표처럼 혼합하지 않는다.

## 5. Validation 비노출·무부작용

비노출:

- 랜덤 이벤트
- 세력 의뢰
- 소문시장
- 일상 에피소드
- 전체 4주 운영
- 복잡한 관계·확률·자동 행동 상세
- 회수 패턴 3·4
- 전체 연구 트리·조달 카탈로그

비노출 기능은 UI만 숨기는 것이 아니라 판정·난수·로그·자원·관계·위험·저장 상태를 변경하지 않는다.

## 6. 시각 보드 제작 계약

승인 후 다음 보드를 별도로 제작한다.

- 보드 A: SCREEN-01~04
- 보드 B: SCREEN-05~07
- 보드 C1: SIT-001~002
- 보드 C2: SIT-003~004
- 보드 C3: SIT-005~006
- 보드 C4: SIT-007~008

금지:

- 7개 화면과 8개 상황을 한 장에 축소
- CURRENT와 TARGET 혼합
- 범용 판타지 UI
- 작은 텍스트 중심 감사 대시보드
- 직전 과밀 보드 재사용

모든 화면·요소에는 필요에 따라 `CURRENT`, `INFERRED`, `PROPOSED`, `PLACEHOLDER` 태그를 표시한다.

## 7. 구현 보호

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

## 8. 승인 상태

```yaml
decision_id: D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE
approval_state: APPROVED_PLANNING_BASELINE
approved_at: 2026-08-01T09:15:00+09:00
screen_count: 7
specialist_flow_count: 4
situation_count: 8
implementation_authority: NONE
runtime: NOT_RUN
visual_review: NOT_RUN
human_validation: NOT_RUN
codex: HOLD
```

## 9. 다음 Gate

```text
GitHub·Sheet 승인 동기화
→ 비주얼 보드 A·B·C1~C4 제작
→ 이미지 중간점검·적대적 검토
→ 플레이테스트 패키지
→ 사용자 기획 최종 승인
→ 상위 정본 단일 Canon Pass
→ writing-plans
→ 마지막에 Codex Goal
```
