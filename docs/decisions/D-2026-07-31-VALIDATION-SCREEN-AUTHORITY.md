# D-2026-07-31-VALIDATION-SCREEN-AUTHORITY — Validation Cut 화면 권위

> 상태: `APPROVED_PLANNING_BASELINE`
> 승인일: 2026-07-31
> 사용자 승인: “승인”
> 추적: Issue #121 / Draft PR #122
> Benchmark Gate: `REUSED`
> 구현 권한: `NONE`
> Runtime / Human QA: `NOT_RUN`

## 1. 결정 목적

Validation Cut에서 플레이어가 실제로 거치는 시작·준비·조사·회수·결과 흐름의 화면 책임을 하나로 고정한다.

이 결정은 기존 Scene을 즉시 변경하는 구현 승인이 아니라, 이후 SCREEN/SIT 명세와 목적형 Benchmark가 따라야 할 제품 화면 권위다.

## 2. A — Validation Cut 시작 구조

```text
SCREEN-01 메인 화면
→ SIT-001 저승역 콜드 오픈
→ SIT-002 기록국 브리핑
→ SIT-003 축약 준비
→ SIT-004 텍스트 노벨 조사
```

- 첫 세션은 장기 운영 UI보다 저승역의 이상 현상과 역할 인지를 먼저 제공한다.
- 콜드 오픈 뒤 기록국 브리핑에서 주인공의 소속·목표·금지 사항을 확인한다.
- 축약 준비에서 요원·장비 또는 지원·조사 우선순위 중 제한된 선택만 수행한다.
- 일반 조사는 `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION`을 따른다.

## 3. B — 준비·자원 관리 화면 권위

`preparation_scene`을 Validation Cut의 제품 준비 화면 권위로 유지한다.

Validation에서는 같은 제품 표면의 **축약 준비 모드**를 사용한다.

필수 선택:

1. 요원 또는 동료 편성
2. 장비 또는 지원 선택
3. 조사 우선순위 선택
4. 출동 확인

Validation에서 제외:

- 4주×7일 전체 일정 편성
- 지난주 복사·다수 템플릿
- 장기 피로·관계·연구 트리의 전체 관리
- ANNUAL-MVP-002의 모든 PoC 기능을 한 번에 제품화

ANNUAL-MVP-002 PoC는 폐기하지 않는다. Validation 통과 뒤 Showcase Cut에서 정식 4주×7일 제품 통합 여부를 별도 승인한다.

## 4. C — 가설 보드와 회수 화면 책임 분리

### 가설 보드

사건 전체의 원인 가설을 다룬다.

- 가설 4개 비교
- 지지·반박·미해결 관계 연결
- 후보 제거
- 원인과 매개 역할 구분
- 최종 원인 검증 상태 기록

### 회수 화면

현재 발생한 전조의 패턴과 현장 행동을 다룬다.

```text
전조 관측
→ 패턴 분류
→ 관련 기록 연결
→ 중립 현장 행동
→ 현장 결과
→ 추론 검증 결과
```

- 사건 전체 가설 네 개를 회수 패턴마다 반복하지 않는다.
- 행동 성공과 공식 추론 검증을 분리한다.
- 저승역에서는 기존 `가설 → 근거 → 대응` 반복형 회수 계약을 대체한다.
- 가설 보드가 없는 구형 사건의 호환 흐름은 별도 보존할 수 있으나 Validation 권위가 아니다.

## 5. D — 결과 이후 단일 복귀 흐름

```text
SCREEN-04 사건 결과
→ 사건 보고서·괴이 매뉴얼 갱신
→ preparation_scene 사후 정산 모드
→ 다음 준비 / 기록국 DB / 메인 화면
```

사후 정산 모드 필수 정보:

1. 확인된 안전 규칙
2. 미해결 질문과 위험 사례
3. 획득한 연구 자료·기록물·장비
4. 피해자·현장 상태
5. 다음 출동 준비에 미치는 영향

기본 행동:

- `다음 준비로`
- `괴이기록국 DB 확인`
- `메인 화면으로`

결과 화면은 단일 총점만 표시하는 종료 화면이 아니라, 다음 판단을 위한 기록과 자원을 전달하는 환류 지점이다.

## 6. 전체 Validation 제품 흐름

```text
메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 가설 보드
→ 시간순 증거 비교
→ 안전 노선 복원
→ 회수 패턴 대응
→ 결과·보고서
→ 사후 정산
```

## 7. 연결 Decision

- `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION`
- `D-2026-07-31-VISUAL-ART-DIRECTION`
- `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE`
- `D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS`
- `R-2026-07-31-PLANNING-MIDPOINT-AUDIT`

## 8. Benchmark 재사용 근거

이번 권위 결정은 다음 기존 조사·검토를 재사용한다.

- 연간 운영·텍스트 노벨 통합 기획
- ANNUAL 장르 Benchmark와 준비·환류 권장안
- 공정 추리 가설 보드 목적형 Benchmark
- 기획 중간점검의 실제 Scene·제품 흐름 충돌 감사
- 승인된 텍스트 노벨 표현과 비주얼 아트 방향

정확한 레이아웃·상태 변형·가독성 판단은 다음 단계의 필수 화면 4종 목적형 Benchmark에서 별도로 검증한다.

## 9. 구현 경계

이번 승인으로 허용되지 않는 것:

- GDScript·Scene·JSON 변경
- 기존 Scene 삭제 또는 통합
- 저장 Schema·ID 변경
- 실제 UI 좌표·폰트·색상 수치 확정
- ANNUAL-MVP-002 제품 통합 구현
- Codex Goal 작성·실행

## 10. 다음 Gate

```text
SCREEN-01~04 목적형 Benchmark
→ 실제 Scene·Script·데이터 인벤토리 보강
→ CURRENT / INFERRED / PROPOSED 화면 정본
→ 상태 변형
→ Validation SIT-001~008 시퀀스
→ 사용자 화면 보드 검수
→ 회수 패턴 최종 승인 검수 재개
```
