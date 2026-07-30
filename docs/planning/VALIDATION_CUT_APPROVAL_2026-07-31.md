# 통합 Vertical Slice Validation Cut 승인 기록

> 상태: `APPROVED_PLANNING_DIRECTION`
> 사용자 승인: 2026-07-31
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> Codex 실행: `HOLD_UNTIL_PLANNING_AND_REVIEW_COMPLETE`

## 1. 승인 결정

`docs/planning/INTEGRATED_VERTICAL_SLICE_EXPERIENCE_DRAFT.md`의 권장 순서를 승인한다.

```text
Validation Cut 35~50분 설계·검증
→ 결과에 따른 수정·재검증
→ 통과 뒤 Showcase Cut 70~90분 확장
```

Showcase Cut으로 즉시 직행하지 않는다.

## 2. Validation Cut 범위

```text
저승역 콜드 오픈
→ 기록국 브리핑
→ 제한된 준비 결정 1회
→ 저승역 핵심 조사
→ 사건 수준 가설 보드
→ 노선 복원 핵심 단계
→ 회수 패턴 2개 이상
→ 결과·매뉴얼 환류
```

### 포함

- 첫 10분 플레이어 역할 전달
- 준비 선택 1회의 사건 영향
- 저승역 핵심 관측·기록
- 후보 가설 4개 중 반증 가능한 2개 제거
- 남은 두 후보의 미해결 차이 확인
- 안전 노선 규칙의 조작 검증
- 회수 전조 2개 이상의 판별·대응
- 행동 성공과 추론 검증 분리
- 결과·위험 사례·매뉴얼 환류

### 제외

- 4주 전체 일정 반복
- 관계 체인 전체
- 연구·장비 전체 탐색 UI
- 회수 패턴 전부 강제
- ANNUAL-MVP-003/004
- 모바일
- 공개 데모·Steam 출시 품질
- Codex 구현

## 3. 통과 조건

Validation Cut은 자동 검증만으로 통과하지 않는다.

사람 플레이에서 다음이 확인되어야 한다.

1. 첫 10분 안에 `기록으로 괴이 규칙을 조사한다`는 역할을 설명한다.
2. 준비 선택이 사건 접근·안전·정보 표현 중 하나 이상을 바꿨다고 인식한다.
3. 후보 2개를 관측 근거로 제거하고 제거 이유를 설명한다.
4. 남은 두 후보가 왜 아직 구분되지 않는지 말한다.
5. 노선 복원은 안전 경로의 운용 검증이지 사건 원인의 자동 정답이 아님을 이해한다.
6. 회수 단계가 사건 가설을 반복하는 것이 아니라 새 전조를 분류·대응하는 단계로 읽힌다.
7. 우연히 올바른 행동을 한 것과 규칙을 증명한 것을 구분한다.
8. 결과 기록에서 다음 준비가 무엇 때문에 달라지는지 설명한다.

판정 어휘:

- `KEEP`
- `AMPLIFY`
- `CHANGE`
- `RETEST`
- `HOLD`

## 4. Showcase Cut 진입 Gate

다음이 모두 충족되어야 한다.

- Validation Cut 사람 테스트 완료
- 핵심 연결의 판정이 `KEEP` 또는 `AMPLIFY`
- P1 Finding에 `HOLD`가 없음
- 첫 10분·가설 보드·노선 복원·회수의 반복 피로가 허용 범위
- 준비 선택→사건→결과 환류의 인과 설명 성공
- 사용자 별도 승인

## 5. 후속 기획 순서

```text
목적형 Benchmark Gate
→ 저승역 4→2 가설 설계
→ 최소 타임라인 증거 확정
→ 행동 성공/추론 검증 결과 계약
→ 회수 encounter 책임 정리
→ Validation Cut 플레이테스트 패키지
→ 독립 검수·적대적 재검토
→ 사용자 최종 승인
→ 마지막에 Codex Goal·구현 계획
```

현재 진행:

- Benchmark Gate: `PASSED_FOR_PLANNING`
- 가설 설계: `DRAFT_REQUIRES_REVIEW`
- Codex: `HOLD`
- 구현: `NOT_STARTED`
- 사람 검증: `NOT_RUN`
