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
- Codex는 기획·검수 최종 완료 뒤 마지막 단계

## 작성·검수 완료

- 프로젝트 기획 정본 감사
- 통합 Vertical Slice 경험 v3
- 전체 기획 적대적 검토
- Benchmark-first 프로젝트 정책
- 저승역 가설 보드 목적형 벤치마크
- 저승역 가설 보드 v2와 적대적 검토
- Validation Cut 회수 encounter 초안
- 결과·해결 등급·연구 환류 초안
- 플레이테스트 계획 초안

## 현재 검수 대상

### D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE

```text
23:57:42 피해자의 개인 목적지 청취 기록
<
23:59:08 검은 승차권 최초 접촉 기록
```

- 기록 A: 피해자 전송 실패 음성 메모
- 기록 B: 개찰구 CCTV·관제 자동 로그
- 획득: 피해자 휴대폰 → 검은 승차권 현장 → 역무원실 관제 기록
- 공백 투사설: 지지
- 승차권 최초 원인 주장: 반박
- 승차권의 인식 고정·물리화 매개 역할: 미해결
- 구현 권한: `NONE`
- 상태: `DRAFT_REQUIRES_USER_REVIEW`

현행 책임 원본:

- `docs/decisions/D-2026-07-31-AFTERLIFE-TIMELINE-EVIDENCE.md`

## 현재 권장 설계

### 원인 후보 4→2

```text
공백 투사설
검은 승차권 지정설
숨은 단일 종착역설
기기 오염설
```

관측 근거로 숨은 단일 종착역설과 기기 오염설을 제거한다.

### 안전 운용 규칙

개인화된 목적지 표기를 현실 경로 기준으로 신뢰하지 않고 공식 노선 식별 정보와 방송 종료 식별음을 사용한다.

### Validation 회수 패턴

1. 존재하지 않는 종착 안내
2. 검은 승차권의 승객 각인

## 남은 P0 기획

1. 시간순 증거의 대사·획득 위치 사용자 검수
2. 회수 패턴의 중립 문구와 분류 후보 검수
3. 원인 미검증 상태의 해결 등급 상한 검수
4. 결과→연구·장비 환류 세부값 검수
5. 플레이테스트 패키지 적대적 검토
6. 사용자 최종 승인
7. 승인 결정의 GitHub 정본·Sheet 상태 승격

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
timeline_evidence: DRAFT_REQUIRES_USER_REVIEW
recovery_encounter: DRAFT_REQUIRES_REVIEW
result_and_reward: DRAFT_REQUIRES_REVIEW
playtest_plan: DRAFT_REQUIRES_REVIEW
showcase_cut: HOLD_UNTIL_VALIDATION
codex: HOLD
human_validation: NOT_RUN
production_expansion: NOT_APPROVED
```
