# D-2026-07-31-VALIDATION-SCREEN-AUTHORITY — Validation Cut 화면 권위

> 상태: `APPROVED_PLANNING_BASELINE / SUPERSEDED_IN_PART`
> 승인일: 2026-07-31
> 최신 정렬: 2026-08-01 09:15 KST
> 사용자 승인: “승인”
> 추적: Issue #121 / Draft PR #122
> Benchmark Gate: `REUSED`
> 후속 권위: `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE`
> 구현 권한: `NONE`
> Runtime / Visual / Human QA: `NOT_RUN`

## 1. 결정 목적

Validation Cut에서 플레이어가 실제로 거치는 시작·준비·조사·회수·결과 흐름의 화면 책임을 하나로 고정한다.

이 결정은 기존 Scene을 즉시 변경하는 구현 승인이 아니다. 이후 승인된 A~G 상세 권위는 `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE`가 소유한다.

## 2. 유지되는 승인 — 시작 구조

```text
SCREEN-01 메인 화면
→ SIT-001 저승역 콜드 오픈
→ SIT-002 기록국 브리핑
→ SIT-003 축약 준비
→ SIT-004 텍스트 노벨 조사
```

- 첫 세션은 장기 운영 UI보다 저승역의 이상 현상과 역할 인지를 먼저 제공한다.
- 콜드 오픈 뒤 기록국 브리핑에서 주인공의 소속·목표·금지 사항을 확인한다.
- 축약 준비에서 편성·장비/지원·조사 우선순위의 제한된 선택만 수행한다.
- 일반 조사는 `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION`을 따른다.

## 3. 유지되는 승인 — 준비 화면 책임

`preparation_scene`을 출동 직전 준비 화면의 재사용 기반으로 유지한다.

Validation 축약 준비의 책임:

1. 요원·동료 편성
2. 장비 또는 지원 선택
3. 조사 우선순위 선택
4. 출동 확인

Validation에서 제외:

- 전체 장기 일정 편성
- 지난주 복사·다수 템플릿
- 장기 피로·관계·연구 트리 전체 관리
- ANNUAL-MVP-002의 모든 PoC 기능 동시 제품화

ANNUAL-MVP-002 PoC는 `CURRENT_IMPLEMENTATION_LEGACY`로 보존한다.

## 4. 유지되는 승인 — 가설과 회수 책임 분리

### 사건 가설

- 사건 전체 원인 가설 비교
- 지지·반박·미해결 관계 연결
- 후보 제거
- 최초 원인과 현장 매개 역할 구분
- 최종 검증 상태 기록

### 회수

```text
전조 관측
→ 패턴 분류
→ 관련 기록 연결
→ 중립 현장 행동
→ 현장 결과
→ 추론 검증 결과
```

- 사건 전체 가설을 회수 패턴마다 반복하지 않는다.
- 행동 성공과 추론 검증을 분리한다.
- Validation 회수 상세는 `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS REV-2`가 소유한다.

## 5. 대체된 부분 — 결과 이후 복귀

### 이전 제안

```text
SCREEN-04 결과
→ preparation_scene 사후 정산 모드
→ 다음 준비 / DB / 메인
```

이 경로는 `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE`의 승인으로 Validation 범위에서 대체됐다.

### 현재 Validation 권위

```text
SCREEN-04 결과 4축 확인
→ 사건 보고서·괴이 매뉴얼·최소 연구/보급 후보 저장
→ Validation 완료 처리
→ SCREEN-01 메인 복귀
```

- 별도 사후 정산 화면 또는 8번째 완료 화면을 만들지 않는다.
- 전체 제품에서는 추후 SCREEN-05 다음 날짜로 연결한다.
- 결과 4축과 환류는 `D-2026-08-01-VALIDATION-RESULT-AXES`가 소유한다.

## 6. 현재 전체 Validation 흐름

```text
메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 사건 가설
→ 시간순 증거
→ 안전 노선 복원
→ 회수 2패턴
→ 결과 4축·보고서·최소 환류
→ 메인 복귀
```

## 7. 연결 Decision

- `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION`
- `D-2026-07-31-VISUAL-ART-DIRECTION`
- `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE`
- `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS`
- `D-2026-08-01-VALIDATION-RESULT-AXES`
- `D-2026-08-01-VALIDATION-SAVE-TEST-MIGRATION`
- `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE`

## 8. 구현 경계

이번 승인으로 허용되지 않는 것:

- GDScript·Scene·JSON 변경
- 기존 Scene 삭제 또는 통합
- 저장 Schema·ID 변경
- 실제 UI 좌표·폰트·색상 수치 확정
- ANNUAL-MVP-002 제품 통합 구현
- Codex Goal 작성·실행

## 9. 다음 Gate

```text
SCREEN 보드 A·B와 SIT 보드 C1~C4 제작
→ 이미지 중간점검·P2 위험 적대적 검토
→ 플레이테스트 패키지
→ 사용자 기획 최종 승인
→ 상위 정본 단일 Canon Pass
→ writing-plans
→ 마지막에 Codex Goal
```
