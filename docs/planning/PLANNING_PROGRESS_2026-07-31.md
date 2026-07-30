# 괴이기록국 기획 진행 상태 — 2026-07-31

> 상태: `PLANNING_IN_PROGRESS`
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> 정본·Sheet 동기화: `D-2026-07-31-CANON-SHEET-SYNC`

## 승인됨

- Validation Cut 35~50분 우선 검증
- Validation 통과 뒤 Showcase Cut 70~90분 별도 승인
- 신규 시스템·핵심 규칙·콘텐츠 구조·UX 흐름의 Benchmark-first 원칙
- 기존 근거 재사용 우선, 기본 3~5개 목적형 비교
- 주요 변경·승인 결정은 동일 Decision ID로 GitHub 책임 원본과 연결 Google Sheet에 즉시 동기화
- `D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE` 시간순 증거 기준선
- Codex는 기획·검수 최종 완료 뒤 마지막 단계

## 작성·검수 완료

- 프로젝트 기획 정본 감사
- 통합 Vertical Slice 경험 v3
- 전체 기획 적대적 검토
- Benchmark-first 프로젝트 정책
- 저승역 가설 보드 목적형 벤치마크
- 저승역 가설 보드 v2와 적대적 검토
- 저승역 시간순 증거 대사·획득 위치 승인
- 결과·해결 등급·연구 환류 초안
- 플레이테스트 계획 초안

## 승인된 시간순 증거

### D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE

```text
23:57:42 피해자의 개인 목적지 청취 기록
<
23:59:08 검은 승차권 최초 접촉 기록
```

- 공백 투사설: `SUPPORTED`
- 승차권 최초 원인 주장: `CONTRADICTED`
- 승차권의 인식 고정·물리화 매개 역할: `UNRESOLVED`
- 상태: `APPROVED_PLANNING_BASELINE`
- 구현 권한: `NONE`
- 사람 검증: `NOT_RUN`

책임 원본:

- `docs/decisions/D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE.md`

## 현재 검수 대상

### D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS

권장 구조:

```text
전조 관측
→ 패턴 분류
→ 관련 기록 연결
→ 중립 현장 행동
→ 현장 결과
→ 추론 검증 결과
```

Validation 패턴:

1. 존재하지 않는 종착 안내
2. 검은 승차권의 승객 각인

권장 중립 행동:

- 패턴 1: `스피커 회로를 분리한다 / 전광판이 가리키는 쪽으로 이동한다 / 방송에 현재 역명을 답한다`
- 패턴 2: `투명 격리함으로 옮긴다 / 개찰기에 통과시킨다 / 보호 봉투에 넣어 요원이 소지한다`

핵심 경계:

- 행동 문구에 근거·정답 논리를 넣지 않는다.
- 행동 성공과 공식 추론 검증을 분리한다.
- 사건 원인 가설 네 개를 매 패턴에서 반복하지 않는다.
- 자동 예측·동료 지원은 정답을 표시하지 않는다.
- 상태: `DRAFT_REQUIRES_USER_REVIEW`
- 구현 권한: `NONE`

책임 원본:

- `docs/decisions/D-2026-07-31-AFTERLIFE-RECOVERY-PATTERNS.md`

## 남은 P0 기획

1. 회수 패턴 분류 후보·중립 행동 문구 사용자 검수
2. 원인 미검증 상태의 해결 등급 상한 검수
3. 결과→연구·장비 환류 세부값 검수
4. 플레이테스트 패키지 적대적 검토
5. 사용자 최종 승인
6. 승인 결정의 GitHub 정본·Sheet 상태 승격

## 보류

- Codex Goal
- GDScript·Scene·JSON·에셋 변경
- Base v9.3 이관 구현
- ANNUAL-MVP-003/004
- Showcase Cut 구현
- 사람 검증 전 제작 확대

Google Sheet 쓰기는 승인·주요 변경 동기화 목적으로만 허용하며, 제품 데이터 구현을 의미하지 않는다.

## 현재 Gate

```yaml
canon_sheet_sync_policy: APPROVED_AND_BRANCH_SYNCED
benchmark_first_policy: APPROVED
validation_cut_direction: APPROVED
hypothesis_benchmark: PASSED
hypothesis_design_v2: DRAFT_REQUIRES_USER_REVIEW
timeline_evidence: APPROVED_PLANNING_BASELINE
recovery_patterns: DRAFT_REQUIRES_USER_REVIEW
result_and_reward: DRAFT_REQUIRES_REVIEW
playtest_plan: DRAFT_REQUIRES_REVIEW
showcase_cut: HOLD_UNTIL_VALIDATION
codex: HOLD
human_validation: NOT_RUN
production_expansion: NOT_APPROVED
```
