# 괴이기록국 기획 진행 상태 — 2026-07-31

> 상태: `PLANNING_IN_PROGRESS`
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`

## 승인됨

- Validation Cut 35~50분 우선 검증
- Validation 통과 뒤 Showcase Cut 70~90분 별도 승인
- 신규 시스템·핵심 규칙·콘텐츠 구조·UX 흐름의 Benchmark-first 원칙
- 기존 근거 재사용 우선, 기본 3~5개 목적형 비교
- Codex는 기획·검수 최종 완료 뒤 마지막 단계

## 작성·검수 완료

- 프로젝트 기획 정본 감사
- 통합 Vertical Slice 경험 v3
- 전체 기획 적대적 검토
- Benchmark-first 프로젝트 정책
- 저승역 가설 보드 목적형 벤치마크
- 저승역 가설 보드 v2와 적대적 검토
- 최종 구분용 시간순 증거 초안
- Validation Cut 회수 encounter 초안

## 현재 권장 설계

### 원인 후보 4→2

```text
공백 투사설
검은 승차권 지정설
숨은 단일 종착역설
기기 오염설
```

관측 근거로 숨은 단일 종착역설과 기기 오염설을 제거한다.

최종 구분:

```text
피해자 개인 목적지 청취 시각
<
검은 승차권 최초 접촉 시각
```

### 안전 운용 규칙

개인화된 목적지 표기를 현실 경로 기준으로 신뢰하지 않고 공식 노선 식별 정보와 방송 종료 식별음을 사용한다.

### Validation 회수 패턴

1. 존재하지 않는 종착 안내
2. 검은 승차권의 승객 각인

## 남은 P0 기획

1. 시간순 증거의 정확한 대사·화면·획득 위치 검수
2. 회수 패턴의 중립 문구와 분류 후보 검수
3. 원인 미검증 상태의 해결 등급 상한
4. 결과→연구·장비 환류 1개 확정
5. 플레이테스트 패키지와 관찰 기록 양식
6. 독립 검수·적대적 재검토
7. 사용자 최종 승인

## 보류

- Codex Goal
- GDScript·Scene·JSON·에셋 변경
- Google Sheet 쓰기
- Base v9.3 이관 구현
- ANNUAL-MVP-003/004
- Showcase Cut 구현
- 사람 검증 전 제작 확대

## 현재 Gate

```yaml
benchmark_first_policy: APPROVED
validation_cut_direction: APPROVED
hypothesis_benchmark: PASSED
hypothesis_design_v2: DRAFT_REQUIRES_USER_REVIEW
timeline_evidence: DRAFT_REQUIRES_REVIEW
recovery_encounter: DRAFT_REQUIRES_REVIEW
showcase_cut: HOLD_UNTIL_VALIDATION
codex: HOLD
human_validation: NOT_RUN
production_expansion: NOT_APPROVED
```
