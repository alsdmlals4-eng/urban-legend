# 연도제 확장 기획 기준선 QA

> 날짜: 2026-07-26
> 추적: Issue #84
> 상태: `SELF_REVIEW_COMPLETE / CI_PENDING`

## 검토 대상

- `docs/superpowers/specs/2026-07-26-annual-expansion-master-design.md`
- `docs/planning/ANNUAL_PROVISIONAL_DATA_BASELINE.md`
- `docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md`
- `docs/DECISION_LOG.md`
- `MVP_ROADMAP.md`
- `tests/test_annual_expansion_planning_contract.py`

## 누락 검사

- [x] 전체 확장 순서 7단계 기록
- [x] 각 단계의 목표·범위·진입 게이트 기록
- [x] 고정 계약과 임시 데이터 구분
- [x] 동료 5명 기준선
- [x] 고유 스킬 5개
- [x] 공용 보조 스킬 8개
- [x] 장비 6개와 모듈 12개
- [x] 연구 분야 4개와 노드 24개
- [x] 상태 8종과 회복 규칙
- [x] 봄 분기 사건 7개와 기관 요청 6개
- [x] 사건 제작 schema와 규모별 최소량
- [x] 관계 5단계·가치 태그·선택적 로맨스 경계
- [x] 미니게임 3종과 난이도 데이터
- [x] 1년 콘텐츠 수량과 연도 계승 payload
- [x] ANNUAL-MVP-002 화면·상태·adapter·save·오류·테스트 계약
- [x] 결정 로그와 로드맵 연결
- [x] 자동 문서 계약 추가

## 일관성 검사

- 권나래 고정 주인공 유지
- 4주×7일과 주차 경계 금지 유지
- ANNUAL-MVP-001 위험 0/15/30 유지
- 직접 휴식과 자동 휴식 차이 유지
- CORE 핵심 단서·가설·전조·포획 조건 비침범
- 기존 save·ID·보호 경로 비침범
- 사람 검증 전 `POC_PASSED`와 제작 확대 미선언
- ANNUAL-MVP-003·004 구현은 `NOT_APPROVED`

## 임시 데이터 경계

신규 이름, ID, 비용, 확률, 피해 완화량, 연구 비용, 콘텐츠 수량은 모두 `PROVISIONAL_BASELINE`이다. 구현 결합 전에 ID 충돌 감사를 수행하고, 플레이 증거에 따른 변경은 `docs/DECISION_LOG.md`에 supersession 관계로 기록한다.

## 자체 검토 결과

- `TODO`: 없음
- `TBD`: 없음
- 빈 필수 섹션: 없음
- 고정 계약과 임시 데이터의 상태 혼용: 없음
- 구현 완료 오인 문구: 없음
- 사용자 승인 없는 ANNUAL-MVP-003/004 착수 문구: 없음

## 남은 게이트

1. GitHub 문서 계약 CI
2. 변경 파일 감사
3. 사용자 상세 spec 검토
4. ANNUAL-MVP-002 구현 계획 작성 승인

자동 문서 검증 통과는 세부 밸런스 승인이나 구현 시작 승인을 뜻하지 않는다.
